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
| `Microsoft.App/managedEnvironments` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/certificates` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates) |
| `Microsoft.App/managedEnvironments/storages` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ContainerInstance/containerGroups` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerInstance/2023-05-01/containerGroups) |
| `Microsoft.ContainerRegistry/registries` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries) |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/cacheRules) |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-11-01-preview/registries/credentialSets) |
| `Microsoft.ContainerRegistry/registries/replications` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/replications) |
| `Microsoft.ContainerRegistry/registries/scopeMaps` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/scopeMaps) |
| `Microsoft.ContainerRegistry/registries/taskRuns` | [2019-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2019-06-01-preview/registries/taskRuns) |
| `Microsoft.ContainerRegistry/registries/tasks` | [2019-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2019-06-01-preview/registries/tasks) |
| `Microsoft.ContainerRegistry/registries/webhooks` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2023-06-01-preview/registries/webhooks) |
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
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses) |
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/publicIPPrefixes` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPPrefixes) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.OperationalInsights/workspaces` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces) |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataExports) |
| `Microsoft.OperationalInsights/workspaces/dataSources` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/dataSources) |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedServices) |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/linkedStorageAccounts) |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/savedSearches) |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/storageInsightConfigs) |
| `Microsoft.OperationalInsights/workspaces/tables` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2023-09-01/workspaces/tables) |
| `Microsoft.OperationsManagement/solutions` | [2015-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.SecurityInsights/onboardingStates` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2024-03-01/onboardingStates) |
| `Microsoft.Storage/storageAccounts` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2023-04-01/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>`.

- [Using only defaults for Azure DevOps self-hosted agents using both Azure Container Instances and Azure Container Apps.](#example-1-using-only-defaults-for-azure-devops-self-hosted-agents-using-both-azure-container-instances-and-azure-container-apps)
- [Using only defaults for Azure DevOps self-hosted agents using Azure Container Instances.](#example-2-using-only-defaults-for-azure-devops-self-hosted-agents-using-azure-container-instances)
- [Using only defaults for GitHub self-hosted runners using Azure Container Apps.](#example-3-using-only-defaults-for-github-self-hosted-runners-using-azure-container-apps)
- [Using large parameter set for Azure DevOps self-hosted agents using Azure Container Apps.](#example-4-using-large-parameter-set-for-azure-devops-self-hosted-agents-using-azure-container-apps)
- [Using large parameter set for GitHub self-hosted runners using Azure Container Instances.](#example-5-using-large-parameter-set-for-github-self-hosted-runners-using-azure-container-instances)
- [Deploys GitHub self-hosted runners using Azure Container Apps for a GitHub organization scope.](#example-6-deploys-github-self-hosted-runners-using-azure-container-apps-for-a-github-organization-scope)
- [Using only defaults for Azure DevOps self-hosted agents using Private networking in an existing vnet.](#example-7-using-only-defaults-for-azure-devops-self-hosted-agents-using-private-networking-in-an-existing-vnet)
- [Using only defaults for GitHub self-hosted runners using Private networking in an existing vnet.](#example-8-using-only-defaults-for-github-self-hosted-runners-using-private-networking-in-an-existing-vnet)
- [Using only defaults for GitHub self-hosted runners using Private networking.](#example-9-using-only-defaults-for-github-self-hosted-runners-using-private-networking)

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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-app'
  'azure-container-instance'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aca'
}
param selfHostedConfig = {
  agentsPoolName: 'agents-pool'
  devOpsOrganization: 'azureDevOpsOrganization'
  personalAccessToken: '<personalAccessToken>'
  selfHostedType: 'azuredevops'
}
// Non-required parameters
param location = '<location>'
param privateNetworking = false
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-instance'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aci'
}
param selfHostedConfig = {
  agentsPoolName: 'aci-pool'
  devOpsOrganization: 'azureDevOpsOrganization'
  personalAccessToken: '<personalAccessToken>'
  selfHostedType: 'azuredevops'
}
// Non-required parameters
param location = '<location>'
param privateNetworking = false
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-app'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aca'
}
param selfHostedConfig = {
  githubOrganization: 'githHubOrganization'
  githubRepository: 'dummyRepo'
  personalAccessToken: '<personalAccessToken>'
  selfHostedType: 'github'
}
// Non-required parameters
param location = '<location>'
param privateNetworking = false
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-app'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  containerAppSubnetAddressPrefix: '10.0.1.0/24'
  containerAppSubnetName: 'acaSubnet'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aca'
}
param selfHostedConfig = {
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
param location = '<location>'
param privateNetworking = false
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-instance'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  containerInstanceSubnetAddressPrefix: '10.0.1.0/24'
  containerInstanceSubnetName: 'aci-subnet'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aci'
}
param selfHostedConfig = {
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
param location = '<location>'
param privateNetworking = false
```

</details>
<p>

### Example 6: _Deploys GitHub self-hosted runners using Azure Container Apps for a GitHub organization scope._

This instance deploys the module with the minimum set of required parameters for GitHub self-hosted runners in Azure Container Apps for a GitHub organization scope.


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
      personalAccessToken: '<personalAccessToken>'
      runnerScope: 'org'
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

<summary>via JSON parameters file</summary>

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
        "personalAccessToken": "<personalAccessToken>",
        "runnerScope": "org",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-app'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aca'
}
param selfHostedConfig = {
  githubOrganization: 'githHubOrganization'
  personalAccessToken: '<personalAccessToken>'
  runnerScope: 'org'
  selfHostedType: 'github'
}
// Non-required parameters
param location = '<location>'
param privateNetworking = false
```

</details>
<p>

### Example 7: _Using only defaults for Azure DevOps self-hosted agents using Private networking in an existing vnet._

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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-instance'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
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
param selfHostedConfig = {
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
param location = '<location>'
param privateNetworking = true
```

</details>
<p>

### Example 8: _Using only defaults for GitHub self-hosted runners using Private networking in an existing vnet._

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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-instance'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
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
param selfHostedConfig = {
  githubOrganization: 'githHubOrganization'
  githubRepository: 'dummyRepo'
  personalAccessToken: '<personalAccessToken>'
  selfHostedType: 'github'
}
// Non-required parameters
param location = '<location>'
param privateNetworking = true
```

</details>
<p>

### Example 9: _Using only defaults for GitHub self-hosted runners using Private networking._

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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/dev-ops/cicd-agents-and-runners:<version>'

// Required parameters
param computeTypes = [
  'azure-container-instance'
]
param namingPrefix = '<namingPrefix>'
param networkingConfiguration = {
  addressSpace: '10.0.0.0/16'
  networkType: 'createNew'
  virtualNetworkName: 'vnet-aci'
}
param selfHostedConfig = {
  githubOrganization: 'githHubOrganization'
  githubRepository: 'dummyRepo'
  personalAccessToken: '<personalAccessToken>'
  selfHostedType: 'github'
}
// Non-required parameters
param location = '<location>'
param privateNetworking = true
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
| [`infrastructureResourceGroupName`](#parameter-infrastructureresourcegroupname) | string | Name of the infrastructure resource group for the container apps environment. |
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
- Discriminator: `networkType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`createNew`](#variant-networkingconfigurationnetworktype-createnew) |  |
| [`useExisting`](#variant-networkingconfigurationnetworktype-useexisting) |  |

### Variant: `networkingConfiguration.networkType-createNew`


To use this variant, set the property `networkType` to `createNew`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressSpace`](#parameter-networkingconfigurationnetworktype-createnewaddressspace) | string | The address space of the created virtual network. |
| [`networkType`](#parameter-networkingconfigurationnetworktype-createnewnetworktype) | string | The network type. This can be either createNew or useExisting. |
| [`virtualNetworkName`](#parameter-networkingconfigurationnetworktype-createnewvirtualnetworkname) | string | The virtual network name of the created virtual network. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerAppDeploymentScriptSubnetName`](#parameter-networkingconfigurationnetworktype-createnewcontainerappdeploymentscriptsubnetname) | string | The subnet name for the container app deployment script. Only required if private networking is used. If not provided, a default name will be used. |
| [`containerAppDeploymentScriptSubnetPrefix`](#parameter-networkingconfigurationnetworktype-createnewcontainerappdeploymentscriptsubnetprefix) | string | The subnet address prefix for the container app deployment script which is used to start the placeholder Azure DevOps agent. Only required if private networking is used. If not provided, a default subnet prefix will be used. |
| [`containerAppSubnetAddressPrefix`](#parameter-networkingconfigurationnetworktype-createnewcontainerappsubnetaddressprefix) | string | The container app subnet CIDR in the created virtual network. If not provided, a default subnet prefix will be used. |
| [`containerAppSubnetName`](#parameter-networkingconfigurationnetworktype-createnewcontainerappsubnetname) | string | The container app subnet name in the created virtual network. If not provided, a default name will be used. |
| [`containerInstanceSubnetAddressPrefix`](#parameter-networkingconfigurationnetworktype-createnewcontainerinstancesubnetaddressprefix) | string | The container instance subnet CIDR in the created virtual network. If not provided, a default subnet prefix will be used. |
| [`containerInstanceSubnetName`](#parameter-networkingconfigurationnetworktype-createnewcontainerinstancesubnetname) | string | The container instance subnet name in the created virtual network. If not provided, a default name will be used. |
| [`containerInstancesubnetPrefix`](#parameter-networkingconfigurationnetworktype-createnewcontainerinstancesubnetprefix) | string | The container instance subnet address prefix in the created virtual network. If not provided, a default subnet prefix will be used. |
| [`containerRegistryPrivateDnsZoneResourceId`](#parameter-networkingconfigurationnetworktype-createnewcontainerregistryprivatednszoneresourceid) | string | The container registry private DNS zone Id. If not provided, a new private DNS zone will be created. |
| [`containerRegistryPrivateEndpointSubnetName`](#parameter-networkingconfigurationnetworktype-createnewcontainerregistryprivateendpointsubnetname) | string | The subnet name for the container registry private endpoint. If not provided, a default name will be used. |
| [`containerRegistrySubnetPrefix`](#parameter-networkingconfigurationnetworktype-createnewcontainerregistrysubnetprefix) | string | The container registry subnet address prefix in the created virtual network. If not provided, a default subnet prefix will be used. |
| [`deploymentScriptPrivateDnsZoneResourceId`](#parameter-networkingconfigurationnetworktype-createnewdeploymentscriptprivatednszoneresourceid) | string | The deployment script private DNS zone Id. If not provided, a new private DNS zone will be created. Only required if private networking is used. |
| [`natGatewayPublicIpAddressResourceId`](#parameter-networkingconfigurationnetworktype-createnewnatgatewaypublicipaddressresourceid) | string | The existing public IP address to associate with the NAT gateway. This should be provided if an existing public Ip address is available to be used. If this parameter is not provided, a new Public Ip address will be created. |
| [`natGatewayResourceId`](#parameter-networkingconfigurationnetworktype-createnewnatgatewayresourceid) | string | The existing NAT Gateway resource Id. This should be provided if an existing NAT gateway is available to be used. If this parameter is not provided, a new NAT gateway will be created. |

### Parameter: `networkingConfiguration.networkType-createNew.addressSpace`

The address space of the created virtual network.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.networkType`

The network type. This can be either createNew or useExisting.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'createNew'
  ]
  ```

### Parameter: `networkingConfiguration.networkType-createNew.virtualNetworkName`

The virtual network name of the created virtual network.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerAppDeploymentScriptSubnetName`

The subnet name for the container app deployment script. Only required if private networking is used. If not provided, a default name will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerAppDeploymentScriptSubnetPrefix`

The subnet address prefix for the container app deployment script which is used to start the placeholder Azure DevOps agent. Only required if private networking is used. If not provided, a default subnet prefix will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerAppSubnetAddressPrefix`

The container app subnet CIDR in the created virtual network. If not provided, a default subnet prefix will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerAppSubnetName`

The container app subnet name in the created virtual network. If not provided, a default name will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerInstanceSubnetAddressPrefix`

The container instance subnet CIDR in the created virtual network. If not provided, a default subnet prefix will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerInstanceSubnetName`

The container instance subnet name in the created virtual network. If not provided, a default name will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerInstancesubnetPrefix`

The container instance subnet address prefix in the created virtual network. If not provided, a default subnet prefix will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerRegistryPrivateDnsZoneResourceId`

The container registry private DNS zone Id. If not provided, a new private DNS zone will be created.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerRegistryPrivateEndpointSubnetName`

The subnet name for the container registry private endpoint. If not provided, a default name will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.containerRegistrySubnetPrefix`

The container registry subnet address prefix in the created virtual network. If not provided, a default subnet prefix will be used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.deploymentScriptPrivateDnsZoneResourceId`

The deployment script private DNS zone Id. If not provided, a new private DNS zone will be created. Only required if private networking is used.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.natGatewayPublicIpAddressResourceId`

The existing public IP address to associate with the NAT gateway. This should be provided if an existing public Ip address is available to be used. If this parameter is not provided, a new Public Ip address will be created.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-createNew.natGatewayResourceId`

The existing NAT Gateway resource Id. This should be provided if an existing NAT gateway is available to be used. If this parameter is not provided, a new NAT gateway will be created.

- Required: No
- Type: string

### Variant: `networkingConfiguration.networkType-useExisting`


To use this variant, set the property `networkType` to `useExisting`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computeNetworking`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworking) | object | The compute type networking type. |
| [`containerRegistryPrivateEndpointSubnetName`](#parameter-networkingconfigurationnetworktype-useexistingcontainerregistryprivateendpointsubnetname) | string | The subnet name for the container registry private endpoint. |
| [`networkType`](#parameter-networkingconfigurationnetworktype-useexistingnetworktype) | string | The network type. This can be either createNew or useExisting. |
| [`virtualNetworkResourceId`](#parameter-networkingconfigurationnetworktype-useexistingvirtualnetworkresourceid) | string | The existing virtual network resource Id. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerRegistryPrivateDnsZoneResourceId`](#parameter-networkingconfigurationnetworktype-useexistingcontainerregistryprivatednszoneresourceid) | string | The container registry private DNS zone Id. If not provided, a new private DNS zone will be created. |
| [`natGatewayPublicIpAddressResourceId`](#parameter-networkingconfigurationnetworktype-useexistingnatgatewaypublicipaddressresourceid) | string | The existing public IP address to associate with the NAT gateway. This should be provided if an existing public Ip address is available to be used. If this parameter is not provided, a new Public Ip address will be created. |
| [`natGatewayResourceId`](#parameter-networkingconfigurationnetworktype-useexistingnatgatewayresourceid) | string | The existing NAT Gateway resource Id. This should be provided if an existing NAT gateway is available to be used. If this parameter is not provided, a new NAT gateway will be created. |

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking`

The compute type networking type.

- Required: Yes
- Type: object
- Discriminator: `computeNetworkType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`azureContainerApp`](#variant-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerapp) |  |
| [`azureContainerInstance`](#variant-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerinstance) |  |

### Variant: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerApp`


To use this variant, set the property `computeNetworkType` to `azureContainerApp`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computeNetworkType`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerappcomputenetworktype) | string | The Azure Container App networking type. |
| [`containerAppDeploymentScriptSubnetName`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerappcontainerappdeploymentscriptsubnetname) | string | The existing subnet name for the container app deployment script. |
| [`containerAppSubnetName`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerappcontainerappsubnetname) | string | The existing network container app subnet name. This is required for Container Apps compute type. This subnet needs to have service delegation for App environments. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerInstanceSubnetName`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerappcontainerinstancesubnetname) | string | The container instance subnet name in the created virtual network. If not provided, a default name will be used. This subnet is required for private networking Azure DevOps scenarios to deploy the deployment script which starts the placeholder agent privately. |
| [`deploymentScriptPrivateDnsZoneResourceId`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerappdeploymentscriptprivatednszoneresourceid) | string | The deployment script private DNS zone Id. If not provided, a new private DNS zone will be created. |

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerApp.computeNetworkType`

The Azure Container App networking type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'azureContainerApp'
  ]
  ```

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerApp.containerAppDeploymentScriptSubnetName`

The existing subnet name for the container app deployment script.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerApp.containerAppSubnetName`

The existing network container app subnet name. This is required for Container Apps compute type. This subnet needs to have service delegation for App environments.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerApp.containerInstanceSubnetName`

The container instance subnet name in the created virtual network. If not provided, a default name will be used. This subnet is required for private networking Azure DevOps scenarios to deploy the deployment script which starts the placeholder agent privately.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerApp.deploymentScriptPrivateDnsZoneResourceId`

The deployment script private DNS zone Id. If not provided, a new private DNS zone will be created.

- Required: No
- Type: string

### Variant: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerInstance`


To use this variant, set the property `computeNetworkType` to `azureContainerInstance`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`computeNetworkType`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerinstancecomputenetworktype) | string | The Azure Container Instance network type. |
| [`containerInstanceSubnetName`](#parameter-networkingconfigurationnetworktype-useexistingcomputenetworkingcomputenetworktype-azurecontainerinstancecontainerinstancesubnetname) | string | The container instance subnet name in the created virtual network. If not provided, a default name will be used. |

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerInstance.computeNetworkType`

The Azure Container Instance network type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'azureContainerInstance'
  ]
  ```

### Parameter: `networkingConfiguration.networkType-useExisting.computeNetworking.computeNetworkType-azureContainerInstance.containerInstanceSubnetName`

The container instance subnet name in the created virtual network. If not provided, a default name will be used.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.containerRegistryPrivateEndpointSubnetName`

The subnet name for the container registry private endpoint.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.networkType`

The network type. This can be either createNew or useExisting.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'useExisting'
  ]
  ```

### Parameter: `networkingConfiguration.networkType-useExisting.virtualNetworkResourceId`

The existing virtual network resource Id.

- Required: Yes
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.containerRegistryPrivateDnsZoneResourceId`

The container registry private DNS zone Id. If not provided, a new private DNS zone will be created.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.natGatewayPublicIpAddressResourceId`

The existing public IP address to associate with the NAT gateway. This should be provided if an existing public Ip address is available to be used. If this parameter is not provided, a new Public Ip address will be created.

- Required: No
- Type: string

### Parameter: `networkingConfiguration.networkType-useExisting.natGatewayResourceId`

The existing NAT Gateway resource Id. This should be provided if an existing NAT gateway is available to be used. If this parameter is not provided, a new NAT gateway will be created.

- Required: No
- Type: string

### Parameter: `selfHostedConfig`

The self-hosted runner configuration. This can be either GitHub or Azure DevOps.

- Required: Yes
- Type: object
- Discriminator: `selfHostedType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`createNew`](#variant-networkingconfigurationnetworktype-createnew) |  |
| [`useExisting`](#variant-networkingconfigurationnetworktype-useexisting) |  |

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`github`](#variant-selfhostedconfigselfhostedtype-github) |  |
| [`azuredevops`](#variant-selfhostedconfigselfhostedtype-azuredevops) |  |

### Variant: `selfHostedConfig.selfHostedType-github`


To use this variant, set the property `selfHostedType` to `github`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`githubOrganization`](#parameter-selfhostedconfigselfhostedtype-githubgithuborganization) | string | The GitHub organization name. |
| [`personalAccessToken`](#parameter-selfhostedconfigselfhostedtype-githubpersonalaccesstoken) | securestring | The GitHub personal access token with permissions to create and manage self-hosted runners.  See https://learn.microsoft.com/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-github-actions#get-a-github-personal-access-token for PAT permissions. The permissions will change based on the scope of the runner. |
| [`selfHostedType`](#parameter-selfhostedconfigselfhostedtype-githubselfhostedtype) | string | The self-hosted runner type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureContainerAppTarget`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerapptarget) | object | The GitHub runner Azure Container app configuration. |
| [`azureContainerInstanceTarget`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerinstancetarget) | object | The GitHub runner Azure Container instance configuration. |
| [`ephemeral`](#parameter-selfhostedconfigselfhostedtype-githubephemeral) | bool | Deploy ephemeral runners. |
| [`githubRepository`](#parameter-selfhostedconfigselfhostedtype-githubgithubrepository) | string | The GitHub repository name. |
| [`runnerGroup`](#parameter-selfhostedconfigselfhostedtype-githubrunnergroup) | string | The GitHub runner group. |
| [`runnerName`](#parameter-selfhostedconfigselfhostedtype-githubrunnername) | string | The GitHub runner name. |
| [`runnerNamePrefix`](#parameter-selfhostedconfigselfhostedtype-githubrunnernameprefix) | string | The GitHub runner name prefix. |
| [`runnerScope`](#parameter-selfhostedconfigselfhostedtype-githubrunnerscope) | string | The GitHub runner scope. Depending on the scope, you would need to set the right permissions for your Personal Access Token. |
| [`targetWorkflowQueueLength`](#parameter-selfhostedconfigselfhostedtype-githubtargetworkflowqueuelength) | string | The target workflow queue length. |

### Parameter: `selfHostedConfig.selfHostedType-github.githubOrganization`

The GitHub organization name.

- Required: Yes
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-github.personalAccessToken`

The GitHub personal access token with permissions to create and manage self-hosted runners.  See https://learn.microsoft.com/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-github-actions#get-a-github-personal-access-token for PAT permissions. The permissions will change based on the scope of the runner.

- Required: Yes
- Type: securestring

### Parameter: `selfHostedConfig.selfHostedType-github.selfHostedType`

The self-hosted runner type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'github'
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerAppTarget`

The GitHub runner Azure Container app configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resources`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerapptargetresources) | object | The Azure Container App Job CPU and memory resources. |

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerAppTarget.resources`

The Azure Container App Job CPU and memory resources.

- Required: No
- Type: object
- Allowed:
  ```Bicep
  [
    {
      cpu: '0.25'
      memory: '0.5Gi'
    }
    {
      cpu: '0.5'
      memory: '1Gi'
    }
    {
      cpu: '0.75'
      memory: '1.5Gi'
    }
    {
      cpu: '1'
      memory: '2Gi'
    }
    {
      cpu: '1.25'
      memory: '2.5Gi'
    }
    {
      cpu: '1.5'
      memory: '3Gi'
    }
    {
      cpu: '1.75'
      memory: '3.5Gi'
    }
    {
      cpu: '2'
      memory: '4Gi'
    }
    {
      cpu: '2.25'
      memory: '4.5Gi'
    }
    {
      cpu: '2.5'
      memory: '5Gi'
    }
    {
      cpu: '2.75'
      memory: '5.5Gi'
    }
    {
      cpu: '3'
      memory: '6Gi'
    }
    {
      cpu: '3.25'
      memory: '6.5Gi'
    }
    {
      cpu: '3.5'
      memory: '7Gi'
    }
    {
      cpu: '3.75'
      memory: '7.5Gi'
    }
    {
      cpu: '4'
      memory: '8Gi'
    }
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerInstanceTarget`

The GitHub runner Azure Container instance configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerinstancetargetcpu) | int | The Azure Container Instance container cpu. |
| [`memoryInGB`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerinstancetargetmemoryingb) | int | The Azure Container Instance container memory. |
| [`numberOfInstances`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerinstancetargetnumberofinstances) | int | The number of the Azure Container Instances to deploy. |
| [`port`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerinstancetargetport) | int | The Azure Container Instance container port. |
| [`sku`](#parameter-selfhostedconfigselfhostedtype-githubazurecontainerinstancetargetsku) | string | The Azure Container Instance Sku name. |

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerInstanceTarget.cpu`

The Azure Container Instance container cpu.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerInstanceTarget.memoryInGB`

The Azure Container Instance container memory.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerInstanceTarget.numberOfInstances`

The number of the Azure Container Instances to deploy.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerInstanceTarget.port`

The Azure Container Instance container port.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-github.azureContainerInstanceTarget.sku`

The Azure Container Instance Sku name.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dedicated'
    'Standard'
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-github.ephemeral`

Deploy ephemeral runners.

- Required: No
- Type: bool
- Allowed:
  ```Bicep
  [
    true
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-github.githubRepository`

The GitHub repository name.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-github.runnerGroup`

The GitHub runner group.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-github.runnerName`

The GitHub runner name.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-github.runnerNamePrefix`

The GitHub runner name prefix.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-github.runnerScope`

The GitHub runner scope. Depending on the scope, you would need to set the right permissions for your Personal Access Token.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ent'
    'org'
    'repo'
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-github.targetWorkflowQueueLength`

The target workflow queue length.

- Required: No
- Type: string

### Variant: `selfHostedConfig.selfHostedType-azuredevops`


To use this variant, set the property `selfHostedType` to `azuredevops`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentsPoolName`](#parameter-selfhostedconfigselfhostedtype-azuredevopsagentspoolname) | string | The Azure DevOps agents pool name. |
| [`devOpsOrganization`](#parameter-selfhostedconfigselfhostedtype-azuredevopsdevopsorganization) | string | The Azure DevOps organization name. |
| [`personalAccessToken`](#parameter-selfhostedconfigselfhostedtype-azuredevopspersonalaccesstoken) | securestring | The Azure DevOps persoanl access token with permissions to create and manage self-hosted agents. See https://learn.microsoft.com/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-azure-pipelines#get-an-azure-devops-personal-access-token for PAT permissions. |
| [`selfHostedType`](#parameter-selfhostedconfigselfhostedtype-azuredevopsselfhostedtype) | string | The self-hosted runner type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agentName`](#parameter-selfhostedconfigselfhostedtype-azuredevopsagentname) | string | The Azure DevOps agent name. |
| [`agentNamePrefix`](#parameter-selfhostedconfigselfhostedtype-azuredevopsagentnameprefix) | string | The Azure DevOps agent name prefix. |
| [`azureContainerAppTarget`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerapptarget) | object | The AzureDevOps agents Azure Container app configuration. |
| [`azureContainerInstanceTarget`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerinstancetarget) | object | The GitHub runner Azure Container instance configuration. |
| [`placeHolderAgentName`](#parameter-selfhostedconfigselfhostedtype-azuredevopsplaceholderagentname) | string | The Azure DevOps placeholder agent name. |
| [`targetPipelinesQueueLength`](#parameter-selfhostedconfigselfhostedtype-azuredevopstargetpipelinesqueuelength) | string | The target pipelines queue length. |

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.agentsPoolName`

The Azure DevOps agents pool name.

- Required: Yes
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.devOpsOrganization`

The Azure DevOps organization name.

- Required: Yes
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.personalAccessToken`

The Azure DevOps persoanl access token with permissions to create and manage self-hosted agents. See https://learn.microsoft.com/azure/container-apps/tutorial-ci-cd-runners-jobs?tabs=bash&pivots=container-apps-jobs-self-hosted-ci-cd-azure-pipelines#get-an-azure-devops-personal-access-token for PAT permissions.

- Required: Yes
- Type: securestring

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.selfHostedType`

The self-hosted runner type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'azuredevops'
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.agentName`

The Azure DevOps agent name.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.agentNamePrefix`

The Azure DevOps agent name prefix.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerAppTarget`

The AzureDevOps agents Azure Container app configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resources`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerapptargetresources) | object | The Azure Container App Job CPU and memory resources. |

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerAppTarget.resources`

The Azure Container App Job CPU and memory resources.

- Required: No
- Type: object
- Allowed:
  ```Bicep
  [
    {
      cpu: '0.25'
      memory: '0.5Gi'
    }
    {
      cpu: '0.5'
      memory: '1Gi'
    }
    {
      cpu: '0.75'
      memory: '1.5Gi'
    }
    {
      cpu: '1'
      memory: '2Gi'
    }
    {
      cpu: '1.25'
      memory: '2.5Gi'
    }
    {
      cpu: '1.5'
      memory: '3Gi'
    }
    {
      cpu: '1.75'
      memory: '3.5Gi'
    }
    {
      cpu: '2'
      memory: '4Gi'
    }
    {
      cpu: '2.25'
      memory: '4.5Gi'
    }
    {
      cpu: '2.5'
      memory: '5Gi'
    }
    {
      cpu: '2.75'
      memory: '5.5Gi'
    }
    {
      cpu: '3'
      memory: '6Gi'
    }
    {
      cpu: '3.25'
      memory: '6.5Gi'
    }
    {
      cpu: '3.5'
      memory: '7Gi'
    }
    {
      cpu: '3.75'
      memory: '7.5Gi'
    }
    {
      cpu: '4'
      memory: '8Gi'
    }
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerInstanceTarget`

The GitHub runner Azure Container instance configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cpu`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerinstancetargetcpu) | int | The Azure Container Instance container cpu. |
| [`memoryInGB`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerinstancetargetmemoryingb) | int | The Azure Container Instance container memory. |
| [`numberOfInstances`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerinstancetargetnumberofinstances) | int | The number of the Azure Container Instances to deploy. |
| [`port`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerinstancetargetport) | int | The Azure Container Instance container port. |
| [`sku`](#parameter-selfhostedconfigselfhostedtype-azuredevopsazurecontainerinstancetargetsku) | string | The Azure Container Instance Sku name. |

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerInstanceTarget.cpu`

The Azure Container Instance container cpu.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerInstanceTarget.memoryInGB`

The Azure Container Instance container memory.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerInstanceTarget.numberOfInstances`

The number of the Azure Container Instances to deploy.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerInstanceTarget.port`

The Azure Container Instance container port.

- Required: No
- Type: int

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.azureContainerInstanceTarget.sku`

The Azure Container Instance Sku name.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dedicated'
    'Standard'
  ]
  ```

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.placeHolderAgentName`

The Azure DevOps placeholder agent name.

- Required: No
- Type: string

### Parameter: `selfHostedConfig.selfHostedType-azuredevops.targetPipelinesQueueLength`

The target pipelines queue length.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `infrastructureResourceGroupName`

Name of the infrastructure resource group for the container apps environment.

- Required: No
- Type: string

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
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/res/app/job:0.6.0` | Remote reference |
| `br/public:avm/res/app/managed-environment:0.10.2` | Remote reference |
| `br/public:avm/res/container-instance/container-group:0.2.0` | Remote reference |
| `br/public:avm/res/container-registry/registry:0.9.1` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.0` | Remote reference |
| `br/public:avm/res/network/nat-gateway:1.2.2` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.5.0` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.7.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.8.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.6.1` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.11.1` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.3.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.13.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
