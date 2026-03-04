# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/app-service-lza/hosting-environment/CHANGELOG.md).

## 0.2.0

### Changes

- **BREAKING**: Consolidated ~150 flat parameters into 9 typed configuration objects using Bicep user-defined types (`spokeNetworkConfig`, `jumpboxConfig`, `servicePlanConfig`, `appServiceConfig`, `keyVaultConfig`, `appInsightsConfig`, `appGatewayConfig`, `frontDoorConfig`, `aseConfig`). All properties are optional with sensible defaults — callers now pass structured objects instead of individual params.
- **BREAKING**: Renamed `webAppConfig`/`webAppConfigType` to `appServiceConfig`/`appServiceConfigType` to align with Azure service naming.
- Upgraded default Linux jumpbox image from Ubuntu 20.04 (EOL) to Ubuntu 24.04 LTS (`ubuntu-24_04-lts` / `server-gen2`).
- Upgraded default Windows jumpbox image from Server 2016 to Server 2025 (`2025-datacenter-g2`).
- Enabled `encryptionAtHost` by default on jumpbox VMs for WAF alignment.
- Fixed `disableIpMasking` default from `true` to `false` in App Insights to preserve IP masking for privacy/GDPR compliance.
- Fixed `clientAffinityProxyEnabled` default from `true` to `false` to match `clientAffinityEnabled: false`.
- Fixed `appInsightsKind` fallback from empty string to `'web'`.
- Fixed role assignment GUID collision between `approve-afd-pe.module.bicep` and `linux-vm.bicep` by adding unique discriminators.
- Fixed inconsistent Windows jumpbox subnet name (hardcoded `'snet-jumpbox'` → `resourceNames.snetDevOps`).
- Consolidated duplicate `import` statements in `application-gateway.module.bicep` and `front-door.module.bicep`.
- Replaced blanket `#disable-diagnostics BCP318` with scoped comment explaining the suppression.
- Updated Azure CLI version in AFD PE approval script from `2.47.0` to `2.67.0`.
- Updated maintenance window defaults: timezone from `'W. Europe Standard Time'` to `'UTC'`, start date to `'2026-06-16 00:00'`.
- Parameterized jumpbox VM OS images, OS disk size/type, and maintenance window settings (surfaced through `jumpboxConfig`).
- Added typed OS disk storage account type using Bicep string literal union matching the `Microsoft.Compute` schema.
- Added new user-defined types to `shared.types.bicep` for all configuration domains.
- Updated all 8 e2e test scenarios to use the new typed configuration objects.

### Breaking Changes

- All flat VM, networking, Key Vault, App Insights, App Gateway, Front Door, ASE, service plan, and web app parameters have been replaced by typed configuration objects. Existing deployments referencing old flat parameter names must be updated to use the corresponding config object properties.

###

## 0.1.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
