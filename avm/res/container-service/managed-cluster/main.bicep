metadata name = 'Azure Kubernetes Service (AKS) Managed Clusters'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster.'

@description('Required. Specifies the name of the AKS cluster.')
param name string

@description('Optional. Specifies the location of AKS cluster. It picks up Resource Group\'s location by default.')
param location string = resourceGroup().location

@description('Optional. Specifies the DNS prefix specified when creating the managed cluster.')
param dnsPrefix string = name

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
param managedIdentities managedIdentityAllType?

@description('Optional. Advanced Networking profile for enabling observability and security feature suite on a cluster. For more information see https://aka.ms/aksadvancednetworking.')
param advancedNetworking resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.advancedNetworking?

@description('Optional. The IP families used for the cluster.')
param ipFamilies resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.ipFamilies = [
  'IPv4'
]

@description('Optional. NAT Gateway profile for the cluster.')
param natGatewayProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.natGatewayProfile?

@description('Optional. Network mode used for building the Kubernetes network.')
param networkMode resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.networkMode?

@description('Optional. Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.')
param networkDataplane resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.networkDataplane?

@description('Optional. Specifies the network plugin used for building Kubernetes network.')
param networkPlugin resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.networkPlugin?

@description('Optional. Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.')
param networkPluginMode resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.networkPluginMode?

@description('Optional. Specifies the network policy used for building Kubernetes network. - calico or azure.')
param networkPolicy resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.networkPolicy?

@description('Optional. Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.')
param podCidr string?

@description('Optional. A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.')
param serviceCidr string?

@description('Optional. The CIDR notation IP ranges from which to assign service cluster IPs. One IPv4 CIDR is expected for single-stack networking. Two CIDRs, one for each IP family (IPv4/IPv6), is expected for dual-stack networking. They must not overlap with any Subnet IP ranges.')
param serviceCidrs string[]?

@description('Optional. The CIDR notation IP ranges from which to assign pod IPs. One IPv4 CIDR is expected for single-stack networking. Two CIDRs, one for each IP family (IPv4/IPv6), is expected for dual-stack networking.')
param podCidrs string[]?

@description('Optional. Static egress gateway profile for the cluster.')
param staticEgressGatewayProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.staticEgressGatewayProfile?

@description('Optional. Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.')
param dnsServiceIP string?

@description('Optional. Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.')
param loadBalancerSku resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.loadBalancerSku = 'standard'

@description('Optional. Outbound IP Count for the Load balancer.')
param managedOutboundIPCount int = 0

@description('Optional. The desired number of allocated SNAT ports per VM. Default is 0, which results in Azure dynamically allocating ports.')
param allocatedOutboundPorts int = 0

@description('Optional. Desired outbound flow idle timeout in minutes.')
param idleTimeoutInMinutes int = 30

@description('Optional. A list of the resource IDs of the public IP addresses to use for the load balancer outbound rules.')
param outboundPublicIPResourceIds string[]?

@description('Optional. A list of the resource IDs of the public IP prefixes to use for the load balancer outbound rules.')
param outboundPublicIPPrefixResourceIds string[]?

@description('Optional. The type of the managed inbound Load Balancer BackendPool.')
param backendPoolType resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.loadBalancerProfile.backendPoolType = 'NodeIPConfiguration'

@description('Optional. Specifies outbound (egress) routing method.')
param outboundType resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.networkProfile.outboundType = 'loadBalancer'

@description('Optional. Name of a managed cluster SKU.')
param skuName resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.sku.name = 'Base'

@description('Optional. Tier of a managed cluster SKU.')
param skuTier resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.sku.tier = 'Standard'

@description('Optional. Version of Kubernetes specified when creating the managed cluster.')
param kubernetesVersion string?

@description('Optional. The profile for Linux VMs in the Managed Cluster.')
param linuxProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.linuxProfile?

@description('Optional. Enable Azure Active Directory integration.')
param aadProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.aadProfile?

@description('Conditional. Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster.')
param aksServicePrincipalProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.servicePrincipalProfile?

@description('Optional. Whether to enable Kubernetes Role-Based Access Control.')
param enableRBAC bool = true

@description('Optional. If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.')
param disableLocalAccounts bool = true

@description('Optional. Node provisioning settings that apply to the whole cluster.')
param nodeProvisioningProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.nodeProvisioningProfile?

@description('Optional. Name of the resource group containing agent pool nodes.')
param nodeResourceGroup string = '${resourceGroup().name}_aks_${name}_nodes'

@description('Optional. The node resource group configuration profile.')
param nodeResourceGroupProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.nodeResourceGroupProfile?

