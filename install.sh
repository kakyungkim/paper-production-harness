#!/usr/bin/env bash
# Install this harness into a team repo (project scope).
#
# Usage:  ./install.sh /path/to/your/team-repo
#
# Copies agents and the orchestrator Skill into <repo>/.claude/, drops the
# routing block and lab map where they belong, then lists every <FILL: …>
# placeholder you still have to complete. Nothing is written to ~/.claude/ —
# this harness is meant to be project-scoped so contexts do not bleed between
# projects.
set -euo pipefail

TARGET="${1:-}"
if [[ -z "$TARGET" ]]; then
  echo "usage: $0 /path/to/team-repo" >&2
  exit 2
fi
if [[ ! -d "$TARGET" ]]; then
  echo "not a directory: $TARGET" >&2
  exit 2
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS="$TARGET/.claude/agents"
SKILLS="$TARGET/.claude/skills/paper-production-orchestrator"
DOCS="$TARGET/docs"

mkdir -p "$AGENTS" "$SKILLS" "$DOCS"

# Reusable agents: copy as-is.
for f in "$HERE"/agents/*.md; do
  base="$(basename "$f")"
  # Templates lose the .template suffix on install; they need filling after.
  dest="$AGENTS/${base/.template.md/.md}"
  cp "$f" "$dest"
  echo "agent    -> ${dest#$TARGET/}"
done

# Orchestrator Skill.
cp "$HERE/skills/paper-production-orchestrator/SKILL.template.md" "$SKILLS/SKILL.md"
echo "skill    -> ${SKILLS#$TARGET/}/SKILL.md"

# Lab map.
cp "$HERE/templates/HARNESS.template.md" "$DOCS/HARNESS.md"
echo "lab map  -> ${DOCS#$TARGET/}/HARNESS.md"

# Routing block: never clobber an existing CLAUDE.md, just stage it.
ROUTING="$TARGET/.claude/CLAUDE-routing.to-paste.md"
cp "$HERE/templates/CLAUDE-routing.template.md" "$ROUTING"
echo "routing  -> ${ROUTING#$TARGET/}  (paste this block into your CLAUDE.md, then delete)"

echo
echo "===================================================================="
echo "Remaining <FILL: …> placeholders — complete these in the team repo:"
echo "===================================================================="
if grep -rn "<FILL:\|<DOMAIN_ANALYSIS_AGENT>\|<DOMAIN_VERIFIER_AGENT>" \
     "$AGENTS" "$SKILLS" "$DOCS/HARNESS.md" "$ROUTING" 2>/dev/null; then
  echo
  echo "Fill every line above before running the orchestrator."
else
  echo "(none found — unexpected; check the copy step)"
fi
