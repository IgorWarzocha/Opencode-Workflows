import { REMINDER_CONTENT } from "./content"
import { wrapSystemReminder } from "./format"
import type { MessageHookInput, MessageHookOutput, MessagePart, ModelInfo } from "./types"

const REMINDER_TEXT = wrapSystemReminder(REMINDER_CONTENT)

function hasReminder(parts: MessagePart[]): boolean {
  return parts.some((part) => part.type === "text" && part.text?.includes("<system_reminder>"))
}

function isGptModel(model?: ModelInfo): boolean {
  if (!model) return false
  const label = `${model.providerID}/${model.modelID}`.toLowerCase()
  return label.includes("gpt")
}

function createPartId(): string {
  const rand = Math.random().toString(36).slice(2, 8)
  return `rem_${Date.now()}_${rand}`
}

export function createMessageHook() {
  return async (input: MessageHookInput, output: MessageHookOutput) => {
    if (output.parts.length === 0) return
    if (!isGptModel(input.model)) return
    if (hasReminder(output.parts)) return

    const messageID = input.messageID ?? output.parts[0]?.messageID ?? ""

    output.parts.push({
      id: createPartId(),
      sessionID: input.sessionID,
      messageID,
      type: "text",
      text: `\n\n${REMINDER_TEXT}`,
      synthetic: true,
    })
  }
}