@description('Optional. The access profile for managed cluster API server.')
param apiServerAccessProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.apiServerAccessProfile?

@description('Optional. Allow or deny public network access for AKS.')
@allowed([
  'Enabled'
  'Disabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = 'Disabled'

@description('Required. Properties of the primary agent pool.')
param primaryAgentPoolProfiles agentPoolType[]

@description('Optional. Define one or more secondary/additional agent pools.')
param agentPools agentPoolType[]?

@description('Optional. Maintenance configurations for the managed cluster.')
param maintenanceConfigurations maintenanceConfigurationType[]?

@description('Optional. Specifies whether the cost analysis add-on is enabled or not. If Enabled `enableStorageProfileDiskCSIDriver` is set to true as it is needed.')
param costAnalysisEnabled bool = false

@description('Optional. Specifies whether the httpApplicationRouting add-on is enabled or not.')
param httpApplicationRoutingEnabled bool = false

@description('Optional. Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.')
param webApplicationRoutingEnabled bool = false

@description('Optional. Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`.')
param dnsZoneResourceId string?

@description('Optional. Ingress type for the default NginxIngressController custom resource. It will be ignored if `webApplicationRoutingEnabled` is set to `false`.')
param defaultIngressControllerType resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.ingressProfile.webAppRouting.nginx.defaultIngressControllerType?

@description('Optional. Specifies whether assing the DNS zone contributor role to the cluster service principal. It will be ignored if `webApplicationRoutingEnabled` is set to `false` or `dnsZoneResourceId` not provided.')
param enableDnsZoneContributorRoleAssignment bool = true

@description('Optional. Specifies whether the ingressApplicationGateway (AGIC) add-on is enabled or not.')
param ingressApplicationGatewayEnabled bool = false

@description('Conditional. Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.')
param appGatewayResourceId string?

@description('Optional. Specifies whether the aciConnectorLinux add-on is enabled or not.')
param aciConnectorLinuxEnabled bool = false

@description('Optional. Specifies whether the azurepolicy add-on is enabled or not. For security reasons, this setting should be enabled.')
param azurePolicyEnabled bool = true

@description('Optional. Specifies whether the openServiceMesh add-on is enabled or not.')
param openServiceMeshEnabled bool = false

@description('Optional. Specifies the azure policy version to use.')
param azurePolicyVersion string = 'v2'

@description('Optional. Specifies whether the kubeDashboard add-on is enabled or not.')
param kubeDashboardEnabled bool = false

@description('Optional. Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.')
#disable-next-line secure-secrets-in-params // Not a secret
param enableKeyvaultSecretsProvider bool = false

@description('Optional. Specifies whether the KeyvaultSecretsProvider add-on uses secret rotation.')
#disable-next-line secure-secrets-in-params // Not a secret
param enableSecretRotation bool = false

@description('Optional. Parameters to be applied to the cluster-autoscaler when enabled.')
param autoScalerProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.autoScalerProfile?

@description('Optional. The auto upgrade configuration.')
param autoUpgradeProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.autoUpgradeProfile = {
  upgradeChannel: 'stable'
}

@description('Optional. The pod identity profile of the Managed Cluster. See [use AAD pod identity](https://learn.microsoft.com/azure/aks/use-azure-ad-pod-identity) for more details on AAD pod identity integration.')
param podIdentityProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.podIdentityProfile?

@description('Optional. Whether the The OIDC issuer profile of the Managed Cluster is enabled.')
param enableOidcIssuerProfile bool = false

@description('Optional. Security profile for the managed cluster.')
param securityProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.securityProfile?

@description('Optional. Whether the AzureBlob CSI Driver for the storage profile is enabled.')
param enableStorageProfileBlobCSIDriver bool = false

@description('Optional. Whether the AzureDisk CSI Driver for the storage profile is enabled.')
param enableStorageProfileDiskCSIDriver bool = false

@description('Optional. Whether the AzureFile CSI Driver for the storage profile is enabled.')
param enableStorageProfileFileCSIDriver bool = false

@description('Optional. Whether the snapshot controller for the storage profile is enabled.')
param enableStorageProfileSnapshotController bool = false

@description('Optional. The support plan for the Managed Cluster.')
param supportPlan resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.supportPlan = 'KubernetesOfficial'

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Specifies whether the OMS agent is enabled.')
param omsAgentEnabled bool = true

@description('Optional. Specifies whether the OMS agent is using managed identity authentication.')
param omsAgentUseAADAuth bool = false

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceResourceId string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.tags?

@description('Optional. The Resource ID of the disk encryption set to use for enabling encryption at rest. For security reasons, this value should be provided.')
param diskEncryptionSetResourceId string?

@description('Optional. Settings and configurations for the flux extension.')
param fluxExtension extensionType?

@description('Optional. Configurations for provisioning the cluster with HTTP proxy servers.')
param httpProxyConfig resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.httpProxyConfig?

@description('Optional. Identities associated with the cluster.')
param identityProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.identityProfile?

@description('Optional. Workload Auto-scaler profile for the managed cluster.')
param workloadAutoScalerProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.workloadAutoScalerProfile?

@description('Optional. Azure Monitor addon profiles for monitoring the managed cluster.')
param azureMonitorProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.azureMonitorProfile?

@description('Optional. Service mesh profile for a managed cluster.')
param serviceMeshProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.serviceMeshProfile?

@description('Optional. AI toolchain operator settings that apply to the whole cluster.')
param aiToolchainOperatorProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.aiToolchainOperatorProfile?

@description('Optional. Profile of the cluster bootstrap configuration.')
param bootstrapProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.bootstrapProfile?

@description('Optional. The FQDN subdomain of the private cluster with custom private dns zone. This cannot be updated once the Managed Cluster has been created.')
param fqdnSubdomain string?

@description('Optional. Settings for upgrading the cluster with override options.')
param upgradeSettings resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.upgradeSettings?

@description('Optional. The profile for Windows VMs in the Managed Cluster.')
param windowsProfile resourceInput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.windowsProfile?

// =========== //
// Variables   //
// =========== //

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'Azure Kubernetes Fleet Manager Contributor Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '63bb64ad-9799-4770-b5c3-24ed299a07bf'
  )
  'Azure Kubernetes Fleet Manager RBAC Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '434fb43a-c01c-447e-9f67-c3ad923cfaba'
  )
  'Azure Kubernetes Fleet Manager RBAC Cluster Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18ab4d3d-a1bf-4477-8ad9-8359bc988f69'
  )
  'Azure Kubernetes Fleet Manager RBAC Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '30b27cfc-9c84-438e-b0ce-70e35255df80'
  )
  'Azure Kubernetes Fleet Manager RBAC Writer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '5af6afb3-c06c-4fa4-8848-71a8aee05683'
  )
  'Azure Kubernetes Service Cluster Admin Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8'
  )
  'Azure Kubernetes Service Cluster Monitoring User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1afdec4b-e479-420e-99e7-f82237c7c5e6'
  )
  'Azure Kubernetes Service Cluster User Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4abbcc35-e782-43d8-92c5-2d3f1bd2253f'
  )
  'Azure Kubernetes Service Contributor Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
  )
  'Azure Kubernetes Service RBAC Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3498e952-d568-435e-9b2c-8d77e338d7f7'
  )
  'Azure Kubernetes Service RBAC Cluster Admin': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
  )
  'Azure Kubernetes Service RBAC Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '7f6c6a51-bcf8-42ba-9220-52d62157d7db'
  )
  'Azure Kubernetes Service RBAC Writer': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a7ffa36f-339b-4b5c-8bdf-e2c188b2c0eb'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Kubernetes Agentless Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd5a2ae44-610b-4500-93be-660a0c5f5ca6'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.containerservice-managedcluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// ============== //
