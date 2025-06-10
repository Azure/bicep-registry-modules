metadata name = 'IaaS VM with CosmosDB Tier 4'
metadata description = 'Creates an IaaS VM with CosmosDB Tier 4 configuration.'

@description('Required. Name of the solution which is used to generate unique resource names.')
param name string

@description('General. Location for all resources.')
param location string = resourceGroup().location

@description('General. Tags for all resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// Network security group parameters
@description('Security. Network security group rules for the ApplicationSubnet.')
param applicationNsgRules array = []

@description('Security. Network security group rules for the VM.')
param vmNsgRules array = [
  {
    name: 'HTTP'
    properties: {
      protocol: 'TCP'
      sourcePortRange: '*'
      destinationPortRange: '80'
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 300
      direction: 'Inbound'
    }
  }
]

// Virtual network parameters
@description('Networking. Address prefix for the virtual network.')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Networking. Subnet configuration for the virtual network.')
param subnets array = [
  {
    name: 'ApplicationSubnet'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'PrivateEndpointsSubnet'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'BootDiagnosticsSubnet'
    addressPrefix: '10.0.2.0/24'
  }
  {
    name: 'AzureBastionSubnet'
    addressPrefix: '10.0.3.0/26'
  }
]

// Virtual machine parameters
@description('Compute. Size of the virtual machine.')
param vmSize string = 'Standard_D2s_v3'

@description('Security. Admin username for the virtual machine.')
param adminUsername string = 'azureuser'

// Storage account parameters
@description('Storage. Storage account SKU.')
param storageAccountSku object = {
  name: 'Standard_GRS'
  tier: 'Standard'
}

// Load balancer parameters
@description('Networking. Load balancer frontend port.')
param lbFrontendPort int = 80

@description('Networking. Load balancer backend port.')
param lbBackendPort int = 80


#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.app-iaasvmcosmosdbt4.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

// Network security group for VM
module vmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${name}-vm-nsg'
  params: {
    name: '${name}-vm-nsg'
    location: location
    tags: tags
    securityRules: vmNsgRules
    enableTelemetry: enableTelemetry
  }
}

// Network security groups for subnets
module applicationNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${name}-application-nsg'
  params: {
    name: 'ApplicationSubnet'
    location: location
    tags: tags
    securityRules: applicationNsgRules
    enableTelemetry: enableTelemetry
  }
}

module privateEndpointNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${name}-privateendpoint-nsg'
  params: {
    name: 'PrivateEndpointSubnet'
    location: location
    tags: tags
    securityRules: []
    enableTelemetry: enableTelemetry
  }
}

module bootDiagnosticsNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${name}-bootdiagnostics-nsg'
  params: {
    name: 'BootDiagnosticsSubnet'
    location: location
    tags: tags
    securityRules: []
    enableTelemetry: enableTelemetry
  }
}

module bastionNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${name}-bastion-nsg'
  params: {
    name: 'AzureBastionSubnet'
    location: location
    tags: tags
    securityRules: [
      {
        name: 'AllowHttpsInBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
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
          destinationPortRange: '443'
          sourceAddressPrefix: 'GatewayManager'
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
          destinationPortRange: '443'
          sourceAddressPrefix: 'AzureLoadBalancer'
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
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 130
          direction: 'Inbound'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'DenyAllInBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
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
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 100
          direction: 'Outbound'
          destinationPortRanges: [
            '22'
            '3389'
          ]
        }
      }
      {
        name: 'AllowAzureCloudCommunicationOutBound'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
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
          destinationAddressPrefix: 'VirtualNetwork'
          access: 'Allow'
          priority: 120
          direction: 'Outbound'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowGetSessionInformationOutBound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          access: 'Allow'
          priority: 130
          direction: 'Outbound'
          destinationPortRanges: [
            '80'
            '443'
          ]
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
    enableTelemetry: enableTelemetry
  }
}

