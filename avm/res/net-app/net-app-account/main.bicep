metadata name = 'Azure NetApp Files'
metadata description = 'This module deploys an Azure NetApp File.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the NetApp account.')
param name string

@description('Optional. Fully Qualified Active Directory DNS Domain Name (e.g. \'contoso.com\').')
param domainName string = ''

@description('Optional. Required if domainName is specified. Username of Active Directory domain administrator, with permissions to create SMB server machine account in the AD domain.')
param domainJoinUser string = ''

@description('Optional. Required if domainName is specified. Password of the user specified in domainJoinUser parameter.')
@secure()
param domainJoinPassword string = ''

@description('Optional. Used only if domainName is specified. LDAP Path for the Organization Unit (OU) where SMB Server machine accounts will be created (i.e. \'OU=SecondLevel,OU=FirstLevel\').')
param domainJoinOU string = ''

@description('Optional. Required if domainName is specified. Comma separated list of DNS server IP addresses (IPv4 only) required for the Active Directory (AD) domain join and SMB authentication operations to succeed.')
param dnsServers string = ''

@description('Optional. Required if domainName is specified. NetBIOS name of the SMB server. A computer account with this prefix will be registered in the AD and used to mount volumes.')
param smbServerNamePrefix string = ''

@description('Optional. Capacity pools to create.')
param capacityPools array = []

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Tags for all resources.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

var activeDirectoryConnectionProperties = [
  {
    username: !empty(domainName) ? domainJoinUser : null
    password: !empty(domainName) ? domainJoinPassword : null
    domain: !empty(domainName) ? domainName : null
    dns: !empty(domainName) ? dnsServers : null
    smbServerName: !empty(domainName) ? smbServerNamePrefix : null
    organizationalUnit: !empty(domainJoinOU) ? domainJoinOU : null
  }
]

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  'User Access Administrator': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2022-11-01' = {
  name: name
  tags: tags
  identity: identity
  location: location
  properties: {
    activeDirectories: !empty(domainName) ? activeDirectoryConnectionProperties : null
  }
}

resource netAppAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: netAppAccount
}

resource netAppAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(netAppAccount.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: netAppAccount
}]

module netAppAccount_capacityPools 'capacity-pool/main.bicep' = [for (capacityPool, index) in capacityPools: {
  name: '${uniqueString(deployment().name, location)}-ANFAccount-CapPool-${index}'
  params: {
    netAppAccountName: netAppAccount.name
    name: capacityPool.name
    location: location
    size: capacityPool.size
    serviceLevel: contains(capacityPool, 'serviceLevel') ? capacityPool.serviceLevel : 'Standard'
    qosType: contains(capacityPool, 'qosType') ? capacityPool.qosType : 'Auto'
    volumes: contains(capacityPool, 'volumes') ? capacityPool.volumes : []
    coolAccess: contains(capacityPool, 'coolAccess') ? capacityPool.coolAccess : false
    roleAssignments: contains(capacityPool, 'roleAssignments') ? capacityPool.roleAssignments : []
    encryptionType: contains(capacityPool, 'encryptionType') ? capacityPool.encryptionType : 'Single'
    tags: capacityPool.?tags ?? tags
    enableDefaultTelemetry: enableReferencedModulesTelemetry
  }
}]

@description('The name of the NetApp account.')
output name string = netAppAccount.name

@description('The Resource ID of the NetApp account.')
output resourceId string = netAppAccount.id

@description('The name of the Resource Group the NetApp account was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = netAppAccount.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?
