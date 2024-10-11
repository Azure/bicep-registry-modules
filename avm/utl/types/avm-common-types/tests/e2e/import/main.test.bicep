targetScope = 'subscription'

metadata name = 'Import'
metadata description = '''
This example imports all available types of the given module.'

Note: When using the published module, you should import the types via the Public Bicep Registry using the following syntax: `br/public:avm/utl/types/avm-common-types:<version>`
'''

// ============== //
// Test Execution //
// ============== //

// Triggering comme

import {
  customerManagedKeyType
  diagnosticSettingFullType
  diagnosticSettingLogsOnlyType
  diagnosticSettingMetricsOnlyType
  roleAssignmentType
  lockType
  managedIdentitiesAllType
  managedIdentitiesOnlySysAssignedType
  managedIdentitiesOnlyUserAssignedType
  privateEndpointMultiServiceType
  privateEndpointSingleServiceType
  secretToSetType
  secretSetType
} from '../../../main.bicep'

//  ====================== //
//   Diagnostic Settings   //
//  ====================== //
output diagnosticFull diagnosticSettingFullType[] = [
  {
    eventHubAuthorizationRuleResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.EventHub/namespaces/myNamespace/eventhubs/myHub/authorizationRules/myRule'
    eventHubName: 'myHub'
    logAnalyticsDestinationType: 'AzureDiagnostics'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
      }
      {
        category: 'jobs'
      }
      {
        category: 'notebook'
      }
    ]
    marketplacePartnerResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Datadog/monitors/dd1'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'mySettings'
    storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
    workspaceResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/myRg/providers/Microsoft.OperationalInsights/workspaces/myLaw'
  }
  {
    eventHubAuthorizationRuleResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.EventHub/namespaces/myNamespace/eventhubs/myHub/authorizationRules/myRule'
    eventHubName: 'myHub'
    storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
    workspaceResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/myRg/providers/Microsoft.OperationalInsights/workspaces/myLaw'
  }
]
output diagnosticMetricsOnly diagnosticSettingMetricsOnlyType = {
  eventHubAuthorizationRuleResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.EventHub/namespaces/myNamespace/eventhubs/myHub/authorizationRules/myRule'
  eventHubName: 'myHub'
  logAnalyticsDestinationType: 'AzureDiagnostics'
  marketplacePartnerResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Datadog/monitors/dd1'
  metricCategories: [
    {
      category: 'AllMetrics'
    }
  ]
  name: 'mySettings'
  storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
  workspaceResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/myRg/providers/Microsoft.OperationalInsights/workspaces/myLaw'
}
output diagnosticLogsOnly diagnosticSettingLogsOnlyType = {
  eventHubAuthorizationRuleResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.EventHub/namespaces/myNamespace/eventhubs/myHub/authorizationRules/myRule'
  eventHubName: 'myHub'
  logAnalyticsDestinationType: 'AzureDiagnostics'
  logCategoriesAndGroups: [
    {
      categoryGroup: 'allLogs'
    }
    {
      category: 'jobs'
    }
    {
      category: 'notebook'
    }
  ]
  marketplacePartnerResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Datadog/monitors/dd1'
  name: 'mySettings'
  storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
  workspaceResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/myRg/providers/Microsoft.OperationalInsights/workspaces/myLaw'
}

//  =================== //
//   Role Assignments   //
//  =================== //
output roleAssignments roleAssignmentType[] = [
  {
    principalId: '11111111-1111-1111-1111-111111111111'
    roleDefinitionIdOrName: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'acdd72a7-3385-48ef-bd42-f606fba81ae7'
    ) // Reader
    condition: '((!(ActionMatches{\'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read\'})) OR (@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringEquals \'blobs-example-container\'))'
    conditionVersion: '2.0'
    delegatedManagedIdentityResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
    description: 'my description'
    name: 'myRoleAssignment'
    principalType: 'ServicePrincipal'
  }
  {
    principalId: '22222222-2222-2222-2222-222222222222'
    roleDefinitionIdOrName: 'Reader'
    principalType: 'ServicePrincipal'
  }
  {
    principalId: '33333333-3333-3333-3333-333333333333'
    roleDefinitionIdOrName: 'acdd72a7-3385-48ef-bd42-f606fba81ae7' //Reader
    principalType: 'ServicePrincipal'
  }
]

// ========= //
//   Locks   //
// ========= //
output locks lockType = {
  kind: 'CanNotDelete'
  name: 'myLock'
}

// ====================== //
//   Managed Idenitites   //
// ====================== //
output managedIdentitiesFull managedIdentitiesAllType = {
  systemAssigned: true
  userAssignedResourceIds: [
    '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
  ]
}
output managedIdentitiesOnlySysAssigned managedIdentitiesOnlySysAssignedType = {
  systemAssigned: true
}
output managedIdentitiesOnlyUserAssigned managedIdentitiesOnlyUserAssignedType = {
  userAssignedResourceIds: [
    '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
  ]
}

// ===================== //
//   Private Endpoints   //
// ===================== //
output privateEndpointMultiService privateEndpointMultiServiceType = {
  lock: {
    kind: 'CanNotDelete'
    name: 'myLock'
  }
  roleAssignments: [
    {
      principalId: '11111111-1111-1111-1111-111111111111'
      roleDefinitionIdOrName: subscriptionResourceId(
        'Microsoft.Authorization/roleDefinitions',
        'acdd72a7-3385-48ef-bd42-f606fba81ae7'
      ) // Reader
    }
  ]
  subnetResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/defaultSubnet'
  service: 'blob'
  applicationSecurityGroupResourceIds: [
    '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/applicationSecurityGroups/myAsg'
  ]
  customDnsConfigs: [
    {
      ipAddresses: [
        '1.2.3.4'
      ]
    }
  ]
  customNetworkInterfaceName: 'myInterface'
  ipConfigurations: [
    {
      name: 'myIpConfig'
      properties: {
        groupId: 'blob'
        memberName: 'blob'
        privateIPAddress: '1.2.3.4'
      }
    }
  ]
  isManualConnection: false
  location: 'WestEurope'
  manualConnectionRequestMessage: 'Please approve this connection.'
  name: 'myPrivateEndpoint'
  privateDnsZoneGroup: {
    privateDnsZoneGroupConfigs: [
      {
        privateDnsZoneResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/privateDnsZones/myZone'
        name: 'myConfig'
      }
    ]
  }
  privateLinkServiceConnectionName: 'myConnection'
  resourceGroupName: 'myResourceGroup'
  tags: {
    Environment: 'Non-Prod'
    Role: 'DeploymentValidation'
  }
}

output privateEndpointSingleService privateEndpointSingleServiceType = {
  subnetResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/defaultSubnet'
}

// ======================== //
//   Customer-Managed Keys  //
// ======================== //
output customerManagedKeyFull customerManagedKeyType = {
  keyName: 'myKey'
  keyVaultResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault'
  keyVersion: '2f4783701d724537a4e0c2d473c31846'
  userAssignedIdentityResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
}
output customerManagedKeyDefaults customerManagedKeyType = {
  keyName: 'myKey'
  keyVaultResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault'
}

// ================== //
//   Secrets Export   //
// ================== //
output secretSet secretToSetType = {
  name: 'mySecret'
  value: 'definitelyAValue'
}
output secretToSet secretSetType = {
  secretResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault/secrets/mySecret'
  secretUri: 'https://myVault.${az.environment().suffixes.keyvaultDns}/secrets/mySecret'
  secretUriWithVersion: 'https://myVault.${az.environment().suffixes.keyvaultDns}/secrets/mySecret/2f4783701d724537a4e0c2d473c31846'
}
