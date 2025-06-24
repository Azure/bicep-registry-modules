@description('Required. The location for all resource except HCI Arc Nodes and HCI resources')
param location string

@description('Optional. The Azure VM size for the HCI Host VM, which must support nested virtualization and have sufficient capacity for the HCI node VMs!')
param hostVMSize string = 'Standard_E32s_v5'

@description('Optional. The local admin user name.')
param localAdminUsername string = 'admin-hci'

@description('Optional. The domain admin user name.')
param domainAdminUsername string = 'Administrator'

@description('Optional. The domain admin user password.')
@secure()
param domainAdminPassword string

@description('Required. The local admin password.')
@secure()
param localAdminPassword string

@secure()
param arbDeploymentAppId string
@secure()
param arbDeploymentServicePrincipalSecret string

@description('Optional. The domain OU path.')
param domainOUPath string = 'OU=HCI,DC=jumpstart,DC=local'

@description('Optional. The deployment username.')
param deploymentUsername string = 'deployUser'

@description('Required. The name of the VM-managed user identity to create, used for HCI Arc onboarding.')
param userAssignedIdentityName string

@description('Required. The name of the VNET for the HCI host Azure VM.')
param virtualNetworkName string

@description('Required. The name of the NSG to create.')
param networkSecurityGroupName string

@description('Required. The name of the maintenance configuration for the Azure Stack HCI Host VM and proxy server.')
param maintenanceConfigurationName string

@description('Required. The name of the Azure VM scale set for the HCI host.')
param HCIHostVirtualMachineScaleSetName string

@description('Required. The name of the Network Interface Card to create.')
param networkInterfaceName string

@description('Required. The name of the Azure VM to create.')
param virtualMachineName string

@description('Required. The name of the Maintenance Configuration Assignment for the proxy server.')
param maintenanceConfigurationAssignmentName string

// =================================//
// Deploy Host VM Infrastructure    //
// =================================//

// vm managed identity used for HCI Arc onboarding
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  location: location
  name: userAssignedIdentityName
}

// grant identity owner permissions on the resource group
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().subscriptionId, userAssignedIdentity.name, 'Owner', resourceGroup().id)
  properties: {
    principalId: userAssignedIdentity.properties.principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
    principalType: 'ServicePrincipal'
    description: 'Role assigned used for Azure Stack HCI IaC testing pipeline - remove if identity no longer exists!'
  }
}

// grant identity contributor permissions on the subscription - needed to register resource providers
module roleAssignment_subscriptionContributor 'modules/subscriptionRoleAssignment.bicep' = {
  name: '${uniqueString(deployment().name, location)}-hcihostmi-roleAssignment_subContributor'
  scope: subscription()
  params: {
    principalId: userAssignedIdentity.properties.principalId
  }
}

// optional VNET and subnet for the HCI host Azure VM
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/8']
    }
    subnets: [
      {
        name: 'subnet01'
        properties: {
          addressPrefix: '10.0.0.0/8'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [location]
            }
            {
              service: 'Microsoft.KeyVault'
              locations: [location]
            }
          ]
        }
      }
    ]
  }
}

// create a mintenance configuration for the Azure Stack HCI Host VM and proxy server
resource maintenanceConfig 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
  location: location
  name: maintenanceConfigurationName ?? ''
  properties: {
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      recurEvery: 'Week Sunday'
      startDateTime: '2020-04-30 08:00'
      duration: '02:00'
      timeZone: 'UTC'
    }
    installPatches: {
      windowsParameters: {
        classificationsToInclude: ['Critical', 'Security']
      }
      rebootSetting: 'IfRequired'
    }
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  location: location
  name: networkSecurityGroupName
}

