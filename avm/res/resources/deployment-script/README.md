# Deployment Scripts `[Microsoft.Resources/deploymentScripts]`

This module deploys Deployment Scripts.

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
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/resources/deployment-script:<version>`.

- [Using Azure CLI](#example-1-using-azure-cli)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Using Private Networking](#example-4-using-private-networking)
- [Using Azure PowerShell](#example-5-using-azure-powershell)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _Using Azure CLI_

This instance deploys the module with an Azure CLI script.


<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br/public:avm/res/resources/deployment-script:<version>' = {
  name: 'deploymentScriptDeployment'
  params: {
    // Required parameters
    kind: 'AzureCLI'
    name: 'rdscli001'
    // Non-required parameters
    azCliVersion: '2.9.1'
    environmentVariables: {
      secureList: [
        {
          name: 'var1'
          value: 'AVM Deployment Script test!'
        }
      ]
    }
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
    scriptContent: 'echo \'Enviornment variable value is: \' $var1'
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
      "value": "AzureCLI"
    },
    "name": {
      "value": "rdscli001"
    },
    // Non-required parameters
    "azCliVersion": {
      "value": "2.9.1"
    },
    "environmentVariables": {
      "value": {
        "secureList": [
          {
            "name": "var1",
            "value": "AVM Deployment Script test!"
          }
        ]
      }
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "scriptContent": {
      "value": "echo \"Enviornment variable value is: \" $var1"
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
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
module deploymentScript 'br/public:avm/res/resources/deployment-script:<version>' = {
  name: 'deploymentScriptDeployment'
  params: {
    // Required parameters
    kind: 'AzurePowerShell'
    name: 'rdsmin001'
    // Non-required parameters
    azPowerShellVersion: '9.7'
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    scriptContent: 'Write-Host \'AVM Deployment Script test!\''
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
      "value": "AzurePowerShell"
    },
    "name": {
      "value": "rdsmin001"
    },
    // Non-required parameters
    "azPowerShellVersion": {
      "value": "9.7"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "scriptContent": {
      "value": "Write-Host \"AVM Deployment Script test!\""
    }
  }
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br/public:avm/res/resources/deployment-script:<version>' = {
  name: 'deploymentScriptDeployment'
  params: {
    // Required parameters
    kind: 'AzureCLI'
    name: 'rdsmax001'
    // Non-required parameters
    arguments: '-argument1 \\\'test\\\''
    azCliVersion: '2.9.1'
    cleanupPreference: 'Always'
    containerGroupName: 'dep-cg-rdsmax'
    environmentVariables: {
      secureList: [
        {
          name: 'var1'
          value: 'test'
        }
        {
          name: 'var2'
          secureValue: '<secureValue>'
        }
      ]
    }
    location: '<location>'
    lock: {
      kind: 'None'
    }
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
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
    runOnce: true
    scriptContent: 'echo \'AVM Deployment Script test!\''
    storageAccountResourceId: '<storageAccountResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    timeout: 'PT1H'
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
      "value": "AzureCLI"
    },
    "name": {
      "value": "rdsmax001"
    },
    // Non-required parameters
    "arguments": {
      "value": "-argument1 \\\"test\\\""
    },
    "azCliVersion": {
      "value": "2.9.1"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "containerGroupName": {
      "value": "dep-cg-rdsmax"
    },
    "environmentVariables": {
      "value": {
        "secureList": [
          {
            "name": "var1",
            "value": "test"
          },
          {
            "name": "var2",
            "secureValue": "<secureValue>"
          }
        ]
      }
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "None"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
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
    "runOnce": {
      "value": true
    },
    "scriptContent": {
      "value": "echo \"AVM Deployment Script test!\""
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "timeout": {
      "value": "PT1H"
    }
  }
}
```

</details>
<p>

### Example 4: _Using Private Networking_

This instance deploys the module with access to a private network.


