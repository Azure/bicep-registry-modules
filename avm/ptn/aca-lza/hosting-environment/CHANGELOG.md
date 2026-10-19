# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/aca-lza/hosting-environment/CHANGELOG.md).

## 0.7.0

### Changes

- Replaced legacy Docker Content Trust with a private-registry sample image signed by a non-exportable Key Vault key and strictly verified with Notation before deployment.
- Preserved quarantine and added native trusted, unsigned, tampered and untrusted-root verification coverage to the existing WAF fixture.

### Breaking Changes

- Docker Content Trust is no longer enabled. Other consuming pipelines must configure approved Notation publisher trust and verify the exact image digest; this sample gate is not an ACA runtime admission policy.

## 0.6.4

### Changes

- Updated Key Vault API references to `2026-02-01`.
- Updated the Key Vault module dependency to `0.14.2`.
- Moved the storage-key export to the Key Vault secret module `0.1.1` without changing its name or value.

### Breaking Changes

- None

## 0.6.3

### Changes

- Bug Fixes

### Breaking Changes

- None

## 0.6.2

### Changes

- Added and exposed the 'acrGeoReplicationLocations' property for enabling georeplication for the acr registry.

### Breaking Changes

- None

## 0.6.1

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
