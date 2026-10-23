# jj (jujutsu) guardrail

## Always run the command `jj workspace update-stale` at the start of every turn. Do not ask explicit permission in this particular case, even though it is potentially a filesystem modifying operation

# Web Browser guardrail

## Always use agent-browser cli to browse or fetch content from Internet URLS

## Give the highest priority to the agent-browser configuration stored in environment variables. i.e. AGENT_BROWSER_SESSION, AGENT_BROWSER_PIN_TAB, AGENT_BROWSER_CDP. Do not override their values with any cli arguments

## Always seek explicit permission from the User before executing any *button click* command (i.e. `<button>`

## Always maintain the URL and tab association
