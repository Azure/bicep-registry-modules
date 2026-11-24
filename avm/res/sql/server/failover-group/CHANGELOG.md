# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/failover-group/CHANGELOG.md).

## 0.1.1

### Changes

- The `readOnlyEndpoint.targetServer` property now also accepts the resource ID of the partner server, supporting partner servers in other resource groups or subscriptions
- The deployment now fails with a descriptive message if the read-write endpoint `failoverPolicy` is `Automatic` and no `failoverWithDataLossGracePeriodMinutes` is provided

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None