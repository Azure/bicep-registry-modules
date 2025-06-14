metadata name = 'Dev Center Project Policy'
metadata description = 'This module deploys a Dev Center Project Policy.'

@description('Conditional. The name of the parent dev center. Required if the template is used in a standalone deployment.')
param devcenterName string

@description('Required. The name of the project policy.')
@minLength(3)
@maxLength(63)
param name string

@description('Required. Resource policies that are a part of this project policy.')
param resourcePolicies resourcePolicyType

@description('Optional. Project names or resource IDs that will be in scope of this project policy. Project names can be used if the project is in the same resource group as the Dev Center. If the project is in a different resource group or subscription, the full resource ID must be provided. If not provided, the policy status will be set to "Unassigned".')
param projectsResourceIdOrName string[]?

resource devcenter 'Microsoft.DevCenter/devcenters@2025-02-01' existing = {
  name: devcenterName
}

// Resolve project names to resource IDs
var projectResourceIds = [
  for projectResourceIdOrName in (projectsResourceIdOrName ?? []): startsWith(
      projectResourceIdOrName,
      '/subscriptions/'
    )
    ? projectResourceIdOrName // It's already a resource ID
    : resourceId('Microsoft.DevCenter/projects', projectResourceIdOrName) // It's a project name, construct the resource ID
]

resource projectPolicy 'Microsoft.DevCenter/devcenters/projectPolicies@2025-02-01' = {
  parent: devcenter
  name: name
  properties: {
    resourcePolicies: resourcePolicies
    scopes: projectResourceIds
  }
}

@description('The name of the resource group the Dev Center Project Policy was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Dev Center Project Policy.')
output name string = projectPolicy.name

@description('The resource ID of the Dev Center Project Policy.')
output resourceId string = projectPolicy.id

// ================ //
// Definitions      //
// ================ //

@export()
@description('A resource policy for a Dev Center Project Policy. Each policy can specify an action (Allow/Deny), an optional filter, the resources included, and an optional resource type.')
type resourcePolicyType = {
  @description('Optional. Policy action to be taken on the resources. Defaults to "Allow" if not specified. Cannot be used when the "resources" property is provided.')
  action: 'Allow' | 'Deny'?

  @description('Optional. When specified, this expression is used to filter the resources.')
  filter: string?

  @description('Optional. Explicit resources that are "allowed" as part of a project policy. Must be in the format of a resource ID. Cannot be used when the "resourceType" property is provided.')
  resources: string?

  @description('Optional. The resource type being restricted or allowed by a project policy. Used with a given "action" to restrict or allow access to a resource type. If not specified for a given policy, the action will be set to "Allow" for the unspecified resource types. For example, if the action is "Deny" for "Images" and "Skus", the project policy will deny access to images and skus, but allow access for remaining resource types like "AttachedNetworks".')
  resourceType: 'AttachedNetworks' | 'Images' | 'Skus'?
}[]
