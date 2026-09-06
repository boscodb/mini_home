#!/usr/bin/env bash
set -euo pipefail

: "${AGENT_NAME:?set AGENT_NAME to rocky, pi, codex, claude, or agy}"

project_name="dipsdime"
case "$AGENT_NAME" in
rocky) # Rocky is operated only in the jj default workspace.
  parent_workspace="."
  ;;
*)
  parent_workspace=".."
  ;;
esac

project_name__jj_workspaces__allow=(
  "$parent_workspace/$project_name/.jj"
  "$parent_workspace/$project_name/.git"
)

AGENT_NAME__NONO_PROFILE="$AGENT_NAME-local"

case "$AGENT_NAME" in
rocky)
  AGENT_NAME__CDP_PORT=9222
  AGENT_NAME__SKIP_PERMISSIONS=()
  AGENT_NAME__TMUX_TARGET=':0.3'

  AGENT_NAME="pi"                     # Because, rocky doesn't yet exist as a binary, and is represented by pi.
  ;;
pi)
  AGENT_NAME__CDP_PORT=9223
  AGENT_NAME__SKIP_PERMISSIONS=()
  AGENT_NAME__TMUX_TARGET=':coders.0'
  ;;
codex)
  AGENT_NAME__CDP_PORT=9224
  AGENT_NAME__SKIP_PERMISSIONS=(--dangerously-bypass-approvals-and-sandbox)
  AGENT_NAME__TMUX_TARGET=':coders.1'
  ;;
claude)
  AGENT_NAME__CDP_PORT=9225
  AGENT_NAME__SKIP_PERMISSIONS=(--dangerously-skip-permissions)
  AGENT_NAME__TMUX_TARGET=':coders.2'
  ;;
agy)
  AGENT_NAME__CDP_PORT=9226
  AGENT_NAME__SKIP_PERMISSIONS=(--mode=accept-edits --dangerously-skip-permissions)
  AGENT_NAME__TMUX_TARGET=':coders.3'
  ;;
*)
  printf 'Unsupported AGENT_NAME: %s\n' "$AGENT_NAME" >&2
  exit 2
  ;;
esac

AGENT_BROWSER_SESSION="$(agent-browser session id --scope worktree --prefix "$AGENT_NAME")"

AGENT_NAME__INVOCATION="nono run \
  --profile $AGENT_NAME__NONO_PROFILE \
  --allow-cwd \
  --allow ${project_name__jj_workspaces__allow[0]} \
  --allow ${project_name__jj_workspaces__allow[1]} \
  -- env \
  AGENT_BROWSER_SESSION=$AGENT_BROWSER_SESSION \
  AGENT_BROWSER_PIN_TAB=1 \
  AGENT_BROWSER_CDP=$AGENT_NAME__CDP_PORT \
  AGENT_BROWSER_STREAM_PORT=$AGENT_NAME__CDP_PORT \
  $AGENT_NAME ${AGENT_NAME__SKIP_PERMISSIONS[*]}"

printf 'Launch parameters:\n'
printf '  project_name: %s\n' "$project_name"
printf '  project_name__jj_workspaces__allow: %s %s\n' "${project_name__jj_workspaces__allow[@]}"
printf '  AGENT_NAME: %s\n' "$AGENT_NAME"
printf '  AGENT_NAME__NONO_PROFILE: %s\n' "$AGENT_NAME__NONO_PROFILE"
printf '  AGENT_NAME__CDP_PORT: %s\n' "$AGENT_NAME__CDP_PORT"
printf '  AGENT_NAME__TMUX_TARGET: %s\n' "$AGENT_NAME__TMUX_TARGET"
printf '  AGENT_NAME__SKIP_PERMISSIONS:'
printf ' %s' "${AGENT_NAME__SKIP_PERMISSIONS[@]}"
printf '\n'
printf '  AGENT_NAME__INVOCATION: %s\n' "$AGENT_NAME__INVOCATION"

if [[ "$(tmux display-message -p -t "$AGENT_NAME__TMUX_TARGET" '#{pane_current_command}')" != "bash" ]]; then
  printf '%s is already active in %s\n' "$AGENT_NAME" "$AGENT_NAME__TMUX_TARGET" >&2
  exit 1
fi

tmux send-keys -t "$AGENT_NAME__TMUX_TARGET" "$AGENT_NAME__INVOCATION" Enter
