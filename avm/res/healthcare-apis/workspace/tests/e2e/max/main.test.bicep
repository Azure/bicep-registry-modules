targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-healthcareapis.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'hawmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      publicNetworkAccess: 'Enabled'
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      fhirservices: [
        {
          name: '${namePrefix}-az-fhir-x-001'
          kind: 'fhir-R4'
          workspaceName: '${namePrefix}${serviceShort}001'
          corsOrigins: ['*']
          corsHeaders: ['*']
          corsMethods: ['GET']
          corsMaxAge: 600
          corsAllowCredentials: false
          location: resourceLocation
          diagnosticSettings: [
            {
              name: 'customSetting'
              metricCategories: [
                {
                  category: 'AllMetrics'
                }
              ]
              eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
              eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
              storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
              workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
          publicNetworkAccess: 'Enabled'
          resourceVersionPolicy: 'versioned'
          smartProxyEnabled: false
          managedIdentities: {
            systemAssigned: false
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
          importEnabled: false
          initialImportMode: false
          roleAssignments: [
            {
              roleDefinitionIdOrName: 'Owner'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
              roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
            {
              roleDefinitionIdOrName: resourceId(
                'Microsoft.Authorization/roleDefinitions',
                '5a1fc7df-4bf1-4951-a576-89034ee01acd'
              )
              principalId: nestedDependencies.outputs.managedIdentityPrincipalId
              principalType: 'ServicePrincipal'
            }
          ]
        }
      ]
      dicomservices: [
        {
          name: '${namePrefix}-az-dicom-x-001'
          workspaceName: '${namePrefix}${serviceShort}001'
          corsOrigins: ['*']
          corsHeaders: ['*']
          corsMethods: ['GET']
          corsMaxAge: 600
          corsAllowCredentials: false
          location: resourceLocation
          diagnosticSettings: [
            {
              name: 'customSetting'
              metricCategories: [
                {
                  category: 'AllMetrics'
                }
              ]
              eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
              eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
              storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
              workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
            }
          ]
          publicNetworkAccess: 'Enabled'
          managedIdentities: {
            systemAssigned: false
            userAssignedResourceIds: [
              nestedDependencies.outputs.managedIdentityResourceId
            ]
          }
        }
      ]
      roleAssignments: [
        {
          name: '6bfff821-2b18-4790-89fa-2849d86bc6be'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
