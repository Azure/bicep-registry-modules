# private-analytical-workspace `[Data/PrivateAnalyticalWorkspace]`

This pattern module enables you to use Azure services that are typical for data analytics solutions. The goal is to help data scientists establish an environment for data analysis simply. It is secure by default for enterprise use. Data scientists should not spend much time on how to build infrastructure solution. They should mainly concentrate on the data analytics components they require for the solution.

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
| `Microsoft.Databricks/workspaces` | [2023-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2023-02-01/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/networkSecurityGroups/securityRules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups/securityRules) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/data/private-analytical-workspace:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using defaults with provided existing Azure Key Vault](#example-2-using-defaults-with-provided-existing-azure-key-vault)
- [Using defaults with provided existing Azure Log Analytics Workspace](#example-3-using-defaults-with-provided-existing-azure-log-analytics-workspace)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    name: 'dpawmin001'
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
    "name": {
      "value": "dpawmin001"
    }
  }
}
```

</details>
<p>

### Example 2: _Using defaults with provided existing Azure Key Vault_

This instance deploys the module with the minimum set of required parameters and with provided existing Azure Key Vault.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawminkv001'
    // Non-required parameters
    enableDatabricks: true
    keyVaultResourceId: '<keyVaultResourceId>'
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
      "value": "dpawminkv001"
    },
    // Non-required parameters
    "enableDatabricks": {
      "value": true
    },
    "keyVaultResourceId": {
      "value": "<keyVaultResourceId>"
    }
  }
}
```

</details>
<p>

### Example 3: _Using defaults with provided existing Azure Log Analytics Workspace_

