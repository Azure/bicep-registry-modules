# Azure Kubernetes Service (AKS) Managed Cluster Agent Pools `[Microsoft.ContainerService/managedClusters/agentPools]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Agent Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | [2024-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2024-08-01/managedClusters/agentPools) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the agent pool. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedClusterName`](#parameter-managedclustername) | string | The name of the parent managed cluster. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-availabilityzones) | array | The list of Availability zones to use for nodes. This can only be specified if the AgentPoolType property is "VirtualMachineScaleSets". |
| [`count`](#parameter-count) | int | Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1. |
| [`enableAutoScaling`](#parameter-enableautoscaling) | bool | Whether to enable auto-scaler. |
| [`enableEncryptionAtHost`](#parameter-enableencryptionathost) | bool | This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption. For security reasons, this setting should be enabled. |
| [`enableFIPS`](#parameter-enablefips) | bool | See Add a FIPS-enabled node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details. |
| [`enableNodePublicIP`](#parameter-enablenodepublicip) | bool | Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools). |
| [`enableUltraSSD`](#parameter-enableultrassd) | bool | Whether to enable UltraSSD. |
| [`gpuInstanceProfile`](#parameter-gpuinstanceprofile) | string | GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU. |
| [`kubeletDiskType`](#parameter-kubeletdisktype) | string | Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage. |
| [`maxCount`](#parameter-maxcount) | int | The maximum number of nodes for auto-scaling. |
| [`maxPods`](#parameter-maxpods) | int | The maximum number of pods that can run on a node. |
| [`maxSurge`](#parameter-maxsurge) | string | This can either be set to an integer (e.g. "5") or a percentage (e.g. "50%"). If a percentage is specified, it is the percentage of the total agent pool size at the time of the upgrade. For percentages, fractional nodes are rounded up. If not specified, the default is 1. For more information, including best practices, see: /azure/aks/upgrade-cluster#customize-node-surge-upgrade. |
| [`minCount`](#parameter-mincount) | int | The minimum number of nodes for auto-scaling. |
| [`mode`](#parameter-mode) | string | A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools. |
| [`nodeLabels`](#parameter-nodelabels) | object | The node labels to be persisted across all nodes in agent pool. |
| [`nodePublicIpPrefixResourceId`](#parameter-nodepublicipprefixresourceid) | string | ResourceId of the node PublicIPPrefix. |
| [`nodeTaints`](#parameter-nodetaints) | array | The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule. |
| [`orchestratorVersion`](#parameter-orchestratorversion) | string | As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool). |
| [`osDiskSizeGB`](#parameter-osdisksizegb) | int | OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified. |
| [`osDiskType`](#parameter-osdisktype) | string | The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://learn.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os). |
| [`osSKU`](#parameter-ossku) | string | Specifies the OS SKU used by the agent pool. The default is Ubuntu if OSType is Linux. The default is Windows2019 when Kubernetes <= 1.24 or Windows2022 when Kubernetes >= 1.25 if OSType is Windows. |
| [`osType`](#parameter-ostype) | string | The operating system type. The default is Linux. |
| [`podSubnetResourceId`](#parameter-podsubnetresourceid) | string | Subnet resource ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}. |
| [`proximityPlacementGroupResourceId`](#parameter-proximityplacementgroupresourceid) | string | The ID for the Proximity Placement Group. |
| [`scaleDownMode`](#parameter-scaledownmode) | string | Describes how VMs are added to or removed from Agent Pools. See [billing states](https://learn.microsoft.com/en-us/azure/virtual-machines/states-billing). |
| [`scaleSetEvictionPolicy`](#parameter-scalesetevictionpolicy) | string | The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs. |
| [`scaleSetPriority`](#parameter-scalesetpriority) | string | The Virtual Machine Scale Set priority. |
| [`sourceResourceId`](#parameter-sourceresourceid) | string | This is the ARM ID of the source object to be used to create the target object. |
| [`spotMaxPrice`](#parameter-spotmaxprice) | int | Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing). |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`type`](#parameter-type) | string | The type of Agent Pool. |
| [`vmSize`](#parameter-vmsize) | string | VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions. |
| [`vnetSubnetResourceId`](#parameter-vnetsubnetresourceid) | string | Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}. |
| [`workloadRuntime`](#parameter-workloadruntime) | string | Determines the type of workload a node can run. |

### Parameter: `name`

Name of the agent pool.

- Required: Yes
- Type: string

### Parameter: `managedClusterName`

The name of the parent managed cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `availabilityZones`

The list of Availability zones to use for nodes. This can only be specified if the AgentPoolType property is "VirtualMachineScaleSets".

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `count`

Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1.

- Required: No
- Type: int
- Default: `1`
- MinValue: 0
- MaxValue: 1000

### Parameter: `enableAutoScaling`

Whether to enable auto-scaler.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 0
- MaxValue: 1000

### Parameter: `enableEncryptionAtHost`

This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption. For security reasons, this setting should be enabled.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 0
- MaxValue: 1000

### Parameter: `enableFIPS`

See Add a FIPS-enabled node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 0
- MaxValue: 1000

### Parameter: `enableNodePublicIP`

Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools).

- Required: No
- Type: bool
- Default: `False`
- MinValue: 0
- MaxValue: 1000

### Parameter: `enableUltraSSD`

Whether to enable UltraSSD.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 0
- MaxValue: 1000

### Parameter: `gpuInstanceProfile`

GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'MIG1g'
    'MIG2g'
    'MIG3g'
    'MIG4g'
    'MIG7g'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `kubeletDiskType`

Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `maxCount`

The maximum number of nodes for auto-scaling.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1000

### Parameter: `maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1000

### Parameter: `maxSurge`

This can either be set to an integer (e.g. "5") or a percentage (e.g. "50%"). If a percentage is specified, it is the percentage of the total agent pool size at the time of the upgrade. For percentages, fractional nodes are rounded up. If not specified, the default is 1. For more information, including best practices, see: /azure/aks/upgrade-cluster#customize-node-surge-upgrade.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `minCount`

The minimum number of nodes for auto-scaling.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1000

### Parameter: `mode`

A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `nodeLabels`

The node labels to be persisted across all nodes in agent pool.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 1000

### Parameter: `nodePublicIpPrefixResourceId`

ResourceId of the node PublicIPPrefix.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `nodeTaints`

The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.

- Required: No
- Type: array
- MinValue: 0
- MaxValue: 1000

### Parameter: `orchestratorVersion`

As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool).

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `osDiskSizeGB`

OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1000

### Parameter: `osDiskType`

The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://learn.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Ephemeral'
    'Managed'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `osSKU`

Specifies the OS SKU used by the agent pool. The default is Ubuntu if OSType is Linux. The default is Windows2019 when Kubernetes <= 1.24 or Windows2022 when Kubernetes >= 1.25 if OSType is Windows.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureLinux'
    'CBLMariner'
    'Ubuntu'
    'Windows2019'
    'Windows2022'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `osType`

The operating system type. The default is Linux.

- Required: No
- Type: string
- Default: `'Linux'`
- Allowed:
  ```Bicep
  [
    'Linux'
    'Windows'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `podSubnetResourceId`

Subnet resource ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `proximityPlacementGroupResourceId`

The ID for the Proximity Placement Group.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `scaleDownMode`

Describes how VMs are added to or removed from Agent Pools. See [billing states](https://learn.microsoft.com/en-us/azure/virtual-machines/states-billing).

- Required: No
- Type: string
- Default: `'Delete'`
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `scaleSetEvictionPolicy`

The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs.

- Required: No
- Type: string
- Default: `'Delete'`
- Allowed:
  ```Bicep
  [
    'Deallocate'
    'Delete'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `scaleSetPriority`

The Virtual Machine Scale Set priority.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Regular'
    'Spot'
  ]
  ```
- MinValue: 0
- MaxValue: 1000

### Parameter: `sourceResourceId`

This is the ARM ID of the source object to be used to create the target object.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `spotMaxPrice`

Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing).

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 1000

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- MinValue: 0
- MaxValue: 1000

### Parameter: `type`

The type of Agent Pool.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `vmSize`

VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions.

- Required: No
- Type: string
- Default: `'Standard_D2s_v3'`
- MinValue: 0
- MaxValue: 1000

### Parameter: `vnetSubnetResourceId`

Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

### Parameter: `workloadRuntime`

Determines the type of workload a node can run.

- Required: No
- Type: string
- MinValue: 0
- MaxValue: 1000

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the agent pool. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
| `resourceId` | string | The resource ID of the agent pool. |
