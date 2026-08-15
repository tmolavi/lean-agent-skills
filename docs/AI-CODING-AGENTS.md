# 🤖 AI Coding Agents — Skills Support & Paths

Every agent below understands the open **Agent Skills** standard
([agentskills.io](https://agentskills.io)): a folder containing a `SKILL.md`
(YAML frontmatter: `name`, `description` + markdown instructions, optional
`scripts/` and reference files).

## Agents with native skills support

| Agent | Vendor | Project path | Global path | Official docs |
|---|---|---|---|---|
| Claude Code | Anthropic | `.claude/skills/` | `~/.claude/skills/` | [code.claude.com/docs/en/skills](https://code.claude.com/docs/en/skills) |
| Codex CLI/IDE | OpenAI | `.agents/skills/` | `~/.agents/skills/` | [developers.openai.com/codex/skills](https://developers.openai.com/codex/skills) |
| Antigravity | Google | `.agents/skills/` | `~/.gemini/antigravity/skills/` | [antigravity.google](https://antigravity.google) |
| Cursor | Anysphere | `.cursor/skills/` | `~/.cursor/skills/` | [cursor.com/docs](https://cursor.com/docs) |
| GitHub Copilot | GitHub/Microsoft | `.github/skills/` | `~/.copilot/skills/` | [docs.github.com](https://docs.github.com) |
| Gemini CLI | Google | `.gemini/skills/` | `~/.gemini/skills/` | [geminicli.com](https://geminicli.com) |
| Windsurf | Codeium | `.windsurf/skills/` | `~/.codeium/windsurf/skills/` | Windsurf docs |
| OpenCode | community | `.opencode/skills/` | `~/.config/opencode/skills/` | opencode.ai |

## Other standard-compliant clients

The agentskills.io showcase lists ~40 clients, including:
**Zed · Kiro (AWS) · JetBrains Junie · Amp (Sourcegraph) · Goose (Block) ·
Roo Code · Cline · Aider · VS Code (via Copilot) · ChatGPT desktop (Work
mode)** — point any of them at a skills folder and the same `SKILL.md`
files work unmodified, as long as instructions are model-agnostic.

## How activation works

- **Implicit:** the agent compares your prompt against each skill's
  `description` field and loads the matching one. Write descriptions with
  clear scope ("use when X; do NOT use for Y").
- **Explicit:** mention the skill — `$skill-name` or `/skills` in Codex,
  skill mention in Claude Code, semantic triggers in Antigravity.

## Portability rules (keep quality across models)

1. Keep instructions **model-agnostic** — a skill may run under Claude, GPT
   or Gemini depending on the host.
2. Don't rely on Claude-only frontmatter semantics (e.g. `allowed-tools`);
   let the host decide execution.
3. Test the description trigger in at least two runtimes.
4. Document script dependencies in the `SKILL.md`.
