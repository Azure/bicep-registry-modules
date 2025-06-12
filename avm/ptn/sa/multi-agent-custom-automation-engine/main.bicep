// // ========== main.bicep ========== //
targetScope = 'resourceGroup'

metadata name = 'Multi-Agent Custom Automation Engine'
metadata description = '''This module  contains the resources required to deploy the [Multi-Agent Custom Automation Engine solution accelerator](https://github.com/microsoft/Multi-Agent-Custom-Automation-Engine-Solution-Accelerator) for both Sandbox environments and WAF aligned environments.

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.
'''

@description('Optional. The prefix to add in the default names given to all deployed Azure resources.')
@maxLength(19)
param solutionPrefix string = 'macae${uniqueString(deployer().objectId, deployer().tenantId, subscription().subscriptionId, resourceGroup().id)}'

@description('Optional. Location for all Resources except AI Foundry.')
param solutionLocation string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// Restricting deployment to only supported Azure OpenAI regions validated with GPT-4o model
@allowed(['australiaeast', 'eastus2', 'francecentral', 'japaneast', 'norwayeast', 'swedencentral', 'uksouth', 'westus'])
@description('Required. The location of OpenAI related resources. This should be one of the supported Azure OpenAI regions.')
param azureOpenAILocation string

// @description('Set this if you want to deploy to a different region than the resource group. Otherwise, it will use the resource group location by default.')
// param AZURE_LOCATION string=''
// param solutionLocation string = empty(AZURE_LOCATION) ? resourceGroup().location

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

@description('Optional. Enable monitoring applicable resources, aligned with the Well Architected Framework recommendations. This setting enables Application Insights and Log Analytics and configures all the resources applicable resources to send logs. Defaults to false.')
param enableMonitoring bool = false

@description('Optional. Enable scalability for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableScalability bool = false

@description('Optional. Enable redundancy for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enableRedundancy bool = false

@description('Optional. Enable private networking for applicable resources, aligned with the Well Architected Framework recommendations. Defaults to false.')
param enablePrivateNetworking bool = false

@secure()
@description('Optional. The username for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.')
param virtualMachineAdminUsername string = '' //TODO: store value in Key Vault

@description('Optional. The password for the administrator account of the virtual machine. Allows to customize credentials if `enablePrivateNetworking` is set to true.')
@secure()
param virtualMachineAdminPassword string = newGuid() //TODO: store value in Key Vault

@description('Optional. The Container Image Tag to deploy on the backend from public Container Registry `biabcontainerreg.azurecr.io`.')
param backendContainerImageTag string = 'latest_2025-06-12_639'

@description('Optional. The Container Image Tag to deploy on the frontend from public Container Registry `biabcontainerreg.azurecr.io`.')
param frontendContainerImageTag string = 'latest_2025-06-12_639'

var containerRegistryHostname = 'biabcontainerreg.azurecr.io'

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.sa-multiagentcustauteng.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, solutionLocation), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// Log Analytics configuration defaults
var logAnalyticsWorkspaceResourceName = 'log-${solutionPrefix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = if (enableMonitoring) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: 'log-${solutionPrefix}'
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    skuName: 'PerGB2018'
    dataRetention: 365
    diagnosticSettings: [{ useThisWorkspace: true }]
  }
}

// ========== Application Insights ========== //
// WAF best practices for Application Insights: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/application-insights
// Application Insights configuration defaults
var applicationInsightsResourceName = 'appi-${solutionPrefix}'
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (enableMonitoring) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    location: solutionLocation
    enableTelemetry: enableTelemetry
    tags: tags
    retentionInDays: 365
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
  }
}

// ========== User assigned identity Web Site ========== //
// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access

