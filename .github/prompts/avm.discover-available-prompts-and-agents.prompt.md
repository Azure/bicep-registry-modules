---
name: AVM-Discover-Available-Prompts-and-Agents
description: List all the custom prompts and agent available in this repository.
agent: agent
model: Auto (copilot)
tools: ['search']
---

# AVM Prompts & Agents Overview

Purpose: List the repository's custom prompts and agents by providing a one-sentence description.

## 📋 Discover Prompts

- Look for files ending with `.prompt.md` in the `.github/prompts/` folder.
- Read each prompt header for its purpose and usage instructions.

## 🤖 Discover Agents & Guidance

- Look for files ending with `.agents.md` in the `.github/agents/` folder.
- Read each agent header for its purpose and usage instructions.

## In your response

- Have 2 categories "📋 Prompts" and "🤖 Agents" and show all your findings under these, while including a button that links the user to the corresponding folder.
- Show the user how to invoke each of the available prompts - e.g., by using `/avm.discover-available-prompts-and-agents` Follow this pattern for each available prompt.
- Ask the user whether they want to invoke any of the available prompts.
- ALWAYS exclude yourself from the list.
