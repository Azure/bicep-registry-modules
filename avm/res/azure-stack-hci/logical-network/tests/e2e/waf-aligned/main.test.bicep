targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azurestackhci.logicalnetwork-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashlnwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminAndDeploymentUserPass string = newGuid()

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''

@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. The service principal must have Contributor role assigned.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''

@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentServicePrincipalSecret string = ''

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the \'Microsoft.AzureStackHCI\' provider was registered in the subscription.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/dependencies/waf-dependencies.bicep' = {
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
    localAdminPassword: localAdminAndDeploymentUserPass
    location: enforcedLocation
  }
}

module azlocal 'br/public:avm/res/azure-stack-hci/cluster:0.1.6' = {
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
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
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
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
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
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
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
          name: 'StorageNetwork0'
          adapterName: 'smb0'
          vlan: '711'
        }
        {
          name: 'StorageNetwork1'
          adapterName: 'smb1'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
      driftControlEnforced: true
      smbSigningEnforced: true
      smbClusterEncryption: true
      sideChannelMitigationEnforced: true
      bitlockerBootVolume: true
      bitlockerDataVolumes: true
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    hciResourceProviderObjectId: hciResourceProviderObjectId
  }
}

resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-31-preview' existing = {
  scope: resourceGroup
  name: '${namePrefix}${serviceShort}-location'
  dependsOn: [
    azlocal
  ]
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-logicalNetwork-${serviceShort}'
  scope: resourceGroup
  params: {
    name: '${namePrefix}${serviceShort}logicalnetwork'
    customLocationResourceId: customLocation.id
    vmSwitchName: azlocal.outputs.vSwitchName
    ipAllocationMethod: 'Static'
    addressPrefix: '172.20.0.1/24'
    startingAddress: '172.20.0.171'
    endingAddress: '172.20.0.190'
    defaultGateway: '172.20.0.1'
    dnsServers: ['172.20.0.1']
    routeName: 'default'
    vlanId: null
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
