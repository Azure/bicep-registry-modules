# CI CD Agents and Runners `[DevOps/CicdAgentsAndRunners]`

This module deploys self-hosted agents and runners for Azure DevOps and GitHub on Azure Container Instances and/or Azure Container Apps.

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
| `Microsoft.App/jobs` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-03-01/jobs) |
| `Microsoft.App/managedEnvironments` | [2023-11-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-11-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/storages` | [2023-11-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2023-11-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerInstance/containerGroups` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2023-05-01/containerGroups) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/taskRuns` | [2019-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2019-06-01-preview/registries/taskRuns) |
| `Microsoft.ContainerRegistry/registries/tasks` | [2019-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2019-06-01-preview/registries/tasks) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/webhooks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |
| `Microsoft.Network/natGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/natGateways) |
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
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/publicIPPrefixes` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPPrefixes) |
| `Microsoft.Network/virtualNetworks` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.OperationalInsights/workspaces` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>`.

- [Using only defaults for Azure DevOps self-hosted agents using both Azure Container Instances and Azure Container Apps.](#example-1-using-only-defaults-for-azure-devops-self-hosted-agents-using-both-azure-container-instances-and-azure-container-apps)
- [Using only defaults for Azure DevOps self-hosted agents using Azure Container Instances.](#example-2-using-only-defaults-for-azure-devops-self-hosted-agents-using-azure-container-instances)
- [Using only defaults for GitHub self-hosted runners using Azure Container Apps.](#example-3-using-only-defaults-for-github-self-hosted-runners-using-azure-container-apps)
- [Using large parameter set for Azure DevOps self-hosted agents using Azure Container Apps.](#example-4-using-large-parameter-set-for-azure-devops-self-hosted-agents-using-azure-container-apps)
- [Using large parameter set for GitHub self-hosted runners using Azure Container Instances.](#example-5-using-large-parameter-set-for-github-self-hosted-runners-using-azure-container-instances)
- [Using only defaults for Azure DevOps self-hosted agents using Private networking in an existing vnet.](#example-6-using-only-defaults-for-azure-devops-self-hosted-agents-using-private-networking-in-an-existing-vnet)
- [Using only defaults for GitHub self-hosted runners using Private networking in an existing vnet.](#example-7-using-only-defaults-for-github-self-hosted-runners-using-private-networking-in-an-existing-vnet)
- [Using only defaults for GitHub self-hosted runners using Private networking.](#example-8-using-only-defaults-for-github-self-hosted-runners-using-private-networking)

### Example 1: _Using only defaults for Azure DevOps self-hosted agents using both Azure Container Instances and Azure Container Apps._

This instance deploys the module with the minimum set of required parameters for Azure DevOps self-hosted agents in Azure Container Instances and Azure Container Apps.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-app'
      'azure-container-instance'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aca'
    }
    selfHostedConfig: {
      agentsPoolName: 'agents-pool'
      devOpsOrganization: 'azureDevOpsOrganization'
      personalAccessToken: '<personalAccessToken>'
      selfHostedType: 'azuredevops'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: false
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
    "computeTypes": {
      "value": [
        "azure-container-app",
        "azure-container-instance"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "addressSpace": "10.0.0.0/16",
        "networkType": "createNew",
        "virtualNetworkName": "vnet-aca"
      }
    },
    "selfHostedConfig": {
      "value": {
        "agentsPoolName": "agents-pool",
        "devOpsOrganization": "azureDevOpsOrganization",
        "personalAccessToken": "<personalAccessToken>",
        "selfHostedType": "azuredevops"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": false
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults for Azure DevOps self-hosted agents using Azure Container Instances._

This instance deploys the module with the minimum set of required parameters for Azure DevOps self-hosted agents in Azure Container Instances.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-instance'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aci'
    }
    selfHostedConfig: {
      agentsPoolName: 'aci-pool'
      devOpsOrganization: 'azureDevOpsOrganization'
      personalAccessToken: '<personalAccessToken>'
      selfHostedType: 'azuredevops'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: false
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
    "computeTypes": {
      "value": [
        "azure-container-instance"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "addressSpace": "10.0.0.0/16",
        "networkType": "createNew",
        "virtualNetworkName": "vnet-aci"
      }
    },
    "selfHostedConfig": {
      "value": {
        "agentsPoolName": "aci-pool",
        "devOpsOrganization": "azureDevOpsOrganization",
        "personalAccessToken": "<personalAccessToken>",
        "selfHostedType": "azuredevops"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": false
    }
  }
}
```