// ========== Network Security Groups ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
var networkSecurityGroupBackendResourceName = 'nsg-backend-${solutionPrefix}'
module networkSecurityGroupBackend 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupBackendResourceName}', 64)
  params: {
    name: networkSecurityGroupBackendResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      // {
      //   name: 'DenySshRdpOutbound' //Azure Bastion
      //   properties: {
      //     priority: 200
      //     access: 'Deny'
      //     protocol: '*'
      //     direction: 'Outbound'
      //     sourceAddressPrefix: 'VirtualNetwork'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRanges: [
      //       '3389'
      //       '22'
      //     ]
      //   }
      // }
    ]
  }
}

var networkSecurityGroupContainersResourceName = 'nsg-containers-${solutionPrefix}'
module networkSecurityGroupContainers 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupContainersResourceName}', 64)
  params: {
    name: networkSecurityGroupContainersResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      // {
      //   name: 'DenySshRdpOutbound' //Azure Bastion
      //   properties: {
      //     priority: 200
      //     access: 'Deny'
      //     protocol: '*'
      //     direction: 'Outbound'
      //     sourceAddressPrefix: 'VirtualNetwork'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRanges: [
      //       '3389'
      //       '22'
      //     ]
      //   }
      // }
    ]
  }
}

var networkSecurityGroupBastionResourceName = 'nsg-bastion-${solutionPrefix}'
module networkSecurityGroupBastion 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupBastionResourceName}', 64)
  params: {
    name: networkSecurityGroupBastionResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowGatewayManagerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'GatewayManager'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowLoadBalancerInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationPortRange: '443'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowSshRdpOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationPortRange: '443'
          destinationAddressPrefix: 'AzureCloud'
          access: 'Allow'
          priority: 110
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowBastionHostCommunicationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '80'
            '443'
          ]
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
        }
      }
      {
        name: 'DenyAllOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 1000
          direction: 'Outbound'
        }
      }
    ]
  }
}

var networkSecurityGroupAdministrationResourceName = 'nsg-administration-${solutionPrefix}'
module networkSecurityGroupAdministration 'br/public:avm/res/network/network-security-group:0.5.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupAdministrationResourceName}', 64)
  params: {
    name: networkSecurityGroupAdministrationResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    securityRules: [
      // {
      //   name: 'DenySshRdpOutbound' //Azure Bastion
      //   properties: {
      //     priority: 200
      //     access: 'Deny'
      //     protocol: '*'
      //     direction: 'Outbound'
      //     sourceAddressPrefix: 'VirtualNetwork'
      //     sourcePortRange: '*'
      //     destinationAddressPrefix: '*'
      //     destinationPortRanges: [
      //       '3389'
      //       '22'
      //     ]
      //   }
      // }
    ]
  }
}

