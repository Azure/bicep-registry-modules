## Description

<!--Why this PR? What is changed? What is the effect? etc.-->

If you haven't already, read the full [contribution guide](../CONTRIBUTING.md). The guide may have changed since the last time you read it, so please double-check. Once you are done and ready to submit your PR, edit the PR description and run through the relevant checklist below.

## Adding a new module

<!--Run through the checklist if your PR adds a new module.-->

- [ ] A proposal has been submitted and approved.
- [ ] I have included "Closes #{module_proposal_issue_number}" in the PR description.
- [ ] I have run `brm validate` locally to verify the module files.
- [ ] I have run deployment tests locally to ensure the module is deployable.

## Updating an existing module

<!--Run through the checklist if your PR updates an existing module.-->

- [ ] This is a bug fix:
  - [ ] Someone has opened a bug report issue, and I have included "Closes #{bug_report_issue_number}" in the PR description.
  - [ ] The bug was found by the module author, and no one has opened an issue to report it yet.
- [ ] I have run `brm validate` locally to verify the module files.
- [ ] I have run deployment tests locally to ensure the module is deployable.
- [ ] I have read the [Updating an existing module](../CONTRIBUTING.md#updating-an-existing-module) section in the contributing guide and updated the `version.json` file properly:
  - [ ] The PR contains backwards compatible bug fixes, and I have NOT bumped the MAJOR or MINOR version in `version.json`.
  - [ ] The PR contains backwards compatible feature updates, and I have bumped the MINOR version in `version.json`.
  - [ ] The PR contains breaking changes, and I have bumped the MAJOR version in `version.json`.
