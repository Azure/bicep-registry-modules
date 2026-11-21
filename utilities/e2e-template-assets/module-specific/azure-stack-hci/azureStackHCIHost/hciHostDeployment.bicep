@description('Required. The location for all resource except HCI Arc Nodes and HCI resources')
param location string

@description('Optional. The Azure VM size for the HCI Host VM, which must support nested virtualization and have sufficient capacity for the HCI node VMs!')
param hostVMSize string = 'Standard_E48bds_v5'

@description('Optional. The number of Azure Stack HCI nodes to deploy.')
param hciNodeCount int = 2

@description('Optional. Enable configuring switchless storage.')
param switchlessStorageConfig bool = false

@description('Optional. The download URL for a pre-built Azure Stack HCI VHDX. When provided, skips the slower ISO download and conversion. Uses the Jumpstart public blob storage by default.')
param hciVHDXDownloadURL string = ''

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

@description('Optional. The resource ID of a pre-baked Azure Compute Gallery image for the HCI host VM. When provided, deploys from the gallery image instead of marketplace.')
param imageReferenceId string = ''

@description('Optional. Grant the host identity subscription Contributor. Disable when providers are already registered and only resource-group access is required.')
param assignSubscriptionContributor bool = true

@description('Optional. The object ID of the Azure Stack HCI resource provider service principal. When provided, the built-in role assignments of the cluster module are created before stage 7, and stage 7 creates the node edge devices, which install the node extensions on 24H2 and later images.')
param hciResourceProviderObjectId string = ''

@description('Optional. Install updates on the host VM in a weekly maintenance window (Sunday 08:00-10:00 UTC), restarting it if required. Disable for a host that must not install updates or restart during its multi-hour setup and cluster deployment: the host then uses manual patching, without Windows automatic updates.')
param enableScheduledPatching bool = true

@description('Optional. Grant the host identity Owner on the resource group. Disable to grant only the roles that Arc registration and the edge-device request need: Azure Connected Machine Onboarding, Azure Connected Machine Resource Administrator and Azure Stack HCI Device Management Role.')
param assignResourceGroupOwner bool = true

// =================================//
// Deploy Host VM Infrastructure    //
// =================================//

// vm managed identity used for HCI Arc onboarding
resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  location: location
  name: userAssignedIdentityName
}

// grant identity owner permissions on the resource group
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (assignResourceGroupOwner) {
  name: guid(subscription().subscriptionId, userAssignedIdentity.name, 'Owner', resourceGroup().id)
  properties: {
    principalId: userAssignedIdentity.properties.principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
    principalType: 'ServicePrincipal'
    description: 'Role assigned used for Azure Stack HCI IaC testing pipeline - remove if identity no longer exists!'
  }
}

// Without Owner: register the Arc machines (stage 6) and request their edge devices (stage 7).
var hostIdentityRoleDefinitionIds = [
  'b64e21ea-ac4e-4cdf-9dc9-5b892992bee7' // Azure Connected Machine Onboarding
  'cd570a14-e51a-42ad-bac8-bafd67325302' // Azure Connected Machine Resource Administrator
  '865ae368-6a45-4bd1-8fbf-0d5151f56fc1' // Azure Stack HCI Device Management Role
]

resource hostIdentityRoleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in hostIdentityRoleDefinitionIds: if (!assignResourceGroupOwner) {
    name: guid(subscription().subscriptionId, userAssignedIdentity.name, roleDefinitionId, resourceGroup().id)
    properties: {
      principalId: userAssignedIdentity.properties.principalId
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
      principalType: 'ServicePrincipal'
      description: 'Role assigned used for Azure Stack HCI IaC testing pipeline - remove if identity no longer exists!'
    }
  }
]

// grant identity contributor permissions on the subscription - needed to register resource providers
module roleAssignment_subscriptionContributor 'modules/subscriptionRoleAssignment.bicep' = if (assignSubscriptionContributor) {
  name: '${uniqueString(deployment().name, location)}-hcihostmi-roleAssignment_subContributor'
  scope: subscription()
  params: {
    principalId: userAssignedIdentity.properties.principalId
  }
}

// NAT Gateway for reliable outbound internet (JumpStart pattern - replaces flaky RRAS NAT)
resource natGatewayPublicIp 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: '${virtualNetworkName}-natgw-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource natGateway 'Microsoft.Network/natGateways@2024-07-01' = {
  name: '${virtualNetworkName}-natgw'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 10
    publicIpAddresses: [
      {
        id: natGatewayPublicIp.id
      }
    ]
  }
}

