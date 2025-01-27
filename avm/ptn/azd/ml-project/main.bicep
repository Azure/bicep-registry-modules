metadata name = 'Azd Machine Learning workspace'
metadata description = '''Create a machine learning workspace, configure the key vault access policy and assign role permissions to the machine learning instance.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. The name of the machine learning workspace.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

@description('Optional. Specifies the SKU, also referred as \'edition\' of the Azure Machine Learning workspace.')
@allowed([
  'Free'
  'Basic'
  'Standard'
  'Premium'
])
param projectSku string = 'Basic'

@description('Optional. The type of Azure Machine Learning workspace to create.')
@allowed([
  'Default'
  'Project'
  'Hub'
  'FeatureStore'
])
param projectKind string = 'Project'

@description('Optional. The flag to signal HBI data in the workspace and reduce diagnostic data collected by the service.')
param hbiWorkspace bool = false

@description('Optional. Whether or not public network access is allowed for this machine learning workspace. For security reasons it should be disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Required. The resource ID of the AI Studio Hub Resource where this project should be created.')
param hubResourceId string

@description('Required. The name of the key vault.')
param keyVaultName string

@description('Optional. The managed identity definition for the machine learning resource. At least one identity type is required.')
param projectManagedIdentities managedIdentitiesType = {
  systemAssigned: true
}

@description('Required. The name of the user assigned identity.')
param userAssignedName string

@description('Optional. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'. Default roles: AzureML Data Scientist, Azure Machine Learning Workspace Connection Secrets Reader.')
param roleDefinitionIdOrName array = [
  'f6c7c914-8db3-469d-8ca1-694a8f32e121' // AzureML Data Scientist
  'ea01e6af-a1c1-4350-9563-ad00f8c72ec5' // Azure Machine Learning Workspace Connection Secrets Reader
]

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-mlproject.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module project 'br/public:avm/res/machine-learning-services/workspace:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-project'
  params: {
    name: name
    tags: tags
    sku: projectSku
    kind: projectKind
    managedIdentities: projectManagedIdentities
    hbiWorkspace: hbiWorkspace
    publicNetworkAccess: publicNetworkAccess
    hubResourceId: hubResourceId
    enableTelemetry: enableTelemetry
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName

  resource keyVaultAccess 'accessPolicies@2023-07-01' = {
    name: 'add'
    properties: {
      accessPolicies: [
        {
          objectId: project.outputs.systemAssignedMIPrincipalId
          permissions: { secrets: ['get', 'list'] }
          tenantId: tenant().tenantId
        }
      ]
    }
  }
}

module mlServiceRoleAssigned 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: '${uniqueString(deployment().name, location)}-roleassignment'
  params: {
    name: userAssignedName
    location: location
    roleAssignments: [
      for id in roleDefinitionIdOrName: {
        principalId: project.outputs.systemAssignedMIPrincipalId
        roleDefinitionIdOrName: id
        principalType: 'ServicePrincipal'
      }
    ]
    enableTelemetry: enableTelemetry
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the machine learning workspace were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the machine learning workspace.')
output projectResourceId string = project.outputs.resourceId

@description('The resource name of the machine learning workspace.')
output projectName string = project.outputs.name

@description('The principal ID of the machine learning workspace.')
output projectPrincipalId string = project.outputs.systemAssignedMIPrincipalId

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource. Must be false if `primaryUserAssignedIdentity` is provided.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}
