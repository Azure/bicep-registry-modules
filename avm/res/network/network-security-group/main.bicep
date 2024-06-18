metadata name = 'Network Security Groups'
metadata description = 'This module deploys a Network security Group (NSG).'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Network Security Group.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param securityRules array = []

@description('Optional. When enabled, flows created from Network Security Group connections will be re-evaluated when rules are updates. Initial enablement will trigger re-evaluation. Network Security Group connection flushing is not available in all regions.')
param flushConnection bool = false

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the NSG resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-networksecuritygroup.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    flushConnection: flushConnection
    securityRules: [
      for securityRule in securityRules: {
        name: securityRule.name
        properties: {
          protocol: securityRule.properties.protocol
          access: securityRule.properties.access
          priority: securityRule.properties.priority
          direction: securityRule.properties.direction
          description: contains(securityRule.properties, 'description') ? securityRule.properties.description : ''
          sourcePortRange: contains(securityRule.properties, 'sourcePortRange')
            ? securityRule.properties.sourcePortRange
            : ''
          sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges')
            ? securityRule.properties.sourcePortRanges
            : []
          destinationPortRange: contains(securityRule.properties, 'destinationPortRange')
            ? securityRule.properties.destinationPortRange
            : ''
          destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges')
            ? securityRule.properties.destinationPortRanges
            : []
          sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix')
            ? securityRule.properties.sourceAddressPrefix
            : ''
          destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix')
            ? securityRule.properties.destinationAddressPrefix
            : ''
          sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes')
            ? securityRule.properties.sourceAddressPrefixes
            : []
          destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes')
            ? securityRule.properties.destinationAddressPrefixes
            : []
          sourceApplicationSecurityGroups: contains(securityRule.properties, 'sourceApplicationSecurityGroups')
            ? securityRule.properties.sourceApplicationSecurityGroups
            : []
          destinationApplicationSecurityGroups: contains(
              securityRule.properties,
              'destinationApplicationSecurityGroups'
            )
            ? securityRule.properties.destinationApplicationSecurityGroups
            : []
        }
      }
    ]
  }
}

module networkSecurityGroup_securityRules 'security-rule/main.bicep' = [
  for (securityRule, index) in securityRules: {
    name: '${uniqueString(deployment().name, location)}-NetworkSecurityGroup-SecurityRule-${index}'
    params: {
      name: securityRule.name
      networkSecurityGroupName: networkSecurityGroup.name
      protocol: securityRule.properties.protocol
      access: securityRule.properties.access
      priority: securityRule.properties.priority
      direction: securityRule.properties.direction
      description: contains(securityRule.properties, 'description') ? securityRule.properties.description : ''
      sourcePortRange: contains(securityRule.properties, 'sourcePortRange')
        ? securityRule.properties.sourcePortRange
        : ''
      sourcePortRanges: contains(securityRule.properties, 'sourcePortRanges')
        ? securityRule.properties.sourcePortRanges
        : []
      destinationPortRange: contains(securityRule.properties, 'destinationPortRange')
        ? securityRule.properties.destinationPortRange
        : ''
      destinationPortRanges: contains(securityRule.properties, 'destinationPortRanges')
        ? securityRule.properties.destinationPortRanges
        : []
      sourceAddressPrefix: contains(securityRule.properties, 'sourceAddressPrefix')
        ? securityRule.properties.sourceAddressPrefix
        : ''
      destinationAddressPrefix: contains(securityRule.properties, 'destinationAddressPrefix')
        ? securityRule.properties.destinationAddressPrefix
        : ''
      sourceAddressPrefixes: contains(securityRule.properties, 'sourceAddressPrefixes')
        ? securityRule.properties.sourceAddressPrefixes
        : []
      destinationAddressPrefixes: contains(securityRule.properties, 'destinationAddressPrefixes')
        ? securityRule.properties.destinationAddressPrefixes
        : []
      sourceApplicationSecurityGroups: contains(securityRule.properties, 'sourceApplicationSecurityGroups')
        ? securityRule.properties.sourceApplicationSecurityGroups
        : []
      destinationApplicationSecurityGroups: contains(securityRule.properties, 'destinationApplicationSecurityGroups')
        ? securityRule.properties.destinationApplicationSecurityGroups
        : []
    }
  }
]

resource networkSecurityGroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkSecurityGroup
}

resource networkSecurityGroup_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: networkSecurityGroup
  }
]

resource networkSecurityGroup_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(networkSecurityGroup.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkSecurityGroup
  }
]

@description('The resource group the network security group was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the network security group.')
output resourceId string = networkSecurityGroup.id

@description('The name of the network security group.')
output name string = networkSecurityGroup.name

@description('The location the resource was deployed into.')
output location string = networkSecurityGroup.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
