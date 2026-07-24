targetScope = 'subscription'

metadata name = 'Using `AIServices` with a GA partner (Anthropic) `deployments` in parameter set'
metadata description = 'This instance deploys the module with a GA partner model deployment that carries the required `modelProviderData` attestation.'

// PREREQUISITE: Anthropic/Claude quota is gated by subscription offer type. A Production EA
// subscription (offer MS-AZR-0017P) receives Anthropic quota; an Enterprise Dev/Test subscription
// (MS-AZR-0148P) shows the model in the catalog but has 0/0 TPM. This deploy test therefore only
// succeeds on a Production EA subscription with approved Anthropic quota in `enforcedLocation`.
// (Confirmed via a Microsoft support case; Opus 4.8 deployed on a Production EA subscription.)

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cognitiveservices.accounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
#disable-next-line no-unused-params
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'csaan'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// The Anthropic `claude-sonnet-4-6` (version 1, Global Standard) model is only offered in
// `eastus2` and `swedencentral`. It is NOT available in the shared `enforcedLocation`
// (`australiaeast`), so this test pins its own supported region.
var enforcedLocation = 'swedencentral'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}-ai'
    params: {
      name: '${namePrefix}${serviceShort}002'
      kind: 'AIServices'
      customSubDomainName: '${namePrefix}x${serviceShort}ai'
      deployments: [
        {
          name: 'claude-sonnet-4-6'
          model: {
            format: 'Anthropic'
            name: 'claude-sonnet-4-6'
            version: '1'
          }
          sku: {
            name: 'GlobalStandard'
            capacity: 25
          }
          // Required for GA partner (Anthropic) models: the RP uses this to
          // auto-accept the Anthropic Azure Marketplace offer.
          modelProviderData: {
            organizationName: 'Contoso'
            countryCode: 'US'
            industry: 'technology'
          }
        }
      ]
    }
  }
]
