metadata name = 'Hybrid Compute Machines'
metadata description = 'This module deploys an Arc Machine for use with Arc Resource Bridge for Azure Stack HCI or VMware. In these scenarios, this resource module will be used in combination with another resource module to create the require Virtual Machine Instance extension resource on this Arc Machine resource. This module should not be used for other Arc-enabled server scenarios, where the Arc Machine resource is created automatically by the onboarding process.'

import { roleAssignmentType, lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'

@description('Required. The name of the Arc machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.')
param name string

@description('Required. Kind of Arc machine to be created. Possible values are: HCI, SCVMM, VMware.')
param kind string

@description('Conditional. The resource ID of an Arc Private Link Scope which which to associate this machine. Required if you are using Private Link for Arc and your Arc Machine will resolve a Private Endpoint for connectivity to Azure.')
param privateLinkScopeResourceId string = ''

@description('Optional. Parent cluster resource ID (Azure Stack HCI).')
param parentClusterResourceId string = ''

@description('Optional. The GUID of the on-premises virtual machine from your hypervisor.')
param vmId string = ''

@description('Optional. The Public Key that the client provides to be used during initial resource onboarding.')
@secure()
param clientPublicKey string = ''

@description('Optional. VM guest patching orchestration mode. \'AutomaticByOS\' & \'Manual\' are for Windows only, \'ImageDefault\' for Linux only.')
@allowed([
  'AutomaticByPlatform'
  'AutomaticByOS'
  'Manual'
  'ImageDefault'
])
param patchMode string?

@description('Optional. VM guest patching assessment mode. Set it to \'AutomaticByPlatform\' to enable automatically check for updates every 24 hours.')
@allowed([
  'AutomaticByPlatform'
  'ImageDefault'
])
param patchAssessmentMode string = 'ImageDefault'

// support added in 2024-05-20-preview
//@description('Optional. Captures the hotpatch capability enrollment intent of the customers, which enables customers to patch their Windows machines without requiring a reboot.')
//param enableHotpatching bool = false

// Child resources
@description('Optional. The guest configuration for the Arc machine. Needs the Guest Configuration extension to be enabled.')
param guestConfiguration object = {}

@description('Conditional. Required if you are providing OS-type specified configurations, such as patch settings. The chosen OS type, either Windows or Linux.')
@allowed([
  'Windows'
  'Linux'
])
param osType string?

// Shared parameters
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var linuxConfiguration = {
  patchSettings: (patchMode == 'AutomaticByPlatform' || patchMode == 'ImageDefault')
    ? {
        patchMode: patchMode
        assessmentMode: patchAssessmentMode
      }
    : null
}

var windowsConfiguration = {
  patchSettings: (patchMode == 'AutomaticByPlatform' || patchMode == 'AutomaticByOS' || patchMode == 'Manual')
    ? {
        patchMode: patchMode
        assessmentMode: patchAssessmentMode
        // enableHotpatching: enableHotpatching // support added in 2024-05-20-preview
      }
    : null
}

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Arc machine Administrator Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1c0163c0-47e6-4577-8991-ea5c82e286e4'
  )
  'Arc machine Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  )
  'Arc machine User Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fb879df8-f326-4884-b1cf-06f3ad86be52'
  )
  'Windows Admin Center Administrator Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a6333a3e-0164-44c3-b281-7a577aff287f'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.hybridcompute-machine.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '0.0.0'
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

resource machine 'Microsoft.HybridCompute/machines@2024-07-10' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  kind: kind
  properties: {
    osProfile: {
      windowsConfiguration: osType == 'Windows' ? windowsConfiguration : null
      linuxConfiguration: osType == 'Linux' ? linuxConfiguration : null
    }
    parentClusterResourceId: parentClusterResourceId
    vmId: vmId
    clientPublicKey: clientPublicKey
    privateLinkScopeResourceId: !empty(privateLinkScopeResourceId) ? privateLinkScopeResourceId : null
  }
}

resource AzureWindowsBaseline 'Microsoft.GuestConfiguration/guestConfigurationAssignments@2020-06-25' = if (!empty(guestConfiguration)) {
  name: 'gca-${name}'
  scope: machine
  dependsOn: []
  location: location
  properties: {
    guestConfiguration: guestConfiguration
  }
}

resource machine_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: machine
}

resource machine_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(machine.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: machine
  }
]

@description('The name of the machine.')
output name string = machine.name

@description('The resource ID of the machine.')
output resourceId string = machine.id

@description('The name of the resource group the VM was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = machine.?identity.?principalId ?? ''

@description('The location the resource was deployed into.')
output location string = machine.location
