# Contributing

Thanks for helping keep Lean Agent Skills lean.

## Propose a skill

Open a PR/issue with:

1. **Source** — upstream repo URL and skill path.
2. **Why it saves tokens** — which mechanism it uses (progressive
   disclosure, scripting, fewer turns).
3. **Quality evidence** — maintained upstream, real-world usage, tests.

### Quality bar

- Model-agnostic instructions (works under Claude, GPT and Gemini).
- Description field states when to use **and when not to** use the skill.
- No bulk/AI-slop generation; real engineering-team or proven community work.
- Lean body; heavy reference material belongs in linked files (loaded on demand).
- License compatible with redistribution instructions (we link/copy per
  upstream license; note it in `manifest.yaml`).

## Report

- Broken upstream links or moved skill paths.
- Installer bugs (`install.sh` / `uninstall.sh`) — include agent list and flags.
- README/SEO improvements always welcome.

## Style

- README stays keyword-natural, no stuffing; headings answer real queries.
- Keep `templates/AGENTS.md` under ~25 lines — it is loaded every turn.

## 📣 Publishing checklist (maintainers)

Repo settings on GitHub:

- **Description:** "⚡ Cut AI coding agent token usage without losing quality — curated Agent Skills for Claude Code, Codex, Antigravity, Cursor, Copilot & more. One-command install."
- **Topics (tags):** `agent-skills` `claude-code` `codex` `openai-codex` `antigravity` `cursor` `gemini-cli` `github-copilot` `ai-coding-agent` `ai-agents` `token-optimization` `llm-cost` `prompt-caching` `context-engineering` `awesome-list` `developer-tools` `skills` `windsurf` `opencode` `productivity`
- **Website:** https://agentskills.io
- Social preview image: dark background, ⚡ + "Lean Agent Skills" + tagline.
- Discussions ON (community = stars = SEO).
