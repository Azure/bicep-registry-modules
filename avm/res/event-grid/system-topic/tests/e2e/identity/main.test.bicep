targetScope = 'subscription'

metadata name = 'Using managed identity authentication'
metadata description = 'This instance deploys the module testing delivery with resource identity (managed identity authentication).'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventgrid.systemtopics-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'egstid'

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

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    storageQueueName: 'dep${namePrefix}sq${serviceShort}'
    serviceBusNamespaceName: 'dep-${namePrefix}-sbn-${serviceShort}'
    serviceBusTopicName: 'dep-${namePrefix}-sbt-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001' // System Topic name
    location: resourceLocation
    source: nestedDependencies.outputs.storageAccountResourceId // Source for EventGrid System Topic
    topicType: 'Microsoft.Storage.StorageAccounts'
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    eventSubscriptions: [
      {
        name: '${namePrefix}${serviceShort}Sub' // Event Subscription with managed identity
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
            userAssignedIdentity: nestedDependencies.outputs.managedIdentityResourceId
          }
          destination: {
            endpointType: 'ServiceBusTopic'
            properties: {
              resourceId: nestedDependencies.outputs.serviceBusTopicResourceId
            }
          }
        }
      }
    ]
    tags: {
      'test-scenario': 'delivery-with-resource-identity'
      'fix-verification': 'true'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

// ======= //
// Outputs //
// ======= //

@description('The name of the resource group that was deployed.')
output resourceGroupName string = resourceGroup.name

@description('The location the resource was deployed into.')
output location string = deployment().location

@description('The resource ID of the EventGrid System Topic.')
output resourceId string = testDeployment.outputs.resourceId

@description('The name of the EventGrid System Topic.')
output name string = testDeployment.outputs.name
