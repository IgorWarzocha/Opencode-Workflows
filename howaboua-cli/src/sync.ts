/**
 * sync.ts
 * Executes file sync operations: installing and removing workflow items.
 * Uses fs-extra for atomic copy and removal.
 */

import fs from "fs-extra";
import path from "path";
import type { RegistryItem, Changes, InstallMode } from "./types";
import { ROOT_DIR } from "./config";
import { resolveTargetPath } from "./registry";

export type SyncLogCallback = (message: string) => void;

export async function performSync(
  changes: Changes,
  mode: InstallMode,
  onLog: SyncLogCallback
): Promise<void> {
  for (const item of changes.remove) {
    const dest = resolveTargetPath(item, mode);
    await fs.remove(dest);
    onLog(`Removed ${item.name}`);
  }

  for (const item of changes.install) {
    const source = path.join(ROOT_DIR, item.path);
    const dest = resolveTargetPath(item, mode);
    await fs.ensureDir(path.dirname(dest));
    await fs.copy(source, dest);
    onLog(`Installed ${item.name}`);
  }
}
