metadata name = 'AI Platform Baseline'
metadata description = '''This module provides a secure and scalable environment for deploying AI applications on Azure.
The module encompasses all essential components required for building, managing, and observing AI solutions, including a machine learning workspace, observability tools, and necessary data management services.
By integrating with Microsoft Entra ID for secure identity management and utilizing private endpoints for services like Key Vault and Blob Storage, the module ensures secure communication and data access.'''
metadata owner = 'Azure/module-maintainers'

@description('Required. Alphanumberic suffix to use for resource naming.')
@minLength(3)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Configuration for the user-assigned managed identities.')
param managedIdentityConfiguration managedIdentityConfigurationType

@description('Optional. Configuration for the Log Analytics workspace.')
param logAnalyticsConfiguration logAnalyticsConfigurationType

@description('Optional. Configuration for the key vault.')
param keyVaultConfiguration keyVaultConfigurationType

@description('Optional. Configuration for the storage account.')
param storageAccountConfiguration storageAccountConfigurationType

@description('Optional. Configuration for the container registry.')
param containerRegistryConfiguration containerRegistryConfigurationType

@description('Optional. Configuration for Application Insights.')
param applicationInsightsConfiguration applicationInsightsConfigurationType

@description('Optional. Configuration for the AI Studio workspace.')
param workspaceConfiguration workspaceConfigurationType

@description('Optional. Configuration for the virtual network.')
param virtualNetworkConfiguration virtualNetworkConfigurationType

@description('Optional. Configuration for the Azure Bastion host.')
param bastionConfiguration bastionConfigurationType

@description('Optional. Configuration for the virtual machine.')
param virtualMachineConfiguration virtualMachineConfigurationType

// ============== //
// Variables      //
// ============== //

var createVirtualNetwork = virtualNetworkConfiguration.?enabled != false

var createBastion = createVirtualNetwork && bastionConfiguration.?enabled != false

var createVirtualMachine = createVirtualNetwork && virtualMachineConfiguration.?enabled != false

var createDefaultNsg = virtualNetworkConfiguration.?subnet.networkSecurityGroupResourceId == null

var subnetResourceId = createVirtualNetwork ? virtualNetwork::defaultSubnet.id : null

var mlTargetSubResource = 'amlworkspace'

var mlPrivateDnsZones = {
  'privatelink.api.azureml.ms': mlTargetSubResource
  'privatelink.notebooks.azure.net': mlTargetSubResource
}

var storagePrivateDnsZones = {
  'privatelink.blob.${environment().suffixes.storage}': 'blob'
  'privatelink.file.${environment().suffixes.storage}': 'file'
}

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.aiplatform-baseline.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module storageAccount_privateDnsZones 'br/public:avm/res/network/private-dns-zone:0.3.1' = [
  for zone in objectKeys(storagePrivateDnsZones): if (createVirtualNetwork) {
    name: '${uniqueString(deployment().name, location, zone)}-storage-private-dns-zones'
    params: {
      name: zone
      virtualNetworkLinks: [
        {
          virtualNetworkResourceId: virtualNetwork.id
        }
      ]
    }
  }
]

module workspaceHub_privateDnsZones 'br/public:avm/res/network/private-dns-zone:0.3.1' = [
  for zone in objectKeys(mlPrivateDnsZones): if (createVirtualNetwork) {
    name: '${uniqueString(deployment().name, location, zone)}-workspace-private-dns-zones'
    params: {
      name: zone
      virtualNetworkLinks: [
        {
          virtualNetworkResourceId: virtualNetwork.id
        }
      ]
      roleAssignments: [
        {
          principalId: managedIdentityHub.properties.principalId
          roleDefinitionIdOrName: 'Contributor'
          principalType: 'ServicePrincipal'
        }
      ]
    }
  }
]

module defaultNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.3.1' = if (createDefaultNsg) {
  name: '${uniqueString(deployment().name, location)}-nsg'
  params: {
    name: 'nsg-${name}'
    location: location
    securityRules: [
      {
        name: 'DenySshRdpOutbound'
        properties: {
          priority: 200
          access: 'Deny'
          protocol: '*'
          direction: 'Outbound'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRanges: [
            '3389'
            '22'
          ]
        }
      }
    ]
    tags: tags
  }
}

