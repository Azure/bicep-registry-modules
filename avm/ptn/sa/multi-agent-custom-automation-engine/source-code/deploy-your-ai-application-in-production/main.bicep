targetScope = 'resourceGroup'

@minLength(3)
@maxLength(12)
@description('The name of the environment/application. Use alphanumeric characters only.')
param name string

@description('Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string

@description('Optional. Specifies the connections to be created for the Azure AI Hub workspace. The connections are used to connect to other Azure resources and services.')
param connections connectionType[] = []

@description('Optional. Specifies the OpenAI deployments to create.')
param aiModelDeployments deploymentsType[] = []

@description('Specifies whether creating an Azure Container Registry.')
param acrEnabled bool 

@description('Specifies the size of the jump-box Virtual Machine.')
param vmSize string = 'Standard_DS4_v2'

@minLength(3)
@maxLength(20)
@description('Specifies the name of the administrator account for the jump-box virtual machine. Defaults to "[name]vmuser". This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion.')
param vmAdminUsername string = '${name}vmuser'

@minLength(4)
@maxLength(70)
@description('Specifies the password for the jump-box virtual machine. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. Value should be meet 3 of the following: uppercase character, lowercase character, numberic digit, special character, and NO control characters.')
@secure()
param vmAdminPasswordOrKey string

@description('Optional. Specifies the resource tags for all the resoources. Tag "zad-env-name" is automatically added to all resources.')
param tags object = {}

@description('Specifies the object id of a Microsoft Entra ID user. In general, this the object id of the system administrator who deploys the Azure resources. This defaults to the deploying user.')
param userObjectId string = deployer().objectId

@description('Optional IP address to allow access to the jump-box VM. This is necessary to provide secure access to the private VNET via a jump-box VM with Bastion. If not specified, all IP addresses are allowed.')
param allowedIpAddress string = ''

@description('Specifies if Microsoft APIM is deployed.')
param apiManagementEnabled bool 

@description('Specifies the publisher email for the API Management service. Defaults to admin@[name].com.')
param apiManagementPublisherEmail string = 'admin@${name}.com'

@description('Specifies whether network isolation is enabled. When true, Foundry and related components will be deployed, network access parameters will be set to Disabled.')
param networkIsolation bool = true

@description('Whether to include Cosmos DB in the deployment.')
param cosmosDbEnabled bool 

@description('Optional. List of Cosmos DB databases to deploy.')
param cosmosDatabases sqlDatabaseType[] = []

@description('Whether to include SQL Server in the deployment.')
param sqlServerEnabled bool 

@description('Optional. List of SQL Server databases to deploy.')
param sqlServerDatabases databasePropertyType[] = []

var defaultTags = {
  'azd-env-name': name
}
var allTags = union(defaultTags, tags)

var resourceToken = substring(uniqueString(subscription().id, location, name), 0, 5)
var servicesUsername = take(replace(vmAdminUsername,'.', ''), 20)

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.0' = {
  name: take('${name}-log-analytics-deployment', 64)
  params: {
    name: toLower('log-${name}')
    location: location
    tags: allTags
    skuName: 'PerNode'
    dataRetention: 60
  }
}

module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: take('${name}-app-insights-deployment', 64)
  params: {
    name: toLower('appi-${name}')
    location: location
    tags: allTags
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

module keyvault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: take('${name}-keyvault-deployment', 64)
  params: {
    name: take(toLower('kv${name}${resourceToken}'), 24)
    location: location
    tags: allTags
    publicNetworkAccess: networkIsolation ?  'Disabled' : 'Enabled'
    networkAcls: {
     defaultAction: 'Allow'
    }
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    diagnosticSettings:[
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      } 
    ]
    roleAssignments: empty(userObjectId) ? [] : [
      {
        principalId: userObjectId
        principalType: 'User'
        roleDefinitionIdOrName: 'Key Vault Secrets User'
      }
    ]
  }
}

