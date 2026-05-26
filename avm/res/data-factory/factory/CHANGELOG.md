# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/data-factory/factory/CHANGELOG.md).

## 0.11.3

### Changes

- Added support for deploying linked Self-Hosted Integration Runtime by providing:
```
  integrationRuntimes: [
        {
          name: '<Self-Hosted Integration Runtime name>'
          type: 'SelfHosted'
          linkedResourceRoleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Optional, Defaults to Contributor role for SHIR
          typeProperties: {
            linkedInfo: {
              authorizationType: 'RBAC'
              resourceId: '<Linked Self-Hosted Integration Runtime ResourceId>'
            }
          }
        }
      ]
```

### Breaking Changes

- None

## 0.11.2

### Changes

- Publishing child module `avm/res/data-factory/factory/integration-runtime`
- Publishing child module `avm/res/data-factory/factory/linked-service`
- Publishing child module `avm/res/data-factory/factory/managed-virtual-network`
- Publishing child module `avm/res/data-factory/factory/managed-virtual-network/managed-private-endpoint`

### Breaking Changes

- None

## 0.11.1

### Changes

- Updated 'private-endpoint' reference to `0.12.0`
- Updated all 'avm-common-types' reference to `0.7.0`

### Breaking Changes

- None

## 0.11.0

### Changes

- Added managed HSM customer-managed key support
- Updated all 'avm-common-types' reference to `0.6.1`

### Breaking Changes

- Merged the parameters `managedVirtualNetworkName` & `managedPrivateEndpoints` to the common `managedVirtualNetwork` parameter

## 0.10.6

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.10.5

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.10.4

### Changes

- Added support for Purview Account integration via `purviewResourceId` parameter
- Enhanced Data Factory configuration to include Purview connectivity when specified
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.10.3

### Changes

- Changed the /managed-virtual-network `module managedVirtualNetwork_managedPrivateEndpoint` to so that when referencing properties of resources within the same template, to always use the resource reference (managedVirtualNetwork.name) rather than parameters (previously it was calling the "name" parameter)

### Breaking Changes

- None

## 0.10.2

### Changes

- Initial version

### Breaking Changes

- None