// Not using the br/public:avm/res/network/virtual-network module here to
// allow consumers of the module to add subnets from outside of the module
// https://github.com/Azure/bicep-registry-modules/issues/2689
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = if (createVirtualNetwork) {
  name: virtualNetworkConfiguration.?name ?? 'vnet-${name}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkConfiguration.?addressPrefix ?? '10.0.0.0/16'
      ]
    }
  }

  resource defaultSubnet 'subnets@2024-01-01' = {
    name: virtualNetworkConfiguration.?subnet.name ?? 'default'
    properties: {
      addressPrefix: virtualNetworkConfiguration.?subnet.addressPrefix ?? '10.0.0.0/24'
      networkSecurityGroup: {
        id: createDefaultNsg
          ? defaultNetworkSecurityGroup.outputs.resourceId
          : virtualNetworkConfiguration.?subnet.networkSecurityGroupResourceId
      }
    }
  }

  resource bastionSubnet 'subnets@2024-01-01' = if (createBastion) {
    name: 'AzureBastionSubnet'
    properties: {
      addressPrefix: bastionConfiguration.?subnetAddressPrefix ?? '10.0.1.0/26'
      networkSecurityGroup: bastionConfiguration.?networkSecurityGroupResourceId != null
        ? {
            id: bastionConfiguration.?networkSecurityGroupResourceId
          }
        : null
    }

    dependsOn: [
      defaultSubnet
    ]
  }
}

module bastion 'br/public:avm/res/network/bastion-host:0.2.2' = if (createBastion) {
  name: '${uniqueString(deployment().name, location)}-bastion-host'
  params: {
    name: bastionConfiguration.?name ?? 'bas-${name}'
    location: location
    skuName: bastionConfiguration.?sku ?? 'Standard'
    enableTelemetry: enableTelemetry
    virtualNetworkResourceId: virtualNetwork.id
    disableCopyPaste: bastionConfiguration.?disableCopyPaste
    enableFileCopy: bastionConfiguration.?enableFileCopy
    enableIpConnect: bastionConfiguration.?enableIpConnect
    enableKerberos: bastionConfiguration.?enableKerberos
    enableShareableLink: bastionConfiguration.?enableShareableLink
    scaleUnits: bastionConfiguration.?scaleUnits
    tags: tags
  }
}

module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.5.3' = if (createVirtualMachine) {
  name: '${uniqueString(deployment().name, location)}-virtual-machine'
  params: {
    name: virtualMachineConfiguration.?name ?? 'vm-${name}'
    computerName: virtualMachineConfiguration.?name ?? take('vm-${name}', 15)
    location: location
    enableTelemetry: enableTelemetry
    adminUsername: virtualMachineConfiguration.?adminUsername ?? ''
    adminPassword: virtualMachineConfiguration.?adminPassword
    nicConfigurations: [
      {
        name: virtualMachineConfiguration.?nicConfigurationConfiguration.name ?? 'nic-vm-${name}'
        location: location
        networkSecurityGroupResourceId: virtualMachineConfiguration.?nicConfigurationConfiguration.networkSecurityGroupResourceId
        ipConfigurations: [
          {
            name: virtualMachineConfiguration.?nicConfigurationConfiguration.ipConfigName ?? 'nic-vm-${name}-ipconfig'
            privateIPAllocationMethod: virtualMachineConfiguration.?nicConfigurationConfiguration.privateIPAllocationMethod ?? 'Dynamic'
            subnetResourceId: virtualNetwork::defaultSubnet.id
          }
        ]
      }
    ]
    imageReference: virtualMachineConfiguration.?imageReference ?? {
      publisher: 'microsoft-dsvm'
      offer: 'dsvm-win-2022'
      sku: 'winserver-2022'
      version: 'latest'
    }
    osDisk: virtualMachineConfiguration.?osDisk ?? {
      createOption: 'FromImage'
      managedDisk: {
        storageAccountType: 'Premium_ZRS'
      }
      diskSizeGB: 128
      caching: 'ReadWrite'
    }
    patchMode: virtualMachineConfiguration.?patchMode
    osType: 'Windows'
    encryptionAtHost: virtualMachineConfiguration.?encryptionAtHost ?? true
    vmSize: virtualMachineConfiguration.?size ?? 'Standard_D2s_v3'
    zone: virtualMachineConfiguration.?zone ?? 0
    extensionAadJoinConfig: virtualMachineConfiguration.?enableAadLoginExtension == true
      ? {
          enabled: true
          typeHandlerVersion: '1.0'
        }
      : null
    extensionMonitoringAgentConfig: virtualMachineConfiguration.?enableAzureMonitorAgent == true
      ? {
          enabled: true
        }
      : null
    maintenanceConfigurationResourceId: virtualMachineConfiguration.?maintenanceConfigurationResourceId
    tags: tags
  }
}

