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
| `Microsoft.Databricks/accessConnectors` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2022-10-01-preview/accessConnectors) |
| `Microsoft.Databricks/workspaces` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Databricks/2024-05-01/workspaces) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults) |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
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
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
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
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Minimal Deployment - fully private](#example-3-minimal-deployment---fully-private)
- [Minimal Deployment - allowed IP address](#example-4-minimal-deployment---allowed-ip-address)
- [Use Case 1 - fully private](#example-5-use-case-1---fully-private)
- [Use Case 1 - allowed IP address](#example-6-use-case-1---allowed-ip-address)
- [Use Case 2 - fully private](#example-7-use-case-2---fully-private)
- [Use Case 2 - allowed IP address](#example-8-use-case-2---allowed-ip-address)
- [Use Case 3 - fully private](#example-9-use-case-3---fully-private)
- [Use Case 3 - allowed IP address](#example-10-use-case-3---allowed-ip-address)
- [WAF-aligned](#example-11-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawmin002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        enablePurgeProtection: false
      }
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
      "value": "dpawmin002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "enablePurgeProtection": false
        }
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawmin002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    enablePurgeProtection: false
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawmax002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        createMode: 'default'
        enablePurgeProtection: false
        enableSoftDelete: false
        sku: 'standard'
        softDeleteRetentionInDays: 7
      }
      logAnalyticsWorkspace: {
        dailyQuotaGb: 1
        dataRetention: 35
      }
      networkAcls: {
        ipRules: [
          '104.43.16.94'
        ]
      }
    }
    enableDatabricks: true
    location: '<location>'
    tags: {
      CostCenter: '123459876'
      Owner: 'Contoso MAX Team'
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
      "value": "dpawmax002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "createMode": "default",
          "enablePurgeProtection": false,
          "enableSoftDelete": false,
          "sku": "standard",
          "softDeleteRetentionInDays": 7
        },
        "logAnalyticsWorkspace": {
          "dailyQuotaGb": 1,
          "dataRetention": 35
        },
        "networkAcls": {
          "ipRules": [
            "104.43.16.94"
          ]
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "CostCenter": "123459876",
        "Owner": "Contoso MAX Team"
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawmax002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    createMode: 'default'
    enablePurgeProtection: false
    enableSoftDelete: false
    sku: 'standard'
    softDeleteRetentionInDays: 7
  }
  logAnalyticsWorkspace: {
    dailyQuotaGb: 1
    dataRetention: 35
  }
  networkAcls: {
    ipRules: [
      '104.43.16.94'
    ]
  }
}
param enableDatabricks = true
param location = '<location>'
param tags = {
  CostCenter: '123459876'
  Owner: 'Contoso MAX Team'
}
```

</details>
<p>

### Example 3: _Minimal Deployment - fully private_

Isolated network deployment (Minimalistic) - fully private.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawminpriv002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        enablePurgeProtection: false
      }
    }
    enableDatabricks: false
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
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
      "value": "dpawminpriv002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "enablePurgeProtection": false
        }
      }
    },
    "enableDatabricks": {
      "value": false
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawminpriv002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    enablePurgeProtection: false
  }
}
param enableDatabricks = false
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
```

</details>
<p>

### Example 4: _Minimal Deployment - allowed IP address_

Isolated network deployment (Minimalistic) - allowed IP address.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawminpu002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        enablePurgeProtection: false
      }
      networkAcls: {
        ipRules: [
          '104.43.16.94'
        ]
      }
    }
    enableDatabricks: false
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
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
      "value": "dpawminpu002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "enablePurgeProtection": false
        },
        "networkAcls": {
          "ipRules": [
            "104.43.16.94"
          ]
        }
      }
    },
    "enableDatabricks": {
      "value": false
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawminpu002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    enablePurgeProtection: false
  }
  networkAcls: {
    ipRules: [
      '104.43.16.94'
    ]
  }
}
param enableDatabricks = false
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
```

</details>
<p>

### Example 5: _Use Case 1 - fully private_

Isolated network deployment - fully private.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawu1pr002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        enablePurgeProtection: false
      }
    }
    enableDatabricks: true
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
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
      "value": "dpawu1pr002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "enablePurgeProtection": false
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawu1pr002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    enablePurgeProtection: false
  }
}
param enableDatabricks = true
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
```

</details>
<p>

