/**
 * SyncView.tsx
 * Shows sync progress and completion status with operation logs.
 * Displays each installed/removed item as the sync proceeds.
 */

import { TextAttributes } from "@opentui/core";
import { For, Show } from "solid-js";
import type { Accessor } from "solid-js";
import type { AppStatus } from "../types";

interface SyncViewProps {
  status: Accessor<AppStatus>;
  logs: Accessor<string[]>;
}

export function SyncView(props: SyncViewProps) {
  return (
    <box flexDirection="column">
      <text attributes={TextAttributes.BOLD}>
        {props.status() === "syncing" ? "Syncing changes..." : "Sync complete!"}
      </text>

      <box flexDirection="column" marginTop={1}>
        <For each={props.logs()}>
          {(log) => (
            <box>
              <text>[OK] </text>
              <text>{log}</text>
            </box>
          )}
        </For>
      </box>

      <Show when={props.status() === "done"}>
        <text marginTop={1}>Press Enter to exit.</text>
      </Show>
    </box>
  );
}
