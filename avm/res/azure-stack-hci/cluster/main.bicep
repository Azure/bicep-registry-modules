metadata name = 'Azure Stack HCI Cluster'
metadata description = 'This module deploys an Azure Stack HCI Cluster on the provided Arc Machines.'

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

@description('Optional. The cluster deployment operations to execute. Defaults to "[Validate, Deploy]".')
@allowed([
  'Deploy'
  'Validate'
])
param deploymentOperations string[] = ['Validate', 'Deploy']

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The deployment settings of the cluster.')
param deploymentSettings deploymentSettingsType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Specify whether to use the shared key vault for the HCI cluster.')
param useSharedKeyVault bool = true

@description('Conditional. The name of the deployment user. Required if useSharedKeyVault is true.')
param deploymentUser string?

@secure()
@description('Conditional. The password of the deployment user. Required if useSharedKeyVault is true.')
param deploymentUserPassword string?

@description('Conditional. The name of the local admin user. Required if useSharedKeyVault is true.')
param localAdminUser string?

@secure()
@description('Conditional. The password of the local admin user. Required if useSharedKeyVault is true.')
param localAdminPassword string?

@description('Conditional. The service principal ID for ARB. Required if useSharedKeyVault is true.')
param servicePrincipalId string?

@secure()
@description('Conditional. The service principal secret for ARB. Required if useSharedKeyVault is true.')
param servicePrincipalSecret string?

@description('Optional. Content type of the azure stack lcm user credential.')
param azureStackLCMUserCredentialContentType string = 'Secret'

@description('Optional. Content type of the local admin credential.')
param localAdminCredentialContentType string = 'Secret'

@description('Optional. Content type of the witness storage key.')
param witnessStoragekeyContentType string = 'Secret'

@description('Optional. Content type of the default ARB application.')
param defaultARBApplicationContentType string = 'Secret'

@description('Optional. Tags of azure stack LCM user credential.')
param azureStackLCMUserCredentialTags object?

@description('Optional. Tags of the local admin credential.')
param localAdminCredentialTags object?

@description('Optional. Tags of the witness storage key.')
param witnessStoragekeyTags object?

@description('Optional. Tags of the default ARB application.')
param defaultARBApplicationTags object?

@description('Optional. Key vault subscription ID.')
param kvSubscriptionId string?

@description('Optional. Key vault resource group.')
param kvResourceGroup string?

@description('Optional. Storage account subscription ID.')
param storageAccountSubscriptionId string?

@description('Optional. Storage account resource group.')
param storageAccountResourceGroup string?

// ============= //
//   Variables   //
// ============= //

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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

// if deployment operations requested, validation must be performed first so we reverse sort the array
var sortedDeploymentOperations = (!empty(deploymentOperations)) ? sort(deploymentOperations, (a, b) => a > b) : []

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

resource cluster 'Microsoft.AzureStackHCI/clusters@2024-04-01' = {
  name: name
  identity: {
    type: 'SystemAssigned'
  }
  location: location
  properties: {}
  tags: tags
}

module secrets './secrets.bicep' = if (useSharedKeyVault) {
  name: '${uniqueString(deployment().name, location)}-secrets'
  scope: resourceGroup(kvSubscriptionId ?? subscription().subscriptionId, kvResourceGroup ?? resourceGroup().name)
  params: {
    clusterName: name
    cloudId: cluster.properties.cloudId
    keyVaultName: deploymentSettings!.keyVaultName
    storageAccountName: deploymentSettings!.clusterWitnessStorageAccountName
    deploymentUser: deploymentUser!
    deploymentUserPassword: deploymentUserPassword!
    localAdminUser: localAdminUser!
    localAdminPassword: localAdminPassword!
    servicePrincipalId: servicePrincipalId!
    servicePrincipalSecret: servicePrincipalSecret!
    azureStackLCMUserCredentialContentType: azureStackLCMUserCredentialContentType
    localAdminCredentialContentType: localAdminCredentialContentType
    witnessStoragekeyContentType: witnessStoragekeyContentType
    defaultARBApplicationContentType: defaultARBApplicationContentType
    azureStackLCMUserCredentialTags: azureStackLCMUserCredentialTags
    localAdminCredentialTags: localAdminCredentialTags
    witnessStoragekeyTags: witnessStoragekeyTags
    defaultARBApplicationTags: defaultARBApplicationTags
    storageAccountResourceGroup: storageAccountResourceGroup ?? resourceGroup().name
    storageAccountSubscriptionId: storageAccountSubscriptionId ?? subscription().subscriptionId
  }
}

