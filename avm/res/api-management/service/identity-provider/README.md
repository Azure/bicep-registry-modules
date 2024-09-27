# API Management Service Identity Providers `[Microsoft.ApiManagement/service/identityProviders]`

This module deploys an API Management Service Identity Provider.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/identityProviders` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/identityProviders) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Identity provider name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`clientId`](#parameter-clientid) | string | Client ID of the Application in the external Identity Provider. Required if identity provider is used. |
| [`clientSecret`](#parameter-clientsecret) | securestring | Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedTenants`](#parameter-allowedtenants) | array | List of Allowed Tenants when configuring Azure Active Directory login. - string. |
| [`authority`](#parameter-authority) | string | OpenID Connect discovery endpoint hostname for AAD or AAD B2C. |
| [`clientLibrary`](#parameter-clientlibrary) | string | The client library to be used in the developer portal. Only applies to AAD and AAD B2C Identity Provider. |
| [`passwordResetPolicyName`](#parameter-passwordresetpolicyname) | string | Password Reset Policy Name. Only applies to AAD B2C Identity Provider. |
| [`profileEditingPolicyName`](#parameter-profileeditingpolicyname) | string | Profile Editing Policy Name. Only applies to AAD B2C Identity Provider. |
| [`signInPolicyName`](#parameter-signinpolicyname) | string | Signin Policy Name. Only applies to AAD B2C Identity Provider. |
| [`signInTenant`](#parameter-signintenant) | string | The TenantId to use instead of Common when logging into Active Directory. |
| [`signUpPolicyName`](#parameter-signuppolicyname) | string | Signup Policy Name. Only applies to AAD B2C Identity Provider. |
| [`type`](#parameter-type) | string | Identity Provider Type identifier. |

### Parameter: `name`

Identity provider name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `clientId`

Client ID of the Application in the external Identity Provider. Required if identity provider is used.

- Required: No
- Type: string
- Default: `''`

### Parameter: `clientSecret`

Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `allowedTenants`

List of Allowed Tenants when configuring Azure Active Directory login. - string.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `authority`

OpenID Connect discovery endpoint hostname for AAD or AAD B2C.

- Required: No
- Type: string
- Default: `''`

### Parameter: `clientLibrary`

The client library to be used in the developer portal. Only applies to AAD and AAD B2C Identity Provider.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ADAL'
    'MSAL-2'
  ]
  ```

### Parameter: `passwordResetPolicyName`

Password Reset Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string
- Default: `''`

### Parameter: `profileEditingPolicyName`

Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string
- Default: `''`

### Parameter: `signInPolicyName`

Signin Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string
- Default: `''`

### Parameter: `signInTenant`

The TenantId to use instead of Common when logging into Active Directory.

- Required: No
- Type: string
- Default: `''`

### Parameter: `signUpPolicyName`

Signup Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string
- Default: `''`

### Parameter: `type`

Identity Provider Type identifier.

- Required: No
- Type: string
- Default: `'aad'`
- Allowed:
  ```Bicep
  [
    'aad'
    'aadB2C'
    'facebook'
    'google'
    'microsoft'
    'twitter'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service identity provider. |
| `resourceGroupName` | string | The resource group the API management service identity provider was deployed into. |
| `resourceId` | string | The resource ID of the API management service identity provider. |
