# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/fabric/capacity/CHANGELOG.md).

## 0.2.0

### Changes

- Added automatic pause handling functionality for SKU changes
- Added `enableAutomaticPauseHandling` parameter to control pause state management
- Added `restorePreviousState` parameter to restore original pause state after SKU changes
- Added `managedIdentities` parameter to support deployment scripts for state management
- Enhanced module to handle SKU changes on paused/suspended capacities without manual intervention

### Breaking Changes

- None (all new parameters have default values that maintain existing behavior)

## 0.1.1

### Changes

- Initial version

### Breaking Changes

- None
