# Container App Auth Configs `[Microsoft.App/containerApps/authConfigs]`

This module deploys Container App Auth Configs.

You can reference the module as follows:
```bicep
module containerApp 'br/public:avm/res/app/container-app/auth-config:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.App/containerApps/authConfigs` | 2026-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps_authconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2026-01-01/containerApps/authConfigs)</li></ul> |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerAppName`](#parameter-containerappname) | string | The name of the parent Container App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionSettings`](#parameter-encryptionsettings) | object | The configuration settings of the secrets references of encryption key and signing key for ContainerApp Service Authentication/Authorization. |
| [`globalValidation`](#parameter-globalvalidation) | object | The configuration settings that determines the validation flow of users using Service Authentication and/or Authorization. |
| [`httpSettings`](#parameter-httpsettings) | object | The configuration settings of the HTTP requests for authentication and authorization requests made against ContainerApp Service Authentication/Authorization. |
| [`identityProviders`](#parameter-identityproviders) | object | The configuration settings of each of the identity providers used to configure ContainerApp Service Authentication/Authorization. |
| [`login`](#parameter-login) | object | The configuration settings of the login flow of users using ContainerApp Service Authentication/Authorization. |
| [`platform`](#parameter-platform) | object | The configuration settings of the platform of ContainerApp Service Authentication/Authorization. |

### Parameter: `containerAppName`

The name of the parent Container App. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionSettings`

The configuration settings of the secrets references of encryption key and signing key for ContainerApp Service Authentication/Authorization.

- Required: No
- Type: object

### Parameter: `globalValidation`

The configuration settings that determines the validation flow of users using Service Authentication and/or Authorization.

- Required: No
- Type: object

### Parameter: `httpSettings`

The configuration settings of the HTTP requests for authentication and authorization requests made against ContainerApp Service Authentication/Authorization.

- Required: No
- Type: object

### Parameter: `identityProviders`

The configuration settings of each of the identity providers used to configure ContainerApp Service Authentication/Authorization.

- Required: No
- Type: object

### Parameter: `login`

The configuration settings of the login flow of users using ContainerApp Service Authentication/Authorization.

- Required: No
- Type: object

### Parameter: `platform`

The configuration settings of the platform of ContainerApp Service Authentication/Authorization.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the set of Container App Auth configs. |
| `resourceGroupName` | string | The resource group containing the set of Container App Auth configs. |
| `resourceId` | string | The resource ID of the set of Container App Auth configs. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