// ========== Virtual Network ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
var virtualNetworkResourceName = 'vnet-${solutionPrefix}'
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = if (enablePrivateNetworking) {
  name: take('avm.res.network.virtual-network.${virtualNetworkResourceName}', 64)
  params: {
    name: virtualNetworkResourceName
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: ['10.0.0.0/8']
    subnets: [
      {
        name: 'backend'
        addressPrefix: '10.0.0.0/27'
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        networkSecurityGroupResourceId: networkSecurityGroupBackend.outputs.resourceId
      }
      {
        name: 'administration'
        addressPrefix: '10.0.0.32/27'
        networkSecurityGroupResourceId: networkSecurityGroupAdministration.outputs.resourceId
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        //natGatewayResourceId: natGateway.outputs.resourceId
      }
      {
        // For Azure Bastion resources deployed on or after November 2, 2021, the minimum AzureBastionSubnet size is /26 or larger (/25, /24, etc.).
        // https://learn.microsoft.com/en-us/azure/bastion/configuration-settings#subnet
        name: 'AzureBastionSubnet' //This exact name is required for Azure Bastion
        addressPrefix: '10.0.0.64/26'
        networkSecurityGroupResourceId: networkSecurityGroupBastion.outputs.resourceId
      }
      {
        // Subnet IP address limitation: only class B and C are supported
        // https://learn.microsoft.com/en-us/azure/ai-services/agents/how-to/virtual-networks
        name: 'ai-foundry-agents' //This exact name is required for Azure Bastion
        addressPrefix: '10.0.1.0/24'
        //networkSecurityGroupResourceId: networkSecurityGroupBastion.outputs.resourceId
        delegation: 'Microsoft.App/environments'
      }
      {
        // If you use your own vnw, you need to provide a subnet that is dedicated exclusively to the Container App environment you deploy. This subnet isn't available to other services
        // https://learn.microsoft.com/en-us/azure/container-apps/networking?tabs=workload-profiles-env%2Cazure-cli#custom-vnw-configuration
        name: 'containers'
        addressPrefix: '10.0.2.0/23' //subnet of size /23 is required for container app
        //defaultOutboundAccess: false TODO: check this configuration for a more restricted outbound access
        delegation: 'Microsoft.App/environments'
        networkSecurityGroupResourceId: networkSecurityGroupContainers.outputs.resourceId
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
  }
}
var bastionResourceName = 'bas-${solutionPrefix}'

// ========== Bastion host ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
module bastionHost 'br/public:avm/res/network/bastion-host:0.6.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.bastion-host.${bastionResourceName}', 64)
  params: {
    name: bastionResourceName
    location: solutionLocation
    skuName: 'Standard'
    enableTelemetry: enableTelemetry
    tags: tags
    virtualNetworkResourceId: virtualNetwork.?outputs.?resourceId
    publicIPAddressObject: { name: 'pip-bas${solutionPrefix}' }
    disableCopyPaste: false
    enableFileCopy: false
    enableIpConnect: true
    //enableKerberos: bastionConfiguration.?enableKerberos
    enableShareableLink: true
    //scaleUnits: bastionConfiguration.?scaleUnits
  }
}

// ========== Virtual machine ========== //
// WAF best practices for virtual machines: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-machines
var virtualMachineResourceName = 'vm${solutionPrefix}'
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.15.0' = if (enablePrivateNetworking) {
  name: take('avm.res.compute.virtual-machine.${virtualMachineResourceName}', 64)
  params: {
    name: virtualMachineResourceName
    computerName: take(virtualMachineResourceName, 15)
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    vmSize: 'Standard_D2s_v3'
    adminUsername: virtualMachineAdminUsername
    adminPassword: virtualMachineAdminPassword
    nicConfigurations: [
      {
        name: 'nic-${virtualMachineResourceName}'
        //networkSecurityGroupResourceId: virtualMachineConfiguration.?nicConfigurationConfiguration.networkSecurityGroupResourceId
        //nicSuffix: 'nic-${virtualMachineResourceName}'
        diagnosticSettings: enableMonitoring
          ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
          : null
        ipConfigurations: [
          {
            name: '${virtualMachineResourceName}-nic01-ipconfig01'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
            diagnosticSettings: enableMonitoring
              ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
              : null
          }
        ]
      }
    ]
    imageReference: {
      publisher: 'microsoft-dsvm'
      offer: 'dsvm-win-2022'
      sku: 'winserver-2022'
      version: 'latest'
    }
    osDisk: {
      name: 'osdisk-${virtualMachineResourceName}'
      createOption: 'FromImage'
      managedDisk: {
        storageAccountType: 'Premium_ZRS'
      }
      diskSizeGB: 128
      caching: 'ReadWrite'
    }
    //patchMode: virtualMachineConfiguration.?patchMode
    osType: 'Windows'
    encryptionAtHost: false //The property 'securityProfile.encryptionAtHost' is not valid because the 'Microsoft.Compute/EncryptionAtHost' feature is not enabled for this subscription.
    zone: 0
    extensionAadJoinConfig: {
      enabled: true
      typeHandlerVersion: '1.0'
    }
    // extensionMonitoringAgentConfig: {
    //   enabled: true
    // }
    //    maintenanceConfigurationResourceId: virtualMachineConfiguration.?maintenanceConfigurationResourceId
  }
}

