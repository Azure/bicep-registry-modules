# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/app/function-app/CHANGELOG.md).

## 0.1.0

### Changes

- Initial version of the pattern module.
- Uses a User-Assigned Managed Identity for runtime storage access (`AzureWebJobsStorage` identity-based connection); a UAMI is created by default and can be supplied via `userAssignedIdentityResourceId` to break the SA-MI / role-assignment dependency cycle.
- Default `appServicePlanSkuName` is `FC1` (Flex Consumption); the module automatically wires up `functionAppConfig` (identity-based deployment storage, runtime, and scale/concurrency) on the underlying `avm/res/web/site` module and provisions the deployment-package blob container in the runtime Storage Account. Use `flexConsumptionInstanceMemoryMB` (512/2048/4096), `flexConsumptionMaximumInstanceCount` (40-1000), and `flexConsumptionDeploymentStorageContainerName` to tune Flex behavior. Note: Flex is Linux-only and does not support the in-process `dotnet` runtime — use `dotnet-isolated` instead.
- Storage RBAC narrowed to **Storage Blob Data Contributor** (instead of Owner) plus Queue/Table Data Contributor.
- App Service Plan `kind` is derived from the SKU family so Function App plans are classified correctly (`functionapp` for FC1 Flex Consumption, `functionapp[,linux]` for Y1, `[linux,]elastic` for EP1-3, `app`/`linux` for Dedicated).
- `zoneRedundant` on the App Service Plan is gated to only the SKUs that actually support it (`P{1-3}v3`, `P{1-5}mv3`, `EP{1-3}`) and requires `appServicePlanSkuCapacity >= 2`.
- For Consumption (Y1) and Elastic Premium (EP) plans, the module sets `WEBSITE_CONTENTAZUREFILECONNECTIONSTRING` and `WEBSITE_CONTENTSHARE` so the runtime can resolve the file share that those plan families require.
- When `enableWafAlignment` is `true` and the plan needs a content share, `WEBSITE_CONTENTOVERVNET=1` is also set so file-share traffic flows over the integrated VNet to the Storage Account's Private Endpoints.
- Storage Account `allowSharedKeyAccess` is gated to `requiresContentShare` so it is only enabled for plan families that need the content-share connection string (Y1, EP). Dedicated and Flex plans run fully identity-based with shared-key disabled.
- Reserved app-setting keys (`AzureWebJobsStorage*`, `APPLICATIONINSIGHTS_CONNECTION_STRING`, `FUNCTIONS_*`, `WEBSITE_CONTENT*`) are filtered out of `appSettingsKeyValuePairs` so module-managed values always win and cannot be silently broken from the consumer side.
- Linux Function Apps now receive a sensible default `linuxFxVersion` per `functionWorkerRuntime` when `runtimeVersion` is not provided (e.g. `dotnet-isolated|8.0`, `node|20`, `python|3.11`, `java|17`, `powershell|7.4`).
- `functionAppKind` allowed list expanded with `functionapp,workflowapp` (Logic Apps Standard). Container-based Function Apps (`functionapp,linux,container`) are not exposed in v0.1 — they require dedicated container image / registry parameters and are planned for a future minor release.
- Added optional `privateDnsZoneResourceIds` (typed) parameter so consumers can wire Private DNS Zones into each Private Endpoint (`sites`, `blob`, `file`, `queue`, `table`) created by this module.
- Added `tags` / `functionAppTags` split: `tags` apply to every resource; `functionAppTags` are merged on top only on the Function App, intended for AZD's `azd-service-name` mapping.
- `appSettingsKeyValuePairs` description clarified — values must be strings; reserved-key behavior documented.
- Added `tests/e2e/max` test exercising every parameter (BYO UAMI, BYO Log Analytics workspace, custom names, CORS, lock, diagnostic settings, and `privateDnsZoneResourceIds` wired against deployed zones).

### Breaking Changes

- None
