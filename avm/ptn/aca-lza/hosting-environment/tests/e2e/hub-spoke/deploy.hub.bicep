targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string = 'test'

@description('The location where the resources will be created.')
param location string = deployment().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deplotment telemetry.')
param enableTelemetry bool

@description('CIDR of the hub virtual network.')
param vnetAddressPrefixes array

@description('Enable or disable the creation of the Azure Bastion.')
param enableBastion bool = true

@description('Bastion sku, default is basic')
@allowed([
  'Basic'
  'Standard'
])
param bastionSku string = 'Basic'

@description('CIDR to use for the Azure Bastion subnet.')
param bastionSubnetAddressPrefix string

@description('CIDR to use for the gatewaySubnet.')
param gatewaySubnetAddressPrefix string

@description('CIDR to use for the azureFirewallSubnet.')
param azureFirewallSubnetAddressPrefix string

//@description('CIDR to use for the AzureFirewallManagementSubnet, which is required by AzFW Basic.')
//param azureFirewallSubnetManagementAddressPrefix string

// ------------------
// VARIABLES
// ------------------

// These cannot be another value
var gatewaySubnetName = 'GatewaySubnet'
var azureFirewallSubnetName = 'AzureFirewallSubnet'
//var AzureFirewallManagementSubnetName = 'AzureFirewallManagementSubnet'
var bastionSubnetName = 'AzureBastionSubnet'

//Subnet definition taking in consideration feature flags
var defaultSubnets = [
  {
    name: gatewaySubnetName
    addressPrefix: gatewaySubnetAddressPrefix
  }
  {
    name: azureFirewallSubnetName
    addressPrefix: azureFirewallSubnetAddressPrefix
  }
  // {
  //   name: AzureFirewallManagementSubnetName
  //   addressPrefix: azureFirewallSubnetManagementAddressPrefix
  // }
]

// Append optional bastion subnet, if required
var vnetSubnets = enableBastion
  ? concat(defaultSubnets, [
      {
        name: bastionSubnetName
        addressPrefix: bastionSubnetAddressPrefix
      }
    ])
  : defaultSubnets

