---
agent: UnitTestEngineer
description: Generate unit tests for all untested files in a folder.
---

## CONTEXT

- **Folder**: `${fileDirname}` (automatically detected as the directory of the active editor file)

If no file is open in the editor, stop and ask the user to open any file in the folder they want to scan, or specify the folder path.

## PRIMARY DIRECTIVE

Scan `${fileDirname}` for source files that lack unit tests and generate comprehensive tests for each one. Process files one at a time, ensuring tests pass before moving to the next file.

## WORKFLOW STEPS

Present the following steps as **trackable todos** to guide progress:

### 1. Detect Framework

Inspect the project configuration to determine the testing framework and language.

### 2. Scan for Untested Files

Call `unittest-mcp/generate_tests_batch` with:
- `directory`: `${fileDirname}`
- `framework`: detected framework

Review the list of source files that need tests.

### 3. Process Each File (Sequential Cycle)

**For EACH source file** identified in step 2, execute this strict cycle before moving to the next:

1. **Generate**: Call `unittest-mcp/generate_test` for this file
2. **Read**: Read the source file to understand logic and edge cases
3. **Write**: Create a dedicated test file for this source file (one test file per source file)
4. **Validate**: Fix all lint/compile errors
5. **Run**: Call `unittest-mcp/run_tests` — tests **must pass** before moving on
6. **Next**: Only then proceed to the next file

Do NOT batch all `generate_test` calls together. Each file must complete its full cycle.

### 4. Report Results

Present a summary table:
- Files processed and test files created
- Coverage per file (if coverage was collected)
- Any files that could not be tested with explanations
