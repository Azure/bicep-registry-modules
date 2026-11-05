# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/auditing-setting/CHANGELOG.md).

## 0.1.1

### Changes

- The primary user-assigned identity of the server is now matched case-insensitively when assigning storage permissions, and the deployment fails with a descriptive message if the server has no suitable identity
- The `storageAccountResourceId` parameter is now nullable
- Updated the API version used to retrieve the storage account access key
- Clarified that a diagnostic setting on the `master` database is required to route audit logs to Azure Monitor

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None