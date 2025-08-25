# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/network/bastion-host/CHANGELOG.md).

## 0.8.0

### Changes

- Updated `lockType` to 'avm-common-types' version `0.6.1`, enabling custom notes for locks.
- Added missing properties of the `publicIPAddressObject` parameter, allowing for more control over public IP address settings.
- Added strong typing for the `publicIPAddressObject` parameter, improving validation and IntelliSense support.
- Updated `roleAssignmentType` and `diagnosticSettingLogsOnlyType` to 'avm-common-types' version `0.6.1`

### Breaking Changes

- The property `publicIPAddressObject.zones` has been renamed to `publicIPAddressObject.availabilityZones` as a result of referencing an updated version of the 'public-ip-address' module.
- The property `publicIPAddressObject.allocationMethod` has been renamed to `publicIPAddressObject.publicIPAllocationMethod` in accordance with the updated 'public-ip-address' module.
- Default value of the `availabilityZones` parameter has been reverted back to an empty array `[]` as Availability Zones are currently in preview and only available in certain regions.

## 0.7.0

### Changes

- Updated ReadMe with AzAdvertizer reference

### Breaking Changes

- Renamed `zones` to `availabilityZones` parameter
- Changed default of `availabilityZones` to `[1,2,3]`

## 0.6.1

### Changes

- Initial version

### Breaking Changes

- None
