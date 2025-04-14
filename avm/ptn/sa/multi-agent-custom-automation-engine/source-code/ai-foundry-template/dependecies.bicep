@description('Name of the Cosmos DB account')
param cosmosDbAccountName string = ''

@description('Cosmos DB database type')
@allowed([
  'MongoDB'
  'SQL'
  'Cassandra'
  'Gremlin'
  'Table'
])
param cosmosDbDatabaseType string = 'MongoDB'

@description('Name of the Fabric Capacity')
param fabricCapacityName string = ''

@description('Fabric Capacity SKU')
@allowed([
  'F1'
  'S1'
  'S2'
  'S3'
])
param fabricCapacitySku string = 'F1'





@description('Name of the Cognitive Services Account')
param cognitiveAccountName string

@description('Required. Kind of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'AIServices'
  'AnomalyDetector'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'ContentSafety'
  'ConversationalLanguageUnderstanding'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Face'
  'FormRecognizer'
  'HealthInsights'
  'ImmersiveReader'
  'Internal.AllInOne'
  'LUIS'
  'LUIS.Authoring'
  'LanguageAuthoring'
  'MetricsAdvisor'
  'OpenAI'
  'Personalizer'
  'QnAMaker.v2'
  'SpeechServices'
  'TextAnalytics'
  'TextTranslation'
])
param kind string

@description('Azure AI Search SKU')
@allowed([
  'standard'
  'standard2'
  'standard3'
]
)
param searchSKU string = 'standard3'

@description('Name of the Azure AI Search service')
param searchServiceName string = ''


module account 'br/public:avm/res/cognitive-services/account:0.9.2' =  {
    scope:resourceGroup(resourceGroupName)
    name: 'CognitiveServicesDeployment'
    params: {
      name: cognitiveAccountName
      location: location
      managedIdentity: true
      sku: 'S0'
      kind: kind
      publicNetworkAccess: 'Disabled'
      // roleAssignments: [
      //   {
      //     principalId: hubMsi.outputs.principalId
      //     roleDefinitionIdOrName: 'Contributor'
      //     principalType: 'ServicePrincipal'
      //   }
      //   {
      //     principalId: msi.outputs.principalId
      //     roleDefinitionIdOrName: 'Cognitive Services OpenAI User'
      //     principalType: 'ServicePrincipal'
      //   }
      // ]
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
              }
            ]
          }
          subnetResourceId: '<subnetResourceId>'
          tags: {
            Environment: 'Non-Prod'
            'hidden-title': 'This is visible in the resource name'
            Role: 'DeploymentValidation'
          }
        }
      ]

      tags: tags
    }
  }


  //Add search 
  module aiSearch 'br/public:avm/res/search/search-service:0.9.0' {
    scope:resourceGroup(resourceGroupName)
    name: searchServiceName
    params: {
         name:searchServiceName
         location: location
         cmkEnforcement: 'Enabled'
         disableLocalAuth: false
         partitionCount: 2
         replicaCount: 3
         sku: searchSKU
         privateEndpoints: [
          {
            applicationSecurityGroupResourceIds: [
              '<applicationSecurityGroupResourceId>'
            ]
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
            tags: {
              Environment: 'Non-Prod'
              Role: 'DeploymentValidation'
            }
          }
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: '<privateDnsZoneResourceId>'
                }
              ]
            }
            subnetResourceId: '<subnetResourceId>'
          }
        ]
        publicNetworkAccess: 'Disabled'
        sharedPrivateLinkResources: [
          {
            groupId: 'blob'
            privateLinkResourceId: '<privateLinkResourceId>'
            requestMessage: 'Please approve this request'
            resourceRegion: '<resourceRegion>'
          }
          {
            groupId: 'vault'
            privateLinkResourceId: '<privateLinkResourceId>'
            requestMessage: 'Please approve this request'
          }
        ]
              
        }
      }