resource hciHostVMSSFlex 'Microsoft.Compute/virtualMachineScaleSets@2024-11-01' = {
  name: HCIHostVirtualMachineScaleSetName
  location: location
  zones: ['1', '2', '3']
  properties: {
    orchestrationMode: 'Flexible'
    platformFaultDomainCount: 1
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  location: location
  name: networkInterfaceName
  properties: {
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
    ipConfigurations: [
      {
        name: 'ipConfig01'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

param imageReferenceId string = '/SharedGalleries/b9e38f20-7c9c-4497-a25d-1a0c5eef2108-DIRECTLYSHARING/Images/vhci-Generalized/Versions/latest'

// Azure Stack HCI Host VM -
resource vm 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  location: location
  name: virtualMachineName
  zones: ['1']
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    virtualMachineScaleSet: {
      id: hciHostVMSSFlex.id
    }
    hardwareProfile: {
      vmSize: hostVMSize
    }
    priority: 'Regular'
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    storageProfile: {
      imageReference: {
        sharedGalleryImageId: imageReferenceId
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    osProfile: {
      adminPassword: localAdminPassword
      adminUsername: localAdminUsername
      computerName: 'hciHost01'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            bypassPlatformSafetyChecksOnUserSchedule: true
          }
        }
      }
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    licenseType: 'Windows_Server'
  }
}

resource maintenanceAssignment_hciHost 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = {
  location: location
  name: maintenanceConfigurationAssignmentName
  properties: {
    maintenanceConfigurationId: maintenanceConfig.id
  }
  scope: vm
}

resource wait 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  name: 'wait'
  location: location
  properties: {
    source: {
      script: loadTextContent('./scripts/wait.ps1')
    }
    treatFailureAsDeploymentFailure: true
    parameters: [
      {
        name: 'Minutes'
        value: '5'
      }
    ]
  }
}

// ================================================//
// Initialize Arc on HCI Node VMs and AD for HCI  //
// ==============================================//

resource ad 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  name: 'ad'
  location: location
  dependsOn: [
    wait
  ]
  properties: {
    source: {
      script: loadTextContent('./scripts/provision-ad.ps1')
    }
    treatFailureAsDeploymentFailure: true
    parameters: [
      {
        name: 'IP'
        value: '192.168.1.254'
      }
      {
        name: 'Port'
        value: '5985'
      }
      {
        name: 'Authentication'
        value: 'Default'
      }
      {
        name: 'DomainFQDN'
        value: 'jumpstart.local'
      }
      {
        name: 'AdministratorAccount'
        value: domainAdminUsername
      }
      {
        name: 'ADOUPath'
        value: domainOUPath
      }
      {
        name: 'DeploymentUserAccount'
        value: deploymentUsername
      }
    ]
    protectedParameters: [
      {
        name: 'AdministratorPassword'
        value: domainAdminPassword
      }
      {
        name: 'DeploymentUserPassword'
        value: domainAdminPassword
      }
    ]
  }
}

resource arc1 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  name: 'arc1'
  location: location
  dependsOn: [
    wait
  ]
  properties: {
    source: {
      script: loadTextContent('./scripts/provision-arc.ps1')
    }
    treatFailureAsDeploymentFailure: true
    parameters: [
      {
        name: 'IP'
        value: '192.168.1.12'
      }
      {
        name: 'Port'
        value: '5985'
      }
      {
        name: 'Authentication'
        value: 'Default'
      }
      {
        name: 'LocalAdministratorAccount'
        value: domainAdminUsername
      }
      {
        name: 'ServicePrincipalId'
        value: arbDeploymentAppId
      }
      {
        name: 'SubscriptionId'
        value: subscription().subscriptionId
      }
      {
        name: 'TenantId'
        value: subscription().tenantId
      }
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'Region'
        value: location
      }
    ]
    protectedParameters: [
      {
        name: 'LocalAdministratorPassword'
        value: domainAdminPassword
      }
      {
        name: 'ServicePrincipalSecret'
        value: arbDeploymentServicePrincipalSecret
      }
    ]
  }
}

resource arc2 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  name: 'arc2'
  location: location
  dependsOn: [
    wait
  ]
  properties: {
    source: {
      script: loadTextContent('./scripts/provision-arc.ps1')
    }
    treatFailureAsDeploymentFailure: true
    parameters: [
      {
        name: 'IP'
        value: '192.168.1.13'
      }
      {
        name: 'Port'
        value: '5985'
      }
      {
        name: 'Authentication'
        value: 'Default'
      }
      {
        name: 'LocalAdministratorAccount'
        value: domainAdminUsername
      }
      {
        name: 'ServicePrincipalId'
        value: arbDeploymentAppId
      }
      {
        name: 'SubscriptionId'
        value: subscription().subscriptionId
      }
      {
        name: 'TenantId'
        value: subscription().tenantId
      }
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'Region'
        value: location
      }
    ]
    protectedParameters: [
      {
        name: 'LocalAdministratorPassword'
        value: domainAdminPassword
      }
      {
        name: 'ServicePrincipalSecret'
        value: arbDeploymentServicePrincipalSecret
      }
    ]
  }
}

output vnetSubnetResourceId string = vnet.properties.subnets[0].id