@batchSize(1)
module deploymentSetting 'deployment-setting/main.bicep' = [
  for deploymentOperation in sortedDeploymentOperations: if (!empty(deploymentOperation) && !empty(deploymentSettings)) {
    name: 'deploymentSettings-${deploymentOperation}'
    params: {
      cloudId: useSharedKeyVault ? cluster.properties.cloudId : null
      clusterName: cluster.name
      deploymentMode: deploymentOperation
      clusterNodeNames: deploymentSettings!.clusterNodeNames
      clusterWitnessStorageAccountName: deploymentSettings!.clusterWitnessStorageAccountName
      customLocationName: deploymentSettings!.customLocationName
      defaultGateway: deploymentSettings!.defaultGateway
      deploymentPrefix: deploymentSettings!.deploymentPrefix
      dnsServers: deploymentSettings!.dnsServers
      domainFqdn: deploymentSettings!.domainFqdn
      domainOUPath: deploymentSettings!.domainOUPath
      endingIPAddress: deploymentSettings!.endingIPAddress
      keyVaultName: deploymentSettings!.keyVaultName
      networkIntents: deploymentSettings!.networkIntents
      startingIPAddress: deploymentSettings!.startingIPAddress
      storageConnectivitySwitchless: deploymentSettings!.storageConnectivitySwitchless
      storageNetworks: deploymentSettings!.storageNetworks
      subnetMask: deploymentSettings!.subnetMask
      bitlockerBootVolume: deploymentSettings!.?bitlockerBootVolume
      bitlockerDataVolumes: deploymentSettings!.?bitlockerDataVolumes
      credentialGuardEnforced: deploymentSettings!.?credentialGuardEnforced
      driftControlEnforced: deploymentSettings!.?driftControlEnforced
      drtmProtection: deploymentSettings!.?drtmProtection
      enableStorageAutoIp: deploymentSettings!.?enableStorageAutoIp
      episodicDataUpload: deploymentSettings!.?episodicDataUpload
      hvciProtection: deploymentSettings!.?hvciProtection
      isEuropeanUnionLocation: deploymentSettings!.?isRFEuropeanUnionLocation
      sideChannelMitigationEnforced: deploymentSettings!.?sideChannelMitigationEnforced
      smbClusterEncryption: deploymentSettings!.?smbClusterEncryption
      smbSigningEnforced: deploymentSettings!.?smbSigningEnforced
      storageConfigurationMode: deploymentSettings!.?storageConfigurationMode
      streamingDataClient: deploymentSettings!.?streamingDataClient
      wdacEnforced: deploymentSettings!.?wdacEnforced
    }
  }
]

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
output name string = cluster.name

@description('The ID of the cluster.')
output resourceId string = cluster.id

@description('The resource group of the cluster.')
output resourceGroupName string = resourceGroup().name

@description('The managed identity of the cluster.')
output systemAssignedMIPrincipalId string = cluster.identity.principalId

@description('The location of the cluster.')
output location string = cluster.location

// =============== //
//   Definitions   //
// =============== //

@export()
type networkIntentType = {
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

    @description('Required. The networkDirect configuration for the network adapters.')
    networkDirect: ('Enabled' | 'Disabled')

    @description('Required. The networkDirectTechnology configuration for the network adapters.')
    networkDirectTechnology: ('RoCEv2' | 'iWARP')
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
    @description('Required. The enableIov configuration for the network intent.')
    enableIov: ('true' | 'false')

    @description('Required. The loadBalancingAlgorithm configuration for the network intent.')
    loadBalancingAlgorithm: ('Dynamic' | 'HyperVPort' | 'IPHash')
  }

  @description('Required. The traffic types for the network intent.')
  trafficType: ('Compute' | 'Management' | 'Storage')[]
}