// Main Resources //
// ============== //

resource managedCluster 'Microsoft.ContainerService/managedClusters@2025-09-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    agentPoolProfiles: map(primaryAgentPoolProfiles, profile => {
      name: profile.name
      count: profile.?count ?? 1
      availabilityZones: map(profile.?availabilityZones ?? [1, 2, 3], zone => '${zone}')
      creationData: !empty(profile.?sourceResourceId)
        ? {
            sourceResourceId: profile.?sourceResourceId
          }
        : null
      enableAutoScaling: profile.?enableAutoScaling ?? false
      enableEncryptionAtHost: profile.?enableEncryptionAtHost ?? false
      enableFIPS: profile.?enableFIPS ?? false
      enableNodePublicIP: profile.?enableNodePublicIP ?? false
      enableUltraSSD: profile.?enableUltraSSD ?? false
      capacityReservationGroupID: profile.?capacityReservationGroupResourceId
      gatewayProfile: profile.?gatewayProfile
      gpuInstanceProfile: profile.?gpuInstanceProfile
      gpuProfile: profile.?gpuProfile
      hostGroupID: profile.?hostGroupResourceId
      kubeletConfig: profile.?kubeletConfig
      kubeletDiskType: profile.?kubeletDiskType
      linuxOSConfig: profile.?linuxOSConfig
      localDNSProfile: profile.?localDNSProfile
      maxCount: profile.?maxCount
      maxPods: profile.?maxPods
      messageOfTheDay: profile.?messageOfTheDay
      minCount: profile.?minCount
      mode: profile.?mode
      networkProfile: profile.?networkProfile
      nodeLabels: profile.?nodeLabels
      nodePublicIPPrefixID: profile.?nodePublicIpPrefixResourceId
      nodeTaints: profile.?nodeTaints
      orchestratorVersion: profile.?orchestratorVersion
      osDiskSizeGB: profile.?osDiskSizeGB
      osDiskType: profile.?osDiskType
      osType: profile.?osType ?? 'Linux'
      osSKU: profile.?osSKU
      podIPAllocationMode: profile.?podIPAllocationMode
      podSubnetID: profile.?podSubnetResourceId
      powerState: profile.?powerState
      proximityPlacementGroupID: profile.?proximityPlacementGroupResourceId
      scaleDownMode: profile.?scaleDownMode ?? 'Delete'
      scaleSetEvictionPolicy: profile.?scaleSetEvictionPolicy ?? 'Delete'
      scaleSetPriority: profile.?scaleSetPriority
      securityProfile: profile.?securityProfile
      spotMaxPrice: profile.?spotMaxPrice
      tags: profile.?tags
      type: profile.?type
      upgradeSettings: profile.?upgradeSettings
      virtualMachinesProfile: profile.?virtualMachinesProfile
      vmSize: profile.?vmSize ?? 'Standard_D2s_v3'
      vnetSubnetID: profile.?vnetSubnetResourceId
      windowsProfile: profile.?windowsProfile
      workloadRuntime: profile.?workloadRuntime
    })
    aiToolchainOperatorProfile: aiToolchainOperatorProfile
    bootstrapProfile: bootstrapProfile
    httpProxyConfig: httpProxyConfig
    identityProfile: identityProfile
    diskEncryptionSetID: diskEncryptionSetResourceId
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    fqdnSubdomain: fqdnSubdomain
    linuxProfile: linuxProfile
    servicePrincipalProfile: aksServicePrincipalProfile
    metricsProfile: {
      costAnalysis: {
        enabled: skuTier == 'Free' ? false : costAnalysisEnabled
      }
    }
    ingressProfile: {
      webAppRouting: {
        enabled: webApplicationRoutingEnabled
        dnsZoneResourceIds: !empty(dnsZoneResourceId)
          ? [
              any(dnsZoneResourceId)
            ]
          : null
        nginx: !empty(defaultIngressControllerType)
          ? {
              defaultIngressControllerType: any(defaultIngressControllerType)
            }
          : null
      }
    }
    addonProfiles: {
      httpApplicationRouting: {
        enabled: httpApplicationRoutingEnabled
      }
      ingressApplicationGateway: {
        enabled: ingressApplicationGatewayEnabled && !empty(appGatewayResourceId)
        #disable-next-line BCP321 // Value will not be used if null or empty
        config: ingressApplicationGatewayEnabled && !empty(appGatewayResourceId)
          ? {
              applicationGatewayId: appGatewayResourceId
              effectiveApplicationGatewayId: appGatewayResourceId
            }
          : null
      }
      omsagent: {
        enabled: omsAgentEnabled && !empty(monitoringWorkspaceResourceId)
        config: omsAgentEnabled && !empty(monitoringWorkspaceResourceId)
          ? {
              logAnalyticsWorkspaceResourceID: monitoringWorkspaceResourceId!
              ...(omsAgentUseAADAuth
                ? {
                    useAADAuth: 'true'
                  }
                : {})
            }
          : null
      }
      aciConnectorLinux: {
        enabled: aciConnectorLinuxEnabled
      }
      azurepolicy: {
        enabled: azurePolicyEnabled
        config: azurePolicyEnabled
          ? {
              version: azurePolicyVersion
            }
          : null
      }
      openServiceMesh: {
        enabled: openServiceMeshEnabled
        config: openServiceMeshEnabled ? {} : null
      }
      kubeDashboard: {
        enabled: kubeDashboardEnabled
      }
      azureKeyvaultSecretsProvider: {
        enabled: enableKeyvaultSecretsProvider
        config: enableKeyvaultSecretsProvider
          ? {
              enableSecretRotation: toLower(string(enableSecretRotation))
            }
          : null
      }
    }
    oidcIssuerProfile: enableOidcIssuerProfile
      ? {
          enabled: enableOidcIssuerProfile
        }
      : null
    enableRBAC: enableRBAC
    disableLocalAccounts: disableLocalAccounts
    nodeResourceGroup: nodeResourceGroup
    nodeResourceGroupProfile: nodeResourceGroupProfile
    nodeProvisioningProfile: nodeProvisioningProfile
    workloadAutoScalerProfile: workloadAutoScalerProfile
    networkProfile: {
      advancedNetworking: advancedNetworking
      ipFamilies: ipFamilies
      natGatewayProfile: natGatewayProfile
      networkMode: networkMode
      podCidrs: podCidrs
      serviceCidrs: serviceCidrs
      staticEgressGatewayProfile: staticEgressGatewayProfile
      networkDataplane: networkDataplane
      networkPlugin: networkPlugin
      networkPluginMode: networkDataplane == 'cilium' ? 'overlay' : networkPluginMode
      networkPolicy: networkDataplane == 'cilium' ? 'cilium' : networkPolicy
      podCidr: podCidr
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      outboundType: outboundType
      loadBalancerSku: loadBalancerSku
      loadBalancerProfile: outboundType != 'userDefinedRouting'
        ? {
            allocatedOutboundPorts: allocatedOutboundPorts
            idleTimeoutInMinutes: idleTimeoutInMinutes
            managedOutboundIPs: managedOutboundIPCount != 0
              ? {
                  count: managedOutboundIPCount
                }
              : null
            backendPoolType: backendPoolType
            outboundIPPrefixes: !empty(outboundPublicIPPrefixResourceIds)
              ? {
                  publicIPPrefixes: map(outboundPublicIPPrefixResourceIds ?? [], id => {
                    id: id
                  })
                }
              : null

            outboundIPs: !empty(outboundPublicIPResourceIds)
              ? {
                  publicIPs: map(outboundPublicIPResourceIds ?? [], id => {
                    id: id
                  })
                }
              : null
          }
        : null
    }
    publicNetworkAccess: publicNetworkAccess
    aadProfile: aadProfile
    autoScalerProfile: autoScalerProfile
    autoUpgradeProfile: autoUpgradeProfile
    apiServerAccessProfile: apiServerAccessProfile
    azureMonitorProfile: azureMonitorProfile
    podIdentityProfile: podIdentityProfile
    securityProfile: securityProfile
    storageProfile: {
      blobCSIDriver: {
        enabled: enableStorageProfileBlobCSIDriver
      }
      diskCSIDriver: {
        enabled: costAnalysisEnabled == true && skuTier != 'Free' ? true : enableStorageProfileDiskCSIDriver
      }
      fileCSIDriver: {
        enabled: enableStorageProfileFileCSIDriver
      }
      snapshotController: {
        enabled: enableStorageProfileSnapshotController
      }
    }
    supportPlan: supportPlan
    upgradeSettings: upgradeSettings
    windowsProfile: windowsProfile
    serviceMeshProfile: serviceMeshProfile
  }
}

