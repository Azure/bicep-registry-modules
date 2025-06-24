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

@description('Required. The deployment settings of the cluster.')
param deploymentSettings deploymentSettingsType

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

@description('Conditional. The service principal ID for ARB. Required if useSharedKeyVault is true and need ARB service principal id.')
param servicePrincipalId string?

@secure()
@description('Conditional. The service principal secret for ARB. Required if useSharedKeyVault is true and need ARB service principal id.')
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

@description('Optional. Key vault subscription ID, which is used for for storing secrets for the HCI cluster.')
param keyvaultSubscriptionId string?

@description('Optional. Key vault resource group, which is used for for storing secrets for the HCI cluster.')
param keyvaultResourceGroup string?

@description('Optional. Storage account subscription ID, which is used as the witness for the HCI Windows Failover Cluster.')
param witnessStorageAccountSubscriptionId string?

@description('Optional. Storage account resource group, which is used as the witness for the HCI Windows Failover Cluster.')
param witnessStorageAccountResourceGroup string?

@description('Required. The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the \'Microsoft.AzureStackHCI\' provider was registered in the subscription.')
@secure()
param hciResourceProviderObjectId string

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

var arcNodeResourceIds = [
  for (nodeName, index) in deploymentSettings!.clusterNodeNames: resourceId(
    'Microsoft.HybridCompute/machines',
    nodeName
  )
]

module secrets './secrets.bicep' = if (useSharedKeyVault) {
  name: '${uniqueString(deployment().name, location)}-secrets'
  scope: resourceGroup(
    keyvaultSubscriptionId ?? subscription().subscriptionId,
    keyvaultResourceGroup ?? resourceGroup().name
  )
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
    witnessStorageAccountResourceGroup: witnessStorageAccountResourceGroup ?? resourceGroup().name
    witnessStorageAccountSubscriptionId: witnessStorageAccountSubscriptionId ?? subscription().subscriptionId
    hciResourceProviderObjectId: hciResourceProviderObjectId
    arcNodeResourceIds: arcNodeResourceIds
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'temp-${name}'
  location: location
  tags: tags
}

// Contributor
resource roleAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, builtInRoleNames.Contributor, resourceGroup().id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: builtInRoleNames.Contributor
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Reader
resource roleAssignmentReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, builtInRoleNames.Reader, resourceGroup().id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: builtInRoleNames.Reader
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Role Based Access Control Administrator
resource roleAssignmentRBACAdmin 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(managedIdentity.id, builtInRoleNames['Role Based Access Control Administrator'], resourceGroup().id)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: builtInRoleNames['Role Based Access Control Administrator']
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Use deployment script to run the shell script
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'hci-deployment-script-${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.50.0'
    timeout: 'PT5H'
    retentionInterval: 'P1D'
    cleanupPreference: 'OnSuccess'
    environmentVariables: [
      {
        name: 'RESOURCE_GROUP_NAME'
        value: resourceGroup().name
      }
      {
        name: 'SUBSCRIPTION_ID'
        value: subscription().subscriptionId
      }
      {
        name: 'CLUSTER_NAME'
        value: cluster.name
      }
      {
        name: 'CLOUD_ID'
        value: cluster.properties.cloudId
      }
      {
        name: 'USE_SHARED_KEYVAULT'
        value: string(useSharedKeyVault)
      }
      {
        name: 'DEPLOYMENT_OPERATIONS'
        value: join(deploymentOperations, ',')
      }
      {
        name: 'HCI_RESOURCE_PROVIDER_OBJECT_ID'
        secureValue: hciResourceProviderObjectId
      }
      {
        name: 'DEPLOYMENT_SETTINGS'
        value: string(deploymentSettings)
      }
      {
        name: 'DEPLOYMENT_SETTING_BICEP_BASE64'
        value: base64(loadTextContent('./nested/deployment-setting.bicep'))
      }
      {
        name: 'DEPLOYMENT_SETTING_MAIN_BICEP_BASE64'
        value: base64(loadTextContent('./deployment-setting/main.bicep'))
      }
      {
        name: 'NEED_ARB_SECRET'
        value: empty(servicePrincipalId) || empty(servicePrincipalSecret) ? string(false) : string(true)
      }
    ]
    scriptContent: loadTextContent('./deploy.sh')
  }
  dependsOn: [
    secrets
    roleAssignmentContributor
    roleAssignmentReader
    roleAssignmentRBACAdmin
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

var managementNetworks = filter(deploymentSettings.networkIntents, n => contains(n.trafficType, 'Management'))
var managementIntentName = length(managementNetworks) > 0 ? managementNetworks[0].name : ''

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

@description('The name of the vSwitch.')
output vSwitchName string = 'ConvergedSwitch(${managementIntentName})'

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
    bandwidthPercentageSMB: string

    @description('Required. Recommend 7.')
    priorityValue8021ActionCluster: string

    @description('Required. Recommend 3.')
    priorityValue8021ActionSMB: string
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
  @description('Required. The name of the storage network.')
  name: string

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

@export()
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
  networkIntents: networkIntentType[]

  @description('Required. Specify whether the Storage Network connectivity is switched or switchless.')
  storageConnectivitySwitchless: bool

  @description('Optional. Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.')
  enableStorageAutoIp: bool?

  @description('Required. An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.')
  storageNetworks: storageNetworksType[]

  // other cluster configuration parameters
  @description('Required. The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.')
  customLocationName: string

  @description('Required. The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.')
  clusterWitnessStorageAccountName: string

  @description('Required. The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.')
  keyVaultName: string
}
