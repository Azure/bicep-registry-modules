targetScope = 'subscription'

metadata name = 'App Service Landing Zone Accelerator'
metadata description = 'This Azure App Service pattern module represents an Azure App Service deployment aligned with the cloud adoption framework'

// ================ //
// Parameters       //
// ================ //

import {
  spokeNetworkConfigType
  servicePlanConfigType
  appServiceConfigType
  keyVaultConfigType
  appInsightsConfigType
  appGatewayConfigType
  frontDoorConfigType
  aseConfigType
} from './modules/shared.types.bicep'

@maxLength(10)
@description('Optional. suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>.')
param workloadName string = 'appsvc${take(uniqueString(subscription().id), 4)}'

@description('Optional. Azure region where the resources will be deployed in.')
param location string = deployment().location

@description('Optional. The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environmentName string = 'test'

@description('Optional. Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.')
param deployAseV3 bool = false

@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace.')
param logAnalyticsWorkspaceResourceId string

// ======================== //
// Domain Configuration     //
// ======================== //

@description('Optional. Configuration for the spoke virtual network and ingress networking.')
param spokeNetworkConfig spokeNetworkConfigType?

@description('Optional. Configuration for the App Service Plan.')
param servicePlanConfig servicePlanConfigType?

@description('Optional. Configuration for the Web App.')
param appServiceConfig appServiceConfigType?

@description('Optional. Configuration for the Key Vault.')
param keyVaultConfig keyVaultConfigType?

@description('Optional. Configuration for Application Insights.')
param appInsightsConfig appInsightsConfigType?

@description('Optional. Configuration for the Application Gateway. Only used when spokeNetworkConfig.ingressOption is "applicationGateway".')
param appGatewayConfig appGatewayConfigType?

@description('Optional. Configuration for Azure Front Door. Only used when spokeNetworkConfig.ingressOption is "frontDoor".')
param frontDoorConfig frontDoorConfigType?

@description('Optional. Configuration for the App Service Environment v3. Only used when deployAseV3 is true.')
param aseConfig aseConfigType?

// ================ //
// Variables        //
// ================ //

// ======================== //
// Resolved Configuration   //
// ======================== //

// Spoke Network
var vnetSpokeAddressSpace = spokeNetworkConfig.?vnetAddressSpace ?? '10.240.0.0/20'
var subnetSpokeAppSvcAddressSpace = spokeNetworkConfig.?appSvcSubnetAddressSpace ?? '10.240.0.0/26'
var subnetSpokePrivateEndpointAddressSpace = spokeNetworkConfig.?privateEndpointSubnetAddressSpace ?? '10.240.11.0/24'
var subnetSpokeAppGwAddressSpace = spokeNetworkConfig.?appGwSubnetAddressSpace ?? ''
var vnetHubResourceId = spokeNetworkConfig.?hubVnetResourceId ?? ''
var firewallInternalIp = spokeNetworkConfig.?firewallInternalIp ?? ''
var networkingOption = spokeNetworkConfig.?ingressOption ?? 'frontDoor'
var enableEgressLockdown = spokeNetworkConfig.?enableEgressLockdown ?? false
var dnsServers = spokeNetworkConfig.?dnsServers ?? []
var ddosProtectionPlanResourceId = spokeNetworkConfig.?ddosProtectionPlanResourceId ?? ''
var disableBgpRoutePropagation = spokeNetworkConfig.?disableBgpRoutePropagation ?? true
var vnetEncryption = spokeNetworkConfig.?encryption ?? false
var vnetEncryptionEnforcement = spokeNetworkConfig.?encryptionEnforcement ?? 'AllowUnencrypted'
var flowTimeoutInMinutes = spokeNetworkConfig.?flowTimeoutInMinutes ?? 0
var enableVmProtection = spokeNetworkConfig.?enableVmProtection
var virtualNetworkBgpCommunity = spokeNetworkConfig.?bgpCommunity
var vnetLock = spokeNetworkConfig.?lock
var vnetRoleAssignments = spokeNetworkConfig.?roleAssignments
var vnetDiagnosticSettings = spokeNetworkConfig.?diagnosticSettings

// Service Plan
var webAppPlanSku = servicePlanConfig.?sku ?? 'P1V3'
var zoneRedundant = servicePlanConfig.?zoneRedundant ?? true
var webAppBaseOs = servicePlanConfig.?kind ?? 'windows'
var existingAppServicePlanId = servicePlanConfig.?existingPlanId ?? ''
var skuCapacity = servicePlanConfig.?skuCapacity
var workerTierName = servicePlanConfig.?workerTierName
var elasticScaleEnabled = servicePlanConfig.?elasticScaleEnabled
var maximumElasticWorkerCount = servicePlanConfig.?maximumElasticWorkerCount ?? 20
var perSiteScaling = servicePlanConfig.?perSiteScaling ?? false
var targetWorkerCount = servicePlanConfig.?targetWorkerCount ?? 0
var targetWorkerSize = servicePlanConfig.?targetWorkerSize ?? 0
var appServicePlanVirtualNetworkSubnetId = servicePlanConfig.?virtualNetworkSubnetId
var isCustomMode = servicePlanConfig.?isCustomMode
var rdpEnabled = servicePlanConfig.?rdpEnabled
var installScripts = servicePlanConfig.?installScripts
var registryAdapters = servicePlanConfig.?registryAdapters
var storageMounts = servicePlanConfig.?storageMounts
var appServicePlanManagedIdentities = servicePlanConfig.?managedIdentities
var appServicePlanLock = servicePlanConfig.?lock
var appServicePlanRoleAssignments = servicePlanConfig.?roleAssignments
var servicePlanDiagnosticSettings = servicePlanConfig.?diagnosticSettings ?? []

// Web App
var webAppKind = appServiceConfig.?kind ?? 'app'
var httpsOnly = appServiceConfig.?httpsOnly ?? true
var clientCertEnabled = appServiceConfig.?clientCertEnabled ?? false
var clientCertMode = appServiceConfig.?clientCertMode ?? 'Required'
var clientCertExclusionPaths = appServiceConfig.?clientCertExclusionPaths
var disableBasicPublishingCredentials = appServiceConfig.?disableBasicPublishingCredentials ?? true
var webAppPublicNetworkAccess = appServiceConfig.?publicNetworkAccess ?? ''
var redundancyMode = appServiceConfig.?redundancyMode ?? 'None'
var scmSiteAlsoStopped = appServiceConfig.?scmSiteAlsoStopped ?? false
var siteConfig = appServiceConfig.?siteConfig ?? {
  alwaysOn: true
  ftpsState: 'FtpsOnly'
  minTlsVersion: '1.2'
  healthCheckPath: '/healthz'
  http20Enabled: true
}
var functionAppConfig = appServiceConfig.?functionAppConfig
var managedEnvironmentResourceId = appServiceConfig.?managedEnvironmentResourceId
var outboundVnetRouting = appServiceConfig.?outboundVnetRouting
var hostNameSslStates = appServiceConfig.?hostNameSslStates
var e2eEncryptionEnabled = appServiceConfig.?e2eEncryptionEnabled
var keyVaultAccessIdentityResourceId = appServiceConfig.?keyVaultAccessIdentityResourceId
var hybridConnectionRelays = appServiceConfig.?hybridConnectionRelays
var webAppExtensions = appServiceConfig.?extensions
var webAppEnabled = appServiceConfig.?enabled ?? true
var cloningInfo = appServiceConfig.?cloningInfo
var containerSize = appServiceConfig.?containerSize
var dailyMemoryTimeQuota = appServiceConfig.?dailyMemoryTimeQuota
var storageAccountRequired = appServiceConfig.?storageAccountRequired ?? false
var appServiceStorageAccounts = appServiceConfig.?storageAccounts
var dnsConfiguration = appServiceConfig.?dnsConfiguration
var autoGeneratedDomainNameLabelScope = appServiceConfig.?autoGeneratedDomainNameLabelScope
var sshEnabled = appServiceConfig.?sshEnabled
var daprConfig = appServiceConfig.?daprConfig
var ipMode = appServiceConfig.?ipMode
var resourceConfig = appServiceConfig.?resourceConfig
var workloadProfileName = appServiceConfig.?workloadProfileName
var hostNamesDisabled = appServiceConfig.?hostNamesDisabled
var webAppReserved = appServiceConfig.?reserved
var extendedLocation = appServiceConfig.?extendedLocation
var clientAffinityEnabled = appServiceConfig.?clientAffinityEnabled ?? false
var clientAffinityProxyEnabled = appServiceConfig.?clientAffinityProxyEnabled
var clientAffinityPartitioningEnabled = appServiceConfig.?clientAffinityPartitioningEnabled
var containerImageName = appServiceConfig.?container.?imageName ?? ''
var containerRegistryUrl = appServiceConfig.?container.?registryUrl ?? ''
var containerRegistryUsername = appServiceConfig.?container.?registryUsername ?? ''
var containerRegistryPassword = appServiceConfig.?container.?registryPassword ?? ''
var webAppLock = appServiceConfig.?lock
var webAppRoleAssignments = appServiceConfig.?roleAssignments
var appserviceDiagnosticSettings = appServiceConfig.?diagnosticSettings ?? []

// Key Vault
var keyVaultEnablePurgeProtection = keyVaultConfig.?enablePurgeProtection ?? true
var keyVaultSoftDeleteRetentionInDays = keyVaultConfig.?softDeleteRetentionInDays ?? 90
var keyVaultAccessPolicies = keyVaultConfig.?accessPolicies
var keyVaultSecrets = keyVaultConfig.?secrets
var keyVaultKeys = keyVaultConfig.?keys
var keyVaultEnableVaultForTemplateDeployment = keyVaultConfig.?enableVaultForTemplateDeployment ?? true
var keyVaultEnableVaultForDiskEncryption = keyVaultConfig.?enableVaultForDiskEncryption ?? true
var keyVaultCreateMode = keyVaultConfig.?createMode ?? 'default'
var keyVaultSku = keyVaultConfig.?sku ?? 'standard'
var keyVaultEnableRbacAuthorization = keyVaultConfig.?enableRbacAuthorization ?? true
var keyVaultEnableVaultForDeployment = keyVaultConfig.?enableVaultForDeployment ?? true
var keyVaultNetworkAcls = keyVaultConfig.?networkAcls
var keyVaultPublicNetworkAccess = keyVaultConfig.?publicNetworkAccess ?? 'Disabled'
var keyVaultLock = keyVaultConfig.?lock
var keyVaultAdditionalRoleAssignments = keyVaultConfig.?additionalRoleAssignments
var keyVaultDiagnosticSettings = keyVaultConfig.?diagnosticSettings ?? []

// App Insights
var appInsightsPublicNetworkAccessForIngestion = appInsightsConfig.?publicNetworkAccessForIngestion ?? 'Disabled'
var appInsightsPublicNetworkAccessForQuery = appInsightsConfig.?publicNetworkAccessForQuery ?? 'Disabled'
var appInsightsRetentionInDays = appInsightsConfig.?retentionInDays ?? 90 // Valid: 30, 60, 90, 120, 180, 270, 365, 550, 730
var appInsightsSamplingPercentage = appInsightsConfig.?samplingPercentage ?? 100
var appInsightsDisableLocalAuth = appInsightsConfig.?disableLocalAuth ?? true
var appInsightsDisableIpMasking = appInsightsConfig.?disableIpMasking
var appInsightsForceCustomerStorageForProfiler = appInsightsConfig.?forceCustomerStorageForProfiler
var appInsightsLinkedStorageAccountResourceId = appInsightsConfig.?linkedStorageAccountResourceId
var appInsightsFlowType = appInsightsConfig.?flowType
var appInsightsRequestSource = appInsightsConfig.?requestSource
var appInsightsKind = appInsightsConfig.?kind
var appInsightsImmediatePurgeDataOn30Days = appInsightsConfig.?immediatePurgeDataOn30Days
var appInsightsIngestionMode = appInsightsConfig.?ingestionMode
var appInsightsLock = appInsightsConfig.?lock
var appInsightsRoleAssignments = appInsightsConfig.?roleAssignments
var appInsightsDiagnosticSettings = appInsightsConfig.?diagnosticSettings

// Application Gateway
var appGatewaySslCertificates = appGatewayConfig.?sslCertificates
var appGatewayManagedIdentities = appGatewayConfig.?managedIdentities
var appGatewayTrustedRootCertificates = appGatewayConfig.?trustedRootCertificates
var appGatewaySslPolicyType = appGatewayConfig.?sslPolicyType
var appGatewaySslPolicyName = appGatewayConfig.?sslPolicyName
var appGatewaySslPolicyMinProtocolVersion = appGatewayConfig.?sslPolicyMinProtocolVersion
var appGatewaySslPolicyCipherSuites = appGatewayConfig.?sslPolicyCipherSuites ?? []
var appGatewayRoleAssignments = appGatewayConfig.?roleAssignments
var appGatewayAuthenticationCertificates = appGatewayConfig.?authenticationCertificates ?? []
var appGatewayCustomErrorConfigurations = appGatewayConfig.?customErrorConfigurations ?? []
var appGatewayEnableFips = appGatewayConfig.?enableFips ?? false
var appGatewayEnableHttp2 = appGatewayConfig.?enableHttp2 ?? true
var appGatewayEnableRequestBuffering = appGatewayConfig.?enableRequestBuffering ?? false
var appGatewayEnableResponseBuffering = appGatewayConfig.?enableResponseBuffering ?? false
var appGatewayHealthProbePath = appGatewayConfig.?healthProbePath ?? '/'
var appGatewayLoadDistributionPolicies = appGatewayConfig.?loadDistributionPolicies ?? []
var appGatewayPrivateEndpoints = appGatewayConfig.?privateEndpoints
var appGatewayPrivateLinkConfigurations = appGatewayConfig.?privateLinkConfigurations ?? []
var appGatewayRedirectConfigurations = appGatewayConfig.?redirectConfigurations ?? []
var appGatewayRewriteRuleSets = appGatewayConfig.?rewriteRuleSets ?? []
var appGatewaySslProfiles = appGatewayConfig.?sslProfiles ?? []
var appGatewayTrustedClientCertificates = appGatewayConfig.?trustedClientCertificates ?? []
var appGatewayUrlPathMaps = appGatewayConfig.?urlPathMaps ?? []
var appGatewayBackendSettingsCollection = appGatewayConfig.?backendSettingsCollection ?? []
var appGatewayListeners = appGatewayConfig.?listeners ?? []
var appGatewayRoutingRules = appGatewayConfig.?routingRules ?? []
var appGatewayLock = appGatewayConfig.?lock
var appGatewayDiagnosticSettings = appGatewayConfig.?diagnosticSettings ?? []

// Front Door
var enableDefaultWafMethodBlock = frontDoorConfig.?enableDefaultWafMethodBlock ?? true
var wafCustomRules = frontDoorConfig.?wafCustomRules
var frontDoorHealthProbePath = frontDoorConfig.?healthProbePath ?? '/'
var frontDoorHealthProbeIntervalInSeconds = frontDoorConfig.?healthProbeIntervalInSeconds ?? 100
var frontDoorCustomDomains = frontDoorConfig.?customDomains
var frontDoorRuleSets = frontDoorConfig.?ruleSets
var frontDoorSecrets = frontDoorConfig.?secrets
var frontDoorRoleAssignments = frontDoorConfig.?roleAssignments
var frontDoorOriginResponseTimeoutSeconds = frontDoorConfig.?originResponseTimeoutSeconds ?? 120
var autoApproveAfdPrivateEndpoint = frontDoorConfig.?autoApprovePrivateEndpoint ?? true
var frontDoorLock = frontDoorConfig.?lock
var frontDoorDiagnosticSettings = frontDoorConfig.?diagnosticSettings ?? []

// ASE
var aseClusterSettings = aseConfig.?clusterSettings ?? [{ name: 'DisableTls1.0', value: '1' }]
var aseCustomDnsSuffix = aseConfig.?customDnsSuffix
var aseIpsslAddressCount = aseConfig.?ipsslAddressCount
var aseMultiSize = aseConfig.?multiSize
var aseManagedIdentities = aseConfig.?managedIdentities
var aseCustomDnsSuffixCertificateUrl = aseConfig.?customDnsSuffixCertificateUrl ?? ''
var aseCustomDnsSuffixKeyVaultReferenceIdentity = aseConfig.?customDnsSuffixKeyVaultReferenceIdentity ?? ''
var aseDedicatedHostCount = aseConfig.?dedicatedHostCount ?? 0
var aseDnsSuffix = aseConfig.?dnsSuffix ?? ''
var aseFrontEndScaleFactor = aseConfig.?frontEndScaleFactor ?? 15
var aseInternalLoadBalancingMode = aseConfig.?internalLoadBalancingMode ?? 'Web, Publishing'
var aseAllowNewPrivateEndpointConnections = aseConfig.?allowNewPrivateEndpointConnections ?? true
var aseFtpEnabled = aseConfig.?ftpEnabled ?? false
var aseInboundIpAddressOverride = aseConfig.?inboundIpAddressOverride ?? ''
var aseRemoteDebugEnabled = aseConfig.?remoteDebugEnabled ?? false
var aseUpgradePreference = aseConfig.?upgradePreference ?? 'None'
var aseLock = aseConfig.?lock
var aseRoleAssignments = aseConfig.?roleAssignments
var aseDiagnosticSettings = aseConfig.?diagnosticSettings ?? []

// ======================== //
// Naming & Resource Names  //
// ======================== //

var resourceSuffix = '${workloadName}-${environmentName}-${location}'
var resourceGroupName = spokeNetworkConfig.?resourceGroupName ?? 'rg-spoke-${resourceSuffix}'

var names = naming.outputs.names
var resourceNames = {
  aseName: aseConfig.?name ?? names.appServiceEnvironment.nameUnique
  aspName: servicePlanConfig.?name ?? names.appServicePlan.name
  webApp: appServiceConfig.?name ?? names.appService.nameUnique
  appSvcUserAssignedManagedIdentity: appServiceConfig.?managedIdentityName ?? take('${names.managedIdentity.name}-appSvc', 128)
  frontDoorEndPoint: frontDoorConfig.?endpointName ?? 'webAppLza-${take(uniqueString(resourceGroupName), 6)}'
  frontDoorWaf: replace(frontDoorConfig.?wafName ?? names.frontDoorFirewallPolicy.name, '-', '')
  frontDoor: frontDoorConfig.?name ?? names.frontDoor.name
  frontDoorOriginGroup: frontDoorConfig.?originGroupName ?? '${names.frontDoor.name}-originGroup'
  idAfdApprovePeAutoApprover: frontDoorConfig.?afdPeAutoApproverName ?? take('${names.managedIdentity.name}-AfdApprovePe', 128)
}

var virtualNetworkLinks = [
  {
    name: networking.outputs.vnetSpokeName
    virtualNetworkResourceId: networking.outputs.vnetSpokeResourceId
    registrationEnabled: false
  }
]

// ================ //
// Resources        //
// ================ //

module spokeResourceGroup 'br/public:avm/res/resources/resource-group:0.4.3' = {
  name: '${uniqueString(deployment().name, location, resourceGroupName)}-deployment'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
}

module naming './modules/naming/naming.module.bicep' = {
  scope: az.resourceGroup(resourceGroupName)
  name: 'NamingDeployment'
  params: {
    location: location
    suffix: [
      environmentName
    ]
    uniqueLength: 6
    uniqueSeed: spokeResourceGroup.outputs.resourceId
  }
}

// ======================== //
// Networking               //
// ======================== //

module networking './modules/networking/network.module.bicep' = {
  name: '${uniqueString(deployment().name, location)}-networking'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    naming: naming.outputs.names
    enableTelemetry: enableTelemetry
    deployAseV3: deployAseV3
    enableEgressLockdown: enableEgressLockdown
    vnetSpokeAddressSpace: vnetSpokeAddressSpace
    subnetSpokeAppSvcAddressSpace: subnetSpokeAppSvcAddressSpace
    subnetSpokePrivateEndpointAddressSpace: subnetSpokePrivateEndpointAddressSpace
    subnetSpokeAppGwAddressSpace: subnetSpokeAppGwAddressSpace
    firewallInternalIp: firewallInternalIp
    hubVnetResourceId: vnetHubResourceId
    networkingOption: networkingOption
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceResourceId
    dnsServers: dnsServers
    ddosProtectionPlanResourceId: ddosProtectionPlanResourceId
    vnetDiagnosticSettings: !empty(vnetDiagnosticSettings)
      ? vnetDiagnosticSettings
      : null
    vnetLock: vnetLock
    disableBgpRoutePropagation: disableBgpRoutePropagation
    vnetRoleAssignments: vnetRoleAssignments
    vnetEncryption: vnetEncryption
    vnetEncryptionEnforcement: vnetEncryptionEnforcement
    flowTimeoutInMinutes: flowTimeoutInMinutes
    enableVmProtection: enableVmProtection
    virtualNetworkBgpCommunity: virtualNetworkBgpCommunity
    tags: tags
  }
}

