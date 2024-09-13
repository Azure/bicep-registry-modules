metadata name = 'Azure Kubernetes Service (AKS) Managed Clusters'
metadata description = 'This module deploys an Azure Kubernetes Service (AKS) Managed Cluster.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Specifies the name of the AKS cluster.')
param name string

@description('Optional. Specifies the location of AKS cluster. It picks up Resource Group\'s location by default.')
param location string = resourceGroup().location

@description('Optional. Specifies the DNS prefix specified when creating the managed cluster.')
param dnsPrefix string = name

@description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
param managedIdentities managedIdentitiesType

@description('Optional. Network dataplane used in the Kubernetes cluster. Not compatible with kubenet network plugin.')
@allowed([
  'azure'
  'cilium'
])
param networkDataplane string?

@description('Optional. Specifies the network plugin used for building Kubernetes network.')
@allowed([
  'azure'
  'kubenet'
])
param networkPlugin string?

@description('Optional. Network plugin mode used for building the Kubernetes network. Not compatible with kubenet network plugin.')
@allowed([
  'overlay'
])
param networkPluginMode string?

@description('Optional. Specifies the network policy used for building Kubernetes network. - calico or azure.')
@allowed([
  'azure'
  'calico'
])
param networkPolicy string?

@description('Optional. Specifies the CIDR notation IP range from which to assign pod IPs when kubenet is used.')
param podCidr string?

@description('Optional. A CIDR notation IP range from which to assign service cluster IPs. It must not overlap with any Subnet IP ranges.')
param serviceCidr string?

@description('Optional. Specifies the IP address assigned to the Kubernetes DNS service. It must be within the Kubernetes service address range specified in serviceCidr.')
param dnsServiceIP string?

@description('Optional. Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.')
@allowed([
  'basic'
  'standard'
])
param loadBalancerSku string = 'standard'

@description('Optional. Outbound IP Count for the Load balancer.')
param managedOutboundIPCount int = 0

@description('Optional. The type of the managed inbound Load Balancer BackendPool.')
@allowed([
  'NodeIP'
  'NodeIPConfiguration'
])
param backendPoolType string = 'NodeIPConfiguration'

@description('Optional. Specifies outbound (egress) routing method.')
@allowed([
  'loadBalancer'
  'userDefinedRouting'
  'managedNATGateway'
  'userAssignedNATGateway'
])
param outboundType string = 'loadBalancer'

@description('Optional. Tier of a managed cluster SKU.')
@allowed([
  'Free'
  'Premium'
  'Standard'
])
param skuTier string = 'Standard'

@description('Optional. Version of Kubernetes specified when creating the managed cluster.')
param kubernetesVersion string?

@description('Optional. Specifies the administrator username of Linux virtual machines.')
param adminUsername string = 'azureuser'

@description('Optional. Specifies the SSH RSA public key string for the Linux nodes.')
param sshPublicKey string?

@description('Conditional. Information about a service principal identity for the cluster to use for manipulating Azure APIs. Required if no managed identities are assigned to the cluster.')
param aksServicePrincipalProfile object?

@description('Optional. The client AAD application ID.')
param aadProfileClientAppID string?

@description('Optional. The server AAD application ID.')
param aadProfileServerAppID string?

@description('Optional. The server AAD application secret.')
#disable-next-line secure-secrets-in-params // Not a secret
param aadProfileServerAppSecret string?

@description('Optional. Specifies the tenant ID of the Azure Active Directory used by the AKS cluster for authentication.')
param aadProfileTenantId string = subscription().tenantId

@description('Optional. Specifies the AAD group object IDs that will have admin role of the cluster.')
param aadProfileAdminGroupObjectIDs array?

@description('Optional. Specifies whether to enable managed AAD integration.')
param aadProfileManaged bool = true

@description('Optional. Whether to enable Kubernetes Role-Based Access Control.')
param enableRBAC bool = true

