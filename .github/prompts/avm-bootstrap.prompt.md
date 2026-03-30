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

Return immediately. This prompt is only used to enforce what's in the front matter.
