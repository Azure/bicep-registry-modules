@description('Required. The location for all resource except HCI Arc Nodes and HCI resources')
param location string

@description('Optional. The Azure VM size for the HCI Host VM, which must support nested virtualization and have sufficient capacity for the HCI node VMs!')
param hostVMSize string = 'Standard_E32bds_v5'

@description('Optional. The number of Azure Stack HCI nodes to deploy.')
param hciNodeCount int = 2

@description('Optional. Enable configuring switchless storage.')
param switchlessStorageConfig bool = false

@description('Optional. The download URL for the Azure Stack HCI ISO.')
param hciISODownloadURL string = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'

@description('Optional. The local admin user name.')
param localAdminUsername string = 'admin-hci'

@description('Required. The local admin password.')
@secure()
param localAdminPassword string

@description('Optional. The domain OU path.')
param domainOUPath string = 'OU=HCI,DC=HCI,DC=local'

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

@description('Required. The name prefix for the Disks to create.')
param diskNamePrefix string

@description('Required. The name of the Azure VM to create.')
param virtualMachineName string

@description('Required. The name of the Maintenance Configuration Assignment for the proxy server.')
param maintenanceConfigurationAssignmentName string

@description('Required. The name prefix for the \'wait\' deployment scripts to create.')
param waitDeploymentScriptPrefixName string

// =================================//
// Deploy Host VM Infrastructure    //
// =================================//

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: uniqueString(resourceGroup().id, 'logs')
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
  }

  resource blob 'blobServices@2024-01-01' = {
    name: 'default'

    resource container 'containers@2024-01-01' = {
      name: 'logs'
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

var blobUriOut1 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand1-output.txt'
var blobUriErr1 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand1-error.txt'
var blobUriOut2 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand2-output.txt'
var blobUriErr2 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand2-error.txt'
var blobUriOut3 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand3-output.txt'
var blobUriErr3 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand3-error.txt'
var blobUriOut4 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand4-output.txt'
var blobUriErr4 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand4-error.txt'
var blobUriOut5 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand5-output.txt'
var blobUriErr5 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand5-error.txt'
var blobUriOut6 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand6-output.txt'
var blobUriErr6 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand6-error.txt'
var blobUriOut7 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand7-output.txt'
var blobUriErr7 = 'https://${storageAccount.name}.blob.core.windows.net/logs/runcommand77-error.txt'

// vm managed identity used for HCI Arc onboarding
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
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
resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/24']
    }
    subnets: [
      {
        name: 'subnet01'
        properties: {
          addressPrefix: '10.0.0.0/24'
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
resource maintenanceConfig 'Microsoft.Maintenance/maintenanceConfigurations@2023-09-01-preview' = {
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

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  location: location
  name: networkSecurityGroupName
}

resource hciHostVMSSFlex 'Microsoft.Compute/virtualMachineScaleSets@2024-03-01' = {
  name: HCIHostVirtualMachineScaleSetName
  location: location
  zones: ['1', '2', '3']
  properties: {
    orchestrationMode: 'Flexible'
    platformFaultDomainCount: 1
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
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

// host VM disks
resource disks 'Microsoft.Compute/disks@2023-10-02' = [
  for diskNum in range(1, hciNodeCount): {
    name: '${diskNamePrefix}${string(diskNum)}'
    location: location
    zones: ['1']
    sku: {
      name: 'Premium_LRS'
    }
    properties: {
      diskSizeGB: 2048
      networkAccessPolicy: 'DenyAll'
      creationData: {
        createOption: 'Empty'
      }
    }
  }
]

// Azure Stack HCI Host VM -
resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: 128
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      dataDisks: [
        for diskNum in range(1, hciNodeCount): {
          lun: diskNum
          createOption: 'Attach'
          caching: 'ReadOnly'
          managedDisk: {
            id: disks[diskNum - 1].id
          }
          deleteOption: 'Delete'
        }
      ]
      //diskControllerType: 'NVMe'
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

// ====================//
// Install Host Roles  //
// ====================//

// installs roles and features required for Azure Stack HCI Host VM
resource runCommand1 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand1'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage1.ps1')
    }
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr1
    outputBlobUri: blobUriOut1
  }
}

// schedules a reboot of the VM
resource runCommand2 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand2'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage2.ps1')
    }
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr2
    outputBlobUri: blobUriOut2
  }
  dependsOn: [runCommand1]
}

