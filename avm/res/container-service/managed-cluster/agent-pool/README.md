# Azure Kubernetes Service (AKS) Managed Cluster Agent Pools `[Microsoft.ContainerService/managedClusters/agentPools]`

This module deploys an Azure Kubernetes Service (AKS) Managed Cluster Agent Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ContainerService/managedClusters/agentPools` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerservice_managedclusters_agentpools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerService/2025-09-01/managedClusters/agentPools)</li></ul> |

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
| [`capacityReservationGroupResourceId`](#parameter-capacityreservationgroupresourceid) | string | AKS will associate the specified agent pool with the Capacity Reservation Group. |
| [`count`](#parameter-count) | int | Desired Number of agents (VMs) specified to host docker containers. Allowed values must be in the range of 0 to 1000 (inclusive) for user pools and in the range of 1 to 1000 (inclusive) for system pools. The default value is 1. |
| [`enableAutoScaling`](#parameter-enableautoscaling) | bool | Whether to enable auto-scaler. |
| [`enableEncryptionAtHost`](#parameter-enableencryptionathost) | bool | This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption. For security reasons, this setting should be enabled. |
| [`enableFIPS`](#parameter-enablefips) | bool | See Add a FIPS-enabled node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details. |
| [`enableNodePublicIP`](#parameter-enablenodepublicip) | bool | Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools). |
| [`enableUltraSSD`](#parameter-enableultrassd) | bool | Whether to enable UltraSSD. |
| [`gatewayProfile`](#parameter-gatewayprofile) | object | Profile specific to a managed agent pool in Gateway mode. Ignored if agent pool mode is not Gateway. |
| [`gpuInstanceProfile`](#parameter-gpuinstanceprofile) | string | GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU. |
| [`gpuProfile`](#parameter-gpuprofile) | object | GPU settings. |
| [`hostGroupResourceId`](#parameter-hostgroupresourceid) | string | This is of the form /subscriptions/{subscriptionId}/resourcegroups/{resourcegroupname}/providers/microsoft.compute/hostgroups/{hostgroupname}. For more information see [Azure Dedicated Hosts](https://learn.microsoft.com/azure/virtual-machines/dedicated-hosts). |
| [`kubeletConfig`](#parameter-kubeletconfig) | object | Kubelet configuration on agent pool nodes. |
| [`kubeletDiskType`](#parameter-kubeletdisktype) | string | Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage. |
| [`linuxOSConfig`](#parameter-linuxosconfig) | object | Linux OS configuration. |
| [`localDNSProfile`](#parameter-localdnsprofile) | object | Local DNS configuration. |
| [`maxCount`](#parameter-maxcount) | int | The maximum number of nodes for auto-scaling. |
| [`maxPods`](#parameter-maxpods) | int | The maximum number of pods that can run on a node. |
| [`messageOfTheDay`](#parameter-messageoftheday) | string | A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message. You can use escape characters like \n for new line. |
| [`minCount`](#parameter-mincount) | int | The minimum number of nodes for auto-scaling. |
| [`mode`](#parameter-mode) | string | A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools. |
| [`networkProfile`](#parameter-networkprofile) | object | Network profile to be used for agent pool nodes. |
| [`nodeLabels`](#parameter-nodelabels) | object | The node labels to be persisted across all nodes in agent pool. |
| [`nodePublicIpPrefixResourceId`](#parameter-nodepublicipprefixresourceid) | string | ResourceId of the node PublicIPPrefix. |
| [`nodeTaints`](#parameter-nodetaints) | array | The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule. |
| [`orchestratorVersion`](#parameter-orchestratorversion) | string | As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool). |
| [`osDiskSizeGB`](#parameter-osdisksizegb) | int | OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified. |
| [`osDiskType`](#parameter-osdisktype) | string | The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://learn.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os). |
| [`osSKU`](#parameter-ossku) | string | Specifies the OS SKU used by the agent pool. The default is Ubuntu if OSType is Linux. The default is Windows2019 when Kubernetes <= 1.24 or Windows2022 when Kubernetes >= 1.25 if OSType is Windows. |
| [`osType`](#parameter-ostype) | string | The operating system type. The default is Linux. |
| [`podIPAllocationMode`](#parameter-podipallocationmode) | string | Pod IP allocation mode. |
| [`podSubnetResourceId`](#parameter-podsubnetresourceid) | string | Subnet resource ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}. |
| [`powerState`](#parameter-powerstate) | object | Power State of the agent pool. |
| [`proximityPlacementGroupResourceId`](#parameter-proximityplacementgroupresourceid) | string | The ID for the Proximity Placement Group. |
| [`scaleDownMode`](#parameter-scaledownmode) | string | Describes how VMs are added to or removed from Agent Pools. See [billing states](https://learn.microsoft.com/en-us/azure/virtual-machines/states-billing). |
| [`scaleSetEvictionPolicy`](#parameter-scalesetevictionpolicy) | string | The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs. |
| [`scaleSetPriority`](#parameter-scalesetpriority) | string | The Virtual Machine Scale Set priority. |
| [`securityProfile`](#parameter-securityprofile) | object | The security settings of an agent pool. |
| [`sourceResourceId`](#parameter-sourceresourceid) | string | This is the ARM ID of the source object to be used to create the target object. |
| [`spotMaxPrice`](#parameter-spotmaxprice) | int | Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing). |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`type`](#parameter-type) | string | The type of Agent Pool. |
| [`upgradeSettings`](#parameter-upgradesettings) | object | Upgrade settings. |
| [`virtualMachinesProfile`](#parameter-virtualmachinesprofile) | object | Virtual Machines resource status. |
| [`vmSize`](#parameter-vmsize) | string | VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions. |
| [`vnetSubnetResourceId`](#parameter-vnetsubnetresourceid) | string | Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}. |
| [`windowsProfile`](#parameter-windowsprofile) | object | Windows OS configuration. |
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

### Parameter: `capacityReservationGroupResourceId`

AKS will associate the specified agent pool with the Capacity Reservation Group.

- Required: No
- Type: string

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

### Parameter: `enableEncryptionAtHost`

This is only supported on certain VM sizes and in certain Azure regions. For more information, see: /azure/aks/enable-host-encryption. For security reasons, this setting should be enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableFIPS`

