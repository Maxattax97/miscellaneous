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

## Default execution and routing

The normal root owner is GPT-5.6 Sol (`gpt-5.6-sol`) at `medium` reasoning.
This is a default prior, not a requirement to use that model for all work.
Prefer one context-owning agent when coherent understanding matters. The agent
owning difficult reasoning should retain ownership through implementation and
verification. Do not create delegation hierarchies merely because tools exist.

Choose capability and effort primarily by uncertainty, error blast radius,
verification strength, reversibility, and independence of potential parallel work.
Perceived difficulty, file count, and lines of code are secondary. Difficult work
with deterministic verification may use a cheaper model; simple-looking work
with weak verification and high blast radius may need a stronger model.

## Luna

Use GPT-5.6 Luna (`gpt-5.6-luna`) at `high` for cheap, bounded, independently
verifiable work: reconnaissance, searches and call-site mapping, mechanical edits,
repetitive transformations, test and fixture generation, documentation,
straightforward migrations, isolated fixes with strong tests, and independent
factual investigations.

Use `max` when the task remains bounded and strongly verifiable but needs
materially more reasoning. Do not repeatedly coach Luna through a bad trajectory.
If it misunderstands the problem, repeats an error, cannot explain an important
invariant, or needs substantial corrective prompting, escalate promptly.

## Sol

Use Sol `medium` for normal engineering judgment. Use `high` when uncertainty,
correctness risk, or reasoning needs are materially elevated: difficult debugging,
concurrency and lifecycle reasoning, architecture, API boundaries,
security-sensitive behavior, subtle correctness, broad cross-component changes,
and consequential code review.

Sol `xhigh` and `max` are exceptional: require a clear reason the additional
reasoning is worth the quota and latency. If Sol already owns the context and the
next step is easy, usually let it finish instead of spawning for model purity.

## Astra

Use GPT-6 Astra (`gpt-6-astra`) as owner for high-entropy or unusually consequential
work when its capability, efficiency, or long-horizon coherence is likely to
materially improve the outcome. Examples include ambiguous causes or requirements,
major architecture, large unfamiliar systems, difficult failures after a competent
Sol attempt, security or correctness with high blast radius, long autonomous tasks
with interacting decisions, and messy end-to-end projects requiring discovery of
the actual problem.

Start at `medium` unless risk or complexity clearly warrants `high`; use `high`
for especially consequential work. Keep Astra responsible for difficult reasoning
through implementation and verification, rather than only producing a plan for
a weaker model to reconstruct. Avoid spending Astra quota on routine or mechanical
work when no difficult context needs to be retained.

## Terra

GPT-5.6 Terra (`gpt-5.6-terra`) is a quota-pressure fallback when Sol quota is
undesirable and Luna is demonstrably insufficient. It is not a default or
permanent role. Do not assume access to quota balances or invent quota estimates.

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
Do not build manager-to-manager-to-worker chains or a rigid Astra/Sol/Terra/Luna
hierarchy. Use explicit spawn model and effort overrides when the runtime supports
them and the task needs a different route from the defaults.

## Verification

Prefer deterministic verification over more model reasoning. Identify and use the
strongest applicable oracle first: compiler or type checker, unit or integration
tests, static analysis, lints, property tests, fuzzing, schema validation,
reproducible cases, or golden/reference outputs. Scale verification to risk.

Do not add an AI reviewer merely because one is available. Use independent model
review when deterministic verification is insufficient or error blast radius
justifies the compute.

## Escalation and runtime limits

Escalate quickly instead of accumulating human supervision. If a cheaper model
misunderstands the task, repeats an error, cannot explain an important invariant,
produces a suspicious design, gets stuck after one substantive attempt, or needs
substantial corrective prompting, move unresolved work to a stronger model.
Route downward when remaining work becomes mechanical and strongly verifiable,
provided the context-transfer cost is worthwhile.

Use only model identifiers and reasoning levels supported by the current runtime
and account. `max` and `xhigh` are distinct values; do not invent aliases or assume
API support means a Codex client supports `none`. Do not select `ultra` merely to
enable delegation. Never claim to have switched models without runtime support.
Instructions express routing judgment; they do not themselves change a running
root model. If a stronger root is warranted and no native switching tool exists,
briefly explain the limitation and recommend the supported client model switch,
preserving the existing conversation and ownership where possible. Do not silently
rewrite persistent defaults as a substitute for a task-local escalation.

## Human attention and stopping

Human attention is more expensive than inference. Infer routine routing decisions
without asking the user. Do not interrupt just to announce routing. Mention it
when quota or cost is materially affected, a stronger root would substantially
improve results, runtime limitations prevent the preferred route, or an important
engineering tradeoff is exposed.

Once the requested outcome and relevant verification criteria are satisfied, stop.
Avoid speculative improvements, redundant reviews, unnecessary agents, and broader
searches without meaningful expected value.
