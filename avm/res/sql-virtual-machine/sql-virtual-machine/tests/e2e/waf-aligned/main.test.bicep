targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework. Patching is delegated to Azure Update Manager via a maintenance configuration on the underlying virtual machine instead of the retiring SQL IaaS Agent Automated Patching feature.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-sqlvirtualmachine.sqlvirtualmachines-${serviceShort}-rg'

// Capacity constraints for the SQL Server VM size used by the test dependencies
#disable-next-line no-hardcoded-location
var resourceLocation = 'eastus2'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'svmwaf'

@description('Optional. The administrator password for the virtual machine.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

var tags = {
  'hidden-title': 'This is visible in the resource name'
  Environment: 'Non-Prod'
  Role: 'DeploymentValidation'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    virtualMachineName: '${namePrefix}${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    dataCollectionRuleName: 'dep-${namePrefix}-dcr-${serviceShort}'
    adminPassword: password
    tags: tags
    location: resourceLocation
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      virtualMachineResourceId: nestedDependencies.outputs.virtualMachineResourceId
      sqlServerLicenseType: 'PAYG'
      assessmentSettings: {
        enable: true
        runImmediately: false
        schedule: {
          dayOfWeek: 'Sunday'
          enable: true
          startTime: '02:00'
          weeklyInterval: 1
        }
      }
      enableAutomaticUpgrade: true
      leastPrivilegeMode: 'Enabled'
      virtualMachineIdentitySettings: {
        type: 'SystemAssigned'
      }
      tags: tags
    }
  }
]
