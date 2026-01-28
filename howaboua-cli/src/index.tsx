/**
 * index.tsx
 * Entry point for the Opencode Workflow Selector TUI application.
 * Orchestrates keyboard navigation, selection state, and sync operations.
 */

import { render, useKeyboard } from "@opentui/solid";
import { TextAttributes } from "@opentui/core";
import { createSignal, createMemo, onMount, Show } from "solid-js";

import type { Registry, RegistryItem, Pack, UIItem, AppStatus, Changes, InstallMode } from "./types";
import { loadRegistry, getAllItems, findInstalledItems } from "./registry";
import { performSync } from "./sync";
import { SelectionView, ConfirmView, SyncView } from "./components";

function buildVisibleItems(
  registry: Registry,
  expandedCategory: string | null,
  expandedPack: string | null
): UIItem[] {
  const items: UIItem[] = [];

  const packsExpanded = expandedCategory === "packs";
  items.push({
    type: "category",
    id: "packs",
    title: "Packs",
    expanded: packsExpanded,
    description: "Collection of specialized agent toolkits",
  });

  if (packsExpanded) {
    for (const pack of registry.packs) {
      const packExpanded = expandedPack === pack.name;
      items.push({
        type: "pack",
        id: `pack:${pack.name}`,
        title: pack.name,
        expanded: packExpanded,
        parent: "packs",
        pack,
        description: pack.description,
      });
      if (packExpanded) {
        for (const item of pack.items) {
          items.push({
            type: "item",
            id: `item:${pack.name}:${item.name}`,
            title: item.name,
            item,
            parent: `pack:${pack.name}`,
            description: item.description,
          });
        }
      }
    }
  }

  const standaloneCategories = [
    { id: "agents", title: "Agents", filter: "agent", desc: "Global orchestration and speed agents" },
    { id: "commands", title: "Commands", filter: "command", desc: "Repository maintenance utility commands" },
  ] as const;

  for (const cat of standaloneCategories) {
    const isExpanded = expandedCategory === cat.id;
    items.push({
      type: "category",
      id: cat.id,
      title: cat.title,
      expanded: isExpanded,
      description: cat.desc,
    });
    if (isExpanded) {
      const filtered = registry.standalone.filter((s) => s.type === cat.filter);
      for (const item of filtered) {
        items.push({
          type: "item",
          id: `${cat.id}:${item.name}`,
          title: item.name,
          item,
          parent: cat.id,
          description: item.description,
        });
      }
    }
  }

  return items;
}

