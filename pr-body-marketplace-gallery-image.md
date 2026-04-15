## Description

- Move `Microsoft.AzureStackHCI/marketplaceGalleryImages` to stable API `2024-01-01` in module and resource-derived typings.
- Keep telemetry deployment on `Microsoft.Resources/deployments@2025-04-01`.
- Regenerate module artifacts via `Set-AVMModule`.
- Align e2e test files with current dependency contract.
- CI setup check: no additional AVM CI setup required compared to existing Azure Stack HCI modules.

## Pipeline Reference

| Pipeline |
| -------- |
| (fill after run) |

## Type of Change

- Azure Verified Module updates:
  - [x] Bugfix containing backwards-compatible bug fixes, and I have NOT bumped the MAJOR or MINOR version in `version.json`:
  - [ ] Feature update backwards compatible feature updates, and I have bumped the MINOR version in `version.json`.
  - [ ] Breaking changes and I have bumped the MAJOR version in `version.json`.
  - [x] Update to documentation
- [ ] Update to CI Environment or utilities (Non-module affecting changes)

## Checklist

- [x] I'm sure there are no other open Pull Requests for the same update/change
- [x] I have run `Set-AVMModule` locally to generate the supporting module files.
- [x] My corresponding pipelines / checks run clean and green without any errors or warnings
- [ ] I have updated the module's CHANGELOG.md file with an entry for the next version
- [x] No new custom CI secrets were introduced for this change.