// ======================== //
// App Service Variables    //
// ======================== //

var webAppDnsZoneName = 'privatelink.azurewebsites.net'
var slotName = 'staging'

var deployPlan = empty(existingAppServicePlanId)
var resolvedServerFarmResourceId = appServicePlan.?outputs.?resourceId ?? existingAppServicePlanId

var isLinux = webAppBaseOs =~ 'linux'
var isContainer = contains(webAppKind, 'container')
var isWindowsContainer = contains(webAppKind, 'container') && contains(webAppKind, 'windows')

// Merge container-specific site config properties
var containerSiteConfig = isContainer && !empty(containerImageName)
  ? union(siteConfig, isLinux
      ? { linuxFxVersion: 'DOCKER|${containerImageName}' }
      : { windowsFxVersion: 'DOCKER|${containerImageName}' })
  : siteConfig

// Container registry app settings for private registries
var containerRegistryAppSettings = isContainer && !empty(containerRegistryUrl)
  ? {
      DOCKER_REGISTRY_SERVER_URL: containerRegistryUrl
      ...(!empty(containerRegistryUsername)
        ? {
            DOCKER_REGISTRY_SERVER_USERNAME: containerRegistryUsername
            DOCKER_REGISTRY_SERVER_PASSWORD: containerRegistryPassword
          }
        : {})
    }
  : {}