</details>
<p>

### Example 3: _Using only defaults for GitHub self-hosted runners using Azure Container Apps._

This instance deploys the module with the minimum set of required parameters for GitHub self-hosted runners in Azure Container Apps.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-app'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aca'
    }
    selfHostedConfig: {
      githubOrganization: 'githHubOrganization'
      githubRepository: 'dummyRepo'
      personalAccessToken: '<personalAccessToken>'
      selfHostedType: 'github'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: false
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
    "computeTypes": {
      "value": [
        "azure-container-app"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "addressSpace": "10.0.0.0/16",
        "networkType": "createNew",
        "virtualNetworkName": "vnet-aca"
      }
    },
    "selfHostedConfig": {
      "value": {
        "githubOrganization": "githHubOrganization",
        "githubRepository": "dummyRepo",
        "personalAccessToken": "<personalAccessToken>",
        "selfHostedType": "github"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": false
    }
  }
}
```

</details>
<p>

### Example 4: _Using large parameter set for Azure DevOps self-hosted agents using Azure Container Apps._

This instance deploys the module with most of its features enabled for Azure DevOps self-hosted agents using Azure Container Apps.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-app'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      containerAppSubnetAddressPrefix: '10.0.1.0/24'
      containerAppSubnetName: 'acaSubnet'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aca'
    }
    selfHostedConfig: {
      agentNamePrefix: '<agentNamePrefix>'
      agentsPoolName: 'aca-pool'
      azureContainerAppTarget: {
        resources: {
          cpu: '1'
          memory: '2Gi'
        }
      }
      devOpsOrganization: 'azureDevOpsOrganization'
      personalAccessToken: '<personalAccessToken>'
      placeHolderAgentName: 'acaPlaceHolderAgent'
      selfHostedType: 'azuredevops'
      targetPipelinesQueueLength: '1'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: false
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
    "computeTypes": {
      "value": [
        "azure-container-app"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "addressSpace": "10.0.0.0/16",
        "containerAppSubnetAddressPrefix": "10.0.1.0/24",
        "containerAppSubnetName": "acaSubnet",
        "networkType": "createNew",
        "virtualNetworkName": "vnet-aca"
      }
    },
    "selfHostedConfig": {
      "value": {
        "agentNamePrefix": "<agentNamePrefix>",
        "agentsPoolName": "aca-pool",
        "azureContainerAppTarget": {
          "resources": {
            "cpu": "1",
            "memory": "2Gi"
          }
        },
        "devOpsOrganization": "azureDevOpsOrganization",
        "personalAccessToken": "<personalAccessToken>",
        "placeHolderAgentName": "acaPlaceHolderAgent",
        "selfHostedType": "azuredevops",
        "targetPipelinesQueueLength": "1"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": false
    }
  }
}
```

</details>
<p>

### Example 5: _Using large parameter set for GitHub self-hosted runners using Azure Container Instances._

