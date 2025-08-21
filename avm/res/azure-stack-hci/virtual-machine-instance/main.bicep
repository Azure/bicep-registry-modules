metadata name = 'Azure Stack HCI Virtual Machine Instance'
metadata description = 'This module deploys an Azure Stack HCI virtual machine.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Resource ID of the associated custom location.')
param customLocationResourceId string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Hardware profile configuration.')
param hardwareProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2025-04-01-preview'>.properties.hardwareProfile

@description('Optional. HTTP proxy configuration.')
param httpProxyConfig resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2025-04-01-preview'>.properties.httpProxyConfig = {}

@description('Required. Network profile configuration.')
param networkProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2025-04-01-preview'>.properties.networkProfile

@description('Required. OS profile configuration.')
param osProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2025-04-01-preview'>.properties.osProfile

@description('Optional. Security profile configuration.')
param securityProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2025-04-01-preview'>.properties.securityProfile = {
  uefiSettings: { secureBootEnabled: true }
}

@description('Required. Storage profile configuration.')
param storageProfile resourceInput<'Microsoft.AzureStackHCI/virtualMachineInstances@2025-04-01-preview'>.properties.storageProfile

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@secure()
@description('Optional. The password of arc vm. If it is provided, it will be used for the admin account in osProfile.')
param adminPassword string?

@secure()
@description('Optional. The HTTP proxy server endpoint to use. If it is provided, it will be used in HttpProxyConfiguration.')
param httpProxy string?

@secure()
@description('Optional. The HTTPS proxy server endpoint to use. If it is provided, it will be used in HttpProxyConfiguration.')
param httpsProxy string?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.azurestackhci-virtualmachineinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

var enableReferencedModulesTelemetry bool = false

module hybridCompute 'br/public:avm/res/hybrid-compute/machine:0.4.1' = {
  name: '${name}-deployment'
  scope: resourceGroup()
  params: {
    name: name
    location: location
    kind: 'HCI'
    enableTelemetry: enableReferencedModulesTelemetry
  }
}

resource existingMachine 'Microsoft.HybridCompute/machines@2023-10-03-preview' existing = {
  name: name
  dependsOn: [
    hybridCompute
  ]
}

resource virtualMachineInstance 'Microsoft.AzureStackHCI/virtualMachineInstances@2024-01-01' = {
  name: 'default'
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocationResourceId
  }
  properties: {
    hardwareProfile: {
      memoryMB: hardwareProfile.memoryMB
      processors: hardwareProfile.processors
      vmSize: empty(hardwareProfile.?vmSize) ? 'Custom' : hardwareProfile.?vmSize
      dynamicMemoryConfig: hardwareProfile.?dynamicMemoryConfig
    }
    httpProxyConfig: empty(httpProxyConfig) ? null : union(
      httpProxyConfig,
      {
        httpProxy: httpProxy
        httpsProxy: httpsProxy
      }
    )
    networkProfile: networkProfile
    osProfile: union(
      osProfile,
      {
        adminPassword: adminPassword
      }
    )
    securityProfile: empty(securityProfile) ? null : securityProfile
    storageProfile: storageProfile
  }
  scope: existingMachine
}

resource virtualMachine_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      virtualMachineInstance.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: virtualMachineInstance
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the virtual machine instance.')
output name string = virtualMachineInstance.name

@description('The resource ID of the virtual machine instance.')
output resourceId string = virtualMachineInstance.id

@description('The resource group of the virtual machine instance.')
output resourceGroupName string = resourceGroup().name