This instance deploys the module with the minimum set of required parameters and with provided existing Azure Log Analytics Workspace.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawminlog001'
    // Non-required parameters
    enableDatabricks: true
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
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
      "value": "dpawminlog001"
    },
    // Non-required parameters
    "enableDatabricks": {
      "value": true
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    }
  }
}
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawmax001'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        createMode: 'default'
        enablePurgeProtection: true
        enableSoftDelete: false
        sku: 'standard'
        softDeleteRetentionInDays: 7
      }
      logAnalyticsWorkspace: {
        dailyQuotaGb: 1
        dataRetention: 35
      }
    }
    enableDatabricks: true
    enableTelemetry: true
    location: '<location>'
    tags: {
      'Cost Center': '2345-324'
      Owner: 'Contoso'
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
      "value": "dpawmax001"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "createMode": "default",
          "enablePurgeProtection": true,
          "enableSoftDelete": false,
          "sku": "standard",
          "softDeleteRetentionInDays": 7
        },
        "logAnalyticsWorkspace": {
          "dailyQuotaGb": 1,
          "dataRetention": 35
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Cost Center": "2345-324",
        "Owner": "Contoso"
      }
    }
  }
}
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawwaf001'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        createMode: 'default'
        enablePurgeProtection: true
        enableSoftDelete: true
        sku: 'standard'
        softDeleteRetentionInDays: 7
      }
      logAnalyticsWorkspace: {
        dailyQuotaGb: 1
        dataRetention: 35
      }
    }
    enableDatabricks: true
    enableTelemetry: true
    location: '<location>'
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
      "value": "dpawwaf001"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "createMode": "default",
          "enablePurgeProtection": true,
          "enableSoftDelete": true,
          "sku": "standard",
          "softDeleteRetentionInDays": 7
        },
        "logAnalyticsWorkspace": {
          "dailyQuotaGb": 1,
          "dataRetention": 35
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
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
| [`name`](#parameter-name) | string | Name of the private analytical workspace solution and its components. Used to ensure unique resource names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`advancedOptions`](#parameter-advancedoptions) | object | Additional options that can affect some parts of the solution and how they are configured. |
| [`enableDatabricks`](#parameter-enabledatabricks) | bool | Enable/Disable Azure Databricks service in the solution. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`keyVaultResourceId`](#parameter-keyvaultresourceid) | string | If you already have a Key Vault that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Key Vault for you. |
| [`location`](#parameter-location) | string | Location for all Resources in the solution. |
| [`lock`](#parameter-lock) | object | The lock settings for all Resources in the solution. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | If you already have a Log Analytics Workspace that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Log Analytics Workspace for you. |
| [`solutionAdministrators`](#parameter-solutionadministrators) | array | Array of users or groups who are in charge of the solution. |
| [`tags`](#parameter-tags) | object | Tags for all Resources in the solution. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | This option allows the solution to be connected to a VNET that the customer provides. If you have an existing VNET that was made for this solution, you can specify it here. If you do not use this option, this module will make a new VNET for you. |

### Parameter: `name`

Name of the private analytical workspace solution and its components. Used to ensure unique resource names.

- Required: Yes
- Type: string

### Parameter: `advancedOptions`

Additional options that can affect some parts of the solution and how they are configured.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`databricks`](#parameter-advancedoptionsdatabricks) | object | This parameter allows you to specify additional settings for Azure Databricks if you set the 'enableDatabricks' parameter to 'true'. |
| [`keyVault`](#parameter-advancedoptionskeyvault) | object | This parameter allows you to specify additional settings for Azure Key Vault if the 'keyVaultResourceId' parameter is empty. |
| [`logAnalyticsWorkspace`](#parameter-advancedoptionsloganalyticsworkspace) | object | This parameter allows you to specify additional settings for Azure Log Analytics Workspace if the 'logAnalyticsWorkspaceResourceId' parameter is empty. |
| [`networkAcls`](#parameter-advancedoptionsnetworkacls) | object | Networks Access Control Lists. This value has public IP addresses or ranges that are allowed to access resources in the solution. |
| [`virtualNetwork`](#parameter-advancedoptionsvirtualnetwork) | object | You can use this parameter to integrate the solution with an existing Azure Virtual Network if the 'virtualNetworkResourceId' parameter is not empty. |

### Parameter: `advancedOptions.databricks`

This parameter allows you to specify additional settings for Azure Databricks if you set the 'enableDatabricks' parameter to 'true'.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetNameComputePlane`](#parameter-advancedoptionsdatabrickssubnetnamecomputeplane) | string | The name of the existing Compute Plane Subnet within the Virtual Network in the parameter: 'virtualNetworkResourceId'. |
| [`subnetNameControlPlane`](#parameter-advancedoptionsdatabrickssubnetnamecontrolplane) | string | The name of the existing Control Plane Subnet within the Virtual Network in the parameter: 'virtualNetworkResourceId'. |

### Parameter: `advancedOptions.databricks.subnetNameComputePlane`

The name of the existing Compute Plane Subnet within the Virtual Network in the parameter: 'virtualNetworkResourceId'.

- Required: No
- Type: string

### Parameter: `advancedOptions.databricks.subnetNameControlPlane`

The name of the existing Control Plane Subnet within the Virtual Network in the parameter: 'virtualNetworkResourceId'.

- Required: No
- Type: string

### Parameter: `advancedOptions.keyVault`

This parameter allows you to specify additional settings for Azure Key Vault if the 'keyVaultResourceId' parameter is empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createMode`](#parameter-advancedoptionskeyvaultcreatemode) | string | The vault's create mode to indicate whether the vault need to be recovered or not. - 'recover' or 'default'. The dafult value is: 'default'. |
| [`enablePurgeProtection`](#parameter-advancedoptionskeyvaultenablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. The dafult value is: 'true'. |
| [`enableSoftDelete`](#parameter-advancedoptionskeyvaultenablesoftdelete) | bool | Switch to enable/disable Key Vault's soft delete feature. The dafult value is: 'true'. |
| [`sku`](#parameter-advancedoptionskeyvaultsku) | string | Specifies the SKU for the vault. - 'premium' or 'standard'. The dafult value is: 'premium'. |
| [`softDeleteRetentionInDays`](#parameter-advancedoptionskeyvaultsoftdeleteretentionindays) | int | Soft delete data retention days. It accepts >=7 and <=90. The dafult value is: '90'. |

### Parameter: `advancedOptions.keyVault.createMode`

The vault's create mode to indicate whether the vault need to be recovered or not. - 'recover' or 'default'. The dafult value is: 'default'.

- Required: No
- Type: string

### Parameter: `advancedOptions.keyVault.enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature. The dafult value is: 'true'.

- Required: No
- Type: bool

### Parameter: `advancedOptions.keyVault.enableSoftDelete`

Switch to enable/disable Key Vault's soft delete feature. The dafult value is: 'true'.

- Required: No
- Type: bool

### Parameter: `advancedOptions.keyVault.sku`

Specifies the SKU for the vault. - 'premium' or 'standard'. The dafult value is: 'premium'.

- Required: No
- Type: string

### Parameter: `advancedOptions.keyVault.softDeleteRetentionInDays`

Soft delete data retention days. It accepts >=7 and <=90. The dafult value is: '90'.

- Required: No
- Type: int

### Parameter: `advancedOptions.logAnalyticsWorkspace`

This parameter allows you to specify additional settings for Azure Log Analytics Workspace if the 'logAnalyticsWorkspaceResourceId' parameter is empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyQuotaGb`](#parameter-advancedoptionsloganalyticsworkspacedailyquotagb) | int | The workspace daily quota for ingestion. The dafult value is: '-1' (not limited). |
| [`dataRetention`](#parameter-advancedoptionsloganalyticsworkspacedataretention) | int | Number of days data will be retained for. The dafult value is: '365'. |

### Parameter: `advancedOptions.logAnalyticsWorkspace.dailyQuotaGb`

The workspace daily quota for ingestion. The dafult value is: '-1' (not limited).

- Required: No
- Type: int

### Parameter: `advancedOptions.logAnalyticsWorkspace.dataRetention`

Number of days data will be retained for. The dafult value is: '365'.

- Required: No
- Type: int

### Parameter: `advancedOptions.networkAcls`

Networks Access Control Lists. This value has public IP addresses or ranges that are allowed to access resources in the solution.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipRules`](#parameter-advancedoptionsnetworkaclsiprules) | array | Sets the public IP addresses or ranges that are allowed to access resources in the solution. |

### Parameter: `advancedOptions.networkAcls.ipRules`

Sets the public IP addresses or ranges that are allowed to access resources in the solution.

- Required: No
- Type: array

### Parameter: `advancedOptions.virtualNetwork`

You can use this parameter to integrate the solution with an existing Azure Virtual Network if the 'virtualNetworkResourceId' parameter is not empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetNamePrivateLink`](#parameter-advancedoptionsvirtualnetworksubnetnameprivatelink) | string | The name of the existing Private Link Subnet within the Virtual Network in the parameter: 'virtualNetworkResourceId'. |

### Parameter: `advancedOptions.virtualNetwork.subnetNamePrivateLink`

The name of the existing Private Link Subnet within the Virtual Network in the parameter: 'virtualNetworkResourceId'.

- Required: No
- Type: string

### Parameter: `enableDatabricks`

Enable/Disable Azure Databricks service in the solution.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyVaultResourceId`

If you already have a Key Vault that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Key Vault for you.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources in the solution.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings for all Resources in the solution.

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

### Parameter: `logAnalyticsWorkspaceResourceId`

If you already have a Log Analytics Workspace that you want to use with the solution, you can specify it here. Otherwise, this module will create a new Log Analytics Workspace for you.

- Required: No
- Type: string

### Parameter: `solutionAdministrators`

Array of users or groups who are in charge of the solution.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-solutionadministratorsprincipalid) | string | The principal ID of the principal (user/group) to assign the role to. |
| [`principalType`](#parameter-solutionadministratorsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `solutionAdministrators.principalId`

The principal ID of the principal (user/group) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `solutionAdministrators.principalType`

The principal type of the assigned principal ID.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Group'
    'User'
  ]
  ```

### Parameter: `tags`

Tags for all Resources in the solution.

- Required: No
- Type: object

### Parameter: `virtualNetworkResourceId`

This option allows the solution to be connected to a VNET that the customer provides. If you have an existing VNET that was made for this solution, you can specify it here. If you do not use this option, this module will make a new VNET for you.

- Required: No
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `databricksLocation` | string | Conditional. The location of the Azure Databricks when `enableDatabricks` is `true`. |
| `databricksName` | string | Conditional. The name of the Azure Databricks when `enableDatabricks` is `true`. |
| `databricksResourceGroupName` | string | Conditional. The name of the Azure Databricks resource group when `enableDatabricks` is `true`. |
| `databricksResourceId` | string | Conditional. The resource ID of the Azure Databricks when `enableDatabricks` is `true`. |
| `keyVaultLocation` | string | The location of the Azure Key Vault. |
| `keyVaultName` | string | The name of the Azure Key Vault. |
| `keyVaultResourceGroupName` | string | The name of the Azure Key Vault resource group. |
| `keyVaultResourceId` | string | The resource ID of the Azure Key Vault. |
| `location` | string | The location the resource was deployed into. |
| `logAnalyticsWorkspaceLocation` | string | The location of the Azure Log Analytics Workspace. |
| `logAnalyticsWorkspaceName` | string | The name of the Azure Log Analytics Workspace. |
| `logAnalyticsWorkspaceResourceGroupName` | string | The name of the Azure Log Analytics Workspace resource group. |
| `logAnalyticsWorkspaceResourceId` | string | The resource ID of the Azure Log Analytics Workspace. |
| `name` | string | The name of the resource. |
| `resourceGroupName` | string | The name of the managed resource group. |
| `resourceId` | string | The resource ID of the resource. |
| `virtualNetworkLocation` | string | The location of the Azure Virtual Network. |
| `virtualNetworkName` | string | The name of the Azure Virtual Network. |
| `virtualNetworkResourceGroupName` | string | The name of the Azure Virtual Network resource group. |
| `virtualNetworkResourceId` | string | The resource ID of the Azure Virtual Network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/databricks/workspace:0.4.0` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.6.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.2.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.3.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.3.0` | Remote reference |

## Notes

This pattern aims to speed up data science projects and create Azure environments
for data analysis in a secure and enterprise-ready way.

Data scientists should not worry about infrastructure details.<br>
Ideally, data scientists should only focus on the data analytics tools they need for the solution. For example Databricks, Machine learning, database, etc.<br>
Enterprise security, monitoring, secrets storage, databases, access over a private network should be
integrated into the solution in a transparent way so cloud and security team can approve the whole solution easily.

One of the design goals is to have all the services that are part of the solution
connected to one virtual network to make the traffic between services private (use of private endpoints).
A virtual network can be either created along with the solution or
an existing virtual network (Hub/Spoke model – spoke VNET made by network enterprise team) can be chosen.

The solution's services save diagnostics data to Azure Log Analytics Workspace,
either existing or new. Secrets such as connection string or data source credentials should
go to secrets store securely. Analytical tools use secure credentials to access data sources.
Secrets can go to Azure Key Vault, either existing or new.

The solution will include at least a virtual network (either created or using VNET created
by enterprise network team), Azure Log Analytics workspace for diagnostics and monitoring
(either created or given by cloud team) and Azure Key Vault as secrets
store (either created or given by cloud team).

### Supported Use Cases

#### Use Case 1: New, Isolated Virtual Network from the enterprise network

- Not reachable from enterprise network.
- Accessible only from specified public IP addresses.
- Public IP addresses or ranges needs to be provided to allow network access to the solution.
- Identity of the solution administrator or group needs to be provided to access and manage the solution.
- Easy to provision and manage.
- When Azure Databricks is enabled, the public IP must be enabled manually.

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'UC1'
  params: {
    // Required parameters
    name: 'pawuc1'
    // Non-required parameters
    virtualNetworkResourceId: null        // null means new VNET will be created
    logAnalyticsWorkspaceResourceId: null // null means new Log Analytical Workspace will be created
    keyVaultResourceId: null              // null means new Azure key Vault will be created
    enableDatabricks: true                // Part of the solution and VNET will be new instance of the Azure Databricks
    solutionAdministrators: [
      {
        principalId: <EntraGroupId>       // Specified group will have enough permissions to manage the solution
        principalType: 'Group'            // Group but User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the isolated solution
    }
  }
}
```

#### Use Case 3: Provided Virtual Network

- Customer needs to provide Spoke Virtual Network dedicated to the workload with subnets for the solution.
  - Spoke Network needs to be peered with Hub Network - typically with central Firewall and connectivity to enterprise network.
  - Private Link Subnet, control plane and compute plane subnet for Azure Databricks
  - !!! Subnets for Azure Databricks must have delegations for 'Microsoft.Databricks/workspaces' enabled
  - Each subnet for Azure Databricks must have same NSG associated
  - NSG for ADb must have following rules - https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject#network-security-group-rules-for-workspaces
  - ADB PEPs
  - ADB UDR?? https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/udr


## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