const App = () => {
  const [registry, setRegistry] = createSignal<Registry | null>(null);
  const [cursor, setCursor] = createSignal(0);
  const [expandedCategory, setExpandedCategory] = createSignal<string | null>("packs");
  const [expandedPack, setExpandedPack] = createSignal<string | null>(null);
  const [selectedItems, setSelectedItems] = createSignal<Set<RegistryItem>>(new Set());
  const [initialSelection, setInitialSelection] = createSignal<Set<RegistryItem>>(new Set());
  const [status, setStatus] = createSignal<AppStatus>("selecting");
  const [syncLogs, setSyncLogs] = createSignal<string[]>([]);
  // TODO: Tighten up install mode - add proper mode persistence and path validation
  // This comment MUST stay until install paths are properly abstracted
  const [installMode, setInstallMode] = createSignal<InstallMode>("global");

  onMount(async () => {
    const reg = await loadRegistry();
    if (!reg) return;
    setRegistry(reg);

    const allItems = getAllItems(reg);
    const installed = await findInstalledItems(allItems, installMode());
    setInitialSelection(installed);
    setSelectedItems(new Set(installed));
  });

  const visibleItems = createMemo(() => {
    const reg = registry();
    if (!reg) return [];
    return buildVisibleItems(reg, expandedCategory(), expandedPack());
  });

  const isPackSelected = (pack: Pack) => pack.items.every((i) => selectedItems().has(i));

  const togglePack = (pack: Pack) => {
    const next = new Set(selectedItems());
    if (isPackSelected(pack)) {
      pack.items.forEach((i) => next.delete(i));
    } else {
      pack.items.forEach((i) => next.add(i));
    }
    setSelectedItems(next);
  };

  const toggleItem = (item: RegistryItem) => {
    const next = new Set(selectedItems());
    if (next.has(item)) {
      next.delete(item);
    } else {
      next.add(item);
    }
    setSelectedItems(next);
  };

  const changes = createMemo<Changes>(() => ({
    install: Array.from(selectedItems()).filter((i) => !initialSelection().has(i)),
    remove: Array.from(initialSelection()).filter((i) => !selectedItems().has(i)),
  }));

  const executeSync = async () => {
    await performSync(changes(), installMode(), (msg) => {
      setSyncLogs((prev) => [...prev, msg]);
    });
    setStatus("done");
  };

  useKeyboard((key: { name: string; ctrl?: boolean }) => {
    const input = key.name;

    if (status() !== "selecting") {
      if (input === "return") {
        if (status() === "confirming") {
          setStatus("syncing");
          executeSync();
        } else if (status() === "done") {
          process.exit(0);
        }
      }
      if (input === "escape" || (key.ctrl && input === "c")) {
        process.exit(0);
      }
      return;
    }

    const items = visibleItems();
    const currentItem = items[cursor()];

    if (input === "up" || input === "k") {
      setCursor((prev) => Math.max(0, prev - 1));
    }

    if (input === "down" || input === "j") {
      setCursor((prev) => Math.min(items.length - 1, prev + 1));
    }

    if ((input === "right" || input === "l") && currentItem) {
      const targetId = currentItem.id;
      if (currentItem.type === "category") {
        setExpandedCategory(currentItem.id);
        setExpandedPack(null);
      } else if (currentItem.type === "pack" && currentItem.pack) {
        setExpandedPack(currentItem.pack.name);
      }
      const newItems = visibleItems();
      const newIdx = newItems.findIndex((i) => i.id === targetId);
      if (newIdx !== -1) setCursor(newIdx);
    }

    if ((input === "left" || input === "h") && currentItem) {
      const targetId = currentItem.id;
      if (currentItem.type === "category") {
        setExpandedCategory(null);
      } else if (currentItem.type === "pack") {
        if (currentItem.pack && expandedPack() === currentItem.pack.name) {
          setExpandedPack(null);
        } else {
          const newItems = visibleItems();
          const idx = newItems.findIndex((i) => i.id === "packs");
          if (idx !== -1) setCursor(idx);
          return;
        }
      } else if (currentItem.type === "item" && currentItem.parent) {
        const newItems = visibleItems();
        const idx = newItems.findIndex((i) => i.id === currentItem.parent);
        if (idx !== -1) setCursor(idx);
        return;
      }
      const newItems = visibleItems();
      const newIdx = newItems.findIndex((i) => i.id === targetId);
      if (newIdx !== -1) setCursor(newIdx);
    }

    if (input === "space" && currentItem) {
      if (currentItem.type === "item" && currentItem.item) {
        toggleItem(currentItem.item);
      } else if (currentItem.type === "pack" && currentItem.pack) {
        togglePack(currentItem.pack);
      }
    }

    if (input === "return") {
      setStatus("confirming");
    }

    if (input === "tab") {
      const newMode = installMode() === "global" ? "local" : "global";
      setInstallMode(newMode);
      const reg = registry();
      if (reg) {
        const allItems = getAllItems(reg);
        findInstalledItems(allItems, newMode).then((installed) => {
          setInitialSelection(installed);
          setSelectedItems(new Set(installed));
        });
      }
    }

    if (key.ctrl && input === "c") {
      process.exit(0);
    }
  });

  return (
    <box flexDirection="column" padding={1} flexGrow={1}>
      <box marginBottom={1}>
        <text attributes={TextAttributes.BOLD}>Howaboua's Opencode Workflows</text>
      </box>

      <Show when={status() === "selecting"}>
        <SelectionView
          items={visibleItems}
          cursor={cursor}
          selectedItems={selectedItems}
          isPackSelected={isPackSelected}
          installMode={installMode}
        />
      </Show>

      <Show when={status() === "confirming"}>
        <ConfirmView changes={changes} />
      </Show>

      <Show when={status() === "syncing" || status() === "done"}>
        <SyncView status={status} logs={syncLogs} />
      </Show>
    </box>
  );
};

render(App);
