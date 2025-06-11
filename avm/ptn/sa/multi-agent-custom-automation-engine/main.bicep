metadata name = 'Multi-Agent Custom Automation Engine'
metadata description = 'This module contains the resources required to deploy the Multi-Agent Custom Automation Engine solution accelerator for both Sandbox environments and WAF aligned environments.'

@description('Optional. The prefix to add in the default names given to all deployed Azure resources.')
@maxLength(19)
param solutionPrefix string = 'macae${uniqueString(deployer().objectId, deployer().tenantId, subscription().subscriptionId, resourceGroup().id)}'

@description('Required. Location for all Resources except AI Foundry.')
param solutionLocation string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// Restricting deployment to only supported Azure OpenAI regions validated with GPT-4o model
@allowed(['australiaeast', 'eastus2', 'francecentral', 'japaneast', 'norwayeast', 'swedencentral', 'uksouth', 'westus'])
@description('Azure OpenAI Location')
param azureOpenAILocation string

// @description('Set this if you want to deploy to a different region than the resource group. Otherwise, it will use the resource group location by default.')
// param AZURE_LOCATION string=''
// param solutionLocation string = empty(AZURE_LOCATION) ? resourceGroup().location

@description('Optional. The tags to apply to all deployed Azure resources.')
param tags object = {
  app: solutionPrefix
  location: solutionLocation
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Log Analytics Workspace resource.')
param logAnalyticsWorkspaceConfiguration logAnalyticsWorkspaceConfigurationType = {
  enabled: true
  name: 'log-${solutionPrefix}'
  location: solutionLocation
  sku: 'PerGB2018'
  tags: tags
  dataRetentionInDays: 365
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Application Insights resource.')
param applicationInsightsConfiguration applicationInsightsConfigurationType = {
  enabled: true
  name: 'appi-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  retentionInDays: 365
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Managed Identity resource.')
param userAssignedManagedIdentityConfiguration userAssignedManagedIdentityType = {
  enabled: true
  name: 'id-${solutionPrefix}'
  location: solutionLocation
  tags: tags
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the backend subnet.')
param networkSecurityGroupBackendConfiguration networkSecurityGroupConfigurationType = {
  enabled: true
  name: 'nsg-backend-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  securityRules: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the containers subnet.')
param networkSecurityGroupContainersConfiguration networkSecurityGroupConfigurationType = {
  enabled: true
  name: 'nsg-containers-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  securityRules: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the Bastion subnet.')
param networkSecurityGroupBastionConfiguration networkSecurityGroupConfigurationType = {
  enabled: true
  name: 'nsg-bastion-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  securityRules: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine Network Security Group resource for the administration subnet.')
param networkSecurityGroupAdministrationConfiguration networkSecurityGroupConfigurationType = {
  enabled: true
  name: 'nsg-administration-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  securityRules: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine virtual network resource.')
param virtualNetworkConfiguration virtualNetworkConfigurationType = {
  enabled: true
  name: 'vnet-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  addressPrefixes: null //Default value set on module configuration
  subnets: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Multi-Agent Custom Automation Engine bastion resource.')
param bastionConfiguration bastionConfigurationType = {
  enabled: true
  name: 'bas-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  sku: 'Standard'
  virtualNetworkResourceId: null //Default value set on module configuration
  publicIpResourceName: 'pip-bas${solutionPrefix}'
}

@description('Optional. Configuration for the Windows virtual machine.')
param virtualMachineConfiguration virtualMachineConfigurationType = {
  enabled: true
  name: 'vm${solutionPrefix}'
  location: solutionLocation
  tags: tags
  adminUsername: 'adminuser'
  adminPassword: guid(solutionPrefix, subscription().subscriptionId)
  vmSize: 'Standard_D2s_v3'
  subnetResourceId: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the AI Foundry AI Services resource.')
param aiFoundryAiServicesConfiguration aiServicesConfigurationType = {
  enabled: true
  name: 'aisa-${solutionPrefix}'
  location: azureOpenAILocation
  sku: 'S0'
  deployments: null //Default value set on module configuration
  subnetResourceId: null //Default value set on module configuration
  modelCapacity: 140
}

@description('Optional. The configuration to apply for the AI Foundry Storage Account resource.')
param aiFoundryStorageAccountConfiguration storageAccountType = {
  enabled: true
  name: replace('sthub${solutionPrefix}', '-', '')
  location: azureOpenAILocation
  tags: tags
  sku: 'Standard_ZRS'
  subnetResourceId: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the AI Foundry AI Hub resource.')
param aiFoundryAiHubConfiguration aiHubType = {
  enabled: true
  name: 'aih-${solutionPrefix}'
  location: azureOpenAILocation
  sku: 'Basic'
  tags: tags
  subnetResourceId: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the AI Foundry AI Project resource.')
param aiFoundryAiProjectConfiguration aiProjectConfigurationType = {
  enabled: true
  name: 'aihb-${solutionPrefix}'
  location: azureOpenAILocation
  sku: 'Basic'
  tags: tags
}

@description('Optional. The configuration to apply for the Cosmos DB Account resource.')
param cosmosDbAccountConfiguration cosmosDbAccountConfigurationType = {
  enabled: true
  name: 'cosmos-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  subnetResourceId: null //Default value set on module configuration
  sqlDatabases: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Container App Environment resource.')
param containerAppEnvironmentConfiguration containerAppEnvironmentConfigurationType = {
  enabled: true
  name: 'cae-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  subnetResourceId: null //Default value set on module configuration
}

@description('Optional. The configuration to apply for the Container App resource.')
param containerAppConfiguration containerAppConfigurationType = {
  enabled: true
  name: 'ca-${solutionPrefix}'
  location: solutionLocation
  tags: tags
  environmentResourceId: null //Default value set on module configuration
  concurrentRequests: '100'
  containerCpu: '2.0'
  containerMemory: '4.0Gi'
  containerImageRegistryDomain: 'biabcontainerreg.azurecr.io'
  containerImageName: 'macaebackend'
  containerImageTag: 'latest'
  containerName: 'backend'
  ingressTargetPort: 8000
  maxReplicas: 1
  minReplicas: 1
}

@description('Optional. The configuration to apply for the Web Server Farm resource.')
param webServerFarmConfiguration webServerFarmConfigurationType = {
  enabled: true
  name: 'asp-${solutionPrefix}'
  location: solutionLocation
  skuName: 'P1v3'
  skuCapacity: 3
  tags: tags
}

@description('Optional. The configuration to apply for the Web Server Farm resource.')
param webSiteConfiguration webSiteConfigurationType = {
  enabled: true
  name: 'app-${solutionPrefix}'
  location: solutionLocation
  containerImageRegistryDomain: 'biabcontainerreg.azurecr.io'
  containerImageName: 'macaefrontend'
  containerImageTag: 'latest'
  containerName: 'backend'
  tags: tags
  environmentResourceId: null //Default value set on module configuration
}

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

/* #disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
} */

// ========== Log Analytics Workspace ========== //
// WAF best practices for Log Analytics: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-log-analytics
// Log Analytics configuration defaults
var logAnalyticsWorkspaceEnabled = logAnalyticsWorkspaceConfiguration.?enabled ?? true
var logAnalyticsWorkspaceResourceName = logAnalyticsWorkspaceConfiguration.?name ?? 'log-${solutionPrefix}'
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = if (logAnalyticsWorkspaceEnabled) {
  name: take('avm.res.operational-insights.workspace.${logAnalyticsWorkspaceResourceName}', 64)
  params: {
    name: logAnalyticsWorkspaceResourceName
    tags: logAnalyticsWorkspaceConfiguration.?tags ?? tags
    location: logAnalyticsWorkspaceConfiguration.?location ?? solutionLocation
    enableTelemetry: enableTelemetry
    skuName: logAnalyticsWorkspaceConfiguration.?sku ?? 'PerGB2018'
    dataRetention: logAnalyticsWorkspaceConfiguration.?dataRetentionInDays ?? 365
    diagnosticSettings: [{ useThisWorkspace: true }]
  }
}

// ========== Application Insights ========== //
// WAF best practices for Application Insights: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/application-insights
// Application Insights configuration defaults
var applicationInsightsEnabled = applicationInsightsConfiguration.?enabled ?? true
var applicationInsightsResourceName = applicationInsightsConfiguration.?name ?? 'appi-${solutionPrefix}'
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = if (applicationInsightsEnabled) {
  name: take('avm.res.insights.component.${applicationInsightsResourceName}', 64)
  params: {
    name: applicationInsightsResourceName
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    location: applicationInsightsConfiguration.?location ?? solutionLocation
    enableTelemetry: enableTelemetry
    tags: applicationInsightsConfiguration.?tags ?? tags
    retentionInDays: applicationInsightsConfiguration.?retentionInDays ?? 365
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    kind: 'web'
    disableIpMasking: false
    flowType: 'Bluefield'
  }
}

// ========== User assigned identity Web Site ========== //
// WAF best practices for identity and access management: https://learn.microsoft.com/en-us/azure/well-architected/security/identity-access
var userAssignedManagedIdentityEnabled = userAssignedManagedIdentityConfiguration.?enabled ?? true
var userAssignedManagedIdentityResourceName = userAssignedManagedIdentityConfiguration.?name ?? 'id-${solutionPrefix}'
module userAssignedIdentityAIHub 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = if (userAssignedManagedIdentityEnabled) {
  name: take('avm.res.managed-identity.user-assigned-identity.${userAssignedManagedIdentityResourceName}', 64)
  params: {
    name: userAssignedManagedIdentityResourceName
    tags: userAssignedManagedIdentityConfiguration.?tags ?? tags
    location: userAssignedManagedIdentityConfiguration.?location ?? solutionLocation
    enableTelemetry: enableTelemetry
  }
}

// ========== Network Security Groups ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
var networkSecurityGroupBackendEnabled = networkSecurityGroupBackendConfiguration.?enabled ?? true
var networkSecurityGroupBackendResourceName = networkSecurityGroupBackendConfiguration.?name ?? 'nsg-backend-${solutionPrefix}'
module networkSecurityGroupBackend 'br/public:avm/res/network/network-security-group:0.5.1' = if (virtualNetworkEnabled && networkSecurityGroupBackendEnabled) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupBackendResourceName}', 64)
  params: {
    name: networkSecurityGroupBackendResourceName
    location: networkSecurityGroupBackendConfiguration.?location ?? solutionLocation
    tags: networkSecurityGroupBackendConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    securityRules: networkSecurityGroupBackendConfiguration.?securityRules ?? [
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

var networkSecurityGroupContainersEnabled = networkSecurityGroupContainersConfiguration.?enabled ?? true
var networkSecurityGroupContainersResourceName = networkSecurityGroupContainersConfiguration.?name ?? 'nsg-containers-${solutionPrefix}'
module networkSecurityGroupContainers 'br/public:avm/res/network/network-security-group:0.5.1' = if (virtualNetworkEnabled && networkSecurityGroupContainersEnabled) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupContainersResourceName}', 64)
  params: {
    name: networkSecurityGroupContainersResourceName
    location: networkSecurityGroupContainersConfiguration.?location ?? solutionLocation
    tags: networkSecurityGroupContainersConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    securityRules: networkSecurityGroupContainersConfiguration.?securityRules ?? [
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

var networkSecurityGroupBastionEnabled = networkSecurityGroupBastionConfiguration.?enabled ?? true
var networkSecurityGroupBastionResourceName = networkSecurityGroupBastionConfiguration.?name ?? 'nsg-bastion-${solutionPrefix}'
module networkSecurityGroupBastion 'br/public:avm/res/network/network-security-group:0.5.1' = if (virtualNetworkEnabled && networkSecurityGroupBastionEnabled) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupBastionResourceName}', 64)
  params: {
    name: networkSecurityGroupBastionResourceName
    location: networkSecurityGroupBastionConfiguration.?location ?? solutionLocation
    tags: networkSecurityGroupBastionConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    securityRules: networkSecurityGroupBastionConfiguration.?securityRules ?? [
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

var networkSecurityGroupAdministrationEnabled = networkSecurityGroupAdministrationConfiguration.?enabled ?? true
var networkSecurityGroupAdministrationResourceName = networkSecurityGroupAdministrationConfiguration.?name ?? 'nsg-administration-${solutionPrefix}'
module networkSecurityGroupAdministration 'br/public:avm/res/network/network-security-group:0.5.1' = if (virtualNetworkEnabled && networkSecurityGroupAdministrationEnabled) {
  name: take('avm.res.network.network-security-group.${networkSecurityGroupAdministrationResourceName}', 64)
  params: {
    name: networkSecurityGroupAdministrationResourceName
    location: networkSecurityGroupAdministrationConfiguration.?location ?? solutionLocation
    tags: networkSecurityGroupAdministrationConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    securityRules: networkSecurityGroupAdministrationConfiguration.?securityRules ?? [
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
var virtualNetworkEnabled = virtualNetworkConfiguration.?enabled ?? true
var virtualNetworkResourceName = virtualNetworkConfiguration.?name ?? 'vnet-${solutionPrefix}'
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = if (virtualNetworkEnabled) {
  name: take('avm.res.network.virtual-network.${virtualNetworkResourceName}', 64)
  params: {
    name: virtualNetworkResourceName
    location: virtualNetworkConfiguration.?location ?? solutionLocation
    tags: virtualNetworkConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    addressPrefixes: virtualNetworkConfiguration.?addressPrefixes ?? ['10.0.0.0/8']
    subnets: virtualNetworkConfiguration.?subnets ?? [
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
var bastionEnabled = bastionConfiguration.?enabled ?? true
var bastionResourceName = bastionConfiguration.?name ?? 'bas-${solutionPrefix}'

// ========== Bastion host ========== //
// WAF best practices for virtual networks: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/virtual-network
// WAF recommendations for networking and connectivity: https://learn.microsoft.com/en-us/azure/well-architected/security/networking
module bastionHost 'br/public:avm/res/network/bastion-host:0.6.1' = if (virtualNetworkEnabled && bastionEnabled) {
  name: take('avm.res.network.bastion-host.${bastionResourceName}', 64)
  params: {
    name: bastionResourceName
    location: bastionConfiguration.?location ?? solutionLocation
    skuName: bastionConfiguration.?sku ?? 'Standard'
    enableTelemetry: enableTelemetry
    tags: bastionConfiguration.?tags ?? tags
    virtualNetworkResourceId: bastionConfiguration.?virtualNetworkResourceId ?? virtualNetwork.?outputs.?resourceId
    publicIPAddressObject: {
      name: bastionConfiguration.?publicIpResourceName ?? 'pip-bas${solutionPrefix}'
    }
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
var virtualMachineEnabled = virtualMachineConfiguration.?enabled ?? true
var virtualMachineResourceName = virtualMachineConfiguration.?name ?? 'vm${solutionPrefix}'
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.13.0' = if (virtualNetworkEnabled && virtualMachineEnabled) {
  name: take('avm.res.compute.virtual-machine.${virtualMachineResourceName}', 64)
  params: {
    name: virtualMachineResourceName
    computerName: take(virtualMachineResourceName, 15)
    location: virtualMachineConfiguration.?location ?? solutionLocation
    tags: virtualMachineConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    vmSize: virtualMachineConfiguration.?vmSize ?? 'Standard_D2s_v3'
    adminUsername: virtualMachineConfiguration.?adminUsername ?? 'adminuser'
    adminPassword: virtualMachineConfiguration.?adminPassword ?? guid(solutionPrefix, subscription().subscriptionId)
    nicConfigurations: [
      {
        name: 'nic-${virtualMachineResourceName}'
        //networkSecurityGroupResourceId: virtualMachineConfiguration.?nicConfigurationConfiguration.networkSecurityGroupResourceId
        //nicSuffix: 'nic-${virtualMachineResourceName}'
        diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
        ipConfigurations: [
          {
            name: '${virtualMachineResourceName}-nic01-ipconfig01'
            subnetResourceId: virtualMachineConfiguration.?subnetResourceId ?? virtualNetwork.outputs.subnetResourceIds[1]
            diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
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
  for zone in objectKeys(openAiPrivateDnsZones): if (virtualNetworkEnabled && aiFoundryAIservicesEnabled) {
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
          name: 'vnetlink-${split(zone, '.')[1]}'
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]

// NOTE: Required version 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' not available in AVM
var aiFoundryAiServicesResourceName = aiFoundryAiServicesConfiguration.?name ?? 'aisa-${solutionPrefix}'
var aiFoundryAIservicesEnabled = aiFoundryAiServicesConfiguration.?enabled ?? true
var aiFoundryAiServicesModelDeployment = {
  format: 'OpenAI'
  name: 'gpt-4o'
  version: '2024-08-06'
  sku: {
    name: 'GlobalStandard'
    //Currently the capacity is set to 140 for optimal performance. 
    capacity: aiFoundryAiServicesConfiguration.?modelCapcity ?? 140
  }
  raiPolicyName: 'Microsoft.Default'
}

module aiFoundryAiServices 'modules/ai-services.bicep' = if (aiFoundryAIservicesEnabled) {
  name: take('avm.res.cognitive-services.account.${aiFoundryAiServicesResourceName}', 64)
  params: {
    name: aiFoundryAiServicesResourceName
    tags: aiFoundryAiServicesConfiguration.?tags ?? tags
    location: aiFoundryAiServicesConfiguration.?location ?? azureOpenAILocation
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    sku: aiFoundryAiServicesConfiguration.?sku ?? 'S0'
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
    networkInjectionSubnetResourceId: virtualNetwork.outputs.subnetResourceIds[3] //This is the subnet for the AI Foundry Agents
    publicNetworkAccess: virtualNetworkEnabled ? 'Disabled' : 'Enabled'
    //publicNetworkAccess: 'Enabled' //TODO: connection via private endpoint is not working from containers network. Change this when fixed
    privateEndpoints: virtualNetworkEnabled
      ? ([
          {
            name: 'pep-${aiFoundryAiServicesResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiServicesResourceName}'
            subnetResourceId: aiFoundryAiServicesConfiguration.?subnetResourceId ?? virtualNetwork.outputs.subnetResourceIds[0]
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
    deployments: aiFoundryAiServicesConfiguration.?deployments ?? [
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
module resourceRoleAssignmentAiHubAiProjectAzureAiDeveloper 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (aiFoundryAiHubEnabled && aiFoundryAIservicesEnabled) {
  name: take('avm.ptn.authorization.resource-role-assignment.${roleAssignmentAiHubAiProjectAzureAiDeveloper}', 64)
  params: {
    roleName: 'Azure AI Developer'
    roleDefinitionId: '64702f94-c441-49e6-a78b-ef80e0188fee'
    principalId: aiFoundryAiHub.outputs.?systemAssignedMIPrincipalId!
    principalType: 'ServicePrincipal'
    resourceId: aiFoundryAiProject.outputs.?resourceId
  }
}

// AI Foundry: storage account
// WAF best practices for Azure Blob Storage: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-blob-storage
var storageAccountPrivateDnsZones = {
  'privatelink.blob.${environment().suffixes.storage}': 'blob'
  'privatelink.file.${environment().suffixes.storage}': 'file'
}

module privateDnsZonesAiFoundryStorageAccount 'br/public:avm/res/network/private-dns-zone:0.3.1' = [
  for zone in objectKeys(storageAccountPrivateDnsZones): if (virtualNetworkEnabled && aiFoundryStorageAccountEnabled) {
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
          name: 'vnetlink-${split(zone, '.')[1]}'
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]
var aiFoundryStorageAccountEnabled = aiFoundryStorageAccountConfiguration.?enabled ?? true
var aiFoundryStorageAccountResourceName = aiFoundryStorageAccountConfiguration.?name ?? replace(
  'sthub${solutionPrefix}',
  '-',
  ''
)

module aiFoundryStorageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = if (aiFoundryStorageAccountEnabled) {
  name: take('avm.res.storage.storage-account.${aiFoundryStorageAccountResourceName}', 64)
  dependsOn: [
    privateDnsZonesAiFoundryStorageAccount
  ]
  params: {
    name: aiFoundryStorageAccountResourceName
    location: aiFoundryStorageAccountConfiguration.?location ?? azureOpenAILocation
    tags: aiFoundryStorageAccountConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    skuName: aiFoundryStorageAccountConfiguration.?sku ?? 'Standard_ZRS'
    allowSharedKeyAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    blobServices: {
      deleteRetentionPolicyEnabled: false
      containerDeleteRetentionPolicyDays: 7
      containerDeleteRetentionPolicyEnabled: false
      diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    }
    publicNetworkAccess: virtualNetworkEnabled ? 'Disabled' : 'Enabled'
    allowBlobPublicAccess: virtualNetworkEnabled ? false : true
    privateEndpoints: virtualNetworkEnabled
      ? map(items(storageAccountPrivateDnsZones), zone => {
          name: 'pep-${zone.value}-${aiFoundryStorageAccountResourceName}'
          customNetworkInterfaceName: 'nic-${zone.value}-${aiFoundryStorageAccountResourceName}'
          service: zone.value
          subnetResourceId: aiFoundryStorageAccountConfiguration.?subnetResourceId ?? virtualNetwork.outputs.subnetResourceIds[0] ?? ''
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
module privateDnsZonesAiFoundryWorkspaceHub 'br/public:avm/res/network/private-dns-zone:0.3.1' = [
  for zone in objectKeys(mlPrivateDnsZones): if (virtualNetworkEnabled && aiFoundryAiHubEnabled) {
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
          name: 'vnetlink-${split(zone, '.')[1]}'
          virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        }
      ]
    }
  }
]
var aiFoundryAiHubEnabled = aiFoundryAiHubConfiguration.?enabled ?? true
var aiFoundryAiHubResourceName = aiFoundryAiHubConfiguration.?name ?? 'aih-${solutionPrefix}'
module aiFoundryAiHub 'modules/ai-hub.bicep' = if (aiFoundryAiHubEnabled) {
  name: take('module.ai-hub.${aiFoundryAiHubResourceName}', 64)
  dependsOn: [
    privateDnsZonesAiFoundryWorkspaceHub
  ]
  params: {
    name: aiFoundryAiHubResourceName
    location: aiFoundryAiHubConfiguration.?location ?? azureOpenAILocation
    tags: aiFoundryAiHubConfiguration.?tags ?? tags
    sku: aiFoundryAiHubConfiguration.?sku ?? 'Basic'
    aiFoundryAiServicesName: aiFoundryAiServices.outputs.name
    applicationInsightsResourceId: applicationInsights.outputs.resourceId
    enableTelemetry: enableTelemetry
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    storageAccountResourceId: aiFoundryStorageAccount.outputs.resourceId
    virtualNetworkEnabled: virtualNetworkEnabled
    privateEndpoints: virtualNetworkEnabled
      ? [
          {
            name: 'pep-${aiFoundryAiHubResourceName}'
            customNetworkInterfaceName: 'nic-${aiFoundryAiHubResourceName}'
            service: mlTargetSubResource
            subnetResourceId: virtualNetworkEnabled
              ? aiFoundryAiHubConfiguration.?subnetResourceId ?? virtualNetwork.?outputs.?subnetResourceIds[0]
              : null
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
var aiFoundryAiProjectEnabled = aiFoundryAiProjectConfiguration.?enabled ?? true
var aiFoundryAiProjectName = aiFoundryAiProjectConfiguration.?name ?? 'aihb-${solutionPrefix}'

module aiFoundryAiProject 'br/public:avm/res/machine-learning-services/workspace:0.12.0' = if (aiFoundryAiProjectEnabled) {
  name: take('avm.res.machine-learning-services.workspace.${aiFoundryAiProjectName}', 64)
  params: {
    name: aiFoundryAiProjectName
    location: aiFoundryAiProjectConfiguration.?location ?? azureOpenAILocation
    tags: aiFoundryAiProjectConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    sku: aiFoundryAiProjectConfiguration.?sku ?? 'Basic'
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
module resourceRoleAssignmentAiProjectAiServicesCognitiveServicesOpenAIUser 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = if (aiFoundryAiHubEnabled && aiFoundryAIservicesEnabled) {
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
  }
}

// ========== Cosmos DB ========== //
// WAF best practices for Cosmos DB: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/cosmos-db
module privateDnsZonesCosmosDb 'br/public:avm/res/network/private-dns-zone:0.7.0' = if (virtualNetworkEnabled) {
  name: take('avm.res.network.private-dns-zone.cosmos-db.${solutionPrefix}', 64)
  params: {
    name: 'privatelink.documents.azure.com'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: [
      {
        name: 'vnetlink-cosmosdb'
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
      }
    ]
    tags: tags
  }
}

var cosmosDbAccountEnabled = cosmosDbAccountConfiguration.?enabled ?? true
var cosmosDbResourceName = cosmosDbAccountConfiguration.?name ?? 'cosmos-${solutionPrefix}'
var cosmosDbDatabaseName = 'macae'
var cosmosDbDatabaseMemoryContainerName = 'memory'
module cosmosDb 'br/public:avm/res/document-db/database-account:0.12.0' = if (cosmosDbAccountEnabled) {
  name: take('avm.res.document-db.database-account.${cosmosDbResourceName}', 64)
  params: {
    // Required parameters
    name: cosmosDbAccountConfiguration.?name ?? 'cosmos-${solutionPrefix}'
    location: cosmosDbAccountConfiguration.?location ?? solutionLocation
    tags: cosmosDbAccountConfiguration.?tags ?? tags
    enableTelemetry: enableTelemetry
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    databaseAccountOfferType: 'Standard'
    enableFreeTier: false
    networkRestrictions: {
      networkAclBypass: 'None'
      publicNetworkAccess: virtualNetworkEnabled ? 'Disabled' : 'Enabled'
    }
    privateEndpoints: virtualNetworkEnabled
      ? [
          {
            name: 'pep-${cosmosDbResourceName}'
            customNetworkInterfaceName: 'nic-${cosmosDbResourceName}'
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [{ privateDnsZoneResourceId: privateDnsZonesCosmosDb.outputs.resourceId }]
            }
            service: 'Sql'
            subnetResourceId: cosmosDbAccountConfiguration.?subnetResourceId ?? virtualNetwork.outputs.subnetResourceIds[0]
          }
        ]
      : []
    sqlDatabases: concat(cosmosDbAccountConfiguration.?sqlDatabases ?? [], [
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
    ])
    locations: [
      {
        locationName: cosmosDbAccountConfiguration.?location ?? solutionLocation
        failoverPriority: 0
      }
    ]
    capabilitiesToAdd: [
      'EnableServerless'
    ]
    sqlRoleAssignmentsPrincipalIds: [
      //userAssignedIdentityAIHub.outputs.principalId
      containerApp.outputs.?systemAssignedMIPrincipalId
    ]
    sqlRoleDefinitions: [
      {
        // Replace this with built-in role definition Cosmos DB Built-in Data Contributor: https://docs.azure.cn/en-us/cosmos-db/nosql/security/reference-data-plane-roles#cosmos-db-built-in-data-contributor
        roleType: 'CustomRole'
        roleName: 'Cosmos DB SQL Data Contributor'
        name: 'cosmos-db-sql-data-contributor'
        dataAction: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
      }
    ]
  }
}

// ========== Backend Container App Environment ========== //
// WAF best practices for container apps: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-container-apps
var containerAppEnvironmentEnabled = containerAppEnvironmentConfiguration.?enabled ?? true
var containerAppEnvironmentResourceName = containerAppEnvironmentConfiguration.?name ?? 'cae-${solutionPrefix}'
module containerAppEnvironment 'modules/container-app-environment.bicep' = if (containerAppEnvironmentEnabled) {
  name: take('module.container-app-environment.${containerAppEnvironmentResourceName}', 64)
  params: {
    name: containerAppEnvironmentResourceName
    tags: containerAppEnvironmentConfiguration.?tags ?? tags
    location: containerAppEnvironmentConfiguration.?location ?? solutionLocation
    logAnalyticsResourceName: logAnalyticsWorkspace.outputs.name
    publicNetworkAccess: 'Enabled'
    zoneRedundant: virtualNetworkEnabled ? true : false
    applicationInsightsConnectionString: applicationInsights.outputs.connectionString
    enableTelemetry: enableTelemetry
    subnetResourceId: virtualNetworkEnabled
      ? containerAppEnvironmentConfiguration.?subnetResourceId ?? virtualNetwork.?outputs.?subnetResourceIds[4] ?? ''
      : ''
    //aspireDashboardEnabled: !virtualNetworkEnabled
    // vnetConfiguration: virtualNetworkEnabled
    //   ? {
    //       internal: false
    //       infrastructureSubnetId: containerAppEnvironmentConfiguration.?subnetResourceId ?? virtualNetwork.?outputs.?subnetResourceIds[3] ?? ''
    //     }
    //   : {}
  }
}

// ========== Backend Container App Service ========== //
// WAF best practices for container apps: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/azure-container-apps
var containerAppEnabled = containerAppConfiguration.?enabled ?? true
var containerAppResourceName = containerAppConfiguration.?name ?? 'ca-${solutionPrefix}'
module containerApp 'br/public:avm/res/app/container-app:0.14.2' = if (containerAppEnabled) {
  name: take('avm.res.app.container-app.${containerAppResourceName}', 64)
  params: {
    name: containerAppResourceName
    tags: containerAppConfiguration.?tags ?? tags
    location: containerAppConfiguration.?location ?? solutionLocation
    enableTelemetry: enableTelemetry
    environmentResourceId: containerAppConfiguration.?environmentResourceId ?? containerAppEnvironment.outputs.resourceId
    managedIdentities: {
      systemAssigned: true //Replace with user assigned identity
      //userAssignedResourceIds: [userAssignedIdentityAIHub.outputs.resourceId]
    }
    ingressTargetPort: containerAppConfiguration.?ingressTargetPort ?? 8000
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
      maxReplicas: containerAppConfiguration.?maxReplicas ?? 1
      minReplicas: containerAppConfiguration.?minReplicas ?? 1
      rules: [
        {
          name: 'http-scaler'
          http: {
            metadata: {
              concurrentRequests: containerAppConfiguration.?concurrentRequests ?? '100'
            }
          }
        }
      ]
    }
    containers: [
      {
        name: containerAppConfiguration.?containerName ?? 'backend'
        image: '${containerAppConfiguration.?containerImageRegistryDomain ?? 'biabcontainerreg.azurecr.io'}/${containerAppConfiguration.?containerImageName ?? 'macaebackend'}:${containerAppConfiguration.?containerImageTag ?? 'latest'}'
        resources: {
          //TODO: Make cpu and memory parameterized
          cpu: containerAppConfiguration.?containerCpu ?? '2.0'
          memory: containerAppConfiguration.?containerMemory ?? '4.0Gi'
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
            value: applicationInsights.outputs.instrumentationKey
          }
          {
            name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
            value: applicationInsights.outputs.connectionString
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

var webServerFarmEnabled = webServerFarmConfiguration.?enabled ?? true
var webServerFarmResourceName = webServerFarmConfiguration.?name ?? 'asp-${solutionPrefix}'

// ========== Frontend server farm ========== //
// WAF best practices for web app service: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
module webServerFarm 'br/public:avm/res/web/serverfarm:0.4.1' = if (webServerFarmEnabled) {
  name: take('avm.res.web.serverfarm.${webServerFarmResourceName}', 64)
  params: {
    name: webServerFarmResourceName
    tags: tags
    location: webServerFarmConfiguration.?location ?? solutionLocation
    skuName: webServerFarmConfiguration.?skuName ?? 'P1v3'
    skuCapacity: webServerFarmConfiguration.?skuCapacity ?? 3
    reserved: true
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    kind: 'linux'
    zoneRedundant: false //TODO: make it zone redundant for waf aligned
  }
}

// ========== Frontend web site ========== //
// WAF best practices for web app service: https://learn.microsoft.com/en-us/azure/well-architected/service-guides/app-service-web-apps
var webSiteEnabled = webSiteConfiguration.?enabled ?? true

var webSiteName = 'app-${solutionPrefix}'
module webSite 'br/public:avm/res/web/site:0.15.1' = if (webSiteEnabled) {
  name: take('avm.res.web.site.${webSiteName}', 64)
  params: {
    name: webSiteName
    tags: webSiteConfiguration.?tags ?? tags
    location: webSiteConfiguration.?location ?? solutionLocation
    kind: 'app,linux,container'
    enableTelemetry: enableTelemetry
    serverFarmResourceId: webSiteConfiguration.?environmentResourceId ?? webServerFarm.?outputs.resourceId
    appInsightResourceId: applicationInsights.outputs.resourceId
    diagnosticSettings: [{ workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId }]
    publicNetworkAccess: 'Enabled' //TODO: use Azure Front Door WAF or Application Gateway WAF instead
    siteConfig: {
      linuxFxVersion: 'DOCKER|${webSiteConfiguration.?containerImageRegistryDomain ?? 'biabcontainerreg.azurecr.io'}/${webSiteConfiguration.?containerImageName ?? 'macaefrontend'}:${webSiteConfiguration.?containerImageTag ?? 'latest'}'
    }
    appSettingsKeyValuePairs: {
      SCM_DO_BUILD_DURING_DEPLOYMENT: 'true'
      DOCKER_REGISTRY_SERVER_URL: 'https://${webSiteConfiguration.?containerImageRegistryDomain ?? 'biabcontainerreg.azurecr.io'}'
      WEBSITES_PORT: '3000'
      WEBSITES_CONTAINER_START_TIME_LIMIT: '1800' // 30 minutes, adjust as needed
      BACKEND_API_URL: 'https://${containerApp.outputs.fqdn}'
      AUTH_ENABLED: 'false'
    }
  }
}

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

@description('The default url of the website to connect to the Multi-Agent Custom Automation Engine solution.')
output webSiteDefaultHostname string = webSite.outputs.defaultHostname

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

@export()
@description('The type for the Multi-Agent Custom Automation Engine Log Analytics Workspace resource configuration.')
type logAnalyticsWorkspaceConfigurationType = {
  @description('Optional. If the Log Analytics Workspace resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Log Analytics Workspace resource.')
  @maxLength(63)
  name: string?

  @description('Optional. Location for the Log Analytics Workspace resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to for the Log Analytics Workspace resource.')
  tags: object?

  @description('Optional. The SKU for the Log Analytics Workspace resource.')
  sku: ('CapacityReservation' | 'Free' | 'LACluster' | 'PerGB2018' | 'PerNode' | 'Premium' | 'Standalone' | 'Standard')?

  @description('Optional. The number of days to retain the data in the Log Analytics Workspace. If empty, it will be set to 365 days.')
  @maxValue(730)
  dataRetentionInDays: int?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Application Insights resource configuration.')
type applicationInsightsConfigurationType = {
  @description('Optional. If the Application Insights resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Application Insights resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the Application Insights resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Application Insights resource.')
  tags: object?

  @description('Optional. The retention of Application Insights data in days. If empty, Standard will be used.')
  retentionInDays: (120 | 180 | 270 | 30 | 365 | 550 | 60 | 730 | 90)?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Application User Assigned Managed Identity resource configuration.')
type userAssignedManagedIdentityType = {
  @description('Optional. If the User Assigned Managed Identity resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the User Assigned Managed Identity resource.')
  @maxLength(128)
  name: string?

  @description('Optional. Location for the User Assigned Managed Identity resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the User Assigned Managed Identity resource.')
  tags: object?
}

@export()
import { securityRuleType } from 'br/public:avm/res/network/network-security-group:0.5.1'
@description('The type for the Multi-Agent Custom Automation Engine Network Security Group resource configuration.')
type networkSecurityGroupConfigurationType = {
  @description('Optional. If the Network Security Group resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Network Security Group resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the Network Security Group resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Network Security Group resource.')
  tags: object?

  @description('Optional. The security rules to set for the Network Security Group resource.')
  securityRules: securityRuleType[]?
}

@export()
@description('The type for the Multi-Agent Custom Automation virtual network resource configuration.')
type virtualNetworkConfigurationType = {
  @description('Optional. If the Virtual Network resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Virtual Network resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the Virtual Network resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Virtual Network resource.')
  tags: object?

  @description('Optional. An array of 1 or more IP Addresses prefixes for the Virtual Network resource.')
  addressPrefixes: string[]?

  @description('Optional. An array of 1 or more subnets for the Virtual Network resource.')
  subnets: subnetType[]?
}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
type subnetType = {
  @description('Optional. The Name of the subnet resource.')
  name: string

  @description('Conditional. The address prefix for the subnet. Required if `addressPrefixes` is empty.')
  addressPrefix: string?

  @description('Conditional. List of address prefixes for the subnet. Required if `addressPrefix` is empty.')
  addressPrefixes: string[]?

  @description('Optional. Application gateway IP configurations of virtual network resource.')
  applicationGatewayIPConfigurations: object[]?

  @description('Optional. The delegation to enable on the subnet.')
  delegation: string?

  @description('Optional. The resource ID of the NAT Gateway to use for the subnet.')
  natGatewayResourceId: string?

  @description('Optional. The resource ID of the network security group to assign to the subnet.')
  networkSecurityGroupResourceId: string?

  @description('Optional. enable or disable apply network policies on private endpoint in the subnet.')
  privateEndpointNetworkPolicies: ('Disabled' | 'Enabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?

  @description('Optional. enable or disable apply network policies on private link service in the subnet.')
  privateLinkServiceNetworkPolicies: ('Disabled' | 'Enabled')?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. The resource ID of the route table to assign to the subnet.')
  routeTableResourceId: string?

  @description('Optional. An array of service endpoint policies.')
  serviceEndpointPolicies: object[]?

  @description('Optional. The service endpoints to enable on the subnet.')
  serviceEndpoints: string[]?

  @description('Optional. Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.')
  defaultOutboundAccess: bool?

  @description('Optional. Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.')
  sharingScope: ('DelegatedServices' | 'Tenant')?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Bastion resource configuration.')
type bastionConfigurationType = {
  @description('Optional. If the Bastion resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Bastion resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the Bastion resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Bastion resource.')
  tags: object?

  @description('Optional. The SKU for the Bastion resource.')
  sku: ('Basic' | 'Developer' | 'Premium' | 'Standard')?

  @description('Optional. The Virtual Network resource id where the Bastion resource should be deployed.')
  virtualNetworkResourceId: string?

  @description('Optional. The name of the Public Ip resource created to connect to Bastion.')
  publicIpResourceName: string?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine virtual machine resource configuration.')
type virtualMachineConfigurationType = {
  @description('Optional. If the Virtual Machine resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Virtual Machine resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the Virtual Machine resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Virtual Machine resource.')
  tags: object?

  @description('Optional. Specifies the size for the Virtual Machine resource.')
  vmSize: (
    | 'Basic_A0'
    | 'Basic_A1'
    | 'Basic_A2'
    | 'Basic_A3'
    | 'Basic_A4'
    | 'Standard_A0'
    | 'Standard_A1'
    | 'Standard_A2'
    | 'Standard_A3'
    | 'Standard_A4'
    | 'Standard_A5'
    | 'Standard_A6'
    | 'Standard_A7'
    | 'Standard_A8'
    | 'Standard_A9'
    | 'Standard_A10'
    | 'Standard_A11'
    | 'Standard_A1_v2'
    | 'Standard_A2_v2'
    | 'Standard_A4_v2'
    | 'Standard_A8_v2'
    | 'Standard_A2m_v2'
    | 'Standard_A4m_v2'
    | 'Standard_A8m_v2'
    | 'Standard_B1s'
    | 'Standard_B1ms'
    | 'Standard_B2s'
    | 'Standard_B2ms'
    | 'Standard_B4ms'
    | 'Standard_B8ms'
    | 'Standard_D1'
    | 'Standard_D2'
    | 'Standard_D3'
    | 'Standard_D4'
    | 'Standard_D11'
    | 'Standard_D12'
    | 'Standard_D13'
    | 'Standard_D14'
    | 'Standard_D1_v2'
    | 'Standard_D2_v2'
    | 'Standard_D3_v2'
    | 'Standard_D4_v2'
    | 'Standard_D5_v2'
    | 'Standard_D2_v3'
    | 'Standard_D4_v3'
    | 'Standard_D8_v3'
    | 'Standard_D16_v3'
    | 'Standard_D32_v3'
    | 'Standard_D64_v3'
    | 'Standard_D2s_v3'
    | 'Standard_D4s_v3'
    | 'Standard_D8s_v3'
    | 'Standard_D16s_v3'
    | 'Standard_D32s_v3'
    | 'Standard_D64s_v3'
    | 'Standard_D11_v2'
    | 'Standard_D12_v2'
    | 'Standard_D13_v2'
    | 'Standard_D14_v2'
    | 'Standard_D15_v2'
    | 'Standard_DS1'
    | 'Standard_DS2'
    | 'Standard_DS3'
    | 'Standard_DS4'
    | 'Standard_DS11'
    | 'Standard_DS12'
    | 'Standard_DS13'
    | 'Standard_DS14'
    | 'Standard_DS1_v2'
    | 'Standard_DS2_v2'
    | 'Standard_DS3_v2'
    | 'Standard_DS4_v2'
    | 'Standard_DS5_v2'
    | 'Standard_DS11_v2'
    | 'Standard_DS12_v2'
    | 'Standard_DS13_v2'
    | 'Standard_DS14_v2'
    | 'Standard_DS15_v2'
    | 'Standard_DS13-4_v2'
    | 'Standard_DS13-2_v2'
    | 'Standard_DS14-8_v2'
    | 'Standard_DS14-4_v2'
    | 'Standard_E2_v3'
    | 'Standard_E4_v3'
    | 'Standard_E8_v3'
    | 'Standard_E16_v3'
    | 'Standard_E32_v3'
    | 'Standard_E64_v3'
    | 'Standard_E2s_v3'
    | 'Standard_E4s_v3'
    | 'Standard_E8s_v3'
    | 'Standard_E16s_v3'
    | 'Standard_E32s_v3'
    | 'Standard_E64s_v3'
    | 'Standard_E32-16_v3'
    | 'Standard_E32-8s_v3'
    | 'Standard_E64-32s_v3'
    | 'Standard_E64-16s_v3'
    | 'Standard_F1'
    | 'Standard_F2'
    | 'Standard_F4'
    | 'Standard_F8'
    | 'Standard_F16'
    | 'Standard_F1s'
    | 'Standard_F2s'
    | 'Standard_F4s'
    | 'Standard_F8s'
    | 'Standard_F16s'
    | 'Standard_F2s_v2'
    | 'Standard_F4s_v2'
    | 'Standard_F8s_v2'
    | 'Standard_F16s_v2'
    | 'Standard_F32s_v2'
    | 'Standard_F64s_v2'
    | 'Standard_F72s_v2'
    | 'Standard_G1'
    | 'Standard_G2'
    | 'Standard_G3'
    | 'Standard_G4'
    | 'Standard_G5'
    | 'Standard_GS1'
    | 'Standard_GS2'
    | 'Standard_GS3'
    | 'Standard_GS4'
    | 'Standard_GS5'
    | 'Standard_GS4-8'
    | 'Standard_GS4-4'
    | 'Standard_GS5-16'
    | 'Standard_GS5-8'
    | 'Standard_H8'
    | 'Standard_H16'
    | 'Standard_H8m'
    | 'Standard_H16m'
    | 'Standard_H16r'
    | 'Standard_H16mr'
    | 'Standard_L4s'
    | 'Standard_L8s'
    | 'Standard_L16s'
    | 'Standard_L32s'
    | 'Standard_M64s'
    | 'Standard_M64ms'
    | 'Standard_M128s'
    | 'Standard_M128ms'
    | 'Standard_M64-32ms'
    | 'Standard_M64-16ms'
    | 'Standard_M128-64ms'
    | 'Standard_M128-32ms'
    | 'Standard_NC6'
    | 'Standard_NC12'
    | 'Standard_NC24'
    | 'Standard_NC24r'
    | 'Standard_NC6s_v2'
    | 'Standard_NC12s_v2'
    | 'Standard_NC24s_v2'
    | 'Standard_NC24rs_v2'
    | 'Standard_NC6s_v3'
    | 'Standard_NC12s_v3'
    | 'Standard_NC24s_v3'
    | 'Standard_NC24rs_v3'
    | 'Standard_ND6s'
    | 'Standard_ND12s'
    | 'Standard_ND24s'
    | 'Standard_ND24rs'
    | 'Standard_NV6'
    | 'Standard_NV12'
    | 'Standard_NV24')?

  @description('Optional. The username for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  adminUsername: string?

  @description('Optional. The password for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  @secure()
  adminPassword: string?

  @description('Optional. The resource ID of the subnet where the Virtual Machine resource should be deployed.')
  subnetResourceId: string?
}

@export()
import { deploymentType } from 'br/public:avm/res/cognitive-services/account:0.10.2'
@description('The type for the Multi-Agent Custom Automation Engine AI Services resource configuration.')
type aiServicesConfigurationType = {
  @description('Optional. If the AI Services resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the AI Services resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Services resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the AI Services resource.')
  tags: object?

  @description('Optional. The SKU of the AI Services resource. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
  sku: (
    | 'C2'
    | 'C3'
    | 'C4'
    | 'F0'
    | 'F1'
    | 'S'
    | 'S0'
    | 'S1'
    | 'S10'
    | 'S2'
    | 'S3'
    | 'S4'
    | 'S5'
    | 'S6'
    | 'S7'
    | 'S8'
    | 'S9')?

  @description('Optional. The resource Id of the subnet where the AI Services private endpoint should be created.')
  subnetResourceId: string?

  @description('Optional. The model deployments to set for the AI Services resource.')
  deployments: deploymentType[]?

  @description('Optional. The capacity to set for AI Services GTP model.')
  modelCapacity: int?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Storage Account resource configuration.')
type storageAccountType = {
  @description('Optional. If the Storage Account resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Storage Account resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Storage Account resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Storage Account resource.')
  tags: object?

  @description('Optional. The SKU for the Storage Account resource.')
  sku: ('Standard_LRS' | 'Standard_GRS' | 'Standard_RAGRS' | 'Standard_ZRS' | 'Premium_LRS' | 'Premium_ZRS')?

  @description('Optional. The resource Id of the subnet where the Storage Account private endpoint should be created.')
  subnetResourceId: string?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine AI Hub resource configuration.')
type aiHubType = {
  @description('Optional. If the AI Hub resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the AI Hub resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Hub resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the AI Hub resource.')
  tags: object?

  @description('Optional. The SKU of the AI Hub resource.')
  sku: ('Basic' | 'Free' | 'Standard' | 'Premium')?

  @description('Optional. The resource Id of the subnet where the AI Hub private endpoint should be created.')
  subnetResourceId: string?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine AI Foundry AI Project resource configuration.')
type aiProjectConfigurationType = {
  @description('Optional. If the AI Project resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the AI Project resource.')
  @maxLength(90)
  name: string?

  @description('Optional. Location for the AI Project resource deployment.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The SKU of the AI Project resource.')
  sku: ('Basic' | 'Free' | 'Standard' | 'Premium')?

  @description('Optional. The tags to set for the AI Project resource.')
  tags: object?
}

import { sqlDatabaseType } from 'br/public:avm/res/document-db/database-account:0.13.0'
@export()
@description('The type for the Multi-Agent Custom Automation Engine Cosmos DB Account resource configuration.')
type cosmosDbAccountConfigurationType = {
  @description('Optional. If the Cosmos DB Account resource should be deployed or not.')
  enabled: bool?
  @description('Optional. The name of the Cosmos DB Account resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Cosmos DB Account resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Cosmos DB Account resource.')
  tags: object?

  @description('Optional. The resource Id of the subnet where the Cosmos DB Account private endpoint should be created.')
  subnetResourceId: string?

  @description('Optional. The SQL databases configuration for the Cosmos DB Account resource.')
  sqlDatabases: sqlDatabaseType[]?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Container App Environment resource configuration.')
type containerAppEnvironmentConfigurationType = {
  @description('Optional. If the Container App Environment resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Container App Environment resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Container App Environment resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Container App Environment resource.')
  tags: object?

  @description('Optional. The resource Id of the subnet where the Container App Environment private endpoint should be created.')
  subnetResourceId: string?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Container App resource configuration.')
type containerAppConfigurationType = {
  @description('Optional. If the Container App resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Container App resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Container App resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Container App resource.')
  tags: object?

  @description('Optional. The resource Id of the Container App Environment where the Container App should be created.')
  environmentResourceId: string?

  @description('Optional. The maximum number of replicas of the Container App.')
  maxReplicas: int?

  @description('Optional. The minimum number of replicas of the Container App.')
  minReplicas: int?

  @description('Optional. The ingress target port of the Container App.')
  ingressTargetPort: int?

  @description('Optional. The concurrent requests allowed for the Container App.')
  concurrentRequests: string?

  @description('Optional. The name given to the Container App.')
  containerName: string?

  @description('Optional. The container registry domain of the container image to be used by the Container App. Default to `biabcontainerreg.azurecr.io`')
  containerImageRegistryDomain: string?

  @description('Optional. The name of the container image to be used by the Container App.')
  containerImageName: string?

  @description('Optional. The tag of the container image to be used by the Container App.')
  containerImageTag: string?

  @description('Optional. The CPU reserved for the Container App. Defaults to 2.0')
  containerCpu: string?

  @description('Optional. The Memory reserved for the Container App. Defaults to 4.0Gi')
  containerMemory: string?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Entra ID Application resource configuration.')
type entraIdApplicationConfigurationType = {
  @description('Optional. If the Entra ID Application for website authentication should be deployed or not.')
  enabled: bool?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Web Server Farm resource configuration.')
type webServerFarmConfigurationType = {
  @description('Optional. If the Web Server Farm resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Web Server Farm resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Web Server Farm resource.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Web Server Farm resource.')
  tags: object?

  @description('Optional. The name of th SKU that will determine the tier, size and family for the Web Server Farm resource. This defaults to P1v3 to leverage availability zones.')
  skuName: string?

  @description('Optional. Number of workers associated with the App Service Plan. This defaults to 3, to leverage availability zones.')
  skuCapacity: int?
}

@export()
@description('The type for the Multi-Agent Custom Automation Engine Web Site resource configuration.')
type webSiteConfigurationType = {
  @description('Optional. If the Web Site resource should be deployed or not.')
  enabled: bool?

  @description('Optional. The name of the Web Site resource.')
  @maxLength(60)
  name: string?

  @description('Optional. Location for the Web Site resource deployment.')
  @metadata({ azd: { type: 'location' } })
  location: string?

  @description('Optional. The tags to set for the Web Site resource.')
  tags: object?

  @description('Optional. The resource Id of the Web Site Environment where the Web Site should be created.')
  environmentResourceId: string?

  @description('Optional. The name given to the Container App.')
  containerName: string?

  @description('Optional. The container registry domain of the container image to be used by the Web Site. Default to `biabcontainerreg.azurecr.io`')
  containerImageRegistryDomain: string?

  @description('Optional. The name of the container image to be used by the Web Site.')
  containerImageName: string?

  @description('Optional. The tag of the container image to be used by the Web Site.')
  containerImageTag: string?
}