var resolvedAppServiceDiagnosticSettings = !empty(appserviceDiagnosticSettings)
  ? appserviceDiagnosticSettings
  : [
      {
        name: 'appservice-diagnosticSettings'
        workspaceResourceId: logAnalyticsWorkspaceResourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]

var resolvedServicePlanDiagnosticSettings = !empty(servicePlanDiagnosticSettings)
  ? servicePlanDiagnosticSettings
  : [
      {
        name: 'servicePlan-diagnosticSettings'
        workspaceResourceId: logAnalyticsWorkspaceResourceId
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]

var resolvedAseDiagnosticSettings = !empty(aseDiagnosticSettings)
  ? aseDiagnosticSettings
  : [
      {
        name: 'ase-diagnosticSettings'
        workspaceResourceId: logAnalyticsWorkspaceResourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
      }
    ]

// ======================== //
// ASE                      //
// ======================== //

module aseEnvironment 'br/public:avm/res/web/hosting-environment:0.5.0' = if (deployAseV3) {
  name: '${uniqueString(deployment().name, location)}-ase-avm'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: resourceNames.aseName
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    subnetResourceId: networking.outputs.snetAppSvcResourceId
    clusterSettings: aseClusterSettings
    dedicatedHostCount: aseDedicatedHostCount != 0 ? aseDedicatedHostCount : null
    frontEndScaleFactor: aseFrontEndScaleFactor
    internalLoadBalancingMode: aseInternalLoadBalancingMode
    zoneRedundant: zoneRedundant
    networkConfiguration: {
      properties: {
        allowNewPrivateEndpointConnections: aseAllowNewPrivateEndpointConnections
        ftpEnabled: aseFtpEnabled
        inboundIpAddressOverride: aseInboundIpAddressOverride
        remoteDebugEnabled: aseRemoteDebugEnabled
      }
    }
    customDnsSuffixCertificateUrl: aseCustomDnsSuffixCertificateUrl
    customDnsSuffixKeyVaultReferenceIdentity: aseCustomDnsSuffixKeyVaultReferenceIdentity
    customDnsSuffix: aseCustomDnsSuffix
    dnsSuffix: !empty(aseDnsSuffix) ? aseDnsSuffix : null
    upgradePreference: aseUpgradePreference
    ipsslAddressCount: aseIpsslAddressCount
    multiSize: aseMultiSize
    managedIdentities: aseManagedIdentities
    diagnosticSettings: resolvedAseDiagnosticSettings
    lock: aseLock
    roleAssignments: aseRoleAssignments
  }
}


// Lookup ASE properties via a resource-group-scoped module to avoid ARM reference() validation issues
// in subscription-scoped templates with conditional existing resources.
module aseLookup './modules/networking/ase-lookup.bicep' = if (deployAseV3) {
  name: '${uniqueString(deployment().name, location)}-ase-lookup'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    aseName: resourceNames.aseName
  }
  dependsOn: [
    aseEnvironment
  ]
}

