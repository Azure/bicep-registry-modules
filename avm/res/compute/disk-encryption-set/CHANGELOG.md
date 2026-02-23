# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/compute/disk-encryption-set/CHANGELOG.md).

## 0.6.1

### Changes

- Small bugfix that ensures the module works if the DiskEncryptionSet and the Key Vault it uses are in different subscriptions. If the case, the `sourceVault` property is not passed into the deployment.

### Breaking Changes

- None

## 0.6.0

### Changes

- Added support for managed HSM customer-managed key encryption
- Added `ConfidentialVmEncryptedWithCustomerKey` as `encryptionType` option

### Breaking Changes

- Key Vault permissions are now optional and controlled by the new parameter `enableKeyPermissions`, which defaults to `false`. To maintain the previous behavior after this breaking change, set `enableKeyPermissions = true` in your configuration.
- The four input parameters (`keyVaultResourceId`, `keyName`, `keyVersion`, and `rotationToLatestKeyVersionEnabled`) have been replaced with a single `customerManagedKey` object, aligning with the AVM Customer-Managed-Key (CMK) interface.

## 0.5.0

### Changes

- Updated common types to 'avm-common-types version' `0.6.1`
- Updated to the newest API versions
- Fixed description of the `keyName` parameter

### Breaking Changes

- None

## 0.4.2

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `tags` parameter

### Breaking Changes

- None

## 0.4.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
