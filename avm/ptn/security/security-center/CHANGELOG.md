# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/security/security-center/CHANGELOG.md).

## 0.3.0

### New Features

- Added unified `defenderPlans` array parameter replacing individual pricing tier params. Each plan entry supports `name`, `pricingTier`, `subPlan`, `enforce`, and `extensions` properties. Closes [#1784](https://github.com/Azure/bicep-registry-modules/issues/1784), [#4855](https://github.com/Azure/bicep-registry-modules/issues/4855).
- Added Defender CSPM (`CloudPosture`) plan support with extensions (AgentlessVmScanning, AgentlessDiscoveryForKubernetes, SensitiveDataDiscovery, ContainerRegistriesVulnerabilityAssessments, EntraPermissionsManagement). Closes [#2663](https://github.com/Azure/bicep-registry-modules/issues/2663).
- Added Defender for APIs (`Api`) plan support. Closes [#2987](https://github.com/Azure/bicep-registry-modules/issues/2987).
- Added `enforce` property support for all Defender plans to control pricing configuration inheritance. Closes [#1784](https://github.com/Azure/bicep-registry-modules/issues/1784).
- Added `securityAutomations` parameter for continuous export of alerts and recommendations to Log Analytics workspaces, Event Hubs, or Logic Apps. Supports fully typed discriminated action types. Closes [#5594](https://github.com/Azure/bicep-registry-modules/issues/5594).
- Added `extensions` property support for all Defender plans (e.g., ContainerSensor, OnUploadMalwareScanning, AgentlessVmScanning). Closes [#4855](https://github.com/Azure/bicep-registry-modules/issues/4855).
- Added `serverVulnerabilityAssessmentsSettings` parameter to configure the vulnerability assessment provider (Microsoft Defender Vulnerability Management).
- Added `securityStandards` parameter to create custom security standards with assessment mappings.
- Added `standardAssignments` parameter to assign security standards to scopes with effect, exclusion, and expiry support.
- Added `customRecommendations` parameter to create custom security recommendations with KQL queries.
- Added `securitySettings` parameter to manage Defender for Cloud integrations (MCAS, WDATP/MDE, Sentinel alert sync).
- Added `assessmentMetadataList` parameter to define custom assessment metadata (pairs with custom recommendations).
- Added `alertsSuppressionRules` parameter to create alert suppression rules for reducing alert noise (preview API).
- Added `governanceRules` parameter to define governance rules for driving security remediation with ownership, timeframes, and notifications (preview API).
- Added `configuredDefenderPlans` output listing the names of deployed Defender plans.
- Added strongly typed user-defined types for all parameters (`defenderPlanType`, `extensionType`, `securityContactType`, `deviceSecurityGroupType`, `ioTSecuritySolutionType`).
- Security contacts `notificationsByRole` and `notificationsSources` are now properly typed with discriminated unions. Closes [#4854](https://github.com/Azure/bicep-registry-modules/issues/4854).

### Changes

- Updated `Microsoft.Resources/deployments` API version from `2024-03-01` to `2024-07-01`.
- Removed deprecated `KubernetesService`, `ContainerRegistry`, and `Dns` plans from defaults (replaced by `Containers` plan).
- Granular plan configuration — callers can now configure only the plans they need without specifying all plans. Closes [#5594](https://github.com/Azure/bicep-registry-modules/issues/5594).
- Modernized module to use nullable types and safe-access operators throughout.
- Addressed MMA deprecation concerns by removing dependency on workspace settings. Closes [#4419](https://github.com/Azure/bicep-registry-modules/issues/4419).
- Comprehensive update towards feature-parity with portal experience. Partially addresses [#2007](https://github.com/Azure/bicep-registry-modules/issues/2007) (policy assignments in [#2662](https://github.com/Azure/bicep-registry-modules/issues/2662) remain open).

### Breaking Changes

- **Removed** individual pricing tier parameters (`virtualMachinesPricingTier`, `sqlServersPricingTier`, `appServicesPricingTier`, `storageAccountsPricingTier`, `storageAccountsMalwareScanningSettings`, `sqlServerVirtualMachinesPricingTier`, `kubernetesServicePricingTier`, `containerRegistryPricingTier`, `keyVaultsPricingTier`, `dnsPricingTier`, `armPricingTier`, `openSourceRelationalDatabasesTier`, `containersTier`, `cosmosDbsTier`) in favor of the unified `defenderPlans` array parameter.
- **Changed** `securityContactProperties` from untyped `object` to strongly typed `securityContactType`.
- **Changed** `deviceSecurityGroupProperties` from untyped `object` to strongly typed `deviceSecurityGroupType`.
- **Changed** `ioTSecuritySolutionProperties` from untyped `object` to strongly typed `ioTSecuritySolutionType`.

## 0.2.0

### Changes

- Updated API version of 'Microsoft.Security/securityContacts'
- Updated parameters to support new version of 'Microsoft.Security/securityContacts'

### Breaking Changes

- securityContactProperties require different parameters


## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
