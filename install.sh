#!/usr/bin/env bash
# Lean Agent Skills — curated skill installer
# Cuts AI coding agent token usage by installing token-efficient, high-quality
# Agent Skills from official repos into Codex / Claude Code / Antigravity /
# Cursor / Gemini CLI. See README.md.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${CACHE_DIR:-$HOME/.cache/lean-agent-skills}"
RECORD_NAME=".lean-agent-skills.installed.txt"

DEST="."
GLOBAL=0
DRY_RUN=0
FORCE=0
AGENTS="codex,claude,antigravity,copilot"

usage() {
  cat <<'EOF'
Lean Agent Skills installer

Options:
  --dest DIR     base directory for project install (default: current dir)
  --global       install into home directories instead
  --agents LIST  comma list: codex,claude,antigravity,cursor,copilot,gemini
                 (default: codex,claude,antigravity,copilot)
  --dry-run      show what would happen
  --force        overwrite existing AGENTS.md
  -h, --help     this help
EOF
}

log()  { printf '\033[1;36m[lean-skills]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[lean-skills]\033[0m %s\n' "$*" >&2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)    DEST="$2"; shift 2 ;;
    --global)  GLOBAL=1; shift ;;
    --agents)  AGENTS="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --force)   FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) warn "unknown option: $1"; usage; exit 1 ;;
  esac
done

# ---------- curated sources: repo | mode | collection-subdir | skill names ----------
# modes:
#   pick -> copy <subdir>/<name> for each listed name
#   all  -> copy every skill folder (with SKILL.md) under <subdir>
#   auto -> find SKILL.md at repo root, skills/, or any subdir containing one
SOURCES=(
  "anthropics/skills|pick|skills|skill-creator docx pdf pptx xlsx"
  "openai/skills|all|skills/.curated|"
  "multica-ai/andrej-karpathy-skills|auto||"
  "hqhq1025/skill-optimizer|auto||"
)

# joke/irrelevant skills excluded by default
EXCLUDES=(hatch-pet yeet)

clone_source() {
  local repo="$1" dir="$CACHE_DIR/$repo"
  if [[ -d "$dir/.git" ]]; then
    if (( ! DRY_RUN )); then
      git -C "$dir" pull --ff-only -q || warn "pull failed for $repo (using cached copy)"
    fi
  elif (( ! DRY_RUN )); then
    log "cloning $repo ..." >&2
    mkdir -p "$(dirname "$dir")"
    git clone -q --depth 1 "https://github.com/$repo.git" "$dir"
  fi
  echo "$dir"
}

