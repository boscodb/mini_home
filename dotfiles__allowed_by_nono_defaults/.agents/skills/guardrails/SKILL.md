---
name: guardrails
description: This skill provides you with the important Constraints and Permissions that you must honor in *every* conversation with the User. These constraints and permissions cover the 'read' and 'write' pathways for filesystem and web browser.
---

# TMPDIR (/tmp), NPM_CONFIG_CACHE (~/.npm)

## These folders are constrained by sandbox policies. Use their workspace-local variants whenever possible. If you are still blocked then let me know so I can modify the sandbox policies suitably, for your work

# Storage guardrail

## Always seek explicit permission from the User before executing any *write* command that modifies the filesystem. *Read* commands may be executed freely

# jj (jujutsu) guardrail

## Always run the command `jj workspace update-stale` at the start of every turn. Do not ask explicit permission in this particular case, even though it is potentially a filesystem modifying operation
