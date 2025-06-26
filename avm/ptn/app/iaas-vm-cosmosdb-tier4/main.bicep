metadata name = 'IaaS VM with CosmosDB Tier 4'
metadata description = 'Creates an IaaS VM with CosmosDB Tier 4 resiliency configuration.'

@description('Required. Name of the solution which is used to generate unique resource names.')
param name string

@description('General. Location for all resources.')
param location string = resourceGroup().location

@description('General. Tags for all resources. Should include standard tags like Environment, Owner, CostCenter, etc.')
@metadata({
  example: {
    Environment: 'Production'
    Owner: 'TeamName'
    CostCenter: 'IT'
    Application: 'MyApp'
  }
})
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// Network security group parameters
@description('Security. Network security group rules for the application subnet.')
param applicationNsgRules array = [
  {
    name: 'DenyManagementOutbound'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRanges: [
        '22'
        '3389'
        '5985'
        '5986'
      ]
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Deny'
      priority: 4000
      direction: 'Outbound'
    }
  }
]

@description('Security. Network security group rules for the VM.')
param vmNsgRules array = [
  {
    name: 'HTTP'
    properties: {
      protocol: 'Tcp'
      sourcePortRange: '*'
      destinationPortRange: '80'
      sourceAddressPrefix: 'VirtualNetwork'
      destinationAddressPrefix: '*'
      access: 'Allow'
      priority: 300
      direction: 'Inbound'
    }
  }
  {
    name: 'DenyManagementOutbound'
    properties: {
      protocol: '*'
      sourcePortRange: '*'
      destinationPortRanges: [
        '22'
        '3389'
        '5985'
        '5986'
      ]
      sourceAddressPrefix: '*'
      destinationAddressPrefix: '*'
      access: 'Deny'
      priority: 4000
      direction: 'Outbound'
    }
  }
]

