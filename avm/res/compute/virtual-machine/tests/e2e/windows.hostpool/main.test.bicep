targetScope = 'subscription'

metadata name = 'Using a host pool to register the VM'
metadata description = 'This instance deploys the module and registers it in a host pool.'

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
param serviceShort string = 'cvmwinhp'

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
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    hostPoolName: 'dep${namePrefix}-hp-${serviceShort}01'
    getRegistrationTokenDeploymentScriptName: 'dep-${namePrefix}-rtds-${serviceShort}'
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
      location: enforcedLocation
      name: take('h${namePrefix}${serviceShort}', 15)
      adminUsername: 'localAdminUser'
      managedIdentities: {
        systemAssigned: true
      }
      availabilityZone: -1
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig01'
              subnetResourceId: nestedDependencies.outputs.subnetResourceId
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
      extensionAadJoinConfig: {
        enabled: true
        settings: {
          mdmId: '' // '0000000a-0000-0000-c000-000000000000'
        }
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
      extensionHostPoolRegistration: {
        enabled: true
        hostPoolName: nestedDependencies.outputs.hostPoolName
        registrationInfoToken: nestedDependencies.outputs.registrationInfoToken
        modulesUrl: 'https://wvdportalstorageblob.blob.${environment().suffixes.storage}/galleryartifacts/Configuration_09-08-2022.zip'
        configurationFunction: 'Configuration.ps1\\AddSessionHost'
        tags: {
          'hidden-title': 'This is visible in the resource name'
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    }
  }
]
