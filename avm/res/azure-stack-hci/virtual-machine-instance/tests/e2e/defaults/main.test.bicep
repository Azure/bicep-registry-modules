targetScope = 'subscription'

metadata name = 'Using default config'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
// e.g., for a module 'network/private-endpoint' you could use 'dep-dev-network.privateendpoints-${serviceShort}-rg'
param resourceGroupName string = 'dep-${namePrefix}-azurestackhci.vmi-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
// e.g., for a module 'network/private-endpoint' you could use 'npe' as a prefix and then 'waf' as a suffix for the waf-aligned test
param serviceShort string = 'ashvmimin'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''

@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-param
param arbDeploymentSPObjectId string = ''

@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentServicePrincipalSecret string = ''

@description('Optional. The service principal ID of the Azure Stack HCI Resource Provider. If this is not provided, the module attemps to determine this value by querying the Microsoft Graph.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

@description('Optional. The password to use for the local and domain accounts in the test.')
param localAdminAndDeploymentUserPass string = newGuid()

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/dependencies/defaults-dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-nestedDependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterName: '${namePrefix}${serviceShort}001'
    clusterWitnessStorageAccountName: 'dep${namePrefix}wst${serviceShort}'
    keyVaultDiagnosticStorageAccountName: 'dep${namePrefix}st${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    userAssignedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    maintenanceConfigurationName: 'dep-${namePrefix}-mc-${serviceShort}'
    maintenanceConfigurationAssignmentName: 'dep-${namePrefix}-mca-${serviceShort}'
    HCIHostVirtualMachineScaleSetName: 'dep-${namePrefix}-hvmss-${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-${namePrefix}-nsg-${serviceShort}'
    networkInterfaceName: 'dep-${namePrefix}-mice-${serviceShort}'
    diskNamePrefix: 'dep-${namePrefix}-disk-${serviceShort}'
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    waitDeploymentScriptPrefixName: 'dep-${namePrefix}-wds-${serviceShort}'
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    deploymentUserPassword: localAdminAndDeploymentUserPass
    hciResourceProviderObjectId: hciResourceProviderObjectId
    localAdminPassword: localAdminAndDeploymentUserPass
    location: enforcedLocation
  }
}

module azlocal 'br/public:avm/res/azure-stack-hci/cluster:0.1.1' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
  scope: resourceGroup
  params: {
    name: nestedDependencies.outputs.clusterName
    deploymentUser: 'deployUser'
    deploymentUserPassword: localAdminAndDeploymentUserPass
    localAdminUser: 'admin-hci'
    localAdminPassword: localAdminAndDeploymentUserPass
    servicePrincipalId: arbDeploymentAppId
    servicePrincipalSecret: arbDeploymentServicePrincipalSecret
    deploymentSettings: {
      customLocationName: '${namePrefix}${serviceShort}-location'
      clusterNodeNames: nestedDependencies.outputs.clusterNodeNames
      clusterWitnessStorageAccountName: nestedDependencies.outputs.clusterWitnessStorageAccountName
      defaultGateway: '172.20.0.1'
      deploymentPrefix: 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'
      dnsServers: ['172.20.0.1']
      domainFqdn: 'hci.local'
      domainOUPath: nestedDependencies.outputs.domainOUPath
      startingIPAddress: '172.20.0.2'
      endingIPAddress: '172.20.0.7'
      enableStorageAutoIp: true
      keyVaultName: nestedDependencies.outputs.keyVaultName
      networkIntents: [
        {
          adapter: ['mgmt']
          name: 'management'
          overrideAdapterProperty: true
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          overrideQosPolicy: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          overrideVirtualSwitchConfiguration: false
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
          trafficType: ['Management']
        }
        {
          adapter: ['comp0', 'comp1']
          name: 'compute'
          overrideAdapterProperty: true
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          overrideQosPolicy: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          overrideVirtualSwitchConfiguration: false
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
          trafficType: ['Compute']
        }
        {
          adapter: ['smb0', 'smb1']
          name: 'storage'
          overrideAdapterProperty: true
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          overrideQosPolicy: true
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          overrideVirtualSwitchConfiguration: false
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
          trafficType: ['Storage']
        }
      ]
      storageConnectivitySwitchless: false
      storageNetworks: [
        {
          adapterName: 'smb0'
          vlan: '711'
        }
        {
          adapterName: 'smb1'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
    }
  }
}

resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-31-preview' existing = {
  scope: resourceGroup
  name: '${namePrefix}${serviceShort}-location'
  dependsOn: [
    azlocal
  ]
}

module hciImage 'dependencies.bicep' = {
  name: 'hciResourcesDeployment'
  scope: resourceGroup
  params: {
    resourceLocation: enforcedLocation
    customLocation: customLocation.id
  }
}

module hybridCompute 'br/public:avm/res/hybrid-compute/machine:0.1.0' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-hybridCompute-${serviceShort}'
  scope: resourceGroup
  params: {
    name: '${uniqueString(deployment().name, enforcedLocation)}-vm-${serviceShort}'
    location: enforcedLocation
    kind: 'HCI'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-vm-${serviceShort}'
  scope: resourceGroup
  params: {
    name: '${namePrefix}${serviceShort}vm'
    location: enforcedLocation
    customLocation: customLocation.id
    arcMachineResourceName: hybridCompute.outputs.name
    hardwareProfile: {
      memoryMB: 4096
      processors: 2
    }
    networkProfile: { networkInterfaces: [] }
    osProfile: {
      computerName: '${uniqueString(deployment().name, enforcedLocation)}-vm-${serviceShort}'
      linuxConfiguration: {}
      windowsConfiguration: {
        provisionVMAgent: true
        provisionVMConfigAgent: true
      }
      adminUsername: 'Administator'
      adminPassword: localAdminAndDeploymentUserPass
    }
    storageProfile: {
      imageReference: { id: hciImage.outputs.resourceId }
      osDisk: {
        osType: 'Windows'
      }
    }
  }
}
