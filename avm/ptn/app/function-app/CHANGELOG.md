# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/ptn/app/function-app/CHANGELOG.md).

## 0.1.0

### Changes

- Initial release of the Function App pattern module, including an App Service Plan, runtime Storage Account, Application Insights component, Log Analytics workspace and User-Assigned Managed Identity.
- Supports Flex Consumption (the default), Consumption, Elastic Premium and Dedicated hosting plans.
- Uses managed identity for runtime storage access and supports reusing an existing User-Assigned Managed Identity and Log Analytics workspace by resource ID.
- Applies HTTPS-only, TLS 1.2 minimum, disabled FTP/FTPS publishing and disabled anonymous blob access. Private networking is outside the module's scope.

### Breaking Changes

- None
