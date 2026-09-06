#!/usr/bin/env bash
set -euo pipefail

status=0

launch_chrome() {
  local agent_name=$1

  if ! AGENT_NAME="$agent_name" ./scripts/agent_chrome__launcher.sh; then
    printf 'Warning: failed to launch %s Chrome; continuing.\n' "$agent_name" >&2
    status=1
  fi
  printf -- '---\n'
}

launch_nono() {
  local agent_name=$1

  if ! AGENT_NAME="$agent_name" ./scripts/agent_nono__launcher.sh; then
    printf 'Warning: failed to launch %s Nono; continuing.\n' "$agent_name" >&2
    status=1
  fi
  printf -- '---\n'
}

launch_nono rocky
launch_nono pi
launch_nono codex
launch_nono claude
launch_nono agy

launch_chrome rocky
launch_chrome pi
launch_chrome codex
launch_chrome claude
launch_chrome agy

exit "$status"
