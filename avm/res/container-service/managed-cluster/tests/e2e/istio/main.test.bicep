targetScope = 'subscription'

metadata name = 'Using Istio Service Mesh add-on'
metadata description = 'This instance deploys the module with Istio Service Mesh add-on and plug a Certificate Authority from Key Vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-containerservice.managedclusters-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csist'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    rootOrganization: 'Istio'
    caOrganization: 'Istio'
    caSubjectName: 'istiod.aks-istio.system.svc'
    cacertDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceLocation
      aadProfile: {
        aadProfileEnableAzureRBAC: true
        aadProfileManaged: true
      }
      managedIdentities: {
        systemAssigned: true
      }
      primaryAgentPoolProfiles: [
        {
          name: 'systempool'
          count: 2
          vmSize: 'Standard_DS4_v2'
          mode: 'System'
        }
      ]
      istioServiceMeshEnabled: true
      istioServiceMeshInternalIngressGatewayEnabled: true
      istioServiceMeshRevisions: [
        'asm-1-22'
      ]
      istioServiceMeshCertificateAuthority: {
        certChainObjectName: nestedDependencies.outputs.certChainSecretName
        certObjectName: nestedDependencies.outputs.caCertSecretName
        keyObjectName: nestedDependencies.outputs.caKeySecretName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
        rootCertObjectName: nestedDependencies.outputs.rootCertSecretName
      }
      enableKeyvaultSecretsProvider: true
      enableSecretRotation: true
    }
  }
]

module secretPermissions 'main.rbac.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-rbac'
  params: {
    keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
    principalId: testDeployment[0].outputs.keyvaultIdentityObjectId!
  }
}