module managedCluster_maintenanceConfigurations 'maintenance-configurations/main.bicep' = [
  for (maintenanceConfiguration, index) in (maintenanceConfigurations ?? []): {
    name: '${uniqueString(deployment().name, location)}-ManagedCluster-MaintenanceCfg-${index}'
    params: {
      managedClusterName: managedCluster.name
      name: maintenanceConfiguration.name
      maintenanceWindow: maintenanceConfiguration.maintenanceWindow
      notAllowedTime: maintenanceConfiguration.?notAllowedTime
      timeInWeek: maintenanceConfiguration.?timeInWeek
    }
  }
]

module managedCluster_agentPools 'agent-pool/main.bicep' = [
  for (agentPool, index) in (agentPools ?? []): {
    name: '${uniqueString(deployment().name, location)}-ManagedCluster-AgentPool-${index}'
    params: {
      managedClusterName: managedCluster.?name
      name: agentPool.name
      availabilityZones: agentPool.?availabilityZones
      count: agentPool.?count
      capacityReservationGroupResourceId: agentPool.?capacityReservationGroupResourceId
      sourceResourceId: agentPool.?sourceResourceId
      enableAutoScaling: agentPool.?enableAutoScaling
      enableEncryptionAtHost: agentPool.?enableEncryptionAtHost
      enableFIPS: agentPool.?enableFIPS
      enableNodePublicIP: agentPool.?enableNodePublicIP
      enableUltraSSD: agentPool.?enableUltraSSD
      gatewayProfile: agentPool.?gatewayProfile
      gpuInstanceProfile: agentPool.?gpuInstanceProfile
      gpuProfile: agentPool.?gpuProfile
      hostGroupResourceId: agentPool.?hostGroupResourceId
      kubeletConfig: agentPool.?kubeletConfig
      kubeletDiskType: agentPool.?kubeletDiskType
      linuxOSConfig: agentPool.?linuxOSConfig
      localDNSProfile: agentPool.?localDNSProfile
      messageOfTheDay: agentPool.?messageOfTheDay
      maxCount: agentPool.?maxCount
      maxPods: agentPool.?maxPods
      minCount: agentPool.?minCount
      mode: agentPool.?mode
      networkProfile: agentPool.?networkProfile
      nodeLabels: agentPool.?nodeLabels
      nodePublicIpPrefixResourceId: agentPool.?nodePublicIpPrefixResourceId
      nodeTaints: agentPool.?nodeTaints
      orchestratorVersion: agentPool.?orchestratorVersion ?? kubernetesVersion
      osDiskSizeGB: agentPool.?osDiskSizeGB
      osDiskType: agentPool.?osDiskType
      osSKU: agentPool.?osSKU
      osType: agentPool.?osType
      podIPAllocationMode: agentPool.?podIPAllocationMode
      podSubnetResourceId: agentPool.?podSubnetResourceId
      powerState: agentPool.?powerState
      proximityPlacementGroupResourceId: agentPool.?proximityPlacementGroupResourceId
      scaleDownMode: agentPool.?scaleDownMode
      scaleSetEvictionPolicy: agentPool.?scaleSetEvictionPolicy
      scaleSetPriority: agentPool.?scaleSetPriority
      securityProfile: agentPool.?securityProfile
      spotMaxPrice: agentPool.?spotMaxPrice
      tags: agentPool.?tags ?? tags
      type: agentPool.?type
      upgradeSettings: agentPool.?upgradeSettings
      vmSize: agentPool.?vmSize
      virtualMachinesProfile: agentPool.?virtualMachinesProfile
      vnetSubnetResourceId: agentPool.?vnetSubnetResourceId
      workloadRuntime: agentPool.?workloadRuntime
      windowsProfile: agentPool.?windowsProfile
    }
  }
]

