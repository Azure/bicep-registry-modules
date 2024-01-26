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
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Web/sites` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites) |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/hybridConnectionNamespaces/relays) |
| `Microsoft.Web/sites/slots` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots) |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/slots/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2022-09-01/sites/slots/hybridConnectionNamespaces/relays) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/web/site:<version>`.

- [Function App, using only defaults](#example-1-function-app-using-only-defaults)
- [Function App, using large parameter set](#example-2-function-app-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)
- [Web App, using only defaults](#example-4-web-app-using-only-defaults)
- [Web App, using large parameter set](#example-5-web-app-using-large-parameter-set)

### Example 1: _Function App, using only defaults_

This instance deploys the module as Function App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-wsfamin'
  params: {
    // Required parameters
    kind: 'functionapp'
    name: 'wsfamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
    // Non-required parameters
    location: '<location>'
    siteConfig: {
      alwaysOn: true
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
    "kind": {
      "value": "functionapp"
    },
    "name": {
      "value": "wsfamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Function App, using large parameter set_

This instance deploys the module as Function App with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-wsfamax'
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
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
    setAzureWebJobsDashboard: true
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
    }
    storageAccountResourceId: '<storageAccountResourceId>'
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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
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
    "setAzureWebJobsDashboard": {
      "value": true
    },
    "siteConfig": {
      "value": {
        "alwaysOn": true,
        "use32BitWorkerProcess": false
      }
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
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
module site 'br/public:avm/res/web/site:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-wswaf'
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
    location: '<location>'
    publicNetworkAccess: 'Disabled'
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
    vnetContentShareEnabled: true
    vnetImagePullEnabled: true
    vnetRouteAllEnabled: true
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
    "location": {
      "value": "<location>"
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
        "metadata": [
          {
            "name": "CURRENT_STACK",
            "value": "dotnetcore"
          }
        ]
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

### Example 4: _Web App, using only defaults_

This instance deploys the module as Web App with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-wswamin'
  params: {
    // Required parameters
    kind: 'app'
    name: 'wswamin001'
    serverFarmResourceId: '<serverFarmResourceId>'
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
    "kind": {
      "value": "app"
    },
    "name": {
      "value": "wswamin001"
    },
    "serverFarmResourceId": {
      "value": "<serverFarmResourceId>"
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

### Example 5: _Web App, using large parameter set_

This instance deploys the module as Web App with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module site 'br/public:avm/res/web/site:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-wswamax'
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
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
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

<summary>via JSON Parameter file</summary>

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
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
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
| [`clientCertMode`](#parameter-clientcertmode) | string | This composes with ClientCertEnabled setting.
- ClientCertEnabled=false means ClientCert is ignored.
- ClientCertEnabled=true and ClientCertMode=Required means ClientCert is required.
- ClientCertEnabled=true and ClientCertMode=Optional means ClientCert is optional or accepted.
 |
| [`cloningInfo`](#parameter-cloninginfo) | object | If specified during app creation, the app is cloned from a source app. |
| [`containerSize`](#parameter-containersize) | int | Size of the function container. |
| [`customDomainVerificationId`](#parameter-customdomainverificationid) | string | Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification. |
| [`dailyMemoryTimeQuota`](#parameter-dailymemorytimequota) | int | Maximum allowed daily memory-time quota (applicable on dynamic apps only). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enabled`](#parameter-enabled) | bool | Setting this value to false disables the app (takes the app offline). |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hostNameSslStates`](#parameter-hostnamesslstates) | array | Hostname SSL states are used to manage the SSL bindings for app's hostnames. |
| [`httpsOnly`](#parameter-httpsonly) | bool | Configures a site to accept only HTTPS requests. Issues redirect for HTTP requests. |
| [`hybridConnectionRelays`](#parameter-hybridconnectionrelays) | array | Names of hybrid connection relays to connect app with. |
| [`hyperV`](#parameter-hyperv) | bool | Hyper-V sandbox. |
| [`keyVaultAccessIdentityResourceId`](#parameter-keyvaultaccessidentityresourceid) | string | The resource ID of the assigned identity to be used to access a key vault with. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set. |
| [`redundancyMode`](#parameter-redundancymode) | string | Site redundancy mode. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scmSiteAlsoStopped`](#parameter-scmsitealsostopped) | bool | Stop SCM (KUDU) site when the app is stopped. |
| [`setAzureWebJobsDashboard`](#parameter-setazurewebjobsdashboard) | bool | For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons. |
| [`siteConfig`](#parameter-siteconfig) | object | The site config object. |
| [`slots`](#parameter-slots) | array | Configuration for deployment slots for an app. |
| [`storageAccountRequired`](#parameter-storageaccountrequired) | bool | Checks if Customer provided storage account is required. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | Required if app of kind functionapp. Resource ID of the storage account to manage triggers and logging function executions. |
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
    'app'
    'functionapp'
    'functionapp,linux'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
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

This composes with ClientCertEnabled setting.
- ClientCertEnabled=false means ClientCert is ignored.
- ClientCertEnabled=true and ClientCertMode=Required means ClientCert is required.
- ClientCertEnabled=true and ClientCertMode=Optional means ClientCert is optional or accepted.


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

### Parameter: `customDomainVerificationId`

Unique identifier that verifies the custom domains assigned to the app. Customer will add this ID to a txt record for verification.

- Required: No
- Type: string

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
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to '' to disable metric collection. |
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

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to '' to disable metric collection.

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
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | array | Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

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

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

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

The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

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

### Parameter: `setAzureWebJobsDashboard`

For function apps. If true the app settings "AzureWebJobsDashboard" will be set. If false not. In case you use Application Insights it can make sense to not set it for performance reasons.

- Required: No
- Type: bool
- Default: `[if(contains(parameters('kind'), 'functionapp'), true(), false())]`

### Parameter: `siteConfig`

The site config object.

- Required: No
- Type: object

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
| `defaultHostname` | string | Default hostname of the app. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the site. |
| `resourceGroupName` | string | The resource group the site was deployed into. |
| `resourceId` | string | The resource ID of the site. |
| `slotResourceIds` | array | The list of the slot resource ids. |
| `slots` | array | The list of the slots. |
| `slotSystemAssignedMIPrincipalIds` | array | The principal ID of the system assigned identity of slots. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.3.2` | Remote reference |

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
      "EASYAUTH_SECRET": "https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password",
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
  EASYAUTH_SECRET: 'https://adp-[[namePrefix]]-az-kv-x-001.vault.azure.net/secrets/Modules-Test-SP-Password'
  FUNCTIONS_EXTENSION_VERSION: '~4'
  FUNCTIONS_WORKER_RUNTIME: 'dotnet'
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