// ========== AI Foundry: AI Services ========== //
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai
var openAiSubResource = 'account'
var openAiPrivateDnsZones = {
  'privatelink.cognitiveservices.azure.com': openAiSubResource
  'privatelink.openai.azure.com': openAiSubResource
  'privatelink.services.ai.azure.com': openAiSubResource
}

module privateDnsZonesAiServices 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in objectKeys(openAiPrivateDnsZones): if (enablePrivateNetworking) {
    name: take(
      'avm.res.network.private-dns-zone.ai-services.${uniqueString(aiFoundryAiServicesResourceName,zone)}.${solutionPrefix}',
      64
    )
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetworkResourceName}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]

// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
var aiFoundryAiServicesResourceName = 'aisa-${solutionPrefix}'
var aiFoundryAIservicesEnabled = true
var aiFoundryAiServicesModelDeployment = {
  format: 'OpenAI'
  name: 'gpt-4o'
  version: '2024-08-06'
  sku: {
    name: 'GlobalStandard'
    //Currently the capacity is set to 140 for optimal performance.
    capacity: 140
  }
  raiPolicyName: 'Microsoft.Default'
}

module aiFoundryAiServices 'modules/ai-services.bicep' = if (aiFoundryAIservicesEnabled) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    tags: tags
    location: azureOpenAILocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    sku: 'S0'
    kind: 'AIServices'
    disableLocalAuth: true //Should be set to true for WAF aligned configuration
    customSubDomainName: aiFoundryAiServicesResourceName
    apiProperties: {
      //staticsEnabled: false
    }
    networkAcls: {
      defaultAction: 'Allow'
      virtualNetworkRules: []
      ipRules: []
    }
    managedIdentities: { systemAssigned: true }
    networkInjectionSubnetResourceId: enablePrivateNetworking ? virtualNetwork.?outputs.?subnetResourceIds[3] : null //This is the subnet for the AI Foundry Agents
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    //publicNetworkAccess: 'Enabled' //TODO: connection via private endpoint is not working from containers network. Change this when fixed
    privateEndpoints: enablePrivateNetworking
      ? ([
          {
            name: 'pep-${aiFoundryAiServicesResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiServicesResourceName}'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: map(objectKeys(openAiPrivateDnsZones), zone => {
                name: replace(zone, '.', '-')
                privateDnsZoneResourceId: resourceId('Microsoft.Network/privateDnsZones', zone)
              })
            }
          }
        ])
      : []
    roleAssignments: [
      {
        principalId: containerApp.outputs.?systemAssignedMIPrincipalId!
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      }
    ]
    deployments: [
      {
        name: aiFoundryAiServicesModelDeployment.name
        model: {
          format: aiFoundryAiServicesModelDeployment.format
          name: aiFoundryAiServicesModelDeployment.name
          version: aiFoundryAiServicesModelDeployment.version
        }
        raiPolicyName: aiFoundryAiServicesModelDeployment.raiPolicyName
        sku: {
          name: aiFoundryAiServicesModelDeployment.sku.name
          capacity: aiFoundryAiServicesModelDeployment.sku.capacity
        }
      }
    ]
  }
}

var roleAssignmentAiHubAiProjectAzureAiDeveloper = '${aiFoundryAiHubResourceName}-${aiFoundryAiProjectName}-CognitiveServicesOpenAIUser'
module resourceRoleAssignmentAiHubAiProjectAzureAiDeveloper 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take('avm.ptn.authorization.resource-role-assignment.${roleAssignmentAiHubAiProjectAzureAiDeveloper}', 64)
  params: {
    roleName: 'Azure AI Developer'
    roleDefinitionId: '64702f94-c441-49e6-a78b-ef80e0188fee'
    principalId: aiFoundryAiHub.outputs.?systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiProject.outputs.?resourceId
    enableTelemetry: enableTelemetry
  }
}