module managedCluster_extension 'br/public:avm/res/kubernetes-configuration/extension:0.3.8' = if (!empty(fluxExtension)) {
  name: '${uniqueString(deployment().name, location)}-ManagedCluster-FluxExtension'
  params: {
    clusterName: managedCluster.name
    configurationProtectedSettings: fluxExtension.?configurationProtectedSettings
    configurationSettings: fluxExtension.?configurationSettings
    enableTelemetry: enableReferencedModulesTelemetry
    extensionType: 'microsoft.flux'
    fluxConfigurations: fluxExtension.?fluxConfigurations
    location: location
    name: fluxExtension.?name ?? 'flux'
    releaseNamespace: fluxExtension.?releaseNamespace ?? 'flux-system'
    releaseTrain: fluxExtension.?releaseTrain ?? 'Stable'
    version: fluxExtension.?version
    targetNamespace: fluxExtension.?targetNamespace
  }
}

resource managedCluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: managedCluster
}

resource managedCluster_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: managedCluster
  }
]

resource managedCluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(managedCluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: managedCluster
  }
]

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = if (publicNetworkAccess != 'Disabled' && enableDnsZoneContributorRoleAssignment == true && dnsZoneResourceId != null && webApplicationRoutingEnabled) {
  name: last(split((!empty(dnsZoneResourceId) ? any(dnsZoneResourceId) : '/dummmyZone'), '/'))!
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = if (publicNetworkAccess == 'Disabled' && enableDnsZoneContributorRoleAssignment == true && dnsZoneResourceId != null && webApplicationRoutingEnabled) {
  name: last(split((!empty(dnsZoneResourceId) ? any(dnsZoneResourceId) : '/dummmyZone'), '/'))
}

resource dnsZone_roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (publicNetworkAccess != 'Disabled' && enableDnsZoneContributorRoleAssignment == true && dnsZoneResourceId != null && webApplicationRoutingEnabled) {
  name: guid(
    dnsZone.id,
    subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'befefa01-2a29-4197-83a8-272ff33ce314'),
    'DNS Zone Contributor'
  )
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'befefa01-2a29-4197-83a8-272ff33ce314'
    ) // 'DNS Zone Contributor'
    principalId: managedCluster.properties.ingressProfile.webAppRouting.identity.objectId
    principalType: 'ServicePrincipal'
  }
  scope: dnsZone
}

