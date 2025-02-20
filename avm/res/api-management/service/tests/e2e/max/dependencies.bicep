@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param locationRegion1 string = resourceGroup().location

@description('Optional. The location to deploy resources to.')
param locationRegion2 string = 'westus'

@description('Required. The name of the Public IP to create.')
param publicIPName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('DNS Prefix')
param publicIpDnsLabelPrefix string

@description('Required. The name of the NSG to create.')
param networkSecurityGroupName string

var addressPrefix = '10.0.0.0/16'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: locationRegion1
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'logAnalyticsWorkspace'
  location: locationRegion1
  tags: {
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'applicationInsights'
  location: locationRegion1
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource vnetRegion1 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${virtualNetworkName}-${locationRegion1}'
  location: locationRegion1
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          networkSecurityGroup: {
            id: nsgRegion1.id
          }
          routeTable: {
            id: routeTableRegion1.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.Sql'
            }
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
    ]
  }
}

resource vnetRegion2 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${virtualNetworkName}-${locationRegion2}'
  location: locationRegion2
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
          networkSecurityGroup: {
            id: nsgRegion2.id
          }
          routeTable: {
            id: routeTableRegion2.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
            {
              service: 'Microsoft.Sql'
            }
            {
              service: 'Microsoft.KeyVault'
            }
          ]
        }
      }
    ]
  }
}

resource routeTableRegion1 'Microsoft.Network/routeTables@2023-11-01' = {
  name: 'apimRouteTableTest-${locationRegion1}'
  location: locationRegion1
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'apimToInternet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

resource routeTableRegion2 'Microsoft.Network/routeTables@2023-11-01' = {
  name: 'apimRouteTableTest-${locationRegion2}'
  location: locationRegion2
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'apimToInternet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

resource nsgRegion1 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${networkSecurityGroupName}-${locationRegion1}'
  location: locationRegion1
  properties: {
    securityRules: [
      {
        name: 'Client_communication_to_API_Management'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          destinationPortRanges: [
            '80'
            '443'
          ]
        }
      }
      {
        name: 'Management_endpoint_for_Azure_portal_and_Powershell'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3443'
          sourceAddressPrefix: 'ApiManagement'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'Azure_Infrastructure_Load_Balancer'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '6390'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 125
          direction: 'Inbound'
        }
      }
      {
        name: 'Azure_Traffic_Manager_routing_for_multi_region_deployment'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'AzureTrafficManager'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'Dependency_on_Azure_Storage_for_core_service_functionality'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 140
          direction: 'Outbound'
        }
      }
      {
        name: 'Access_to_Azure_SQL_endpoints_for_core_service_functionality'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Sql'
          access: 'Allow'
          priority: 150
          direction: 'Outbound'
        }
      }
      {
        name: 'Access_to_Azure_Key_Vault_for_core_service_functionality'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureKeyVault'
          access: 'Allow'
          priority: 160
          direction: 'Outbound'
        }
      }
      {
        name: 'Publish_Diagnostics_Logs_and_Metrics_Resource_Health_and_Application_Insights'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '1886'
            '443'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureMonitor'
          access: 'Allow'
          priority: 170
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource nsgRegion2 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${networkSecurityGroupName}-${locationRegion2}'
  location: locationRegion2
  properties: {
    securityRules: [
      {
        name: 'Client_communication_to_API_Management'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
          destinationPortRanges: [
            '80'
            '443'
          ]
        }
      }
      {
        name: 'Management_endpoint_for_Azure_portal_and_Powershell'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3443'
          sourceAddressPrefix: 'ApiManagement'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Inbound'
        }
      }
      {
        name: 'Azure_Infrastructure_Load_Balancer'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '6390'
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 125
          direction: 'Inbound'
        }
      }
      {
        name: 'Azure_Traffic_Manager_routing_for_multi_region_deployment'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'AzureTrafficManager'
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
        }
      }
      {
        name: 'Dependency_on_Azure_Storage_for_core_service_functionality'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Storage'
          access: 'Allow'
          priority: 140
          direction: 'Outbound'
        }
      }
      {
        name: 'Access_to_Azure_SQL_endpoints_for_core_service_functionality'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'Sql'
          access: 'Allow'
          priority: 150
          direction: 'Outbound'
        }
      }
      {
        name: 'Access_to_Azure_Key_Vault_for_core_service_functionality'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureKeyVault'
          access: 'Allow'
          priority: 160
          direction: 'Outbound'
        }
      }
      {
        name: 'Publish_Diagnostics_Logs_and_Metrics_Resource_Health_and_Application_Insights'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '1886'
            '443'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'AzureMonitor'
          access: 'Allow'
          priority: 170
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource publicIpRegion1 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${publicIPName}-${locationRegion1}'
  location: locationRegion1
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: publicIpDnsLabelPrefix
    }
  }
}

resource publicIpRegion2 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${publicIPName}-${locationRegion2}'
  location: locationRegion2
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: publicIpDnsLabelPrefix
    }
  }
}

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The Application Insights Instrumentation Key')
output appInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('The Application Insights ResourceId')
output appInsightsResourceId string = applicationInsights.id

@description('The resource ID of the created Public IP for Region1.')
output publicIPResourceIdRegion1 string = publicIpRegion1.id

@description('The resource ID of the created Public IP for Region2.')
output publicIPResourceIdRegion2 string = publicIpRegion2.id

@description('The resource ID of the created Public IP for Region1.')
output subnetResourceIdRegion1 string = vnetRegion1.properties.subnets[0].id

@description('The resource ID of the created Public IP for Region1.')
output subnetResourceIdRegion2 string = vnetRegion2.properties.subnets[0].id
