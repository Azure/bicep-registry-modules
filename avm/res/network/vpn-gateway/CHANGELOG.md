# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/vpn-gateway/CHANGELOG.md).

## 0.3.0

### Changes

- Updated 'avm-common-types' references to `0.7.0`
- Added `secure()` to `sharedKey` references

### Breaking Changes

- Removed all user-defined types that represented the API in favor of resource-derived types
  - `bgpSettingsType`
  - `nat-rule.vpnNatRuleMappingType`
  - `vpn-connection.ipsecPolicyType`
  - `vpn-connection.trafficSelectorPolicyType`
  - `vpn-connection.vpnSiteLinkConnectionType`
  - `vpn-connection.routingConfigurationType`

  which only has an impact on which types are exported, not the way the parameters are used

## 0.2.2

### Changes

- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.2.1

### Changes

- Added bgpPeeringAddress property to bgpSettingsType
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None

## 0.2.0

### Changes

- Initial version

### Breaking Changes

- None
