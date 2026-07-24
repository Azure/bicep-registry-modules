# App ManagedEnvironments `[Microsoft.App/managedEnvironments]`

This module deploys an App Managed Environment (also known as a Container App Environment).

You can reference the module as follows:
```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
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
| `Microsoft.App/managedEnvironments` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments)</li></ul> |
| `Microsoft.App/managedEnvironments/certificates` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/certificates)</li></ul> |
| `Microsoft.App/managedEnvironments/storages` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/storages)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/managed-environment:<version>`.

- [No App Logging](#example-1-no-app-logging)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Enable public access](#example-4-enable-public-access)
- [With an external certificate](#example-5-with-an-external-certificate)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _No App Logging_

This instance deploys the module to use Azure Monitor for logging.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/azure-monitor]


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  params: {
    // Required parameters
    name: 'ameamon001'
    // Non-required parameters
    appLogsConfiguration: {
      destination: 'azure-monitor'
    }
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
      "value": "ameamon001"
    },
    // Non-required parameters
    "appLogsConfiguration": {
      "value": {
        "destination": "azure-monitor"
      }
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'ameamon001'
// Non-required parameters
param appLogsConfiguration = {
  destination: 'azure-monitor'
}
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  params: {
    // Required parameters
    name: 'amemin001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
      "value": "amemin001"
    },
    // Non-required parameters
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amemin001'
// Non-required parameters
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  params: {
    // Required parameters
    name: 'amemax001'
    // Non-required parameters
    appInsightsConnectionString: '<appInsightsConnectionString>'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    }
    certificate: {
      certificateKeyVaultProperties: {
        identityResourceId: '<identityResourceId>'
        keyVaultUrl: '<keyVaultUrl>'
      }
      name: 'dep-cert-amemax'
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'ContainerAppConsoleLogs'
          }
          {
            category: 'ContainerAppSystemLogs'
          }
        ]
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
    dnsSuffix: 'contoso.com'
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
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
    openTelemetryConfiguration: {
      logsConfiguration: {
        destinations: [
          'appInsights'
        ]
      }
      tracesConfiguration: {
        destinations: [
          'appInsights'
        ]
      }
    }
    peerTrafficEncryption: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    privateEndpoints: [
      {
        customDnsConfigs: [
          {
            fqdn: 'abc.managedEnvironments.com'
            ipAddresses: [
              '10.0.0.10'
            ]
          }
        ]
        ipConfigurations: [
          {
            name: 'myIPconfig'
            properties: {
              groupId: 'managedEnvironments'
              memberName: 'default'
              privateIPAddress: '10.0.0.10'
            }
          }
        ]
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
            }
          ]
        }
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Owner'
          }
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
          }
        ]
        service: 'managedEnvironments'
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
        resourceGroupResourceId: '<resourceGroupResourceId>'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    roleAssignments: [
      {
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
    storages: [
      {
        accessMode: 'ReadWrite'
        kind: 'SMB'
        name: 'smbfileshare'
        storageAccountName: '<storageAccountName>'
      }
      {
        accessMode: 'ReadWrite'
        kind: 'NFS'
        name: 'nfsfileshare'
        storageAccountName: '<storageAccountName>'
      }
    ]
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
      "value": "amemax001"
    },
    // Non-required parameters
    "appInsightsConnectionString": {
      "value": "<appInsightsConnectionString>"
    },
    "appLogsConfiguration": {
      "value": {
        "destination": "log-analytics",
        "logAnalyticsWorkspaceResourceId": "<logAnalyticsWorkspaceResourceId>"
      }
    },
    "certificate": {
      "value": {
        "certificateKeyVaultProperties": {
          "identityResourceId": "<identityResourceId>",
          "keyVaultUrl": "<keyVaultUrl>"
        },
        "name": "dep-cert-amemax"
      }
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "ContainerAppConsoleLogs"
            },
            {
              "category": "ContainerAppSystemLogs"
            }
          ],
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
    "dnsSuffix": {
      "value": "contoso.com"
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
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
    "openTelemetryConfiguration": {
      "value": {
        "logsConfiguration": {
          "destinations": [
            "appInsights"
          ]
        },
        "tracesConfiguration": {
          "destinations": [
            "appInsights"
          ]
        }
      }
    },
    "peerTrafficEncryption": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "privateEndpoints": {
      "value": [
        {
          "customDnsConfigs": [
            {
              "fqdn": "abc.managedEnvironments.com",
              "ipAddresses": [
                "10.0.0.10"
              ]
            }
          ],
          "ipConfigurations": [
            {
              "name": "myIPconfig",
              "properties": {
                "groupId": "managedEnvironments",
                "memberName": "default",
                "privateIPAddress": "10.0.0.10"
              }
            }
          ],
          "privateDnsZoneGroup": {
            "privateDnsZoneGroupConfigs": [
              {
                "privateDnsZoneResourceId": "<privateDnsZoneResourceId>"
              }
            ]
          },
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Owner"
            },
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
            }
          ],
          "service": "managedEnvironments",
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
          "resourceGroupResourceId": "<resourceGroupResourceId>",
          "subnetResourceId": "<subnetResourceId>"
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
    "storages": {
      "value": [
        {
          "accessMode": "ReadWrite",
          "kind": "SMB",
          "name": "smbfileshare",
          "storageAccountName": "<storageAccountName>"
        },
        {
          "accessMode": "ReadWrite",
          "kind": "NFS",
          "name": "nfsfileshare",
          "storageAccountName": "<storageAccountName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amemax001'
// Non-required parameters
param appInsightsConnectionString = '<appInsightsConnectionString>'
param appLogsConfiguration = {
  destination: 'log-analytics'
  logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
}
param certificate = {
  certificateKeyVaultProperties: {
    identityResourceId: '<identityResourceId>'
    keyVaultUrl: '<keyVaultUrl>'
  }
  name: 'dep-cert-amemax'
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        category: 'ContainerAppConsoleLogs'
      }
      {
        category: 'ContainerAppSystemLogs'
      }
    ]
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
param dnsSuffix = 'contoso.com'
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
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
param openTelemetryConfiguration = {
  logsConfiguration: {
    destinations: [
      'appInsights'
    ]
  }
  tracesConfiguration: {
    destinations: [
      'appInsights'
    ]
  }
}
param peerTrafficEncryption = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param privateEndpoints = [
  {
    customDnsConfigs: [
      {
        fqdn: 'abc.managedEnvironments.com'
        ipAddresses: [
          '10.0.0.10'
        ]
      }
    ]
    ipConfigurations: [
      {
        name: 'myIPconfig'
        properties: {
          groupId: 'managedEnvironments'
          memberName: 'default'
          privateIPAddress: '10.0.0.10'
        }
      }
    ]
    privateDnsZoneGroup: {
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
        }
      ]
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    service: 'managedEnvironments'
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
    resourceGroupResourceId: '<resourceGroupResourceId>'
    subnetResourceId: '<subnetResourceId>'
  }
]
param roleAssignments = [
  {
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
param storages = [
  {
    accessMode: 'ReadWrite'
    kind: 'SMB'
    name: 'smbfileshare'
    storageAccountName: '<storageAccountName>'
  }
  {
    accessMode: 'ReadWrite'
    kind: 'NFS'
    name: 'nfsfileshare'
    storageAccountName: '<storageAccountName>'
  }
]
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 4: _Enable public access_

This instance deploys the module with public access enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/public-access]


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  params: {
    // Required parameters
    name: 'amepa001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    location: '<location>'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    publicNetworkAccess: 'Enabled'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
      "value": "amepa001"
    },
    // Non-required parameters
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "location": {
      "value": "<location>"
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amepa001'
// Non-required parameters
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param location = '<location>'
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param publicNetworkAccess = 'Enabled'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 5: _With an external certificate_

This instance deploys the module with its certificate being located in a different resource group.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/secondary-rg]


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  params: {
    // Required parameters
    name: 'amecert001'
    // Non-required parameters
    certificate: {
      certificateKeyVaultProperties: {
        identityResourceId: '<identityResourceId>'
        keyVaultUrl: '<keyVaultUrl>'
      }
      name: 'dep-cert-amecert'
    }
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
      "value": "amecert001"
    },
    // Non-required parameters
    "certificate": {
      "value": {
        "certificateKeyVaultProperties": {
          "identityResourceId": "<identityResourceId>",
          "keyVaultUrl": "<keyVaultUrl>"
        },
        "name": "dep-cert-amecert"
      }
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amecert001'
// Non-required parameters
param certificate = {
  certificateKeyVaultProperties: {
    identityResourceId: '<identityResourceId>'
    keyVaultUrl: '<keyVaultUrl>'
  }
  name: 'dep-cert-amecert'
}
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  params: {
    // Required parameters
    name: 'amewaf001'
    // Non-required parameters
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    }
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    managedIdentities: {
      systemAssigned: true
    }
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
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
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
      "value": "amewaf001"
    },
    // Non-required parameters
    "appLogsConfiguration": {
      "value": {
        "destination": "log-analytics",
        "logAnalyticsWorkspaceResourceId": "<logAnalyticsWorkspaceResourceId>"
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
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
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
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amewaf001'
// Non-required parameters
param appLogsConfiguration = {
  destination: 'log-analytics'
  logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
}
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param managedIdentities = {
  systemAssigned: true
}
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
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
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Container Apps Managed Environment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dockerBridgeCidr`](#parameter-dockerbridgecidr) | string | CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureResourceGroupName`](#parameter-infrastructureresourcegroupname) | string | Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureSubnetResourceId`](#parameter-infrastructuresubnetresourceid) | string | Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`internal`](#parameter-internal) | bool | Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetResourceId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`platformReservedCidr`](#parameter-platformreservedcidr) | string | IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant. |
| [`platformReservedDnsIP`](#parameter-platformreserveddnsip) | string | An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`workloadProfiles`](#parameter-workloadprofiles) | array | Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | securestring | Application Insights connection string. |
| [`appLogsConfiguration`](#parameter-applogsconfiguration) | object | The AppLogsConfiguration for the Managed Environment. |
| [`certificate`](#parameter-certificate) | object | A Managed Environment Certificate. |
| [`certificatePassword`](#parameter-certificatepassword) | securestring | Password of the certificate used by the custom domain. |
| [`certificateValue`](#parameter-certificatevalue) | securestring | Certificate to use for the custom domain. PFX or PEM. |
| [`daprAIConnectionString`](#parameter-dapraiconnectionstring) | securestring | Application Insights connection string used by Dapr to export Service to Service communication telemetry. |
| [`daprAIInstrumentationKey`](#parameter-dapraiinstrumentationkey) | securestring | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| [`daprConfiguration`](#parameter-daprconfiguration) | object | The configuration of Dapr component. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. If neither metrics nor logs are specified, all metrics & logs are configured by default. If only one of them is specified, the other one will not be configured. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | DNS suffix for the environment domain. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ingressConfiguration`](#parameter-ingressconfiguration) | object | Ingress configuration for the Managed Environment. |
| [`kedaConfiguration`](#parameter-kedaconfiguration) | object | The configuration of Keda component. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`openTelemetryConfiguration`](#parameter-opentelemetryconfiguration) | object | Open Telemetry configuration. |
| [`peerAuthentication`](#parameter-peerauthentication) | object | Peer authentication settings for the Managed Environment. |
| [`peerTrafficEncryption`](#parameter-peertrafficencryption) | bool | Whether or not to encrypt peer traffic. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether to allow or block all public traffic. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`storages`](#parameter-storages) | array | The list of storages to mount on the environment. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this Managed Environment is zone-redundant. |

### Parameter: `name`

Name of the Container Apps Managed Environment.

- Required: Yes
- Type: string

### Parameter: `dockerBridgeCidr`

CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `infrastructureResourceGroupName`

Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `[take(format('ME_{0}', parameters('name')), 63)]`

### Parameter: `infrastructureSubnetResourceId`

Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string

### Parameter: `internal`

Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetResourceId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `platformReservedCidr`

IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `platformReservedDnsIP`

An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `workloadProfiles`

Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: array

### Parameter: `appInsightsConnectionString`

Application Insights connection string.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `appLogsConfiguration`

The AppLogsConfiguration for the Managed Environment.

- Required: No
- Type: object
- Discriminator: `destination`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`azure-monitor`](#variant-applogsconfigurationdestination-azure-monitor) | The type for the App Logs Configuration if using azure-monitor. |
| [`log-analytics`](#variant-applogsconfigurationdestination-log-analytics) | The type for the App Logs Configuration if using log-analytics. |

### Variant: `appLogsConfiguration.destination-azure-monitor`
The type for the App Logs Configuration if using azure-monitor.

To use this variant, set the property `destination` to `azure-monitor`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-applogsconfigurationdestination-azure-monitordestination) | string | The destination of the logs. |

### Parameter: `appLogsConfiguration.destination-azure-monitor.destination`

The destination of the logs.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'azure-monitor'
  ]
  ```

### Variant: `appLogsConfiguration.destination-log-analytics`
The type for the App Logs Configuration if using log-analytics.

To use this variant, set the property `destination` to `log-analytics`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-applogsconfigurationdestination-log-analyticsdestination) | string | The destination of the logs. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-applogsconfigurationdestination-log-analyticsloganalyticsworkspaceresourceid) | string | Existing Log Analytics Workspace resource ID. |

### Parameter: `appLogsConfiguration.destination-log-analytics.destination`

The destination of the logs.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'log-analytics'
  ]
  ```

### Parameter: `appLogsConfiguration.destination-log-analytics.logAnalyticsWorkspaceResourceId`

Existing Log Analytics Workspace resource ID.

- Required: Yes
- Type: string

### Parameter: `certificate`

A Managed Environment Certificate.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateKeyVaultProperties`](#parameter-certificatecertificatekeyvaultproperties) | object | A key vault reference. |
| [`certificatePassword`](#parameter-certificatecertificatepassword) | securestring | The password of the certificate. |
| [`certificateType`](#parameter-certificatecertificatetype) | string | The type of the certificate. |
| [`certificateValue`](#parameter-certificatecertificatevalue) | string | The value of the certificate. PFX or PEM blob. |
| [`location`](#parameter-certificatelocation) | string | The location for the resource. |
| [`name`](#parameter-certificatename) | string | The name of the certificate. |
| [`tags`](#parameter-certificatetags) | object | Tags of the resource. |

### Parameter: `certificate.certificateKeyVaultProperties`

A key vault reference.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityResourceId`](#parameter-certificatecertificatekeyvaultpropertiesidentityresourceid) | string | The resource ID of the identity. This is the identity that will be used to access the key vault. |
| [`keyVaultUrl`](#parameter-certificatecertificatekeyvaultpropertieskeyvaulturl) | string | A key vault URL referencing the wildcard certificate that will be used for the custom domain. |

### Parameter: `certificate.certificateKeyVaultProperties.identityResourceId`

The resource ID of the identity. This is the identity that will be used to access the key vault.

- Required: Yes
- Type: string

### Parameter: `certificate.certificateKeyVaultProperties.keyVaultUrl`

A key vault URL referencing the wildcard certificate that will be used for the custom domain.

- Required: Yes
- Type: string

### Parameter: `certificate.certificatePassword`

The password of the certificate.

- Required: No
- Type: securestring

### Parameter: `certificate.certificateType`

The type of the certificate.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ImagePullTrustedCA'
    'ServerSSLCertificate'
  ]
  ```

### Parameter: `certificate.certificateValue`

The value of the certificate. PFX or PEM blob.

- Required: No
- Type: string

### Parameter: `certificate.location`

The location for the resource.

- Required: No
- Type: string

### Parameter: `certificate.name`

The name of the certificate.

- Required: No
- Type: string

### Parameter: `certificate.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `certificatePassword`

Password of the certificate used by the custom domain.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `certificateValue`

Certificate to use for the custom domain. PFX or PEM.

- Required: No
- Type: securestring

### Parameter: `daprAIConnectionString`

Application Insights connection string used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIInstrumentationKey`

Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprConfiguration`

The configuration of Dapr component.

- Required: No
- Type: object

### Parameter: `diagnosticSettings`

The diagnostic settings of the service. If neither metrics nor logs are specified, all metrics & logs are configured by default. If only one of them is specified, the other one will not be configured.

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

### Parameter: `dnsSuffix`

DNS suffix for the environment domain.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ingressConfiguration`

Ingress configuration for the Managed Environment.

- Required: No
- Type: object

### Parameter: `kedaConfiguration`

The configuration of Keda component.

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

### Parameter: `openTelemetryConfiguration`

Open Telemetry configuration.

- Required: No
- Type: object

### Parameter: `peerAuthentication`

Peer authentication settings for the Managed Environment.

- Required: No
- Type: object

### Parameter: `peerTrafficEncryption`

Whether or not to encrypt peer traffic.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `publicNetworkAccess`

Whether to allow or block all public traffic.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

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

### Parameter: `storages`

The list of storages to mount on the environment.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-storagesaccessmode) | string | Access mode for storage: "ReadOnly" or "ReadWrite". |
| [`kind`](#parameter-storageskind) | string | Type of storage: "SMB" or "NFS". |
| [`name`](#parameter-storagesname) | string | File share name. |
| [`storageAccountName`](#parameter-storagesstorageaccountname) | string | Storage account name. |

### Parameter: `storages.accessMode`

Access mode for storage: "ReadOnly" or "ReadWrite".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `storages.kind`

Type of storage: "SMB" or "NFS".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `storages.name`

File share name.

- Required: Yes
- Type: string

### Parameter: `storages.storageAccountName`

Storage account name.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneRedundant`

Whether or not this Managed Environment is zone-redundant.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultDomain` | string | The Default domain of the Managed Environment. |
| `domainVerificationId` | string | The domain verification id for custom domains. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Managed Environment. |
| `resourceGroupName` | string | The name of the resource group the Managed Environment was deployed into. |
| `resourceId` | string | The resource ID of the Managed Environment. |
| `staticIp` | string | The IP address of the Managed Environment. Only populated for internal Managed Environments deployed into a VNet. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.12.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.7.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