resource managedIdentityHub 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityConfiguration.?hubName ?? 'id-hub-${name}'
  location: location
  tags: tags
}

resource managedIdentityProject 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityConfiguration.?projectName ?? 'id-project-${name}'
  location: location
  tags: tags
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsConfiguration.?name ?? 'log-${name}'
  location: location
  tags: tags
}

resource resourceGroup_roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, name)
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
    )
    principalId: managedIdentityHub.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.6.2' = {
  name: '${uniqueString(deployment().name, location)}-key-vault'
  params: {
    name: keyVaultConfiguration.?name ?? 'kv-${name}'
    location: location
    enableTelemetry: enableTelemetry
    enableRbacAuthorization: true
    enableVaultForDeployment: false
    enableVaultForDiskEncryption: false
    enableVaultForTemplateDeployment: false
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    publicNetworkAccess: 'Disabled'
    enablePurgeProtection: keyVaultConfiguration.?enablePurgeProtection ?? true
    roleAssignments: [
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Key Vault Administrator'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Key Vault Administrator'
        principalType: 'ServicePrincipal'
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.id
        logCategoriesAndGroups: [
          {
            category: 'AuditEvent'
            enabled: true
          }
        ]
      }
    ]
    tags: tags
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.11.0' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: storageAccountConfiguration.?name ?? 'st${name}'
    location: location
    skuName: storageAccountConfiguration.?sku ?? 'Standard_RAGZRS'
    enableTelemetry: enableTelemetry
    allowBlobPublicAccess: false
    allowSharedKeyAccess: storageAccountConfiguration.?allowSharedKeyAccess ?? true
    defaultToOAuthAuthentication: !(storageAccountConfiguration.?allowSharedKeyAccess ?? true)
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    privateEndpoints: subnetResourceId != null
      ? map(items(storagePrivateDnsZones), zone => {
          name: 'pep-${zone.value}-${name}'
          customNetworkInterfaceName: 'nic-${zone.value}-${name}'
          service: zone.value
          subnetResourceId: subnetResourceId ?? ''
          privateDnsZoneResourceIds: [resourceId('Microsoft.Network/privateDnsZones', zone.key)]
        })
      : null
    roleAssignments: [
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Reader'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Storage Account Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Storage Table Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: '69566ab7-960f-475b-8e7c-b3118f30c6bd' // Storage File Data Privileged Contributor
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
  }

  dependsOn: storageAccount_privateDnsZones
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-container-registry'
  params: {
    name: containerRegistryConfiguration.?name ?? 'cr${name}'
    acrSku: 'Premium'
    location: location
    enableTelemetry: enableTelemetry
    publicNetworkAccess: 'Disabled'
    networkRuleBypassOptions: 'AzureServices'
    zoneRedundancy: 'Enabled'
    trustPolicyStatus: containerRegistryConfiguration.?trustPolicyStatus ?? 'enabled'
    roleAssignments: [
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'AcrPull'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'AcrPull'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.3.1' = {
  name: '${uniqueString(deployment().name, location)}-appi'
  params: {
    name: applicationInsightsConfiguration.?name ?? 'appi-${name}'
    location: location
    kind: 'web'
    enableTelemetry: enableTelemetry
    workspaceResourceId: logAnalyticsWorkspace.id
    roleAssignments: [
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
  }
}

module workspaceHub 'br/public:avm/res/machine-learning-services/workspace:0.5.0' = {
  name: '${uniqueString(deployment().name, location)}-hub'
  params: {
    name: workspaceConfiguration.?name ?? 'hub-${name}'
    sku: 'Standard'
    location: location
    enableTelemetry: enableTelemetry
    kind: 'Hub'
    associatedApplicationInsightsResourceId: applicationInsights.outputs.resourceId
    associatedKeyVaultResourceId: keyVault.outputs.resourceId
    associatedStorageAccountResourceId: storageAccount.outputs.resourceId
    associatedContainerRegistryResourceId: containerRegistry.outputs.resourceId
    workspaceHubConfig: {
      defaultWorkspaceResourceGroup: resourceGroup().id
    }
    managedIdentities: {
      userAssignedResourceIds: [
        managedIdentityHub.id
      ]
    }
    primaryUserAssignedIdentity: managedIdentityHub.id
    computes: workspaceConfiguration.?computes
    managedNetworkSettings: {
      isolationMode: workspaceConfiguration.?networkIsolationMode ?? 'AllowInternetOutbound'
      outboundRules: workspaceConfiguration.?networkOutboundRules
    }
    privateEndpoints: subnetResourceId != null
      ? [
          {
            name: 'pep-${mlTargetSubResource}-${name}'
            customNetworkInterfaceName: 'nic-${mlTargetSubResource}-${name}'
            service: mlTargetSubResource
            subnetResourceId: subnetResourceId ?? ''
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: map(objectKeys(mlPrivateDnsZones), zone => {
                name: replace(zone, '.', '-')
                privateDnsZoneResourceId: resourceId('Microsoft.Network/privateDnsZones', zone)
              })
            }
          }
        ]
      : null
    systemDatastoresAuthMode: 'identity'
    roleAssignments: [
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
  }

  dependsOn: workspaceHub_privateDnsZones
}

module workspaceProject 'br/public:avm/res/machine-learning-services/workspace:0.5.0' = {
  name: '${uniqueString(deployment().name, location)}-project'
  params: {
    name: workspaceConfiguration.?projectName ?? 'project-${name}'
    sku: 'Standard'
    location: location
    enableTelemetry: enableTelemetry
    kind: 'Project'
    hubResourceId: workspaceHub.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        managedIdentityProject.id
      ]
    }
    primaryUserAssignedIdentity: managedIdentityProject.id
    roleAssignments: [
      {
        principalId: managedIdentityHub.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
      {
        principalId: managedIdentityProject.properties.principalId
        roleDefinitionIdOrName: 'Contributor'
        principalType: 'ServicePrincipal'
      }
    ]
    tags: tags
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the module was deployed to.')
output resourceGroupName string = resourceGroup().name

@description('The location the module was deployed to.')
output location string = location

@description('The resource ID of the application insights component.')
output applicationInsightsResourceId string = applicationInsights.outputs.resourceId

@description('The name of the application insights component.')
output applicationInsightsName string = applicationInsights.outputs.name

@description('The application ID of the application insights component.')
output applicationInsightsApplicationId string = applicationInsights.outputs.applicationId

@description('The instrumentation key of the application insights component.')
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.instrumentationKey

@description('The connection string of the application insights component.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@description('The resource ID of the log analytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.id

@description('The name of the log analytics workspace.')
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name

@description('The resource ID of the workspace hub user assigned managed identity.')
output managedIdentityHubResourceId string = managedIdentityHub.id

@description('The name of the workspace hub user assigned managed identity.')
output managedIdentityHubName string = managedIdentityHub.name

@description('The principal ID of the workspace hub user assigned managed identity.')
output managedIdentityHubPrincipalId string = managedIdentityHub.properties.principalId

@description('The client ID of the workspace hub user assigned managed identity.')
output managedIdentityHubClientId string = managedIdentityHub.properties.clientId

@description('The resource ID of the workspace project user assigned managed identity.')
output managedIdentityProjectResourceId string = managedIdentityProject.id

@description('The name of the workspace project user assigned managed identity.')
output managedIdentityProjectName string = managedIdentityProject.name

@description('The principal ID of the workspace project user assigned managed identity.')
output managedIdentityProjectPrincipalId string = managedIdentityProject.properties.principalId

@description('The client ID of the workspace project user assigned managed identity.')
output managedIdentityProjectClientId string = managedIdentityProject.properties.clientId

@description('The resource ID of the key vault.')
output keyVaultResourceId string = keyVault.outputs.resourceId

@description('The name of the key vault.')
output keyVaultName string = keyVault.outputs.name

@description('The URI of the key vault.')
output keyVaultUri string = keyVault.outputs.uri

@description('The resource ID of the storage account.')
output storageAccountResourceId string = storageAccount.outputs.resourceId

@description('The name of the storage account.')
output storageAccountName string = storageAccount.outputs.name

@description('The resource ID of the container registry.')
output containerRegistryResourceId string = containerRegistry.outputs.resourceId

@description('The name of the container registry.')
output containerRegistryName string = containerRegistry.outputs.name

@description('The resource ID of the workspace hub.')
output workspaceHubResourceId string = workspaceHub.outputs.resourceId

@description('The name of the workspace hub.')
output workspaceHubName string = workspaceHub.outputs.name

@description('The resource ID of the workspace project.')
output workspaceProjectResourceId string = workspaceProject.outputs.resourceId

@description('The name of the workspace project.')
output workspaceProjectName string = workspaceProject.outputs.name

@description('The resource ID of the virtual network.')
output virtualNetworkResourceId string = createVirtualNetwork ? virtualNetwork.id : ''

@description('The name of the virtual network.')
output virtualNetworkName string = createVirtualNetwork ? virtualNetwork.name : ''

@description('The resource ID of the subnet in the virtual network.')
output virtualNetworkSubnetResourceId string = createVirtualNetwork ? virtualNetwork::defaultSubnet.id : ''

@description('The name of the subnet in the virtual network.')
output virtualNetworkSubnetName string = createVirtualNetwork ? virtualNetwork::defaultSubnet.name : ''

@description('The resource ID of the Azure Bastion host.')
output bastionResourceId string = createBastion ? bastion.outputs.resourceId : ''

@description('The name of the Azure Bastion host.')
output bastionName string = createBastion ? bastion.outputs.name : ''

@description('The resource ID of the virtual machine.')
output virtualMachineResourceId string = createVirtualMachine ? virtualMachine.outputs.resourceId : ''

@description('The name of the virtual machine.')
output virtualMachineName string = createVirtualMachine ? virtualMachine.outputs.name : ''

// ================ //
// Definitions      //
// ================ //

type managedIdentityConfigurationType = {
  @description('Optional. The name of the workspace hub user-assigned managed identity.')
  hubName: string?

  @description('Optional. The name of the workspace project user-assigned managed identity.')
  projectName: string?
}?

type logAnalyticsConfigurationType = {
  @description('Optional. The name of the Log Analytics workspace.')
  name: string?
}?

type keyVaultConfigurationType = {
  @description('Optional. The name of the key vault.')
  name: string?

  @description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature. Defaults to \'true\'.')
  enablePurgeProtection: bool?
}?

type storageAccountConfigurationType = {
  @description('Optional. The name of the storage account.')
  name: string?

  @description('Optional. Storage account SKU. Defaults to \'Standard_RAGZRS\'.')
  sku:
    | 'Standard_LRS'
    | 'Standard_GRS'
    | 'Standard_RAGRS'
    | 'Standard_ZRS'
    | 'Premium_LRS'
    | 'Premium_ZRS'
    | 'Standard_GZRS'
    | 'Standard_RAGZRS'?

  @description('Optional. Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to \'false\'.')
  allowSharedKeyAccess: bool?
}?

type containerRegistryConfigurationType = {
  @description('Optional. The name of the container registry.')
  name: string?

  @description('Optional. Whether the trust policy is enabled for the container registry. Defaults to \'enabled\'.')
  trustPolicyStatus: 'enabled' | 'disabled'?
}?

type applicationInsightsConfigurationType = {
  @description('Optional. The name of the Application Insights resource.')
  name: string?
}?

type workspaceConfigurationType = {
  @description('Optional. The name of the AI Studio workspace hub.')
  name: string?

  @description('Optional. The name of the AI Studio workspace project.')
  projectName: string?

  @description('Optional. Computes to create and attach to the workspace hub.')
  computes: array?

  @description('Optional. The network isolation mode of the workspace hub. Defaults to \'AllowInternetOutbound\'.')
  networkIsolationMode: 'AllowInternetOutbound' | 'AllowOnlyApprovedOutbound'?

  @description('Optional. The outbound rules for the managed network of the workspace hub.')
  networkOutboundRules: networkOutboundRuleType
}?

type virtualNetworkSubnetConfigurationType = {
  @description('Optional. The name of the subnet to create.')
  name: string?

  @description('Optional. The address prefix of the subnet to create.')
  addressPrefix: string?

  @description('Optional. The resource ID of an existing network security group to associate with the subnet.')
  networkSecurityGroupResourceId: string?
}?

type virtualNetworkConfigurationType = {
  @description('Optional. Whether to create an associated virtual network. Defaults to \'true\'.')
  enabled: bool?

  @description('Optional. The name of the virtual network to create.')
  name: string?

  @description('Optional. The address prefix of the virtual network to create.')
  addressPrefix: string?

  @description('Optional. Configuration for the virual network subnet.')
  subnet: virtualNetworkSubnetConfigurationType
}?

type bastionConfigurationType = {
  @description('Optional. Whether to create a Bastion host in the virtual network. Defaults to \'true\'.')
  enabled: bool?

  @description('Optional. The name of the Bastion host to create.')
  name: string?

  @description('Optional. The SKU of the Bastion host to create.')
  sku: 'Basic' | 'Standard'?

  @description('Optional. The resource ID of an existing network security group to associate with the Azure Bastion subnet.')
  networkSecurityGroupResourceId: string?

  @description('Optional. The address prefix of the Azure Bastion subnet.')
  subnetAddressPrefix: string?

  @description('Optional. Choose to disable or enable Copy Paste.')
  disableCopyPaste: bool?

  @description('Optional. Choose to disable or enable File Copy.')
  enableFileCopy: bool?

  @description('Optional. Choose to disable or enable IP Connect.')
  enableIpConnect: bool?

  @description('Optional. Choose to disable or enable Kerberos authentication.')
  enableKerberos: bool?

  @description('Optional. Choose to disable or enable Shareable Link.')
  enableShareableLink: bool?

  @description('Optional. The scale units for the Bastion Host resource.')
  scaleUnits: int?
}?

type nicConfigurationConfigurationType = {
  @description('Optional. The name of the network interface.')
  name: string?

  @description('Optional. The name of the IP configuration.')
  ipConfigName: string?

  @description('Optional. The private IP address allocation method.')
  privateIPAllocationMethod: 'Dynamic' | 'Static'?

  @description('Optional. The resource ID of an existing network security group to associate with the network interface.')
  networkSecurityGroupResourceId: string?
}?

type osDiskType = {
  @description('Optional. The disk name.')
  name: string?

  @description('Optional. Specifies the size of an empty data disk in gigabytes.')
  diskSizeGB: int?

  @description('Optional. Specifies how the virtual machine should be created.')
  createOption: 'Attach' | 'Empty' | 'FromImage'?

  @description('Optional. Specifies whether data disk should be deleted or detached upon VM deletion.')
  deleteOption: 'Delete' | 'Detach'?

  @description('Optional. Specifies the caching requirements.')
  caching: 'None' | 'ReadOnly' | 'ReadWrite'?

  @description('Required. The managed disk parameters.')
  managedDisk: {
    @description('Optional. Specifies the storage account type for the managed disk.')
    storageAccountType:
      | 'PremiumV2_LRS'
      | 'Premium_LRS'
      | 'Premium_ZRS'
      | 'StandardSSD_LRS'
      | 'StandardSSD_ZRS'
      | 'Standard_LRS'
      | 'UltraSSD_LRS'?

    @description('Optional. Specifies the customer managed disk encryption set resource id for the managed disk.')
    diskEncryptionSetResourceId: string?
  }
}?

@secure()
type virtualMachineConfigurationType = {
  @description('Optional. Whether to create a virtual machine in the associated virtual network. Defaults to \'true\'.')
  enabled: bool?

  @description('Optional. The name of the virtual machine.')
  @maxLength(15)
  name: string?

  @description('Optional. The availability zone of the virtual machine. If set to 0, no availability zone is used (default).')
  zone: 0 | 1 | 2 | 3?

  @description('Required. The virtual machine size. Defaults to \'Standard_D2s_v3\'.')
  size: string?

  @description('Conditional. The username for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  adminUsername: string?

  @description('Conditional. The password for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  adminPassword: string?

  @description('Optional. Configuration for the virtual machine network interface.')
  nicConfigurationConfiguration: nicConfigurationConfigurationType

  @description('Optional. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
  imageReference: object?

  @description('Optional. Specifies the OS disk.')
  osDisk: osDiskType

  @description('Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to \'true\'.')
  encryptionAtHost: bool?

  @description('Optional. VM guest patching orchestration mode. Refer to \'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching\'.')
  patchMode: 'AutomaticByPlatform' | 'AutomaticByOS' | 'Manual'?

  @description('Optional. Whether to enable the Microsoft.Azure.ActiveDirectory AADLoginForWindows extension, allowing users to log in to the virtual machine using Microsoft Entra. Defaults to \'false\'.')
  enableAadLoginExtension: bool?

  @description('Optional. Whether to enable the Microsoft.Azure.Monitor AzureMonitorWindowsAgent extension. Defaults to \'false\'.')
  enableAzureMonitorAgent: bool?

  @description('Optional. The resource Id of a maintenance configuration for the virtual machine.')
  maintenanceConfigurationResourceId: string?
}?

@discriminator('type')
type OutboundRuleType = FqdnOutboundRuleType | PrivateEndpointOutboundRule | ServiceTagOutboundRule

type FqdnOutboundRuleType = {
  @sys.description('Required. Type of a managed network Outbound Rule of the  workspace hub. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\'.')
  type: 'FQDN'

  @sys.description('Required. Fully Qualified Domain Name to allow for outbound traffic.')
  destination: string

  @sys.description('Optional. Category of a managed network Outbound Rule of the workspace hub.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type PrivateEndpointOutboundRule = {
  @sys.description('Required. Type of a managed network Outbound Rule of the workspace hub.')
  type: 'PrivateEndpoint'

  @sys.description('Required. Service Tag destination for a Service Tag Outbound Rule for the managed network of the workspace hub.')
  destination: {
    @sys.description('Required. The resource ID of the target resource for the private endpoint.')
    serviceResourceId: string

    @sys.description('Optional. Whether the private endpoint can be used by jobs running on Spark.')
    sparkEnabled: bool?

    @sys.description('Required. The sub resource to connect for the private endpoint.')
    subresourceTarget: string
  }

  @sys.description('Optional. Category of a managed network Outbound Rule of the workspace hub.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

type ServiceTagOutboundRule = {
  @sys.description('Required. Type of a managed network Outbound Rule of the workspace hub. Only supported when \'isolationMode\' is \'AllowOnlyApprovedOutbound\'.')
  type: 'ServiceTag'

  @sys.description('Required. Service Tag destination for a Service Tag Outbound Rule for the managed network of the workspace hub.')
  destination: {
    @sys.description('Required. The name of the service tag to allow.')
    portRanges: string

    @sys.description('Required. The protocol to allow. Provide an asterisk(*) to allow any protocol.')
    protocol: 'TCP' | 'UDP' | 'ICMP' | '*'

    @sys.description('Required. Which ports will be allow traffic by this rule. Provide an asterisk(*) to allow any port.')
    serviceTag: string
  }

  @sys.description('Optional. Category of a managed network Outbound Rule of the workspace hub.')
  category: 'Dependency' | 'Recommended' | 'Required' | 'UserDefined'?
}

@sys.description('Optional. Outbound rules for the managed network of the workspace hub.')
type networkOutboundRuleType = {
  @sys.description('Required. The outbound rule. The name of the rule is the object key.')
  *: OutboundRuleType
}?