<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br/public:avm/res/resources/deployment-script:<version>' = {
  name: 'deploymentScriptDeployment'
  params: {
    // Required parameters
    kind: 'AzureCLI'
    name: 'rdsnet001'
    // Non-required parameters
    azCliVersion: '2.9.1'
    cleanupPreference: 'Always'
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
    runOnce: true
    scriptContent: 'echo \'AVM Deployment Script test!\''
    storageAccountResourceId: '<storageAccountResourceId>'
    subnetResourceIds: [
      '<subnetResourceId>'
    ]
    timeout: 'PT1H'
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
      "value": "AzureCLI"
    },
    "name": {
      "value": "rdsnet001"
    },
    // Non-required parameters
    "azCliVersion": {
      "value": "2.9.1"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "runOnce": {
      "value": true
    },
    "scriptContent": {
      "value": "echo \"AVM Deployment Script test!\""
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "subnetResourceIds": {
      "value": [
        "<subnetResourceId>"
      ]
    },
    "timeout": {
      "value": "PT1H"
    }
  }
}
```

</details>
<p>

### Example 5: _Using Azure PowerShell_

This instance deploys the module with an Azure PowerShell script.


<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br/public:avm/res/resources/deployment-script:<version>' = {
  name: 'deploymentScriptDeployment'
  params: {
    // Required parameters
    kind: 'AzurePowerShell'
    name: 'rdsps001'
    // Non-required parameters
    arguments: '-var1 \\\'AVM Deployment Script test!\\\''
    azPowerShellVersion: '9.7'
    location: '<location>'
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
    scriptContent: 'param([string] $var1);Write-Host \'Argument var1 value is:\' $var1'
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
      "value": "AzurePowerShell"
    },
    "name": {
      "value": "rdsps001"
    },
    // Non-required parameters
    "arguments": {
      "value": "-var1 \\\"AVM Deployment Script test!\\\""
    },
    "azPowerShellVersion": {
      "value": "9.7"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "scriptContent": {
      "value": "param([string] $var1);Write-Host \"Argument var1 value is:\" $var1"
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    }
  }
}
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module deploymentScript 'br/public:avm/res/resources/deployment-script:<version>' = {
  name: 'deploymentScriptDeployment'
  params: {
    // Required parameters
    kind: 'AzureCLI'
    name: 'rdswaf001'
    // Non-required parameters
    azCliVersion: '2.9.1'
    cleanupPreference: 'Always'
    location: '<location>'
    lock: {
      kind: 'None'
    }
    managedIdentities: {
      userAssignedResourcesIds: [
        '<managedIdentityResourceId>'
      ]
    }
    retentionInterval: 'P1D'
    runOnce: true
    scriptContent: 'echo \'AVM Deployment Script test!\''
    storageAccountResourceId: '<storageAccountResourceId>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    timeout: 'PT1H'
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
      "value": "AzureCLI"
    },
    "name": {
      "value": "rdswaf001"
    },
    // Non-required parameters
    "azCliVersion": {
      "value": "2.9.1"
    },
    "cleanupPreference": {
      "value": "Always"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "None"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourcesIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "retentionInterval": {
      "value": "P1D"
    },
    "runOnce": {
      "value": true
    },
    "scriptContent": {
      "value": "echo \"AVM Deployment Script test!\""
    },
    "storageAccountResourceId": {
      "value": "<storageAccountResourceId>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "timeout": {
      "value": "PT1H"
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
| [`kind`](#parameter-kind) | string | Specifies the Kind of the Deployment Script. |
| [`name`](#parameter-name) | string | Name of the Deployment Script. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arguments`](#parameter-arguments) | string | Command-line arguments to pass to the script. Arguments are separated by spaces. |
| [`azCliVersion`](#parameter-azcliversion) | string | Azure CLI module version to be used. See a list of supported Azure CLI versions: https://mcr.microsoft.com/v2/azure-cli/tags/list. |
| [`azPowerShellVersion`](#parameter-azpowershellversion) | string | Azure PowerShell module version to be used. See a list of supported Azure PowerShell versions: https://mcr.microsoft.com/v2/azuredeploymentscripts-powershell/tags/list. |
| [`cleanupPreference`](#parameter-cleanuppreference) | string | The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled). |
| [`containerGroupName`](#parameter-containergroupname) | string | Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`environmentVariables`](#parameter-environmentvariables) | secureObject | The environment variables to pass over to the script. The list is passed as an object with a key name "secureList" and the value is the list of environment variables (array). The list must have a 'name' and a 'value' or a 'secretValue' property for each object. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`primaryScriptUri`](#parameter-primaryscripturi) | string | Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent parameter instead. |
| [`retentionInterval`](#parameter-retentioninterval) | string | Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week). |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`runOnce`](#parameter-runonce) | bool | When set to false, script will run every time the template is deployed. When set to true, the script will only run once. |
| [`scriptContent`](#parameter-scriptcontent) | string | Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead. |
| [`storageAccountResourceId`](#parameter-storageaccountresourceid) | string | The resource ID of the storage account to use for this deployment script. If none is provided, the deployment script uses a temporary, managed storage account. |
| [`subnetResourceIds`](#parameter-subnetresourceids) | array | List of subnet IDs to use for the container group. This is required if you want to run the deployment script in a private network. When using a private network, the `Storage File Data Privileged Contributor` role needs to be assigned to the user-assigned managed identity and the deployment principal needs to have permissions to list the storage account keys. Also, Shared-Keys must not be disabled on the used storage account [ref](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet). |
| [`supportingScriptUris`](#parameter-supportingscripturis) | array | List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent). |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`timeout`](#parameter-timeout) | string | Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Do not provide a value! This date value is used to make sure the script run every time the template is deployed. |

### Parameter: `kind`

Specifies the Kind of the Deployment Script.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureCLI'
    'AzurePowerShell'
  ]
  ```

### Parameter: `name`

Name of the Deployment Script.

- Required: Yes
- Type: string

### Parameter: `arguments`

Command-line arguments to pass to the script. Arguments are separated by spaces.

- Required: No
- Type: string

### Parameter: `azCliVersion`

Azure CLI module version to be used. See a list of supported Azure CLI versions: https://mcr.microsoft.com/v2/azure-cli/tags/list.

- Required: No
- Type: string

### Parameter: `azPowerShellVersion`

Azure PowerShell module version to be used. See a list of supported Azure PowerShell versions: https://mcr.microsoft.com/v2/azuredeploymentscripts-powershell/tags/list.

- Required: No
- Type: string

### Parameter: `cleanupPreference`

The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled).

- Required: No
- Type: string
- Default: `'Always'`
- Allowed:
  ```Bicep
  [
    'Always'
    'OnExpiration'
    'OnSuccess'
  ]
  ```

### Parameter: `containerGroupName`

Container group name, if not specified then the name will get auto-generated. Not specifying a 'containerGroupName' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use 'containerGroupName' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. 'containerGroupName' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `environmentVariables`

The environment variables to pass over to the script. The list is passed as an object with a key name "secureList" and the value is the list of environment variables (array). The list must have a 'name' and a 'value' or a 'secretValue' property for each object.

- Required: No
- Type: secureObject

### Parameter: `location`

Location for all resources.

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
| [`userAssignedResourcesIds`](#parameter-managedidentitiesuserassignedresourcesids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourcesIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `primaryScriptUri`

Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent parameter instead.

- Required: No
- Type: string

### Parameter: `retentionInterval`

Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week).

- Required: No
- Type: string
- Default: `'P1D'`

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

### Parameter: `runOnce`

When set to false, script will run every time the template is deployed. When set to true, the script will only run once.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `scriptContent`

Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead.

- Required: No
- Type: string

### Parameter: `storageAccountResourceId`

The resource ID of the storage account to use for this deployment script. If none is provided, the deployment script uses a temporary, managed storage account.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subnetResourceIds`

List of subnet IDs to use for the container group. This is required if you want to run the deployment script in a private network. When using a private network, the `Storage File Data Privileged Contributor` role needs to be assigned to the user-assigned managed identity and the deployment principal needs to have permissions to list the storage account keys. Also, Shared-Keys must not be disabled on the used storage account [ref](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet).

- Required: No
- Type: array

### Parameter: `supportingScriptUris`

List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent).

- Required: No
- Type: array

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `timeout`

Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; 'PT30M' - 30 minutes; 'P5D' - 5 days; 'P1Y' 1 year.

- Required: No
- Type: string

### Parameter: `baseTime`

Do not provide a value! This date value is used to make sure the script run every time the template is deployed.

- Required: No
- Type: string
- Default: `[utcNow('yyyy-MM-dd-HH-mm-ss')]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `deploymentScriptLogs` | array | The logs of the deployment script. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployment script. |
| `outputs` | object | The output of the deployment script. |
| `resourceGroupName` | string | The resource group the deployment script was deployed into. |
| `resourceId` | string | The resource ID of the deployment script. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
