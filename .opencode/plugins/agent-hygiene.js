import { spawnSync } from "node:child_process"
import { fileURLToPath } from "node:url"
import { dirname, resolve } from "node:path"

const engine = resolve(dirname(fileURLToPath(import.meta.url)), "../../.agents/hooks/agent_hygiene.py")
const pendingContext = new Map()
function evaluate(payload) {
  const run = spawnSync("python3", [engine], { input: JSON.stringify(payload), encoding: "utf8" })
  try { return JSON.parse(run.stdout || "{}") } catch { return { decision: "allow" } }
}

export const AgentHygiene = async ({ directory }) => ({
  "tool.execute.before": async (input, output) => {
    const result = evaluate({ host: "opencode", event: "pre_tool", session_id: input.sessionID, cwd: directory, tool_name: input.tool, tool_input: output.args })
    if (result.decision === "deny") throw new Error(result.message)
    if (result.context) pendingContext.set(input.sessionID, result.context)
  },
  "tool.execute.after": async (input, output) => {
    const result = evaluate({ host: "opencode", event: "post_tool", session_id: input.sessionID, cwd: directory, tool_name: input.tool, tool_input: input.args })
    const context = result.context || pendingContext.get(input.sessionID)
    if (context) output.output = `${output.output}\n\n${context}`
    pendingContext.delete(input.sessionID)
  },
  event: async ({ event }) => {
    const types = { "session.compacted": "pre_compact", "session.deleted": "session_end" }
    if (types[event.type]) {
      const result = evaluate({ host: "opencode", event: types[event.type], session_id: event.properties.sessionID, cwd: directory })
      if (result.context) pendingContext.set(event.properties.sessionID, result.context)
    }
  },
})