resource privateDnsZone_roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (publicNetworkAccess == 'Disabled' && enableDnsZoneContributorRoleAssignment == true && dnsZoneResourceId != null && webApplicationRoutingEnabled) {
  name: guid(
    privateDnsZone.id,
    subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'befefa01-2a29-4197-83a8-272ff33ce314'),
    'DNS Zone Contributor'
  )
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'befefa01-2a29-4197-83a8-272ff33ce314'
    ) // 'DNS Zone Contributor'
    principalId: managedCluster.properties.ingressProfile.webAppRouting.identity.objectId
    principalType: 'ServicePrincipal'
  }
  scope: privateDnsZone
}

@description('The resource ID of the managed cluster.')
output resourceId string = managedCluster.id

@description('The resource group the managed cluster was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the managed cluster.')
output name string = managedCluster.name

@description('The control plane FQDN of the managed cluster.')
output controlPlaneFQDN string = (apiServerAccessProfile.?enablePrivateCluster ?? false)
  ? managedCluster.properties.privateFQDN
  : managedCluster.properties.fqdn

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = managedCluster.?identity.?principalId

@description('The Client ID of the AKS identity.')
output kubeletIdentityClientId string? = managedCluster.properties.?identityProfile.?kubeletidentity.?clientId

@description('The Object ID of the AKS identity.')
output kubeletIdentityObjectId string? = managedCluster.properties.?identityProfile.?kubeletidentity.?objectId

