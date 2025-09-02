---
mode: 'agent'
description: 'Analyze Azure Verified Module (AVM) Bicep files and examples for technical debt, inconsistencies, documentation gaps, and quality issues.'
tools: ['search', 'runCommands', 'runTasks', 'usages', 'think', 'problems', 'changes', 'testFailure', 'openSimpleBrowser', 'fetch', 'githubRepo', 'todos', 'runTests', 'documentation', 'search']
---

# Technical Debt Analysis for Azure Verified Module

## 1. Objective
As an AI agent, your task is to analyze Azure Verified Module (AVM) Bicep files starting with `${file}`, including child folders of `${fileDirname}`, to identify technical debt, inconsistencies, documentation gaps, spelling mistakes, conflicting information, and quality issues in examples and documentation.

> [!IMPORTANT]
> This is a planning task only. Do not modify any files, unless the user asks you to.

## 2. Prerequisites

- Valid file path for AVM resource module following pattern: `avm/res/{provider}/{resource}/main.bicep`.
- Module must exist in the workspace.
- Access to `#fetch` tool for AVM documentation validation.

> [!CRITICAL]
> If any prerequisites are not met, you must stop and inform the user clearly, indicating what they must do.

## 3. Tool Use

- If the `#todos` tool is available, you must use that to track progress, updating it regularly.

## 4. Execution Flow

Here is a ReAct-style Thought–Action–Observation execution flow that you MUST follow:

- Thought: Validate file path and confirm module exists. Get AVM documentation index for compliance.
  - Action: todos.write → Track progress; codebase.stat(path=${file}); fetch(url=`https://azure.github.io/Azure-Verified-Modules/llms.txt`)
  - Observation: File exists and AVM documentation available (or not). If missing, stop and report per prerequisites.

- Thought: Scan module structure and identify all files to analyze for technical debt.
  - Action: list_dir(path=${fileDirname}); file_search(query=${fileDirname}/**/*.{bicep,md,json})
  - Observation: Complete inventory of module files including Bicep files, documentation, tests, and metadata.

- Thought: Analyze main Bicep file for code quality issues, inconsistencies, and best practice violations.
  - Action: read_file(filePath=${file}); grep_search(query=`@description|@metadata|param|var|resource|output`, isRegexp=true, includePattern=${file})
  - Observation: Module structure, parameter definitions, resource declarations, and output definitions available for analysis.

- Thought: Examine test files for consistency, completeness, and quality issues.
  - Action: file_search(query=${fileDirname}/tests/**/*.bicep); For each test file → read_file(filePath=testFile)
  - Observation: Test scenarios identified with their parameter usage and validation approaches.

- Thought: Analyze documentation files for accuracy, completeness, and consistency.
  - Action: file_search(query=${fileDirname}/**/*.md); For each README/doc → read_file(filePath=docFile)
  - Observation: Documentation content available for spelling, accuracy, and completeness validation.

- Thought: Check metadata and configuration files for consistency and compliance.
  - Action: file_search(query=${fileDirname}/**/version.json); read_file(filePath=versionFile); file_search(query=${fileDirname}/**/*.json)
  - Observation: Version information and configuration data available for validation.

- Thought: Cross-reference examples in documentation with actual test implementations.
  - Action: Compare documentation examples with test file parameters and validate consistency
  - Observation: Discrepancies between documented examples and actual test implementations identified.

- Thought: Validate AVM compliance by checking against official AVM specifications.
  - Action: fetch(url=AVM-specific-documentation-URLs); Compare module structure against AVM requirements
  - Observation: AVM compliance gaps and violations documented.

- Thought: Compile comprehensive technical debt findings into categorized issues.
  - Action: think(thoughts=`Categorize all identified issues: spelling errors, inconsistencies, missing documentation, incorrect examples, AVM violations, code quality issues`)
  - Observation: Complete technical debt inventory with severity and priority assignments.

- Thought: Produce final technical debt report with actionable recommendations.
  - Action: Compile detailed issue list with specific fixes and validation checklist
  - Observation: Complete technical debt analysis ready for user review and remediation.

## 5. Output Format

> [!CRITICAL]
> You MUST produce ALL sections below in the EXACT format specified. Missing any section will result in an incomplete analysis.

### 5.1. Technical Debt Summary (MANDATORY)

| Category | File | Issue Type | Severity | Description | Line/Section |
|----------|------|------------|----------|-------------|--------------|
| Documentation | `README.md` | Spelling Error | Low | "paramter" should be "parameter" | Line 45 |
| Examples | `tests/e2e/defaults/main.test.bicep` | Inconsistency | Medium | Parameter value differs from documentation example | Line 12 |
| Code Quality | `main.bicep` | Missing Description | High | Parameter lacks @description decorator | Line 23 |

### 5.2. Issue Categories

- � **Documentation**: Spelling errors, outdated information, missing sections
- 🔧 **Code Quality**: Missing decorators, inconsistent naming, poor structure
- 📋 **Examples**: Incorrect values, missing scenarios, inconsistent approaches
- ⚖️ **Compliance**: AVM specification violations, missing required elements
- � **Consistency**: Conflicting information between files, inconsistent patterns
- 🧪 **Testing**: Missing test scenarios, inadequate coverage, incorrect implementations

### 5.3. Detailed Issue Reports (MANDATORY)

For each identified issue, provide the following details:

#### Issue: {IssueTitle}
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

## 6. Execution Validation

> [!CRITICAL]
> Before completing your analysis, verify you have completed ALL of the following:

### Checklist for Complete Analysis:
- [ ] **Step 4**: Complete execution of all ReAct steps
- [ ] **Step 5.1**: Technical debt summary table created with ALL identified issues
- [ ] **Step 5.2**: Issue categories legend included
- [ ] **File Analysis**: Analyzed ALL files in the module including Bicep, documentation, tests, and metadata
- [ ] **Step 5.3**: Created detailed issue reports for EVERY identified problem
- [ ] **Validation**: Provided specific fixes, validation steps, and remediation guidance

### Failure Conditions:
- **INCOMPLETE**: If you skip any mandatory section (5.1, 5.2, or 5.3)
- **INSUFFICIENT**: If you don't analyze all module files or miss critical components
- **VAGUE**: If you provide general statements instead of specific issue descriptions and fixes
- **MISSING**: If you don't create detailed remediation plans for identified issues

> [!WARNING]
> If any of the above conditions are met, the analysis is considered incomplete and must be redone.

## 7. Constraints
- ⚠️ **No File Modifications**: This is a planning task only. Do not edit any files.
- ⚠️ **AVM Compliance**: All recommendations must align with AVM specifications.
- ⚠️ **Quality Focus**: Prioritize issues that impact module quality, usability, and maintainability.
- ⚠️ **Documentation Accuracy**: Ensure all spelling and factual corrections are verified.
