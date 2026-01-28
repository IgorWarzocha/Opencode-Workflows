/**
 * SelectionView.tsx
 * Renders the interactive item selection interface with hierarchical navigation.
 * Displays packs, standalone items, and selection state indicators.
 */

import { TextAttributes } from "@opentui/core";
import { For, createMemo } from "solid-js";
import type { Accessor } from "solid-js";
import type { UIItem, RegistryItem, Pack, InstallMode } from "../types";

interface SelectionViewProps {
  items: Accessor<UIItem[]>;
  cursor: Accessor<number>;
  selectedItems: Accessor<Set<RegistryItem>>;
  isPackSelected: (pack: Pack) => boolean;
  installMode: Accessor<InstallMode>;
}

export function SelectionView(props: SelectionViewProps) {
  const currentDescription = createMemo(
    () => props.items()[props.cursor()]?.description || ""
  );

  return (
    <>
      <box flexDirection="column" marginBottom={1}>
        <box>
          <text attributes={TextAttributes.BOLD}>{props.selectedItems().size}</text>
          <text attributes={TextAttributes.DIM}> selected | </text>
          <text attributes={TextAttributes.BOLD}>
            {props.installMode() === "global" ? "Global" : "Local"}
          </text>
          <text attributes={TextAttributes.DIM}>
            {props.installMode() === "global"
              ? " (~/.config/opencode/)"
              : " (.opencode/)"}
          </text>
        </box>
        <box height={1}>
          <text attributes={TextAttributes.DIM}>{currentDescription()}</text>
        </box>
        <text attributes={TextAttributes.DIM}>
          j/k: Nav | h/l: Drill | Space: Toggle | Tab: Mode | Enter: Sync
        </text>
      </box>

      <box flexDirection="column" flexGrow={1}>
        <For each={props.items()}>
          {(item, index) => {
            const isCursor = createMemo(() => index() === props.cursor());

            const isSelected = createMemo(() =>
              item.type === "item"
                ? props.selectedItems().has(item.item!)
                : item.type === "pack"
                  ? props.isPackSelected(item.pack!)
                  : false
            );

            const indent =
              item.type === "category"
                ? ""
                : item.type === "pack"
                  ? "  "
                  : item.parent === "agents" || item.parent === "commands"
                    ? "  "
                    : "    ";

            const chevron =
              item.type === "category" || item.type === "pack"
                ? item.expanded
                  ? "v "
                  : "> "
                : "";

            const checkbox =
              item.type === "item" || item.type === "pack"
                ? isSelected()
                  ? "[x] "
                  : "[ ] "
                : "";

            const itemCount =
              item.type === "pack" ? ` (${item.pack!.items.length})` : "";

            return (
              <box
                backgroundColor={isCursor() ? "cyan" : undefined}
                height={1}
              >
                <text
                  attributes={
                    isCursor()
                      ? TextAttributes.BOLD
                      : item.type === "category"
                        ? TextAttributes.BOLD
                        : undefined
                  }
                >
                  {indent}
                  {chevron}
                  {checkbox}
                  {item.title}
                  {itemCount}
                </text>
              </box>
            );
          }}
        </For>
      </box>
    </>
  );
}
