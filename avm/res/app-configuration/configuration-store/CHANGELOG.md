# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app-configuration/configuration-store/CHANGELOG.md).

## 0.9.2

### Changes

- Updated logic for `softDeleteRetentionInDays`: now sets retention to `0` when `sku` is `Developer` (previously only checked for `Free`).
- Updated logic for `enablePurgeProtections`: now sets retention to `false` when `sku` is `Developer` (previously only checked for `Free`).

### Breaking Changes

- None

## 0.9.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.9.0

### Changes

- Updated the API version for `Microsoft.AppConfiguration/configurationStores`, `keyValues`, and `replicas` resources from `2024-05-01` to `2025-02-01-preview` in both Bicep and JSON templates, ensuring support for the latest platform features.
- Upgraded related resource API versions, including telemetry deployments to `2025-04-01` and Key Vault to `2024-12-01-preview`.
- Added support for new pricing tiers: `Developer` and `Premium`, in addition to existing tiers, across documentation, Bicep, and JSON templates.
- Improved handling of Customer Managed Keys (CMK) by using safe navigation operators and more robust property access, increasing reliability when referencing Key Vault resources and identities.
- Added built-in role assignments for `App Configuration Reader` and `App Configuration Contributor`, both in documentation and implementation, allowing finer-grained access control.
- Applied `@batchSize(1)` to the replica deployment module for improved resource management and reliability during parallel deployments.

### Breaking Changes

- None

## 0.8.0

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- Added type for replica location, enabling the specification of the replica name

## 0.7.0

### Changes

- Upgraded to version `0.11.0` of Private-Endpoint module
- Updated interface of `privateEndpoints` parameter to avm-common-types version `0.5.1` which allows defining the additional scope parameter `resourceGroupResourceId` to optionally deploy a private endpoint into a different resource group in the same or different subscription
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Added type for Private Endpoint output to allow discovery
  - Changed the contained property name `customDnsConfig` to `customDnsConfigs` and  `networkInterfaceIds` to `networkInterfaceResourceIds`
- Introduced a type for the `tags` parameter

## 0.6.3

### Changes

- Initial version

### Breaking Changes

- None
