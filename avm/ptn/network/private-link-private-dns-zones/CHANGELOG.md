# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/network/private-link-private-dns-zones/CHANGELOG.md).

## 0.7.0

### Changes

- Added Cosmos DB MongoDB vCore zone `privatelink.mongocluster.cosmos.azure.com`
- Added Monitor Managed Prometheus zone `privatelink.{regionName}.prometheus.monitor.azure.com`
- Removed ACR data zone `{regionName}.data.privatelink.azurecr.io`

### Breaking Changes

- Removed ACR data zone `{regionName}.data.privatelink.azurecr.io`
  - Shouldn't be needed as entry should be made into the main ACR zone `privatelink.azurecr.io` instead
  - If still needed please add to `additionalPrivateLinkPrivateDnsZonesToInclude` parameter input

## 0.6.0

### Changes

- Initial version of changelog
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
