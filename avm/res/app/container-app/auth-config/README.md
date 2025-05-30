# Container App Auth Configs `[Microsoft.App/containerApps/authConfigs]`

This module deploys Container App Auth Configs.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/containerApps/authConfigs` | [2025-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps/authConfigs) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerAppName`](#parameter-containerappname) | string | The name of the parent Container App. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
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
