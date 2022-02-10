<!-- If you haven't already, read the full [contribution guide](TODO). The guide may have changed since the last time you read it, so please double-check. Once you are done and ready to submit your PR, add PR description and run through the relevant checklist below. -->

## Description

<!--Why this PR? What is changed? What is the effect? etc.-->

## Adding a new module

<!--Run through the checklist if your PR adds a new module.-->

- [ ] A proposal has been submitted and approved.
- [ ] I have included "Closes #{proposal_issue_number}" in the PR description.
- [ ] I have run `brm validate` locally to verify the module files.
- [ ] I have run deployment tests locally to ensure the module is deployable.

## Updating an existing module

<!--Run through the checklist if your PR updates a new module.-->

- [ ] I have run `brm validate` locally to verify the module files.
- [ ] I have run deployment tests locally to ensure the module is deployable.
- [ ] The PR contains backwards compatible bug fixes and I have not bumped the MAJOR or MINOR version in `version.json`.
- [ ] The PR contains backwards compatible feature updates and I have bumped the MINOR version in `version.json`.
- [ ] The PR contains breaking changes and I have bumped the MAJOR version in `version.json`.
