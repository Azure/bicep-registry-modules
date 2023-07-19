@description('Deployment Location')
param location string

@description('Prefix of Storage Account Resource Name. This param is ignored when name is provided.')
param prefix string = 'st'

@description('Name of Storage Account. Must be unique within Azure.')
param name string = '${prefix}${uniqueString(resourceGroup().id, subscription().id)}'

@description('Tags to be applied to the Storage Account.')
param tags { *: string } = {}

@description('Storage Account SKU.')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param sku string = 'Standard_LRS'

var isPremium = contains(sku, 'Premium')

@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
@description('Storage Account Kind.')
param kind string = 'StorageV2'

@description('The type of identity used for the storage account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the resource.')
@allowed([ 'None', 'SystemAssigned', 'SystemAssigned,UserAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities string[] = []

@description('''
The access tier of the storage account, which is used for billing.
Required for storage accounts where kind = BlobStorage. The 'Premium' access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.
''')
@allowed([
  'Cool'
  'Hot'
])
param accessTier string = 'Hot'

@description('Allow or disallow public access to all blobs or containers in the storage account.')
param allowBlobPublicAccess bool = false

@description('Replication of objects between AAD tenants is allowed or not. For this property, the default interpretation is true.')
param allowCrossTenantReplication bool = true

@description('Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.')
param allowedCopyScope {
  enable: bool
  @description('Required when enable=true.')
  scope: ('AAD' | 'PrivateLink')?
} = { enable: false }

@description('Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD).')
param allowSharedKeyAccess bool = true

@description('Provides the identity based authentication settings for Azure Files.')
param azureFilesIdentityBasedAuthentication azureFilesIdentityBasedAuthenticationType = { enable: false }

@description('A boolean flag which indicates whether the default authentication is OAuth or not.')
param defaultToOAuthAuthentication bool = false

@description('Allows you to specify the type of endpoint. Set this to AzureDNSZone to create a large number of accounts in a single subscription, which creates accounts in an Azure DNS Zone and the endpoint URL will have an alphanumeric DNS Zone identifier.')
@allowed([ 'AzureDnsZone', 'Standard' ])
param dnsEndpointType string = 'Standard'

@description('Encryption settings to be used for server-side encryption for the storage account.')
param encryption encryptionType = { enable: false }

@description('Account HierarchicalNamespace enabled if sets to true.')
param enableHns bool = false

@description('Enables local users feature, if set to true.')
param enableLocalUser bool = false

@description('NFS 3.0 protocol support enabled if set to true.')
param enableNfsV3 bool = false

@description('Enables Secure File Transfer Protocol, if set to true.')
param enableSftp bool = false

@description('Policies for the access keys of the storage account.')
param accessKeyPolicy accessKeyPolicyType = { enable: false }

@description('Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.')
param enablelargeFileShares bool = false

@description('Configuration for network access rules.')
param networkAcls networkAclsType = {
  defaultAction: 'Allow'
}

@description('Network routing choice for data transfer.')
param routingPreference routingPreferenceType = { routingChoice: 'MicrosoftRouting' }

@description('SasPolicy assigned to the storage account.')
param sasTokenPolicy sasTokenPolicyType = { enable: false }

@description('Allows https traffic only to storage service if sets to true.')
param supportHttpsTrafficOnly bool = true

@description('Allow or disallow public network access to Storage Account. Value is optional but if passed in, must be Enabled or Disabled.')
param enablePublicNetworkAccess bool = true

@description('Set the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Private Endpoints that should be created for the storage account.')
param privateEndpoints privateEndpointType[] = []

@description('Properties object for a Blob service of a Storage Account.')
param blobServiceProperties blobServicePropertiesType = {}

@description('Array of blob containers to be created for blobServices of Storage Account.')
param blobContainers blobContainerType[] = []

@description('Configuration for the blob inventory policy.')
param managementPolicyRules managementPolicyRuleType[] = []

@description('''
Configure object replication on a source storage accounts.
This config only applies to the current storage account managed by this module.
''')
param objectReplicationSourcePolicy objectReplicationSourcePolicyType[] = []

@description('''
Configure object replication on a destination storage accounts.
This config only applies to the current storage account managed by this module.
''')
param objectReplicationDestinationPolicy objectReplicationDestinationPolicyType[] = []

@description('Array of role assignment objects with Storage Account scope that contain the \'roleDefinitionIdOrName\', \'principalId\' and \'principalType\' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param storageRoleAssignments storageRoleAssignmentsType[] = []

@description('Array of role assignment objects with blobServices/containers scope that contain the \'containerName\', \'roleDefinitionIdOrName\', \'principalId\' and \'principalType\' to define RBAC role assignments on that resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param containerRoleAssignments containerRoleAssignmentsArray[] = []

var managementPolicyRulesWithDefaults = [for rule in managementPolicyRules: union(rule, {
    enabled: rule.?enabled ?? true
    type: 'Lifecycle'
  })]

var varNetworkAclsIpRules = [for ip in networkAcls.?ipAllowlist ?? []: { action: 'Allow', value: ip }]

var varNetworkAclsVirtualNetworkRules = [for subnet in networkAcls.?subnetIds ?? []: { action: 'Allow', id: subnet }]

var varNetworkAcls = {
  bypass: networkAcls.?bypass ?? 'AzureServices'
  defaultAction: networkAcls.defaultAction
  ipRules: varNetworkAclsIpRules
  resourceAccessRules: networkAcls.?resourceAccessRules
  virtualNetworkRules: varNetworkAclsVirtualNetworkRules
}

var objectReplicationDestinationPolicyWithName = [for policy in objectReplicationDestinationPolicy: union(policy, {
    sourceStorageAccountName: last(split(policy.sourceStorageAccountId, '/'))
  }
)]

var objectReplicationSourcePolicyWithName = [for policy in objectReplicationSourcePolicy: union(policy, {
    destinationStorageAccountName: last(split(policy.destinationStorageAccountId, '/'))
  }
)]

var builtInRoles = {
  // Generic useful roles
  Owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'

  // Storage Account specific roles
  'Avere Contributor': '4f8fab4f-1852-4a58-a46a-8eaf358af14a'
  'Avere Operator': 'c025889f-8102-4ebf-b32c-fc0c6f0c6bd9'
  'Backup Contributor': '5e467623-bb1f-42f4-a55d-6e525e11384b'
  'Backup Operator': '00c29273-979b-4161-815c-10b084fb9324'
  'Backup Reader': 'a795c7a0-d4a2-40c1-ae25-d81f01202912'
  'Classic Storage Account Contributor': '86e8f5dc-a6e9-4c67-9d15-de283e8eac25'
  'Classic Storage Account Key Operator Service Role': '985d6b00-f706-48f5-a6fe-d0ca12fb668d'
  'Data Box Contributor': 'add466c9-e687-43fc-8d98-dfcf8d720be5'
  'Data Box Reader': '028f4ed7-e2a9-465e-a8f4-9c0ffdfdc027'
  'Data Lake Analytics Developer': '47b7735b-770e-4598-a7da-8b91488b4c88'
  'Elastic SAN Owner': '80dcbedb-47ef-405d-95bd-188a1b4ac406'
  'Elastic SAN Reader': 'af6a70f8-3c9f-4105-acf1-d719e9fca4ca'
  'Elastic SAN Volume Group Owner': 'a8281131-f312-4f34-8d98-ae12be9f0d23'
  'Reader and Data Access': 'c12c1c16-33a1-487b-954d-41c89c60f349'
  'Storage Account Backup Contributor': 'e5e2a7ff-d759-4cd2-bb51-3152d37e2eb1'
  'Storage Account Contributor': '17d1049b-9a84-46fb-8f53-869881c3d3ab'
  'Storage Account Key Operator Service Role': '81a9662b-bebf-436f-a333-f67b29880f12'
  'Storage Blob Data Contributor': 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  'Storage Blob Data Owner': 'b7e6dc6d-f1e8-4753-8033-0f276bb0955b'
  'Storage Blob Data Reader': '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  'Storage Blob Delegator': 'db58b8e5-c6ad-4a2a-8342-4190687cbf4a'
  'Storage File Data SMB Share Contributor': '0c867c2a-1d8c-454a-a3db-ab2ea1bdc8bb'
  'Storage File Data SMB Share Elevated Contributor': 'a7264617-510b-434b-a828-9731dc254ea7'
  'Storage File Data SMB Share Reader': 'aba4ae5f-2193-4029-9191-0cb91df5e314'
  'Storage Queue Data Contributor': '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
  'Storage Queue Data Message Processor': '8a0f0c08-91a1-4084-bc3d-661d67233fed'
  'Storage Queue Data Message Sender': 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a'
  'Storage Queue Data Reader': '19e7f393-937e-4f77-808e-94535e297925'
  'Storage Table Data Contributor': '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'
  'Storage Table Data Reader': '76199698-9eea-4c19-bc75-cec21354c6b6'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: { name: sku }
  kind: kind
  identity: {
    type: identityType
    userAssignedIdentities: contains(identityType, 'UserAssigned') ? toObject(userAssignedIdentities, id => id, id => {}) : null
  }
  properties: union({
      accessTier: isPremium ? 'Premium' : accessTier
      allowBlobPublicAccess: allowBlobPublicAccess
      allowCrossTenantReplication: allowCrossTenantReplication
      allowSharedKeyAccess: allowSharedKeyAccess
      defaultToOAuthAuthentication: defaultToOAuthAuthentication
      dnsEndpointType: dnsEndpointType
      isHnsEnabled: enableHns
      isLocalUserEnabled: enableLocalUser
      isNfsV3Enabled: enableNfsV3
      isSftpEnabled: enableSftp
      largeFileSharesState: enablelargeFileShares ? 'Enabled' : 'Disabled'
      minimumTlsVersion: minimumTlsVersion
      networkAcls: varNetworkAcls
      publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
      routingPreference: routingPreference
      supportsHttpsTrafficOnly: supportHttpsTrafficOnly
    },
    allowedCopyScope.enable ? { allowedCopyScope: allowedCopyScope.scope } : {},
    encryption.enable ? { encryption: encryption.configurations } : {},
    accessKeyPolicy.enable ? { keyPolicy: accessKeyPolicy.keyExpirationPeriodInDays } : {},
    sasTokenPolicy.enable ? { sasPolicy: sasTokenPolicy.configurations } : {},
    azureFilesIdentityBasedAuthentication.enable ? { azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication.configurations } : {}
  )
}

resource managementpolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2022-09-01' = if (!empty(managementPolicyRulesWithDefaults)) {
  dependsOn: [ blobService ]
  name: 'default'
  parent: storageAccount
  properties: {
    policy: {
      rules: managementPolicyRulesWithDefaults
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageAccount
  properties: blobServiceProperties
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = [for container in blobContainers: {
  name: container.name
  parent: blobService
  properties: container.?properties ?? {}
}]

module storageAccount_objectReplicationSourcePolicy 'modules/objectReplicationPolicy.bicep' = [for policy in objectReplicationSourcePolicyWithName: {
  name: join([ storageAccount.name, 'to', policy.destinationStorageAccountName ], '-')
  params: {
    storageAccountName: storageAccount.name
    policy: union(policy, {
        id: policy.policyId
        type: 'source'
        sourceStorageAccountId: storageAccount.id
      })
  }
}]

module storageAccount_objectReplicationDestinationPolicy 'modules/objectReplicationPolicy.bicep' = [for policy in objectReplicationDestinationPolicyWithName: {
  name: join([ policy.sourceStorageAccountName, 'to', storageAccount.name ], '-')
  params: {
    storageAccountName: storageAccount.name
    policy: union(policy, {
        id: 'default'
        type: 'destination'
        destinationStorageAccountId: storageAccount.id
      })
  }
}]

module storageAccount_privateEndpoints 'modules/privateEndpoint.bicep' = [for endpoint in privateEndpoints: {
  name: uniqueString(storageAccount.id, endpoint.name)
  params: {
    targetResourceId: storageAccount.id
    location: location
    endpoint: endpoint
  }
}]

resource storageAccount_RoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for assignment in storageRoleAssignments: {
  scope: storageAccount

  name: guid(storageAccount.name, assignment.principalId, assignment.roleDefinitionIdOrName)
  properties: {
    description: assignment.?description ?? ''
    roleDefinitionId: contains(builtInRoles, assignment.roleDefinitionIdOrName) ? subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoles[assignment.roleDefinitionIdOrName]) : assignment.roleDefinitionIdOrName
    principalId: assignment.principalId
    principalType: assignment.?principalType
  }
}]

resource storageAccount_containerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for assignment in containerRoleAssignments: {
  dependsOn: [ blobContainer ]
  scope: blobContainer[indexOf(map(blobContainers, container => container.name), assignment.containerName)]

  name: guid(storageAccount.name, assignment.principalId, assignment.roleDefinitionIdOrName, assignment.containerName)
  properties: {
    description: assignment.?description ?? ''
    roleDefinitionId: contains(builtInRoles, assignment.roleDefinitionIdOrName) ? subscriptionResourceId('Microsoft.Authorization/roleDefinitions', builtInRoles[assignment.roleDefinitionIdOrName]) : assignment.roleDefinitionIdOrName
    principalId: assignment.principalId
    principalType: assignment.?principalType
  }
}]

@description('The name of the Storage Account resource')
output name string = name

@description('The ID of the Storage Account. Use this ID to reference the Storage Account in other Azure resource deployments.')
output id string = storageAccount.id

@description('Array of Object Replication Policy IDs and Object Replication PolicyID Rules for OR Policy')
output objectReplicationDestinationPolicyIdsAndRuleIds array = [for (policy, index) in objectReplicationDestinationPolicyWithName: {
  sourceStorageAccountName: policy.sourceStorageAccountName
  policyId: storageAccount_objectReplicationDestinationPolicy[index].outputs.policyId
  ruleIds: storageAccount_objectReplicationDestinationPolicy[index].outputs.ruleIds
}]

@description('The blob service properties for change feed events.')
type changeFeed = {
  enabled: bool
  @minValue(1)
  @maxValue(146000)
  @description('Indicates the duration of changeFeed retention in days. A null value indicates an infinite retention of the change feed.')
  retentionInDays: int?
}

type deleteRetentionPolicyType = {
  @description('This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used blob restore policy. This property only applies to blob service and does not apply to containers or file share.')
  allowPermanentDelete: bool
  @minValue(1)
  @maxValue(365)
  @description('Indicates the number of days that the deleted item should be retained.')
  days: int?
  enabled: bool
}

@description('Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.')
type cors = {
  corsRules: {
    @description('A list of headers allowed to be part of the cross-origin request.')
    allowedHeaders: string[]
    @description('A list of HTTP methods that are allowed to be executed by the origin.')
    allowedMethods: ('DELETE' | 'GET' | 'HEAD' | 'MERGE' | 'OPTIONS' | 'PATCH' | 'POST' | 'PUT')[]
    @description('A list of origin domains that will be allowed via CORS, or "*" to allow all domains')
    allowedOrigins: string[]
    @description('A list of response headers to expose to CORS clients.')
    exposedHeaders: string[]
    @description('The number of seconds that the client/browser should cache a preflight response.')
    maxAgeInSeconds: int
  }[]
}

@description('The blob service property to configure last access time based tracking policy.')
type lastAccessTimeTrackingPolicyType = {
  blobType: string[]?
  enable: bool
}

@description('The blob service property to configure last access time based tracking policy.')
type restorePolicy = {
  @description('how long this blob can be restored. It should be great than zero and less than DeleteRetentionPolicy.days.')
  days: int?
  enabled: bool
}

type blobContainerPropertiesType = {
  defaultEncryptionScope: string?
  denyEncryptionScopeOverride: bool?
  publicAccess: ('Blob' | 'Container' | 'None')?
}

type blobContainerType = {
  @minLength(3)
  @maxLength(63)
  name: string
  properties: blobContainerPropertiesType?
}

type activeDirectoryPropertiesType = {
  @description('Specifies the domain GUID.')
  domainGuid: string
  @description('Specifies the primary domain that the AD DNS server is authoritative for.')
  domainName: string
  @description('Specifies the Active Directory account type for Azure Storage.')
  accountType: ('Computer' | 'User')?
  @description('Specifies the security identifier (SID) for Azure Storage.')
  azureStorageSid: string?
  @description('Specifies the security identifier (SID) for domain.')
  domainSid: string?
  @description('Specifies the Active Directory forest to get.')
  forestName: string?
  @description('Specifies the NetBIOS domain name.')
  netBiosDomainName: string?
  @description('Specifies the Active Directory SAMAccountName for Azure Storage.')
  samAccountName: string?
}

type azureFilesIdentityBasedAuthenticationType = {
  enable: bool
  @description('Required when enable=true.')
  configurations: {
    @description('Required if directoryServiceOptions are AD, optional if they are AADKERB.')
    activeDirectoryProperties: activeDirectoryPropertiesType?
    @description('Default share permission for users using Kerberos authentication if RBAC role is not assigned.')
    defaultSharePermission: ('None' | 'StorageFileDataSmbShareContributor' | 'StorageFileDataSmbShareElevatedContributor' | 'StorageFileDataSmbShareReader')?
    @description('Indicates the directory service used. Note that this enum may be extended in the future.')
    directoryServiceOptions: ('AADDS' | 'AADKERB' | 'AD' | 'None')
  }?
}

type EncryptionIdentityType = {
  @description('ClientId of the multi-tenant application to be used in conjunction with the user-assigned identity for cross-tenant customer-managed-keys server-side encryption on the storage account.')
  federatedIdentityClientId: string?
  @description('Resource identifier of the UserAssigned identity to be associated with server-side encryption on the storage account.')
  userAssignedIdentity: string?
}

type encryptionKeyVaultPropertiesType = {
  @description('The name of KeyVault key.')
  keyName: string
  @description('The Uri of KeyVault.')
  keyVaultUri: string
  @description('The version of KeyVault key.')
  keyVersion: string
}

type encryptionServiceType = {
  @description('A boolean indicating whether or not the service encrypts the data as it is stored. Encryption at rest is enabled by default today and cannot be disabled.')
  enabled: bool
  @description('Encryption key type to be used for the encryption service. "Account" key type implies that an account-scoped encryption key will be used. "Service" key type implies that a default service key is used.')
  keyType: ('Account' | 'Service')?
}

type encryptionServicesType = {
  @description('The encryption function of the blob storage service.')
  blob: encryptionServiceType?
  @description('The encryption function of the file storage service.')
  file: encryptionServiceType?
  @description('The encryption function of the queue storage service.')
  queue: encryptionServiceType?
  @description('The encryption function of the table storage service.')
  table: encryptionServiceType?
}

type encryptionType = {
  enable: bool
  configurations: {
    @description('The identity to be used with service-side encryption at rest.')
    identity: EncryptionIdentityType?
    @description('Specifies the encryption keySource (provider).')
    keySource: ('Microsoft.Storage' | 'Microsoft.Keyvault')?
    @description('Properties provided by key vault.')
    keyVaultProperties: encryptionKeyVaultPropertiesType?
    @description('A boolean indicating whether or not the service applies a secondary layer of encryption with platform managed keys for data at rest.')
    requireInfrastructureEncryption: bool?
    @description('''
    List of services which enable encryption using customer-managed keys.
    Azure only support enabling either blob and file, queue and table, or all of them.
    ''')
    services: encryptionServicesType?
  }?
}

type networkAclsResourceAccessRuleType = {
  @description('Specifies the resource id of the resource to which the access rule applies.')
  resourceAccessRuleId: string
  @description('Specifies the tenant id of the resource to which the access rule applies.')
  tenantId: string
}

type networkAclsType = {
  @description('Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Possible values are any combination of Logging,Metrics,AzureServices (For example, "Logging, Metrics"), or None to bypass none of those traffics.')
  bypass: ('AzureServices' | 'Logging' | 'Metrics' | 'None')?
  @description('Specifies whether all network access is allowed or denied when no other rules match.')
  defaultAction: ('Allow' | 'Deny')
  @description('Specifies the IP or IP range in CIDR format to be allowed to connect. Only IPV4 address is allowed.')
  ipAllowlist: string[]?
  @description('Sets the resource access rules.')
  resourceAccessRules: networkAclsResourceAccessRuleType[]?
  @description('Sets the virtual network rules.')
  subnetIds: string[]?
}

type routingPreferenceType = {
  @description('A boolean flag which indicates whether internet routing storage endpoints are to be published.')
  publishInternetEndpoints: bool?
  @description('A boolean flag which indicates whether microsoft routing storage endpoints are to be published.')
  publishMicrosoftEndpoints: bool?
  @description('Routing Choice defines the kind of network routing opted by the user.')
  routingChoice: ('InternetRouting' | 'MicrosoftRouting')
}

type accessKeyPolicyType = {
  enable: bool
  @description('''
  Required when enable=true
  The key expiration period in days.''')
  keyExpirationPeriodInDays: int?

}

type sasTokenPolicyType = {
  enable: bool
  @description('Required when enable=true.')
  configurations: {
    expirationAction: ('log')
    @description('The SAS expiration period, DD.HH:MM:SS.')
    sasExpirationPeriod: string
  }?
}

type privateEndpointType = {
  @description('The name of the private endpoint.')
  name: string
  @description('The subnet that the private endpoint should be created in.')
  subnetId: string
  @description('The subresource name of the target Azure resource that private endpoint will connect to.')
  groupId: string
  @description('The ID of the private DNS zone in which private endpoint will register its private IP address.')
  privateDnsZoneId: string?
  @description('When set to true, users will need to manually approve the private endpoint connection request.')
  isManualApproval: bool?
  @description('Tags for the resource.')
  tags: { *: string }?
}

@description('The properties of a storage account’s Blob service.')
type blobServicePropertiesType = {
  changeFeed: changeFeed?
  containerDeleteRetentionPolicy: deleteRetentionPolicyType?
  cors: cors?
  deleteRetentionPolicy: deleteRetentionPolicyType?
  isVersioningEnabled: bool?
  lastAccessTimeTrackingPolicy: lastAccessTimeTrackingPolicyType?
  restorePolicy: restorePolicy?
}

type managementPolicyRuleType = {
  @description('A rule name can contain any combination of alpha numeric characters. Rule name is case-sensitive. It must be unique within a policy.')
  name: string
  enabled: bool?
  definition: managementPolicyRuleDefinitionType?
}

type managementPolicyRuleDefinitionType = {
  @description('An object that defines the action set.')
  actions: managementPolicyActionType
  @description('An object that defines the filter set.')
  filters: managementPolicyFilterType
}

type managementPolicyFilterType = {
  @description('An array of predefined enum values. Currently blockBlob supports all tiering and delete actions. Only delete actions are supported for appendBlob.')
  blobTypes: string[]
  @description('An array of strings for prefixes to be match.')
  prefixMatch: string[]?
  @description('An array of blob index tag based filters, there can be at most 10 tag filters')
  @maxLength(10)
  blobIndexMatch: managementPolicyTagFilterType[]?
}

type managementPolicyTagFilterType = {
  @description('This is the filter tag name, it can have 1 - 128 characters')
  @minLength(1)
  @maxLength(128)
  name: string
  @description('This is the comparison operator which is used for object comparison and filtering. Only == (equality operator) is currently supported')
  op: ('=')
  @description('This is the filter tag value field used for tag based filtering, it can have 0 - 256 characters.')
  @maxLength(256)
  value: string
}

type managementPolicyActionType = {
  @description('The management policy action for base blob.')
  baseBlob: managementPolicyBaseBlobType?
  @description('The management policy action for snapshot.')
  snapshot: managementPolicySnapShotAndVersionType?
  @description('The management policy action for version.')
  version: managementPolicySnapShotAndVersionType?
}

type managementPolicySnapShotAndVersionType = {
  @description('The function to delete the blob snapshot/version.')
  delete: managementPolicyDateAfterCreationType?
  tierToArchive: managementPolicyDateAfterCreationType?
  tierToCold: managementPolicyDateAfterCreationType?
  tierToCool: managementPolicyDateAfterCreationType?
  tierToHot: managementPolicyDateAfterCreationType?
}

type managementPolicyDateAfterCreationType = {
  @description('Value indicating the age in days after creation.')
  daysAfterCreationGreaterThan: int
  @description('Value indicating the age in days after last blob tier change time. This property is only applicable for tierToArchive actions and requires daysAfterCreationGreaterThan to be set for snapshots and blob version based actions. The blob will be archived if both the conditions are satisfied.')
  daysAfterLastTierChangeGreaterThan: int?
}

type managementPolicyBaseBlobType = {
  @description('This property enables auto tiering of a blob from cool to hot on a blob access. This property requires tierToCool.daysAfterLastAccessTimeGreaterThan.')
  enableAutoTierToHotFromCool: bool?
  delete: managementPolicyDateAfterModificationType?
  tierToArchive: managementPolicyDateAfterModificationType?
  tierToCold: managementPolicyDateAfterModificationType?
  tierToCool: managementPolicyDateAfterModificationType?
  tierToHot: managementPolicyDateAfterModificationType?
}

type managementPolicyDateAfterModificationType = {
  @description('Value indicating the age in days after blob creation.')
  daysAfterCreationGreaterThan: int?
  @description('Value indicating the age in days after last blob access. This property can only be used in conjunction with last access time tracking policy.')
  daysAfterLastAccessTimeGreaterThan: int?
  @description('Value indicating the age in days after last blob tier change time. This property is only applicable for tierToArchive actions and requires daysAfterModificationGreaterThan to be set for baseBlobs based actions. The blob will be archived if both the conditions are satisfied.')
  daysAfterLastTierChangeGreaterThan: int?
  @description('Value indicating the age in days after last modification.')
  daysAfterModificationGreaterThan: int?
}

type objectReplicationSourcePolicyType = {
  @description('The value of the policy ID returned from the matching policy of the destination account.')
  policyId: string
  @description('The ID of the destination storage account.')
  destinationStorageAccountId: string
  rules: objectReplicationSourceRuelType[]
}

type objectReplicationDestinationPolicyType = {
  @description('The ID of the source storage account.')
  sourceStorageAccountId: string
  rules: objectReplicationDestinationRuelType[]
}

type objectReplicationSourceRuelType = {
  @description('The values of the rule IDs returned from the matching policy of the destination account.')
  ruleId: string
  @description('Destination container name.')
  destinationContainer: string
  @description('Source container name.')
  sourceContainer: string
  filters: objectReplicationRuleFilterType?
}

type objectReplicationDestinationRuelType = {
  @description('Destination container name.')
  destinationContainer: string
  @description('Source container name.')
  sourceContainer: string
  filters: objectReplicationRuleFilterType?
}

type objectReplicationRuleFilterType = {
  @description('Filters the results to replicate only blobs whose names begin with the specified prefix..')
  prefixMatch: string[]?
  @description('''Blobs created after the time will be replicated to the destination.
  It must be in datetime format "yyyy-MM-ddTHH:mm:ssZ". Example: 2020-02-19T16:05:00Z.
  ''')
  minCreationTime: string?
}

type storageRoleAssignmentsType = {
  @description('Description of role assignment.')
  description: string?
  @description('The role definition ID, or the name of a built-in role from the list var.builtInRoles.')
  roleDefinitionIdOrName: string
  principalId: string
  @description('Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
  principalType: ('Device' | 'ForeignGroup' | 'Group' | 'ServicePrincipal' | 'User')?
}

type containerRoleAssignmentsArray = {
  @description('Description of role assignment.')
  description: string?
  @description('The role definition ID, or the name of a built-in role from the list var.builtInRoles.')
  roleDefinitionIdOrName: string
  principalId: string
  @description('Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
  principalType: ('Device' | 'ForeignGroup' | 'Group' | 'ServicePrincipal' | 'User')?
  containerName: string
}
