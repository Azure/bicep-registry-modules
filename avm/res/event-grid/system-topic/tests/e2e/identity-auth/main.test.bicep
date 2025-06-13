targetScope = 'subscription'

metadata name = 'Using deliveryWithResourceIdentity with system-assigned identity'
metadata description = 'This test verify the Event Grid System Topic with deliveryWithResourceIdentity using system-assigned managed identity and automatic role assignments to Storage Account.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-eventgrid.systemtopics-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'egstsi'

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

module dependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-dependencies'
  params: {
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    storageQueueName: 'dep${namePrefix}sq${serviceShort}'
    storageBlobContainerName: 'dep${namePrefix}sc${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      source: dependencies.outputs.storageAccountResourceId
      topicType: 'Microsoft.Storage.StorageAccounts'
      location: resourceLocation
      managedIdentities: {
        systemAssigned: true
      }
      eventSubscriptions: [
        {
          name: '${namePrefix}${serviceShort}001'
          eventDeliverySchema: 'CloudEventSchemaV1_0'
          deliveryWithResourceIdentity: {
            identity: {
              type: 'SystemAssigned'
            }
            destination: {
              endpointType: 'StorageQueue'
              properties: {
                resourceId: dependencies.outputs.storageAccountResourceId
                queueMessageTimeToLiveInSeconds: 500000
                queueName: dependencies.outputs.queueName
              }
            }
          }
          // Also test deadLetterWithResourceIdentity with system-assigned identity
          deadLetterWithResourceIdentity: {
            identity: {
              type: 'SystemAssigned'
            }
            deadLetterDestination: {
              endpointType: 'StorageBlob'
              properties: {
                resourceId: dependencies.outputs.storageAccountResourceId
                blobContainerName: dependencies.outputs.blobContainerName
              }
            }
          }
          filter: {
            isSubjectCaseSensitive: false
          }
          retryPolicy: {
            maxDeliveryAttempts: 10
            eventTimeToLive: '600'          }
        }
      ]
      resourceRoleAssignments: [
        {
          resourceId: dependencies.outputs.storageAccountResourceId
          roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' // Storage Blob Data Contributor
          description: 'Allow Event Grid System Topic to write dead letter blobs to storage'
        }
        {
          resourceId: dependencies.outputs.storageAccountResourceId
          roleDefinitionIdOrName: '974c5e8b-45b9-4653-ba55-5f855dd0fb88' // Storage Queue Data Contributor
          description: 'Allow Event Grid System Topic to write to storage queue'
        }
        {
          resourceId: dependencies.outputs.storageAccountResourceId
          roleDefinitionIdOrName: 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a' // Storage Queue Data Message Sender
          description: 'Allow Event Grid System Topic to send messages to storage queue'
        }
      ]
    }
  }
]
