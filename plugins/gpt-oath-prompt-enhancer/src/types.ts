export type MessagePart = {
  id: string
  sessionID: string
  messageID: string
  type: string
  text?: string
  synthetic?: boolean
}

export type ModelInfo = {
  providerID: string
  modelID: string
}

export type MessageHookInput = {
  sessionID: string
  messageID?: string
  model?: ModelInfo
}

export type MessageHookOutput = {
  message: unknown
  parts: MessagePart[]
}
