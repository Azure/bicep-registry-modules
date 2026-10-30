# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/data-factory/factory/CHANGELOG.md).

## 0.13.0

### Changes

- Fixed the Git repository configuration being silently discarded by the resource provider. The configuration is now passed through as a single object that is typed against the resource provider schema, so only properties belonging to the selected repository type can be supplied.
- Replaced the `gitConfigureLater` flag and the flat `git*` parameters with a single optional `gitConfiguration` parameter. Omitting it deploys the Data Factory without a Git repository configuration.
- Updated the telemetry deployment to API version `2025-04-01`.
- Updated the telemetry identifier to the prefix published in the AVM module index.
- Updated the referenced `avm/res/network/private-endpoint` module to version `0.12.1`.

### Breaking Changes

- The parameters `gitConfigureLater`, `gitRepoType`, `gitAccountName`, `gitProjectName`, `gitRepositoryName`, `gitCollaborationBranch`, `gitDisablePublish`, `gitRootFolder`, `gitHostName`, `gitLastCommitId` and `gitTenantId` were removed and replaced by the `gitConfiguration` parameter.
- `collaborationBranch` and `rootFolder` no longer default to `'main'` and `'/'`. Both are required by the resource provider and must be supplied explicitly whenever a Git repository configuration is used.

  Before:

  ```bicep
  gitConfigureLater: false
  gitRepoType: 'FactoryVSTSConfiguration'
  gitAccountName: 'contoso'
  gitProjectName: 'contoso-adf'
  gitRepositoryName: 'contoso-adf-repo'
  gitCollaborationBranch: 'main'
  gitRootFolder: '/'
  ```

  After:

  ```bicep
  gitConfiguration: {
    type: 'FactoryVSTSConfiguration'
    accountName: 'contoso'
    projectName: 'contoso-adf'
    repositoryName: 'contoso-adf-repo'
    collaborationBranch: 'main'
    rootFolder: '/'
  }
  ```

  Deployments that relied on `gitConfigureLater` defaulting to `true` require no change - omitting `gitConfiguration` preserves the existing behaviour.

## 0.12.1

### Changes

- Added the customer-managed key's user-assigned identity to the resource's managed identities.
- Updated the Key Vault API version used for customer-managed key references.

### Breaking Changes

- None

## 0.12.0

### Changes

- None

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

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
