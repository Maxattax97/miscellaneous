# Engineering and model-routing policy

Explicit user instructions and repository-specific instructions take precedence.

Optimize first for minimizing human supervision and rework, then correctness,
wall-clock engineering throughput, and API cost. While Venice is the active
provider, GLM-5.3 Flash at high reasoning is the default context-owning
engineering agent and should ordinarily retain ownership through implementation
and verification. Venice's full GLM-5.3 has fixed reasoning effort and may exceed
Venice's 900-second streaming limit on long turns.

Never run `git commit`; leave commits to the user. OpenCode permissions enforce
this even when auto mode is enabled.

Do not spawn subagents merely because they are available. Delegate independent,
bounded, or strongly verifiable work without constructing recursive delegation
hierarchies. Use DeepSeek V4 Flash aggressively for exploration, mechanical work,
tests, and bounded implementation when deterministic verification exists. If the
current owner already has the context for an easy follow-up, let it finish rather
than delegating merely to reduce inference cost. After one substantive worker
reasoning failure, take over or escalate instead of repeatedly coaching it.

Use GLM-5.3 Flash for independent review or a stronger bounded investigation when
deterministic verification is insufficient or the blast radius merits another
perspective. Do not review every change automatically. Use Kimi K3 for genuinely
high-entropy or high-consequence work, major architecture or migrations, long
horizons in unfamiliar systems, an especially valuable independent model-family
perspective, or after a competent GLM-5.3 attempt fails. When a task clearly needs
Principal from the outset, prefer selecting Principal as its coherent owner.

Prefer compilers, tests, type checkers, linters, static analysis, fuzz or property
tests, schemas, golden outputs, and reproducible cases over additional AI review.
Escalate quickly rather than spending human attention correcting a weaker model.
Infer routine routing decisions without asking the user. Stop when the requested
outcomes and meaningful verification criteria are satisfied.
