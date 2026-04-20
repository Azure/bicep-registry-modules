# API Management Workspace APIs `[Microsoft.ApiManagement/service/workspaces/apis]`

This module deploys an API in an API Management Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service/workspaces/apis` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/diagnostics` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_diagnostics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/diagnostics)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/operations` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_operations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/operations)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/operations/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_operations_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/operations/policies)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/policies)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | API display name. |
| [`name`](#parameter-name) | string | API revision identifier. Must be unique in the current API Management workspace. Non-current revision has ;rev=n as a suffix where n is the revision number. |
| [`path`](#parameter-path) | string | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiRevision`](#parameter-apirevision) | string | Describes the Revision of the API. If no value is provided, default revision 1 is created. |
| [`apiRevisionDescription`](#parameter-apirevisiondescription) | string | Description of the API Revision. |
| [`apiType`](#parameter-apitype) | string | Type of API to create.<p>* `http` creates a REST API<p>* `soap` creates a SOAP pass-through API<p>* `websocket` creates websocket API<p>* `graphql` creates GraphQL API. |
| [`apiVersion`](#parameter-apiversion) | string | Indicates the Version identifier of the API if the API is versioned. |
| [`apiVersionDescription`](#parameter-apiversiondescription) | string | Description of the API Version. |
| [`apiVersionSetName`](#parameter-apiversionsetname) | string | The name of the API version set to link. |
| [`authenticationSettings`](#parameter-authenticationsettings) | object | Collection of authentication settings included into this API. |
| [`description`](#parameter-description) | string | Description of the API. May include HTML formatting tags. |
| [`diagnostics`](#parameter-diagnostics) | array | Array of diagnostics to apply to the Service API. |
| [`format`](#parameter-format) | string | Format of the Content in which the API is getting imported. |
| [`isCurrent`](#parameter-iscurrent) | bool | Indicates if API revision is current API revision. |
| [`operations`](#parameter-operations) | array | The operations of the api. |
| [`policies`](#parameter-policies) | array | Array of Policies to apply to the Service API. |
| [`protocols`](#parameter-protocols) | array | Describes on which protocols the operations in this API can be invoked. |
| [`serviceUrl`](#parameter-serviceurl) | string | Absolute URL of the backend service implementing this API. |
| [`sourceApiId`](#parameter-sourceapiid) | string | API identifier of the source API. |
| [`subscriptionKeyParameterNames`](#parameter-subscriptionkeyparameternames) | object | Protocols over which API is made available. |
| [`subscriptionRequired`](#parameter-subscriptionrequired) | bool | Specifies whether an API or Product subscription is required for accessing the API. |
| [`type`](#parameter-type) | string | Type of API. |
| [`value`](#parameter-value) | string | Content value when Importing an API. |
| [`wsdlSelector`](#parameter-wsdlselector) | object | Criteria to limit import of WSDL to a subset of the document. |

### Parameter: `displayName`

API display name.

- Required: Yes
- Type: string

### Parameter: `name`

API revision identifier. Must be unique in the current API Management workspace. Non-current revision has ;rev=n as a suffix where n is the revision number.

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

### Parameter: `workspaceName`

The name of the parent Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
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

Type of API to create.<p>* `http` creates a REST API<p>* `soap` creates a SOAP pass-through API<p>* `websocket` creates websocket API<p>* `graphql` creates GraphQL API.

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

### Parameter: `apiVersionSetName`

The name of the API version set to link.

- Required: No
- Type: string

### Parameter: `authenticationSettings`

Collection of authentication settings included into this API.

- Required: No
- Type: object

### Parameter: `description`

Description of the API. May include HTML formatting tags.

- Required: No
- Type: string

### Parameter: `diagnostics`

Array of diagnostics to apply to the Service API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loggerName`](#parameter-diagnosticsloggername) | string | The name of the target logger. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpCorrelationProtocol`](#parameter-diagnosticshttpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-diagnosticsmetrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |
| [`operationNameFormat`](#parameter-diagnosticsoperationnameformat) | string | The format of the Operation Name for Application Insights telemetries. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-diagnosticsalwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-diagnosticsbackend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`frontend`](#parameter-diagnosticsfrontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-diagnosticslogclientip) | bool | Log the ClientIP. |
| [`name`](#parameter-diagnosticsname) | string | The identifier of the Diagnostic. |
| [`samplingPercentage`](#parameter-diagnosticssamplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. |
| [`verbosity`](#parameter-diagnosticsverbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `diagnostics.loggerName`

The name of the target logger.

- Required: Yes
- Type: string

### Parameter: `diagnostics.httpCorrelationProtocol`

Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Legacy'
    'None'
    'W3C'
  ]
  ```

### Parameter: `diagnostics.metrics`

Emit custom metrics via emit-metric policy. Required if using Application Insights.

- Required: No
- Type: bool

### Parameter: `diagnostics.operationNameFormat`

The format of the Operation Name for Application Insights telemetries. Required if using Application Insights.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Name'
    'Url'
  ]
  ```

### Parameter: `diagnostics.alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'allErrors'
  ]
  ```

### Parameter: `diagnostics.backend`

Diagnostic settings for incoming/outgoing HTTP messages to the Backend.

- Required: No
- Type: object

### Parameter: `diagnostics.frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object

### Parameter: `diagnostics.logClientIp`

Log the ClientIP.

- Required: No
- Type: bool

### Parameter: `diagnostics.name`

The identifier of the Diagnostic.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'applicationinsights'
    'azuremonitor'
    'local'
  ]
  ```

### Parameter: `diagnostics.samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 100

### Parameter: `diagnostics.verbosity`

The verbosity level applied to traces emitted by trace policies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'error'
    'information'
    'verbose'
  ]
  ```

### Parameter: `format`

Format of the Content in which the API is getting imported.

- Required: No
- Type: string
- Default: `'openapi'`
- Allowed:
  ```Bicep
  [
    'graphql-link'
    'grpc'
    'grpc-link'
    'odata'
    'odata-link'
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

### Parameter: `operations`

The operations of the api.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-operationsdisplayname) | string | The display name of the operation. |
| [`method`](#parameter-operationsmethod) | string | A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them. |
| [`name`](#parameter-operationsname) | string | The name of the operation. |
| [`urlTemplate`](#parameter-operationsurltemplate) | string | Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-operationsdescription) | string | Description of the operation. May include HTML formatting tags. Must not be longer than 1.000 characters. |
| [`policies`](#parameter-operationspolicies) | array | The policies to apply to the operation. |
| [`request`](#parameter-operationsrequest) | object | An entity containing request details. |
| [`responses`](#parameter-operationsresponses) | array | Array of Operation responses. |
| [`templateParameters`](#parameter-operationstemplateparameters) | array | Collection of URL template parameters. |

### Parameter: `operations.displayName`

The display name of the operation.

- Required: Yes
- Type: string

### Parameter: `operations.method`

A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.

- Required: Yes
- Type: string

### Parameter: `operations.name`

The name of the operation.

- Required: Yes
- Type: string

### Parameter: `operations.urlTemplate`

Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}.

- Required: Yes
- Type: string

### Parameter: `operations.description`

Description of the operation. May include HTML formatting tags. Must not be longer than 1.000 characters.

- Required: No
- Type: string

### Parameter: `operations.policies`

The policies to apply to the operation.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-operationspoliciesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-operationspoliciesformat) | string | Format of the policyContent. |
| [`name`](#parameter-operationspoliciesname) | string | The name of the policy. |

### Parameter: `operations.policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `operations.policies.format`

Format of the policyContent.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'rawxml'
    'rawxml-link'
    'xml'
    'xml-link'
  ]
  ```

### Parameter: `operations.policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `operations.request`

An entity containing request details.

- Required: No
- Type: object

### Parameter: `operations.responses`

Array of Operation responses.

- Required: No
- Type: array

### Parameter: `operations.templateParameters`

Collection of URL template parameters.

- Required: No
- Type: array

### Parameter: `policies`

Array of Policies to apply to the Service API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-policiesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-policiesformat) | string | Format of the policyContent. |
| [`name`](#parameter-policiesname) | string | The name of the policy. |

### Parameter: `policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `policies.format`

Format of the policyContent.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'rawxml'
    'rawxml-link'
    'xml'
    'xml-link'
  ]
  ```

### Parameter: `policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `protocols`

Describes on which protocols the operations in this API can be invoked.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'https'
  ]
  ```
- Allowed:
  ```Bicep
  [
    'http'
    'https'
    'ws'
    'wss'
  ]
  ```

### Parameter: `serviceUrl`

Absolute URL of the backend service implementing this API.

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
    'grpc'
    'http'
    'odata'
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
| `name` | string | The name of the workspace API. |
| `resourceGroupName` | string | The resource group the workspace API was deployed to. |
| `resourceId` | string | The resource ID of the workspace API. |
