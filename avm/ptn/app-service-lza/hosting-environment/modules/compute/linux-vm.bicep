targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

param vmName string
param vmSize string
param vmZone int = 0
param vmVnetName string
param vmSubnetName string
param vmSubnetAddressPrefix string
param vmNetworkSecurityGroupName string
param vmNetworkInterfaceName string
param logAnalyticsWorkspaceResourceId string
param bastionResourceId string
param vmAdminUsername string

@secure()
param vmAdminPassword string

@description('Optional. Name of the SSH key for the jumpbox.')
param sshKeyName string = 'jumpboxSshKey'

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

param location string = resourceGroup().location

@description('Optional. The name of the user-assigned identity to be used to generate SSH key for Linux VM. Changing this forces a new resource to be created.')
param sshKeyGenName string = guid(resourceGroup().id, 'userAssignedIdentity')

var roleAssignmentName = guid(resourceGroup().id, 'contributor')
var contributorRoleDefinitionId = resourceId(
  'Microsoft.Authorization/roleDefinitions',
  'b24988ac-6180-42a0-ab88-20f7382dd24c'
)

var uami = resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', sshKeyGenName)
// ------------------
// VARIABLES
// ------------------

// ------------------
// RESOURCES
// ------------------

module vmNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.2.0' = {
  name: 'vmNetworkSecurityDeployment'
  params: {
    name: vmNetworkSecurityGroupName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    securityRules: !empty(bastionResourceId)
      ? [
          {
            name: 'allow-bastion-inbound'
            properties: {
              description: 'Allow inbound traffic from Bastion to the JumpBox'
              protocol: '*'
              sourceAddressPrefix: 'Bastion'
              sourcePortRange: '*'
              destinationAddressPrefix: '*'
              destinationPortRange: '*'
              access: 'Allow'
              priority: 100
              direction: 'Inbound'
            }
          }
          {
            name: 'deny-hop-outbound'
            properties: {
              priority: 200
              access: 'Deny'
              protocol: 'Tcp'
              direction: 'Outbound'
              sourceAddressPrefix: 'VirtualNetwork'
              destinationAddressPrefix: '*'
              destinationPortRanges: [
                '3389'
                '22'
              ]
            }
          }
        ]
      : [
          {
            name: 'deny-hop-outbound'
            properties: {
              priority: 200
              access: 'Deny'
              protocol: 'Tcp'
              direction: 'Outbound'
              sourceAddressPrefix: 'VirtualNetwork'
              destinationAddressPrefix: '*'
              destinationPortRanges: [
                '3389'
                '22'
              ]
            }
          }
        ]
  }
}

//TODO: Subnet deployment needs to be updated with AVM module once it is available
resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  name: '${vmVnetName}/${vmSubnetName}'
  properties: {
    addressPrefix: vmSubnetAddressPrefix
    networkSecurityGroup: {
      id: vmNetworkSecurityGroup.outputs.resourceId
    }
  }
}
resource maintenanceConfiguration 'Microsoft.Maintenance/maintenanceConfigurations@2023-10-01-preview' = {
  name: 'dep-mc-${vmName}'
  location: location
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2024-06-16 00:00'
      duration: '03:55'
      timeZone: 'W. Europe Standard Time'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}

@description('The User Assigned Managed Identity that will be given Contributor role on the Resource Group in order to auto-approve the Private Endpoint Connection of the AFD.')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: '${sshKeyGenName}-deployment'
  params: {
    name: sshKeyGenName
    location: location
  }
}

@description('The role assignment that will be created to give the User Assigned Managed Identity Contributor role on the Resource Group in order to auto-approve the Private Endpoint Connection of the AFD.')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentName
  scope: resourceGroup()
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: userAssignedIdentity.outputs.principalId
    principalType: 'ServicePrincipal'
  }
}

resource sshDeploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'sshDeploymentScriptName'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uami}': {}
    }
  }
  properties: {
    azPowerShellVersion: '9.0'
    retentionInterval: 'P1D'
    arguments: '-SSHKeyName "${sshKeyName}" -ResourceGroupName "${resourceGroup().name}"'
    scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')
  }
  dependsOn: [
    roleAssignment
  ]
}

resource sshKey 'Microsoft.Compute/sshPublicKeys@2022-03-01' = {
  name: sshKeyName
  location: location
  properties: {
    publicKey: sshDeploymentScript.properties.outputs.publicKey
  }
}

module vm 'br/public:avm/res/compute/virtual-machine:0.12.0' = {
  name: 'vmDeployment'
  params: {
    name: vmName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    osType: 'Linux'
    computerName: vmName
    adminUsername: vmAdminUsername
    adminPassword: ((vmAuthenticationType == 'password') ? vmAdminPassword : null)
    disablePasswordAuthentication: ((vmAuthenticationType == 'sshPublicKey') ? true : false)
    encryptionAtHost: false
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByPlatform'
    bypassPlatformSafetyChecksOnUserSchedule: true
    maintenanceConfigurationResourceId: maintenanceConfiguration.id
    publicKeys: ((vmAuthenticationType == 'sshPublicKey')
      ? [
          {
            keyData: sshKey.properties.publicKey
            path: '/home/${vmAdminUsername}/.ssh/authorized_keys'
          }
        ]
      : [])
    nicConfigurations: [
      {
        name: vmNetworkInterfaceName
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipConfig01'
            privateIPAllocationMethod: 'Dynamic'
            subnetResourceId: vmSubnet.id
          }
        ]
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      createOption: 'FromImage'
      deleteOption: 'Delete'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    zone: vmZone
    vmSize: vmSize
    imageReference: {
      publisher: 'canonical'
      offer: '0001-com-ubuntu-server-focal'
      sku: '20_04-lts-gen2'
      version: 'latest'
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      tags: tags
      monitoringWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    }
  }
}
