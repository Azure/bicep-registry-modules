metadata name = 'Azd AKS'
metadata description = '''Creates an Azure Kubernetes Service (AKS) cluster with a system agent pool as well as an additional user agent pool.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param name string

@description('Required. Name of your Azure Container Registry.')
@minLength(5)
@maxLength(50)
param containerRegistryName string

@description('Required. The name of the connected log analytics workspace.')
param logAnalyticsName string

@description('Required. Name of the Key Vault. Must be globally unique.')
@maxLength(24)
param keyVaultName string

@description('Optional. Specifies the location of AKS cluster. It picks up Resource Group\'s location by default.')
param location string = resourceGroup().location

@description('Optional. Custom tags to apply to the AKS resources.')
param tags object = {}

@description('Optional. Network plugin used for building the Kubernetes network.')
@allowed(['azure', 'kubenet'])
param networkPlugin string = 'azure'

@description('Optional. Specifies the network policy used for building Kubernetes network. - calico or azure.')
@allowed(['azure', 'calico'])
param networkPolicy string = 'azure'

@description('Optional. Specifies the DNS prefix specified when creating the managed cluster.')
param dnsPrefix string = name

@description('Optional. The name of the resource group for the managed resources of the AKS cluster.')
param nodeResourceGroupName string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Id of the user or app to assign application roles.')
param principalId string

@description('Optional. The type of principal to assign application roles.')
@allowed(['Device', 'ForeignGroup', 'Group', 'ServicePrincipal', 'User'])
param principalType string = 'User'

@description('Optional. Kubernetes Version.')
param kubernetesVersion string = '1.29'

@description('Optional. Tier of a managed cluster SKU.')
@allowed([
  'Free'
  'Premium'
  'Standard'
])
param skuTier string = 'Standard'

@description('Optional. Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.')
@allowed([
  'azure'
  'cilium'
])
param networkDataplane string?

@description('Optional. Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.')
@allowed([
  'overlay'
])
param networkPluginMode string?

@description('Optional. Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.')
param podCidr string?

@description('Optional. A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.')
param serviceCidr string?

@description('Optional. Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.')
param dnsServiceIP string?

@description('Optional. Specifies the SSH RSA public key string for the Linux nodes.')
param sshPublicKey string?

@description('Optional. Specifies whether to enable Azure RBAC for Kubernetes authorization.')
param aadProfileEnableAzureRBAC bool = false

@description('Conditional. Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.')
param appGatewayResourceId string?

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceResourceId string?

@description('Optional. Define one or more secondary/additional agent pools.')
param agentPools agentPoolType

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the \'acrSku\' to be \'Premium\'.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Scope maps setting.')
param scopeMaps scopeMapsType

@description('Optional. Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.')
param webApplicationRoutingEnabled bool?

@description('Optional. Tier of your Azure container registry.')
@allowed([
  'Basic'
  'Premium'
  'Standard'
])
param acrSku string = 'Standard'

@description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
param containerRegistryRoleName string?

@description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
param aksClusterRoleAssignmentName string?

var aksClusterAdminRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
)

var acrPullRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)

var nodePoolPresets = {
  vmSize: 'Standard_DS2_v2'
  count: 3
  minCount: 3
  maxCount: 5
  enableAutoScaling: true
  availabilityZones: [
    '1'
    '2'
    '3'
  ]
}

var nodePoolBase = {
  osType: 'Linux'
  maxPods: 30
  type: 'VirtualMachineScaleSets'
  upgradeSettings: {
    maxSurge: '33%'
  }
}

var primaryAgentPoolProfile = [
  union({ name: 'npsystem', mode: 'System' }, nodePoolBase, nodePoolPresets)
]

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-aks.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' existing = if (!empty(logAnalyticsName)) {
  name: logAnalyticsName
}

module managedCluster 'br/public:avm/res/container-service/managed-cluster:0.3.0' = {
  name: '${uniqueString(deployment().name, location)}-managed-cluster'
  params: {
    name: name
    location: location
    tags: tags
    nodeResourceGroup: nodeResourceGroupName
    networkDataplane: networkDataplane
    networkPlugin: networkPlugin
    networkPluginMode: networkPluginMode
    networkPolicy: networkPolicy
    podCidr: podCidr
    serviceCidr: serviceCidr
    dnsServiceIP: dnsServiceIP
    kubernetesVersion: kubernetesVersion
    sshPublicKey: sshPublicKey
    aadProfileEnableAzureRBAC: aadProfileEnableAzureRBAC
    skuTier: skuTier
    appGatewayResourceId: appGatewayResourceId
    monitoringWorkspaceId: monitoringWorkspaceResourceId
    managedIdentities: {
      systemAssigned: true
    }
    diagnosticSettings: [
      {
        logCategoriesAndGroups: [
          {
            category: 'cluster-autoscaler'
            enabled: true
          }
          {
            category: 'kube-controller-manager'
            enabled: true
          }
          {
            category: 'kube-audit-admin'
            enabled: true
          }
          {
            category: 'guard'
            enabled: true
          }
        ]
        workspaceResourceId: !empty(logAnalyticsName) ? logAnalytics.id : ''
        metricCategories: [
          {
            category: 'AllMetrics'
            enabled: true
          }
        ]
      }
    ]
    webApplicationRoutingEnabled: webApplicationRoutingEnabled
    primaryAgentPoolProfile: primaryAgentPoolProfile
    dnsPrefix: dnsPrefix
    agentPools: agentPools
    enableTelemetry: enableTelemetry
    roleAssignments: [
      {
        name: aksClusterRoleAssignmentName
        principalId: principalId
        principalType: principalType
        roleDefinitionIdOrName: aksClusterAdminRole
      }
    ]
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.5.1' = {
  name: '${uniqueString(deployment().name, location)}-container-registry'
  params: {
    name: containerRegistryName
    location: location
    tags: tags
    publicNetworkAccess: publicNetworkAccess
    scopeMaps: scopeMaps
    acrSku: acrSku
    enableTelemetry: enableTelemetry
    diagnosticSettings: [
      {
        logCategoriesAndGroups: [
          {
            category: 'ContainerRegistryRepositoryEvents'
            enabled: true
          }
          {
            category: 'ContainerRegistryLoginEvents'
            enabled: true
          }
        ]
        workspaceResourceId: !empty(logAnalyticsName) ? logAnalytics.id : ''
        metricCategories: [
          {
            category: 'AllMetrics'
            enabled: true
          }
        ]
      }
    ]
    roleAssignments: [
      {
        name: containerRegistryRoleName
        principalId: managedCluster.outputs.kubeletIdentityObjectId
        roleDefinitionIdOrName: acrPullRole
      }
    ]
  }
}

module keyVault 'br/public:avm/res/key-vault/vault:0.9.0' = {
  name: '${uniqueString(deployment().name, location)}-key-vault'
  params: {
    name: keyVaultName
    enableTelemetry: enableTelemetry
    accessPolicies: [
      {
        objectId: managedCluster.outputs.kubeletIdentityObjectId
        permissions: {
          secrets: ['get', 'list']
        }
      }
    ]
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the application insights components were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource name of the AKS cluster.')
output managedClusterName string = managedCluster.outputs.name

@description('The Client ID of the AKS identity.')
output managedClusterClientId string = managedCluster.outputs.kubeletIdentityClientId

@description('The Object ID of the AKS identity.')
output managedClusterObjectId string = managedCluster.outputs.kubeletIdentityObjectId

@description('The resource ID of the AKS cluster.')
output managedClusterResourceId string = managedCluster.outputs.kubeletIdentityResourceId

@description('The resource name of the ACR.')
output containerRegistryName string = containerRegistry.outputs.name

@description('The login server for the container registry.')
output containerRegistryLoginServer string = containerRegistry.outputs.loginServer

// =============== //
//   Definitions   //
// =============== //

type agentPoolType = {
  @description('Required. The name of the agent pool.')
  name: string

  @description('Optional. The availability zones of the agent pool.')
  availabilityZones: string[]?

  @description('Optional. The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).')
  count: int?

  @description('Optional. The source resource ID to create the agent pool from.')
  sourceResourceId: string?

  @description('Optional. Whether to enable auto-scaling for the agent pool.')
  enableAutoScaling: bool?

  @description('Optional. Whether to enable encryption at host for the agent pool.')
  enableEncryptionAtHost: bool?

  @description('Optional. Whether to enable FIPS for the agent pool.')
  enableFIPS: bool?

  @description('Optional. Whether to enable node public IP for the agent pool.')
  enableNodePublicIP: bool?

  @description('Optional. Whether to enable Ultra SSD for the agent pool.')
  enableUltraSSD: bool?

  @description('Optional. The GPU instance profile of the agent pool.')
  gpuInstanceProfile: ('MIG1g' | 'MIG2g' | 'MIG3g' | 'MIG4g' | 'MIG7g')?

  @description('Optional. The kubelet disk type of the agent pool.')
  kubeletDiskType: string?

  @description('Optional. The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).')
  maxCount: int?

  @description('Optional. The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).')
  minCount: int?

  @description('Optional. The maximum number of pods that can run on a node.')
  maxPods: int?

  @description('Optional. The minimum number of pods that can run on a node.')
  minPods: int?

  @description('Optional. The mode of the agent pool.')
  mode: ('System' | 'User')?

  @description('Optional. The node labels of the agent pool.')
  nodeLabels: object?

  @description('Optional. The node public IP prefix ID of the agent pool.')
  nodePublicIpPrefixId: string?

  @description('Optional. The node taints of the agent pool.')
  nodeTaints: string[]?

  @description('Optional. The Kubernetes version of the agent pool.')
  orchestratorVersion: string?

  @description('Optional. The OS disk size in GB of the agent pool.')
  osDiskSizeGB: int?

  @description('Optional. The OS disk type of the agent pool.')
  osDiskType: string?

  @description('Optional. The OS SKU of the agent pool.')
  osSku: string?

  @description('Optional. The OS type of the agent pool.')
  osType: ('Linux' | 'Windows')?

  @description('Optional. The pod subnet ID of the agent pool.')
  podSubnetId: string?

  @description('Optional. The proximity placement group resource ID of the agent pool.')
  proximityPlacementGroupResourceId: string?

  @description('Optional. The scale down mode of the agent pool.')
  scaleDownMode: ('Delete' | 'Deallocate')?

  @description('Optional. The scale set eviction policy of the agent pool.')
  scaleSetEvictionPolicy: ('Delete' | 'Deallocate')?

  @description('Optional. The scale set priority of the agent pool.')
  scaleSetPriority: ('Low' | 'Regular' | 'Spot')?

  @description('Optional. The spot max price of the agent pool.')
  spotMaxPrice: int?

  @description('Optional. The tags of the agent pool.')
  tags: object?

  @description('Optional. The type of the agent pool.')
  type: ('AvailabilitySet' | 'VirtualMachineScaleSets')?

  @description('Optional. The maximum number of nodes that can be created during an upgrade.')
  maxSurge: string?

  @description('Optional. The VM size of the agent pool.')
  vmSize: string?

  @description('Optional. The VNet subnet ID of the agent pool.')
  vnetSubnetID: string?

  @description('Optional. The workload runtime of the agent pool.')
  workloadRuntime: string?

  @description('Optional. The enable default telemetry of the agent pool.')
  enableDefaultTelemetry: bool?
}[]?

type scopeMapsType = {
  @description('Optional. The name of the scope map.')
  name: string?

  @description('Required. The list of scoped permissions for registry artifacts.')
  actions: string[]

  @description('Optional. The user friendly description of the scope map.')
  description: string?
}[]?
