metadata name = 'AKS Secure Baseline Deployment'
metadata description = 'Orchestrates the resource-group scoped resources used by the AKS secure baseline pattern.'

param clusterName string
param location string
param availabilityZones (1 | 2 | 3)[]
param systemPoolVmSku string
param minSystemNodeCount int
param nodeProvisioningMode ('Auto' | 'Manual')
param numberOfUserPools int
param nodePoolVmSku string
param nodePoolZones (1 | 2 | 3)[]
param minUserNodeCount int
param vnetAddressPrefix string[]
param subnetAddressPrefixipV4 string
param bastionSubnetAddressPrefix string
param serviceTag string
param networkSku ('Standard' | 'StandardV2')
param tenantID string
@secure()
param sshPublicKey string
param deployBastion bool
param localDNSMode ('Preferred' | 'Required' | 'Disabled')
param imageCleanerIntervalHours int
param maintenanceWindowStartTime string
param maintenanceWindowUTCOffset string
param istioRev string
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags
param enableTelemetry bool

var aksSubnetServiceEndpoints = tenantID == '33e01921-4d64-4f8c-a055-5bdaffd5e33d'
  ? [
      'Microsoft.AzureCosmosDB'
      'Microsoft.AzureActiveDirectory'
      'Microsoft.ContainerRegistry'
      'Microsoft.EventHub'
      'Microsoft.KeyVault'
      'Microsoft.ServiceBus'
      'Microsoft.Storage'
      'Microsoft.Web'
    ]
  : []

module clusterIdentity 'cluster-identity.bicep' = {
  name: '${uniqueString(deployment().name, location, clusterName)}-ClusterIdentity'
  params: {
    clusterName: clusterName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module networkFoundation 'network.bicep' = {
  name: '${uniqueString(deployment().name, location, clusterName)}-NetworkFoundation'
  params: {
    clusterName: clusterName
    location: location
    availabilityZones: availabilityZones
    virtualNetworkAddressPrefixes: vnetAddressPrefix
    aksSubnetAddressPrefix: subnetAddressPrefixipV4
    aksSubnetServiceEndpoints: aksSubnetServiceEndpoints
    deployBastion: deployBastion
    bastionSubnetAddressPrefix: bastionSubnetAddressPrefix
    serviceTag: serviceTag
    networkSku: networkSku
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module managedCluster 'managed-cluster.bicep' = {
  name: '${uniqueString(deployment().name, location, clusterName)}-ManagedCluster'
  params: {
    clusterName: clusterName
    location: location
    availabilityZones: availabilityZones
    systemPoolVmSku: systemPoolVmSku
    minSystemNodeCount: minSystemNodeCount
    nodeProvisioningMode: nodeProvisioningMode
    numberOfUserPools: numberOfUserPools
    nodePoolVmSku: nodePoolVmSku
    nodePoolZones: nodePoolZones
    minUserNodeCount: minUserNodeCount
    tenantID: tenantID
    sshPublicKey: sshPublicKey
    localDNSMode: localDNSMode
    imageCleanerIntervalHours: imageCleanerIntervalHours
    maintenanceWindowStartTime: maintenanceWindowStartTime
    maintenanceWindowUTCOffset: maintenanceWindowUTCOffset
    istioRev: istioRev
    clusterIdentityResourceId: clusterIdentity.outputs.resourceId
    clusterIdentityClientId: clusterIdentity.outputs.clientId
    clusterIdentityPrincipalId: clusterIdentity.outputs.principalId
    aksSubnetResourceId: networkFoundation.outputs.aksSubnetResourceId
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module bastionHost 'br/public:avm/res/network/bastion-host:0.8.2' = if (deployBastion) {
  name: '${uniqueString(deployment().name, location, clusterName)}-BastionHost'
  params: {
    name: 'bh-${clusterName}'
    location: location
    virtualNetworkResourceId: networkFoundation.outputs.virtualNetworkResourceId
    skuName: 'Basic'
    availabilityZones: availabilityZones
    publicIPAddressObject: {
      name: 'pip-bastion-${clusterName}'
      publicIPAllocationMethod: 'Static'
      skuName: 'Standard'
      tags: tags
    }
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

output aksClusterName string = managedCluster.outputs.name
output aksClusterResourceId string = managedCluster.outputs.resourceId
output aksControlPlaneFqdn string = managedCluster.outputs.controlPlaneFqdn
output aksOidcIssuerUrl string? = managedCluster.outputs.?oidcIssuerUrl
output clusterIdentityResourceId string = clusterIdentity.outputs.resourceId
output virtualNetworkResourceId string = networkFoundation.outputs.virtualNetworkResourceId
output aksSubnetResourceId string = networkFoundation.outputs.aksSubnetResourceId
output natGatewayResourceId string = networkFoundation.outputs.natGatewayResourceId
output ingressPublicIpPrefixResourceId string = networkFoundation.outputs.ingressPublicIpPrefixResourceId
output bastionHostResourceId string? = deployBastion ? bastionHost!.outputs.resourceId : null
