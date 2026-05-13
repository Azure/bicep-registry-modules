# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/web/function-app/CHANGELOG.md).

## 0.1.0

### Changes

- Initial version of the pattern module.
- Uses a User-Assigned Managed Identity for runtime storage access (`AzureWebJobsStorage` identity-based connection); a UAMI is created by default and can be supplied via `userAssignedIdentityResourceId` to break the SA-MI / role-assignment dependency cycle.
- Default `appServicePlanSkuName` is `Y1` (Consumption); `FC1` (Flex Consumption) remains in the allowed list but requires a consumer-supplied `functionAppConfig`.
- Storage RBAC narrowed to **Storage Blob Data Contributor** (instead of Owner) plus Queue/Table Data Contributor.
- App Service Plan `kind` is derived from the SKU family so Function App plans are classified correctly (`functionapp[,linux]` for Y1/FC1, `[linux,]elastic` for EP1-3, `app`/`linux` for Dedicated).
- `zoneRedundant` on the App Service Plan is gated to only the SKUs that actually support it (`P{1-3}v3`, `P{1-5}mv3`, `EP{1-3}`) and requires `appServicePlanSkuCapacity >= 2`.
- For Consumption (Y1) and Elastic Premium (EP) plans, the module sets `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING` and `WEBSITE_CONTENTSHARE` so the runtime can resolve the file share that those plan families require.
- When `enableWafAlignment` is `true` and the plan needs a content share, `WEBSITE_CONTENTOVERVNET=1` is also set so file-share traffic flows over the integrated VNet to the Storage Account's Private Endpoints.
- Added optional `privateDnsZoneResourceIds` (typed) parameter so consumers can wire Private DNS Zones into each Private Endpoint (`sites`, `blob`, `file`, `queue`, `table`) created by this module.
- `appSettingsKeyValuePairs` description clarified — values must be strings.

### Breaking Changes

- None
