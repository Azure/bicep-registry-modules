# Dev Center Project `[Microsoft.DevCenter/projects]`

This module deploys a Dev Center Project.

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
| `Microsoft.DevCenter/projects` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects) |
| `Microsoft.DevCenter/projects/catalogs` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/catalogs) |
| `Microsoft.DevCenter/projects/environmentTypes` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/environmentTypes) |
| `Microsoft.DevCenter/projects/pools` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools) |
| `Microsoft.DevCenter/projects/pools/schedules` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/pools/schedules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/dev-center/project:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module project 'br/public:avm/res/dev-center/project:<version>' = {
  name: 'projectDeployment'
  params: {
    // Required parameters
    devCenterResourceId: '<devCenterResourceId>'
    name: 'dcpmin001'
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
    "devCenterResourceId": {
      "value": "<devCenterResourceId>"
    },
    "name": {
      "value": "dcpmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/project:<version>'

// Required parameters
param devCenterResourceId = '<devCenterResourceId>'
param name = 'dcpmin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module project 'br/public:avm/res/dev-center/project:<version>' = {
  name: 'projectDeployment'
  params: {
    // Required parameters
    devCenterResourceId: '<devCenterResourceId>'
    name: 'dcpmax001'
    // Non-required parameters
    catalogs: [
      {
        gitHub: {
          branch: 'main'
          path: 'dotnet-dev-orchardcore'
          secretIdentifier: '<secretIdentifier>'
          uri: 'https://github.com/microsoft/devcenter-catalog.git'
        }
        name: 'testCatalogGitHub'
        syncType: 'Scheduled'
        tags: {
          'test-tag': 'test-value'
        }
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
    catalogSettings: {
      catalogItemSyncTypes: [
        'EnvironmentDefinition'
        'ImageDefinition'
      ]
    }
    description: 'This is a test project for the Dev Center project module.'
    displayName: 'My Dev Center Project'
    environmentTypes: [
      {
        creatorRoleAssignmentRoles: [
          'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          'b24988ac-6180-42a0-ab88-20f7382dd24c'
        ]
        deploymentTargetSubscriptionResourceId: '<deploymentTargetSubscriptionResourceId>'
        displayName: 'My Sandbox Environment Type'
        managedIdentities: {
          systemAssigned: false
          userAssignedResourceIds: [
            '<managedIdentity1ResourceId>'
          ]
        }
        name: 'dep-et-dcpmax'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'DevCenter Project Admin'
          }
        ]
        status: 'Enabled'
        tags: {
          'prj-type': 'sandbox'
        }
        userRoleAssignmentsRoles: [
          {
            objectId: '<objectId>'
            roleDefinitions: [
              'b59867f0-fa02-499b-be73-45a86b5b3e1c'
              'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815'
            ]
          }
          {
            objectId: '<objectId>'
            roleDefinitions: [
              '<roleDefinitionId // Custom role>'
            ]
          }
        ]
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentity1ResourceId>'
      ]
    }
    maxDevBoxesPerUser: 2
    pools: [
      {
        devBoxDefinitionName: '<devBoxDefinitionName>'
        devBoxDefinitionType: 'Reference'
        displayName: 'My Sandbox Pool - Managed Network'
        localAdministrator: 'Enabled'
        managedVirtualNetworkRegion: 'australiaeast'
        name: 'sandbox-pool'
        schedule: {
          state: 'Enabled'
          time: '18:30'
          timeZone: 'Australia/Sydney'
        }
        singleSignOnStatus: 'Enabled'
        stopOnDisconnect: {
          gracePeriodMinutes: 60
          status: 'Enabled'
        }
        stopOnNoConnect: {
          gracePeriodMinutes: 30
          status: 'Enabled'
        }
        virtualNetworkType: 'Managed'
      }
      {
        devBoxDefinitionName: '<devBoxDefinitionName>'
        devBoxDefinitionType: 'Reference'
        displayName: 'My Sandbox Pool - Unmanaged Network'
        localAdministrator: 'Disabled'
        name: 'sandbox-pool-2'
        networkConnectionName: '<networkConnectionName>'
        singleSignOnStatus: 'Disabled'
        virtualNetworkType: 'Unmanaged'
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'DevCenter Project Admin'
      }
      {
        principalId: '<principalId>'
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
    "devCenterResourceId": {
      "value": "<devCenterResourceId>"
    },
    "name": {
      "value": "dcpmax001"
    },
    // Non-required parameters
    "catalogs": {
      "value": [
        {
          "gitHub": {
            "branch": "main",
            "path": "dotnet-dev-orchardcore",
            "secretIdentifier": "<secretIdentifier>",
            "uri": "https://github.com/microsoft/devcenter-catalog.git"
          },
          "name": "testCatalogGitHub",
          "syncType": "Scheduled",
          "tags": {
            "test-tag": "test-value"
          }
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
    "catalogSettings": {
      "value": {
        "catalogItemSyncTypes": [
          "EnvironmentDefinition",
          "ImageDefinition"
        ]
      }
    },
    "description": {
      "value": "This is a test project for the Dev Center project module."
    },
    "displayName": {
      "value": "My Dev Center Project"
    },
    "environmentTypes": {
      "value": [
        {
          "creatorRoleAssignmentRoles": [
            "acdd72a7-3385-48ef-bd42-f606fba81ae7",
            "b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "deploymentTargetSubscriptionResourceId": "<deploymentTargetSubscriptionResourceId>",
          "displayName": "My Sandbox Environment Type",
          "managedIdentities": {
            "systemAssigned": false,
            "userAssignedResourceIds": [
              "<managedIdentity1ResourceId>"
            ]
          },
          "name": "dep-et-dcpmax",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "DevCenter Project Admin"
            }
          ],
          "status": "Enabled",
          "tags": {
            "prj-type": "sandbox"
          },
          "userRoleAssignmentsRoles": [
            {
              "objectId": "<objectId>",
              "roleDefinitions": [
                "b59867f0-fa02-499b-be73-45a86b5b3e1c",
                "e503ece1-11d0-4e8e-8e2c-7a6c3bf38815"
              ]
            },
            {
              "objectId": "<objectId>",
              "roleDefinitions": [
                "<roleDefinitionId // Custom role>"
              ]
            }
          ]
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
          "<managedIdentity1ResourceId>"
        ]
      }
    },
    "maxDevBoxesPerUser": {
      "value": 2
    },
    "pools": {
      "value": [
        {
          "devBoxDefinitionName": "<devBoxDefinitionName>",
          "devBoxDefinitionType": "Reference",
          "displayName": "My Sandbox Pool - Managed Network",
          "localAdministrator": "Enabled",
          "managedVirtualNetworkRegion": "australiaeast",
          "name": "sandbox-pool",
          "schedule": {
            "state": "Enabled",
            "time": "18:30",
            "timeZone": "Australia/Sydney"
          },
          "singleSignOnStatus": "Enabled",
          "stopOnDisconnect": {
            "gracePeriodMinutes": 60,
            "status": "Enabled"
          },
          "stopOnNoConnect": {
            "gracePeriodMinutes": 30,
            "status": "Enabled"
          },
          "virtualNetworkType": "Managed"
        },
        {
          "devBoxDefinitionName": "<devBoxDefinitionName>",
          "devBoxDefinitionType": "Reference",
          "displayName": "My Sandbox Pool - Unmanaged Network",
          "localAdministrator": "Disabled",
          "name": "sandbox-pool-2",
          "networkConnectionName": "<networkConnectionName>",
          "singleSignOnStatus": "Disabled",
          "virtualNetworkType": "Unmanaged"
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
          "principalId": "<principalId>",
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
using 'br/public:avm/res/dev-center/project:<version>'

// Required parameters
param devCenterResourceId = '<devCenterResourceId>'
param name = 'dcpmax001'
// Non-required parameters
param catalogs = [
  {
    gitHub: {
      branch: 'main'
      path: 'dotnet-dev-orchardcore'
      secretIdentifier: '<secretIdentifier>'
      uri: 'https://github.com/microsoft/devcenter-catalog.git'
    }
    name: 'testCatalogGitHub'
    syncType: 'Scheduled'
    tags: {
      'test-tag': 'test-value'
    }
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
param catalogSettings = {
  catalogItemSyncTypes: [
    'EnvironmentDefinition'
    'ImageDefinition'
  ]
}
param description = 'This is a test project for the Dev Center project module.'
param displayName = 'My Dev Center Project'
param environmentTypes = [
  {
    creatorRoleAssignmentRoles: [
      'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    deploymentTargetSubscriptionResourceId: '<deploymentTargetSubscriptionResourceId>'
    displayName: 'My Sandbox Environment Type'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentity1ResourceId>'
      ]
    }
    name: 'dep-et-dcpmax'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'DevCenter Project Admin'
      }
    ]
    status: 'Enabled'
    tags: {
      'prj-type': 'sandbox'
    }
    userRoleAssignmentsRoles: [
      {
        objectId: '<objectId>'
        roleDefinitions: [
          'b59867f0-fa02-499b-be73-45a86b5b3e1c'
          'e503ece1-11d0-4e8e-8e2c-7a6c3bf38815'
        ]
      }
      {
        objectId: '<objectId>'
        roleDefinitions: [
          '<roleDefinitionId // Custom role>'
        ]
      }
    ]
  }
]
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentity1ResourceId>'
  ]
}
param maxDevBoxesPerUser = 2
param pools = [
  {
    devBoxDefinitionName: '<devBoxDefinitionName>'
    devBoxDefinitionType: 'Reference'
    displayName: 'My Sandbox Pool - Managed Network'
    localAdministrator: 'Enabled'
    managedVirtualNetworkRegion: 'australiaeast'
    name: 'sandbox-pool'
    schedule: {
      state: 'Enabled'
      time: '18:30'
      timeZone: 'Australia/Sydney'
    }
    singleSignOnStatus: 'Enabled'
    stopOnDisconnect: {
      gracePeriodMinutes: 60
      status: 'Enabled'
    }
    stopOnNoConnect: {
      gracePeriodMinutes: 30
      status: 'Enabled'
    }
    virtualNetworkType: 'Managed'
  }
  {
    devBoxDefinitionName: '<devBoxDefinitionName>'
    devBoxDefinitionType: 'Reference'
    displayName: 'My Sandbox Pool - Unmanaged Network'
    localAdministrator: 'Disabled'
    name: 'sandbox-pool-2'
    networkConnectionName: '<networkConnectionName>'
    singleSignOnStatus: 'Disabled'
    virtualNetworkType: 'Unmanaged'
  }
]
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'DevCenter Project Admin'
  }
  {
    principalId: '<principalId>'
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
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module project 'br/public:avm/res/dev-center/project:<version>' = {
  name: 'projectDeployment'
  params: {
    // Required parameters
    devCenterResourceId: '<devCenterResourceId>'
    name: 'dcpwaf001'
    // Non-required parameters
    catalogSettings: {
      catalogItemSyncTypes: [
        'EnvironmentDefinition'
        'ImageDefinition'
      ]
    }
    description: 'This is a test project for the Dev Center project module.'
    displayName: 'My Dev Center Project'
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
        name: 'dep-et-dcpwaf'
        status: 'Enabled'
      }
    ]
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    maxDevBoxesPerUser: 2
    pools: [
      {
        devBoxDefinitionName: '<devBoxDefinitionName>'
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
    "devCenterResourceId": {
      "value": "<devCenterResourceId>"
    },
    "name": {
      "value": "dcpwaf001"
    },
    // Non-required parameters
    "catalogSettings": {
      "value": {
        "catalogItemSyncTypes": [
          "EnvironmentDefinition",
          "ImageDefinition"
        ]
      }
    },
    "description": {
      "value": "This is a test project for the Dev Center project module."
    },
    "displayName": {
      "value": "My Dev Center Project"
    },
    "environmentTypes": {
      "value": [
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
          "name": "dep-et-dcpwaf",
          "status": "Enabled"
        }
      ]
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "maxDevBoxesPerUser": {
      "value": 2
    },
    "pools": {
      "value": [
        {
          "devBoxDefinitionName": "<devBoxDefinitionName>",
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/dev-center/project:<version>'

// Required parameters
param devCenterResourceId = '<devCenterResourceId>'
param name = 'dcpwaf001'
// Non-required parameters
param catalogSettings = {
  catalogItemSyncTypes: [
    'EnvironmentDefinition'
    'ImageDefinition'
  ]
}
param description = 'This is a test project for the Dev Center project module.'
param displayName = 'My Dev Center Project'
param environmentTypes = [
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
    name: 'dep-et-dcpwaf'
    status: 'Enabled'
  }
]
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param maxDevBoxesPerUser = 2
param pools = [
  {
    devBoxDefinitionName: '<devBoxDefinitionName>'
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
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devCenterResourceId`](#parameter-devcenterresourceid) | string | Resource ID of an associated DevCenter. |
| [`name`](#parameter-name) | string | The name of the project. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogs`](#parameter-catalogs) | array | The catalogs to create in the project. Catalogs are templates from a git repository that can be used to create environments. |
| [`catalogSettings`](#parameter-catalogsettings) | object | The settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings. |
| [`description`](#parameter-description) | string | The description of the project. |
| [`displayName`](#parameter-displayname) | string | The display name of project. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentTypes`](#parameter-environmenttypes) | array | The environment types to create. Environment types must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Only one user assigned identity can be used per project. |
| [`maxDevBoxesPerUser`](#parameter-maxdevboxesperuser) | int | When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced. |
| [`pools`](#parameter-pools) | array | The type of pool to create in the project. A project pool is a container for dev boxes that share the same configuration, like a dev box definition and a network connection. Essentially, a project pool defines the specifications for the dev boxes that developers can create from a specific project in the Dev Box service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Resource tags to apply to the project. |

### Parameter: `devCenterResourceId`

Resource ID of an associated DevCenter.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the project.

- Required: Yes
- Type: string

### Parameter: `catalogs`

The catalogs to create in the project. Catalogs are templates from a git repository that can be used to create environments.

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

### Parameter: `catalogSettings`

The settings to be used when associating a project with a catalog. The Dev Center this project is associated with must allow configuring catalog item sync types before configuring project level catalog settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`catalogItemSyncTypes`](#parameter-catalogsettingscatalogitemsynctypes) | array | Indicates catalog item types that can be synced. |

### Parameter: `catalogSettings.catalogItemSyncTypes`

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

### Parameter: `description`

The description of the project.

- Required: No
- Type: string

### Parameter: `displayName`

The display name of project.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentTypes`

The environment types to create. Environment types must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`creatorRoleAssignmentRoles`](#parameter-environmenttypescreatorroleassignmentroles) | array | An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified. |
| [`deploymentTargetSubscriptionResourceId`](#parameter-environmenttypesdeploymenttargetsubscriptionresourceid) | string | The subscription Resource ID where the environment type will be mapped to. The environment's resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}". |
| [`name`](#parameter-environmenttypesname) | string | The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-environmenttypesdisplayname) | string | The display name of the environment type. |
| [`managedIdentities`](#parameter-environmenttypesmanagedidentities) | object | The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity. |
| [`roleAssignments`](#parameter-environmenttypesroleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-environmenttypesstatus) | string | Defines whether this Environment Type can be used in this Project. The default is "Enabled". |
| [`tags`](#parameter-environmenttypestags) | object | Resource tags to apply to the environment type. |
| [`userRoleAssignmentsRoles`](#parameter-environmenttypesuserroleassignmentsroles) | array | A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions. |

### Parameter: `environmentTypes.creatorRoleAssignmentRoles`

An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified.

- Required: Yes
- Type: array

### Parameter: `environmentTypes.deploymentTargetSubscriptionResourceId`

The subscription Resource ID where the environment type will be mapped to. The environment's resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}".

- Required: Yes
- Type: string

### Parameter: `environmentTypes.name`

The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.

- Required: Yes
- Type: string

### Parameter: `environmentTypes.displayName`

The display name of the environment type.

- Required: No
- Type: string

### Parameter: `environmentTypes.managedIdentities`

The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-environmenttypesmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-environmenttypesmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `environmentTypes.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `environmentTypes.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `environmentTypes.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-environmenttypesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-environmenttypesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-environmenttypesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-environmenttypesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-environmenttypesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-environmenttypesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-environmenttypesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-environmenttypesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `environmentTypes.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `environmentTypes.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `environmentTypes.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `environmentTypes.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `environmentTypes.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `environmentTypes.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `environmentTypes.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `environmentTypes.roleAssignments.principalType`

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

### Parameter: `environmentTypes.status`

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

### Parameter: `environmentTypes.tags`

Resource tags to apply to the environment type.

- Required: No
- Type: object

### Parameter: `environmentTypes.userRoleAssignmentsRoles`

A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-environmenttypesuserroleassignmentsrolesobjectid) | string | The object ID of the user, group, service principal, or managed identity. |
| [`roleDefinitions`](#parameter-environmenttypesuserroleassignmentsrolesroledefinitions) | array | An array of role definition GUIDs to assign to the object. |

### Parameter: `environmentTypes.userRoleAssignmentsRoles.objectId`

The object ID of the user, group, service principal, or managed identity.

- Required: Yes
- Type: string

### Parameter: `environmentTypes.userRoleAssignmentsRoles.roleDefinitions`

An array of role definition GUIDs to assign to the object.

- Required: Yes
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

### Parameter: `managedIdentities`

The managed identity definition for this resource. Only one user assigned identity can be used per project.

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

### Parameter: `maxDevBoxesPerUser`

When specified, limits the maximum number of Dev Boxes a single user can create across all pools in the project. This will have no effect on existing Dev Boxes when reduced.

- Required: No
- Type: int
- MinValue: 0

### Parameter: `pools`

The type of pool to create in the project. A project pool is a container for dev boxes that share the same configuration, like a dev box definition and a network connection. Essentially, a project pool defines the specifications for the dev boxes that developers can create from a specific project in the Dev Box service.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinitionName`](#parameter-poolsdevboxdefinitionname) | string | Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\~Catalog\~{catalogName}\~{imagedefinition YAML name}" (e.g. "\~Catalog\~eshopRepo\~frontend-dev"). |
| [`localAdministrator`](#parameter-poolslocaladministrator) | string | Each dev box creator will be granted the selected permissions on the dev boxes they create. Indicates whether owners of Dev Boxes in this pool are added as a "local administrator" or "standard user" on the Dev Box. |
| [`name`](#parameter-poolsname) | string | The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes. |
| [`virtualNetworkType`](#parameter-poolsvirtualnetworktype) | string | Indicates whether the pool uses a Virtual Network managed by Microsoft or a customer provided network. For the easiest configuration experience, the Microsoft hosted network can be used for dev box deployment. For organizations that require customized networking, use a network connection resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinition`](#parameter-poolsdevboxdefinition) | object | A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value". |
| [`managedVirtualNetworkRegion`](#parameter-poolsmanagedvirtualnetworkregion) | string | The region of the managed virtual network. Required if virtualNetworkType is "Managed". |
| [`networkConnectionName`](#parameter-poolsnetworkconnectionname) | string | Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`devBoxDefinitionType`](#parameter-poolsdevboxdefinitiontype) | string | Indicates if the pool is created from an existing Dev Box Definition or if one is provided directly. Defaults to "Reference". |
| [`displayName`](#parameter-poolsdisplayname) | string | The display name of the pool. |
| [`schedule`](#parameter-poolsschedule) | object | The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration. |
| [`singleSignOnStatus`](#parameter-poolssinglesignonstatus) | string | Indicates whether Dev Boxes in this pool are created with single sign on enabled. The also requires that single sign on be enabled on the tenant. Changing this setting will not affect existing dev boxes. |
| [`stopOnDisconnect`](#parameter-poolsstopondisconnect) | object | Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects. |
| [`stopOnNoConnect`](#parameter-poolsstoponnoconnect) | object | Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects. |
| [`tags`](#parameter-poolstags) | object | Resource tags to apply to the pool. |

### Parameter: `pools.devBoxDefinitionName`

Name of a Dev Box definition in parent Project of this Pool. If creating a pool from a definition defined in the Dev Center, then this will be the name of the definition. If creating a pool from a custom definition (e.g. Team Customizations), first the catalog must be added to this project, and second must use the format "\~Catalog\~{catalogName}\~{imagedefinition YAML name}" (e.g. "\~Catalog\~eshopRepo\~frontend-dev").

- Required: Yes
- Type: string

### Parameter: `pools.localAdministrator`

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

### Parameter: `pools.name`

The name of the project pool. This name must be unique within a project and is visible to developers when creating dev boxes.

- Required: Yes
- Type: string

### Parameter: `pools.virtualNetworkType`

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

### Parameter: `pools.devBoxDefinition`

A definition of the machines that are created from this Pool. Required if devBoxDefinitionType is "Value".

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`imageReferenceResourceId`](#parameter-poolsdevboxdefinitionimagereferenceresourceid) | string | The resource ID of the image reference for the dev box definition. This would be the resource ID of the project image where the image has the same name as the dev box definition name. If the dev box definition is created from a catalog, then this would be the resource ID of the image in the project that was created from the catalog. The format is "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevCenter/projects/{projectName}/images/~Catalog~{catalogName}~{imagedefinition YAML name}". |
| [`sku`](#parameter-poolsdevboxdefinitionsku) | object | The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs. |

### Parameter: `pools.devBoxDefinition.imageReferenceResourceId`

The resource ID of the image reference for the dev box definition. This would be the resource ID of the project image where the image has the same name as the dev box definition name. If the dev box definition is created from a catalog, then this would be the resource ID of the image in the project that was created from the catalog. The format is "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevCenter/projects/{projectName}/images/~Catalog~{catalogName}~{imagedefinition YAML name}".

- Required: Yes
- Type: string

### Parameter: `pools.devBoxDefinition.sku`

The SKU configuration for the dev box definition. See "https://learn.microsoft.com/en-us/rest/api/devcenter/administrator/skus/list-by-subscription?view=rest-devcenter-administrator-2024-02-01" for more information about SKUs.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-poolsdevboxdefinitionskuname) | string | The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-poolsdevboxdefinitionskucapacity) | int | If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted. |
| [`family`](#parameter-poolsdevboxdefinitionskufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2". |
| [`size`](#parameter-poolsdevboxdefinitionskusize) | string | The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code. |

### Parameter: `pools.devBoxDefinition.sku.name`

The name of the SKU. E.g. P3. It is typically a letter+number code. E.g. "general_i_8c32gb256ssd_v2" or "general_i_8c32gb512ssd_v2". See "https://learn.microsoft.com/en-us/python/api/azure-developer-devcenter/azure.developer.devcenter.models.hardwareprofile" for more information about acceptable SKU names.

- Required: Yes
- Type: string

### Parameter: `pools.devBoxDefinition.sku.capacity`

If the SKU supports scale out/in then the capacity integer should be included. If scale out/in is not possible for the resource this may be omitted.

- Required: No
- Type: int

### Parameter: `pools.devBoxDefinition.sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here. For example, "general_i_v2".

- Required: No
- Type: string

### Parameter: `pools.devBoxDefinition.sku.size`

The SKU size. When the name field is the combination of tier and some other value, this would be the standalone code.

- Required: No
- Type: string

### Parameter: `pools.managedVirtualNetworkRegion`

The region of the managed virtual network. Required if virtualNetworkType is "Managed".

- Required: No
- Type: string

### Parameter: `pools.networkConnectionName`

Name of a Network Connection in parent Project of this Pool. Required if virtualNetworkType is "Unmanaged". The region hosting a pool is determined by the region of the network connection. For best performance, create a dev box pool for every region where your developers are located. The network connection cannot be configured with "None" domain join type and must be first attached to the Dev Center before used by the pool. Will be set to "managedNetwork" if virtualNetworkType is "Managed".

- Required: No
- Type: string

### Parameter: `pools.devBoxDefinitionType`

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

### Parameter: `pools.displayName`

The display name of the pool.

- Required: No
- Type: string

### Parameter: `pools.schedule`

The schedule for the pool. Dev boxes in this pool will auto-stop every day as per the schedule configuration.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`state`](#parameter-poolsschedulestate) | string | Indicates whether or not this scheduled task is enabled. Allowed values: Disabled, Enabled. |
| [`time`](#parameter-poolsscheduletime) | string | The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM. |
| [`timeZone`](#parameter-poolsscheduletimezone) | string | The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central". |

### Parameter: `pools.schedule.state`

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

### Parameter: `pools.schedule.time`

The target time to trigger the action. The format is HH:MM. For example, "14:30" for 2:30 PM.

- Required: Yes
- Type: string

### Parameter: `pools.schedule.timeZone`

The IANA timezone id at which the schedule should execute. For example, "Australia/Sydney", "Canada/Central".

- Required: Yes
- Type: string

### Parameter: `pools.singleSignOnStatus`

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

### Parameter: `pools.stopOnDisconnect`

Stop on "disconnect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period after the user disconnects.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gracePeriodMinutes`](#parameter-poolsstopondisconnectgraceperiodminutes) | int | The specified time in minutes to wait before stopping a Dev Box once disconnect is detected. |
| [`status`](#parameter-poolsstopondisconnectstatus) | string | Whether the feature to stop the Dev Box on disconnect once the grace period has lapsed is enabled. |

### Parameter: `pools.stopOnDisconnect.gracePeriodMinutes`

The specified time in minutes to wait before stopping a Dev Box once disconnect is detected.

- Required: Yes
- Type: int

### Parameter: `pools.stopOnDisconnect.status`

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

### Parameter: `pools.stopOnNoConnect`

Stop on "no connect" configuration settings for Dev Boxes created in this pool. Dev boxes in this pool will hibernate after the grace period if the user never connects.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gracePeriodMinutes`](#parameter-poolsstoponnoconnectgraceperiodminutes) | int | The specified time in minutes to wait before stopping a Dev Box if no connection is made. |
| [`status`](#parameter-poolsstoponnoconnectstatus) | string | Enables the feature to stop a started Dev Box when it has not been connected to, once the grace period has lapsed. |

### Parameter: `pools.stopOnNoConnect.gracePeriodMinutes`

The specified time in minutes to wait before stopping a Dev Box if no connection is made.

- Required: Yes
- Type: int

### Parameter: `pools.stopOnNoConnect.status`

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

### Parameter: `pools.tags`

Resource tags to apply to the pool.

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

Resource tags to apply to the project.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the Dev Center Project resource was deployed into. |
| `name` | string | The name of the Dev Center Project. |
| `resourceGroupName` | string | The name of the resource group the Dev Center Project resource was deployed into. |
| `resourceId` | string | The resource ID of the Dev Center Project. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
