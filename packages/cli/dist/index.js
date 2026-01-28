// src/index.ts
import { Command } from "commander";
import chalk from "chalk";
import fs from "fs-extra";
import path from "path";
import ora from "ora";
import readline from "readline";
var LOCAL_REGISTRY_PATH = path.join("/home/igorw/Work/Opencode-Workflows", "registry.json");
async function getRegistry() {
  const spinner = ora("Fetching latest registry...").start();
  try {
    const registryContent = await fs.readJson(LOCAL_REGISTRY_PATH);
    spinner.succeed("Registry loaded.");
    return registryContent;
  } catch (error) {
    spinner.fail("Failed to load registry.");
    process.exit(1);
  }
}
function resolveTargetPath(item) {
  let target = item.target;
  if (["agent", "skill", "command"].includes(item.type) && !target.startsWith(".opencode/")) {
    target = path.join(".opencode", target);
  }
  return path.join(process.cwd(), target);
}
var TreeSelector = class {
  registry;
  cursor = 0;
  cursorId = "packs";
  expandedCategory = null;
  expandedPack = null;
  selectedItems = /* @__PURE__ */ new Set();
  visibleItems = [];
  initialSelection = /* @__PURE__ */ new Set();
  constructor(registry) {
    this.registry = registry;
  }
  async init() {
    const allItems = [
      ...this.registry.packs.flatMap((p) => p.items),
      ...this.registry.standalone
    ];
    for (const item of allItems) {
      if (await fs.pathExists(resolveTargetPath(item))) {
        this.selectedItems.add(item);
        this.initialSelection.add(item);
      }
    }
  }
  buildVisibleItems() {
    const items = [];
    const packsExpanded = this.expandedCategory === "packs";
    items.push({ type: "category", id: "packs", title: "Packs", expanded: packsExpanded });
    if (packsExpanded) {
      for (const pack of this.registry.packs) {
        const packExpanded = this.expandedPack === pack.name;
        items.push({ type: "pack", id: `pack:${pack.name}`, title: pack.name, expanded: packExpanded, parent: "packs", pack });
        if (packExpanded) {
          for (const item of pack.items) {
            items.push({ type: "item", id: `item:${pack.name}:${item.name}`, title: item.name, item, parent: `pack:${pack.name}` });
          }
        }
      }
    }
    const agentsExpanded = this.expandedCategory === "agents";
    items.push({ type: "category", id: "agents", title: "Standalone Agents", expanded: agentsExpanded });
    if (agentsExpanded) {
      const agents = this.registry.standalone.filter((s) => s.type === "agent");
      for (const agent of agents) {
        items.push({ type: "item", id: `agent:${agent.name}`, title: agent.name, item: agent, parent: "agents" });
      }
    }
    const commandsExpanded = this.expandedCategory === "commands";
    items.push({ type: "category", id: "commands", title: "Standalone Commands", expanded: commandsExpanded });
    if (commandsExpanded) {
      const cmds = this.registry.standalone.filter((s) => s.type === "command");
      for (const cmd of cmds) {
        items.push({ type: "item", id: `cmd:${cmd.name}`, title: cmd.name, item: cmd, parent: "commands" });
      }
    }
    this.visibleItems = items;
    const newIndex = items.findIndex((i) => i.id === this.cursorId);
    if (newIndex !== -1) {
      this.cursor = newIndex;
    } else {
      this.cursor = Math.min(this.cursor, items.length - 1);
      this.cursorId = items[this.cursor].id;
    }
  }
  render() {
    process.stdout.write("\x1Bc");
    console.log(chalk.bold.cyan("Opencode Workflow Selector"));
    console.log(chalk.gray("\u2191/\u2193: Navigate | \u2192/\u2190: Expand | Space: Toggle | Enter: Sync\n"));
    this.visibleItems.forEach((item, index) => {
      const isCursor = index === this.cursor;
      const prefix = isCursor ? chalk.blue("\u276F ") : "  ";
      let line = "";
      if (item.type === "category") {
        const icon = item.expanded ? "\u25BC " : "\u25B6 ";
        line = `${prefix}${chalk.bold(icon + item.title)}`;
      } else if (item.type === "pack") {
        const icon = item.expanded ? "  \u25BC " : "  \u25B6 ";
        const checkbox = this.isPackSelected(item.pack) ? chalk.green("[x] ") : "[ ] ";
        line = `${prefix}${icon}${checkbox}${item.title} ${chalk.dim(`(${item.pack.items.length} items)`)}`;
      } else if (item.type === "item") {
        const checkbox = this.selectedItems.has(item.item) ? chalk.green("[x] ") : "[ ] ";
        const indent = item.parent === "agents" || item.parent === "commands" ? "    " : "      ";
        line = `${prefix}${indent}${checkbox}${item.title} ${chalk.dim(`(${item.item.type})`)}`;
      }
      console.log(isCursor ? chalk.bgWhite.black(line) : line);
    });
    const current = this.visibleItems[this.cursor];
    let desc = "";
    if (current.type === "pack") desc = current.pack.description;
    else if (current.type === "item") desc = current.item.description;
    else if (current.type === "category") {
      if (current.id === "packs") desc = "Collection of specialized agents and tools";
      else if (current.id === "agents") desc = "Individual global orchestration agents";
      else if (current.id === "commands") desc = "Common repository utility commands";
    }
    console.log(chalk.dim("\n" + "\u2500".repeat(50)));
    if (desc) {
      console.log(chalk.italic.yellow(" Info: ") + chalk.white(desc));
    }
    console.log(chalk.dim(" Selected: ") + chalk.bold.green(this.selectedItems.size) + chalk.dim(" items"));
  }
  isPackSelected(pack) {
    return pack.items.every((i) => this.selectedItems.has(i));
  }
  togglePack(pack) {
    if (this.isPackSelected(pack)) pack.items.forEach((i) => this.selectedItems.delete(i));
    else pack.items.forEach((i) => this.selectedItems.add(i));
  }
  select() {
    return new Promise((resolve) => {
      readline.emitKeypressEvents(process.stdin);
      if (process.stdin.isTTY) {
        process.stdin.setRawMode(true);
        process.stdin.resume();
      }
      this.buildVisibleItems();
      this.render();
      process.stdin.on("keypress", (str, key) => {
        if (!key) return;
        const item = this.visibleItems[this.cursor];
        if (!item) return;
        if (key.name === "up") {
          this.cursor = Math.max(0, this.cursor - 1);
          this.cursorId = this.visibleItems[this.cursor].id;
        } else if (key.name === "down") {
          this.cursor = Math.min(this.visibleItems.length - 1, this.cursor + 1);
          this.cursorId = this.visibleItems[this.cursor].id;
        } else if (key.name === "right") {
          if (item.type === "category") {
            this.expandedCategory = item.id;
            this.expandedPack = null;
          } else if (item.type === "pack") {
            this.expandedPack = item.pack.name;
          }
        } else if (key.name === "left") {
          if (item.type === "category") {
            this.expandedCategory = null;
          } else if (item.type === "pack") {
            if (this.expandedPack === item.pack.name) {
              this.expandedPack = null;
            } else {
              this.cursorId = "packs";
            }
          } else if (item.type === "item") {
            this.cursorId = item.parent;
          }
        } else if (key.name === "space") {
          if (item.type === "item") {
            if (this.selectedItems.has(item.item)) this.selectedItems.delete(item.item);
            else this.selectedItems.add(item.item);
          } else if (item.type === "pack") {
            this.togglePack(item.pack);
          }
        } else if (key.name === "return") {
          if (process.stdin.isTTY) process.stdin.setRawMode(false);
          process.stdin.pause();
          const currentSelection = Array.from(this.selectedItems);
          const toInstall = currentSelection.filter((i) => !this.initialSelection.has(i));
          const toRemove = Array.from(this.initialSelection).filter((i) => !this.selectedItems.has(i));
          resolve({ install: toInstall, remove: toRemove });
          return;
        } else if (key.ctrl && key.name === "c") {
          if (process.stdin.isTTY) process.stdin.setRawMode(false);
          process.exit();
        }
        this.buildVisibleItems();
        this.render();
      });
    });
  }
};
var program = new Command();
program.name("opencode").version("0.1.0");
program.command("add").option("-d, --dry-run").action(async (options) => {
  const registry = await getRegistry();
  const selector = new TreeSelector(registry);
  await selector.init();
  const { install, remove } = await selector.select();
  if (install.length === 0 && remove.length === 0) {
    console.log(chalk.yellow("\nNo changes to apply."));
    return;
  }
  console.log(chalk.bold.blue("\nChanges Summary:"));
  if (install.length > 0) {
    console.log(chalk.green(`  Install (${install.length}):`));
    install.forEach((i) => console.log(`    + ${i.name}`));
  }
  if (remove.length > 0) {
    console.log(chalk.red(`  Remove (${remove.length}):`));
    remove.forEach((i) => console.log(`    - ${i.name}`));
  }
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  const confirm = await new Promise((r) => rl.question(chalk.bold("\nProceed with changes? (y/N): "), r));
  rl.close();
  if (String(confirm).toLowerCase() !== "y") {
    console.log(chalk.yellow("Aborted."));
    return;
  }
  if (remove.length > 0) {
    console.log(chalk.blue(`
Uninstalling items...`));
    for (const item of remove) {
      const dest = resolveTargetPath(item);
      if (options.dryRun) console.log(chalk.gray(`[DRY] rm ${dest}`));
      else {
        await fs.remove(dest);
        console.log(chalk.red(`\u2713 Removed ${item.name}`));
      }
    }
  }
  if (install.length > 0) {
    console.log(chalk.blue(`
Installing items...`));
    for (const item of install) {
      const source = path.join("/home/igorw/Work/Opencode-Workflows", item.path);
      const dest = resolveTargetPath(item);
      if (options.dryRun) console.log(chalk.gray(`[DRY] ${item.name} -> ${path.relative(process.cwd(), dest)}`));
      else {
        await fs.ensureDir(path.dirname(dest));
        await fs.copy(source, dest);
        console.log(chalk.green(`\u2713 Installed ${item.name}`));
      }
    }
  }
});
program.parse();