// AI Foundry: storage account
// WAF best practices for Azure Blob Storage: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-blob-storage
var storageAccountPrivateDnsZones = {
  'privatelink.blob.${environment().suffixes.storage}': 'blob'
  'privatelink.file.${environment().suffixes.storage}': 'file'
}

module privateDnsZonesAiFoundryStorageAccount 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in objectKeys(storageAccountPrivateDnsZones): if (enablePrivateNetworking) {
    name: take(
      'avm.res.network.private-dns-zone.storage-account.${uniqueString(aiFoundryStorageAccountResourceName,zone)}.${solutionPrefix}',
      64
    )
    params: {
      name: zone
      tags: tags
      enableTelemetry: enableTelemetry
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetworkResourceName}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]
var aiFoundryStorageAccountResourceName = replace('sthub${solutionPrefix}', '-', '')

module aiFoundryStorageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: take('avm.res.storage.storage-account.${aiFoundryStorageAccountResourceName}', 64)
  dependsOn: [
    privateDnsZonesAiFoundryStorageAccount
  ]
  params: {
    name: aiFoundryStorageAccountResourceName
    location: azureOpenAILocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    skuName: 'Standard_ZRS'
    allowSharedKeyAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    blobServices: {
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
      diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    }
    publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    allowBlobPublicAccess: enablePrivateNetworking ? false : true
    privateEndpoints: enablePrivateNetworking
      ? map(items(storageAccountPrivateDnsZones), zone => {
          name: 'pep-${zone.value}-${aiFoundryStorageAccountResourceName}'
          customNetworkInterfaceName: 'nic-${zone.value}-${aiFoundryStorageAccountResourceName}'
          service: zone.value
          subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0] ?? ''
          privateDnsZoneResourceIds: [resourceId('Microsoft.Network/privateDnsZones', zone.key)]
        })
      : null
    roleAssignments: [
      {
        principalId: containerApp.?outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
      {
        principalId: containerApp.?outputs.?systemAssignedMIPrincipalId!
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd' //'Storage File Privileged Contributor'
      }
    ]
  }
}

