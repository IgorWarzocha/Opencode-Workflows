/**
 * registry.ts
 * Handles registry loading and target path resolution.
 * Prefixes specialized items with .opencode/ when needed.
 */

import fs from "fs-extra";
import path from "path";
import type { Registry, RegistryItem, Pack, InstallMode } from "./types";
import { ROOT_DIR, REGISTRY_PATH, GLOBAL_INSTALL_DIR, LOCAL_INSTALL_DIR } from "./config";

const PREFIXED_TYPES = new Set(["agent", "skill", "command"]);

export function resolveTargetPath(item: RegistryItem, mode: InstallMode): string {
  const baseDir = mode === "global" ? GLOBAL_INSTALL_DIR : LOCAL_INSTALL_DIR;
  
  if (PREFIXED_TYPES.has(item.type)) {
    return path.join(baseDir, item.target);
  }
  return path.join(ROOT_DIR, item.target);
}

export async function loadRegistry(): Promise<Registry | null> {
  const exists = await fs.pathExists(REGISTRY_PATH);
  if (!exists) {
    throw new Error(`Registry file not found at ${REGISTRY_PATH}`);
  }
  return fs.readJson(REGISTRY_PATH) as Promise<Registry>;
}

export function getAllItems(registry: Registry): RegistryItem[] {
  return [
    ...registry.packs.flatMap((p: Pack) => p.items),
    ...registry.standalone,
  ];
}

export async function findInstalledItems(
  items: RegistryItem[],
  mode: InstallMode
): Promise<Set<RegistryItem>> {
  const installed = new Set<RegistryItem>();
  for (const item of items) {
    const exists = await fs.pathExists(resolveTargetPath(item, mode));
    if (exists) {
      installed.add(item);
    }
  }
  return installed;
}