See Add a FIPS-enabled node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview) for more details.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableNodePublicIP`

Some scenarios may require nodes in a node pool to receive their own dedicated public IP addresses. A common scenario is for gaming workloads, where a console needs to make a direct connection to a cloud virtual machine to minimize hops. For more information see assigning a public IP per node (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#assign-a-public-ip-per-node-for-your-node-pools).

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableUltraSSD`

Whether to enable UltraSSD.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `gatewayProfile`

Profile specific to a managed agent pool in Gateway mode. Ignored if agent pool mode is not Gateway.

- Required: No
- Type: object

### Parameter: `gpuInstanceProfile`

GPUInstanceProfile to be used to specify GPU MIG instance profile for supported GPU VM SKU.

- Required: No
- Type: string

### Parameter: `gpuProfile`

GPU settings.

- Required: No
- Type: object

### Parameter: `hostGroupResourceId`

This is of the form /subscriptions/{subscriptionId}/resourcegroups/{resourcegroupname}/providers/microsoft.compute/hostgroups/{hostgroupname}. For more information see [Azure Dedicated Hosts](https://learn.microsoft.com/azure/virtual-machines/dedicated-hosts).

- Required: No
- Type: string

### Parameter: `kubeletConfig`

Kubelet configuration on agent pool nodes.

- Required: No
- Type: object

### Parameter: `kubeletDiskType`

Determines the placement of emptyDir volumes, container runtime data root, and Kubelet ephemeral storage.

- Required: No
- Type: string

### Parameter: `linuxOSConfig`

Linux OS configuration.

- Required: No
- Type: object

### Parameter: `localDNSProfile`

Local DNS configuration.

- Required: No
- Type: object

### Parameter: `maxCount`

The maximum number of nodes for auto-scaling.

- Required: No
- Type: int

### Parameter: `maxPods`

The maximum number of pods that can run on a node.

- Required: No
- Type: int

### Parameter: `messageOfTheDay`

A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message. You can use escape characters like \n for new line.

- Required: No
- Type: string

### Parameter: `minCount`

The minimum number of nodes for auto-scaling.

- Required: No
- Type: int

### Parameter: `mode`

A cluster must have at least one "System" Agent Pool at all times. For additional information on agent pool restrictions and best practices, see: /azure/aks/use-system-pools.

- Required: No
- Type: string

### Parameter: `networkProfile`

Network profile to be used for agent pool nodes.

- Required: No
- Type: object

### Parameter: `nodeLabels`

The node labels to be persisted across all nodes in agent pool.

- Required: No
- Type: object

### Parameter: `nodePublicIpPrefixResourceId`

ResourceId of the node PublicIPPrefix.

- Required: No
- Type: string

### Parameter: `nodeTaints`

The taints added to new nodes during node pool create and scale. For example, key=value:NoSchedule.

- Required: No
- Type: array

### Parameter: `orchestratorVersion`

As a best practice, you should upgrade all node pools in an AKS cluster to the same Kubernetes version. The node pool version must have the same major version as the control plane. The node pool minor version must be within two minor versions of the control plane version. The node pool version cannot be greater than the control plane version. For more information see upgrading a node pool (https://learn.microsoft.com/en-us/azure/aks/use-multiple-node-pools#upgrade-a-node-pool).

- Required: No
- Type: string

### Parameter: `osDiskSizeGB`

OS Disk Size in GB to be used to specify the disk size for every machine in the master/agent pool. If you specify 0, it will apply the default osDisk size according to the vmSize specified.

- Required: No
- Type: int

### Parameter: `osDiskType`

The default is "Ephemeral" if the VM supports it and has a cache disk larger than the requested OSDiskSizeGB. Otherwise, defaults to "Managed". May not be changed after creation. For more information see Ephemeral OS (https://learn.microsoft.com/en-us/azure/aks/cluster-configuration#ephemeral-os).

- Required: No
- Type: string

### Parameter: `osSKU`

Specifies the OS SKU used by the agent pool. The default is Ubuntu if OSType is Linux. The default is Windows2019 when Kubernetes <= 1.24 or Windows2022 when Kubernetes >= 1.25 if OSType is Windows.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureLinux'
    'AzureLinux3'
    'CBLMariner'
    'Ubuntu'
    'Ubuntu2204'
    'Ubuntu2404'
    'Windows2019'
    'Windows2022'
    'Windows2025'
  ]
  ```

### Parameter: `osType`

The operating system type. The default is Linux.

- Required: No
- Type: string
- Default: `'Linux'`

### Parameter: `podIPAllocationMode`

Pod IP allocation mode.

- Required: No
- Type: string

### Parameter: `podSubnetResourceId`

Subnet resource ID for the pod IPs. If omitted, pod IPs are statically assigned on the node subnet (see vnetSubnetID for more details). This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.

- Required: No
- Type: string

### Parameter: `powerState`

Power State of the agent pool.

- Required: No
- Type: object

### Parameter: `proximityPlacementGroupResourceId`

The ID for the Proximity Placement Group.

- Required: No
- Type: string

### Parameter: `scaleDownMode`

Describes how VMs are added to or removed from Agent Pools. See [billing states](https://learn.microsoft.com/en-us/azure/virtual-machines/states-billing).

- Required: No
- Type: string
- Default: `'Delete'`

### Parameter: `scaleSetEvictionPolicy`

The eviction policy specifies what to do with the VM when it is evicted. The default is Delete. For more information about eviction see spot VMs.

- Required: No
- Type: string
- Default: `'Delete'`

### Parameter: `scaleSetPriority`

The Virtual Machine Scale Set priority.

- Required: No
- Type: string

### Parameter: `securityProfile`

The security settings of an agent pool.

- Required: No
- Type: object

### Parameter: `sourceResourceId`

This is the ARM ID of the source object to be used to create the target object.

- Required: No
- Type: string

### Parameter: `spotMaxPrice`

Possible values are any decimal value greater than zero or -1 which indicates the willingness to pay any on-demand price. For more details on spot pricing, see spot VMs pricing (https://learn.microsoft.com/en-us/azure/virtual-machines/spot-vms#pricing).

- Required: No
- Type: int

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `type`

The type of Agent Pool.

- Required: No
- Type: string

### Parameter: `upgradeSettings`

Upgrade settings.

- Required: No
- Type: object

### Parameter: `virtualMachinesProfile`

Virtual Machines resource status.

- Required: No
- Type: object

### Parameter: `vmSize`

VM size. VM size availability varies by region. If a node contains insufficient compute resources (memory, cpu, etc) pods might fail to run correctly. For more details on restricted VM sizes, see: /azure/aks/quotas-skus-regions.

- Required: No
- Type: string
- Default: `'Standard_D2s_v3'`

### Parameter: `vnetSubnetResourceId`

Node Subnet ID. If this is not specified, a VNET and subnet will be generated and used. If no podSubnetID is specified, this applies to nodes and pods, otherwise it applies to just nodes. This is of the form: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.

- Required: No
- Type: string

### Parameter: `windowsProfile`

Windows OS configuration.

- Required: No
- Type: object

### Parameter: `workloadRuntime`

Determines the type of workload a node can run.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the agent pool. |
| `resourceGroupName` | string | The resource group the agent pool was deployed into. |
| `resourceId` | string | The resource ID of the agent pool. |
