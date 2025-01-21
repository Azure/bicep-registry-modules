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
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/sites` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/config) |
| `Microsoft.Web/sites/extensions` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/extensions) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots) |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/basicPublishingCredentialsPolicies) |
| `Microsoft.Web/sites/slots/config` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/config) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-04-01/sites/slots/hybridConnectionNamespaces/relays) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/site:<version>`.

- [Function App, using only defaults](#example-1-function-app-using-only-defaults)
- [Function App, using large parameter set](#example-2-function-app-using-large-parameter-set)
- [Function App, with App Settings Pairs](#example-3-function-app-with-app-settings-pairs)
- [Linux Container Web App, using only defaults](#example-4-linux-container-web-app-using-only-defaults)
- [Web App, with Logs Configuration](#example-5-web-app-with-logs-configuration)
- [WAF-aligned](#example-6-waf-aligned)
- [Web App, using only defaults](#example-7-web-app-using-only-defaults)
- [Web App, using large parameter set](#example-8-web-app-using-large-parameter-set)
- [Linux Web App, using only defaults](#example-9-linux-web-app-using-only-defaults)
- [Linux Web App, using large parameter set](#example-10-linux-web-app-using-large-parameter-set)
- [Web App, with Web Configuration](#example-11-web-app-with-web-configuration)
- [Windows Web App for Containers, using only defaults](#example-12-windows-web-app-for-containers-using-only-defaults)

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
    appInsightResourceId: '<appInsightResourceId>'
    appSettingsKeyValuePairs: {
      AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
      EASYAUTH_SECRET: '<EASYAUTH_SECRET>'
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    }
    authSettingV2Configuration: {
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
        resourceId: '<resourceId>'
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
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
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
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "appSettingsKeyValuePairs": {
      "value": {
        "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
        "EASYAUTH_SECRET": "<EASYAUTH_SECRET>",
        "FUNCTIONS_EXTENSION_VERSION": "~4",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet"
      }
    },
    "authSettingV2Configuration": {
      "value": {
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
    },
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
          "resourceId": "<resourceId>",
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
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "storageAccountUseIdentityAuthentication": {
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
param kind = 'functionapp'
param name = 'wsfamax001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param appInsightResourceId = '<appInsightResourceId>'
param appSettingsKeyValuePairs = {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  EASYAUTH_SECRET: '<EASYAUTH_SECRET>'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
authSettingV2Configuration: {
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
    resourceId: '<resourceId>'
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
param storageAccountResourceId = '<storageAccountResourceId>'
param storageAccountUseIdentityAuthentication = true
```

</details>
<p>

### Example 3: _Function App, with App Settings Pairs_

This instance deploys the module as Function App with sample app settings.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: 'wsfaset001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    appSettingsKeyValuePairs: {
      AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
      FUNCTIONS_EXTENSION_VERSION: '~4'
      FUNCTIONS_WORKER_RUNTIME: 'dotnet'
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
      "value": "wsfaset001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "appSettingsKeyValuePairs": {
      "value": {
        "AzureFunctionsJobHost__logging__logLevel__default": "Trace",
        "FUNCTIONS_EXTENSION_VERSION": "~4",
        "FUNCTIONS_WORKER_RUNTIME": "dotnet"
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
param name = 'wsfaset001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param appSettingsKeyValuePairs = {
  AzureFunctionsJobHost__logging__logLevel__default: 'Trace'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

### Example 4: _Linux Container Web App, using only defaults_

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

### Example 5: _Web App, with Logs Configuration_

This instance deploys the module as Web App with the set of logs configuration.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wslc001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    appInsightResourceId: '<appInsightResourceId>'
    appSettingsKeyValuePairs: {
      ENABLE_ORYX_BUILD: 'True'
      JAVA_OPTS: '<JAVA_OPTS>'
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'True'
    }
    logsConfiguration: {
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
    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      alwaysOn: true
      appCommandLine: ''
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
      "value": "app"
    },
    "name": {
      "value": "wslc001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "appSettingsKeyValuePairs": {
      "value": {
        "ENABLE_ORYX_BUILD": "True",
        "JAVA_OPTS": "<JAVA_OPTS>",
        "SCM_DO_BUILD_DURING_DEPLOYMENT": "True"
      }
    },
    "logsConfiguration": {
      "value": {
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "appCommandLine": ""
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
param kind = 'app'
param name = 'wslc001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param appInsightResourceId = '<appInsightResourceId>'
param appSettingsKeyValuePairs = {
  ENABLE_ORYX_BUILD: 'True'
  JAVA_OPTS: '<JAVA_OPTS>'
  SCM_DO_BUILD_DURING_DEPLOYMENT: 'True'
}
param logsConfiguration = {
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
param managedIdentities = {
  systemAssigned: true
}
param siteConfig = {
  alwaysOn: true
  appCommandLine: ''
}
```

</details>
<p>

### Example 6: _WAF-aligned_

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

### Example 7: _Web App, using only defaults_

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

### Example 8: _Web App, using large parameter set_

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
        resourceId: '<resourceId>'
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
            resourceId: '<resourceId>'
            sendKeyName: 'defaultSender'
          }
        ]
        name: 'slot1'
        privateEndpoints: [
          {
            privateDnsZoneResourceIds: [
              '<privateDNSZoneResourceId>'
            ]
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
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
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
        name: 'slot2'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
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
          "resourceId": "<resourceId>",
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
              "resourceId": "<resourceId>",
              "sendKeyName": "defaultSender"
            }
          ],
          "name": "slot1",
          "privateEndpoints": [
            {
              "privateDnsZoneResourceIds": [
                "<privateDNSZoneResourceId>"
              ],
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
          },
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
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
          "name": "slot2",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
        }
      ]
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "storageAccountUseIdentityAuthentication": {
      "value": true
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
    resourceId: '<resourceId>'
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
        resourceId: '<resourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    name: 'slot1'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
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
    name: 'slot2'
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
  }
]
param storageAccountResourceId = '<storageAccountResourceId>'
param storageAccountUseIdentityAuthentication = true
param vnetContentShareEnabled = true
param vnetImagePullEnabled = true
param vnetRouteAllEnabled = true
```

</details>
<p>

### Example 9: _Linux Web App, using only defaults_

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

### Example 10: _Linux Web App, using large parameter set_

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
        resourceId: '<resourceId>'
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
            resourceId: '<resourceId>'
            sendKeyName: 'defaultSender'
          }
        ]
        name: 'slot1'
        privateEndpoints: [
          {
            privateDnsZoneResourceIds: [
              '<privateDNSZoneResourceId>'
            ]
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
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
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
        name: 'slot2'
        storageAccountResourceId: '<storageAccountResourceId>'
        storageAccountUseIdentityAuthentication: true
      }
    ]
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
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
          "resourceId": "<resourceId>",
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
              "resourceId": "<resourceId>",
              "sendKeyName": "defaultSender"
            }
          ],
          "name": "slot1",
          "privateEndpoints": [
            {
              "privateDnsZoneResourceIds": [
                "<privateDNSZoneResourceId>"
              ],
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
          },
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
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
          "name": "slot2",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "storageAccountUseIdentityAuthentication": true
        }
      ]
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "storageAccountUseIdentityAuthentication": {
      "value": true
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
    resourceId: '<resourceId>'
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
        resourceId: '<resourceId>'
        sendKeyName: 'defaultSender'
      }
    ]
    name: 'slot1'
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
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
    name: 'slot2'
    storageAccountResourceId: '<storageAccountResourceId>'
    storageAccountUseIdentityAuthentication: true
  }
]
param storageAccountResourceId = '<storageAccountResourceId>'
param storageAccountUseIdentityAuthentication = true
param vnetContentShareEnabled = true
param vnetImagePullEnabled = true
param vnetRouteAllEnabled = true
```

</details>
<p>

### Example 11: _Web App, with Web Configuration_

This instance deploys the module as a Web App with web configuration to demonstrate its usage. Deploying a configuration containing API Management and Ip Security Restrictions.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: 'siteDeployment'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswc001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    appInsightResourceId: '<appInsightResourceId>'
    appSettingsKeyValuePairs: {
      ENABLE_ORYX_BUILD: 'True'
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'False'
    }
    managedIdentities: {
      systemAssigned: true
    }
    siteConfig: {
      alwaysOn: true
      appCommandLine: ''
    }
    webConfiguration: {
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
      "value": "wswc001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "appInsightResourceId": {
      "value": "<appInsightResourceId>"
    },
    "appSettingsKeyValuePairs": {
      "value": {
        "ENABLE_ORYX_BUILD": "True",
        "SCM_DO_BUILD_DURING_DEPLOYMENT": "False"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "appCommandLine": ""
      }
    },
    "webConfiguration": {
      "value": {
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
param name = 'wswc001'
param serverFarmResourceId = '<serverFarmResourceId>'
// Non-required parameters
param appInsightResourceId = '<appInsightResourceId>'
param appSettingsKeyValuePairs = {
  ENABLE_ORYX_BUILD: 'True'
  SCM_DO_BUILD_DURING_DEPLOYMENT: 'False'
}
param managedIdentities = {
  systemAssigned: true
}
param siteConfig = {
  alwaysOn: true
  appCommandLine: ''
}
param webConfiguration = {
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
```

</details>
<p>

### Example 12: _Windows Web App for Containers, using only defaults_

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
| [`appInsightResourceId`](#parameter-appinsightresourceid) | string | Resource ID of the app insight to leverage for this resource. |
| [`appServiceEnvironmentResourceId`](#parameter-appserviceenvironmentresourceid) | string | The resource ID of the app service environment to use for this resource. |
| [`appSettingsKeyValuePairs`](#parameter-appsettingskeyvaluepairs) | object | The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING. |
| [`authSettingV2Configuration`](#parameter-authsettingv2configuration) | object | The auth settings V2 configuration. |
| [`basicPublishingCredentialsPolicies`](#parameter-basicpublishingcredentialspolicies) | array | The site publishing credential policy names which are associated with the sites. |
| [`clientAffinityEnabled`](#parameter-clientaffinityenabled) | bool | If client affinity is enabled. |
| [`clientCertEnabled`](#parameter-clientcertenabled) | bool | To enable client certificate authentication (TLS mutual authentication). |
| [`clientCertExclusionPaths`](#parameter-clientcertexclusionpaths) | string | Client certificate authentication comma-separated exclusion paths. |
| [`clientCertMode`](#parameter-clientcertmode) | string | This composes with ClientCertEnabled setting.<li>ClientCertEnabled=false means ClientCert is ignored.<li>ClientCertEnabled=true and ClientCertMode=Required means ClientCert is required.<li>ClientCertEnabled=true and ClientCertMode=Optional means ClientCert is optional or accepted.<p> |
| [`cloningInfo`](#parameter-cloninginfo) | object | If specified during app creation, the app is cloned from a source app. |
| [`containerSize`](#parameter-containersize) | int | Size of the function container. |
| [`dailyMemoryTimeQuota`](#parameter-dailymemorytimequota) | int | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`e2eEncryptionEnabled`](#parameter-e2eencryptionenabled) | bool | End to End Encryption Setting. |
| [`enabled`](#parameter-enabled) | bool | Setting this value to false disables the app (takes the app offline). |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`functionAppConfig`](#parameter-functionappconfig) | object | The Function App configuration object. |
| [`hostNameSslStates`](#parameter-hostnamesslstates) | array | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| [`httpsOnly`](#parameter-httpsonly) | bool | Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| [`hybridConnectionRelays`](#parameter-hybridconnectionrelays) | array | Names of hybrid connection relays to connect app with. |
| [`hyperV`](#parameter-hyperv) | bool | Hyper-V sandbox. |
| [`keyVaultAccessIdentityResourceId`](#parameter-keyvaultaccessidentityresourceid) | string | The resource ID of the assigned identity to be used to access a key vault with. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`logsConfiguration`](#parameter-logsconfiguration) | object | The logs settings configuration. |
| [`managedEnvironmentId`](#parameter-managedenvironmentid) | string | Azure Resource Manager ID of the customers selected Managed Environment on which to host this app. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`msDeployConfiguration`](#parameter-msdeployconfiguration) | object | The extension MSDeployment configuration. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`redundancyMode`](#parameter-redundancymode) | string | Site redundancy mode. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scmSiteAlsoStopped`](#parameter-scmsitealsostopped) | bool | Stop SCM (KUDU) site when the app is stopped. |
| [`siteConfig`](#parameter-siteconfig) | object | The site config object. The defaults are set to the following values: alwaysOn: true, minTlsVersion: '1.2', ftpsState: 'FtpsOnly'. |
| [`slots`](#parameter-slots) | array | Configuration for deployment slots for an app. |
| [`storageAccountRequired`](#parameter-storageaccountrequired) | bool | Checks if Customer provided storage account is required. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
| [`storageAccountUseIdentityAuthentication`](#parameter-storageaccountuseidentityauthentication) | bool | If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkSubnetId`](#parameter-virtualnetworksubnetid) | string | Azure Resource Manager ID of the Virtual network and subnet to be joined by Regional VNET Integration. This must be of the form /subscriptions/{subscriptionName}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}. |
| [`vnetContentShareEnabled`](#parameter-vnetcontentshareenabled) | bool | To enable accessing content over virtual network. |
| [`vnetImagePullEnabled`](#parameter-vnetimagepullenabled) | bool | To enable pulling image over Virtual Network. |
| [`vnetRouteAllEnabled`](#parameter-vnetrouteallenabled) | bool | Virtual Network Route All enabled. This causes all outbound traffic to have Virtual Network Security Groups and User Defined Routes applied. |
| [`webConfiguration`](#parameter-webconfiguration) | object | The Site Config, Web settings to deploy. |

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

### Parameter: `appInsightResourceId`

Resource ID of the app insight to leverage for this resource.

- Required: No
- Type: string

### Parameter: `appServiceEnvironmentResourceId`

The resource ID of the app service environment to use for this resource.

- Required: No
- Type: string

### Parameter: `appSettingsKeyValuePairs`

The app settings-value pairs except for AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING.

- Required: No
- Type: object

### Parameter: `authSettingV2Configuration`

The auth settings V2 configuration.

- Required: No
- Type: object

### Parameter: `basicPublishingCredentialsPolicies`

The site publishing credential policy names which are associated with the sites.

- Required: No
- Type: array

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

### Parameter: `logsConfiguration`

The logs settings configuration.

- Required: No
- Type: object

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

### Parameter: `msDeployConfiguration`

The extension MSDeployment configuration.

- Required: No
- Type: object

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

### Parameter: `storageAccountRequired`

Checks if Customer provided storage account is required.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `storageAccountResourceId`

Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions.

- Required: No
- Type: string

### Parameter: `storageAccountUseIdentityAuthentication`

If the provided storage account requires Identity based authentication ('allowSharedKeyAccess' is set to false). When set to true, the minimum role assignment required for the App Service Managed Identity to the storage account is 'Storage Blob Data Owner'.

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

### Parameter: `webConfiguration`

The Site Config, Web settings to deploy.

- Required: No
- Type: object

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
| `slotPrivateEndpoints` | array | The private endpoints of the slots. |
| `slotResourceIds` | array | The list of the slot resource ids. |
| `slots` | array | The list of the slots. |
| `slotSystemAssignedMIPrincipalIds` | array | The principal ID of the system assigned identity of slots. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.7.1` | Remote reference |
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
