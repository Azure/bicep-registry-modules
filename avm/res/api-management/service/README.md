# API Management Services `[Microsoft.ApiManagement/service]`

This module deploys an API Management Service. The default deployment is set to use a Premium SKU to align with Microsoft WAF-aligned best practices. In most cases, non-prod deployments should use a lower-tier SKU.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service) |
| `Microsoft.ApiManagement/service/apis` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/diagnostics` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/diagnostics) |
| `Microsoft.ApiManagement/service/apis/operations` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/operations) |
| `Microsoft.ApiManagement/service/apis/operations/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/operations/policies) |
| `Microsoft.ApiManagement/service/apis/policies` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apis/policies) |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apiVersionSets) |
| `Microsoft.ApiManagement/service/authorizationServers` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/authorizationServers) |
| `Microsoft.ApiManagement/service/backends` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/backends) |
| `Microsoft.ApiManagement/service/caches` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/caches) |
| `Microsoft.ApiManagement/service/identityProviders` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/identityProviders) |
| `Microsoft.ApiManagement/service/loggers` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/loggers) |
| `Microsoft.ApiManagement/service/namedValues` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/namedValues) |
| `Microsoft.ApiManagement/service/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/policies) |
| `Microsoft.ApiManagement/service/portalsettings` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/portalsettings) |
| `Microsoft.ApiManagement/service/products` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/products) |
| `Microsoft.ApiManagement/service/products/apis` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/products/apis) |
| `Microsoft.ApiManagement/service/products/groups` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/products/groups) |
| `Microsoft.ApiManagement/service/subscriptions` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/subscriptions) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

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


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  name: 'serviceDeployment'
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


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  name: 'serviceDeployment'
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


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  name: 'serviceDeployment'
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


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  name: 'serviceDeployment'
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
        signinTenant: 'mytenant.onmicrosoft.com'
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
        loggerType: 'applicationInsights'
        name: 'logger'
        resourceId: '<resourceId>'
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
          {
            name: 'echo-api'
          }
        ]
        approvalRequired: false
        displayName: 'Starter'
        groups: [
          {
            name: 'developers'
          }
        ]
        name: 'Starter'
        subscriptionRequired: false
      }
    ]
    publicIpAddressResourceId: '<publicIpAddressResourceId>'
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
          "signinTenant": "mytenant.onmicrosoft.com"
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
          "loggerType": "applicationInsights",
          "name": "logger",
          "resourceId": "<resourceId>"
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
            {
              "name": "echo-api"
            }
          ],
          "approvalRequired": false,
          "displayName": "Starter",
          "groups": [
            {
              "name": "developers"
            }
          ],
          "name": "Starter",
          "subscriptionRequired": false
        }
      ]
    },
    "publicIpAddressResourceId": {
      "value": "<publicIpAddressResourceId>"
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
    signinTenant: 'mytenant.onmicrosoft.com'
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
    loggerType: 'applicationInsights'
    name: 'logger'
    resourceId: '<resourceId>'
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
      {
        name: 'echo-api'
      }
    ]
    approvalRequired: false
    displayName: 'Starter'
    groups: [
      {
        name: 'developers'
      }
    ]
    name: 'Starter'
    subscriptionRequired: false
  }
]
param publicIpAddressResourceId = '<publicIpAddressResourceId>'
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


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  name: 'serviceDeployment'
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


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br/public:avm/res/api-management/service:<version>' = {
  name: 'serviceDeployment'
  params: {
    // Required parameters
    name: 'apiswaf001'
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
        signinTenant: 'mytenant.onmicrosoft.com'
      }
    ]
    loggers: [
      {
        credentials: {
          instrumentationKey: '<instrumentationKey>'
        }
        description: 'Logger to Azure Application Insights'
        isBuffered: false
        loggerType: 'applicationInsights'
        name: 'logger'
        resourceId: '<resourceId>'
      }
    ]
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    minApiVersion: '2022-08-01'
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
          {
            name: 'echo-api'
          }
        ]
        approvalRequired: true
        description: 'This is an echo API'
        displayName: 'Echo API'
        groups: [
          {
            name: 'developers'
          }
        ]
        name: 'Starter'
        subscriptionRequired: true
        terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
      }
    ]
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
      "value": "apiswaf001"
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
          "signinTenant": "mytenant.onmicrosoft.com"
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
          "loggerType": "applicationInsights",
          "name": "logger",
          "resourceId": "<resourceId>"
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
    "minApiVersion": {
      "value": "2022-08-01"
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
            {
              "name": "echo-api"
            }
          ],
          "approvalRequired": true,
          "description": "This is an echo API",
          "displayName": "Echo API",
          "groups": [
            {
              "name": "developers"
            }
          ],
          "name": "Starter",
          "subscriptionRequired": true,
          "terms": "By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes."
        }
      ]
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
param name = 'apiswaf001'
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
    signinTenant: 'mytenant.onmicrosoft.com'
  }
]
param loggers = [
  {
    credentials: {
      instrumentationKey: '<instrumentationKey>'
    }
    description: 'Logger to Azure Application Insights'
    isBuffered: false
    loggerType: 'applicationInsights'
    name: 'logger'
    resourceId: '<resourceId>'
  }
]
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param minApiVersion = '2022-08-01'
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
      {
        name: 'echo-api'
      }
    ]
    approvalRequired: true
    description: 'This is an echo API'
    displayName: 'Echo API'
    groups: [
      {
        name: 'developers'
      }
    ]
    name: 'Starter'
    subscriptionRequired: true
    terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
  }
]
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
| [`products`](#parameter-products) | array | Products. |
| [`publicIpAddressResourceId`](#parameter-publicipaddressresourceid) | string | Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network. |
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-authorizationserverstokenbodyparametersname) | string | Body parameter name. |
| [`value`](#parameter-authorizationserverstokenbodyparametersvalue) | string | Body parameter value. |

### Parameter: `authorizationServers.tokenBodyParameters.name`

Body parameter name.

- Required: Yes
- Type: string

### Parameter: `authorizationServers.tokenBodyParameters.value`

Body parameter value.

- Required: Yes
- Type: string

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

### Parameter: `caches`

Caches.

- Required: No
- Type: array

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

### Parameter: `loggers`

Loggers.

- Required: No
- Type: array

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

### Parameter: `portalsettings`

Portal settings.

- Required: No
- Type: array

### Parameter: `products`

Products.

- Required: No
- Type: array

### Parameter: `publicIpAddressResourceId`

Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.

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
| `resourceGroupName` | string | The resource group the API management service was deployed into. |
| `resourceId` | string | The resource ID of the API management service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.1` | Remote reference |

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

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
