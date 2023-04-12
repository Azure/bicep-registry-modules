type StorageAccount = {
  name: _name
  location: _location?
  tags: _tags?
  sku: _sku
  kind: _kind
  extendedLocation: _extendedLocation?
  identity: _identity?
  properties: _properties
}

@minLength(3)
@maxLength(24)
type _name = string

@description('The location of the resource group to which the resource belongs.')
type _location = 'eastus' | 'eastus2' | 'westus' | 'westus2' | 'westcentralus' | 'westeurope' | 'southeastasia' | 'northeurope' | 'uksouth' | 'ukwest' | 'australiaeast' | 'australiasoutheast' | 'brazilsouth' | 'southindia' | 'centralindia' | 'westindia' | 'canadacentral' | 'canadaeast' | 'japaneast' | 'japanwest' | 'koreacentral' | 'koreasouth' | 'francecentral' | 'southafricanorth' | 'uaenorth' | 'switzerlandnorth' | 'germanywestcentral' | 'norwayeast'

@maxLength(128)
type _tag_key = string

@maxLength(256)
type _tag_value = string

@description('Tags are a list of key-value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. For example, the default experience for a template type is set with "defaultExperience": "Cassandra". Current "defaultExperience" values also include "Table", "Graph", "DocumentDB", and "MongoDB".')
@maxLength(15)
type _tags = {
  'key': _tag_key
  'value': _tag_value
}[]

@description('Gets or sets the SKU name. Required.')
type _sku = {
  name: _sku_name
}

@description('The SKU name. Required for account creation; optional for update. Note that in older versions, SKU name was called accountType.')
type _sku_name = 'Standard_LRS' | 'Standard_GRS' | 'Standard_RAGRS' | 'Standard_ZRS' | 'Premium_LRS'

@description('Indicates the type of storage account. Required.')
type _kind = 'Storage' | 'StorageV2' | 'BlobStorage' | 'FileStorage' | 'BlockBlobStorage'

@description('Set the extended location of the resource. If not set, the storage account will be created in Azure main region. Otherwise it will be created in the specified extended location')
type _extendedLocation = {
  name: _extendedLocation_name
  type: _extendedLocation_type
}

@description('The name of the extended location.')
type _extendedLocation_name = 'string'

@description('The type of the extended location.')
type _extendedLocation_type = 'EdgeZone'

@description('The identity of the resource.')
type _identity = {
  type: _identity_type
  userAssignedIdentities: _identity_userAssignedIdentities?
}

@description('The type of identity used for the resource. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the service.')
type _identity_type = 'None' | 'SystemAssigned' | 'SystemAssigned,UserAssigned' | 'UserAssigned'

@description('The list of user identities associated with the resource. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}".')
type _identity_userAssignedIdentities = {}

@description('The parameters used to create the storage account.')
type _properties = {
  accessTier: _accessTier?
  allowBlobPublicAccess: allowBlobPublicAccess?
  allowCrossTenantReplication: allowCrossTenantReplication?
  allowedCopyScope: allowedCopyScope?
  allowSharedKeyAccess: allowSharedKeyAccess?
  azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication?
  customDomain: customDomain?
  defaultToOAuthAuthentication: defaultToOAuthAuthentication?
  dnsEndpointType: dnsEndpointType?
  encryption: encryption?
  immutableStorageWithVersioning: immutableStorageWithVersioning?
  isHnsEnabled: isHnsEnabled?
  isLocalUserEnabled: isLocalUserEnabled?
  isNfsV3Enabled: isNfsV3Enabled?
  isSftpEnabled: isSftpEnabled?
  keyPolicy: keyPolicy?
  largeFileSharesState: largeFileSharesState?
  minimumTlsVersion: minimumTlsVersion?
  networkAcls: networkAcls?
  publicNetworkAccess: publicNetworkAccess?
  routingPreference: routingPreference?
  sasPolicy: sasPolicy?
  supportsHttpsTrafficOnly: supportsHttpsTrafficOnly?
}

@description('Required for storage accounts where kind = BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.')
type _accessTier = 'Hot' | 'Cool' | 'Premium'

@description('Allow or disallow public access to all blobs or containers in the storage account. The default interpretation is true for this property.')
type allowBlobPublicAccess = bool

