# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/sa/modernize-your-code/CHANGELOG.md).

## 0.2.0

### Changes

- Fix Bicep linter warnings (`no-unused-params`, `use-recent-api-versions`)
- Update parameter descriptions to comply with AVM standards (Required./Optional. prefix and trailing dot)
- Remove support for existing Log Analytics and AI Project resource IDs
- Update API versions for Key Vault and Cognitive Services

### Breaking Changes

- Removed parameters:
  - `azureExistingAIProjectResourceId`
  - `existingLogAnalyticsWorkspaceId`

## 0.1.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None