---
agent: UnitTestEngineer
description: Analyze coverage gaps and generate targeted tests to improve coverage to target thresholds.
---

## CONTEXT

- **Scope**: `${file}` (automatically detected from the active editor — can also be a folder path)

If no file is open in the editor, stop and ask the user to open the source file or specify the folder they want coverage analysis for.

## PRIMARY DIRECTIVE

Analyze code coverage for `${file}` and generate targeted tests to fill coverage gaps. Iterate until the configured coverage target (default: 80%) is met or 5 improvement rounds have been exhausted.

## WORKFLOW STEPS

Present the following steps as **trackable todos** to guide progress:

### 1. Detect Framework

Inspect the project configuration to determine the testing framework, language, and root directory.

### 2. Run Tests with Coverage

Call `unittest-mcp/run_tests` with:
- `include_coverage`: true
- `framework`: detected framework
- `root_dir`: project root directory
- `timeout_ms`: 600000

### 3. Inspect Coverage

Call `unittest-mcp/inspect_coverage` with:
- `source_file`: `${file}` (for single file)
- `root_dir`: project root directory
- `framework`: detected framework

Identify:
- Overall coverage percentage (line and branch)
- Specific uncovered lines and branches
- Files with lowest coverage (if folder scope)

### 4. Coverage Improvement Loop (max 5 iterations)

For each iteration:

1. **Analyze**: Read the source code at uncovered lines to understand the missed paths
2. **Target**: Focus on error handling, early returns, conditional branches, catch blocks, edge cases
3. **Generate**: Call `unittest-mcp/generate_test` for each file needing improvement
4. **Write**: Create or update test files with targeted tests
5. **Validate**: Fix all lint/compile errors
6. **Verify**: Run tests with coverage — if target met, stop

Track coverage improvement per iteration.

### 5. Report Results

Present a coverage report:
- Starting vs. final coverage (line and branch)
- Tests added per iteration
- Uncovered paths that remain with explanations (unreachable code, platform-specific, etc.)
- Recommendations for further improvement if target not fully met
