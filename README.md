<div align="center">

# ⚡ Lean Agent Skills

### Your coding agent is re-reading your entire codebase every turn — and you're paying for it.

**One command installs curated, battle-tested Agent Skills that slash token usage of AI coding agents — without lowering output quality.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Standard: Agent Skills](https://img.shields.io/badge/standard-Agent%20Skills-blue)](https://agentskills.io)
[![Agents supported](https://img.shields.io/badge/agents-10%2B-success)](#supported-ai-coding-agents)
[![Curated skills](https://img.shields.io/badge/skills-45%2B-orange)](#curated-skill-catalog)

[Quick start](#-quick-start) · [Why it saves tokens](#-why-this-saves-tokens) · [Supported agents](#-supported-ai-coding-agents) · [Catalog](#-curated-skill-catalog) · [FAQ](#-faq) · [فارسی](README.fa.md)

</div>

---

## 😤 The problem

Every AI coding agent — **Claude Code, OpenAI Codex, Google Antigravity, Cursor, GitHub Copilot, Gemini CLI** — burns tokens on the same three things:

1. **Re-discovery.** Each session, the agent re-explores your repo to learn conventions it already learned yesterday.
2. **Bulky always-on context.** Giant rule files (`AGENTS.md`, `CLAUDE.md`, `.cursorrules`) get resent on *every single turn*.
3. **Trial and error.** Vague tasks → exploration → wrong turns → fix-up rounds. Each round resends the whole conversation.

You feel it as: hitting context limits, slow turns, and a token bill that keeps growing.

## ✅ The fix

Agent Skills are the open standard ([agentskills.io](https://agentskills.io)) adopted by **40+ clients** — including Claude Code, Codex, Copilot, Cursor, Antigravity and Gemini CLI. A skill is a folder with a `SKILL.md`; agents load them **progressively**:

| Mechanism | What happens | Token effect |
|---|---|---|
| **Progressive disclosure** | Only each skill's *name + description* (~50–100 tokens) sits in context; full instructions load only when a task matches | Replaces bulky always-on rule files |
| **Scripts instead of context** | Deterministic work (documents, analysis, validation) runs as code, not LLM reasoning | That work costs **zero** LLM tokens |
| **Battle-tested procedures** | Curated workflows remove exploration, wrong turns and fix-up rounds | Fewer turns, *better* results |
| **Cache-friendly design** | Stable prefixes + lean sessions → more prompt-cache hits | Cached input tokens are discounted up to ~90% by major providers |

> Quality goes **up**, not down: skills encode verified procedures instead of the agent improvising a new approach every session.

## 🚀 Quick start

```bash
git clone https://github.com/tmolavi/lean-agent-skills.git
cd your-project
../lean-agent-skills/install.sh              # project-level (recommended)

# or globally, for every project:
../lean-agent-skills/install.sh --global

# preview first:
../lean-agent-skills/install.sh --dry-run
```

That's it. Start a new turn in your agent — skills are discovered automatically, or invoke them explicitly (e.g. `$skill-name` in Codex, `/skills` listing).

**Options**

```
--dest DIR      base directory for the project install (default: current dir)
--global        install into your home directories instead
--agents LIST   codex,claude,antigravity,cursor,copilot,gemini
                (default: codex,claude,antigravity,copilot)
--dry-run       show what would happen
--force         overwrite an existing AGENTS.md
```

The installer also writes a tiny **token-frugal `AGENTS.md`** (~20 lines) with working rules for context hygiene, scope discipline and targeted execution — and never overwrites yours without `--force`.

Remove everything with `uninstall.sh` (it tracks exactly what it installed).

## 🤖 Supported AI coding agents

Full breakdown with skill paths and official docs: [docs/AI-CODING-AGENTS.md](docs/AI-CODING-AGENTS.md)

| Agent | Vendor | Skill path (project) | Status |
|---|---|---|---|
| **Claude Code** | Anthropic | `.claude/skills/` | ✅ native |
| **Codex** | OpenAI | `.agents/skills/` | ✅ native |
| **Antigravity** | Google | `.agents/skills/` | ✅ native |
| **Cursor** | Anysphere | `.cursor/skills/` | ✅ native |
| **GitHub Copilot** | GitHub/Microsoft | `.github/skills/` | ✅ native |
| **Gemini CLI** | Google | `.gemini/skills/` | ✅ native |
| **Windsurf** | Codeium | `.windsurf/skills/` | ✅ native |
| **OpenCode** | community | `.opencode/skills/` | ✅ native |
| Zed, Kiro, Junie, Amp, Goose, Roo Code, Cline, Aider… | various | standard-compliant | ✅ via [agentskills.io](https://agentskills.io) |

## 📦 Curated skill catalog

This repo **selects** the best existing skills from official sources — no AI-slop, no bulk generation. 45+ skills, all lazy-loaded:

| Source | Skills | Why it's here |
|---|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) (official) | `skill-creator`, `docx`, `pdf`, `pptx`, `xlsx` | Document work delegated to **scripts** (zero LLM tokens); `skill-creator` helps you build your own |
| [openai/skills](https://github.com/openai/skills) (official Codex catalog) | 30+ curated: `gh-fix-ci`, `gh-address-comments`, `define-goal`, `security-best-practices`, `playwright`, deploys (Vercel/Netlify/Cloudflare/Render), Notion, Linear, Figma… | OpenAI's vetted workflows replace trial-and-error |
| [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | `karpathy-guidelines` | "Surgical changes, simplicity, verifiable success criteria" — the quality guardrail |
| [hqhq1025/skill-optimizer](https://github.com/hqhq1025/skill-optimizer) | `skill-miner`, `skill-generalizer`, `skill-personalizer` | Mines **your session history** into new skills, then keeps every skill lean |

Browse even more: [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) · [gmh5225/awesome-skills](https://github.com/gmh5225/awesome-skills) · [agent-skill.co](https://github.com/heicheng/awesome-agent-skills)

The machine-readable list lives in [manifest.yaml](manifest.yaml).

## 🧠 The token-frugal rules (installed as `AGENTS.md`)

```markdown
## Context hygiene
- New task = new session; compact/summarize when context grows heavy.
- Read only the files you need; prefer search/grep over reading whole files.
- Never re-read a file that has not changed since you last read it.

## Scope discipline
- Make minimal, surgical changes; do not touch files outside the task.
- For anything beyond a small edit: present a short plan first, then execute.

## Execution
- Run targeted tests, not the whole suite, unless asked.
- If an installed skill covers the task, use it and follow its scripts.
- Keep diffs, comments and answers concise; no boilerplate.
```

Deep dive with sources: [docs/WHY.md](docs/WHY.md) · FAQ: [docs/FAQ.md](docs/FAQ.md)

## ❓ FAQ

**Does this actually reduce my token bill?**
The mechanisms are structural: leaner always-on context, lazy-loaded instructions, scripted deterministic work, fewer exploration/fix-up turns, and better prompt-cache hit rates. Your exact savings depend on workload — but every mechanism above removes tokens that were previously spent on *every* turn.

**Will output quality drop?**
The opposite is the goal: curated skills replace improvisation with verified procedures. The included `karpathy-guidelines` skill explicitly enforces simplicity and surgical changes.

**Do I need all 45 skills?**
No. Skills are lazy-loaded; each costs only its name+description in context until used. Prune anytime — delete folders from the skills directory, or run `skill-personalizer` to tailor the set.

**Which agents work?**
Anything implementing the open Agent Skills standard — Claude Code, Codex, Antigravity, Cursor, Copilot, Gemini CLI, Windsurf, OpenCode and ~40 more clients listed on [agentskills.io](https://agentskills.io).

**More questions?** → [docs/FAQ.md](docs/FAQ.md)

## 🗺️ Roadmap

- [ ] Per-agent token-spend audit skill (uses local session logs)
- [ ] `npx lean-skills` one-liner installer
- [ ] Community skill nominations via PR (quality bar: real usage, lean, model-agnostic)
- [ ] Quarterly re-curation against upstream repos

## 🤝 Contributing

Propose a skill, report a broken upstream link, or improve the frugal rules. Quality bar is in [CONTRIBUTING.md](CONTRIBUTING.md).

## 🔗 Related Projects

Part of the **Molavi AI Engineering Ecosystem**:

* [**mcp-agent-skills-hub**](https://github.com/tmolavi/mcp-agent-skills-hub): Curated production agent skills catalog.
* [**n8n-agent-skills**](https://github.com/tmolavi/n8n-agent-skills): Production n8n agent workflow architecture.
* [**agent-project-discovery-skill**](https://github.com/tmolavi/agent-project-discovery-skill): Codebase startup & context discovery skill.
* [**geo-scope**](https://github.com/tmolavi/geo-scope): Multi-model empirical AI visibility benchmark engine.
* [**Ecosystem Map**](https://github.com/tmolavi/geo-scope/blob/main/docs/GITHUB_ECOSYSTEM.md): Complete architecture and evidence flow.

---

## 👤 Author & License

Developed by **Taghi Molavi** — [molavi.pro](https://molavi.pro)  
MIT — see [LICENSE](LICENSE). All skills belong to their respective upstream authors and licenses; this repository selects, organizes and installs them.

