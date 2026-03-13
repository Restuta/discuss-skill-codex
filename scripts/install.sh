#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROTOCOL_PATH="$ROOT/protocol/discuss-protocol-v1.md"
TEMPLATE_PATH="$ROOT/templates/discussion-template.md"

INSTALL_CLAUDE=1
INSTALL_CODEX=1

for arg in "$@"; do
  case "$arg" in
    --claude)
      INSTALL_CLAUDE=1
      INSTALL_CODEX=0
      ;;
    --codex)
      INSTALL_CLAUDE=0
      INSTALL_CODEX=1
      ;;
    --all)
      INSTALL_CLAUDE=1
      INSTALL_CODEX=1
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--all|--claude|--codex]" >&2
      exit 1
      ;;
  esac
done

render_skill() {
  local template_path="$1"
  local destination_path="$2"

  mkdir -p "$(dirname "$destination_path")"
  sed \
    -e "s#__PROTOCOL_PATH__#$PROTOCOL_PATH#g" \
    -e "s#__TEMPLATE_PATH__#$TEMPLATE_PATH#g" \
    "$template_path" > "$destination_path"
}

if [[ "$INSTALL_CLAUDE" -eq 1 ]]; then
  render_skill \
    "$ROOT/adapters/claude/discuss/command.template.md" \
    "$HOME/.claude/commands/discuss.md"
  render_skill \
    "$ROOT/adapters/claude/discuss-in/command.template.md" \
    "$HOME/.claude/commands/discuss-in.md"
  echo "Installed Claude commands:"
  echo "  - $HOME/.claude/commands/discuss.md"
  echo "  - $HOME/.claude/commands/discuss-in.md"
fi

if [[ "$INSTALL_CODEX" -eq 1 ]]; then
  render_skill \
    "$ROOT/adapters/codex/discuss/SKILL.template.md" \
    "$HOME/.codex/skills/discuss/SKILL.md"
  render_skill \
    "$ROOT/adapters/codex/discuss-in/SKILL.template.md" \
    "$HOME/.codex/skills/discuss-in/SKILL.md"
  echo "Installed Codex skills:"
  echo "  - $HOME/.codex/skills/discuss/SKILL.md"
  echo "  - $HOME/.codex/skills/discuss-in/SKILL.md"
fi