### Example 6: _Use Case 1 - allowed IP address_

Isolated network deployment - allowed IP address.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawu1pu002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        enablePurgeProtection: false
      }
      networkAcls: {
        ipRules: [
          '104.43.16.94'
        ]
      }
    }
    enableDatabricks: true
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
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
      "value": "dpawu1pu002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "enablePurgeProtection": false
        },
        "networkAcls": {
          "ipRules": [
            "104.43.16.94"
          ]
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawu1pu002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    enablePurgeProtection: false
  }
  networkAcls: {
    ipRules: [
      '104.43.16.94'
    ]
  }
}
param enableDatabricks = true
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
```

</details>
<p>

### Example 7: _Use Case 2 - fully private_

Deployment in an Existing, Enterprise-Specific Virtual Network - fully private.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawu2pr002'
    // Non-required parameters
    advancedOptions: {
      databricks: {
        subnetNameBackend: '<subnetNameBackend>'
        subnetNameFrontend: '<subnetNameFrontend>'
      }
      keyVault: {
        enablePurgeProtection: false
      }
      virtualNetwork: {
        subnetNamePrivateLink: '<subnetNamePrivateLink>'
      }
    }
    enableDatabricks: true
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
      "value": "dpawu2pr002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "databricks": {
          "subnetNameBackend": "<subnetNameBackend>",
          "subnetNameFrontend": "<subnetNameFrontend>"
        },
        "keyVault": {
          "enablePurgeProtection": false
        },
        "virtualNetwork": {
          "subnetNamePrivateLink": "<subnetNamePrivateLink>"
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawu2pr002'
// Non-required parameters
param advancedOptions = {
  databricks: {
    subnetNameBackend: '<subnetNameBackend>'
    subnetNameFrontend: '<subnetNameFrontend>'
  }
  keyVault: {
    enablePurgeProtection: false
  }
  virtualNetwork: {
    subnetNamePrivateLink: '<subnetNamePrivateLink>'
  }
}
param enableDatabricks = true
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 8: _Use Case 2 - allowed IP address_

Deployment in an Existing, Enterprise-Specific Virtual Network - allowed IP address.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawu2pu002'
    // Non-required parameters
    advancedOptions: {
      databricks: {
        subnetNameBackend: '<subnetNameBackend>'
        subnetNameFrontend: '<subnetNameFrontend>'
      }
      keyVault: {
        enablePurgeProtection: false
      }
      networkAcls: {
        ipRules: [
          '104.43.16.94'
        ]
      }
      virtualNetwork: {
        subnetNamePrivateLink: '<subnetNamePrivateLink>'
      }
    }
    enableDatabricks: true
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
      "value": "dpawu2pu002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "databricks": {
          "subnetNameBackend": "<subnetNameBackend>",
          "subnetNameFrontend": "<subnetNameFrontend>"
        },
        "keyVault": {
          "enablePurgeProtection": false
        },
        "networkAcls": {
          "ipRules": [
            "104.43.16.94"
          ]
        },
        "virtualNetwork": {
          "subnetNamePrivateLink": "<subnetNamePrivateLink>"
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawu2pu002'
// Non-required parameters
param advancedOptions = {
  databricks: {
    subnetNameBackend: '<subnetNameBackend>'
    subnetNameFrontend: '<subnetNameFrontend>'
  }
  keyVault: {
    enablePurgeProtection: false
  }
  networkAcls: {
    ipRules: [
      '104.43.16.94'
    ]
  }
  virtualNetwork: {
    subnetNamePrivateLink: '<subnetNamePrivateLink>'
  }
}
param enableDatabricks = true
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 9: _Use Case 3 - fully private_

Integration with existing core Infrastructure - fully private.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawu3pr002'
    // Non-required parameters
    advancedOptions: {
      databricks: {
        subnetNameBackend: '<subnetNameBackend>'
        subnetNameFrontend: '<subnetNameFrontend>'
      }
      keyVault: {
        enablePurgeProtection: false
      }
      virtualNetwork: {
        subnetNamePrivateLink: '<subnetNamePrivateLink>'
      }
    }
    enableDatabricks: true
    keyVaultResourceId: '<keyVaultResourceId>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
      "value": "dpawu3pr002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "databricks": {
          "subnetNameBackend": "<subnetNameBackend>",
          "subnetNameFrontend": "<subnetNameFrontend>"
        },
        "keyVault": {
          "enablePurgeProtection": false
        },
        "virtualNetwork": {
          "subnetNamePrivateLink": "<subnetNamePrivateLink>"
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "keyVaultResourceId": {
      "value": "<keyVaultResourceId>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawu3pr002'
// Non-required parameters
param advancedOptions = {
  databricks: {
    subnetNameBackend: '<subnetNameBackend>'
    subnetNameFrontend: '<subnetNameFrontend>'
  }
  keyVault: {
    enablePurgeProtection: false
  }
  virtualNetwork: {
    subnetNamePrivateLink: '<subnetNamePrivateLink>'
  }
}
param enableDatabricks = true
param keyVaultResourceId = '<keyVaultResourceId>'
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 10: _Use Case 3 - allowed IP address_

Integration with existing core Infrastructure - allowed IP address.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawu3p002'
    // Non-required parameters
    advancedOptions: {
      databricks: {
        subnetNameBackend: '<subnetNameBackend>'
        subnetNameFrontend: '<subnetNameFrontend>'
      }
      networkAcls: {
        ipRules: [
          '104.43.16.94'
        ]
      }
      virtualNetwork: {
        subnetNamePrivateLink: '<subnetNamePrivateLink>'
      }
    }
    enableDatabricks: true
    keyVaultResourceId: '<keyVaultResourceId>'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    tags: {
      CostCenter: '123-456-789'
      Owner: 'Contoso'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
      "value": "dpawu3p002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "databricks": {
          "subnetNameBackend": "<subnetNameBackend>",
          "subnetNameFrontend": "<subnetNameFrontend>"
        },
        "networkAcls": {
          "ipRules": [
            "104.43.16.94"
          ]
        },
        "virtualNetwork": {
          "subnetNamePrivateLink": "<subnetNamePrivateLink>"
        }
      }
    },
    "enableDatabricks": {
      "value": true
    },
    "keyVaultResourceId": {
      "value": "<keyVaultResourceId>"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "tags": {
      "value": {
        "CostCenter": "123-456-789",
        "Owner": "Contoso"
      }
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawu3p002'
// Non-required parameters
param advancedOptions = {
  databricks: {
    subnetNameBackend: '<subnetNameBackend>'
    subnetNameFrontend: '<subnetNameFrontend>'
  }
  networkAcls: {
    ipRules: [
      '104.43.16.94'
    ]
  }
  virtualNetwork: {
    subnetNamePrivateLink: '<subnetNamePrivateLink>'
  }
}
param enableDatabricks = true
param keyVaultResourceId = '<keyVaultResourceId>'
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param tags = {
  CostCenter: '123-456-789'
  Owner: 'Contoso'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 11: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'privateAnalyticalWorkspaceDeployment'
  params: {
    // Required parameters
    name: 'dpawwaf002'
    // Non-required parameters
    advancedOptions: {
      keyVault: {
        createMode: 'default'
        enablePurgeProtection: false
        enableSoftDelete: true
        sku: 'standard'
        softDeleteRetentionInDays: 90
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
      CostCenter: '123-456-789'
      'hidden-title': 'This is visible in the resource name'
      Owner: 'Contoso'
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
      "value": "dpawwaf002"
    },
    // Non-required parameters
    "advancedOptions": {
      "value": {
        "keyVault": {
          "createMode": "default",
          "enablePurgeProtection": false,
          "enableSoftDelete": true,
          "sku": "standard",
          "softDeleteRetentionInDays": 90
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
        "CostCenter": "123-456-789",
        "hidden-title": "This is visible in the resource name",
        "Owner": "Contoso"
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
using 'br/public:avm/ptn/data/private-analytical-workspace:<version>'

// Required parameters
param name = 'dpawwaf002'
// Non-required parameters
param advancedOptions = {
  keyVault: {
    createMode: 'default'
    enablePurgeProtection: false
    enableSoftDelete: true
    sku: 'standard'
    softDeleteRetentionInDays: 90
  }
  logAnalyticsWorkspace: {
    dailyQuotaGb: 1
    dataRetention: 35
  }
}
param enableDatabricks = true
param enableTelemetry = true
param location = '<location>'
param tags = {
  CostCenter: '123-456-789'
  'hidden-title': 'This is visible in the resource name'
  Owner: 'Contoso'
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
| [`advancedOptions`](#parameter-advancedoptions) | object | Additional options that can affect some components of the solution and how they are configured. |
| [`enableDatabricks`](#parameter-enabledatabricks) | bool | Enable/Disable Azure Databricks service within the solution. |
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

Additional options that can affect some components of the solution and how they are configured.

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
| [`subnetNameBackend`](#parameter-advancedoptionsdatabrickssubnetnamebackend) | string | The name of the existing backend Subnet for Azure Databricks within the Virtual Network in the parameter: 'virtualNetworkResourceId'. |
| [`subnetNameFrontend`](#parameter-advancedoptionsdatabrickssubnetnamefrontend) | string | The name of the existing frontend Subnet for Azure Databricks within the Virtual Network in the parameter: 'virtualNetworkResourceId'. |

### Parameter: `advancedOptions.databricks.subnetNameBackend`

The name of the existing backend Subnet for Azure Databricks within the Virtual Network in the parameter: 'virtualNetworkResourceId'.

- Required: No
- Type: string

### Parameter: `advancedOptions.databricks.subnetNameFrontend`

The name of the existing frontend Subnet for Azure Databricks within the Virtual Network in the parameter: 'virtualNetworkResourceId'.

- Required: No
- Type: string

### Parameter: `advancedOptions.keyVault`

This parameter allows you to specify additional settings for Azure Key Vault if the 'keyVaultResourceId' parameter is empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createMode`](#parameter-advancedoptionskeyvaultcreatemode) | string | The vault's create mode to indicate whether the vault need to be recovered or not. The default value is: 'default'. |
| [`enablePurgeProtection`](#parameter-advancedoptionskeyvaultenablepurgeprotection) | bool | Provide 'true' to enable Key Vault's purge protection feature. The default value is: 'true'. |
| [`enableSoftDelete`](#parameter-advancedoptionskeyvaultenablesoftdelete) | bool | Switch to enable/disable Key Vault's soft delete feature. The default value is: 'true'. |
| [`sku`](#parameter-advancedoptionskeyvaultsku) | string | Specifies the SKU for the vault. The default value is: 'premium'. |
| [`softDeleteRetentionInDays`](#parameter-advancedoptionskeyvaultsoftdeleteretentionindays) | int | Soft delete data retention days. It accepts >=7 and <=90. The default value is: '90'. |

### Parameter: `advancedOptions.keyVault.createMode`

The vault's create mode to indicate whether the vault need to be recovered or not. The default value is: 'default'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'default'
    'recover'
  ]
  ```

### Parameter: `advancedOptions.keyVault.enablePurgeProtection`

Provide 'true' to enable Key Vault's purge protection feature. The default value is: 'true'.

- Required: No
- Type: bool

### Parameter: `advancedOptions.keyVault.enableSoftDelete`

Switch to enable/disable Key Vault's soft delete feature. The default value is: 'true'.

- Required: No
- Type: bool

### Parameter: `advancedOptions.keyVault.sku`

Specifies the SKU for the vault. The default value is: 'premium'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'premium'
    'standard'
  ]
  ```

### Parameter: `advancedOptions.keyVault.softDeleteRetentionInDays`

Soft delete data retention days. It accepts >=7 and <=90. The default value is: '90'.

- Required: No
- Type: int

### Parameter: `advancedOptions.logAnalyticsWorkspace`

This parameter allows you to specify additional settings for Azure Log Analytics Workspace if the 'logAnalyticsWorkspaceResourceId' parameter is empty.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyQuotaGb`](#parameter-advancedoptionsloganalyticsworkspacedailyquotagb) | int | The workspace daily quota for ingestion. The default value is: '-1' (not limited). |
| [`dataRetention`](#parameter-advancedoptionsloganalyticsworkspacedataretention) | int | Number of days data will be retained for. The default value is: '365'. |

### Parameter: `advancedOptions.logAnalyticsWorkspace.dailyQuotaGb`

The workspace daily quota for ingestion. The default value is: '-1' (not limited).

- Required: No
- Type: int

### Parameter: `advancedOptions.logAnalyticsWorkspace.dataRetention`

Number of days data will be retained for. The default value is: '365'.

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

Enable/Disable Azure Databricks service within the solution.

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
| `br/public:avm/res/databricks/access-connector:0.3.0` | Remote reference |
| `br/public:avm/res/databricks/workspace:0.8.5` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.9.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.5.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.6.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.5.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.7.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |

## Notes

This pattern aims to speed up data science projects and create Azure environments
for data analysis in a secure and enterprise-ready way.

Data scientists should not worry about infrastructure details.<br>
Ideally, data scientists should only focus on the data analytics tools they need for the solution. For example Databricks, Machine learning, database, etc.<br>
Enterprise security, monitoring, secrets storage, databases, access over a private network should be built into the solution in a transparent way so cloud and security team can approve the whole solution easily.

One of the design goals of this pattern is to have all the services that are part of the solution
connected to one virtual network to make the traffic between services private (use of private endpoints).
A virtual network can be either created along with the solution or
an existing / pre-defined virtual network (Hub/Spoke model – spoke VNET made by network enterprise team) can be chosen.

The solution's services save diagnostics data to Azure Log Analytics Workspace,
either created along with the solution or an existing / pre-defined.
Secrets such as connection string or data source credentials should
go to secrets store securely. Analytical tools use secure credentials to access data sources.
Secrets can go to Azure Key Vault, either existing or new.

The solution will include at least a virtual network (either created or using VNET created
by enterprise network team), Azure Log Analytics workspace for diagnostics and monitoring
(either created or given by cloud team) and Azure Key Vault as secrets
store (either created or given by cloud team).

Every resource in the solution can be tagged and locked.
The owner role for every resource can be given with the ```solutionAdministrators.*``` parameter.</br>
All resources are named according to the provided input parameter ```name```.</br>
All resources gather diagnostic and monitoring data, which is then stored in either a newly created or an existing Log Analytics Workspace.

The solution may optionally include additional analytical services, for instance by enabling the ```enableDatabricks``` parameter.</br>
The parameter ```advancedOptions.*``` allows for finer customization of the solution.
Certain Azure services within the solution can be reached via a public endpoint (if preferred) and can also be limited using network access control lists by permitting only the public IP of the accessing client.

This solution invariably demands a Virtual network presence.
At the very least, it necessitates a single subnet to cater to private link endpoints.
The incorporation of additional optional services implies further prerequisites for the network,
such as subnets, their sizes, network security groups, NSG access control lists, (sometimes) private endpoints, DNS zones, etc.
For instance, activating the Azure Databricks service would automatically generate a virtual network and its essential components per established best practices.</br>
When an enterprise's virtual network is supplied by either the network or cloud team, it has to comply with the requirements of the services being activated.
It's crucial that Network Security Groups, Network Security Group Rules, DNS Zones and DNS forwarding, (sometimes) private endpoints, and domain zones for services like Key Vault and Azure Databricks, along with subnet delegations, are all set up correctly.
For example, refer to the documentation here: https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject#--virtual-network-requirements.

### Supported Use Cases

#### Use Case 1: Greenfield, isolated network deployment

This use case is fairly simple to provision while ensuring security.
Ideal for rapid problem-solving that requires an analytical workspace for swift development.
The solution will create all the required components such as Virtual Network, Monitoring, Key Vault, permissions, and analytical services.
All utilizing recommended practices.

Because of the isolated network configuration, public IP addresses of customers must be designated as authorized to access the environment through secure public endpoints.
The solution will only be accessible from predetermined public IP addresses. This use case may not be suitable for highly restrictive enterprises that have strict no public IP policies.</br>
The identity of the solution administrator or the managing group must be submitted to gain access and control over the solution.
There is no requirement to pre-establish a virtual network or any additional components.

##### Virtual Network

A Virtual Network will be created with all necessary components and will be established to accommodate the designated Azure Services.
This will include the creation of appropriate subnets, private links, and Network Security Groups.
Additionally, it will leverage Azure DNS along with Azure DNS zones for the configuration of private endpoints, which will be associated with the Virtual Network.

The assigned IP address range of a Virtual Network may conflict with that of an enterprise network. As a result, this virtual network should not be connected, or peered, with any enterprise network. In this use case, the virtual network is established as an isolated segment.

Since it's an isolated segment, in order to access client resources such as key vault and others, the client's public IP must be included in the allowed range within the ```advancedOptions.networkAcls.ipRules``` parameter.

For a dedicated virtual network to be provisioned for you (this use case), the Virtual Network ```virtualNetworkResourceId``` parameter needs to remain unfilled.

<a name="monitoring-uc1"></a>
##### Monitoring of the Solution

If the parameter ```logAnalyticsWorkspaceResourceId``` is left unspecified or set to ```null```, a new Azure Log Analytics Workspace will be created as part of the solution. The diagnostic settings for most services within the solution will be configured to channel into this newly created Azure Log Analytics Workspace.</br>
Additional creation configurations for the Azure Log Analytics Workspace are available under the parameter ```advancedOptions.logAnalyticsWorkspace.*```.</br>
The ```logAnalyticsWorkspaceResourceId``` parameter may be configured to use an existing Azure Log Analytics Workspace, which is beneficial for enterprises that prefer to centralize their diagnostic data.</br>

<a name="kv-uc1"></a>
##### Storing Secrets - Key Vault

If the parameter ```keyVaultResourceId``` is left unspecified or set to ```null```, a new Azure Key Vault will be created as part of the solution.</br>
Additional creation configurations for the Azure Key Vault are available under the parameter ```advancedOptions.keyVault.*```.</br>
As part of the solution, a private endpoint and a DNS Key Vault Zone are created. To handle secrets through the Azure Portal, Public Access must be provided for the given public IP within the parameter ```advancedOptions.networkAcls.ipRules```.</br>
For the handling of secrets, users need to have privileged roles. Those listed in the ```solutionAdministrators.*``` parameter will receive 'Key Vault Administrator' privileges specifically for Azure Key Vaults that are newly created.</br>

<a name="sol-admin-uc1"></a>
##### Solution Administrators

In order to grant administrative rights for the newly created services that have been added to the solution, you should utilize the parameter ```solutionAdministrators.*```. You can designate User or Entra ID Groups for this purpose.</br>
The specified identities will be granted ownership of the solution, enabling them to delegate permissions as necessary. Additionally, they will obtain 'Key Vault Administrator' rights, which apply solely to the Azure Key Vaults that have been created as part of the solution.</br>
It's essential to designate an individual as the Solution Administrator to utilize the solution effectively.</br>

<a name="adb-uc1"></a>
##### Analytical Service - Azure Databricks

If the parameter ```enableDatabricks``` is set to ```true```, a new Azure Databricks instance will be created as part of the solution.</br>
Additional creation configurations for the Azure Databricks are available under the parameter ```advancedOptions.databricks.*```.</br>
As part of the solution, two subnets with delegations, two private endpoints, network security groups and a Azure Databricks Zone are created.</br>
To access Azure Databricks integrated into the isolated Virtual Network, Public Access must be provided for the given public IP within the parameter ```advancedOptions.networkAcls.ipRules```.</br>
Additional manual setup is required to restrict public access for different clients. Refer to this guide for more information: <https://learn.microsoft.com/en-us/azure/databricks/security/network/front-end/ip-access-list#ip-access-lists-overview></br>

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
        principalType: 'Group'            // Group and/or User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the isolated solution (enables public endpoints for some services)
    }
    tags: { Owner: 'Contoso', 'Cost Center': '2345-324' }
  }
}
```

<a name="uc2"></a>
#### Use Case 2: Brownfield, Implementation in an Existing, Enterprise-Specific Virtual Network for a New Deployment

This use case seeks to align with the expectations of enterprise infrastructure.</br>
For instance, certain companies prohibit the use of public IP addresses in their solutions.</br>
The solution will provision certain elements such as Monitoring, Key Vault, permissions, and analytics services.</br>
However, additional configurations may be required before and after deployment.</br>
Choosing this option allows you to tailor the infrastructure, but typically requires customized services from the cloud, security, and network teams, leading to less agility and project delays.</br>
This case presents a balance between an extended deployment timeline and compliance with corporate policies and infrastructure requirements.</br>

Complexity could be notably high on the Virtual Network side.</br>
Anticipate the need for virtual network peering arrangements using a hub and spoke design, route tables, configuration of DNS, private zones, (sometimes) private endpoints, DNS forwarding for private links, virtual network delegations, and so on.</br>
Additionally, various analytics services may each have distinct virtual network requirements.

This use case does not require any public IP addresses to be exposed.</br>
All services can utilize private Enterprise Network access exclusively.

The identity of the solution administrator or the managing group must be submitted to gain access and control over the solution.

<a name="vnet-uc2"></a>
##### Virtual Network

The enterprise network team needs to set up a virtual network with necessary components and settings in advance. This must be a spoke-type network connected to the central hub network with central Enterprise Firewall and connectivity to enterprise network - following the hub and spoke architecture.

The Customer/Network team must set up a unique virtual network without overlapping the corporate address space, designate the right-sized subnets, manage network delegations, route tables, set up corporate DNS at the Virtual Network level, enroll private links in enterprise-grade private DNS zones with forwarding for resolving private links, and create specific Network Security Groups with tailored rules for certain services enabled in the solution.

Creating at least a /26 subnet is essential for hosting private endpoints. As additional analytical services are activated, there will generally be a need for a greater number of subnets of varying sizes.
The services within the solution vary in their requirements. For instance, consider the needs of Azure Databricks:

- https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject#network-security-group-rules-for-workspaces
- https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/udr

Review the necessary subnets, subnet sizing, routing, DNS settings, network security groups, delegations for 'Microsoft.Databricks/workspaces', and private endpoints.

If only full private access is required, the ```advancedOptions.networkAcls.ipRules``` parameter should not be configured.

When utilizing a pre-defined virtual network provided by the Enterprise Network team (this use case), the ```virtualNetworkResourceId``` parameter should be set to reference the existing Virtual Network.

##### Monitoring of the Solution

The rules outlined here: [Monitoring of the Solution for Use Case 1](#monitoring-uc1) apply to this use case as well.

<a name="kv-uc2"></a>
##### Storing Secrets - Key Vault

If the parameter ```keyVaultResourceId``` is left unspecified or set to ```null```, a new Azure Key Vault will be created as part of the solution.</br>
Additional creation configurations for the Azure Key Vault are available under the parameter ```advancedOptions.keyVault.*```.</br>

This use case resembles use case [Storing Secrets - Key Vault for Use Case 1](#kv-uc1).
The difference is that the customer usually needs full private access in own virtual network and must configure (sometimes) private endpoints for the created Azure Key Vault.
This includes registering DNS records pointing to the private IP address under the private endpoint for Network Interface Card.
Additionally, the customer must create or use an existing Azure Key Vault private DNS zone to support private endpoint resolution
and integrate it with enterprise DNS and DNS forwarding mechanisms.

To allow both private and public access, you can set the ```advancedOptions.networkAcls.ipRules``` parameter
to include the client's public IP (enables public endpoints for some services).

For the handling of secrets, users need to have privileged roles.
Those listed in the ```solutionAdministrators.*``` parameter will receive 'Key Vault Administrator'
privileges specifically for Azure Key Vaults that are newly created.</br>

##### Solution Administrators

The rules outlined here: [Solution Administrators for Use Case 1](#sol-admin-uc1) apply to this use case as well.

<a name="adb-uc2"></a>
##### Analytical Service - Azure Databricks

If the parameter ```enableDatabricks``` is set to ```true```, a new Azure Databricks instance will be created as part of the solution.</br>
Additional creation configurations for the Azure Databricks are available under the parameter ```advancedOptions.databricks.*```.</br>

This use case resembles use case [Analytical Service - Azure Databricks for Use Case 1](#adb-uc1).
The difference is that the customer usually needs full private access in own virtual network and must configure (sometimes) private endpoints for the created Azure Databricks.
This includes registering DNS records pointing to the private IP address under the private endpoint for Network Interface Card.
Additionally, the customer must create or use an existing Azure Databricks private DNS zone to support private endpoint resolution
and integrate it with enterprise DNS and DNS forwarding mechanisms.

This use case usually involves integrating with a private virtual network. Refer to: [Virtual Network for Use Case 2](#vnet-uc2).
The network team needs to set up the virtual network to include a private links subnet and two additional subnets delegated for Azure Databricks.
Then, create (sometimes) two private endpoints, network security groups, and an Azure Databricks Zone.

Refer to this guide for more information: <https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/vnet-inject>
and this: <https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link></br>

To allow both private and public access, you can set the ```advancedOptions.networkAcls.ipRules``` parameter
to include the client's public IP (enables public endpoints for some services).
If you allow public access, additional manual setup is required to restrict public access for different clients.
Refer to this guide for more information: <https://learn.microsoft.com/en-us/azure/databricks/security/network/front-end/ip-access-list#ip-access-lists-overview></br>

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'UC2'
  params: {
    // Required parameters
    name: 'pawuc2'
    // Non-required parameters
    virtualNetworkResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.Network/virtualNetworks/{NAME-OF-VNET}'
    logAnalyticsWorkspaceResourceId: null // null means new Log Analytical Workspace will be created
    keyVaultResourceId: null              // null means new Azure key Vault will be created
    enableDatabricks: true                // Part of the solution will be new instance of the Azure Databricks
    solutionAdministrators: [
      {
        principalId: <EntraGroupId>       // Specified group will have enough permissions to manage the solution
        principalType: 'Group'            // Group and/or User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the solution (enables public endpoints for some services)
    }
    tags: { Owner: 'Contoso', 'Cost Center': '2345-324' }
  }
}
```

#### Use Case 3: Integration with existing core Infrastructure

This use case aims to meet the specific needs of enterprise infrastructure, similar to use case
[Use Case 2: Brownfield, Implementation in an Existing, Enterprise-Specific Virtual Network for a New Deployment](#uc2) but more advanced.</br>
It integrates with a pre-provisioned virtual network for private traffic and pre-provisioned Azure Key Vault and central Azure Log Analytics workspace.</br>
This allows the cloud and network teams to provide core components, and the solution linking them together.</br>

Cloud and network teams remain responsible for configuring prerequisites and providing elements like private endpoints (sometimes), private endpoint zones, DNS resolution, and access permissions.</br>
Find further information here: [Use Case 2: Brownfield, Implementation in an Existing, Enterprise-Specific Virtual Network for a New Deployment](#uc2)</br>

This use case does not require any public IP addresses to be exposed,
but you can enable public access with the ```advancedOptions.networkAcls.ipRules``` parameter if necessary.</br>
All services can utilize private Enterprise Network access exclusively.

##### Virtual Network

The rules outlined here: [Virtual Network for Use Case 2](#vnet-uc2) apply to this use case as well.

##### Monitoring of the Solution

The rules outlined here: [Monitoring of the Solution for Use Case 1](#monitoring-uc1) apply to this use case as well.

The ```logAnalyticsWorkspaceResourceId``` parameter should be set to use an existing Azure Log Analytics Workspace.</br>

The team responsible for resource management must set up Azure Log Analytics Workspace access for the necessary end users.</br>

##### Storing Secrets - Key Vault

The rules outlined here: [Storing Secrets - Key Vault for Use Case 2](#kv-uc2) apply to this use case as well.

The ```keyVaultResourceId``` parameter should be set to use an existing Azure Key Vault.</br>

The team responsible for resource management must set up Azure Key Vault access for the necessary end users.</br>

##### Solution Administrators

The rules outlined here: [Solution Administrators for Use Case 1](#sol-admin-uc1) apply to this use case as well.</br>
However, role assignments will apply exclusively to resources generated within this use case, excluding those pre-created by the network and cloud team.</br>

##### Analytical Service - Azure Databricks

The rules outlined here: [Analytical Service - Azure Databricks for Use Case 2](#adb-uc2) apply to this use case as well.

```bicep
module privateAnalyticalWorkspace 'br/public:avm/ptn/data/private-analytical-workspace:<version>' = {
  name: 'UC3'
  params: {
    // Required parameters
    name: 'pawuc3'
    // Non-required parameters
    virtualNetworkResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.Network/virtualNetworks/{NAME-OF-VNET}'
    logAnalyticsWorkspaceResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.OperationalInsights/workspaces/{NAME-OF-LOG}'
    keyVaultResourceId: '/subscriptions/{SUBSCRIPTION-ID}/resourceGroups/{NAME-OF-RG}/providers/Microsoft.KeyVault/vaults/{NAME-OF-KV}'
    enableDatabricks: true                // Part of the solution will be new instance of the Azure Databricks
    solutionAdministrators: [
      {
        principalId: <EntraGroupId>       // Specified group will have enough permissions to manage the solution
        principalType: 'Group'            // Group and/or User type can be specified
      }
    ]
    advancedOptions: {
      networkAcls: { ipRules: [<AllowedPublicIPAddress>] } // Which public IP addresses of the end users can access the solution (enables public endpoints for some services)
    }
    tags: { Owner: 'Contoso', 'Cost Center': '2345-324' }
  }
}
```

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
