export function wrapSystemReminder(content: string): string {
  return `<system_reminder>\n${content}\n</system_reminder>`
}
