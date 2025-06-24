targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-hybridcontainerservice.provisionedclusterinstances-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'hcpciwaf'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The password of the LCM deployment user and local administrator accounts.')
@secure()
param arbLocalAdminAndDeploymentUserPass string = ''

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''

@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment.')
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

module nestedDependencies '../../../../../../../utilities/e2e-template-assets/module-specific/azure-stack-hci/dependencies/dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-nestedDependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterName: '${namePrefix}${serviceShort}01'
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
    virtualMachineName: 'dep-${namePrefix}-vm-${serviceShort}'
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    domainAdminPassword: arbLocalAdminAndDeploymentUserPass
    location: enforcedLocation
  }
}

module azlocal 'br/public:avm/res/azure-stack-hci/cluster:0.1.6' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustermodule-${serviceShort}'
  scope: resourceGroup
  params: {
    name: nestedDependencies.outputs.clusterName
    deploymentUser: 'deployUser'
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminUser: 'Administrator'
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    servicePrincipalId: arbDeploymentAppId
    servicePrincipalSecret: arbDeploymentServicePrincipalSecret
    hciResourceProviderObjectId: hciResourceProviderObjectId
    deploymentSettings: {
      customLocationName: '${namePrefix}${serviceShort}-location'
      clusterNodeNames: nestedDependencies.outputs.clusterNodeNames
      clusterWitnessStorageAccountName: nestedDependencies.outputs.clusterWitnessStorageAccountName
      defaultGateway: '192.168.1.1'
      deploymentPrefix: 'a${take(uniqueString(namePrefix, serviceShort), 7)}' // ensure deployment prefix starts with a letter to match '^(?=.{1,8}$)([a-zA-Z])(\-?[a-zA-Z\d])*$'
      dnsServers: ['192.168.1.254']
      domainFqdn: 'jumpstart.local'
      domainOUPath: nestedDependencies.outputs.domainOUPath
      startingIPAddress: '192.168.1.55'
      endingIPAddress: '192.168.1.65'
      enableStorageAutoIp: true
      keyVaultName: nestedDependencies.outputs.keyVaultName
      networkIntents: [
        {
          adapter: [
            'FABRIC'
            'FABRIC2'
          ]
          name: 'ManagementCompute'
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
          trafficType: [
            'Management'
            'Compute'
          ]
        }
        {
          adapter: [
            'StorageA'
            'StorageB'
          ]
          name: 'Storage'
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
          name: 'Storage1Network'
          adapterName: 'StorageA'
          vlan: '711'
        }
        {
          name: 'Storage2Network'
          adapterName: 'StorageB'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
    }
  }
}

resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-31-preview' existing = {
  name: '${namePrefix}${serviceShort}-location'
  scope: resourceGroup
  dependsOn: [
    azlocal
  ]
}

module azLocalInit '../init.bicep' = {
  name: '${deployment().name}-azLocalInit'
  scope: resourceGroup
  params: {
    customLocationResourceId: customLocation.id
  }
}

module logicalNetwork 'br/public:avm/res/azure-stack-hci/logical-network:0.1.1' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-logicalNetwork-${serviceShort}'
  scope: resourceGroup
  params: {
    name: '${namePrefix}${serviceShort}logicalnetwork'
    customLocationResourceId: customLocation.id
    vmSwitchName: azlocal.outputs.vSwitchName
    ipAllocationMethod: 'Static'
    addressPrefix: '192.168.1.0/24'
    startingAddress: '192.168.1.171'
    endingAddress: '192.168.1.190'
    defaultGateway: '192.168.1.1'
    dnsServers: ['192.168.1.254']
    routeName: 'default'
    vlanId: null
    tags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}

module testDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-aks-${serviceShort}'
  scope: resourceGroup
  dependsOn: [
    azLocalInit
  ]
  params: {
    name: '${namePrefix}${serviceShort}001'
    customLocationResourceId: customLocation.id
    keyVaultName: nestedDependencies.outputs.keyVaultName
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          logicalNetwork.outputs.resourceId
        ]
      }
    }
    controlPlane: {
      count: 1
      vmSize: 'Standard_A4_v2'
      controlPlaneEndpoint: {
        hostIP: null
      }
    }
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 2
        enableAutoScaling: false
        maxCount: 5
        minCount: 1
        maxPods: 110
        nodeLabels: {}
        nodeTaints: []
        osSKU: 'CBLMariner'
        osType: 'Linux'
        vmSize: 'Standard_A4_v2'
      }
    ]
    connectClustersTags: {
      'hidden-title': 'This is visible in the resource name'
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
  }
}
