metadata name = 'CDN Profiles Security Policy'
metadata description = 'This module deploys a CDN Profile Security Policy.'

@description('Required. The resource name.')
param name string

@description('Conditional. The name of the parent CDN profile. Required if the template is used in a standalone deployment.')
param profileName string

@description('Required. Resource ID of WAF Policy.')
param wafPolicyResourceId string

// param associations associationsType
@description('Required. Waf associations (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/securitypolicies?pivots=deployment-language-bicep#securitypolicywebapplicationfirewallassociation for details).')
param associations associationsType[]

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cdn-profile-securitypolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource profile 'Microsoft.Cdn/profiles@2025-04-15' existing = {
  name: profileName
}

resource securityPolicies 'Microsoft.Cdn/profiles/securityPolicies@2025-04-15' = {
  name: name
  parent: profile
  properties: {
    parameters: {
      type: 'WebApplicationFirewall'
      wafPolicy: {
        id: wafPolicyResourceId
      }
      associations: associations
    }
  }
}

@description('The name of the secret.')
output name string = securityPolicies.name

@description('The resource ID of the secret.')
output resourceId string = securityPolicies.id

@description('The name of the resource group the secret was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of the associations.')
type associationsType = {
  @description('Required. List of domain resource id to associate with this resource.')
  domains: {
    @description('Required. ResourceID to domain that will be associated.')
    id: string
  }[]
  @description('Required. List of patterns to match with this association.')
  patternsToMatch: string[]
}
