# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/local-network-gateway/CHANGELOG.md).

## 0.4.0

### Changes

- Added type for `tags` parameter
- Updated to latest avm-common-types version, enabling custom notes for locks.
- Added optional property `bgpPeeringAddresses` to `bgpSettings` parameter

### Breaking Changes

- Replaced the `localAddressPrefixes` parameter with the more comprehensive `localNetworkAddressSpace` parameter. To migrate, change your implementation
  ```bicep
  localAddressPrefixes: [
    '192.168.1.0/24'
  ]
  ```
  to
  ```bicep
  localNetworkAddressSpace: {
    addressPrefixes: [
      '192.168.1.0/24'
    ]
  }
  ```

## 0.3.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