#disable-diagnostics BCP318
module asePrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.1' = if (deployAseV3) {
  name: '${uniqueString(deployment().name, location)}-ase-dnszone'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: '${aseEnvironment.outputs.name}.appserviceenvironment.net'
    virtualNetworkLinks: virtualNetworkLinks
    enableTelemetry: enableTelemetry
    tags: tags
    a: [
      {
        name: '*'
        aRecords: [
          {
            ipv4Address: aseLookup.outputs.internalInboundIpAddress
          }
        ]
        ttl: 3600
      }
      {
        name: '*.scm'
        aRecords: [
          {
            ipv4Address: aseLookup.outputs.internalInboundIpAddress
          }
        ]
        ttl: 3600
      }
      {
        name: '@'
        aRecords: [
          {
            ipv4Address: aseLookup.outputs.internalInboundIpAddress
          }
        ]
        ttl: 3600
      }
    ]
  }
}

// ======================== //
// App Insights             //
// ======================== //

module appInsights 'br/public:avm/res/insights/component:0.7.1' = {
  name: '${uniqueString(deployment().name, location)}-appInsights'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: 'appi-${resourceNames.webApp}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    workspaceResourceId: logAnalyticsWorkspaceResourceId
    applicationType: 'web'
    publicNetworkAccessForIngestion: appInsightsPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: appInsightsPublicNetworkAccessForQuery
    retentionInDays: appInsightsRetentionInDays
    samplingPercentage: appInsightsSamplingPercentage
    disableLocalAuth: appInsightsDisableLocalAuth
    disableIpMasking: appInsightsDisableIpMasking ?? true
    forceCustomerStorageForProfiler: appInsightsForceCustomerStorageForProfiler ?? false
    linkedStorageAccountResourceId: appInsightsLinkedStorageAccountResourceId
    flowType: appInsightsFlowType
    requestSource: appInsightsRequestSource
    kind: appInsightsKind ?? 'web'
    immediatePurgeDataOn30Days: appInsightsImmediatePurgeDataOn30Days
    ingestionMode: appInsightsIngestionMode
    lock: appInsightsLock
    roleAssignments: appInsightsRoleAssignments
    diagnosticSettings: appInsightsDiagnosticSettings
  }
}

