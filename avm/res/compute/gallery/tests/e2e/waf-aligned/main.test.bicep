targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.galleries-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cgwaf'

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '[[namePrefix]]'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    enableDefaultTelemetry: enableDefaultTelemetry
    name: '${namePrefix}${serviceShort}001'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    applications: [
      {
        name: '${namePrefix}-${serviceShort}-appd-001'
      }
      {
        name: '${namePrefix}-${serviceShort}-appd-002'
        supportedOSType: 'Windows'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
      }
    ]
    images: [
      {
        name: '${namePrefix}-az-imgd-ws-001'
      }
      {
        hyperVGeneration: 'V1'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '${namePrefix}-az-imgd-ws-002'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        sku: '2022-datacenter-azure-edition'
      }
      {
        hyperVGeneration: 'V2'
        isHibernateSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '${namePrefix}-az-imgd-ws-003'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        sku: '2022-datacenter-azure-edition-hibernate'
      }
      {
        hyperVGeneration: 'V2'
        isAcceleratedNetworkSupported: 'true'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 8
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '${namePrefix}-az-imgd-ws-004'
        offer: 'WindowsServer'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsServer'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        sku: '2022-datacenter-azure-edition-accnet'
      }
      {
        hyperVGeneration: 'V2'
        securityType: 'TrustedLaunch'
        maxRecommendedMemory: 16
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 2
        name: '${namePrefix}-az-imgd-wdtl-002'
        offer: 'WindowsDesktop'
        osState: 'Generalized'
        osType: 'Windows'
        publisher: 'MicrosoftWindowsDesktop'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalId: nestedDependencies.outputs.managedIdentityPrincipalId
            principalType: 'ServicePrincipal'
          }
        ]
        sku: 'Win11-21H2'
      }
      {
        hyperVGeneration: 'V2'
        maxRecommendedMemory: 32
        maxRecommendedvCPUs: 4
        minRecommendedMemory: 4
        minRecommendedvCPUs: 1
        name: '${namePrefix}-az-imgd-us-001'
        offer: '0001-com-ubuntu-server-focal'
        osState: 'Generalized'
        osType: 'Linux'
        publisher: 'canonical'
        sku: '20_04-lts-gen2'
      }
    ]
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}]
