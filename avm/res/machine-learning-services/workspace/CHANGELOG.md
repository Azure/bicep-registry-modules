# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/machine-learning-services/workspace/CHANGELOG.md).

## 0.15.0

### Changes

- Added workspace network ACLs, data isolation, legacy mode, and resource-group role assignment controls.
- Expanded managed networking and connection configuration options.
- Improved input validation for compute configurations, service-managed resource settings, shared private links, and tags.

### Breaking Changes

- Removed `ipAllowlist`. Use `networkAcls` with `defaultAction: 'Deny'` and allowed IP ranges in `ipRules[*].value` instead.
- Removed `discoveryUrl`.
- Removed `connections[*].value`. Remove this property from connection configurations before upgrading.

## 0.14.2

### Changes

- Regenerated ARM template artifacts with Bicep 0.48.1 without changing resource configuration.

### Breaking Changes

- None

## 0.14.1

### Changes

- Added the customer-managed key's user-assigned identity to the resource's managed identities.
- Updated the Key Vault API version used for customer-managed key references.

### Breaking Changes

- None

## 0.14.0

### Changes

- None

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

## 0.13.2

### Changes

- Publishing child module `avm/res/machine-learning-services/workspace/compute`
- Publishing child module `avm/res/machine-learning-services/workspace/connection`
- Publishing child module `avm/res/machine-learning-services/workspace/datastore`

### Breaking Changes

- None

## 0.13.1

### Changes

- Recompiled the template with latest Bicep version `0.42.1.51946`

### Breaking Changes

- None

## 0.13.0

### Changes

- Add support for datastores
- Updated ReadMe with AzAdvertizer reference
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.12.1

### Changes

- Initial version

### Breaking Changes

- None
