import {
  diagnosticSettingFullType
  lockType
  roleAssignmentType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

// ------------------
//    TYPES
// ------------------

@description('Describes a private link origin configuration for Front Door.')
type privateLinkOriginType = {
  @description('Required. The resource ID of the private endpoint resource.')
  privateEndpointResourceId: string

  @description('Required. The location of the private endpoint resource.')
  privateEndpointLocation: string

  @description('Required. The resource type of the private link (e.g. "sites").')
  privateLinkResourceType: string
}

@description('Describes an origin for Front Door.')
type originType = {
  @description('Required. The hostname of the origin.')
  hostname: string

  @description('Required. Whether the origin is enabled.')
  enabledState: bool

  @description('Required. Private Link configuration for the origin.')
  privateLinkOrigin: privateLinkOriginType
}

// ------------------
//    PARAMETERS
// ------------------

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Optional. Diagnostic Settings for the Front Door profile.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Required. Name of the AFD profile.')
param afdName string

@description('Required. Name of the endpoint under the profile, which is unique globally.')
param endpointName string

@description('Optional. State of the AFD endpoint.')
@allowed([
  'Enabled'
  'Disabled'
])
param endpointEnabled string = 'Enabled'

@description('Optional. Endpoint tags.')
param tags object = {}

@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
@description('Required. The pricing tier of the CDN profile.')
param skuName string

@description('Required. The name of the origin group.')
param originGroupName string

@description('Required. List of origins for the Front Door profile.')
param origins originType[]

@description('Optional. The action to take when a WAF rule is matched.')
@allowed([
  'Block'
  'Log'
  'Redirect'
])
param wafRuleSetAction string = 'Block'

@description('Optional. WAF policy enabled state.')
@allowed([
  'Enabled'
  'Disabled'
])
param wafPolicyState string = 'Enabled'

@description('Optional. WAF policy mode.')
@allowed([
  'Detection'
  'Prevention'
])
param wafPolicyMode string = 'Prevention'

@description('Optional. Name for the WAF policy resource. Defaults to naming-module value if empty.')
param wafPolicyName string = ''

@description('Optional. Whether to deploy the default WAF custom rule that blocks non-GET/HEAD/OPTIONS methods. Set to false for API backends that need POST/PUT/PATCH/DELETE.')
param enableDefaultWafMethodBlock bool = true

@description('Optional. Custom WAF rules to deploy. Only used if enableDefaultWafMethodBlock is false (replaces the default rule set).')
param wafCustomRules object?

@description('Optional. Health probe path for the origin group. Defaults to "/".')
param healthProbePath string = '/'

@description('Optional. Health probe interval in seconds. Defaults to 100.')
param healthProbeIntervalInSeconds int = 100

@description('Optional. Custom domains for the Front Door profile.')
param customDomains array?

@description('Optional. Rule sets for URL rewrites, header manipulation, and caching.')
param ruleSets array?

@description('Optional. Secrets for the Front Door profile (e.g. BYOC certificates).')
param secrets array?

@description('Optional. Specify the type of resource lock for the Front Door profile.')
param lock lockType?

@description('Optional. Role assignments for the Front Door profile.')
param roleAssignments roleAssignmentType[]?

@description('Optional. The time in seconds before the origin response times out. Defaults to 120.')
param originResponseTimeoutSeconds int = 120

module waf 'br/public:avm/res/network/front-door-web-application-firewall-policy:0.3.3' = {
  name: 'wafPolicy-${uniqueString(resourceGroup().id)}'
  params: {
    name: !empty(wafPolicyName) ? wafPolicyName : 'waffrontdoor'
    location: 'Global'
    enableTelemetry: enableTelemetry
    tags: tags
    sku: skuName
    policySettings: {
      enabledState: wafPolicyState
      mode: wafPolicyMode
      requestBodyCheck: 'Enabled'
    }
    customRules: enableDefaultWafMethodBlock
      ? {
          rules: [
            {
              name: 'BlockMethod'
              enabledState: 'Enabled'
              action: 'Block'
              ruleType: 'MatchRule'
              priority: 10
              rateLimitDurationInMinutes: 1
              rateLimitThreshold: 100
              matchConditions: [
                {
                  matchVariable: 'RequestMethod'
                  operator: 'Equal'
                  negateCondition: true
                  matchValue: [
                    'GET'
                    'OPTIONS'
                    'HEAD'
                  ]
                }
              ]
            }
          ]
        }
      : (wafCustomRules ?? { rules: [] })
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'Microsoft_DefaultRuleSet'
          ruleSetVersion: '2.1'
          ruleSetAction: wafRuleSetAction
          ruleGroupOverrides: []
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
          ruleSetAction: wafRuleSetAction
          ruleGroupOverrides: []
        }
      ]
    }
  }
}

