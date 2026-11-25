## Description

<!--
>Thank you for your contribution !
> Please include a summary of the change and which issue is fixed.
> Please also include the context.
> List any dependencies that are required for this change.

Fixes #123
Closes #123
-->

## PR Checks

<!-- E2E deployments are label-gated so PRs can be opened early and cloud tests run only when the changes are ready, reducing cost and feedback time. Add PR: Run Required E2E Tests for required scenarios only, or PR: Run All E2E Tests for required and optional scenarios. Fork PR labels do not grant deployment credentials. -->

## Type of Change

<!-- Use the checkboxes [x] on the options that are relevant. -->

- Azure Verified Module updates:
  - [ ] Bugfix containing backwards-compatible bug fixes, and I have NOT bumped the MAJOR or MINOR version in `version.json`:
  - [ ] Feature update backwards compatible feature updates, and I have bumped the MINOR version in `version.json`.
  - [ ] Breaking changes and I have bumped the MAJOR version in `version.json`.
  - [ ] Update to documentation
- [ ] Update to CI Environment or utilities (Non-module affecting changes)

## Checklist

- [ ] I'm sure there are no other open Pull Requests for the same update/change
- [ ] I have run `avm pre-commit` locally to generate the supporting module files, if applicable.
- [ ] My corresponding pipelines / checks run clean and green without any errors or warnings
- [ ] I have updated the module's CHANGELOG.md file with an entry for the next version

<!--  Please keep up to date with the contribution guide at https://aka.ms/avm/contribute/bicep -->
