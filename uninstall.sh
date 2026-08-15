#!/usr/bin/env bash
# Lean Agent Skills — uninstaller
# Removes exactly what install.sh recorded in .lean-agent-skills.installed.txt
set -euo pipefail

RECORD_NAME=".lean-agent-skills.installed.txt"
DEST="."
GLOBAL=0

log()  { printf '\033[1;36m[lean-skills]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[lean-skills]\033[0m %s\n' "$*" >&2; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest)   DEST="$2"; shift 2 ;;
    --global) GLOBAL=1; shift ;;
    -h|--help) echo "usage: uninstall.sh [--dest DIR | --global]"; exit 0 ;;
    *) warn "unknown option: $1"; exit 1 ;;
  esac
done

base="$DEST"; (( GLOBAL )) && base="$HOME"
record="$base/$RECORD_NAME"

if [[ ! -f "$record" ]]; then
  warn "no install record at $record — nothing to do."
  exit 0
fi

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  case "$line" in
    SYMLINK:*)
      p="${line#SYMLINK:}"
      if [[ -L "$p" ]]; then rm "$p"; log "removed symlink $p"; fi ;;
    AGENTS_MD:*)
      p="${line#AGENTS_MD:}"
      log "keeping $p (review manually — you may have edited it)" ;;
    *)
      if [[ -e "$line" ]]; then rm -rf "$line"; log "removed $line"; fi ;;
  esac
done < "$record"

rm -f "$record"

# tidy up empty parent dirs we may have left behind
for d in "$base/.agents/skills" "$base/.agents" "$base/.claude" \
         "$base/.cursor/skills" "$base/.cursor" "$base/.gemini/skills" "$base/.gemini" \
         "$base/.github/skills" "$base/.copilot/skills" "$base/.copilot"; do
  [[ -d "$d" ]] && find "$d" -maxdepth 0 -empty -exec rmdir {} \; 2>/dev/null || true
done

log "uninstall complete."
