# CDN Profiles `[Microsoft.Cdn/profiles]`

This module deploys a CDN Profile.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Cdn/profiles` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles) |
| `Microsoft.Cdn/profiles/afdEndpoints` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/afdEndpoints) |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/afdEndpoints/routes) |
| `Microsoft.Cdn/profiles/customDomains` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/customDomains) |
| `Microsoft.Cdn/profiles/endpoints` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints) |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |
| `Microsoft.Cdn/profiles/originGroups` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/originGroups) |
| `Microsoft.Cdn/profiles/originGroups/origins` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/originGroups/origins) |
| `Microsoft.Cdn/profiles/ruleSets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets) |
| `Microsoft.Cdn/profiles/ruleSets/rules` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/ruleSets/rules) |
| `Microsoft.Cdn/profiles/secrets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/secrets) |
| `Microsoft.Cdn/profiles/securityPolicies` | [2024-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/profiles/securityPolicies) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/cdn/profile:<version>`.

- [As Azure Front Door Premium](#example-1-as-azure-front-door-premium)
- [As Azure Front Door](#example-2-as-azure-front-door)
- [Using only defaults](#example-3-using-only-defaults)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _As Azure Front Door Premium_

This instance deploys the module as Azure Front Door Premium.


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  name: 'profileDeployment'
  params: {
    // Required parameters
    name: 'dep-test-cdnpafdp'
    sku: 'Premium_AzureFrontDoor'
    // Non-required parameters
    afdEndpoints: [
      {
        name: 'dep-test-cdnpafdp-afd-endpoint'
        routes: [
          {
            customDomainNames: [
              'dep-test-cdnpafdp-custom-domain'
            ]
            name: 'dep-test-cdnpafdp-afd-route'
            originGroupName: 'dep-test-cdnpafdp-origin-group'
            ruleSets: [
              {
                name: 'deptestcdnpafdpruleset'
              }
            ]
          }
        ]
      }
    ]
    customDomains: [
      {
        certificateType: 'ManagedCertificate'
        hostName: 'dep-test-cdnpafdp-custom-domain.azurewebsites.net'
        name: 'dep-test-cdnpafdp-custom-domain'
      }
    ]
    location: 'global'
    originGroups: [
      {
        loadBalancingSettings: {
          additionalLatencyInMilliseconds: 50
          sampleSize: 4
          successfulSamplesRequired: 3
        }
        name: 'dep-test-cdnpafdp-origin-group'
        origins: [
          {
            hostName: 'dep-test-cdnpafdp-origin.azurewebsites.net'
            name: 'dep-test-cdnpafdp-origin'
          }
        ]
      }
    ]
    originResponseTimeoutSeconds: 60
    ruleSets: [
      {
        name: 'deptestcdnpafdpruleset'
        rules: [
          {
            actions: [
              {
                name: 'UrlRedirect'
                parameters: {
                  customHostname: 'dev-etradefd.trade.azure.defra.cloud'
                  customPath: '/test123'
                  destinationProtocol: 'Https'
                  redirectType: 'PermanentRedirect'
                  typeName: 'DeliveryRuleUrlRedirectActionParameters'
                }
              }
            ]
            name: 'deptestcdnpafdprule'
            order: 1
          }
        ]
      }
    ]
    securityPolicies: [
      {
        associations: [
          {
            domains: [
              {
                id: '<id>'
              }
            ]
            patternsToMatch: [
              '/*'
            ]
          }
        ]
        name: 'deptestcdnpafdpsecpol'
        wafPolicyResourceId: '<wafPolicyResourceId>'
      }
    ]
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
      "value": "dep-test-cdnpafdp"
    },
    "sku": {
      "value": "Premium_AzureFrontDoor"
    },
    // Non-required parameters
    "afdEndpoints": {
      "value": [
        {
          "name": "dep-test-cdnpafdp-afd-endpoint",
          "routes": [
            {
              "customDomainNames": [
                "dep-test-cdnpafdp-custom-domain"
              ],
              "name": "dep-test-cdnpafdp-afd-route",
              "originGroupName": "dep-test-cdnpafdp-origin-group",
              "ruleSets": [
                {
                  "name": "deptestcdnpafdpruleset"
                }
              ]
            }
          ]
        }
      ]
    },
    "customDomains": {
      "value": [
        {
          "certificateType": "ManagedCertificate",
          "hostName": "dep-test-cdnpafdp-custom-domain.azurewebsites.net",
          "name": "dep-test-cdnpafdp-custom-domain"
        }
      ]
    },
    "location": {
      "value": "global"
    },
    "originGroups": {
      "value": [
        {
          "loadBalancingSettings": {
            "additionalLatencyInMilliseconds": 50,
            "sampleSize": 4,
            "successfulSamplesRequired": 3
          },
          "name": "dep-test-cdnpafdp-origin-group",
          "origins": [
            {
              "hostName": "dep-test-cdnpafdp-origin.azurewebsites.net",
              "name": "dep-test-cdnpafdp-origin"
            }
          ]
        }
      ]
    },
    "originResponseTimeoutSeconds": {
      "value": 60
    },
    "ruleSets": {
      "value": [
        {
          "name": "deptestcdnpafdpruleset",
          "rules": [
            {
              "actions": [
                {
                  "name": "UrlRedirect",
                  "parameters": {
                    "customHostname": "dev-etradefd.trade.azure.defra.cloud",
                    "customPath": "/test123",
                    "destinationProtocol": "Https",
                    "redirectType": "PermanentRedirect",
                    "typeName": "DeliveryRuleUrlRedirectActionParameters"
                  }
                }
              ],
              "name": "deptestcdnpafdprule",
              "order": 1
            }
          ]
        }
      ]
    },
    "securityPolicies": {
      "value": [
        {
          "associations": [
            {
              "domains": [
                {
                  "id": "<id>"
                }
              ],
              "patternsToMatch": [
                "/*"
              ]
            }
          ],
          "name": "deptestcdnpafdpsecpol",
          "wafPolicyResourceId": "<wafPolicyResourceId>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'dep-test-cdnpafdp'
param sku = 'Premium_AzureFrontDoor'
// Non-required parameters
param afdEndpoints = [
  {
    name: 'dep-test-cdnpafdp-afd-endpoint'
    routes: [
      {
        customDomainNames: [
          'dep-test-cdnpafdp-custom-domain'
        ]
        name: 'dep-test-cdnpafdp-afd-route'
        originGroupName: 'dep-test-cdnpafdp-origin-group'
        ruleSets: [
          {
            name: 'deptestcdnpafdpruleset'
          }
        ]
      }
    ]
  }
]
param customDomains = [
  {
    certificateType: 'ManagedCertificate'
    hostName: 'dep-test-cdnpafdp-custom-domain.azurewebsites.net'
    name: 'dep-test-cdnpafdp-custom-domain'
  }
]
param location = 'global'
param originGroups = [
  {
    loadBalancingSettings: {
      additionalLatencyInMilliseconds: 50
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    name: 'dep-test-cdnpafdp-origin-group'
    origins: [
      {
        hostName: 'dep-test-cdnpafdp-origin.azurewebsites.net'
        name: 'dep-test-cdnpafdp-origin'
      }
    ]
  }
]
param originResponseTimeoutSeconds = 60
param ruleSets = [
  {
    name: 'deptestcdnpafdpruleset'
    rules: [
      {
        actions: [
          {
            name: 'UrlRedirect'
            parameters: {
              customHostname: 'dev-etradefd.trade.azure.defra.cloud'
              customPath: '/test123'
              destinationProtocol: 'Https'
              redirectType: 'PermanentRedirect'
              typeName: 'DeliveryRuleUrlRedirectActionParameters'
            }
          }
        ]
        name: 'deptestcdnpafdprule'
        order: 1
      }
    ]
  }
]
param securityPolicies = [
  {
    associations: [
      {
        domains: [
          {
            id: '<id>'
          }
        ]
        patternsToMatch: [
          '/*'
        ]
      }
    ]
    name: 'deptestcdnpafdpsecpol'
    wafPolicyResourceId: '<wafPolicyResourceId>'
  }
]
```

</details>
<p>

### Example 2: _As Azure Front Door_

This instance deploys the module as Azure Front Door.


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  name: 'profileDeployment'
  params: {
    // Required parameters
    name: 'dep-test-cdnpafd'
    sku: 'Standard_AzureFrontDoor'
    // Non-required parameters
    afdEndpoints: [
      {
        name: 'dep-test-cdnpafd-afd-endpoint'
        routes: [
          {
            customDomainNames: [
              'dep-test-cdnpafd-custom-domain'
            ]
            name: 'dep-test-cdnpafd-afd-route'
            originGroupName: 'dep-test-cdnpafd-origin-group'
            ruleSets: [
              {
                name: 'deptestcdnpafdruleset'
              }
            ]
          }
        ]
      }
    ]
    customDomains: [
      {
        certificateType: 'ManagedCertificate'
        hostName: 'dep-test-cdnpafd-custom-domain.azurewebsites.net'
        name: 'dep-test-cdnpafd-custom-domain'
      }
    ]
    location: 'global'
    managedIdentities: {
      systemAssigned: true
    }
    originGroups: [
      {
        loadBalancingSettings: {
          additionalLatencyInMilliseconds: 50
          sampleSize: 4
          successfulSamplesRequired: 3
        }
        name: 'dep-test-cdnpafd-origin-group'
        origins: [
          {
            hostName: 'dep-test-cdnpafd-origin.azurewebsites.net'
            name: 'dep-test-cdnpafd-origin'
          }
        ]
      }
    ]
    originResponseTimeoutSeconds: 60
    ruleSets: [
      {
        name: 'deptestcdnpafdruleset'
        rules: [
          {
            actions: [
              {
                name: 'UrlRedirect'
                parameters: {
                  customHostname: 'dev-etradefd.trade.azure.defra.cloud'
                  customPath: '/test123'
                  destinationProtocol: 'Https'
                  redirectType: 'PermanentRedirect'
                  typeName: 'DeliveryRuleUrlRedirectActionParameters'
                }
              }
            ]
            name: 'deptestcdnpafdrule'
            order: 1
          }
        ]
      }
    ]
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
      "value": "dep-test-cdnpafd"
    },
    "sku": {
      "value": "Standard_AzureFrontDoor"
    },
    // Non-required parameters
    "afdEndpoints": {
      "value": [
        {
          "name": "dep-test-cdnpafd-afd-endpoint",
          "routes": [
            {
              "customDomainNames": [
                "dep-test-cdnpafd-custom-domain"
              ],
              "name": "dep-test-cdnpafd-afd-route",
              "originGroupName": "dep-test-cdnpafd-origin-group",
              "ruleSets": [
                {
                  "name": "deptestcdnpafdruleset"
                }
              ]
            }
          ]
        }
      ]
    },
    "customDomains": {
      "value": [
        {
          "certificateType": "ManagedCertificate",
          "hostName": "dep-test-cdnpafd-custom-domain.azurewebsites.net",
          "name": "dep-test-cdnpafd-custom-domain"
        }
      ]
    },
    "location": {
      "value": "global"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "originGroups": {
      "value": [
        {
          "loadBalancingSettings": {
            "additionalLatencyInMilliseconds": 50,
            "sampleSize": 4,
            "successfulSamplesRequired": 3
          },
          "name": "dep-test-cdnpafd-origin-group",
          "origins": [
            {
              "hostName": "dep-test-cdnpafd-origin.azurewebsites.net",
              "name": "dep-test-cdnpafd-origin"
            }
          ]
        }
      ]
    },
    "originResponseTimeoutSeconds": {
      "value": 60
    },
    "ruleSets": {
      "value": [
        {
          "name": "deptestcdnpafdruleset",
          "rules": [
            {
              "actions": [
                {
                  "name": "UrlRedirect",
                  "parameters": {
                    "customHostname": "dev-etradefd.trade.azure.defra.cloud",
                    "customPath": "/test123",
                    "destinationProtocol": "Https",
                    "redirectType": "PermanentRedirect",
                    "typeName": "DeliveryRuleUrlRedirectActionParameters"
                  }
                }
              ],
              "name": "deptestcdnpafdrule",
              "order": 1
            }
          ]
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'dep-test-cdnpafd'
param sku = 'Standard_AzureFrontDoor'
// Non-required parameters
param afdEndpoints = [
  {
    name: 'dep-test-cdnpafd-afd-endpoint'
    routes: [
      {
        customDomainNames: [
          'dep-test-cdnpafd-custom-domain'
        ]
        name: 'dep-test-cdnpafd-afd-route'
        originGroupName: 'dep-test-cdnpafd-origin-group'
        ruleSets: [
          {
            name: 'deptestcdnpafdruleset'
          }
        ]
      }
    ]
  }
]
param customDomains = [
  {
    certificateType: 'ManagedCertificate'
    hostName: 'dep-test-cdnpafd-custom-domain.azurewebsites.net'
    name: 'dep-test-cdnpafd-custom-domain'
  }
]
param location = 'global'
param managedIdentities = {
  systemAssigned: true
}
param originGroups = [
  {
    loadBalancingSettings: {
      additionalLatencyInMilliseconds: 50
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    name: 'dep-test-cdnpafd-origin-group'
    origins: [
      {
        hostName: 'dep-test-cdnpafd-origin.azurewebsites.net'
        name: 'dep-test-cdnpafd-origin'
      }
    ]
  }
]
param originResponseTimeoutSeconds = 60
param ruleSets = [
  {
    name: 'deptestcdnpafdruleset'
    rules: [
      {
        actions: [
          {
            name: 'UrlRedirect'
            parameters: {
              customHostname: 'dev-etradefd.trade.azure.defra.cloud'
              customPath: '/test123'
              destinationProtocol: 'Https'
              redirectType: 'PermanentRedirect'
              typeName: 'DeliveryRuleUrlRedirectActionParameters'
            }
          }
        ]
        name: 'deptestcdnpafdrule'
        order: 1
      }
    ]
  }
]
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  name: 'profileDeployment'
  params: {
    // Required parameters
    name: 'dep-test-cdnpmin'
    sku: 'Standard_Microsoft'
    // Non-required parameters
    location: '<location>'
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
      "value": "dep-test-cdnpmin"
    },
    "sku": {
      "value": "Standard_Microsoft"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'dep-test-cdnpmin'
param sku = 'Standard_Microsoft'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  name: 'profileDeployment'
  params: {
    // Required parameters
    name: 'dep-test-cdnpmax'
    sku: 'Standard_Verizon'
    // Non-required parameters
    endpointProperties: {
      contentTypesToCompress: [
        'application/javascript'
        'application/json'
        'application/x-javascript'
        'application/xml'
        'text/css'
        'text/html'
        'text/javascript'
        'text/plain'
      ]
      geoFilters: []
      isCompressionEnabled: true
      isHttpAllowed: true
      isHttpsAllowed: true
      originGroups: []
      originHostHeader: '<originHostHeader>'
      origins: [
        {
          name: 'dep-cdn-endpoint01'
          properties: {
            enabled: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
          }
        }
      ]
      queryStringCachingBehavior: 'IgnoreQueryString'
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    originResponseTimeoutSeconds: 60
    roleAssignments: [
      {
        name: '50362c78-6910-43c3-8639-9cae123943bb'
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
      "value": "dep-test-cdnpmax"
    },
    "sku": {
      "value": "Standard_Verizon"
    },
    // Non-required parameters
    "endpointProperties": {
      "value": {
        "contentTypesToCompress": [
          "application/javascript",
          "application/json",
          "application/x-javascript",
          "application/xml",
          "text/css",
          "text/html",
          "text/javascript",
          "text/plain"
        ],
        "geoFilters": [],
        "isCompressionEnabled": true,
        "isHttpAllowed": true,
        "isHttpsAllowed": true,
        "originGroups": [],
        "originHostHeader": "<originHostHeader>",
        "origins": [
          {
            "name": "dep-cdn-endpoint01",
            "properties": {
              "enabled": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443
            }
          }
        ],
        "queryStringCachingBehavior": "IgnoreQueryString"
      }
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
    "originResponseTimeoutSeconds": {
      "value": 60
    },
    "roleAssignments": {
      "value": [
        {
          "name": "50362c78-6910-43c3-8639-9cae123943bb",
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'dep-test-cdnpmax'
param sku = 'Standard_Verizon'
// Non-required parameters
param endpointProperties = {
  contentTypesToCompress: [
    'application/javascript'
    'application/json'
    'application/x-javascript'
    'application/xml'
    'text/css'
    'text/html'
    'text/javascript'
    'text/plain'
  ]
  geoFilters: []
  isCompressionEnabled: true
  isHttpAllowed: true
  isHttpsAllowed: true
  originGroups: []
  originHostHeader: '<originHostHeader>'
  origins: [
    {
      name: 'dep-cdn-endpoint01'
      properties: {
        enabled: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
      }
    }
  ]
  queryStringCachingBehavior: 'IgnoreQueryString'
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param originResponseTimeoutSeconds = 60
param roleAssignments = [
  {
    name: '50362c78-6910-43c3-8639-9cae123943bb'
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
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  name: 'profileDeployment'
  params: {
    // Required parameters
    name: 'dep-test-cdnpwaf'
    sku: 'Standard_Verizon'
    // Non-required parameters
    endpointProperties: {
      contentTypesToCompress: [
        'application/javascript'
        'application/json'
        'application/x-javascript'
        'application/xml'
        'text/css'
        'text/html'
        'text/javascript'
        'text/plain'
      ]
      geoFilters: []
      isCompressionEnabled: true
      isHttpAllowed: true
      isHttpsAllowed: true
      originGroups: []
      originHostHeader: '<originHostHeader>'
      origins: [
        {
          name: 'dep-cdn-endpoint01'
          properties: {
            enabled: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
          }
        }
      ]
      queryStringCachingBehavior: 'IgnoreQueryString'
    }
    location: '<location>'
    originResponseTimeoutSeconds: 60
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
      "value": "dep-test-cdnpwaf"
    },
    "sku": {
      "value": "Standard_Verizon"
    },
    // Non-required parameters
    "endpointProperties": {
      "value": {
        "contentTypesToCompress": [
          "application/javascript",
          "application/json",
          "application/x-javascript",
          "application/xml",
          "text/css",
          "text/html",
          "text/javascript",
          "text/plain"
        ],
        "geoFilters": [],
        "isCompressionEnabled": true,
        "isHttpAllowed": true,
        "isHttpsAllowed": true,
        "originGroups": [],
        "originHostHeader": "<originHostHeader>",
        "origins": [
          {
            "name": "dep-cdn-endpoint01",
            "properties": {
              "enabled": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443
            }
          }
        ],
        "queryStringCachingBehavior": "IgnoreQueryString"
      }
    },
    "location": {
      "value": "<location>"
    },
    "originResponseTimeoutSeconds": {
      "value": 60
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'dep-test-cdnpwaf'
param sku = 'Standard_Verizon'
// Non-required parameters
param endpointProperties = {
  contentTypesToCompress: [
    'application/javascript'
    'application/json'
    'application/x-javascript'
    'application/xml'
    'text/css'
    'text/html'
    'text/javascript'
    'text/plain'
  ]
  geoFilters: []
  isCompressionEnabled: true
  isHttpAllowed: true
  isHttpsAllowed: true
  originGroups: []
  originHostHeader: '<originHostHeader>'
  origins: [
    {
      name: 'dep-cdn-endpoint01'
      properties: {
        enabled: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
      }
    }
  ]
  queryStringCachingBehavior: 'IgnoreQueryString'
}
param location = '<location>'
param originResponseTimeoutSeconds = 60
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the CDN profile. |
| [`sku`](#parameter-sku) | string | The pricing tier (defines a CDN provider, feature list and rate) of the CDN profile. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`originGroups`](#parameter-origingroups) | array | Array of origin group objects. Required if the afdEndpoints is specified. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`afdEndpoints`](#parameter-afdendpoints) | array | Array of AFD endpoint objects. |
| [`customDomains`](#parameter-customdomains) | array | Array of custom domain objects. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`endpointName`](#parameter-endpointname) | string | Name of the endpoint under the profile which is unique globally. |
| [`endpointProperties`](#parameter-endpointproperties) | object | Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details). |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`originResponseTimeoutSeconds`](#parameter-originresponsetimeoutseconds) | int | Send and receive timeout on forwarding request to the origin. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`ruleSets`](#parameter-rulesets) | array | Array of rule set objects. |
| [`secrets`](#parameter-secrets) | array | Array of secret objects. |
| [`securityPolicies`](#parameter-securitypolicies) | array | Array of Security Policy objects (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies for details). |
| [`tags`](#parameter-tags) | object | Endpoint tags. |

### Parameter: `name`

Name of the CDN profile.

- Required: Yes
- Type: string

### Parameter: `sku`

The pricing tier (defines a CDN provider, feature list and rate) of the CDN profile.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom_Verizon'
    'Premium_AzureFrontDoor'
    'Premium_Verizon'
    'Standard_955BandWidth_ChinaCdn'
    'Standard_AvgBandWidth_ChinaCdn'
    'Standard_AzureFrontDoor'
    'Standard_ChinaCdn'
    'Standard_Microsoft'
    'Standard_Verizon'
    'StandardPlus_955BandWidth_ChinaCdn'
    'StandardPlus_AvgBandWidth_ChinaCdn'
    'StandardPlus_ChinaCdn'
  ]
  ```

### Parameter: `originGroups`

Array of origin group objects. Required if the afdEndpoints is specified.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loadBalancingSettings`](#parameter-origingroupsloadbalancingsettings) | object | Load balancing settings for a backend pool. |
| [`name`](#parameter-origingroupsname) | string | The name of the origin group. |
| [`origins`](#parameter-origingroupsorigins) | array | The list of origins within the origin group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`healthProbeSettings`](#parameter-origingroupshealthprobesettings) | object | Health probe settings to the origin that is used to determine the health of the origin. |
| [`sessionAffinityState`](#parameter-origingroupssessionaffinitystate) | string | Whether to allow session affinity on this host. |
| [`trafficRestorationTimeToHealedOrNewEndpointsInMinutes`](#parameter-origingroupstrafficrestorationtimetohealedornewendpointsinminutes) | int | Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins. |

### Parameter: `originGroups.loadBalancingSettings`

Load balancing settings for a backend pool.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalLatencyInMilliseconds`](#parameter-origingroupsloadbalancingsettingsadditionallatencyinmilliseconds) | int | Additional latency in milliseconds for probes to the backend. Must be between 0 and 1000. |
| [`sampleSize`](#parameter-origingroupsloadbalancingsettingssamplesize) | int | Number of samples to consider for load balancing decisions. |
| [`successfulSamplesRequired`](#parameter-origingroupsloadbalancingsettingssuccessfulsamplesrequired) | int | Number of samples within the sample window that must be successful to mark the backend as healthy. |

### Parameter: `originGroups.loadBalancingSettings.additionalLatencyInMilliseconds`

Additional latency in milliseconds for probes to the backend. Must be between 0 and 1000.

- Required: Yes
- Type: int

### Parameter: `originGroups.loadBalancingSettings.sampleSize`

Number of samples to consider for load balancing decisions.

- Required: Yes
- Type: int

### Parameter: `originGroups.loadBalancingSettings.successfulSamplesRequired`

Number of samples within the sample window that must be successful to mark the backend as healthy.

- Required: Yes
- Type: int

### Parameter: `originGroups.name`

The name of the origin group.

- Required: Yes
- Type: string

### Parameter: `originGroups.origins`

The list of origins within the origin group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hostName`](#parameter-origingroupsoriginshostname) | string | The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint. |
| [`name`](#parameter-origingroupsoriginsname) | string | The name of the origion. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabledState`](#parameter-origingroupsoriginsenabledstate) | string | Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool. |
| [`enforceCertificateNameCheck`](#parameter-origingroupsoriginsenforcecertificatenamecheck) | bool | Whether to enable certificate name check at origin level. |
| [`httpPort`](#parameter-origingroupsoriginshttpport) | int | The value of the HTTP port. Must be between 1 and 65535. |
| [`httpsPort`](#parameter-origingroupsoriginshttpsport) | int | The value of the HTTPS port. Must be between 1 and 65535. |
| [`originHostHeader`](#parameter-origingroupsoriginsoriginhostheader) | string | The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint. |
| [`priority`](#parameter-origingroupsoriginspriority) | int | Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5. |
| [`sharedPrivateLinkResource`](#parameter-origingroupsoriginssharedprivatelinkresource) | object | The properties of the private link resource for private origin. |
| [`weight`](#parameter-origingroupsoriginsweight) | int | Weight of the origin in given origin group for load balancing. Must be between 1 and 1000. |

### Parameter: `originGroups.origins.hostName`

The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.

- Required: Yes
- Type: string

### Parameter: `originGroups.origins.name`

The name of the origion.

- Required: Yes
- Type: string

### Parameter: `originGroups.origins.enabledState`

Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `originGroups.origins.enforceCertificateNameCheck`

Whether to enable certificate name check at origin level.

- Required: No
- Type: bool

### Parameter: `originGroups.origins.httpPort`

The value of the HTTP port. Must be between 1 and 65535.

- Required: No
- Type: int

### Parameter: `originGroups.origins.httpsPort`

The value of the HTTPS port. Must be between 1 and 65535.

- Required: No
- Type: int

### Parameter: `originGroups.origins.originHostHeader`

The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.

- Required: No
- Type: string

### Parameter: `originGroups.origins.priority`

Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.

- Required: No
- Type: int

### Parameter: `originGroups.origins.sharedPrivateLinkResource`

The properties of the private link resource for private origin.

- Required: No
- Type: object

### Parameter: `originGroups.origins.weight`

Weight of the origin in given origin group for load balancing. Must be between 1 and 1000.

- Required: No
- Type: int

### Parameter: `originGroups.healthProbeSettings`

Health probe settings to the origin that is used to determine the health of the origin.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`probeIntervalInSeconds`](#parameter-origingroupshealthprobesettingsprobeintervalinseconds) | int | The number of seconds between health probes.Default is 240sec. |
| [`probePath`](#parameter-origingroupshealthprobesettingsprobepath) | string | The path relative to the origin that is used to determine the health of the origin. |
| [`probeProtocol`](#parameter-origingroupshealthprobesettingsprobeprotocol) | string | Protocol to use for health probe. |
| [`probeRequestType`](#parameter-origingroupshealthprobesettingsproberequesttype) | string | The request type to probe. |

### Parameter: `originGroups.healthProbeSettings.probeIntervalInSeconds`

The number of seconds between health probes.Default is 240sec.

- Required: No
- Type: int

### Parameter: `originGroups.healthProbeSettings.probePath`

The path relative to the origin that is used to determine the health of the origin.

- Required: No
- Type: string

### Parameter: `originGroups.healthProbeSettings.probeProtocol`

Protocol to use for health probe.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Https'
    'NotSet'
  ]
  ```

### Parameter: `originGroups.healthProbeSettings.probeRequestType`

The request type to probe.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GET'
    'HEAD'
    'NotSet'
  ]
  ```

### Parameter: `originGroups.sessionAffinityState`

Whether to allow session affinity on this host.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `originGroups.trafficRestorationTimeToHealedOrNewEndpointsInMinutes`

Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins.

- Required: No
- Type: int

### Parameter: `afdEndpoints`

Array of AFD endpoint objects.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-afdendpointsname) | string | The name of the AFD Endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoGeneratedDomainNameLabelScope`](#parameter-afdendpointsautogenerateddomainnamelabelscope) | string | The scope of the auto-generated domain name label. |
| [`enabledState`](#parameter-afdendpointsenabledstate) | string | The state of the AFD Endpoint. |
| [`routes`](#parameter-afdendpointsroutes) | array | The list of routes for this AFD Endpoint. |
| [`tags`](#parameter-afdendpointstags) | object | The tags for the AFD Endpoint. |

### Parameter: `afdEndpoints.name`

The name of the AFD Endpoint.

- Required: Yes
- Type: string

### Parameter: `afdEndpoints.autoGeneratedDomainNameLabelScope`

The scope of the auto-generated domain name label.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NoReuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
  ]
  ```

### Parameter: `afdEndpoints.enabledState`

The state of the AFD Endpoint.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `afdEndpoints.routes`

The list of routes for this AFD Endpoint.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-afdendpointsroutesname) | string | The name of the route. |
| [`originGroupName`](#parameter-afdendpointsroutesorigingroupname) | string | The name of the origin group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cacheConfiguration`](#parameter-afdendpointsroutescacheconfiguration) | object | The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object. |
| [`customDomainNames`](#parameter-afdendpointsroutescustomdomainnames) | array | The names of the custom domains. |
| [`enabledState`](#parameter-afdendpointsroutesenabledstate) | string | Whether to enable use of this rule. |
| [`forwardingProtocol`](#parameter-afdendpointsroutesforwardingprotocol) | string | The protocol this rule will use when forwarding traffic to backends. |
| [`httpsRedirect`](#parameter-afdendpointsrouteshttpsredirect) | string | Whether to automatically redirect HTTP traffic to HTTPS traffic. |
| [`linkToDefaultDomain`](#parameter-afdendpointsrouteslinktodefaultdomain) | string | Whether this route will be linked to the default endpoint domain. |
| [`originPath`](#parameter-afdendpointsroutesoriginpath) | string | A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath. |
| [`patternsToMatch`](#parameter-afdendpointsroutespatternstomatch) | array | The route patterns of the rule. |
| [`ruleSets`](#parameter-afdendpointsroutesrulesets) | array | The rule sets of the rule. |
| [`supportedProtocols`](#parameter-afdendpointsroutessupportedprotocols) | array | The supported protocols of the rule. |

### Parameter: `afdEndpoints.routes.name`

The name of the route.

- Required: Yes
- Type: string

### Parameter: `afdEndpoints.routes.originGroupName`

The name of the origin group.

- Required: Yes
- Type: string

### Parameter: `afdEndpoints.routes.cacheConfiguration`

The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compressionSettings`](#parameter-afdendpointsroutescacheconfigurationcompressionsettings) | object | Compression settings. |
| [`queryParameters`](#parameter-afdendpointsroutescacheconfigurationqueryparameters) | string | Query parameters to include or exclude (comma separated). |
| [`queryStringCachingBehavior`](#parameter-afdendpointsroutescacheconfigurationquerystringcachingbehavior) | string | Defines how Frontdoor caches requests that include query strings. |

### Parameter: `afdEndpoints.routes.cacheConfiguration.compressionSettings`

Compression settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentTypesToCompress`](#parameter-afdendpointsroutescacheconfigurationcompressionsettingscontenttypestocompress) | array | List of content types on which compression applies. The value should be a valid MIME type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`iscontentTypeToCompressAll`](#parameter-afdendpointsroutescacheconfigurationcompressionsettingsiscontenttypetocompressall) | bool | Indicates whether content compression is enabled on AzureFrontDoor. Default value is false. If compression is enabled, content will be served as compressed if user requests for a compressed version. Content won't be compressed on AzureFrontDoor when requested content is smaller than 1 byte or larger than 1 MB. |

### Parameter: `afdEndpoints.routes.cacheConfiguration.compressionSettings.contentTypesToCompress`

List of content types on which compression applies. The value should be a valid MIME type.

- Required: Yes
- Type: array

### Parameter: `afdEndpoints.routes.cacheConfiguration.compressionSettings.iscontentTypeToCompressAll`

Indicates whether content compression is enabled on AzureFrontDoor. Default value is false. If compression is enabled, content will be served as compressed if user requests for a compressed version. Content won't be compressed on AzureFrontDoor when requested content is smaller than 1 byte or larger than 1 MB.

- Required: No
- Type: bool

### Parameter: `afdEndpoints.routes.cacheConfiguration.queryParameters`

Query parameters to include or exclude (comma separated).

- Required: Yes
- Type: string

### Parameter: `afdEndpoints.routes.cacheConfiguration.queryStringCachingBehavior`

Defines how Frontdoor caches requests that include query strings.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IgnoreQueryString'
    'IgnoreSpecifiedQueryStrings'
    'IncludeSpecifiedQueryStrings'
    'UseQueryString'
  ]
  ```

### Parameter: `afdEndpoints.routes.customDomainNames`

The names of the custom domains.

- Required: No
- Type: array

### Parameter: `afdEndpoints.routes.enabledState`

Whether to enable use of this rule.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `afdEndpoints.routes.forwardingProtocol`

The protocol this rule will use when forwarding traffic to backends.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'HttpOnly'
    'HttpsOnly'
    'MatchRequest'
  ]
  ```

### Parameter: `afdEndpoints.routes.httpsRedirect`

Whether to automatically redirect HTTP traffic to HTTPS traffic.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `afdEndpoints.routes.linkToDefaultDomain`

Whether this route will be linked to the default endpoint domain.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `afdEndpoints.routes.originPath`

A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath.

- Required: No
- Type: string

### Parameter: `afdEndpoints.routes.patternsToMatch`

The route patterns of the rule.

- Required: No
- Type: array

### Parameter: `afdEndpoints.routes.ruleSets`

The rule sets of the rule.

- Required: No
- Type: array

### Parameter: `afdEndpoints.routes.supportedProtocols`

The supported protocols of the rule.

- Required: No
- Type: array

### Parameter: `afdEndpoints.tags`

The tags for the AFD Endpoint.

- Required: No
- Type: object

### Parameter: `customDomains`

Array of custom domain objects.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateType`](#parameter-customdomainscertificatetype) | string | The type of the certificate. |
| [`hostName`](#parameter-customdomainshostname) | string | The host name of the custom domain. |
| [`name`](#parameter-customdomainsname) | string | The name of the custom domain. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureDnsZoneResourceId`](#parameter-customdomainsazurednszoneresourceid) | string | The resource ID of the Azure DNS zone. |
| [`extendedProperties`](#parameter-customdomainsextendedproperties) | object | Extended properties. |
| [`minimumTlsVersion`](#parameter-customdomainsminimumtlsversion) | string | The minimum TLS version. |
| [`preValidatedCustomDomainResourceId`](#parameter-customdomainsprevalidatedcustomdomainresourceid) | string | The resource ID of the pre-validated custom domain. |
| [`secretName`](#parameter-customdomainssecretname) | string | The name of the secret. |

### Parameter: `customDomains.certificateType`

The type of the certificate.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureFirstPartyManagedCertificate'
    'CustomerCertificate'
    'ManagedCertificate'
  ]
  ```

### Parameter: `customDomains.hostName`

The host name of the custom domain.

- Required: Yes
- Type: string

### Parameter: `customDomains.name`

The name of the custom domain.

- Required: Yes
- Type: string

### Parameter: `customDomains.azureDnsZoneResourceId`

The resource ID of the Azure DNS zone.

- Required: No
- Type: string

### Parameter: `customDomains.extendedProperties`

Extended properties.

- Required: No
- Type: object

### Parameter: `customDomains.minimumTlsVersion`

The minimum TLS version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'TLS10'
    'TLS12'
  ]
  ```

### Parameter: `customDomains.preValidatedCustomDomainResourceId`

The resource ID of the pre-validated custom domain.

- Required: No
- Type: string

### Parameter: `customDomains.secretName`

The name of the secret.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `endpointName`

Name of the endpoint under the profile which is unique globally.

- Required: No
- Type: string

### Parameter: `endpointProperties`

Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).

- Required: No
- Type: object

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

### Parameter: `originResponseTimeoutSeconds`

Send and receive timeout on forwarding request to the origin.

- Required: No
- Type: int
- Default: `60`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'CDN Endpoint Contributor'`
  - `'CDN Endpoint Reader'`
  - `'CDN Profile Contributor'`
  - `'CDN Profile Reader'`
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

### Parameter: `ruleSets`

Array of rule set objects.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-rulesetsname) | string | Name of the rule set. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-rulesetsrules) | array | Array of rules. |

### Parameter: `ruleSets.name`

Name of the rule set.

- Required: Yes
- Type: string

### Parameter: `ruleSets.rules`

Array of rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-rulesetsrulesname) | string | The name of the rule. |
| [`order`](#parameter-rulesetsrulesorder) | int | The order in which the rules are applied for the endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-rulesetsrulesactions) | array | A list of actions that are executed when all the conditions of a rule are satisfied.. |
| [`conditions`](#parameter-rulesetsrulesconditions) | array | A list of conditions that must be matched for the actions to be executed. |
| [`matchProcessingBehavior`](#parameter-rulesetsrulesmatchprocessingbehavior) | string | If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue. |

### Parameter: `ruleSets.rules.name`

The name of the rule.

- Required: Yes
- Type: string

### Parameter: `ruleSets.rules.order`

The order in which the rules are applied for the endpoint.

- Required: Yes
- Type: int

### Parameter: `ruleSets.rules.actions`

A list of actions that are executed when all the conditions of a rule are satisfied..

- Required: No
- Type: array

### Parameter: `ruleSets.rules.conditions`

A list of conditions that must be matched for the actions to be executed.

- Required: No
- Type: array

### Parameter: `ruleSets.rules.matchProcessingBehavior`

If this rule is a match should the rules engine continue running the remaining rules or stop. If not present, defaults to Continue.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Continue'
    'Stop'
  ]
  ```

### Parameter: `secrets`

Array of secret objects.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `securityPolicies`

Array of Security Policy objects (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies for details).

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associations`](#parameter-securitypoliciesassociations) | array | Domain names and URL patterns to math with this association. |
| [`name`](#parameter-securitypoliciesname) | string | Name of the security policy. |
| [`wafPolicyResourceId`](#parameter-securitypolicieswafpolicyresourceid) | string | Resource ID of WAF policy. |

### Parameter: `securityPolicies.associations`

Domain names and URL patterns to math with this association.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domains`](#parameter-securitypoliciesassociationsdomains) | array | List of domain resource id to associate with this resource. |
| [`patternsToMatch`](#parameter-securitypoliciesassociationspatternstomatch) | array | List of patterns to match with this association. |

### Parameter: `securityPolicies.associations.domains`

List of domain resource id to associate with this resource.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-securitypoliciesassociationsdomainsid) | string | ResourceID to domain that will be associated. |

### Parameter: `securityPolicies.associations.domains.id`

ResourceID to domain that will be associated.

- Required: Yes
- Type: string

### Parameter: `securityPolicies.associations.patternsToMatch`

List of patterns to match with this association.

- Required: Yes
- Type: array

### Parameter: `securityPolicies.name`

Name of the security policy.

- Required: Yes
- Type: string

### Parameter: `securityPolicies.wafPolicyResourceId`

Resource ID of WAF policy.

- Required: Yes
- Type: string

### Parameter: `tags`

Endpoint tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpointId` | string | The resource ID of the CDN profile endpoint. |
| `endpointName` | string | The name of the CDN profile endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the CDN profile. |
| `profileType` | string | The type of the CDN profile. |
| `resourceGroupName` | string | The resource group where the CDN profile is deployed. |
| `resourceId` | string | The resource ID of the CDN profile. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
| `uri` | string | The uri of the CDN profile endpoint. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
