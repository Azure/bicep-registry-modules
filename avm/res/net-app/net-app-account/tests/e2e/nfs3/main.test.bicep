targetScope = 'subscription'

metadata name = 'Using nfs31 parameter set'
metadata description = 'This instance deploys the module with nfs31.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-netapp.netappaccounts-${serviceShort}-rg'

// enforcing location due to quote restrictions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'nanaanfs3'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The source of the encryption key.')
param encryptionKeySource string = 'Microsoft.NetApp'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: enforcedLocation
    capacityPools: [
      {
        name: '${namePrefix}-${serviceShort}-cp-001'
        serviceLevel: 'Premium'
        size: 4398046511104
        volumes: [
          {
            exportPolicyRules: [
              {
                allowedClients: '0.0.0.0/0'
                nfsv3: true
                nfsv41: false
                ruleIndex: 1
                unixReadOnly: false
                unixReadWrite: true
              }
            ]
            name: '${namePrefix}-${serviceShort}-vol-001'
            networkFeatures: 'Standard'
            encryptionKeySource: encryptionKeySource
            protocolTypes: [
              'NFSv3'
            ]
            roleAssignments: [
              {
                roleDefinitionIdOrName: 'Reader'
                principalId: nestedDependencies.outputs.managedIdentityPrincipalId
                principalType: 'ServicePrincipal'
              }
            ]
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
            usageThreshold: 107374182400
          }
          {
            name: '${namePrefix}-${serviceShort}-vol-002'
            networkFeatures: 'Standard'
            encryptionKeySource: encryptionKeySource
            protocolTypes: [
              'NFSv3'
            ]
            subnetResourceId: nestedDependencies.outputs.subnetResourceId
            usageThreshold: 107374182400
          }
        ]
      }
    ]
  }
}
