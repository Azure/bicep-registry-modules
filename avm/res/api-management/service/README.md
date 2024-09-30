# API Management Services `[Microsoft.ApiManagement/service]`

This module deploys an API Management Service. The default deployment is set to use a Premium SKU to align with Microsoft WAF-aligned best practices. In most cases, non-prod deployments should use a lower-tier SKU.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/service) |
| `Microsoft.ApiManagement/service/apis` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/diagnostics` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/diagnostics) |
| `Microsoft.ApiManagement/service/apis/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apis/policies) |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apiVersionSets) |
| `Microsoft.ApiManagement/service/authorizationServers` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/authorizationServers) |
| `Microsoft.ApiManagement/service/backends` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/backends) |
| `Microsoft.ApiManagement/service/caches` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/caches) |
| `Microsoft.ApiManagement/service/identityProviders` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/identityProviders) |
| `Microsoft.ApiManagement/service/loggers` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/loggers) |
| `Microsoft.ApiManagement/service/namedValues` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/namedValues) |
| `Microsoft.ApiManagement/service/policies` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/policies) |
| `Microsoft.ApiManagement/service/portalsettings` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/service) |
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
    location: '<location>'
    sku: 'Consumption'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

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
    "location": {
      "value": "<location>"
    },
    "sku": {
      "value": "Consumption"
    }
  }
}
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
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

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
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
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
    location: '<location>'
    sku: 'Developer'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

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
    "location": {
      "value": "<location>"
    },
    "sku": {
      "value": "Developer"
    }
  }
}
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
        publicIpAddressId: '<publicIpAddressId>'
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
        apiVersionSet: {
          name: 'echo-version-set'
          properties: {
            description: 'echo-version-set'
            displayName: 'echo-version-set'
            versioningScheme: 'Segment'
          }
        }
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        serviceUrl: 'http://echoapi.cloudapp.net/api'
      }
    ]
    authorizationServers: {
      secureList: [
        {
          authorizationEndpoint: '<authorizationEndpoint>'
          clientId: 'apimclientid'
          clientRegistrationEndpoint: 'http://localhost'
          clientSecret: '<clientSecret>'
          grantTypes: [
            'authorizationCode'
          ]
          name: 'AuthServer1'
          tokenEndpoint: '<tokenEndpoint>'
        }
      ]
    }
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

<summary>via JSON Parameter file</summary>

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
          "publicIpAddressId": "<publicIpAddressId>",
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
          "apiVersionSet": {
            "name": "echo-version-set",
            "properties": {
              "description": "echo-version-set",
              "displayName": "echo-version-set",
              "versioningScheme": "Segment"
            }
          },
          "displayName": "Echo API",
          "name": "echo-api",
          "path": "echo",
          "serviceUrl": "http://echoapi.cloudapp.net/api"
        }
      ]
    },
    "authorizationServers": {
      "value": {
        "secureList": [
          {
            "authorizationEndpoint": "<authorizationEndpoint>",
            "clientId": "apimclientid",
            "clientRegistrationEndpoint": "http://localhost",
            "clientSecret": "<clientSecret>",
            "grantTypes": [
              "authorizationCode"
            ],
            "name": "AuthServer1",
            "tokenEndpoint": "<tokenEndpoint>"
          }
        ]
      }
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
    location: '<location>'
    sku: 'BasicV2'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

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
    "location": {
      "value": "<location>"
    },
    "sku": {
      "value": "BasicV2"
    }
  }
}
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
        disableGateway: false
        location: 'westus'
        sku: {
          capacity: 1
          name: 'Premium'
        }
      }
    ]
    apis: [
      {
        apiVersionSet: {
          name: 'echo-version-set'
          properties: {
            description: 'An echo API version set'
            displayName: 'Echo version set'
            versioningScheme: 'Segment'
          }
        }
        description: 'An echo API service'
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        serviceUrl: 'https://echoapi.cloudapp.net/api'
      }
    ]
    authorizationServers: {
      secureList: [
        {
          authorizationEndpoint: '<authorizationEndpoint>'
          clientId: 'apimClientid'
          clientRegistrationEndpoint: 'https://localhost'
          clientSecret: '<clientSecret>'
          grantTypes: [
            'authorizationCode'
          ]
          name: 'AuthServer1'
          tokenEndpoint: '<tokenEndpoint>'
        }
      ]
    }
    backends: [
      {
        name: 'backend'
        tls: {
          validateCertificateChain: false
          validateCertificateName: false
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
    location: '<location>'
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

<summary>via JSON Parameter file</summary>

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
          "disableGateway": false,
          "location": "westus",
          "sku": {
            "capacity": 1,
            "name": "Premium"
          }
        }
      ]
    },
    "apis": {
      "value": [
        {
          "apiVersionSet": {
            "name": "echo-version-set",
            "properties": {
              "description": "An echo API version set",
              "displayName": "Echo version set",
              "versioningScheme": "Segment"
            }
          },
          "description": "An echo API service",
          "displayName": "Echo API",
          "name": "echo-api",
          "path": "echo",
          "serviceUrl": "https://echoapi.cloudapp.net/api"
        }
      ]
    },
    "authorizationServers": {
      "value": {
        "secureList": [
          {
            "authorizationEndpoint": "<authorizationEndpoint>",
            "clientId": "apimClientid",
            "clientRegistrationEndpoint": "https://localhost",
            "clientSecret": "<clientSecret>",
            "grantTypes": [
              "authorizationCode"
            ],
            "name": "AuthServer1",
            "tokenEndpoint": "<tokenEndpoint>"
          }
        ]
      }
    },
    "backends": {
      "value": [
        {
          "name": "backend",
          "tls": {
            "validateCertificateChain": false,
            "validateCertificateName": false
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
    "location": {
      "value": "<location>"
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
| [`authorizationServers`](#parameter-authorizationservers) | secureObject | Authorization servers. |
| [`backends`](#parameter-backends) | array | Backends. |
| [`caches`](#parameter-caches) | array | Caches. |
| [`certificates`](#parameter-certificates) | array | List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10. |
| [`customProperties`](#parameter-customproperties) | object | Custom properties of the API Management service. Not supported if SKU is Consumption. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableGateway`](#parameter-disablegateway) | bool | Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region. |
| [`enableClientCertificate`](#parameter-enableclientcertificate) | bool | Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway. |
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
| [`zones`](#parameter-zones) | array | A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku. |

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
- Default: `2`

### Parameter: `additionalLocations`

Additional datacenter locations of the API Management service. Not supported with V2 SKUs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `apiDiagnostics`

API Diagnostics.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `apis`

APIs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `apiVersionSets`

API Version Sets.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `authorizationServers`

Authorization servers.

- Required: No
- Type: secureObject
- Default: `{}`

### Parameter: `backends`

Backends.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `caches`

Caches.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `certificates`

List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hostnameConfigurations`

Custom hostname configuration of the API Management service.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `identityProviders`

Identity providers.

- Required: No
- Type: array
- Default: `[]`

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
- Default: `[]`

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

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
- Default: `[]`

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
- Default: `[]`

### Parameter: `portalsettings`

Portal settings.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `products`

Products.

- Required: No
- Type: array
- Default: `[]`

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
- Default: `[]`

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

### Parameter: `zones`

A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
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

## Notes

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
