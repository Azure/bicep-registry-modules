param location string // all resource except HCI Arc Nodes + HCI resources
param vnetSubnetID string = '' // use to connect the HCI Azure Host VM to an existing VNET in the same region
param useSpotVM bool = false // change to false to use regular priority VM
param hostVMSize string = 'Standard_E32bds_v5' // Azure VM size for the HCI Host VM - must support nested virtualization and have sufficient capacity for the HCI node VMs!
param hciNodeCount int = 2 // number of Azure Stack HCI nodes to deploy
param switchlessStorageConfig bool = false // set to true to configure switchless storage
// specify either a VHDX or ISO download URL; if both are specified, the VHDX download URL will be used
param hciVHDXDownloadURL string = ''
param hciISODownloadURL string = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
param localAdminUsername string = 'admin-hci'
@secure()
param localAdminPassword string
param domainOUPath string = 'OU=HCI,DC=HCI,DC=local'
param deploymentUsername string = 'deployUser'
param arcGatewayId string = '' // default to '' to support runCommand parameters requiring string values
param deployProxy bool = false // set to true to deploy a proxy VM for hci internet access
param proxyBypassString string? // bypass string for proxy server - deployProxy must be true
param proxyServerEndpoint string? // endpoint for proxy server - deployProxy must be true
param hciHostAssignPublicIp bool = false // set to true to deploy a public IP for the HCI Host VM

// =================================//
// Deploy Host VM Infrastructure    //
// =================================//

// vm managed identity used for HCI Arc onboarding
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  location: location
  name: 'hciHost01Identity'
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
  name: '${uniqueString(deployment().name, location)}-hcihostmi-roleAssignment_subscriptionContributor'
  scope: subscription()
  params: {
    principalId: userAssignedIdentity.properties.principalId
  }
}

// optional VNET and subnet for the HCI host Azure VM
resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = if (vnetSubnetID == '') {
  name: 'vnet01'
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
  name: 'maintenanceConfig01'
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

resource proxyVMSSFlex 'Microsoft.Compute/virtualMachineScaleSets@2024-03-01' = if (deployProxy) {
  name: 'vmss-proxy01'
  location: location
  zones: ['1', '2', '3']
  properties: {
    orchestrationMode: 'Flexible'
    platformFaultDomainCount: 1
  }
}

resource proxyNic 'Microsoft.Network/networkInterfaces@2023-11-01' = if (deployProxy) {
  name: 'proxyNic01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnetSubnetID == '' ? vnet.properties.subnets[0].id : vnetSubnetID
          }
        }
      }
    ]
  }
}

resource proxyServer 'Microsoft.Compute/virtualMachines@2024-03-01' = if (deployProxy) {
  name: 'proxyServer01'
  location: location
  zones: ['1']
  properties: {
    virtualMachineScaleSet: {
      id: proxyVMSSFlex.id
    }
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_ZRS'
        }
      }
    }
    osProfile: {
      computerName: 'proxyServer'
      adminUsername: localAdminUsername
      adminPassword: localAdminPassword
      customData: (arcGatewayId == null || arcGatewayId == '')
        ? base64(loadTextContent('./scripts/proxyConfig.sh'))
        : base64(loadTextContent('./scripts/proxyConfigArcGW.sh'))
      linuxConfiguration: {
        disablePasswordAuthentication: false
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            bypassPlatformSafetyChecksOnUserSchedule: true
          }
        }
      }
    }

    networkProfile: {
      networkInterfaces: [
        {
          id: proxyNic.id
        }
      ]
    }
  }
}

resource maintenanceAssignment_proxyServer 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = if (deployProxy) {
  location: location
  name: 'maintenanceAssignment01'
  properties: {
    maintenanceConfigurationId: maintenanceConfig.id
  }
  scope: proxyServer
}

resource publicIP_HCIHost 'Microsoft.Network/publicIPAddresses@2024-01-01' = if (hciHostAssignPublicIp) {
  name: 'pip-hcihost01'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource networkSecurityGroup_HCIHost 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  location: location
  name: 'hciHostNSG'
}

resource hciHostVMSSFlex 'Microsoft.Compute/virtualMachineScaleSets@2024-03-01' = {
  name: 'vmss-hcihost01'
  location: location
  zones: ['1', '2', '3']
  properties: {
    orchestrationMode: 'Flexible'
    platformFaultDomainCount: 1
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  location: location
  name: 'nic01'
  properties: {
    networkSecurityGroup: {
      id: networkSecurityGroup_HCIHost.id
    }
    ipConfigurations: [
      {
        name: 'ipConfig01'
        properties: {
          subnet: {
            id: vnetSubnetID == '' ? vnet.properties.subnets[0].id : vnetSubnetID
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: hciHostAssignPublicIp
            ? {
                id: publicIP_HCIHost.id
              }
            : null
        }
      }
    ]
  }
}

// host VM disks
resource disks 'Microsoft.Compute/disks@2023-10-02' = [
  for diskNum in range(1, hciNodeCount): {
    name: 'dataDisk${string(diskNum)}'
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
  name: 'hciHost01'
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
    priority: useSpotVM ? 'Spot' : 'Regular'
    evictionPolicy: useSpotVM ? 'Deallocate' : null
    billingProfile: useSpotVM
      ? {
          maxPrice: -1
        }
      : null
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
  name: 'maintenanceAssignmentHciHost'
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
  }
  dependsOn: [runCommand1]
}

// initiates a wait for the VM to reboot
resource wait1 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  location: location
  kind: 'AzurePowerShell'
  name: 'wait1'
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
        value: hciVHDXDownloadURL
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
  }
  dependsOn: [runCommand3]
}

// initiates a wait for the VM to reboot - extra time for AD initialization
resource wait2 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  location: location
  kind: 'AzurePowerShell'
  name: 'wait2'
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'Start-Sleep -Seconds 300 #enough time for AD start-up'
    retentionInterval: 'PT6H'
  }
  dependsOn: [
    proxyServer
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
        value: arcGatewayId
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
        value: proxyBypassString ?? (deployProxy ? 'GENERATE_PROXY_BYPASS_DYNAMICALLY' : '')
      }
      {
        name: 'proxyServerEndpoint'
        value: proxyServerEndpoint ?? (deployProxy
          ? 'http://${proxyNic.properties.ipConfigurations[0].properties.privateIPAddress}:3128'
          : '')
      }
    ]
    protectedParameters: [
      {
        name: 'adminPw'
        value: localAdminPassword
      }
    ]
    treatFailureAsDeploymentFailure: true
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
    ]
    treatFailureAsDeploymentFailure: true
  }
  dependsOn: [runCommand6]
}

output vnetSubnetId string = vnetSubnetID == '' ? vnet.properties.subnets[0].id : vnetSubnetID
