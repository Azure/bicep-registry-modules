@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param locationRegion1 string = resourceGroup().location

@description('Required. The location to deploy resources to.')
param locationRegion2 string

@description('Required. The name prefix of the Public IP to create.')
param publicIPNamePrefix string

@description('Required. The DNS Prefix to apply for the public IPs.')
param publicIpDnsLabelPrefix string

@description('Required. The name of the Application insights instance to create.')
param applicationInsightsName string

@description('Required. The name prefix of the Virtual Network to create.')
param virtualNetworkNamePrefix string

@description('Required. The name prefix of the NSG to create.')
param networkSecurityGroupNamePrefix string

@description('Required. The name prefix of the Route Table to create.')
param routeTableNamePrefix string

@description('Required. The name of the managed identity to create.')
param logAnalyticsWorkspaceName string

var addressPrefix = '10.0.0.0/16'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: locationRegion1
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: logAnalyticsWorkspaceName
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
  name: applicationInsightsName
  location: locationRegion1
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource vnetRegion1 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: '${virtualNetworkNamePrefix}-${locationRegion1}'
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
      {
        name: 'workspace-gateway-subnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
          networkSecurityGroup: {
            id: nsgRegion1.id
          }
          delegations: [
            {
              name: 'Microsoft.Web/serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

resource vnetRegion2 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: '${virtualNetworkNamePrefix}-${locationRegion2}'
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

resource routeTableRegion1 'Microsoft.Network/routeTables@2025-01-01' = {
  name: '${routeTableNamePrefix}-${locationRegion1}'
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

resource routeTableRegion2 'Microsoft.Network/routeTables@2025-01-01' = {
  name: '${routeTableNamePrefix}-${locationRegion2}'
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

resource nsgRegion1 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: '${networkSecurityGroupNamePrefix}-${locationRegion1}'
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

resource nsgRegion2 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: '${networkSecurityGroupNamePrefix}-${locationRegion2}'
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

resource publicIpRegion1 'Microsoft.Network/publicIPAddresses@2025-01-01' = {
  name: '${publicIPNamePrefix}-${locationRegion1}'
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

resource publicIpRegion2 'Microsoft.Network/publicIPAddresses@2025-01-01' = {
  name: '${publicIPNamePrefix}-${locationRegion2}'
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

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.azure-api.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2024-06-01' = {
    name: '${vnetRegion1.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: vnetRegion1.id
      }
      registrationEnabled: false
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

@description('The resource ID of the created virtual network subnet for a Private Endpoint.')
output privateEndpointSubnetResourceId string = vnetRegion1.properties.subnets[0].id

@description('The resource ID of the created virtual network subnet for a Workspace Gateway.')
output workspaceGatewaySubnetResourceId string = vnetRegion1.properties.subnets[1].id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id

@description('The resource ID of the created Public IP for Region1.')
output subnetResourceIdRegion1 string = vnetRegion1.properties.subnets[0].id

@description('The resource ID of the created Public IP for Region1.')
output subnetResourceIdRegion2 string = vnetRegion2.properties.subnets[0].id
