# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/app-service-lza/hosting-environment/CHANGELOG.md).

## 0.2.0

### Changes

#### Architecture Refactoring

- Consolidated ~150 flat parameters into 9 typed configuration objects using Bicep user-defined types (`spokeNetworkConfig`, `jumpboxConfig`, `servicePlanConfig`, `appServiceConfig`, `keyVaultConfig`, `appInsightsConfig`, `appGatewayConfig`, `frontDoorConfig`, `aseConfig`). All properties are optional with sensible defaults — callers now pass structured objects instead of individual params.
- Renamed `webAppConfig`/`webAppConfigType` to `appServiceConfig`/`appServiceConfigType` to align with Azure service naming.
- Removed intermediate orchestrator modules: `modules/app-service/app-service.module.bicep`, `modules/app-service/ase.module.bicep`, `modules/spoke/deploy.spoke.bicep`, and `modules/supporting-services/deploy.supporting-services.bicep`. Their logic has been inlined into `main.bicep` using direct AVM module references.
- Added `modules/shared.types.bicep` with exported user-defined types for all 9 configuration domains, plus shared types (`clusterSettingType`, `siteConfigType`, `virtualNetworkLinkType`, `osDiskConfigType`, `maintenanceWindowConfigType`).
- Added `modules/networking/application-gateway.module.bicep` as a new child module for Application Gateway with WAF policy integration.
- Re-structured `main.bicep` to use resolver variables that bridge typed config objects to internal module call sites, enabling the refactoring without modifying child modules.

#### Dependency Version Updates

- `avm/utl/types/avm-common-types`: `0.5.1` → `0.7.0`
- `avm/res/web/site`: `0.9.0` → `0.22.0`
- `avm/res/web/serverfarm`: `0.2.4` → `0.7.0`
- `avm/res/web/hosting-environment`: `0.3.0` → `0.5.0`
- `avm/res/cdn/profile` (Front Door): `0.12.1` → `0.17.2`
- `avm/res/key-vault/vault`: `0.12.1` → `0.13.3`
- `avm/res/insights/component`: `0.4.1` → `0.7.1`
- `avm/res/compute/virtual-machine`: `0.12.1` → `0.21.0`
- `avm/res/network/virtual-network`: `0.5.4` → `0.7.2`
- `avm/res/network/virtual-network/subnet`: `0.1.1` → `0.1.3`
- `avm/res/network/network-security-group`: `0.5.0` → `0.5.2`
- `avm/res/network/private-dns-zone`: `0.6.0`/`0.7.0` → `0.8.0`
- `avm/res/network/private-endpoint`: `0.9.0` → `0.11.1`
- `avm/res/network/route-table`: `0.4.0` → `0.5.0`
- `avm/res/network/front-door-web-application-firewall-policy`: `0.3.1` → `0.3.3`
- `avm/res/managed-identity/user-assigned-identity`: `0.4.0` → `0.5.0`
- `avm/res/resources/resource-group`: `0.4.1` → `0.4.3`

#### New Dependencies

- `avm/res/network/application-gateway:0.8.0`
- `avm/res/network/application-gateway-web-application-firewall-policy:0.2.1`
- `avm/res/network/public-ip-address:0.12.0`
- `avm/res/insights/data-collection-rule:0.10.0`
- `avm/res/maintenance/maintenance-configuration:0.3.2`
- `avm/res/resources/deployment-script:0.5.2`
- `avm/res/compute/ssh-public-key:0.4.4`

#### Removed Dependencies

- `avm/res/operational-insights/workspace` (Log Analytics workspace is now expected as an existing resource via `logAnalyticsWorkspaceResourceId`)

#### New Features

- Added Application Gateway as an alternative ingress option alongside Front Door (`spokeNetworkConfig.ingressOption: 'applicationGateway'`).
- Added bring-your-own-service support: pass an existing App Service Plan via `servicePlanConfig.existingPlanId` to skip plan creation.
- Added `customResourceNames` parameter for overriding generated resource names to comply with organization-specific naming policies.
- Added container workload support: Linux containers, Windows containers, container registry authentication via `appServiceConfig.container`.
- Added jumpbox VM maintenance window configuration (parameterized start time, duration, timezone, recurrence).
- Added jumpbox VM OS disk configuration (disk size, storage account type with typed union).
- Added jumpbox VM image parameterization (Linux publisher/offer/sku, Windows OS version).
- Added Data Collection Rules for VM monitoring with Azure Monitor Agent.
- Added SSH key generation via deployment script for Linux jumpbox VMs.
- Added `encryptionAtHost` parameter for jumpbox VMs (defaults to `true` for WAF alignment).
- Added multi-region deployment support (validated via `multi-region-front-door` test scenario).

#### Bug Fixes

- Fixed `disableIpMasking` default from `true` to `false` in App Insights to preserve IP masking for privacy/GDPR compliance.
- Fixed `clientAffinityProxyEnabled` default from `true` to `false` to match `clientAffinityEnabled: false`.
- Fixed `appInsightsKind` fallback from empty string to `'web'`.
- Fixed role assignment GUID collision between `approve-afd-pe.module.bicep` and `linux-vm.bicep` by adding unique discriminators.
- Fixed inconsistent Windows jumpbox subnet name (hardcoded `'snet-jumpbox'` → `resourceNames.snetDevOps`).
- Consolidated duplicate `import` statements in `application-gateway.module.bicep` and `front-door.module.bicep`.
- Replaced blanket `#disable-diagnostics BCP318` with scoped comment explaining the suppression.
- Updated Azure CLI version in AFD PE approval script from `2.47.0` to `2.67.0`.
- Updated maintenance window defaults: timezone from `'W. Europe Standard Time'` to `'UTC'`, start date to `'2026-06-16 00:00'`.

#### Security & WAF Alignment

- Upgraded default Linux jumpbox image from Ubuntu 20.04 (EOL) to Ubuntu 24.04 LTS (`ubuntu-24_04-lts` / `server-gen2`).
- Upgraded default Windows jumpbox image from Server 2016 to Server 2025 (`2025-datacenter-g2`).
- Enabled `encryptionAtHost` by default on jumpbox VMs.
- VM patching configured with `AutomaticByPlatform` mode and maintenance configurations for scheduled patching.

#### Test Coverage

- Added 6 new e2e test scenarios: `max`, `multi-region-front-door`, `byos-linux-matrix`, `byos-windows-matrix`, `ase-linux-matrix`, `ase-windows-matrix`.
- Updated existing `defaults` and `waf-aligned` test scenarios for the new typed parameter interface.

### Breaking Changes

- All flat parameters have been replaced by 9 typed configuration objects. Existing deployments referencing old flat parameter names must migrate to the new typed config properties. See the mapping below:
  - `vmSize`, `adminUsername`, `adminPassword`, `deployJumpHost`, `vmJumpboxOSType`, `vmAuthenticationType`, `bastionResourceId`, `vm*` image/disk/maintenance params → `jumpboxConfig`
  - `vnetSpokeAddressSpace`, `subnet*`, `vnetHubResourceId`, `firewallInternalIp`, `networkingOption`, `enableEgressLockdown`, `dnsServers`, `ddos*`, `vnet*` → `spokeNetworkConfig`
  - `webAppPlanSku`, `zoneRedundant`, `webAppBaseOs`, `existingAppServicePlanId`, `sku*`, `perSiteScaling`, `maximumElasticWorkerCount`, `targetWorker*`, `appServicePlan*` → `servicePlanConfig`
  - `webAppKind`, `httpsOnly`, `clientCert*`, `disableBasicPublishingCredentials`, `webAppPublicNetworkAccess`, `siteConfig`, `containerImageName`, `containerRegistry*`, `webApp*` → `appServiceConfig`
  - `keyVault*` → `keyVaultConfig`
  - `appInsights*` → `appInsightsConfig`
  - `appGateway*` → `appGatewayConfig`
  - `frontDoor*`, `enableDefaultWafMethodBlock`, `wafCustomRules`, `autoApproveAfdPrivateEndpoint` → `frontDoorConfig`
  - `ase*` → `aseConfig`
- Removed intermediate orchestrator modules (`app-service.module.bicep`, `ase.module.bicep`, `deploy.spoke.bicep`, `deploy.supporting-services.bicep`). Consumers referencing these child modules directly must update to use `main.bicep`.
- Log Analytics workspace is no longer created by this module. Provide an existing workspace resource ID via the `logAnalyticsWorkspaceResourceId` parameter.

###

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
