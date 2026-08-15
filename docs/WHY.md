# Why Lean Agent Skills saves tokens (deep dive)

Token spend of a coding agent ≈
**model × context-per-turn × number-of-turns × reasoning depth**.
Every mechanism below attacks at least one of those factors.

## 1. Progressive disclosure replaces always-on rule files

The classic setup stuffs conventions into `AGENTS.md` / `CLAUDE.md` /
`.cursorrules` — content that is re-sent on **every turn**.

With Agent Skills, only each skill's *name + description* (~50–100 tokens)
is resident. The full instruction body loads **only when a task matches**,
and reference files/scripts load only when needed.

→ Fixed per-turn overhead drops from "entire rule file" to "a short index".

Sources: [agentskills.io](https://agentskills.io),
[Anthropic — Equipping agents for the real world with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills),
[Codex skills docs](https://developers.openai.com/codex/skills).

## 2. Scripts move deterministic work out of the LLM

Document generation (docx/pdf/pptx/xlsx), formatting, validation and
analysis in the curated catalog run as **scripts**. The agent executes them
and reads the output — it does not spend reasoning tokens re-deriving the
procedure.

→ That work costs zero LLM tokens, and it's reproducible.

## 3. Curated procedures cut exploration and fix-up rounds

Vague task → agent explores → wrong turn → fix → re-send full context.
Skills like `gh-fix-ci`, `define-goal` and `karpathy-guidelines` give the
agent a verified path up front: fewer turns, no re-discovery, smaller diffs.

→ Each avoided turn saves the entire accumulated conversation from being
re-sent.

## 4. Cache-friendly by design

Providers discount cached input tokens heavily (Anthropic documents up to
~90% off for cache reads). Skills encourage:

- stable prefixes (small fixed `AGENTS.md`, stable skill index),
- starting new sessions per task instead of dragging dead context,
- compacting before context bloats.

→ More cache hits, cheaper input tokens.

## 5. Quality is preserved by construction

- `karpathy-guidelines`: simplicity, surgical changes, surfaced
  assumptions, verifiable success criteria.
- `skill-optimizer` suite: mines your own session history into skills and
  keeps skill bodies lean.
- Model-agnostic instructions mean behavior doesn't degrade when the host
  agent switches models.

## Honest expectations

Savings are workload-dependent. The guarantee this repo makes is
**structural**: every mechanism removes tokens that were previously paid on
every turn or on every wrong turn. Measure your own delta with your
agent's usage view (`/cost` in Claude Code, Codex usage dashboard,
Antigravity quota panel).