// define custom type for storage adapter IP info for 3-node switchless deployments
@export()
type storageAdapterIPInfoType = {
  @description('Required. The HCI node name.')
  physicalNode: string

  @description('Required. The IPv4 address for the storage adapter.')
  ipv4Address: string

  @description('Required. The subnet mask for the storage adapter.')
  subnetMask: string
}

// define custom type for storage network objects
@export()
type storageNetworksType = {
  @description('Required. The name of the storage adapter.')
  adapterName: string

  @description('Required. The VLAN for the storage adapter.')
  vlan: string

  @description('Optional. The storage adapter IP information for 3-node switchless or manual config deployments.')
  storageAdapterIPInfo: storageAdapterIPInfoType[]? // optional for switched deployments
}

// cluster security configuration settings
@export()
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

type deploymentSettingsType = {
  @minLength(4)
  @maxLength(8)
  @description('Required. The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.')
  deploymentPrefix: string

  @description('Required. Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2].')
  clusterNodeNames: array

  @description('Required. The domain name of the Active Directory Domain Services. Example: "contoso.com".')
  domainFqdn: string

  @description('Required. The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com".')
  domainOUPath: string

  @description('Optional. The Hypervisor-protected Code Integrity setting.')
  hvciProtection: bool?

  @description('Optional. The hardware-dependent Secure Boot setting.')
  drtmProtection: bool?

  @description('Optional. When set to true, the security baseline is re-applied regularly.')
  driftControlEnforced: bool?

  @description('Optional. Enables the Credential Guard.')
  credentialGuardEnforced: bool?

  @description('Optional. When set to true, the SMB default instance requires sign in for the client and server services.')
  smbSigningEnforced: bool?

  @description('Optional. When set to true, cluster east-west traffic is encrypted.')
  smbClusterEncryption: bool?

  @description('Optional. When set to true, all the side channel mitigations are enabled.')
  sideChannelMitigationEnforced: bool?

  @description('Optional. When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent.')
  bitlockerBootVolume: bool?

  @description('Optional. When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes.')
  bitlockerDataVolumes: bool?

  @description('Optional. Limits the applications and the code that you can run on your Azure Stack HCI cluster.')
  wdacEnforced: bool?

  // cluster diagnostics and telemetry configuration
  @description('Optional. The metrics data for deploying a HCI cluster.')
  streamingDataClient: bool?

  @description('Optional. The location data for deploying a HCI cluster.')
  isEuropeanUnionLocation: bool?

  @description('Optional. The diagnostic data for deploying a HCI cluster.')
  episodicDataUpload: bool?

  // storage configuration
  @description('Optional. The storage volume configuration mode. See documentation for details.')
  storageConfigurationMode: ('Express' | 'InfraOnly' | 'KeepStorage')?

  // cluster network configuration details
  @description('Required. The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.')
  subnetMask: string

  @description('Required. The default gateway of the Management Network. Example: 192.168.0.1.')
  defaultGateway: string

  @description('Required. The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
  startingIPAddress: string

  @description('Required. The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.')
  endingIPAddress: string

  @description('Required. The DNS servers accessible from the Management Network for the HCI cluster.')
  dnsServers: string[]

  @description('Required. An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.')
  networkIntents: array

  @description('Required. Specify whether the Storage Network connectivity is switched or switchless.')
  storageConnectivitySwitchless: bool

  @description('Optional. Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.')
  enableStorageAutoIp: bool?

  @description('Required. An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.')
  storageNetworks: array

  // other cluster configuration parameters
  @description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
  customLocationName: string

  @description('Required. The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.')
  clusterWitnessStorageAccountName: string

  @description('Required. The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.')
  keyVaultName: string

  @description('Optional. If using a shared key vault or non-legacy secret naming, pass the properties.cloudId guid from the pre-created HCI cluster resource.')
  cloudId: string?
}

@export()
@description('Key vault secret names interface')
type KeyVaultSecretNames = {
  @description('Required. The name of the Azure Stack HCI LCM user credential secret.')
  azureStackLCMUserCredential: string
  @description('Required. The name of the Azure Stack HCI local admin credential secret.')
  localAdminCredential: string
  @description('Required. The name of the Azure Stack HCI default ARB application secret.')
  defaultARBApplication: string
  @description('Required. The name of the Azure Stack HCI witness storage key secret.')
  witnessStorageKey: string
}