// ======================== //
// App Service Plan         //
// ======================== //

module appServicePlan 'br/public:avm/res/web/serverfarm:0.7.0' = if (deployPlan) {
  name: '${uniqueString(deployment().name, location, 'webapp')}-plan'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: resourceNames.aspName
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    skuName: webAppPlanSku
    skuCapacity: skuCapacity
    zoneRedundant: zoneRedundant
    kind: isLinux ? 'Linux' : 'Windows'
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: deployAseV3 ? null : ((maximumElasticWorkerCount < 3 && zoneRedundant) ? 3 : maximumElasticWorkerCount)
    elasticScaleEnabled: deployAseV3 ? false : elasticScaleEnabled
    reserved: isLinux
    targetWorkerCount: (targetWorkerCount < 3 && zoneRedundant) ? 3 : targetWorkerCount
    targetWorkerSize: targetWorkerSize
    workerTierName: workerTierName
    hyperV: isWindowsContainer
    appServiceEnvironmentResourceId: aseEnvironment.?outputs.?resourceId ?? null
    virtualNetworkSubnetId: (isCustomMode ?? false) ? networking.outputs.snetAppSvcResourceId : appServicePlanVirtualNetworkSubnetId
    isCustomMode: isCustomMode ?? false
    rdpEnabled: rdpEnabled
    installScripts: installScripts
    registryAdapters: registryAdapters
    storageMounts: storageMounts
    managedIdentities: appServicePlanManagedIdentities
    diagnosticSettings: resolvedServicePlanDiagnosticSettings
    lock: appServicePlanLock
    roleAssignments: appServicePlanRoleAssignments
  }
}

