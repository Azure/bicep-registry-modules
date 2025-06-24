# Web/Function Apps `[Microsoft.Web/sites]`

This module deploys a Web or Function App.

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
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/sites` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/config) |
| `Microsoft.Web/sites/extensions` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/extensions) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots) |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/slots/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/config) |
| `Microsoft.Web/sites/slots/extensions` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/extensions) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/hybridConnectionNamespaces/relays) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/site:<version>`.

- [Function App, using only defaults](#example-1-function-app-using-only-defaults)
- [Function App, using large parameter set](#example-2-function-app-using-large-parameter-set)
- [Linux Container Web App, using only defaults](#example-3-linux-container-web-app-using-only-defaults)
- [WAF-aligned](#example-4-waf-aligned)
- [Web App, using only defaults](#example-5-web-app-using-only-defaults)
- [Web App, using large parameter set](#example-6-web-app-using-large-parameter-set)
- [Linux Web App, using only defaults](#example-7-linux-web-app-using-only-defaults)
- [Linux Web App, using large parameter set](#example-8-linux-web-app-using-large-parameter-set)
- [Windows Web App for Containers, using only defaults](#example-9-windows-web-app-for-containers-using-only-defaults)

### Example 1: _Function App, using only defaults_

This instance deploys the module as Function App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: 'wsfamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "wsfamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'functionapp'
param name = 'wsfamin001'
param serverFarmResourceId = '<serverFarmResourceId>'
```

</details>
<p>

### Example 2: _Function App, using large parameter set_

This instance deploys the module as Function App with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: 'wsfamax001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    basicPublishingCredentialsPolicies: [
      {
        allow: false
        name: 'ftp'
      }
      {
        allow: false
        name: 'scm'
      }
    ]
    configs: [
      {
        applicationInsightResourceId: '<applicationInsightResourceId>'
        name: 'appsettings'
        properties: {
          AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
          EASYAUTH_SECRET: '<EASYAUTH_SECRET>'
          FUNCTIONS_EXTENSION_VERSION: '~4'
          FUNCTIONS_WORKER_RUNTIME: 'dotnet'
        }
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
      {
        name: 'authsettingsV2'
        properties: {
          globalValidation: {
            requireAuthentication: true
            unauthenticatedClientAction: 'Return401'
          }
          httpSettings: {
            forwardProxy: {
              convention: 'NoProxy'
            }
            requireHttps: true
            routes: {
              apiPrefix: '/.auth'
            }
          }
          identityProviders: {
            azureActiveDirectory: {
              enabled: true
              login: {
                disableWWWAuthenticate: false
              }
              registration: {
                clientId: 'd874dd2f-2032-4db1-a053-f0ec243685aa'
                clientSecretSettingName: 'EASYAUTH_SECRET'
                openIdIssuer: '<openIdIssuer>'
              }
              validation: {
                allowedAudiences: [
                  'api://d874dd2f-2032-4db1-a053-f0ec243685aa'
                ]
                defaultAuthorizationPolicy: {
                  allowedPrincipals: {}
                }
                jwtClaimChecks: {}
              }
            }
          }
          login: {
            allowedExternalRedirectUrls: [
              'string'
            ]
            cookieExpiration: {
              convention: 'FixedTime'
              timeToExpiration: '08:00:00'
            }
            nonce: {
              nonceExpirationInterval: '00:05:00'
              validateNonce: true
            }
            preserveUrlFragmentsForLogins: false
            routes: {}
            tokenStore: {
              azureBlobStorage: {}
              enabled: true
              fileSystem: {}
              tokenRefreshExtensionHours: 72
            }
          }
          platform: {
            enabled: true
            runtimeVersion: '~1'
          }
        }
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
    hybridConnectionRelays: [
      {
        hybridConnectionResourceId: '<hybridConnectionResourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    keyVaultAccessIdentityResourceId: '<keyVaultAccessIdentityResourceId>'
    location: '<location>'
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
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
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
    roleAssignments: [
      {
        name: '9efc9c10-f482-4af0-9acb-03b5a16f947e'
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
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "wsfamax001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "basicPublishingCredentialsPolicies": {
      "value": [
        {
          "allow": false,
          "name": "ftp"
        },
        {
          "allow": false,
          "name": "scm"
        }
      ]
    },
    "configs": {
      "value": [
        {
          "applicationInsightResourceId": "<applicationInsightResourceId>",
          "name": "appsettings",
          "properties": {
            "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
            "EASYAUTH_SECRET": "<EASYAUTH_SECRET>",
            "FUNCTIONS_EXTENSION_VERSION": "~4",
            "FUNCTIONS_WORKER_RUNTIME": "dotnet"
          },
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
        },
        {
          "name": "authsettingsV2",
          "properties": {
            "globalValidation": {
              "requireAuthentication": true,
              "unauthenticatedClientAction": "Return401"
            },
            "httpSettings": {
              "forwardProxy": {
                "convention": "NoProxy"
              },
              "requireHttps": true,
              "routes": {
                "apiPrefix": "/.auth"
              }
            },
            "identityProviders": {
              "azureActiveDirectory": {
                "enabled": true,
                "login": {
                  "disableWWWAuthenticate": false
                },
                "registration": {
                  "clientId": "d874dd2f-2032-4db1-a053-f0ec243685aa",
                  "clientSecretSettingName": "EASYAUTH_SECRET",
                  "openIdIssuer": "<openIdIssuer>"
                },
                "validation": {
                  "allowedAudiences": [
                    "api://d874dd2f-2032-4db1-a053-f0ec243685aa"
                  ],
                  "defaultAuthorizationPolicy": {
                    "allowedPrincipals": {}
                  },
                  "jwtClaimChecks": {}
                }
              }
            },
            "login": {
              "allowedExternalRedirectUrls": [
                "string"
              ],
              "cookieExpiration": {
                "convention": "FixedTime",
                "timeToExpiration": "08:00:00"
              },
              "nonce": {
                "nonceExpirationInterval": "00:05:00",
                "validateNonce": true
              },
              "preserveUrlFragmentsForLogins": false,
              "routes": {},
              "tokenStore": {
                "azureBlobStorage": {},
                "enabled": true,
                "fileSystem": {},
                "tokenRefreshExtensionHours": 72
              }
            },
            "platform": {
              "enabled": true,
              "runtimeVersion": "~1"
            }
          }
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
    "hybridConnectionRelays": {
      "value": [
        {
          "hybridConnectionResourceId": "<hybridConnectionResourceId>",
          "sendKeyName": "defaultSender"
        }
      ]
    },
    "keyVaultAccessIdentityResourceId": {
      "value": "<keyVaultAccessIdentityResourceId>"
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
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
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
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
    "roleAssignments": {
      "value": [
        {
          "name": "9efc9c10-f482-4af0-9acb-03b5a16f947e",
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
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "use32BitWorkerProcess": false
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
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'functionapp'
param name = 'wsfamax001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param basicPublishingCredentialsPolicies = [
  {
    allow: false
    name: 'ftp'
  }
  {
    allow: false
    name: 'scm'
  }
]
param configs = [
  {
    applicationInsightResourceId: '<applicationInsightResourceId>'
    name: 'appsettings'
    properties: {
      AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
      EASYAUTH_SECRET: '<EASYAUTH_SECRET>'
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    }
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
  }
  {
    name: 'authsettingsV2'
    properties: {
      globalValidation: {
        requireAuthentication: true
        unauthenticatedClientAction: 'Return401'
      }
      httpSettings: {
        forwardProxy: {
          convention: 'NoProxy'
        }
        requireHttps: true
        routes: {
          apiPrefix: '/.auth'
        }
      }
      identityProviders: {
        azureActiveDirectory: {
          enabled: true
          login: {
            disableWWWAuthenticate: false
          }
          registration: {
            clientId: 'd874dd2f-2032-4db1-a053-f0ec243685aa'
            clientSecretSettingName: 'EASYAUTH_SECRET'
            openIdIssuer: '<openIdIssuer>'
          }
          validation: {
            allowedAudiences: [
              'api://d874dd2f-2032-4db1-a053-f0ec243685aa'
            ]
            defaultAuthorizationPolicy: {
              allowedPrincipals: {}
            }
            jwtClaimChecks: {}
          }
        }
      }
      login: {
        allowedExternalRedirectUrls: [
          'string'
        ]
        cookieExpiration: {
          convention: 'FixedTime'
          timeToExpiration: '08:00:00'
        }
        nonce: {
          nonceExpirationInterval: '00:05:00'
          validateNonce: true
        }
        preserveUrlFragmentsForLogins: false
        routes: {}
        tokenStore: {
          azureBlobStorage: {}
          enabled: true
          fileSystem: {}
          tokenRefreshExtensionHours: 72
        }
      }
      platform: {
        enabled: true
        runtimeVersion: '~1'
      }
    }
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
param hybridConnectionRelays = [
  {
    hybridConnectionResourceId: '<hybridConnectionResourceId>'
    sendKeyName: 'defaultSender'
  }
]
param keyVaultAccessIdentityResourceId = '<keyVaultAccessIdentityResourceId>'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
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
param roleAssignments = [
  {
    name: '9efc9c10-f482-4af0-9acb-03b5a16f947e'
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
param siteConfig = {
  alwaysOn: true
  use32BitWorkerProcess: false
}
```

</details>
<p>

### Example 3: _Linux Container Web App, using only defaults_

This instance deploys the module as Linux Container Web App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app,linux,container'
    name: 'wslwamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      ftpsState: 'FtpsOnly'
      linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
      minTlsVersion: '1.2'
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
    "kind": {
      "value": "app,linux,container"
    },
    "name": {
      "value": "wslwamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "siteConfig": {
      "value": {
        "appSettings": [
          {
            "name": "WEBSITES_ENABLE_APP_SERVICE_STORAGE",
            "value": "false"
          }
        ],
        "ftpsState": "FtpsOnly",
        "linuxFxVersion": "DOCKER|mcr.microsoft.com/appsvc/staticsite:latest",
        "minTlsVersion": "1.2"
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
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app,linux,container'
param name = 'wslwamin001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param siteConfig = {
  appSettings: [
    {
      name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
      value: 'false'
    }
  ]
  ftpsState: 'FtpsOnly'
  linuxFxVersion: 'DOCKER|mcr.microsoft.com/appsvc/staticsite:latest'
  minTlsVersion: '1.2'
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswaf001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    basicPublishingCredentialsPolicies: [
      {
        allow: false
        name: 'ftp'
      }
      {
        allow: false
        name: 'scm'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    httpsOnly: true
    publicNetworkAccess: 'Disabled'
    scmSiteAlsoStopped: true
    siteConfig: {
      alwaysOn: true
      ftpsState: 'FtpsOnly'
      healthCheckPath: '/healthz'
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
      minTlsVersion: '1.2'
    }
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "wswaf001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "basicPublishingCredentialsPolicies": {
      "value": [
        {
          "allow": false,
          "name": "ftp"
        },
        {
          "allow": false,
          "name": "scm"
        }
      ]
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
    "httpsOnly": {
      "value": true
    },
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "scmSiteAlsoStopped": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "ftpsState": "FtpsOnly",
        "healthCheckPath": "/healthz",
        "metadata": [
          {
            "name": "CURRENT_STACK",
            "value": "dotnetcore"
          }
        ],
        "minTlsVersion": "1.2"
      }
    },
    "vnetContentShareEnabled": {
      "value": true
    },
    "vnetImagePullEnabled": {
      "value": true
    },
    "vnetRouteAllEnabled": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app'
param name = 'wswaf001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param basicPublishingCredentialsPolicies = [
  {
    allow: false
    name: 'ftp'
  }
  {
    allow: false
    name: 'scm'
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param httpsOnly = true
param publicNetworkAccess = 'Disabled'
param scmSiteAlsoStopped = true
param siteConfig = {
  alwaysOn: true
  ftpsState: 'FtpsOnly'
  healthCheckPath: '/healthz'
  metadata: [
    {
      name: 'CURRENT_STACK'
      value: 'dotnetcore'
    }
  ]
  minTlsVersion: '1.2'
}
param vnetContentShareEnabled = true
param vnetImagePullEnabled = true
param vnetRouteAllEnabled = true
```

</details>
<p>

### Example 5: _Web App, using only defaults_

This instance deploys the module as Web App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "wswamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app'
param name = 'wswamin001'
param serverFarmResourceId = '<serverFarmResourceId>'
```

</details>
<p>

### Example 6: _Web App, using large parameter set_

This instance deploys the module as Web App with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswamax001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    basicPublishingCredentialsPolicies: [
      {
        allow: false
        name: 'ftp'
      }
      {
        allow: false
        name: 'scm'
      }
    ]
    configs: [
      {
        name: 'appsettings'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
      {
        name: 'logs'
        properties: {
          applicationLogs: {
            fileSystem: {
              level: 'Verbose'
            }
          }
          detailedErrorMessages: {
            enabled: true
          }
          failedRequestsTracing: {
            enabled: true
          }
          httpLogs: {
            fileSystem: {
              enabled: true
              retentionInDays: 1
              retentionInMb: 35
            }
          }
        }
      }
      {
        name: 'web'
        properties: {
          apiManagementConfig: {
            id: '<id>'
          }
          ipSecurityRestrictions: [
            {
              action: 'Allow'
              description: 'Test IP Restriction'
              ipAddress: 'ApiManagement'
              name: 'Test Restriction'
              priority: 200
              tag: 'ServiceTag'
            }
          ]
        }
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
    dnsConfiguration: {
      dnsMaxCacheTimeout: 45
      dnsRetryAttemptCount: 3
      dnsRetryAttemptTimeout: 5
      dnsServers: [
        '168.63.129.16'
      ]
    }
    httpsOnly: true
    hybridConnectionRelays: [
      {
        hybridConnectionResourceId: '<hybridConnectionResourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    location: '<location>'
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
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
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
    publicNetworkAccess: 'Disabled'
    roleAssignments: [
      {
        name: '0c2c82ef-069c-4085-b1bc-01614e0aa5ff'
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
    scmSiteAlsoStopped: true
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
    slots: [
      {
        basicPublishingCredentialsPolicies: [
          {
            allow: false
            name: 'ftp'
          }
          {
            allow: false
            name: 'scm'
          }
        ]
        configs: [
          {
            name: 'appsettings'
            storageAccountResourceId: '<storageAccountResourceId>'
            storageAccountUseIdentityAuthentication: true
          }
        ]
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        dnsConfiguration: {
          dnsMaxCacheTimeout: 45
          dnsRetryAttemptCount: 3
          dnsRetryAttemptTimeout: 5
          dnsServers: [
            '168.63.129.20'
          ]
        }
        hybridConnectionRelays: [
          {
            hybridConnectionResourceId: '<hybridConnectionResourceId>'
            sendKeyName: 'defaultSender'
          }
        ]
        name: 'slot1'
        privateEndpoints: [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
                }
              ]
            }
            service: 'sites-slot1'
            subnetResourceId: '<subnetResourceId>'
            tags: {
              Environment: 'Non-Prod'
              'hidden-title': 'This is visible in the resource name'
              Role: 'DeploymentValidation'
            }
          }
        ]
        roleAssignments: [
          {
            name: '845ed19c-78e7-4422-aa3d-b78b67cd78a2'
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
        siteConfig: {
          alwaysOn: true
          metadata: [
            {
              name: 'CURRENT_STACK'
              value: 'dotnetcore'
            }
          ]
        }
      }
      {
        basicPublishingCredentialsPolicies: [
          {
            name: 'ftp'
          }
          {
            name: 'scm'
          }
        ]
        configs: [
          {
            name: 'appsettings'
            storageAccountResourceId: '<storageAccountResourceId>'
            storageAccountUseIdentityAuthentication: true
          }
        ]
        name: 'slot2'
      }
    ]
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "wswamax001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "basicPublishingCredentialsPolicies": {
      "value": [
        {
          "allow": false,
          "name": "ftp"
        },
        {
          "allow": false,
          "name": "scm"
        }
      ]
    },
    "configs": {
      "value": [
        {
          "name": "appsettings",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
        },
        {
          "name": "logs",
          "properties": {
            "applicationLogs": {
              "fileSystem": {
                "level": "Verbose"
              }
            },
            "detailedErrorMessages": {
              "enabled": true
            },
            "failedRequestsTracing": {
              "enabled": true
            },
            "httpLogs": {
              "fileSystem": {
                "enabled": true,
                "retentionInDays": 1,
                "retentionInMb": 35
              }
            }
          }
        },
        {
          "name": "web",
          "properties": {
            "apiManagementConfig": {
              "id": "<id>"
            },
            "ipSecurityRestrictions": [
              {
                "action": "Allow",
                "description": "Test IP Restriction",
                "ipAddress": "ApiManagement",
                "name": "Test Restriction",
                "priority": 200,
                "tag": "ServiceTag"
              }
            ]
          }
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
    "dnsConfiguration": {
      "value": {
        "dnsMaxCacheTimeout": 45,
        "dnsRetryAttemptCount": 3,
        "dnsRetryAttemptTimeout": 5,
        "dnsServers": [
          "168.63.129.16"
        ]
      }
    },
    "httpsOnly": {
      "value": true
    },
    "hybridConnectionRelays": {
      "value": [
        {
          "hybridConnectionResourceId": "<hybridConnectionResourceId>",
          "sendKeyName": "defaultSender"
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
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
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
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
    "publicNetworkAccess": {
      "value": "Disabled"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "0c2c82ef-069c-4085-b1bc-01614e0aa5ff",
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
    "scmSiteAlsoStopped": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "metadata": [
          {
            "name": "CURRENT_STACK",
            "value": "dotnetcore"
          }
        ]
      }
    },
    "slots": {
      "value": [
        {
          "basicPublishingCredentialsPolicies": [
            {
              "allow": false,
              "name": "ftp"
            },
            {
              "allow": false,
              "name": "scm"
            }
          ],
          "configs": [
            {
              "name": "appsettings",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "storageAccountUseIdentityAuthentication": true
            }
          ],
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "dnsConfiguration": {
            "dnsMaxCacheTimeout": 45,
            "dnsRetryAttemptCount": 3,
            "dnsRetryAttemptTimeout": 5,
            "dnsServers": [
              "168.63.129.20"
            ]
          },
          "hybridConnectionRelays": [
            {
              "hybridConnectionResourceId": "<hybridConnectionResourceId>",
              "sendKeyName": "defaultSender"
            }
          ],
          "name": "slot1",
          "privateEndpoints": [
            {
              "privateDnsZoneGroup": {
                "privateDnsZoneGroupConfigs": [
                  {
                    "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
                  }
                ]
              },
              "service": "sites-slot1",
              "subnetResourceId": "<subnetResourceId>",
              "tags": {
                "Environment": "Non-Prod",
                "hidden-title": "This is visible in the resource name",
                "Role": "DeploymentValidation"
              }
            }
          ],
          "roleAssignments": [
            {
              "name": "845ed19c-78e7-4422-aa3d-b78b67cd78a2",
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
          ],
          "siteConfig": {
            "alwaysOn": true,
            "metadata": [
              {
                "name": "CURRENT_STACK",
                "value": "dotnetcore"
              }
            ]
          }
        },
        {
          "basicPublishingCredentialsPolicies": [
            {
              "name": "ftp"
            },
            {
              "name": "scm"
            }
          ],
          "configs": [
            {
              "name": "appsettings",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "storageAccountUseIdentityAuthentication": true
            }
          ],
          "name": "slot2"
        }
      ]
    },
    "vnetContentShareEnabled": {
      "value": true
    },
    "vnetImagePullEnabled": {
      "value": true
    },
    "vnetRouteAllEnabled": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app'
param name = 'wswamax001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param basicPublishingCredentialsPolicies = [
  {
    allow: false
    name: 'ftp'
  }
  {
    allow: false
    name: 'scm'
  }
]
param configs = [
  {
    name: 'appsettings'
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
  }
  {
    name: 'logs'
    properties: {
      applicationLogs: {
        fileSystem: {
          level: 'Verbose'
        }
      }
      detailedErrorMessages: {
        enabled: true
      }
      failedRequestsTracing: {
        enabled: true
      }
      httpLogs: {
        fileSystem: {
          enabled: true
          retentionInDays: 1
          retentionInMb: 35
        }
      }
    }
  }
  {
    name: 'web'
    properties: {
      apiManagementConfig: {
        id: '<id>'
      }
      ipSecurityRestrictions: [
        {
          action: 'Allow'
          description: 'Test IP Restriction'
          ipAddress: 'ApiManagement'
          name: 'Test Restriction'
          priority: 200
          tag: 'ServiceTag'
        }
      ]
    }
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
param dnsConfiguration = {
  dnsMaxCacheTimeout: 45
  dnsRetryAttemptCount: 3
  dnsRetryAttemptTimeout: 5
  dnsServers: [
    '168.63.129.16'
  ]
}
param httpsOnly = true
param hybridConnectionRelays = [
  {
    hybridConnectionResourceId: '<hybridConnectionResourceId>'
    sendKeyName: 'defaultSender'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
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
param publicNetworkAccess = 'Disabled'
param roleAssignments = [
  {
    name: '0c2c82ef-069c-4085-b1bc-01614e0aa5ff'
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
param scmSiteAlsoStopped = true
param siteConfig = {
  alwaysOn: true
  metadata: [
    {
      name: 'CURRENT_STACK'
      value: 'dotnetcore'
    }
  ]
}
param slots = [
  {
    basicPublishingCredentialsPolicies: [
      {
        allow: false
        name: 'ftp'
      }
      {
        allow: false
        name: 'scm'
      }
    ]
    configs: [
      {
        name: 'appsettings'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    dnsConfiguration: {
      dnsMaxCacheTimeout: 45
      dnsRetryAttemptCount: 3
      dnsRetryAttemptTimeout: 5
      dnsServers: [
        '168.63.129.20'
      ]
    }
    hybridConnectionRelays: [
      {
        hybridConnectionResourceId: '<hybridConnectionResourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    name: 'slot1'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'sites-slot1'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        name: '845ed19c-78e7-4422-aa3d-b78b67cd78a2'
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
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
  }
  {
    basicPublishingCredentialsPolicies: [
      {
        name: 'ftp'
      }
      {
        name: 'scm'
      }
    ]
    configs: [
      {
        name: 'appsettings'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
    ]
    name: 'slot2'
  }
]
param vnetContentShareEnabled = true
param vnetImagePullEnabled = true
param vnetRouteAllEnabled = true
```

</details>
<p>

### Example 7: _Linux Web App, using only defaults_

This instance deploys the module as a Linux Web App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app,linux'
    name: 'wswalmin001'
    serverFarmResourceId: '<serverFarmResourceId>'
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
    "kind": {
      "value": "app,linux"
    },
    "name": {
      "value": "wswalmin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app,linux'
param name = 'wswalmin001'
param serverFarmResourceId = '<serverFarmResourceId>'
```

</details>
<p>

### Example 8: _Linux Web App, using large parameter set_

This instance deploys the module asa Linux Web App with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app,linux'
    name: 'wswalmax001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    basicPublishingCredentialsPolicies: [
      {
        allow: false
        name: 'ftp'
      }
      {
        allow: false
        name: 'scm'
      }
    ]
    configs: [
      {
        name: 'appsettings'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
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
    httpsOnly: true
    hybridConnectionRelays: [
      {
        hybridConnectionResourceId: '<hybridConnectionResourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    location: '<location>'
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
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
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
    publicNetworkAccess: 'Disabled'
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
    scmSiteAlsoStopped: true
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
    slots: [
      {
        basicPublishingCredentialsPolicies: [
          {
            allow: false
            name: 'ftp'
          }
          {
            allow: false
            name: 'scm'
          }
        ]
        configs: [
          {
            name: 'appsettings'
            storageAccountResourceId: '<storageAccountResourceId>'
            storageAccountUseIdentityAuthentication: true
          }
        ]
        diagnosticSettings: [
          {
            eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
            eventHubName: '<eventHubName>'
            name: 'customSetting'
            storageAccountResourceId: '<storageAccountResourceId>'
            workspaceResourceId: '<workspaceResourceId>'
          }
        ]
        hybridConnectionRelays: [
          {
            hybridConnectionResourceId: '<hybridConnectionResourceId>'
            sendKeyName: 'defaultSender'
          }
        ]
        name: 'slot1'
        privateEndpoints: [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
                }
              ]
            }
            service: 'sites-slot1'
            subnetResourceId: '<subnetResourceId>'
            tags: {
              Environment: 'Non-Prod'
              'hidden-title': 'This is visible in the resource name'
              Role: 'DeploymentValidation'
            }
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
        siteConfig: {
          alwaysOn: true
          metadata: [
            {
              name: 'CURRENT_STACK'
              value: 'dotnetcore'
            }
          ]
        }
      }
      {
        basicPublishingCredentialsPolicies: [
          {
            name: 'ftp'
          }
          {
            name: 'scm'
          }
        ]
        configs: [
          {
            name: 'appsettings'
            storageAccountResourceId: '<storageAccountResourceId>'
            storageAccountUseIdentityAuthentication: true
          }
        ]
        name: 'slot2'
      }
    ]
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
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
    "kind": {
      "value": "app,linux"
    },
    "name": {
      "value": "wswalmax001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "basicPublishingCredentialsPolicies": {
      "value": [
        {
          "allow": false,
          "name": "ftp"
        },
        {
          "allow": false,
          "name": "scm"
        }
      ]
    },
    "configs": {
      "value": [
        {
          "name": "appsettings",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
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
    "httpsOnly": {
      "value": true
    },
    "hybridConnectionRelays": {
      "value": [
        {
          "hybridConnectionResourceId": "<hybridConnectionResourceId>",
          "sendKeyName": "defaultSender"
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
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
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        },
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
    "publicNetworkAccess": {
      "value": "Disabled"
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
    "scmSiteAlsoStopped": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "metadata": [
          {
            "name": "CURRENT_STACK",
            "value": "dotnetcore"
          }
        ]
      }
    },
    "slots": {
      "value": [
        {
          "basicPublishingCredentialsPolicies": [
            {
              "allow": false,
              "name": "ftp"
            },
            {
              "allow": false,
              "name": "scm"
            }
          ],
          "configs": [
            {
              "name": "appsettings",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "storageAccountUseIdentityAuthentication": true
            }
          ],
          "diagnosticSettings": [
            {
              "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
              "eventHubName": "<eventHubName>",
              "name": "customSetting",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "workspaceResourceId": "<workspaceResourceId>"
            }
          ],
          "hybridConnectionRelays": [
            {
              "hybridConnectionResourceId": "<hybridConnectionResourceId>",
              "sendKeyName": "defaultSender"
            }
          ],
          "name": "slot1",
          "privateEndpoints": [
            {
              "privateDnsZoneGroup": {
                "privateDnsZoneGroupConfigs": [
                  {
                    "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
                  }
                ]
              },
              "service": "sites-slot1",
              "subnetResourceId": "<subnetResourceId>",
              "tags": {
                "Environment": "Non-Prod",
                "hidden-title": "This is visible in the resource name",
                "Role": "DeploymentValidation"
              }
            }
          ],
          "roleAssignments": [
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
          ],
          "siteConfig": {
            "alwaysOn": true,
            "metadata": [
              {
                "name": "CURRENT_STACK",
                "value": "dotnetcore"
              }
            ]
          }
        },
        {
          "basicPublishingCredentialsPolicies": [
            {
              "name": "ftp"
            },
            {
              "name": "scm"
            }
          ],
          "configs": [
            {
              "name": "appsettings",
              "storageAccountResourceId": "<storageAccountResourceId>",
              "storageAccountUseIdentityAuthentication": true
            }
          ],
          "name": "slot2"
        }
      ]
    },
    "vnetContentShareEnabled": {
      "value": true
    },
    "vnetImagePullEnabled": {
      "value": true
    },
    "vnetRouteAllEnabled": {
      "value": true
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app,linux'
param name = 'wswalmax001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param basicPublishingCredentialsPolicies = [
  {
    allow: false
    name: 'ftp'
  }
  {
    allow: false
    name: 'scm'
  }
]
param configs = [
  {
    name: 'appsettings'
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
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
param httpsOnly = true
param hybridConnectionRelays = [
  {
    hybridConnectionResourceId: '<hybridConnectionResourceId>'
    sendKeyName: 'defaultSender'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
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
param publicNetworkAccess = 'Disabled'
param roleAssignments = [
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
param scmSiteAlsoStopped = true
param siteConfig = {
  alwaysOn: true
  metadata: [
    {
      name: 'CURRENT_STACK'
      value: 'dotnetcore'
    }
  ]
}
param slots = [
  {
    basicPublishingCredentialsPolicies: [
      {
        allow: false
        name: 'ftp'
      }
      {
        allow: false
        name: 'scm'
      }
    ]
    configs: [
      {
        name: 'appsettings'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    hybridConnectionRelays: [
      {
        hybridConnectionResourceId: '<hybridConnectionResourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    name: 'slot1'
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        service: 'sites-slot1'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
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
    siteConfig: {
      alwaysOn: true
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnetcore'
        }
      ]
    }
  }
  {
    basicPublishingCredentialsPolicies: [
      {
        name: 'ftp'
      }
      {
        name: 'scm'
      }
    ]
    configs: [
      {
        name: 'appsettings'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
    ]
    name: 'slot2'
  }
]
param vnetContentShareEnabled = true
param vnetImagePullEnabled = true
param vnetRouteAllEnabled = true
```

</details>
<p>

### Example 9: _Windows Web App for Containers, using only defaults_

This instance deploys the module as a Windows based Container Web App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app,container,windows'
    name: 'wswcamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      windowsFxVersion: 'DOCKER|mcr.microsoft.com/azure-app-service/windows/parkingpage:latest'
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
    "kind": {
      "value": "app,container,windows"
    },
    "name": {
      "value": "wswcamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "siteConfig": {
      "value": {
        "appSettings": [
          {
            "name": "WEBSITES_ENABLE_APP_SERVICE_STORAGE",
            "value": "false"
          }
        ],
        "ftpsState": "FtpsOnly",
        "minTlsVersion": "1.2",
        "windowsFxVersion": "DOCKER|mcr.microsoft.com/azure-app-service/windows/parkingpage:latest"
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
using 'br/public:avm/res/web/site:<version>'

// Required parameters
param kind = 'app,container,windows'
param name = 'wswcamin001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param siteConfig = {
  appSettings: [
    {
      name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
      value: 'false'
    }
  ]
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  windowsFxVersion: 'DOCKER|mcr.microsoft.com/azure-app-service/windows/parkingpage:latest'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | Type of site to deploy. |
| [`name`](#parameter-name) | string | Name of the site. |
| [`serverFarmResourceId`](#parameter-serverfarmresourceid) | string | The resource ID of the app service plan to use for the site. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appServiceEnvironmentResourceId`](#parameter-appserviceenvironmentresourceid) | string | The resource ID of the app service environment to use for this resource. |
| [`autoGeneratedDomainNameLabelScope`](#parameter-autogenerateddomainnamelabelscope) | string | Specifies the scope of uniqueness for the default hostname during resource creation. |
| [`basicPublishingCredentialsPolicies`](#parameter-basicpublishingcredentialspolicies) | array | The site publishing credential policy names which are associated with the sites. |
| [`clientAffinityEnabled`](#parameter-clientaffinityenabled) | bool | If client affinity is enabled. |
| [`clientCertEnabled`](#parameter-clientcertenabled) | bool | To enable client certificate authentication (TLS mutual authentication). |
| [`clientCertExclusionPaths`](#parameter-clientcertexclusionpaths) | string | Client certificate authentication comma-separated exclusion paths. |
| [`clientCertMode`](#parameter-clientcertmode) | string | This composes with ClientCertEnabled setting.<li>ClientCertEnabled=false means ClientCert is ignored.<li>ClientCertEnabled=true and ClientCertMode=Required means ClientCert is required.<li>ClientCertEnabled=true and ClientCertMode=Optional means ClientCert is optional or accepted.<p> |
| [`cloningInfo`](#parameter-cloninginfo) | object | If specified during app creation, the app is cloned from a source app. |
| [`configs`](#parameter-configs) | array | The web site config. |
| [`containerSize`](#parameter-containersize) | int | Size of the function container. |
| [`dailyMemoryTimeQuota`](#parameter-dailymemorytimequota) | int | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsConfiguration`](#parameter-dnsconfiguration) | object | Property to configure various DNS related settings for a site. |
| [`e2eEncryptionEnabled`](#parameter-e2eencryptionenabled) | bool | End to End Encryption Setting. |
| [`enabled`](#parameter-enabled) | bool | Setting this value to false disables the app (takes the app offline). |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extensions`](#parameter-extensions) | array | The extensions configuration. |
| [`functionAppConfig`](#parameter-functionappconfig) | object | The Function App configuration object. |
| [`hostNameSslStates`](#parameter-hostnamesslstates) | array | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| [`httpsOnly`](#parameter-httpsonly) | bool | Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| [`hybridConnectionRelays`](#parameter-hybridconnectionrelays) | array | Names of hybrid connection relays to connect app with. |
| [`hyperV`](#parameter-hyperv) | bool | Hyper-V sandbox. |
| [`keyVaultAccessIdentityResourceId`](#parameter-keyvaultaccessidentityresourceid) | string | The resource ID of the assigned identity to be used to access a key vault with. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedEnvironmentId`](#parameter-managedenvironmentid) | string | Azure Resource Manager ID of the customers selected Managed Environment on which to host this app. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`redundancyMode`](#parameter-redundancymode) | string | Site redundancy mode. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scmSiteAlsoStopped`](#parameter-scmsitealsostopped) | bool | Stop SCM (KUDU) site when the app is stopped. |
| [`siteConfig`](#parameter-siteconfig) | object | The site config object. The defaults are set to the following values: alwaysOn: true, minTlsVersion: '1.2', ftpsState: 'FtpsOnly'. |
| [`slots`](#parameter-slots) | array | Configuration for deployment slots for an app. |
| [`storageAccountRequired`](#parameter-storageaccountrequired) | bool | Checks if Customer provided storage account is required. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkSubnetId`](#parameter-virtualnetworksubnetid) | string | Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}. |
| [`vnetContentShareEnabled`](#parameter-vnetcontentshareenabled) | bool | To enable accessing content over virtual network. |
| [`vnetImagePullEnabled`](#parameter-vnetimagepullenabled) | bool | To enable pulling image over Virtual Network. |
| [`vnetRouteAllEnabled`](#parameter-vnetrouteallenabled) | bool | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |

### Parameter: `kind`

Type of site to deploy.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'api'
    'app'
    'app,container,windows'
    'app,linux'
    'app,linux,container'
    'functionapp'
    'functionapp,linux'
    'functionapp,linux,container'
    'functionapp,linux,container,azurecontainerapps'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
    'linux,api'
  ]
  ```

### Parameter: `name`

Name of the site.

- Required: Yes
- Type: string

### Parameter: `serverFarmResourceId`

The resource ID of the app service plan to use for the site.

- Required: Yes
- Type: string

### Parameter: `appServiceEnvironmentResourceId`

The resource ID of the app service environment to use for this resource.

- Required: No
- Type: string

### Parameter: `autoGeneratedDomainNameLabelScope`

Specifies the scope of uniqueness for the default hostname during resource creation.

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

### Parameter: `basicPublishingCredentialsPolicies`

The site publishing credential policy names which are associated with the sites.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-basicpublishingcredentialspoliciesname) | string | The name of the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allow`](#parameter-basicpublishingcredentialspoliciesallow) | bool | Set to true to enable or false to disable a publishing method. |
| [`location`](#parameter-basicpublishingcredentialspolicieslocation) | string | Location for all Resources. |

### Parameter: `basicPublishingCredentialsPolicies.name`

The name of the resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ftp'
    'scm'
  ]
  ```

### Parameter: `basicPublishingCredentialsPolicies.allow`

Set to true to enable or false to disable a publishing method.

- Required: No
- Type: bool

### Parameter: `basicPublishingCredentialsPolicies.location`

Location for all Resources.

- Required: No
- Type: string

### Parameter: `clientAffinityEnabled`

If client affinity is enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `clientCertEnabled`

To enable client certificate authentication (TLS mutual authentication).

- Required: No
- Type: bool
- Default: `False`

### Parameter: `clientCertExclusionPaths`

Client certificate authentication comma-separated exclusion paths.

- Required: No
- Type: string

### Parameter: `clientCertMode`

This composes with ClientCertEnabled setting.<li>ClientCertEnabled=false means ClientCert is ignored.<li>ClientCertEnabled=true and ClientCertMode=Required means ClientCert is required.<li>ClientCertEnabled=true and ClientCertMode=Optional means ClientCert is optional or accepted.<p>

- Required: No
- Type: string
- Default: `'Optional'`
- Allowed:
  ```Bicep
  [
    'Optional'
    'OptionalInteractiveUser'
    'Required'
  ]
  ```

### Parameter: `cloningInfo`

If specified during app creation, the app is cloned from a source app.

- Required: No
- Type: object

### Parameter: `configs`

The web site config.

- Required: No
- Type: array
- Discriminator: `name`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`appsettings`](#variant-configsname-appsettings) | The type of an app settings configuration. |
| [`authsettings`](#variant-configsname-authsettings) | The type of an auth settings configuration. |
| [`authsettingsV2`](#variant-configsname-authsettingsv2) | The type of an authSettingsV2 configuration. |
| [`azurestorageaccounts`](#variant-configsname-azurestorageaccounts) | The type of an Azure Storage Account configuration. |
| [`backup`](#variant-configsname-backup) | The type for a backup configuration. |
| [`connectionstrings`](#variant-configsname-connectionstrings) | The type for a connection string configuration. |
| [`logs`](#variant-configsname-logs) | The type of a logs configuration. |
| [`metadata`](#variant-configsname-metadata) | The type of a metadata configuration. |
| [`pushsettings`](#variant-configsname-pushsettings) | The type of a pushSettings configuration. |
| [`slotConfigNames`](#variant-configsname-slotconfignames) | The type of a slotConfigNames configuration. |
| [`web`](#variant-configsname-web) | The type of a web configuration. |

### Variant: `configs.name-appsettings`
The type of an app settings configuration.

To use this variant, set the property `name` to `appsettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-appsettingsname) | string | The type of config. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightResourceId`](#parameter-configsname-appsettingsapplicationinsightresourceid) | string | Resource ID of the application insight to leverage for this resource. |
| [`properties`](#parameter-configsname-appsettingsproperties) | object | The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| [`retainCurrentAppSettings`](#parameter-configsname-appsettingsretaincurrentappsettings) | bool | The retain the current app settings. Defaults to true. |
| [`storageAccountResourceId`](#parameter-configsname-appsettingsstorageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| [`storageAccountUseIdentityAuthentication`](#parameter-configsname-appsettingsstorageaccountuseidentityauthentication) | bool | If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'. |

### Parameter: `configs.name-appsettings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'appsettings'
  ]
  ```

### Parameter: `configs.name-appsettings.applicationInsightResourceId`

Resource ID of the application insight to leverage for this resource.

- Required: No
- Type: string

### Parameter: `configs.name-appsettings.properties`

The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-appsettingsproperties>any_other_property<) | string | An app settings key-value pair. |

### Parameter: `configs.name-appsettings.properties.>Any_other_property<`

An app settings key-value pair.

- Required: Yes
- Type: string

### Parameter: `configs.name-appsettings.retainCurrentAppSettings`

The retain the current app settings. Defaults to true.

- Required: No
- Type: bool

### Parameter: `configs.name-appsettings.storageAccountResourceId`

Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.

- Required: No
- Type: string

### Parameter: `configs.name-appsettings.storageAccountUseIdentityAuthentication`

If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'.

- Required: No
- Type: bool

### Variant: `configs.name-authsettings`
The type of an auth settings configuration.

To use this variant, set the property `name` to `authsettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-authsettingsname) | string | The type of config. |
| [`properties`](#parameter-configsname-authsettingsproperties) | object | The config settings. |

### Parameter: `configs.name-authsettings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'authsettings'
  ]
  ```

### Parameter: `configs.name-authsettings.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadClaimsAuthorization`](#parameter-configsname-authsettingspropertiesaadclaimsauthorization) | string | Gets a JSON string containing the Azure AD Acl settings. |
| [`additionalLoginParams`](#parameter-configsname-authsettingspropertiesadditionalloginparams) | array | Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value". |
| [`allowedAudiences`](#parameter-configsname-authsettingspropertiesallowedaudiences) | array | Allowed audience values to consider when validating JSON Web Tokens issued by Azure Active Directory. Note that the `ClientID` value is always considered an allowed audience, regardless of this setting. |
| [`allowedExternalRedirectUrls`](#parameter-configsname-authsettingspropertiesallowedexternalredirecturls) | array | External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed. |
| [`authFilePath`](#parameter-configsname-authsettingspropertiesauthfilepath) | string | The path of the config file containing auth settings. If the path is relative, base will the site's root directory. |
| [`clientId`](#parameter-configsname-authsettingspropertiesclientid) | string | The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html). |
| [`clientSecret`](#parameter-configsname-authsettingspropertiesclientsecret) | securestring | The Client Secret of this relying party application (in Azure Active Directory, this is also referred to as the Key). This setting is optional. If no client secret is configured, the OpenID Connect implicit auth flow is used to authenticate end users. Otherwise, the OpenID Connect Authorization Code Flow is used to authenticate end users. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html). |
| [`clientSecretCertificateThumbprint`](#parameter-configsname-authsettingspropertiesclientsecretcertificatethumbprint) | string | An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret. |
| [`clientSecretSettingName`](#parameter-configsname-authsettingspropertiesclientsecretsettingname) | string | The app setting name that contains the client secret of the relying party application. |
| [`configVersion`](#parameter-configsname-authsettingspropertiesconfigversion) | string | The ConfigVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of the control plane for Authentication / Authorization. |
| [`defaultProvider`](#parameter-configsname-authsettingspropertiesdefaultprovider) | string | The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage". |
| [`enabled`](#parameter-configsname-authsettingspropertiesenabled) | bool | Set to `true` if the Authentication / Authorization feature is enabled for the current app. |
| [`facebookAppId`](#parameter-configsname-authsettingspropertiesfacebookappid) | string | The App ID of the Facebook app used for login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login). |
| [`facebookAppSecret`](#parameter-configsname-authsettingspropertiesfacebookappsecret) | securestring | The App Secret of the Facebook app used for Facebook Login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login). |
| [`facebookAppSecretSettingName`](#parameter-configsname-authsettingspropertiesfacebookappsecretsettingname) | string | The app setting name that contains the app secret used for Facebook Login. |
| [`facebookOAuthScopes`](#parameter-configsname-authsettingspropertiesfacebookoauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication. This setting is optional. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login). |
| [`gitHubClientId`](#parameter-configsname-authsettingspropertiesgithubclientid) | string | The Client Id of the GitHub app used for login. This setting is required for enabling Github login. |
| [`gitHubClientSecret`](#parameter-configsname-authsettingspropertiesgithubclientsecret) | securestring | The Client Secret of the GitHub app used for Github Login. This setting is required for enabling Github login. |
| [`gitHubClientSecretSettingName`](#parameter-configsname-authsettingspropertiesgithubclientsecretsettingname) | string | The app setting name that contains the client secret of the Github app used for GitHub Login. |
| [`gitHubOAuthScopes`](#parameter-configsname-authsettingspropertiesgithuboauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of GitHub Login authentication. |
| [`googleClientId`](#parameter-configsname-authsettingspropertiesgoogleclientid) | string | The OpenID Connect Client ID for the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web). |
| [`googleClientSecret`](#parameter-configsname-authsettingspropertiesgoogleclientsecret) | securestring | The client secret associated with the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web). |
| [`googleClientSecretSettingName`](#parameter-configsname-authsettingspropertiesgoogleclientsecretsettingname) | string | The app setting name that contains the client secret associated with the Google web application. |
| [`googleOAuthScopes`](#parameter-configsname-authsettingspropertiesgoogleoauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication. This setting is optional. If not specified, "openid", "profile", and "email" are used as default scopes. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web). |
| [`isAuthFromFile`](#parameter-configsname-authsettingspropertiesisauthfromfile) | string | "true" if the auth config settings should be read from a file, "false" otherwise. |
| [`issuer`](#parameter-configsname-authsettingspropertiesissuer) | string | The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html). |
| [`microsoftAccountClientId`](#parameter-configsname-authsettingspropertiesmicrosoftaccountclientid) | string | The OAuth 2.0 client ID that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm). |
| [`microsoftAccountClientSecret`](#parameter-configsname-authsettingspropertiesmicrosoftaccountclientsecret) | securestring | The OAuth 2.0 client secret that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm). |
| [`microsoftAccountClientSecretSettingName`](#parameter-configsname-authsettingspropertiesmicrosoftaccountclientsecretsettingname) | string | The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication. |
| [`microsoftAccountOAuthScopes`](#parameter-configsname-authsettingspropertiesmicrosoftaccountoauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. This setting is optional. If not specified, "wl.basic" is used as the default scope. Microsoft Account Scopes and permissions [documentation](https://msdn.microsoft.com/en-us/library/dn631845.aspx). |
| [`runtimeVersion`](#parameter-configsname-authsettingspropertiesruntimeversion) | string | The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module. |
| [`tokenRefreshExtensionHours`](#parameter-configsname-authsettingspropertiestokenrefreshextensionhours) | int | The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours. |
| [`tokenStoreEnabled`](#parameter-configsname-authsettingspropertiestokenstoreenabled) | bool | Set to `true` to durably store platform-specific security tokens that are obtained during login flows. The default is `false`. |
| [`twitterConsumerKey`](#parameter-configsname-authsettingspropertiestwitterconsumerkey) | securestring | The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in). |
| [`twitterConsumerSecret`](#parameter-configsname-authsettingspropertiestwitterconsumersecret) | securestring | The OAuth 1.0a consumer secret of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in). |
| [`twitterConsumerSecretSettingName`](#parameter-configsname-authsettingspropertiestwitterconsumersecretsettingname) | string | The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in. |
| [`unauthenticatedClientAction`](#parameter-configsname-authsettingspropertiesunauthenticatedclientaction) | string | The action to take when an unauthenticated client attempts to access the app. |
| [`validateIssuer`](#parameter-configsname-authsettingspropertiesvalidateissuer) | bool | Gets a value indicating whether the issuer should be a valid HTTPS url and be validated as such. |

### Parameter: `configs.name-authsettings.properties.aadClaimsAuthorization`

Gets a JSON string containing the Azure AD Acl settings.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.additionalLoginParams`

Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.allowedAudiences`

Allowed audience values to consider when validating JSON Web Tokens issued by Azure Active Directory. Note that the `ClientID` value is always considered an allowed audience, regardless of this setting.

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.allowedExternalRedirectUrls`

External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed.

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.authFilePath`

The path of the config file containing auth settings. If the path is relative, base will the site's root directory.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.clientId`

The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.clientSecret`

The Client Secret of this relying party application (in Azure Active Directory, this is also referred to as the Key). This setting is optional. If no client secret is configured, the OpenID Connect implicit auth flow is used to authenticate end users. Otherwise, the OpenID Connect Authorization Code Flow is used to authenticate end users. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.clientSecretCertificateThumbprint`

An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.clientSecretSettingName`

The app setting name that contains the client secret of the relying party application.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.configVersion`

The ConfigVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of the control plane for Authentication / Authorization.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.defaultProvider`

The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureActiveDirectory'
    'Facebook'
    'Github'
    'Google'
    'MicrosoftAccount'
    'Twitter'
  ]
  ```

### Parameter: `configs.name-authsettings.properties.enabled`

Set to `true` if the Authentication / Authorization feature is enabled for the current app.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettings.properties.facebookAppId`

The App ID of the Facebook app used for login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.facebookAppSecret`

The App Secret of the Facebook app used for Facebook Login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.facebookAppSecretSettingName`

The app setting name that contains the app secret used for Facebook Login.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.facebookOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication. This setting is optional. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.gitHubClientId`

The Client Id of the GitHub app used for login. This setting is required for enabling Github login.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.gitHubClientSecret`

The Client Secret of the GitHub app used for Github Login. This setting is required for enabling Github login.

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.gitHubClientSecretSettingName`

The app setting name that contains the client secret of the Github app used for GitHub Login.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.gitHubOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of GitHub Login authentication.

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.googleClientId`

The OpenID Connect Client ID for the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.googleClientSecret`

The client secret associated with the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.googleClientSecretSettingName`

The app setting name that contains the client secret associated with the Google web application.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.googleOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication. This setting is optional. If not specified, "openid", "profile", and "email" are used as default scopes. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.isAuthFromFile`

"true" if the auth config settings should be read from a file, "false" otherwise.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `configs.name-authsettings.properties.issuer`

The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html).

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.microsoftAccountClientId`

The OAuth 2.0 client ID that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm).

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.microsoftAccountClientSecret`

The OAuth 2.0 client secret that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.microsoftAccountClientSecretSettingName`

The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.microsoftAccountOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. This setting is optional. If not specified, "wl.basic" is used as the default scope. Microsoft Account Scopes and permissions [documentation](https://msdn.microsoft.com/en-us/library/dn631845.aspx).

- Required: No
- Type: array

### Parameter: `configs.name-authsettings.properties.runtimeVersion`

The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.tokenRefreshExtensionHours`

The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours.

- Required: No
- Type: int

### Parameter: `configs.name-authsettings.properties.tokenStoreEnabled`

Set to `true` to durably store platform-specific security tokens that are obtained during login flows. The default is `false`.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettings.properties.twitterConsumerKey`

The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.twitterConsumerSecret`

The OAuth 1.0a consumer secret of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettings.properties.twitterConsumerSecretSettingName`

The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.

- Required: No
- Type: string

### Parameter: `configs.name-authsettings.properties.unauthenticatedClientAction`

The action to take when an unauthenticated client attempts to access the app.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowAnonymous'
    'RedirectToLoginPage'
  ]
  ```

### Parameter: `configs.name-authsettings.properties.validateIssuer`

Gets a value indicating whether the issuer should be a valid HTTPS url and be validated as such.

- Required: No
- Type: bool

### Variant: `configs.name-authsettingsV2`
The type of an authSettingsV2 configuration.

To use this variant, set the property `name` to `authsettingsV2`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-authsettingsv2name) | string | The type of config. |
| [`properties`](#parameter-configsname-authsettingsv2properties) | object | The config settings. |

### Parameter: `configs.name-authsettingsV2.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'authsettingsV2'
  ]
  ```

### Parameter: `configs.name-authsettingsV2.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`globalValidation`](#parameter-configsname-authsettingsv2propertiesglobalvalidation) | object | The configuration settings that determines the validation flow of users using App Service Authentication/Authorization. |
| [`httpSettings`](#parameter-configsname-authsettingsv2propertieshttpsettings) | object | The configuration settings of the HTTP requests for authentication and authorization requests made against App Service Authentication/Authorization. |
| [`identityProviders`](#parameter-configsname-authsettingsv2propertiesidentityproviders) | object | The configuration settings of each of the identity providers used to configure App Service Authentication/Authorization. |
| [`login`](#parameter-configsname-authsettingsv2propertieslogin) | object | The configuration settings of the login flow of users using App Service Authentication/Authorization. |
| [`platform`](#parameter-configsname-authsettingsv2propertiesplatform) | object | The configuration settings of the platform of App Service Authentication/Authorization. |

### Parameter: `configs.name-authsettingsV2.properties.globalValidation`

The configuration settings that determines the validation flow of users using App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`excludedPaths`](#parameter-configsname-authsettingsv2propertiesglobalvalidationexcludedpaths) | array | The paths for which unauthenticated flow would not be redirected to the login page. |
| [`redirectToProvider`](#parameter-configsname-authsettingsv2propertiesglobalvalidationredirecttoprovider) | string | The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage". |
| [`requireAuthentication`](#parameter-configsname-authsettingsv2propertiesglobalvalidationrequireauthentication) | bool | Set to `true` if the authentication flow is required by every request. |
| [`unauthenticatedClientAction`](#parameter-configsname-authsettingsv2propertiesglobalvalidationunauthenticatedclientaction) | string | The action to take when an unauthenticated client attempts to access the app. |

### Parameter: `configs.name-authsettingsV2.properties.globalValidation.excludedPaths`

The paths for which unauthenticated flow would not be redirected to the login page.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.globalValidation.redirectToProvider`

The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage".

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.globalValidation.requireAuthentication`

Set to `true` if the authentication flow is required by every request.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.globalValidation.unauthenticatedClientAction`

The action to take when an unauthenticated client attempts to access the app.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowAnonymous'
    'RedirectToLoginPage'
    'Return401'
    'Return403'
  ]
  ```

### Parameter: `configs.name-authsettingsV2.properties.httpSettings`

The configuration settings of the HTTP requests for authentication and authorization requests made against App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`forwardProxy`](#parameter-configsname-authsettingsv2propertieshttpsettingsforwardproxy) | object | The configuration settings of a forward proxy used to make the requests. |
| [`requireHttps`](#parameter-configsname-authsettingsv2propertieshttpsettingsrequirehttps) | bool | Set to `false` if the authentication/authorization responses not having the HTTPS scheme are permissible. |
| [`routes`](#parameter-configsname-authsettingsv2propertieshttpsettingsroutes) | object | The configuration settings of the paths HTTP requests. |

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.forwardProxy`

The configuration settings of a forward proxy used to make the requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`convention`](#parameter-configsname-authsettingsv2propertieshttpsettingsforwardproxyconvention) | string | The convention used to determine the url of the request made. |
| [`customHostHeaderName`](#parameter-configsname-authsettingsv2propertieshttpsettingsforwardproxycustomhostheadername) | string | The name of the header containing the host of the request. |
| [`customProtoHeaderName`](#parameter-configsname-authsettingsv2propertieshttpsettingsforwardproxycustomprotoheadername) | string | The name of the header containing the scheme of the request. |

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.forwardProxy.convention`

The convention used to determine the url of the request made.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom'
    'NoProxy'
    'Standard'
  ]
  ```

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.forwardProxy.customHostHeaderName`

The name of the header containing the host of the request.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.forwardProxy.customProtoHeaderName`

The name of the header containing the scheme of the request.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.requireHttps`

Set to `false` if the authentication/authorization responses not having the HTTPS scheme are permissible.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.routes`

The configuration settings of the paths HTTP requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiPrefix`](#parameter-configsname-authsettingsv2propertieshttpsettingsroutesapiprefix) | string | The prefix that should precede all the authentication/authorization paths. |

### Parameter: `configs.name-authsettingsV2.properties.httpSettings.routes.apiPrefix`

The prefix that should precede all the authentication/authorization paths.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders`

The configuration settings of each of the identity providers used to configure App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apple`](#parameter-configsname-authsettingsv2propertiesidentityprovidersapple) | object | The configuration settings of the Apple provider. |
| [`azureActiveDirectory`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectory) | object | The configuration settings of the Azure Active directory provider. |
| [`azureStaticWebApps`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazurestaticwebapps) | object | The configuration settings of the Azure Static Web Apps provider. |
| [`customOpenIdConnectProviders`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders) | object | The map of the name of the alias of each custom Open ID Connect provider to the configuration settings of the custom Open ID Connect provider. |
| [`facebook`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebook) | object | The configuration settings of the Facebook provider. |
| [`gitHub`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithub) | object | The configuration settings of the GitHub provider. |
| [`google`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgoogle) | object | The configuration settings of the Google provider. |
| [`legacyMicrosoftAccount`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccount) | object | The configuration settings of the legacy Microsoft Account provider. |
| [`twitter`](#parameter-configsname-authsettingsv2propertiesidentityproviderstwitter) | object | The configuration settings of the Twitter provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple`

The configuration settings of the Apple provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityprovidersappleenabled) | bool | Set to `false` if the Apple provider should not be enabled despite the set registration. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityprovidersapplelogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityprovidersappleregistration) | object | The configuration settings of the Apple registration. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple.enabled`

Set to `false` if the Apple provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-configsname-authsettingsv2propertiesidentityprovidersappleloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple.registration`

The configuration settings of the Apple registration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityprovidersappleregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityprovidersappleregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.apple.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory`

The configuration settings of the Azure Active directory provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryenabled) | bool | Set to `false` if the Azure Active Directory provider should not be enabled despite the set registration. |
| [`isAutoProvisioned`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryisautoprovisioned) | bool | Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling. This is an internal flag primarily intended to support the Azure Management Portal. Users should not read or write to this property. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectorylogin) | object | The configuration settings of the Azure Active Directory login flow. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistration) | object | The configuration settings of the Azure Active Directory app registration. |
| [`validation`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidation) | object | The configuration settings of the Azure Active Directory token validation flow. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.enabled`

Set to `false` if the Azure Active Directory provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.isAutoProvisioned`

Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling. This is an internal flag primarily intended to support the Azure Management Portal. Users should not read or write to this property.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.login`

The configuration settings of the Azure Active Directory login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disableWWWAuthenticate`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectorylogindisablewwwauthenticate) | bool | Set to `true` if the www-authenticate provider should be omitted from the request. |
| [`loginParameters`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryloginloginparameters) | array | Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value". |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.login.disableWWWAuthenticate`

Set to `true` if the www-authenticate provider should be omitted from the request.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.login.loginParameters`

Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration`

The configuration settings of the Azure Active Directory app registration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientid) | string | The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientSecretCertificateIssuer`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretcertificateissuer) | string | An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint. |
| [`clientSecretCertificateSubjectAlternativeName`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretcertificatesubjectalternativename) | string | An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint. |
| [`clientSecretCertificateThumbprint`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretcertificatethumbprint) | string | An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret. |
| [`clientSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretsettingname) | string | The app setting name that contains the client secret of the relying party application. |
| [`openIdIssuer`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationopenidissuer) | string | The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html). |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientId`

The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretCertificateIssuer`

An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretCertificateSubjectAlternativeName`

An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretCertificateThumbprint`

An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretSettingName`

The app setting name that contains the client secret of the relying party application.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.openIdIssuer`

The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html).

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation`

The configuration settings of the Azure Active Directory token validation flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAudiences`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationallowedaudiences) | array | The list of audiences that can make successful authentication/authorization requests. |
| [`defaultAuthorizationPolicy`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicy) | object | The configuration settings of the default authorization policy. |
| [`jwtClaimChecks`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationjwtclaimchecks) | object | The configuration settings of the checks that should be made while validating the JWT Claims. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.allowedAudiences`

The list of audiences that can make successful authentication/authorization requests.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy`

The configuration settings of the default authorization policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedApplications`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedapplications) | array | The configuration settings of the Azure Active Directory allowed applications. |
| [`allowedPrincipals`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedprincipals) | object | The configuration settings of the Azure Active Directory allowed principals. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedApplications`

The configuration settings of the Azure Active Directory allowed applications.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedPrincipals`

The configuration settings of the Azure Active Directory allowed principals.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groups`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedprincipalsgroups) | array | The list of the allowed groups. |
| [`identities`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedprincipalsidentities) | array | The list of the allowed identities. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedPrincipals.groups`

The list of the allowed groups.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedPrincipals.identities`

The list of the allowed identities.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.jwtClaimChecks`

The configuration settings of the checks that should be made while validating the JWT Claims.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedClientApplications`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationjwtclaimchecksallowedclientapplications) | array | The list of the allowed client applications. |
| [`allowedGroups`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationjwtclaimchecksallowedgroups) | array | The list of the allowed groups. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.jwtClaimChecks.allowedClientApplications`

The list of the allowed client applications.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.jwtClaimChecks.allowedGroups`

The list of the allowed groups.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps`

The configuration settings of the Azure Static Web Apps provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazurestaticwebappsenabled) | bool | Set to `false` if the Azure Static Web Apps provider should not be enabled despite the set registration. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazurestaticwebappsregistration) | object | The configuration settings of the Azure Static Web Apps registration. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps.enabled`

Set to `false` if the Azure Static Web Apps provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps.registration`

The configuration settings of the Azure Static Web Apps registration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityprovidersazurestaticwebappsregistrationclientid) | string | The Client ID of the app used for login. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders`

The map of the name of the alias of each custom Open ID Connect provider to the configuration settings of the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<) | object | The alias of each custom Open ID Connect provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<`

The alias of each custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<enabled) | bool | Set to `false` if the custom Open ID provider provider should not be enabled. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<login) | object | The configuration settings of the login flow of the custom Open ID Connect provider. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registration) | object | The configuration settings of the app registration for the custom Open ID Connect provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.enabled`

Set to `false` if the custom Open ID provider provider should not be enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.login`

The configuration settings of the login flow of the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nameClaimType`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<loginnameclaimtype) | string | The name of the claim that contains the users name. |
| [`scopes`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<loginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.login.nameClaimType`

The name of the claim that contains the users name.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration`

The configuration settings of the app registration for the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientCredential`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientcredential) | object | The authentication credentials of the custom Open ID Connect provider. |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientid) | string | The client id of the custom Open ID Connect provider. |
| [`openIdConnectConfiguration`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfiguration) | object | The configuration settings of the endpoints used for the custom Open ID Connect provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientCredential`

The authentication credentials of the custom Open ID Connect provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientcredentialclientsecretsettingname) | string | The app setting that contains the client secret for the custom Open ID Connect provider. |
| [`method`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientcredentialmethod) | string | The method that should be used to authenticate the user. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientCredential.clientSecretSettingName`

The app setting that contains the client secret for the custom Open ID Connect provider.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientCredential.method`

The method that should be used to authenticate the user.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ClientSecretPost'
  ]
  ```

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientId`

The client id of the custom Open ID Connect provider.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration`

The configuration settings of the endpoints used for the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationEndpoint`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationauthorizationendpoint) | string | The endpoint to be used to make an authorization request. |
| [`certificationUri`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationcertificationuri) | string | The endpoint that provides the keys necessary to validate the token. |
| [`issuer`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationissuer) | string | The endpoint that issues the token. |
| [`tokenEndpoint`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationtokenendpoint) | string | The endpoint to be used to request a token. |
| [`wellKnownOpenIdConfiguration`](#parameter-configsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationwellknownopenidconfiguration) | string | The endpoint that contains all the configuration endpoints for the provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.authorizationEndpoint`

The endpoint to be used to make an authorization request.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.certificationUri`

The endpoint that provides the keys necessary to validate the token.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.issuer`

The endpoint that issues the token.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.tokenEndpoint`

The endpoint to be used to request a token.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.wellKnownOpenIdConfiguration`

The endpoint that contains all the configuration endpoints for the provider.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook`

The configuration settings of the Facebook provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebookenabled) | bool | Set to `false` if the Facebook provider should not be enabled despite the set registration. |
| [`graphApiVersion`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebookgraphapiversion) | string | The version of the Facebook api to be used while logging in. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebooklogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebookregistration) | object | The configuration settings of the app registration for the Facebook provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.enabled`

Set to `false` if the Facebook provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.graphApiVersion`

The version of the Facebook api to be used while logging in.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebookloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.registration`

The configuration settings of the app registration for the Facebook provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appId`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebookregistrationappid) | string | The App ID of the app used for login. |
| [`appSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityprovidersfacebookregistrationappsecretsettingname) | string | The app setting name that contains the app secret. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.registration.appId`

The App ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.facebook.registration.appSecretSettingName`

The app setting name that contains the app secret.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub`

The configuration settings of the GitHub provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithubenabled) | bool | Set to `false` if the GitHub provider should not be enabled despite the set registration. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithublogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithubregistration) | object | The configuration settings of the app registration for the GitHub provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub.enabled`

Set to `false` if the GitHub provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithubloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub.registration`

The configuration settings of the app registration for the GitHub provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithubregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgithubregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.gitHub.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google`

The configuration settings of the Google provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgoogleenabled) | bool | Set to `false` if the Google provider should not be enabled despite the set registration. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgooglelogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgoogleregistration) | object | The configuration settings of the app registration for the Google provider. |
| [`validation`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgooglevalidation) | object | The configuration settings of the Azure Active Directory token validation flow. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.enabled`

Set to `false` if the Google provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgoogleloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.registration`

The configuration settings of the app registration for the Google provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgoogleregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgoogleregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.validation`

The configuration settings of the Azure Active Directory token validation flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAudiences`](#parameter-configsname-authsettingsv2propertiesidentityprovidersgooglevalidationallowedaudiences) | array | The configuration settings of the allowed list of audiences from which to validate the JWT token. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.google.validation.allowedAudiences`

The configuration settings of the allowed list of audiences from which to validate the JWT token.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount`

The configuration settings of the legacy Microsoft Account provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountenabled) | bool | Set to `false` if the legacy Microsoft Account provider should not be enabled despite the set registration. |
| [`login`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountlogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountregistration) | object | The configuration settings of the app registration for the legacy Microsoft Account provider. |
| [`validation`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountvalidation) | object | The configuration settings of the legacy Microsoft Account provider token validation flow. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.enabled`

Set to `false` if the legacy Microsoft Account provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.registration`

The configuration settings of the app registration for the legacy Microsoft Account provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.validation`

The configuration settings of the legacy Microsoft Account provider token validation flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAudiences`](#parameter-configsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountvalidationallowedaudiences) | array | The configuration settings of the allowed list of audiences from which to validate the JWT token. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.validation.allowedAudiences`

The configuration settings of the allowed list of audiences from which to validate the JWT token.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.twitter`

The configuration settings of the Twitter provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesidentityproviderstwitterenabled) | bool | Set to `false` if the Twitter provider should not be enabled despite the set registration. |
| [`registration`](#parameter-configsname-authsettingsv2propertiesidentityproviderstwitterregistration) | object | The configuration settings of the app registration for the Twitter provider. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.twitter.enabled`

Set to `false` if the Twitter provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.twitter.registration`

The configuration settings of the app registration for the Twitter provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consumerKey`](#parameter-configsname-authsettingsv2propertiesidentityproviderstwitterregistrationconsumerkey) | securestring | The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in). |
| [`consumerSecretSettingName`](#parameter-configsname-authsettingsv2propertiesidentityproviderstwitterregistrationconsumersecretsettingname) | string | The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in. |

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.twitter.registration.consumerKey`

The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).

- Required: No
- Type: securestring

### Parameter: `configs.name-authsettingsV2.properties.identityProviders.twitter.registration.consumerSecretSettingName`

The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.login`

The configuration settings of the login flow of users using App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedExternalRedirectUrls`](#parameter-configsname-authsettingsv2propertiesloginallowedexternalredirecturls) | array | External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed. |
| [`cookieExpiration`](#parameter-configsname-authsettingsv2propertieslogincookieexpiration) | object | The configuration settings of the session cookie's expiration. |
| [`nonce`](#parameter-configsname-authsettingsv2propertiesloginnonce) | object | The configuration settings of the nonce used in the login flow. |
| [`preserveUrlFragmentsForLogins`](#parameter-configsname-authsettingsv2propertiesloginpreserveurlfragmentsforlogins) | bool | Set to `true` if the fragments from the request are preserved after the login request is made. |
| [`routes`](#parameter-configsname-authsettingsv2propertiesloginroutes) | object | The routes that specify the endpoints used for login and logout requests. |
| [`tokenStore`](#parameter-configsname-authsettingsv2propertieslogintokenstore) | object | The configuration settings of the token store. |

### Parameter: `configs.name-authsettingsV2.properties.login.allowedExternalRedirectUrls`

External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed.

- Required: No
- Type: array

### Parameter: `configs.name-authsettingsV2.properties.login.cookieExpiration`

The configuration settings of the session cookie's expiration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`convention`](#parameter-configsname-authsettingsv2propertieslogincookieexpirationconvention) | string | The convention used when determining the session cookie's expiration. |
| [`timeToExpiration`](#parameter-configsname-authsettingsv2propertieslogincookieexpirationtimetoexpiration) | string | The time after the request is made when the session cookie should expire. |

### Parameter: `configs.name-authsettingsV2.properties.login.cookieExpiration.convention`

The convention used when determining the session cookie's expiration.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'FixedTime'
    'IdentityProviderDerived'
  ]
  ```

### Parameter: `configs.name-authsettingsV2.properties.login.cookieExpiration.timeToExpiration`

The time after the request is made when the session cookie should expire.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.login.nonce`

The configuration settings of the nonce used in the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nonceExpirationInterval`](#parameter-configsname-authsettingsv2propertiesloginnoncenonceexpirationinterval) | string | The time after the request is made when the nonce should expire. |
| [`validateNonce`](#parameter-configsname-authsettingsv2propertiesloginnoncevalidatenonce) | bool | Set to `false` if the nonce should not be validated while completing the login flow. |

### Parameter: `configs.name-authsettingsV2.properties.login.nonce.nonceExpirationInterval`

The time after the request is made when the nonce should expire.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.login.nonce.validateNonce`

Set to `false` if the nonce should not be validated while completing the login flow.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.login.preserveUrlFragmentsForLogins`

Set to `true` if the fragments from the request are preserved after the login request is made.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.login.routes`

The routes that specify the endpoints used for login and logout requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logoutEndpoint`](#parameter-configsname-authsettingsv2propertiesloginrouteslogoutendpoint) | string | The endpoint at which a logout request should be made. |

### Parameter: `configs.name-authsettingsV2.properties.login.routes.logoutEndpoint`

The endpoint at which a logout request should be made.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore`

The configuration settings of the token store.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureBlobStorage`](#parameter-configsname-authsettingsv2propertieslogintokenstoreazureblobstorage) | object | The configuration settings of the storage of the tokens if blob storage is used. |
| [`enabled`](#parameter-configsname-authsettingsv2propertieslogintokenstoreenabled) | bool | Set to `true` to durably store platform-specific security tokens that are obtained during login flows. |
| [`fileSystem`](#parameter-configsname-authsettingsv2propertieslogintokenstorefilesystem) | object | The configuration settings of the storage of the tokens if a file system is used. |
| [`tokenRefreshExtensionHours`](#parameter-configsname-authsettingsv2propertieslogintokenstoretokenrefreshextensionhours) | int | The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours. |

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore.azureBlobStorage`

The configuration settings of the storage of the tokens if blob storage is used.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sasUrlSettingName`](#parameter-configsname-authsettingsv2propertieslogintokenstoreazureblobstoragesasurlsettingname) | string | The name of the app setting containing the SAS URL of the blob storage containing the tokens. |

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore.azureBlobStorage.sasUrlSettingName`

The name of the app setting containing the SAS URL of the blob storage containing the tokens.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore.enabled`

Set to `true` to durably store platform-specific security tokens that are obtained during login flows.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore.fileSystem`

The configuration settings of the storage of the tokens if a file system is used.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`directory`](#parameter-configsname-authsettingsv2propertieslogintokenstorefilesystemdirectory) | string | The directory in which the tokens will be stored. |

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore.fileSystem.directory`

The directory in which the tokens will be stored.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.login.tokenStore.tokenRefreshExtensionHours`

The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours.

- Required: No
- Type: int

### Parameter: `configs.name-authsettingsV2.properties.platform`

The configuration settings of the platform of App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configFilePath`](#parameter-configsname-authsettingsv2propertiesplatformconfigfilepath) | string | The path of the config file containing auth settings if they come from a file. If the path is relative, base will the site's root directory. |
| [`enabled`](#parameter-configsname-authsettingsv2propertiesplatformenabled) | bool | Set to `true` if the Authentication / Authorization feature is enabled for the current app. |
| [`runtimeVersion`](#parameter-configsname-authsettingsv2propertiesplatformruntimeversion) | string | The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module. |

### Parameter: `configs.name-authsettingsV2.properties.platform.configFilePath`

The path of the config file containing auth settings if they come from a file. If the path is relative, base will the site's root directory.

- Required: No
- Type: string

### Parameter: `configs.name-authsettingsV2.properties.platform.enabled`

Set to `true` if the Authentication / Authorization feature is enabled for the current app.

- Required: No
- Type: bool

### Parameter: `configs.name-authsettingsV2.properties.platform.runtimeVersion`

The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module.

- Required: No
- Type: string

### Variant: `configs.name-azurestorageaccounts`
The type of an Azure Storage Account configuration.

To use this variant, set the property `name` to `azurestorageaccounts`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-azurestorageaccountsname) | string | The type of config. |
| [`properties`](#parameter-configsname-azurestorageaccountsproperties) | object | The config settings. |

### Parameter: `configs.name-azurestorageaccounts.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'azurestorageaccounts'
  ]
  ```

### Parameter: `configs.name-azurestorageaccounts.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<) | object | The Azure Storage Info configuration. |

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<`

The Azure Storage Info configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKey`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<accesskey) | securestring | Access key for the storage account. |
| [`accountName`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<accountname) | string | Name of the storage account. |
| [`mountPath`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<mountpath) | string | Path to mount the storage within the site's runtime environment. |
| [`protocol`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<protocol) | string | Mounting protocol to use for the storage account. |
| [`shareName`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<sharename) | string | Name of the file share (container name, for Blob storage). |
| [`type`](#parameter-configsname-azurestorageaccountsproperties>any_other_property<type) | string | Type of storage. |

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<.accessKey`

Access key for the storage account.

- Required: No
- Type: securestring

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<.accountName`

Name of the storage account.

- Required: No
- Type: string

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<.mountPath`

Path to mount the storage within the site's runtime environment.

- Required: No
- Type: string

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<.protocol`

Mounting protocol to use for the storage account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Nfs'
    'Smb'
  ]
  ```

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<.shareName`

Name of the file share (container name, for Blob storage).

- Required: No
- Type: string

### Parameter: `configs.name-azurestorageaccounts.properties.>Any_other_property<.type`

Type of storage.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureBlob'
    'AzureFiles'
  ]
  ```

### Variant: `configs.name-backup`
The type for a backup configuration.

To use this variant, set the property `name` to `backup`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-backupname) | string | The type of config. |
| [`properties`](#parameter-configsname-backupproperties) | object | The config settings. |

### Parameter: `configs.name-backup.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'backup'
  ]
  ```

### Parameter: `configs.name-backup.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupName`](#parameter-configsname-backuppropertiesbackupname) | string | Name of the backup. |
| [`backupSchedule`](#parameter-configsname-backuppropertiesbackupschedule) | object | Schedule for the backup if it is executed periodically. |
| [`databases`](#parameter-configsname-backuppropertiesdatabases) | array | Databases included in the backup. |
| [`enabled`](#parameter-configsname-backuppropertiesenabled) | bool | Set to `True` if the backup schedule is enabled (must be included in that case), `false` if the backup schedule should be disabled. |
| [`storageAccountUrl`](#parameter-configsname-backuppropertiesstorageaccounturl) | string | SAS URL to the container. |

### Parameter: `configs.name-backup.properties.backupName`

Name of the backup.

- Required: No
- Type: string

### Parameter: `configs.name-backup.properties.backupSchedule`

Schedule for the backup if it is executed periodically.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequencyInterval`](#parameter-configsname-backuppropertiesbackupschedulefrequencyinterval) | int | How often the backup should be executed (e.g. for weekly backup, this should be set to 7 and FrequencyUnit should be set to Day). |
| [`frequencyUnit`](#parameter-configsname-backuppropertiesbackupschedulefrequencyunit) | string | The unit of time for how often the backup should be executed (e.g. for weekly backup, this should be set to Day and FrequencyInterval should be set to 7). |
| [`keepAtLeastOneBackup`](#parameter-configsname-backuppropertiesbackupschedulekeepatleastonebackup) | bool | Set to `True` if the retention policy should always keep at least one backup in the storage account, regardless how old it is. |
| [`retentionPeriodInDays`](#parameter-configsname-backuppropertiesbackupscheduleretentionperiodindays) | int | After how many days backups should be deleted. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`startTime`](#parameter-configsname-backuppropertiesbackupschedulestarttime) | string | When the schedule should start working. |

### Parameter: `configs.name-backup.properties.backupSchedule.frequencyInterval`

How often the backup should be executed (e.g. for weekly backup, this should be set to 7 and FrequencyUnit should be set to Day).

- Required: Yes
- Type: int

### Parameter: `configs.name-backup.properties.backupSchedule.frequencyUnit`

The unit of time for how often the backup should be executed (e.g. for weekly backup, this should be set to Day and FrequencyInterval should be set to 7).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Day'
    'Hour'
  ]
  ```

### Parameter: `configs.name-backup.properties.backupSchedule.keepAtLeastOneBackup`

Set to `True` if the retention policy should always keep at least one backup in the storage account, regardless how old it is.

- Required: Yes
- Type: bool

### Parameter: `configs.name-backup.properties.backupSchedule.retentionPeriodInDays`

After how many days backups should be deleted.

- Required: Yes
- Type: int

### Parameter: `configs.name-backup.properties.backupSchedule.startTime`

When the schedule should start working.

- Required: No
- Type: string

### Parameter: `configs.name-backup.properties.databases`

Databases included in the backup.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseType`](#parameter-configsname-backuppropertiesdatabasesdatabasetype) | string | Database type (e.g. SqlAzure / MySql). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionString`](#parameter-configsname-backuppropertiesdatabasesconnectionstring) | securestring | Contains a connection string to a database which is being backed up or restored. If the restore should happen to a new database, the database name inside is the new one. |
| [`connectionStringName`](#parameter-configsname-backuppropertiesdatabasesconnectionstringname) | string | Contains a connection string name that is linked to the SiteConfig.ConnectionStrings. This is used during restore with overwrite connection strings options. |
| [`name`](#parameter-configsname-backuppropertiesdatabasesname) | string | The name of the setting. |

### Parameter: `configs.name-backup.properties.databases.databaseType`

Database type (e.g. SqlAzure / MySql).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LocalMySql'
    'MySql'
    'PostgreSql'
    'SqlAzure'
  ]
  ```

### Parameter: `configs.name-backup.properties.databases.connectionString`

Contains a connection string to a database which is being backed up or restored. If the restore should happen to a new database, the database name inside is the new one.

- Required: No
- Type: securestring

### Parameter: `configs.name-backup.properties.databases.connectionStringName`

Contains a connection string name that is linked to the SiteConfig.ConnectionStrings. This is used during restore with overwrite connection strings options.

- Required: No
- Type: string

### Parameter: `configs.name-backup.properties.databases.name`

The name of the setting.

- Required: No
- Type: string

### Parameter: `configs.name-backup.properties.enabled`

Set to `True` if the backup schedule is enabled (must be included in that case), `false` if the backup schedule should be disabled.

- Required: No
- Type: bool

### Parameter: `configs.name-backup.properties.storageAccountUrl`

SAS URL to the container.

- Required: No
- Type: string

### Variant: `configs.name-connectionstrings`
The type for a connection string configuration.

To use this variant, set the property `name` to `connectionstrings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-connectionstringsname) | string | The type of config. |
| [`properties`](#parameter-configsname-connectionstringsproperties) | object | The config settings. |

### Parameter: `configs.name-connectionstrings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'connectionstrings'
  ]
  ```

### Parameter: `configs.name-connectionstrings.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-connectionstringsproperties>any_other_property<) | object | The name of the connection string setting. |

### Parameter: `configs.name-connectionstrings.properties.>Any_other_property<`

The name of the connection string setting.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-configsname-connectionstringsproperties>any_other_property<type) | string | Type of database. |
| [`value`](#parameter-configsname-connectionstringsproperties>any_other_property<value) | string | Value of pair. |

### Parameter: `configs.name-connectionstrings.properties.>Any_other_property<.type`

Type of database.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ApiHub'
    'Custom'
    'DocDb'
    'EventHub'
    'MySql'
    'NotificationHub'
    'PostgreSQL'
    'RedisCache'
    'ServiceBus'
    'SQLAzure'
    'SQLServer'
  ]
  ```

### Parameter: `configs.name-connectionstrings.properties.>Any_other_property<.value`

Value of pair.

- Required: Yes
- Type: string

### Variant: `configs.name-logs`
The type of a logs configuration.

To use this variant, set the property `name` to `logs`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-logsname) | string | The type of config. |
| [`properties`](#parameter-configsname-logsproperties) | object | The config settings. |

### Parameter: `configs.name-logs.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'logs'
  ]
  ```

### Parameter: `configs.name-logs.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationLogs`](#parameter-configsname-logspropertiesapplicationlogs) | object | Application Logs for Azure configuration. |
| [`detailedErrorMessages`](#parameter-configsname-logspropertiesdetailederrormessages) | object | Detailed error messages configuration. |
| [`failedRequestsTracing`](#parameter-configsname-logspropertiesfailedrequeststracing) | object | Failed requests tracing configuration. |
| [`httpLogs`](#parameter-configsname-logspropertieshttplogs) | object | HTTP logs configuration. |

### Parameter: `configs.name-logs.properties.applicationLogs`

Application Logs for Azure configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureBlobStorage`](#parameter-configsname-logspropertiesapplicationlogsazureblobstorage) | object | Application logs to blob storage configuration. |
| [`azureTableStorage`](#parameter-configsname-logspropertiesapplicationlogsazuretablestorage) | object | Application logs to azure table storage configuration. |
| [`fileSystem`](#parameter-configsname-logspropertiesapplicationlogsfilesystem) | object | Application logs to file system configuration. |

### Parameter: `configs.name-logs.properties.applicationLogs.azureBlobStorage`

Application logs to blob storage configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-configsname-logspropertiesapplicationlogsazureblobstoragelevel) | string | Log level. |
| [`retentionInDays`](#parameter-configsname-logspropertiesapplicationlogsazureblobstorageretentionindays) | int | Retention in days. Remove blobs older than X days. 0 or lower means no retention. |
| [`sasUrl`](#parameter-configsname-logspropertiesapplicationlogsazureblobstoragesasurl) | string | SAS url to a azure blob container with read/write/list/delete permissions. |

### Parameter: `configs.name-logs.properties.applicationLogs.azureBlobStorage.level`

Log level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Error'
    'Information'
    'Off'
    'Verbose'
    'Warning'
  ]
  ```

### Parameter: `configs.name-logs.properties.applicationLogs.azureBlobStorage.retentionInDays`

Retention in days. Remove blobs older than X days. 0 or lower means no retention.

- Required: No
- Type: int

### Parameter: `configs.name-logs.properties.applicationLogs.azureBlobStorage.sasUrl`

SAS url to a azure blob container with read/write/list/delete permissions.

- Required: No
- Type: string

### Parameter: `configs.name-logs.properties.applicationLogs.azureTableStorage`

Application logs to azure table storage configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sasUrl`](#parameter-configsname-logspropertiesapplicationlogsazuretablestoragesasurl) | string | SAS URL to an Azure table with add/query/delete permissions. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-configsname-logspropertiesapplicationlogsazuretablestoragelevel) | string | Log level. |

### Parameter: `configs.name-logs.properties.applicationLogs.azureTableStorage.sasUrl`

SAS URL to an Azure table with add/query/delete permissions.

- Required: Yes
- Type: string

### Parameter: `configs.name-logs.properties.applicationLogs.azureTableStorage.level`

Log level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Error'
    'Information'
    'Off'
    'Verbose'
    'Warning'
  ]
  ```

### Parameter: `configs.name-logs.properties.applicationLogs.fileSystem`

Application logs to file system configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-configsname-logspropertiesapplicationlogsfilesystemlevel) | string | Log level. |

### Parameter: `configs.name-logs.properties.applicationLogs.fileSystem.level`

Log level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Error'
    'Information'
    'Off'
    'Verbose'
    'Warning'
  ]
  ```

### Parameter: `configs.name-logs.properties.detailedErrorMessages`

Detailed error messages configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-logspropertiesdetailederrormessagesenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |

### Parameter: `configs.name-logs.properties.detailedErrorMessages.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `configs.name-logs.properties.failedRequestsTracing`

Failed requests tracing configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-logspropertiesfailedrequeststracingenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |

### Parameter: `configs.name-logs.properties.failedRequestsTracing.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `configs.name-logs.properties.httpLogs`

HTTP logs configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureBlobStorage`](#parameter-configsname-logspropertieshttplogsazureblobstorage) | object | Http logs to azure blob storage configuration. |
| [`fileSystem`](#parameter-configsname-logspropertieshttplogsfilesystem) | object | Http logs to file system configuration. |

### Parameter: `configs.name-logs.properties.httpLogs.azureBlobStorage`

Http logs to azure blob storage configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-logspropertieshttplogsazureblobstorageenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |
| [`retentionInDays`](#parameter-configsname-logspropertieshttplogsazureblobstorageretentionindays) | int | Retention in days. Remove blobs older than X days. 0 or lower means no retention. |
| [`sasUrl`](#parameter-configsname-logspropertieshttplogsazureblobstoragesasurl) | string | SAS url to a azure blob container with read/write/list/delete permissions. |

### Parameter: `configs.name-logs.properties.httpLogs.azureBlobStorage.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `configs.name-logs.properties.httpLogs.azureBlobStorage.retentionInDays`

Retention in days. Remove blobs older than X days. 0 or lower means no retention.

- Required: No
- Type: int

### Parameter: `configs.name-logs.properties.httpLogs.azureBlobStorage.sasUrl`

SAS url to a azure blob container with read/write/list/delete permissions.

- Required: No
- Type: string

### Parameter: `configs.name-logs.properties.httpLogs.fileSystem`

Http logs to file system configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-configsname-logspropertieshttplogsfilesystemenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |
| [`retentionInDays`](#parameter-configsname-logspropertieshttplogsfilesystemretentionindays) | int | Retention in days. Remove files older than X days. 0 or lower means no retention. |
| [`retentionInMb`](#parameter-configsname-logspropertieshttplogsfilesystemretentioninmb) | int | Maximum size in megabytes that http log files can use. When reached old log files will be removed to make space for new ones. |

### Parameter: `configs.name-logs.properties.httpLogs.fileSystem.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `configs.name-logs.properties.httpLogs.fileSystem.retentionInDays`

Retention in days. Remove files older than X days. 0 or lower means no retention.

- Required: No
- Type: int

### Parameter: `configs.name-logs.properties.httpLogs.fileSystem.retentionInMb`

Maximum size in megabytes that http log files can use. When reached old log files will be removed to make space for new ones.

- Required: No
- Type: int
- MinValue: 25
- MaxValue: 100

### Variant: `configs.name-metadata`
The type of a metadata configuration.

To use this variant, set the property `name` to `metadata`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-metadataname) | string | The type of config. |
| [`properties`](#parameter-configsname-metadataproperties) | object | The config settings. |

### Parameter: `configs.name-metadata.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'metadata'
  ]
  ```

### Parameter: `configs.name-metadata.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-metadataproperties>any_other_property<) | string | The metadata key value pair. |

### Parameter: `configs.name-metadata.properties.>Any_other_property<`

The metadata key value pair.

- Required: No
- Type: string

### Variant: `configs.name-pushsettings`
The type of a pushSettings configuration.

To use this variant, set the property `name` to `pushsettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-pushsettingsname) | string | The type of config. |
| [`properties`](#parameter-configsname-pushsettingsproperties) | object | The config settings. |

### Parameter: `configs.name-pushsettings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'pushsettings'
  ]
  ```

### Parameter: `configs.name-pushsettings.properties`

The config settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isPushEnabled`](#parameter-configsname-pushsettingspropertiesispushenabled) | bool | Gets or sets a flag indicating whether the Push endpoint is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamicTagsJson`](#parameter-configsname-pushsettingspropertiesdynamictagsjson) | string | Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint. |
| [`tagsRequiringAuth`](#parameter-configsname-pushsettingspropertiestagsrequiringauth) | string | Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler. |
| [`tagWhitelistJson`](#parameter-configsname-pushsettingspropertiestagwhitelistjson) | string | Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint. |

### Parameter: `configs.name-pushsettings.properties.isPushEnabled`

Gets or sets a flag indicating whether the Push endpoint is enabled.

- Required: Yes
- Type: bool

### Parameter: `configs.name-pushsettings.properties.dynamicTagsJson`

Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint.

- Required: No
- Type: string

### Parameter: `configs.name-pushsettings.properties.tagsRequiringAuth`

Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler.

- Required: No
- Type: string

### Parameter: `configs.name-pushsettings.properties.tagWhitelistJson`

Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint.

- Required: No
- Type: string

### Variant: `configs.name-slotConfigNames`
The type of a slotConfigNames configuration.

To use this variant, set the property `name` to `slotConfigNames`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-slotconfignamesname) | string | The type of config. |
| [`properties`](#parameter-configsname-slotconfignamesproperties) | object | The config settings. |

### Parameter: `configs.name-slotConfigNames.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'slotConfigNames'
  ]
  ```

### Parameter: `configs.name-slotConfigNames.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appSettingNames`](#parameter-configsname-slotconfignamespropertiesappsettingnames) | array | List of application settings names. |
| [`azureStorageConfigNames`](#parameter-configsname-slotconfignamespropertiesazurestorageconfignames) | array | List of external Azure storage account identifiers. |
| [`connectionStringNames`](#parameter-configsname-slotconfignamespropertiesconnectionstringnames) | array | List of connection string names. |

### Parameter: `configs.name-slotConfigNames.properties.appSettingNames`

List of application settings names.

- Required: No
- Type: array

### Parameter: `configs.name-slotConfigNames.properties.azureStorageConfigNames`

List of external Azure storage account identifiers.

- Required: No
- Type: array

### Parameter: `configs.name-slotConfigNames.properties.connectionStringNames`

List of connection string names.

- Required: No
- Type: array

### Variant: `configs.name-web`
The type of a web configuration.

To use this variant, set the property `name` to `web`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-webname) | string | The type of config. |
| [`properties`](#parameter-configsname-webproperties) | object | The config settings. |

### Parameter: `configs.name-web.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'web'
  ]
  ```

### Parameter: `configs.name-web.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrUseManagedIdentityCreds`](#parameter-configsname-webpropertiesacrusemanagedidentitycreds) | bool | Flag to use Managed Identity Creds for ACR pull. |
| [`acrUserManagedIdentityID`](#parameter-configsname-webpropertiesacrusermanagedidentityid) | string | If using user managed identity, the user managed identity ClientId. |
| [`alwaysOn`](#parameter-configsname-webpropertiesalwayson) | bool | Set to `true` if 'Always On' is enabled. |
| [`apiDefinition`](#parameter-configsname-webpropertiesapidefinition) | object | Information about the formal API definition for the app. |
| [`apiManagementConfig`](#parameter-configsname-webpropertiesapimanagementconfig) | object | Azure API management settings linked to the app. |
| [`appCommandLine`](#parameter-configsname-webpropertiesappcommandline) | string | App command line to launch. |
| [`appSettings`](#parameter-configsname-webpropertiesappsettings) | array | Application settings. |
| [`autoHealEnabled`](#parameter-configsname-webpropertiesautohealenabled) | bool | Set to `true` if Auto Heal is enabled. |
| [`autoHealRules`](#parameter-configsname-webpropertiesautohealrules) | object | Auto Heal rules. |
| [`autoSwapSlotName`](#parameter-configsname-webpropertiesautoswapslotname) | string | Auto-swap slot name. |
| [`azureStorageAccounts`](#parameter-configsname-webpropertiesazurestorageaccounts) | object | List of Azure Storage Accounts. |
| [`connectionStrings`](#parameter-configsname-webpropertiesconnectionstrings) | array | Connection strings. |
| [`cors`](#parameter-configsname-webpropertiescors) | object | Cross-Origin Resource Sharing (CORS) settings. |
| [`defaultDocuments`](#parameter-configsname-webpropertiesdefaultdocuments) | array | Default documents. |
| [`detailedErrorLoggingEnabled`](#parameter-configsname-webpropertiesdetailederrorloggingenabled) | bool | Set to `true` if detailed error logging is enabled. |
| [`documentRoot`](#parameter-configsname-webpropertiesdocumentroot) | string | Document root. |
| [`elasticWebAppScaleLimit`](#parameter-configsname-webpropertieselasticwebappscalelimit) | int | Maximum number of workers that a site can scale out to. This setting only applies to apps in plans where ElasticScaleEnabled is `true`. |
| [`experiments`](#parameter-configsname-webpropertiesexperiments) | object | This is work around for polymorphic types. |
| [`ftpsState`](#parameter-configsname-webpropertiesftpsstate) | string | State of FTP / FTPS service. |
| [`functionAppScaleLimit`](#parameter-configsname-webpropertiesfunctionappscalelimit) | int | Maximum number of workers that a site can scale out to. This setting only applies to the Consumption and Elastic Premium Plans. |
| [`functionsRuntimeScaleMonitoringEnabled`](#parameter-configsname-webpropertiesfunctionsruntimescalemonitoringenabled) | bool | Gets or sets a value indicating whether functions runtime scale monitoring is enabled. When enabled, the ScaleController will not monitor event sources directly, but will instead call to the runtime to get scale status. |
| [`handlerMappings`](#parameter-configsname-webpropertieshandlermappings) | array | Handler mappings. |
| [`healthCheckPath`](#parameter-configsname-webpropertieshealthcheckpath) | string | Health check path. |
| [`http20Enabled`](#parameter-configsname-webpropertieshttp20enabled) | bool | Allow clients to connect over http2.0. |
| [`httpLoggingEnabled`](#parameter-configsname-webpropertieshttploggingenabled) | bool | Set to `true` if HTTP logging is enabled. |
| [`ipSecurityRestrictions`](#parameter-configsname-webpropertiesipsecurityrestrictions) | array | IP security restrictions for main. |
| [`ipSecurityRestrictionsDefaultAction`](#parameter-configsname-webpropertiesipsecurityrestrictionsdefaultaction) | string | Default action for main access restriction if no rules are matched. |
| [`javaContainer`](#parameter-configsname-webpropertiesjavacontainer) | string | Java container. |
| [`javaContainerVersion`](#parameter-configsname-webpropertiesjavacontainerversion) | string | Java container version. |
| [`javaVersion`](#parameter-configsname-webpropertiesjavaversion) | string | Java version. |
| [`keyVaultReferenceIdentity`](#parameter-configsname-webpropertieskeyvaultreferenceidentity) | string | Identity to use for Key Vault Reference authentication. |
| [`limits`](#parameter-configsname-webpropertieslimits) | object | Site limits. |
| [`linuxFxVersion`](#parameter-configsname-webpropertieslinuxfxversion) | string | Linux App Framework and version. |
| [`loadBalancing`](#parameter-configsname-webpropertiesloadbalancing) | string | Site load balancing. |
| [`localMySqlEnabled`](#parameter-configsname-webpropertieslocalmysqlenabled) | bool | Set to `true` to enable local MySQL. |
| [`logsDirectorySizeLimit`](#parameter-configsname-webpropertieslogsdirectorysizelimit) | int | HTTP logs directory size limit. |
| [`managedPipelineMode`](#parameter-configsname-webpropertiesmanagedpipelinemode) | string | Managed pipeline mode. |
| [`managedServiceIdentityId`](#parameter-configsname-webpropertiesmanagedserviceidentityid) | int | Managed Service Identity Id. |
| [`metadata`](#parameter-configsname-webpropertiesmetadata) | array | Application metadata. This property cannot be retrieved, since it may contain secrets. |
| [`minimumElasticInstanceCount`](#parameter-configsname-webpropertiesminimumelasticinstancecount) | int | Number of minimum instance count for a site. This setting only applies to the Elastic Plans. |
| [`minTlsCipherSuite`](#parameter-configsname-webpropertiesmintlsciphersuite) | string | The minimum strength TLS cipher suite allowed for an application. |
| [`minTlsVersion`](#parameter-configsname-webpropertiesmintlsversion) | string | MinTlsVersion: configures the minimum version of TLS required for SSL requests. |
| [`netFrameworkVersion`](#parameter-configsname-webpropertiesnetframeworkversion) | string | .NET Framework version. |
| [`nodeVersion`](#parameter-configsname-webpropertiesnodeversion) | string | Version of Node.js. |
| [`numberOfWorkers`](#parameter-configsname-webpropertiesnumberofworkers) | int | Number of workers. |
| [`phpVersion`](#parameter-configsname-webpropertiesphpversion) | string | Version of PHP. |
| [`powerShellVersion`](#parameter-configsname-webpropertiespowershellversion) | string | Version of PowerShell. |
| [`preWarmedInstanceCount`](#parameter-configsname-webpropertiesprewarmedinstancecount) | int | Number of preWarmed instances. This setting only applies to the Consumption and Elastic Plans. |
| [`publicNetworkAccess`](#parameter-configsname-webpropertiespublicnetworkaccess) | string | Property to allow or block all public traffic. |
| [`publishingUsername`](#parameter-configsname-webpropertiespublishingusername) | string | Publishing user name. |
| [`push`](#parameter-configsname-webpropertiespush) | object | Push endpoint settings. |
| [`pythonVersion`](#parameter-configsname-webpropertiespythonversion) | string | Version of Python. |
| [`remoteDebuggingEnabled`](#parameter-configsname-webpropertiesremotedebuggingenabled) | bool | Set to `true` if remote debugging is enabled. |
| [`remoteDebuggingVersion`](#parameter-configsname-webpropertiesremotedebuggingversion) | string | Remote debugging version. |
| [`requestTracingEnabled`](#parameter-configsname-webpropertiesrequesttracingenabled) | bool | Set to `true` if request tracing is enabled. |
| [`requestTracingExpirationTime`](#parameter-configsname-webpropertiesrequesttracingexpirationtime) | string | Request tracing expiration time. |
| [`scmIpSecurityRestrictions`](#parameter-configsname-webpropertiesscmipsecurityrestrictions) | array | IP security restrictions for scm. |
| [`scmIpSecurityRestrictionsDefaultAction`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsdefaultaction) | string | Default action for scm access restriction if no rules are matched. |
| [`scmIpSecurityRestrictionsUseMain`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsusemain) | bool | IP security restrictions for scm to use main. |
| [`scmMinTlsVersion`](#parameter-configsname-webpropertiesscmmintlsversion) | string | ScmMinTlsVersion: configures the minimum version of TLS required for SSL requests for SCM site. |
| [`scmType`](#parameter-configsname-webpropertiesscmtype) | string | SCM type. |
| [`tracingOptions`](#parameter-configsname-webpropertiestracingoptions) | string | Tracing options. |
| [`use32BitWorkerProcess`](#parameter-configsname-webpropertiesuse32bitworkerprocess) | bool | Set to `true` to use 32-bit worker process. |
| [`virtualApplications`](#parameter-configsname-webpropertiesvirtualapplications) | array | Virtual applications. |
| [`vnetName`](#parameter-configsname-webpropertiesvnetname) | string | Virtual Network name. |
| [`vnetPrivatePortsCount`](#parameter-configsname-webpropertiesvnetprivateportscount) | int | The number of private ports assigned to this app. These will be assigned dynamically on runtime. |
| [`vnetRouteAllEnabled`](#parameter-configsname-webpropertiesvnetrouteallenabled) | bool | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |
| [`websiteTimeZone`](#parameter-configsname-webpropertieswebsitetimezone) | string | Sets the time zone a site uses for generating timestamps. Compatible with Linux and Windows App Service. Setting the WEBSITE_TIME_ZONE app setting takes precedence over this config. For Linux, expects tz database values https://www.iana.org/time-zones (for a quick reference see [ref](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)). For Windows, expects one of the time zones listed under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones. |
| [`webSocketsEnabled`](#parameter-configsname-webpropertieswebsocketsenabled) | bool | Set to `true` if WebSocket is enabled. |
| [`windowsFxVersion`](#parameter-configsname-webpropertieswindowsfxversion) | string | Xenon App Framework and version. |
| [`xManagedServiceIdentityId`](#parameter-configsname-webpropertiesxmanagedserviceidentityid) | int | Explicit Managed Service Identity Id. |

### Parameter: `configs.name-web.properties.acrUseManagedIdentityCreds`

Flag to use Managed Identity Creds for ACR pull.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.acrUserManagedIdentityID`

If using user managed identity, the user managed identity ClientId.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.alwaysOn`

Set to `true` if 'Always On' is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.apiDefinition`

Information about the formal API definition for the app.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-configsname-webpropertiesapidefinitionurl) | string | The URL of the API definition. |

### Parameter: `configs.name-web.properties.apiDefinition.url`

The URL of the API definition.

- Required: Yes
- Type: string

### Parameter: `configs.name-web.properties.apiManagementConfig`

Azure API management settings linked to the app.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-configsname-webpropertiesapimanagementconfigid) | string | APIM-Api Identifier. |

### Parameter: `configs.name-web.properties.apiManagementConfig.id`

APIM-Api Identifier.

- Required: Yes
- Type: string

### Parameter: `configs.name-web.properties.appCommandLine`

App command line to launch.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.appSettings`

Application settings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-webpropertiesappsettingsname) | string | Name of the pair. |
| [`value`](#parameter-configsname-webpropertiesappsettingsvalue) | string | Value of the pair. |

### Parameter: `configs.name-web.properties.appSettings.name`

Name of the pair.

- Required: Yes
- Type: string

### Parameter: `configs.name-web.properties.appSettings.value`

Value of the pair.

- Required: Yes
- Type: string

### Parameter: `configs.name-web.properties.autoHealEnabled`

Set to `true` if Auto Heal is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.autoHealRules`

Auto Heal rules.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-configsname-webpropertiesautohealrulesactions) | object | Actions to be executed when a rule is triggered. |
| [`triggers`](#parameter-configsname-webpropertiesautohealrulestriggers) | object | Conditions that describe when to execute the auto-heal actions. |

### Parameter: `configs.name-web.properties.autoHealRules.actions`

Actions to be executed when a rule is triggered.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionType`](#parameter-configsname-webpropertiesautohealrulesactionsactiontype) | string | Predefined action to be taken. |
| [`customAction`](#parameter-configsname-webpropertiesautohealrulesactionscustomaction) | object | Custom action to be taken. |
| [`minProcessExecutionTime`](#parameter-configsname-webpropertiesautohealrulesactionsminprocessexecutiontime) | string | Minimum time the process must execute before taking the action. |

### Parameter: `configs.name-web.properties.autoHealRules.actions.actionType`

Predefined action to be taken.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CustomAction'
    'LogEvent'
    'Recycle'
  ]
  ```

### Parameter: `configs.name-web.properties.autoHealRules.actions.customAction`

Custom action to be taken.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exe`](#parameter-configsname-webpropertiesautohealrulesactionscustomactionexe) | string | Executable to be run. |
| [`parameters`](#parameter-configsname-webpropertiesautohealrulesactionscustomactionparameters) | string | Parameters for the executable. |

### Parameter: `configs.name-web.properties.autoHealRules.actions.customAction.exe`

Executable to be run.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.actions.customAction.parameters`

Parameters for the executable.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.actions.minProcessExecutionTime`

Minimum time the process must execute before taking the action.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers`

Conditions that describe when to execute the auto-heal actions.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateBytesInKB`](#parameter-configsname-webpropertiesautohealrulestriggersprivatebytesinkb) | int | A rule based on private bytes. |
| [`requests`](#parameter-configsname-webpropertiesautohealrulestriggersrequests) | object | A rule based on total requests. |
| [`slowRequests`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequests) | object | A rule based on request execution time. |
| [`slowRequestsWithPath`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestswithpath) | array | A rule based on multiple Slow Requests Rule with path. |
| [`statusCodes`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodes) | array | A rule based on status codes. |
| [`statusCodesRange`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodesrange) | array | A rule based on status codes ranges. |

### Parameter: `configs.name-web.properties.autoHealRules.triggers.privateBytesInKB`

A rule based on private bytes.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.requests`

A rule based on total requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-configsname-webpropertiesautohealrulestriggersrequestscount) | int | Request Count. |
| [`timeInterval`](#parameter-configsname-webpropertiesautohealrulestriggersrequeststimeinterval) | string | Time interval. |

### Parameter: `configs.name-web.properties.autoHealRules.triggers.requests.count`

Request Count.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.requests.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequests`

A rule based on request execution time.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestscount) | int | Request Count. |
| [`path`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestspath) | string | Request Path. |
| [`timeInterval`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequeststimeinterval) | string | Time interval. |
| [`timeTaken`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequeststimetaken) | string | Time taken. |

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequests.count`

Request Count.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequests.path`

Request Path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequests.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequests.timeTaken`

Time taken.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath`

A rule based on multiple Slow Requests Rule with path.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestswithpathcount) | int | Request Count. |
| [`path`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestswithpathpath) | string | Request Path. |
| [`timeInterval`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestswithpathtimeinterval) | string | Time interval. |
| [`timeTaken`](#parameter-configsname-webpropertiesautohealrulestriggersslowrequestswithpathtimetaken) | string | Time taken. |

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.count`

Request Count.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.path`

Request Path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.timeTaken`

Time taken.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes`

A rule based on status codes.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodescount) | int | Request Count. |
| [`path`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodespath) | string | Request Path. |
| [`status`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodesstatus) | int | HTTP status code. |
| [`subStatus`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodessubstatus) | int | Request Sub Status. |
| [`timeInterval`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodestimeinterval) | string | Time interval. |
| [`win32Status`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodeswin32status) | int | Win32 error code. |

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes.count`

Request Count.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes.path`

Request Path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes.status`

HTTP status code.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes.subStatus`

Request Sub Status.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodes.win32Status`

Win32 error code.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodesRange`

A rule based on status codes ranges.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodesrangecount) | int | Request Count. |
| [`path`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodesrangepath) | string | Path. |
| [`statusCodes`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodesrangestatuscodes) | string | HTTP status code. |
| [`timeInterval`](#parameter-configsname-webpropertiesautohealrulestriggersstatuscodesrangetimeinterval) | string | Time interval. |

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodesRange.count`

Request Count.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodesRange.path`

Path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodesRange.statusCodes`

HTTP status code.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoHealRules.triggers.statusCodesRange.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.autoSwapSlotName`

Auto-swap slot name.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.azureStorageAccounts`

List of Azure Storage Accounts.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<) | object | A storage account configuration. |

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<`

A storage account configuration.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKey`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<accesskey) | securestring | Access key for the storage account. |
| [`accountName`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<accountname) | string | Name of the storage account. |
| [`mountPath`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<mountpath) | string | Path to mount the storage within the site's runtime environment. |
| [`protocol`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<protocol) | string | Mounting protocol to use for the storage account. |
| [`shareName`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<sharename) | string | Name of the file share (container name, for Blob storage). |
| [`type`](#parameter-configsname-webpropertiesazurestorageaccounts>any_other_property<type) | string | Type of storage. |

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<.accessKey`

Access key for the storage account.

- Required: No
- Type: securestring

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<.accountName`

Name of the storage account.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<.mountPath`

Path to mount the storage within the site's runtime environment.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<.protocol`

Mounting protocol to use for the storage account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Nfs'
    'Smb'
  ]
  ```

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<.shareName`

Name of the file share (container name, for Blob storage).

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.azureStorageAccounts.>Any_other_property<.type`

Type of storage.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureBlob'
    'AzureFiles'
  ]
  ```

### Parameter: `configs.name-web.properties.connectionStrings`

Connection strings.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionString`](#parameter-configsname-webpropertiesconnectionstringsconnectionstring) | string | Connection string value. |
| [`name`](#parameter-configsname-webpropertiesconnectionstringsname) | string | Name of connection string. |
| [`type`](#parameter-configsname-webpropertiesconnectionstringstype) | string | Type of database. |

### Parameter: `configs.name-web.properties.connectionStrings.connectionString`

Connection string value.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.connectionStrings.name`

Name of connection string.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.connectionStrings.type`

Type of database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ApiHub'
    'Custom'
    'DocDb'
    'EventHub'
    'MySql'
    'NotificationHub'
    'PostgreSQL'
    'RedisCache'
    'ServiceBus'
    'SQLAzure'
    'SQLServer'
  ]
  ```

### Parameter: `configs.name-web.properties.cors`

Cross-Origin Resource Sharing (CORS) settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedOrigins`](#parameter-configsname-webpropertiescorsallowedorigins) | array | Gets or sets the list of origins that should be allowed to make cross-origin calls (for example: http://example.com:12345). Use "*" to allow all. |
| [`supportCredentials`](#parameter-configsname-webpropertiescorssupportcredentials) | bool | Gets or sets whether CORS requests with credentials are allowed. See [ref](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#Requests_with_credentials) for more details. |

### Parameter: `configs.name-web.properties.cors.allowedOrigins`

Gets or sets the list of origins that should be allowed to make cross-origin calls (for example: http://example.com:12345). Use "*" to allow all.

- Required: No
- Type: array

### Parameter: `configs.name-web.properties.cors.supportCredentials`

Gets or sets whether CORS requests with credentials are allowed. See [ref](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#Requests_with_credentials) for more details.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.defaultDocuments`

Default documents.

- Required: No
- Type: array

### Parameter: `configs.name-web.properties.detailedErrorLoggingEnabled`

Set to `true` if detailed error logging is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.documentRoot`

Document root.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.elasticWebAppScaleLimit`

Maximum number of workers that a site can scale out to. This setting only applies to apps in plans where ElasticScaleEnabled is `true`.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `configs.name-web.properties.experiments`

This is work around for polymorphic types.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rampUpRules`](#parameter-configsname-webpropertiesexperimentsrampuprules) | array | List of ramp-up rules. |

### Parameter: `configs.name-web.properties.experiments.rampUpRules`

List of ramp-up rules.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionHostName`](#parameter-configsname-webpropertiesexperimentsrampuprulesactionhostname) | string | Hostname of a slot to which the traffic will be redirected if decided to. E.g. myapp-stage.azurewebsites.net. |
| [`changeDecisionCallbackUrl`](#parameter-configsname-webpropertiesexperimentsrampupruleschangedecisioncallbackurl) | string | Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified. |
| [`changeIntervalInMinutes`](#parameter-configsname-webpropertiesexperimentsrampupruleschangeintervalinminutes) | int | Specifies interval in minutes to reevaluate ReroutePercentage. |
| [`changeStep`](#parameter-configsname-webpropertiesexperimentsrampupruleschangestep) | int | In auto ramp up scenario this is the step to add/remove from `ReroutePercentage` until it reaches `MinReroutePercentage` or `MaxReroutePercentage`. Site metrics are checked every N minutes specified in `ChangeIntervalInMinutes`. Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified in `ChangeDecisionCallbackUrl`. |
| [`maxReroutePercentage`](#parameter-configsname-webpropertiesexperimentsrampuprulesmaxreroutepercentage) | int | Specifies upper boundary below which ReroutePercentage will stay. |
| [`minReroutePercentage`](#parameter-configsname-webpropertiesexperimentsrampuprulesminreroutepercentage) | int | Specifies lower boundary above which ReroutePercentage will stay. |
| [`name`](#parameter-configsname-webpropertiesexperimentsrampuprulesname) | string | Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment. |
| [`reroutePercentage`](#parameter-configsname-webpropertiesexperimentsrampuprulesreroutepercentage) | int | Percentage of the traffic which will be redirected to `ActionHostName`. |

### Parameter: `configs.name-web.properties.experiments.rampUpRules.actionHostName`

Hostname of a slot to which the traffic will be redirected if decided to. E.g. myapp-stage.azurewebsites.net.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.experiments.rampUpRules.changeDecisionCallbackUrl`

Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.experiments.rampUpRules.changeIntervalInMinutes`

Specifies interval in minutes to reevaluate ReroutePercentage.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.experiments.rampUpRules.changeStep`

In auto ramp up scenario this is the step to add/remove from `ReroutePercentage` until it reaches `MinReroutePercentage` or `MaxReroutePercentage`. Site metrics are checked every N minutes specified in `ChangeIntervalInMinutes`. Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified in `ChangeDecisionCallbackUrl`.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.experiments.rampUpRules.maxReroutePercentage`

Specifies upper boundary below which ReroutePercentage will stay.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.experiments.rampUpRules.minReroutePercentage`

Specifies lower boundary above which ReroutePercentage will stay.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.experiments.rampUpRules.name`

Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.experiments.rampUpRules.reroutePercentage`

Percentage of the traffic which will be redirected to `ActionHostName`.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.ftpsState`

State of FTP / FTPS service.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllAllowed'
    'Disabled'
    'FtpsOnly'
  ]
  ```

### Parameter: `configs.name-web.properties.functionAppScaleLimit`

Maximum number of workers that a site can scale out to. This setting only applies to the Consumption and Elastic Premium Plans.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `configs.name-web.properties.functionsRuntimeScaleMonitoringEnabled`

Gets or sets a value indicating whether functions runtime scale monitoring is enabled. When enabled, the ScaleController will not monitor event sources directly, but will instead call to the runtime to get scale status.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.handlerMappings`

Handler mappings.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arguments`](#parameter-configsname-webpropertieshandlermappingsarguments) | string | Command-line arguments to be passed to the script processor. |
| [`extension`](#parameter-configsname-webpropertieshandlermappingsextension) | string | Requests with this extension will be handled using the specified FastCGI application. |
| [`scriptProcessor`](#parameter-configsname-webpropertieshandlermappingsscriptprocessor) | string | The absolute path to the FastCGI application. |

### Parameter: `configs.name-web.properties.handlerMappings.arguments`

Command-line arguments to be passed to the script processor.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.handlerMappings.extension`

Requests with this extension will be handled using the specified FastCGI application.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.handlerMappings.scriptProcessor`

The absolute path to the FastCGI application.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.healthCheckPath`

Health check path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.http20Enabled`

Allow clients to connect over http2.0.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.httpLoggingEnabled`

Set to `true` if HTTP logging is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.ipSecurityRestrictions`

IP security restrictions for main.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-configsname-webpropertiesipsecurityrestrictionsaction) | string | Allow or Deny access for this IP range. |
| [`description`](#parameter-configsname-webpropertiesipsecurityrestrictionsdescription) | string | IP restriction rule description. |
| [`headers`](#parameter-configsname-webpropertiesipsecurityrestrictionsheaders) | object | IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match. |
| [`ipAddress`](#parameter-configsname-webpropertiesipsecurityrestrictionsipaddress) | string | IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified. |
| [`name`](#parameter-configsname-webpropertiesipsecurityrestrictionsname) | string | IP restriction rule name. |
| [`priority`](#parameter-configsname-webpropertiesipsecurityrestrictionspriority) | int | Priority of IP restriction rule. |
| [`subnetMask`](#parameter-configsname-webpropertiesipsecurityrestrictionssubnetmask) | string | Subnet mask for the range of IP addresses the restriction is valid for. |
| [`subnetTrafficTag`](#parameter-configsname-webpropertiesipsecurityrestrictionssubnettraffictag) | int | (internal) Subnet traffic tag. |
| [`tag`](#parameter-configsname-webpropertiesipsecurityrestrictionstag) | string | Defines what this IP filter will be used for. This is to support IP filtering on proxies. |
| [`vnetSubnetResourceId`](#parameter-configsname-webpropertiesipsecurityrestrictionsvnetsubnetresourceid) | string | Virtual network resource id. |
| [`vnetTrafficTag`](#parameter-configsname-webpropertiesipsecurityrestrictionsvnettraffictag) | int | (internal) Vnet traffic tag. |

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.action`

Allow or Deny access for this IP range.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.description`

IP restriction rule description.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.headers`

IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-webpropertiesipsecurityrestrictionsheaders>any_other_property<) | array | A header. |

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.headers.>Any_other_property<`

A header.

- Required: Yes
- Type: array

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.ipAddress`

IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.name`

IP restriction rule name.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.priority`

Priority of IP restriction rule.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.subnetMask`

Subnet mask for the range of IP addresses the restriction is valid for.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.subnetTrafficTag`

(internal) Subnet traffic tag.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.tag`

Defines what this IP filter will be used for. This is to support IP filtering on proxies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'ServiceTag'
    'XffProxy'
  ]
  ```

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.vnetSubnetResourceId`

Virtual network resource id.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.ipSecurityRestrictions.vnetTrafficTag`

(internal) Vnet traffic tag.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.ipSecurityRestrictionsDefaultAction`

Default action for main access restriction if no rules are matched.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `configs.name-web.properties.javaContainer`

Java container.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.javaContainerVersion`

Java container version.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.javaVersion`

Java version.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.keyVaultReferenceIdentity`

Identity to use for Key Vault Reference authentication.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.limits`

Site limits.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxDiskSizeInMb`](#parameter-configsname-webpropertieslimitsmaxdisksizeinmb) | int | Maximum allowed disk size usage in MB. |
| [`maxMemoryInMb`](#parameter-configsname-webpropertieslimitsmaxmemoryinmb) | int | Maximum allowed memory usage in MB. |
| [`maxPercentageCpu`](#parameter-configsname-webpropertieslimitsmaxpercentagecpu) | int | Maximum allowed CPU usage percentage. |

### Parameter: `configs.name-web.properties.limits.maxDiskSizeInMb`

Maximum allowed disk size usage in MB.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.limits.maxMemoryInMb`

Maximum allowed memory usage in MB.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.limits.maxPercentageCpu`

Maximum allowed CPU usage percentage.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.linuxFxVersion`

Linux App Framework and version.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.loadBalancing`

Site load balancing.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'LeastRequests'
    'LeastRequestsWithTieBreaker'
    'LeastResponseTime'
    'PerSiteRoundRobin'
    'RequestHash'
    'WeightedRoundRobin'
    'WeightedTotalTraffic'
  ]
  ```

### Parameter: `configs.name-web.properties.localMySqlEnabled`

Set to `true` to enable local MySQL.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.logsDirectorySizeLimit`

HTTP logs directory size limit.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.managedPipelineMode`

Managed pipeline mode.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Classic'
    'Integrated'
  ]
  ```

### Parameter: `configs.name-web.properties.managedServiceIdentityId`

Managed Service Identity Id.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.metadata`

Application metadata. This property cannot be retrieved, since it may contain secrets.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-configsname-webpropertiesmetadataname) | string | Pair name. |
| [`value`](#parameter-configsname-webpropertiesmetadatavalue) | string | Pair Value. |

### Parameter: `configs.name-web.properties.metadata.name`

Pair name.

- Required: Yes
- Type: string

### Parameter: `configs.name-web.properties.metadata.value`

Pair Value.

- Required: Yes
- Type: string

### Parameter: `configs.name-web.properties.minimumElasticInstanceCount`

Number of minimum instance count for a site. This setting only applies to the Elastic Plans.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 20

### Parameter: `configs.name-web.properties.minTlsCipherSuite`

The minimum strength TLS cipher suite allowed for an application.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'TLS_AES_128_GCM_SHA256'
    'TLS_AES_256_GCM_SHA384'
    'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
    'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
    'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
    'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
    'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
    'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
    'TLS_RSA_WITH_AES_128_CBC_SHA'
    'TLS_RSA_WITH_AES_128_CBC_SHA256'
    'TLS_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_RSA_WITH_AES_256_CBC_SHA'
    'TLS_RSA_WITH_AES_256_CBC_SHA256'
    'TLS_RSA_WITH_AES_256_GCM_SHA384'
  ]
  ```

### Parameter: `configs.name-web.properties.minTlsVersion`

MinTlsVersion: configures the minimum version of TLS required for SSL requests.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    '1.3'
  ]
  ```

### Parameter: `configs.name-web.properties.netFrameworkVersion`

.NET Framework version.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.nodeVersion`

Version of Node.js.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.numberOfWorkers`

Number of workers.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.phpVersion`

Version of PHP.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.powerShellVersion`

Version of PowerShell.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.preWarmedInstanceCount`

Number of preWarmed instances. This setting only applies to the Consumption and Elastic Plans.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 10

### Parameter: `configs.name-web.properties.publicNetworkAccess`

Property to allow or block all public traffic.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.publishingUsername`

Publishing user name.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.push`

Push endpoint settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-configsname-webpropertiespushkind) | string | Kind of resource. |
| [`properties`](#parameter-configsname-webpropertiespushproperties) | object | PushSettings resource specific properties. |

### Parameter: `configs.name-web.properties.push.kind`

Kind of resource.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.push.properties`

PushSettings resource specific properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isPushEnabled`](#parameter-configsname-webpropertiespushpropertiesispushenabled) | bool | Gets or sets a flag indicating whether the Push endpoint is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamicTagsJson`](#parameter-configsname-webpropertiespushpropertiesdynamictagsjson) | string | Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint. |
| [`tagsRequiringAuth`](#parameter-configsname-webpropertiespushpropertiestagsrequiringauth) | string | Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler. |
| [`tagWhitelistJson`](#parameter-configsname-webpropertiespushpropertiestagwhitelistjson) | string | Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint. |

### Parameter: `configs.name-web.properties.push.properties.isPushEnabled`

Gets or sets a flag indicating whether the Push endpoint is enabled.

- Required: Yes
- Type: bool

### Parameter: `configs.name-web.properties.push.properties.dynamicTagsJson`

Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.push.properties.tagsRequiringAuth`

Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.push.properties.tagWhitelistJson`

Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.pythonVersion`

Version of Python.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.remoteDebuggingEnabled`

Set to `true` if remote debugging is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.remoteDebuggingVersion`

Remote debugging version.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.requestTracingEnabled`

Set to `true` if request tracing is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.requestTracingExpirationTime`

Request tracing expiration time.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions`

IP security restrictions for scm.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsaction) | string | Allow or Deny access for this IP range. |
| [`description`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsdescription) | string | IP restriction rule description. |
| [`headers`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsheaders) | object | IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match. |
| [`ipAddress`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsipaddress) | string | IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified. |
| [`name`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsname) | string | IP restriction rule name. |
| [`priority`](#parameter-configsname-webpropertiesscmipsecurityrestrictionspriority) | int | Priority of IP restriction rule. |
| [`subnetMask`](#parameter-configsname-webpropertiesscmipsecurityrestrictionssubnetmask) | string | Subnet mask for the range of IP addresses the restriction is valid for. |
| [`subnetTrafficTag`](#parameter-configsname-webpropertiesscmipsecurityrestrictionssubnettraffictag) | int | (internal) Subnet traffic tag. |
| [`tag`](#parameter-configsname-webpropertiesscmipsecurityrestrictionstag) | string | Defines what this IP filter will be used for. This is to support IP filtering on proxies. |
| [`vnetSubnetResourceId`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsvnetsubnetresourceid) | string | Virtual network resource id. |
| [`vnetTrafficTag`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsvnettraffictag) | int | (internal) Vnet traffic tag. |

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.action`

Allow or Deny access for this IP range.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.description`

IP restriction rule description.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.headers`

IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-configsname-webpropertiesscmipsecurityrestrictionsheaders>any_other_property<) | array | A header. |

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.headers.>Any_other_property<`

A header.

- Required: Yes
- Type: array

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.ipAddress`

IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.name`

IP restriction rule name.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.priority`

Priority of IP restriction rule.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.subnetMask`

Subnet mask for the range of IP addresses the restriction is valid for.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.subnetTrafficTag`

(internal) Subnet traffic tag.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.tag`

Defines what this IP filter will be used for. This is to support IP filtering on proxies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'ServiceTag'
    'XffProxy'
  ]
  ```

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.vnetSubnetResourceId`

Virtual network resource id.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictions.vnetTrafficTag`

(internal) Vnet traffic tag.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictionsDefaultAction`

Default action for scm access restriction if no rules are matched.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `configs.name-web.properties.scmIpSecurityRestrictionsUseMain`

IP security restrictions for scm to use main.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.scmMinTlsVersion`

ScmMinTlsVersion: configures the minimum version of TLS required for SSL requests for SCM site.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    '1.3'
  ]
  ```

### Parameter: `configs.name-web.properties.scmType`

SCM type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'BitbucketGit'
    'BitbucketHg'
    'CodePlexGit'
    'CodePlexHg'
    'Dropbox'
    'ExternalGit'
    'ExternalHg'
    'GitHub'
    'LocalGit'
    'None'
    'OneDrive'
    'Tfs'
    'VSO'
    'VSTSRM'
  ]
  ```

### Parameter: `configs.name-web.properties.tracingOptions`

Tracing options.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.use32BitWorkerProcess`

Set to `true` to use 32-bit worker process.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.virtualApplications`

Virtual applications.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`physicalPath`](#parameter-configsname-webpropertiesvirtualapplicationsphysicalpath) | string | Physical path. |
| [`preloadEnabled`](#parameter-configsname-webpropertiesvirtualapplicationspreloadenabled) | bool | Set to `true` if preloading is enabled. |
| [`virtualDirectories`](#parameter-configsname-webpropertiesvirtualapplicationsvirtualdirectories) | array | Virtual directories for virtual application. |
| [`virtualPath`](#parameter-configsname-webpropertiesvirtualapplicationsvirtualpath) | string | Virtual path. |

### Parameter: `configs.name-web.properties.virtualApplications.physicalPath`

Physical path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.virtualApplications.preloadEnabled`

Set to `true` if preloading is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.virtualApplications.virtualDirectories`

Virtual directories for virtual application.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`physicalPath`](#parameter-configsname-webpropertiesvirtualapplicationsvirtualdirectoriesphysicalpath) | string | Physical path. |
| [`virtualPath`](#parameter-configsname-webpropertiesvirtualapplicationsvirtualdirectoriesvirtualpath) | string | Path to virtual application. |

### Parameter: `configs.name-web.properties.virtualApplications.virtualDirectories.physicalPath`

Physical path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.virtualApplications.virtualDirectories.virtualPath`

Path to virtual application.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.virtualApplications.virtualPath`

Virtual path.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.vnetName`

Virtual Network name.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.vnetPrivatePortsCount`

The number of private ports assigned to this app. These will be assigned dynamically on runtime.

- Required: No
- Type: int

### Parameter: `configs.name-web.properties.vnetRouteAllEnabled`

Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.websiteTimeZone`

Sets the time zone a site uses for generating timestamps. Compatible with Linux and Windows App Service. Setting the WEBSITE_TIME_ZONE app setting takes precedence over this config. For Linux, expects tz database values https://www.iana.org/time-zones (for a quick reference see [ref](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)). For Windows, expects one of the time zones listed under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.webSocketsEnabled`

Set to `true` if WebSocket is enabled.

- Required: No
- Type: bool

### Parameter: `configs.name-web.properties.windowsFxVersion`

Xenon App Framework and version.

- Required: No
- Type: string

### Parameter: `configs.name-web.properties.xManagedServiceIdentityId`

Explicit Managed Service Identity Id.

- Required: No
- Type: int

### Parameter: `containerSize`

Size of the function container.

- Required: No
- Type: int

### Parameter: `dailyMemoryTimeQuota`

Maximum allowed daily memory-time quota (applicable on dynamic apps only).

- Required: No
- Type: int

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

### Parameter: `dnsConfiguration`

Property to configure various DNS related settings for a site.

- Required: No
- Type: object

### Parameter: `e2eEncryptionEnabled`

End to End Encryption Setting.

- Required: No
- Type: bool

### Parameter: `enabled`

Setting this value to false disables the app (takes the app offline).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extensions`

The extensions configuration.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`properties`](#parameter-extensionsproperties) | object | Sets the properties. |

### Parameter: `extensions.properties`

Sets the properties.

- Required: No
- Type: object

### Parameter: `functionAppConfig`

The Function App configuration object.

- Required: No
- Type: object

### Parameter: `hostNameSslStates`

Hostname SSL states are used to manage the SSL bindings for app's hostnames.

- Required: No
- Type: array

### Parameter: `httpsOnly`

Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hybridConnectionRelays`

Names of hybrid connection relays to connect app with.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hybridConnectionResourceId`](#parameter-hybridconnectionrelayshybridconnectionresourceid) | string | The resource ID of the relay namespace hybrid connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sendKeyName`](#parameter-hybridconnectionrelayssendkeyname) | string | Name of the authorization rule send key to use. |

### Parameter: `hybridConnectionRelays.hybridConnectionResourceId`

The resource ID of the relay namespace hybrid connection.

- Required: Yes
- Type: string

### Parameter: `hybridConnectionRelays.sendKeyName`

Name of the authorization rule send key to use.

- Required: No
- Type: string

### Parameter: `hyperV`

Hyper-V sandbox.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `keyVaultAccessIdentityResourceId`

The resource ID of the assigned identity to be used to access a key vault with.

- Required: No
- Type: string

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

### Parameter: `managedEnvironmentId`

Azure Resource Manager ID of the customers selected Managed Environment on which to host this app.

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

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `redundancyMode`

Site redundancy mode.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'ActiveActive'
    'Failover'
    'GeoRedundant'
    'Manual'
    'None'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'App Compliance Automation Administrator'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Web Plan Contributor'`
  - `'Website Contributor'`

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

### Parameter: `scmSiteAlsoStopped`

Stop SCM (KUDU) site when the app is stopped.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `siteConfig`

The site config object. The defaults are set to the following values: alwaysOn: true, minTlsVersion: '1.2', ftpsState: 'FtpsOnly'.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      alwaysOn: true
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
  }
  ```

### Parameter: `slots`

Configuration for deployment slots for an app.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsname) | string | Name of the slot. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appServiceEnvironmentResourceId`](#parameter-slotsappserviceenvironmentresourceid) | string | The resource ID of the app service environment to use for this resource. |
| [`autoGeneratedDomainNameLabelScope`](#parameter-slotsautogenerateddomainnamelabelscope) | string | Specifies the scope of uniqueness for the default hostname during resource creation. |
| [`basicPublishingCredentialsPolicies`](#parameter-slotsbasicpublishingcredentialspolicies) | array | The site publishing credential policy names which are associated with the site slot. |
| [`clientAffinityEnabled`](#parameter-slotsclientaffinityenabled) | bool | If client affinity is enabled. |
| [`clientCertEnabled`](#parameter-slotsclientcertenabled) | bool | To enable client certificate authentication (TLS mutual authentication). |
| [`clientCertExclusionPaths`](#parameter-slotsclientcertexclusionpaths) | string | Client certificate authentication comma-separated exclusion paths. |
| [`clientCertMode`](#parameter-slotsclientcertmode) | string | This composes with ClientCertEnabled setting.</p>- ClientCertEnabled: false means ClientCert is ignored.</p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.</p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted. |
| [`cloningInfo`](#parameter-slotscloninginfo) | object | If specified during app creation, the app is cloned from a source app. |
| [`configs`](#parameter-slotsconfigs) | array | The web site config. |
| [`containerSize`](#parameter-slotscontainersize) | int | Size of the function container. |
| [`customDomainVerificationId`](#parameter-slotscustomdomainverificationid) | string | Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification. |
| [`dailyMemoryTimeQuota`](#parameter-slotsdailymemorytimequota) | int | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| [`diagnosticSettings`](#parameter-slotsdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsConfiguration`](#parameter-slotsdnsconfiguration) | object | Property to configure various DNS related settings for a site. |
| [`enabled`](#parameter-slotsenabled) | bool | Setting this value to false disables the app (takes the app offline). |
| [`extensions`](#parameter-slotsextensions) | array | The extensions configuration. |
| [`functionAppConfig`](#parameter-slotsfunctionappconfig) | object | The Function App config object. |
| [`hostNameSslStates`](#parameter-slotshostnamesslstates) | array | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| [`httpsOnly`](#parameter-slotshttpsonly) | bool | Configures a slot to accept only HTTPS requests. Issues redirect for HTTP requests. |
| [`hybridConnectionRelays`](#parameter-slotshybridconnectionrelays) | array | Names of hybrid connection relays to connect app with. |
| [`hyperV`](#parameter-slotshyperv) | bool | Hyper-V sandbox. |
| [`keyVaultAccessIdentityResourceId`](#parameter-slotskeyvaultaccessidentityresourceid) | string | The resource ID of the assigned identity to be used to access a key vault with. |
| [`location`](#parameter-slotslocation) | string | Location for all Resources. |
| [`lock`](#parameter-slotslock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-slotsmanagedidentities) | object | The managed identity definition for this resource. |
| [`privateEndpoints`](#parameter-slotsprivateendpoints) | array | Configuration details for private endpoints. |
| [`publicNetworkAccess`](#parameter-slotspublicnetworkaccess) | string | Allow or block all public traffic. |
| [`redundancyMode`](#parameter-slotsredundancymode) | string | Site redundancy mode. |
| [`roleAssignments`](#parameter-slotsroleassignments) | array | Array of role assignments to create. |
| [`serverFarmResourceId`](#parameter-slotsserverfarmresourceid) | string | The resource ID of the app service plan to use for the slot. |
| [`siteConfig`](#parameter-slotssiteconfig) | object | The site config object. |
| [`storageAccountRequired`](#parameter-slotsstorageaccountrequired) | bool | Checks if Customer provided storage account is required. |
| [`tags`](#parameter-slotstags) | object | Tags of the resource. |
| [`virtualNetworkSubnetId`](#parameter-slotsvirtualnetworksubnetid) | string | Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}. |
| [`vnetContentShareEnabled`](#parameter-slotsvnetcontentshareenabled) | bool | To enable accessing content over virtual network. |
| [`vnetImagePullEnabled`](#parameter-slotsvnetimagepullenabled) | bool | To enable pulling image over Virtual Network. |
| [`vnetRouteAllEnabled`](#parameter-slotsvnetrouteallenabled) | bool | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |

### Parameter: `slots.name`

Name of the slot.

- Required: Yes
- Type: string

### Parameter: `slots.appServiceEnvironmentResourceId`

The resource ID of the app service environment to use for this resource.

- Required: No
- Type: string

### Parameter: `slots.autoGeneratedDomainNameLabelScope`

Specifies the scope of uniqueness for the default hostname during resource creation.

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

### Parameter: `slots.basicPublishingCredentialsPolicies`

The site publishing credential policy names which are associated with the site slot.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsbasicpublishingcredentialspoliciesname) | string | The name of the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allow`](#parameter-slotsbasicpublishingcredentialspoliciesallow) | bool | Set to true to enable or false to disable a publishing method. |
| [`location`](#parameter-slotsbasicpublishingcredentialspolicieslocation) | string | Location for all Resources. |

### Parameter: `slots.basicPublishingCredentialsPolicies.name`

The name of the resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ftp'
    'scm'
  ]
  ```

### Parameter: `slots.basicPublishingCredentialsPolicies.allow`

Set to true to enable or false to disable a publishing method.

- Required: No
- Type: bool

### Parameter: `slots.basicPublishingCredentialsPolicies.location`

Location for all Resources.

- Required: No
- Type: string

### Parameter: `slots.clientAffinityEnabled`

If client affinity is enabled.

- Required: No
- Type: bool

### Parameter: `slots.clientCertEnabled`

To enable client certificate authentication (TLS mutual authentication).

- Required: No
- Type: bool

### Parameter: `slots.clientCertExclusionPaths`

Client certificate authentication comma-separated exclusion paths.

- Required: No
- Type: string

### Parameter: `slots.clientCertMode`

This composes with ClientCertEnabled setting.</p>- ClientCertEnabled: false means ClientCert is ignored.</p>- ClientCertEnabled: true and ClientCertMode: Required means ClientCert is required.</p>- ClientCertEnabled: true and ClientCertMode: Optional means ClientCert is optional or accepted.

- Required: No
- Type: string

### Parameter: `slots.cloningInfo`

If specified during app creation, the app is cloned from a source app.

- Required: No
- Type: object

### Parameter: `slots.configs`

The web site config.

- Required: No
- Type: array
- Discriminator: `name`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`appsettings`](#variant-slotsconfigsname-appsettings) | The type of an app settings configuration. |
| [`authsettings`](#variant-slotsconfigsname-authsettings) | The type of an auth settings configuration. |
| [`authsettingsV2`](#variant-slotsconfigsname-authsettingsv2) | The type of an authSettingsV2 configuration. |
| [`azurestorageaccounts`](#variant-slotsconfigsname-azurestorageaccounts) | The type of an Azure Storage Account configuration. |
| [`backup`](#variant-slotsconfigsname-backup) | The type for a backup configuration. |
| [`connectionstrings`](#variant-slotsconfigsname-connectionstrings) | The type for a connection string configuration. |
| [`logs`](#variant-slotsconfigsname-logs) | The type of a logs configuration. |
| [`metadata`](#variant-slotsconfigsname-metadata) | The type of a metadata configuration. |
| [`pushsettings`](#variant-slotsconfigsname-pushsettings) | The type of a pushSettings configuration. |
| [`slotConfigNames`](#variant-slotsconfigsname-slotconfignames) | The type of a slotConfigNames configuration. |
| [`web`](#variant-slotsconfigsname-web) | The type of a web configuration. |

### Variant: `slots.configs.name-appsettings`
The type of an app settings configuration.

To use this variant, set the property `name` to `appsettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-appsettingsname) | string | The type of config. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightResourceId`](#parameter-slotsconfigsname-appsettingsapplicationinsightresourceid) | string | Resource ID of the application insight to leverage for this resource. |
| [`properties`](#parameter-slotsconfigsname-appsettingsproperties) | object | The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| [`retainCurrentAppSettings`](#parameter-slotsconfigsname-appsettingsretaincurrentappsettings) | bool | The retain the current app settings. Defaults to true. |
| [`storageAccountResourceId`](#parameter-slotsconfigsname-appsettingsstorageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| [`storageAccountUseIdentityAuthentication`](#parameter-slotsconfigsname-appsettingsstorageaccountuseidentityauthentication) | bool | If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'. |

### Parameter: `slots.configs.name-appsettings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'appsettings'
  ]
  ```

### Parameter: `slots.configs.name-appsettings.applicationInsightResourceId`

Resource ID of the application insight to leverage for this resource.

- Required: No
- Type: string

### Parameter: `slots.configs.name-appsettings.properties`

The app settings key-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-appsettingsproperties>any_other_property<) | string | An app settings key-value pair. |

### Parameter: `slots.configs.name-appsettings.properties.>Any_other_property<`

An app settings key-value pair.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-appsettings.retainCurrentAppSettings`

The retain the current app settings. Defaults to true.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-appsettings.storageAccountResourceId`

Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.

- Required: No
- Type: string

### Parameter: `slots.configs.name-appsettings.storageAccountUseIdentityAuthentication`

If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'.

- Required: No
- Type: bool

### Variant: `slots.configs.name-authsettings`
The type of an auth settings configuration.

To use this variant, set the property `name` to `authsettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-authsettingsname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-authsettingsproperties) | object | The config settings. |

### Parameter: `slots.configs.name-authsettings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'authsettings'
  ]
  ```

### Parameter: `slots.configs.name-authsettings.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadClaimsAuthorization`](#parameter-slotsconfigsname-authsettingspropertiesaadclaimsauthorization) | string | Gets a JSON string containing the Azure AD Acl settings. |
| [`additionalLoginParams`](#parameter-slotsconfigsname-authsettingspropertiesadditionalloginparams) | array | Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value". |
| [`allowedAudiences`](#parameter-slotsconfigsname-authsettingspropertiesallowedaudiences) | array | Allowed audience values to consider when validating JSON Web Tokens issued by Azure Active Directory. Note that the `ClientID` value is always considered an allowed audience, regardless of this setting. |
| [`allowedExternalRedirectUrls`](#parameter-slotsconfigsname-authsettingspropertiesallowedexternalredirecturls) | array | External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed. |
| [`authFilePath`](#parameter-slotsconfigsname-authsettingspropertiesauthfilepath) | string | The path of the config file containing auth settings. If the path is relative, base will the site's root directory. |
| [`clientId`](#parameter-slotsconfigsname-authsettingspropertiesclientid) | string | The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html). |
| [`clientSecret`](#parameter-slotsconfigsname-authsettingspropertiesclientsecret) | securestring | The Client Secret of this relying party application (in Azure Active Directory, this is also referred to as the Key). This setting is optional. If no client secret is configured, the OpenID Connect implicit auth flow is used to authenticate end users. Otherwise, the OpenID Connect Authorization Code Flow is used to authenticate end users. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html). |
| [`clientSecretCertificateThumbprint`](#parameter-slotsconfigsname-authsettingspropertiesclientsecretcertificatethumbprint) | string | An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret. |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingspropertiesclientsecretsettingname) | string | The app setting name that contains the client secret of the relying party application. |
| [`configVersion`](#parameter-slotsconfigsname-authsettingspropertiesconfigversion) | string | The ConfigVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of the control plane for Authentication / Authorization. |
| [`defaultProvider`](#parameter-slotsconfigsname-authsettingspropertiesdefaultprovider) | string | The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage". |
| [`enabled`](#parameter-slotsconfigsname-authsettingspropertiesenabled) | bool | Set to `true` if the Authentication / Authorization feature is enabled for the current app. |
| [`facebookAppId`](#parameter-slotsconfigsname-authsettingspropertiesfacebookappid) | string | The App ID of the Facebook app used for login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login). |
| [`facebookAppSecret`](#parameter-slotsconfigsname-authsettingspropertiesfacebookappsecret) | securestring | The App Secret of the Facebook app used for Facebook Login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login). |
| [`facebookAppSecretSettingName`](#parameter-slotsconfigsname-authsettingspropertiesfacebookappsecretsettingname) | string | The app setting name that contains the app secret used for Facebook Login. |
| [`facebookOAuthScopes`](#parameter-slotsconfigsname-authsettingspropertiesfacebookoauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication. This setting is optional. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login). |
| [`gitHubClientId`](#parameter-slotsconfigsname-authsettingspropertiesgithubclientid) | string | The Client Id of the GitHub app used for login. This setting is required for enabling Github login. |
| [`gitHubClientSecret`](#parameter-slotsconfigsname-authsettingspropertiesgithubclientsecret) | securestring | The Client Secret of the GitHub app used for Github Login. This setting is required for enabling Github login. |
| [`gitHubClientSecretSettingName`](#parameter-slotsconfigsname-authsettingspropertiesgithubclientsecretsettingname) | string | The app setting name that contains the client secret of the Github app used for GitHub Login. |
| [`gitHubOAuthScopes`](#parameter-slotsconfigsname-authsettingspropertiesgithuboauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of GitHub Login authentication. |
| [`googleClientId`](#parameter-slotsconfigsname-authsettingspropertiesgoogleclientid) | string | The OpenID Connect Client ID for the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web). |
| [`googleClientSecret`](#parameter-slotsconfigsname-authsettingspropertiesgoogleclientsecret) | securestring | The client secret associated with the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web). |
| [`googleClientSecretSettingName`](#parameter-slotsconfigsname-authsettingspropertiesgoogleclientsecretsettingname) | string | The app setting name that contains the client secret associated with the Google web application. |
| [`googleOAuthScopes`](#parameter-slotsconfigsname-authsettingspropertiesgoogleoauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication. This setting is optional. If not specified, "openid", "profile", and "email" are used as default scopes. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web). |
| [`isAuthFromFile`](#parameter-slotsconfigsname-authsettingspropertiesisauthfromfile) | string | "true" if the auth config settings should be read from a file, "false" otherwise. |
| [`issuer`](#parameter-slotsconfigsname-authsettingspropertiesissuer) | string | The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html). |
| [`microsoftAccountClientId`](#parameter-slotsconfigsname-authsettingspropertiesmicrosoftaccountclientid) | string | The OAuth 2.0 client ID that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm). |
| [`microsoftAccountClientSecret`](#parameter-slotsconfigsname-authsettingspropertiesmicrosoftaccountclientsecret) | securestring | The OAuth 2.0 client secret that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm). |
| [`microsoftAccountClientSecretSettingName`](#parameter-slotsconfigsname-authsettingspropertiesmicrosoftaccountclientsecretsettingname) | string | The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication. |
| [`microsoftAccountOAuthScopes`](#parameter-slotsconfigsname-authsettingspropertiesmicrosoftaccountoauthscopes) | array | The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. This setting is optional. If not specified, "wl.basic" is used as the default scope. Microsoft Account Scopes and permissions [documentation](https://msdn.microsoft.com/en-us/library/dn631845.aspx). |
| [`runtimeVersion`](#parameter-slotsconfigsname-authsettingspropertiesruntimeversion) | string | The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module. |
| [`tokenRefreshExtensionHours`](#parameter-slotsconfigsname-authsettingspropertiestokenrefreshextensionhours) | int | The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours. |
| [`tokenStoreEnabled`](#parameter-slotsconfigsname-authsettingspropertiestokenstoreenabled) | bool | Set to `true` to durably store platform-specific security tokens that are obtained during login flows. The default is `false`. |
| [`twitterConsumerKey`](#parameter-slotsconfigsname-authsettingspropertiestwitterconsumerkey) | securestring | The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in). |
| [`twitterConsumerSecret`](#parameter-slotsconfigsname-authsettingspropertiestwitterconsumersecret) | securestring | The OAuth 1.0a consumer secret of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in). |
| [`twitterConsumerSecretSettingName`](#parameter-slotsconfigsname-authsettingspropertiestwitterconsumersecretsettingname) | string | The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in. |
| [`unauthenticatedClientAction`](#parameter-slotsconfigsname-authsettingspropertiesunauthenticatedclientaction) | string | The action to take when an unauthenticated client attempts to access the app. |
| [`validateIssuer`](#parameter-slotsconfigsname-authsettingspropertiesvalidateissuer) | bool | Gets a value indicating whether the issuer should be a valid HTTPS url and be validated as such. |

### Parameter: `slots.configs.name-authsettings.properties.aadClaimsAuthorization`

Gets a JSON string containing the Azure AD Acl settings.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.additionalLoginParams`

Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.allowedAudiences`

Allowed audience values to consider when validating JSON Web Tokens issued by Azure Active Directory. Note that the `ClientID` value is always considered an allowed audience, regardless of this setting.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.allowedExternalRedirectUrls`

External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.authFilePath`

The path of the config file containing auth settings. If the path is relative, base will the site's root directory.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.clientId`

The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.clientSecret`

The Client Secret of this relying party application (in Azure Active Directory, this is also referred to as the Key). This setting is optional. If no client secret is configured, the OpenID Connect implicit auth flow is used to authenticate end users. Otherwise, the OpenID Connect Authorization Code Flow is used to authenticate end users. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.clientSecretCertificateThumbprint`

An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.clientSecretSettingName`

The app setting name that contains the client secret of the relying party application.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.configVersion`

The ConfigVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of the control plane for Authentication / Authorization.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.defaultProvider`

The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureActiveDirectory'
    'Facebook'
    'Github'
    'Google'
    'MicrosoftAccount'
    'Twitter'
  ]
  ```

### Parameter: `slots.configs.name-authsettings.properties.enabled`

Set to `true` if the Authentication / Authorization feature is enabled for the current app.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettings.properties.facebookAppId`

The App ID of the Facebook app used for login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.facebookAppSecret`

The App Secret of the Facebook app used for Facebook Login. This setting is required for enabling Facebook Login. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.facebookAppSecretSettingName`

The app setting name that contains the app secret used for Facebook Login.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.facebookOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of Facebook Login authentication. This setting is optional. Facebook Login [documentation](https://developers.facebook.com/docs/facebook-login).

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.gitHubClientId`

The Client Id of the GitHub app used for login. This setting is required for enabling Github login.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.gitHubClientSecret`

The Client Secret of the GitHub app used for Github Login. This setting is required for enabling Github login.

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.gitHubClientSecretSettingName`

The app setting name that contains the client secret of the Github app used for GitHub Login.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.gitHubOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of GitHub Login authentication.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.googleClientId`

The OpenID Connect Client ID for the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.googleClientSecret`

The client secret associated with the Google web application. This setting is required for enabling Google Sign-In. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.googleClientSecretSettingName`

The app setting name that contains the client secret associated with the Google web application.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.googleOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of Google Sign-In authentication. This setting is optional. If not specified, "openid", "profile", and "email" are used as default scopes. Google Sign-In [documentation](https://developers.google.com/identity/sign-in/web).

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.isAuthFromFile`

"true" if the auth config settings should be read from a file, "false" otherwise.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `slots.configs.name-authsettings.properties.issuer`

The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://sts.windows.net/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html).

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.microsoftAccountClientId`

The OAuth 2.0 client ID that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm).

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.microsoftAccountClientSecret`

The OAuth 2.0 client secret that was created for the app used for authentication. This setting is required for enabling Microsoft Account authentication. Microsoft Account OAuth [documentation](https://dev.onedrive.com/auth/msa_oauth.htm).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.microsoftAccountClientSecretSettingName`

The app setting name containing the OAuth 2.0 client secret that was created for the app used for authentication.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.microsoftAccountOAuthScopes`

The OAuth 2.0 scopes that will be requested as part of Microsoft Account authentication. This setting is optional. If not specified, "wl.basic" is used as the default scope. Microsoft Account Scopes and permissions [documentation](https://msdn.microsoft.com/en-us/library/dn631845.aspx).

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettings.properties.runtimeVersion`

The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.tokenRefreshExtensionHours`

The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours.

- Required: No
- Type: int

### Parameter: `slots.configs.name-authsettings.properties.tokenStoreEnabled`

Set to `true` to durably store platform-specific security tokens that are obtained during login flows. The default is `false`.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettings.properties.twitterConsumerKey`

The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.twitterConsumerSecret`

The OAuth 1.0a consumer secret of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettings.properties.twitterConsumerSecretSettingName`

The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettings.properties.unauthenticatedClientAction`

The action to take when an unauthenticated client attempts to access the app.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowAnonymous'
    'RedirectToLoginPage'
  ]
  ```

### Parameter: `slots.configs.name-authsettings.properties.validateIssuer`

Gets a value indicating whether the issuer should be a valid HTTPS url and be validated as such.

- Required: No
- Type: bool

### Variant: `slots.configs.name-authsettingsV2`
The type of an authSettingsV2 configuration.

To use this variant, set the property `name` to `authsettingsV2`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-authsettingsv2name) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-authsettingsv2properties) | object | The config settings. |

### Parameter: `slots.configs.name-authsettingsV2.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'authsettingsV2'
  ]
  ```

### Parameter: `slots.configs.name-authsettingsV2.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`globalValidation`](#parameter-slotsconfigsname-authsettingsv2propertiesglobalvalidation) | object | The configuration settings that determines the validation flow of users using App Service Authentication/Authorization. |
| [`httpSettings`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettings) | object | The configuration settings of the HTTP requests for authentication and authorization requests made against App Service Authentication/Authorization. |
| [`identityProviders`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviders) | object | The configuration settings of each of the identity providers used to configure App Service Authentication/Authorization. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertieslogin) | object | The configuration settings of the login flow of users using App Service Authentication/Authorization. |
| [`platform`](#parameter-slotsconfigsname-authsettingsv2propertiesplatform) | object | The configuration settings of the platform of App Service Authentication/Authorization. |

### Parameter: `slots.configs.name-authsettingsV2.properties.globalValidation`

The configuration settings that determines the validation flow of users using App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`excludedPaths`](#parameter-slotsconfigsname-authsettingsv2propertiesglobalvalidationexcludedpaths) | array | The paths for which unauthenticated flow would not be redirected to the login page. |
| [`redirectToProvider`](#parameter-slotsconfigsname-authsettingsv2propertiesglobalvalidationredirecttoprovider) | string | The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage". |
| [`requireAuthentication`](#parameter-slotsconfigsname-authsettingsv2propertiesglobalvalidationrequireauthentication) | bool | Set to `true` if the authentication flow is required by every request. |
| [`unauthenticatedClientAction`](#parameter-slotsconfigsname-authsettingsv2propertiesglobalvalidationunauthenticatedclientaction) | string | The action to take when an unauthenticated client attempts to access the app. |

### Parameter: `slots.configs.name-authsettingsV2.properties.globalValidation.excludedPaths`

The paths for which unauthenticated flow would not be redirected to the login page.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.globalValidation.redirectToProvider`

The default authentication provider to use when multiple providers are configured. This setting is only needed if multiple providers are configured and the unauthenticated client action is set to "RedirectToLoginPage".

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.globalValidation.requireAuthentication`

Set to `true` if the authentication flow is required by every request.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.globalValidation.unauthenticatedClientAction`

The action to take when an unauthenticated client attempts to access the app.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowAnonymous'
    'RedirectToLoginPage'
    'Return401'
    'Return403'
  ]
  ```

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings`

The configuration settings of the HTTP requests for authentication and authorization requests made against App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`forwardProxy`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsforwardproxy) | object | The configuration settings of a forward proxy used to make the requests. |
| [`requireHttps`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsrequirehttps) | bool | Set to `false` if the authentication/authorization responses not having the HTTPS scheme are permissible. |
| [`routes`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsroutes) | object | The configuration settings of the paths HTTP requests. |

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.forwardProxy`

The configuration settings of a forward proxy used to make the requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`convention`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsforwardproxyconvention) | string | The convention used to determine the url of the request made. |
| [`customHostHeaderName`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsforwardproxycustomhostheadername) | string | The name of the header containing the host of the request. |
| [`customProtoHeaderName`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsforwardproxycustomprotoheadername) | string | The name of the header containing the scheme of the request. |

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.forwardProxy.convention`

The convention used to determine the url of the request made.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Custom'
    'NoProxy'
    'Standard'
  ]
  ```

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.forwardProxy.customHostHeaderName`

The name of the header containing the host of the request.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.forwardProxy.customProtoHeaderName`

The name of the header containing the scheme of the request.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.requireHttps`

Set to `false` if the authentication/authorization responses not having the HTTPS scheme are permissible.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.routes`

The configuration settings of the paths HTTP requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiPrefix`](#parameter-slotsconfigsname-authsettingsv2propertieshttpsettingsroutesapiprefix) | string | The prefix that should precede all the authentication/authorization paths. |

### Parameter: `slots.configs.name-authsettingsV2.properties.httpSettings.routes.apiPrefix`

The prefix that should precede all the authentication/authorization paths.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders`

The configuration settings of each of the identity providers used to configure App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apple`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersapple) | object | The configuration settings of the Apple provider. |
| [`azureActiveDirectory`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectory) | object | The configuration settings of the Azure Active directory provider. |
| [`azureStaticWebApps`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazurestaticwebapps) | object | The configuration settings of the Azure Static Web Apps provider. |
| [`customOpenIdConnectProviders`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders) | object | The map of the name of the alias of each custom Open ID Connect provider to the configuration settings of the custom Open ID Connect provider. |
| [`facebook`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebook) | object | The configuration settings of the Facebook provider. |
| [`gitHub`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithub) | object | The configuration settings of the GitHub provider. |
| [`google`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgoogle) | object | The configuration settings of the Google provider. |
| [`legacyMicrosoftAccount`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccount) | object | The configuration settings of the legacy Microsoft Account provider. |
| [`twitter`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderstwitter) | object | The configuration settings of the Twitter provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple`

The configuration settings of the Apple provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersappleenabled) | bool | Set to `false` if the Apple provider should not be enabled despite the set registration. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersapplelogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersappleregistration) | object | The configuration settings of the Apple registration. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple.enabled`

Set to `false` if the Apple provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersappleloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple.registration`

The configuration settings of the Apple registration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersappleregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersappleregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.apple.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory`

The configuration settings of the Azure Active directory provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryenabled) | bool | Set to `false` if the Azure Active Directory provider should not be enabled despite the set registration. |
| [`isAutoProvisioned`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryisautoprovisioned) | bool | Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling. This is an internal flag primarily intended to support the Azure Management Portal. Users should not read or write to this property. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectorylogin) | object | The configuration settings of the Azure Active Directory login flow. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistration) | object | The configuration settings of the Azure Active Directory app registration. |
| [`validation`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidation) | object | The configuration settings of the Azure Active Directory token validation flow. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.enabled`

Set to `false` if the Azure Active Directory provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.isAutoProvisioned`

Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling. This is an internal flag primarily intended to support the Azure Management Portal. Users should not read or write to this property.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.login`

The configuration settings of the Azure Active Directory login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disableWWWAuthenticate`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectorylogindisablewwwauthenticate) | bool | Set to `true` if the www-authenticate provider should be omitted from the request. |
| [`loginParameters`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryloginloginparameters) | array | Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value". |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.login.disableWWWAuthenticate`

Set to `true` if the www-authenticate provider should be omitted from the request.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.login.loginParameters`

Login parameters to send to the OpenID Connect authorization endpoint when a user logs in. Each parameter must be in the form "key=value".

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration`

The configuration settings of the Azure Active Directory app registration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientid) | string | The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientSecretCertificateIssuer`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretcertificateissuer) | string | An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint. |
| [`clientSecretCertificateSubjectAlternativeName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretcertificatesubjectalternativename) | string | An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint. |
| [`clientSecretCertificateThumbprint`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretcertificatethumbprint) | string | An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret. |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationclientsecretsettingname) | string | The app setting name that contains the client secret of the relying party application. |
| [`openIdIssuer`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryregistrationopenidissuer) | string | The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html). |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientId`

The Client ID of this relying party application, known as the client_id. This setting is required for enabling OpenID Connection authentication with Azure Active Directory or other 3rd party OpenID Connect providers. More information on [OpenID Connect](http://openid.net/specs/openid-connect-core-1_0.html).

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretCertificateIssuer`

An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretCertificateSubjectAlternativeName`

An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as a replacement for the Client Secret Certificate Thumbprint.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretCertificateThumbprint`

An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as a replacement for the Client Secret.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.clientSecretSettingName`

The app setting name that contains the client secret of the relying party application.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.registration.openIdIssuer`

The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application. When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/. This URI is a case-sensitive identifier for the token issuer. More information on [OpenID Connect Discovery](http://openid.net/specs/openid-connect-discovery-1_0.html).

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation`

The configuration settings of the Azure Active Directory token validation flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAudiences`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationallowedaudiences) | array | The list of audiences that can make successful authentication/authorization requests. |
| [`defaultAuthorizationPolicy`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicy) | object | The configuration settings of the default authorization policy. |
| [`jwtClaimChecks`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationjwtclaimchecks) | object | The configuration settings of the checks that should be made while validating the JWT Claims. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.allowedAudiences`

The list of audiences that can make successful authentication/authorization requests.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy`

The configuration settings of the default authorization policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedApplications`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedapplications) | array | The configuration settings of the Azure Active Directory allowed applications. |
| [`allowedPrincipals`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedprincipals) | object | The configuration settings of the Azure Active Directory allowed principals. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedApplications`

The configuration settings of the Azure Active Directory allowed applications.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedPrincipals`

The configuration settings of the Azure Active Directory allowed principals.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groups`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedprincipalsgroups) | array | The list of the allowed groups. |
| [`identities`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationdefaultauthorizationpolicyallowedprincipalsidentities) | array | The list of the allowed identities. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedPrincipals.groups`

The list of the allowed groups.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.defaultAuthorizationPolicy.allowedPrincipals.identities`

The list of the allowed identities.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.jwtClaimChecks`

The configuration settings of the checks that should be made while validating the JWT Claims.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedClientApplications`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationjwtclaimchecksallowedclientapplications) | array | The list of the allowed client applications. |
| [`allowedGroups`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazureactivedirectoryvalidationjwtclaimchecksallowedgroups) | array | The list of the allowed groups. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.jwtClaimChecks.allowedClientApplications`

The list of the allowed client applications.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureActiveDirectory.validation.jwtClaimChecks.allowedGroups`

The list of the allowed groups.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps`

The configuration settings of the Azure Static Web Apps provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazurestaticwebappsenabled) | bool | Set to `false` if the Azure Static Web Apps provider should not be enabled despite the set registration. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazurestaticwebappsregistration) | object | The configuration settings of the Azure Static Web Apps registration. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps.enabled`

Set to `false` if the Azure Static Web Apps provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps.registration`

The configuration settings of the Azure Static Web Apps registration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersazurestaticwebappsregistrationclientid) | string | The Client ID of the app used for login. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.azureStaticWebApps.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders`

The map of the name of the alias of each custom Open ID Connect provider to the configuration settings of the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<) | object | The alias of each custom Open ID Connect provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<`

The alias of each custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<enabled) | bool | Set to `false` if the custom Open ID provider provider should not be enabled. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<login) | object | The configuration settings of the login flow of the custom Open ID Connect provider. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registration) | object | The configuration settings of the app registration for the custom Open ID Connect provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.enabled`

Set to `false` if the custom Open ID provider provider should not be enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.login`

The configuration settings of the login flow of the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nameClaimType`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<loginnameclaimtype) | string | The name of the claim that contains the users name. |
| [`scopes`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<loginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.login.nameClaimType`

The name of the claim that contains the users name.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration`

The configuration settings of the app registration for the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientCredential`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientcredential) | object | The authentication credentials of the custom Open ID Connect provider. |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientid) | string | The client id of the custom Open ID Connect provider. |
| [`openIdConnectConfiguration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfiguration) | object | The configuration settings of the endpoints used for the custom Open ID Connect provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientCredential`

The authentication credentials of the custom Open ID Connect provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientcredentialclientsecretsettingname) | string | The app setting that contains the client secret for the custom Open ID Connect provider. |
| [`method`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationclientcredentialmethod) | string | The method that should be used to authenticate the user. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientCredential.clientSecretSettingName`

The app setting that contains the client secret for the custom Open ID Connect provider.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientCredential.method`

The method that should be used to authenticate the user.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ClientSecretPost'
  ]
  ```

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.clientId`

The client id of the custom Open ID Connect provider.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration`

The configuration settings of the endpoints used for the custom Open ID Connect provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationEndpoint`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationauthorizationendpoint) | string | The endpoint to be used to make an authorization request. |
| [`certificationUri`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationcertificationuri) | string | The endpoint that provides the keys necessary to validate the token. |
| [`issuer`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationissuer) | string | The endpoint that issues the token. |
| [`tokenEndpoint`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationtokenendpoint) | string | The endpoint to be used to request a token. |
| [`wellKnownOpenIdConfiguration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderscustomopenidconnectproviders>any_other_property<registrationopenidconnectconfigurationwellknownopenidconfiguration) | string | The endpoint that contains all the configuration endpoints for the provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.authorizationEndpoint`

The endpoint to be used to make an authorization request.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.certificationUri`

The endpoint that provides the keys necessary to validate the token.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.issuer`

The endpoint that issues the token.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.tokenEndpoint`

The endpoint to be used to request a token.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.customOpenIdConnectProviders.>Any_other_property<.registration.openIdConnectConfiguration.wellKnownOpenIdConfiguration`

The endpoint that contains all the configuration endpoints for the provider.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook`

The configuration settings of the Facebook provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebookenabled) | bool | Set to `false` if the Facebook provider should not be enabled despite the set registration. |
| [`graphApiVersion`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebookgraphapiversion) | string | The version of the Facebook api to be used while logging in. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebooklogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebookregistration) | object | The configuration settings of the app registration for the Facebook provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.enabled`

Set to `false` if the Facebook provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.graphApiVersion`

The version of the Facebook api to be used while logging in.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebookloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.registration`

The configuration settings of the app registration for the Facebook provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebookregistrationappid) | string | The App ID of the app used for login. |
| [`appSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersfacebookregistrationappsecretsettingname) | string | The app setting name that contains the app secret. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.registration.appId`

The App ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.facebook.registration.appSecretSettingName`

The app setting name that contains the app secret.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub`

The configuration settings of the GitHub provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithubenabled) | bool | Set to `false` if the GitHub provider should not be enabled despite the set registration. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithublogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithubregistration) | object | The configuration settings of the app registration for the GitHub provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub.enabled`

Set to `false` if the GitHub provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithubloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub.registration`

The configuration settings of the app registration for the GitHub provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithubregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgithubregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.gitHub.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google`

The configuration settings of the Google provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgoogleenabled) | bool | Set to `false` if the Google provider should not be enabled despite the set registration. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgooglelogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgoogleregistration) | object | The configuration settings of the app registration for the Google provider. |
| [`validation`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgooglevalidation) | object | The configuration settings of the Azure Active Directory token validation flow. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.enabled`

Set to `false` if the Google provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgoogleloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.registration`

The configuration settings of the app registration for the Google provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgoogleregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgoogleregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.validation`

The configuration settings of the Azure Active Directory token validation flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAudiences`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityprovidersgooglevalidationallowedaudiences) | array | The configuration settings of the allowed list of audiences from which to validate the JWT token. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.google.validation.allowedAudiences`

The configuration settings of the allowed list of audiences from which to validate the JWT token.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount`

The configuration settings of the legacy Microsoft Account provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountenabled) | bool | Set to `false` if the legacy Microsoft Account provider should not be enabled despite the set registration. |
| [`login`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountlogin) | object | The configuration settings of the login flow. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountregistration) | object | The configuration settings of the app registration for the legacy Microsoft Account provider. |
| [`validation`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountvalidation) | object | The configuration settings of the legacy Microsoft Account provider token validation flow. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.enabled`

Set to `false` if the legacy Microsoft Account provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.login`

The configuration settings of the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`scopes`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountloginscopes) | array | A list of the scopes that should be requested while authenticating. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.login.scopes`

A list of the scopes that should be requested while authenticating.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.registration`

The configuration settings of the app registration for the legacy Microsoft Account provider.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountregistrationclientid) | string | The Client ID of the app used for login. |
| [`clientSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountregistrationclientsecretsettingname) | string | The app setting name that contains the client secret. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.registration.clientId`

The Client ID of the app used for login.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.registration.clientSecretSettingName`

The app setting name that contains the client secret.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.validation`

The configuration settings of the legacy Microsoft Account provider token validation flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedAudiences`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderslegacymicrosoftaccountvalidationallowedaudiences) | array | The configuration settings of the allowed list of audiences from which to validate the JWT token. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.legacyMicrosoftAccount.validation.allowedAudiences`

The configuration settings of the allowed list of audiences from which to validate the JWT token.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.twitter`

The configuration settings of the Twitter provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderstwitterenabled) | bool | Set to `false` if the Twitter provider should not be enabled despite the set registration. |
| [`registration`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderstwitterregistration) | object | The configuration settings of the app registration for the Twitter provider. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.twitter.enabled`

Set to `false` if the Twitter provider should not be enabled despite the set registration.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.twitter.registration`

The configuration settings of the app registration for the Twitter provider.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`consumerKey`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderstwitterregistrationconsumerkey) | securestring | The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in). |
| [`consumerSecretSettingName`](#parameter-slotsconfigsname-authsettingsv2propertiesidentityproviderstwitterregistrationconsumersecretsettingname) | string | The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in. |

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.twitter.registration.consumerKey`

The OAuth 1.0a consumer key of the Twitter application used for sign-in. This setting is required for enabling Twitter Sign-In. Twitter Sign-In [documentation](https://dev.twitter.com/web/sign-in).

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-authsettingsV2.properties.identityProviders.twitter.registration.consumerSecretSettingName`

The app setting name that contains the OAuth 1.0a consumer secret of the Twitter application used for sign-in.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.login`

The configuration settings of the login flow of users using App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedExternalRedirectUrls`](#parameter-slotsconfigsname-authsettingsv2propertiesloginallowedexternalredirecturls) | array | External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed. |
| [`cookieExpiration`](#parameter-slotsconfigsname-authsettingsv2propertieslogincookieexpiration) | object | The configuration settings of the session cookie's expiration. |
| [`nonce`](#parameter-slotsconfigsname-authsettingsv2propertiesloginnonce) | object | The configuration settings of the nonce used in the login flow. |
| [`preserveUrlFragmentsForLogins`](#parameter-slotsconfigsname-authsettingsv2propertiesloginpreserveurlfragmentsforlogins) | bool | Set to `true` if the fragments from the request are preserved after the login request is made. |
| [`routes`](#parameter-slotsconfigsname-authsettingsv2propertiesloginroutes) | object | The routes that specify the endpoints used for login and logout requests. |
| [`tokenStore`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstore) | object | The configuration settings of the token store. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.allowedExternalRedirectUrls`

External URLs that can be redirected to as part of logging in or logging out of the app. Note that the query string part of the URL is ignored. This is an advanced setting typically only needed by Windows Store application backends. Note that URLs within the current domain are always implicitly allowed.

- Required: No
- Type: array

### Parameter: `slots.configs.name-authsettingsV2.properties.login.cookieExpiration`

The configuration settings of the session cookie's expiration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`convention`](#parameter-slotsconfigsname-authsettingsv2propertieslogincookieexpirationconvention) | string | The convention used when determining the session cookie's expiration. |
| [`timeToExpiration`](#parameter-slotsconfigsname-authsettingsv2propertieslogincookieexpirationtimetoexpiration) | string | The time after the request is made when the session cookie should expire. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.cookieExpiration.convention`

The convention used when determining the session cookie's expiration.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'FixedTime'
    'IdentityProviderDerived'
  ]
  ```

### Parameter: `slots.configs.name-authsettingsV2.properties.login.cookieExpiration.timeToExpiration`

The time after the request is made when the session cookie should expire.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.login.nonce`

The configuration settings of the nonce used in the login flow.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nonceExpirationInterval`](#parameter-slotsconfigsname-authsettingsv2propertiesloginnoncenonceexpirationinterval) | string | The time after the request is made when the nonce should expire. |
| [`validateNonce`](#parameter-slotsconfigsname-authsettingsv2propertiesloginnoncevalidatenonce) | bool | Set to `false` if the nonce should not be validated while completing the login flow. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.nonce.nonceExpirationInterval`

The time after the request is made when the nonce should expire.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.login.nonce.validateNonce`

Set to `false` if the nonce should not be validated while completing the login flow.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.login.preserveUrlFragmentsForLogins`

Set to `true` if the fragments from the request are preserved after the login request is made.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.login.routes`

The routes that specify the endpoints used for login and logout requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logoutEndpoint`](#parameter-slotsconfigsname-authsettingsv2propertiesloginrouteslogoutendpoint) | string | The endpoint at which a logout request should be made. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.routes.logoutEndpoint`

The endpoint at which a logout request should be made.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore`

The configuration settings of the token store.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureBlobStorage`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstoreazureblobstorage) | object | The configuration settings of the storage of the tokens if blob storage is used. |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstoreenabled) | bool | Set to `true` to durably store platform-specific security tokens that are obtained during login flows. |
| [`fileSystem`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstorefilesystem) | object | The configuration settings of the storage of the tokens if a file system is used. |
| [`tokenRefreshExtensionHours`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstoretokenrefreshextensionhours) | int | The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore.azureBlobStorage`

The configuration settings of the storage of the tokens if blob storage is used.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sasUrlSettingName`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstoreazureblobstoragesasurlsettingname) | string | The name of the app setting containing the SAS URL of the blob storage containing the tokens. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore.azureBlobStorage.sasUrlSettingName`

The name of the app setting containing the SAS URL of the blob storage containing the tokens.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore.enabled`

Set to `true` to durably store platform-specific security tokens that are obtained during login flows.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore.fileSystem`

The configuration settings of the storage of the tokens if a file system is used.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`directory`](#parameter-slotsconfigsname-authsettingsv2propertieslogintokenstorefilesystemdirectory) | string | The directory in which the tokens will be stored. |

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore.fileSystem.directory`

The directory in which the tokens will be stored.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.login.tokenStore.tokenRefreshExtensionHours`

The number of hours after session token expiration that a session token can be used to call the token refresh API. The default is 72 hours.

- Required: No
- Type: int

### Parameter: `slots.configs.name-authsettingsV2.properties.platform`

The configuration settings of the platform of App Service Authentication/Authorization.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configFilePath`](#parameter-slotsconfigsname-authsettingsv2propertiesplatformconfigfilepath) | string | The path of the config file containing auth settings if they come from a file. If the path is relative, base will the site's root directory. |
| [`enabled`](#parameter-slotsconfigsname-authsettingsv2propertiesplatformenabled) | bool | Set to `true` if the Authentication / Authorization feature is enabled for the current app. |
| [`runtimeVersion`](#parameter-slotsconfigsname-authsettingsv2propertiesplatformruntimeversion) | string | The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module. |

### Parameter: `slots.configs.name-authsettingsV2.properties.platform.configFilePath`

The path of the config file containing auth settings if they come from a file. If the path is relative, base will the site's root directory.

- Required: No
- Type: string

### Parameter: `slots.configs.name-authsettingsV2.properties.platform.enabled`

Set to `true` if the Authentication / Authorization feature is enabled for the current app.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-authsettingsV2.properties.platform.runtimeVersion`

The RuntimeVersion of the Authentication / Authorization feature in use for the current app. The setting in this value can control the behavior of certain features in the Authentication / Authorization module.

- Required: No
- Type: string

### Variant: `slots.configs.name-azurestorageaccounts`
The type of an Azure Storage Account configuration.

To use this variant, set the property `name` to `azurestorageaccounts`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-azurestorageaccountsname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-azurestorageaccountsproperties) | object | The config settings. |

### Parameter: `slots.configs.name-azurestorageaccounts.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'azurestorageaccounts'
  ]
  ```

### Parameter: `slots.configs.name-azurestorageaccounts.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<) | object | The Azure Storage Info configuration. |

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<`

The Azure Storage Info configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKey`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<accesskey) | securestring | Access key for the storage account. |
| [`accountName`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<accountname) | string | Name of the storage account. |
| [`mountPath`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<mountpath) | string | Path to mount the storage within the site's runtime environment. |
| [`protocol`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<protocol) | string | Mounting protocol to use for the storage account. |
| [`shareName`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<sharename) | string | Name of the file share (container name, for Blob storage). |
| [`type`](#parameter-slotsconfigsname-azurestorageaccountsproperties>any_other_property<type) | string | Type of storage. |

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<.accessKey`

Access key for the storage account.

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<.accountName`

Name of the storage account.

- Required: No
- Type: string

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<.mountPath`

Path to mount the storage within the site's runtime environment.

- Required: No
- Type: string

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<.protocol`

Mounting protocol to use for the storage account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Nfs'
    'Smb'
  ]
  ```

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<.shareName`

Name of the file share (container name, for Blob storage).

- Required: No
- Type: string

### Parameter: `slots.configs.name-azurestorageaccounts.properties.>Any_other_property<.type`

Type of storage.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureBlob'
    'AzureFiles'
  ]
  ```

### Variant: `slots.configs.name-backup`
The type for a backup configuration.

To use this variant, set the property `name` to `backup`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-backupname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-backupproperties) | object | The config settings. |

### Parameter: `slots.configs.name-backup.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'backup'
  ]
  ```

### Parameter: `slots.configs.name-backup.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupName`](#parameter-slotsconfigsname-backuppropertiesbackupname) | string | Name of the backup. |
| [`backupSchedule`](#parameter-slotsconfigsname-backuppropertiesbackupschedule) | object | Schedule for the backup if it is executed periodically. |
| [`databases`](#parameter-slotsconfigsname-backuppropertiesdatabases) | array | Databases included in the backup. |
| [`enabled`](#parameter-slotsconfigsname-backuppropertiesenabled) | bool | Set to `True` if the backup schedule is enabled (must be included in that case), `false` if the backup schedule should be disabled. |
| [`storageAccountUrl`](#parameter-slotsconfigsname-backuppropertiesstorageaccounturl) | string | SAS URL to the container. |

### Parameter: `slots.configs.name-backup.properties.backupName`

Name of the backup.

- Required: No
- Type: string

### Parameter: `slots.configs.name-backup.properties.backupSchedule`

Schedule for the backup if it is executed periodically.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`frequencyInterval`](#parameter-slotsconfigsname-backuppropertiesbackupschedulefrequencyinterval) | int | How often the backup should be executed (e.g. for weekly backup, this should be set to 7 and FrequencyUnit should be set to Day). |
| [`frequencyUnit`](#parameter-slotsconfigsname-backuppropertiesbackupschedulefrequencyunit) | string | The unit of time for how often the backup should be executed (e.g. for weekly backup, this should be set to Day and FrequencyInterval should be set to 7). |
| [`keepAtLeastOneBackup`](#parameter-slotsconfigsname-backuppropertiesbackupschedulekeepatleastonebackup) | bool | Set to `True` if the retention policy should always keep at least one backup in the storage account, regardless how old it is. |
| [`retentionPeriodInDays`](#parameter-slotsconfigsname-backuppropertiesbackupscheduleretentionperiodindays) | int | After how many days backups should be deleted. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`startTime`](#parameter-slotsconfigsname-backuppropertiesbackupschedulestarttime) | string | When the schedule should start working. |

### Parameter: `slots.configs.name-backup.properties.backupSchedule.frequencyInterval`

How often the backup should be executed (e.g. for weekly backup, this should be set to 7 and FrequencyUnit should be set to Day).

- Required: Yes
- Type: int

### Parameter: `slots.configs.name-backup.properties.backupSchedule.frequencyUnit`

The unit of time for how often the backup should be executed (e.g. for weekly backup, this should be set to Day and FrequencyInterval should be set to 7).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Day'
    'Hour'
  ]
  ```

### Parameter: `slots.configs.name-backup.properties.backupSchedule.keepAtLeastOneBackup`

Set to `True` if the retention policy should always keep at least one backup in the storage account, regardless how old it is.

- Required: Yes
- Type: bool

### Parameter: `slots.configs.name-backup.properties.backupSchedule.retentionPeriodInDays`

After how many days backups should be deleted.

- Required: Yes
- Type: int

### Parameter: `slots.configs.name-backup.properties.backupSchedule.startTime`

When the schedule should start working.

- Required: No
- Type: string

### Parameter: `slots.configs.name-backup.properties.databases`

Databases included in the backup.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databaseType`](#parameter-slotsconfigsname-backuppropertiesdatabasesdatabasetype) | string | Database type (e.g. SqlAzure / MySql). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionString`](#parameter-slotsconfigsname-backuppropertiesdatabasesconnectionstring) | securestring | Contains a connection string to a database which is being backed up or restored. If the restore should happen to a new database, the database name inside is the new one. |
| [`connectionStringName`](#parameter-slotsconfigsname-backuppropertiesdatabasesconnectionstringname) | string | Contains a connection string name that is linked to the SiteConfig.ConnectionStrings. This is used during restore with overwrite connection strings options. |
| [`name`](#parameter-slotsconfigsname-backuppropertiesdatabasesname) | string | The name of the setting. |

### Parameter: `slots.configs.name-backup.properties.databases.databaseType`

Database type (e.g. SqlAzure / MySql).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LocalMySql'
    'MySql'
    'PostgreSql'
    'SqlAzure'
  ]
  ```

### Parameter: `slots.configs.name-backup.properties.databases.connectionString`

Contains a connection string to a database which is being backed up or restored. If the restore should happen to a new database, the database name inside is the new one.

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-backup.properties.databases.connectionStringName`

Contains a connection string name that is linked to the SiteConfig.ConnectionStrings. This is used during restore with overwrite connection strings options.

- Required: No
- Type: string

### Parameter: `slots.configs.name-backup.properties.databases.name`

The name of the setting.

- Required: No
- Type: string

### Parameter: `slots.configs.name-backup.properties.enabled`

Set to `True` if the backup schedule is enabled (must be included in that case), `false` if the backup schedule should be disabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-backup.properties.storageAccountUrl`

SAS URL to the container.

- Required: No
- Type: string

### Variant: `slots.configs.name-connectionstrings`
The type for a connection string configuration.

To use this variant, set the property `name` to `connectionstrings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-connectionstringsname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-connectionstringsproperties) | object | The config settings. |

### Parameter: `slots.configs.name-connectionstrings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'connectionstrings'
  ]
  ```

### Parameter: `slots.configs.name-connectionstrings.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-connectionstringsproperties>any_other_property<) | object | The name of the connection string setting. |

### Parameter: `slots.configs.name-connectionstrings.properties.>Any_other_property<`

The name of the connection string setting.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-slotsconfigsname-connectionstringsproperties>any_other_property<type) | string | Type of database. |
| [`value`](#parameter-slotsconfigsname-connectionstringsproperties>any_other_property<value) | string | Value of pair. |

### Parameter: `slots.configs.name-connectionstrings.properties.>Any_other_property<.type`

Type of database.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ApiHub'
    'Custom'
    'DocDb'
    'EventHub'
    'MySql'
    'NotificationHub'
    'PostgreSQL'
    'RedisCache'
    'ServiceBus'
    'SQLAzure'
    'SQLServer'
  ]
  ```

### Parameter: `slots.configs.name-connectionstrings.properties.>Any_other_property<.value`

Value of pair.

- Required: Yes
- Type: string

### Variant: `slots.configs.name-logs`
The type of a logs configuration.

To use this variant, set the property `name` to `logs`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-logsname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-logsproperties) | object | The config settings. |

### Parameter: `slots.configs.name-logs.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'logs'
  ]
  ```

### Parameter: `slots.configs.name-logs.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationLogs`](#parameter-slotsconfigsname-logspropertiesapplicationlogs) | object | Application Logs for Azure configuration. |
| [`detailedErrorMessages`](#parameter-slotsconfigsname-logspropertiesdetailederrormessages) | object | Detailed error messages configuration. |
| [`failedRequestsTracing`](#parameter-slotsconfigsname-logspropertiesfailedrequeststracing) | object | Failed requests tracing configuration. |
| [`httpLogs`](#parameter-slotsconfigsname-logspropertieshttplogs) | object | HTTP logs configuration. |

### Parameter: `slots.configs.name-logs.properties.applicationLogs`

Application Logs for Azure configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureBlobStorage`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazureblobstorage) | object | Application logs to blob storage configuration. |
| [`azureTableStorage`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazuretablestorage) | object | Application logs to azure table storage configuration. |
| [`fileSystem`](#parameter-slotsconfigsname-logspropertiesapplicationlogsfilesystem) | object | Application logs to file system configuration. |

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureBlobStorage`

Application logs to blob storage configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazureblobstoragelevel) | string | Log level. |
| [`retentionInDays`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazureblobstorageretentionindays) | int | Retention in days. Remove blobs older than X days. 0 or lower means no retention. |
| [`sasUrl`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazureblobstoragesasurl) | string | SAS url to a azure blob container with read/write/list/delete permissions. |

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureBlobStorage.level`

Log level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Error'
    'Information'
    'Off'
    'Verbose'
    'Warning'
  ]
  ```

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureBlobStorage.retentionInDays`

Retention in days. Remove blobs older than X days. 0 or lower means no retention.

- Required: No
- Type: int

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureBlobStorage.sasUrl`

SAS url to a azure blob container with read/write/list/delete permissions.

- Required: No
- Type: string

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureTableStorage`

Application logs to azure table storage configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sasUrl`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazuretablestoragesasurl) | string | SAS URL to an Azure table with add/query/delete permissions. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-slotsconfigsname-logspropertiesapplicationlogsazuretablestoragelevel) | string | Log level. |

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureTableStorage.sasUrl`

SAS URL to an Azure table with add/query/delete permissions.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-logs.properties.applicationLogs.azureTableStorage.level`

Log level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Error'
    'Information'
    'Off'
    'Verbose'
    'Warning'
  ]
  ```

### Parameter: `slots.configs.name-logs.properties.applicationLogs.fileSystem`

Application logs to file system configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`level`](#parameter-slotsconfigsname-logspropertiesapplicationlogsfilesystemlevel) | string | Log level. |

### Parameter: `slots.configs.name-logs.properties.applicationLogs.fileSystem.level`

Log level.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Error'
    'Information'
    'Off'
    'Verbose'
    'Warning'
  ]
  ```

### Parameter: `slots.configs.name-logs.properties.detailedErrorMessages`

Detailed error messages configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-logspropertiesdetailederrormessagesenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |

### Parameter: `slots.configs.name-logs.properties.detailedErrorMessages.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-logs.properties.failedRequestsTracing`

Failed requests tracing configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-logspropertiesfailedrequeststracingenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |

### Parameter: `slots.configs.name-logs.properties.failedRequestsTracing.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-logs.properties.httpLogs`

HTTP logs configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureBlobStorage`](#parameter-slotsconfigsname-logspropertieshttplogsazureblobstorage) | object | Http logs to azure blob storage configuration. |
| [`fileSystem`](#parameter-slotsconfigsname-logspropertieshttplogsfilesystem) | object | Http logs to file system configuration. |

### Parameter: `slots.configs.name-logs.properties.httpLogs.azureBlobStorage`

Http logs to azure blob storage configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-logspropertieshttplogsazureblobstorageenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |
| [`retentionInDays`](#parameter-slotsconfigsname-logspropertieshttplogsazureblobstorageretentionindays) | int | Retention in days. Remove blobs older than X days. 0 or lower means no retention. |
| [`sasUrl`](#parameter-slotsconfigsname-logspropertieshttplogsazureblobstoragesasurl) | string | SAS url to a azure blob container with read/write/list/delete permissions. |

### Parameter: `slots.configs.name-logs.properties.httpLogs.azureBlobStorage.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-logs.properties.httpLogs.azureBlobStorage.retentionInDays`

Retention in days. Remove blobs older than X days. 0 or lower means no retention.

- Required: No
- Type: int

### Parameter: `slots.configs.name-logs.properties.httpLogs.azureBlobStorage.sasUrl`

SAS url to a azure blob container with read/write/list/delete permissions.

- Required: No
- Type: string

### Parameter: `slots.configs.name-logs.properties.httpLogs.fileSystem`

Http logs to file system configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsconfigsname-logspropertieshttplogsfilesystemenabled) | bool | Set to `True` if configuration is enabled, false if it is disabled. |
| [`retentionInDays`](#parameter-slotsconfigsname-logspropertieshttplogsfilesystemretentionindays) | int | Retention in days. Remove files older than X days. 0 or lower means no retention. |
| [`retentionInMb`](#parameter-slotsconfigsname-logspropertieshttplogsfilesystemretentioninmb) | int | Maximum size in megabytes that http log files can use. When reached old log files will be removed to make space for new ones. |

### Parameter: `slots.configs.name-logs.properties.httpLogs.fileSystem.enabled`

Set to `True` if configuration is enabled, false if it is disabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-logs.properties.httpLogs.fileSystem.retentionInDays`

Retention in days. Remove files older than X days. 0 or lower means no retention.

- Required: No
- Type: int

### Parameter: `slots.configs.name-logs.properties.httpLogs.fileSystem.retentionInMb`

Maximum size in megabytes that http log files can use. When reached old log files will be removed to make space for new ones.

- Required: No
- Type: int
- MinValue: 25
- MaxValue: 100

### Variant: `slots.configs.name-metadata`
The type of a metadata configuration.

To use this variant, set the property `name` to `metadata`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-metadataname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-metadataproperties) | object | The config settings. |

### Parameter: `slots.configs.name-metadata.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'metadata'
  ]
  ```

### Parameter: `slots.configs.name-metadata.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-metadataproperties>any_other_property<) | string | The metadata key value pair. |

### Parameter: `slots.configs.name-metadata.properties.>Any_other_property<`

The metadata key value pair.

- Required: No
- Type: string

### Variant: `slots.configs.name-pushsettings`
The type of a pushSettings configuration.

To use this variant, set the property `name` to `pushsettings`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-pushsettingsname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-pushsettingsproperties) | object | The config settings. |

### Parameter: `slots.configs.name-pushsettings.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'pushsettings'
  ]
  ```

### Parameter: `slots.configs.name-pushsettings.properties`

The config settings.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isPushEnabled`](#parameter-slotsconfigsname-pushsettingspropertiesispushenabled) | bool | Gets or sets a flag indicating whether the Push endpoint is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamicTagsJson`](#parameter-slotsconfigsname-pushsettingspropertiesdynamictagsjson) | string | Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint. |
| [`tagsRequiringAuth`](#parameter-slotsconfigsname-pushsettingspropertiestagsrequiringauth) | string | Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler. |
| [`tagWhitelistJson`](#parameter-slotsconfigsname-pushsettingspropertiestagwhitelistjson) | string | Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint. |

### Parameter: `slots.configs.name-pushsettings.properties.isPushEnabled`

Gets or sets a flag indicating whether the Push endpoint is enabled.

- Required: Yes
- Type: bool

### Parameter: `slots.configs.name-pushsettings.properties.dynamicTagsJson`

Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint.

- Required: No
- Type: string

### Parameter: `slots.configs.name-pushsettings.properties.tagsRequiringAuth`

Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler.

- Required: No
- Type: string

### Parameter: `slots.configs.name-pushsettings.properties.tagWhitelistJson`

Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint.

- Required: No
- Type: string

### Variant: `slots.configs.name-slotConfigNames`
The type of a slotConfigNames configuration.

To use this variant, set the property `name` to `slotConfigNames`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-slotconfignamesname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-slotconfignamesproperties) | object | The config settings. |

### Parameter: `slots.configs.name-slotConfigNames.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'slotConfigNames'
  ]
  ```

### Parameter: `slots.configs.name-slotConfigNames.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appSettingNames`](#parameter-slotsconfigsname-slotconfignamespropertiesappsettingnames) | array | List of application settings names. |
| [`azureStorageConfigNames`](#parameter-slotsconfigsname-slotconfignamespropertiesazurestorageconfignames) | array | List of external Azure storage account identifiers. |
| [`connectionStringNames`](#parameter-slotsconfigsname-slotconfignamespropertiesconnectionstringnames) | array | List of connection string names. |

### Parameter: `slots.configs.name-slotConfigNames.properties.appSettingNames`

List of application settings names.

- Required: No
- Type: array

### Parameter: `slots.configs.name-slotConfigNames.properties.azureStorageConfigNames`

List of external Azure storage account identifiers.

- Required: No
- Type: array

### Parameter: `slots.configs.name-slotConfigNames.properties.connectionStringNames`

List of connection string names.

- Required: No
- Type: array

### Variant: `slots.configs.name-web`
The type of a web configuration.

To use this variant, set the property `name` to `web`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-webname) | string | The type of config. |
| [`properties`](#parameter-slotsconfigsname-webproperties) | object | The config settings. |

### Parameter: `slots.configs.name-web.name`

The type of config.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'web'
  ]
  ```

### Parameter: `slots.configs.name-web.properties`

The config settings.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`acrUseManagedIdentityCreds`](#parameter-slotsconfigsname-webpropertiesacrusemanagedidentitycreds) | bool | Flag to use Managed Identity Creds for ACR pull. |
| [`acrUserManagedIdentityID`](#parameter-slotsconfigsname-webpropertiesacrusermanagedidentityid) | string | If using user managed identity, the user managed identity ClientId. |
| [`alwaysOn`](#parameter-slotsconfigsname-webpropertiesalwayson) | bool | Set to `true` if 'Always On' is enabled. |
| [`apiDefinition`](#parameter-slotsconfigsname-webpropertiesapidefinition) | object | Information about the formal API definition for the app. |
| [`apiManagementConfig`](#parameter-slotsconfigsname-webpropertiesapimanagementconfig) | object | Azure API management settings linked to the app. |
| [`appCommandLine`](#parameter-slotsconfigsname-webpropertiesappcommandline) | string | App command line to launch. |
| [`appSettings`](#parameter-slotsconfigsname-webpropertiesappsettings) | array | Application settings. |
| [`autoHealEnabled`](#parameter-slotsconfigsname-webpropertiesautohealenabled) | bool | Set to `true` if Auto Heal is enabled. |
| [`autoHealRules`](#parameter-slotsconfigsname-webpropertiesautohealrules) | object | Auto Heal rules. |
| [`autoSwapSlotName`](#parameter-slotsconfigsname-webpropertiesautoswapslotname) | string | Auto-swap slot name. |
| [`azureStorageAccounts`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts) | object | List of Azure Storage Accounts. |
| [`connectionStrings`](#parameter-slotsconfigsname-webpropertiesconnectionstrings) | array | Connection strings. |
| [`cors`](#parameter-slotsconfigsname-webpropertiescors) | object | Cross-Origin Resource Sharing (CORS) settings. |
| [`defaultDocuments`](#parameter-slotsconfigsname-webpropertiesdefaultdocuments) | array | Default documents. |
| [`detailedErrorLoggingEnabled`](#parameter-slotsconfigsname-webpropertiesdetailederrorloggingenabled) | bool | Set to `true` if detailed error logging is enabled. |
| [`documentRoot`](#parameter-slotsconfigsname-webpropertiesdocumentroot) | string | Document root. |
| [`elasticWebAppScaleLimit`](#parameter-slotsconfigsname-webpropertieselasticwebappscalelimit) | int | Maximum number of workers that a site can scale out to. This setting only applies to apps in plans where ElasticScaleEnabled is `true`. |
| [`experiments`](#parameter-slotsconfigsname-webpropertiesexperiments) | object | This is work around for polymorphic types. |
| [`ftpsState`](#parameter-slotsconfigsname-webpropertiesftpsstate) | string | State of FTP / FTPS service. |
| [`functionAppScaleLimit`](#parameter-slotsconfigsname-webpropertiesfunctionappscalelimit) | int | Maximum number of workers that a site can scale out to. This setting only applies to the Consumption and Elastic Premium Plans. |
| [`functionsRuntimeScaleMonitoringEnabled`](#parameter-slotsconfigsname-webpropertiesfunctionsruntimescalemonitoringenabled) | bool | Gets or sets a value indicating whether functions runtime scale monitoring is enabled. When enabled, the ScaleController will not monitor event sources directly, but will instead call to the runtime to get scale status. |
| [`handlerMappings`](#parameter-slotsconfigsname-webpropertieshandlermappings) | array | Handler mappings. |
| [`healthCheckPath`](#parameter-slotsconfigsname-webpropertieshealthcheckpath) | string | Health check path. |
| [`http20Enabled`](#parameter-slotsconfigsname-webpropertieshttp20enabled) | bool | Allow clients to connect over http2.0. |
| [`httpLoggingEnabled`](#parameter-slotsconfigsname-webpropertieshttploggingenabled) | bool | Set to `true` if HTTP logging is enabled. |
| [`ipSecurityRestrictions`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictions) | array | IP security restrictions for main. |
| [`ipSecurityRestrictionsDefaultAction`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsdefaultaction) | string | Default action for main access restriction if no rules are matched. |
| [`javaContainer`](#parameter-slotsconfigsname-webpropertiesjavacontainer) | string | Java container. |
| [`javaContainerVersion`](#parameter-slotsconfigsname-webpropertiesjavacontainerversion) | string | Java container version. |
| [`javaVersion`](#parameter-slotsconfigsname-webpropertiesjavaversion) | string | Java version. |
| [`keyVaultReferenceIdentity`](#parameter-slotsconfigsname-webpropertieskeyvaultreferenceidentity) | string | Identity to use for Key Vault Reference authentication. |
| [`limits`](#parameter-slotsconfigsname-webpropertieslimits) | object | Site limits. |
| [`linuxFxVersion`](#parameter-slotsconfigsname-webpropertieslinuxfxversion) | string | Linux App Framework and version. |
| [`loadBalancing`](#parameter-slotsconfigsname-webpropertiesloadbalancing) | string | Site load balancing. |
| [`localMySqlEnabled`](#parameter-slotsconfigsname-webpropertieslocalmysqlenabled) | bool | Set to `true` to enable local MySQL. |
| [`logsDirectorySizeLimit`](#parameter-slotsconfigsname-webpropertieslogsdirectorysizelimit) | int | HTTP logs directory size limit. |
| [`managedPipelineMode`](#parameter-slotsconfigsname-webpropertiesmanagedpipelinemode) | string | Managed pipeline mode. |
| [`managedServiceIdentityId`](#parameter-slotsconfigsname-webpropertiesmanagedserviceidentityid) | int | Managed Service Identity Id. |
| [`metadata`](#parameter-slotsconfigsname-webpropertiesmetadata) | array | Application metadata. This property cannot be retrieved, since it may contain secrets. |
| [`minimumElasticInstanceCount`](#parameter-slotsconfigsname-webpropertiesminimumelasticinstancecount) | int | Number of minimum instance count for a site. This setting only applies to the Elastic Plans. |
| [`minTlsCipherSuite`](#parameter-slotsconfigsname-webpropertiesmintlsciphersuite) | string | The minimum strength TLS cipher suite allowed for an application. |
| [`minTlsVersion`](#parameter-slotsconfigsname-webpropertiesmintlsversion) | string | MinTlsVersion: configures the minimum version of TLS required for SSL requests. |
| [`netFrameworkVersion`](#parameter-slotsconfigsname-webpropertiesnetframeworkversion) | string | .NET Framework version. |
| [`nodeVersion`](#parameter-slotsconfigsname-webpropertiesnodeversion) | string | Version of Node.js. |
| [`numberOfWorkers`](#parameter-slotsconfigsname-webpropertiesnumberofworkers) | int | Number of workers. |
| [`phpVersion`](#parameter-slotsconfigsname-webpropertiesphpversion) | string | Version of PHP. |
| [`powerShellVersion`](#parameter-slotsconfigsname-webpropertiespowershellversion) | string | Version of PowerShell. |
| [`preWarmedInstanceCount`](#parameter-slotsconfigsname-webpropertiesprewarmedinstancecount) | int | Number of preWarmed instances. This setting only applies to the Consumption and Elastic Plans. |
| [`publicNetworkAccess`](#parameter-slotsconfigsname-webpropertiespublicnetworkaccess) | string | Property to allow or block all public traffic. |
| [`publishingUsername`](#parameter-slotsconfigsname-webpropertiespublishingusername) | string | Publishing user name. |
| [`push`](#parameter-slotsconfigsname-webpropertiespush) | object | Push endpoint settings. |
| [`pythonVersion`](#parameter-slotsconfigsname-webpropertiespythonversion) | string | Version of Python. |
| [`remoteDebuggingEnabled`](#parameter-slotsconfigsname-webpropertiesremotedebuggingenabled) | bool | Set to `true` if remote debugging is enabled. |
| [`remoteDebuggingVersion`](#parameter-slotsconfigsname-webpropertiesremotedebuggingversion) | string | Remote debugging version. |
| [`requestTracingEnabled`](#parameter-slotsconfigsname-webpropertiesrequesttracingenabled) | bool | Set to `true` if request tracing is enabled. |
| [`requestTracingExpirationTime`](#parameter-slotsconfigsname-webpropertiesrequesttracingexpirationtime) | string | Request tracing expiration time. |
| [`scmIpSecurityRestrictions`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictions) | array | IP security restrictions for scm. |
| [`scmIpSecurityRestrictionsDefaultAction`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsdefaultaction) | string | Default action for scm access restriction if no rules are matched. |
| [`scmIpSecurityRestrictionsUseMain`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsusemain) | bool | IP security restrictions for scm to use main. |
| [`scmMinTlsVersion`](#parameter-slotsconfigsname-webpropertiesscmmintlsversion) | string | ScmMinTlsVersion: configures the minimum version of TLS required for SSL requests for SCM site. |
| [`scmType`](#parameter-slotsconfigsname-webpropertiesscmtype) | string | SCM type. |
| [`tracingOptions`](#parameter-slotsconfigsname-webpropertiestracingoptions) | string | Tracing options. |
| [`use32BitWorkerProcess`](#parameter-slotsconfigsname-webpropertiesuse32bitworkerprocess) | bool | Set to `true` to use 32-bit worker process. |
| [`virtualApplications`](#parameter-slotsconfigsname-webpropertiesvirtualapplications) | array | Virtual applications. |
| [`vnetName`](#parameter-slotsconfigsname-webpropertiesvnetname) | string | Virtual Network name. |
| [`vnetPrivatePortsCount`](#parameter-slotsconfigsname-webpropertiesvnetprivateportscount) | int | The number of private ports assigned to this app. These will be assigned dynamically on runtime. |
| [`vnetRouteAllEnabled`](#parameter-slotsconfigsname-webpropertiesvnetrouteallenabled) | bool | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |
| [`websiteTimeZone`](#parameter-slotsconfigsname-webpropertieswebsitetimezone) | string | Sets the time zone a site uses for generating timestamps. Compatible with Linux and Windows App Service. Setting the WEBSITE_TIME_ZONE app setting takes precedence over this config. For Linux, expects tz database values https://www.iana.org/time-zones (for a quick reference see [ref](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)). For Windows, expects one of the time zones listed under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones. |
| [`webSocketsEnabled`](#parameter-slotsconfigsname-webpropertieswebsocketsenabled) | bool | Set to `true` if WebSocket is enabled. |
| [`windowsFxVersion`](#parameter-slotsconfigsname-webpropertieswindowsfxversion) | string | Xenon App Framework and version. |
| [`xManagedServiceIdentityId`](#parameter-slotsconfigsname-webpropertiesxmanagedserviceidentityid) | int | Explicit Managed Service Identity Id. |

### Parameter: `slots.configs.name-web.properties.acrUseManagedIdentityCreds`

Flag to use Managed Identity Creds for ACR pull.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.acrUserManagedIdentityID`

If using user managed identity, the user managed identity ClientId.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.alwaysOn`

Set to `true` if 'Always On' is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.apiDefinition`

Information about the formal API definition for the app.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-slotsconfigsname-webpropertiesapidefinitionurl) | string | The URL of the API definition. |

### Parameter: `slots.configs.name-web.properties.apiDefinition.url`

The URL of the API definition.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-web.properties.apiManagementConfig`

Azure API management settings linked to the app.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-slotsconfigsname-webpropertiesapimanagementconfigid) | string | APIM-Api Identifier. |

### Parameter: `slots.configs.name-web.properties.apiManagementConfig.id`

APIM-Api Identifier.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-web.properties.appCommandLine`

App command line to launch.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.appSettings`

Application settings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-webpropertiesappsettingsname) | string | Name of the pair. |
| [`value`](#parameter-slotsconfigsname-webpropertiesappsettingsvalue) | string | Value of the pair. |

### Parameter: `slots.configs.name-web.properties.appSettings.name`

Name of the pair.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-web.properties.appSettings.value`

Value of the pair.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealEnabled`

Set to `true` if Auto Heal is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.autoHealRules`

Auto Heal rules.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-slotsconfigsname-webpropertiesautohealrulesactions) | object | Actions to be executed when a rule is triggered. |
| [`triggers`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggers) | object | Conditions that describe when to execute the auto-heal actions. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.actions`

Actions to be executed when a rule is triggered.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionType`](#parameter-slotsconfigsname-webpropertiesautohealrulesactionsactiontype) | string | Predefined action to be taken. |
| [`customAction`](#parameter-slotsconfigsname-webpropertiesautohealrulesactionscustomaction) | object | Custom action to be taken. |
| [`minProcessExecutionTime`](#parameter-slotsconfigsname-webpropertiesautohealrulesactionsminprocessexecutiontime) | string | Minimum time the process must execute before taking the action. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.actions.actionType`

Predefined action to be taken.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CustomAction'
    'LogEvent'
    'Recycle'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.autoHealRules.actions.customAction`

Custom action to be taken.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exe`](#parameter-slotsconfigsname-webpropertiesautohealrulesactionscustomactionexe) | string | Executable to be run. |
| [`parameters`](#parameter-slotsconfigsname-webpropertiesautohealrulesactionscustomactionparameters) | string | Parameters for the executable. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.actions.customAction.exe`

Executable to be run.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.actions.customAction.parameters`

Parameters for the executable.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.actions.minProcessExecutionTime`

Minimum time the process must execute before taking the action.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers`

Conditions that describe when to execute the auto-heal actions.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateBytesInKB`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersprivatebytesinkb) | int | A rule based on private bytes. |
| [`requests`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersrequests) | object | A rule based on total requests. |
| [`slowRequests`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequests) | object | A rule based on request execution time. |
| [`slowRequestsWithPath`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestswithpath) | array | A rule based on multiple Slow Requests Rule with path. |
| [`statusCodes`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodes) | array | A rule based on status codes. |
| [`statusCodesRange`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodesrange) | array | A rule based on status codes ranges. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.privateBytesInKB`

A rule based on private bytes.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.requests`

A rule based on total requests.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersrequestscount) | int | Request Count. |
| [`timeInterval`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersrequeststimeinterval) | string | Time interval. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.requests.count`

Request Count.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.requests.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequests`

A rule based on request execution time.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestscount) | int | Request Count. |
| [`path`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestspath) | string | Request Path. |
| [`timeInterval`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequeststimeinterval) | string | Time interval. |
| [`timeTaken`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequeststimetaken) | string | Time taken. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequests.count`

Request Count.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequests.path`

Request Path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequests.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequests.timeTaken`

Time taken.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath`

A rule based on multiple Slow Requests Rule with path.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestswithpathcount) | int | Request Count. |
| [`path`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestswithpathpath) | string | Request Path. |
| [`timeInterval`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestswithpathtimeinterval) | string | Time interval. |
| [`timeTaken`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersslowrequestswithpathtimetaken) | string | Time taken. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.count`

Request Count.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.path`

Request Path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.slowRequestsWithPath.timeTaken`

Time taken.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes`

A rule based on status codes.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodescount) | int | Request Count. |
| [`path`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodespath) | string | Request Path. |
| [`status`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodesstatus) | int | HTTP status code. |
| [`subStatus`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodessubstatus) | int | Request Sub Status. |
| [`timeInterval`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodestimeinterval) | string | Time interval. |
| [`win32Status`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodeswin32status) | int | Win32 error code. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes.count`

Request Count.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes.path`

Request Path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes.status`

HTTP status code.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes.subStatus`

Request Sub Status.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodes.win32Status`

Win32 error code.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodesRange`

A rule based on status codes ranges.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`count`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodesrangecount) | int | Request Count. |
| [`path`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodesrangepath) | string | Path. |
| [`statusCodes`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodesrangestatuscodes) | string | HTTP status code. |
| [`timeInterval`](#parameter-slotsconfigsname-webpropertiesautohealrulestriggersstatuscodesrangetimeinterval) | string | Time interval. |

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodesRange.count`

Request Count.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodesRange.path`

Path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodesRange.statusCodes`

HTTP status code.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoHealRules.triggers.statusCodesRange.timeInterval`

Time interval.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.autoSwapSlotName`

Auto-swap slot name.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts`

List of Azure Storage Accounts.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<) | object | A storage account configuration. |

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<`

A storage account configuration.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessKey`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<accesskey) | securestring | Access key for the storage account. |
| [`accountName`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<accountname) | string | Name of the storage account. |
| [`mountPath`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<mountpath) | string | Path to mount the storage within the site's runtime environment. |
| [`protocol`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<protocol) | string | Mounting protocol to use for the storage account. |
| [`shareName`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<sharename) | string | Name of the file share (container name, for Blob storage). |
| [`type`](#parameter-slotsconfigsname-webpropertiesazurestorageaccounts>any_other_property<type) | string | Type of storage. |

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<.accessKey`

Access key for the storage account.

- Required: No
- Type: securestring

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<.accountName`

Name of the storage account.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<.mountPath`

Path to mount the storage within the site's runtime environment.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<.protocol`

Mounting protocol to use for the storage account.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Nfs'
    'Smb'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<.shareName`

Name of the file share (container name, for Blob storage).

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.azureStorageAccounts.>Any_other_property<.type`

Type of storage.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureBlob'
    'AzureFiles'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.connectionStrings`

Connection strings.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionString`](#parameter-slotsconfigsname-webpropertiesconnectionstringsconnectionstring) | string | Connection string value. |
| [`name`](#parameter-slotsconfigsname-webpropertiesconnectionstringsname) | string | Name of connection string. |
| [`type`](#parameter-slotsconfigsname-webpropertiesconnectionstringstype) | string | Type of database. |

### Parameter: `slots.configs.name-web.properties.connectionStrings.connectionString`

Connection string value.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.connectionStrings.name`

Name of connection string.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.connectionStrings.type`

Type of database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ApiHub'
    'Custom'
    'DocDb'
    'EventHub'
    'MySql'
    'NotificationHub'
    'PostgreSQL'
    'RedisCache'
    'ServiceBus'
    'SQLAzure'
    'SQLServer'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.cors`

Cross-Origin Resource Sharing (CORS) settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedOrigins`](#parameter-slotsconfigsname-webpropertiescorsallowedorigins) | array | Gets or sets the list of origins that should be allowed to make cross-origin calls (for example: http://example.com:12345). Use "*" to allow all. |
| [`supportCredentials`](#parameter-slotsconfigsname-webpropertiescorssupportcredentials) | bool | Gets or sets whether CORS requests with credentials are allowed. See [ref](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#Requests_with_credentials) for more details. |

### Parameter: `slots.configs.name-web.properties.cors.allowedOrigins`

Gets or sets the list of origins that should be allowed to make cross-origin calls (for example: http://example.com:12345). Use "*" to allow all.

- Required: No
- Type: array

### Parameter: `slots.configs.name-web.properties.cors.supportCredentials`

Gets or sets whether CORS requests with credentials are allowed. See [ref](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS#Requests_with_credentials) for more details.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.defaultDocuments`

Default documents.

- Required: No
- Type: array

### Parameter: `slots.configs.name-web.properties.detailedErrorLoggingEnabled`

Set to `true` if detailed error logging is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.documentRoot`

Document root.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.elasticWebAppScaleLimit`

Maximum number of workers that a site can scale out to. This setting only applies to apps in plans where ElasticScaleEnabled is `true`.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `slots.configs.name-web.properties.experiments`

This is work around for polymorphic types.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rampUpRules`](#parameter-slotsconfigsname-webpropertiesexperimentsrampuprules) | array | List of ramp-up rules. |

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules`

List of ramp-up rules.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionHostName`](#parameter-slotsconfigsname-webpropertiesexperimentsrampuprulesactionhostname) | string | Hostname of a slot to which the traffic will be redirected if decided to. E.g. myapp-stage.azurewebsites.net. |
| [`changeDecisionCallbackUrl`](#parameter-slotsconfigsname-webpropertiesexperimentsrampupruleschangedecisioncallbackurl) | string | Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified. |
| [`changeIntervalInMinutes`](#parameter-slotsconfigsname-webpropertiesexperimentsrampupruleschangeintervalinminutes) | int | Specifies interval in minutes to reevaluate ReroutePercentage. |
| [`changeStep`](#parameter-slotsconfigsname-webpropertiesexperimentsrampupruleschangestep) | int | In auto ramp up scenario this is the step to add/remove from `ReroutePercentage` until it reaches `MinReroutePercentage` or `MaxReroutePercentage`. Site metrics are checked every N minutes specified in `ChangeIntervalInMinutes`. Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified in `ChangeDecisionCallbackUrl`. |
| [`maxReroutePercentage`](#parameter-slotsconfigsname-webpropertiesexperimentsrampuprulesmaxreroutepercentage) | int | Specifies upper boundary below which ReroutePercentage will stay. |
| [`minReroutePercentage`](#parameter-slotsconfigsname-webpropertiesexperimentsrampuprulesminreroutepercentage) | int | Specifies lower boundary above which ReroutePercentage will stay. |
| [`name`](#parameter-slotsconfigsname-webpropertiesexperimentsrampuprulesname) | string | Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment. |
| [`reroutePercentage`](#parameter-slotsconfigsname-webpropertiesexperimentsrampuprulesreroutepercentage) | int | Percentage of the traffic which will be redirected to `ActionHostName`. |

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.actionHostName`

Hostname of a slot to which the traffic will be redirected if decided to. E.g. myapp-stage.azurewebsites.net.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.changeDecisionCallbackUrl`

Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.changeIntervalInMinutes`

Specifies interval in minutes to reevaluate ReroutePercentage.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.changeStep`

In auto ramp up scenario this is the step to add/remove from `ReroutePercentage` until it reaches `MinReroutePercentage` or `MaxReroutePercentage`. Site metrics are checked every N minutes specified in `ChangeIntervalInMinutes`. Custom decision algorithm can be provided in TiPCallback site extension which URL can be specified in `ChangeDecisionCallbackUrl`.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.maxReroutePercentage`

Specifies upper boundary below which ReroutePercentage will stay.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.minReroutePercentage`

Specifies lower boundary above which ReroutePercentage will stay.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.name`

Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.experiments.rampUpRules.reroutePercentage`

Percentage of the traffic which will be redirected to `ActionHostName`.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.ftpsState`

State of FTP / FTPS service.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllAllowed'
    'Disabled'
    'FtpsOnly'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.functionAppScaleLimit`

Maximum number of workers that a site can scale out to. This setting only applies to the Consumption and Elastic Premium Plans.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `slots.configs.name-web.properties.functionsRuntimeScaleMonitoringEnabled`

Gets or sets a value indicating whether functions runtime scale monitoring is enabled. When enabled, the ScaleController will not monitor event sources directly, but will instead call to the runtime to get scale status.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.handlerMappings`

Handler mappings.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arguments`](#parameter-slotsconfigsname-webpropertieshandlermappingsarguments) | string | Command-line arguments to be passed to the script processor. |
| [`extension`](#parameter-slotsconfigsname-webpropertieshandlermappingsextension) | string | Requests with this extension will be handled using the specified FastCGI application. |
| [`scriptProcessor`](#parameter-slotsconfigsname-webpropertieshandlermappingsscriptprocessor) | string | The absolute path to the FastCGI application. |

### Parameter: `slots.configs.name-web.properties.handlerMappings.arguments`

Command-line arguments to be passed to the script processor.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.handlerMappings.extension`

Requests with this extension will be handled using the specified FastCGI application.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.handlerMappings.scriptProcessor`

The absolute path to the FastCGI application.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.healthCheckPath`

Health check path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.http20Enabled`

Allow clients to connect over http2.0.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.httpLoggingEnabled`

Set to `true` if HTTP logging is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions`

IP security restrictions for main.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsaction) | string | Allow or Deny access for this IP range. |
| [`description`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsdescription) | string | IP restriction rule description. |
| [`headers`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsheaders) | object | IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match. |
| [`ipAddress`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsipaddress) | string | IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified. |
| [`name`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsname) | string | IP restriction rule name. |
| [`priority`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionspriority) | int | Priority of IP restriction rule. |
| [`subnetMask`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionssubnetmask) | string | Subnet mask for the range of IP addresses the restriction is valid for. |
| [`subnetTrafficTag`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionssubnettraffictag) | int | (internal) Subnet traffic tag. |
| [`tag`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionstag) | string | Defines what this IP filter will be used for. This is to support IP filtering on proxies. |
| [`vnetSubnetResourceId`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsvnetsubnetresourceid) | string | Virtual network resource id. |
| [`vnetTrafficTag`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsvnettraffictag) | int | (internal) Vnet traffic tag. |

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.action`

Allow or Deny access for this IP range.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.description`

IP restriction rule description.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.headers`

IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-webpropertiesipsecurityrestrictionsheaders>any_other_property<) | array | A header. |

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.headers.>Any_other_property<`

A header.

- Required: Yes
- Type: array

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.ipAddress`

IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.name`

IP restriction rule name.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.priority`

Priority of IP restriction rule.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.subnetMask`

Subnet mask for the range of IP addresses the restriction is valid for.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.subnetTrafficTag`

(internal) Subnet traffic tag.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.tag`

Defines what this IP filter will be used for. This is to support IP filtering on proxies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'ServiceTag'
    'XffProxy'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.vnetSubnetResourceId`

Virtual network resource id.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictions.vnetTrafficTag`

(internal) Vnet traffic tag.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.ipSecurityRestrictionsDefaultAction`

Default action for main access restriction if no rules are matched.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.javaContainer`

Java container.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.javaContainerVersion`

Java container version.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.javaVersion`

Java version.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.keyVaultReferenceIdentity`

Identity to use for Key Vault Reference authentication.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.limits`

Site limits.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxDiskSizeInMb`](#parameter-slotsconfigsname-webpropertieslimitsmaxdisksizeinmb) | int | Maximum allowed disk size usage in MB. |
| [`maxMemoryInMb`](#parameter-slotsconfigsname-webpropertieslimitsmaxmemoryinmb) | int | Maximum allowed memory usage in MB. |
| [`maxPercentageCpu`](#parameter-slotsconfigsname-webpropertieslimitsmaxpercentagecpu) | int | Maximum allowed CPU usage percentage. |

### Parameter: `slots.configs.name-web.properties.limits.maxDiskSizeInMb`

Maximum allowed disk size usage in MB.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.limits.maxMemoryInMb`

Maximum allowed memory usage in MB.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.limits.maxPercentageCpu`

Maximum allowed CPU usage percentage.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.linuxFxVersion`

Linux App Framework and version.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.loadBalancing`

Site load balancing.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'LeastRequests'
    'LeastRequestsWithTieBreaker'
    'LeastResponseTime'
    'PerSiteRoundRobin'
    'RequestHash'
    'WeightedRoundRobin'
    'WeightedTotalTraffic'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.localMySqlEnabled`

Set to `true` to enable local MySQL.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.logsDirectorySizeLimit`

HTTP logs directory size limit.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.managedPipelineMode`

Managed pipeline mode.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Classic'
    'Integrated'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.managedServiceIdentityId`

Managed Service Identity Id.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.metadata`

Application metadata. This property cannot be retrieved, since it may contain secrets.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsconfigsname-webpropertiesmetadataname) | string | Pair name. |
| [`value`](#parameter-slotsconfigsname-webpropertiesmetadatavalue) | string | Pair Value. |

### Parameter: `slots.configs.name-web.properties.metadata.name`

Pair name.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-web.properties.metadata.value`

Pair Value.

- Required: Yes
- Type: string

### Parameter: `slots.configs.name-web.properties.minimumElasticInstanceCount`

Number of minimum instance count for a site. This setting only applies to the Elastic Plans.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 20

### Parameter: `slots.configs.name-web.properties.minTlsCipherSuite`

The minimum strength TLS cipher suite allowed for an application.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'TLS_AES_128_GCM_SHA256'
    'TLS_AES_256_GCM_SHA384'
    'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
    'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
    'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
    'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
    'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
    'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
    'TLS_RSA_WITH_AES_128_CBC_SHA'
    'TLS_RSA_WITH_AES_128_CBC_SHA256'
    'TLS_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_RSA_WITH_AES_256_CBC_SHA'
    'TLS_RSA_WITH_AES_256_CBC_SHA256'
    'TLS_RSA_WITH_AES_256_GCM_SHA384'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.minTlsVersion`

MinTlsVersion: configures the minimum version of TLS required for SSL requests.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    '1.3'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.netFrameworkVersion`

.NET Framework version.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.nodeVersion`

Version of Node.js.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.numberOfWorkers`

Number of workers.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.phpVersion`

Version of PHP.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.powerShellVersion`

Version of PowerShell.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.preWarmedInstanceCount`

Number of preWarmed instances. This setting only applies to the Consumption and Elastic Plans.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 10

### Parameter: `slots.configs.name-web.properties.publicNetworkAccess`

Property to allow or block all public traffic.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.publishingUsername`

Publishing user name.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.push`

Push endpoint settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-slotsconfigsname-webpropertiespushkind) | string | Kind of resource. |
| [`properties`](#parameter-slotsconfigsname-webpropertiespushproperties) | object | PushSettings resource specific properties. |

### Parameter: `slots.configs.name-web.properties.push.kind`

Kind of resource.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.push.properties`

PushSettings resource specific properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isPushEnabled`](#parameter-slotsconfigsname-webpropertiespushpropertiesispushenabled) | bool | Gets or sets a flag indicating whether the Push endpoint is enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dynamicTagsJson`](#parameter-slotsconfigsname-webpropertiespushpropertiesdynamictagsjson) | string | Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint. |
| [`tagsRequiringAuth`](#parameter-slotsconfigsname-webpropertiespushpropertiestagsrequiringauth) | string | Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler. |
| [`tagWhitelistJson`](#parameter-slotsconfigsname-webpropertiespushpropertiestagwhitelistjson) | string | Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint. |

### Parameter: `slots.configs.name-web.properties.push.properties.isPushEnabled`

Gets or sets a flag indicating whether the Push endpoint is enabled.

- Required: Yes
- Type: bool

### Parameter: `slots.configs.name-web.properties.push.properties.dynamicTagsJson`

Gets or sets a JSON string containing a list of dynamic tags that will be evaluated from user claims in the push registration endpoint.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.push.properties.tagsRequiringAuth`

Gets or sets a JSON string containing a list of tags that require user authentication to be used in the push registration endpoint. Tags can consist of alphanumeric characters and the following: '_', '@', '#', '.', ':', '-'. Validation should be performed at the PushRequestHandler.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.push.properties.tagWhitelistJson`

Gets or sets a JSON string containing a list of tags that are whitelisted for use by the push registration endpoint.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.pythonVersion`

Version of Python.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.remoteDebuggingEnabled`

Set to `true` if remote debugging is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.remoteDebuggingVersion`

Remote debugging version.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.requestTracingEnabled`

Set to `true` if request tracing is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.requestTracingExpirationTime`

Request tracing expiration time.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions`

IP security restrictions for scm.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsaction) | string | Allow or Deny access for this IP range. |
| [`description`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsdescription) | string | IP restriction rule description. |
| [`headers`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsheaders) | object | IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match. |
| [`ipAddress`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsipaddress) | string | IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified. |
| [`name`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsname) | string | IP restriction rule name. |
| [`priority`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionspriority) | int | Priority of IP restriction rule. |
| [`subnetMask`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionssubnetmask) | string | Subnet mask for the range of IP addresses the restriction is valid for. |
| [`subnetTrafficTag`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionssubnettraffictag) | int | (internal) Subnet traffic tag. |
| [`tag`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionstag) | string | Defines what this IP filter will be used for. This is to support IP filtering on proxies. |
| [`vnetSubnetResourceId`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsvnetsubnetresourceid) | string | Virtual network resource id. |
| [`vnetTrafficTag`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsvnettraffictag) | int | (internal) Vnet traffic tag. |

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.action`

Allow or Deny access for this IP range.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.description`

IP restriction rule description.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.headers`

IP restriction rule headers.<p>X-Forwarded-Host (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-Host#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), all hosts(or lack of) are allowed.<li>A value is compared using ordinal-ignore-case (excluding port number).<li>Subdomain wildcards are permitted but don't match the root domain. For example, *.contoso.com matches the subdomain foo.contoso.com<p>but not the root domain contoso.com or multi-level foo.bar.contoso.com<li>Unicode host names are allowed but are converted to Punycode for matching.<p><p>X-Forwarded-For (https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Forwarded-For#Examples).<p>The matching logic is ..<li>If the property is null or empty (default), any forwarded-for chains (or lack of) are allowed.<li>If any address (excluding port number) in the chain (comma separated) matches the CIDR defined by the property.<p><p>X-Azure-FDID and X-FD-HealthProbe.<p>The matching logic is exact match.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-slotsconfigsname-webpropertiesscmipsecurityrestrictionsheaders>any_other_property<) | array | A header. |

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.headers.>Any_other_property<`

A header.

- Required: Yes
- Type: array

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.ipAddress`

IP address the security restriction is valid for. It can be in form of pure ipv4 address (required SubnetMask property) or CIDR notation such as ipv4/mask (leading bit match). For CIDR, SubnetMask property must not be specified.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.name`

IP restriction rule name.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.priority`

Priority of IP restriction rule.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.subnetMask`

Subnet mask for the range of IP addresses the restriction is valid for.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.subnetTrafficTag`

(internal) Subnet traffic tag.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.tag`

Defines what this IP filter will be used for. This is to support IP filtering on proxies.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'ServiceTag'
    'XffProxy'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.vnetSubnetResourceId`

Virtual network resource id.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictions.vnetTrafficTag`

(internal) Vnet traffic tag.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictionsDefaultAction`

Default action for scm access restriction if no rules are matched.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.scmIpSecurityRestrictionsUseMain`

IP security restrictions for scm to use main.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.scmMinTlsVersion`

ScmMinTlsVersion: configures the minimum version of TLS required for SSL requests for SCM site.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '1.0'
    '1.1'
    '1.2'
    '1.3'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.scmType`

SCM type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'BitbucketGit'
    'BitbucketHg'
    'CodePlexGit'
    'CodePlexHg'
    'Dropbox'
    'ExternalGit'
    'ExternalHg'
    'GitHub'
    'LocalGit'
    'None'
    'OneDrive'
    'Tfs'
    'VSO'
    'VSTSRM'
  ]
  ```

### Parameter: `slots.configs.name-web.properties.tracingOptions`

Tracing options.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.use32BitWorkerProcess`

Set to `true` to use 32-bit worker process.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.virtualApplications`

Virtual applications.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`physicalPath`](#parameter-slotsconfigsname-webpropertiesvirtualapplicationsphysicalpath) | string | Physical path. |
| [`preloadEnabled`](#parameter-slotsconfigsname-webpropertiesvirtualapplicationspreloadenabled) | bool | Set to `true` if preloading is enabled. |
| [`virtualDirectories`](#parameter-slotsconfigsname-webpropertiesvirtualapplicationsvirtualdirectories) | array | Virtual directories for virtual application. |
| [`virtualPath`](#parameter-slotsconfigsname-webpropertiesvirtualapplicationsvirtualpath) | string | Virtual path. |

### Parameter: `slots.configs.name-web.properties.virtualApplications.physicalPath`

Physical path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.virtualApplications.preloadEnabled`

Set to `true` if preloading is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.virtualApplications.virtualDirectories`

Virtual directories for virtual application.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`physicalPath`](#parameter-slotsconfigsname-webpropertiesvirtualapplicationsvirtualdirectoriesphysicalpath) | string | Physical path. |
| [`virtualPath`](#parameter-slotsconfigsname-webpropertiesvirtualapplicationsvirtualdirectoriesvirtualpath) | string | Path to virtual application. |

### Parameter: `slots.configs.name-web.properties.virtualApplications.virtualDirectories.physicalPath`

Physical path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.virtualApplications.virtualDirectories.virtualPath`

Path to virtual application.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.virtualApplications.virtualPath`

Virtual path.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.vnetName`

Virtual Network name.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.vnetPrivatePortsCount`

The number of private ports assigned to this app. These will be assigned dynamically on runtime.

- Required: No
- Type: int

### Parameter: `slots.configs.name-web.properties.vnetRouteAllEnabled`

Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.websiteTimeZone`

Sets the time zone a site uses for generating timestamps. Compatible with Linux and Windows App Service. Setting the WEBSITE_TIME_ZONE app setting takes precedence over this config. For Linux, expects tz database values https://www.iana.org/time-zones (for a quick reference see [ref](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)). For Windows, expects one of the time zones listed under HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.webSocketsEnabled`

Set to `true` if WebSocket is enabled.

- Required: No
- Type: bool

### Parameter: `slots.configs.name-web.properties.windowsFxVersion`

Xenon App Framework and version.

- Required: No
- Type: string

### Parameter: `slots.configs.name-web.properties.xManagedServiceIdentityId`

Explicit Managed Service Identity Id.

- Required: No
- Type: int

### Parameter: `slots.containerSize`

Size of the function container.

- Required: No
- Type: int

### Parameter: `slots.customDomainVerificationId`

Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification.

- Required: No
- Type: string

### Parameter: `slots.dailyMemoryTimeQuota`

Maximum allowed daily memory-time quota (applicable on dynamic apps only).

- Required: No
- Type: int

### Parameter: `slots.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-slotsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-slotsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-slotsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-slotsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-slotsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-slotsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-slotsdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-slotsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-slotsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `slots.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `slots.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-slotsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-slotsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-slotsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `slots.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `slots.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-slotsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-slotsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `slots.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `slots.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `slots.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `slots.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `slots.dnsConfiguration`

Property to configure various DNS related settings for a site.

- Required: No
- Type: object

### Parameter: `slots.enabled`

Setting this value to false disables the app (takes the app offline).

- Required: No
- Type: bool

### Parameter: `slots.extensions`

The extensions configuration.

- Required: No
- Type: array

### Parameter: `slots.functionAppConfig`

The Function App config object.

- Required: No
- Type: object

### Parameter: `slots.hostNameSslStates`

Hostname SSL states are used to manage the SSL bindings for app's hostnames.

- Required: No
- Type: array

### Parameter: `slots.httpsOnly`

Configures a slot to accept only HTTPS requests. Issues redirect for HTTP requests.

- Required: No
- Type: bool

### Parameter: `slots.hybridConnectionRelays`

Names of hybrid connection relays to connect app with.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hybridConnectionResourceId`](#parameter-slotshybridconnectionrelayshybridconnectionresourceid) | string | The resource ID of the relay namespace hybrid connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sendKeyName`](#parameter-slotshybridconnectionrelayssendkeyname) | string | Name of the authorization rule send key to use. |

### Parameter: `slots.hybridConnectionRelays.hybridConnectionResourceId`

The resource ID of the relay namespace hybrid connection.

- Required: Yes
- Type: string

### Parameter: `slots.hybridConnectionRelays.sendKeyName`

Name of the authorization rule send key to use.

- Required: No
- Type: string

### Parameter: `slots.hyperV`

Hyper-V sandbox.

- Required: No
- Type: bool

### Parameter: `slots.keyVaultAccessIdentityResourceId`

The resource ID of the assigned identity to be used to access a key vault with.

- Required: No
- Type: string

### Parameter: `slots.location`

Location for all Resources.

- Required: No
- Type: string

### Parameter: `slots.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-slotslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-slotslockname) | string | Specify the name of lock. |

### Parameter: `slots.lock.kind`

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

### Parameter: `slots.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `slots.managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-slotsmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-slotsmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `slots.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `slots.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `slots.privateEndpoints`

Configuration details for private endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-slotsprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-slotsprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-slotsprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-slotsprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-slotsprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-slotsprivateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-slotsprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-slotsprivateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-slotsprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-slotsprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-slotsprivateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-slotsprivateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-slotsprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupResourceId`](#parameter-slotsprivateendpointsresourcegroupresourceid) | string | The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used. |
| [`roleAssignments`](#parameter-slotsprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-slotsprivateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-slotsprivateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `slots.privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `slots.privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-slotsprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-slotsprivateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `slots.privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `slots.privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `slots.privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-slotsprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `slots.privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-slotsprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-slotsprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-slotsprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `slots.privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `slots.privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-slotsprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-slotsprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `slots.privateEndpoints.lock.kind`

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

### Parameter: `slots.privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-slotsprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `slots.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-slotsprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-slotsprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `slots.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.resourceGroupResourceId`

The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'App Compliance Automation Administrator'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Web Plan Contributor'`
  - `'Website Contributor'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-slotsprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-slotsprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-slotsprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-slotsprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-slotsprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-slotsprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-slotsprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-slotsprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `slots.privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `slots.privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.roleAssignments.principalType`

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

### Parameter: `slots.privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `slots.privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `slots.publicNetworkAccess`

Allow or block all public traffic.

- Required: No
- Type: string

### Parameter: `slots.redundancyMode`

Site redundancy mode.

- Required: No
- Type: string

### Parameter: `slots.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'App Compliance Automation Administrator'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Web Plan Contributor'`
  - `'Website Contributor'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-slotsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-slotsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-slotsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-slotsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-slotsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-slotsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-slotsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-slotsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `slots.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `slots.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `slots.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `slots.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `slots.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `slots.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `slots.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `slots.roleAssignments.principalType`

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

### Parameter: `slots.serverFarmResourceId`

The resource ID of the app service plan to use for the slot.

- Required: No
- Type: string

### Parameter: `slots.siteConfig`

The site config object.

- Required: No
- Type: object

### Parameter: `slots.storageAccountRequired`

Checks if Customer provided storage account is required.

- Required: No
- Type: bool

### Parameter: `slots.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `slots.virtualNetworkSubnetId`

Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.

- Required: No
- Type: string

### Parameter: `slots.vnetContentShareEnabled`

To enable accessing content over virtual network.

- Required: No
- Type: bool

### Parameter: `slots.vnetImagePullEnabled`

To enable pulling image over Virtual Network.

- Required: No
- Type: bool

### Parameter: `slots.vnetRouteAllEnabled`

Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.

- Required: No
- Type: bool

### Parameter: `storageAccountRequired`

Checks if Customer provided storage account is required.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualNetworkSubnetId`

Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.

- Required: No
- Type: string

### Parameter: `vnetContentShareEnabled`

To enable accessing content over virtual network.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vnetImagePullEnabled`

To enable pulling image over Virtual Network.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vnetRouteAllEnabled`

Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `customDomainVerificationId` | string | Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification. |
| `defaultHostname` | string | Default hostname of the app. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `outboundIpAddresses` | string | The outbound IP addresses of the app. |
| `privateEndpoints` | array | The private endpoints of the site. |
| `resourceGroupName` | string | The resource group the site was deployed into. |
| `resourceId` | string | The resource ID of the site. |
| `slots` | array | The slots of the site. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.10.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Notes

### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": {
      "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
      "EASYAUTH_SECRET": "https://adp-#_namePrefix_#-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
      "FUNCTIONS_EXTENSION_VERSION": "~4",
      "FUNCTIONS_WORKER_RUNTIME": "dotnet"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  EASYAUTH_SECRET: 'https://adp-#_namePrefix_#-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