//used only to override the RG name - because it is created at the subscription level, the naming module cannot be loaded/used
var namingRules = json(loadTextContent('../../../modules/naming/naming-rules.jsonc'))
var rgHubName = '${namingRules.resourceTypeAbbreviations.resourceGroup}-${workloadName}-hub-${environment}-${namingRules.regionAbbreviations[toLower(location)]}'
var spokeInfraSubnetAddressPrefix = '10.1.0.0/23'
var applicationRuleCollections = [
  {
    name: 'ace-allow-rules'
    properties: {
      action: {
        type: 'Allow'
      }
      priority: 110
      rules: [
        {
          name: 'ace-general-allow-rules'
          protocols: [
            {
              port: 80
              protocolType: 'Http'
            }
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          targetFqdns: [
            'mcr.microsoft.com'
            '*.data.mcr.microsoft.com'
            '*.blob.${az.environment().suffixes.storage}' //NOTE: If you use ACR the endpoint must be added as well.
          ]
        }
        {
          name: 'ace-acr-and-docker-allow-rules'
          protocols: [
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          targetFqdns: [
            '*.blob.${az.environment().suffixes.storage}'
            'login.microsoft.com'
            '*.azurecr.io' //NOTE: for less permisive environment replace wildcard with actual(s) Container Registries
            'hub.docker.com'
            'registry-1.docker.io'
            'production.cloudflare.docker.com'
          ]
        }
        {
          name: 'ace-managed-identity-allow-rules'
          protocols: [
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          targetFqdns: [
            '*.identity.azure.net'
            'login.microsoftonline.com'
            '*.login.microsoftonline.com'
            '*.login.microsoft.com'
          ]
        }
        {
          name: 'ace-keyvault-allow-rules'
          protocols: [
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          targetFqdns: [
            '*${az.environment().suffixes.keyvaultDns}' //NOTE: for less permisive environment replace wildcard with actual(s) KeyVault
            #disable-next-line no-hardcoded-env-urls
            'login.microsoft.com'
          ]
        }
      ]
    }
  }
  {
    name: 'allow_azure_monitor'
    properties: {
      action: {
        type: 'Allow'
      }
      priority: 120
      rules: [
        {
          fqdnTags: []
          targetFqdns: [
            'dc.applicationinsights.azure.com'
            'dc.applicationinsights.microsoft.com'
            'dc.services.visualstudio.com'
            '*.in.applicationinsights.azure.com'
            'live.applicationinsights.azure.com'
            'rt.applicationinsights.microsoft.com'
            'rt.services.visualstudio.com'
            '*.livediagnostics.monitor.azure.com'
            '*.monitoring.azure.com'
            'agent.azureserviceprofiler.net'
            '*.agent.azureserviceprofiler.net'
            '*.monitor.azure.com'
          ]
          name: 'allow-azure-monitor'
          protocols: [
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
        }
      ]
    }
  }
  {
    name: 'allow_core_dev_fqdn' //NOTE: This rule is optional, and used here only to demonstrate that there are possibly more fqdns that need to be allowed, depending on your scenario
    properties: {
      action: {
        type: 'Allow'
      }
      priority: 130
      rules: [
        {
          name: 'allow-developer-services'
          fqdnTags: []
          targetFqdns: [
            'github.com'
            '*.github.com'
            'ghcr.io'
            '*.ghcr.io'
            '*.nuget.org'
            '*.blob.${az.environment().suffixes.storage}' // might replace wildcard with specific FQDN
            '*.table.${az.environment().suffixes.storage}' // might replace wildcard with specific FQDN
            '*.servicebus.windows.net' // might replace wildcard with specific FQDN
            'githubusercontent.com'
            '*.githubusercontent.com'
            'dev.azure.com'
            'portal.azure.com'
            '*.portal.azure.com'
            '*.portal.azure.net'
            'appservice.azureedge.net'
            '*.azurewebsites.net'
          ]
          protocols: [
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
        }
        {
          name: 'allow-certificate-dependencies'
          fqdnTags: []
          targetFqdns: [
            '*.delivery.mp.microsoft.com'
            'ctldl.windowsupdate.com'
            'ocsp.msocsp.com'
            'oneocsp.microsoft.com'
            'crl.microsoft.com'
            'www.microsoft.com'
            '*.digicert.com'
            '*.symantec.com'
            '*.symcb.com'
            '*.d-trust.net'
          ]
          protocols: [
            {
              port: 80
              protocolType: 'Http'
            }
            {
              port: 443
              protocolType: 'Https'
            }
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
        }
      ]
    }
  }
]
var networkRules = [
  {
    name: 'ace-allow-rules'
    properties: {
      action: {
        type: 'Allow'
      }
      priority: 100
      // For more  Azure resources (than KeyVault, ACR etc which we use here) you are using with Azure Firewall,
      // please refer to the service tags documentation: https://learn.microsoft.com/azure/virtual-network/service-tags-overview#available-service-tags
      rules: [
        {
          name: 'ace-general-allow-rule'
          protocols: [
            'Any'
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          destinationAddresses: [
            'MicrosoftContainerRegistry' //For even less permisive environment, you can point to a specific MCR region, i.e. 'MicrosoftContainerRegistry.Westeurope'
            'AzureFrontDoor.FirstParty'
          ]
          destinationPorts: [
            '443'
          ]
        }
        {
          name: 'ace-acr-allow-rule'
          protocols: [
            'Any'
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          destinationAddresses: [
            'AzureContainerRegistry' //For even less permisive environment, you can point to a specific ACR region, i.e. 'MicrosoftContainerRegistry.Westeurope'
            'AzureActiveDirectory'
          ]
          destinationPorts: [
            '443'
          ]
        }
        {
          name: 'ace-keyvault-allow-rule'
          protocols: [
            'Any'
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          destinationAddresses: [
            'AzureKeyVault' //For even less permisive environment, you can point to a specific keyvault region, i.e. 'MicrosoftContainerRegistry.Westeurope'
            'AzureActiveDirectory'
          ]
          destinationPorts: [
            '443'
          ]
        }
        {
          name: 'ace-managedIdentity-allow-rule'
          protocols: [
            'Any'
          ]
          sourceAddresses: [
            spokeInfraSubnetAddressPrefix
          ]
          destinationAddresses: [
            'AzureActiveDirectory'
          ]
          destinationPorts: [
            '443'
          ]
        }
      ]
    }
  }
]
// ------------------
// RESOURCES
// ------------------
@description('User-configured naming rules')
module naming '../../../modules/naming/naming.module.bicep' = {
  scope: resourceGroup(rgHubName)
  name: take('hubNamingDeployment-${deployment().name}', 64)
  params: {
    uniqueId: uniqueString(hubResourceGroup.outputs.resourceId)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

@description('The hub resource group. This would normally be already provisioned by your platform team.')
module hubResourceGroup 'br/public:avm/res/resources/resource-group:0.2.3' = {
  name: take('rg-${deployment().name}', 64)
  params: {
    name: rgHubName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('The log sink for Azure Diagnostics')
module hubLogAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.3.4' = {
  name: take('logAnalyticsWs-${uniqueString(rgHubName)}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    name: naming.outputs.resourcesNames.logAnalyticsWorkspace
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

@description('The virtual network used as the stand-in for the regional hub. This would normally be already provisioned by your platform team.')
module vnetHub 'br/public:avm/res/network/virtual-network:0.1.6' = {
  name: take('vnetHub-${deployment().name}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    name: naming.outputs.resourcesNames.vnetHub
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    addressPrefixes: vnetAddressPrefixes
    subnets: vnetSubnets
  }
}

@description('The Azure Firewall deployment. This would normally be already provisioned by your platform team.')
module azureFirewall 'br/public:avm/res/network/azure-firewall:0.3.2' = {
  name: take('afw-${deployment().name}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    name: naming.outputs.resourcesNames.azureFirewall
    azureSkuTier: 'Standard'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    virtualNetworkResourceId: vnetHub.outputs.resourceId
    applicationRuleCollections: applicationRuleCollections
    networkRuleCollections: networkRules
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'azfw-diag'
        workspaceResourceId: hubLogAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

@description('An optional Azure Bastion deployment for jump box access. This would normally be already provisioned by your platform team.')
module bastionHost 'br/public:avm/res/network/bastion-host:0.2.1' = {
  name: take('bastion-${deployment().name}', 64)
  scope: resourceGroup(rgHubName)
  params: {
    // Required parameters
    name: naming.outputs.resourcesNames.bastion
    virtualNetworkResourceId: vnetHub.outputs.resourceId
    // Non-required parameters
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    enableFileCopy: true
    skuName: bastionSku
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of hub virtual network.')
output hubVNetId string = vnetHub.outputs.resourceId

@description('The name of hub virtual network')
output hubVnetName string = vnetHub.outputs.name

@description('The name of the hub resource group.')
output resourceGroupName string = hubResourceGroup.outputs.name

@description('The private IP address of the Azure Firewall.')
output networkApplianceIpAddress string = azureFirewall.outputs.privateIp
