---
name: get-bdd
description: >-
  Converts plain-English requirements (with optional UI screens, block diagrams, or system diagrams) into a structured Behavior-Driven (Given-When-Then) specification with CRUD categorization, always-populated Distilled When tags, observable UI/system Then outcomes, and a DMC (Duplicate/Missing/Contradictory) audit, writing directly to Google Sheets (via MCP) or outputting CSV. Use when the user invokes /get-bdd or asks to translate English requirements into the Behavior table format.
---

# English Requirement to BDD Specification (`get-bdd`)

Transform any plain-English requirement, user story, flow description, or visual artifact (UI mockup, block diagram, system diagram) into a structured **Behavior** table using the Arrange–Act–Assert (`Given`–`When`–`Then`) schema. Write directly into the configured Google Sheet when the `google-sheets` MCP is active, or output RFC 4180 CSV as a fallback.

## Input Handling & Visual Context

- When invoked via `/get-bdd <english-message>` (or natural language), parse the requirement into atomic, sequential user/system behaviors.
- Break multi-step flows into one behavior row per distinct action or state transition.
- **Visual & Diagram Context (UI Screens / Block / System Diagrams):** When the user also attaches or references a UI screen, wireframe, flowchart, block diagram, or system diagram:
  - **UI Screens / Wireframes:** Ground `Given` in exact visible screen/modal titles (`UI - <Screen Name>`), use exact visible button/field/tab/label names in `When` and `Distilled When`, and capture visible enabled/disabled states, inline errors, modals, and navigation targets in `Then`.
  - **Block / System / Flow Diagrams:** Map modules, services, or components to `Given`; map transitions, arrows, API calls, and decision branches to `When` + `Distilled When` (`ENDPOINT:`, `SYSTEM:`, `EVENT:`, `CHECK:`); and map observable outputs across every branch (success, failure, timeout, fallback) to `Then`.
- If the requirement omits a module/project prefix for `Behavior Id`, inspect the target sheet tab's existing rows first; if empty or in CSV-only mode, derive a short uppercase prefix from context (e.g., `AUTH-LOGIN-01`, `CHECKOUT-CART-01`, `APP-SETUP-01`).

## Google Sheets Integration (Primary Mode)

- **Default Spreadsheet ID:** `1_1lIERByBIHY1hfjmTh6Qo5sVypVaKLcgtO83sL63Rw` (reference tab `gid=346732514`; users may also pass a different Spreadsheet URL/ID).
- **Multi-Project Tab Selection (Mandatory Before Writing):**
  1. Because this spreadsheet contains multiple project tabs, **check whether the user already specified a tab/sheet name** in their prompt (or earlier in the active conversation).
  2. If no tab/sheet is set yet and `google-sheets` MCP tools are available, **list the spreadsheet's tabs first and ask the user which tab/sheet to target** (or whether to create/name one) **before generating/writing rows into the sheet**.
- **Read Existing Sheet Format First (and Template for Empty/New Tabs):**
  1. Inspect the selected tab's header rows and last populated rows before writing.
  2. **Template Rule (`000{Serial_Id}__Template`):** For `BDD-Master Sheet` (`1_1lIERByBIHY1hfjmTh6Qo5sVypVaKLcgtO83sL63Rw`), **always refer to `000{Serial_Id}__Template` (`sheetId: 1998191516`) as the template for all project headers**. If the target project tab is empty or newly created:
     - Copy `A1:K9` (headers including Col D `Distilled Given`, Col I `Service Layer Repository Issue`, Col J `Presentation Layer Repository Issue`, Col K `QA Approval`, merges `A7:K7`, `A8:A9`, `C8:H8`, `K8:K9`, and styling) from `000{Serial_Id}__Template` (`sheetId: 1998191516`).
     - Apply the template column widths across Columns A–K: `[149, 176, 217, 176, 71, 278, 176, 176, 181, 192, 176]` px.
     - Populate `B3` (`Project Name`), `E3` (`Project Code`), and `E4` (`Module Code`), and clear template placeholders in `B4` (Github Link) and `B5` (Current Production SHA) unless the user provided them.
     - Start behavior rows at Row 10 (`A10:H...`), using the template's Column B (`Behavior Id`) formula: `=JOIN("_",$E$3:$E$4,TEXT(ROUND(A<row>, 2), "0000"))` (which generates `<ProjectCode>_<ModuleCode>_0001`, etc.), and populate Column D (`Distilled Given`) with the prerequisite `Behavior Id`(s) or `NONE`.
  3. If the target tab is **already populated**, detect its column layout (whether it uses the updated `A1:K9` template with `Distilled Given` in Col D and `$E$3:$E$4`, or a legacy tab without `Distilled Given` using `$D$3:$D$4`) and match its conventions:
     - Continue `Sr.No.` sequentially from the last populated row (`last + 1`).
     - Continue the tab's `Behavior Id` formula (`=JOIN(...)`) or existing static prefix/zero-padding (e.g., `EB-OFFLINE-06` → `EB-OFFLINE-07`).
     - Match how `Given` is formatted in that tab (whether repeated on every row or left blank on consecutive rows sharing the same `Given`), and populate `Distilled Given` with prerequisite `Behavior Id`(s) if the tab includes that column.