// VNET and subnet for the HCI host Azure VM - with NAT Gateway for reliable outbound
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' = {
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
          natGateway: {
            id: natGateway.id
          }
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

// create a maintenance configuration for the Azure Stack HCI Host VM and proxy server
resource maintenanceConfig 'Microsoft.Maintenance/maintenanceConfigurations@2023-09-01-preview' = if (enableScheduledPatching) {
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

resource disks 'Microsoft.Compute/disks@2023-10-02' = [
  for diskNum in range(0, hciNodeCount): {
    name: '${diskNamePrefix}${string(diskNum)}'
    location: location
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

// Azure Stack HCI Host VM
resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  location: location
  name: virtualMachineName
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
      imageReference: !empty(imageReferenceId)
        ? (startsWith(imageReferenceId, '/SharedGalleries/')
            ? { sharedGalleryImageId: imageReferenceId }
            : { id: imageReferenceId })
        : {
            publisher: 'MicrosoftWindowsServer'
            offer: 'WindowsServer'
            sku: '2022-datacenter-g2'
            version: 'latest'
          }
      osDisk: {
        createOption: 'FromImage'
        diskSizeGB: 1024
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      dataDisks: [
        for diskNum in range(0, hciNodeCount): {
          lun: diskNum
          createOption: 'Attach'
          caching: 'ReadOnly'
          managedDisk: {
            id: disks[diskNum].id
          }
          deleteOption: 'Delete'
        }
      ]
    }
    osProfile: {
      adminPassword: localAdminPassword
      adminUsername: localAdminUsername
      computerName: 'hciHost01'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: enableScheduledPatching
        patchSettings: enableScheduledPatching
          ? {
              patchMode: 'AutomaticByPlatform'
              automaticByPlatformSettings: {
                bypassPlatformSafetyChecksOnUserSchedule: true
              }
            }
          : {
              patchMode: 'Manual'
            }
      }
    }
  }
}

resource maintenanceAssignment_hciHost 'Microsoft.Maintenance/configurationAssignments@2023-04-01' = if (enableScheduledPatching) {
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

resource runCommand1 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = if (empty(imageReferenceId)) {
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
resource runCommand2 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = if (empty(imageReferenceId)) {
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
resource wait1 'Microsoft.Resources/deploymentScripts@2023-08-01' = if (empty(imageReferenceId)) {
  location: location
  kind: 'AzurePowerShell'
  name: '${waitDeploymentScriptPrefixName}-wait1'
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'Start-Sleep -Seconds 60 # VM reboot typically completes in 30-45s; next runCommand retries if VM not ready'
    retentionInterval: 'PT6H'
  }
  dependsOn: [runCommand2]
}

// ======================//
// Configure Host Roles  //
// ======================//

// mounts data disks, obtains the HCI VHDX, configures AD, routing, DNS, DHCP
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
        value: empty(imageReferenceId) ? hciVHDXDownloadURL : ''
      }
      {
        name: 'hciISODownloadURL'
        value: empty(imageReferenceId) ? hciISODownloadURL : ''
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

// schedules a reboot of the VM after AD DS install
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

// wait for VM to reboot and AD DS to initialize
resource wait2 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  location: location
  kind: 'AzurePowerShell'
  name: '${waitDeploymentScriptPrefixName}-wait2'
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'Start-Sleep -Seconds 180'
    retentionInterval: 'PT6H'
  }
  dependsOn: [runCommand4]
}

// NEW - configure RRAS after reboot
resource runCommand3b 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand3b'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage3b.ps1')
    }
    treatFailureAsDeploymentFailure: true
  }
  dependsOn: [wait2]
}
// Reboot after uninstall of RRAS
resource runCommand3c 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand3c'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage2.ps1') // reuse existing reboot script
    }
    treatFailureAsDeploymentFailure: true
  }
  dependsOn: [runCommand3b]
}
// Wait for reboot
resource wait3 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  location: location
  kind: 'AzurePowerShell'
  name: '${waitDeploymentScriptPrefixName}-wait3'
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent: 'Start-Sleep -Seconds 60'
    retentionInterval: 'PT6H'
  }
  dependsOn: [runCommand3c]
}
resource runCommand3d 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand3d'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage3d.ps1')
    }
    treatFailureAsDeploymentFailure: true
  }
  dependsOn: [wait3]
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
  dependsOn: [runCommand3d]
}

// ================================================//
// Initialize Arc on HCI Node VMs and AD for HCI  //
// ===============================================//

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
  }
  dependsOn: [runCommand5]
}

// ===================================================== //
// Azure Stack HCI resource provider role assignments    //
// ===================================================== //

