# API Management Service Workspace `[Microsoft.ApiManagement/service/workspaces]`

This module deploys an API Management Service Workspace.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/gateways` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_gateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/gateways)</li></ul> |
| `Microsoft.ApiManagement/gateways/configConnections` | 2024-06-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_gateways_configconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-06-01-preview/gateways/configConnections)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/diagnostics` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_diagnostics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/diagnostics)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/operations` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_operations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/operations)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/operations/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_operations_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/operations/policies)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apis/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apis_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apis/policies)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/apiVersionSets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_apiversionsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/apiVersionSets)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/backends` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_backends.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/backends)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/diagnostics` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_diagnostics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/diagnostics)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/loggers` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_loggers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/loggers)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/namedValues` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_namedvalues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/namedValues)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/policies)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products/apiLinks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products_apilinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products/apiLinks)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products/groupLinks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products_grouplinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products/groupLinks)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/products/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_products_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/products/policies)</li></ul> |
| `Microsoft.ApiManagement/service/workspaces/subscriptions` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_workspaces_subscriptions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/workspaces/subscriptions)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | Name of the workspace. |
| [`gateway`](#parameter-gateway) | object | Gateway to deploy for this workspace. |
| [`name`](#parameter-name) | string | Workspace Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apis`](#parameter-apis) | array | APIs to deploy in this workspace. |
| [`apiVersionSets`](#parameter-apiversionsets) | array | API Version Sets to deploy in this workspace. |
| [`backends`](#parameter-backends) | array | Backends to deploy in this workspace. |
| [`description`](#parameter-description) | string | Description of the workspace. |
| [`diagnostics`](#parameter-diagnostics) | array | Diagnostics to deploy in this workspace. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`loggers`](#parameter-loggers) | array | Loggers to deploy in this workspace. |
| [`namedValues`](#parameter-namedvalues) | array | Named values to deploy in this workspace. |
| [`policies`](#parameter-policies) | array | Policies to deploy in this workspace. |
| [`products`](#parameter-products) | array | Products to deploy in this workspace. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`subscriptions`](#parameter-subscriptions) | array | Subscriptions to deploy in this workspace. |

### Parameter: `displayName`

Name of the workspace.

- Required: Yes
- Type: string

### Parameter: `gateway`

Gateway to deploy for this workspace.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-gatewayname) | string | Gateway name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-gatewaysubnetresourceid) | string | The resource ID of the subnet to associate with the gateway backend. Required if virtualNetworkType is External or Internal. The subnet must be in the same region and subscription as the APIM instance and must be delegated to the required service: `Microsoft.Web/serverFarms` for External virtualNetworkType, `Microsoft.Web/hostingEnvironments` for Internal virtualNetworkType. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-gatewaycapacity) | int | Gateway SKU capacity. Defaults to 1. |
| [`location`](#parameter-gatewaylocation) | string | Location where the gateway will be deployed. |
| [`virtualNetworkType`](#parameter-gatewayvirtualnetworktype) | string | Virtual Network Type of the gateway. Defaults to None. |

### Parameter: `gateway.name`

Gateway name.

- Required: Yes
- Type: string

### Parameter: `gateway.subnetResourceId`

The resource ID of the subnet to associate with the gateway backend. Required if virtualNetworkType is External or Internal. The subnet must be in the same region and subscription as the APIM instance and must be delegated to the required service: `Microsoft.Web/serverFarms` for External virtualNetworkType, `Microsoft.Web/hostingEnvironments` for Internal virtualNetworkType.

- Required: No
- Type: string

### Parameter: `gateway.capacity`

Gateway SKU capacity. Defaults to 1.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 32

### Parameter: `gateway.location`

Location where the gateway will be deployed.

- Required: No
- Type: string

### Parameter: `gateway.virtualNetworkType`

Virtual Network Type of the gateway. Defaults to None.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'External'
    'Internal'
    'None'
  ]
  ```

### Parameter: `name`

Workspace Name.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `apis`

APIs to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-apisdisplayname) | string | API display name. |
| [`name`](#parameter-apisname) | string | API revision identifier. Must be unique in the current API Management workspace. Non-current revision has ;rev=n as a suffix where n is the revision number. |
| [`path`](#parameter-apispath) | string | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiRevision`](#parameter-apisapirevision) | string | Describes the Revision of the API. If no value is provided, default revision 1 is created. |
| [`apiRevisionDescription`](#parameter-apisapirevisiondescription) | string | Description of the API Revision. |
| [`apiType`](#parameter-apisapitype) | string | Type of API to create.<p>* `http` creates a REST API<p>* `soap` creates a SOAP pass-through API<p>* `websocket` creates websocket API<p>* `graphql` creates GraphQL API. |
| [`apiVersion`](#parameter-apisapiversion) | string | Indicates the Version identifier of the API if the API is versioned. |
| [`apiVersionDescription`](#parameter-apisapiversiondescription) | string | Description of the API Version. |
| [`apiVersionSetName`](#parameter-apisapiversionsetname) | string | The name of the API version set to link. |
| [`authenticationSettings`](#parameter-apisauthenticationsettings) | object | Collection of authentication settings included into this API. |
| [`description`](#parameter-apisdescription) | string | Description of the API. May include HTML formatting tags. |
| [`diagnostics`](#parameter-apisdiagnostics) | array | Array of diagnostics to apply to the Service API. |
| [`format`](#parameter-apisformat) | string | Format of the Content in which the API is getting imported. |
| [`isCurrent`](#parameter-apisiscurrent) | bool | Indicates if API revision is current API revision. |
| [`operations`](#parameter-apisoperations) | array | The operations of the api. |
| [`policies`](#parameter-apispolicies) | array | Array of Policies to apply to the Service API. |
| [`protocols`](#parameter-apisprotocols) | array | Describes on which protocols the operations in this API can be invoked. |
| [`serviceUrl`](#parameter-apisserviceurl) | string | Absolute URL of the backend service implementing this API. |
| [`sourceApiId`](#parameter-apissourceapiid) | string | API identifier of the source API. |
| [`subscriptionKeyParameterNames`](#parameter-apissubscriptionkeyparameternames) | object | Protocols over which API is made available. |
| [`subscriptionRequired`](#parameter-apissubscriptionrequired) | bool | Specifies whether an API or Product subscription is required for accessing the API. |
| [`type`](#parameter-apistype) | string | Type of API. |
| [`value`](#parameter-apisvalue) | string | Content value when Importing an API. |
| [`wsdlSelector`](#parameter-apiswsdlselector) | object | Criteria to limit import of WSDL to a subset of the document. |

### Parameter: `apis.displayName`

API display name.

- Required: Yes
- Type: string

### Parameter: `apis.name`

API revision identifier. Must be unique in the current API Management workspace. Non-current revision has ;rev=n as a suffix where n is the revision number.

- Required: Yes
- Type: string

### Parameter: `apis.path`

Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API.

- Required: Yes
- Type: string

### Parameter: `apis.apiRevision`

Describes the Revision of the API. If no value is provided, default revision 1 is created.

- Required: No
- Type: string

### Parameter: `apis.apiRevisionDescription`

Description of the API Revision.

- Required: No
- Type: string

### Parameter: `apis.apiType`

Type of API to create.<p>* `http` creates a REST API<p>* `soap` creates a SOAP pass-through API<p>* `websocket` creates websocket API<p>* `graphql` creates GraphQL API.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'graphql'
    'http'
    'soap'
    'websocket'
  ]
  ```

### Parameter: `apis.apiVersion`

Indicates the Version identifier of the API if the API is versioned.

- Required: No
- Type: string

### Parameter: `apis.apiVersionDescription`

Description of the API Version.

- Required: No
- Type: string

### Parameter: `apis.apiVersionSetName`

The name of the API version set to link.

- Required: No
- Type: string

### Parameter: `apis.authenticationSettings`

Collection of authentication settings included into this API.

- Required: No
- Type: object

### Parameter: `apis.description`

Description of the API. May include HTML formatting tags.

- Required: No
- Type: string

### Parameter: `apis.diagnostics`

Array of diagnostics to apply to the Service API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loggerName`](#parameter-apisdiagnosticsloggername) | string | The name of the target logger. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpCorrelationProtocol`](#parameter-apisdiagnosticshttpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-apisdiagnosticsmetrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |
| [`operationNameFormat`](#parameter-apisdiagnosticsoperationnameformat) | string | The format of the Operation Name for Application Insights telemetries. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-apisdiagnosticsalwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-apisdiagnosticsbackend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`frontend`](#parameter-apisdiagnosticsfrontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-apisdiagnosticslogclientip) | bool | Log the ClientIP. |
| [`name`](#parameter-apisdiagnosticsname) | string | The identifier of the Diagnostic. |
| [`samplingPercentage`](#parameter-apisdiagnosticssamplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. |
| [`verbosity`](#parameter-apisdiagnosticsverbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `apis.diagnostics.loggerName`

The name of the target logger.

- Required: Yes
- Type: string

### Parameter: `apis.diagnostics.httpCorrelationProtocol`

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

### Parameter: `apis.diagnostics.metrics`

Emit custom metrics via emit-metric policy. Required if using Application Insights.

- Required: No
- Type: bool

### Parameter: `apis.diagnostics.operationNameFormat`

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

### Parameter: `apis.diagnostics.alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'allErrors'
  ]
  ```

### Parameter: `apis.diagnostics.backend`

Diagnostic settings for incoming/outgoing HTTP messages to the Backend.

- Required: No
- Type: object

### Parameter: `apis.diagnostics.frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object

### Parameter: `apis.diagnostics.logClientIp`

Log the ClientIP.

- Required: No
- Type: bool

### Parameter: `apis.diagnostics.name`

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

### Parameter: `apis.diagnostics.samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 100

### Parameter: `apis.diagnostics.verbosity`

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

### Parameter: `apis.format`

Format of the Content in which the API is getting imported.

- Required: No
- Type: string
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

### Parameter: `apis.isCurrent`

Indicates if API revision is current API revision.

- Required: No
- Type: bool

### Parameter: `apis.operations`

The operations of the api.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-apisoperationsdisplayname) | string | The display name of the operation. |
| [`method`](#parameter-apisoperationsmethod) | string | A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them. |
| [`name`](#parameter-apisoperationsname) | string | The name of the operation. |
| [`urlTemplate`](#parameter-apisoperationsurltemplate) | string | Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apisoperationsdescription) | string | Description of the operation. May include HTML formatting tags. Must not be longer than 1.000 characters. |
| [`policies`](#parameter-apisoperationspolicies) | array | The policies to apply to the operation. |
| [`request`](#parameter-apisoperationsrequest) | object | An entity containing request details. |
| [`responses`](#parameter-apisoperationsresponses) | array | Array of Operation responses. |
| [`templateParameters`](#parameter-apisoperationstemplateparameters) | array | Collection of URL template parameters. |

### Parameter: `apis.operations.displayName`

The display name of the operation.

- Required: Yes
- Type: string

### Parameter: `apis.operations.method`

A Valid HTTP Operation Method. Typical Http Methods like GET, PUT, POST but not limited by only them.

- Required: Yes
- Type: string

### Parameter: `apis.operations.name`

The name of the operation.

- Required: Yes
- Type: string

### Parameter: `apis.operations.urlTemplate`

Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}.

- Required: Yes
- Type: string

### Parameter: `apis.operations.description`

Description of the operation. May include HTML formatting tags. Must not be longer than 1.000 characters.

- Required: No
- Type: string

### Parameter: `apis.operations.policies`

The policies to apply to the operation.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-apisoperationspoliciesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-apisoperationspoliciesformat) | string | Format of the policyContent. |
| [`name`](#parameter-apisoperationspoliciesname) | string | The name of the policy. |

### Parameter: `apis.operations.policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `apis.operations.policies.format`

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

### Parameter: `apis.operations.policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `apis.operations.request`

An entity containing request details.

- Required: No
- Type: object

### Parameter: `apis.operations.responses`

Array of Operation responses.

- Required: No
- Type: array

### Parameter: `apis.operations.templateParameters`

Collection of URL template parameters.

- Required: No
- Type: array

### Parameter: `apis.policies`

Array of Policies to apply to the Service API.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-apispoliciesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-apispoliciesformat) | string | Format of the policyContent. |
| [`name`](#parameter-apispoliciesname) | string | The name of the policy. |

### Parameter: `apis.policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `apis.policies.format`

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

### Parameter: `apis.policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `apis.protocols`

Describes on which protocols the operations in this API can be invoked.

- Required: No
- Type: array

### Parameter: `apis.serviceUrl`

Absolute URL of the backend service implementing this API.

- Required: No
- Type: string

### Parameter: `apis.sourceApiId`

API identifier of the source API.

- Required: No
- Type: string

### Parameter: `apis.subscriptionKeyParameterNames`

Protocols over which API is made available.

- Required: No
- Type: object

### Parameter: `apis.subscriptionRequired`

Specifies whether an API or Product subscription is required for accessing the API.

- Required: No
- Type: bool

### Parameter: `apis.type`

Type of API.

- Required: No
- Type: string
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

### Parameter: `apis.value`

Content value when Importing an API.

- Required: No
- Type: string

### Parameter: `apis.wsdlSelector`

Criteria to limit import of WSDL to a subset of the document.

- Required: No
- Type: object

### Parameter: `apiVersionSets`

API Version Sets to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-apiversionsetsdisplayname) | string | The display name of the API Version Set. |
| [`name`](#parameter-apiversionsetsname) | string | API Version set name. |
| [`versioningScheme`](#parameter-apiversionsetsversioningscheme) | string | An value that determines where the API Version identifier will be located in a HTTP request. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apiversionsetsdescription) | string | Description of API Version Set. |
| [`versionHeaderName`](#parameter-apiversionsetsversionheadername) | string | Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header. |
| [`versionQueryName`](#parameter-apiversionsetsversionqueryname) | string | Name of query parameter that indicates the API Version if versioningScheme is set to query. |

### Parameter: `apiVersionSets.displayName`

The display name of the API Version Set.

- Required: Yes
- Type: string

### Parameter: `apiVersionSets.name`

API Version set name.

- Required: Yes
- Type: string

### Parameter: `apiVersionSets.versioningScheme`

An value that determines where the API Version identifier will be located in a HTTP request.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Header'
    'Query'
    'Segment'
  ]
  ```

### Parameter: `apiVersionSets.description`

Description of API Version Set.

- Required: No
- Type: string

### Parameter: `apiVersionSets.versionHeaderName`

Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.

- Required: No
- Type: string

### Parameter: `apiVersionSets.versionQueryName`

Name of query parameter that indicates the API Version if versioningScheme is set to query.

- Required: No
- Type: string

### Parameter: `backends`

Backends to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-backendsname) | string | Backend Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`pool`](#parameter-backendspool) | object | Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single. |
| [`url`](#parameter-backendsurl) | string | Runtime URL of the Backend. Required if type is Single and not supported if type is Pool. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`circuitBreaker`](#parameter-backendscircuitbreaker) | object | Backend Circuit Breaker Configuration. Not supported for Backend Pools. |
| [`credentials`](#parameter-backendscredentials) | object | Backend Credentials Contract Properties. Not supported for Backend Pools. |
| [`description`](#parameter-backendsdescription) | string | Backend Description. |
| [`protocol`](#parameter-backendsprotocol) | string | Backend communication protocol. http or soap. Not supported for Backend Pools. |
| [`proxy`](#parameter-backendsproxy) | object | Backend Proxy Contract Properties. Not supported for Backend Pools. |
| [`resourceId`](#parameter-backendsresourceid) | string | Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools. |
| [`serviceFabricCluster`](#parameter-backendsservicefabriccluster) | object | Backend Service Fabric Cluster Properties. Not supported for Backend Pools. |
| [`title`](#parameter-backendstitle) | string | Backend Title. |
| [`tls`](#parameter-backendstls) | object | Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true. |
| [`type`](#parameter-backendstype) | string | Type of the backend. A backend can be either Single or Pool. |

### Parameter: `backends.name`

Backend Name.

- Required: Yes
- Type: string

### Parameter: `backends.pool`

Backend pool configuration for load balancing. Required if type is Pool and not supported if type is Single.

- Required: No
- Type: object

### Parameter: `backends.url`

Runtime URL of the Backend. Required if type is Single and not supported if type is Pool.

- Required: No
- Type: string

### Parameter: `backends.circuitBreaker`

Backend Circuit Breaker Configuration. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `backends.credentials`

Backend Credentials Contract Properties. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `backends.description`

Backend Description.

- Required: No
- Type: string

### Parameter: `backends.protocol`

Backend communication protocol. http or soap. Not supported for Backend Pools.

- Required: No
- Type: string

### Parameter: `backends.proxy`

Backend Proxy Contract Properties. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `backends.resourceId`

Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. Not supported for Backend Pools.

- Required: No
- Type: string

### Parameter: `backends.serviceFabricCluster`

Backend Service Fabric Cluster Properties. Not supported for Backend Pools.

- Required: No
- Type: object

### Parameter: `backends.title`

Backend Title.

- Required: No
- Type: string

### Parameter: `backends.tls`

Backend TLS Properties. Not supported for Backend Pools. If not specified and type is Single, TLS properties will default to validateCertificateChain and validateCertificateName set to true.

- Required: No
- Type: object

### Parameter: `backends.type`

Type of the backend. A backend can be either Single or Pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Pool'
    'Single'
  ]
  ```

### Parameter: `description`

Description of the workspace.

- Required: No
- Type: string

### Parameter: `diagnostics`

Diagnostics to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loggerResourceId`](#parameter-diagnosticsloggerresourceid) | string | Logger resource ID. |
| [`name`](#parameter-diagnosticsname) | string | Diagnostic Name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpCorrelationProtocol`](#parameter-diagnosticshttpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-diagnosticsmetrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-diagnosticsalwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-diagnosticsbackend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`frontend`](#parameter-diagnosticsfrontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-diagnosticslogclientip) | bool | Log the ClientIP. |
| [`operationNameFormat`](#parameter-diagnosticsoperationnameformat) | string | The format of the Operation Name for Application Insights telemetries. |
| [`samplingPercentage`](#parameter-diagnosticssamplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. |
| [`verbosity`](#parameter-diagnosticsverbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `diagnostics.loggerResourceId`

Logger resource ID.

- Required: Yes
- Type: string

### Parameter: `diagnostics.name`

Diagnostic Name.

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

### Parameter: `diagnostics.alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string

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

### Parameter: `diagnostics.operationNameFormat`

The format of the Operation Name for Application Insights telemetries.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Name'
    'Url'
  ]
  ```

### Parameter: `diagnostics.samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged.

- Required: No
- Type: int

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

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `loggers`

Loggers to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-loggersname) | string | Logger name. |
| [`type`](#parameter-loggerstype) | string | Logger type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-loggerscredentials) | object | The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub, ignored if loggerType = azureMonitor. |
| [`targetResourceId`](#parameter-loggerstargetresourceid) | string | Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-loggersdescription) | string | Description of the logger. |
| [`isBuffered`](#parameter-loggersisbuffered) | bool | Whether records are buffered in the logger before publishing. |

### Parameter: `loggers.name`

Logger name.

- Required: Yes
- Type: string

### Parameter: `loggers.type`

Logger type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'applicationInsights'
    'azureEventHub'
    'azureMonitor'
  ]
  ```

### Parameter: `loggers.credentials`

The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub, ignored if loggerType = azureMonitor.

- Required: No
- Type: object

### Parameter: `loggers.targetResourceId`

Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub.

- Required: No
- Type: string

### Parameter: `loggers.description`

Description of the logger.

- Required: No
- Type: string

### Parameter: `loggers.isBuffered`

Whether records are buffered in the logger before publishing.

- Required: No
- Type: bool

### Parameter: `namedValues`

Named values to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-namedvaluesdisplayname) | string | Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters. |
| [`name`](#parameter-namedvaluesname) | string | The name of the named value. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVault`](#parameter-namedvalueskeyvault) | object | KeyVault location details of the namedValue. |
| [`secret`](#parameter-namedvaluessecret) | bool | Determines whether the value is a secret and should be encrypted or not. |
| [`tags`](#parameter-namedvaluestags) | array | Tags that when provided can be used to filter the NamedValue list. |
| [`value`](#parameter-namedvaluesvalue) | string | Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |

### Parameter: `namedValues.displayName`

Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.

- Required: Yes
- Type: string

### Parameter: `namedValues.name`

The name of the named value.

- Required: Yes
- Type: string

### Parameter: `namedValues.keyVault`

KeyVault location details of the namedValue.

- Required: No
- Type: object

### Parameter: `namedValues.secret`

Determines whether the value is a secret and should be encrypted or not.

- Required: No
- Type: bool

### Parameter: `namedValues.tags`

Tags that when provided can be used to filter the NamedValue list.

- Required: No
- Type: array

### Parameter: `namedValues.value`

Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.

- Required: No
- Type: string

### Parameter: `policies`

Policies to deploy in this workspace.

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

### Parameter: `products`

Products to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-productsdisplayname) | string | Product display name. |
| [`name`](#parameter-productsname) | string | Product Name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiLinks`](#parameter-productsapilinks) | array | Names of Product API Links. |
| [`approvalRequired`](#parameter-productsapprovalrequired) | bool | Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product's APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product's APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`description`](#parameter-productsdescription) | string | Product description. May include HTML formatting tags. |
| [`groupLinks`](#parameter-productsgrouplinks) | array | Names of Product Group Links. |
| [`policies`](#parameter-productspolicies) | array | Array of Policies to apply to the Product. |
| [`state`](#parameter-productsstate) | string | Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. |
| [`subscriptionRequired`](#parameter-productssubscriptionrequired) | bool | Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
| [`subscriptionsLimit`](#parameter-productssubscriptionslimit) | int | Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`terms`](#parameter-productsterms) | string | Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process. |

### Parameter: `products.displayName`

Product display name.

- Required: Yes
- Type: string

### Parameter: `products.name`

Product Name.

- Required: Yes
- Type: string

### Parameter: `products.apiLinks`

Names of Product API Links.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiResourceId`](#parameter-productsapilinksapiresourceid) | string | Full resource Id of an API. |
| [`name`](#parameter-productsapilinksname) | string | The name of the API link. |

### Parameter: `products.apiLinks.apiResourceId`

Full resource Id of an API.

- Required: Yes
- Type: string

### Parameter: `products.apiLinks.name`

The name of the API link.

- Required: Yes
- Type: string

### Parameter: `products.approvalRequired`

Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product's APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product's APIs. Can be present only if subscriptionRequired property is present and has a value of false.

- Required: No
- Type: bool

### Parameter: `products.description`

Product description. May include HTML formatting tags.

- Required: No
- Type: string

### Parameter: `products.groupLinks`

Names of Product Group Links.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupResourceId`](#parameter-productsgrouplinksgroupresourceid) | string | Full resource Id of a Group. |
| [`name`](#parameter-productsgrouplinksname) | string | The name of the Product Group link. |

### Parameter: `products.groupLinks.groupResourceId`

Full resource Id of a Group.

- Required: Yes
- Type: string

### Parameter: `products.groupLinks.name`

The name of the Product Group link.

- Required: Yes
- Type: string

### Parameter: `products.policies`

Array of Policies to apply to the Product.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`value`](#parameter-productspoliciesvalue) | string | Contents of the Policy as defined by the format. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-productspoliciesformat) | string | Format of the policyContent. |
| [`name`](#parameter-productspoliciesname) | string | The name of the policy. |

### Parameter: `products.policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `products.policies.format`

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

### Parameter: `products.policies.name`

The name of the policy.

- Required: No
- Type: string

### Parameter: `products.state`

Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'notPublished'
    'published'
  ]
  ```

### Parameter: `products.subscriptionRequired`

Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true.

- Required: No
- Type: bool

### Parameter: `products.subscriptionsLimit`

Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.

- Required: No
- Type: int

### Parameter: `products.terms`

Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.

- Required: No
- Type: string

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'API Management Developer Portal Content Editor'`
  - `'API Management Service Contributor'`
  - `'API Management Service Operator Role'`
  - `'API Management Service Reader Role'`
  - `'API Management Service Workspace API Developer'`
  - `'API Management Service Workspace API Product Manager'`
  - `'API Management Workspace API Developer'`
  - `'API Management Workspace API Product Manager'`
  - `'API Management Workspace Contributor'`
  - `'API Management Workspace Reader'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `subscriptions`

Subscriptions to deploy in this workspace.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-subscriptionsdisplayname) | string | API Management Service Subscriptions name. |
| [`name`](#parameter-subscriptionsname) | string | Subscription name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowTracing`](#parameter-subscriptionsallowtracing) | bool | Determines whether tracing can be enabled. |
| [`ownerId`](#parameter-subscriptionsownerid) | string | User (user ID path) for whom subscription is being created in form /users/{userId}. |
| [`primaryKey`](#parameter-subscriptionsprimarykey) | string | Primary subscription key. If not specified during request key will be generated automatically. |
| [`scope`](#parameter-subscriptionsscope) | string | Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}". |
| [`secondaryKey`](#parameter-subscriptionssecondarykey) | string | Secondary subscription key. If not specified during request key will be generated automatically. |
| [`state`](#parameter-subscriptionsstate) | string | Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:<p>* active - the subscription is active<p>* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product<p>* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected<p>* rejected - the subscription request has been denied by an administrator<p>* cancelled - the subscription has been cancelled by the developer or administrator<p>* expired - the subscription reached its expiration date and was deactivated. |

### Parameter: `subscriptions.displayName`

API Management Service Subscriptions name.

- Required: Yes
- Type: string

### Parameter: `subscriptions.name`

Subscription name.

- Required: Yes
- Type: string

### Parameter: `subscriptions.allowTracing`

Determines whether tracing can be enabled.

- Required: No
- Type: bool

### Parameter: `subscriptions.ownerId`

User (user ID path) for whom subscription is being created in form /users/{userId}.

- Required: No
- Type: string

### Parameter: `subscriptions.primaryKey`

Primary subscription key. If not specified during request key will be generated automatically.

- Required: No
- Type: string

### Parameter: `subscriptions.scope`

Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".

- Required: No
- Type: string

### Parameter: `subscriptions.secondaryKey`

Secondary subscription key. If not specified during request key will be generated automatically.

- Required: No
- Type: string

### Parameter: `subscriptions.state`

Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:<p>* active - the subscription is active<p>* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product<p>* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected<p>* rejected - the subscription request has been denied by an administrator<p>* cancelled - the subscription has been cancelled by the developer or administrator<p>* expired - the subscription reached its expiration date and was deactivated.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'active'
    'cancelled'
    'expired'
    'rejected'
    'submitted'
    'suspended'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management workspace. |
| `resourceGroupName` | string | The resource group the API management workspace was deployed into. |
| `resourceId` | string | The resource ID of the API management workspace. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |
