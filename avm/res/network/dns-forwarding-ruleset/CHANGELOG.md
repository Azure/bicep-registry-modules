# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/dns-forwarding-ruleset/CHANGELOG.md).

## 0.6.0

### Changes

- Fixed forwarding rule metadata to accept an object, matching the child module and Azure API.

### Breaking Changes

- Changed `forwardingRuleType.metadata` from `string?` to `object?`. Pass metadata as an object instead of a string; the previous string type did not match the child module or Azure API.

## 0.5.4

### Changes

- Publishing child module `avm/res/network/dns-forwarding-ruleset/forwarding-rule`
- Publishing child module `avm/res/network/dns-forwarding-ruleset/virtual-network-link`

### Breaking Changes

- None

## 0.5.3

### Changes

- Added type for parameters `tags` & `dnsForwardingRulesetOutboundEndpointResourceIds`
- Updated LockType to 'avm-common-types version' `0.6.1`, enabling custom notes for locks.

### Breaking Changes

- None

## 0.5.2

### Changes

- Initial version
- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- None
