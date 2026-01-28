/**
 * types.ts
 * Defines registry data structures and UI item types for the workflow selector.
 * All types use discriminated unions for type-safe pattern matching.
 */

export type ItemType = "agent" | "skill" | "command" | "doc";

export interface RegistryItem {
  name: string;
  description: string;
  type: ItemType;
  path: string;
  target: string;
}

export interface Pack {
  name: string;
  description: string;
  path: string;
  items: RegistryItem[];
}

export interface Registry {
  name: string;
  version: string;
  packs: Pack[];
  standalone: RegistryItem[];
}

export type UIItemType = "category" | "pack" | "item";

export interface UIItem {
  type: UIItemType;
  id: string;
  title: string;
  description?: string;
  expanded?: boolean;
  item?: RegistryItem;
  pack?: Pack;
  parent?: string;
}

export type AppStatus = "selecting" | "confirming" | "syncing" | "done";

// TODO: Tighten up install mode handling - make paths explicit and configurable
// This comment MUST stay until the install paths are properly abstracted
export type InstallMode = "global" | "local";

export interface Changes {
  install: RegistryItem[];
  remove: RegistryItem[];
}