@description('Optional. Specifies whether to enable Azure RBAC for Kubernetes authorization.')
param aadProfileEnableAzureRBAC bool = enableRBAC

@description('Optional. If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.')
param disableLocalAccounts bool = false

@description('Optional. Name of the resource group containing agent pool nodes.')
param nodeResourceGroup string = '${resourceGroup().name}_aks_${name}_nodes'

@description('Optional. IP ranges are specified in CIDR format, e.g. 137.117.106.88/29. This feature is not compatible with clusters that use Public IP Per Node, or clusters that are using a Basic Load Balancer.')
param authorizedIPRanges array?

@description('Optional. Whether to disable run command for the cluster or not.')
param disableRunCommand bool = false

@description('Optional. Allow or deny public network access for AKS.')
@allowed([
  'Enabled'
  'Disabled'
  'SecuredByPerimeter'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional. Specifies whether to create the cluster as a private cluster or not.')
param enablePrivateCluster bool = false

@description('Optional. Whether to create additional public FQDN for private cluster or not.')
param enablePrivateClusterPublicFQDN bool = false

@description('Optional. Private DNS Zone configuration. Set to \'system\' and AKS will create a private DNS zone in the node resource group. Set to \'\' to disable private DNS Zone creation and use public DNS. Supply the resource ID here of an existing Private DNS zone to use an existing zone.')
param privateDNSZone string?

@description('Required. Properties of the primary agent pool.')
param primaryAgentPoolProfile array

@description('Optional. Define one or more secondary/additional agent pools.')
param agentPools agentPoolType

@description('Optional. Whether or not to use AKS Automatic mode.')
param maintenanceConfiguration maintenanceConfigurationType

@description('Optional. Specifies whether the cost analysis add-on is enabled or not. If Enabled `enableStorageProfileDiskCSIDriver` is set to true as it is needed.')
param costAnalysisEnabled bool = false

@description('Optional. Specifies whether the httpApplicationRouting add-on is enabled or not.')
param httpApplicationRoutingEnabled bool = false

@description('Optional. Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.')
param webApplicationRoutingEnabled bool = false

@description('Optional. Specifies the resource ID of connected DNS zone. It will be ignored if `webApplicationRoutingEnabled` is set to `false`.')
param dnsZoneResourceId string?

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

@description('Optional. Specifies the scan interval of the auto-scaler of the AKS cluster.')
param autoScalerProfileScanInterval string = '10s'

@description('Optional. Specifies the scale down delay after add of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterAdd string = '10m'

@description('Optional. Specifies the scale down delay after delete of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterDelete string = '20s'

@description('Optional. Specifies scale down delay after failure of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownDelayAfterFailure string = '3m'

@description('Optional. Specifies the scale down unneeded time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnneededTime string = '10m'

@description('Optional. Specifies the scale down unready time of the auto-scaler of the AKS cluster.')
param autoScalerProfileScaleDownUnreadyTime string = '20m'

@description('Optional. Specifies the utilization threshold of the auto-scaler of the AKS cluster.')
param autoScalerProfileUtilizationThreshold string = '0.5'

@description('Optional. Specifies the max graceful termination time interval in seconds for the auto-scaler of the AKS cluster.')
param autoScalerProfileMaxGracefulTerminationSec string = '600'

@description('Optional. Specifies the balance of similar node groups for the auto-scaler of the AKS cluster.')
param autoScalerProfileBalanceSimilarNodeGroups bool = false

@allowed([
  'least-waste'
  'most-pods'
  'priority'
  'random'
])
@description('Optional. Specifies the expand strategy for the auto-scaler of the AKS cluster.')
param autoScalerProfileExpander string = 'random'

@description('Optional. Specifies the maximum empty bulk delete for the auto-scaler of the AKS cluster.')
param autoScalerProfileMaxEmptyBulkDelete string = '10'

@description('Optional. Specifies the maximum node provisioning time for the auto-scaler of the AKS cluster. Values must be an integer followed by an "m". No unit of time other than minutes (m) is supported.')
param autoScalerProfileMaxNodeProvisionTime string = '15m'

@description('Optional. Specifies the mximum total unready percentage for the auto-scaler of the AKS cluster. The maximum is 100 and the minimum is 0.')
param autoScalerProfileMaxTotalUnreadyPercentage string = '45'

@description('Optional. For scenarios like burst/batch scale where you do not want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they are a certain age. Values must be an integer followed by a unit ("s" for seconds, "m" for minutes, "h" for hours, etc).')
param autoScalerProfileNewPodScaleUpDelay string = '0s'

@description('Optional. Specifies the OK total unready count for the auto-scaler of the AKS cluster.')
param autoScalerProfileOkTotalUnreadyCount string = '3'

@description('Optional. Specifies if nodes with local storage should be skipped for the auto-scaler of the AKS cluster.')
param autoScalerProfileSkipNodesWithLocalStorage bool = true

@description('Optional. Specifies if nodes with system pods should be skipped for the auto-scaler of the AKS cluster.')
param autoScalerProfileSkipNodesWithSystemPods bool = true

@allowed([
  'node-image'
  'none'
  'patch'
  'rapid'
  'stable'
])
@description('Optional. Auto-upgrade channel on the AKS cluster.')
param autoUpgradeProfileUpgradeChannel string = 'stable'

@description('Optional. Running in Kubenet is disabled by default due to the security related nature of AAD Pod Identity and the risks of IP spoofing.')
param podIdentityProfileAllowNetworkPluginKubenet bool = false

@description('Optional. Whether the pod identity addon is enabled.')
param podIdentityProfileEnable bool = false

@description('Optional. The pod identities to use in the cluster.')
param podIdentityProfileUserAssignedIdentities array?

@description('Optional. The pod identity exceptions to allow.')
param podIdentityProfileUserAssignedIdentityExceptions array?

@description('Optional. Whether the The OIDC issuer profile of the Managed Cluster is enabled.')
param enableOidcIssuerProfile bool = false

@description('Optional. Whether to enable Workload Identity. Requires OIDC issuer profile to be enabled.')
param enableWorkloadIdentity bool = false

@description('Optional. Whether to enable Azure Defender.')
param enableAzureDefender bool = false

@description('Optional. Whether to enable Image Cleaner for Kubernetes.')
param enableImageCleaner bool = false

@description('Optional. The interval in hours Image Cleaner will run. The maximum value is three months.')
@minValue(24)
param imageCleanerIntervalHours int = 24

@description('Optional. Whether to enable Kubernetes pod security policy. Requires enabling the pod security policy feature flag on the subscription.')
param enablePodSecurityPolicy bool = false

@description('Optional. Whether the AzureBlob CSI Driver for the storage profile is enabled.')
param enableStorageProfileBlobCSIDriver bool = false

@description('Optional. Whether the AzureDisk CSI Driver for the storage profile is enabled.')
param enableStorageProfileDiskCSIDriver bool = false

@description('Optional. Whether the AzureFile CSI Driver for the storage profile is enabled.')
param enableStorageProfileFileCSIDriver bool = false

@description('Optional. Whether the snapshot controller for the storage profile is enabled.')
param enableStorageProfileSnapshotController bool = false

@allowed([
  'AKSLongTermSupport'
  'KubernetesOfficial'
])
@description('Optional. The support plan for the Managed Cluster.')
param supportPlan string = 'KubernetesOfficial'

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Specifies whether the OMS agent is enabled.')
param omsAgentEnabled bool = true

@description('Optional. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceId string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The resource ID of the disc encryption set to apply to the cluster. For security reasons, this value should be provided.')
param diskEncryptionSetResourceId string?

@description('Optional. Settings and configurations for the flux extension.')
param fluxExtension extensionType

@description('Optional. Configurations for provisioning the cluster with HTTP proxy servers.')
param httpProxyConfig object?

@description('Optional. Identities associated with the cluster.')
param identityProfile object?

@description('Optional. Enables Kubernetes Event-driven Autoscaling (KEDA).')
param kedaAddon bool = false

@description('Optional. Whether to enable VPA add-on in cluster. Default value is false.')
param vpaAddon bool = false

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@description('Optional. Whether the metric state of the kubenetes cluster is enabled.')
param enableAzureMonitorProfileMetrics bool = false

@description('Optional. Indicates if Azure Monitor Container Insights Logs Addon is enabled.')
param enableContainerInsights bool = false

@description('Optional. Indicates whether custom metrics collection has to be disabled or not. If not specified the default is false. No custom metrics will be emitted if this field is false but the container insights enabled field is false.')
param disableCustomMetrics bool = false

@description('Optional. Indicates whether prometheus metrics scraping is disabled or not. If not specified the default is false. No prometheus metrics will be emitted if this field is false but the container insights enabled field is false.')
param disablePrometheusMetricsScraping bool = false

@description('Optional. The syslog host port. If not specified, the default port is 28330.')
param syslogPort int = 28330

@description('Optional. A comma-separated list of kubernetes cluster metrics labels.')
param metricLabelsAllowlist string = ''

@description('Optional. A comma-separated list of Kubernetes cluster metrics annotations.')
param metricAnnotationsAllowList string = ''

// =========== //
// Variables   //
// =========== //

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourcesIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'UserAssigned' : null)
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
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

// ============== //
// Main Resources //
// ============== //

resource managedCluster 'Microsoft.ContainerService/managedClusters@2024-03-02-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: 'Base'
    tier: skuTier
  }
  properties: {
    httpProxyConfig: httpProxyConfig
    identityProfile: identityProfile
    diskEncryptionSetID: diskEncryptionSetResourceId
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    agentPoolProfiles: primaryAgentPoolProfile
    linuxProfile: !empty(sshPublicKey)
      ? {
          adminUsername: adminUsername
          ssh: {
            publicKeys: [
              {
                keyData: sshPublicKey ?? ''
              }
            ]
          }
        }
      : null
    servicePrincipalProfile: aksServicePrincipalProfile
    metricsProfile: {
      costAnalysis: {
        enabled: skuTier == 'free' ? false : costAnalysisEnabled
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
        enabled: omsAgentEnabled && !empty(monitoringWorkspaceId)
        #disable-next-line BCP321 // Value will not be used if null or empty
        config: omsAgentEnabled && !empty(monitoringWorkspaceId)
          ? {
              logAnalyticsWorkspaceResourceID: monitoringWorkspaceId
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
    enablePodSecurityPolicy: enablePodSecurityPolicy
    workloadAutoScalerProfile: {
      keda: {
        enabled: kedaAddon
      }
      verticalPodAutoscaler: {
        enabled: vpaAddon
      }
    }
    networkProfile: {
      networkDataplane: networkDataplane
      networkPlugin: networkPlugin
      networkPluginMode: networkPluginMode
      networkPolicy: networkPolicy
      podCidr: podCidr
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      outboundType: outboundType
      loadBalancerSku: loadBalancerSku
      loadBalancerProfile: {
        managedOutboundIPs: managedOutboundIPCount != 0
          ? {
              count: managedOutboundIPCount
            }
          : null
        effectiveOutboundIPs: []
        backendPoolType: backendPoolType
      }
    }
    publicNetworkAccess: publicNetworkAccess
    aadProfile: {
      clientAppID: aadProfileClientAppID
      serverAppID: aadProfileServerAppID
      serverAppSecret: aadProfileServerAppSecret
      managed: aadProfileManaged
      enableAzureRBAC: aadProfileEnableAzureRBAC
      adminGroupObjectIDs: aadProfileAdminGroupObjectIDs
      tenantID: aadProfileTenantId
    }
    autoScalerProfile: {
      'balance-similar-node-groups': toLower(string(autoScalerProfileBalanceSimilarNodeGroups))
      expander: autoScalerProfileExpander
      'max-empty-bulk-delete': autoScalerProfileMaxEmptyBulkDelete
      'max-graceful-termination-sec': autoScalerProfileMaxGracefulTerminationSec
      'max-node-provision-time': autoScalerProfileMaxNodeProvisionTime
      'max-total-unready-percentage': autoScalerProfileMaxTotalUnreadyPercentage
      'new-pod-scale-up-delay': autoScalerProfileNewPodScaleUpDelay
      'ok-total-unready-count': autoScalerProfileOkTotalUnreadyCount
      'scale-down-delay-after-add': autoScalerProfileScaleDownDelayAfterAdd
      'scale-down-delay-after-delete': autoScalerProfileScaleDownDelayAfterDelete
      'scale-down-delay-after-failure': autoScalerProfileScaleDownDelayAfterFailure
      'scale-down-unneeded-time': autoScalerProfileScaleDownUnneededTime
      'scale-down-unready-time': autoScalerProfileScaleDownUnreadyTime
      'scale-down-utilization-threshold': autoScalerProfileUtilizationThreshold
      'scan-interval': autoScalerProfileScanInterval
      'skip-nodes-with-local-storage': toLower(string(autoScalerProfileSkipNodesWithLocalStorage))
      'skip-nodes-with-system-pods': toLower(string(autoScalerProfileSkipNodesWithSystemPods))
    }
    autoUpgradeProfile: {
      upgradeChannel: autoUpgradeProfileUpgradeChannel
    }
    apiServerAccessProfile: {
      authorizedIPRanges: authorizedIPRanges
      disableRunCommand: disableRunCommand
      enablePrivateCluster: enablePrivateCluster
      enablePrivateClusterPublicFQDN: enablePrivateClusterPublicFQDN
      privateDNSZone: privateDNSZone
    }
    azureMonitorProfile: {
      containerInsights: enableContainerInsights
        ? {
            enabled: enableContainerInsights
            logAnalyticsWorkspaceResourceId: !empty(monitoringWorkspaceId) ? monitoringWorkspaceId : null
            disableCustomMetrics: disableCustomMetrics
            disablePrometheusMetricsScraping: disablePrometheusMetricsScraping
            syslogPort: syslogPort
          }
        : null
      metrics: enableAzureMonitorProfileMetrics
        ? {
            enabled: enableAzureMonitorProfileMetrics
            kubeStateMetrics: {
              metricLabelsAllowlist: metricLabelsAllowlist
              metricAnnotationsAllowList: metricAnnotationsAllowList
            }
          }
        : null
    }
    podIdentityProfile: {
      allowNetworkPluginKubenet: podIdentityProfileAllowNetworkPluginKubenet
      enabled: podIdentityProfileEnable
      userAssignedIdentities: podIdentityProfileUserAssignedIdentities
      userAssignedIdentityExceptions: podIdentityProfileUserAssignedIdentityExceptions
    }
    securityProfile: {
      defender: enableAzureDefender
        ? {
            securityMonitoring: {
              enabled: enableAzureDefender
            }
            logAnalyticsWorkspaceResourceId: monitoringWorkspaceId
          }
        : null
      workloadIdentity: enableWorkloadIdentity
        ? {
            enabled: enableWorkloadIdentity
          }
        : null
      imageCleaner: enableImageCleaner
        ? {
            enabled: enableImageCleaner
            intervalHours: imageCleanerIntervalHours
          }
        : null
    }
    storageProfile: {
      blobCSIDriver: {
        enabled: enableStorageProfileBlobCSIDriver
      }
      diskCSIDriver: {
        enabled: costAnalysisEnabled == true && skuTier != 'free' ? true : enableStorageProfileDiskCSIDriver
      }
      fileCSIDriver: {
        enabled: enableStorageProfileFileCSIDriver
      }
      snapshotController: {
        enabled: enableStorageProfileSnapshotController
      }
    }
    supportPlan: supportPlan
  }
}

module managedCluster_maintenanceConfigurations 'maintenance-configurations/main.bicep' = if (!empty(maintenanceConfiguration)) {
  name: '${uniqueString(deployment().name, location)}-ManagedCluster-MaintenanceConfigurations'
  params: {
    maintenanceWindow: maintenanceConfiguration!.maintenanceWindow
    managedClusterName: managedCluster.name
  }
}

module managedCluster_agentPools 'agent-pool/main.bicep' = [
  for (agentPool, index) in (agentPools ?? []): {
    name: '${uniqueString(deployment().name, location)}-ManagedCluster-AgentPool-${index}'
    params: {
      managedClusterName: managedCluster.?name
      name: agentPool.name
      availabilityZones: agentPool.?availabilityZones
      count: agentPool.?count
      sourceResourceId: agentPool.?sourceResourceId
      enableAutoScaling: agentPool.?enableAutoScaling
      enableEncryptionAtHost: agentPool.?enableEncryptionAtHost
      enableFIPS: agentPool.?enableFIPS
      enableNodePublicIP: agentPool.?enableNodePublicIP
      enableUltraSSD: agentPool.?enableUltraSSD
      gpuInstanceProfile: agentPool.?gpuInstanceProfile
      kubeletDiskType: agentPool.?kubeletDiskType
      maxCount: agentPool.?maxCount
      maxPods: agentPool.?maxPods
      minCount: agentPool.?minCount
      mode: agentPool.?mode
      nodeLabels: agentPool.?nodeLabels
      nodePublicIpPrefixId: agentPool.?nodePublicIpPrefixId
      nodeTaints: agentPool.?nodeTaints
      orchestratorVersion: agentPool.?orchestratorVersion ?? kubernetesVersion
      osDiskSizeGB: agentPool.?osDiskSizeGB
      osDiskType: agentPool.?osDiskType
      osSku: agentPool.?osSku
      osType: agentPool.?osType
      podSubnetId: agentPool.?podSubnetId
      proximityPlacementGroupResourceId: agentPool.?proximityPlacementGroupResourceId
      scaleDownMode: agentPool.?scaleDownMode
      scaleSetEvictionPolicy: agentPool.?scaleSetEvictionPolicy
      scaleSetPriority: agentPool.?scaleSetPriority
      spotMaxPrice: agentPool.?spotMaxPrice
      tags: agentPool.?tags ?? tags
      type: agentPool.?type
      maxSurge: agentPool.?maxSurge
      vmSize: agentPool.?vmSize
      vnetSubnetId: agentPool.?vnetSubnetId
      workloadRuntime: agentPool.?workloadRuntime
    }
  }
]

module managedCluster_extension 'br/public:avm/res/kubernetes-configuration/extension:0.2.0' = if (!empty(fluxExtension)) {
  name: '${uniqueString(deployment().name, location)}-ManagedCluster-FluxExtension'
  params: {
    clusterName: managedCluster.name
    configurationProtectedSettings: fluxExtension.?configurationProtectedSettings
    configurationSettings: fluxExtension.?configurationSettings
    enableTelemetry: enableTelemetry
    extensionType: 'microsoft.flux'
    fluxConfigurations: fluxExtension.?configurations
    location: location
    name: 'flux'
    releaseNamespace: fluxExtension.?releaseNamespace ?? 'flux-system'
    releaseTrain: fluxExtension.?releaseTrain ?? 'Stable'
    version: fluxExtension.?version
  }
}

resource managedCluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
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

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = if (enableDnsZoneContributorRoleAssignment == true && dnsZoneResourceId != null && webApplicationRoutingEnabled) {
  name: last(split((!empty(dnsZoneResourceId) ? any(dnsZoneResourceId) : '/dummmyZone'), '/'))!
}

resource dnsZone_roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (enableDnsZoneContributorRoleAssignment == true && dnsZoneResourceId != null && webApplicationRoutingEnabled) {
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

@description('The resource ID of the managed cluster.')
output resourceId string = managedCluster.id

@description('The resource group the managed cluster was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the managed cluster.')
output name string = managedCluster.name

@description('The control plane FQDN of the managed cluster.')
output controlPlaneFQDN string = enablePrivateCluster
  ? managedCluster.properties.privateFQDN
  : managedCluster.properties.fqdn

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = managedCluster.?identity.?principalId ?? ''

@description('The Client ID of the AKS identity.')
output kubeletIdentityClientId string = managedCluster.properties.?identityProfile.?kubeletidentity.?clientId ?? ''

@description('The Object ID of the AKS identity.')
output kubeletIdentityObjectId string = managedCluster.properties.?identityProfile.?kubeletidentity.?objectId ?? ''

@description('The Resource ID of the AKS identity.')
output kubeletIdentityResourceId string = managedCluster.properties.?identityProfile.?kubeletidentity.?resourceId ?? ''

@description('The Object ID of the OMS agent identity.')
output omsagentIdentityObjectId string = managedCluster.properties.?addonProfiles.?omsagent.?identity.?objectId ?? ''

@description('The Object ID of the Key Vault Secrets Provider identity.')
output keyvaultIdentityObjectId string = managedCluster.properties.?addonProfiles.?azureKeyvaultSecretsProvider.?identity.?objectId ?? ''

@description('The Client ID of the Key Vault Secrets Provider identity.')
output keyvaultIdentityClientId string = managedCluster.properties.?addonProfiles.?azureKeyvaultSecretsProvider.?identity.?clientId ?? ''

@description('The Object ID of Application Gateway Ingress Controller (AGIC) identity.')
output ingressApplicationGatewayIdentityObjectId string = managedCluster.properties.?addonProfiles.?ingressApplicationGateway.?identity.?objectId ?? ''

@description('The location the resource was deployed into.')
output location string = managedCluster.location

@description('The OIDC token issuer URL.')
output oidcIssuerUrl string = managedCluster.properties.?oidcIssuerProfile.?issuerURL ?? ''

@description('The addonProfiles of the Kubernetes cluster.')
output addonProfiles object = managedCluster.properties.?addonProfiles ?? {}

@description('The Object ID of Web Application Routing.')
output webAppRoutingIdentityObjectId string = managedCluster.properties.?ingressProfile.?webAppRouting.?identity.?objectId ?? ''

// =============== //
//   Definitions   //
// =============== //

type agentPoolType = {
  @description('Required. The name of the agent pool.')
  name: string?

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

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourcesIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics' | null)?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

type fluxConfigurationProtectedSettingsType = {
  @description('Optional. The SSH private key to use for Git authentication.')
  sshPrivateKey: string?
}?

type extensionType = {
  @description('Required. The name of the extension.')
  name: string?

  @description('Optional. Namespace where the extension Release must be placed.')
  releaseNamespace: string?

  @description('Optional. Namespace where the extension will be created for an Namespace scoped extension.')
  targetNamespace: string?

  @description('Required. The release train of the extension.')
  releaseTrain: string?

  @description('Optional. The configuration protected settings of the extension.')
  configurationProtectedSettings: fluxConfigurationProtectedSettingsType?

  @description('Optional. The configuration settings of the extension.')
  configurationSettings: object?

  @description('Optional. The version of the extension.')
  version: string?

  @description('Optional. The flux configurations of the extension.')
  configurations: array?
}?

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Required. Network access of key vault. The possible values are Public and Private. Public means the key vault allows public access from all networks. Private means the key vault disables public access and enables private link. The default value is Public.')
  keyVaultNetworkAccess: ('Private' | 'Public')
}?

type maintenanceConfigurationType = {
  @description('Required. Maintenance window for the maintenance configuration.')
  maintenanceWindow: object
}?