@description('The Resource ID of the AKS identity.')
output kubeletIdentityResourceId string? = managedCluster.properties.?identityProfile.?kubeletidentity.?resourceId

@description('The Object ID of the OMS agent identity.')
output omsagentIdentityObjectId string? = managedCluster.properties.?addonProfiles.?omsagent.?identity.?objectId

@description('The Object ID of the Key Vault Secrets Provider identity.')
output keyvaultIdentityObjectId string? = managedCluster.properties.?addonProfiles.?azureKeyvaultSecretsProvider.?identity.?objectId

@description('The Client ID of the Key Vault Secrets Provider identity.')
output keyvaultIdentityClientId string? = managedCluster.properties.?addonProfiles.?azureKeyvaultSecretsProvider.?identity.?clientId

@description('The Object ID of Application Gateway Ingress Controller (AGIC) identity.')
output ingressApplicationGatewayIdentityObjectId string? = managedCluster.properties.?addonProfiles.?ingressApplicationGateway.?identity.?objectId

@description('The location the resource was deployed into.')
output location string = managedCluster.location

@description('The OIDC token issuer URL.')
output oidcIssuerUrl string? = managedCluster.properties.?oidcIssuerProfile.?issuerURL

@description('The addonProfiles of the Kubernetes cluster.')
output addonProfiles resourceOutput<'Microsoft.ContainerService/managedClusters@2025-09-01'>.properties.addonProfiles? = managedCluster.properties.?addonProfiles