// AI Foundry: AI Hub
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai
var mlTargetSubResource = 'amlworkspace'
var mlPrivateDnsZones = {
  'privatelink.api.azureml.ms': mlTargetSubResource
  'privatelink.notebooks.azure.net': mlTargetSubResource
}
module privateDnsZonesAiFoundryWorkspaceHub 'br/public:avm/res/network/private-dns-zone:0.7.1' = [
  for zone in objectKeys(mlPrivateDnsZones): if (enablePrivateNetworking) {
    name: take(
      'avm.res.network.private-dns-zone.ai-hub.${uniqueString(aiFoundryAiHubResourceName,zone)}.${solutionPrefix}',
      64
    )
    params: {
      name: zone
      enableTelemetry: enableTelemetry
      tags: tags
      virtualNetworkLinks: [
        {
          name: take('vnetlink-${virtualNetworkResourceName}-${split(zone, '.')[1]}', 80)
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]
var aiFoundryAiHubResourceName = 'aih-${solutionPrefix}'
module aiFoundryAiHub 'modules/ai-hub.bicep' = {
  name: take('module.ai-hub.${aiFoundryAiHubResourceName}', 64)
  dependsOn: [
    privateDnsZonesAiFoundryWorkspaceHub
  ]
  params: {
    name: aiFoundryAiHubResourceName
    location: azureOpenAILocation
    tags: tags
    sku: 'Basic'
    aiFoundryAiServicesName: aiFoundryAiServices.outputs.name
    applicationInsightsResourceId: enableMonitoring ? applicationInsights.outputs.resourceId : null
    enableTelemetry: enableTelemetry
    enableMonitoring: enableMonitoring
    logAnalyticsWorkspaceResourceId: enableMonitoring ? logAnalyticsWorkspace.outputs.resourceId : null
    storageAccountResourceId: aiFoundryStorageAccount.outputs.resourceId
    virtualNetworkEnabled: enablePrivateNetworking
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${aiFoundryAiHubResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiHubResourceName}'
            service: mlTargetSubResource
            subnetResourceId: enablePrivateNetworking ? virtualNetwork.?outputs.?subnetResourceIds[0] : null
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: map(objectKeys(mlPrivateDnsZones), zone => {
                name: replace(zone, '.', '-')
                privateDnsZoneResourceId: resourceId('Microsoft.Network/privateDnsZones', zone)
              })
            }
          }
        ]
      : []
  }
}

// AI Foundry: AI Project
// WAF best practices for Open AI: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-openai
var aiFoundryAiProjectName = 'aipj-${solutionPrefix}'

module aiFoundryAiProject 'br/public:avm/res/machine-learning-services/workspace:0.12.1' = {
  name: take('avm.res.machine-learning-services.workspace.${aiFoundryAiProjectName}', 64)
  params: {
    name: aiFoundryAiProjectName
    location: azureOpenAILocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    sku: 'Basic'
    kind: 'Project'
    hubResourceId: aiFoundryAiHub.outputs.resourceId
    managedIdentities: { systemAssigned: true }
    roleAssignments: [
      {
        principalId: containerApp.outputs.?systemAssignedMIPrincipalId!
        // Assigning the role with the role name instead of the role ID freezes the deployment at this point
        roleDefinitionIdOrName: '64702f94-c441-49e6-a78b-ef80e0188fee' //'Azure AI Developer'
      }
    ]
  }
}

var roleAssignmentAiProjectAiServicesCognitiveServicesOpenAIUser = '${aiFoundryAiProjectName}-${aiFoundryAiHubResourceName}-CognitiveServicesOpenAIUser'
module resourceRoleAssignmentAiProjectAiServicesCognitiveServicesOpenAIUser 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: take(
    'avm.ptn.authorization.resource-role-assignment.${roleAssignmentAiProjectAiServicesCognitiveServicesOpenAIUser}',
    64
  )
  params: {
    roleName: 'Cognitive Services OpenAI User'
    roleDefinitionId: '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'
    principalId: aiFoundryAiProject.outputs.?systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiServices.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

// ========== Cosmos DB ========== //
// WAF best practices for Cosmos DB: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/cosmos-db
module privateDnsZonesCosmosDb 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (enablePrivateNetworking) {
  name: take('avm.res.network.private-dns-zone.cosmos-db.${solutionPrefix}', 64)
  params: {
    name: 'privatelink.documents.azure.com'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        name: take('vnetlink-${virtualNetworkResourceName}-documents', 80)
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
      }
    ]
    tags: tags
  }
}

var cosmosDbResourceName = 'cosmos-${solutionPrefix}'
var cosmosDbDatabaseName = 'macae'
var cosmosDbDatabaseMemoryContainerName = 'memory'

//TODO: update to latest version of AVM module
module cosmosDb 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: 'cosmos-${solutionPrefix}'
    location: solutionLocation
    tags: tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: enablePrivateNetworking ? 'Disabled' : 'Enabled'
    }
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-${cosmosDbResourceName}'
            customNetworkInterfaceName: 'nic-${cosmosDbResourceName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [{ privateDnsZoneResourceId: privateDnsZonesCosmosDb.outputs.resourceId }]
            }
            service: 'Sql'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
          }
        ]
      : []
    sqlDatabases: [
      {
        name: cosmosDbDatabaseName
        containers: [
          {
            name: cosmosDbDatabaseMemoryContainerName
            paths: [
              '/session_id'
            ]
            kind: 'Hash'
            version: 2
          }
        ]
      }
    ]
    failoverLocations: [
      {
        locationName: solutionLocation
        failoverPriority: 0
      }
    ]
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    dataPlaneRoleDefinitions: [
      {
        // Replace this with built-in role definition Cosmos DB Built-in Data Contributor: https://docs.azure.cn/en-us/cosmos-db/nosql/security/reference-data-plane-roles#cosmos-db-built-in-data-contributor
        roleName: 'Cosmos DB SQL Data Contributor'
        //name: 'cosmos-db-sql-data-contributor'
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        assignments: [
          {
            principalId: containerApp.outputs.?systemAssignedMIPrincipalId!
          }
        ]
      }
    ]
  }
}

