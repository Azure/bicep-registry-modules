targetScope = 'subscription'

metadata name = 'Pinned Gallery Applications with Flexible orchestration'
metadata description = '''
Assigns two existing Gallery Application Versions to the common Flexible scale set model. The dependencies publish harmless test packages as version 1.0.0; the resource module itself does not publish packages. Existing instances follow platform upgrade behavior. Application order is per VM, not VM rollout order. Failure propagation does not verify end-to-end application health. Manage this array as the complete intended set of application assignments.

For an existing application, the scale set module parameter can be configured as follows. Replace the angle-bracket placeholders with your existing resource names and subscription ID; keep the numeric application version pinned:

```bicep
galleryApplications: [
  {
    packageReferenceId: '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Compute/galleries/<galleryName>/applications/<applicationName>/versions/1.0.0'
    enableAutomaticUpgrade: false
    treatFailureAsDeploymentFailure: true
    order: 1
  }
]
```
'''

@description('Optional. The location to deploy to.')
param location string = deployment().location

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-compute.virtualmachinescalesets-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment.')
param serviceShort string = 'cvmsslinapps'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

@description('Optional. The expiration time of the temporary package SAS.')
param packageSasExpiry string = dateTimeAdd(utcNow(), 'P1D')

resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: location
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    location: location
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    galleryName: 'dep${namePrefix}${serviceShort}'
    storageAccountName: 'dep${uniqueString(resourceGroup.id, serviceShort)}'
    deploymentScriptName: 'dep-${namePrefix}-ds-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    packageSasExpiry: packageSasExpiry
  }
}

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: location
      adminUsername: 'scaleSetAdmin'
      adminPassword: password
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      osType: 'Linux'
      orchestrationMode: 'Flexible'
      skuName: 'Standard_D2s_v5'
      skuCapacity: 1
      patchMode: 'ImageDefault'
      patchAssessmentMode: 'ImageDefault'
      extensionHealthConfig: {
        enabled: true
        protocol: 'tcp'
        port: 22
      }
      nicConfigurations: [
        {
          nicSuffix: '-nic01'
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
        }
      ]
      galleryApplications: [
        {
          packageReferenceId: '${nestedDependencies.outputs.applicationResourceIds[0]}/versions/1.0.0'
          enableAutomaticUpgrade: false
          treatFailureAsDeploymentFailure: true
          order: 1
          tags: 'first-test-application'
        }
        {
          packageReferenceId: '${nestedDependencies.outputs.applicationResourceIds[1]}/versions/1.0.0'
          enableAutomaticUpgrade: false
          treatFailureAsDeploymentFailure: false
          order: 2
        }
      ]
    }
  }
]

@description('The resource ID of the scale set under test.')
output virtualMachineScaleSetResourceId string = testDeployment[1].outputs.resourceId

@description('The expected application version resource IDs.')
output applicationVersionResourceIds string[] = nestedDependencies.outputs.applicationVersionResourceIds
