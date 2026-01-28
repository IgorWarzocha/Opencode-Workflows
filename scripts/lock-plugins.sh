#!/bin/sh
# Locks or unlocks plugins in the config file to a specific version.
# This speeds up the startup time and possibly prevents bun install errors.
#
# Usage:
#   lock-plugins.sh [--locked | --latest] [--active | --all]
#
# Options:
#   --locked: Locks all plugins to the latest version, but pins them, ie 0.5.1
#   --latest: Unlocks all plugins to the latest version, aka @latest
#
#   --active (default): affects only active, uncommented plugins
#   --all: affects all plugins, including those commented out

CONFIG_PATH="$HOME/.config/opencode/opencode.json"

# Modes
MODE=""      # locked | latest
SCOPE="active" # active | all

for arg in "$@"; do
  case $arg in
    --locked) MODE="locked" ;;
    --latest) MODE="latest" ;;
    --active) SCOPE="active" ;;
    --all)    SCOPE="all" ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

if [ -z "$MODE" ]; then
  echo "Usage: $0 [--locked | --latest] [--active | --all]"
  exit 1
fi

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Config not found at $CONFIG_PATH"
  exit 1
fi

# Create a temporary file
TEMP_FILE=$(mktemp)
cp "$CONFIG_PATH" "$TEMP_FILE"

# Process with Perl
# State machine approach to safely ignore the "plugin" key itself
perl -i -pe '
  BEGIN { $in_plugins = 0; $mode = "'"$MODE"'"; $scope = "'"$SCOPE"'"; }

  if (/"plugin":\s*\[/) { $in_plugins = 1; next; }
  if ($in_plugins && /\]/) { $in_plugins = 0; }

  if ($in_plugins) {
    # Skip any line that looks like a key-value pair (contains :) to avoid matching "plugin"
    if (!/:/ && /^\s*(\/\/)?\s*"((?:@[^\/]+\/)?[^@"]+)(?:@([^"]+))?"/) {
      $is_commented = $1 ? 1 : 0;
      $pkg = $2;

      if ($pkg !~ /^file:\/\//) {
        if ($scope eq "all" || !$is_commented) {
          $target_ver = "latest";
          if ($mode eq "locked") {
             print STDERR "Fetching version for $pkg...\n";
             $target_ver = `npm show $pkg version 2>/dev/null` || "latest";
             chomp($target_ver);
          }
          s/"\Q$pkg\E(?:@[^"]+)?"/"$pkg\@$target_ver"/;
        }
      }
    }
  }
' "$TEMP_FILE"

mv "$TEMP_FILE" "$CONFIG_PATH"
echo "Plugins updated: mode=$MODE, scope=$SCOPE"
