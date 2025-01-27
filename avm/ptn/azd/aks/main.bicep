metadata name = 'Azd AKS'
metadata description = '''Creates an Azure Kubernetes Service (AKS) cluster with a system agent pool as well as an additional user agent pool.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. The name of the parent managed cluster. Required if the template is used in a standalone deployment.')
param name string

@description('Required. Name of your Azure Container Registry.')
@minLength(5)
@maxLength(50)
param containerRegistryName string

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
param nodeResourceGroupName string = 'rg-mc-${name}'

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

@description('Conditional. Specifies the resource ID of connected application gateway. Required if `ingressApplicationGatewayEnabled` is set to `true`.')
param appGatewayResourceId string?

@description('Required. Resource ID of the monitoring log analytics workspace.')
param monitoringWorkspaceResourceId string

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkRuleSetIpRules are not set.  Note, requires the \'acrSku\' to be \'Premium\'.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional. Specifies the sku of the load balancer used by the virtual machine scale sets used by nodepools.')
@allowed([
  'basic'
  'standard'
])
param loadBalancerSku string = 'standard'

@description('Optional. Scope maps setting.')
param scopeMaps scopeMapsType

@description('Optional. Specifies whether the webApplicationRoutingEnabled add-on is enabled or not.')
param webApplicationRoutingEnabled bool = true

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

import { agentPoolType } from 'br/public:avm/res/container-service/managed-cluster:0.5.2'
@description('Optional. Custom configuration of system node pool.')
param systemPoolConfig agentPoolType[]?

@description('Optional. Custom configuration of user node pool.')
param agentPoolConfig agentPoolType[]?

@description('Optional. Specifies whether the KeyvaultSecretsProvider add-on is enabled or not.')
param enableKeyvaultSecretsProvider bool = true

@description('Optional. If set to true, getting static credentials will be disabled for this cluster. This must only be used on Managed Clusters that are AAD enabled.')
param disableLocalAccounts bool = true

@allowed([
  'NodeImage'
  'None'
  'SecurityPatch'
  'Unmanaged'
])
@description('Optional. Auto-upgrade channel on the Node Os.')
param autoNodeOsUpgradeProfileUpgradeChannel string = 'NodeImage'

@allowed([
  'CostOptimised'
  'Standard'
  'HighSpec'
  'Custom'
])
@description('Optional. The System Pool Preset sizing.')
param systemPoolSize string = 'Standard'

@allowed([
  ''
  'CostOptimised'
  'Standard'
  'HighSpec'
  'Custom'
])
@description('Optional. The User Pool Preset sizing.')
param agentPoolSize string = ''

@description('Optional. Property that controls how data actions are authorized. When true, the key vault will use Role Based Access Control (RBAC) for authorization of data actions, and the access policies specified in vault properties will be ignored. When false, the key vault will use the access policies specified in vault properties, and any policy stored on Azure Resource Manager will be ignored. Note that management actions are always authorized with RBAC.')
param enableRbacAuthorization bool = false

@description('Optional. Provide \'true\' to enable Key Vault\'s purge protection feature.')
param enablePurgeProtection bool = false

@description('Optional. Specifies if the vault is enabled for deployment by script or compute.')
param enableVaultForDeployment bool = false

@description('Optional. Specifies if the vault is enabled for a template deployment.')
param enableVaultForTemplateDeployment bool = false

@description('Optional. Enable RBAC using AAD.')
param enableAzureRbac bool = false

import { aadProfileType } from 'br/public:avm/res/container-service/managed-cluster:0.5.2'
@description('Optional. Enable Azure Active Directory integration.')
param aadProfile aadProfileType?

var systemPoolsConfig = !empty(systemPoolConfig)
  ? systemPoolConfig
  : [union({ name: 'npsystem', mode: 'System' }, nodePoolBase, nodePoolPresets[systemPoolSize])]

var agentPoolsConfig = !empty(agentPoolConfig)
  ? agentPoolConfig
  : empty(agentPoolSize)
      ? null
      : [union({ name: 'npuser', mode: 'User' }, nodePoolBase, nodePoolPresets[agentPoolSize])]

var aksClusterAdminRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'b1ff04bb-8a4e-4dc4-8eb5-8693973ce19b'
)

var acrPullRole = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)

var nodePoolPresets = {
  CostOptimised: {
    vmSize: 'Standard_B4ms'
    count: 1
    minCount: 1
    maxCount: 3
    enableAutoScaling: true
    availabilityZones: []
  }
  Standard: {
    vmSize: 'Standard_DS2_v2'
    count: 3
    minCount: 3
    maxCount: 5
    enableAutoScaling: true
    availabilityZones: [
      1
      2
      3
    ]
  }
  HighSpec: {
    vmSize: 'Standard_D4s_v3'
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
}

var nodePoolBase = {
  osType: 'Linux'
  maxPods: 30
  type: 'VirtualMachineScaleSets'
  upgradeSettings: {
    maxSurge: '33%'
  }
}

var roleAssignments = (enableAzureRbac || disableLocalAccounts)
  ? [
      {
        name: aksClusterRoleAssignmentName
        principalId: principalId
        principalType: principalType
        roleDefinitionIdOrName: aksClusterAdminRole
      }
    ]
  : []

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

module managedCluster 'br/public:avm/res/container-service/managed-cluster:0.5.2' = {
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
    skuTier: skuTier
    appGatewayResourceId: appGatewayResourceId
    monitoringWorkspaceResourceId: monitoringWorkspaceResourceId
    publicNetworkAccess: publicNetworkAccess
    autoNodeOsUpgradeProfileUpgradeChannel: autoNodeOsUpgradeProfileUpgradeChannel
    enableKeyvaultSecretsProvider: enableKeyvaultSecretsProvider
    webApplicationRoutingEnabled: webApplicationRoutingEnabled
    disableLocalAccounts: disableLocalAccounts
    loadBalancerSku: loadBalancerSku
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
        workspaceResourceId: monitoringWorkspaceResourceId
        metricCategories: [
          {
            category: 'AllMetrics'
            enabled: true
          }
        ]
      }
    ]
    primaryAgentPoolProfiles: systemPoolsConfig
    aadProfile: aadProfile
    dnsPrefix: dnsPrefix
    agentPools: agentPoolsConfig
    enableTelemetry: enableTelemetry
    roleAssignments: roleAssignments
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
        workspaceResourceId: monitoringWorkspaceResourceId
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
    enableRbacAuthorization: enableRbacAuthorization
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    enablePurgeProtection: enablePurgeProtection
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

type scopeMapsType = {
  @description('Optional. The name of the scope map.')
  name: string?

  @description('Required. The list of scoped permissions for registry artifacts.')
  actions: string[]

  @description('Optional. The user friendly description of the scope map.')
  description: string?
}[]?
