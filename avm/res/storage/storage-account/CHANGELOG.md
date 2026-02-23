# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/storage/storage-account/CHANGELOG.md).

## 0.31.1

### Changes

- Added `provisionedBandwidthMibps` and `provisionedIops` parameters to `file-service/share` for FileStorage (premium file share) accounts
- Updated e2e test `premium-file-share` to cover new provisioned IOPS and bandwidth properties

### Breaking Changes

- None

## 0.31.0

### Changes

- Updated `file-service/share` property `accessTier` to allow for `null`
- Updated default `file-service/share accessTier` to default to `null` when Storage Account sku is in `PremiumV2` family

### Breaking Changes

- Updated `blob-service/container/immutabilityPolicy` write access flags `allowProtectedAppendWrites` and `allowProtectedAppendWritesAll` to default to `false` instead of `true`

## 0.30.0

### Changes

- Updated `publicNetworkAccess` enum to include `SecuredByPerimeter`

### Breaking Changes

- None

## 0.29.0

### Changes

- Added support for managed HSM key encryption

### Breaking Changes

- None

## 0.28.0

### Changes

- Added strict types for `fileServices`, `queueServices`, and `tableServices` inputs
- Updated input `managementPolicyRules` to match underlying strict type `storageAccounts/managementPolicies.properties.policy.rules`
- Added optional input `blobServices.versionDeletePolicyDays` to provide a friendly means of including an auto-created lifecycle policy for deleting blob versions after x days.
- Added optional input `extendedLocationZone` to support Azure Extended Zone region deployment
- Added optional input `objectReplicationPolicies` to support Object Replication policies across storage accounts

### Breaking Changes

- None

## 0.27.1

### Changes

- Added check for immutability when hierarchical namespace is enabled

### Breaking Changes

- None

## 0.27.0

### Changes

- Added type for `blobServices` parameter and its children
- Added support for `immutableStorageWithVersioning` parameter

### Breaking Changes

- Renamed `blobServices.container.immutabilityPolicyProperties` parameter to `immutabilityPolicy`
- Moved `blobServices.container.immutabilityPolicyName` parameter into `blobServices.container.immutabilityPolicy` parameter and implemented its pass thru

## 0.26.2

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.26.1

### Changes

- Added metadata to exported types

### Breaking Changes

- None

## 0.26.0

### Changes

- Addressed diverse warnings
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Changed the type for the `diagnosticSettings` parameter to only support metrics. This matches the implementation of the resource provider.

## 0.25.1

### Changes

- Enabling child module `avm/res/storage/storage-account/file-service/share` for publishing (added telemetry option)

### Breaking Changes

- None

## 0.25.0

### Changes

- None

### Breaking Changes

- Update the `immutabilityPolicy` module name to avoid deployment name conflicts

## 0.24.0

### Changes

- None

### Breaking Changes

- Changed the default value for `enableHierarchicalNamespace` to `null` and changed its type from `bool` to nullable `bool`: `bool?`
  - **Only** if a non-null value is passed to the resource provider, allowing users to completely omitting the parameter

## 0.23.0

### Changes

- Added additional SKU's to support v2 Filestorage

### Breaking Changes

- None

## 0.22.1

### Changes

- Corrected spelling of 'secondaryAccessKey' output

### Breaking Changes

- output name changed from 'secondayAccessKey' to 'secondaryAccessKey'