module frontDoor 'br/public:avm/res/cdn/profile:0.19.0' = {
  name: 'frontDoorDeployment-${uniqueString(resourceGroup().id)}'
  params: {
    name: afdName
    sku: skuName
    location: 'global'
    enableTelemetry: enableTelemetry
    originResponseTimeoutSeconds: originResponseTimeoutSeconds
    managedIdentities: {
      systemAssigned: true
    }
    diagnosticSettings: diagnosticSettings
    lock: lock
    roleAssignments: roleAssignments
    customDomains: customDomains
    ruleSets: ruleSets
    secrets: secrets
    afdEndpoints: [
      {
        name: endpointName
        enabledState: endpointEnabled

        routes: [
          {
            name: '${originGroupName}-route'
            originGroupName: originGroupName
            patternsToMatch: [
              '/*'
            ]
            forwardingProtocol: 'HttpsOnly'
            linkToDefaultDomain: 'Enabled'
            httpsRedirect: 'Enabled'
            enabledState: 'Enabled'
          }
        ]
        tags: tags
      }
    ]
    originGroups: [
      {
        name: originGroupName
        loadBalancingSettings: {
          sampleSize: 4
          successfulSamplesRequired: 3
          additionalLatencyInMilliseconds: 50
        }
        healthProbeSettings: {
          probePath: healthProbePath
          probeRequestType: 'GET'
          probeProtocol: 'Https'
          probeIntervalInSeconds: healthProbeIntervalInSeconds
        }
        sessionAffinityState: 'Disabled'
        trafficRestorationTimeToHealedOrNewEndpointsInMinutes: 10
        origins: [
          for (origin, index) in origins: {
            name: replace(origin.hostname, '.', '-')
            hostName: origin.hostname
            httpPort: 80
            httpsPort: 443
            priority: 1
            weight: 1000
            enabledState: origin.enabledState ? 'Enabled' : 'Disabled'
            enforceCertificateNameCheck: true
            sharedPrivateLinkResource: {
              privateLink: {
                id: origin.privateLinkOrigin.privateEndpointResourceId
              }
              privateLinkLocation: origin.privateLinkOrigin.privateEndpointLocation
              requestMessage: 'frontdoor'
              groupId: origin.privateLinkOrigin.privateLinkResourceType
            }
          }
        ]
      }
    ]
    securityPolicies: [
      {
        name: 'webApplicationFirewall'
        wafPolicyResourceId: waf.outputs.resourceId
        associations: [
          {
            // Note: resourceId() is necessary here because the AFD endpoint is created within
            // the same module call and cannot be referenced directly as a Bicep symbolic name.
            domains: [
              {
                id: resourceId(
                  subscription().subscriptionId,
                  resourceGroup().name,
                  'Microsoft.Cdn/profiles/afdEndpoints',
                  afdName,
                  endpointName
                )
              }
            ]
            patternsToMatch: [
              '/*'
            ]
          }
        ]
      }
    ]

    tags: tags
  }
}

@description('The name of the CDN profile.')
output afdProfileName string = frontDoor.outputs.name

@description('The resource ID of the CDN profile.')
output afdProfileResourceId string = frontDoor.outputs.resourceId

@description('Name of the endpoint.')
output endpointName string = frontDoor.outputs.?endpointName ?? ''

@description('HostName of the endpoint.')
output afdEndpointHostName string = frontDoor.outputs.?uri ?? ''

@description('The resource group where the CDN profile is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The type of the CDN profile.')
output profileType string = frontDoor.outputs.profileType
