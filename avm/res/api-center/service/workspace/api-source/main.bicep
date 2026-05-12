metadata name = 'API Center Service Workspace API Sources'
metadata description = 'This module deploys an API Center Service Workspace API Source for importing APIs from external sources like Azure API Management.'

@sys.description('Conditional. The name of the parent API Center service. Required if the template is used in a standalone deployment.')
param serviceName string

@sys.description('Conditional. The name of the parent workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@sys.description('Required. The name of the API source.')
@minLength(3)
@maxLength(90)
param name string

@sys.description('Optional. Indicates if the specification should be imported along with metadata.')
@allowed([
  'never'
  'ondemand'
  'always'
])
param importSpecification string?

@sys.description('Optional. The target environment resource ID within API Center.')
param targetEnvironmentId string?

@sys.description('Optional. The target lifecycle stage for imported APIs.')
@allowed([
  'design'
  'development'
  'testing'
  'preview'
  'production'
  'deprecated'
  'retired'
])
param targetLifecycleStage string?

@sys.description('Required. Configuration for importing APIs from an Azure API Management instance.')
param azureApiManagementSource azureApiManagementSourceType

@sys.description('Optional. Whether to deploy the API Management Service Reader role assignment on the target API Management instance. Defaults to true.')
param createRoleAssignment bool = true

resource service 'Microsoft.ApiCenter/services@2024-06-01-preview' existing = {
  name: serviceName

  resource workspace 'workspaces' existing = {
    name: workspaceName
  }
}

var useUserAssignedManagedIdentity = !empty(azureApiManagementSource.?msiResourceId ?? '')

// Safe parsing of msiResourceId - fallback values are used when msiResourceId is null (the existing resource won't be deployed)
var msiResourceIdSegments = split(
  azureApiManagementSource.?msiResourceId ?? '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/placeholder',
  '/'
)

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (useUserAssignedManagedIdentity) {
  name: msiResourceIdSegments[8]
  scope: resourceGroup(msiResourceIdSegments[2], msiResourceIdSegments[4])
}

var principalIdToUse = useUserAssignedManagedIdentity
  ? managedIdentity!.properties.principalId
  : (service.?identity.?principalId ?? '')

var apimResourceIdSegments = split(azureApiManagementSource.resourceId, '/')

module apimRoleAssignment 'modules/apimRoleAssignment.bicep' = if (createRoleAssignment) {
  name: '${uniqueString(deployment().name)}-ApiSource-ApimRbac'
  scope: resourceGroup(apimResourceIdSegments[2], apimResourceIdSegments[4])
  params: {
    apimServiceName: last(apimResourceIdSegments)!
    principalId: principalIdToUse
  }
}

resource apiSource 'Microsoft.ApiCenter/services/workspaces/apiSources@2024-06-01-preview' = {
  name: name
  parent: service::workspace
  properties: {
    importSpecification: importSpecification
    targetEnvironmentId: targetEnvironmentId
    targetLifecycleStage: targetLifecycleStage
    azureApiManagementSource: azureApiManagementSource
  }
  dependsOn: [
    apimRoleAssignment
  ]
}

@sys.description('The name of the API source.')
output name string = apiSource.name

@sys.description('The resource ID of the API source.')
output resourceId string = apiSource.id

@sys.description('The name of the resource group the API source was created in.')
output resourceGroupName string = resourceGroup().name

@export()
type azureApiManagementSourceType = {
  @sys.description('Required. The resource ID of the Azure API Management instance.')
  resourceId: string

  @sys.description('Optional. The resource ID of the managed identity that has access to the API Management instance.')
  msiResourceId: string?
}
