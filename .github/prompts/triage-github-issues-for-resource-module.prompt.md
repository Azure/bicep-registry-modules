---
mode: 'agent'
description: 'Triage Open GitHub Issues related to the specific resource module.'
tools: ['search', 'runCommands', 'runTasks', 'usages', 'think', 'problems', 'changes', 'testFailure', 'openSimpleBrowser', 'fetch', 'githubRepo', 'todos', 'documentation', 'search', 'get_issue', 'get_issue_comments', 'get_pull_request', 'get_pull_request_comments', 'list_issues', 'search_issues', 'search_pull_requests']
---

# Triage Open GitHub Issues for Resource Module

## 1. Objective
As an AI agent, your task is to list all open GitHub Issues related to this resource module `${input:resource}` in the `${input:provider}` and provide triaging for them.

> [!IMPORTANT]
> This is a planning task only. Do not modify any files, unless the user asks you to. You may however add comments or notes to relevant GitHub Issues if the user asks you to.

## 2. Prerequisites

- ${input:provider} and ${input:resource} must be clearly provided, or detectable based on the ${file}.
- A valid resource module must exist in the `avm/res/${input:provider}/${input:resource}/` folder.
- You must have access to the `#search_issues` and `#get_issue` tools.

> [!CRITICAL]
> If any of the prerequisites are not met, you must stop and inform the user clearly, indicating what they must do.

## 3. Tool Use

- If the `#todos` tool is available, you must use that to track progress, updating it regularly.

## 4. Execution Flow

Here is a ReAct-style Thought–Action–Observation execution flow that you MUST follow:

- Thought: Validate inputs `${input:provider}` and `${input:resource}` and determine expected module path `avm/res/${input:provider}/${input:resource}/`. Confirm the module exists.
  - Action: todos.write → Track progress; codebase.stat(path=`avm/res/${input:provider}/${input:resource}/`)
  - Observation: Module path exists (or not). If missing, stop and report per prerequisites.

- Thought: Search for all `open issues` related to the module path in the repository.
  - Action: github.search_issues(query=`repo:Azure/bicep-registry-modules state:open "avm/res/${input:provider}/${input:resource}/" in:title,body`)
  - Observation: A list of candidate issues (numbers, titles, URLs).

- Thought: For each candidate issue, gather full context to assess relevance.
  - Action: For each issue → github.get_issue(owner=Azure, repo=bicep-registry-modules, issue_number); github.get_issue_comments(owner=Azure, repo=bicep-registry-modules, issue_number)
  - Observation: Issue body and aggregated comments are available for analysis.

- Thought: Perform a quick triage to determine relevance and categorize.
  - Action: Analyze title/body/comments; classify into one of ['Bug','Update Required','Feature Request','Documentation','Examples','Security','Critical','Other']; flag if the module path appears explicitly.
  - Observation: A shallow assessment record for the issue.

- Thought: Perform deeper reasoning to evaluate impact on the resource module.
  - Action: think(thoughts=`Impact on avm/res/${input:provider}/${input:resource}/, potential module changes, risks, and next steps`)
  - Observation: A deeper analysis summary including potential impact and recommended actions.

- Thought: Produce outputs for reporting.
  - Action: Compile a summary table (issue/link, title, relevance, category, findings) and a detailed findings list including deep analysis.
  - Observation: Outputs ready for presentation to the user.


## 5. Output Format
The output table must comply with the final action and should look similar to this example:

| Issue                                                                | Title                                          | Relevance | Category | Findings           |
| ---------------------------------------------------------------------|------------------------------------------------|-----------|----------|--------------------|
| [#5798](https://github.com/Azure/bicep-registry-modules/issues/5798) | [Failed pipeline] avm.res.databricks.workspace | High      |  🐞     | Summary of findings |

### 5.1 Categories

- 🐞 **Bug**: A bug in the module has been identified.
- 🔁 **Update Required**: An API update to the module is required.
- ➕ **Feature Request**: A new feature or enhancement is requested.
- 📄 **Documentation**: Improvements or additions to the module's documentation are needed.
- 🧪 **Examples**: New examples or improvements to existing examples are needed.
- 🔒 **Security**: Security-related issues or enhancements are needed.
- ❓ **Other**: Any other type of issue not covered by the above categories.
- 🔴 **Critical**: Issues that require immediate attention and resolution.

## 6. Finding Details

The findings from the analysis for each issue should be provided using the following format:
```markdown
## Issue: {IssueTitle}
- **Category**: {Documentation | Code Quality | Examples | Compliance | Consistency | Testing}
- **Severity**: {Low | Medium | High | Critical}
- **File(s)**: {affected file paths}
- **Location**: {specific line numbers or sections}

**Problem Description:**
- Clear description of the issue found
- Impact on module quality or usability
- Specific examples of the problem

**Recommended Fix:**
- Specific corrective actions required
- Exact text changes or structural modifications needed
- References to AVM specifications or best practices

**Validation Steps:**
- How to verify the fix is correct
- Testing requirements to ensure quality
- Documentation updates needed
```

## 7. Execution Validation

> [!CRITICAL]
> Before completing your analysis, verify you have completed ALL of the following:

### Checklist for Complete Analysis:
- [ ] **Step 4**: Complete execution of all steps
- [ ] **Step 5**: Summary table has been outputted including correct categories for 5.1.
- [ ] **Step 6**: The complete findings list has been generated.

### Failure Conditions:
- **INCOMPLETE**: If you skip any mandatory section (4, 5 or 6)
- **NO ISSUES**: If you don't fetch github issues or can't find any relevant issues.
- **VAGUE**: If you provide general statements instead of specific property differences
- **MISSING**: If you don't create detailed implementation plans for resources requiring updates

> [!WARNING]
> If any of the above conditions are met, the analysis is considered incomplete and must be redone.

## 8. Constraints
- ⚠️ **No File Modifications**: This is a planning task only. Do not edit any files.
- ⚠️ **AVM Compliance**: All recommendations must align with AVM specifications.
- ⚠️ **Stable Versions Only**: Prioritize stable API versions unless a preview is explicitly required.
