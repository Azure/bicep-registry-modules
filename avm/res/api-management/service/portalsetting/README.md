# API Management Service Portal Settings `[Microsoft.ApiManagement/service/portalsettings]`

This module deploys an API Management Service Portal Setting.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/portalsettings` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/portalsettings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Portal setting name. |
| [`properties`](#parameter-properties) | object | Portal setting properties. Strings may be left empty, but must not be omitted. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | Required if the template is used in a standalone deployment. The name of the parent API Management service. |

### Parameter: `name`

Portal setting name.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'delegation'
    'signin'
    'signup'
  ]
  ```

### Parameter: `properties`

Portal setting properties. Strings may be left empty, but must not be omitted.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-propertiesenabled) | bool | 'signin': Redirect Anonymous users to the Sign-In page. 'signup': Allow users to sign up on a developer portal. |
| [`subscriptions`](#parameter-propertiessubscriptions) | object | Subscriptions delegation settings. |
| [`termsOfService`](#parameter-propertiestermsofservice) | object | Terms of service contract properties. |
| [`url`](#parameter-propertiesurl) | string | A delegation Url. |
| [`userRegistration`](#parameter-propertiesuserregistration) | object | User registration delegation settings. |
| [`validationKey`](#parameter-propertiesvalidationkey) | securestring | A base64-encoded validation key to validate, that a request is coming from Azure API Management. |

### Parameter: `properties.enabled`

'signin': Redirect Anonymous users to the Sign-In page. 'signup': Allow users to sign up on a developer portal.

- Required: Yes
- Type: bool

### Parameter: `properties.subscriptions`

Subscriptions delegation settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-propertiessubscriptionsenabled) | bool | Enable or disable delegation for subscriptions. |

### Parameter: `properties.subscriptions.enabled`

Enable or disable delegation for subscriptions.

- Required: Yes
- Type: bool

### Parameter: `properties.termsOfService`

Terms of service contract properties.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consentRequired`](#parameter-propertiestermsofserviceconsentrequired) | bool | Ask user for consent to the terms of service. |
| [`enabled`](#parameter-propertiestermsofserviceenabled) | bool | Display terms of service during a sign-up process. |
| [`text`](#parameter-propertiestermsofservicetext) | string | A terms of service text. |

### Parameter: `properties.termsOfService.consentRequired`

Ask user for consent to the terms of service.

- Required: Yes
- Type: bool

### Parameter: `properties.termsOfService.enabled`

Display terms of service during a sign-up process.

- Required: Yes
- Type: bool

### Parameter: `properties.termsOfService.text`

A terms of service text.

- Required: Yes
- Type: string

### Parameter: `properties.url`

A delegation Url.

- Required: Yes
- Type: string

### Parameter: `properties.userRegistration`

User registration delegation settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-propertiesuserregistrationenabled) | bool | Enable or disable delegation for user registration. |

### Parameter: `properties.userRegistration.enabled`

Enable or disable delegation for user registration.

- Required: Yes
- Type: bool

### Parameter: `properties.validationKey`

A base64-encoded validation key to validate, that a request is coming from Azure API Management.

- Required: Yes
- Type: securestring

### Parameter: `apiManagementServiceName`

Required if the template is used in a standalone deployment. The name of the parent API Management service.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service portal setting. |
| `resourceGroupName` | string | The resource group the API management service portal setting was deployed into. |
| `resourceId` | string | The resource ID of the API management service portal setting. |
