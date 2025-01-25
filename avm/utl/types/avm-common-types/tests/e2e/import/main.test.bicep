targetScope = 'subscription'

metadata name = 'Import all'
metadata description = '''
This example imports all available types of the given module.

Note: In your module you would import only the types you need.
'''

// ============== //
// Test Execution //
// ============== //

import {
  customerManagedKeyType
  customerManagedKeyWithAutoRotateType
  diagnosticSettingFullType
  diagnosticSettingLogsOnlyType
  diagnosticSettingMetricsOnlyType
  roleAssignmentType
  lockType
  managedIdentityAllType
  managedIdentityOnlySysAssignedType
  managedIdentityOnlyUserAssignedType
  privateEndpointMultiServiceType
  privateEndpointSingleServiceType
  secretToSetType
  secretSetOutputType
} from '../../../main.bicep' // Would be: br/public:avm/utl/types/avm-common-types:<version>

//  ====================== //
//   Diagnostic Settings   //
//  ====================== //
param diagnosticFull diagnosticSettingFullType[] = [
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
output diagnosticFullOutput diagnosticSettingFullType[] = diagnosticFull

param diagnosticMetricsOnly diagnosticSettingMetricsOnlyType[] = [
  {
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
]
output diagnosticMetricsOnlyOutput diagnosticSettingFullType[] = diagnosticMetricsOnly

param diagnosticLogsOnly diagnosticSettingLogsOnlyType[] = [
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
    name: 'mySettings'
    storageAccountResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Storage/storageAccounts/myStorageAccount'
    workspaceResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/myRg/providers/Microsoft.OperationalInsights/workspaces/myLaw'
  }
]
output diagnosticLogsOnlyOutput diagnosticSettingFullType[] = diagnosticLogsOnly

//  =================== //
//   Role Assignments   //
//  =================== //
param roleAssignments roleAssignmentType[] = [
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
output roleAssignmentsOutput roleAssignmentType[] = roleAssignments

// ========= //
//   Locks   //
// ========= //
param lock lockType = {
  kind: 'CanNotDelete'
  name: 'myLock'
}
output lockOutput lockType = lock

// ====================== //
//   Managed Idenitites   //
// ====================== //
param managedIdentityFull managedIdentityAllType = {
  systemAssigned: true
  userAssignedResourceIds: [
    '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
  ]
}
output managedIdentityFullOutput managedIdentityAllType = managedIdentityFull

param managedIdentityOnlySysAssigned managedIdentityOnlySysAssignedType = {
  systemAssigned: true
}
output managedIdentityOnlySysAssignedOutput managedIdentityAllType = managedIdentityOnlySysAssigned

param managedIdentityOnlyUserAssigned managedIdentityOnlyUserAssignedType = {
  userAssignedResourceIds: [
    '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
  ]
}
output managedIdentityOnlyUserAssignedOutput managedIdentityAllType = managedIdentityOnlyUserAssigned

// ===================== //
//   Private Endpoints   //
// ===================== //
param privateEndpointMultiService privateEndpointMultiServiceType[] = [
  {
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
    resourceGroupResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg'
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
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
]
output privateEndpointMultiServiceOutput privateEndpointMultiServiceType[] = privateEndpointMultiService

param privateEndpointSingleService privateEndpointSingleServiceType[] = [
  {
    subnetResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/defaultSubnet'
  }
]
output privateEndpointSingleServiceOutput privateEndpointSingleServiceType[] = privateEndpointSingleService

// ======================== //
//   Customer-Managed Keys  //
// ======================== //
param customerManagedKeyFull customerManagedKeyType = {
  keyName: 'myKey'
  keyVaultResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault'
  keyVersion: '2f4783701d724537a4e0c2d473c31846'
  userAssignedIdentityResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
}
output customerManagedKeyFullOutput customerManagedKeyType = customerManagedKeyFull

param customerManagedKeyDefaults customerManagedKeyType = {
  keyName: 'myKey'
  keyVaultResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault'
}
output customerManagedKeyDefaultsOutput customerManagedKeyType = customerManagedKeyDefaults

param customerManagedKeyWithAutoRotate customerManagedKeyWithAutoRotateType = {
  keyName: 'myKey'
  keyVaultResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault'
  autoRotationEnabled: false
  userAssignedIdentityResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
}
output customerManagedKeyWithAutoRotateOutput customerManagedKeyWithAutoRotateType = customerManagedKeyWithAutoRotate

// ================== //
//   Secrets Export   //
// ================== //
param secretToSet secretToSetType[] = [
  {
    name: 'mySecret'
    value: 'definitelyAValue'
  }
]
#disable-next-line outputs-should-not-contain-secrets // Does not contain a secret
output secretToSetOutput secretToSetType[] = secretToSet

param secretSet secretSetOutputType[] = [
  {
    secretResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.KeyVault/vaults/myVault/secrets/mySecret'
    secretUri: 'https://myVault.${az.environment().suffixes.keyvaultDns}/secrets/mySecret'
    secretUriWithVersion: 'https://myVault.${az.environment().suffixes.keyvaultDns}/secrets/mySecret/2f4783701d724537a4e0c2d473c31846'
  }
]
output secretSetOutput secretSetOutputType[] = secretSet