# emit directories containing a SKILL.md for one source
collect_skills() {
  local repo="$1" mode="$2" subdir="$3" names="$4"
  local root; root="$(clone_source "$repo")"
  case "$mode" in
    pick)
      local n d
      for n in $names; do
        d="$root/$subdir/$n"
        if [[ -f "$d/SKILL.md" ]]; then echo "$d"
        else warn "skip $repo:$subdir/$n (SKILL.md not found upstream)"; fi
      done ;;
    all)
      local d
      for d in "$root/$subdir"/*/; do
        [[ -f "${d}SKILL.md" ]] && echo "${d%/}"
      done ;;
    auto)
      if [[ -f "$root/SKILL.md" ]]; then echo "$root"; return; fi
      local d
      for d in "$root"/*/; do
        [[ -f "${d}SKILL.md" ]] && echo "${d%/}"
      done
      if [[ -d "$root/skills" ]]; then
        [[ -f "$root/skills/SKILL.md" ]] && echo "$root/skills"
        for d in "$root/skills"/*/; do
          [[ -f "${d}SKILL.md" ]] && echo "${d%/}"
        done
      fi ;;
  esac
  return 0
}

# where agent X reads skills from
agent_dir() {
  local agent="$1"
  case "$agent" in
    codex|antigravity)
      (( GLOBAL )) && echo "$HOME/.agents/skills" || echo "$DEST/.agents/skills" ;;
    claude)
      (( GLOBAL )) && echo "$HOME/.claude/skills" || echo "$DEST/.claude/skills" ;;
    cursor)
      (( GLOBAL )) && echo "$HOME/.cursor/skills" || echo "$DEST/.cursor/skills" ;;
    copilot)
      (( GLOBAL )) && echo "$HOME/.copilot/skills" || echo "$DEST/.github/skills" ;;
    gemini)
      (( GLOBAL )) && echo "$HOME/.gemini/skills" || echo "$DEST/.gemini/skills" ;;
    *) warn "unknown agent: $agent"; return 1 ;;
  esac
}

INSTALLED=()

install_skill() {
  local src="$1" target="$2"
  local name; name="$(basename "$src")"
  local dest="$target/$name"
  if (( DRY_RUN )); then log "(dry) $name -> $dest"; return; fi
  mkdir -p "$target"
  rm -rf "$dest"
  cp -R "$src" "$dest"
  INSTALLED+=("$dest")
  log "installed $name -> $dest"
}

write_agents_md() {
  local base="$DEST"; (( GLOBAL )) && base="$HOME"
  local f="$base/AGENTS.md"
  if [[ -f "$f" && $FORCE -eq 0 ]]; then
    log "AGENTS.md exists at $f — keeping it (use --force to overwrite)"
    return
  fi
  if (( DRY_RUN )); then log "(dry) would write $f"; return; fi
  if [[ -f "$SCRIPT_DIR/templates/AGENTS.md" ]]; then
    cp "$SCRIPT_DIR/templates/AGENTS.md" "$f"
  else
    cat > "$f" <<'EOF'
# AGENTS.md — token-frugal working rules
- New task = new session; compact/summarize when context grows heavy.
- Read only the files you need; prefer search/grep over reading whole files.
- Make minimal, surgical changes; plan first for anything non-trivial.
- Run targeted tests, not the whole suite, unless asked.
- If an installed skill covers the task, use it and follow its scripts.
EOF
  fi
  INSTALLED+=("AGENTS_MD:$f")
  log "wrote $f"
}

# ---------- main ----------
log "Lean Agent Skills | dest: $( (( GLOBAL )) && echo 'GLOBAL (~)' || readlink -f "$DEST" ) | agents: $AGENTS"
IFS=',' read -ra AGENT_LIST <<< "$AGENTS"

CANON="" ; CLAUDE_DIR=""
for a in "${AGENT_LIST[@]}"; do
  case "$a" in
    codex|antigravity) [[ -z "$CANON" ]] && CANON="$(agent_dir "$a")" ;;
    claude)            CLAUDE_DIR="$(agent_dir claude)" ;;
  esac
done
CLAUDE_LINKED=0
[[ -n "$CANON" && -n "$CLAUDE_DIR" && "$CANON" != "$CLAUDE_DIR" ]] && CLAUDE_LINKED=1

TARGETS=()
for a in "${AGENT_LIST[@]}"; do
  [[ "$a" == "claude" && $CLAUDE_LINKED -eq 1 ]] && continue
  t="$(agent_dir "$a")" || continue
  dup=0
  for x in "${TARGETS[@]:-}"; do [[ "$x" == "$t" ]] && dup=1; done
  (( dup )) || TARGETS+=("$t")
done

SKILL_SET=()
declare -A SEEN=()

for source in "${SOURCES[@]}"; do
  IFS='|' read -r repo mode subdir names <<< "$source"
  log "source: $repo ($mode)"
  while IFS= read -r skill_dir; do
    [[ -z "$skill_dir" ]] && continue
    name="$(basename "$skill_dir")"
    for ex in "${EXCLUDES[@]}"; do
      [[ "$name" == "$ex" ]] && { warn "excluding $name"; continue 2; }
    done
    [[ -n "${SEEN[$name]:-}" ]] && { warn "skip duplicate $name"; continue; }
    SEEN[$name]=1
    SKILL_SET+=("$skill_dir")
    for t in "${TARGETS[@]}"; do
      install_skill "$skill_dir" "$t"
    done
  done < <(collect_skills "$repo" "$mode" "$subdir" "$names")
done

if (( CLAUDE_LINKED )); then
  if (( DRY_RUN )); then
    log "(dry) symlink $CLAUDE_DIR -> ../.agents/skills"
  else
    rm -rf "$CLAUDE_DIR"
    mkdir -p "$(dirname "$CLAUDE_DIR")"
    ln -s "../.agents/skills" "$CLAUDE_DIR"
    INSTALLED+=("SYMLINK:$CLAUDE_DIR")
    log "symlinked $CLAUDE_DIR -> ../.agents/skills"
  fi
fi

write_agents_md

if (( DRY_RUN )); then
  log "dry run complete — nothing was written."
else
  base="$DEST"; (( GLOBAL )) && base="$HOME"
  printf '%s\n' "${INSTALLED[@]}" > "$base/$RECORD_NAME"
  log "record saved to $base/$RECORD_NAME (used by uninstall.sh)"
  log "done: ${#SKILL_SET[@]} skills installed. Restart your agent or start a new turn."
fi
