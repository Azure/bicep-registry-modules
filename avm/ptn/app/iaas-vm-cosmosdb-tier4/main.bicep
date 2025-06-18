metadata name = 'IaaS VM with CosmosDB Tier 4'
metadata description = 'Creates an IaaS VM with CosmosDB Tier 4 configuration.'

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
param tags object = {}

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
    tags: tags
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
    tags: tags
    securityRules: applicationNsgRules
    enableTelemetry: enableTelemetry
  }
}

module privateEndpointNsg 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-privateendpoint-nsg'
  params: {
    name: 'nsg-${name}-privateendpoints'
    location: location
    tags: tags
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
    tags: tags
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
          sourceAddressPrefix: '10.0.1.0/24' // Restrict to Bastion subnet
          destinationAddressPrefix: '10.0.0.0/24' // Only allow to application subnet
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
          sourceAddressPrefix: '10.0.1.0/24' // Restrict to Bastion subnet
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
          sourceAddressPrefix: '10.0.1.0/24' // Restrict to Bastion subnet
          destinationAddressPrefix: '10.0.1.0/24' // Only within Bastion subnet
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
          sourceAddressPrefix: '10.0.1.0/24' // Restrict to Bastion subnet
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
  name: '${uniqueString(deployment().name, location)}-vnet'
  params: {
    name: 'vnet-${name}'
    location: location
    tags: tags
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
module storageAccount 'br/public:avm/res/storage/storage-account:0.20.0' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: 'st${take(replace(replace(replace(replace(toLower(name), '-', ''), '_', ''), '#', ''), '.', ''), 6)}${take(uniqueString(resourceGroup().id), 10)}'
    location: location
    tags: tags
    skuName: storageAccountSku.name
    allowBlobPublicAccess: false
    defaultToOAuthAuthentication: true
    minimumTlsVersion: 'TLS1_2'
    enableTelemetry: enableTelemetry
  }
}

// SSH public key generation via deployment script
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'id-${name}-sshkey'
  location: location
  tags: tags
}

resource contributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, 'ManagedIdentityContributor', name)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('Optional. Do not provide a value. Used to force the deployment script to rerun on every redeployment.')
param utcValue string = utcNow()

// PSRule: Azure.Deployment.OutputSecretValue - SSH public key is infrastructure data, not user secrets
resource sshKeyGenerationScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'ds-${name}-sshkey'
  location: location
  tags: tags
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '8.0'
    retentionInterval: 'P1D'
    arguments: '-ResourceGroupName ${resourceGroup().name} -SSHKeyName ${name}-vm-key'
    scriptContent: '''
<#
.SYNOPSIS
Generate a new Public SSH Key or fetch it from an existing Public SSH Key resource.

.DESCRIPTION
Generate a new Public SSH Key or fetch it from an existing Public SSH Key resource.

.PARAMETER SSHKeyName
Mandatory. The name of the Public SSH Key Resource as it would be deployed in Azure

.PARAMETER ResourceGroupName
Mandatory. The resource group name of the Public SSH Key Resource as it would be deployed in Azure

.EXAMPLE
./New-SSHKey.ps1 -SSHKeyName 'myKeyResource' -ResourceGroupName 'ssh-rg'

Generate a new Public SSH Key or fetch it from an existing Public SSH Key resource 'myKeyResource' in Resource Group 'ssh-rg'
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $SSHKeyName,

    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName
)

if (-not ($sshKey = Get-AzSshKey -ResourceGroupName $ResourceGroupName | Where-Object { $_.Name -eq $SSHKeyName })) {
    Write-Verbose "No SSH key [$SSHKeyName] found in Resource Group [$ResourceGroupName]. Generating new." -Verbose
    $null = ssh-keygen -f generated -N (Get-Random -Maximum 99999)
    $publicKey = Get-Content 'generated.pub' -Raw
    # $privateKey = cat generated | Out-String
} else {
    Write-Verbose "SSH key [$SSHKeyName] found in Resource Group [$ResourceGroupName]. Returning." -Verbose
    $publicKey = $sshKey.publicKey
}
# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    # Note: This output is needed for the SSH public key resource
    # PSRule exception: This is infrastructure setup data, not user secrets
    publicKey = $publicKey | Out-String
}
'''
    cleanupPreference: 'OnExpiration'
    forceUpdateTag: utcValue
  }
  dependsOn: [
    contributorRoleAssignment
  ]
}

// SSH public key for VM
module sshPublicKey 'br/public:avm/res/compute/ssh-public-key:0.4.3' = {
  name: '${uniqueString(deployment().name, location)}-ssh-key'
  params: {
    name: '${name}-vm-key'
    location: location
    tags: tags
    publicKey: sshKeyGenerationScript.properties.outputs.publicKey
    enableTelemetry: enableTelemetry
  }
}

// Load balancer
module loadBalancer 'br/public:avm/res/network/load-balancer:0.4.2' = {
  name: '${uniqueString(deployment().name, location)}-lb'
  params: {
    name: 'lb-${name}'
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
  name: '${uniqueString(deployment().name, location)}-vm'
  params: {
    name: 'vm-${name}'
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
        keyData: sshKeyGenerationScript.properties.outputs.publicKey
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
      caching: 'ReadWrite'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    nicConfigurations: [
      {
        name: 'primary-nic'
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
  name: '${uniqueString(deployment().name, location)}-rsv'
  params: {
    name: 'rsv-${name}'
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
    immutabilitySettingState: 'Unlocked'
    enableTelemetry: enableTelemetry
  }
}

// CosmosDB MongoDB
module cosmosdbAccount 'br/public:avm/res/document-db/database-account:0.15.0' = {
  name: 'cosmosdbAccount-${uniqueString(deployment().name, location)}'
  params: {
    name: 'cosmos-${name}'
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
  name: '${uniqueString(deployment().name, location)}-dns'
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
  name: '${uniqueString(deployment().name, location)}-cosmos-pe'
  params: {
    name: 'pep-${name}-cosmos'
    location: location
    tags: tags
    subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
    privateLinkServiceConnections: [
      {
        name: 'pep-${name}-cosmos-conn'
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
