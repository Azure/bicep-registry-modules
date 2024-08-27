/*
Types:
------
- GitHub self-hosted runner
- Azure DevOps self-hosted agent
- ACI target
- ACA target
- Images?
*/

metadata name = 'CI CD Agents and Runners'
metadata description = 'This module deploys self-hosted agents and runners for Azure DevOps and GitHub.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Naming prefix to be used with naming the deployed resources.')
param namingPrefix string

@description('Required. The compute target for the private runners.')
param computeTypes computeTypesType = [
  'azure-container-instance'
]

param selfHostedConfig selfHostedRunnerType

/*@description('Optional. The GitHub runners configuration.')
param githubRunners gitHubRunnersType?

@description('Optional. The Azure DevOps agents configuration.')
param azureDevOpsAgents devOpsAgentsType?
*/
@description('Required. The networking configuration.')
param networkingConfiguration networkType

@description('Optional. Whether to use private or public networking for the Azure Container Registry.')
param privateNetworking bool = true

var githubURL = 'https://github.com/sebassem/bicep-registry-modules#avm-ptn-lz-private-runners:avm/ptn/lz/private-runners/container-images'

// ================ //
// Variables        //
// ================ //

var imagePaths = [
  {
    platform: 'azuredevops-container-app'
    imagePath: 'azure-devops-agent-aca'
  }
  {
    platform: 'github-container-app'
    imagePath: 'github-runner-aca'
  }
  {
    platform: 'azuredevops-container-instance'
    imagePath: 'azure-devops-agent-aci'
  }
  {
    platform: 'github-container-instance'
    imagePath: 'github-runner-aci'
  }
]

var gitHubOrganization = selfHostedConfig.selfHostedType == 'github'
  ? selfHostedConfig.?githubOrganization ?? 'dummyOrg'
  : null

var gitHubRepository = selfHostedConfig.selfHostedType == 'github'
  ? selfHostedConfig.?githubRepository ?? 'dummyRepo'
  : null

var gitHubRunnerURL = 'https://github.com/${gitHubOrganization}/${gitHubRepository}'

var devOpsOrgURL = selfHostedConfig.selfHostedType == 'azuredevops'
  ? 'https://dev.azure.com/${selfHostedConfig.?devOpsOrganization ?? 'dummyOrg'}'
  : null

//var containerImagesURL = 'https://github.com/sebassem/bicep-registry-modules#avm-ptn-lz-private-runners:avm/ptn/lz/private-runners/container-images'

// ================ //
// Resources        //
// ================ //

module logAnalyticsWokrspace 'br/public:avm/res/operational-insights/workspace:0.5.0' = {
  name: 'logAnalyticsWokrspace'
  params: {
    name: 'law-${namingPrefix}-${uniqueString(resourceGroup().id)}-law'
  }
}

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.3.0' = {
  name: 'userAssignedIdentity'
  params: {
    name: 'msi-${namingPrefix}-${uniqueString(resourceGroup().id)}'
    location: location
  }
}

module acrPrivateDNSZone 'br/public:avm/res/network/private-dns-zone:0.5.0' = if (privateNetworking) {
  name: 'acrdnszone${namingPrefix}${uniqueString(resourceGroup().id)}'
  params: {
    name: 'privatelink.azurecr.io'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: networkingConfiguration.networkType == 'useExisting'
          ? resourceId('Microsoft.Network/virtualNetworks', networkingConfiguration.?virtualNetworkName)
          : newVnet.outputs.resourceId
      }
    ]
  }
}

module acr 'br/public:avm/res/container-registry/registry:0.4.0' = {
  name: 'acr${namingPrefix}${uniqueString(resourceGroup().id)}'
  params: {
    name: 'acr${namingPrefix}${uniqueString(resourceGroup().id)}'
    acrSku: privateNetworking ? 'Premium' : 'Basic'
    acrAdminUserEnabled: false
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '8311e382-0749-4cb8-b61a-304f252e45ec'
      }
    ]
    networkRuleBypassOptions: privateNetworking ? 'AzureServices' : 'None'
    privateEndpoints: privateNetworking
      ? [
          {
            subnetResourceId: networkingConfiguration.networkType == 'useExisting'
              ? resourceId(
                  'Microsoft.Network/virtualNetworks/subnets',
                  networkingConfiguration.?virtualNetworkName,
                  networkingConfiguration.?containerRegistryPrivateEndpointSubnetName
                )
              : newVnet.outputs.subnetResourceIds[0]
            privateDnsZoneResourceIds: networkingConfiguration.?containerRegistryPrivateDnsZoneId != null
              ? [
                  networkingConfiguration.?containerRegistryPrivateDnsZoneId
                ]
              : [
                  acrPrivateDNSZone.outputs.resourceId
                ]
            privateDnsZoneGroupName: 'acrPrivateDNSZoneGroup'
          }
        ]
      : null
  }
}

