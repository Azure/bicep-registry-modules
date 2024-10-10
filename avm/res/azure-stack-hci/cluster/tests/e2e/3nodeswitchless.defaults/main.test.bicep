targetScope = 'subscription'

metadata name = 'Deploy Azure Stack HCI Cluster in Azure with a 3 node switchless configuration'
metadata description = 'This test deploys an Azure VM to host a 3 node switchless Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.'

@description('Optional. The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.')
@maxLength(15)
@minLength(4)
param name string = 'hcicluster'
@description('Optional. Location for all resources.')
param location string = deployment().location
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-azure-stack-hci.cluster-${serviceShort}-rg'
@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ashc3nmin'
@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'
@minLength(4)
@maxLength(8)
@description('Optional. The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.')
param deploymentPrefix string = take('${take(namePrefix, 8)}${uniqueString(utcNow())}', 8)

@description('Optional. The password of the LCM deployment user and local administrator accounts.')
@secure()
param localAdminAndDeploymentUserPass string = newGuid()

@description('Required. The app ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentAppId string = ''
@description('Required. The service principal ID of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentSPObjectId string = ''

@description('Required. The secret of the service principal used for the Azure Stack HCI Resource Bridge deployment. If omitted, the deploying user must have permissions to create service principals and role assignments in Entra ID.')
@secure()
#disable-next-line secure-parameter-default
param arbDeploymentServicePrincipalSecret string = ''

@description('Optional. The service principal ID of the Azure Stack HCI Resource Provider. If this is not provided, the module attemps to determine this value by querying the Microsoft Graph.')
@secure()
#disable-next-line secure-parameter-default
param hciResourceProviderObjectId string = ''

#disable-next-line no-hardcoded-location // Due to quotas and capacity challenges, this region must be used in the AVM testing subscription
var enforcedLocation = 'southeastasia'

var clusterNodeNames = ['hcinode1', 'hcinode2', 'hcinode3']
var domainFqdn = 'hci.local'
var domainOUPath = 'OU=HCI,DC=hci,DC=local'
var subnetMask = '255.255.255.0'
var defaultGateway = '172.20.0.1'
var startingIPAddress = '172.20.0.2'
var endingIPAddress = '172.20.0.7'
var dnsServers = ['172.20.0.1']
var customLocationName = '${serviceShort}-location'
var enableStorageAutoIp = true
var clusterWitnessStorageAccountName = 'dep${namePrefix}${serviceShort}wit'
var keyVaultName = 'dep-${namePrefix}${serviceShort}kv'
var hciISODownloadURL = 'https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureStackHCI/OS-Composition/10.2408.0.3061/AZURESTACKHci23H2.25398.469.LCM.10.2408.0.3061.x64.en-us.iso'
var networkIntents = [
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

@description('Optional. The storage networks for the cluster.')
var storageNetworks = [
  {
    adapterName: 'smb0'
    vlan: '711'
    storageAdapterIPInfo: [
      {
        //switch A
        physicalNode: 'hcinode1'
        ipv4Address: '10.71.1.1'
        subnetMask: '255.255.255.0'
      }
      {
        //switch A
        physicalNode: 'hcinode2'
        ipv4Address: '10.71.1.2'
        subnetMask: '255.255.255.0'
      }
      {
        // switch B
        physicalNode: 'hcinode3'
        ipv4Address: '10.71.2.3'
        subnetMask: '255.255.255.0'
      }
    ]
  }
  {
    adapterName: 'smb1'
    vlan: '711'
    storageAdapterIPInfo: [
      {
        // switch B
        physicalNode: 'hcinode1'
        ipv4Address: '10.71.2.1'
        subnetMask: '255.255.255.0'
      }
      {
        // switch C
        physicalNode: 'hcinode2'
        ipv4Address: '10.71.3.2'
        subnetMask: '255.255.255.0'
      }
      {
        //switch C
        physicalNode: 'hcinode3'
        ipv4Address: '10.71.3.3'
        subnetMask: '255.255.255.0'
      }
    ]
  }
]

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module hciDependencies 'dependencies.bicep' = {
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-hcidependencies-${serviceShort}'
  scope: resourceGroup
  params: {
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    deploymentPrefix: deploymentPrefix
    deploymentUserPassword: localAdminAndDeploymentUserPass
    hciResourceProviderObjectId: hciResourceProviderObjectId
    localAdminPassword: localAdminAndDeploymentUserPass
    location: enforcedLocation
    arbDeploymentAppId: arbDeploymentAppId
    arbDeploymentSPObjectId: arbDeploymentSPObjectId
    arbDeploymentServicePrincipalSecret: arbDeploymentServicePrincipalSecret
    hciNodeCount: 3
    switchlessStorageConfig: true
    hciISODownloadURL: hciISODownloadURL
    namePrefix: namePrefix
    keyVaultName: keyVaultName
  }
}

module cluster_validate '../../../main.bicep' = {
  dependsOn: [
    hciDependencies
  ]
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clustervalidate-${serviceShort}'
  scope: resourceGroup
  params: {
    name: name
    customLocationName: customLocationName
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    defaultGateway: defaultGateway
    deploymentMode: 'Validate'
    deploymentPrefix: deploymentPrefix
    dnsServers: dnsServers
    domainFqdn: domainFqdn
    domainOUPath: domainOUPath
    endingIPAddress: endingIPAddress
    enableStorageAutoIp: enableStorageAutoIp
    keyVaultName: keyVaultName
    networkIntents: networkIntents
    startingIPAddress: startingIPAddress
    storageConnectivitySwitchless: true
    storageNetworks: storageNetworks
    subnetMask: subnetMask
  }
}

module testDeployment '../../../main.bicep' = {
  dependsOn: [
    hciDependencies
    cluster_validate
  ]
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-clusterdeploy-${serviceShort}'
  scope: resourceGroup
  params: {
    name: name
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    customLocationName: customLocationName
    defaultGateway: defaultGateway
    deploymentMode: 'Deploy'
    deploymentPrefix: deploymentPrefix
    dnsServers: dnsServers
    domainFqdn: domainFqdn
    domainOUPath: domainOUPath
    endingIPAddress: endingIPAddress
    enableStorageAutoIp: enableStorageAutoIp
    keyVaultName: keyVaultName
    networkIntents: networkIntents
    startingIPAddress: startingIPAddress
    storageConnectivitySwitchless: true
    storageNetworks: storageNetworks
    subnetMask: subnetMask
  }
}
