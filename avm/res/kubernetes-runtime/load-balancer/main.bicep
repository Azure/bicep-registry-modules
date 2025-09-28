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

@description('Required. IP Range - The IP addresses that this load balancer will advertise.')
param addresses string[]

@description('Required. Advertise Mode - The mode in which the load balancer should advertise the IP addresses.')
@allowed([
  'ARP'
  'BGP'
  'Both'
])
param advertiseMode string

@description('Optional. The list of BGP peers it should advertise to. Null or empty means to advertise to all peers.')
param bgpPeers string[]?

@description('Optional. A dynamic label mapping to select related services. For instance, if you want to create a load balancer only for services with label "a=b", then please specify {"a": "b"} in the field.')
param serviceSelector {
  @description('Optional. Any additional property for service selector.')
  *: string
}?

@description('Required. The service principal object ID of the Kubernetes Runtime HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 087fca6e-4606-4d41-b3f6-5ebdf75b8b4c`.')
param kubernetesRuntimeRPObjectId string

var enableReferencedModulesTelemetry = false

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

module arcnetworking 'br/public:avm/res/kubernetes-configuration/extension:0.3.7' = {
  name: '${uniqueString(deployment().name, clusterName)}-arcnetworking'
  params: {
    name: 'arcnetworking'
    clusterName: clusterName
    clusterType: 'connectedCluster'
    extensionType: 'microsoft.arcnetworking'
    releaseNamespace: 'kube-system'
    configurationSettings: {
      k8sRuntimeFpaObjectId: kubernetesRuntimeRPObjectId
    }
    releaseTrain: 'Stable'
    enableTelemetry: enableReferencedModulesTelemetry
  }
}

// Reference existing Arc-enabled connected cluster
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-01-01' existing = {
  name: clusterName
}

// Load Balancer resource for connected cluster (Arc-enabled)
resource loadBalancerConnectedCluster 'Microsoft.KubernetesRuntime/loadBalancers@2024-03-01' = {
  scope: connectedCluster
  name: name
  properties: {
    addresses: addresses
    advertiseMode: advertiseMode
    bgpPeers: bgpPeers
    serviceSelector: serviceSelector
  }
  dependsOn: [
    arcnetworking
  ]
}

@description('The resource ID of the load balancer.')
output resourceId string = loadBalancerConnectedCluster.id

@description('The name of the load balancer.')
output name string = name

@description('The resource group the load balancer was deployed into.')
output resourceGroupName string = resourceGroup().name
