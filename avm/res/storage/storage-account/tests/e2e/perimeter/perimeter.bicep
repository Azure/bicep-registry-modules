@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the perimeter.')
param perimeterName string

@description('Required. The resource ID of the storage account to secure with the perimeter.')
param storageAccountResourceId string

var profileName = 'Default'

module perimeter '../../../../../network/network-security-perimeter/main.bicep' = {
  params: {
    name: perimeterName
    location: location
    resourceAssociations: [
      {
        accessMode: 'Enforced'
        privateLinkResource: storageAccountResourceId
        profile: profileName
      }
    ]
    profiles: [
      {
        name: profileName
        accessRules: [
          {
            name: 'AllowSubscription'
            direction: 'Inbound'
            subscriptions: [
              {
                id: subscription().id
              }
            ]
          }
        ]
      }
    ]
  }
}