- **Write in Native Sheet Cell Format:**
  1. Prefer `google-sheets` `batch_update` (`copyPaste`, `updateDimensionProperties`, `updateCells` with `wrapStrategy: "WRAP"`) so formatting, formulas, and multi-line cells are written cleanly.
  2. Write native cell strings/numbers/formulas (do **not** wrap cells in CSV escape quotes).
  3. Use literal newline characters (`\n`) inside `Then` cells for multiple observable effects (e.g., `SCREEN: Loader\nBUTTON: Get Start Disabled`).
  4. Append rows after the last populated row in the chosen tab, then summarize the written range and rows to the user.
- **CSV Fallback Mode:**
  - If `google-sheets` MCP tools are **not** available in the current session (or the user explicitly asks for CSV only), output the RFC 4180 CSV block below and note that the Google Sheets MCP is not connected.

## Output Format (CSV Fallback — RFC 4180)

Always output the result inside a single `csv` fenced code block with this exact header row:

```csv
Sr.No.,Behavior Id,Given,Distilled Given,CRUD,When,Distilled When,Then
```

### CSV Rules
1. **Quote any field** containing commas, double quotes (escaped as `""`), or newlines (including multi-ID `Distilled Given` and multi-line `Then`).
2. **Repeat `Given`** on every row where it applies (do not leave merged cells blank in CSV).
3. **Multi-line `Then` values** (when one action produces multiple observable effects) must be enclosed in double quotes with each effect on its own line.
4. **No prose paragraphs or verbs in `Then`:** In `Distilled When` and `Then`, use terse `TAG: description` lines only; **avoid all verbs in `Then`** (express outcomes strictly as nouns, UI targets, values, or state adjectives such as `Enabled`, `Disabled`, `Visible`, `Hidden`, `Active`, `Empty`, `Unchanged`).

---

## Column Specification

| Column | Purpose | Format & Rules |
| :--- | :--- | :--- |
| `Sr.No.` | Sequential row index | `1`, `2`, `3`, ... |
| `Behavior Id` | Unique behavior identifier | `<PROJECT>-<MODULE>-<NN>` (zero-padded 2+ digits, e.g., `EB-OFFLINE-01`). |
| `Given` | Initial System State / Module (*Arrange*) | Module, screen, or prerequisite condition (e.g., `SETUP FILE RECEIVED`, `UI - Get Ready Page`). |
| `Distilled Given` | Prerequisite Behavior Id(s) | Exact `Behavior Id`(s) that must precede or trigger the current behavior (e.g., `EB-OFFLINE-01`, or `EB-OFFLINE-01, EB-OFFLINE-02`); use `NONE` when there is no prior behavior prerequisite. |
| `CRUD` | Data/system operation of `When` | Single letter: `C`, `R`, `U`, or `D` (see CRUD Rules below). |
| `When` | Process: UI interaction, endpoint call, or system trigger (*Act*) | Concise active sentence describing what happens (e.g., `User clicks Get Started button`). |
| `Distilled When` | Standardized action tag (**always populated**) | `UPPERCASE_TAG: concise description` (e.g., `BUTTON: Click Get Started`). Never leave blank. |
| `Then` | Observable UI / item / data outcome (*Assert*) | One or more `UPPERCASE_TAG: <noun / target / state / value>` lines **without verbs** (no action or passive verbs like `displayed`, `shown`, `created`, `updated`, `remains`). |

---

## CRUD Categorization Rules (for `When`)

Classify the `When` action strictly by its effect on the system/files/data:

- **`C` (Create):** Any **new write**, **file addition or creation on the system**, new entity/record creation, upload of a new file, installation/initialization writing new artifacts, or `POST` creating a resource.
- **`R` (Read):** Reading, viewing, fetching, searching, filtering, navigating without writing, or running non-mutating system/validation checks (`GET`).
- **`U` (Update):** Modifying existing records, editing fields, toggling persisted settings/flags, replacing/patching an existing file, or changing an existing item's state (`PUT`/`PATCH`).
- **`D` (Delete):** Deleting, removing, uninstalling, clearing, or cancelling persisted records/files/sessions (`DELETE`).

---

## Standardized Tag Taxonomy

Always prefer these standardized `UPPER_SNAKE_CASE` prefixes. Introduce a new `UPPER_SNAKE_CASE:` tag only if none of the standard tags below fit.

### `Distilled When` Tags (Always Required)

