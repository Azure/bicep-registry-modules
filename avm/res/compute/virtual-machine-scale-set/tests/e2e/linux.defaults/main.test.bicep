targetScope = 'subscription'

metadata name = 'Using only defaults for Linux'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualmachinescalesets-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cvmsslinmin'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    sshDeploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    sshKeyName: 'dep-${namePrefix}-ssh-${serviceShort}'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      adminUsername: 'scaleSetAdmin'
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
        diskSizeGB: '128'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      osType: 'Linux'
      skuName: 'Standard_B12ms'
      disablePasswordAuthentication: true
      nicConfigurations: [
        {
          ipConfigurations: [
            {
              name: 'ipconfig1'
              properties: {
                subnet: {
                  id: nestedDependencies.outputs.subnetResourceId
                }
                publicIPAddressConfiguration: {
                  name: '${namePrefix}-pip-${serviceShort}'
                }
              }
            }
          ]
          nicSuffix: '-nic01'
        }
      ]
      publicKeys: [
        {
          keyData: nestedDependencies.outputs.SSHKeyPublicKey
          path: '/home/scaleSetAdmin/.ssh/authorized_keys'
        }
      ]
    }
  }
]
