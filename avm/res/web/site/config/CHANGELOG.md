# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/web/site/config/CHANGELOG.md).

## 0.2.1

### Changes

- Recompiled templates with latest Bicep version `0.39.26.7824`

### Breaking Changes

- None

## 0.2.0

### Changes

- None

### Breaking Changes

- Added additional setting `ApplicationInsightsAgent_EXTENSION_VERSION` for configs of type `appsettings` that is automatically set if the parameter `applicationInsightResourceId` is provided and no custom `ApplicationInsightsAgent_EXTENSION_VERSION` is configured via the config's `properties` parameter. It automatically selects `~3` for Linux sites & `~2` for Windows.

## 0.1.1

### Changes

- Recompiled templates with latest Bicep version `0.38.33.2757`

### Breaking Changes

- None


## 0.1.0

### Changes

- Initial version

### Breaking Changes

- None
