#!/usr/bin/env bash
set -euo pipefail

: "${AGENT_NAME:?set AGENT_NAME to rocky, pi, codex, claude, or agy}"

case "$AGENT_NAME" in
rocky)
  AGENT_NAME__CDP_PORT=9222
  AGENT_NAME__TMUX_TARGET='commons:0.4'
  ;;
pi)
  AGENT_NAME__CDP_PORT=9223
  AGENT_NAME__TMUX_TARGET='commons:browsers.0'
  ;;
codex)
  AGENT_NAME__CDP_PORT=9224
  AGENT_NAME__TMUX_TARGET='commons:browsers.1'
  ;;
claude)
  AGENT_NAME__CDP_PORT=9225
  AGENT_NAME__TMUX_TARGET='commons:browsers.2'
  ;;
agy)
  AGENT_NAME__CDP_PORT=9226
  AGENT_NAME__TMUX_TARGET='commons:browsers.3'
  ;;
*)
  printf 'Unsupported AGENT_NAME: %s\n' "$AGENT_NAME" >&2
  exit 2
  ;;
esac

mkdir -p $HOME/data/zr/chrome_debug_profiles/
AGENT_NAME__USER_DATA_DIR="$HOME/data/zr/chrome_debug_profiles/${AGENT_NAME}__chrome-debug-profile"

AGENT_NAME__INVOCATION="google-chrome \
  --no-first-run \
  --no-default-browser-check \
  --window-name=\"${AGENT_NAME^} | CDP $AGENT_NAME__CDP_PORT\" \
  --remote-debugging-port=$AGENT_NAME__CDP_PORT \
  --user-data-dir=$AGENT_NAME__USER_DATA_DIR"

printf 'Launch parameters:\n'
printf '  AGENT_NAME: %s\n' "$AGENT_NAME"
printf '  AGENT_NAME__CDP_PORT: %s\n' "$AGENT_NAME__CDP_PORT"
printf '  AGENT_NAME__TMUX_TARGET: %s\n' "$AGENT_NAME__TMUX_TARGET"
printf '  AGENT_NAME__USER_DATA_DIR: %s\n' "$AGENT_NAME__USER_DATA_DIR"
printf '  AGENT_NAME__INVOCATION: %s\n' "$AGENT_NAME__INVOCATION"

if [[ "$(tmux display-message -p -t "$AGENT_NAME__TMUX_TARGET" '#{pane_current_command}')" != "bash" ]]; then
  printf '%s Chrome is already active in %s\n' "$AGENT_NAME" "$AGENT_NAME__TMUX_TARGET" >&2
  exit 1
fi

tmux send-keys -t "$AGENT_NAME__TMUX_TARGET" "$AGENT_NAME__INVOCATION" Enter
