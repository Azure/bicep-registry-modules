targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventgrid.systemtopics-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'egstmax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// Dependencies for the main test (testDeployment loop)
module depSourceForTestDeployment 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dep-main'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}-main'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}main' // Unique SA name
    storageQueueName: 'dep${namePrefix}sq${serviceShort}main'
    serviceBusNamespaceName: 'dep-${namePrefix}-sbn-${serviceShort}-main'
    serviceBusTopicName: 'dep-${namePrefix}-sbt-${serviceShort}-main'
    location: resourceLocation
  }
}

// Dependencies for the noManagedIdentities test
module depSourceForNoMI 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dep-nomi'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}-nomi' // Not strictly needed by this test but part of dependencies module
    storageAccountName: 'dep${namePrefix}sa${serviceShort}nomi' // Unique SA name
    storageQueueName: 'dep${namePrefix}sq${serviceShort}nomi'
    serviceBusNamespaceName: 'dep-${namePrefix}-sbn-${serviceShort}-nomi'
    serviceBusTopicName: 'dep-${namePrefix}-sbt-${serviceShort}-nomi'
    location: resourceLocation
  }
}

// Dependencies for the onlyUserAssignedMI test
module depSourceForUserMI 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dep-usermi'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}-usermi'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}usermi' // Unique SA name
    storageQueueName: 'dep${namePrefix}sq${serviceShort}usermi'
    serviceBusNamespaceName: 'dep-${namePrefix}-sbn-${serviceShort}-usermi'
    serviceBusTopicName: 'dep-${namePrefix}-sbt-${serviceShort}-usermi'
    location: resourceLocation
  }
}

// Dependencies for the systemAssignedMIFalse test
module depSourceForSysMIFalse 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dep-sysmifalse'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}-sysmifalse'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}sysmif' // Unique SA name
    storageQueueName: 'dep${namePrefix}sq${serviceShort}sysmifalse'
    serviceBusNamespaceName: 'dep-${namePrefix}-sbn-${serviceShort}-sysmifalse'
    serviceBusTopicName: 'dep-${namePrefix}-sbt-${serviceShort}-sysmifalse'
    location: resourceLocation
  }
}

// Dependencies for the deliveryWithResourceIdentity test (Issue #705)
module depSourceFordelwri 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dep-delwri'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}-delwri'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}delwri' // Unique SA name
    storageQueueName: 'dep${namePrefix}sq${serviceShort}delwri'
    serviceBusNamespaceName: 'dep-${namePrefix}-sbn-${serviceShort}-delwri'
    serviceBusTopicName: 'dep-${namePrefix}-sbt-${serviceShort}-delwri'
    location: resourceLocation
  }
}


