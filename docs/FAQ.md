# FAQ

**How do I reduce token usage in Claude Code?**
Install the skills (`install.sh`), start new sessions per task (`/clear`),
compact when heavy (`/compact`), keep `CLAUDE.md` tiny, disable unused MCP
servers, and pick cheaper models for simple work (`/model`). This repo
automates the skills part and installs lean working rules.

**How do I lower OpenAI Codex token cost?**
Same skills (Codex reads `.agents/skills/`), plus
`model_reasoning_effort = "low"|"medium"` in `~/.codex/config.toml` for
routine tasks, and `$skill-name` to invoke workflows directly.

**Do skills work in Google Antigravity?**
Yes — Antigravity reads the same `SKILL.md` format from `.agents/skills/`
and activates skills semantically via the `description` field.

**What are Agent Skills / SKILL.md?**
An open standard (agentskills.io): each skill is a folder with a
`SKILL.md` — YAML frontmatter (`name`, `description`) plus markdown
instructions and optional scripts. 40+ clients support it.

**Will skills lower output quality?**
No — they replace improvisation with verified procedures. The included
`karpathy-guidelines` skill explicitly enforces simplicity, surgical
changes and verifiable success criteria.

**Do all 45 skills cost context?**
Only their name+description (~50–100 tokens each) until a task matches.
Delete any folder to prune; run `skill-personalizer` to tailor the set.

**Which upstream repos are used?**
anthropics/skills (official Anthropic), openai/skills (official Codex
catalog), multica-ai/andrej-karpathy-skills, hqhq1025/skill-optimizer.
See `manifest.yaml`.

**How do I uninstall?**
Run `uninstall.sh` with the same `--dest/--global` flags you installed
with. It removes exactly what it installed (tracked in a manifest file).

**Can I add my own skills?**
Yes — create a folder with a `SKILL.md` in the skills directory, or use
the installed `skill-creator` skill to author one properly.