// ======================== //
// Web App                  //
// ======================== //

module webAppSite 'br/public:avm/res/web/site:0.22.0' = {
  name: '${uniqueString(deployment().name, location)}-webapp'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    kind: webAppKind
    name: resourceNames.webApp
    location: location
    enableTelemetry: enableTelemetry
    serverFarmResourceId: resolvedServerFarmResourceId
    siteConfig: containerSiteConfig
    httpsOnly: httpsOnly
    clientAffinityEnabled: clientAffinityEnabled
    clientAffinityProxyEnabled: clientAffinityProxyEnabled ?? true
    clientAffinityPartitioningEnabled: clientAffinityPartitioningEnabled ?? false
    clientCertEnabled: clientCertEnabled
    clientCertMode: clientCertEnabled ? clientCertMode : null
    clientCertExclusionPaths: clientCertExclusionPaths
    publicNetworkAccess: !empty(webAppPublicNetworkAccess) ? webAppPublicNetworkAccess : null
    redundancyMode: redundancyMode
    scmSiteAlsoStopped: scmSiteAlsoStopped
    functionAppConfig: functionAppConfig
    managedEnvironmentResourceId: managedEnvironmentResourceId
    outboundVnetRouting: outboundVnetRouting
    hostNameSslStates: hostNameSslStates
    e2eEncryptionEnabled: e2eEncryptionEnabled
    keyVaultAccessIdentityResourceId: keyVaultAccessIdentityResourceId
    hybridConnectionRelays: hybridConnectionRelays
    extensions: webAppExtensions
    enabled: webAppEnabled
    cloningInfo: cloningInfo
    containerSize: containerSize
    dailyMemoryTimeQuota: dailyMemoryTimeQuota
    storageAccountRequired: storageAccountRequired
    dnsConfiguration: dnsConfiguration
    autoGeneratedDomainNameLabelScope: autoGeneratedDomainNameLabelScope
    sshEnabled: sshEnabled
    daprConfig: daprConfig
    ipMode: ipMode
    resourceConfig: resourceConfig
    workloadProfileName: workloadProfileName
    hostNamesDisabled: hostNamesDisabled
    reserved: webAppReserved ?? isLinux
    extendedLocation: extendedLocation
    basicPublishingCredentialsPolicies: disableBasicPublishingCredentials
      ? [
          {
            name: 'ftp'
            allow: false
          }
          {
            name: 'scm'
            allow: false
          }
        ]
      : null
    diagnosticSettings: resolvedAppServiceDiagnosticSettings
    lock: webAppLock
    roleAssignments: webAppRoleAssignments
    virtualNetworkSubnetResourceId: !deployAseV3 && !(isCustomMode ?? false) ? networking.outputs.snetAppSvcResourceId : null
    managedIdentities: {
      userAssignedResourceIds: [webAppUserAssignedManagedIdentity.outputs.resourceId]
    }
    configs: union(
      [
        {
          name: 'appsettings'
          applicationInsightResourceId: appInsights.outputs.resourceId
          properties: !empty(containerRegistryAppSettings) ? containerRegistryAppSettings : {}
        }
      ],
      !empty(appServiceStorageAccounts)
        ? [
            {
              name: 'azurestorageaccounts'
              properties: appServiceStorageAccounts
            }
          ]
        : []
    )
    slots: [
      {
        name: slotName
      }
    ]
    privateEndpoints: (!empty(subnetSpokePrivateEndpointAddressSpace) && !deployAseV3)
      ? [
          {
            name: 'webApp'
            subnetResourceId: networking.outputs.snetPeResourceId
            privateDnsZoneGroup: {
              name: 'webApp'
              privateDnsZoneGroupConfigs: [
                {
                  name: webAppDnsZoneName
                  privateDnsZoneResourceId: webAppPrivateDnsZone.?outputs.?resourceId ?? ''
                }
              ]
            }
          }
        ]
      : []
    tags: tags
  }
}

module webAppPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.8.1'= if (!empty(subnetSpokePrivateEndpointAddressSpace) && !deployAseV3) {
  name: '${uniqueString(deployment().name, location, 'webapp')}-dnszone'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: webAppDnsZoneName
    location: 'global'
    enableTelemetry: enableTelemetry
    virtualNetworkLinks: virtualNetworkLinks
    tags: tags
  }
}

module webAppUserAssignedManagedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.5.0' = {
  name: '${uniqueString(deployment().name, location, 'webapp')}-uami'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: resourceNames.appSvcUserAssignedManagedIdentity
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

module peWebAppSlot 'br/public:avm/res/network/private-endpoint:0.12.0' = if (!empty(subnetSpokePrivateEndpointAddressSpace) && !deployAseV3) {
  name: '${uniqueString(deployment().name, location, 'webapp')}-slot-${slotName}'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: take('pe-${resourceNames.webApp}-slot-${slotName}', 64)
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    privateDnsZoneGroup: (!empty(subnetSpokePrivateEndpointAddressSpace) && !deployAseV3)
      ? {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: webAppPrivateDnsZone.?outputs.?resourceId ?? ''
            }
          ]
        }
      : null
    subnetResourceId: networking.outputs.snetPeResourceId
    privateLinkServiceConnections: [
      {
        name: 'webApp'
        properties: {
          privateLinkServiceId: webAppSite.outputs.resourceId
          groupIds: ['sites-${slotName}']
        }
      }
    ]
  }
}

// ======================== //
// Front Door               //
// ======================== //

module afd './modules/front-door/front-door.module.bicep' = if (networkingOption == 'frontDoor') {
  name: '${uniqueString(deployment().name, location)}-afd'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    enableTelemetry: enableTelemetry
    afdName: '${resourceNames.frontDoor}${workloadName}'
    endpointName: resourceNames.frontDoorEndPoint
    originGroupName: resourceNames.frontDoorOriginGroup
    origins: [
      {
        hostname: webAppSite.outputs.defaultHostname
        enabledState: true
        privateLinkOrigin: {
          privateEndpointResourceId: webAppSite.outputs.resourceId
          privateLinkResourceType: 'sites'
          privateEndpointLocation: webAppSite.outputs.location
        }
      }
    ]
    skuName: 'Premium_AzureFrontDoor'
    enableDefaultWafMethodBlock: enableDefaultWafMethodBlock
    wafCustomRules: wafCustomRules
    healthProbePath: frontDoorHealthProbePath
    healthProbeIntervalInSeconds: frontDoorHealthProbeIntervalInSeconds
    customDomains: frontDoorCustomDomains
    ruleSets: frontDoorRuleSets
    secrets: frontDoorSecrets
    lock: frontDoorLock
    roleAssignments: frontDoorRoleAssignments
    originResponseTimeoutSeconds: frontDoorOriginResponseTimeoutSeconds
    wafPolicyName: resourceNames.frontDoorWaf
    diagnosticSettings: !empty(frontDoorDiagnosticSettings)
      ? frontDoorDiagnosticSettings
      : [
          {
            name: 'frontdoor-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                category: 'FrontdoorAccessLog'
              }
              {
                category: 'FrontdoorWebApplicationFirewallLog'
              }
            ]
          }
        ]
    tags: tags
  }
}

module autoApproveAfdPe './modules/front-door/approve-afd-pe.module.bicep' = if (autoApproveAfdPrivateEndpoint && networkingOption == 'frontDoor') {
  name: '${uniqueString(deployment().name, location)}-autoApproveAfdPe'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    enableTelemetry: enableTelemetry
    idAfdPeAutoApproverName: resourceNames.idAfdApprovePeAutoApprover
    tags: tags
  }
  dependsOn: [
    afd
  ]
}

// ======================== //
// Application Gateway      //
// ======================== //