// ========== Backend Container App Environment ========== //
// WAF best practices for container apps: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-container-apps
var containerAppEnvironmentResourceName = 'cae-${solutionPrefix}'
module containerAppEnvironment 'modules/container-app-environment.bicep' = {
  name: take('module.container-app-environment.${containerAppEnvironmentResourceName}', 64)
  params: {
    name: containerAppEnvironmentResourceName
    tags: tags
    location: solutionLocation
    logAnalyticsResourceName: enableMonitoring ? logAnalyticsWorkspace.outputs.name : null
    publicNetworkAccess: 'Enabled'
    zoneRedundant: enablePrivateNetworking ? true : false
    applicationInsightsConnectionString: enableMonitoring ? applicationInsights.outputs.connectionString : null
    enableTelemetry: enableTelemetry
    subnetResourceId: enablePrivateNetworking ? virtualNetwork.?outputs.?subnetResourceIds[4] ?? '' : ''
    enableMonitoring: enableMonitoring
    //aspireDashboardEnabled: !enablePrivateNetworking
    // vnetConfiguration: enablePrivateNetworking
    //   ? {
    //       internal: false
    //       infrastructureSubnetId: containerAppEnvironmentConfiguration.?subnetResourceId ?? virtualNetwork.?outputs.?subnetResourceIds[3] ?? ''
    //     }
    //   : {}
  }
}

// ========== Backend Container App Service ========== //
// WAF best practices for container apps: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-container-apps
var containerAppResourceName = 'ca-${solutionPrefix}'
module containerApp 'br/public:avm/res/app/container-app:0.17.0' = {
  name: take('avm.res.app.container-app.${containerAppResourceName}', 64)
  params: {
    name: containerAppResourceName
    tags: tags
    location: solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppEnvironment.outputs.resourceId
    managedIdentities: {
      systemAssigned: true //Replace with user assigned identity
      //userAssignedResourceIds: [userAssignedIdentityAIHub.outputs.resourceId]
    }
    ingressTargetPort: 8000
    ingressExternal: true
    activeRevisionsMode: 'Single'
    corsPolicy: {
      allowedOrigins: [
        'https://${webSiteName}.azurewebsites.net'
        'http://${webSiteName}.azurewebsites.net'
      ]
    }
    scaleSettings: {
      //TODO: Make maxReplicas and minReplicas parameterized
      maxReplicas: 1
      minReplicas: 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: '100'
            }
          }
        }
      ]
    }
    containers: [
      {
        name: 'backend'
        image: '${containerRegistryHostname}/macaebackend:${backendContainerImageTag}'
        resources: {
          //TODO: Make cpu and memory parameterized
          cpu: '2.0'
          memory: '4.0Gi'
        }
        env: [
          {
            name: 'COSMOSDB_ENDPOINT'
            value: 'https://${cosmosDbResourceName}.documents.azure.com:443/'
          }
          {
            name: 'COSMOSDB_DATABASE'
            value: cosmosDbDatabaseName
          }
          {
            name: 'COSMOSDB_CONTAINER'
            value: cosmosDbDatabaseMemoryContainerName
          }
          {
            name: 'AZURE_OPENAI_ENDPOINT'
            value: 'https://${aiFoundryAiServicesResourceName}.openai.azure.com/'
          }
          {
            name: 'AZURE_OPENAI_MODEL_NAME'
            value: aiFoundryAiServicesModelDeployment.name
          }
          {
            name: 'AZURE_OPENAI_DEPLOYMENT_NAME'
            value: aiFoundryAiServicesModelDeployment.name
          }
          {
            name: 'AZURE_OPENAI_API_VERSION'
            value: '2025-01-01-preview' //TODO: set parameter/variable
          }
          {
            name: 'APPLICATIONINSIGHTS_INSTRUMENTATION_KEY'
            value: enableMonitoring ? applicationInsights.outputs.instrumentationKey : ''
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: enableMonitoring ? applicationInsights.outputs.connectionString : ''
          }
          {
            name: 'AZURE_AI_AGENT_PROJECT_CONNECTION_STRING'
            value: '${toLower(replace(azureOpenAILocation,' ',''))}.api.azureml.ms;${subscription().subscriptionId};${resourceGroup().name};${aiFoundryAiProjectName}'
            //Location should be the AI Foundry AI Project location
          }
          {
            name: 'AZURE_AI_SUBSCRIPTION_ID'
            value: subscription().subscriptionId
          }
          {
            name: 'AZURE_AI_RESOURCE_GROUP'
            value: resourceGroup().name
          }
          {
            name: 'AZURE_AI_PROJECT_NAME'
            value: aiFoundryAiProjectName
          }
          {
            name: 'FRONTEND_SITE_NAME'
            value: 'https://${webSiteName}.azurewebsites.net'
          }
        ]
      }
    ]
  }
}

