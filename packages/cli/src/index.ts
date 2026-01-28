import { Command } from "commander"
import chalk from "chalk"
import fs from "fs-extra"
import path from "path"
import ora from "ora"
import readline from "readline"

// --- Registry Types ---
interface RegistryItem {
  name: string
  description: string
  type: "agent" | "skill" | "command" | "doc"
  path: string
  target: string
}

interface Pack {
  name: string
  description: string
  path: string
  items: RegistryItem[]
}

interface Registry {
  name: string
  version: string
  packs: Pack[]
  standalone: RegistryItem[]
}

// --- Constants ---
const LOCAL_REGISTRY_PATH = path.join("/home/igorw/Work/Opencode-Workflows", "registry.json")

// --- Helpers ---
async function getRegistry(): Promise<Registry> {
  const spinner = ora("Fetching latest registry...").start()
  try {
    const registryContent = await fs.readJson(LOCAL_REGISTRY_PATH)
    spinner.succeed("Registry loaded.")
    return registryContent as Registry
  } catch (error) {
    spinner.fail("Failed to load registry.")
    process.exit(1)
  }
}

function resolveTargetPath(item: RegistryItem): string {
  let target = item.target
  if (["agent", "skill", "command"].includes(item.type) && !target.startsWith(".opencode/")) {
    target = path.join(".opencode", target)
  }
  return path.join(process.cwd(), target)
}

// --- Tree Selector Implementation ---
class TreeSelector {
  private registry: Registry
  private cursor = 0
  private cursorId: string = "packs" // ID-based cursor for stability
  private expandedCategory: string | null = null
  private expandedPack: string | null = null
  private selectedItems = new Set<RegistryItem>()
  private visibleItems: any[] = []

  constructor(registry: Registry) {
    this.registry = registry
  }

  private buildVisibleItems() {
    const items: any[] = []

    // 1. Packs Category
    const packsExpanded = this.expandedCategory === "packs"
    items.push({ type: "category", id: "packs", title: "Packs", expanded: packsExpanded })
    
    if (packsExpanded) {
      for (const pack of this.registry.packs) {
        const packExpanded = this.expandedPack === pack.name
        items.push({ type: "pack", id: `pack:${pack.name}`, title: pack.name, expanded: packExpanded, parent: "packs", pack })
        if (packExpanded) {
          for (const item of pack.items) {
            items.push({ type: "item", id: `item:${pack.name}:${item.name}`, title: item.name, item, parent: `pack:${pack.name}` })
          }
        }
      }
    }

    // 2. Agents Category
    const agentsExpanded = this.expandedCategory === "agents"
    items.push({ type: "category", id: "agents", title: "Standalone Agents", expanded: agentsExpanded })
    if (agentsExpanded) {
      const agents = this.registry.standalone.filter(s => s.type === "agent")
      for (const agent of agents) {
        items.push({ type: "item", id: `agent:${agent.name}`, title: agent.name, item: agent, parent: "agents" })
      }
    }

    // 3. Commands Category
    const commandsExpanded = this.expandedCategory === "commands"
    items.push({ type: "category", id: "commands", title: "Standalone Commands", expanded: commandsExpanded })
    if (commandsExpanded) {
      const cmds = this.registry.standalone.filter(s => s.type === "command")
      for (const cmd of cmds) {
        items.push({ type: "item", id: `cmd:${cmd.name}`, title: cmd.name, item: cmd, parent: "commands" })
      }
    }

    this.visibleItems = items
    
    // Stabilize numerical cursor based on cursorId
    const newIndex = items.findIndex(i => i.id === this.cursorId)
    if (newIndex !== -1) {
      this.cursor = newIndex
    } else {
      // If the tracked ID is gone, snap to parent or nearest neighbor
      this.cursor = Math.min(this.cursor, items.length - 1)
      this.cursorId = items[this.cursor].id
    }
  }