// On 24H2 and later images, Arc initialization no longer installs the node extensions: the edge device resource does,
// through the resource provider, which needs these roles. Names and properties match the cluster module's built-in
// role assignments, so its later deployment updates them in place.
var createHciResourceProviderRoleAssignments = !empty(hciResourceProviderObjectId)

var arcNodeResourceIds = [
  for i in range(1, hciNodeCount): resourceId('Microsoft.HybridCompute/machines', 'hcinode${i}')
]

// Stage 6 creates the Arc machines outside this template. ARM reads a resource that `reference()` names outside the
// template when the deployment starts, whatever the dependencies, so the identities are read in a module that starts
// after stage 6.
module arcMachineIdentities 'modules/arcMachineIdentities.bicep' = if (createHciResourceProviderRoleAssignments) {
  name: '${uniqueString(deployment().name, location)}-hcihost-arcMachineIdentities'
  params: {
    machineNames: [for i in range(1, hciNodeCount): 'hcinode${i}']
  }
  dependsOn: [runCommand6]
}

var azureConnectedMachineResourceManagerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'f5819b54-e033-4d82-ac66-4fec3cbf3f4c'
)
var readerRoleID = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
)
var azureStackHCIDeviceManagementRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '865ae368-6a45-4bd1-8fbf-0d5151f56fc1'
)

resource spConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (createHciResourceProviderRoleAssignments) {
  name: guid(
    subscription().subscriptionId,
    hciResourceProviderObjectId,
    'ConnectedMachineResourceManagerRolePermissions',
    resourceGroup().id
  )
  properties: {
    roleDefinitionId: azureConnectedMachineResourceManagerRoleID
    principalId: hciResourceProviderObjectId
    principalType: 'ServicePrincipal'
    description: 'Created by Azure Stack HCI deployment template'
  }
}

resource nodeAzureConnectedMachineResourceManagerRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (hciNode, i) in arcNodeResourceIds: if (createHciResourceProviderRoleAssignments) {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'azureConnectedMachineResourceManager',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: azureConnectedMachineResourceManagerRoleID
      principalId: arcMachineIdentities!.outputs.principalIds[i]
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource nodeAzureStackHCIDeviceManagementRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (hciNode, i) in arcNodeResourceIds: if (createHciResourceProviderRoleAssignments) {
    name: guid(
      subscription().subscriptionId,
      hciResourceProviderObjectId,
      'azureStackHCIDeviceManagementRole',
      hciNode,
      resourceGroup().id
    )
    properties: {
      roleDefinitionId: azureStackHCIDeviceManagementRole
      principalId: arcMachineIdentities!.outputs.principalIds[i]
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

resource nodeReaderRolePermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (hciNode, i) in arcNodeResourceIds: if (createHciResourceProviderRoleAssignments) {
    name: guid(subscription().subscriptionId, hciResourceProviderObjectId, 'reader', hciNode, resourceGroup().id)
    properties: {
      roleDefinitionId: readerRoleID
      principalId: arcMachineIdentities!.outputs.principalIds[i]
      principalType: 'ServicePrincipal'
      description: 'Created by Azure Stack HCI deployment template'
    }
  }
]

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
      {
        name: 'ensureEdgeDevices'
        value: string(createHciResourceProviderRoleAssignments)
      }
    ]
    // The script waits up to 180 minutes, longer than the 90-minute default.
    timeoutInSeconds: 12600
    treatFailureAsDeploymentFailure: true
  }
  dependsOn: [
    runCommand6
    spConnectedMachineResourceManagerRolePermissions
    nodeAzureConnectedMachineResourceManagerRolePermissions
    nodeAzureStackHCIDeviceManagementRole
    nodeReaderRolePermissions
  ]
}

// ============================================= //
// Pre-deployment Health Check                   //
// ============================================= //

// validates AD, DNS, node VMs, Arc extensions, credentials, and network connectivity before cluster deployment
resource runCommand8 'Microsoft.Compute/virtualMachines/runCommands@2024-03-01' = {
  parent: vm
  location: location
  name: 'runCommand8'
  properties: {
    source: {
      script: loadTextContent('./scripts/hciHostStage8-preDeployCheck.ps1')
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
      {
        name: 'domainOUPath'
        value: domainOUPath
      }
      {
        name: 'deploymentUsername'
        value: deploymentUsername
      }
    ]
    treatFailureAsDeploymentFailure: true
  }
  dependsOn: [runCommand7]
}

output vnetSubnetResourceId string = vnet.properties.subnets[0].id
