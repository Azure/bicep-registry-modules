metadata name = 'Azure Stack HCI Cluster'
metadata description = 'This module deploys an Azure Stack HCI Cluster on the provided Arc Machines.'
metadata owner = 'Azure/module-maintainers'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.')
@maxLength(15)
@minLength(4)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. First must pass with this parameter set to Validate prior running with it set to Deploy. If either Validation or Deployment phases fail, fix the issue, then resubmit the template with the same deploymentMode to retry.')
@allowed([
  'Validate'
  'Deploy'
])
param deploymentMode string

@minLength(4)
@maxLength(8)
@description('Required. The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.')
param deploymentPrefix string

@description('Required. Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2].')
param clusterNodeNames array

@description('Required. The domain name of the Active Directory Domain Services. Example: "contoso.com".')
param domainFqdn string

@description('Required. The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com".')
param domainOUPath string

@description('Optional. Security configuration settings object; defaults to most secure posture.')
param securityConfiguration securityConfigurationType = {
  hvciProtection: true
  drtmProtection: true
  driftControlEnforced: true
  credentialGuardEnforced: true
  smbSigningEnforced: true
  smbClusterEncryption: true
  sideChannelMitigationEnforced: true
  bitlockerBootVolume: true
  bitlockerDataVolumes: true
  wdacEnforced: true
}

// cluster diagnostics and telemetry configuration
@description('Optional. The metrics data for deploying a HCI cluster.')
param streamingDataClient bool = true

@description('Optional. The location data for deploying a HCI cluster.')
param isEuropeanUnionLocation bool = false

@description('Optional. The diagnostic data for deploying a HCI cluster.')
param episodicDataUpload bool = true

// storage configuration
@description('Optional. The storage volume configuration mode. See documentation for details.')
@allowed([
  'Express'
  'InfraOnly'
  'KeepStorage'
])
param storageConfigurationMode string = 'Express'

// cluster network configuration details
@description('Required. The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.')
param subnetMask string

@description('Required. The default gateway of the Management Network. Exameple: 192.168.0.1.')
param defaultGateway string

@description('Required. The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
param startingIPAddress string

@description('Required. The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
param endingIPAddress string

@description('Required. The DNS servers accessible from the Management Network for the HCI cluster.')
param dnsServers array

@description('Required. An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.')
param networkIntents networkIntent[]

@description('Required. Specify whether the Storage Network connectivity is switched or switchless.')
param storageConnectivitySwitchless bool

@description('Required. Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.')
param enableStorageAutoIp bool = true

@description('Required. An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.')
param storageNetworks storageNetworksArrayType

@description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
param customLocationName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.')
param clusterWitnessStorageAccountName string

@description('Required. The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.')
param keyVaultName string

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

// ============= //
//   Variables   //
// ============= //

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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
  'Azure Stack HCI Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'bda0d508-adf1-4af0-9c28-88919fc3ae06'
  )
  'Windows Admin Center Administrator Login': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a6333a3e-0164-44c3-b281-7a577aff287f'
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

// ============= //
//   Resources   //
// ============= //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.azurestackhci-cluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '0.0.0'
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

// cluster resource is created when deploymentMode is set to 'Validate'
resource cluster 'Microsoft.AzureStackHCI/clusters@2024-04-01' = if (deploymentMode == 'Validate') {
  name: name
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {}
  tags: tags
}

// existing cluster resource is used when deploymentMode is set to 'Deploy'
resource clusterExisting 'Microsoft.AzureStackHCI/clusters@2024-04-01' existing = if (deploymentMode == 'Deploy') {
  name: name
}

module deploymentSetting 'deployment-settings/main.bicep' = {
  name: 'deploymentSettings'
  params: {
    clusterName: name
    clusterNodeNames: clusterNodeNames
    clusterWitnessStorageAccountName: clusterWitnessStorageAccountName
    customLocationName: customLocationName
    defaultGateway: defaultGateway
    deploymentMode: deploymentMode
    deploymentPrefix: deploymentPrefix
    dnsServers: dnsServers
    domainFqdn: domainFqdn
    domainOUPath: domainOUPath
    enableStorageAutoIp: enableStorageAutoIp
    endingIPAddress: endingIPAddress
    episodicDataUpload: episodicDataUpload
    isEuropeanUnionLocation: isEuropeanUnionLocation
    keyVaultName: keyVaultName
    networkIntents: networkIntents
    securityConfiguration: securityConfiguration
    startingIPAddress: startingIPAddress
    storageConfigurationMode: storageConfigurationMode
    storageConnectivitySwitchless: storageConnectivitySwitchless
    storageNetworks: storageNetworks
    streamingDataClient: streamingDataClient
    subnetMask: subnetMask
  }
  dependsOn: [
    cluster
  ]
}

resource cluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(cluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: cluster
  }
]

