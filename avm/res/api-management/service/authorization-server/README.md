# API Management Service Authorization Servers `[Microsoft.ApiManagement/service/authorizationServers]`

This module deploys an API Management Service Authorization Server.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/authorizationServers` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/authorizationServers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationEndpoint`](#parameter-authorizationendpoint) | string | OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>. |
| [`clientId`](#parameter-clientid) | securestring | Client or app ID registered with this authorization server. |
| [`clientSecret`](#parameter-clientsecret) | securestring | Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |
| [`grantTypes`](#parameter-granttypes) | array | Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials. |
| [`name`](#parameter-name) | string | Identifier of the authorization server. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationMethods`](#parameter-authorizationmethods) | array | HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE. |
| [`bearerTokenSendingMethods`](#parameter-bearertokensendingmethods) | array | Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query. |
| [`clientAuthenticationMethod`](#parameter-clientauthenticationmethod) | array | Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body. |
| [`clientRegistrationEndpoint`](#parameter-clientregistrationendpoint) | string | Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced. |
| [`defaultScope`](#parameter-defaultscope) | string | Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values. |
| [`resourceOwnerPassword`](#parameter-resourceownerpassword) | string | Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password. |
| [`resourceOwnerUsername`](#parameter-resourceownerusername) | string | Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username. |
| [`serverDescription`](#parameter-serverdescription) | string | Description of the authorization server. Can contain HTML formatting tags. |
| [`supportState`](#parameter-supportstate) | bool | If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security. |
| [`tokenBodyParameters`](#parameter-tokenbodyparameters) | array | Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object. |
| [`tokenEndpoint`](#parameter-tokenendpoint) | string | OAuth token endpoint. Contains absolute URI to entity being referenced. |

### Parameter: `authorizationEndpoint`

OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>.

- Required: Yes
- Type: string

### Parameter: `clientId`

Client or app ID registered with this authorization server.

- Required: Yes
- Type: securestring

### Parameter: `clientSecret`

Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.

- Required: Yes
- Type: securestring

### Parameter: `grantTypes`

Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials.

- Required: Yes
- Type: array

### Parameter: `name`

Identifier of the authorization server.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `authorizationMethods`

HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'GET'
  ]
  ```

### Parameter: `bearerTokenSendingMethods`

Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'authorizationHeader'
  ]
  ```

### Parameter: `clientAuthenticationMethod`

Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'Basic'
  ]
  ```

### Parameter: `clientRegistrationEndpoint`

Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.

- Required: No
- Type: string
- Default: `''`

### Parameter: `defaultScope`

Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values.

- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceOwnerPassword`

Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.

- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceOwnerUsername`

Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.

- Required: No
- Type: string
- Default: `''`

### Parameter: `serverDescription`

Description of the authorization server. Can contain HTML formatting tags.

- Required: No
- Type: string
- Default: `''`

### Parameter: `supportState`

If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tokenBodyParameters`

Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tokenEndpoint`

OAuth token endpoint. Contains absolute URI to entity being referenced.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service authorization server. |
| `resourceGroupName` | string | The resource group the API management service authorization server was deployed into. |
| `resourceId` | string | The resource ID of the API management service authorization server. |
