# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/web/function-app/CHANGELOG.md).

## 0.1.0

### Changes

- Initial version of the pattern module.
- Uses a User-Assigned Managed Identity for runtime storage access (`AzureWebJobsStorage` identity-based connection); a UAMI is created by default and can be supplied via `userAssignedIdentityResourceId` to break the SA-MI / role-assignment dependency cycle.
- Default `appServicePlanSkuName` is `Y1` (Consumption); `FC1` (Flex Consumption) remains in the allowed list but requires a consumer-supplied `functionAppConfig`.
- Storage RBAC narrowed to **Storage Blob Data Contributor** (instead of Owner) plus Queue/Table Data Contributor.

### Breaking Changes

- None
