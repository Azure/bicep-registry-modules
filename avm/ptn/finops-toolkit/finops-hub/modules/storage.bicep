//==============================================================================
// Parameters
//==============================================================================
@description('Optional. Azure location where all resources should be created. See https://aka.ms/azureregions. Default: (resource group location).')
param location string = resourceGroup().location

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
])
@description('Optional. Storage SKU to use. LRS = Lowest cost, ZRS = High availability. Note Standard SKUs are not available for Data Lake gen2 storage. Allowed: Premium_LRS, Premium_ZRS. Default: Premium_LRS.')
param sku string = 'Premium_LRS'

@description('Optional. Tags to apply to all resources. We will also add the cm-resource-parent tag for improved cost roll-ups in Cost Management.')
param tags object?

@description('Optional. Tags to apply to resources based on their resource type. Resource type specific tags will be merged with tags for all resources.')
param tagsByResource object = {}

@description('Optional. List of scope IDs to create exports for.')
param exportScopes array = []

@description('The name of the container used for configuration settings.')
param configContainer string = 'config'

@description('The name of the container used for Cost Management exports.')
param exportContainer string = 'exports'

@description('The name of the container used for normalized data ingestion.')
param ingestionContainer string = 'ingestion'

@description('Optional. Name of the storage account.')
param storageAccountName string = ''

@description('Optional. The version of the FTK to use.')
param ftkVersion string = ''

//==============================================================================
// Resources
//==============================================================================

module storageAccount 'br/public:avm/res/storage/storage-account:0.8.3' = {
  name: '${uniqueString(deployment().name, location)}-storage'
  params: {
    name: storageAccountName
    skuName: sku
    kind: 'BlockBlobStorage'
    tags: union(tags ?? {}, tagsByResource[?'Microsoft.Storage/storageAccounts'] ?? {})
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Enabled'
    enableHierarchicalNamespace: true
    blobServices: {
      containers: [
        {
          name: configContainer
          publicAccess: 'None'
          metadata: {}
        }
        {
          name: exportContainer
          publicAccess: 'None'
          metadata: {}
        }
        {
          name: ingestionContainer
          publicAccess: 'None'
          metadata: {}
        }
      ]
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
        principalId: identity.properties.principalId
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: 'e40ec5ca-96e0-45a2-b4ff-59039f2c2b59'
        principalId: identity.properties.principalId
        principalType: 'ServicePrincipal'
      }
    ]
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

//------------------------------------------------------------------------------
// Settings.json
//------------------------------------------------------------------------------

// Create managed identity to upload files
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${storageAccountName}_blobManager'
  tags: union(tags ?? {}, tagsByResource[?'Microsoft.ManagedIdentity/userAssignedIdentities'] ?? {})
  location: location
}

module uploadSettings 'br/public:avm/res/resources/deployment-script:0.2.0' = {
  name: '${uniqueString(deployment().name, location)}-uploadSettings'
  params: {
    name: 'uploadSettings'
    kind: 'AzurePowerShell'
    location: startsWith(location, 'china') ? 'chinaeast2' : location
    tags: union(tags ?? {}, tagsByResource[?'Microsoft.Resources/deploymentScripts'] ?? {})
    managedIdentities: {
      userAssignedResourcesIds: [
        identity.id
      ]
    }
    azPowerShellVersion: '9.7'
    retentionInterval: 'PT1H'
    environmentVariables: {
      secureList: [
        {
          name: 'ftkVersion'
          value: ftkVersion
        }
        {
          name: 'exportScopes'
          value: join(exportScopes, '|')
        }
        {
          name: 'storageAccountName'
          value: storageAccountName
        }
        {
          name: 'containerName'
          value: 'config'
        }
      ]
    }
    scriptContent: loadTextContent('./scripts/Copy-FileToAzureBlob.ps1')
  }
}

//==============================================================================
// Outputs
//==============================================================================

@description('The resource ID of the storage account.')
output resourceId string = storageAccount.outputs.resourceId

@description('The name of the storage account.')
output name string = storageAccount.outputs.name