| Category | Standard Tags | Example |
| :--- | :--- | :--- |
| **UI Click / Navigation** | `CLICK:`, `DOUBLE_CLICK:`, `BUTTON:`, `NAVIGATE:`, `HOVER:`, `SCROLL:` | `DOUBLE_CLICK: Setup file`, `BUTTON: Click Get Started` |
| **UI Input / Form** | `INPUT:`, `SELECT:`, `TOGGLE:`, `SUBMIT:`, `UPLOAD:`, `DOWNLOAD:`, `KEYPRESS:` | `INPUT: Email address`, `SUBMIT: Login form` |
| **API / Endpoint** | `ENDPOINT:` | `ENDPOINT: POST /api/v1/users` |
| **System / Background** | `SYSTEM:`, `CHECK:`, `EVENT:`, `TIMER:` | `CHECK: System requirements`, `SYSTEM: Verify dependencies` |

### `Then` Tags (Observable Effects — Strictly Verb-Free)

Never use verbs inside `Then` descriptions (e.g., avoid `displayed`, `shown`, `created`, `updated`, `opened`, `remains`). State only the UI/data target and its resulting state/value:

| Category | Standard Tags | Example |
| :--- | :--- | :--- |
| **Screen / Window** | `OPEN:`, `CLOSE:`, `SCREEN:`, `MODAL:`, `REDIRECT:` | `OPEN: Installer --> Get Ready page`, `SCREEN: Loader` |
| **UI Controls & Labels** | `BUTTON:`, `FIELD:`, `LABEL:`, `TEXT:`, `LIST:`, `TABLE:` | `BUTTON: Get Start Disabled`, `LABEL: Status Active` |
| **Notifications / Errors** | `TOAST:`, `BANNER:`, `ERROR_MSG:` | `ERROR_MSG: Invalid credentials` |
| **Data / Files / State** | `STATE:`, `DATA:`, `FILE:`, `API_RESPONSE:`, `NO_ACTION:` | `FILE: config.json present`, `NO_ACTION: Form unchanged` |

---

## DMC Quality Check (Mandatory Before Writing / Output)

Before writing rows to Google Sheets (or emitting CSV), audit all candidate behaviors against **existing rows in the target sheet tab**, **each other**, and **any attached UI screen or diagram**:

1. **D — Duplicate Check (Prevent Redundant Rows):**
   - Compare each candidate row's `(Given, When / Distilled When, Then)` semantically against existing behaviors in the target tab and earlier rows in the same batch.
   - **Action:** **Do not write or emit duplicate rows.** Skip any duplicate and report the existing `Behavior Id`(s) that already cover it.
2. **M — Missing Check (Flag Coverage Gaps):**
   - Check for uncovered transitions, edge cases, or branches implied by the requirement, visible UI controls, or diagram arrows (e.g., invalid/empty input, error/retry/timeout handling, disabled button states, cancel/back paths, unauthorized/unregistered states), as well as any missing prerequisite `Behavior Id` referenced in `Distilled Given`.
   - **Action:** **Flag missing scenarios** clearly in the response so the user can confirm or expand coverage.
3. **C — Contradictory Check (Flag Spec Conflicts):**
   - Check for conflicts between new behaviors and existing sheet rows, within the requirement itself, or between text and attached UI/diagrams (e.g., conflicting landing screens like `Dashboard Page` vs. `Welcome to App Screen`, conflicting retry limits, mismatched button states, or conflicting `CRUD` effects).
   - **Action:** **Flag contradictions explicitly** (citing the conflicting `Behavior Id`(s) or diagram element) and ask the user whether to update/replace the existing row(s) before writing conflicting behaviors.

Always include a brief **DMC Check** summary (`Duplicates Skipped`, `Missing Flagged`, `Contradictions Flagged`) in your response.

---

## Reference Example

See [examples/sample-bdd.md](./examples/sample-bdd.md) for a full worked conversion from English requirements to CSV.

## Pre-Output Verification Checklist

Before writing to Google Sheets or returning CSV, verify:
1. Column order matches `Sr.No.`, `Behavior Id`, `Given`, `Distilled Given`, `CRUD`, `When`, `Distilled When`, `Then` (or the target sheet tab's header layout).
2. Target tab/sheet was confirmed with the user before writing when using Google Sheets.
3. Visual/diagram context (if attached) is reflected accurately in screen names, labels, components, and branch outcomes.
4. DMC check completed: duplicates excluded, missing gaps (including dangling `Distilled Given` prerequisites) flagged, and contradictions flagged before writing conflicting rows.
5. `Distilled Given` references valid prerequisite `Behavior Id`(s) or `NONE`.
6. Every row has a non-empty `Distilled When` starting with an `UPPERCASE_TAG:`.
7. `CRUD` is one of `C`, `R`, `U`, `D`, with all new writes/file additions marked `C`.
8. `Then` expresses only observable UI/item/data effects using `UPPERCASE_TAG:` prefixes **with zero verbs** (only nouns, targets, values, and state adjectives).
9. For Google Sheets: native cell strings/formulas are written (no CSV double-quoting, raw `\n` for multi-line `Then`), continuing `Sr.No.` and `Behavior Id` from the last row. For CSV fallback: multi-line `Then` cells and values with commas are double-quoted.
