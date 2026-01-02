import type { Plugin } from "@opencode-ai/plugin"
import { createMessageHook } from "./hook"

export const UserReminderPlugin: Plugin = async () => {
  return {
    "chat.message": createMessageHook(),
  }
}
