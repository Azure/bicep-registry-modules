# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utl/types/avm-common-types/CHANGELOG.md).

## 0.6.0

### Changes

- Added `notes` as an optional property to the `lockType`

### Breaking Changes

- None

## 0.5.1

### Changes

- When introducing the `resourceGroupResourceId` property, the `resourceGroupName` property was not removed from the `privateEndpointMultiServiceType` and  privateEndpointSingleServiceType` types.

### Breaking Changes

- None

## 0.5.0

### Changes

- Adds `resourceGroupResourceId` to the private endpoint type

### Breaking Changes

- None

## 0.4.0

### Changes

- Change autorotation parameter name from `autorotationDisabled `to `autorotationEnabled`

### Breaking Changes

- None

## 0.3.0

### Changes

- Added additional variant of CMK UDT for resources supporting auto-rotation

### Breaking Changes

- None

## 0.2.1

### Changes

- Common-Types: Fixed incorrect parameter description: The FQDN parameter is optional, yet the description said it was required.
- Diverse: Fixed metadata descriptions
- Fixed static test validating parameter descriptions
- It checked for a line that looke like ('Required. even though the value of the $description variable at the time only has the description's value, that is Required.
- Added test that tests the reverse, that is, that a parameter's description starts with Required. in its title if it is required

### Breaking Changes

- None

## 0.2.0

### Changes

- Added missing `export()` annotation

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