module newVnet 'br/public:avm/res/network/virtual-network:0.2.0' = if (networkingConfiguration.networkType == 'createNew') {
  name: 'vnet-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'vnet-${namingPrefix}-${uniqueString(resourceGroup().id)}'
    location: location
    addressPrefixes: [
      networkingConfiguration.addressSpace
    ]
    subnets: union(
      privateNetworking
        ? [
            {
              name: networkingConfiguration.?containerRegistryPrivateEndpointSubnetName ?? 'acr-pe-subnet'
              addressPrefix: networkingConfiguration.?containerRegistrySubnetPrefix ?? '10.0.0.0/29'
            }
          ]
        : [],
      contains(computeTypes, 'azure-container-app')
        ? [
            {
              name: networkingConfiguration.?containerAppSubnetName ?? 'app-subnet'
              addressPrefix: networkingConfiguration.?containerAppSubnetAddressPrefix ?? '10.0.0.0/27'
              delegations: [
                {
                  name: 'Microsoft.App.environments'
                  properties: {
                    serviceName: 'Microsoft.App/environments'
                  }
                }
              ]
            }
          ]
        : contains(computeTypes, 'azure-container-instance')
            ? [
                {
                  name: networkingConfiguration.?containerInstanceSubnetName ?? 'aci-subnet'
                  addressPrefix: networkingConfiguration.?containerInstanceSubnetAddressPrefix ?? '10.0.0.16/28'
                  delegations: [
                    {
                      name: 'Microsoft.ContainerInstance/containerGroups'
                      properties: {
                        serviceName: 'Microsoft.ContainerInstance/containerGroups'
                      }
                    }
                  ]
                }
              ]
            : [],
      []
    )
  }
}

module appEnvironment 'br/public:avm/res/app/managed-environment:0.6.2' = if (contains(
  computeTypes,
  'azure-container-app'
)) {
  name: 'appEnv-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'appEnv${namingPrefix}${uniqueString(resourceGroup().id)}'
    logAnalyticsWorkspaceResourceId: logAnalyticsWokrspace.outputs.resourceId
    location: location
    infrastructureSubnetId: privateNetworking && networkingConfiguration.networkType == 'useExisting'
      ? resourceId(
          'Microsoft.Network/virtualNetworks/subnets',
          networkingConfiguration.?virtualNetworkName ?? 'vnet-runners',
          networkingConfiguration.?containerAppSubnetName ?? 'app-subnet'
        )
      : privateNetworking && networkingConfiguration.networkType == 'createNew'
          ? newVnet.outputs.subnetResourceIds[0]
          : null
    zoneRedundant: privateNetworking ? true : false
    internal: privateNetworking ? true : false
    workloadProfiles: [
      {
        name: 'consumption'
        workloadProfileType: 'consumption'
      }
    ]
  }
}

resource buildImages 'Microsoft.ContainerRegistry/registries/tasks@2019-06-01-preview' = [
  for (image, i) in computeTypes: {
    name: '${acr.name}/buildImage-${image}-${selfHostedConfig.selfHostedType}-${i}'
    location: location
    identity: {
      type: 'SystemAssigned'
    }
    properties: {
      platform: {
        os: 'Linux'
      }
      step: {
        dockerFilePath: 'dockerfile'
        type: 'Docker'
        contextPath: contains(computeTypes, 'azure-container-app')
          ? '${githubURL}/${filter(imagePaths, imagePath => imagePath.platform == '${selfHostedConfig.selfHostedType}-container-app')[0].imagePath}'
          : contains(computeTypes, 'azure-container-instance')
              ? '${githubURL}/${filter(imagePaths, imagePath => imagePath.platform == '${selfHostedConfig.selfHostedType}-container-instance')[0].imagePath}'
              : null
        imageNames: [
          '${acr.outputs.loginServer}/${selfHostedConfig.selfHostedType}-${image}:latest'
        ]
      }
      credentials: privateNetworking
        ? {
            customRegistries: {
              '${acr.outputs.loginServer}': {
                identity: '[system]'
              }
            }
          }
        : null
    }
  }
]

module buildImagesRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.1' = [
  for (image, i) in computeTypes: {
    name: 'buildImagesRoleAssignment-${uniqueString(resourceGroup().id)}-${i}'
    params: {
      principalId: buildImages[i].identity.principalId
      resourceId: acr.outputs.resourceId
      roleDefinitionId: '8311e382-0749-4cb8-b61a-304f252e45ec'
      principalType: 'ServicePrincipal'
    }
  }
]

resource taskRun 'Microsoft.ContainerRegistry/registries/taskRuns@2019-06-01-preview' = [
  for (image, i) in computeTypes: {
    name: '${acr.name}/taskrun-${image}-${selfHostedConfig.selfHostedType}-${i}'
    location: location
    dependsOn: [
      buildImagesRoleAssignment
    ]
    properties: {
      runRequest: {
        taskId: buildImages[i].id
        type: 'TaskRunRequest'
      }
    }
  }
]

module aciJob 'br/public:avm/res/container-instance/container-group:0.2.0' = [
  for i in range(0, int(selfHostedConfig.?azureContainerInstanceTarget.?numberOfInstances ?? 1)): if (contains(
    computeTypes,
    'azure-container-instance'
  )) {
    name: '${namingPrefix}aciJob-${i}'
    dependsOn: [
      taskRun
    ]
    params: {
      name: '${namingPrefix}-${uniqueString(resourceGroup().id)}-instance-${i}'
      managedIdentities: {
        userAssignedResourceIds: [
          userAssignedIdentity.outputs.resourceId
        ]
      }
      imageRegistryCredentials: [
        {
          identity: userAssignedIdentity.outputs.resourceId
          server: acr.outputs.loginServer
        }
      ]
      subnetId: privateNetworking && networkingConfiguration.networkType == 'useExisting'
        ? resourceId(
            'Microsoft.Network/virtualNetworks/subnets',
            networkingConfiguration.?virtualNetworkName,
            networkingConfiguration.?containerInstanceSubnetName
          )
        : privateNetworking && networkingConfiguration.networkType == 'createNew'
            ? filter(
                newVnet.outputs.subnetResourceIds,
                subnetId => contains(subnetId, networkingConfiguration.?containerInstanceSubnetName ?? 'aci-subnet')
              )[0]
            : null
      ipAddressType: privateNetworking ? 'Private' : 'Public'
      sku: 'Standard'
      containers: [
        {
          name: selfHostedConfig.selfHostedType == 'github'
            ? 'private-runner-github-aci-${i}'
            : selfHostedConfig.selfHostedType == 'azuredevops'
                ? 'private-runner-devops-aci-${i}'
                : 'private-runner-aci-${i}'
          properties: {
            image: '${acr.outputs.loginServer}/${selfHostedConfig.selfHostedType}-azure-container-instance:latest'
            ports: [
              {
                port: 80
                protocol: 'TCP'
              }
            ]
            resources: {
              requests: {
                cpu: 1
                memoryInGB: 2
              }
            }
            environmentVariables: selfHostedConfig.selfHostedType == 'github'
              ? [
                  {
                    name: 'GH_RUNNER_NAME'
                    value: any(selfHostedConfig.?runnerName ?? 'runner-${i}')
                  }
                  {
                    name: 'GH_RUNNER_URL'
                    value: gitHubRunnerURL
                  }
                  {
                    name: 'GH_RUNNER_GROUP'
                    value: selfHostedConfig.?runnerGroup != null ? '${selfHostedConfig.?runnerGroup}' : ''
                  }
                  {
                    name: 'GH_RUNNER_TOKEN'
                    secureValue: any(selfHostedConfig.?personalAccessToken ?? '')
                  }
                ]
              : [
                  {
                    name: 'AZP_URL'
                    value: devOpsOrgURL
                  }
                  {
                    name: 'AZP_POOL'
                    value: selfHostedConfig.?agentsPoolName ?? 'dummyPool'
                  }
                  {
                    name: 'AZP_AGENT_NAME'
                    value: any(selfHostedConfig.?agentName ?? 'agent-${i}')
                  }
                  {
                    name: 'AZP_TOKEN'
                    secureValue: any(selfHostedConfig.?personalAccessToken ?? '')
                  }
                ]
          }
        }
      ]
      ipAddressPorts: [
        {
          port: 80
          protocol: 'TCP'
        }
      ]
    }
  }
]

// ================ //
// Definitions      //
// ================ //

