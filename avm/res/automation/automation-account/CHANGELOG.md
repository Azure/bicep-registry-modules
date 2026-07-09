# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/automation/automation-account/CHANGELOG.md).

## 0.19.1

### Changes

- Publishing child module `avm/res/automation/automation-account/credential`
- Publishing child module `avm/res/automation/automation-account/hybrid-runbook-worker-group`
- Publishing child module `avm/res/automation/automation-account/hybrid-runbook-worker-group/hybrid-runbook-worker`
- Publishing child module `avm/res/automation/automation-account/job-schedule`
- Publishing child module `avm/res/automation/automation-account/module`
- Publishing child module `avm/res/automation/automation-account/powershell72-module`
- Publishing child module `avm/res/automation/automation-account/python2-package`
- Publishing child module `avm/res/automation/automation-account/python3-package`
- Publishing child module `avm/res/automation/automation-account/runbook`
- Publishing child module `avm/res/automation/automation-account/schedule`
- Publishing child module `avm/res/automation/automation-account/source-control`
- Publishing child module `avm/res/automation/automation-account/variable`
- Publishing child module `avm/res/automation/automation-account/webhook`

### Breaking Changes

- None

## 0.19.0

### Changes

- Fixed bug of setting `managedIdentities` with `systemAssigned: false` lead to an error
- Update the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

### Breaking Changes

- None

## 0.18.0

### Changes

- Added support for the `hybridRunbookWorkerGroups` & its workers via the `hybridRunbookWorkerGroups` parameter

### Breaking Changes

- None

## 0.17.2

### Changes

- Fixed small bug with deployment name conflict of `automationAccount_variables` & `automationAccount_sourceControlConfigurations`
- Updated API versions

### Breaking Changes

- None

## 0.17.1

### Changes

- Updated child module deployment names to use stable identifiers instead of `deployment().name` to prevent deployment history accumulation when using Azure Deployment Stacks.

### Breaking Changes

- None

## 0.17.0

### Changes

- Added support for the `sourceControlConfigurations` parameter and a type for the same

### Breaking Changes

- None

## 0.16.1

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.16.0

### Changes

- Adding capability to support `webhook` deployment.

### Breaking Changes

- None

## 0.15.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for tags

### Breaking Changes

- None

## 0.15.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Removed the softwareUpdateConfigurations parameter

## 0.14.1

### Changes

- Initial version

### Breaking Changes

- None