  private render() {
    process.stdout.write("\x1Bc") 
    console.log(chalk.bold.cyan("Opencode Workflow Selector"))
    console.log(chalk.gray("↑/↓: Navigate | →/←: Expand/Collapse | Space: Toggle | Enter: Install\n"))

    this.visibleItems.forEach((item, index) => {
      const isCursor = index === this.cursor
      const prefix = isCursor ? chalk.blue("❯ ") : "  "
      
      let line = ""
      if (item.type === "category") {
        const icon = item.expanded ? "▼ " : "▶ "
        line = `${prefix}${chalk.bold(icon + item.title)}`
      } else if (item.type === "pack") {
        const icon = item.expanded ? "  ▼ " : "  ▶ "
        const checkbox = this.isPackSelected(item.pack) ? chalk.green("[x] ") : "[ ] "
        line = `${prefix}${icon}${checkbox}${item.title} ${chalk.dim(`(${item.pack.items.length} items)`)}`
      } else if (item.type === "item") {
        const checkbox = this.selectedItems.has(item.item) ? chalk.green("[x] ") : "[ ] "
        const indent = (item.parent === "agents" || item.parent === "commands") ? "    " : "      "
        line = `${prefix}${indent}${checkbox}${item.title} ${chalk.dim(`(${item.item.type})`)}`
      }

      console.log(isCursor ? chalk.bgWhite.black(line) : line)
    })

    console.log(`\nSelected: ${this.selectedItems.size} items`)
  }

  private isPackSelected(pack: Pack) {
    return pack.items.every(i => this.selectedItems.has(i))
  }

  private togglePack(pack: Pack) {
    if (this.isPackSelected(pack)) pack.items.forEach(i => this.selectedItems.delete(i))
    else pack.items.forEach(i => this.selectedItems.add(i))
  }

  public select(): Promise<RegistryItem[]> {
    return new Promise((resolve) => {
      readline.emitKeypressEvents(process.stdin)
      if (process.stdin.isTTY) {
        process.stdin.setRawMode(true)
        process.stdin.resume()
      }

      this.buildVisibleItems()
      this.render()

      process.stdin.on("keypress", (str, key) => {
        if (!key) return
        const item = this.visibleItems[this.cursor]
        if (!item) return

        if (key.name === "up") {
          this.cursor = Math.max(0, this.cursor - 1)
          this.cursorId = this.visibleItems[this.cursor].id
        } else if (key.name === "down") {
          this.cursor = Math.min(this.visibleItems.length - 1, this.cursor + 1)
          this.cursorId = this.visibleItems[this.cursor].id
        } else if (key.name === "right") {
          if (item.type === "category") {
            this.expandedCategory = item.id
            this.expandedPack = null
          } else if (item.type === "pack") {
            this.expandedPack = item.pack.name
          }
        } else if (key.name === "left") {
          if (item.type === "category") {
            this.expandedCategory = null
          } else if (item.type === "pack") {
            if (this.expandedPack === item.pack.name) {
              this.expandedPack = null
            } else {
              this.cursorId = "packs"
            }
          } else if (item.type === "item") {
            this.cursorId = item.parent
          }
        } else if (key.name === "space") {
          if (item.type === "item") {
            if (this.selectedItems.has(item.item)) this.selectedItems.delete(item.item)
            else this.selectedItems.add(item.item)
          } else if (item.type === "pack") {
            this.togglePack(item.pack)
          }
        } else if (key.name === "return") {
          if (process.stdin.isTTY) process.stdin.setRawMode(false)
          process.stdin.pause()
          resolve(Array.from(this.selectedItems))
          return
        } else if (key.ctrl && key.name === "c") {
          if (process.stdin.isTTY) process.stdin.setRawMode(false)
          process.exit()
        }

        this.buildVisibleItems()
        this.render()
      })
    })
  }
}

// --- Main CLI ---
const program = new Command()
program.name("opencode").version("0.1.0")

program
  .command("add")
  .option("-d, --dry-run")
  .action(async (options) => {
    const registry = await getRegistry()
    const selector = new TreeSelector(registry)
    const selection = await selector.select()

    if (selection.length === 0) {
      console.log(chalk.yellow("\nNo items selected."))
      return
    }

    console.log(chalk.blue(`\nInstalling ${selection.length} items...`))
    for (const item of selection) {
      const source = path.join("/home/igorw/Work/Opencode-Workflows", item.path)
      const dest = resolveTargetPath(item)
      if (options.dryRun) console.log(chalk.gray(`[DRY] ${item.name} -> ${path.relative(process.cwd(), dest)}`))
      else {
        await fs.ensureDir(path.dirname(dest))
        await fs.copy(source, dest)
        console.log(chalk.green(`✓ ${item.name}`))
      }
    }
  })

program.parse()
