# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/service-bus/namespace/topic/CHANGELOG.md).

## 0.2.0

### Changes

- Added optional parameter `namespaceSkuName`. When provided, it is used instead of reading the SKU from the existing namespace at deployment time, allowing `what-if` to evaluate `enableExpress` and `maxMessageSizeInKilobytes`.

### Breaking Changes

- None

## 0.1.1

### Changes

- Added publishing criteria to child modules `authorization-rule`, `subscription` and `subscription/rule`.

### Breaking Changes

- None

## 0.1.0

### Changes

- Initial release

### Breaking Changes

- None