// Virtual network parameters
@description('Networking. Address prefix for the virtual network.')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Networking. Subnet configuration for the virtual network.')
param subnets array = [
  {
    name: 'snet-application'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'snet-privateendpoints'
    addressPrefix: '10.0.1.0/24'
  }
  {
    name: 'snet-bootdiagnostics'
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

@description('Security. SSH public key for the virtual machine. If empty, a new SSH key will be generated.')
@secure()
param sshPublicKey string = ''

@description('Security. Enables encryption at host for the virtual machine.')
param encryptionAtHost bool = true

@description('Compute. Virtual machine availability zone. Set to 0 for no zone.')
param virtualMachineZone int = 1

@description('Compute. Virtual machine image reference configuration.')
param virtualMachineImageReference object = {
  publisher: 'canonical'
  offer: 'ubuntu-24_04-lts'
  sku: 'server'
  version: 'latest'
}

@description('Storage. Virtual machine OS disk configuration.')
param virtualMachineOsDisk object = {
  createOption: 'FromImage'
  diskSizeGB: 30
  caching: 'ReadWrite'
  managedDisk: {
    storageAccountType: 'Premium_LRS'
  }
}

@description('Identity. Virtual machine managed identity configuration.')
param virtualMachineManagedIdentities object = {
  systemAssigned: true
}

@description('Networking. Virtual machine NIC configurations.')
param virtualMachineNicConfigurations array = [
  {
    name: 'primary-nic'
    ipConfigurations: [
      {
        name: 'ipconfig1'
      }
    ]
    deleteOption: 'Delete'
  }
]

// Storage account parameters
@description('Storage. Storage account SKU configuration.')
param storageAccountConfiguration object = {
  name: 'Standard_GRS'
  tier: 'Standard'
}

// Load balancer parameters
@description('Networking. Load balancer configuration.')
param loadBalancerConfiguration object = {
  frontendPort: 80
  backendPort: 80
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.app-iaasvmcosmosdbt4.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  name: '${uniqueString(deployment().name, location)}-vm-nsg'
  params: {
    name: 'nsg-${name}-vm'
    location: location
    tags: tags ?? {}
    securityRules: vmNsgRules
    enableTelemetry: enableTelemetry
  }
}

// Network security groups for subnets
module applicationNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-application-nsg'
  params: {
    name: 'nsg-${name}-application'
    location: location
    tags: tags ?? {}
    securityRules: applicationNsgRules
    enableTelemetry: enableTelemetry
  }
}

module privateEndpointNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-privateendpoint-nsg'
  params: {
    name: 'nsg-${name}-privateendpoints'
    location: location
    tags: tags ?? {}
    securityRules: [
      {
        name: 'DenyManagementOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '22'
            '3389'
            '5985'
            '5986'
          ]
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4000
          direction: 'Outbound'
        }
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module bootDiagnosticsNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-bootdiagnostics-nsg'
  params: {
    name: 'nsg-${name}-bootdiagnostics'
    location: location
    tags: tags ?? {}
    securityRules: [
      {
        name: 'DenyManagementOutbound'
        properties: {
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '22'
            '3389'
            '5985'
            '5986'
          ]
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4000
          direction: 'Outbound'
        }
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

module bastionNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-bastion-nsg'
  params: {
    name: 'nsg-${name}-bastion'
    location: location
    tags: tags ?? {}
    securityRules: [
      // Required Inbound Rules for Azure Bastion
      {
        name: 'AllowHttpsInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 100
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowGatewayManagerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 110
          sourceAddressPrefix: 'GatewayManager'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowAzureLoadBalancerInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 120
          sourceAddressPrefix: 'AzureLoadBalancer'
          destinationAddressPrefix: '*'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionHostCommunicationInbound'
        properties: {
          access: 'Allow'
          direction: 'Inbound'
          priority: 130
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      // Required Outbound Rules for Azure Bastion
      {
        name: 'AllowSshRdpOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 100
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '22'
            '3389'
          ]
        }
      }
      {
        name: 'AllowAzureCloudOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 110
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'AzureCloud'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowBastionCommunicationOutbound'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 120
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRanges: [
            '8080'
            '5701'
          ]
        }
      }
      {
        name: 'AllowGetSessionInformation'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          priority: 130
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '80'
        }
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Virtual network with subnets
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: 'vnet-${name}'
    location: location
    tags: tags ?? {}
    addressPrefixes: [
      vnetAddressPrefix
    ]
    subnets: [
      {
        name: subnets[0].name
        addressPrefix: subnets[0].addressPrefix
        networkSecurityGroupResourceId: applicationNsg.outputs.resourceId
      }
      {
        name: subnets[1].name
        addressPrefix: subnets[1].addressPrefix
        networkSecurityGroupResourceId: privateEndpointNsg.outputs.resourceId
      }
      {
        name: subnets[2].name
        addressPrefix: subnets[2].addressPrefix
        networkSecurityGroupResourceId: bootDiagnosticsNsg.outputs.resourceId
      }
      {
        name: subnets[3].name
        addressPrefix: subnets[3].addressPrefix
        networkSecurityGroupResourceId: bastionNsg.outputs.resourceId
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Storage account for boot diagnostics
module storageAccount 'br/public:avm/res/storage/storage-account:0.22.1' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: 'st${take(replace(replace(replace(replace(toLower(name), '-', ''), '_', ''), '#', ''), '.', ''), 6)}${take(uniqueString(resourceGroup().id), 10)}'
    location: location
    tags: tags ?? {}
    skuName: storageAccountConfiguration.name
    allowBlobPublicAccess: false
    defaultToOAuthAuthentication: true
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    enableTelemetry: enableTelemetry
  }
}

// SSH Key Resource - generates or uses provided SSH key
var managedIdentityName = 'sshKeyGenIdentity'
var sshKeyName = 'sshKey'
var sshDeploymentScriptName = '${take(uniqueString(resourceGroup().name, location),4)}-sshDeploymentScript'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = if (empty(sshPublicKey)) {
  name: '${uniqueString(resourceGroup().id, location)}-${managedIdentityName}'
  tags: tags ?? {}
  location: location
}

resource msiRGContrRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'ssh-Contributor', managedIdentity.id)
  scope: resourceGroup()
  properties: {
    principalId: managedIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalType: 'ServicePrincipal'
  }
}

resource sshDeploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = if (empty(sshPublicKey)) {
  name: sshDeploymentScriptName
  location: location
  tags: tags ?? {}
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-SSHKeyName "${sshKeyName}" -ResourceGroupName "${resourceGroup().name}"'
    scriptContent: loadTextContent('../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')
  }
  dependsOn: [
    msiRGContrRoleAssignment
  ]
}

resource sshKey 'Microsoft.Compute/sshPublicKeys@2024-07-01' = {
  name: '${take(uniqueString(resourceGroup().name, location),4)}-${sshKeyName}'
  location: location
  tags: tags ?? {}
  properties: {
    publicKey: (!empty(sshPublicKey)) ? sshPublicKey : sshDeploymentScript.properties.outputs.publicKey
  }
}

// Load balancer
module loadBalancer 'br/public:avm/res/network/load-balancer:0.4.2' = {
  name: '${uniqueString(deployment().name, location)}-lb'
  params: {
    name: 'lb-${name}'
    location: location
    tags: tags ?? {}
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
        frontendPort: loadBalancerConfiguration.frontendPort
        backendPort: loadBalancerConfiguration.backendPort
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
        port: loadBalancerConfiguration.backendPort
        intervalInSeconds: 15
        numberOfProbes: 2
        probeThreshold: 1
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Virtual machine
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.15.0' = {
  name: '${uniqueString(deployment().name, location)}-vm'
  params: {
    name: 'vm-${name}'
    location: location
    tags: tags ?? {}
    zone: virtualMachineZone
    managedIdentities: virtualMachineManagedIdentities
    osType: 'Linux'
    vmSize: vmSize
    adminUsername: adminUsername
    disablePasswordAuthentication: true
    encryptionAtHost: encryptionAtHost
    publicKeys: [
      {
        keyData: (!empty(sshPublicKey)) ? sshPublicKey : sshKey.properties.publicKey
        path: '/home/${adminUsername}/.ssh/authorized_keys'
      }
    ]
    imageReference: virtualMachineImageReference
    osDisk: virtualMachineOsDisk
    nicConfigurations: [
      for (nicConfig, index) in virtualMachineNicConfigurations: {
        name: nicConfig.name
        tags: tags ?? {}
        ipConfigurations: [
          {
            name: nicConfig.ipConfigurations[0].name
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
          }
        ]
        deleteOption: nicConfig.deleteOption
      }
    ]
    bootDiagnostics: true
    bootDiagnosticStorageAccountName: storageAccount.outputs.name
    enableTelemetry: enableTelemetry
  }
}

// Recovery Services Vault
module recoveryServicesVault 'br/public:avm/res/recovery-services/vault:0.9.1' = {
  name: '${uniqueString(deployment().name, location)}-rsv'
  params: {
    name: 'rsv-${name}'
    location: location
    tags: tags ?? {}
    publicNetworkAccess: 'Disabled'
    replicationAlertSettings: {
      customEmailAddresses: [
        'test.user@testcompany.com'
      ]
      locale: 'en-US'
      sendToOwners: 'Send'
    }
    immutabilitySettingState: 'Unlocked'
    enableTelemetry: enableTelemetry
  }
}

// CosmosDB MongoDB
module cosmosdbAccount 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: 'cosmosdbAccount-${uniqueString(deployment().name, location)}'
  params: {
    name: 'cosmos-${toLower(name)}'
    location: location
    tags: tags ?? {}
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
  name: '${uniqueString(deployment().name, location)}-dns'
  params: {
    name: 'privatelink.documents.azure.com'
    location: 'global'
    tags: tags ?? {}
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
  name: '${uniqueString(deployment().name, location)}-cosmos-pe'
  params: {
    name: 'pep-${name}-cosmos'
    location: location
    tags: tags ?? {}
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
    privateLinkServiceConnections: [
      {
        name: 'pep-${name}-cosmos-conn'
        properties: {
          groupIds: [
            'Sql'
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

// Private DNS Zone for Storage Account
module storagePrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = {
  name: '${uniqueString(deployment().name, location)}-storage-dns'
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
    location: 'global'
    tags: tags ?? {}
    virtualNetworkLinks: [
      {
        name: uniqueString(virtualNetwork.outputs.resourceId, 'storage')
        virtualNetworkResourceId: virtualNetwork.outputs.resourceId
        registrationEnabled: false
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// Private Endpoint for Storage Account
module storagePrivateEndpoint 'br/public:avm/res/network/private-endpoint:0.11.0' = {
  name: '${uniqueString(deployment().name, location)}-storage-pe'
  params: {
    name: 'pep-${name}-storage'
    location: location
    tags: tags ?? {}
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
    privateLinkServiceConnections: [
      {
        name: 'pep-${name}-storage-conn'
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceId: storageAccount.outputs.resourceId
        }
      }
    ]
    privateDnsZoneGroup: {
      name: 'default'
      privateDnsZoneGroupConfigs: [
        {
          privateDnsZoneResourceId: storagePrivateDnsZone.outputs.resourceId
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

@description('Resource. The resource ID of the storage account.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('Resource. The resource ID of the storage private endpoint.')
output storagePrivateEndpointResourceId string = storagePrivateEndpoint.outputs.resourceId