module containerRegistry 'br/public:avm/res/container-registry/registry:0.8.4' = if (acrEnabled) {
  name: take('${name}-container-registry-deployment', 64)
  params: {
    name: take(toLower('cr${name}${resourceToken}'), 50)
    location: location
    tags: allTags
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    anonymousPullEnabled: false
    dataEndpointEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSetDefaultAction: networkIsolation ? 'Deny' : 'Allow'
    exportPolicyStatus: networkIsolation ? 'disabled' : 'enabled'
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled' 
    zoneRedundancy: 'Disabled'
    managedIdentities: {
      systemAssigned: true
    }
    diagnosticSettings:[
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      } 
    ]
  }
}

module storageAccount 'br/public:avm/res/storage/storage-account:0.17.0' = {
  name: take('${name}-storage-account-deployment', 64)
  params: {
    name: take(toLower('st${name}${resourceToken}'), 24)
    location: location
    tags: allTags
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    roleAssignments: union(empty(userObjectId) ? [] : [
      {
        principalId: userObjectId
        principalType: 'User'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ], [
      {
        principalId: aiServices.outputs.?systemAssignedMIPrincipalId ?? ''
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
      {
        principalId: aiSearch.outputs.?systemAssignedMIPrincipalId ?? ''
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
      }
    ])
  }
}

module aiServices 'br/public:avm/res/cognitive-services/account:0.10.1' = {
  name: take('${name}-ai-services-deployment', 64)
  params: {
    name: toLower('cog${name}${resourceToken}')
    location: location
    tags: allTags
    sku: 'S0'
    kind: 'AIServices'
    managedIdentities: {
      systemAssigned: true
    }
    deployments: aiModelDeployments
    customSubDomainName: toLower('cog${name}${resourceToken}')
    disableLocalAuth: networkIsolation
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    diagnosticSettings:[
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      } 
    ]
    roleAssignments: empty(userObjectId) ? [] : [
      {
        principalId: userObjectId
        principalType: 'User'
        roleDefinitionIdOrName: 'Cognitive Services OpenAI Contributor'
      }
    ]
  }
}

module aiSearch 'br/public:avm/res/search/search-service:0.9.0' = {
  name: take('${name}-search-services-deployment', 64)
  params: {
      name: take(toLower('srch${name}${resourceToken}'), 60)
      location: location
      cmkEnforcement: 'Enabled'
      managedIdentities: {
        systemAssigned: true
      }
      publicNetworkAccess: 'Disabled'
      disableLocalAuth: true
      sku: 'standard'
      partitionCount:1
      replicaCount:3
      roleAssignments: union(empty(userObjectId) ? [] : [
        {
          principalId: userObjectId
          principalType: 'User'
          roleDefinitionIdOrName: 'Search Index Data Contributor'
        }
      ], [
        {
          principalId: aiServices.outputs.?systemAssignedMIPrincipalId ?? ''
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Search Index Data Contributor'
        }
        {
          principalId: aiServices.outputs.?systemAssignedMIPrincipalId ?? ''
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Search Service Contributor'
        }
      ])
      diagnosticSettings: [
        {
          workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        }
      ]
      tags: allTags
  }
}

module network './modules/virtualNetwork.bicep' = if (networkIsolation) {  
  name: take('${name}-network-deployment', 64)
  params: {
    virtualNetworkName: toLower('vnet-${name}')
    virtualNetworkAddressPrefixes: '10.0.0.0/8'
    vmSubnetName: toLower('snet-${name}-vm')
    vmSubnetAddressPrefix: '10.3.1.0/24'
    vmSubnetNsgName: toLower('nsg-snet-${name}-vm')
    bastionHostEnabled: true
    bastionSubnetAddressPrefix: '10.3.2.0/24'
    bastionSubnetNsgName: 'nsg-AzureBastionSubnet'
    bastionHostName: toLower('bas-${name}')
    bastionHostDisableCopyPaste: false
    bastionHostEnableFileCopy: true
    bastionHostEnableIpConnect: true
    bastionHostEnableShareableLink: true
    bastionHostEnableTunneling: true
    bastionPublicIpAddressName: toLower('pip-bas-${name}')
    bastionHostSkuName: 'Standard'
    natGatewayName: toLower('nat-${name}')
    natGatewayPublicIps: 1
    natGatewayIdleTimeoutMins: 30
    allowedIpAddress: allowedIpAddress
    workspaceId: logAnalyticsWorkspace.outputs.resourceId
    location: location
    tags: allTags
  }
}

module virtualMachine './modules/virtualMachine.bicep' = if (networkIsolation)  {
  name: take('${name}-virtual-machine-deployment', 64)
  params: {
    vmName: toLower('vm-${name}-jump')
    vmNicName: toLower('nic-vm-${name}-jump')
    vmSize: vmSize
    vmSubnetId: network.outputs.vmSubnetId
    storageAccountName: storageAccount.outputs.name
    storageAccountResourceGroup: resourceGroup().name
    imagePublisher: 'MicrosoftWindowsDesktop'
    imageOffer: 'Windows-11'
    imageSku: 'win11-23h2-ent'
    authenticationType: 'password'
    vmAdminUsername: servicesUsername
    vmAdminPasswordOrKey: vmAdminPasswordOrKey
    diskStorageAccountType: 'Premium_LRS'
    numDataDisks: 1
    osDiskSize: 128
    dataDiskSize: 50
    dataDiskCaching: 'ReadWrite'
    enableAcceleratedNetworking: true
    enableMicrosoftEntraIdAuth: true
    userObjectId: userObjectId
    workspaceId: logAnalyticsWorkspace.outputs.resourceId
    location: location
    tags: allTags
  }
  dependsOn: networkIsolation ? [storageAccount] : []
}

module aiHub 'br/public:avm/res/machine-learning-services/workspace:0.10.1' = {
  name: take('${name}-ai-hub-deployment', 64)
  dependsOn: acrEnabled ? [containerRegistry] : []
  params: {
    name: toLower('hub-${name}')
    sku: 'Standard'
    kind: 'Hub'
    description: toLower('hub-${name}')
    associatedApplicationInsightsResourceId: applicationInsights.outputs.resourceId
    associatedContainerRegistryResourceId: acrEnabled ? containerRegistry.outputs.resourceId : null
    associatedKeyVaultResourceId: keyvault.outputs.resourceId
    associatedStorageAccountResourceId: storageAccount.outputs.resourceId
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    managedNetworkSettings: {
      isolationMode: networkIsolation ? 'AllowInternetOutbound' : 'Disabled'
    }
    connections: union(connections, [
      {
        name: toLower('${aiServices.outputs.name}-connection')
        category: 'AIServices'
        target: aiServices.outputs.endpoint
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure'
          ResourceId: aiServices.outputs.resourceId
        }
      }
      {
        name: toLower('${aiSearch.outputs.name}-connection')
        category: 'CognitiveSearch'
        target: 'https://${aiSearch.outputs.name}.search.windows.net/'
        connectionProperties: {
          authType: 'AAD'
        }
        isSharedToAll: true
        metadata: {
          ApiType: 'Azure' 
          ResourceId: aiSearch.outputs.resourceId
        }
      }
    ])
    roleAssignments: empty(userObjectId) ? [] : [
      {
        roleDefinitionIdOrName: 'f6c7c914-8db3-469d-8ca1-694a8f32e121' // ML Data Scientist Role
        principalId: userObjectId
        principalType: 'User'
      }
    ]
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        logCategoriesAndGroups: [
          {
            category: 'ComputeInstanceEvent'
          }
        ]
      }
    ]
    location: location
    systemDatastoresAuthMode: 'identity'
    tags: allTags
  }
}

var aiProjectLogCategories = [
  'AmlComputeClusterEvent'
  'AmlComputeClusterNodeEvent'
  'AmlComputeJobEvent'
  'AmlComputeCpuGpuUtilization'
  'AmlRunStatusChangedEvent'
  'ModelsChangeEvent'
  'ModelsReadEvent'
  'ModelsActionEvent'
  'DeploymentReadEvent'
  'DeploymentEventACI'
  'DeploymentEventAKS'
  'InferencingOperationAKS'
  'InferencingOperationACI'
  'EnvironmentChangeEvent'
  'EnvironmentReadEvent'
  'DataLabelChangeEvent'
  'DataLabelReadEvent'
  'DataSetChangeEvent'
  'DataSetReadEvent'
  'PipelineChangeEvent'
  'PipelineReadEvent'
  'RunEvent'
  'RunReadEvent'
]

module aiProject 'br/public:avm/res/machine-learning-services/workspace:0.10.1' = {
  name: take('${name}-ai-project-deployment', 64)
  params: {
    name: toLower('proj-${name}')
    sku: 'Standard'
    kind: 'Project'
    location: location
    hubResourceId: aiHub.outputs.resourceId
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    hbiWorkspace: false
    systemDatastoresAuthMode: 'identity'
    roleAssignments: union(empty(userObjectId) ? [] : [
      {
        roleDefinitionIdOrName: 'f6c7c914-8db3-469d-8ca1-694a8f32e121' // ML Data Scientist Role
        principalId: userObjectId
        principalType: 'User'
      }
    ], [
      {
        roleDefinitionIdOrName: 'f6c7c914-8db3-469d-8ca1-694a8f32e121' // ML Data Scientist Role
        principalId: aiServices.outputs.?systemAssignedMIPrincipalId ?? ''
        principalType: 'ServicePrincipal'
      }
    ])
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        logCategoriesAndGroups: [for log in aiProjectLogCategories: {
          category: log
        }]
      }
    ]
    tags: allTags
  }
}