// initiates a wait for the VM to reboot
resource wait1 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  location: location
  kind: 'AzurePowerShell'
  name: '${waitDeploymentScriptPrefixName}-wait1'
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'Start-Sleep -Seconds 90'
    retentionInterval: 'PT6H'
  }
  dependsOn: [runCommand2]
}

// ======================//
// Configure Host Roles  //
// ======================//

// initializes and mounts data disks, downloads HCI VHDX, configures the Azure Stack HCI Host VM with AD, routing, DNS, DHCP
resource runCommand3 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand3'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage3.ps1')
    }
    parameters: [
      {
        name: 'hciVHDXDownloadURL'
        value: ''
      }
      {
        name: 'hciISODownloadURL'
        value: hciISODownloadURL
      }
      {
        name: 'hciNodeCount'
        value: string(hciNodeCount)
      }
    ]
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr3
    outputBlobUri: blobUriOut3
  }
  dependsOn: [wait1]
}

// schedules a reboot of the VM
resource runCommand4 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand4'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage4.ps1')
    }
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr4
    outputBlobUri: blobUriOut4
  }
  dependsOn: [runCommand3]
}

// initiates a wait for the VM to reboot - extra time for AD initialization
resource wait2 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  location: location
  kind: 'AzurePowerShell'
  name: '${waitDeploymentScriptPrefixName}-wait2'
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'Start-Sleep -Seconds 300 #enough time for AD start-up'
    retentionInterval: 'PT6H'
  }
  dependsOn: [
    runCommand4
  ]
}

// ===========================//
// Create HCI Node Guest VMs  //
// ===========================//

// creates hyper-v resources, configures NAT, builds and preps the Azure Stack HCI node VMs
resource runCommand5 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand5'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage5.ps1')
    }
    parameters: [
      {
        name: 'adminUsername'
        value: localAdminUsername
      }
      {
        name: 'hciNodeCount'
        value: string(hciNodeCount)
      }
      {
        name: 'switchlessStorageConfig'
        value: switchlessStorageConfig ? 'switchless' : 'switched'
      }
    ]
    protectedParameters: [
      {
        name: 'adminPw'
        value: localAdminPassword
      }
    ]
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr5
    outputBlobUri: blobUriOut5
  }
  dependsOn: [wait2]
}

// ================================================//
// Initialize Arc on HCI Node VMs and AD for HCI  //
// ==============================================//

// prepares AD for ASHCI onboarding, initiates Arc onboarding of HCI node VMs
resource runCommand6 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand6'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage6.ps1')
    }
    parameters: [
      {
        name: 'location'
        value: location
      }
      {
        name: 'resourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'subscriptionId'
        value: subscription().subscriptionId
      }
      {
        name: 'tenantId'
        value: tenant().tenantId
      }
      {
        name: 'accountName'
        value: userAssignedIdentity.properties.principalId
      }
      {
        name: 'adminUsername'
        value: localAdminUsername
      }
      {
        name: 'arcGatewayId'
        value: ''
      }
      {
        name: 'deploymentUsername'
        value: deploymentUsername
      }
      {
        name: 'domainOUPath'
        value: domainOUPath
      }
      {
        name: 'proxyBypassString'
        value: ''
      }
      {
        name: 'proxyServerEndpoint'
        value: ''
      }
      {
        name: 'userAssignedManagedIdentityClientId'
        value: userAssignedIdentity.properties.clientId
      }
    ]
    protectedParameters: [
      {
        name: 'adminPw'
        value: localAdminPassword
      }
    ]
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr6
    outputBlobUri: blobUriOut6
  }
  dependsOn: [runCommand5]
}

// waits for HCI extensions to be in succeeded state
resource runCommand7 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand7'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage7.ps1')
    }
    parameters: [
      {
        name: 'hciNodeCount'
        value: string(hciNodeCount)
      }
      {
        name: 'resourceGroupName'
        value: resourceGroup().name
      }
      {
        name: 'subscriptionId'
        value: subscription().subscriptionId
      }
      {
        name: 'userAssignedManagedIdentityClientId'
        value: userAssignedIdentity.properties.clientId
      }
    ]
    treatFailureAsDeploymentFailure: true
    errorBlobUri: blobUriErr7
    outputBlobUri: blobUriOut7
  }
  dependsOn: [runCommand6]
}

output vnetSubnetResourceId string = vnet.properties.subnets[0].id
