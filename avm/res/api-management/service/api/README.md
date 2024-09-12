# API Management Service APIs `[Microsoft.ApiManagement/service/apis]`

This module deploys an API Management Service API.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apis` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/diagnostics` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/diagnostics) |
| `Microsoft.ApiManagement/service/apis/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/policies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | API name. Must be 1 to 300 characters long. |
| [`name`](#parameter-name) | string | API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. |
| [`path`](#parameter-path) | string | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`loggerName`](#parameter-loggername) | string | The name of the API management service logger. Required if using api/diagnostics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiDescription`](#parameter-apidescription) | string | Description of the API. May include HTML formatting tags. |
| [`apiRevision`](#parameter-apirevision) | string | Describes the Revision of the API. If no value is provided, default revision 1 is created. |
| [`apiRevisionDescription`](#parameter-apirevisiondescription) | string | Description of the API Revision. |
| [`apiType`](#parameter-apitype) | string | Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API. |
| [`apiVersion`](#parameter-apiversion) | string | Indicates the Version identifier of the API if the API is versioned. |
| [`apiVersionDescription`](#parameter-apiversiondescription) | string | Description of the API Version. |
| [`apiVersionSetId`](#parameter-apiversionsetid) | string | Indicates the Version identifier of the API version set. |
| [`authenticationSettings`](#parameter-authenticationsettings) | object | Collection of authentication settings included into this API. |
| [`diagnostics`](#parameter-diagnostics) | array | Array of diagnostics to apply to the Service API. |
| [`format`](#parameter-format) | string | Format of the Content in which the API is getting imported. |
| [`isCurrent`](#parameter-iscurrent) | bool | Indicates if API revision is current API revision. |
| [`policies`](#parameter-policies) | array | Array of Policies to apply to the Service API. |
| [`protocols`](#parameter-protocols) | array | Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS. |
| [`serviceUrl`](#parameter-serviceurl) | string | Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long. |
| [`sourceApiId`](#parameter-sourceapiid) | string | API identifier of the source API. |
| [`subscriptionKeyParameterNames`](#parameter-subscriptionkeyparameternames) | object | Protocols over which API is made available. |
| [`subscriptionRequired`](#parameter-subscriptionrequired) | bool | Specifies whether an API or Product subscription is required for accessing the API. |
| [`type`](#parameter-type) | string | Type of API. |
| [`value`](#parameter-value) | string | Content value when Importing an API. |
| [`wsdlSelector`](#parameter-wsdlselector) | object | Criteria to limit import of WSDL to a subset of the document. |

### Parameter: `displayName`

API name. Must be 1 to 300 characters long.

- Required: Yes
- Type: string

### Parameter: `name`

API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.

- Required: Yes
- Type: string

### Parameter: `path`

Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `loggerName`

The name of the API management service logger. Required if using api/diagnostics.

- Required: No
- Type: string
- Default: `''`

### Parameter: `apiDescription`

Description of the API. May include HTML formatting tags.

- Required: No
- Type: string

### Parameter: `apiRevision`

Describes the Revision of the API. If no value is provided, default revision 1 is created.

- Required: No
- Type: string

### Parameter: `apiRevisionDescription`

Description of the API Revision.

- Required: No
- Type: string

### Parameter: `apiType`

Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API.

- Required: No
- Type: string
- Default: `'http'`
- Allowed:
  ```Bicep
  [
    'graphql'
    'http'
    'soap'
    'websocket'
  ]
  ```

### Parameter: `apiVersion`

Indicates the Version identifier of the API if the API is versioned.

- Required: No
- Type: string

### Parameter: `apiVersionDescription`

Description of the API Version.

- Required: No
- Type: string

### Parameter: `apiVersionSetId`

Indicates the Version identifier of the API version set.

- Required: No
- Type: string

### Parameter: `authenticationSettings`

Collection of authentication settings included into this API.

- Required: No
- Type: object

### Parameter: `diagnostics`

Array of diagnostics to apply to the Service API.

- Required: No
- Type: array

### Parameter: `format`

Format of the Content in which the API is getting imported.

- Required: No
- Type: string
- Default: `'openapi'`
- Allowed:
  ```Bicep
  [
    'openapi'
    'openapi-link'
    'openapi+json'
    'openapi+json-link'
    'swagger-json'
    'swagger-link-json'
    'wadl-link-json'
    'wadl-xml'
    'wsdl'
    'wsdl-link'
  ]
  ```

### Parameter: `isCurrent`

Indicates if API revision is current API revision.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `policies`

Array of Policies to apply to the Service API.

- Required: No
- Type: array

### Parameter: `protocols`

Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'https'
  ]
  ```

### Parameter: `serviceUrl`

Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.

- Required: No
- Type: string

### Parameter: `sourceApiId`

API identifier of the source API.

- Required: No
- Type: string

### Parameter: `subscriptionKeyParameterNames`

Protocols over which API is made available.

- Required: No
- Type: object

### Parameter: `subscriptionRequired`

Specifies whether an API or Product subscription is required for accessing the API.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `type`

Type of API.

- Required: No
- Type: string
- Default: `'http'`
- Allowed:
  ```Bicep
  [
    'graphql'
    'http'
    'soap'
    'websocket'
  ]
  ```

### Parameter: `value`

Content value when Importing an API.

- Required: No
- Type: string

### Parameter: `wsdlSelector`

Criteria to limit import of WSDL to a subset of the document.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service API. |
| `resourceGroupName` | string | The resource group the API management service API was deployed to. |
| `resourceId` | string | The resource ID of the API management service API. |