@description('The Object ID of Web Application Routing.')
output webAppRoutingIdentityObjectId string? = managedCluster.properties.?ingressProfile.?webAppRouting.?identity.?objectId

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for an agent pool.')
type agentPoolType = {
  @description('Required. The name of the agent pool.')
  name: string

  @description('Optional. The availability zones of the agent pool.')
  availabilityZones: int[]?

  @description('Optional. The number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).')
  count: int?

  @description('Optional. AKS will associate the specified agent pool with the Capacity Reservation Group.')
  capacityReservationGroupResourceId: string?

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

  @description('Optional. Represents the Gateway node pool configuration.')
  gatewayProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.gatewayProfile?

  @description('Optional. The GPU instance profile of the agent pool.')
  gpuInstanceProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.gpuInstanceProfile?

  @description('Optional. GPU settings.')
  gpuProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.gpuProfile?

  @description('Optional. Host group resource ID.')
  hostGroupResourceId: string?

  @description('Optional. Kubelet configuration on agent pool nodes.')
  kubeletConfig: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.kubeletConfig?

  @description('Optional. The kubelet disk type of the agent pool.')
  kubeletDiskType: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.kubeletDiskType?

  @description('Optional. The Linux OS configuration of the agent pool.')
  linuxOSConfig: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.linuxOSConfig?

  @description('Optional. Local DNS configuration.')
  localDNSProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.localDNSProfile?

  @description('Optional. A message of the day will be a multi-line message that is prepended to the command prompt and the SSH login message.')
  messageOfTheDay: string?

  @description('Optional. The maximum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).')
  maxCount: int?

  @description('Optional. The minimum number of agents (VMs) to host docker containers. Allowed values must be in the range of 1 to 100 (inclusive).')
  minCount: int?

  @description('Optional. The maximum number of pods that can run on a node.')
  maxPods: int?

  @description('Optional. The minimum number of pods that can run on a node.')
  minPods: int?

  @description('Optional. The mode of the agent pool.')
  mode: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.mode?

  @description('Optional. Network profile to be used for agent pool nodes.')
  networkProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.networkProfile?

  @description('Optional. The node labels of the agent pool.')
  nodeLabels: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.nodeLabels?

  @description('Optional. The node public IP prefix ID of the agent pool.')
  nodePublicIpPrefixResourceId: string?

  @description('Optional. The node taints of the agent pool.')
  nodeTaints: string[]?

  @description('Optional. The Kubernetes version of the agent pool.')
  orchestratorVersion: string?

  @description('Optional. The OS disk size in GB of the agent pool.')
  osDiskSizeGB: int?

  @description('Optional. The OS disk type of the agent pool.')
  osDiskType: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.osDiskType?

  @description('Optional. The OS SKU of the agent pool.')
  osSKU: (
    | 'AzureLinux'
    | 'AzureLinux3'
    | 'CBLMariner'
    | 'Ubuntu'
    | 'Ubuntu2204'
    | 'Ubuntu2404'
    | 'Windows2019'
    | 'Windows2022'
    | 'Windows2025')?

  @description('Optional. The OS type of the agent pool.')
  osType: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.osType?

  @description('Optional. Pod IP allocation mode.')
  podIPAllocationMode: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.podIPAllocationMode?

  @description('Optional. The pod subnet ID of the agent pool.')
  podSubnetResourceId: string?

  @description('Optional. Power State of the agent pool.')
  powerState: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.powerState?

  @description('Optional. The proximity placement group resource ID of the agent pool.')
  proximityPlacementGroupResourceId: string?

  @description('Optional. The scale down mode of the agent pool.')
  scaleDownMode: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.scaleDownMode?

  @description('Optional. The scale set eviction policy of the agent pool.')
  scaleSetEvictionPolicy: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.scaleSetEvictionPolicy?

  @description('Optional. The scale set priority of the agent pool.')
  scaleSetPriority: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.scaleSetPriority?

  @description('Optional. The security settings of an agent pool.')
  securityProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.securityProfile?

  @description('Optional. The spot max price of the agent pool.')
  spotMaxPrice: int?

  @description('Optional. The tags of the agent pool.')
  tags: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.tags?

  @description('Optional. The type of the agent pool.')
  type: ('AvailabilitySet' | 'VirtualMachineScaleSets')?

  @description('Optional. Upgrade settings.')
  upgradeSettings: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.upgradeSettings?

  @description('Optional. The VM size of the agent pool.')
  vmSize: string?

  @description('Optional. Virtual Machines resource status.')
  virtualMachinesProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.virtualMachinesProfile?

  @description('Optional. The VNet subnet ID of the agent pool.')
  vnetSubnetResourceId: string?

  @description('Optional. The workload runtime of the agent pool.')
  workloadRuntime: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.workloadRuntime?

  @description('Optional. The Windows profile of the agent pool.')
  windowsProfile: resourceInput<'Microsoft.ContainerService/managedClusters/agentPools@2025-09-01'>.properties.windowsProfile?

  @description('Optional. The enable default telemetry of the agent pool.')
  enableDefaultTelemetry: bool?
}

@export()
@description('The type for an extension.')
type extensionType = {
  @description('Optional. The name of the extension.')
  name: string?

  @description('Optional. Namespace where the extension Release must be placed.')
  releaseNamespace: string?

  @description('Optional. Namespace where the extension will be created for an Namespace scoped extension.')
  targetNamespace: string?

  @description('Optional. The release train of the extension.')
  releaseTrain: string?

  @description('Optional. The configuration protected settings of the extension.')
  configurationProtectedSettings: resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties.configurationProtectedSettings?

  @description('Optional. The configuration settings of the extension.')
  configurationSettings: resourceInput<'Microsoft.KubernetesConfiguration/extensions@2024-11-01'>.properties.configurationSettings?

  @description('Optional. The version of the extension.')
  version: string?

  @description('Optional. The flux configurations of the extension.')
  fluxConfigurations: resourceInput<'Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01'>.properties[]?
}

@export()
@description('The type of a mainenance configuration.')
type maintenanceConfigurationType = {
  @description('Required. Name of maintenance window.')
  name: ('aksManagedAutoUpgradeSchedule' | 'aksManagedNodeOSUpgradeSchedule')

  @description('Required. Maintenance window for the maintenance configuration.')
  maintenanceWindow: resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01'>.properties.maintenanceWindow

  @description('Optional. Time slots on which upgrade is not allowed.')
  notAllowedTime: resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01'>.properties.notAllowedTime?

  @description('Optional. Time slots during the week when planned maintenance is allowed to proceed.')
  timeInWeek: resourceInput<'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2025-09-01'>.properties.timeInWeek?
}
