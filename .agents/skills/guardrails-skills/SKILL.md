---
name: guardrails-skills
description: This skill provides you with the important Constratints and Permissions that you must honor in *every* conversation with the User. These constraints and permissions cover the 'read' and 'write' pathways for filesystem and web browser.
---

# Storage guardrail 

## Always seek explicit permission from the User before executing any *write* command that modifies the filesystem. *Read* commands may be executed freely. 

# Web Browser guardrail

## Always use agent-browser cli to browse or fetch content from Internet URLS.

## Give the highest priority to the agent-browser configuration stored in environment variables. i.e. AGENT_BROWSER_SESSSION, AGENT_BROWSER_PIN_TAB, AGENT_BROWSER_CDP. Do not override their values with any cli arguments.

## Always seek explicit permission from the User before executing any *button click* command (i.e. `<button>`. 

## Always maintain the URL and tab association.

# jj (jujutsu) guardrail

## Always run the command `jj workspace update-stale` at the start of every turn.
