@description('Required. Location of the reserved Azure Local environment.')
param location string

@description('Required. Environment ownership tags.')
param tags object

@description('Required. Name of the shared Azure Local cluster.')
param clusterName string

@description('Required. Name of the shared custom location.')
param customLocationName string

@description('Required. Name of the shared readiness network.')
param logicalNetworkName string

@description('Required. Registered environment generation, retained on reuse and replaced on explicit recreation.')
param generation string

@description('Required. Existing Azure Stack HCI resource-provider service principal object ID.')
param builtInServicePrincipalObjectId string

@description('Required. Password for the local administrator and cluster deployment user.')
@secure()
param arbLocalAdminAndDeploymentUserPass string

@description('Required. Existing resource-bridge service principal application ID.')
@secure()
param arbDeploymentAppId string

@description('Required. Existing resource-bridge service principal object ID.')
@secure()
param arbDeploymentSPObjectId string

@description('Required. Existing resource-bridge service principal secret.')
@secure()
param arbDeploymentServicePrincipalSecret string

@description('Required. Validated immutable host image-version resource ID.')
@secure()
param hciHostImageReferenceId string

var suffix = uniqueString(subscription().subscriptionId, resourceGroup().id, generation)

module dependencies 'dependencies/dependencies.bicep' = {
  name: 'foundation-dependencies'
  params: {
    location: location
    clusterName: clusterName
    clusterWitnessStorageAccountName: 'avmhciw${suffix}'
    keyVaultDiagnosticStorageAccountName: 'avmhcid${suffix}'
    keyVaultName: 'avm-hci-${suffix}'
    userAssignedIdentityName: 'id-avm-ci-azure-local-host'
    maintenanceConfigurationName: 'avm-ci-azure-local-host-maintenance'
    maintenanceConfigurationAssignmentName: 'avm-ci-azure-local-proxy-maintenance'
    HCIHostVirtualMachineScaleSetName: 'avm-ci-azure-local-host'
    virtualNetworkName: 'avm-ci-azure-local-host'
    networkSecurityGroupName: 'avm-ci-azure-local-host'
    networkInterfaceName: 'avm-ci-azure-local-host'
    virtualMachineName: 'avm-ci-azure-local-proxy'
    diskNamePrefix: 'avm-ci-azure-local'
    waitDeploymentScriptPrefixName: 'avm-ci-azure-local'
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    hciHostImageReferenceId: hciHostImageReferenceId
    assignSubscriptionContributor: false
  }
}

module cluster 'br/public:avm/res/azure-stack-hci/cluster:0.4.0' = {
  name: 'foundation-cluster'
  params: {
    name: dependencies.outputs.clusterName
    location: location
    tags: tags
    deploymentUser: 'deployUser'
    deploymentUserPassword: arbLocalAdminAndDeploymentUserPass
    localAdminUser: 'Administrator'
    localAdminPassword: arbLocalAdminAndDeploymentUserPass
    servicePrincipalId: arbDeploymentAppId
    servicePrincipalSecret: arbDeploymentServicePrincipalSecret
    hciResourceProviderObjectId: builtInServicePrincipalObjectId
    deploymentSettings: {
      customLocationName: customLocationName
      clusterNodeNames: dependencies.outputs.clusterNodeNames
      clusterWitnessStorageAccountName: dependencies.outputs.clusterWitnessStorageAccountName
      deploymentPrefix: 'a${take(suffix, 7)}'
      defaultGateway: '172.20.0.1'
      dnsServers: ['172.20.0.1']
      domainFqdn: 'hci.local'
      domainOUPath: dependencies.outputs.domainOUPath
      startingIPAddress: '172.20.0.55'
      endingIPAddress: '172.20.0.65'
      enableStorageAutoIp: true
      keyVaultName: dependencies.outputs.keyVaultName
      networkIntents: [
        {
          name: 'ManagementCompute'
          adapter: ['FABRIC', 'FABRIC2']
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
          trafficType: ['Management', 'Compute']
        }
        {
          name: 'Storage'
          adapter: ['StorageA', 'StorageB']
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

resource customLocation 'Microsoft.ExtendedLocation/customLocations@2021-08-15' existing = {
  name: customLocationName
  dependsOn: [
    cluster
  ]
}

module network 'br/public:avm/res/azure-stack-hci/logical-network:0.1.1' = {
  name: 'foundation-network'
  params: {
    name: logicalNetworkName
    location: location
    tags: tags
    customLocationResourceId: customLocation.id
    vmSwitchName: cluster.outputs.vSwitchName
    ipAllocationMethod: 'Static'
    addressPrefix: '172.20.0.0/24'
    startingAddress: '172.20.0.200'
    endingAddress: '172.20.0.219'
    defaultGateway: '172.20.0.1'
    dnsServers: ['172.20.0.1']
    routeName: 'default'
    vlanId: null
  }
}

@description('The shared dependency contract. Resources under test are not part of this deployment.')
output environment object = {
  clusterResourceId: cluster.outputs.resourceId
  customLocationResourceId: customLocation.id
  logicalNetworkResourceId: network.outputs.resourceId
  keyVaultName: dependencies.outputs.keyVaultName
  clusterNodeNames: dependencies.outputs.clusterNodeNames
  vSwitchName: cluster.outputs.vSwitchName
  imageVersionName: dependencies.outputs.imageVersionName
}
