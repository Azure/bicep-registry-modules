# CDN Profiles `[Microsoft.Cdn/profiles]`

This module deploys a CDN Profile.

You can reference the module as follows:
```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
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
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Cdn/profiles` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles)</li></ul> |
| `Microsoft.Cdn/profiles/afdEndpoints` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_afdendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/afdEndpoints)</li></ul> |
| `Microsoft.Cdn/profiles/afdEndpoints/routes` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_afdendpoints_routes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/afdEndpoints/routes)</li></ul> |
| `Microsoft.Cdn/profiles/customDomains` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_customdomains.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/customDomains)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/endpoints)</li></ul> |
| `Microsoft.Cdn/profiles/endpoints/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_endpoints_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/endpoints/origins)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups/origins)</li></ul> |
| `Microsoft.Cdn/profiles/ruleSets` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets)</li></ul> |
| `Microsoft.Cdn/profiles/ruleSets/rules` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_rulesets_rules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/ruleSets/rules)</li></ul> |
| `Microsoft.Cdn/profiles/secrets` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/secrets)</li></ul> |
| `Microsoft.Cdn/profiles/securityPolicies` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_securitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/securityPolicies)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/cdn/profile:<version>`.

- [As Azure Front Door Premium](#example-1-as-azure-front-door-premium)
- [As Azure Front Door](#example-2-as-azure-front-door)
- [Using only defaults](#example-3-using-only-defaults)
- [Using maximum parameter set](#example-4-using-maximum-parameter-set)
- [WAF-aligned Premium AFD](#example-5-waf-aligned-premium-afd)

### Example 1: _As Azure Front Door Premium_

This instance deploys the module as Azure Front Door Premium.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/afd.premium]


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  params: {
    // Required parameters
    name: 'test-afd-cdnpafdp'
    sku: 'Premium_AzureFrontDoor'
    // Non-required parameters
    afdEndpoints: [
      {
        name: 'test-afd-cdnpafdp-afd-endpoint'
        routes: [
          {
            customDomainNames: [
              'test-cdnpafdp-custom-domain'
            ]
            name: 'test-cdnpafdp-afd-route'
            originGroupName: 'test-cdnpafdp-origin-group'
            ruleSets: [
              'deptestcdnpafdpruleset'
            ]
          }
        ]
      }
    ]
    customDomains: [
      {
        certificateType: 'ManagedCertificate'
        hostName: 'test-cdnpafdp-custom-domain.azurewebsites.net'
        name: 'test-cdnpafdp-custom-domain'
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
        name: 'test-cdnpafdp-origin-group'
        origins: [
          {
            hostName: 'test-cdnpafdp-origin.azurewebsites.net'
            name: 'test-cdnpafdp-origin'
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
                  customHostname: 'dev-contoso.azurewebsites.net'
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
      "value": "test-afd-cdnpafdp"
    },
    "sku": {
      "value": "Premium_AzureFrontDoor"
    },
    // Non-required parameters
    "afdEndpoints": {
      "value": [
        {
          "name": "test-afd-cdnpafdp-afd-endpoint",
          "routes": [
            {
              "customDomainNames": [
                "test-cdnpafdp-custom-domain"
              ],
              "name": "test-cdnpafdp-afd-route",
              "originGroupName": "test-cdnpafdp-origin-group",
              "ruleSets": [
                "deptestcdnpafdpruleset"
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
          "hostName": "test-cdnpafdp-custom-domain.azurewebsites.net",
          "name": "test-cdnpafdp-custom-domain"
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
          "name": "test-cdnpafdp-origin-group",
          "origins": [
            {
              "hostName": "test-cdnpafdp-origin.azurewebsites.net",
              "name": "test-cdnpafdp-origin"
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
                    "customHostname": "dev-contoso.azurewebsites.net",
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
param name = 'test-afd-cdnpafdp'
param sku = 'Premium_AzureFrontDoor'
// Non-required parameters
param afdEndpoints = [
  {
    name: 'test-afd-cdnpafdp-afd-endpoint'
    routes: [
      {
        customDomainNames: [
          'test-cdnpafdp-custom-domain'
        ]
        name: 'test-cdnpafdp-afd-route'
        originGroupName: 'test-cdnpafdp-origin-group'
        ruleSets: [
          'deptestcdnpafdpruleset'
        ]
      }
    ]
  }
]
param customDomains = [
  {
    certificateType: 'ManagedCertificate'
    hostName: 'test-cdnpafdp-custom-domain.azurewebsites.net'
    name: 'test-cdnpafdp-custom-domain'
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
    name: 'test-cdnpafdp-origin-group'
    origins: [
      {
        hostName: 'test-cdnpafdp-origin.azurewebsites.net'
        name: 'test-cdnpafdp-origin'
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
              customHostname: 'dev-contoso.azurewebsites.net'
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

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/afd]


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  params: {
    // Required parameters
    name: 'test-cdnpafd'
    sku: 'Standard_AzureFrontDoor'
    // Non-required parameters
    afdEndpoints: [
      {
        name: 'test-cdnpafd-afd-endpoint'
        routes: [
          {
            customDomainNames: [
              'test-cdnpafd-custom-domain'
            ]
            name: 'test-cdnpafd-afd-route'
            originGroupName: 'test-cdnpafd-origin-group'
            ruleSets: [
              'deptestcdnpafdruleset'
            ]
          }
        ]
      }
    ]
    customDomains: [
      {
        certificateType: 'ManagedCertificate'
        hostName: 'test-cdnpafd-custom-domain.azurewebsites.net'
        name: 'test-cdnpafd-custom-domain'
      }
      {
        certificateType: 'ManagedCertificate'
        cipherSuiteSetType: 'TLS12_2022'
        hostName: 'test2-cdnpafd-custom-domain.azurewebsites.net'
        name: 'test2-cdnpafd-custom-domain'
      }
      {
        certificateType: 'ManagedCertificate'
        cipherSuiteSetType: 'Customized'
        customizedCipherSuiteSet: {
          cipherSuiteSetForTls12: [
            'DHE_RSA_AES128_GCM_SHA256'
            'DHE_RSA_AES256_GCM_SHA384'
          ]
          cipherSuiteSetForTls13: [
            'TLS_AES_128_GCM_SHA256'
            'TLS_AES_256_GCM_SHA384'
          ]
        }
        hostName: 'test3-cdnpafd-custom-domain.azurewebsites.net'
        name: 'test3-cdnpafd-custom-domain'
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
        name: 'test-cdnpafd-origin-group'
        origins: [
          {
            hostName: 'test-cdnpafd-origin.azurewebsites.net'
            name: 'test-cdnpafd-origin'
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
                  customHostname: 'dev-contoso.azurewebsites.net'
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
      "value": "test-cdnpafd"
    },
    "sku": {
      "value": "Standard_AzureFrontDoor"
    },
    // Non-required parameters
    "afdEndpoints": {
      "value": [
        {
          "name": "test-cdnpafd-afd-endpoint",
          "routes": [
            {
              "customDomainNames": [
                "test-cdnpafd-custom-domain"
              ],
              "name": "test-cdnpafd-afd-route",
              "originGroupName": "test-cdnpafd-origin-group",
              "ruleSets": [
                "deptestcdnpafdruleset"
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
          "hostName": "test-cdnpafd-custom-domain.azurewebsites.net",
          "name": "test-cdnpafd-custom-domain"
        },
        {
          "certificateType": "ManagedCertificate",
          "cipherSuiteSetType": "TLS12_2022",
          "hostName": "test2-cdnpafd-custom-domain.azurewebsites.net",
          "name": "test2-cdnpafd-custom-domain"
        },
        {
          "certificateType": "ManagedCertificate",
          "cipherSuiteSetType": "Customized",
          "customizedCipherSuiteSet": {
            "cipherSuiteSetForTls12": [
              "DHE_RSA_AES128_GCM_SHA256",
              "DHE_RSA_AES256_GCM_SHA384"
            ],
            "cipherSuiteSetForTls13": [
              "TLS_AES_128_GCM_SHA256",
              "TLS_AES_256_GCM_SHA384"
            ]
          },
          "hostName": "test3-cdnpafd-custom-domain.azurewebsites.net",
          "name": "test3-cdnpafd-custom-domain"
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
          "name": "test-cdnpafd-origin-group",
          "origins": [
            {
              "hostName": "test-cdnpafd-origin.azurewebsites.net",
              "name": "test-cdnpafd-origin"
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
                    "customHostname": "dev-contoso.azurewebsites.net",
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
param name = 'test-cdnpafd'
param sku = 'Standard_AzureFrontDoor'
// Non-required parameters
param afdEndpoints = [
  {
    name: 'test-cdnpafd-afd-endpoint'
    routes: [
      {
        customDomainNames: [
          'test-cdnpafd-custom-domain'
        ]
        name: 'test-cdnpafd-afd-route'
        originGroupName: 'test-cdnpafd-origin-group'
        ruleSets: [
          'deptestcdnpafdruleset'
        ]
      }
    ]
  }
]
param customDomains = [
  {
    certificateType: 'ManagedCertificate'
    hostName: 'test-cdnpafd-custom-domain.azurewebsites.net'
    name: 'test-cdnpafd-custom-domain'
  }
  {
    certificateType: 'ManagedCertificate'
    cipherSuiteSetType: 'TLS12_2022'
    hostName: 'test2-cdnpafd-custom-domain.azurewebsites.net'
    name: 'test2-cdnpafd-custom-domain'
  }
  {
    certificateType: 'ManagedCertificate'
    cipherSuiteSetType: 'Customized'
    customizedCipherSuiteSet: {
      cipherSuiteSetForTls12: [
        'DHE_RSA_AES128_GCM_SHA256'
        'DHE_RSA_AES256_GCM_SHA384'
      ]
      cipherSuiteSetForTls13: [
        'TLS_AES_128_GCM_SHA256'
        'TLS_AES_256_GCM_SHA384'
      ]
    }
    hostName: 'test3-cdnpafd-custom-domain.azurewebsites.net'
    name: 'test3-cdnpafd-custom-domain'
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
    name: 'test-cdnpafd-origin-group'
    origins: [
      {
        hostName: 'test-cdnpafd-origin.azurewebsites.net'
        name: 'test-cdnpafd-origin'
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
              customHostname: 'dev-contoso.azurewebsites.net'
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

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  params: {
    // Required parameters
    name: 'test-cdnpmin'
    sku: 'Standard_AzureFrontDoor'
    // Non-required parameters
    location: 'global'
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
      "value": "test-cdnpmin"
    },
    "sku": {
      "value": "Standard_AzureFrontDoor"
    },
    // Non-required parameters
    "location": {
      "value": "global"
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
param name = 'test-cdnpmin'
param sku = 'Standard_AzureFrontDoor'
// Non-required parameters
param location = 'global'
```

</details>
<p>

### Example 4: _Using maximum parameter set_

This instance deploys the module with all available features and parameters for Premium_AzureFrontDoor SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  params: {
    // Required parameters
    name: 'test-cdnpmax'
    sku: 'Premium_AzureFrontDoor'
    // Non-required parameters
    afdEndpoints: [
      {
        autoGeneratedDomainNameLabelScope: 'TenantReuse'
        enabledState: 'Enabled'
        name: 'test-cdnpmax-afd-endpoint-1'
        routes: [
          {
            cacheConfiguration: {
              compressionSettings: {
                contentTypesToCompress: [
                  'application/json'
                  'text/css'
                  'text/html'
                ]
                isCompressionEnabled: true
              }
              queryParameters: 'version,locale'
              queryStringCachingBehavior: 'IncludeSpecifiedQueryStrings'
            }
            customDomainNames: [
              'test1-cdnpmax-custom-domain'
            ]
            enabledState: 'Enabled'
            forwardingProtocol: 'MatchRequest'
            httpsRedirect: 'Enabled'
            linkToDefaultDomain: 'Enabled'
            name: 'test-cdnpmax-afd-route-1'
            originGroupName: 'test-cdnpmax-origin-group-1'
            patternsToMatch: [
              '/api/*'
              '/health'
            ]
            ruleSets: [
              'deptestcdnpmaxruleset1'
            ]
            supportedProtocols: [
              'Http'
              'Https'
            ]
          }
        ]
      }
    ]
    customDomains: [
      {
        certificateType: 'ManagedCertificate'
        hostName: 'test1-cdnpmax-custom-domain.azurewebsites.net'
        minimumTlsVersion: 'TLS12'
        name: 'test1-cdnpmax-custom-domain'
      }
      {
        certificateType: 'ManagedCertificate'
        cipherSuiteSetType: 'TLS12_2022'
        hostName: 'test2-cdnpmax-custom-domain.azurewebsites.net'
        minimumTlsVersion: 'TLS12'
        name: 'test2-cdnpmax-custom-domain'
      }
      {
        certificateType: 'ManagedCertificate'
        cipherSuiteSetType: 'Customized'
        customizedCipherSuiteSet: {
          cipherSuiteSetForTls13: [
            'TLS_AES_128_GCM_SHA256'
            'TLS_AES_256_GCM_SHA384'
          ]
        }
        hostName: 'test3-cdnpmax-custom-domain.azurewebsites.net'
        minimumTlsVersion: 'TLS13'
        name: 'test3-cdnpmax-custom-domain'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
            enabled: true
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
      notes: 'This resource cannot be deleted for security reasons.'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    originGroups: [
      {
        healthProbeSettings: {
          probeIntervalInSeconds: 120
          probePath: '/health'
          probeProtocol: 'Https'
          probeRequestType: 'GET'
        }
        loadBalancingSettings: {
          additionalLatencyInMilliseconds: 50
          sampleSize: 4
          successfulSamplesRequired: 3
        }
        name: 'test-cdnpmax-origin-group-1'
        origins: [
          {
            enabledState: 'Enabled'
            enforceCertificateNameCheck: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
            name: 'test-cdnpmax-origin-1'
            priority: 1
            weight: 1000
          }
        ]
        sessionAffinityState: 'Enabled'
        trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 15
      }
      {
        loadBalancingSettings: {
          additionalLatencyInMilliseconds: 100
          sampleSize: 6
          successfulSamplesRequired: 4
        }
        name: 'test-cdnpmax-origin-group-2'
        origins: [
          {
            enabledState: 'Enabled'
            enforceCertificateNameCheck: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
            name: 'test-cdnpmax-origin-2'
            priority: 1
            weight: 1000
          }
        ]
        sessionAffinityState: 'Disabled'
        trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 10
      }
    ]
    originResponseTimeoutSeconds: 240
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'CDN Profile Contributor'
      }
    ]
    ruleSets: [
      {
        name: 'deptestcdnpmaxruleset1'
        rules: [
          {
            actions: [
              {
                name: 'UrlRedirect'
                parameters: {
                  customHostname: 'api.example.com'
                  customPath: '/v2/api/'
                  destinationProtocol: 'Https'
                  redirectType: 'PermanentRedirect'
                  typeName: 'DeliveryRuleUrlRedirectActionParameters'
                }
              }
            ]
            conditions: []
            matchProcessingBehavior: 'Continue'
            name: 'deptestcdnpmaxrule1'
            order: 1
          }
        ]
      }
    ]
    tags: {
      Application: 'CDN'
      CostCenter: '12345'
      Environment: 'Test'
      Owner: 'TestTeam'
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
      "value": "test-cdnpmax"
    },
    "sku": {
      "value": "Premium_AzureFrontDoor"
    },
    // Non-required parameters
    "afdEndpoints": {
      "value": [
        {
          "autoGeneratedDomainNameLabelScope": "TenantReuse",
          "enabledState": "Enabled",
          "name": "test-cdnpmax-afd-endpoint-1",
          "routes": [
            {
              "cacheConfiguration": {
                "compressionSettings": {
                  "contentTypesToCompress": [
                    "application/json",
                    "text/css",
                    "text/html"
                  ],
                  "isCompressionEnabled": true
                },
                "queryParameters": "version,locale",
                "queryStringCachingBehavior": "IncludeSpecifiedQueryStrings"
              },
              "customDomainNames": [
                "test1-cdnpmax-custom-domain"
              ],
              "enabledState": "Enabled",
              "forwardingProtocol": "MatchRequest",
              "httpsRedirect": "Enabled",
              "linkToDefaultDomain": "Enabled",
              "name": "test-cdnpmax-afd-route-1",
              "originGroupName": "test-cdnpmax-origin-group-1",
              "patternsToMatch": [
                "/api/*",
                "/health"
              ],
              "ruleSets": [
                "deptestcdnpmaxruleset1"
              ],
              "supportedProtocols": [
                "Http",
                "Https"
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
          "hostName": "test1-cdnpmax-custom-domain.azurewebsites.net",
          "minimumTlsVersion": "TLS12",
          "name": "test1-cdnpmax-custom-domain"
        },
        {
          "certificateType": "ManagedCertificate",
          "cipherSuiteSetType": "TLS12_2022",
          "hostName": "test2-cdnpmax-custom-domain.azurewebsites.net",
          "minimumTlsVersion": "TLS12",
          "name": "test2-cdnpmax-custom-domain"
        },
        {
          "certificateType": "ManagedCertificate",
          "cipherSuiteSetType": "Customized",
          "customizedCipherSuiteSet": {
            "cipherSuiteSetForTls13": [
              "TLS_AES_128_GCM_SHA256",
              "TLS_AES_256_GCM_SHA384"
            ]
          },
          "hostName": "test3-cdnpmax-custom-domain.azurewebsites.net",
          "minimumTlsVersion": "TLS13",
          "name": "test3-cdnpmax-custom-domain"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs",
              "enabled": true
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics",
              "enabled": true
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "global"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName",
        "notes": "This resource cannot be deleted for security reasons."
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
    "originGroups": {
      "value": [
        {
          "healthProbeSettings": {
            "probeIntervalInSeconds": 120,
            "probePath": "/health",
            "probeProtocol": "Https",
            "probeRequestType": "GET"
          },
          "loadBalancingSettings": {
            "additionalLatencyInMilliseconds": 50,
            "sampleSize": 4,
            "successfulSamplesRequired": 3
          },
          "name": "test-cdnpmax-origin-group-1",
          "origins": [
            {
              "enabledState": "Enabled",
              "enforceCertificateNameCheck": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443,
              "name": "test-cdnpmax-origin-1",
              "priority": 1,
              "weight": 1000
            }
          ],
          "sessionAffinityState": "Enabled",
          "trafficRestorationTimeToHealedOrNewEndpointsInMinutes": 15
        },
        {
          "loadBalancingSettings": {
            "additionalLatencyInMilliseconds": 100,
            "sampleSize": 6,
            "successfulSamplesRequired": 4
          },
          "name": "test-cdnpmax-origin-group-2",
          "origins": [
            {
              "enabledState": "Enabled",
              "enforceCertificateNameCheck": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443,
              "name": "test-cdnpmax-origin-2",
              "priority": 1,
              "weight": 1000
            }
          ],
          "sessionAffinityState": "Disabled",
          "trafficRestorationTimeToHealedOrNewEndpointsInMinutes": 10
        }
      ]
    },
    "originResponseTimeoutSeconds": {
      "value": 240
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "CDN Profile Contributor"
        }
      ]
    },
    "ruleSets": {
      "value": [
        {
          "name": "deptestcdnpmaxruleset1",
          "rules": [
            {
              "actions": [
                {
                  "name": "UrlRedirect",
                  "parameters": {
                    "customHostname": "api.example.com",
                    "customPath": "/v2/api/",
                    "destinationProtocol": "Https",
                    "redirectType": "PermanentRedirect",
                    "typeName": "DeliveryRuleUrlRedirectActionParameters"
                  }
                }
              ],
              "conditions": [],
              "matchProcessingBehavior": "Continue",
              "name": "deptestcdnpmaxrule1",
              "order": 1
            }
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "Application": "CDN",
        "CostCenter": "12345",
        "Environment": "Test",
        "Owner": "TestTeam"
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
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'test-cdnpmax'
param sku = 'Premium_AzureFrontDoor'
// Non-required parameters
param afdEndpoints = [
  {
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
    enabledState: 'Enabled'
    name: 'test-cdnpmax-afd-endpoint-1'
    routes: [
      {
        cacheConfiguration: {
          compressionSettings: {
            contentTypesToCompress: [
              'application/json'
              'text/css'
              'text/html'
            ]
            isCompressionEnabled: true
          }
          queryParameters: 'version,locale'
          queryStringCachingBehavior: 'IncludeSpecifiedQueryStrings'
        }
        customDomainNames: [
          'test1-cdnpmax-custom-domain'
        ]
        enabledState: 'Enabled'
        forwardingProtocol: 'MatchRequest'
        httpsRedirect: 'Enabled'
        linkToDefaultDomain: 'Enabled'
        name: 'test-cdnpmax-afd-route-1'
        originGroupName: 'test-cdnpmax-origin-group-1'
        patternsToMatch: [
          '/api/*'
          '/health'
        ]
        ruleSets: [
          'deptestcdnpmaxruleset1'
        ]
        supportedProtocols: [
          'Http'
          'Https'
        ]
      }
    ]
  }
]
param customDomains = [
  {
    certificateType: 'ManagedCertificate'
    hostName: 'test1-cdnpmax-custom-domain.azurewebsites.net'
    minimumTlsVersion: 'TLS12'
    name: 'test1-cdnpmax-custom-domain'
  }
  {
    certificateType: 'ManagedCertificate'
    cipherSuiteSetType: 'TLS12_2022'
    hostName: 'test2-cdnpmax-custom-domain.azurewebsites.net'
    minimumTlsVersion: 'TLS12'
    name: 'test2-cdnpmax-custom-domain'
  }
  {
    certificateType: 'ManagedCertificate'
    cipherSuiteSetType: 'Customized'
    customizedCipherSuiteSet: {
      cipherSuiteSetForTls13: [
        'TLS_AES_128_GCM_SHA256'
        'TLS_AES_256_GCM_SHA384'
      ]
    }
    hostName: 'test3-cdnpmax-custom-domain.azurewebsites.net'
    minimumTlsVersion: 'TLS13'
    name: 'test3-cdnpmax-custom-domain'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metricCategories: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = 'global'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
  notes: 'This resource cannot be deleted for security reasons.'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param originGroups = [
  {
    healthProbeSettings: {
      probeIntervalInSeconds: 120
      probePath: '/health'
      probeProtocol: 'Https'
      probeRequestType: 'GET'
    }
    loadBalancingSettings: {
      additionalLatencyInMilliseconds: 50
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    name: 'test-cdnpmax-origin-group-1'
    origins: [
      {
        enabledState: 'Enabled'
        enforceCertificateNameCheck: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
        name: 'test-cdnpmax-origin-1'
        priority: 1
        weight: 1000
      }
    ]
    sessionAffinityState: 'Enabled'
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 15
  }
  {
    loadBalancingSettings: {
      additionalLatencyInMilliseconds: 100
      sampleSize: 6
      successfulSamplesRequired: 4
    }
    name: 'test-cdnpmax-origin-group-2'
    origins: [
      {
        enabledState: 'Enabled'
        enforceCertificateNameCheck: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
        name: 'test-cdnpmax-origin-2'
        priority: 1
        weight: 1000
      }
    ]
    sessionAffinityState: 'Disabled'
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 10
  }
]
param originResponseTimeoutSeconds = 240
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'CDN Profile Contributor'
  }
]
param ruleSets = [
  {
    name: 'deptestcdnpmaxruleset1'
    rules: [
      {
        actions: [
          {
            name: 'UrlRedirect'
            parameters: {
              customHostname: 'api.example.com'
              customPath: '/v2/api/'
              destinationProtocol: 'Https'
              redirectType: 'PermanentRedirect'
              typeName: 'DeliveryRuleUrlRedirectActionParameters'
            }
          }
        ]
        conditions: []
        matchProcessingBehavior: 'Continue'
        name: 'deptestcdnpmaxrule1'
        order: 1
      }
    ]
  }
]
param tags = {
  Application: 'CDN'
  CostCenter: '12345'
  Environment: 'Test'
  Owner: 'TestTeam'
}
```

</details>
<p>

### Example 5: _WAF-aligned Premium AFD_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework using Premium_AzureFrontDoor SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module profile 'br/public:avm/res/cdn/profile:<version>' = {
  params: {
    // Required parameters
    name: 'waf-cdnpwaf'
    sku: 'Premium_AzureFrontDoor'
    // Non-required parameters
    afdEndpoints: [
      {
        autoGeneratedDomainNameLabelScope: 'TenantReuse'
        enabledState: 'Enabled'
        name: 'waf-primary-endpoint'
        routes: [
          {
            cacheConfiguration: {
              compressionSettings: {
                contentTypesToCompress: [
                  'application/json'
                  'application/xml'
                  'text/xml'
                ]
                isCompressionEnabled: true
              }
              queryParameters: 'timestamp,nonce'
              queryStringCachingBehavior: 'IgnoreSpecifiedQueryStrings'
            }
            customDomainNames: [
              'waf-api-cdnpwaf-domain'
            ]
            enabledState: 'Enabled'
            forwardingProtocol: 'HttpsOnly'
            httpsRedirect: 'Enabled'
            linkToDefaultDomain: 'Disabled'
            name: 'waf-api-route'
            originGroupName: 'waf-api-origin-group'
            patternsToMatch: [
              '/api/*'
              '/v1/*'
              '/v2/*'
            ]
            ruleSets: [
              'depwafsecurityrulescdnpwaf'
            ]
            supportedProtocols: [
              'Https'
            ]
          }
        ]
      }
    ]
    customDomains: [
      {
        certificateType: 'ManagedCertificate'
        cipherSuiteSetType: 'TLS12_2023'
        hostName: 'waf-primary-cdnpwaf.example.com'
        minimumTlsVersion: 'TLS12'
        name: 'waf-primary-cdnpwaf-domain'
      }
      {
        certificateType: 'ManagedCertificate'
        cipherSuiteSetType: 'Customized'
        customizedCipherSuiteSet: {
          cipherSuiteSetForTls13: [
            'TLS_AES_128_GCM_SHA256'
            'TLS_AES_256_GCM_SHA384'
          ]
        }
        hostName: 'api-waf-cdnpwaf.example.com'
        minimumTlsVersion: 'TLS13'
        name: 'waf-api-cdnpwaf-domain'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
            enabled: true
          }
        ]
        name: 'waf-comprehensive-diagnostics'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'waf-protection-lock'
      notes: 'WAF: Protected against accidental deletion for business continuity'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    originGroups: [
      {
        healthProbeSettings: {
          probeIntervalInSeconds: 15
          probePath: '/api/health'
          probeProtocol: 'Https'
          probeRequestType: 'GET'
        }
        loadBalancingSettings: {
          additionalLatencyInMilliseconds: 25
          sampleSize: 6
          successfulSamplesRequired: 4
        }
        name: 'waf-api-origin-group'
        origins: [
          {
            enabledState: 'Enabled'
            enforceCertificateNameCheck: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
            name: 'waf-api-origin'
            originHostHeader: 'www.bing.com'
            priority: 1
            weight: 100
          }
          {
            enabledState: 'Enabled'
            enforceCertificateNameCheck: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
            name: 'waf-api-origin-no-2'
            originHostHeader: ''
            priority: 2
            weight: 200
          }
          {
            enabledState: 'Enabled'
            enforceCertificateNameCheck: true
            hostName: '<hostName>'
            httpPort: 80
            httpsPort: 443
            name: 'waf-api-origin-no-3'
            priority: 3
            weight: 300
          }
        ]
        sessionAffinityState: 'Disabled'
        trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 2
      }
    ]
    originResponseTimeoutSeconds: 60
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'CDN Profile Reader'
      }
    ]
    ruleSets: [
      {
        name: 'depwafsecurityrulescdnpwaf'
        rules: [
          {
            actions: [
              {
                name: 'UrlRedirect'
                parameters: {
                  destinationProtocol: 'Https'
                  redirectType: 'PermanentRedirect'
                  typeName: 'DeliveryRuleUrlRedirectActionParameters'
                }
              }
            ]
            conditions: [
              {
                name: 'RequestScheme'
                parameters: {
                  matchValues: [
                    'HTTP'
                  ]
                  negateCondition: false
                  operator: 'Equal'
                  typeName: 'DeliveryRuleRequestSchemeConditionParameters'
                }
              }
            ]
            matchProcessingBehavior: 'Stop'
            name: 'HTTPSRedirectRule'
            order: 1
          }
          {
            actions: [
              {
                name: 'ModifyResponseHeader'
                parameters: {
                  headerAction: 'Overwrite'
                  headerName: 'Strict-Transport-Security'
                  typeName: 'DeliveryRuleHeaderActionParameters'
                  value: 'max-age=31536000; includeSubDomains; preload'
                }
              }
              {
                name: 'ModifyResponseHeader'
                parameters: {
                  headerAction: 'Overwrite'
                  headerName: 'X-Content-Type-Options'
                  typeName: 'DeliveryRuleHeaderActionParameters'
                  value: 'nosniff'
                }
              }
              {
                name: 'ModifyResponseHeader'
                parameters: {
                  headerAction: 'Overwrite'
                  headerName: 'X-Frame-Options'
                  typeName: 'DeliveryRuleHeaderActionParameters'
                  value: 'DENY'
                }
              }
              {
                name: 'ModifyResponseHeader'
                parameters: {
                  headerAction: 'Overwrite'
                  headerName: 'X-XSS-Protection'
                  typeName: 'DeliveryRuleHeaderActionParameters'
                  value: '1; mode=block'
                }
              }
              {
                name: 'ModifyResponseHeader'
                parameters: {
                  headerAction: 'Overwrite'
                  headerName: 'Referrer-Policy'
                  typeName: 'DeliveryRuleHeaderActionParameters'
                  value: 'strict-origin-when-cross-origin'
                }
              }
            ]
            conditions: [
              {
                name: 'RequestScheme'
                parameters: {
                  matchValues: [
                    'HTTPS'
                  ]
                  negateCondition: false
                  operator: 'Equal'
                  typeName: 'DeliveryRuleRequestSchemeConditionParameters'
                }
              }
            ]
            matchProcessingBehavior: 'Continue'
            name: 'SecurityHeadersRule'
            order: 2
          }
          {
            actions: [
              {
                name: 'ModifyResponseHeader'
                parameters: {
                  headerAction: 'Overwrite'
                  headerName: 'X-RateLimit-Limit'
                  typeName: 'DeliveryRuleHeaderActionParameters'
                  value: '1000'
                }
              }
            ]
            conditions: [
              {
                name: 'RequestUri'
                parameters: {
                  matchValues: [
                    '/api/'
                  ]
                  negateCondition: false
                  operator: 'BeginsWith'
                  transforms: [
                    'Lowercase'
                  ]
                  typeName: 'DeliveryRuleRequestUriConditionParameters'
                }
              }
            ]
            matchProcessingBehavior: 'Continue'
            name: 'APIRateLimitRule'
            order: 3
          }
        ]
      }
    ]
    tags: {
      Application: 'CDN-WAF-Aligned'
      BackupRequired: 'Yes'
      BusinessUnit: 'Digital-Services'
      CostCenter: 'IT-Infrastructure'
      Criticality: 'High'
      DataClassification: 'Internal'
      Environment: 'Production'
      MonitoringRequired: 'Yes'
      Owner: 'Platform-Team'
      'WAF-Pillar': 'All'
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
      "value": "waf-cdnpwaf"
    },
    "sku": {
      "value": "Premium_AzureFrontDoor"
    },
    // Non-required parameters
    "afdEndpoints": {
      "value": [
        {
          "autoGeneratedDomainNameLabelScope": "TenantReuse",
          "enabledState": "Enabled",
          "name": "waf-primary-endpoint",
          "routes": [
            {
              "cacheConfiguration": {
                "compressionSettings": {
                  "contentTypesToCompress": [
                    "application/json",
                    "application/xml",
                    "text/xml"
                  ],
                  "isCompressionEnabled": true
                },
                "queryParameters": "timestamp,nonce",
                "queryStringCachingBehavior": "IgnoreSpecifiedQueryStrings"
              },
              "customDomainNames": [
                "waf-api-cdnpwaf-domain"
              ],
              "enabledState": "Enabled",
              "forwardingProtocol": "HttpsOnly",
              "httpsRedirect": "Enabled",
              "linkToDefaultDomain": "Disabled",
              "name": "waf-api-route",
              "originGroupName": "waf-api-origin-group",
              "patternsToMatch": [
                "/api/*",
                "/v1/*",
                "/v2/*"
              ],
              "ruleSets": [
                "depwafsecurityrulescdnpwaf"
              ],
              "supportedProtocols": [
                "Https"
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
          "cipherSuiteSetType": "TLS12_2023",
          "hostName": "waf-primary-cdnpwaf.example.com",
          "minimumTlsVersion": "TLS12",
          "name": "waf-primary-cdnpwaf-domain"
        },
        {
          "certificateType": "ManagedCertificate",
          "cipherSuiteSetType": "Customized",
          "customizedCipherSuiteSet": {
            "cipherSuiteSetForTls13": [
              "TLS_AES_128_GCM_SHA256",
              "TLS_AES_256_GCM_SHA384"
            ]
          },
          "hostName": "api-waf-cdnpwaf.example.com",
          "minimumTlsVersion": "TLS13",
          "name": "waf-api-cdnpwaf-domain"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs",
              "enabled": true
            }
          ],
          "metricCategories": [
            {
              "category": "AllMetrics",
              "enabled": true
            }
          ],
          "name": "waf-comprehensive-diagnostics",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "location": {
      "value": "global"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "waf-protection-lock",
        "notes": "WAF: Protected against accidental deletion for business continuity"
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
    "originGroups": {
      "value": [
        {
          "healthProbeSettings": {
            "probeIntervalInSeconds": 15,
            "probePath": "/api/health",
            "probeProtocol": "Https",
            "probeRequestType": "GET"
          },
          "loadBalancingSettings": {
            "additionalLatencyInMilliseconds": 25,
            "sampleSize": 6,
            "successfulSamplesRequired": 4
          },
          "name": "waf-api-origin-group",
          "origins": [
            {
              "enabledState": "Enabled",
              "enforceCertificateNameCheck": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443,
              "name": "waf-api-origin",
              "originHostHeader": "www.bing.com",
              "priority": 1,
              "weight": 100
            },
            {
              "enabledState": "Enabled",
              "enforceCertificateNameCheck": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443,
              "name": "waf-api-origin-no-2",
              "originHostHeader": "",
              "priority": 2,
              "weight": 200
            },
            {
              "enabledState": "Enabled",
              "enforceCertificateNameCheck": true,
              "hostName": "<hostName>",
              "httpPort": 80,
              "httpsPort": 443,
              "name": "waf-api-origin-no-3",
              "priority": 3,
              "weight": 300
            }
          ],
          "sessionAffinityState": "Disabled",
          "trafficRestorationTimeToHealedOrNewEndpointsInMinutes": 2
        }
      ]
    },
    "originResponseTimeoutSeconds": {
      "value": 60
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "CDN Profile Reader"
        }
      ]
    },
    "ruleSets": {
      "value": [
        {
          "name": "depwafsecurityrulescdnpwaf",
          "rules": [
            {
              "actions": [
                {
                  "name": "UrlRedirect",
                  "parameters": {
                    "destinationProtocol": "Https",
                    "redirectType": "PermanentRedirect",
                    "typeName": "DeliveryRuleUrlRedirectActionParameters"
                  }
                }
              ],
              "conditions": [
                {
                  "name": "RequestScheme",
                  "parameters": {
                    "matchValues": [
                      "HTTP"
                    ],
                    "negateCondition": false,
                    "operator": "Equal",
                    "typeName": "DeliveryRuleRequestSchemeConditionParameters"
                  }
                }
              ],
              "matchProcessingBehavior": "Stop",
              "name": "HTTPSRedirectRule",
              "order": 1
            },
            {
              "actions": [
                {
                  "name": "ModifyResponseHeader",
                  "parameters": {
                    "headerAction": "Overwrite",
                    "headerName": "Strict-Transport-Security",
                    "typeName": "DeliveryRuleHeaderActionParameters",
                    "value": "max-age=31536000; includeSubDomains; preload"
                  }
                },
                {
                  "name": "ModifyResponseHeader",
                  "parameters": {
                    "headerAction": "Overwrite",
                    "headerName": "X-Content-Type-Options",
                    "typeName": "DeliveryRuleHeaderActionParameters",
                    "value": "nosniff"
                  }
                },
                {
                  "name": "ModifyResponseHeader",
                  "parameters": {
                    "headerAction": "Overwrite",
                    "headerName": "X-Frame-Options",
                    "typeName": "DeliveryRuleHeaderActionParameters",
                    "value": "DENY"
                  }
                },
                {
                  "name": "ModifyResponseHeader",
                  "parameters": {
                    "headerAction": "Overwrite",
                    "headerName": "X-XSS-Protection",
                    "typeName": "DeliveryRuleHeaderActionParameters",
                    "value": "1; mode=block"
                  }
                },
                {
                  "name": "ModifyResponseHeader",
                  "parameters": {
                    "headerAction": "Overwrite",
                    "headerName": "Referrer-Policy",
                    "typeName": "DeliveryRuleHeaderActionParameters",
                    "value": "strict-origin-when-cross-origin"
                  }
                }
              ],
              "conditions": [
                {
                  "name": "RequestScheme",
                  "parameters": {
                    "matchValues": [
                      "HTTPS"
                    ],
                    "negateCondition": false,
                    "operator": "Equal",
                    "typeName": "DeliveryRuleRequestSchemeConditionParameters"
                  }
                }
              ],
              "matchProcessingBehavior": "Continue",
              "name": "SecurityHeadersRule",
              "order": 2
            },
            {
              "actions": [
                {
                  "name": "ModifyResponseHeader",
                  "parameters": {
                    "headerAction": "Overwrite",
                    "headerName": "X-RateLimit-Limit",
                    "typeName": "DeliveryRuleHeaderActionParameters",
                    "value": "1000"
                  }
                }
              ],
              "conditions": [
                {
                  "name": "RequestUri",
                  "parameters": {
                    "matchValues": [
                      "/api/"
                    ],
                    "negateCondition": false,
                    "operator": "BeginsWith",
                    "transforms": [
                      "Lowercase"
                    ],
                    "typeName": "DeliveryRuleRequestUriConditionParameters"
                  }
                }
              ],
              "matchProcessingBehavior": "Continue",
              "name": "APIRateLimitRule",
              "order": 3
            }
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "Application": "CDN-WAF-Aligned",
        "BackupRequired": "Yes",
        "BusinessUnit": "Digital-Services",
        "CostCenter": "IT-Infrastructure",
        "Criticality": "High",
        "DataClassification": "Internal",
        "Environment": "Production",
        "MonitoringRequired": "Yes",
        "Owner": "Platform-Team",
        "WAF-Pillar": "All"
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
using 'br/public:avm/res/cdn/profile:<version>'

// Required parameters
param name = 'waf-cdnpwaf'
param sku = 'Premium_AzureFrontDoor'
// Non-required parameters
param afdEndpoints = [
  {
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
    enabledState: 'Enabled'
    name: 'waf-primary-endpoint'
    routes: [
      {
        cacheConfiguration: {
          compressionSettings: {
            contentTypesToCompress: [
              'application/json'
              'application/xml'
              'text/xml'
            ]
            isCompressionEnabled: true
          }
          queryParameters: 'timestamp,nonce'
          queryStringCachingBehavior: 'IgnoreSpecifiedQueryStrings'
        }
        customDomainNames: [
          'waf-api-cdnpwaf-domain'
        ]
        enabledState: 'Enabled'
        forwardingProtocol: 'HttpsOnly'
        httpsRedirect: 'Enabled'
        linkToDefaultDomain: 'Disabled'
        name: 'waf-api-route'
        originGroupName: 'waf-api-origin-group'
        patternsToMatch: [
          '/api/*'
          '/v1/*'
          '/v2/*'
        ]
        ruleSets: [
          'depwafsecurityrulescdnpwaf'
        ]
        supportedProtocols: [
          'Https'
        ]
      }
    ]
  }
]
param customDomains = [
  {
    certificateType: 'ManagedCertificate'
    cipherSuiteSetType: 'TLS12_2023'
    hostName: 'waf-primary-cdnpwaf.example.com'
    minimumTlsVersion: 'TLS12'
    name: 'waf-primary-cdnpwaf-domain'
  }
  {
    certificateType: 'ManagedCertificate'
    cipherSuiteSetType: 'Customized'
    customizedCipherSuiteSet: {
      cipherSuiteSetForTls13: [
        'TLS_AES_128_GCM_SHA256'
        'TLS_AES_256_GCM_SHA384'
      ]
    }
    hostName: 'api-waf-cdnpwaf.example.com'
    minimumTlsVersion: 'TLS13'
    name: 'waf-api-cdnpwaf-domain'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metricCategories: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    name: 'waf-comprehensive-diagnostics'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = 'global'
param lock = {
  kind: 'CanNotDelete'
  name: 'waf-protection-lock'
  notes: 'WAF: Protected against accidental deletion for business continuity'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param originGroups = [
  {
    healthProbeSettings: {
      probeIntervalInSeconds: 15
      probePath: '/api/health'
      probeProtocol: 'Https'
      probeRequestType: 'GET'
    }
    loadBalancingSettings: {
      additionalLatencyInMilliseconds: 25
      sampleSize: 6
      successfulSamplesRequired: 4
    }
    name: 'waf-api-origin-group'
    origins: [
      {
        enabledState: 'Enabled'
        enforceCertificateNameCheck: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
        name: 'waf-api-origin'
        originHostHeader: 'www.bing.com'
        priority: 1
        weight: 100
      }
      {
        enabledState: 'Enabled'
        enforceCertificateNameCheck: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
        name: 'waf-api-origin-no-2'
        originHostHeader: ''
        priority: 2
        weight: 200
      }
      {
        enabledState: 'Enabled'
        enforceCertificateNameCheck: true
        hostName: '<hostName>'
        httpPort: 80
        httpsPort: 443
        name: 'waf-api-origin-no-3'
        priority: 3
        weight: 300
      }
    ]
    sessionAffinityState: 'Disabled'
    trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 2
  }
]
param originResponseTimeoutSeconds = 60
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'CDN Profile Reader'
  }
]
param ruleSets = [
  {
    name: 'depwafsecurityrulescdnpwaf'
    rules: [
      {
        actions: [
          {
            name: 'UrlRedirect'
            parameters: {
              destinationProtocol: 'Https'
              redirectType: 'PermanentRedirect'
              typeName: 'DeliveryRuleUrlRedirectActionParameters'
            }
          }
        ]
        conditions: [
          {
            name: 'RequestScheme'
            parameters: {
              matchValues: [
                'HTTP'
              ]
              negateCondition: false
              operator: 'Equal'
              typeName: 'DeliveryRuleRequestSchemeConditionParameters'
            }
          }
        ]
        matchProcessingBehavior: 'Stop'
        name: 'HTTPSRedirectRule'
        order: 1
      }
      {
        actions: [
          {
            name: 'ModifyResponseHeader'
            parameters: {
              headerAction: 'Overwrite'
              headerName: 'Strict-Transport-Security'
              typeName: 'DeliveryRuleHeaderActionParameters'
              value: 'max-age=31536000; includeSubDomains; preload'
            }
          }
          {
            name: 'ModifyResponseHeader'
            parameters: {
              headerAction: 'Overwrite'
              headerName: 'X-Content-Type-Options'
              typeName: 'DeliveryRuleHeaderActionParameters'
              value: 'nosniff'
            }
          }
          {
            name: 'ModifyResponseHeader'
            parameters: {
              headerAction: 'Overwrite'
              headerName: 'X-Frame-Options'
              typeName: 'DeliveryRuleHeaderActionParameters'
              value: 'DENY'
            }
          }
          {
            name: 'ModifyResponseHeader'
            parameters: {
              headerAction: 'Overwrite'
              headerName: 'X-XSS-Protection'
              typeName: 'DeliveryRuleHeaderActionParameters'
              value: '1; mode=block'
            }
          }
          {
            name: 'ModifyResponseHeader'
            parameters: {
              headerAction: 'Overwrite'
              headerName: 'Referrer-Policy'
              typeName: 'DeliveryRuleHeaderActionParameters'
              value: 'strict-origin-when-cross-origin'
            }
          }
        ]
        conditions: [
          {
            name: 'RequestScheme'
            parameters: {
              matchValues: [
                'HTTPS'
              ]
              negateCondition: false
              operator: 'Equal'
              typeName: 'DeliveryRuleRequestSchemeConditionParameters'
            }
          }
        ]
        matchProcessingBehavior: 'Continue'
        name: 'SecurityHeadersRule'
        order: 2
      }
      {
        actions: [
          {
            name: 'ModifyResponseHeader'
            parameters: {
              headerAction: 'Overwrite'
              headerName: 'X-RateLimit-Limit'
              typeName: 'DeliveryRuleHeaderActionParameters'
              value: '1000'
            }
          }
        ]
        conditions: [
          {
            name: 'RequestUri'
            parameters: {
              matchValues: [
                '/api/'
              ]
              negateCondition: false
              operator: 'BeginsWith'
              transforms: [
                'Lowercase'
              ]
              typeName: 'DeliveryRuleRequestUriConditionParameters'
            }
          }
        ]
        matchProcessingBehavior: 'Continue'
        name: 'APIRateLimitRule'
        order: 3
      }
    ]
  }
]
param tags = {
  Application: 'CDN-WAF-Aligned'
  BackupRequired: 'Yes'
  BusinessUnit: 'Digital-Services'
  CostCenter: 'IT-Infrastructure'
  Criticality: 'High'
  DataClassification: 'Internal'
  Environment: 'Production'
  MonitoringRequired: 'Yes'
  Owner: 'Platform-Team'
  'WAF-Pillar': 'All'
}
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
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`endpoint`](#parameter-endpoint) | object | Endpoint properties (see [ref](https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties) for details). |
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
    'Premium_AzureFrontDoor'
    'Standard_955BandWidth_ChinaCdn'
    'Standard_AvgBandWidth_ChinaCdn'
    'Standard_AzureFrontDoor'
    'Standard_ChinaCdn'
    'Standard_Microsoft'
    'StandardPlus_955BandWidth_ChinaCdn'
    'StandardPlus_AvgBandWidth_ChinaCdn'
    'StandardPlus_ChinaCdn'
  ]
  ```

### Parameter: `originGroups`

Array of origin group objects. Required if the afdEndpoints is specified.

- Required: No
- Type: array

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
| [`ruleSets`](#parameter-afdendpointsroutesrulesets) | array | The names of the rule sets of the rule. |
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

The names of the rule sets of the rule.

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
| [`cipherSuiteSetType`](#parameter-customdomainsciphersuitesettype) | string | The cipher suite set type that will be used for Https. |
| [`customizedCipherSuiteSet`](#parameter-customdomainscustomizedciphersuiteset) | object | The customized cipher suite set that will be used for Https. |
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

### Parameter: `customDomains.cipherSuiteSetType`

The cipher suite set type that will be used for Https.

- Required: No
- Type: string

### Parameter: `customDomains.customizedCipherSuiteSet`

The customized cipher suite set that will be used for Https.

- Required: No
- Type: object

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
    'TLS13'
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `endpoint`

Endpoint properties (see [ref](https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties) for details).

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-endpointname) | string | Name of the endpoint under the profile which is unique globally. |
| [`properties`](#parameter-endpointproperties) | object | Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tags`](#parameter-endpointtags) | object | Endpoint tags. |

### Parameter: `endpoint.name`

Name of the endpoint under the profile which is unique globally.

- Required: Yes
- Type: string

### Parameter: `endpoint.properties`

Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).

- Required: Yes
- Type: object

### Parameter: `endpoint.tags`

Endpoint tags.

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
| [`actions`](#parameter-rulesetsrulesactions) | array | A list of actions that are executed when all the conditions of a rule are satisfied. |
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

A list of actions that are executed when all the conditions of a rule are satisfied.

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-secretsname) | string | The name of the secret. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretSourceResourceId`](#parameter-secretssecretsourceresourceid) | string | The resource ID of the secret source. Required if the `type` is "CustomerCertificate". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretVersion`](#parameter-secretssecretversion) | string | The version of the secret. |
| [`subjectAlternativeNames`](#parameter-secretssubjectalternativenames) | array | The subject alternative names of the secret. |
| [`type`](#parameter-secretstype) | string | The type of the secret. |
| [`useLatestVersion`](#parameter-secretsuselatestversion) | bool | Indicates whether to use the latest version of the secret. |

### Parameter: `secrets.name`

The name of the secret.

- Required: Yes
- Type: string

### Parameter: `secrets.secretSourceResourceId`

The resource ID of the secret source. Required if the `type` is "CustomerCertificate".

- Required: No
- Type: string

### Parameter: `secrets.secretVersion`

The version of the secret.

- Required: No
- Type: string

### Parameter: `secrets.subjectAlternativeNames`

The subject alternative names of the secret.

- Required: No
- Type: array

### Parameter: `secrets.type`

The type of the secret.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureFirstPartyManagedCertificate'
    'CustomerCertificate'
    'ManagedCertificate'
    'UrlSigningKey'
  ]
  ```

### Parameter: `secrets.useLatestVersion`

Indicates whether to use the latest version of the secret.

- Required: No
- Type: bool

### Parameter: `securityPolicies`

Array of Security Policy objects (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies for details).

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associations`](#parameter-securitypoliciesassociations) | array | Domain names and URL patterns to match with this association. |
| [`name`](#parameter-securitypoliciesname) | string | Name of the security policy. |
| [`wafPolicyResourceId`](#parameter-securitypolicieswafpolicyresourceid) | string | Resource ID of WAF policy. |

### Parameter: `securityPolicies.associations`

Domain names and URL patterns to match with this association.

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
| `dnsValidation` | array | The list of records required for custom domains validation. |
| `endpointId` | string | The resource ID of the CDN profile endpoint. |
| `endpointName` | string | The name of the CDN profile endpoint. |
| `frontDoorEndpointHostNames` | array | The list of AFD endpoint host names. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the CDN profile. |
| `profileType` | string | The type of the CDN profile. |
| `resourceGroupName` | string | The resource group where the CDN profile is deployed. |
| `resourceId` | string | The resource ID of the CDN profile. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
| `uri` | string | The uri of the CDN profile endpoint. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
