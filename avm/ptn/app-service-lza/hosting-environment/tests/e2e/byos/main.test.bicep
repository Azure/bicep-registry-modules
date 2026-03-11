metadata name = 'Bring Your Own Storage'
metadata description = 'This instance deploys the module with Azure Files mounted as custom storage (BYOS) on a Linux web app behind Application Gateway.'

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-ptn.appsvclza-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'apbyo'

@description('Optional. Test name prefix.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location
var enforcedLocation = 'australiaeast'

// Dependencies
// ===========
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module dependencies './dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-dependencies'
  params: {
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    storageAccountName: take('dep${namePrefix}sa${serviceShort}', 24)
    fileShareName: 'appdata'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      workloadName: take('${namePrefix}${serviceShort}', 10)
      logAnalyticsWorkspaceResourceId: dependencies.outputs.logAnalyticsWorkspaceResourceId
      tags: {
        environment: 'test'
        scenario: 'byos'
      }

      servicePlanConfig: {
        kind: 'linux'
      }
      appServiceConfig: {
        kind: 'app,linux'
        storageAccounts: {
          appdata: {
            accountName: dependencies.outputs.storageAccountName
            accessKey: dependencies.outputs.storageAccountKey
            shareName: dependencies.outputs.fileShareName
            mountPath: '/mnt/appdata'
            type: 'AzureFiles'
            protocol: 'Smb'
          }
        }
      }
      spokeNetworkConfig: {
        resourceGroupName: resourceGroupName
        ingressOption: 'applicationGateway'
        appGwSubnetAddressSpace: '10.240.12.0/24'
      }

      location: enforcedLocation
    }
  }
]

output testDeploymentOutputs object = testDeployment[0].outputs
