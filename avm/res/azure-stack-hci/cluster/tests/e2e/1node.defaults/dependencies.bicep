param customLocationName string
param keyVaultName string
param clusterWitnessStorageAccountName string

var domainOUPath = 'OU=HCI,DC=hci,DC=local'
var domainFqdn = 'hci.local'
var subnetMask = '255.255.255.0'
var defaultGateway = '192.168.1.1'
var dnsServers = ['192.168.1.254']
var startingIPAddress = '192.168.1.55'
var endingIPAddress = '192.168.1.65'
var enableStorageAutoIp = true

var clusterNodeNames = ['AzSHOST1', 'AzSHOST2']

var networkIntents = [
  {
    adapter: ['FABRIC']
    name: 'ManagementCompute'
    overrideAdapterProperty: true
    adapterPropertyOverrides: {
      jumboPacket: ''
      networkDirect: 'Disabled'
      networkDirectTechnology: ''
    }
    overrideQosPolicy: false
    qosPolicyOverrides: {
      bandwidthPercentage_SMB: ''
      priorityValue8021Action_Cluster: ''
      priorityValue8021Action_SMB: ''
    }
    overrideVirtualSwitchConfiguration: false
    virtualSwitchConfigurationOverrides: {
      enableIov: ''
      loadBalancingAlgorithm: ''
    }
    trafficType: ['Compute']
  }
  {
    adapter: ['StorageA', 'StorageB']
    name: 'Storage'
    overrideAdapterProperty: true
    adapterPropertyOverrides: {
      jumboPacket: ''
      networkDirect: 'Disabled'
      networkDirectTechnology: ''
    }
    overrideQosPolicy: false
    qosPolicyOverrides: {
      bandwidthPercentage_SMB: ''
      priorityValue8021Action_Cluster: ''
      priorityValue8021Action_SMB: ''
    }
    overrideVirtualSwitchConfiguration: false
    virtualSwitchConfigurationOverrides: {
      enableIov: ''
      loadBalancingAlgorithm: ''
    }
    trafficType: ['Storage']
  }
]

var storageNetworks = [
  {
    adapterName: 'StorageA'
    vlan: '711'
  }
  {
    adapterName: 'StorageB'
    vlan: '712'
  }
]

output customLocationName string = customLocationName
output keyVaultName string = keyVaultName
output clusterWitnessStorageAccountName string = clusterWitnessStorageAccountName

output domainOUPath string = domainOUPath
output domainFqdn string = domainFqdn
output subnetMask string = subnetMask
output defaultGateway string = defaultGateway
output dnsServers array = dnsServers
output startingIPAddress string = startingIPAddress
output endingIPAddress string = endingIPAddress
output enableStorageAutoIp bool = enableStorageAutoIp

output clusterNodeNames array = clusterNodeNames

// output hciClusterPreqs object = hciClusterPreqs
output networkIntents array = networkIntents
output storageNetworks array = storageNetworks