This instance deploys the module with most of its features enabled for GitHub self-hosted runners using Azure Container Instances.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-instance'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      containerInstanceSubnetAddressPrefix: '10.0.1.0/24'
      containerInstanceSubnetName: 'aci-subnet'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aci'
    }
    selfHostedConfig: {
      azureContainerInstanceTarget: {
        cpu: 1
        memoryInGB: 2
        numberOfInstances: 3
        sku: 'Standard'
      }
      ephemeral: true
      githubOrganization: 'githHubOrganization'
      githubRepository: 'dummyRepo'
      personalAccessToken: '<personalAccessToken>'
      runnerNamePrefix: '<runnerNamePrefix>'
      runnerScope: 'repo'
      selfHostedType: 'github'
      targetWorkflowQueueLength: '1'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: false
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
    "computeTypes": {
      "value": [
        "azure-container-instance"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "addressSpace": "10.0.0.0/16",
        "containerInstanceSubnetAddressPrefix": "10.0.1.0/24",
        "containerInstanceSubnetName": "aci-subnet",
        "networkType": "createNew",
        "virtualNetworkName": "vnet-aci"
      }
    },
    "selfHostedConfig": {
      "value": {
        "azureContainerInstanceTarget": {
          "cpu": 1,
          "memoryInGB": 2,
          "numberOfInstances": 3,
          "sku": "Standard"
        },
        "ephemeral": true,
        "githubOrganization": "githHubOrganization",
        "githubRepository": "dummyRepo",
        "personalAccessToken": "<personalAccessToken>",
        "runnerNamePrefix": "<runnerNamePrefix>",
        "runnerScope": "repo",
        "selfHostedType": "github",
        "targetWorkflowQueueLength": "1"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": false
    }
  }
}
```

</details>
<p>

### Example 6: _Using only defaults for Azure DevOps self-hosted agents using Private networking in an existing vnet._

This instance deploys the module with the minimum set of required parameters Azure DevOps self-hosted agents using Private networking in Azure Container Instances in an existing vnet.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-instance'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      computeNetworking: {
        computeNetworkType: 'azureContainerInstance'
        containerInstanceSubnetName: 'aci-subnet'
      }
      containerRegistryPrivateDnsZoneResourceId: '<containerRegistryPrivateDnsZoneResourceId>'
      containerRegistryPrivateEndpointSubnetName: 'acr-subnet'
      natGatewayPublicIpAddressResourceId: '<natGatewayPublicIpAddressResourceId>'
      natGatewayResourceId: '<natGatewayResourceId>'
      networkType: 'useExisting'
      virtualNetworkResourceId: '<virtualNetworkResourceId>'
    }
    selfHostedConfig: {
      agentNamePrefix: '<agentNamePrefix>'
      agentsPoolName: 'aci-pool'
      azureContainerInstanceTarget: {
        numberOfInstances: 2
      }
      devOpsOrganization: 'azureDevOpsOrganization'
      personalAccessToken: '<personalAccessToken>'
      selfHostedType: 'azuredevops'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: true
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
    "computeTypes": {
      "value": [
        "azure-container-instance"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "computeNetworking": {
          "computeNetworkType": "azureContainerInstance",
          "containerInstanceSubnetName": "aci-subnet"
        },
        "containerRegistryPrivateDnsZoneResourceId": "<containerRegistryPrivateDnsZoneResourceId>",
        "containerRegistryPrivateEndpointSubnetName": "acr-subnet",
        "natGatewayPublicIpAddressResourceId": "<natGatewayPublicIpAddressResourceId>",
        "natGatewayResourceId": "<natGatewayResourceId>",
        "networkType": "useExisting",
        "virtualNetworkResourceId": "<virtualNetworkResourceId>"
      }
    },
    "selfHostedConfig": {
      "value": {
        "agentNamePrefix": "<agentNamePrefix>",
        "agentsPoolName": "aci-pool",
        "azureContainerInstanceTarget": {
          "numberOfInstances": 2
        },
        "devOpsOrganization": "azureDevOpsOrganization",
        "personalAccessToken": "<personalAccessToken>",
        "selfHostedType": "azuredevops"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 7: _Using only defaults for GitHub self-hosted runners using Private networking in an existing vnet._

This instance deploys the module with the minimum set of required parameters GitHub self-hosted runners using Private networking in Azure Container Apps in an existing vnet.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-instance'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      computeNetworking: {
        computeNetworkType: 'azureContainerApp'
        containerAppDeploymentScriptSubnetName: 'aca-ds-subnet'
        containerAppSubnetName: 'aca-subnet'
        containerInstanceSubnetName: 'aci-subnet'
        deploymentScriptPrivateDnsZoneResourceId: '<deploymentScriptPrivateDnsZoneResourceId>'
      }
      containerRegistryPrivateDnsZoneResourceId: '<containerRegistryPrivateDnsZoneResourceId>'
      containerRegistryPrivateEndpointSubnetName: 'acr-subnet'
      natGatewayPublicIpAddressResourceId: '<natGatewayPublicIpAddressResourceId>'
      natGatewayResourceId: '<natGatewayResourceId>'
      networkType: 'useExisting'
      virtualNetworkResourceId: '<virtualNetworkResourceId>'
    }
    selfHostedConfig: {
      githubOrganization: 'githHubOrganization'
      githubRepository: 'dummyRepo'
      personalAccessToken: '<personalAccessToken>'
      selfHostedType: 'github'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: true
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
    "computeTypes": {
      "value": [
        "azure-container-instance"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "computeNetworking": {
          "computeNetworkType": "azureContainerApp",
          "containerAppDeploymentScriptSubnetName": "aca-ds-subnet",
          "containerAppSubnetName": "aca-subnet",
          "containerInstanceSubnetName": "aci-subnet",
          "deploymentScriptPrivateDnsZoneResourceId": "<deploymentScriptPrivateDnsZoneResourceId>"
        },
        "containerRegistryPrivateDnsZoneResourceId": "<containerRegistryPrivateDnsZoneResourceId>",
        "containerRegistryPrivateEndpointSubnetName": "acr-subnet",
        "natGatewayPublicIpAddressResourceId": "<natGatewayPublicIpAddressResourceId>",
        "natGatewayResourceId": "<natGatewayResourceId>",
        "networkType": "useExisting",
        "virtualNetworkResourceId": "<virtualNetworkResourceId>"
      }
    },
    "selfHostedConfig": {
      "value": {
        "githubOrganization": "githHubOrganization",
        "githubRepository": "dummyRepo",
        "personalAccessToken": "<personalAccessToken>",
        "selfHostedType": "github"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
      "value": true
    }
  }
}
```

