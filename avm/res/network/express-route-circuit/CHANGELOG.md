# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/express-route-circuit/CHANGELOG.md).

## 0.6.1

### Changes

- Added type for `tags` parameter
- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.
- Updated API version for `Microsoft.Network/expressRouteCircuits` to 2024-07-01.
- Added support for `globalReachEnabled` parameter in the module.
- Introduced detailed peering configurations including IPv6 settings.
- Introduced resource defined types for peerings.

### Breaking Changes

- Introduced resource defined types for peerings. This requires the use of a "properties:{}" object when defining the peering. The following is an example of an updated peerings entry:

```bicep
{
  name: 'AzurePrivatePeering'
  properties: {
    peeringType: 'AzurePrivatePeering'
    peerASN: 65001
    primaryPeerAddressPrefix: '10.0.0.0/30'
    secondaryPeerAddressPrefix: '10.0.0.4/30'
    vlanId: 100
    state: 'Enabled'
    ipv6PeeringConfig: {
      primaryPeerAddressPrefix: '2001:db8::/126'
      secondaryPeerAddressPrefix: '2001:db8::8/126'
    }
  }
}
```

## 0.6.1

### Changes

- Updated LockType to 'avm-common-types version' `0.6.0`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.6.0

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