module appGw './modules/networking/application-gateway.module.bicep' = if (networkingOption == 'applicationGateway') {
  name: '${uniqueString(deployment().name, location)}-appGw'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    appGwName: appGatewayConfig.?name ?? '${names.applicationGateway.name}-${workloadName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    subnetResourceId: networking.outputs.snetAppGwResourceId
    backendHostName: webAppSite.outputs.defaultHostname
    healthProbePath: appGatewayHealthProbePath
    lock: appGatewayLock
    managedIdentities: appGatewayManagedIdentities
    sslCertificates: appGatewaySslCertificates
    trustedRootCertificates: appGatewayTrustedRootCertificates
    sslPolicyType: appGatewaySslPolicyType
    sslPolicyName: appGatewaySslPolicyName
    sslPolicyMinProtocolVersion: appGatewaySslPolicyMinProtocolVersion
    sslPolicyCipherSuites: appGatewaySslPolicyCipherSuites
    roleAssignments: appGatewayRoleAssignments
    authenticationCertificates: appGatewayAuthenticationCertificates
    customErrorConfigurations: appGatewayCustomErrorConfigurations
    enableFips: appGatewayEnableFips
    enableHttp2: appGatewayEnableHttp2
    enableRequestBuffering: appGatewayEnableRequestBuffering
    enableResponseBuffering: appGatewayEnableResponseBuffering
    loadDistributionPolicies: appGatewayLoadDistributionPolicies
    privateEndpoints: appGatewayPrivateEndpoints
    privateLinkConfigurations: appGatewayPrivateLinkConfigurations
    redirectConfigurations: appGatewayRedirectConfigurations
    rewriteRuleSets: appGatewayRewriteRuleSets
    sslProfiles: appGatewaySslProfiles
    trustedClientCertificates: appGatewayTrustedClientCertificates
    urlPathMaps: appGatewayUrlPathMaps
    backendSettingsCollection: appGatewayBackendSettingsCollection
    listeners: appGatewayListeners
    routingRules: appGatewayRoutingRules
    diagnosticSettings: !empty(appGatewayDiagnosticSettings)
      ? appGatewayDiagnosticSettings
      : [
          {
            name: 'appgw-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// ======================== //
// Supporting Services      //
// ======================== //

@description('Azure Key Vault used to hold items like TLS certs and application secrets that your workload will need.')
module keyVault './modules/supporting-services/modules/key-vault.bicep' = {
  name: '${uniqueString(deployment().name, location)}-keyVault'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    keyVaultName: names.keyVault.nameUnique
    tags: tags
    enableTelemetry: enableTelemetry
    hubVNetResourceId: vnetHubResourceId
    spokeVNetResourceId: networking.outputs.vnetSpokeResourceId
    spokePrivateEndpointSubnetName: networking.outputs.snetPeName
    appServiceManagedIdentityPrincipalId: webAppUserAssignedManagedIdentity.outputs.principalId
    lock: keyVaultLock
    enablePurgeProtection: keyVaultEnablePurgeProtection
    softDeleteRetentionInDays: keyVaultSoftDeleteRetentionInDays
    additionalRoleAssignments: keyVaultAdditionalRoleAssignments
    accessPolicies: keyVaultAccessPolicies
    secrets: keyVaultSecrets
    keys: keyVaultKeys
    enableVaultForTemplateDeployment: keyVaultEnableVaultForTemplateDeployment
    enableVaultForDiskEncryption: keyVaultEnableVaultForDiskEncryption
    createMode: keyVaultCreateMode
    keyVaultSku: keyVaultSku
    enableRbacAuthorization: keyVaultEnableRbacAuthorization
    enableVaultForDeployment: keyVaultEnableVaultForDeployment
    networkAcls: keyVaultNetworkAcls
    keyVaultPublicNetworkAccess: keyVaultPublicNetworkAccess
    diagnosticSettings: !empty(keyVaultDiagnosticSettings)
      ? keyVaultDiagnosticSettings
      : [
          {
            name: 'keyvault-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
  }
}

// ======================== //
// Telemetry                //
// ======================== //

#disable-next-line no-deployments-resources use-recent-api-versions
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.appsvclza-hostingenvironment.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

// ================ //
// Outputs          //
// ================ //

@description('The name of the Spoke resource group.')
output spokeResourceGroupName string = spokeResourceGroup.outputs.name

@description('The resource ID of the Spoke Virtual Network.')
output spokeVNetResourceId string = networking.outputs.vnetSpokeResourceId

@description('The name of the Spoke Virtual Network.')
output spokeVnetName string = networking.outputs.vnetSpokeName

@description('The resource ID of the key vault.')
output keyVaultResourceId string = keyVault.outputs.keyVaultResourceId

@description('The name of the Azure key vault.')
output keyVaultName string = keyVault.outputs.keyVaultName

@description('The name of the web app.')
output webAppName string = webAppSite.outputs.name

@description('The default hostname of the web app.')
output webAppHostName string = webAppSite.outputs.defaultHostname

@description('The resource ID of the web app.')
output webAppResourceId string = webAppSite.outputs.resourceId

@description('The location of the web app.')
output webAppLocation string = webAppSite.outputs.location

@description('The principal ID of the user-assigned managed identity for the web app.')
output webAppManagedIdentityPrincipalId string = webAppUserAssignedManagedIdentity.outputs.principalId

@description('The resource ID of the App Service Plan used (either created or pre-existing).')
output appServicePlanResourceId string = resolvedServerFarmResourceId

@description('The Internal ingress IP of the ASE.')
output internalInboundIpAddress string = aseLookup.?outputs.?internalInboundIpAddress ?? ''

@description('The name of the ASE.')
output aseName string = aseEnvironment.?outputs.?name ?? ''
