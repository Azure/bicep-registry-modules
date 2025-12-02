# API Management Services `[Microsoft.ApiManagement/service]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
>
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys an API Management Service. The default deployment is set to use a Premium SKU to align with Microsoft WAF-aligned best practices. In most cases, non-prod deployments should use a lower-tier SKU.

You can reference the module as follows:
```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ApiManagement/service` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service)</li></ul> |
| `Microsoft.ApiManagement/service/apis` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis)</li></ul> |
| `Microsoft.ApiManagement/service/apis/diagnostics` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apis_diagnostics.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/diagnostics)</li></ul> |
| `Microsoft.ApiManagement/service/apis/operations` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apis_operations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/operations)</li></ul> |
| `Microsoft.ApiManagement/service/apis/operations/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apis_operations_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/operations/policies)</li></ul> |
| `Microsoft.ApiManagement/service/apis/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apis_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/policies)</li></ul> |
| `Microsoft.ApiManagement/service/apiVersionSets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_apiversionsets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apiVersionSets)</li></ul> |
| `Microsoft.ApiManagement/service/authorizationServers` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_authorizationservers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/authorizationServers)</li></ul> |
| `Microsoft.ApiManagement/service/backends` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_backends.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/backends)</li></ul> |
| `Microsoft.ApiManagement/service/caches` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_caches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/caches)</li></ul> |
| `Microsoft.ApiManagement/service/identityProviders` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_identityproviders.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/identityProviders)</li></ul> |
| `Microsoft.ApiManagement/service/loggers` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_loggers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/loggers)</li></ul> |
| `Microsoft.ApiManagement/service/namedValues` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_namedvalues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/namedValues)</li></ul> |
| `Microsoft.ApiManagement/service/policies` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_policies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/policies)</li></ul> |
| `Microsoft.ApiManagement/service/portalsettings` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_portalsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/portalsettings)</li></ul> |
| `Microsoft.ApiManagement/service/products` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_products.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/products)</li></ul> |
| `Microsoft.ApiManagement/service/products/apis` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_products_apis.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/products/apis)</li></ul> |
| `Microsoft.ApiManagement/service/products/groups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_products_groups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/products/groups)</li></ul> |
| `Microsoft.ApiManagement/service/subscriptions` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_subscriptions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/subscriptions)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/api-management/service:<version>`.

- [Deploying a Consumption SKU](#example-1-deploying-a-consumption-sku)
- [Using only defaults](#example-2-using-only-defaults)
- [Deploying a Developer SKU](#example-3-deploying-a-developer-sku)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [Deploying an APIM v2 sku](#example-5-deploying-an-apim-v2-sku)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Deploying a Consumption SKU_

This instance deploys the module using a Consumption SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/consumptionSku]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: {
    // Required parameters
    name: 'apiscon001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    sku: 'Consumption'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apiscon001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "sku": {
      "value": "Consumption"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-management/service:<version>'

// Required parameters
param name = 'apiscon001'
param publisherEmail = 'apimgmt-noreply@mail.windowsazure.com'
param publisherName = 'az-amorg-x-001'
// Non-required parameters
param sku = 'Consumption'
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: {
    // Required parameters
    name: 'apismin001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apismin001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-management/service:<version>'

// Required parameters
param name = 'apismin001'
param publisherEmail = 'apimgmt-noreply@mail.windowsazure.com'
param publisherName = 'az-amorg-x-001'
```

</details>
<p>

### Example 3: _Deploying a Developer SKU_