module apiManagementService 'br/public:avm/res/api-management/service:0.8.0' = if (apiManagementEnabled) {
  name: take('${name}-apim-deployment', 64)
  params: {
    name: toLower('apim${name}${resourceToken}')
    location: location
    tags: allTags
    sku: 'Developer'
    publisherEmail: apiManagementPublisherEmail
    publisherName: '${name} API Management'
    virtualNetworkType: networkIsolation ? 'Internal' : 'None'
    managedIdentities: {
      systemAssigned: true
    }
    apis: [
      {
        apiVersionSet: {
          name: 'echo-version-set'
          properties: {
            description: 'An echo API version set'
            displayName: 'Echo version set'
            versioningScheme: 'Segment'
          }
        }
        description: 'An echo API service'
        displayName: 'Echo API'
        name: 'echo-api'
        path: 'echo'
        protocols: [
          'https'
        ]
        serviceUrl: 'https://echoapi.cloudapp.net/api'
      }
    ]
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'True'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
    }
    diagnosticSettings: [
      {
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    products: [
      {
        apis: [
          {
            name: 'echo-api'
          }
        ]
        approvalRequired: true
        description: 'This is an echo API'
        displayName: 'Echo API'
        groups: [
          {
            name: 'developers'
          }
        ]
        name: 'Starter'
        subscriptionRequired: true
        terms: 'By accessing or using the services provided by Echo API through Azure API Management, you agree to be bound by these Terms of Use. These terms may be updated from time to time, and your continued use of the services constitutes acceptance of any changes.'
      }
    ]
    subscriptions: [
      {
        displayName: 'testArmSubscriptionAllApis'
        name: 'testArmSubscriptionAllApis'
        scope: '/apis'
      }
    ]
  }
}

module cosmosdb 'modules/cosmosDb.bicep' = if (cosmosDbEnabled && networkIsolation) {
  name: take('${name}-cosmosdb-deployment', 64)
  params: {
    name: toLower('cos${name}${resourceToken}')
    databases: cosmosDatabases
    location: location
    virtualNetworkResourceId: network.outputs.virtualNetworkId
    virtualNetworkSubnetResourceId: network.outputs.vmSubnetId
    storageAccountResourceId: storageAccount.outputs.resourceId
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    tags: allTags
  }
}

module sqlServer 'modules/sqlServer.bicep' = if (sqlServerEnabled && networkIsolation) {
  name: take('${name}-sqlserver-deployment', 64)
  params: {
    name: toLower('sql${name}${resourceToken}')
    location: location
    adminUsername: servicesUsername
    adminPassword: vmAdminPasswordOrKey
    databases: sqlServerDatabases
    virtualNetworkResourceId: network.outputs.virtualNetworkId
    virtualNetworkSubnetResourceId: network.outputs.vmSubnetId
    tags: allTags
  }
}

module privateEndpoints './modules/privateEndpoints.bicep' = if (networkIsolation) {
  name: take('${name}-private-endpoints-deployment', 64)
  params: {
    subnetId: network.outputs.vmSubnetId
    blobStorageAccountPrivateEndpointName: toLower('pep-${storageAccount.outputs.name}-blob')
    fileStorageAccountPrivateEndpointName: toLower('pep-${storageAccount.outputs.name}-file')
    keyVaultPrivateEndpointName: toLower('pep-${keyvault.outputs.name}')
    acrPrivateEndpointName: acrEnabled ? toLower('pep-${containerRegistry.outputs.name}') : ''
    storageAccountId: storageAccount.outputs.resourceId
    keyVaultId: keyvault.outputs.resourceId
    acrId: acrEnabled ? containerRegistry.outputs.resourceId : ''
    hubWorkspacePrivateEndpointName: toLower('pep-${aiHub.outputs.name}')
    hubWorkspaceId: aiHub.outputs.resourceId
    aiServicesPrivateEndpointName: toLower('pep-${aiServices.outputs.name}')
    aiServicesId: aiServices.outputs.resourceId
    apiManagementPrivateEndpointName: apiManagementEnabled ? (toLower('pep-${apiManagementService.outputs.name}')) : ''
    apiManagementId: apiManagementEnabled ? apiManagementService.outputs.resourceId : ''
    aiSearchId: aiSearch.outputs.resourceId
    aiSearchPrivateEndpointName: toLower('pep-${aiSearch.outputs.name}')
    location: location
    tags: allTags
  }
  dependsOn: networkIsolation ? [apiManagementService] : []
}

import { sqlDatabaseType, databasePropertyType, deploymentsType } from 'modules/customTypes.bicep'
import { connectionType } from 'br/public:avm/res/machine-learning-services/workspace:0.10.1'

output AZURE_KEY_VAULT_NAME string = keyvault.outputs.name
output AZURE_AI_SERVICES_NAME string = aiServices.outputs.name
output AZURE_AI_SEARCH_NAME string = aiSearch.outputs.name
output AZURE_AI_HUB_NAME string = aiHub.outputs.name
output AZURE_AI_PROJECT_NAME string = aiHub.outputs.name
output AZURE_BASTION_NAME string = networkIsolation ? network.outputs.bastionName : ''
output AZURE_VM_RESOURCE_ID string = networkIsolation ? virtualMachine.outputs.id : ''
output AZURE_VM_USERNAME string = servicesUsername
output AZURE_APP_INSIGHTS_NAME string = applicationInsights.outputs.name
output AZURE_CONTAINER_REGISTRY_NAME string = acrEnabled ? containerRegistry.outputs.name : ''
output AZURE_LOG_ANALYTICS_WORKSPACE_NAME string = logAnalyticsWorkspace.outputs.name
output AZURE_STORAGE_ACCOUNT_NAME string = storageAccount.outputs.name
output AZURE_API_MANAGEMENT_NAME string = apiManagementEnabled ? apiManagementService.outputs.name : ''
output AZURE_VIRTUAL_NETWORK_NAME string = networkIsolation ?  network.outputs.virtualNetworkName : ''
output AZURE_VIRTUAL_NETWORK_SUBNET_NAME string =networkIsolation ?  network.outputs.vmSubnetName : ''
output AZURE_SQL_SERVER_NAME string = sqlServerEnabled ? sqlServer.outputs.name : ''
output AZURE_SQL_SERVER_USERNAME string = sqlServerEnabled ? servicesUsername : ''
output AZURE_COSMOS_ACCOUNT_NAME string = cosmosDbEnabled ? cosmosdb.outputs.name : ''
