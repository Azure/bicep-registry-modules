# API Management Services `[Microsoft.ApiManagement/service]`

This module deploys an API Management Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service) |
| `Microsoft.ApiManagement/service/apis` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis) |
| `Microsoft.ApiManagement/service/apis/policies` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apis/policies) |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/apiVersionSets) |
| `Microsoft.ApiManagement/service/authorizationServers` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/authorizationServers) |
| `Microsoft.ApiManagement/service/backends` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/backends) |
| `Microsoft.ApiManagement/service/caches` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/caches) |
| `Microsoft.ApiManagement/service/identityProviders` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/identityProviders) |
| `Microsoft.ApiManagement/service/namedValues` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/namedValues) |
| `Microsoft.ApiManagement/service/policies` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/policies) |
| `Microsoft.ApiManagement/service/portalsettings` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/service) |
| `Microsoft.ApiManagement/service/products` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products) |
| `Microsoft.ApiManagement/service/products/apis` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/apis) |
| `Microsoft.ApiManagement/service/products/groups` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/products/groups) |
| `Microsoft.ApiManagement/service/subscriptions` | [2021-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2021-08-01/service/subscriptions) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/api-management.service:1.0.0`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br:bicep/modules/api-management.service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-apismin'
  params: {
    // Required parameters
    name: 'apismin001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br:bicep/modules/api-management.service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-apismax'
  params: {
    // Required parameters
    name: 'apismax001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
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
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    identityProviders: [
      {
        name: 'aadProvider'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    subscriptions: [
      {
        name: 'testArmSubscriptionAllApis'
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
      "value": "apismax001"
    },
    "publisherEmail": {
      "value": "apimgmt-noreply@mail.windowsazure.com"
    },
    "publisherName": {
      "value": "az-amorg-x-001"
    },
    // Non-required parameters
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "identityProviders": {
      "value": [
        {
          "name": "aadProvider"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
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
    "subscriptions": {
      "value": [
        {
          "name": "testArmSubscriptionAllApis"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module service 'br:bicep/modules/api-management.service:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-apiswaf'
  params: {
    // Required parameters
    name: 'apiswaf001'
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: 'az-amorg-x-001'
    // Non-required parameters
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
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    identityProviders: [
      {
        name: 'aadProvider'
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
    subscriptions: [
      {
        name: 'testArmSubscriptionAllApis'
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "identityProviders": {
      "value": [
        {
          "name": "aadProvider"
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
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
    "subscriptions": {
      "value": [
        {
          "name": "testArmSubscriptionAllApis"
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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalLocations`](#parameter-additionallocations) | array | Additional datacenter locations of the API Management service. |
| [`apis`](#parameter-apis) | array | APIs. |
| [`apiVersionSets`](#parameter-apiversionsets) | array | API Version Sets. |
| [`authorizationServers`](#parameter-authorizationservers) | secureObject | Authorization servers. |
| [`backends`](#parameter-backends) | array | Backends. |
| [`caches`](#parameter-caches) | array | Caches. |
| [`certificates`](#parameter-certificates) | array | List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10. |
| [`customProperties`](#parameter-customproperties) | object | Custom properties of the API Management service. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableGateway`](#parameter-disablegateway) | bool | Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region. |
| [`enableClientCertificate`](#parameter-enableclientcertificate) | bool | Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`hostnameConfigurations`](#parameter-hostnameconfigurations) | array | Custom hostname configuration of the API Management service. |
| [`identityProviders`](#parameter-identityproviders) | array | Identity providers. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`minApiVersion`](#parameter-minapiversion) | string | Limit control plane API calls to API Management service with version equal to or newer than this value. |
| [`namedValues`](#parameter-namedvalues) | array | Named values. |
| [`newGuidValue`](#parameter-newguidvalue) | string | Necessary to create a new GUID. |
| [`notificationSenderEmail`](#parameter-notificationsenderemail) | string | The notification sender email address for the service. |
| [`policies`](#parameter-policies) | array | Policies. |
| [`portalsettings`](#parameter-portalsettings) | array | Portal settings. |
| [`products`](#parameter-products) | array | Products. |
| [`restore`](#parameter-restore) | bool | Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | The pricing tier of this API Management service. |
| [`skuCount`](#parameter-skucount) | int | The instance size of this API Management service. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The full resource ID of a subnet in a virtual network to deploy the API Management service in. |
| [`subscriptions`](#parameter-subscriptions) | array | Subscriptions. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkType`](#parameter-virtualnetworktype) | string | The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only. |
| [`zones`](#parameter-zones) | array | A list of availability zones denoting where the resource needs to come from. |

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

### Parameter: `additionalLocations`

Additional datacenter locations of the API Management service.

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

Custom properties of the API Management service.

- Required: No
- Type: object
- Default: `{}`

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
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
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

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

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
- Default: `''`

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

### Parameter: `restore`

Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
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

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

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
- Default: `'Developer'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Consumption'
    'Developer'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `skuCount`

The instance size of this API Management service.

- Required: No
- Type: int
- Default: `1`
- Allowed:
  ```Bicep
  [
    1
    2
  ]
  ```

### Parameter: `subnetResourceId`

The full resource ID of a subnet in a virtual network to deploy the API Management service in.

- Required: No
- Type: string
- Default: `''`

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

A list of availability zones denoting where the resource needs to come from.

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the API management service. |
| `resourceGroupName` | string | The resource group the API management service was deployed into. |
| `resourceId` | string | The resource ID of the API management service. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

_None_

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
