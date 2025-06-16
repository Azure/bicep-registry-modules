@description('Required. The name of the Dev Center.')
param devCenterName string

@description('Required. The name of the Dev Center Environment Type to create.')
param environmentTypeName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource devCenter 'Microsoft.DevCenter/devcenters@2025-02-01' = {
  name: devCenterName
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
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

@description('The resource ID of the created DevCenter.')
output devCenterResourceId string = devCenter.id

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The name of the Dev Center Devbox Definition.')
output devboxDefinitionName string = devboxDefinition.name
