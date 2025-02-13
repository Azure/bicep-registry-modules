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
param associations associationsType

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName
}

resource securityPolicies 'Microsoft.Cdn/profiles/securityPolicies@2024-02-01' = {
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

@export()
type associationsType = {
  @description('Required. List of domain resource id to associate with this resource.')
  domains: {
    @description('Required. ResourceID to domain that will be associated.')
    id: string
  }[]
  @description('Required. List of patterns to match with this association.')
  patternsToMatch: string[]
}[]

@description('The name of the secrect.')
output name string = securityPolicies.name

@description('The resource ID of the secrect.')
output resourceId string = securityPolicies.id

@description('The name of the resource group the secret was created in.')
output resourceGroupName string = resourceGroup().name
