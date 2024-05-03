targetScope = 'subscription'

metadata name = 'Using `deployments` in parameter set'
metadata description = '''
This instance deploys the module with the AI model deployment feature.'

Note, this test is temporarily disabled as it needs to be enabled on the subscription.
As we don't want other contributions from being blocked by this, we disabled the test for now / rely on a manual execution outside the CI environemnt
You can find more information here: https://learn.microsoft.com/en-us/legal/cognitive-services/openai/limited-access
And register here: https://aka.ms/oai/access
'''

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cognitiveservices.accounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csad'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: if (true == false) {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}-ai'
    params: {
      name: '${namePrefix}${serviceShort}002'
      kind: 'AIServices'
      location: resourceLocation
      customSubDomainName: '${namePrefix}x${serviceShort}ai'
      deployments: [
        {
          name: 'gpt-35-turbo'
          model: {
            format: 'OpenAI'
            name: 'gpt-35-turbo'
            version: '0301'
          }
          sku: {
            name: 'Standard'
            capacity: 10
          }
        }
      ]
    }
  }
]
