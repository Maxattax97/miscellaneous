# Global engineering and model-routing policy

Explicit user instructions and repository-specific instructions take precedence
over this policy, subject to higher-priority system and developer instructions.

## Objective

Optimize total engineering throughput and correctness, in this priority order:

1. Human attention and interruption cost.
2. Probability and cost of incorrect work and rework.
3. Model and quota consumption.
4. Wall-clock latency.

Do not maximize capability, reasoning effort, agent count, or parallelism for
their own sake.

## Hard safety boundaries

Never run `git commit`; leave commits to the user. This boundary is also enforced
by Codex command rules and a pre-tool hook; it is not merely advisory.

## Fixed model routing

Use only the following provider-specific model assignments:

| Provider | Primary: main chat thread | Secondary: subagents |
| --- | --- | --- |
| Claude | Opus 5.5 High | Haiku 5.5 Medium |
| Codex | GPT-6.1 Sol Low | GPT-6 Luna Medium |
| Open Source | MiMo-V2.6-Pro | MiMo-V2.6-Flash |

The primary is mandatory for the main chat thread. Every subagent must use the
secondary for the same provider. These are exclusive assignments, not defaults:
do not consider or select other models or reasoning efforts, including for
escalation, review, fallback, or quota pressure. Do not invent reasoning effort
settings for the Open Source models.

For Codex subagents, explicitly select `gpt-6-luna` with `medium` reasoning.
The Codex main thread uses `gpt-6.1-sol` with `low` reasoning.

Prefer one context-owning main agent when coherent understanding matters. The
main agent retains ownership through implementation and verification. Do not
create delegation hierarchies merely because tools exist.

## Delegation

Do not spawn subagents by default. This policy requests selective delegation when:

- Independent workstreams save meaningful time in parallel.
- A cheap agent can reduce uncertainty for the owner.
- An independent investigation provides useful diversity.
- Independent review is justified by verification gaps or risk.
- Mechanical work can be offloaded without losing important context.

Prefer investigations, experiments, searches, test exploration, factual questions,
and bounded mechanical work over arbitrary implementation partitioning by files.
Give each delegate a bounded question, relevant context, and acceptance oracle.
Verify its result before integrating it. Avoid duplicated reconstruction of large
contexts unless independent solutions are intentionally valuable.

Prefer an owner with bounded reconnaissance, investigation, or mechanical agents.
Do not build manager-to-manager-to-worker chains or recursive delegation
hierarchies. Use explicit spawn model and effort settings to enforce the fixed
secondary assignment.

## Verification

Prefer deterministic verification over more model reasoning. Identify and use the
strongest applicable oracle first: compiler or type checker, unit or integration
tests, static analysis, lints, property tests, fuzzing, schema validation,
reproducible cases, or golden/reference outputs. Scale verification to risk.

Do not add an AI reviewer merely because one is available. Use independent model
review when deterministic verification is insufficient or error blast radius
justifies the compute.

## Failed delegation and runtime limits

If a subagent misunderstands the task, repeats an error, cannot explain an
important invariant, or gets stuck after one substantive attempt, the main agent
should take over. Do not repeatedly coach a failing subagent or switch to an
unlisted model or effort.

Use only supported runtime identifiers for the exact assignments above. If an
assignment is unavailable, explain the limitation rather than substituting another
model or effort. Never claim to have switched models without runtime support.
Instructions do not themselves change the running main-thread model. Do not
rewrite persistent defaults as a substitute for a task-local model switch.

## Human attention and stopping

Human attention is more expensive than inference. Infer routine routing decisions
without asking the user. Do not interrupt just to announce routing. Mention it
when quota or cost is materially affected, runtime limitations prevent the
required assignment, or an important
engineering tradeoff is exposed.

Once the requested outcome and relevant verification criteria are satisfied, stop.
Avoid speculative improvements, redundant reviews, unnecessary agents, and broader
searches without meaningful expected value.

# BEGIN miscellaneous-agent-toolkit
Use the skills linked from ~/.agents/skills when relevant; preserve user changes.
# END miscellaneous-agent-toolkit
