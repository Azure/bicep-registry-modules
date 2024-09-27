metadata name = 'Azure Kubernetes Service (AKS) Managed Cluster Agent Pools'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Agent Pool.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param managedClusterName string

@description('Required. Name of the agent pool.')
param name string

@description('Optional. The list of Availability zones to use for nodes. This can only be specified if the AgentPoolType property is "VirtualMachineScaleSets".')
param availabilityZones array?

@description('Optional. Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1.')
@minValue(0)
@maxValue(1000)
param count int = 1

@description('Optional. This is the ARM ID of the source object to be used to create the target object.')
param sourceResourceId string?

@description('Optional. Whether to enable auto-scaler.')
param enableAutoScaling bool = false

@description('Optional. This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption. For security reasons, this setting should be enabled.')
param enableEncryptionAtHost bool = false

@description('Optional. See Add a FIPS-enabled node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details.')
param enableFIPS bool = false

@description('Optional. Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools).')
param enableNodePublicIP bool = false

@description('Optional. Whether to enable UltraSSD.')
param enableUltraSSD bool = false

@description('Optional. GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU.')
@allowed([
  'MIG1g'
  'MIG2g'
  'MIG3g'
  'MIG4g'
  'MIG7g'
])
param gpuInstanceProfile string?

@description('Optional. Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.')
param kubeletDiskType string?

@description('Optional. The maximum number of nodes for auto-scaling.')
param maxCount int?

@description('Optional. The maximum number of pods that can run on a node.')
param maxPods int?

@description('Optional. The minimum number of nodes for auto-scaling.')
param minCount int?

@description('Optional. A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools.')
param mode string?

@description('Optional. The node labels to be persisted across all nodes in agent pool.')
param nodeLabels object?

@description('Optional. ResourceId of the node PublicIPPrefix.')
param nodePublicIpPrefixId string?

@description('Optional. The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.')
param nodeTaints array?

@description('Optional. As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool).')
param orchestratorVersion string?

@description('Optional. OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.')
param osDiskSizeGB int?

@description('Optional. The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://learn.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os).')
@allowed([
  'Ephemeral'
  'Managed'
])
param osDiskType string?

@description('Optional. Specifies the OS SKU used by the agent pool. The default is Ubuntu if OSType is Linux. The default is Windows2019 when Kubernetes <= 1.24 or Windows2022 when Kubernetes >= 1.25 if OSType is Windows.')
@allowed([
  'AzureLinux'
  'CBLMariner'
  'Ubuntu'
  'Windows2019'
  'Windows2022'
])
param osSku string?

@description('Optional. The operating system type. The default is Linux.')
@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

@description('Optional. Subnet ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.')
param podSubnetId string?

@description('Optional. The ID for the Proximity Placement Group.')
param proximityPlacementGroupResourceId string?

@description('Optional. Describes how VMs are added to or removed from Agent Pools. See [billing states](https://learn.microsoft.com/en-us/azure/virtual-machines/states-billing).')
@allowed([
  'Deallocate'
  'Delete'
])
param scaleDownMode string = 'Delete'

@description('Optional. The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs.')
@allowed([
  'Deallocate'
  'Delete'
])
param scaleSetEvictionPolicy string = 'Delete'

@description('Optional. The Virtual Machine Scale Set priority.')
@allowed([
  'Regular'
  'Spot'
])
param scaleSetPriority string?

@description('Optional. Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing).')
param spotMaxPrice int?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The type of Agent Pool.')
param type string?

@description('Optional. This can either be set to an integer (e.g. "5") or a percentage (e.g. "50%"). If a percentage is specified, it is the percentage of the total agent pool size at the time of the upgrade. For percentages, fractional nodes are rounded up. If not specified, the default is 1. For more information, including best practices, see: /azure/aks/upgrade-cluster#customize-node-surge-upgrade.')
param maxSurge string?

@description('Optional. VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions.')
param vmSize string = 'Standard_D2s_v3'

@description('Optional. Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.')
param vnetSubnetId string?

@description('Optional. Determines the type of workload a node can run.')
param workloadRuntime string?

resource managedCluster 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' existing = {
  name: managedClusterName
}

resource agentPool 'Microsoft.ContainerService/managedClusters/agentPools@2023-07-02-preview' = {
  name: name
  parent: managedCluster
  properties: {
    availabilityZones: availabilityZones
    count: count
    creationData: !empty(sourceResourceId)
      ? {
          sourceResourceId: sourceResourceId
        }
      : null
    enableAutoScaling: enableAutoScaling
    enableEncryptionAtHost: enableEncryptionAtHost
    enableFIPS: enableFIPS
    enableNodePublicIP: enableNodePublicIP
    enableUltraSSD: enableUltraSSD
    gpuInstanceProfile: gpuInstanceProfile
    kubeletDiskType: kubeletDiskType
    maxCount: maxCount
    maxPods: maxPods
    minCount: minCount
    mode: mode
    nodeLabels: nodeLabels
    nodePublicIPPrefixID: nodePublicIpPrefixId
    nodeTaints: nodeTaints
    orchestratorVersion: orchestratorVersion
    osDiskSizeGB: osDiskSizeGB
    osDiskType: osDiskType
    osSKU: osSku
    osType: osType
    podSubnetID: podSubnetId
    proximityPlacementGroupID: proximityPlacementGroupResourceId
    scaleDownMode: scaleDownMode
    scaleSetEvictionPolicy: scaleSetEvictionPolicy
    scaleSetPriority: scaleSetPriority
    spotMaxPrice: spotMaxPrice
    tags: tags
    type: type
    upgradeSettings: {
      maxSurge: maxSurge
    }
    vmSize: vmSize
    vnetSubnetID: vnetSubnetId
    workloadRuntime: workloadRuntime
  }
}

@description('The name of the agent pool.')
output name string = agentPool.name

@description('The resource ID of the agent pool.')
output resourceId string = agentPool.id

@description('The resource group the agent pool was deployed into.')
output resourceGroupName string = resourceGroup().name