// Virtual network with subnets
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = {
  name: '${name}-vnet'
  params: {
    name: '${name}-vnet'
    location: location
    tags: tags
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets: [
      {
        name: 'ApplicationSubnet'
        addressPrefix: subnets[0].addressPrefix
        networkSecurityGroupResourceId: applicationNsg.outputs.resourceId
      }
      {
        name: 'PrivateEndpointsSubnet'
        addressPrefix: subnets[1].addressPrefix
        networkSecurityGroupResourceId: privateEndpointNsg.outputs.resourceId
      }
      {
        name: 'BootDiagnosticsSubnet'
        addressPrefix: subnets[2].addressPrefix
        networkSecurityGroupResourceId: bootDiagnosticsNsg.outputs.resourceId
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: subnets[3].addressPrefix
        networkSecurityGroupResourceId: bastionNsg.outputs.resourceId
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Storage account for boot diagnostics
module storageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: '${name}-storage'
  params: {
    name: replace('${name}stdiag', '-', '')
    location: location
    tags: tags
    skuName: storageAccountSku.name
    allowBlobPublicAccess: false
    defaultToOAuthAuthentication: true
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
  }
}

// SSH public key for VM
module sshPublicKey 'br/public:avm/res/compute/ssh-public-key:0.4.3' = {
  name: '${name}-ssh-key'
  params: {
    name: '${name}-vm-key'
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

// Load balancer
module loadBalancer 'br/public:avm/res/network/load-balancer:0.4.2' = {
  name: '${name}-lb'
  params: {
    name: '${name}-lb'
    location: location
    tags: tags
    frontendIPConfigurations: [
      {
        name: '${name}-lb-frontendconfig01'
        subnetId: virtualNetwork.outputs.subnetResourceIds[0]
        zones: [
          1
          2
          3
        ]
      }
    ]
    backendAddressPools: [
      {
        name: '${name}-lb-backendpool01'
      }
    ]
    loadBalancingRules: [
      {
        name: '${name}-lb-lbrule01'
        frontendIPConfigurationName: '${name}-lb-frontendconfig01'
        frontendPort: lbFrontendPort
        backendPort: lbBackendPort
        enableFloatingIP: false
        idleTimeoutInMinutes: 15
        protocol: 'Tcp'
        loadDistribution: 'Default'
        disableOutboundSnat: true
        backendAddressPoolName: '${name}-lb-backendpool01'
        probeEnabled: true
        probeName: '${name}-lb-probe01'
      }
    ]
    probes: [
      {
        name: '${name}-lb-probe01'
        protocol: 'Tcp'
        port: lbBackendPort
        intervalInSeconds: 15
        numberOfProbes: 2
        probeThreshold: 1
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Network interface for VM
module networkInterface 'br/public:avm/res/network/network-interface:0.5.2' = {
  name: '${name}-vm-nic'
  params: {
    name: '${name}-vm-nic'
    location: location
    tags: tags
    ipConfigurations: [
      {
        name: 'ipconfig1'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
        loadBalancerBackendAddressPools: [
          {
            id: loadBalancer.outputs.backendpools[0].id
          }
        ]
      }
    ]
    networkSecurityGroupResourceId: vmNetworkSecurityGroup.outputs.resourceId
    enableTelemetry: enableTelemetry
  }
}

// Virtual machine
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.15.0' = {
  name: '${name}-vm'
  params: {
    name: '${name}-vm'
    location: location
    tags: tags
    zone: 1
    managedIdentities: {
      systemAssigned: true
    }
    osType: 'Linux'
    vmSize: vmSize
    adminUsername: adminUsername
    disablePasswordAuthentication: true
    publicKeys: [
      {
        keyData: sshPublicKey.outputs.resourceId
        path: '/home/${adminUsername}/.ssh/authorized_keys'
      }
    ]
    imageReference: {
      publisher: 'canonical'
      offer: 'ubuntu-24_04-lts'
      sku: 'server'
      version: 'latest'
    }
    osDisk: {
      createOption: 'FromImage'
      diskSizeGB: 30
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    nicConfigurations: [
      {
        name: 'primary-nic'
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
            loadBalancerBackendAddressPools: [
              {
                id: loadBalancer.outputs.backendpools[0].id
              }
            ]
          }
        ]
        networkSecurityGroupResourceId: vmNetworkSecurityGroup.outputs.resourceId
        deleteOption: 'Delete'
      }
    ]
    bootDiagnostics: true
    bootDiagnosticStorageAccountName: storageAccount.outputs.name
    enableTelemetry: enableTelemetry
  }
}

// Recovery Services Vault
module recoveryServicesVault 'br/public:avm/res/recovery-services/vault:0.9.1' = {
  name: '${name}-rsv'
  params: {
    name: '${name}-rsv'
    location: location
    tags: tags
    publicNetworkAccess: 'Disabled'
    replicationAlertSettings: {
      customEmailAddresses: [
        'test.user@testcompany.com'
      ]
      locale: 'en-US'
      sendToOwners: 'Send'
    }
    enableTelemetry: enableTelemetry
  }
}

// CosmosDB MongoDB
module cosmosdbAccount 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: 'cosmosdbAccount-${uniqueString(deployment().name, location)}'
  params: {
    name: '${name}-cosmos'
    location: location
    tags: tags
    defaultConsistencyLevel: 'Session'

    capabilitiesToAdd: [
      'EnableServerless'
    ]

    failoverLocations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]

    maxStalenessPrefix: 100
    maxIntervalInSeconds: 5

    networkRestrictions: {
      publicNetworkAccess: 'Disabled'
    }

    sqlDatabases: [
      {
        name: '${name}-cosmosdb'
        containers: [
          {
            name: 'defaultContainer'
            paths: [
              '/partitionKey'
            ]
          }
        ]
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Private DNS Zone for CosmosDB
module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: '${name}-dns'
  params: {
    name: 'privatelink.mongocluster.cosmos.azure.com'
    location: 'global'
    tags: tags
    virtualNetworkLinks: [
      {
        name: uniqueString(virtualNetwork.outputs.resourceId)
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Private Endpoint for CosmosDB
module privateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.0' = {
  name: '${name}-cosmos-pe'
  params: {
    name: '${name}-cosmos-pe'
    location: location
    tags: tags
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
    privateLinkServiceConnections: [
      {
        name: '${name}-cosmos-pe-conn'
        properties: {
          groupIds: [
            'MongoCluster'
          ]
          privateLinkServiceId: cosmosdbAccount.outputs.resourceId
        }
      }
    ]
    privateDnsZoneGroup: {
      name: 'default'
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
        }
      ]
    }
    enableTelemetry: enableTelemetry
  }
}

// Outputs
@description('Resource. The resource ID of the virtual machine.')
output virtualMachineResourceId string = virtualMachine.outputs.resourceId

@description('Resource. The resource ID of the CosmosDB MongoDB vCore cluster.')
output cosmosDbResourceId string = cosmosdbAccount.outputs.resourceId

@description('Resource. The resource ID of the virtual network.')
output virtualNetworkResourceId string = virtualNetwork.outputs.resourceId

@description('Resource. The resource ID of the load balancer.')
output loadBalancerResourceId string = loadBalancer.outputs.resourceId

@description('Resource. The resource ID.')
output resourceId string = virtualMachine.outputs.resourceId

@description('Resource. Resource Group Name.')
output resourceGroupName string = resourceGroup().name

@description('Resource. The name of the virtual machine.')
output name string = virtualMachine.outputs.name
