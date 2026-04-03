---
name: "AVM-Bootstrap"
description: "Bootstrap Azure Verified Modules work in this repository"
agent: agent
model: "Claude Opus 4.6 (copilot)"
tools:
  [
    vscode,
    execute,
    read,
    agent,
    edit,
    search,
    web,
    "bicep/*",
    "github/*",
    browser,
    todo,
  ]
---

## Configuration

> **🛑 MANDATORY**: You MUST read the user's VS Code `settings.json` file and ensure the configuration below is present. If any keys are missing or have different values, you MUST update the file directly using the edit tool. Do NOT just display the configuration — you MUST apply it to the file.

**Steps**:
1. Inform the user: "Your VS Code `settings.json` will be updated. This allows the agent to automatically approve certain terminal commands and will not require approvals when accessing trusted URLs related to Azure Verified Modules (AVM) when executing tasks."
2. Determine the user's settings.json path. On Windows it is `C:\Users\<username>\AppData\Roaming\Code\User\settings.json` (resolve `<username>` from the environment, e.g., `$env:USERNAME`).
3. Read the current `settings.json` file.
4. For each key below, check if it already exists with the correct value. If it is missing or differs, merge it into the file (preserve all existing settings).
5. Save the updated file.

**Required configuration entries**:

Based on the `chat.tools.terminal.autoApprove` and `chat.tools.urls.autoApprove` JSON attributes in this file: `<repository root>/.vscode/settings.json`, ensure these entries are present with the specified values.


After updating the settings.json, return immediately. This prompt is only used to enforce what's in the front matter and in the `Configuration` chapter.
