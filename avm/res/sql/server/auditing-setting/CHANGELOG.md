# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/auditing-setting/CHANGELOG.md).

## 0.1.2

### Changes

- Storage permissions are assigned to the server's primary user-assigned identity when configured, falling back to the system-assigned identity only when no primary is configured. Primary identity resource IDs are matched case-insensitively, and deployment fails with a descriptive message if no suitable identity can be resolved
- The `storageAccountResourceId` parameter is now nullable
- Updated the API version used to retrieve the storage account access key
- Clarified that a diagnostic setting on the `master` database is required to route audit logs to Azure Monitor

### Breaking Changes

- None

## 0.1.1

### Changes

- Regenerated ARM template artifacts with Bicep 0.48.1 without changing resource configuration.

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None