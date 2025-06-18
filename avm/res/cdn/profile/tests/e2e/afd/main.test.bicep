targetScope = 'subscription'

metadata name = 'As Azure Front Door'
metadata description = 'This instance deploys the module as Azure Front Door.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cdn.profiles-${serviceShort}-rg-3'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'cdnpafd'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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
      name: 'dep-${namePrefix}-test-${serviceShort}'
      managedIdentities: {
        systemAssigned: true
      }
      location: 'global'
      originResponseTimeoutSeconds: 60
      sku: 'Standard_AzureFrontDoor'
      customDomains: [
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          // The default value for minimumTlsVersion is 'TLS12_2022'.
        }
        {
          name: 'dep-${namePrefix}-test2-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test2-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          // If you set cipherSuiteSetType to a predefined value (like "TLS12_2022"), you must not provide customizedCipherSuiteSet.
          cipherSuiteSetType: 'TLS12_2022'
        }
        {
          name: 'dep-${namePrefix}-test3-${serviceShort}-custom-domain'
          hostName: 'dep-${namePrefix}-test3-${serviceShort}-custom-domain.azurewebsites.net'
          certificateType: 'ManagedCertificate'
          // If you set cipherSuiteSetType to "Customized", you must provide a valid customizedCipherSuiteSet object.
          // The below setup with a customized cipher suite effectively deploys the resources
          cipherSuiteSetType: 'Customized'
          customizedCipherSuiteSet: {
            cipherSuiteSetForTls12: [
              'DHE_RSA_AES128_GCM_SHA256'
              'DHE_RSA_AES256_GCM_SHA384'
            ]
            cipherSuiteSetForTls13: [
              'TLS_AES_128_GCM_SHA256'
              'TLS_AES_256_GCM_SHA384'
            ]
          }
        }
      ]
      originGroups: [
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-origin-group'
          loadBalancingSettings: {
            additionalLatencyInMilliseconds: 50
            sampleSize: 4
            successfulSamplesRequired: 3
          }
          origins: [
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-origin'
              hostName: 'dep-${namePrefix}-test-${serviceShort}-origin.azurewebsites.net'
            }
          ]
        }
      ]
      ruleSets: [
        {
          name: 'dep${namePrefix}test${serviceShort}ruleset'
          rules: [
            {
              name: 'dep${namePrefix}test${serviceShort}rule'
              order: 1
              actions: [
                {
                  name: 'UrlRedirect'
                  parameters: {
                    typeName: 'DeliveryRuleUrlRedirectActionParameters'
                    redirectType: 'PermanentRedirect'
                    destinationProtocol: 'Https'
                    customPath: '/test123'
                    customHostname: 'dev-etradefd.trade.azure.defra.cloud'
                  }
                }
              ]
            }
          ]
        }
      ]
      afdEndpoints: [
        {
          name: 'dep-${namePrefix}-test-${serviceShort}-afd-endpoint'
          routes: [
            {
              name: 'dep-${namePrefix}-test-${serviceShort}-afd-route'
              originGroupName: 'dep-${namePrefix}-test-${serviceShort}-origin-group'
              customDomainNames: ['dep-${namePrefix}-test-${serviceShort}-custom-domain']
              ruleSets: [
                {
                  name: 'dep${namePrefix}test${serviceShort}ruleset'
                }
              ]
            }
          ]
        }
      ]
    }
  }
]

output dnsValidationRecords array = testDeployment[0].outputs.dnsValidation
output afdEndpointNames array = testDeployment[0].outputs.frontDoorEndpointHostNames