// Diagnostics (shared)
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
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
@batchSize(1) // Serializes iterations of this specific loop
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001' // System Topic name
      source: depSourceForTestDeployment.outputs.storageAccountResourceId // Unique source for this test
      topicType: 'Microsoft.Storage.StorageAccounts'
      location: resourceLocation
      eventSubscriptions: [
        {
          name: '${namePrefix}${serviceShort}001sub' // Event Subscription name needs to be unique per topic
          expirationTimeUtc: '2099-01-01T11:00:21.715Z'
          filter: {
            isSubjectCaseSensitive: false
            enableAdvancedFilteringOnArrays: true
          }
          retryPolicy: {
            maxDeliveryAttempts: 10
            eventTimeToLive: '120'
          }
          eventDeliverySchema: 'CloudEventSchemaV1_0'
          destination: {
            endpointType: 'StorageQueue'
            properties: {
              resourceId: depSourceForTestDeployment.outputs.storageAccountResourceId // Destination can be the same SA for the queue
              queueMessageTimeToLiveInSeconds: 86400
              queueName: depSourceForTestDeployment.outputs.queueName
            }
          }
        }
      ]
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
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        systemAssigned: true
      }
      roleAssignments: [
        {
          name: guid(resourceGroup.id, '${namePrefix}${serviceShort}001', 'Owner')
          roleDefinitionIdOrName: 'Owner'
          principalId: depSourceForTestDeployment.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid(resourceGroup.id, '${namePrefix}${serviceShort}001', 'Contributor')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
          principalId: depSourceForTestDeployment.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid(resourceGroup.id, '${namePrefix}${serviceShort}001', 'Reader')
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
          )
          principalId: depSourceForTestDeployment.outputs.managedIdentityPrincipalId
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
// Test case 1: systemAssignedMIPrincipalId should be null when no managed identities are configured
module testNoManagedIdentities '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-noMI'
  params: {
    name: '${namePrefix}${serviceShort}NoMI01' // System Topic name
    location: resourceLocation
    source: depSourceForNoMI.outputs.storageAccountResourceId // Unique source
    topicType: 'Microsoft.Storage.StorageAccounts'
    tags: {
      'test-scenario': 'no-managed-identities'
    }
  }
}
// Test case 2: systemAssignedMIPrincipalId should be null when only user-assigned MI is configured
module testOnlyUserAssignedMI '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-onlyUserMI'
  params: {
    name: '${namePrefix}${serviceShort}UserMI01' // System Topic name
    location: resourceLocation
    source: depSourceForUserMI.outputs.storageAccountResourceId // Unique source
    topicType: 'Microsoft.Storage.StorageAccounts'
    managedIdentities: {
      userAssignedResourceIds: [
        depSourceForUserMI.outputs.managedIdentityResourceId
      ]
    }
    tags: {
      'test-scenario': 'only-user-assigned-mi'
    }
  }
}
// Test case 3: systemAssignedMIPrincipalId should be null when systemAssigned is explicitly false
module testSystemAssignedMIFalse '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-sysMIFalse'
  params: {
    name: '${namePrefix}${serviceShort}SysMIFalse01' // System Topic name
    location: resourceLocation
    source: depSourceForSysMIFalse.outputs.storageAccountResourceId // Unique source
    topicType: 'Microsoft.Storage.StorageAccounts'
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        depSourceForSysMIFalse.outputs.managedIdentityResourceId
      ]
    }
    tags: {
      'test-scenario': 'system-assigned-mi-false'
    }
  }
}

// Test case 4: This test ensures that "destination" and "deliveryWithResourceIdentity" don't conflict
module testDeliveryWithResourceIdentity '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-delwri'
  params: {
    name: '${namePrefix}${serviceShort}delwri01' // System Topic name
    location: resourceLocation
    source: depSourceFordelwri.outputs.storageAccountResourceId // Unique source
    topicType: 'Microsoft.Storage.StorageAccounts'
    managedIdentities: {
      userAssignedResourceIds: [
        depSourceFordelwri.outputs.managedIdentityResourceId
      ]
    }
    eventSubscriptions: [
      {
        name: '${namePrefix}${serviceShort}delwriSub' // Event Subscription with managed identity
        expirationTimeUtc: '2099-01-01T11:00:21.715Z'
        filter: {
          isSubjectCaseSensitive: false
          enableAdvancedFilteringOnArrays: true
        }
        retryPolicy: {
          maxDeliveryAttempts: 10
          eventTimeToLive: '120'
        }
        eventDeliverySchema: 'CloudEventSchemaV1_0'

        deliveryWithResourceIdentity: {
          identity: {
            type: 'UserAssigned'
            userAssignedIdentity: depSourceFordelwri.outputs.managedIdentityResourceId
          }
          destination: {
            endpointType: 'ServiceBusTopic'
            properties: {
              resourceId: depSourceFordelwri.outputs.serviceBusTopicResourceId
            }
          }
        }
      }
    ]
    tags: {
      'test-scenario': 'delivery-with-resource-identity'
      issue705: 'true'
      'fix-verification': 'true'
    }
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The result of checking if systemAssignedMIPrincipalId is null when no managed identities are configured.')
output systemAssignedMIPrincipalIdForNoMIIsNull_CheckResult bool = (testNoManagedIdentities.outputs.?systemAssignedMIPrincipalId == null)

@description('The result of checking if systemAssignedMIPrincipalId is null when only user-assigned MI is configured.')
output systemAssignedMIPrincipalIdForUserOnlyIsNull_CheckResult bool = (testOnlyUserAssignedMI.outputs.?systemAssignedMIPrincipalId == null)

@description('The result of checking if systemAssignedMIPrincipalId is null when systemAssigned is explicitly false.')
output systemAssignedMIPrincipalIdForSysMIFalseIsNull_CheckResult bool = (testSystemAssignedMIFalse.outputs.?systemAssignedMIPrincipalId == null)

@description('The result of verifying that deliveryWithResourceIdentity works without API conflict (Issue #705).')
output deliveryWithResourceIdentityTest_CheckResult bool = (testDeliveryWithResourceIdentity.outputs.name != null)
