targetScope = 'tenant'

@maxLength(63)
@description('The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.')
param subscriptionDisplayName string

@maxLength(63)
@description('The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, -, _ and space. The maximum length is 63 characters.')
param subscriptionAliasName string

@description('The billing scope for the new subscription alias. A valid billing scope starts with `/providers/Microsoft.Billing/billingAccounts/` and is case sensitive.')
param subscriptionBillingScope string

@allowed([
  'DevTest'
  'Production'
])
@description('The workload type can be either `Production` or `DevTest` and is case sensitive.')
param subscriptionWorkload string = 'Production'

resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  name: subscriptionAliasName
  properties: {
    workload: subscriptionWorkload
    displayName: subscriptionDisplayName
    billingScope: subscriptionBillingScope
  }
}

output subscriptionId string = subscriptionAlias.properties.subscriptionId
output subscriptionResourceId string = '/subscriptions/${subscriptionAlias.properties.subscriptionId}'
