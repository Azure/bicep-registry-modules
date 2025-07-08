targetScope = 'subscription'

metadata name = 'Disconnected Speech Test'
metadata description = 'This instance deploys SpeechServices with DC0 and Disconnected Container plan for Neural TTS.'

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cognitiveservices.accounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csaspeech'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module speechDeployment '../../../main.bicep' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  scope: rg
  params: {
    name: '${namePrefix}-${serviceShort}001'
    kind: 'SpeechServices'
    sku: 'DC0'
    location: resourceLocation

    publicNetworkAccess: 'Enabled'

    isCommitmentPlanForDisconnectedContainerEnabledForNeuralTTS: true
    commitmentPlanForDisconnectedContainerForNeuralTTS: {
      autoRenew: false
      hostingModel: 'DisconnectedContainer'
      planType: 'NTTS'
      current: {
        count: 1
        tier: 'T1'
      }
    }

    tags: {
      Environment: 'Test'
      Deployment: 'DC0Disconnected'
    }

    diagnosticSettings: []
    privateEndpoints: []
    roleAssignments: []
    allowedFqdnList: []
    apiProperties: {}
    userOwnedStorage: []
    deployments: []
    lock: {
      kind: 'None'
    }
    migrationToken: ''
    allowProjectManagement: false
    customerManagedKey: null
    managedIdentities: null
    secretsExportConfiguration: null
    disableLocalAuth: false
    networkAcls: {
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}
