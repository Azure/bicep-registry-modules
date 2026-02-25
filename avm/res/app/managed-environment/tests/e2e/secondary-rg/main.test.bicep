targetScope = 'subscription'

metadata name = 'With an external certificate'
metadata description = 'This instance deploys the module with its certificate being located in a different resource group.'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-app.managedenvironments-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'amecert'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource primaryResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: primaryResourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// Secondary resources
// ====================
resource secondaryResourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  #disable-next-line BCP335 // Won't exceed the max length
  name: '${resourceGroupName}-snd'
  location: resourceLocation
}

module secondaryDependencies 'dependencies.secondary.bicep' = {
  scope: secondaryResourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-paramNested'
  params: {
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
    scope: primaryResourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      workloadProfiles: [
        {
          workloadProfileType: 'D4'
          name: 'CAW01'
          minimumCount: 0
          maximumCount: 3
        }
      ]
      managedIdentities: {
        userAssignedResourceIds: [
          secondaryDependencies.outputs.managedIdentityResourceId
        ]
      }
      internal: true
      dockerBridgeCidr: '172.16.0.1/28'
      platformReservedCidr: '172.17.17.0/24'
      platformReservedDnsIP: '172.17.17.17'
      infrastructureSubnetResourceId: nestedDependencies.outputs.subnetResourceId
      infrastructureResourceGroupName: 'me-${resourceGroupName}'
      certificate: {
        name: 'dep-${namePrefix}-cert-${serviceShort}'
        certificateKeyVaultProperties: {
          identityResourceId: secondaryDependencies.outputs.managedIdentityResourceId
          keyVaultUrl: '${secondaryDependencies.outputs.keyVaultUri}secrets/${split(secondaryDependencies.outputs.certificateSecretUrl, '/')[4]}'
        }
      }
    }
  }
]