@description('Allow or disallow cross AAD tenant object replication. The default interpretation is true for this property.')
type allowCrossTenantReplication = bool

@description('Restrict copy to and from Storage Accounts within an AAD tenant or with Private Links to the same VNet.')
type allowedCopyScope = 'AAD' | 'PrivateLink'

@description('Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). The default value is null, which is equivalent to true.')
type allowSharedKeyAccess = bool

@description('Provides the identity based authentication settings for Azure Files.')
type azureFilesIdentityBasedAuthentication = {
  activeDirectoryProperties: {
    accountType: 'string'
    azureStorageSid: 'string'
    domainGuid: 'string'
    domainName: 'string'
    domainSid: 'string'
    forestName: 'string'
    netBiosDomainName: 'string'
    samAccountName: 'string'
  }
  defaultSharePermission: 'string'
  directoryServiceOptions: 'string'
}

@description('The custom domain name assigned to the storage account by the user. Name is the CNAME source. Only one custom domain is supported per storage account at this time. To clear the existing custom domain, use an empty string for the custom domain name property.')
type customDomain = {
  name: 'string'
  useSubDomainName: bool
}

@description('Indicates whether default authentication with Azure Active Directory (Azure AD) is enabled for the storage account. The default value is true, this means that Azure AD authentication is enabled unless explicitly disabled when creating the storage account.')
type defaultToOAuthAuthentication = bool

@description('Indicates the type of DNS to be used.')
type dnsEndpointType = 'string'

@description('Provides the encryption settings on the account. The default setting is unencrypted.')
type encryption = {
  identity: {
    federatedIdentityClientId: 'string'
    userAssignedIdentity: 'string'
  }
  keySource: 'string'
  keyvaultproperties: {
    keyname: 'string'
    keyvaulturi: 'string'
    keyversion: 'string'
  }
  requireInfrastructureEncryption: bool
  services: {
    blob: {
      enabled: bool
      keyType: 'string'
    }
    file: {
      enabled: bool
      keyType: 'string'
    }
    queue: {
      enabled: bool
      keyType: 'string'
    }
    table: {
      enabled: bool
      keyType: 'string'
    }
  }
}

@description('Provides the immutable storage with versioning settings on the account.')
type immutableStorageWithVersioning = {
  enabled: bool
  immutabilityPolicy: {
    allowProtectedAppendWrites: bool
    immutabilityPeriodSinceCreationInDays: int
    state: 'string'
  }
}

@description('Indicates whether the storage account has Hierarchical Namespace enabled.')
type isHnsEnabled = bool

@description('Indicates whether the storage account has local user enabled.')
type isLocalUserEnabled = bool

@description('Indicates whether the storage account has NFSv3 enabled.')
type isNfsV3Enabled = bool

@description('Indicates whether the storage account has SFTP enabled.')
type isSftpEnabled = bool

@description('Provides the key policy rules on the account.')
type keyPolicy = {
  keyExpirationPeriodInDays: int
}

@description('Indicates whether large file shares is enabled.')
type largeFileSharesState = 'Disabled' | 'Enabled'

@description('Indicates the minimum TLS version to be permitted on requests to storage. The default interpretation is TLS 1.0 for this property.')
type minimumTlsVersion = 'TLS1_0' | 'TLS1_1' | 'TLS1_2'

@description('Provides the network ruleset for a storage account.')
type networkAcls = {
  bypass: 'string'
  defaultAction: 'string'
  ipRules: [
    {
      action: 'Allow'
      value: 'string'
    }
  ]
  resourceAccessRules: [
    {
      resourceId: 'string'
      tenantId: 'string'
    }
  ]
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: 'string'
      state: 'string'
    }
  ]
}

@description('Indicates whether or not public endpoint access is allowed for this storage account. The default interpretation is true for this property.')
type publicNetworkAccess = 'Enabled' | 'Disabled'

@description('Provides the routing choice between Internet and Microsoft network for data transfer.')
type routingPreference = {
  publishInternetEndpoints: bool
  publishMicrosoftEndpoints: bool
  routingChoice: 'string'
}

@description('Provides the Secure Access Signature (SAS) policy assigned to the storage account.')
type sasPolicy = {
  expirationAction: 'Log'
  sasExpirationPeriod: 'string'
}

@description('Indicates whether https traffic is required for the storage account.')
type supportsHttpsTrafficOnly = bool
