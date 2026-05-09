# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cache/redis/CHANGELOG.md).

## 0.17.2

### Changes

- Publishing child module `avm/res/cache/redis/access-policy`
- Publishing child module `avm/res/cache/redis/access-policy-assignment`
- Publishing child module `avm/res/cache/redis/firewall-rule`
- Publishing child module `avm/res/cache/redis/linked-server`

### Breaking Changes

- None

## 0.17.1

### Changes

- Recompiled the template with latest Bicep version `0.42.1.51946`

### Breaking Changes

- None

## 0.17.0

### Changes

- None

### Breaking Changes

- Aligned zonal interface with AVM spec. This means, the resource, by default, assigns all 3 zones `[1,2,3]` as opposed to running the function `pickZones('Microsoft.Cache', 'redisEnterprise', location, 3)` on the user's behalf. To still achieve this behavior, please invoke this function from your invoking template like `availabilityZones: map(pickZones('Microsoft.Cache', 'redisEnterprise', resourceLocation, 3), zone => int(zone))`. This also means the `zoneRedundant` parameter became obsolete and can be removed.


## 0.16.5

### Changes

- Fixed a bug when deploying multiple `accessPolicies` and `accessPolicyAssignments`
- Fixed `persistence` test to use Managed Identity for connection to Storage Account
- Fixed `passive-geo-replication` test to use latest Az PowerShell module
- Updated resource API versions to use latest versions

### Breaking Changes

- None

## 0.16.4

### Changes

- Fixed an incorrect parameter description
- Added types for the `geoReplicationObject` & `firewallRules` parameters
- Updated the references to the 'avm-common-types' module to it's latest version `0.6.1`

### Breaking Changes

- None

## 0.16.3

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.16.2

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Added type for `tags` parameter
- Removed empty allowed value from `publicNetworkAccess` parameter in favor of nullable

### Breaking Changes

- None

## 0.16.0

### Changes

- Added allowed set `[1,2,3]` to `availabilityZones` parameter.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `zones` parameter to `availabilityZones`

## 0.15.0

### Changes

- Initial version

### Breaking Changes

- None
