# Dev Center `[Microsoft.DevCenter/devcenters]`

This module deploys an Azure Dev Center.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DevCenter/devcenters` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters) |
| `Microsoft.DevCenter/devcenters/attachednetworks` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/attachednetworks) |
| `Microsoft.DevCenter/devcenters/catalogs` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/catalogs) |
| `Microsoft.DevCenter/devcenters/devboxdefinitions` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/devboxdefinitions) |
| `Microsoft.DevCenter/devcenters/environmentTypes` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/environmentTypes) |
| `Microsoft.DevCenter/devcenters/galleries` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/galleries) |
| `Microsoft.DevCenter/devcenters/projectPolicies` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/devcenters/projectPolicies) |
| `Microsoft.DevCenter/projects` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects) |
| `Microsoft.DevCenter/projects/catalogs` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/catalogs) |
| `Microsoft.DevCenter/projects/environmentTypes` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/environmentTypes) |
| `Microsoft.DevCenter/projects/pools` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools) |
| `Microsoft.DevCenter/projects/pools/schedules` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools/schedules) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/dev-center/devcenter:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module devcenter 'br/public:avm/res/dev-center/devcenter:<version>' = {
  name: 'devcenterDeployment'
  params: {
    // Required parameters
    name: 'dcdcmin001'
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
      "value": "dcdcmin001"
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
using 'br/public:avm/res/dev-center/devcenter:<version>'

// Required parameters
param name = 'dcdcmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module devcenter 'br/public:avm/res/dev-center/devcenter:<version>' = {
  name: 'devcenterDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    attachedNetworks: [
      {
        name: 'test-attached-network'
        networkConnectionResourceId: '<networkConnectionResourceId>'
      }
    ]
    catalogs: [
      {
        gitHub: {
          branch: 'main'
          path: 'Environment-Definitions'
          uri: 'https://github.com/microsoft/devcenter-catalog.git'
        }
        name: 'quickstart-catalog'
        syncType: 'Scheduled'
      }
      {
        adoGit: {
          branch: 'main'
          secretIdentifier: '<secretIdentifier>'
          uri: 'https://contoso@dev.azure.com/contoso/your-project/_git/your-repo'
        }
        name: 'testCatalogAzureDevOpsGit'
        syncType: 'Manual'
      }
    ]
    devboxDefinitions: [
      {
        hibernateSupport: 'Enabled'
        imageResourceId: '<imageResourceId>'
        name: 'test-devbox-definition-builtin-gallery-image'
        sku: {
          capacity: 1
          family: 'general_i'
          name: 'general_i_8c32gb512ssd_v2'
        }
        tags: {
          costCenter: '1234'
        }
      }
      {
        imageResourceId: '<imageResourceId>'
        name: 'test-devbox-definition-custom-gallery-image'
        sku: {
          name: 'general_i_8c32gb256ssd_v2'
        }
      }
    ]
    devBoxProvisioningSettings: {
      installAzureMonitorAgentEnableStatus: 'Enabled'
    }
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
    displayName: 'Dev Center Test'
    environmentTypes: [
      {
        displayName: 'Development Environment'
        name: 'dev'
        tags: {
          costCenter: '1234'
        }
      }
      {
        displayName: 'Testing Environment'
        name: 'test'
        tags: {
          costCenter: '5678'
        }
      }
      {
        displayName: 'Production Environment'
        name: 'prod'
        tags: {
          costCenter: '9012'
        }
      }
    ]
    galleries: [
      {
        devCenterIdentityPrincipalId: '<devCenterIdentityPrincipalId>'
        galleryResourceId: '<galleryResourceId>'
        name: 'computegallery'
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
    networkSettings: {
      microsoftHostedNetworkEnableStatus: 'Disabled'
    }
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: 'Enabled'
    }
    projectPolicies: [
      {
        name: 'Default'
        resourcePolicies: [
          {
            action: 'Allow'
            resourceType: 'Images'
          }
          {
            action: 'Allow'
            resourceType: 'Skus'
          }
          {
            action: 'Allow'
            resourceType: 'AttachedNetworks'
          }
        ]
      }
      {
        name: 'DevProjectsPolicy'
        projectsResourceIdOrName: [
          '<value>/providers/Microsoft.DevCenter/projects/test-project-another-resource-group'
          'test-project-same-resource-group'
        ]
        resourcePolicies: [
          {
            filter: 'Name eq \'general_i_8c32gb512ssd_v2\''
            resources: '<resources>'
          }
          {
            resources: '<resources>'
          }
          {
            resources: '<resources>'
          }
          {
            action: 'Deny'
            resourceType: 'AttachedNetworks'
          }
        ]
      }
    ]
    projects: [
      {
        catalogSettings: {
          catalogItemSyncTypes: [
            'EnvironmentDefinition'
            'ImageDefinition'
          ]
        }
        environmentTypes: [
          {
            creatorRoleAssignmentRoles: [
              'acdd72a7-3385-48ef-bd42-f606fba81ae7'
            ]
            deploymentTargetSubscriptionResourceId: '<deploymentTargetSubscriptionResourceId>'
            displayName: 'My Sandbox Environment Type'
            managedIdentities: {
              systemAssigned: false
              userAssignedResourceIds: [
                '<managedIdentityResourceId>'
              ]
            }
            name: 'dep-et-dcdcmax'
            status: 'Enabled'
          }
        ]
        managedIdentities: {
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        maxDevBoxesPerUser: 2
        name: 'test-project-same-resource-group'
        pools: [
          {
            devBoxDefinitionName: 'test-devbox-definition-builtin-gallery-image'
            devBoxDefinitionType: 'Reference'
            displayName: 'My Sandbox Pool - Managed Network'
            localAdministrator: 'Disabled'
            managedVirtualNetworkRegion: 'westeurope'
            name: 'sandbox-pool'
            singleSignOnStatus: 'Enabled'
            stopOnDisconnect: {
              gracePeriodMinutes: 60
              status: 'Enabled'
            }
            virtualNetworkType: 'Managed'
          }
        ]
      }
      {
        name: 'test-project-another-resource-group'
        resourceGroupResourceId: '<resourceGroupResourceId>'
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'DevCenter Project Admin'
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
    tags: {
      costCenter: '1234'
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
      "value": "<name>"
    },
    // Non-required parameters
    "attachedNetworks": {
      "value": [
        {
          "name": "test-attached-network",
          "networkConnectionResourceId": "<networkConnectionResourceId>"
        }
      ]
    },
    "catalogs": {
      "value": [
        {
          "gitHub": {
            "branch": "main",
            "path": "Environment-Definitions",
            "uri": "https://github.com/microsoft/devcenter-catalog.git"
          },
          "name": "quickstart-catalog",
          "syncType": "Scheduled"
        },
        {
          "adoGit": {
            "branch": "main",
            "secretIdentifier": "<secretIdentifier>",
            "uri": "https://contoso@dev.azure.com/contoso/your-project/_git/your-repo"
          },
          "name": "testCatalogAzureDevOpsGit",
          "syncType": "Manual"
        }
      ]
    },
    "devboxDefinitions": {
      "value": [
        {
          "hibernateSupport": "Enabled",
          "imageResourceId": "<imageResourceId>",
          "name": "test-devbox-definition-builtin-gallery-image",
          "sku": {
            "capacity": 1,
            "family": "general_i",
            "name": "general_i_8c32gb512ssd_v2"
          },
          "tags": {
            "costCenter": "1234"
          }
        },
        {
          "imageResourceId": "<imageResourceId>",
          "name": "test-devbox-definition-custom-gallery-image",
          "sku": {
            "name": "general_i_8c32gb256ssd_v2"
          }
        }
      ]
    },
    "devBoxProvisioningSettings": {
      "value": {
        "installAzureMonitorAgentEnableStatus": "Enabled"
      }
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
    "displayName": {
      "value": "Dev Center Test"
    },
    "environmentTypes": {
      "value": [
        {
          "displayName": "Development Environment",
          "name": "dev",
          "tags": {
            "costCenter": "1234"
          }
        },
        {
          "displayName": "Testing Environment",
          "name": "test",
          "tags": {
            "costCenter": "5678"
          }
        },
        {
          "displayName": "Production Environment",
          "name": "prod",
          "tags": {
            "costCenter": "9012"
          }
        }
      ]
    },
    "galleries": {
      "value": [
        {
          "devCenterIdentityPrincipalId": "<devCenterIdentityPrincipalId>",
          "galleryResourceId": "<galleryResourceId>",
          "name": "computegallery"
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
    "networkSettings": {
      "value": {
        "microsoftHostedNetworkEnableStatus": "Disabled"
      }
    },
    "projectCatalogSettings": {
      "value": {
        "catalogItemSyncEnableStatus": "Enabled"
      }
    },
    "projectPolicies": {
      "value": [
        {
          "name": "Default",
          "resourcePolicies": [
            {
              "action": "Allow",
              "resourceType": "Images"
            },
            {
              "action": "Allow",
              "resourceType": "Skus"
            },
            {
              "action": "Allow",
              "resourceType": "AttachedNetworks"
            }
          ]
        },
        {
          "name": "DevProjectsPolicy",
          "projectsResourceIdOrName": [
            "<value>/providers/Microsoft.DevCenter/projects/test-project-another-resource-group",
            "test-project-same-resource-group"
          ],
          "resourcePolicies": [
            {
              "filter": "Name eq \"general_i_8c32gb512ssd_v2\"",
              "resources": "<resources>"
            },
            {
              "resources": "<resources>"
            },
            {
              "resources": "<resources>"
            },
            {
              "action": "Deny",
              "resourceType": "AttachedNetworks"
            }
          ]
        }
      ]
    },
    "projects": {
      "value": [
        {
          "catalogSettings": {
            "catalogItemSyncTypes": [
              "EnvironmentDefinition",
              "ImageDefinition"
            ]
          },
          "environmentTypes": [
            {
              "creatorRoleAssignmentRoles": [
                "acdd72a7-3385-48ef-bd42-f606fba81ae7"
              ],
              "deploymentTargetSubscriptionResourceId": "<deploymentTargetSubscriptionResourceId>",
              "displayName": "My Sandbox Environment Type",
              "managedIdentities": {
                "systemAssigned": false,
                "userAssignedResourceIds": [
                  "<managedIdentityResourceId>"
                ]
              },
              "name": "dep-et-dcdcmax",
              "status": "Enabled"
            }
          ],
          "managedIdentities": {
            "userAssignedResourceIds": [
              "<managedIdentityResourceId>"
            ]
          },
          "maxDevBoxesPerUser": 2,
          "name": "test-project-same-resource-group",
          "pools": [
            {
              "devBoxDefinitionName": "test-devbox-definition-builtin-gallery-image",
              "devBoxDefinitionType": "Reference",
              "displayName": "My Sandbox Pool - Managed Network",
              "localAdministrator": "Disabled",
              "managedVirtualNetworkRegion": "westeurope",
              "name": "sandbox-pool",
              "singleSignOnStatus": "Enabled",
              "stopOnDisconnect": {
                "gracePeriodMinutes": 60,
                "status": "Enabled"
              },
              "virtualNetworkType": "Managed"
            }
          ]
        },
        {
          "name": "test-project-another-resource-group",
          "resourceGroupResourceId": "<resourceGroupResourceId>"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "DevCenter Project Admin"
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
    "tags": {
      "value": {
        "costCenter": "1234"
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
using 'br/public:avm/res/dev-center/devcenter:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param attachedNetworks = [
  {
    name: 'test-attached-network'
    networkConnectionResourceId: '<networkConnectionResourceId>'
  }
]
param catalogs = [
  {
    gitHub: {
      branch: 'main'
      path: 'Environment-Definitions'
      uri: 'https://github.com/microsoft/devcenter-catalog.git'
    }
    name: 'quickstart-catalog'
    syncType: 'Scheduled'
  }
  {
    adoGit: {
      branch: 'main'
      secretIdentifier: '<secretIdentifier>'
      uri: 'https://contoso@dev.azure.com/contoso/your-project/_git/your-repo'
    }
    name: 'testCatalogAzureDevOpsGit'
    syncType: 'Manual'
  }
]
param devboxDefinitions = [
  {
    hibernateSupport: 'Enabled'
    imageResourceId: '<imageResourceId>'
    name: 'test-devbox-definition-builtin-gallery-image'
    sku: {
      capacity: 1
      family: 'general_i'
      name: 'general_i_8c32gb512ssd_v2'
    }
    tags: {
      costCenter: '1234'
    }
  }
  {
    imageResourceId: '<imageResourceId>'
    name: 'test-devbox-definition-custom-gallery-image'
    sku: {
      name: 'general_i_8c32gb256ssd_v2'
    }
  }
]
param devBoxProvisioningSettings = {
  installAzureMonitorAgentEnableStatus: 'Enabled'
}
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
param displayName = 'Dev Center Test'
param environmentTypes = [
  {
    displayName: 'Development Environment'
    name: 'dev'
    tags: {
      costCenter: '1234'
    }
  }
  {
    displayName: 'Testing Environment'
    name: 'test'
    tags: {
      costCenter: '5678'
    }
  }
  {
    displayName: 'Production Environment'
    name: 'prod'
    tags: {
      costCenter: '9012'
    }
  }
]
param galleries = [
  {
    devCenterIdentityPrincipalId: '<devCenterIdentityPrincipalId>'
    galleryResourceId: '<galleryResourceId>'
    name: 'computegallery'
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
param networkSettings = {
  microsoftHostedNetworkEnableStatus: 'Disabled'
}
param projectCatalogSettings = {
  catalogItemSyncEnableStatus: 'Enabled'
}
param projectPolicies = [
  {
    name: 'Default'
    resourcePolicies: [
      {
        action: 'Allow'
        resourceType: 'Images'
      }
      {
        action: 'Allow'
        resourceType: 'Skus'
      }
      {
        action: 'Allow'
        resourceType: 'AttachedNetworks'
      }
    ]
  }
  {
    name: 'DevProjectsPolicy'
    projectsResourceIdOrName: [
      '<value>/providers/Microsoft.DevCenter/projects/test-project-another-resource-group'
      'test-project-same-resource-group'
    ]
    resourcePolicies: [
      {
        filter: 'Name eq \'general_i_8c32gb512ssd_v2\''
        resources: '<resources>'
      }
      {
        resources: '<resources>'
      }
      {
        resources: '<resources>'
      }
      {
        action: 'Deny'
        resourceType: 'AttachedNetworks'
      }
    ]
  }
]
param projects = [
  {
    catalogSettings: {
      catalogItemSyncTypes: [
        'EnvironmentDefinition'
        'ImageDefinition'
      ]
    }
    environmentTypes: [
      {
        creatorRoleAssignmentRoles: [
          'acdd72a7-3385-48ef-bd42-f606fba81ae7'
        ]
        deploymentTargetSubscriptionResourceId: '<deploymentTargetSubscriptionResourceId>'
        displayName: 'My Sandbox Environment Type'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentityResourceId>'
          ]
        }
        name: 'dep-et-dcdcmax'
        status: 'Enabled'
      }
    ]
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    maxDevBoxesPerUser: 2
    name: 'test-project-same-resource-group'
    pools: [
      {
        devBoxDefinitionName: 'test-devbox-definition-builtin-gallery-image'
        devBoxDefinitionType: 'Reference'
        displayName: 'My Sandbox Pool - Managed Network'
        localAdministrator: 'Disabled'
        managedVirtualNetworkRegion: 'westeurope'
        name: 'sandbox-pool'
        singleSignOnStatus: 'Enabled'
        stopOnDisconnect: {
          gracePeriodMinutes: 60
          status: 'Enabled'
        }
        virtualNetworkType: 'Managed'
      }
    ]
  }
  {
    name: 'test-project-another-resource-group'
    resourceGroupResourceId: '<resourceGroupResourceId>'
  }
]
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'DevCenter Project Admin'
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
param tags = {
  costCenter: '1234'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module devcenter 'br/public:avm/res/dev-center/devcenter:<version>' = {
  name: 'devcenterDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    attachedNetworks: [
      {
        name: 'test-attached-network'
        networkConnectionResourceId: '<networkConnectionResourceId>'
      }
    ]
    catalogs: [
      {
        gitHub: {
          branch: 'main'
          path: 'Environment-Definitions'
          uri: 'https://github.com/microsoft/devcenter-catalog.git'
        }
        name: 'quickstart-catalog'
        syncType: 'Scheduled'
      }
    ]
    devboxDefinitions: [
      {
        hibernateSupport: 'Enabled'
        imageResourceId: '<imageResourceId>'
        name: 'test-devbox-definition-builtin-gallery-image'
        sku: {
          name: 'general_i_8c32gb512ssd_v2'
        }
      }
    ]
    devBoxProvisioningSettings: {
      installAzureMonitorAgentEnableStatus: 'Enabled'
    }
    location: '<location>'
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    networkSettings: {
      microsoftHostedNetworkEnableStatus: 'Disabled'
    }
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: 'Enabled'
    }
    projectPolicies: [
      {
        name: 'Default'
        resourcePolicies: [
          {
            action: 'Allow'
            resourceType: 'Images'
          }
          {
            action: 'Allow'
            resourceType: 'Skus'
          }
          {
            action: 'Allow'
            resourceType: 'AttachedNetworks'
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
      "value": "<name>"
    },
    // Non-required parameters
    "attachedNetworks": {
      "value": [
        {
          "name": "test-attached-network",
          "networkConnectionResourceId": "<networkConnectionResourceId>"
        }
      ]
    },
    "catalogs": {
      "value": [
        {
          "gitHub": {
            "branch": "main",
            "path": "Environment-Definitions",
            "uri": "https://github.com/microsoft/devcenter-catalog.git"
          },
          "name": "quickstart-catalog",
          "syncType": "Scheduled"
        }
      ]
    },
    "devboxDefinitions": {
      "value": [
        {
          "hibernateSupport": "Enabled",
          "imageResourceId": "<imageResourceId>",
          "name": "test-devbox-definition-builtin-gallery-image",
          "sku": {
            "name": "general_i_8c32gb512ssd_v2"
          }
        }
      ]
    },
    "devBoxProvisioningSettings": {
      "value": {
        "installAzureMonitorAgentEnableStatus": "Enabled"
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "networkSettings": {
      "value": {
        "microsoftHostedNetworkEnableStatus": "Disabled"
      }
    },
    "projectCatalogSettings": {
      "value": {
        "catalogItemSyncEnableStatus": "Enabled"
      }
    },
    "projectPolicies": {
      "value": [
        {
          "name": "Default",
          "resourcePolicies": [
            {
              "action": "Allow",
              "resourceType": "Images"
            },
            {
              "action": "Allow",
              "resourceType": "Skus"
            },
            {
              "action": "Allow",
              "resourceType": "AttachedNetworks"
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
using 'br/public:avm/res/dev-center/devcenter:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param attachedNetworks = [
  {
    name: 'test-attached-network'
    networkConnectionResourceId: '<networkConnectionResourceId>'
  }
]
param catalogs = [
  {
    gitHub: {
      branch: 'main'
      path: 'Environment-Definitions'
      uri: 'https://github.com/microsoft/devcenter-catalog.git'
    }
    name: 'quickstart-catalog'
    syncType: 'Scheduled'
  }
]
param devboxDefinitions = [
  {
    hibernateSupport: 'Enabled'
    imageResourceId: '<imageResourceId>'
    name: 'test-devbox-definition-builtin-gallery-image'
    sku: {
      name: 'general_i_8c32gb512ssd_v2'
    }
  }
]
param devBoxProvisioningSettings = {
  installAzureMonitorAgentEnableStatus: 'Enabled'
}
param location = '<location>'
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param networkSettings = {
  microsoftHostedNetworkEnableStatus: 'Disabled'
}
param projectCatalogSettings = {
  catalogItemSyncEnableStatus: 'Enabled'
}
param projectPolicies = [
  {
    name: 'Default'
    resourcePolicies: [
      {
        action: 'Allow'
        resourceType: 'Images'
      }
      {
        action: 'Allow'
        resourceType: 'Skus'
      }
      {
        action: 'Allow'
        resourceType: 'AttachedNetworks'
      }
    ]
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Dev Center. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attachedNetworks`](#parameter-attachednetworks) | array | The attached networks to associate with the Dev Center. You can attach existing network connections to a dev center. You must attach a network connection to a dev center before you can use it in projects to create dev box pools. Network connections enable dev boxes to connect to existing virtual networks. The location, or Azure region, of the network connection determines where associated dev boxes are hosted. |
| [`catalogs`](#parameter-catalogs) | array | The catalogs to create in the dev center. Catalogs help you provide a set of curated infrastructure-as-code(IaC) templates, known as environment definitions for your development teams to create environments. You can attach your own source control repository from GitHub or Azure Repos as a catalog and specify the folder with your environment definitions. Deployment Environments scans the folder for environment definitions and makes them available for dev teams to create environments. |
| [`devboxDefinitions`](#parameter-devboxdefinitions) | array | The DevBox definitions to create in the Dev Center. A DevBox definition specifies the source operating system image and compute size, including CPU, memory, and storage. Dev Box definitions are used to create DevBox pools. |
| [`devBoxProvisioningSettings`](#parameter-devboxprovisioningsettings) | object | Settings to be used in the provisioning of all Dev Boxes that belong to this dev center. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`displayName`](#parameter-displayname) | string | The display name of the Dev Center. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentTypes`](#parameter-environmenttypes) | array | Define the environment types that development teams can deploy. For example, sandbox, dev, test, and production. A dev center environment type is available to a specific project only after you add an associated project environment type. You can't delete a dev center environment type if any existing project environment types or deployed environments reference it. |
| [`galleries`](#parameter-galleries) | array | The compute galleries to associate with the Dev Center. The Dev Center identity (system or user) must have "Contributor" access to the gallery. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`networkSettings`](#parameter-networksettings) | object | Network settings that will be enforced on network resources associated with the Dev Center. |
| [`projectCatalogSettings`](#parameter-projectcatalogsettings) | object | Dev Center settings to be used when associating a project with a catalog. |
| [`projectPolicies`](#parameter-projectpolicies) | array | Project policies provide a mechanism to restrict access to certain resources—specifically, SKUs, Images, and Network Connections—to designated projects. Creating a policy does not mean it has automatically been enforced on the selected projects. It must be explicitly assigned to a project as part of the scope property. You must first create the "Default" project policy before you can create any other project policies. The "Default" project policy is automatically assigned to all projects in the Dev Center. |
| [`projects`](#parameter-projects) | array | The projects to create in the Dev Center. A project is the point of access to Microsoft Dev Box for the development team members. A project contains dev box pools, which specify the dev box definitions and network connections used when dev boxes are created. Each project is associated with a single dev center. When you associate a project with a dev center, all the settings at the dev center level are applied to the project automatically. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Dev Center.

- Required: Yes
- Type: string

### Parameter: `attachedNetworks`

The attached networks to associate with the Dev Center. You can attach existing network connections to a dev center. You must attach a network connection to a dev center before you can use it in projects to create dev box pools. Network connections enable dev boxes to connect to existing virtual networks. The location, or Azure region, of the network connection determines where associated dev boxes are hosted.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-attachednetworksname) | string | The name of the attached network. |
| [`networkConnectionResourceId`](#parameter-attachednetworksnetworkconnectionresourceid) | string | The resource ID of the Network Connection you want to attach to the Dev Center. |

### Parameter: `attachedNetworks.name`

The name of the attached network.

- Required: Yes
- Type: string

### Parameter: `attachedNetworks.networkConnectionResourceId`

The resource ID of the Network Connection you want to attach to the Dev Center.

- Required: Yes
- Type: string

### Parameter: `catalogs`

The catalogs to create in the dev center. Catalogs help you provide a set of curated infrastructure-as-code(IaC) templates, known as environment definitions for your development teams to create environments. You can attach your own source control repository from GitHub or Azure Repos as a catalog and specify the folder with your environment definitions. Deployment Environments scans the folder for environment definitions and makes them available for dev teams to create environments.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-catalogsname) | string | The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adoGit`](#parameter-catalogsadogit) | object | Azure DevOps Git repository configuration for the catalog. |
| [`gitHub`](#parameter-catalogsgithub) | object | GitHub repository configuration for the catalog. |
| [`syncType`](#parameter-catalogssynctype) | string | Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled". |
| [`tags`](#parameter-catalogstags) | object | Resource tags to apply to the catalog. |

### Parameter: `catalogs.name`

The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods.

- Required: Yes
- Type: string

### Parameter: `catalogs.adoGit`

Azure DevOps Git repository configuration for the catalog.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-catalogsadogituri) | string | The Git repository URI. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-catalogsadogitbranch) | string | The Git branch to use. Defaults to "main". |
| [`path`](#parameter-catalogsadogitpath) | string | The folder path within the repository. Defaults to "/". |
| [`secretIdentifier`](#parameter-catalogsadogitsecretidentifier) | string | A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center. |

### Parameter: `catalogs.adoGit.uri`

The Git repository URI.

- Required: Yes
- Type: string

### Parameter: `catalogs.adoGit.branch`

The Git branch to use. Defaults to "main".

- Required: No
- Type: string

### Parameter: `catalogs.adoGit.path`

The folder path within the repository. Defaults to "/".

- Required: No
- Type: string

### Parameter: `catalogs.adoGit.secretIdentifier`

A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.

- Required: No
- Type: string

### Parameter: `catalogs.gitHub`

GitHub repository configuration for the catalog.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-catalogsgithuburi) | string | The Git repository URI. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-catalogsgithubbranch) | string | The Git branch to use. Defaults to "main". |
| [`path`](#parameter-catalogsgithubpath) | string | The folder path within the repository. Defaults to "/". |
| [`secretIdentifier`](#parameter-catalogsgithubsecretidentifier) | string | A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center. |

### Parameter: `catalogs.gitHub.uri`

The Git repository URI.

- Required: Yes
- Type: string

### Parameter: `catalogs.gitHub.branch`

The Git branch to use. Defaults to "main".

- Required: No
- Type: string

### Parameter: `catalogs.gitHub.path`

The folder path within the repository. Defaults to "/".

- Required: No
- Type: string

### Parameter: `catalogs.gitHub.secretIdentifier`

A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.

- Required: No
- Type: string

### Parameter: `catalogs.syncType`

Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Manual'
    'Scheduled'
  ]
  ```

### Parameter: `catalogs.tags`

Resource tags to apply to the catalog.

- Required: No
- Type: object

### Parameter: `devboxDefinitions`

The DevBox definitions to create in the Dev Center. A DevBox definition specifies the source operating system image and compute size, including CPU, memory, and storage. Dev Box definitions are used to create DevBox pools.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageResourceId`](#parameter-devboxdefinitionsimageresourceid) | string | The Image ID, or Image version ID. When Image ID is provided, its latest version will be used. When using custom images from a compute gallery, Microsoft Dev Box supports only images that are compatible with Dev Box and use the security type Trusted Launch enabled. See "https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements" for more information about image requirements. |
| [`name`](#parameter-devboxdefinitionsname) | string | The name of the DevBox definition. |
| [`sku`](#parameter-devboxdefinitionssku) | object | The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hibernateSupport`](#parameter-devboxdefinitionshibernatesupport) | string | Settings for hibernation support. |
| [`location`](#parameter-devboxdefinitionslocation) | string | Location for the DevBox definition. |
| [`tags`](#parameter-devboxdefinitionstags) | object | Tags of the resource. |

### Parameter: `devboxDefinitions.imageResourceId`

The Image ID, or Image version ID. When Image ID is provided, its latest version will be used. When using custom images from a compute gallery, Microsoft Dev Box supports only images that are compatible with Dev Box and use the security type Trusted Launch enabled. See "https://learn.microsoft.com/en-us/azure/dev-box/how-to-configure-azure-compute-gallery#compute-gallery-image-requirements" for more information about image requirements.

- Required: Yes
- Type: string

### Parameter: `devboxDefinitions.name`

The name of the DevBox definition.

- Required: Yes
- Type: string

### Parameter: `devboxDefinitions.sku`

The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-devboxdefinitionsskuname) | string | The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-devboxdefinitionsskucapacity) | int | If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. |
| [`family`](#parameter-devboxdefinitionsskufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2". |
| [`size`](#parameter-devboxdefinitionsskusize) | string | The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. |

### Parameter: `devboxDefinitions.sku.name`

The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names.

- Required: Yes
- Type: string

### Parameter: `devboxDefinitions.sku.capacity`

If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.

- Required: No
- Type: int

### Parameter: `devboxDefinitions.sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2".

- Required: No
- Type: string

### Parameter: `devboxDefinitions.sku.size`

The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.

- Required: No
- Type: string

### Parameter: `devboxDefinitions.hibernateSupport`

Settings for hibernation support.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `devboxDefinitions.location`

Location for the DevBox definition.

- Required: No
- Type: string

### Parameter: `devboxDefinitions.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `devBoxProvisioningSettings`

Settings to be used in the provisioning of all Dev Boxes that belong to this dev center.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`installAzureMonitorAgentEnableStatus`](#parameter-devboxprovisioningsettingsinstallazuremonitoragentenablestatus) | string | Whether project catalogs associated with projects in this dev center can be configured to sync catalog items. |

### Parameter: `devBoxProvisioningSettings.installAzureMonitorAgentEnableStatus`

Whether project catalogs associated with projects in this dev center can be configured to sync catalog items.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
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

### Parameter: `displayName`

The display name of the Dev Center.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentTypes`

Define the environment types that development teams can deploy. For example, sandbox, dev, test, and production. A dev center environment type is available to a specific project only after you add an associated project environment type. You can't delete a dev center environment type if any existing project environment types or deployed environments reference it.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-environmenttypesname) | string | The name of the environment type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-environmenttypesdisplayname) | string | The display name of the environment type. |
| [`tags`](#parameter-environmenttypestags) | object | Tags of the resource. |

### Parameter: `environmentTypes.name`

The name of the environment type.

- Required: Yes
- Type: string

### Parameter: `environmentTypes.displayName`

The display name of the environment type.

- Required: No
- Type: string

### Parameter: `environmentTypes.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `galleries`

The compute galleries to associate with the Dev Center. The Dev Center identity (system or user) must have "Contributor" access to the gallery.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`galleryResourceId`](#parameter-galleriesgalleryresourceid) | string | The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery. |
| [`name`](#parameter-galleriesname) | string | It must be between 3 and 63 characters, can only include alphanumeric characters, underscores and periods, and can not start or end with "." or "_". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devCenterIdentityPrincipalId`](#parameter-galleriesdevcenteridentityprincipalid) | string | The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically. |

### Parameter: `galleries.galleryResourceId`

The resource ID of the backing Azure Compute Gallery. The devcenter identity (system or user) must have "Contributor" access to the gallery.

- Required: Yes
- Type: string

### Parameter: `galleries.name`

It must be between 3 and 63 characters, can only include alphanumeric characters, underscores and periods, and can not start or end with "." or "_".

- Required: Yes
- Type: string

### Parameter: `galleries.devCenterIdentityPrincipalId`

The principal ID of the Dev Center identity (system or user) that will be assigned the "Contributor" role on the backing Azure Compute Gallery. This is only required if the Dev Center identity has not been granted the right permissions on the gallery. The portal experience handles this automatically.

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
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `networkSettings`

Network settings that will be enforced on network resources associated with the Dev Center.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`microsoftHostedNetworkEnableStatus`](#parameter-networksettingsmicrosofthostednetworkenablestatus) | string | Indicates whether pools in this Dev Center can use Microsoft Hosted Networks. Defaults to Enabled if not set. |

### Parameter: `networkSettings.microsoftHostedNetworkEnableStatus`

Indicates whether pools in this Dev Center can use Microsoft Hosted Networks. Defaults to Enabled if not set.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projectCatalogSettings`

Dev Center settings to be used when associating a project with a catalog.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogItemSyncEnableStatus`](#parameter-projectcatalogsettingscatalogitemsyncenablestatus) | string | Whether project catalogs associated with projects in this dev center can be configured to sync catalog items. |

### Parameter: `projectCatalogSettings.catalogItemSyncEnableStatus`

Whether project catalogs associated with projects in this dev center can be configured to sync catalog items.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projectPolicies`

Project policies provide a mechanism to restrict access to certain resources—specifically, SKUs, Images, and Network Connections—to designated projects. Creating a policy does not mean it has automatically been enforced on the selected projects. It must be explicitly assigned to a project as part of the scope property. You must first create the "Default" project policy before you can create any other project policies. The "Default" project policy is automatically assigned to all projects in the Dev Center.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-projectpoliciesname) | string | The name of the project policy. |
| [`resourcePolicies`](#parameter-projectpoliciesresourcepolicies) | array | Resource policies that are a part of this project policy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectsResourceIdOrName`](#parameter-projectpoliciesprojectsresourceidorname) | array | Project names or resource IDs that will be in scope of this project policy. Project names can be used if the project is in the same resource group as the Dev Center. If the project is in a different resource group or subscription, the full resource ID must be provided. If not provided, the policy status will be set to "Unassigned". |

### Parameter: `projectPolicies.name`

The name of the project policy.

- Required: Yes
- Type: string

### Parameter: `projectPolicies.resourcePolicies`

Resource policies that are a part of this project policy.

- Required: Yes
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-projectpoliciesresourcepoliciesaction) | string | Policy action to be taken on the resources. Defaults to "Allow" if not specified. Cannot be used when the "resources" property is provided. |
| [`filter`](#parameter-projectpoliciesresourcepoliciesfilter) | string | When specified, this expression is used to filter the resources. |
| [`resources`](#parameter-projectpoliciesresourcepoliciesresources) | string | Explicit resources that are "allowed" as part of a project policy. Must be in the format of a resource ID. Cannot be used when the "resourceType" property is provided. |
| [`resourceType`](#parameter-projectpoliciesresourcepoliciesresourcetype) | string | The resource type being restricted or allowed by a project policy. Used with a given "action" to restrict or allow access to a resource type. If not specified for a given policy, the action will be set to "Allow" for the unspecified resource types. For example, if the action is "Deny" for "Images" and "Skus", the project policy will deny access to images and skus, but allow access for remaining resource types like "AttachedNetworks". |

### Parameter: `projectPolicies.resourcePolicies.action`

Policy action to be taken on the resources. Defaults to "Allow" if not specified. Cannot be used when the "resources" property is provided.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `projectPolicies.resourcePolicies.filter`

When specified, this expression is used to filter the resources.

- Required: No
- Type: string

### Parameter: `projectPolicies.resourcePolicies.resources`

Explicit resources that are "allowed" as part of a project policy. Must be in the format of a resource ID. Cannot be used when the "resourceType" property is provided.

- Required: No
- Type: string

### Parameter: `projectPolicies.resourcePolicies.resourceType`

The resource type being restricted or allowed by a project policy. Used with a given "action" to restrict or allow access to a resource type. If not specified for a given policy, the action will be set to "Allow" for the unspecified resource types. For example, if the action is "Deny" for "Images" and "Skus", the project policy will deny access to images and skus, but allow access for remaining resource types like "AttachedNetworks".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AttachedNetworks'
    'Images'
    'Skus'
  ]
  ```

### Parameter: `projectPolicies.projectsResourceIdOrName`

Project names or resource IDs that will be in scope of this project policy. Project names can be used if the project is in the same resource group as the Dev Center. If the project is in a different resource group or subscription, the full resource ID must be provided. If not provided, the policy status will be set to "Unassigned".

- Required: No
- Type: array

### Parameter: `projects`

The projects to create in the Dev Center. A project is the point of access to Microsoft Dev Box for the development team members. A project contains dev box pools, which specify the dev box definitions and network connections used when dev boxes are created. Each project is associated with a single dev center. When you associate a project with a dev center, all the settings at the dev center level are applied to the project automatically.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-projectsname) | string | The name of the project. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogs`](#parameter-projectscatalogs) | array | The catalogs to create in the project. Catalogs are templates from a git repository that can be used to create environments. |
| [`catalogSettings`](#parameter-projectscatalogsettings) | object | Settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings. |
| [`description`](#parameter-projectsdescription) | string | The description of the project. |
| [`displayName`](#parameter-projectsdisplayname) | string | The display name of project. |
| [`environmentTypes`](#parameter-projectsenvironmenttypes) | array | The environment types to create. Environment types must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center. |
| [`location`](#parameter-projectslocation) | string | Location for the project. |
| [`lock`](#parameter-projectslock) | object | The lock settings of the project. |
| [`managedIdentities`](#parameter-projectsmanagedidentities) | object | The managed identity definition for the project resource. Only one user assigned identity can be used per project. |
| [`maxDevBoxesPerUser`](#parameter-projectsmaxdevboxesperuser) | int | When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced. |
| [`pools`](#parameter-projectspools) | array | The type of pool to create in the project. A project pool is a container for dev boxes that share the same configuration, like a dev box definition and a network connection. Essentially, a project pool defines the specifications for the dev boxes that developers can create from a specific project in the Dev Box service. |
| [`resourceGroupResourceId`](#parameter-projectsresourcegroupresourceid) | string | The resource group resource ID where the project will be deployed. If not provided, the project will be deployed to the same resource group as the Dev Center. |
| [`roleAssignments`](#parameter-projectsroleassignments) | array | Array of role assignments to create for the project. |
| [`tags`](#parameter-projectstags) | object | Resource tags to apply to the project. |

### Parameter: `projects.name`

The name of the project.

- Required: Yes
- Type: string

### Parameter: `projects.catalogs`

The catalogs to create in the project. Catalogs are templates from a git repository that can be used to create environments.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-projectscatalogsname) | string | The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adoGit`](#parameter-projectscatalogsadogit) | object | Azure DevOps Git repository configuration for the catalog. |
| [`gitHub`](#parameter-projectscatalogsgithub) | object | GitHub repository configuration for the catalog. |
| [`syncType`](#parameter-projectscatalogssynctype) | string | Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled". |
| [`tags`](#parameter-projectscatalogstags) | object | Resource tags to apply to the catalog. |

### Parameter: `projects.catalogs.name`

The name of the catalog. Must be between 3 and 63 characters and can contain alphanumeric characters, hyphens, underscores, and periods.

- Required: Yes
- Type: string

### Parameter: `projects.catalogs.adoGit`

Azure DevOps Git repository configuration for the catalog.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-projectscatalogsadogituri) | string | The Git repository URI. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-projectscatalogsadogitbranch) | string | The Git branch to use. Defaults to "main". |
| [`path`](#parameter-projectscatalogsadogitpath) | string | The folder path within the repository. Defaults to "/". |
| [`secretIdentifier`](#parameter-projectscatalogsadogitsecretidentifier) | string | A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center. |

### Parameter: `projects.catalogs.adoGit.uri`

The Git repository URI.

- Required: Yes
- Type: string

### Parameter: `projects.catalogs.adoGit.branch`

The Git branch to use. Defaults to "main".

- Required: No
- Type: string

### Parameter: `projects.catalogs.adoGit.path`

The folder path within the repository. Defaults to "/".

- Required: No
- Type: string

### Parameter: `projects.catalogs.adoGit.secretIdentifier`

A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.

- Required: No
- Type: string

### Parameter: `projects.catalogs.gitHub`

GitHub repository configuration for the catalog.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`uri`](#parameter-projectscatalogsgithuburi) | string | The Git repository URI. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-projectscatalogsgithubbranch) | string | The Git branch to use. Defaults to "main". |
| [`path`](#parameter-projectscatalogsgithubpath) | string | The folder path within the repository. Defaults to "/". |
| [`secretIdentifier`](#parameter-projectscatalogsgithubsecretidentifier) | string | A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center. |

### Parameter: `projects.catalogs.gitHub.uri`

The Git repository URI.

- Required: Yes
- Type: string

### Parameter: `projects.catalogs.gitHub.branch`

The Git branch to use. Defaults to "main".

- Required: No
- Type: string

### Parameter: `projects.catalogs.gitHub.path`

The folder path within the repository. Defaults to "/".

- Required: No
- Type: string

### Parameter: `projects.catalogs.gitHub.secretIdentifier`

A reference to the Key Vault secret containing a Personal Access Token (PAT) to authenticate to a Git repository. Not required for Azure DevOps with Managed Identity authentication or GitHub with App Center.

- Required: No
- Type: string

### Parameter: `projects.catalogs.syncType`

Indicates the type of sync that is configured for the catalog. Defaults to "Scheduled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Manual'
    'Scheduled'
  ]
  ```

### Parameter: `projects.catalogs.tags`

Resource tags to apply to the catalog.

- Required: No
- Type: object

### Parameter: `projects.catalogSettings`

Settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogItemSyncTypes`](#parameter-projectscatalogsettingscatalogitemsynctypes) | array | Indicates catalog item types that can be synced. |

### Parameter: `projects.catalogSettings.catalogItemSyncTypes`

Indicates catalog item types that can be synced.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'EnvironmentDefinition'
    'ImageDefinition'
  ]
  ```

### Parameter: `projects.description`

The description of the project.

- Required: No
- Type: string

### Parameter: `projects.displayName`

The display name of project.

- Required: No
- Type: string

### Parameter: `projects.environmentTypes`

The environment types to create. Environment types must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`creatorRoleAssignmentRoles`](#parameter-projectsenvironmenttypescreatorroleassignmentroles) | array | An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified. |
| [`deploymentTargetSubscriptionResourceId`](#parameter-projectsenvironmenttypesdeploymenttargetsubscriptionresourceid) | string | The subscription Resource ID where the environment type will be mapped to. The environment's resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}". |
| [`name`](#parameter-projectsenvironmenttypesname) | string | The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-projectsenvironmenttypesdisplayname) | string | The display name of the environment type. |
| [`managedIdentities`](#parameter-projectsenvironmenttypesmanagedidentities) | object | The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity. |
| [`roleAssignments`](#parameter-projectsenvironmenttypesroleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-projectsenvironmenttypesstatus) | string | Defines whether this Environment Type can be used in this Project. The default is "Enabled". |
| [`tags`](#parameter-projectsenvironmenttypestags) | object | Resource tags to apply to the environment type. |
| [`userRoleAssignmentsRoles`](#parameter-projectsenvironmenttypesuserroleassignmentsroles) | array | A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions. |

### Parameter: `projects.environmentTypes.creatorRoleAssignmentRoles`

An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified.

- Required: Yes
- Type: array

### Parameter: `projects.environmentTypes.deploymentTargetSubscriptionResourceId`

The subscription Resource ID where the environment type will be mapped to. The environment's resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}".

- Required: Yes
- Type: string

### Parameter: `projects.environmentTypes.name`

The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.

- Required: Yes
- Type: string

### Parameter: `projects.environmentTypes.displayName`

The display name of the environment type.

- Required: No
- Type: string

### Parameter: `projects.environmentTypes.managedIdentities`

The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-projectsenvironmenttypesmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-projectsenvironmenttypesmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `projects.environmentTypes.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `projects.environmentTypes.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `projects.environmentTypes.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-projectsenvironmenttypesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-projectsenvironmenttypesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-projectsenvironmenttypesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-projectsenvironmenttypesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-projectsenvironmenttypesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-projectsenvironmenttypesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-projectsenvironmenttypesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-projectsenvironmenttypesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `projects.environmentTypes.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `projects.environmentTypes.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `projects.environmentTypes.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `projects.environmentTypes.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `projects.environmentTypes.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `projects.environmentTypes.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `projects.environmentTypes.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `projects.environmentTypes.roleAssignments.principalType`

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

### Parameter: `projects.environmentTypes.status`

Defines whether this Environment Type can be used in this Project. The default is "Enabled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projects.environmentTypes.tags`

Resource tags to apply to the environment type.

- Required: No
- Type: object

### Parameter: `projects.environmentTypes.userRoleAssignmentsRoles`

A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-projectsenvironmenttypesuserroleassignmentsrolesobjectid) | string | The object ID of the user, group, service principal, or managed identity. |
| [`roleDefinitions`](#parameter-projectsenvironmenttypesuserroleassignmentsrolesroledefinitions) | array | An array of role definition GUIDs to assign to the object. |

### Parameter: `projects.environmentTypes.userRoleAssignmentsRoles.objectId`

The object ID of the user, group, service principal, or managed identity.

- Required: Yes
- Type: string

### Parameter: `projects.environmentTypes.userRoleAssignmentsRoles.roleDefinitions`

An array of role definition GUIDs to assign to the object.

- Required: Yes
- Type: array

### Parameter: `projects.location`

Location for the project.

- Required: No
- Type: string

### Parameter: `projects.lock`

The lock settings of the project.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-projectslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-projectslockname) | string | Specify the name of lock. |

### Parameter: `projects.lock.kind`

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

### Parameter: `projects.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `projects.managedIdentities`

The managed identity definition for the project resource. Only one user assigned identity can be used per project.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-projectsmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-projectsmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `projects.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `projects.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `projects.maxDevBoxesPerUser`

When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `projects.pools`

The type of pool to create in the project. A project pool is a container for dev boxes that share the same configuration, like a dev box definition and a network connection. Essentially, a project pool defines the specifications for the dev boxes that developers can create from a specific project in the Dev Box service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinitionName`](#parameter-projectspoolsdevboxdefinitionname) | string | Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\~Catalog\~{catalogName}\~{imagedefinition YAML name}" (e.g. "\~Catalog\~eshopRepo\~frontend-dev"). |
| [`localAdministrator`](#parameter-projectspoolslocaladministrator) | string | Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box. |
| [`name`](#parameter-projectspoolsname) | string | The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes. |
| [`virtualNetworkType`](#parameter-projectspoolsvirtualnetworktype) | string | Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinition`](#parameter-projectspoolsdevboxdefinition) | object | A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value". |
| [`managedVirtualNetworkRegion`](#parameter-projectspoolsmanagedvirtualnetworkregion) | string | The region of the managed virtual network. Required if virtualNetworkType is "Managed". |
| [`networkConnectionName`](#parameter-projectspoolsnetworkconnectionname) | string | Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinitionType`](#parameter-projectspoolsdevboxdefinitiontype) | string | Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly. Defaults to "Reference". |
| [`displayName`](#parameter-projectspoolsdisplayname) | string | The display name of the pool. |
| [`location`](#parameter-projectspoolslocation) | string | Location for the pool. |
| [`schedule`](#parameter-projectspoolsschedule) | object | The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration. |
| [`singleSignOnStatus`](#parameter-projectspoolssinglesignonstatus) | string | Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes. |
| [`stopOnDisconnect`](#parameter-projectspoolsstopondisconnect) | object | Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects. |
| [`stopOnNoConnect`](#parameter-projectspoolsstoponnoconnect) | object | Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects. |
| [`tags`](#parameter-projectspoolstags) | object | Resource tags to apply to the pool. |

### Parameter: `projects.pools.devBoxDefinitionName`

Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\~Catalog\~{catalogName}\~{imagedefinition YAML name}" (e.g. "\~Catalog\~eshopRepo\~frontend-dev").

- Required: Yes
- Type: string

### Parameter: `projects.pools.localAdministrator`

Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projects.pools.name`

The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes.

- Required: Yes
- Type: string

### Parameter: `projects.pools.virtualNetworkType`

Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Managed'
    'Unmanaged'
  ]
  ```

### Parameter: `projects.pools.devBoxDefinition`

A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value".

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageReferenceResourceId`](#parameter-projectspoolsdevboxdefinitionimagereferenceresourceid) | string | The resource ID of the image reference for the dev box definition. This would be the resource ID of the project image where the image has the same name as the dev box definition name. If the dev box definition is created from a catalog, then this would be the resource ID of the image in the project that was created from the catalog. The format is "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevCenter/projects/{projectName}/images/~Catalog~{catalogName}~{imagedefinition YAML name}". |
| [`sku`](#parameter-projectspoolsdevboxdefinitionsku) | object | The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs. |

### Parameter: `projects.pools.devBoxDefinition.imageReferenceResourceId`

The resource ID of the image reference for the dev box definition. This would be the resource ID of the project image where the image has the same name as the dev box definition name. If the dev box definition is created from a catalog, then this would be the resource ID of the image in the project that was created from the catalog. The format is "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevCenter/projects/{projectName}/images/~Catalog~{catalogName}~{imagedefinition YAML name}".

- Required: Yes
- Type: string

### Parameter: `projects.pools.devBoxDefinition.sku`

The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-projectspoolsdevboxdefinitionskuname) | string | The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-projectspoolsdevboxdefinitionskucapacity) | int | If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. |
| [`family`](#parameter-projectspoolsdevboxdefinitionskufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2". |
| [`size`](#parameter-projectspoolsdevboxdefinitionskusize) | string | The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. |

### Parameter: `projects.pools.devBoxDefinition.sku.name`

The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names.

- Required: Yes
- Type: string

### Parameter: `projects.pools.devBoxDefinition.sku.capacity`

If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.

- Required: No
- Type: int

### Parameter: `projects.pools.devBoxDefinition.sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2".

- Required: No
- Type: string

### Parameter: `projects.pools.devBoxDefinition.sku.size`

The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.

- Required: No
- Type: string

### Parameter: `projects.pools.managedVirtualNetworkRegion`

The region of the managed virtual network. Required if virtualNetworkType is "Managed".

- Required: No
- Type: string

### Parameter: `projects.pools.networkConnectionName`

Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed".

- Required: No
- Type: string

### Parameter: `projects.pools.devBoxDefinitionType`

Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly. Defaults to "Reference".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Reference'
    'Value'
  ]
  ```

### Parameter: `projects.pools.displayName`

The display name of the pool.

- Required: No
- Type: string

### Parameter: `projects.pools.location`

Location for the pool.

- Required: No
- Type: string

### Parameter: `projects.pools.schedule`

The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-projectspoolsschedulestate) | string | Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled. |
| [`time`](#parameter-projectspoolsscheduletime) | string | The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM. |
| [`timeZone`](#parameter-projectspoolsscheduletimezone) | string | The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central". |

### Parameter: `projects.pools.schedule.state`

Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projects.pools.schedule.time`

The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM.

- Required: Yes
- Type: string

### Parameter: `projects.pools.schedule.timeZone`

The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central".

- Required: Yes
- Type: string

### Parameter: `projects.pools.singleSignOnStatus`

Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projects.pools.stopOnDisconnect`

Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gracePeriodMinutes`](#parameter-projectspoolsstopondisconnectgraceperiodminutes) | int | The specified time in minutes to wait before stopping a Dev Box once disconnect is detected. |
| [`status`](#parameter-projectspoolsstopondisconnectstatus) | string | Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled. |

### Parameter: `projects.pools.stopOnDisconnect.gracePeriodMinutes`

The specified time in minutes to wait before stopping a Dev Box once disconnect is detected.

- Required: Yes
- Type: int

### Parameter: `projects.pools.stopOnDisconnect.status`

Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projects.pools.stopOnNoConnect`

Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gracePeriodMinutes`](#parameter-projectspoolsstoponnoconnectgraceperiodminutes) | int | The specified time in minutes to wait before stopping a Dev Box if no connection is made. |
| [`status`](#parameter-projectspoolsstoponnoconnectstatus) | string | Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed. |

### Parameter: `projects.pools.stopOnNoConnect.gracePeriodMinutes`

The specified time in minutes to wait before stopping a Dev Box if no connection is made.

- Required: Yes
- Type: int

### Parameter: `projects.pools.stopOnNoConnect.status`

Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `projects.pools.tags`

Resource tags to apply to the pool.

- Required: No
- Type: object

### Parameter: `projects.resourceGroupResourceId`

The resource group resource ID where the project will be deployed. If not provided, the project will be deployed to the same resource group as the Dev Center.

- Required: No
- Type: string

### Parameter: `projects.roleAssignments`

Array of role assignments to create for the project.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-projectsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-projectsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-projectsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-projectsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-projectsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-projectsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-projectsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-projectsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `projects.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `projects.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `projects.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `projects.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `projects.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `projects.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `projects.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `projects.roleAssignments.principalType`

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

### Parameter: `projects.tags`

Resource tags to apply to the project.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DevCenter Project Admin'`
  - `'DevCenter Dev Box User'`
  - `'DevTest Labs User'`
  - `'Deployment Environments User'`
  - `'Deployment Environments Reader'`
  - `'Network Contributor'`
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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `devboxDefinitionNames` | array | The names of the DevBox definitions. |
| `devCenterUri` | string | The URI of the Dev Center. |
| `location` | string | The location the Dev Center was deployed into. |
| `name` | string | The name of the Dev Center. |
| `resourceGroupName` | string | The resource group the Dev Center was deployed into. |
| `resourceId` | string | The resource ID of the Dev Center. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/dev-center/project:0.1.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
