metadata name = 'CDN Profiles AFD Endpoint Route'
metadata description = 'This module deploys a CDN Profile AFD Endpoint route.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the route.')
param name string

@description('Required. The name of the parent CDN profile.')
param profileName string

@description('Required. The name of the AFD endpoint.')
param afdEndpointName string

@description('Optional. The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object.')
param cacheConfiguration object?

@description('Optional. The names of the custom domains. The custom domains must be defined in the profile customDomains array.')
param customDomainNames string[]?

@allowed([
  'HttpOnly'
  'HttpsOnly'
  'MatchRequest'
])
@description('Optional. The protocol this rule will use when forwarding traffic to backends.')
param forwardingProtocol string = 'MatchRequest'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether this route is enabled.')
param enabledState string = 'Enabled'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether to automatically redirect HTTP traffic to HTTPS traffic.')
param httpsRedirect string = 'Enabled'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether this route will be linked to the default endpoint domain.')
param linkToDefaultDomain string = 'Enabled'

@description('Required. The name of the origin group. The origin group must be defined in the profile originGroups.')
param originGroupName string

@description('Optional. A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath.')
param originPath string?

@description('Optional. The route patterns of the rule.')
param patternsToMatch array?

@description('Optional. The rule sets of the rule. The rule sets must be defined in the profile ruleSets.')
param ruleSets array = []

@allowed(['Http', 'Https'])
@description('Optional. The supported protocols of the rule.')
param supportedProtocols array?

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName

  resource afdEndpoint 'afdEndpoints@2023-05-01' existing = {
    name: afdEndpointName
  }

  resource customDomains 'customDomains@2023-05-01' existing = [
    for customDomainName in (customDomainNames ?? []): {
      name: customDomainName
    }
  ]

  resource originGroup 'originGroups@2023-05-01' existing = {
    name: originGroupName
  }

  resource ruleSet 'ruleSets@2023-05-01' existing = [
    for ruleSet in ruleSets: {
      name: ruleSet.name
    }
  ]
}

resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2023-05-01' = {
  name: name
  parent: profile::afdEndpoint
  properties: {
    cacheConfiguration: cacheConfiguration
    customDomains: [
      for index in range(0, length(customDomainNames ?? [])): {
        id: profile::customDomains[index].id
      }
    ]
    enabledState: enabledState
    forwardingProtocol: forwardingProtocol
    httpsRedirect: httpsRedirect
    linkToDefaultDomain: linkToDefaultDomain
    originGroup: {
      id: profile::originGroup.id
    }
    originPath: originPath
    patternsToMatch: patternsToMatch
    ruleSets: [
      for (item, index) in ruleSets: {
        id: profile::ruleSet[index].id
      }
    ]
    supportedProtocols: supportedProtocols
  }
}

@description('The name of the route.')
output name string = route.name

@description('The ID of the route.')
output resourceId string = route.id

@description('The name of the resource group the route was created in.')
output resourceGroupName string = resourceGroup().name
