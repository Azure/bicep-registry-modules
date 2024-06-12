targetScope = 'managementGroup'

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

@maxLength(36)
@description('''The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to. Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).''')
param subscriptionTenantId string = ''

@maxLength(36)
@description('''The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner. Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants).''')
param subscriptionOwnerId string = ''

@description('Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.')
param subscriptionManagementGroupAssociationEnabled bool = true

@description('The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.')
param subscriptionManagementGroupId string = ''

var formattedAdditionalProperties = union(
  subscriptionManagementGroupAssociationEnabled && !empty(subscriptionManagementGroupId)
    ? {
        managementGroupId: tenantResourceId('Microsoft.Management/managementGroups', subscriptionManagementGroupId)
      }
    : {},
  (!empty(subscriptionTenantId) && !empty(subscriptionOwnerId))
    ? {
        subscriptionTenantId: subscriptionTenantId
        subscriptionOwnerId: subscriptionOwnerId
      }
    : {}
)

resource subscriptionAlias 'Microsoft.Subscription/aliases@2021-10-01' = {
  scope: tenant()
  name: subscriptionAliasName
  properties: {
    workload: subscriptionWorkload
    displayName: subscriptionDisplayName
    billingScope: subscriptionBillingScope
    additionalProperties: formattedAdditionalProperties
  }
}

output subscriptionId string = subscriptionAlias.properties.subscriptionId
output subscriptionResourceId string = '/subscriptions/${subscriptionAlias.properties.subscriptionId}'
output subscriptionAcceptOwnershipState string = (!empty(subscriptionTenantId) && !empty(subscriptionOwnerId))
  ? subscriptionAlias.properties.acceptOwnershipState
  : 'N/A'
output subscriptionAcceptOwnershipUrl string = (!empty(subscriptionTenantId) && !empty(subscriptionOwnerId))
  ? subscriptionAlias.properties.acceptOwnershipUrl
  : 'N/A'
