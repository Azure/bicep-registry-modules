targetScope = 'resourceGroup'

param workloadName string
param location string
param tags object

var azureFirewallSubnetName = 'AzureFirewallSubnet'
var vnetAddressPrefixes = ['10.0.0.0/24']
var azureFirewallSubnetAddressPrefix = '10.0.0.64/26'
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

resource vnetHub 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnetHub-${workloadName}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefixes
    }
    subnets: [
      {
        name: azureFirewallSubnetName
        properties: {
          addressPrefix: azureFirewallSubnetAddressPrefix
        }
      }
    ]
  }
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'fw-pip-${workloadName}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' = {
  name: 'azureFirewall-${workloadName}'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'AzureFirewallIpConfig'
        properties: {
          subnet: {
            id: vnetHub.properties.subnets[0].id
          }
        }
      }
      {
        name: 'AzureFirewallPublicIpConfig'
        properties: {
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    applicationRuleCollections: applicationRuleCollections
    networkRuleCollections: networkRules
  }
}

@description('The resource ID of hub virtual network.')
output hubVNetId string = vnetHub.id

@description('The private IP address of the Azure Firewall.')
output networkApplianceIpAddress string = azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress
