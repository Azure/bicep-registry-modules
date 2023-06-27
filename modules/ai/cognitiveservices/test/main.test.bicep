targetScope = 'resourceGroup'
param location string = resourceGroup().location
param serviceShort string = 'cognitiveservice'

// Dependencies
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.test.bicep' = {
  name: 'test-dependencies'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

// ===== //
// Tests //
// ===== //

// Test-01 - Speech service with minimal params

module test_01_speech '../main.bicep' = {
  name: 'test-01-speech'
  params: {
    kind: 'SpeechServices'
    skuName: 'S0'
    name: 'test-01-speech-${uniqueName}'
    location: location
  }
}

// Test-02 - OpenAI with a deployment with minimal params

module test_02_openAI '../main.bicep' = {
  name: 'test-02-openai'
  params: {
    skuName: 'S0'
    kind: 'OpenAI'
    name: 'test-02-openai-${uniqueName}'
    location: 'eastus'
    deployments: [
      {
        name: 'test-02-openai-deployment-${uniqueName}'
        sku: {
          name: 'Standard'
          capacity: 120
        }
        properties: {
          model: {
            format: 'OpenAI'
            name: 'text-davinci-002'
            version: 1
          }
          raiPolicyName: 'Microsoft.Default'
        }
      }
    ]
  }
}

// Test-03 - Content Moderator service with minimal params

module test_03_contentModerator '../main.bicep' = {
  name: 'test-03-cm'
  params: {
    skuName: 'S0'
    kind: 'ContentModerator'
    name: 'test-03-cm-${uniqueName}'
    location: location
  }
}

// Test-04 - Speech Service with role assignments and private endpoints

module test_04_speech '../main.bicep' = {
  name: 'test-04-speech'
  params: {
    name: 'test-04-speech-${uniqueName}'
    kind: 'SpeechServices'
    skuName: 'S0'
    location: location
    publicNetworkAccess: false
    customSubDomainName: uniqueName
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech Contributor'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech User'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
        groupId: 'account'
      }
    ]
  }
}
