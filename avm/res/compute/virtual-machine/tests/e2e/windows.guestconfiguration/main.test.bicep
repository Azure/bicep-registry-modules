targetScope = 'subscription'

metadata name = 'Using guest configuration for Windows'
metadata description = 'This instance deploys the module with the a guest configuration.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualMachines-${serviceShort}-rg'

// Capacity constraints for VM type
#disable-next-line no-hardcoded-location
var enforcedLocation = 'uksouth'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmwinguest'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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
    location: enforcedLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //
@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      managedIdentities: {
        systemAssigned: true
      }
      location: enforcedLocation
      name: '${namePrefix}${serviceShort}'
      adminUsername: 'localAdminUser'
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      zone: 0
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig01'
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
              pipConfiguration: {
                publicIpNameSuffix: '-pip-01'
                zones: []
              }
            }
          ]
          nicSuffix: '-nic-01'
        }
      ]
      osDisk: {
        diskSizeGB: 128
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      osType: 'Windows'
      vmSize: 'Standard_D2s_v3'
      adminPassword: password
      extensionGuestConfigurationExtension: {
        enabled: true
      }
      guestConfiguration: {
        name: 'AzureWindowsBaseline'
        version: '1.*'
        assignmentType: 'ApplyAndMonitor'
        configurationParameter: [
          {
            name: 'Minimum Password Length;ExpectedValue'
            value: '16'
          }
          {
            name: 'Minimum Password Length;RemediateValue'
            value: '16'
          }
          {
            name: 'Maximum Password Age;ExpectedValue'
            value: '75'
          }
          {
            name: 'Maximum Password Age;RemediateValue'
            value: '75'
          }
        ]
      }
    }
  }
]
