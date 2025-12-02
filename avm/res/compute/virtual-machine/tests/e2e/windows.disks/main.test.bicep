targetScope = 'subscription'

metadata name = 'Deploying Windows VM from an existing OS-Disk, with premium SSDv2 data disk and shared disk'
metadata description = 'This instance deploys the module with using a pre-existing OS Disk, premium SSDv2 data disk and attachment of an existing shared disk.'

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
param serviceShort string = 'cvmwindisk'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    sharedDiskName: 'dep-${namePrefix}-shared-disk-${serviceShort}'
    osDiskVMName: 'dep-${namePrefix}-os-disk-vm-${serviceShort}'
    osDiskName: 'dep-${namePrefix}-os-disk-${serviceShort}'
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    waitDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}-waitForPropagation'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep${namePrefix}kv${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
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
      name: '${namePrefix}${serviceShort}02'
      securityType: nestedDependencies.outputs.?securityType
      osType: nestedDependencies.outputs.osType
      vmSize: 'Standard_D2s_v3'
      availabilityZone: 1
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
        managedDisk: {
          resourceId: nestedDependencies.outputs.osDiskResourceId
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1024
          createOption: 'Empty'
          caching: 'None'
          managedDisk: {
            storageAccountType: 'PremiumV2_LRS'
          }
          diskIOPSReadWrite: 3000
          diskMBpsReadWrite: 125
        }
        {
          managedDisk: {
            resourceId: nestedDependencies.outputs.sharedDataDiskResourceId
            diskEncryptionSetResourceId: nestedDependencies.outputs.diskEncryptionSetResourceId
          }
        }
      ]
      extensionAntiMalwareConfig: {
        enabled: false
      }
    }
  }
]
