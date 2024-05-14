targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-managedidentity.userassignedidentities-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'miuaiwaf'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Set to fixed location as the RP function returns unsupported locations
// Right now (2024/03) the following locations are NOT supported for federated identity credentials: East Asia, Qatar Central, Malaysia South, Italy North, Israel Central
param enforcedLocation string = 'westeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      federatedIdentityCredentials: [
        {
          name: 'test-fed-cred-${serviceShort}-001'
          audiences: [
            'api://AzureADTokenExchange'
          ]
          issuer: 'https://contoso.com/${subscription().tenantId}/${guid(deployment().name)}01/'
          subject: 'system:serviceaccount:default:workload-identity-sa'
        }
        {
          name: 'test-fed-cred-${serviceShort}-002'
          audiences: [
            'api://AzureADTokenExchange'
          ]
          issuer: 'https://contoso.com/${subscription().tenantId}/${guid(deployment().name)}02/'
          subject: 'system:serviceaccount:default:workload-identity-sa'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