</details>
<p>

### Example 8: _Using only defaults for GitHub self-hosted runners using Private networking._

This instance deploys the module with the minimum set of required parameters GitHub self-hosted runners using Private networking in Azure Container Instances.


<details>

<summary>via Bicep module</summary>

```bicep
module cicdAgentsAndRunners 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>' = {
  name: 'cicdAgentsAndRunnersDeployment'
  params: {
    // Required parameters
    computeTypes: [
      'azure-container-instance'
    ]
    namingPrefix: '<namingPrefix>'
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet-aci'
    }
    selfHostedConfig: {
      githubOrganization: 'githHubOrganization'
      githubRepository: 'dummyRepo'
      personalAccessToken: '<personalAccessToken>'
      selfHostedType: 'github'
    }
    // Non-required parameters
    location: '<location>'
    privateNetworking: true
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
    "computeTypes": {
      "value": [
        "azure-container-instance"
      ]
    },
    "namingPrefix": {
      "value": "<namingPrefix>"
    },
    "networkingConfiguration": {
      "value": {
        "addressSpace": "10.0.0.0/16",
        "networkType": "createNew",
        "virtualNetworkName": "vnet-aci"
      }
    },
    "selfHostedConfig": {
      "value": {
        "githubOrganization": "githHubOrganization",
        "githubRepository": "dummyRepo",
        "personalAccessToken": "<personalAccessToken>",
        "selfHostedType": "github"
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "privateNetworking": {
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
| [`computeTypes`](#parameter-computetypes) | array | The compute target for the private runners. |
| [`namingPrefix`](#parameter-namingprefix) | string | Naming prefix to be used with naming the deployed resources. |
| [`networkingConfiguration`](#parameter-networkingconfiguration) | object | The networking configuration. |
| [`selfHostedConfig`](#parameter-selfhostedconfig) | object | The self-hosted runner configuration. This can be either GitHub or Azure DevOps. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`privateNetworking`](#parameter-privatenetworking) | bool | Whether to use private or public networking for the Azure Container Registry. |

### Parameter: `computeTypes`

The compute target for the private runners.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'azure-container-app'
    'azure-container-instance'
  ]
  ```

### Parameter: `namingPrefix`

Naming prefix to be used with naming the deployed resources.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration`

The networking configuration.

- Required: Yes
- Type: object

### Parameter: `selfHostedConfig`

The self-hosted runner configuration. This can be either GitHub or Azure DevOps.

- Required: Yes
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `privateNetworking`

Whether to use private or public networking for the Azure Container Registry.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the module was deployed to. |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.1` | Remote reference |
| `br/public:avm/res/app/job:0.4.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.6.2` | Remote reference |
| `br/public:avm/res/container-instance/container-group:0.2.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.4.0` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.3.0` | Remote reference |
| `br/public:avm/res/network/nat-gateway:1.1.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.5.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.5.1` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.2.0` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.5.0` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.3.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.13.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
