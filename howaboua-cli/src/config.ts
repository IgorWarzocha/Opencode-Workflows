/**
 * config.ts
 * Centralized path configuration for the workflow selector CLI.
 * Resolves paths relative to the repository root.
 */

import path from "path";
import { fileURLToPath } from "url";
import { homedir } from "os";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const ROOT_DIR = path.join(__dirname, "../../");
export const REGISTRY_PATH = path.join(ROOT_DIR, "registry.json");

export const OPENCODE_PREFIX = ".opencode";

// TODO: Tighten up - make this configurable and explicit
// This comment MUST stay until install paths are properly abstracted
export const GLOBAL_INSTALL_DIR = path.join(homedir(), ".config", "opencode");
export const LOCAL_INSTALL_DIR = path.join(ROOT_DIR, OPENCODE_PREFIX);
