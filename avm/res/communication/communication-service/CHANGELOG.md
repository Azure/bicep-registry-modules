# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/communication/communication-service/CHANGELOG.md).

## 0.4.3

### Changes

- Updated `Microsoft.Communication/communicationServices` API version from `2023-04-01` to `2025-09-01`
- Updated `Microsoft.Resources/deployments` API version from `2024-03-01` to `2025-04-01`
- Updated API version reference in tags parameter from `2025-05-01` to `2025-09-01`
- Updated references to `avm-common-types` module from `0.5.1.` to `0.6.1`

### Breaking Changes

- None

## 0.4.2

### Changes

- Added built-in role definition for 'Communication and Email Service Owner', allowing assigning it by the name.

### Breaking Changes

- None

## 0.4.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type to `tags` parameter

### Breaking Changes

- None

## 0.4.0

### Changes

- Added new `endpoint` output to expose the hostname/endpoint URI of the deployed Communication Service resource
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.3.1

### Changes

- Initial version

### Breaking Changes

- None
