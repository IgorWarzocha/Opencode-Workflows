import { Command } from "commander"
import chalk from "chalk"

const program = new Command()

program
  .name("opencode")
  .description("CLI for managing Opencode workflows")
  .version("0.1.0")

program
  .command("init")
  .description("Initialize opencode configuration in your project")
  .action(() => {
    console.log(chalk.green("Initializing opencode..."))
    // TODO: Implement init logic
  })

program
  .command("add")
  .description("Add an agent or skill to your project")
  .argument("<name>", "Name of the agent or skill to add")
  .action((name) => {
    console.log(chalk.blue(`Adding ${name}...`))
    // TODO: Implement add logic using registry.json
  })

program.parse()
