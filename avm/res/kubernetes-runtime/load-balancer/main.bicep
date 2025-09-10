metadata name = 'Kubernetes Runtime Load Balancers'
metadata description = 'This module deploys a Kubernetes Runtime Load Balancer for MetalLB and related networking services.'

@description('Required. The name of the load balancer.')
@minLength(3)
@maxLength(24)
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The name of the AKS cluster or Arc-enabled connected cluster that should be configured.')
param clusterName string

@allowed([
  'managedCluster'
  'connectedCluster'
])
@description('Optional. The type of cluster to configure. Choose between AKS managed cluster or Arc-enabled connected cluster.')
param clusterType string = 'managedCluster'

@description('Required. IP Range - The IP addresses that this load balancer will advertise.')
param addresses resourceInput<'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01'>.properties.addresses

@description('Required. Advertise Mode - The mode in which the load balancer should advertise the IP addresses.')
@allowed([
  'ARP'
  'BGP'
  'Both'
])
param advertiseMode resourceInput<'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01'>.properties.advertiseMode

@description('Optional. The list of BGP peers it should advertise to. Null or empty means to advertise to all peers.')
param bgpPeers resourceInput<'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01'>.properties.bgpPeers?

@description('Optional. A dynamic label mapping to select related services. For instance, if you want to create a load balancer only for services with label "a=b", then please specify {"a": "b"} in the field.')
param serviceSelector resourceInput<'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01'>.properties.serviceSelector?

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.kubernetesruntime-loadbalancer.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

// Reference existing AKS managed cluster
resource managedCluster 'Microsoft.ContainerService/managedClusters@2025-05-01' existing = if (clusterType == 'managedCluster') {
  name: clusterName
}

// Reference existing Arc-enabled connected cluster
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = if (clusterType == 'connectedCluster') {
  name: clusterName
}

// Load Balancer resource for managed cluster (AKS)
resource loadBalancerManagedCluster 'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01' = if (clusterType == 'managedCluster') {
  scope: managedCluster
  name: name
  properties: {
    addresses: addresses
    advertiseMode: advertiseMode
    bgpPeers: bgpPeers
    serviceSelector: serviceSelector
  }
}

// Load Balancer resource for connected cluster (Arc-enabled)
resource loadBalancerConnectedCluster 'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01' = if (clusterType == 'connectedCluster') {
  scope: connectedCluster
  name: name
  properties: {
    addresses: addresses
    advertiseMode: advertiseMode
    bgpPeers: bgpPeers
    serviceSelector: serviceSelector
  }
}

@description('The resource ID of the load balancer.')
output resourceId string = clusterType == 'managedCluster'
  ? loadBalancerManagedCluster.id
  : loadBalancerConnectedCluster.id

@description('The name of the load balancer.')
output name string = name

@description('The resource group the load balancer was deployed into.')
output resourceGroupName string = resourceGroup().name
