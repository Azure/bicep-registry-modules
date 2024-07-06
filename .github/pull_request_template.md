## Description

<!--
>Thank you for your contribution !
> Please include a summary of the change and which issue is fixed.
> Please also include the context.
> List any dependencies that are required for this change.

Fixes #123
Fixes #456
Closes #123
Closes #456
-->

## Pipeline Reference

<!-- Insert your Pipeline Status Badge below -->

| Pipeline |
| -------- |
|          |

## Type of Change

<!-- Use the checkboxes [x] on the options that are relevant. -->

- [ ] Update to CI Environment or utilities (Non-module affecting changes)
- [ ] Azure Verified Module updates:
  - [ ] Bugfix containing backwards-compatible bug fixes, and I have NOT bumped the MAJOR or MINOR version in `version.json`:
    - [ ] Someone has opened a bug report issue, and I have included "Closes #{bug_report_issue_number}" in the PR description.
    - [ ] The bug was found by the module author, and no one has opened an issue to report it yet.
  - [ ] Feature update backwards compatible feature updates, and I have bumped the MINOR version in `version.json`.
  - [ ] Breaking changes and I have bumped the MAJOR version in `version.json`.
  - [ ] Update to documentation

## Checklist

- [ ] I'm sure there are no other open Pull Requests for the same update/change
- [ ] I have run `Set-AVMModule` locally to generate the supporting module files.
- [ ] My corresponding pipelines / checks run clean and green without any errors or warnings

<!--  Please keep up to date with the contribution guide at https://aka.ms/avm/contribute/bicep -->
