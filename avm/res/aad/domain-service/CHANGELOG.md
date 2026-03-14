# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/aad/domain-service/CHANGELOG.md).

## 0.6.0

### Changes

- Updates Resource Provider version to `2025-06-01`
- Adds `syncOnPremSamAccountName` property

### Breaking Changes

- None

## 0.5.0

### Changes

- Updated `avm-common-types` to `0.6.1`

### Breaking Changes

- TLS 1.0/1.1 has been deprecated and the property `tlsV1` can't be enabled anymore. [How to migrate to Transport Layer Security (TLS) 1.2 enforcement for Microsoft Entra Domain Services](https://learn.microsoft.com/en-us/entra/identity/domain-services/reference-domain-services-tls-enforcement)

## 0.4.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Changed default of `pfxCertificate` & `pfxCertificatePassword` parameters to nullable

### Breaking Changes

- None

## 0.4.0

### Changes

- WAF reliability compatibility
- SKU defaults to Enterprise
- `syncScope` property added
- Resource provider updates
- `Tags` property not an object anymore
- Rebranding to Microsoft Entra
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.3.2

### Changes

- Updated UDTs (RoleAssignments, DiagnosticsSettings, Locks) to use AVM common type
- Configured `replicaSetType` to be exportable

### Breaking Changes

- None

## 0.3.1

### Changes

- Removed unused owner metadata

### Breaking Changes

- None

## 0.3.0

### Changes

- Roleassignment update to align to the latest specs. Added the optional name parameter.

### Breaking Changes

- None

## 0.2.1

### Changes

- Resource Provider version update for AVM Telemetry

### Breaking Changes

- None

## 0.2.0

### Changes

- TLSV1 is disabled by default
- Kerberos RC4 is disabled by default

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial Release

### Breaking Changes

- None
