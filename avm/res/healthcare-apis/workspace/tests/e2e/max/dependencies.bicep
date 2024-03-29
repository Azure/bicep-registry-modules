@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Event Hub Namespace to create.')
param eventHubNamespaceName string

@description('Required. The name of the Event Hub consumer group to create.')
param eventHubConsumerGroupName string

@description('Required. The name of the Storage Account to create.')
param storageAccountName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_LRS'
    }
    kind: 'StorageV2'
}

resource ehns 'Microsoft.EventHub/namespaces@2022-01-01-preview' = {
    name: eventHubNamespaceName
    location: location
    sku: {
        name: 'Standard'
        tier: 'Standard'
        capacity: 1
    }
    properties: {
        zoneRedundant: false
        isAutoInflateEnabled: false
    }

    resource eventhub 'eventhubs@2022-01-01-preview' = {
        name: '${eventHubNamespaceName}-hub'
        properties: {
            messageRetentionInDays: 1
            partitionCount: 1
        }

        resource consumergroup 'consumergroups@2022-01-01-preview' = {
            name: eventHubConsumerGroupName
        }
    }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
@description('The resource ID of the created Storage Account.')
output storageAccountResourceId string = storageAccount.id

@description('The resource ID of the created Event Hub Namespace.')
output eventHubNamespaceResourceId string = ehns.id

@description('The name of the created Event Hub Namespace.')
output eventHubNamespaceName string = ehns.name

@description('The resource ID of the created Event Hub.')
output eventHubResourceId string = ehns::eventhub.id

@description('The name of the created Event Hub.')
output eventHubName string = ehns::eventhub.name
