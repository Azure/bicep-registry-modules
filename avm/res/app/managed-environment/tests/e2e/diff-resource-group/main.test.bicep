targetScope = 'subscription'

metadata name = 'Using different locations'
metadata description = 'This instance deploys a keyvault and certificate in a different resource group.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.managedenvironments-${serviceShort}-rg'

@description('Optional. The name of the second resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName2 string = 'dep-${namePrefix}-app.managedenvironments-${serviceShort}2-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'amedrg'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

resource resourceGroup2 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName2
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    appInsightsComponentName: 'dep-${namePrefix}-appinsights-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
  }
}

module nestedDependencies2 'dependencies2.bicep' = {
  scope: resourceGroup2
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested2'
  params: {
    location: resourceLocation
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    certname: 'dep-${namePrefix}-cert-${serviceShort}'
    certDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      appLogsConfiguration: {
        destination: 'log-analytics'
        logAnalyticsConfiguration: {
          customerId: nestedDependencies.outputs.logAnalyticsWorkspaceCustomerId
          sharedKey: listKeys(
            '${resourceGroup.id}/providers/Microsoft.OperationalInsights/workspaces/dep-${namePrefix}-law-${serviceShort}',
            '2023-09-01'
          ).primarySharedKey
        }
      }
      location: resourceLocation
      appInsightsConnectionString: nestedDependencies.outputs.appInsightsConnectionString
      workloadProfiles: [
        {
          workloadProfileType: 'D4'
          name: 'CAW01'
          minimumCount: 0
          maximumCount: 3
        }
      ]
      internal: true
      dnsSuffix: 'contoso.com'
      certificate: {
        name: 'dep-${namePrefix}-cert-${serviceShort}'
        certificateKeyVaultProperties: {
          identityResourceId: nestedDependencies2.outputs.managedIdentityResourceId
          keyVaultUrl: '${nestedDependencies2.outputs.keyVaultUri}secrets/${split(nestedDependencies2.outputs.certificateSecretUrl, '/')[4]}'
        }
      }
      dockerBridgeCidr: '172.16.0.1/28'
      peerTrafficEncryption: true
      platformReservedCidr: '172.17.17.0/24'
      platformReservedDnsIP: '172.17.17.17'
      infrastructureSubnetResourceId: nestedDependencies.outputs.subnetResourceId
      infrastructureResourceGroupName: 'me-${resourceGroupName}'
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies2.outputs.managedIdentityResourceId
        ]
      }
      roleAssignments: [
        {
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]

      storages: [
        {
          kind: 'SMB'
          shareName: 'smbfileshare'
          accessMode: 'ReadWrite'
          storageAccountName: nestedDependencies.outputs.storageAccountName
        }
        {
          kind: 'NFS'
          shareName: 'nfsfileshare'
          accessMode: 'ReadWrite'
          storageAccountName: nestedDependencies.outputs.storageAccountName
        }
      ]
    }
  }
]
