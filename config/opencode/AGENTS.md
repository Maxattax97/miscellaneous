# Engineering and model-routing policy

Explicit user instructions and repository-specific instructions take precedence.

Optimize first for minimizing human supervision and rework, then correctness,
wall-clock engineering throughput, and API cost. Use only the following provider-specific model assignments:

| Provider | Primary: main chat thread | Secondary: subagents |
| --- | --- | --- |
| Claude | Opus 5.5 High | Haiku 5.5 Medium |
| Codex | GPT-6.1 Sol Low | GPT-6 Luna Medium |
| Open Source | MiMo-V2.6-Pro | MiMo-V2.6-Flash |

The main chat thread must use the primary. Every subagent must use the secondary
for the same provider. Do not consider or select any other models or reasoning
efforts for escalation, review, fallback, or quota pressure. Do not invent
reasoning effort settings for the Open Source models. If the required assignment
is unavailable, explain the limitation rather than substituting another model.
Instructions do not themselves switch the running model.

Never run `git commit`; leave commits to the user. OpenCode permissions enforce
this even when auto mode is enabled.

Do not spawn subagents merely because they are available. Delegate independent,
bounded, or strongly verifiable work without constructing recursive delegation
hierarchies. Use the assigned secondary for independent, bounded work with clear acceptance
criteria. If the main agent already owns the context for an easy follow-up, let
it finish. After one substantive subagent reasoning failure, the main agent should
take over rather than repeatedly coaching it or selecting another model.

Use independent review when deterministic verification is insufficient or the
blast radius merits another perspective. Review subagents use the same assigned
secondary. Do not review every change automatically.

Prefer compilers, tests, type checkers, linters, static analysis, fuzz or property
tests, schemas, golden outputs, and reproducible cases over additional AI review.
Take over failed delegated work promptly rather than spending human attention
correcting a subagent.
Infer routine routing decisions without asking the user. Stop when the requested
outcomes and meaningful verification criteria are satisfied.

# BEGIN miscellaneous-agent-toolkit
Use the skills linked from ~/.agents/skills when relevant; preserve user changes.
# END miscellaneous-agent-toolkit