type newNetworkType = {
  @description('Required. The network type')
  networkType: 'createNew'

  @description('Required. The new virtual network name.')
  virtualNetworkName: string

  @description('Required. The new virtual network address space.')
  addressSpace: string

  @description('Optional. Deploy a NAT gateway.')
  deployNatGateway: true?

  @description('Optional. The new network container instance subnet name.')
  containerInstanceSubnetName: string?

  @description('Optional. The new network container instance subnet CIDR.')
  containerInstanceSubnetAddressPrefix: string?

  @description('Optional. The new network container app subnet name.')
  containerAppSubnetName: string?

  @description('Optional. The new network container app subnet CIDR.')
  containerAppSubnetAddressPrefix: string?

  @description('Optional. The new network container instance subnet address prefix.')
  containerInstancesubnetPrefix: string?

  @description('Optional. The new network container app subnet address prefix.')
  containerAppSubnetPrefix: string?

  @description('Optional. The new network container registry subnet address prefix.')
  containerRegistrySubnetPrefix: string?

  @description('Optional. The container registry private DNS zone Id.')
  containerRegistryPrivateDnsZoneId: string?

  @description('Optional. The subnet name for the container registry private endpoint.')
  containerRegistryPrivateEndpointSubnetName: string?
}

type existingNetworkType = {
  @description('Required. The network type')
  networkType: 'UseExisting'

  @description('Required. The existing virtual network name.')
  virtualNetworkName: string

  @description('Optional. The existing network container instance subnet name.')
  containerInstanceSubnetName: string?

  @description('Optional. The existing network container app subnet name.')
  containerAppSubnetName: string?

  @description('Optional. The container registry private DNS zone Id.')
  containerRegistryPrivateDnsZoneId: string?

  @description('Optional. The subnet name for the container registry private endpoint.')
  containerRegistryPrivateEndpointSubnetName: string
}

@discriminator('networkType')
type networkType = newNetworkType | existingNetworkType

type azureContainerInstanceTargetType = {
  @description('Optional. The Azure Container Instance Ip address type.')
  ipAddressType: 'Public' | 'Private'

  @description('Optional. The Azure Container Instance Sku name.')
  sku: 'Standard' | 'Dedicated'?

  @description('Optional. The number of the Azure Container Instances to deploy.')
  numberOfInstances: int?

  @description('Optional. The Azure Container Instance container cpu.')
  cpu: int?

  @description('Optional. The Azure Container Instance container memory.')
  memory: int?

  @description('Optional. The Azure Container Instance container port.')
  port: int?
}?

type azureContainerAppTargetType = {}

type gitHubRunnersType = {
  @description('Required. The self-hosted runner type.')
  selfHostedType: 'github'

  @description('Required. The GitHub persoanl access token with permissions to create and manage self-hosted runners.')
  @secure()
  personalAccessToken: string

  @description('Required. The GitHub organization name.')
  githubOrganization: string

  @description('Required. The GitHub repository name.')
  githubRepository: string

  @description('Optional. The GitHub runner name.')
  runnerName: string?

  @description('Optional. The GitHub runner group.')
  runnerGroup: string?

  @description('Optional. The GitHub runner name prefix.')
  runnerNamePrefix: string?

  @description('Optional. The GitHub runner scope.')
  runnerScope: 'repo' | 'org' | 'ent'?

  @description('Optional. Deploy ephemeral runners.')
  ephemeral: true?

  @description('Optional. The GitHub runner Azure Container instance configuration.')
  azureContainerInstanceTarget: azureContainerInstanceTargetType?
}

type devOpsAgentsType = {
  @description('Required. The self-hosted runner type.')
  selfHostedType: 'azuredevops'

  @description('Required. The Azure DevOps persoanl access token with permissions to create and manage self-hosted agents.')
  @secure()
  personalAccessToken: string

  @description('Required. The Azure DevOps organization name.')
  devOpsOrganization: string

  @description('Required. The Azure DevOps agents pool name.')
  agentsPoolName: string

  @description('Optional. The Azure DevOps agent name.')
  agentName: string?

  @description('Optional. The Azure DevOps agent name prefix.')
  agentNamePrefix: string?

  @description('Optional. Create a placeholder agent.')
  deployPlaceholder: true?

  @description('Optional. The GitHub runner Azure Container instance configuration.')
  azureContainerInstanceTarget: azureContainerInstanceTargetType?
}

@discriminator('selfHostedType')
type selfHostedRunnerType = gitHubRunnersType | devOpsAgentsType

@description('Optional. The target compute environments for the private runners.')
type computeTypesType = ('azure-container-app' | 'azure-container-instance')[]
