targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-aiplatform-baseline-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aipbmax'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. The password to leverage for the login.')
@secure()
param password string = newGuid()

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
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    networkSecurityGroupName: 'dep${namePrefix}nsg${serviceShort}'
    networkSecurityGroupBastionName: 'dep-${namePrefix}-nsg-bastion-${serviceShort}'
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
      name: '${namePrefix}${serviceShort}'
      managedIdentityConfiguration: {
        hubName: '${namePrefix}-id-hub-${serviceShort}'
        projectName: '${namePrefix}-id-project-${serviceShort}'
      }
      logAnalyticsConfiguration: {
        name: '${namePrefix}-log-${serviceShort}'
      }
      keyVaultConfiguration: {
        name: '${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
        enablePurgeProtection: false
      }
      storageAccountConfiguration: {
        name: '${namePrefix}st${serviceShort}'
        sku: 'Standard_GRS'
        allowSharedKeyAccess: true
      }
      containerRegistryConfiguration: {
        name: '${namePrefix}cr${serviceShort}'
        trustPolicyStatus: 'disabled'
      }
      applicationInsightsConfiguration: {
        name: '${namePrefix}-appi-${serviceShort}'
      }
      virtualNetworkConfiguration: {
        name: '${namePrefix}-vnet-${serviceShort}'
        addressPrefix: '10.1.0.0/16'
        enabled: true
        subnet: {
          name: '${namePrefix}-snet-${serviceShort}'
          addressPrefix: '10.1.0.0/24'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupResourceId
        }
      }
      bastionConfiguration: {
        enabled: true
        name: '${namePrefix}-bas-${serviceShort}'
        sku: 'Standard'
        networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupBastionResourceId
        subnetAddressPrefix: '10.1.1.0/26'
        disableCopyPaste: true
        enableFileCopy: true
        enableIpConnect: true
        enableKerberos: true
        enableShareableLink: true
        scaleUnits: 3
      }
      virtualMachineConfiguration: {
        enabled: true
        name: take('${namePrefix}-vm-${serviceShort}', 15)
        zone: 0
        size: 'Standard_DS1_v2'
        adminUsername: 'localAdminUser'
        adminPassword: password
        nicConfigurationConfiguration: {
          name: '${namePrefix}-nic-${serviceShort}'
          ipConfigName: '${namePrefix}-ipcfg-${serviceShort}'
          privateIPAllocationMethod: 'Dynamic'
          networkSecurityGroupResourceId: nestedDependencies.outputs.networkSecurityGroupResourceId
        }
        imageReference: {
          publisher: 'microsoft-dsvm'
          offer: 'dsvm-win-2022'
          sku: 'winserver-2022'
          version: 'latest'
        }
        osDisk: {
          name: '${namePrefix}-disk-${serviceShort}'
          diskSizeGB: 256
          createOption: 'FromImage'
          caching: 'ReadOnly'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
          deleteOption: 'Delete'
        }
        patchMode: 'AutomaticByPlatform'
        encryptionAtHost: false
        enableAadLoginExtension: true
        enableAzureMonitorAgent: true
        maintenanceConfigurationResourceId: nestedDependencies.outputs.maintenanceConfigurationResourceId
      }
      workspaceConfiguration: {
        name: '${namePrefix}-hub-${serviceShort}'
        projectName: '${namePrefix}-project-${serviceShort}'
        computes: [
          {
            computeType: 'ComputeInstance'
            name: 'c-${substring(uniqueString(baseTime), 0, 3)}-${serviceShort}'
            description: 'Default'
            location: resourceLocation
            properties: {
              vmSize: 'STANDARD_DS11_V2'
            }
            sku: 'Standard'
          }
        ]
        networkIsolationMode: 'AllowOnlyApprovedOutbound'
        networkOutboundRules: {
          rule1: {
            type: 'FQDN'
            destination: 'pypi.org'
            category: 'UserDefined'
          }
        }
      }
    }
  }
]
