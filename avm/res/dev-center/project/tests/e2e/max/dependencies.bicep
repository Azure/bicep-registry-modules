@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Required. The name of the Dev Center Network Connection to create.')
param devCenterNetworkConnectionName string

@description('Required. The name of the Dev Center Environment Type to create.')
param environmentTypeName string

@description('Required. The name of the first Managed Identity to create.')
param managedIdentity1Name string

@description('Required. The name of the second Managed Identity to create.')
param managedIdentity2Name string

@description('Required. The name of the custom role definition to create.')
param roleDefinitionName string

@description('Required. The name of the Key Vault to create.')
param keyVaultName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

var addressPrefix = '10.0.0.0/16'

resource managedIdentity1 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentity1Name
  location: location
}

resource managedIdentity2 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentity2Name
  location: location
}

resource devCenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: devCenterName
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity1.id}': {}
    }
  }
  location: location
  properties: {
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: 'Enabled'
    }
  }
}

resource environmentType 'Microsoft.DevCenter/devcenters/environmentTypes@2025-02-01' = {
  name: environmentTypeName
  parent: devCenter
  tags: {
    env: 'sandbox'
  }
  properties: {
    displayName: 'Sandbox'
  }
}

resource gallery 'Microsoft.DevCenter/devcenters/galleries@2025-02-01' existing = {
  name: 'Default'
  parent: devCenter
}

resource devboxDefinition 'Microsoft.DevCenter/devcenters/devboxdefinitions@2025-02-01' = {
  name: 'SandboxDevboxDefinition'
  parent: devCenter
  location: location
  properties: {
    imageReference: {
      id: '${gallery.id}/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    }
    sku: {
      name: 'general_i_8c32gb256ssd_v2'
    }
    hibernateSupport: 'Enabled'
  }
}

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(resourceGroup().id, 'DevCenterReader')
  properties: {
    roleName: roleDefinitionName
    description: 'Allows users to read Dev Center resources.'
    type: 'CustomRole'
    assignableScopes: [
      resourceGroup().id
    ]
    permissions: [
      {
        actions: [
          'Microsoft.DevCenter/devcenters/read'
        ]
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 0)
        }
      }
    ]
  }
}

resource devCenterNetworkConnection 'Microsoft.DevCenter/networkConnections@2025-02-01' = {
  name: devCenterNetworkConnectionName
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: virtualNetwork.properties.subnets[0].id
  }
}

resource devCenterNetworkConnectionAssociation 'Microsoft.DevCenter/devcenters/attachednetworks@2025-02-01' = {
  name: 'default'
  parent: devCenter
  properties: {
    networkConnectionId: devCenterNetworkConnection.id
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    softDeleteRetentionInDays: 7
    enableRbacAuthorization: true
  }

  resource secret 'secrets' = {
    name: 'testSecret'
    properties: {
      value: ''
    }
  }
}

resource keyPermissions 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('msi-${keyVault.id}-${location}-${keyVault::secret.id}-KeyVault-Secrets-User-RoleAssignment')
  scope: keyVault
  properties: {
    principalId: managedIdentity1.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '4633458b-17de-408a-b874-0445c86b69e6'
    ) // Key Vault Secrets User
    principalType: 'ServicePrincipal'
  }
}

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

@description('The name of the craeted Dev Center Attached Network Connection.')
output devCenterAttachedNetworkConnectionName string = devCenterNetworkConnectionAssociation.name

@description('The principal ID of the first created Managed Identity.')
output managedIdentity1PrincipalId string = managedIdentity1.properties.principalId

@description('The resource ID of the first created Managed Identity.')
output managedIdentity1ResourceId string = managedIdentity1.id

@description('The principal ID of the second created Managed Identity.')
output managedIdentity2PrincipalId string = managedIdentity2.properties.principalId

@description('The resource ID of the second created Managed Identity.')
output managedIdentity2ResourceId string = managedIdentity2.id

@description('The resource ID of the custom role definition.')
output roleDefinitionResourceId string = roleDefinition.id

@description('The ID of the created custom role definition.')
output roleDefinitionId string = roleDefinition.name

@description('The name of the Dev Center Devbox Definition.')
output devboxDefinitionName string = devboxDefinition.name

@description('The secret URI of the created Key Vault secret.')
output keyVaultSecretUri string = keyVault::secret.properties.secretUriWithVersion