// ========== Frontend server farm ========== //
// WAF best practices for web app service: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
var webServerFarmResourceName = 'asp-${solutionPrefix}'
module webServerFarm 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: tags
    location: solutionLocation
    skuName: 'P1v3'
    skuCapacity: 3
    reserved: true
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    kind: 'linux'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
    enableTelemetry: enableTelemetry
  }
}

// ========== Frontend web site ========== //
// WAF best practices for web app service: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps

var webSiteName = 'app-${solutionPrefix}'
// module webSite 'br/public:avm/res/web/site:0.16.0' = {
//   name: take('avm.res.web.site.${webSiteName}', 64)
//   params: {
//     name: webSiteName
//     tags: tags
//     location: solutionLocation
//     kind: 'app,linux,container'
//     enableTelemetry: enableTelemetry
//     serverFarmResourceId: webServerFarm.?outputs.resourceId
//     diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
//     publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
//     siteConfig: {
//       linuxFxVersion: 'DOCKER|${containerRegistryHostname}/macaefrontend:${frontendContainerImageTag}'
//     }
//     configs: [
//       {
//         name: 'appsettings'
//         applicationInsightResourceId: applicationInsights.outputs.resourceId
//         properties: {
//           SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
//           DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryHostname}'
//           WEBSITES_PORT: '3000'
//           WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
//           BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
//           AUTH_ENABLED: 'false'
//         }
//       }
//     ]
//   }
// }

module webSite 'modules/web-sites.bicep' = {
  name: take('module.web-sites.${webSiteName}', 64)
  params: {
    name: webSiteName
    tags: tags
    location: solutionLocation
    kind: 'app,linux,container'
    serverFarmResourceId: webServerFarm.?outputs.resourceId
    diagnosticSettings: enableMonitoring ? [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }] : null
    publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryHostname}/macaefrontend:${frontendContainerImageTag}'
    }
    configs: [
      {
        name: 'appsettings'
        applicationInsightResourceId: enableMonitoring ? applicationInsights.outputs.resourceId : null
        properties: {
          SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
          DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryHostname}'
          WEBSITES_PORT: '3000'
          WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
          BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
          AUTH_ENABLED: 'false'
        }
      }
    ]
  }
}
// ============ //
// Outputs      //
// ============ //

// Add your outputs here

@description('The resource group the resources were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The default url of the website to connect to the Multi-Agent Custom Automation Engine solution.')
output webSiteDefaultHostname string = webSite.outputs.defaultHostname

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//