@description('The name of the cluster.')
output name string = (deploymentMode == 'Validate')
  ? cluster.name
  : (deploymentMode == 'Deploy') ? clusterExisting.name : ''
@description('The ID of the cluster.')
output resourceId string = (deploymentMode == 'Validate')
  ? cluster.id
  : (deploymentMode == 'Deploy') ? clusterExisting.id : ''
@description('The resource group of the cluster.')
output resourceGroupName string = resourceGroup().name
@description('The managed identity of the cluster.')
output systemAssignedMIPrincipalId string = (deploymentMode == 'Validate')
  ? cluster.identity.principalId
  : (deploymentMode == 'Deploy') ? clusterExisting.identity.principalId : ''
@description('The location of the cluster.')
output location string = (deploymentMode == 'Validate')
  ? cluster.location
  : (deploymentMode == 'Deploy') ? clusterExisting.location : ''

// =============== //
//   Definitions   //
// =============== //

type networkIntent = {
  @description('Required. The names of the network adapters to include in the intent.')
  adapter: string[]
  @description('Required. The name of the network intent.')
  name: string
  @description('Required. Specify whether to override the adapter property. Use false by default.')
  overrideAdapterProperty: bool
  @description('Required. The adapter property overrides for the network intent.')
  adapterPropertyOverrides: {
    @description('Required. The jumboPacket configuration for the network adapters.')
    jumboPacket: string
    @description('Required. The networkDirect configuration for the network adapters. Allowed values: "Enabled", "Disabled".')
    networkDirect: string
    @description('Required. The networkDirectTechnology configuration for the network adapters. Allowed values: "RoCEv2", "iWARP".')
    networkDirectTechnology: string
  }
  @description('Required. Specify whether to override the qosPolicy property. Use false by default.')
  overrideQosPolicy: bool
  @description('Required. The qosPolicy overrides for the network intent.')
  qosPolicyOverrides: {
    @description('Required. The bandwidthPercentage for the network intent. Recommend 50.')
    bandwidthPercentage_SMB: string
    @description('Required. Recommend 7.')
    priorityValue8021Action_Cluster: string
    @description('Required. Recommend 3.')
    priorityValue8021Action_SMB: string
  }
  @description('Required. Specify whether to override the virtualSwitchConfiguration property. Use false by default.')
  overrideVirtualSwitchConfiguration: bool
  @description('Required. The virtualSwitchConfiguration overrides for the network intent.')
  virtualSwitchConfigurationOverrides: {
    @description('Required. The enableIov configuration for the network intent. Allowed values: "True", "False".')
    enableIov: string
    @description('Required. The loadBalancingAlgorithm configuration for the network intent. Allowed values: "Dynamic", "HyperVPort", "IPHash".')
    loadBalancingAlgorithm: string
  }
  @description('Required. The traffic types for the network intent. Allowed values: "Compute", "Management", "Storage".')
  trafficType: string[]
}

// define custom type for storage adapter IP info for 3-node switchless deployments
type storageAdapterIPInfoType = {
  @description('Required. The HCI node name.')
  physicalNode: string
  @description('Required. The IPv4 address for the storage adapter.')
  ipv4Address: string
  @description('Required. The subnet mask for the storage adapter.')
  subnetMask: string
}

// define custom type for storage network objects
type storageNetworksType = {
  @description('Required. The name of the storage adapter.')
  adapterName: string
  @description('Required. The VLAN for the storage adapter.')
  vlan: string
  @description('Optional. The storage adapter IP information for 3-node switchless or manual config deployments.')
  storageAdapterIPInfo: storageAdapterIPInfoType[]? // optional for non-switchless deployments
}
type storageNetworksArrayType = storageNetworksType[]

// cluster security configuration settings
type securityConfigurationType = {
  @description('Required. Enable/Disable HVCI protection.')
  hvciProtection: bool
  @description('Required. Enable/Disable DRTM protection.')
  drtmProtection: bool
  @description('Required. Enable/Disable Drift Control enforcement.')
  driftControlEnforced: bool
  @description('Required. Enable/Disable Credential Guard enforcement.')
  credentialGuardEnforced: bool
  @description('Required. Enable/Disable SMB signing enforcement.')
  smbSigningEnforced: bool
  @description('Required. Enable/Disable SMB cluster encryption.')
  smbClusterEncryption: bool
  @description('Required. Enable/Disable Side Channel Mitigation enforcement.')
  sideChannelMitigationEnforced: bool
  @description('Required. Enable/Disable BitLocker protection for boot volume.')
  bitlockerBootVolume: bool
  @description('Required. Enable/Disable BitLocker protection for data volumes.')
  bitlockerDataVolumes: bool
  @description('Required. Enable/Disable WDAC enforcement.')
  wdacEnforced: bool
}

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
