# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/kusto/cluster/CHANGELOG.md).

## 0.11.0

### Changes

- Corrected Kusto database name length constraints to match Azure naming rules (1-260 characters). Removed the invalid `@minLength(4)` and `@maxLength(22)` constraints on the `kustoDatabaseName` parameter of the `database/principal-assignment` child module, which previously prevented deploying principal assignments for databases with short names (e.g. "Hub"). Added `@maxLength(260)` to the `name` parameter of the `database` child module and to `kustoDatabaseName` in `database/principal-assignment` to enforce the correct upper bound.

### Breaking Changes

- Updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

## 0.10.0

### Changes

- Updated 'kustoClusterPrincipalAssignment' resource name to use a combination of 'principalId' and 'role' for uniqueness.

### Breaking Changes

- The `kustoClusterPrincipalAssignment` resource name changed from `principalId` to `uniqueString(principalId, role)`. Existing principal assignments will be orphaned and may need to be manually removed before redeploying.

## 0.9.2

### Changes

- Added missing role option 'AllDatabasesAdmin' to allowed values in 'role' parameter.

### Breaking Changes

- None

## 0.9.1

### Changes

- Added missing role option 'AllDatabasesMonitor' to 'role' parameter in 'kustoClusterRoleAssignment' object type.
- Updated 'zones' property assignment to handle empty 'availabilityZones' parameter correctly.

### Breaking Changes

- None

## 0.9.0

### Changes

- Updated all 'avm-common-types' references to version 0.6.1
- Updated avm/res/network/private-endpoint cross-referenced module to version 0.11.1

### Breaking Changes

- Replacing `enableZoneRedundant` with `availabilityZones` parameter.
  Per best practice, the default is to deploy to all zones, i.e., to avoid this, set the value to of `availabilityZones` to `[]`

## 0.8.0

### Changes

- Updates RP API versions.

### Breaking Changes

- Removes default value requirement for capacity as it's not needed with the current auto-scale settings

## 0.7.3

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.7.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
