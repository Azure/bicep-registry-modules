metadata name = 'Compute Galleries Applications'
metadata description = 'This module deploys an Azure Compute Gallery Application.'

@sys.description('Required. Name of the application definition.')
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Conditional. The name of the parent Azure Compute Gallery. Required if the template is used in a standalone deployment.')
@minLength(1)
param galleryName string

@sys.description('Optional. The description of this gallery Application Definition resource. This property is updatable.')
param description string?

@sys.description('Optional. The Eula agreement for the gallery Application Definition. Has to be a valid URL.')
param eula string?

@sys.description('Optional. The privacy statement uri. Has to be a valid URL.')
param privacyStatementUri string?

@sys.description('Optional. The release note uri. Has to be a valid URL.')
param releaseNoteUri string?

@sys.description('Required. This property allows you to specify the supported type of the OS that application is built for.')
@allowed([
  'Windows'
  'Linux'
])
param supportedOSType string

@sys.description('Optional. The end of life date of the gallery Image Definition. This property can be used for decommissioning purposes. This property is updatable. Allowed format: 2020-01-10T23:00:00.000Z.')
param endOfLifeDate string?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@sys.description('Optional. Tags for all resources.')
param tags resourceInput<'Microsoft.Compute/galleries/applications@2024-03-03'>.tags?

@sys.description('Optional. A list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.')
param customActions customActionType[]?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  'Compute Gallery Sharing Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1ef6a3be-d0ac-425d-8c01-acb62866290b'
  )
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
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.compute-gallery-application.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource gallery 'Microsoft.Compute/galleries@2024-03-03' existing = {
  name: galleryName
}

resource application 'Microsoft.Compute/galleries/applications@2024-03-03' = {
  name: name
  parent: gallery
  location: location
  tags: tags
  properties: {
    customActions: customActions
    description: description
    endOfLifeDate: endOfLifeDate
    eula: eula
    privacyStatementUri: privacyStatementUri
    releaseNoteUri: releaseNoteUri
    supportedOSType: supportedOSType
  }
}

resource application_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(application.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: application
  }
]

@sys.description('The resource group the image was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The resource ID of the image.')
output resourceId string = application.id

@sys.description('The name of the image.')
output name string = application.name

@sys.description('The location the resource was deployed into.')
output location string = application.location

// =============== //
//   Definitions   //
// =============== //

@export()
@sys.description('The type for a custom action.')
type customActionType = {
  @sys.description('Required. The name of the custom action. Must be unique within the Gallery Application Version.')
  name: string

  @sys.description('Required. The script to run when executing this custom action.')
  script: string

  @sys.description('Optional. Description to help the users understand what this custom action does.')
  description: string?

  @sys.description('Optional. The parameters that this custom action uses.')
  parameters: {
    @sys.description('Required. The name of the parameter.')
    name: string

    @sys.description('Optional. Specifies the type of the custom action parameter.')
    type: ('ConfigurationDataBlob' | 'LogOutputBlob' | 'String')?

    @sys.description('Optional. A description to help users understand what this parameter means.')
    description: string?

    @sys.description('Optional. The default value of the parameter. Only applies to string types.')
    defaultValue: string?

    @sys.description('Optional. Indicates whether this parameter must be passed when running the custom action.')
    required: bool?
  }[]?
}