This instance deploys the module using a Developer SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/developerSku]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: {
    // Required parameters
    name: 'apisdev001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    enableDeveloperPortal: true
    sku: 'Developer'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apisdev001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "enableDeveloperPortal": {
      "value": true
    },
    "sku": {
      "value": "Developer"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-management/service:<version>'

// Required parameters
param name = 'apisdev001'
param publisherEmail = 'apimgmt-noreply@mail.windowsazure.com'
param publisherName = 'az-amorg-x-001'
// Non-required parameters
param enableDeveloperPortal = true
param sku = 'Developer'
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: {
    // Required parameters
    name: 'apismax001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    additionalLocations: [
      {
        disableGateway: false
        location: '<location>'
        publicIpAddressResourceId: '<publicIpAddressResourceId>'
        sku: {
          capacity: 1
          name: 'Premium'
        }
        virtualNetworkConfiguration: {
          subnetResourceId: '<subnetResourceId>'
        }
      }
    ]
    apiDiagnostics: [
      {
        apiName: 'echo-api'
        loggerName: 'logger'
        metrics: true
        name: 'applicationinsights'
      }
    ]
    apis: [
      {
        apiVersionSetName: 'echo-version-set'
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        protocols: [
          'http'
          'https'
        ]
        serviceUrl: 'http://echoapi.cloudapp.net/api'
      }
    ]
    apiVersionSets: [
      {
        description: 'echo-version-set'
        displayName: 'echo-version-set'
        name: 'echo-version-set'
        versioningScheme: 'Segment'
      }
    ]
    authorizationServers: [
      {
        authorizationEndpoint: '<authorizationEndpoint>'
        clientId: 'apimclientid'
        clientRegistrationEndpoint: 'http://localhost'
        clientSecret: '<clientSecret>'
        displayName: 'AuthServer1'
        grantTypes: [
          'authorizationCode'
        ]
        name: 'AuthServer1'
        tokenEndpoint: '<tokenEndpoint>'
      }
    ]
    backends: [
      {
        name: 'backend'
        tls: {
          validateCertificateChain: false
          validateCertificateName: false
        }
        url: 'http://echoapi.cloudapp.net/api'
      }
    ]
    caches: [
      {
        connectionString: 'connectionstringtest'
        name: 'westeurope'
        useFromLocation: 'westeurope'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    identityProviders: [
      {
        allowedTenants: [
          'mytenant.onmicrosoft.com'
        ]
        authority: '<authority>'
        clientId: 'apimClientid'
        clientLibrary: 'MSAL-2'
        clientSecret: 'apimSlientSecret'
        name: 'aad'
        signInTenant: 'mytenant.onmicrosoft.com'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    loggers: [
      {
        credentials: {
          instrumentationKey: '<instrumentationKey>'
        }
        description: 'Logger to Azure Application Insights'
        isBuffered: false
        name: 'logger'
        targetResourceId: '<targetResourceId>'
        type: 'applicationInsights'
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    namedValues: [
      {
        displayName: 'apimkey'
        name: 'apimkey'
        secret: true
      }
    ]
    policies: [
      {
        format: 'xml'
        value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
      }
    ]
    portalsettings: [
      {
        name: 'signin'
        properties: {
          enabled: false
        }
      }
      {
        name: 'signup'
        properties: {
          enabled: false
          termsOfService: {
            consentRequired: false
            enabled: false
          }
        }
      }
    ]
    products: [
      {
        apis: [
          'echo-api'
        ]
        approvalRequired: false
        displayName: 'Starter'
        groups: [
          'developers'
        ]
        name: 'Starter'
        subscriptionRequired: false
      }
    ]
    publicIpAddressResourceId: '<publicIpAddressResourceId>'
    publicNetworkAccess: 'Enabled'
    roleAssignments: [
      {
        name: '6352c3e3-ac6b-43d5-ac43-1077ff373721'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    subnetResourceId: '<subnetResourceId>'
    subscriptions: [
      {
        displayName: 'testArmSubscriptionAllApis'
        name: 'testArmSubscriptionAllApis'
        scope: '/apis'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkType: 'Internal'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apismax001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "additionalLocations": {
      "value": [
        {
          "disableGateway": false,
          "location": "<location>",
          "publicIpAddressResourceId": "<publicIpAddressResourceId>",
          "sku": {
            "capacity": 1,
            "name": "Premium"
          },
          "virtualNetworkConfiguration": {
            "subnetResourceId": "<subnetResourceId>"
          }
        }
      ]
    },
    "apiDiagnostics": {
      "value": [
        {
          "apiName": "echo-api",
          "loggerName": "logger",
          "metrics": true,
          "name": "applicationinsights"
        }
      ]
    },
    "apis": {
      "value": [
        {
          "apiVersionSetName": "echo-version-set",
          "displayName": "Echo API",
          "name": "echo-api",
          "path": "echo",
          "protocols": [
            "http",
            "https"
          ],
          "serviceUrl": "http://echoapi.cloudapp.net/api"
        }
      ]
    },
    "apiVersionSets": {
      "value": [
        {
          "description": "echo-version-set",
          "displayName": "echo-version-set",
          "name": "echo-version-set",
          "versioningScheme": "Segment"
        }
      ]
    },
    "authorizationServers": {
      "value": [
        {
          "authorizationEndpoint": "<authorizationEndpoint>",
          "clientId": "apimclientid",
          "clientRegistrationEndpoint": "http://localhost",
          "clientSecret": "<clientSecret>",
          "displayName": "AuthServer1",
          "grantTypes": [
            "authorizationCode"
          ],
          "name": "AuthServer1",
          "tokenEndpoint": "<tokenEndpoint>"
        }
      ]
    },
    "backends": {
      "value": [
        {
          "name": "backend",
          "tls": {
            "validateCertificateChain": false,
            "validateCertificateName": false
          },
          "url": "http://echoapi.cloudapp.net/api"
        }
      ]
    },
    "caches": {
      "value": [
        {
          "connectionString": "connectionstringtest",
          "name": "westeurope",
          "useFromLocation": "westeurope"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "identityProviders": {
      "value": [
        {
          "allowedTenants": [
            "mytenant.onmicrosoft.com"
          ],
          "authority": "<authority>",
          "clientId": "apimClientid",
          "clientLibrary": "MSAL-2",
          "clientSecret": "apimSlientSecret",
          "name": "aad",
          "signInTenant": "mytenant.onmicrosoft.com"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "loggers": {
      "value": [
        {
          "credentials": {
            "instrumentationKey": "<instrumentationKey>"
          },
          "description": "Logger to Azure Application Insights",
          "isBuffered": false,
          "name": "logger",
          "targetResourceId": "<targetResourceId>",
          "type": "applicationInsights"
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "namedValues": {
      "value": [
        {
          "displayName": "apimkey",
          "name": "apimkey",
          "secret": true
        }
      ]
    },
    "policies": {
      "value": [
        {
          "format": "xml",
          "value": "<policies> <inbound> <rate-limit-by-key calls=\"250\" renewal-period=\"60\" counter-key=\"@(context.Request.IpAddress)\" /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>"
        }
      ]
    },
    "portalsettings": {
      "value": [
        {
          "name": "signin",
          "properties": {
            "enabled": false
          }
        },
        {
          "name": "signup",
          "properties": {
            "enabled": false,
            "termsOfService": {
              "consentRequired": false,
              "enabled": false
            }
          }
        }
      ]
    },
    "products": {
      "value": [
        {
          "apis": [
            "echo-api"
          ],
          "approvalRequired": false,
          "displayName": "Starter",
          "groups": [
            "developers"
          ],
          "name": "Starter",
          "subscriptionRequired": false
        }
      ]
    },
    "publicIpAddressResourceId": {
      "value": "<publicIpAddressResourceId>"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "6352c3e3-ac6b-43d5-ac43-1077ff373721",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "subnetResourceId": {
      "value": "<subnetResourceId>"
    },
    "subscriptions": {
      "value": [
        {
          "displayName": "testArmSubscriptionAllApis",
          "name": "testArmSubscriptionAllApis",
          "scope": "/apis"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkType": {
      "value": "Internal"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-management/service:<version>'

// Required parameters
param name = 'apismax001'
param publisherEmail = 'apimgmt-noreply@mail.windowsazure.com'
param publisherName = 'az-amorg-x-001'
// Non-required parameters
param additionalLocations = [
  {
    disableGateway: false
    location: '<location>'
    publicIpAddressResourceId: '<publicIpAddressResourceId>'
    sku: {
      capacity: 1
      name: 'Premium'
    }
    virtualNetworkConfiguration: {
      subnetResourceId: '<subnetResourceId>'
    }
  }
]
param apiDiagnostics = [
  {
    apiName: 'echo-api'
    loggerName: 'logger'
    metrics: true
    name: 'applicationinsights'
  }
]
param apis = [
  {
    apiVersionSetName: 'echo-version-set'
    displayName: 'Echo API'
    name: 'echo-api'
    path: 'echo'
    protocols: [
      'http'
      'https'
    ]
    serviceUrl: 'http://echoapi.cloudapp.net/api'
  }
]
param apiVersionSets = [
  {
    description: 'echo-version-set'
    displayName: 'echo-version-set'
    name: 'echo-version-set'
    versioningScheme: 'Segment'
  }
]
param authorizationServers = [
  {
    authorizationEndpoint: '<authorizationEndpoint>'
    clientId: 'apimclientid'
    clientRegistrationEndpoint: 'http://localhost'
    clientSecret: '<clientSecret>'
    displayName: 'AuthServer1'
    grantTypes: [
      'authorizationCode'
    ]
    name: 'AuthServer1'
    tokenEndpoint: '<tokenEndpoint>'
  }
]
param backends = [
  {
    name: 'backend'
    tls: {
      validateCertificateChain: false
      validateCertificateName: false
    }
    url: 'http://echoapi.cloudapp.net/api'
  }
]
param caches = [
  {
    connectionString: 'connectionstringtest'
    name: 'westeurope'
    useFromLocation: 'westeurope'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param identityProviders = [
  {
    allowedTenants: [
      'mytenant.onmicrosoft.com'
    ]
    authority: '<authority>'
    clientId: 'apimClientid'
    clientLibrary: 'MSAL-2'
    clientSecret: 'apimSlientSecret'
    name: 'aad'
    signInTenant: 'mytenant.onmicrosoft.com'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param loggers = [
  {
    credentials: {
      instrumentationKey: '<instrumentationKey>'
    }
    description: 'Logger to Azure Application Insights'
    isBuffered: false
    name: 'logger'
    targetResourceId: '<targetResourceId>'
    type: 'applicationInsights'
  }
]
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param namedValues = [
  {
    displayName: 'apimkey'
    name: 'apimkey'
    secret: true
  }
]
param policies = [
  {
    format: 'xml'
    value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
  }
]
param portalsettings = [
  {
    name: 'signin'
    properties: {
      enabled: false
    }
  }
  {
    name: 'signup'
    properties: {
      enabled: false
      termsOfService: {
        consentRequired: false
        enabled: false
      }
    }
  }
]
param products = [
  {
    apis: [
      'echo-api'
    ]
    approvalRequired: false
    displayName: 'Starter'
    groups: [
      'developers'
    ]
    name: 'Starter'
    subscriptionRequired: false
  }
]
param publicIpAddressResourceId = '<publicIpAddressResourceId>'
param publicNetworkAccess = 'Enabled'
param roleAssignments = [
  {
    name: '6352c3e3-ac6b-43d5-ac43-1077ff373721'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param subnetResourceId = '<subnetResourceId>'
param subscriptions = [
  {
    displayName: 'testArmSubscriptionAllApis'
    name: 'testArmSubscriptionAllApis'
    scope: '/apis'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkType = 'Internal'
```

</details>
<p>

### Example 5: _Deploying an APIM v2 sku_

This instance deploys the module using a v2 SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/v2Sku]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: {
    // Required parameters
    name: 'apisv2s001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    enableDeveloperPortal: true
    sku: 'BasicV2'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apisv2s001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "enableDeveloperPortal": {
      "value": true
    },
    "sku": {
      "value": "BasicV2"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-management/service:<version>'

// Required parameters
param name = 'apisv2s001'
param publisherEmail = 'apimgmt-noreply@mail.windowsazure.com'
param publisherName = 'az-amorg-x-001'
// Non-required parameters
param enableDeveloperPortal = true
param sku = 'BasicV2'
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  params: {
    // Required parameters
    name: 'apiswaf002'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    additionalLocations: [
      {
        availabilityZones: [
          1
          2
          3
        ]
        disableGateway: false
        location: '<location>'
        sku: {
          capacity: 3
          name: 'Premium'
        }
      }
    ]
    apis: [
      {
        apiVersionSetName: 'echo-version-set'
        description: 'An echo API service'
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        protocols: [
          'https'
        ]
        serviceUrl: 'https://echoapi.cloudapp.net/api'
      }
    ]
    apiVersionSets: [
      {
        description: 'An echo API version set'
        displayName: 'Echo version set'
        name: 'echo-version-set'
        versioningScheme: 'Segment'
      }
    ]
    authorizationServers: [
      {
        authorizationEndpoint: '<authorizationEndpoint>'
        clientId: 'apimClientid'
        clientRegistrationEndpoint: 'https://localhost'
        clientSecret: '<clientSecret>'
        displayName: 'AuthServer1'
        grantTypes: [
          'authorizationCode'
        ]
        name: 'AuthServer1'
        tokenEndpoint: '<tokenEndpoint>'
      }
    ]
    backends: [
      {
        name: 'backend'
        tls: {
          validateCertificateChain: true
          validateCertificateName: true
        }
        url: 'https://echoapi.cloudapp.net/api'
      }
    ]
    caches: [
      {
        connectionString: 'connectionstringtest'
        name: 'westeurope'
        useFromLocation: 'westeurope'
      }
    ]
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'True'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    identityProviders: [
      {
        allowedTenants: [
          'mytenant.onmicrosoft.com'
        ]
        authority: '<authority>'
        clientId: 'apimClientid'
        clientLibrary: 'MSAL-2'
        clientSecret: '<clientSecret>'
        name: 'aad'
        signInTenant: 'mytenant.onmicrosoft.com'
      }
    ]
    loggers: [
      {
        credentials: {
          instrumentationKey: '<instrumentationKey>'
        }
        description: 'Logger to Azure Application Insights'
        isBuffered: false
        name: 'logger'
        targetResourceId: '<targetResourceId>'
        type: 'applicationInsights'
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    namedValues: [
      {
        displayName: 'apimkey'
        name: 'apimkey'
        secret: true
      }
    ]
    policies: [
      {
        format: 'xml'
        value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
      }
    ]
    portalsettings: [
      {
        name: 'signin'
        properties: {
          enabled: false
        }
      }
      {
        name: 'signup'
        properties: {
          enabled: false
          termsOfService: {
            consentRequired: false
            enabled: false
          }
        }
      }
    ]
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    products: [
      {
        apis: [
          'echo-api'
        ]
        approvalRequired: true
        description: 'This is an echo API'
        displayName: 'Echo API'
        groups: [
          'developers'
        ]
        name: 'Starter'
        subscriptionRequired: true
        terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
      }
    ]
    publicNetworkAccess: '<publicNetworkAccess>'
    subscriptions: [
      {
        displayName: 'testArmSubscriptionAllApis'
        name: 'testArmSubscriptionAllApis'
        scope: '/apis'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apiswaf002"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
    "additionalLocations": {
      "value": [
        {
          "availabilityZones": [
            1,
            2,
            3
          ],
          "disableGateway": false,
          "location": "<location>",
          "sku": {
            "capacity": 3,
            "name": "Premium"
          }
        }
      ]
    },
    "apis": {
      "value": [
        {
          "apiVersionSetName": "echo-version-set",
          "description": "An echo API service",
          "displayName": "Echo API",
          "name": "echo-api",
          "path": "echo",
          "protocols": [
            "https"
          ],
          "serviceUrl": "https://echoapi.cloudapp.net/api"
        }
      ]
    },
    "apiVersionSets": {
      "value": [
        {
          "description": "An echo API version set",
          "displayName": "Echo version set",
          "name": "echo-version-set",
          "versioningScheme": "Segment"
        }
      ]
    },
    "authorizationServers": {
      "value": [
        {
          "authorizationEndpoint": "<authorizationEndpoint>",
          "clientId": "apimClientid",
          "clientRegistrationEndpoint": "https://localhost",
          "clientSecret": "<clientSecret>",
          "displayName": "AuthServer1",
          "grantTypes": [
            "authorizationCode"
          ],
          "name": "AuthServer1",
          "tokenEndpoint": "<tokenEndpoint>"
        }
      ]
    },
    "backends": {
      "value": [
        {
          "name": "backend",
          "tls": {
            "validateCertificateChain": true,
            "validateCertificateName": true
          },
          "url": "https://echoapi.cloudapp.net/api"
        }
      ]
    },
    "caches": {
      "value": [
        {
          "connectionString": "connectionstringtest",
          "name": "westeurope",
          "useFromLocation": "westeurope"
        }
      ]
    },
    "customProperties": {
      "value": {
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2": "True",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10": "False",
        "Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11": "False"
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "identityProviders": {
      "value": [
        {
          "allowedTenants": [
            "mytenant.onmicrosoft.com"
          ],
          "authority": "<authority>",
          "clientId": "apimClientid",
          "clientLibrary": "MSAL-2",
          "clientSecret": "<clientSecret>",
          "name": "aad",
          "signInTenant": "mytenant.onmicrosoft.com"
        }
      ]
    },
    "loggers": {
      "value": [
        {
          "credentials": {
            "instrumentationKey": "<instrumentationKey>"
          },
          "description": "Logger to Azure Application Insights",
          "isBuffered": false,
          "name": "logger",
          "targetResourceId": "<targetResourceId>",
          "type": "applicationInsights"
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "namedValues": {
      "value": [
        {
          "displayName": "apimkey",
          "name": "apimkey",
          "secret": true
        }
      ]
    },
    "policies": {
      "value": [
        {
          "format": "xml",
          "value": "<policies> <inbound> <rate-limit-by-key calls=\"250\" renewal-period=\"60\" counter-key=\"@(context.Request.IpAddress)\" /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>"
        }
      ]
    },
    "portalsettings": {
      "value": [
        {
          "name": "signin",
          "properties": {
            "enabled": false
          }
        },
        {
          "name": "signup",
          "properties": {
            "enabled": false,
            "termsOfService": {
              "consentRequired": false,
              "enabled": false
            }
          }
        }
      ]
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "subnetResourceId": "<subnetResourceId>"
        }
      ]
    },
    "products": {
      "value": [
        {
          "apis": [
            "echo-api"
          ],
          "approvalRequired": true,
          "description": "This is an echo API",
          "displayName": "Echo API",
          "groups": [
            "developers"
          ],
          "name": "Starter",
          "subscriptionRequired": true,
          "terms": "By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes."
        }
      ]
    },
    "publicNetworkAccess": {
      "value": "<publicNetworkAccess>"
    },
    "subscriptions": {
      "value": [
        {
          "displayName": "testArmSubscriptionAllApis",
          "name": "testArmSubscriptionAllApis",
          "scope": "/apis"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/api-management/service:<version>'

// Required parameters
param name = 'apiswaf002'
param publisherEmail = 'apimgmt-noreply@mail.windowsazure.com'
param publisherName = 'az-amorg-x-001'
// Non-required parameters
param additionalLocations = [
  {
    availabilityZones: [
      1
      2
      3
    ]
    disableGateway: false
    location: '<location>'
    sku: {
      capacity: 3
      name: 'Premium'
    }
  }
]
param apis = [
  {
    apiVersionSetName: 'echo-version-set'
    description: 'An echo API service'
    displayName: 'Echo API'
    name: 'echo-api'
    path: 'echo'
    protocols: [
      'https'
    ]
    serviceUrl: 'https://echoapi.cloudapp.net/api'
  }
]
param apiVersionSets = [
  {
    description: 'An echo API version set'
    displayName: 'Echo version set'
    name: 'echo-version-set'
    versioningScheme: 'Segment'
  }
]
param authorizationServers = [
  {
    authorizationEndpoint: '<authorizationEndpoint>'
    clientId: 'apimClientid'
    clientRegistrationEndpoint: 'https://localhost'
    clientSecret: '<clientSecret>'
    displayName: 'AuthServer1'
    grantTypes: [
      'authorizationCode'
    ]
    name: 'AuthServer1'
    tokenEndpoint: '<tokenEndpoint>'
  }
]
param backends = [
  {
    name: 'backend'
    tls: {
      validateCertificateChain: true
      validateCertificateName: true
    }
    url: 'https://echoapi.cloudapp.net/api'
  }
]
param caches = [
  {
    connectionString: 'connectionstringtest'
    name: 'westeurope'
    useFromLocation: 'westeurope'
  }
]
param customProperties = {
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'True'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
  'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param identityProviders = [
  {
    allowedTenants: [
      'mytenant.onmicrosoft.com'
    ]
    authority: '<authority>'
    clientId: 'apimClientid'
    clientLibrary: 'MSAL-2'
    clientSecret: '<clientSecret>'
    name: 'aad'
    signInTenant: 'mytenant.onmicrosoft.com'
  }
]
param loggers = [
  {
    credentials: {
      instrumentationKey: '<instrumentationKey>'
    }
    description: 'Logger to Azure Application Insights'
    isBuffered: false
    name: 'logger'
    targetResourceId: '<targetResourceId>'
    type: 'applicationInsights'
  }
]
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param namedValues = [
  {
    displayName: 'apimkey'
    name: 'apimkey'
    secret: true
  }
]
param policies = [
  {
    format: 'xml'
    value: '<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period=\'60\' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
  }
]
param portalsettings = [
  {
    name: 'signin'
    properties: {
      enabled: false
    }
  }
  {
    name: 'signup'
    properties: {
      enabled: false
      termsOfService: {
        consentRequired: false
        enabled: false
      }
    }
  }
]
param privateEndpoints = [
  {
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    subnetResourceId: '<subnetResourceId>'
  }
]
param products = [
  {
    apis: [
      'echo-api'
    ]
    approvalRequired: true
    description: 'This is an echo API'
    displayName: 'Echo API'
    groups: [
      'developers'
    ]
    name: 'Starter'
    subscriptionRequired: true
    terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
  }
]
param publicNetworkAccess = '<publicNetworkAccess>'
param subscriptions = [
  {
    displayName: 'testArmSubscriptionAllApis'
    name: 'testArmSubscriptionAllApis'
    scope: '/apis'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the API Management service. |
| [`publisherEmail`](#parameter-publisheremail) | string | The email address of the owner of the service. |
| [`publisherName`](#parameter-publishername) | string | The name of the owner of the service. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`skuCapacity`](#parameter-skucapacity) | int | The scale units for this API Management service. Required if using Basic, Standard, or Premium skus. For range of capacities for each sku, reference https://azure.microsoft.com/en-us/pricing/details/api-management/. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalLocations`](#parameter-additionallocations) | array | Additional datacenter locations of the API Management service. Not supported with V2 SKUs. |
| [`apiDiagnostics`](#parameter-apidiagnostics) | array | API Diagnostics. |
| [`apis`](#parameter-apis) | array | APIs. |
| [`apiVersionSets`](#parameter-apiversionsets) | array | API Version Sets. |
| [`authorizationServers`](#parameter-authorizationservers) | array | Authorization servers. |
| [`availabilityZones`](#parameter-availabilityzones) | array | A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku. |
| [`backends`](#parameter-backends) | array | Backends. |
| [`caches`](#parameter-caches) | array | Caches. |
| [`certificates`](#parameter-certificates) | array | List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10. |
| [`customProperties`](#parameter-customproperties) | object | Custom properties of the API Management service. Not supported if SKU is Consumption. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableGateway`](#parameter-disablegateway) | bool | Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region. |
| [`enableClientCertificate`](#parameter-enableclientcertificate) | bool | Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway. |
| [`enableDeveloperPortal`](#parameter-enabledeveloperportal) | bool | Enable the Developer Portal. The developer portal is not supported on the Consumption SKU. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hostnameConfigurations`](#parameter-hostnameconfigurations) | array | Custom hostname configuration of the API Management service. |
| [`identityProviders`](#parameter-identityproviders) | array | Identity providers. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`loggers`](#parameter-loggers) | array | Loggers. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`minApiVersion`](#parameter-minapiversion) | string | Limit control plane API calls to API Management service with version equal to or newer than this value. |
| [`namedValues`](#parameter-namedvalues) | array | Named values. |
| [`newGuidValue`](#parameter-newguidvalue) | string | Necessary to create a new GUID. |
| [`notificationSenderEmail`](#parameter-notificationsenderemail) | string | The notification sender email address for the service. |
| [`policies`](#parameter-policies) | array | Policies. |
| [`portalsettings`](#parameter-portalsettings) | array | Portal settings. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`products`](#parameter-products) | array | Products. |
| [`publicIpAddressResourceId`](#parameter-publicipaddressresourceid) | string | Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public endpoint access is allowed for this API Management service. If set to 'Disabled', private endpoints are the exclusive access method. MUST be enabled during service creation. |
| [`restore`](#parameter-restore) | bool | Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | The pricing tier of this API Management service. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The full resource ID of a subnet in a virtual network to deploy the API Management service in. |
| [`subscriptions`](#parameter-subscriptions) | array | Subscriptions. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkType`](#parameter-virtualnetworktype) | string | The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. |

### Parameter: `name`

The name of the API Management service.

- Required: Yes
- Type: string

### Parameter: `publisherEmail`

The email address of the owner of the service.

- Required: Yes
- Type: string

### Parameter: `publisherName`

The name of the owner of the service.

- Required: Yes
- Type: string

### Parameter: `skuCapacity`

The scale units for this API Management service. Required if using Basic, Standard, or Premium skus. For range of capacities for each sku, reference https://azure.microsoft.com/en-us/pricing/details/api-management/.

- Required: No
- Type: int
- Default: `3`

### Parameter: `additionalLocations`

Additional datacenter locations of the API Management service. Not supported with V2 SKUs.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-additionallocationslocation) | string | The location name of the additional region among Azure Data center regions. |
| [`sku`](#parameter-additionallocationssku) | object | SKU properties of the API Management service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-additionallocationsavailabilityzones) | array | A list of availability zones denoting where the resource needs to come from. |
| [`disableGateway`](#parameter-additionallocationsdisablegateway) | bool | Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in this additional location. |
| [`natGatewayState`](#parameter-additionallocationsnatgatewaystate) | string | Property can be used to enable NAT Gateway for this API Management service. |
| [`publicIpAddressResourceId`](#parameter-additionallocationspublicipaddressresourceid) | string | Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the location. Supported only for Premium SKU being deployed in Virtual Network. |
| [`virtualNetworkConfiguration`](#parameter-additionallocationsvirtualnetworkconfiguration) | object | Virtual network configuration for the location. |

### Parameter: `additionalLocations.location`

The location name of the additional region among Azure Data center regions.

- Required: Yes
- Type: string

### Parameter: `additionalLocations.sku`

SKU properties of the API Management service.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-additionallocationsskucapacity) | int | Capacity of the SKU (number of deployed units of the SKU). For Consumption SKU capacity must be specified as 0. |
| [`name`](#parameter-additionallocationsskuname) | string | Name of the Sku. |

### Parameter: `additionalLocations.sku.capacity`

Capacity of the SKU (number of deployed units of the SKU). For Consumption SKU capacity must be specified as 0.

- Required: Yes
- Type: int

### Parameter: `additionalLocations.sku.name`

Name of the Sku.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'BasicV2'
    'Consumption'
    'Developer'
    'Isolated'
    'Premium'
    'Standard'
    'StandardV2'
  ]
  ```

### Parameter: `additionalLocations.availabilityZones`

A list of availability zones denoting where the resource needs to come from.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `additionalLocations.disableGateway`

Property only valid for an Api Management service deployed in multiple locations. This can be used to disable the gateway in this additional location.

- Required: No
- Type: bool

### Parameter: `additionalLocations.natGatewayState`

Property can be used to enable NAT Gateway for this API Management service.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `additionalLocations.publicIpAddressResourceId`

Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the location. Supported only for Premium SKU being deployed in Virtual Network.

- Required: No
- Type: string

### Parameter: `additionalLocations.virtualNetworkConfiguration`

Virtual network configuration for the location.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-additionallocationsvirtualnetworkconfigurationsubnetresourceid) | string | The full resource ID of a subnet in a virtual network to deploy the API Management service in. |

### Parameter: `additionalLocations.virtualNetworkConfiguration.subnetResourceId`

The full resource ID of a subnet in a virtual network to deploy the API Management service in.

- Required: Yes
- Type: string

### Parameter: `apiDiagnostics`

API Diagnostics.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiName`](#parameter-apidiagnosticsapiname) | string | The name of the parent API. |
| [`loggerName`](#parameter-apidiagnosticsloggername) | string | The name of the logger. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`httpCorrelationProtocol`](#parameter-apidiagnosticshttpcorrelationprotocol) | string | Sets correlation protocol to use for Application Insights diagnostics. Required if using Application Insights. |
| [`metrics`](#parameter-apidiagnosticsmetrics) | bool | Emit custom metrics via emit-metric policy. Required if using Application Insights. |
| [`operationNameFormat`](#parameter-apidiagnosticsoperationnameformat) | string | The format of the Operation Name for Application Insights telemetries. Required if using Application Insights. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alwaysLog`](#parameter-apidiagnosticsalwayslog) | string | Specifies for what type of messages sampling settings should not apply. |
| [`backend`](#parameter-apidiagnosticsbackend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Backend. |
| [`frontend`](#parameter-apidiagnosticsfrontend) | object | Diagnostic settings for incoming/outgoing HTTP messages to the Gateway. |
| [`logClientIp`](#parameter-apidiagnosticslogclientip) | bool | Log the ClientIP. |
| [`name`](#parameter-apidiagnosticsname) | string | Type of diagnostic resource. |
| [`samplingPercentage`](#parameter-apidiagnosticssamplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged. |
| [`verbosity`](#parameter-apidiagnosticsverbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `apiDiagnostics.apiName`

The name of the parent API.

- Required: Yes
- Type: string

### Parameter: `apiDiagnostics.loggerName`

The name of the logger.

- Required: Yes
- Type: string

### Parameter: `apiDiagnostics.httpCorrelationProtocol`

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

### Parameter: `apiDiagnostics.metrics`

Emit custom metrics via emit-metric policy. Required if using Application Insights.

- Required: No
- Type: bool

### Parameter: `apiDiagnostics.operationNameFormat`

The format of the Operation Name for Application Insights telemetries. Required if using Application Insights.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Name'
    'URI'
  ]
  ```

### Parameter: `apiDiagnostics.alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string

### Parameter: `apiDiagnostics.backend`

Diagnostic settings for incoming/outgoing HTTP messages to the Backend.

- Required: No
- Type: object

### Parameter: `apiDiagnostics.frontend`

Diagnostic settings for incoming/outgoing HTTP messages to the Gateway.

- Required: No
- Type: object

### Parameter: `apiDiagnostics.logClientIp`

Log the ClientIP.

- Required: No
- Type: bool

### Parameter: `apiDiagnostics.name`

Type of diagnostic resource.

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

### Parameter: `apiDiagnostics.samplingPercentage`

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged.

- Required: No
- Type: int

### Parameter: `apiDiagnostics.verbosity`

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

### Parameter: `apis`

APIs.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-apisdisplayname) | string | API name. Must be 1 to 300 characters long. |
| [`name`](#parameter-apisname) | string | API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number. |
| [`path`](#parameter-apispath) | string | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiRevision`](#parameter-apisapirevision) | string | Describes the Revision of the API. If no value is provided, default revision 1 is created. |
| [`apiRevisionDescription`](#parameter-apisapirevisiondescription) | string | Description of the API Revision. |
| [`apiType`](#parameter-apisapitype) | string | Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API. |
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
| [`protocols`](#parameter-apisprotocols) | array | Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS. |
| [`serviceUrl`](#parameter-apisserviceurl) | string | Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long. |
| [`sourceApiId`](#parameter-apissourceapiid) | string | API identifier of the source API. |
| [`subscriptionKeyParameterNames`](#parameter-apissubscriptionkeyparameternames) | object | Protocols over which API is made available. |
| [`subscriptionRequired`](#parameter-apissubscriptionrequired) | bool | Specifies whether an API or Product subscription is required for accessing the API. |
| [`type`](#parameter-apistype) | string | Type of API. |
| [`value`](#parameter-apisvalue) | string | Content value when Importing an API. |

### Parameter: `apis.displayName`

API name. Must be 1 to 300 characters long.

- Required: Yes
- Type: string

### Parameter: `apis.name`

API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.

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

Type of API to create. * http creates a REST API * soap creates a SOAP pass-through API * websocket creates websocket API * graphql creates GraphQL API.

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
| [`loggerName`](#parameter-apisdiagnosticsloggername) | string | The name of the logger. |

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
| [`name`](#parameter-apisdiagnosticsname) | string | Type of diagnostic resource. |
| [`samplingPercentage`](#parameter-apisdiagnosticssamplingpercentage) | int | Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged. |
| [`verbosity`](#parameter-apisdiagnosticsverbosity) | string | The verbosity level applied to traces emitted by trace policies. |

### Parameter: `apis.diagnostics.loggerName`

The name of the logger.

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
    'URI'
  ]
  ```

### Parameter: `apis.diagnostics.alwaysLog`

Specifies for what type of messages sampling settings should not apply.

- Required: No
- Type: string

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

Type of diagnostic resource.

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

Rate of sampling for fixed-rate sampling. Specifies the percentage of requests that are logged. 0% sampling means zero requests logged, while 100% sampling means all requests logged.

- Required: No
- Type: int

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
| [`name`](#parameter-apisoperationsname) | string | The name of the policy. |
| [`urlTemplate`](#parameter-apisoperationsurltemplate) | string | Relative URL template identifying the target resource for this operation. May include parameters. Example: /customers/{cid}/orders/{oid}/?date={date}. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apisoperationsdescription) | string | Description of the operation. May include HTML formatting tags. Must not be longer than 1.000 characters. |
| [`policies`](#parameter-apisoperationspolicies) | array | The policies to apply to the operation. |
| [`request`](#parameter-apisoperationsrequest) | object | An entity containing request details. |
| [`responses`](#parameter-apisoperationsresponses) | array | An entity containing request details. |
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

The name of the policy.

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
| [`format`](#parameter-apisoperationspoliciesformat) | string | Format of the policyContent. |
| [`name`](#parameter-apisoperationspoliciesname) | string | The name of the policy. |
| [`value`](#parameter-apisoperationspoliciesvalue) | string | Contents of the Policy as defined by the format. |

### Parameter: `apis.operations.policies.format`

Format of the policyContent.

- Required: Yes
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

- Required: Yes
- Type: string

### Parameter: `apis.operations.policies.value`

Contents of the Policy as defined by the format.

- Required: Yes
- Type: string

### Parameter: `apis.operations.request`

An entity containing request details.

- Required: No
- Type: object

### Parameter: `apis.operations.responses`

An entity containing request details.

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

Describes on which protocols the operations in this API can be invoked. - HTTP or HTTPS.

- Required: No
- Type: array

### Parameter: `apis.serviceUrl`

Absolute URL of the backend service implementing this API. Cannot be more than 2000 characters long.

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
    'http'
    'soap'
    'websocket'
  ]
  ```

### Parameter: `apis.value`

Content value when Importing an API.

- Required: No
- Type: string

### Parameter: `apiVersionSets`

API Version Sets.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-apiversionsetsdisplayname) | string | The display name of the Name of API Version Set. |
| [`name`](#parameter-apiversionsetsname) | string | API Version set name. |
| [`versioningScheme`](#parameter-apiversionsetsversioningscheme) | string | An value that determines where the API Version identifier will be located in a HTTP request. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-apiversionsetsdescription) | string | Description of API Version Set. |
| [`versionHeaderName`](#parameter-apiversionsetsversionheadername) | string | Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header. |
| [`versionQueryName`](#parameter-apiversionsetsversionqueryname) | string | Name of query parameter that indicates the API Version if versioningScheme is set to query. |

### Parameter: `apiVersionSets.displayName`

The display name of the Name of API Version Set.

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

### Parameter: `authorizationServers`

Authorization servers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationEndpoint`](#parameter-authorizationserversauthorizationendpoint) | string | OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>. |
| [`clientId`](#parameter-authorizationserversclientid) | securestring | Client or app ID registered with this authorization server. |
| [`clientSecret`](#parameter-authorizationserversclientsecret) | securestring | Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |
| [`displayName`](#parameter-authorizationserversdisplayname) | string | API Management Service Authorization Servers name. Must be 1 to 50 characters long. |
| [`grantTypes`](#parameter-authorizationserversgranttypes) | array | Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials. |
| [`name`](#parameter-authorizationserversname) | string | Identifier of the authorization server. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationMethods`](#parameter-authorizationserversauthorizationmethods) | array | HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE. |
| [`bearerTokenSendingMethods`](#parameter-authorizationserversbearertokensendingmethods) | array | Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query. |
| [`clientAuthenticationMethod`](#parameter-authorizationserversclientauthenticationmethod) | array | Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body. |
| [`clientRegistrationEndpoint`](#parameter-authorizationserversclientregistrationendpoint) | string | Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced. |
| [`defaultScope`](#parameter-authorizationserversdefaultscope) | string | Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values. |
| [`resourceOwnerPassword`](#parameter-authorizationserversresourceownerpassword) | securestring | Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password. |
| [`resourceOwnerUsername`](#parameter-authorizationserversresourceownerusername) | string | Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username. |
| [`serverDescription`](#parameter-authorizationserversserverdescription) | string | Description of the authorization server. Can contain HTML formatting tags. |
| [`supportState`](#parameter-authorizationserverssupportstate) | bool | If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security. |
| [`tokenBodyParameters`](#parameter-authorizationserverstokenbodyparameters) | array | Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object. |
| [`tokenEndpoint`](#parameter-authorizationserverstokenendpoint) | string | OAuth token endpoint. Contains absolute URI to entity being referenced. |

### Parameter: `authorizationServers.authorizationEndpoint`

OAuth authorization endpoint. See <http://tools.ietf.org/html/rfc6749#section-3.2>.

- Required: Yes
- Type: string

### Parameter: `authorizationServers.clientId`

Client or app ID registered with this authorization server.

- Required: Yes
- Type: securestring

### Parameter: `authorizationServers.clientSecret`

Client or app secret registered with this authorization server. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.

- Required: Yes
- Type: securestring

### Parameter: `authorizationServers.displayName`

API Management Service Authorization Servers name. Must be 1 to 50 characters long.

- Required: Yes
- Type: string

### Parameter: `authorizationServers.grantTypes`

Form of an authorization grant, which the client uses to request the access token. - authorizationCode, implicit, resourceOwnerPassword, clientCredentials.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'authorizationCode'
    'clientCredentials'
    'implicit'
    'resourceOwnerPassword'
  ]
  ```

### Parameter: `authorizationServers.name`

Identifier of the authorization server.

- Required: Yes
- Type: string

### Parameter: `authorizationServers.authorizationMethods`

HTTP verbs supported by the authorization endpoint. GET must be always present. POST is optional. - HEAD, OPTIONS, TRACE, GET, POST, PUT, PATCH, DELETE.

- Required: No
- Type: array

### Parameter: `authorizationServers.bearerTokenSendingMethods`

Specifies the mechanism by which access token is passed to the API. - authorizationHeader or query.

- Required: No
- Type: array

### Parameter: `authorizationServers.clientAuthenticationMethod`

Method of authentication supported by the token endpoint of this authorization server. Possible values are Basic and/or Body. When Body is specified, client credentials and other parameters are passed within the request body in the application/x-www-form-urlencoded format. - Basic or Body.

- Required: No
- Type: array

### Parameter: `authorizationServers.clientRegistrationEndpoint`

Optional reference to a page where client or app registration for this authorization server is performed. Contains absolute URL to entity being referenced.

- Required: No
- Type: string

### Parameter: `authorizationServers.defaultScope`

Access token scope that is going to be requested by default. Can be overridden at the API level. Should be provided in the form of a string containing space-delimited values.

- Required: No
- Type: string

### Parameter: `authorizationServers.resourceOwnerPassword`

Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner password.

- Required: No
- Type: securestring

### Parameter: `authorizationServers.resourceOwnerUsername`

Can be optionally specified when resource owner password grant type is supported by this authorization server. Default resource owner username.

- Required: No
- Type: string

### Parameter: `authorizationServers.serverDescription`

Description of the authorization server. Can contain HTML formatting tags.

- Required: No
- Type: string

### Parameter: `authorizationServers.supportState`

If true, authorization server will include state parameter from the authorization request to its response. Client may use state parameter to raise protocol security.

- Required: No
- Type: bool

### Parameter: `authorizationServers.tokenBodyParameters`

Additional parameters required by the token endpoint of this authorization server represented as an array of JSON objects with name and value string properties, i.e. {"name" : "name value", "value": "a value"}. - TokenBodyParameterContract object.

- Required: No
- Type: array

### Parameter: `authorizationServers.tokenEndpoint`

OAuth token endpoint. Contains absolute URI to entity being referenced.

- Required: No
- Type: string

### Parameter: `availabilityZones`

A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `backends`

Backends.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-backendsname) | string | Backend Name. |
| [`url`](#parameter-backendsurl) | string | Runtime URL of the Backend. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-backendscredentials) | object | Backend Credentials Contract Properties. |
| [`description`](#parameter-backendsdescription) | string | Backend Description. |
| [`protocol`](#parameter-backendsprotocol) | string | Backend communication protocol. - http or soap. |
| [`proxy`](#parameter-backendsproxy) | object | Backend Proxy Contract Properties. |
| [`resourceId`](#parameter-backendsresourceid) | string | Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. |
| [`serviceFabricCluster`](#parameter-backendsservicefabriccluster) | object | Backend Service Fabric Cluster Properties. |
| [`title`](#parameter-backendstitle) | string | Backend Title. |
| [`tls`](#parameter-backendstls) | object | Backend TLS Properties. |

### Parameter: `backends.name`

Backend Name.

- Required: Yes
- Type: string

### Parameter: `backends.url`

Runtime URL of the Backend.

- Required: Yes
- Type: string

### Parameter: `backends.credentials`

Backend Credentials Contract Properties.

- Required: No
- Type: object

### Parameter: `backends.description`

Backend Description.

- Required: No
- Type: string

### Parameter: `backends.protocol`

Backend communication protocol. - http or soap.

- Required: No
- Type: string

### Parameter: `backends.proxy`

Backend Proxy Contract Properties.

- Required: No
- Type: object

### Parameter: `backends.resourceId`

Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.

- Required: No
- Type: string

### Parameter: `backends.serviceFabricCluster`

Backend Service Fabric Cluster Properties.

- Required: No
- Type: object

### Parameter: `backends.title`

Backend Title.

- Required: No
- Type: string

### Parameter: `backends.tls`

Backend TLS Properties.

- Required: No
- Type: object

### Parameter: `caches`

Caches.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionString`](#parameter-cachesconnectionstring) | string | Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}. |
| [`name`](#parameter-cachesname) | string | Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier). |
| [`useFromLocation`](#parameter-cachesusefromlocation) | string | Location identifier to use cache from (should be either 'default' or valid Azure region identifier). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-cachesdescription) | string | Cache description. |
| [`resourceId`](#parameter-cachesresourceid) | string | Original uri of entity in external system cache points to. |

### Parameter: `caches.connectionString`

Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}.

- Required: Yes
- Type: string

### Parameter: `caches.name`

Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).

- Required: Yes
- Type: string

### Parameter: `caches.useFromLocation`

Location identifier to use cache from (should be either 'default' or valid Azure region identifier).

- Required: Yes
- Type: string

### Parameter: `caches.description`

Cache description.

- Required: No
- Type: string

### Parameter: `caches.resourceId`

Original uri of entity in external system cache points to.

- Required: No
- Type: string

### Parameter: `certificates`

List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.

- Required: No
- Type: array

### Parameter: `customProperties`

Custom properties of the API Management service. Not supported if SKU is Consumption.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
  }
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
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
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

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

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

### Parameter: `disableGateway`

Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableClientCertificate`

Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDeveloperPortal`

Enable the Developer Portal. The developer portal is not supported on the Consumption SKU.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hostnameConfigurations`

Custom hostname configuration of the API Management service.

- Required: No
- Type: array

### Parameter: `identityProviders`

Identity providers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-identityprovidersname) | string | Identity provider name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-identityprovidersclientid) | string | Client ID of the Application in the external Identity Provider. Required if identity provider is used. |
| [`clientSecret`](#parameter-identityprovidersclientsecret) | securestring | Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedTenants`](#parameter-identityprovidersallowedtenants) | array | List of Allowed Tenants when configuring Azure Active Directory login. - string. |
| [`authority`](#parameter-identityprovidersauthority) | string | OpenID Connect discovery endpoint hostname for AAD or AAD B2C. |
| [`clientLibrary`](#parameter-identityprovidersclientlibrary) | string | The client library to be used in the developer portal. Only applies to AAD and AAD B2C Identity Provider. |
| [`passwordResetPolicyName`](#parameter-identityproviderspasswordresetpolicyname) | string | Password Reset Policy Name. Only applies to AAD B2C Identity Provider. |
| [`profileEditingPolicyName`](#parameter-identityprovidersprofileeditingpolicyname) | string | Profile Editing Policy Name. Only applies to AAD B2C Identity Provider. |
| [`signInPolicyName`](#parameter-identityproviderssigninpolicyname) | string | Signin Policy Name. Only applies to AAD B2C Identity Provider. |
| [`signInTenant`](#parameter-identityproviderssignintenant) | string | The TenantId to use instead of Common when logging into Active Directory. |
| [`signUpPolicyName`](#parameter-identityproviderssignuppolicyname) | string | Signup Policy Name. Only applies to AAD B2C Identity Provider. |
| [`type`](#parameter-identityproviderstype) | string | Identity Provider Type identifier. |

### Parameter: `identityProviders.name`

Identity provider name.

- Required: Yes
- Type: string

### Parameter: `identityProviders.clientId`

Client ID of the Application in the external Identity Provider. Required if identity provider is used.

- Required: No
- Type: string

### Parameter: `identityProviders.clientSecret`

Client secret of the Application in external Identity Provider, used to authenticate login request. Required if identity provider is used.

- Required: No
- Type: securestring

### Parameter: `identityProviders.allowedTenants`

List of Allowed Tenants when configuring Azure Active Directory login. - string.

- Required: No
- Type: array

### Parameter: `identityProviders.authority`

OpenID Connect discovery endpoint hostname for AAD or AAD B2C.

- Required: No
- Type: string

### Parameter: `identityProviders.clientLibrary`

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

### Parameter: `identityProviders.passwordResetPolicyName`

Password Reset Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string

### Parameter: `identityProviders.profileEditingPolicyName`

Profile Editing Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string

### Parameter: `identityProviders.signInPolicyName`

Signin Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string

### Parameter: `identityProviders.signInTenant`

The TenantId to use instead of Common when logging into Active Directory.

- Required: No
- Type: string

### Parameter: `identityProviders.signUpPolicyName`

Signup Policy Name. Only applies to AAD B2C Identity Provider.

- Required: No
- Type: string

### Parameter: `identityProviders.type`

Identity Provider Type identifier.

- Required: No
- Type: string
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

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `loggers`

Loggers.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-loggersname) | string | Resource Name. |
| [`type`](#parameter-loggerstype) | string | Logger type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-loggerscredentials) | secureObject | The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub. |
| [`targetResourceId`](#parameter-loggerstargetresourceid) | string | Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-loggersdescription) | string | Logger description. |
| [`isBuffered`](#parameter-loggersisbuffered) | bool | Whether records are buffered in the logger before publishing. |

### Parameter: `loggers.name`

Resource Name.

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

The name and SendRule connection string of the event hub for azureEventHub logger. Instrumentation key for applicationInsights logger. Required if loggerType = applicationInsights or azureEventHub.

- Required: No
- Type: secureObject

### Parameter: `loggers.targetResourceId`

Azure Resource Id of a log target (either Azure Event Hub resource or Azure Application Insights resource). Required if loggerType = applicationInsights or azureEventHub.

- Required: No
- Type: string

### Parameter: `loggers.description`

Logger description.

- Required: No
- Type: string

### Parameter: `loggers.isBuffered`

Whether records are buffered in the logger before publishing.

- Required: No
- Type: bool

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `minApiVersion`

Limit control plane API calls to API Management service with version equal to or newer than this value.

- Required: No
- Type: string

### Parameter: `namedValues`

Named values.

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
| [`secret`](#parameter-namedvaluessecret) | bool | Determines whether the value is a secret and should be encrypted or not. Default value is false. |
| [`tags`](#parameter-namedvaluestags) | array | Tags that when provided can be used to filter the NamedValue list. - string. |
| [`value`](#parameter-namedvaluesvalue) | securestring | Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value. |

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

Determines whether the value is a secret and should be encrypted or not. Default value is false.

- Required: No
- Type: bool

### Parameter: `namedValues.tags`

Tags that when provided can be used to filter the NamedValue list. - string.

- Required: No
- Type: array

### Parameter: `namedValues.value`

Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on 'GET' operations! Use '/listSecrets' POST request to get the value.

- Required: No
- Type: securestring

### Parameter: `newGuidValue`

Necessary to create a new GUID.

- Required: No
- Type: string
- Default: `[newGuid()]`

### Parameter: `notificationSenderEmail`

The notification sender email address for the service.

- Required: No
- Type: string
- Default: `'apimgmt-noreply@mail.windowsazure.com'`

### Parameter: `policies`

Policies.

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

### Parameter: `portalsettings`

Portal settings.

- Required: No
- Type: array
- Discriminator: `name`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`signin`](#variant-portalsettingsname-signin) | The type for sign-in portal settings. |
| [`signup`](#variant-portalsettingsname-signup) | The type for sign-up portal settings. |
| [`delegation`](#variant-portalsettingsname-delegation) | The type for delegation portal settings. |

### Variant: `portalsettings.name-signin`
The type for sign-in portal settings.

To use this variant, set the property `name` to `signin`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-portalsettingsname-signinname) | string | The name of the portal-setting. |
| [`properties`](#parameter-portalsettingsname-signinproperties) | object | The portal-settings contract properties. |

### Parameter: `portalsettings.name-signin.name`

The name of the portal-setting.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'signin'
  ]
  ```

### Parameter: `portalsettings.name-signin.properties`

The portal-settings contract properties.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-portalsettingsname-signinpropertiesenabled) | bool | Redirect Anonymous users to the Sign-In page. |

### Parameter: `portalsettings.name-signin.properties.enabled`

Redirect Anonymous users to the Sign-In page.

- Required: Yes
- Type: bool

### Variant: `portalsettings.name-signup`
The type for sign-up portal settings.

To use this variant, set the property `name` to `signup`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-portalsettingsname-signupname) | string | The name of the portal-setting. |
| [`properties`](#parameter-portalsettingsname-signupproperties) | object | The portal-settings contract properties. |

### Parameter: `portalsettings.name-signup.name`

The name of the portal-setting.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'signup'
  ]
  ```

### Parameter: `portalsettings.name-signup.properties`

The portal-settings contract properties.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-portalsettingsname-signuppropertiesenabled) | bool | Allow users to sign up on a developer portal. |
| [`termsOfService`](#parameter-portalsettingsname-signuppropertiestermsofservice) | object | Terms of service contract properties. |

### Parameter: `portalsettings.name-signup.properties.enabled`

Allow users to sign up on a developer portal.

- Required: No
- Type: bool

### Parameter: `portalsettings.name-signup.properties.termsOfService`

Terms of service contract properties.

- Required: No
- Type: object

**Otional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consentRequired`](#parameter-portalsettingsname-signuppropertiestermsofserviceconsentrequired) | bool | Ask user for consent to the terms of service. |
| [`enabled`](#parameter-portalsettingsname-signuppropertiestermsofserviceenabled) | bool | Display terms of service during a sign-up process. |
| [`text`](#parameter-portalsettingsname-signuppropertiestermsofservicetext) | string | A terms of service text. |

### Parameter: `portalsettings.name-signup.properties.termsOfService.consentRequired`

Ask user for consent to the terms of service.

- Required: No
- Type: bool

### Parameter: `portalsettings.name-signup.properties.termsOfService.enabled`

Display terms of service during a sign-up process.

- Required: No
- Type: bool

### Parameter: `portalsettings.name-signup.properties.termsOfService.text`

A terms of service text.

- Required: No
- Type: string

### Variant: `portalsettings.name-delegation`
The type for delegation portal settings.

To use this variant, set the property `name` to `delegation`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-portalsettingsname-delegationname) | string | The name of the portal-setting. |
| [`properties`](#parameter-portalsettingsname-delegationproperties) | object | The portal-settings contract properties. |

### Parameter: `portalsettings.name-delegation.name`

The name of the portal-setting.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'delegation'
  ]
  ```

### Parameter: `portalsettings.name-delegation.properties`

The portal-settings contract properties.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subscriptions`](#parameter-portalsettingsname-delegationpropertiessubscriptions) | object | Subscriptions delegation settings. |
| [`url`](#parameter-portalsettingsname-delegationpropertiesurl) | string | A delegation Url. |
| [`userRegistration`](#parameter-portalsettingsname-delegationpropertiesuserregistration) | object | User registration delegation settings. |
| [`validationKey`](#parameter-portalsettingsname-delegationpropertiesvalidationkey) | securestring | A base64-encoded validation key to validate, that a request is coming from Azure API Management. |

### Parameter: `portalsettings.name-delegation.properties.subscriptions`

Subscriptions delegation settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-portalsettingsname-delegationpropertiessubscriptionsenabled) | bool | Enable or disable delegation for subscriptions. |

### Parameter: `portalsettings.name-delegation.properties.subscriptions.enabled`

Enable or disable delegation for subscriptions.

- Required: Yes
- Type: bool

### Parameter: `portalsettings.name-delegation.properties.url`

A delegation Url.

- Required: No
- Type: string

### Parameter: `portalsettings.name-delegation.properties.userRegistration`

User registration delegation settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-portalsettingsname-delegationpropertiesuserregistrationenabled) | bool | Enable or disable delegation for user registration. |

### Parameter: `portalsettings.name-delegation.properties.userRegistration.enabled`

Enable or disable delegation for user registration.

- Required: Yes
- Type: bool

### Parameter: `portalsettings.name-delegation.properties.validationKey`

A base64-encoded validation key to validate, that a request is coming from Azure API Management.

- Required: No
- Type: securestring

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-privateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-privateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-privateendpointslocknotes) | string | Specify the notes of the lock. |

### Parameter: `privateEndpoints.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

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

### Parameter: `privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `products`

Products.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-productsdisplayname) | string | API Management Service Products name. Must be 1 to 300 characters long. |
| [`name`](#parameter-productsname) | string | Product Name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apis`](#parameter-productsapis) | array | Names of Product APIs. |
| [`approvalRequired`](#parameter-productsapprovalrequired) | bool | Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the products APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the products APIs. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`description`](#parameter-productsdescription) | string | Product description. May include HTML formatting tags. |
| [`groups`](#parameter-productsgroups) | array | Names of Product Groups. |
| [`state`](#parameter-productsstate) | string | whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published. |
| [`subscriptionRequired`](#parameter-productssubscriptionrequired) | bool | Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it's value is assumed to be true. |
| [`subscriptionsLimit`](#parameter-productssubscriptionslimit) | int | Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false. |
| [`terms`](#parameter-productsterms) | string | Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process. |

### Parameter: `products.displayName`

API Management Service Products name. Must be 1 to 300 characters long.

- Required: Yes
- Type: string

### Parameter: `products.name`

Product Name.

- Required: Yes
- Type: string

### Parameter: `products.apis`

Names of Product APIs.

- Required: No
- Type: array

### Parameter: `products.approvalRequired`

Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the products APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the products APIs. Can be present only if subscriptionRequired property is present and has a value of false.

- Required: No
- Type: bool

### Parameter: `products.description`

Product description. May include HTML formatting tags.

- Required: No
- Type: string

### Parameter: `products.groups`

Names of Product Groups.

- Required: No
- Type: array

### Parameter: `products.state`

whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published.

- Required: No
- Type: string

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

### Parameter: `publicIpAddressResourceId`

Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.

- Required: No
- Type: string

### Parameter: `publicNetworkAccess`

Whether or not public endpoint access is allowed for this API Management service. If set to 'Disabled', private endpoints are the exclusive access method. MUST be enabled during service creation.

- Required: No
- Type: string

### Parameter: `restore`

Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'API Management Developer Portal Content Editor'`
  - `'API Management Service Contributor'`
  - `'API Management Service Operator Role'`
  - `'API Management Service Reader Role'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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

### Parameter: `sku`

The pricing tier of this API Management service.

- Required: No
- Type: string
- Default: `'Premium'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'BasicV2'
    'Consumption'
    'Developer'
    'Premium'
    'Standard'
    'StandardV2'
  ]
  ```

### Parameter: `subnetResourceId`

The full resource ID of a subnet in a virtual network to deploy the API Management service in.

- Required: No
- Type: string

### Parameter: `subscriptions`

Subscriptions.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-subscriptionsdisplayname) | string | API Management Service Subscriptions name. Must be 1 to 100 characters long. |
| [`name`](#parameter-subscriptionsname) | string | Subscription name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowTracing`](#parameter-subscriptionsallowtracing) | bool | Determines whether tracing can be enabled. |
| [`ownerId`](#parameter-subscriptionsownerid) | string | User (user ID path) for whom subscription is being created in form /users/{userId}. |
| [`primaryKey`](#parameter-subscriptionsprimarykey) | string | Primary subscription key. If not specified during request key will be generated automatically. |
| [`scope`](#parameter-subscriptionsscope) | string | Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}". |
| [`secondaryKey`](#parameter-subscriptionssecondarykey) | string | Secondary subscription key. If not specified during request key will be generated automatically. |
| [`state`](#parameter-subscriptionsstate) | string | Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled. |

### Parameter: `subscriptions.displayName`

API Management Service Subscriptions name. Must be 1 to 100 characters long.

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

Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".

- Required: No
- Type: string

### Parameter: `subscriptions.secondaryKey`

Secondary subscription key. If not specified during request key will be generated automatically.

- Required: No
- Type: string

### Parameter: `subscriptions.state`

Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualNetworkType`

The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'External'
    'Internal'
    'None'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the API management service. |
| `privateEndpoints` | array | The private endpoints of the key vault. |
| `resourceGroupName` | string | The resource group the API management service was deployed into. |
| `resourceId` | string | The resource ID of the API management service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.11.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Notes

The latest version of this module only includes supported versions of the API Management resource. All unsupported versions of API Management have been removed from the related parameters. See the [API Management stv1 platform retirement](https://learn.microsoft.com/en-us/azure/api-management/breaking-changes/stv1-platform-retirement-august-2024) article for more details.

### Parameter Usage: `apiManagementServicePolicy`

<details>

<summary>Parameter JSON format</summary>

```json
"apiManagementServicePolicy": {
    "value": {
        "value":"<policies> <inbound> <rate-limit-by-key calls='250' renewal-period='60' counter-key='@(context.Request.IpAddress)' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>",
        "format":"xml"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
apiManagementServicePolicy: {
    value:'<policies> <inbound> <rate-limit-by-key calls=\'250\' renewal-period='60' counter-key=\'@(context.Request.IpAddress)\' /> </inbound> <backend> <forward-request /> </backend> <outbound> </outbound> </policies>'
    format:'xml'
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
