# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/CHANGELOG.md).

## 0.23.0

### Changes

- Fixed `roleAssignments` of `elasticPools` not being passed to the `elastic-pool` child module
- Marked the `storageAccountAccessKey` property of the `securityAlertPolicies` type as `@secure()` to avoid exposing it in the deployment history
- Added the `diagnosticSettings` parameter, applied to the server's `master` database. Required to route server-level audit logs (`SQLSecurityAuditEvents`) to a Log Analytics workspace or Event Hub
- Added the `expressVulnerabilityAssessmentState` parameter to configure the express configuration of SQL vulnerability assessment (no storage account required)
- Added `roleAssignments` support to the `databases` parameter
- Added `diagnosticSettings` support to the `elasticPools` parameter
- Added the `databases` and `elasticPools` outputs
- The `primaryUserAssignedIdentityResourceId` now defaults to the user-assigned identity, if exactly one is provided
- The `administrators` property is only set if the `administrators` parameter is provided
- Managed HSM key URIs are now derived from the cloud environment instead of being hardcoded to the Azure public cloud, and the HSM detection is case-insensitive
- Added validations for missing administrator configuration, multiple user-assigned identities without a primary identity, secrets export without an administrator password, and combining the classic and express vulnerability assessment configurations
- Consolidated the customer-managed key URI logic into a single variable
- Fixed the `name` description of the `databaseType` and clarified the `auditSettings` description
- Updated the `tags` types to API version `2025-01-01`
- Updated `avm-common-types` to version `0.7.0` across the module
- Updated the child modules `auditing-setting`, `database`, `database/backup-long-term-retention-policy`, `elastic-pool`, `encryption-protector`, `failover-group` and `vulnerability-assessment` (see their changelogs)
- Updated the WAF-aligned test to disable public network access, use zone-redundant backup storage, send diagnostics/audit logs to Log Analytics and use the express vulnerability assessment configuration

### Breaking Changes

- Removed `1.0` and `1.1` from the allowed values of `minimalTlsVersion`, as TLS 1.0 and 1.1 are retired for Azure SQL Database
- The `publicNetworkAccess` parameter is now nullable and no longer accepts an empty string (`''`). Omit the parameter instead
- The deployment now fails if neither `administratorLogin` nor `administrators` is provided
- The deployment now fails if more than one user-assigned identity is provided without a `primaryUserAssignedIdentityResourceId`
- Removed the ignored `enableTelemetry` property from all child resource types (e.g., `databases`, `elasticPools`, `firewallRules`, `auditSettings`)
- The `timeBasedImmutabilityMode` of the database long-term backup retention policy now defaults to `Unlocked` (instead of `Locked`) if time-based immutability is enabled

## 0.22.1

### Changes

- Added support for time-based immutability settings in database backup long-term retention policy module
- Added types for tags parameters

### Breaking Changes

- None

## 0.22.0

### Changes

- For child-module `database`, updated the diagnostic implementation to avoid automatically enabling both metrics and logs when only one is specified.

### Breaking Changes

- None

## 0.21.4

### Changes

- Enabled child modules `avm/res/sql/server/auditing-setting`, `avm/res/sql/server/elastic-pool`, `avm/res/sql/server/encryption-protector`, `avm/res/sql/server/failover-group`, `avm/res/sql/server/firewall-rule`, `avm/res/sql/server/key`, `avm/res/sql/server/security-alert-policy`, `avm/res/sql/server/virtual-network-rule`, `avm/res/sql/server/vulnerability-assessment`, `avm/res/sql/server/database/backup-short-term-retention-policy`, and `avm/res/sql/server/database/backup-long-term-retention-policy` for publishing

### Breaking Changes

- None

## 0.21.3

### Changes

- Fixed server-level customer-managed key autorotation when using a versionless Key Vault key URI
- Added regression coverage for CMK autorotation without an explicit server key version

### Breaking Changes

- None

## 0.21.2

### Changes

- Added suppoort for SQL Server outbound firewall rules

### Breaking Changes

- None

## 0.21.1

### Changes

- Fixed typo in HSM CMK schema implementation

### Breaking Changes

- None

## 0.21.0

### Changes

- Added support for managed HSM customer-managed key encryption for both server and database
- Updated all 'avm-common-types' references to version `0.6.1`
- Updated `avm/res/network/private-endpoint` cross-referenced module to version `0.11.1`

### Breaking Changes

- None

## 0.20.3

### Changes

- Enabling child module `avm/res/sql/server/database` for publishing (added telemetry option)

### Breaking Changes

- None

## 0.20.2

### Changes

- Updated `privateEndpoints` parameter type to 'avm-common-types' `0.6.1`, adding a type to its `tags` property

### Breaking Changes

- None

## 0.20.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.20.0

### Changes

- `tags` parameters are now properly typed instead of using `object` type.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `partnerServers` array to `partnerServerResourceIds` in the failover group module to make it possible to use SQL servers from different resource groups.

## 0.19.1

### Changes

- Initial version

### Breaking Changes

- None
