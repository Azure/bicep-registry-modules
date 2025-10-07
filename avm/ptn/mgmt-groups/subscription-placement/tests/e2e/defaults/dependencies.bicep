targetScope = 'tenant'

@description('Required. The root management group resource ID where the subscriptions will be placed.')
@secure()
param rootManagementGroupResourceId string


@description('Required. The scope of the subscription billing.')
@secure()
param subscriptionBillingScope string

resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'test-mgmt-group'
  properties: {
    displayName: 'Test Management Group'
    details:{
      parent:{
        id: rootManagementGroupResourceId
      }
    }
  }
}

resource managementGroup2 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: 'test-mgmt-group-2'
  properties: {
    displayName: 'Test Management Group'
    details:{
      parent:{
        id: rootManagementGroupResourceId
      }
    }
  }
}

module subVending 'br/public:avm/ptn/lz/sub-vending:0.4.0' = {
  name: 'subVendingDeployment'
  scope: managementGroup
  params: {
    subscriptionAliasEnabled: true
    subscriptionAliasName: 'AVMSubPlacementSub'
    subscriptionBillingScope: subscriptionBillingScope
    subscriptionDisplayName: 'AVMSubPlacementSub'

    subscriptionTags: {
      avmTest: 'true'
    }
    subscriptionWorkload: 'Production'
    resourceProviders: {}
  }
}

@description('Output of the management group resource ID.')
output managementGroupId string = managementGroup.id

@description('Output of the management group name.')
output managementGroupName string = managementGroup.name

@description('Output of the second management group resource ID.')
output managementGroupId2 string = managementGroup2.id

@description('Output of the second management group name.')
output managementGroupName2 string = managementGroup2.name

@description('Output of the subscription vending resource ID.')
output subVendingResourceId string = subVending.outputs.subscriptionResourceId

@description('Output of the subscription vending subscription ID.')
output subVendingSubscriptionId string = subVending.outputs.subscriptionId
