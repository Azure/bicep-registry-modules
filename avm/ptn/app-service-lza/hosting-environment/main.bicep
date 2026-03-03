targetScope = 'subscription'

metadata name = 'App Service Landing Zone Accelerator'
metadata description = 'This Azure App Service pattern module represents an Azure App Service deployment aligned with the cloud adoption framework'

// ================ //
// Parameters       //
// ================ //

import {
  diagnosticSettingFullType
  diagnosticSettingMetricsOnlyType
  diagnosticSettingLogsOnlyType
  lockType
  roleAssignmentType
  managedIdentityAllType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

@maxLength(10)
@description('Optional. suffix (max 10 characters long) that will be used to name the resources in a pattern like <resourceAbbreviation>-<workloadName>.')
param workloadName string = 'appsvc${take( uniqueString( subscription().id), 4) }'

@description('Optional. Azure region where the resources will be deployed in.')
param location string = deployment().location

@description('Optional. The name of the environmentName (e.g. "dev", "test", "prod", "preprod", "staging", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environmentName string = 'test'

@description('Optional. Default is false. Set to true if you want to deploy ASE v3 instead of Multitenant App Service Plan.')
param deployAseV3 bool = false

@description('Optional. CIDR of the SPOKE vnet i.e. 192.168.0.0/24.')
param vnetSpokeAddressSpace string = '10.240.0.0/20'

@description('Optional. CIDR of the subnet that will hold the app services plan. ATTENTION: ASEv3 needs a /24 network.')
param subnetSpokeAppSvcAddressSpace string = '10.240.0.0/26'

@description('Optional. CIDR of the subnet that will hold the jumpbox.')
param subnetSpokeJumpboxAddressSpace string = '10.240.10.128/26'

@description('Optional. CIDR of the subnet that will hold the private endpoints of the supporting services.')
param subnetSpokePrivateEndpointAddressSpace string = '10.240.11.0/24'

@description('Optional. Default is empty. If given, peering between spoke and and existing hub vnet will be created.')
param vnetHubResourceId string = ''

@description('Optional. Internal IP of the Azure firewall deployed in Hub. Used for creating UDR to route all vnet egress traffic through Firewall. If empty no UDR.')
param firewallInternalIp string = ''

@description('Optional. The size of the jump box virtual machine to create. See https://learn.microsoft.com/azure/virtual-machines/sizes for more information.')
param vmSize string = 'Standard_D2s_v4'

// See https://learn.microsoft.com/azure/app-service/overview-hosting-plans for available SKUs and tiers.
@description('Optional. The name of the SKU for the App Service Plan. Determines the tier, size, family and capacity. Defaults to P1V3 to leverage availability zones. EP* SKUs are only for Azure Functions elastic premium plans.')
@metadata({
  example: '''
  // Premium v4
  'P0v4'
  'P1v4'
  'P2v4'
  'P3v4'
  // Premium Memory Optimized v4
  'P1mv4'
  'P3mv4'
  'P4mv4'
  'P5mv4'
  // Isolated v2
  'I1v2'
  'I2v2'
  'I3v2'
  'I4v2'
  'I5v2'
  'I6v2'
  // Functions Elastic Premium
  'EP1'
  'EP2'
  'EP3'
  '''
})
param webAppPlanSku resourceInput<'Microsoft.Web/serverfarms@2025-03-01'>.sku.name = 'P1V3'

@description('Optional. Set to true if you want to deploy the App Service Plan in a zone redundant manner. Default is true.')
param zoneRedundant bool = true

@description('Optional. Kind of server OS of the App Service Plan. Default is "windows".')
@allowed(['windows', 'linux'])
param webAppBaseOs string = 'windows'

@description('Conditional. Required if jumpbox deployed. The username of the admin user of the jumpbox VM.')
param adminUsername string = 'azureuser'

@description('Conditional. Required if jumpbox deployed and not using SSH key. The password of the admin user of the jumpbox VM.')
@secure()
param adminPassword string = ''

@description('Optional. Set to true if you want to intercept all outbound traffic with azure firewall.')
param enableEgressLockdown bool = false

@description('Optional. Set to true if you want to deploy a jumpbox/devops VM.')
param deployJumpHost bool = true

@description('Optional. Type of authentication to use on the Virtual Machine. SSH key is recommended. Default is "password".')
@allowed([
  'sshPublicKey'
  'password'
])
param vmAuthenticationType string = 'password'

@description('Optional. The resource ID of the bastion host. If set, the spoke virtual network will be peered with the hub virtual network and the bastion host will be allowed to connect to the jump box. Default is empty.')
param bastionResourceId string = ''

@description('Optional. Tags to apply to all resources.')
param tags object = {}

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. The resource ID of the Log Analytics workspace managed by the Platform Landing Zone. All diagnostic settings will be configured to send logs and metrics to this workspace.')
param logAnalyticsWorkspaceResourceId string

@description('Optional. Set to true if you want to auto-approve the private endpoint connection to the Azure Front Door.')
param autoApproveAfdPrivateEndpoint bool = true

@description('Optional. Default is windows. The OS of the jump box virtual machine to create.')
@allowed(['linux', 'windows', 'none'])
param vmJumpboxOSType string = 'windows'

@description('Optional. Diagnostic Settings for the App Service.')
param appserviceDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the App Service Plan.')
param servicePlanDiagnosticSettings diagnosticSettingMetricsOnlyType[] = []

@description('Optional. Diagnostic Settings for the ASE.')
param aseDiagnosticSettings diagnosticSettingLogsOnlyType[] = []

@description('Optional. Diagnostic Settings for Front Door.')
param frontDoorDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the Application Gateway.')
param appGatewayDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the KeyVault.')
param keyVaultDiagnosticSettings diagnosticSettingFullType[] = []

@description('Optional. Diagnostic Settings for the spoke virtual network.')
param vnetDiagnosticSettings diagnosticSettingFullType[] = []

// ======================== //
// Governance & Security    //
// ======================== //

@description('Optional. Specify the type of resource lock for the Web App.')
param webAppLock lockType?

@description('Optional. Role assignments to apply to the Web App.')
param webAppRoleAssignments roleAssignmentType[]?

@description('Optional. Specify the type of resource lock for the App Service Plan.')
param appServicePlanLock lockType?

@description('Optional. Role assignments to apply to the App Service Plan.')
param appServicePlanRoleAssignments roleAssignmentType[]?

@description('Optional. Specify the type of resource lock for the Key Vault.')
param keyVaultLock lockType?

@description('Optional. Additional role assignments for the Key Vault beyond the default App Service identity.')
param keyVaultAdditionalRoleAssignments roleAssignmentType[]?

@description('Optional. Specify the type of resource lock for the spoke virtual network.')
param vnetLock lockType?

@description('Optional. Specify the type of resource lock for the Front Door profile.')
param frontDoorLock lockType?

@description('Optional. Specify the type of resource lock for the Application Gateway.')
param appGatewayLock lockType?

@description('Optional. Enable purge protection for the Key Vault. Defaults to true.')
param keyVaultEnablePurgeProtection bool = true

@description('Optional. Soft delete retention in days for the Key Vault. Defaults to 90.')
param keyVaultSoftDeleteRetentionInDays int = 90

@description('Optional. Access policies for the Key Vault (non-RBAC mode).')
param keyVaultAccessPolicies array?

@description('Optional. Secrets to create in the Key Vault.')
param keyVaultSecrets array?

@description('Optional. Keys to create in the Key Vault.')
param keyVaultKeys array?

@description('Optional. Enable the Key Vault for template deployment.')
param keyVaultEnableVaultForTemplateDeployment bool = true

@description('Optional. Enable the Key Vault for disk encryption.')
param keyVaultEnableVaultForDiskEncryption bool = true

@description('Optional. The create mode for the Key Vault (default or recover).')
@allowed(['default', 'recover'])
param keyVaultCreateMode string = 'default'

@description('Optional. The SKU of the Key Vault.')
@allowed(['standard', 'premium'])
param keyVaultSku string = 'standard'

@description('Optional. Enable RBAC authorization on the Key Vault. Defaults to true.')
param keyVaultEnableRbacAuthorization bool = true

@description('Optional. Enable the Key Vault for deployment. Defaults to true.')
param keyVaultEnableVaultForDeployment bool = true

@description('Optional. Network ACLs for the Key Vault.')
param keyVaultNetworkAcls object?

@description('Optional. Public network access for the Key Vault.')
@allowed(['Enabled', 'Disabled', ''])
param keyVaultPublicNetworkAccess string = 'Disabled'

@description('Optional. Set to true to enable client certificate authentication (mTLS) on the web app.')
param clientCertEnabled bool = false

@description('Optional. Client certificate mode. Only used when clientCertEnabled is true.')
@allowed(['Optional', 'OptionalInteractiveUser', 'Required'])
param clientCertMode string = 'Required'

@description('Optional. Disable basic publishing credentials (FTP/SCM) on the web app. Defaults to true for security.')
param disableBasicPublishingCredentials bool = true

@description('Optional. Property to allow or block public network access to the web app.')
@allowed(['Enabled', 'Disabled', ''])
param webAppPublicNetworkAccess string = ''

// ======================== //
// Web App Advanced         //
// ======================== //

@description('Optional. Configures the web app to accept only HTTPS requests.')
param httpsOnly bool = true

@description('Optional. Client certificate authentication exclusion paths (comma-separated).')
param clientCertExclusionPaths string?

@description('Optional. Site redundancy mode.')
@allowed(['ActiveActive', 'Failover', 'GeoRedundant', 'Manual', 'None'])
param redundancyMode string = 'None'

@description('Optional. Stop SCM (Kudu) site when the app is stopped.')
param scmSiteAlsoStopped bool = false

@description('Optional. The Function App configuration object.')
param functionAppConfig object?

@description('Optional. The managed environment resource ID for Azure Container Apps scenarios.')
param managedEnvironmentResourceId string?

@description('Optional. The outbound VNET routing configuration for the site.')
param outboundVnetRouting object?

@description('Optional. Hostname SSL states for managing SSL bindings.')
param hostNameSslStates array?

@description('Optional. Enable end-to-end encryption (used with ASE).')
param e2eEncryptionEnabled bool?

@description('Optional. The resource ID of the identity to use for Key Vault references.')
param keyVaultAccessIdentityResourceId string?

@description('Optional. Names of hybrid connection relays to connect the app with.')
param hybridConnectionRelays array?

@description('Optional. Extensions configuration for the web app.')
param webAppExtensions array?

@description('Optional. Setting this value to false disables the app (takes the app offline).')
param webAppEnabled bool = true

@description('Optional. If specified during app creation, the app is cloned from a source app.')
param cloningInfo object?

@description('Optional. Size of the function container.')
param containerSize int?

@description('Optional. Maximum allowed daily memory-time quota (applicable on dynamic apps only).')
param dailyMemoryTimeQuota int?

@description('Optional. Whether customer-provided storage account is required.')
param storageAccountRequired bool = false

@description('Optional. Property to configure DNS-related settings for the site.')
param dnsConfiguration object?

@description('Optional. Specifies the scope of uniqueness for the default hostname during resource creation.')
param autoGeneratedDomainNameLabelScope string?

@description('Optional. Whether to enable SSH access.')
param sshEnabled bool?

@description('Optional. Dapr configuration for the app (Container Apps).')
param daprConfig object?

@description('Optional. Specifies the IP mode of the app.')
param ipMode string?

@description('Optional. Function app resource requirements.')
param resourceConfig object?

@description('Optional. Workload profile name for function app to execute on.')
param workloadProfileName string?

@description('Optional. True to disable the public hostnames of the app.')
param hostNamesDisabled bool?

@description('Optional. True if reserved (Linux). Overrides auto-detection when set.')
param webAppReserved bool?

@description('Optional. Extended location of the web app resource.')
param extendedLocation object?

@description('Optional. If client affinity is enabled on the web app.')
param clientAffinityEnabled bool = false

@description('Optional. Proxy-based client affinity enabled on the web app.')
param clientAffinityProxyEnabled bool?

@description('Optional. Partitioned client affinity using CHIPS cookies.')
param clientAffinityPartitioningEnabled bool?

// ======================== //
// Service Plan Advanced    //
// ======================== //

@description('Optional. The SKU capacity (number of workers) for the App Service Plan.')
param skuCapacity int?

@description('Optional. Target worker tier assigned to the App Service Plan.')
param workerTierName string?

@description('Optional. Whether elastic scale is enabled on the App Service Plan.')
param elasticScaleEnabled bool?

@description('Optional. The resource ID of a subnet for VNet integration on the App Service Plan level.')
param appServicePlanVirtualNetworkSubnetId string?

@description('Optional. Whether the App Service Plan uses custom mode.')
param isCustomMode bool?

@description('Optional. Whether RDP is enabled on the App Service Plan.')
param rdpEnabled bool?

@description('Optional. Install scripts for the App Service Plan.')
param installScripts array?

@description('Optional. The default identity for the App Service Plan.')
param planDefaultIdentity resourceInput<'Microsoft.Web/serverfarms@2025-03-01'>.properties.planDefaultIdentity?

@description('Optional. Registry adapter configuration for the App Service Plan.')
param registryAdapters array?

@description('Optional. Storage mount configuration for the App Service Plan.')
param storageMounts array?

@description('Optional. Managed identities for the App Service Plan.')
param appServicePlanManagedIdentities managedIdentityAllType?

// ======================== //
// App Insights Settings    //
// ======================== //

@description('Optional. Public network access for App Insights ingestion. Defaults to Disabled for secure baseline.')
@allowed(['Enabled', 'Disabled'])
param appInsightsPublicNetworkAccessForIngestion string = 'Disabled'

@description('Optional. Public network access for App Insights query. Defaults to Disabled for secure baseline.')
@allowed(['Enabled', 'Disabled'])
param appInsightsPublicNetworkAccessForQuery string = 'Disabled'

@description('Optional. App Insights data retention in days. Defaults to 90.')
param appInsightsRetentionInDays int = 90

@description('Optional. App Insights sampling percentage (1-100). Defaults to 100.')
param appInsightsSamplingPercentage int = 100

@description('Optional. Disable non-AAD based auth on App Insights. Defaults to true.')
param appInsightsDisableLocalAuth bool = true

@description('Optional. Disable IP masking in App Insights.')
param appInsightsDisableIpMasking bool?

@description('Optional. Force customer storage for profiler in App Insights.')
param appInsightsForceCustomerStorageForProfiler bool?

@description('Optional. Linked storage account resource ID for App Insights.')
param appInsightsLinkedStorageAccountResourceId string?

@description('Optional. Flow type for App Insights.')
param appInsightsFlowType string?

@description('Optional. Request source for App Insights.')
param appInsightsRequestSource string?

@description('Optional. Kind of App Insights resource.')
param appInsightsKind string?

@description('Optional. Purge data immediately after 30 days in App Insights.')
param appInsightsImmediatePurgeDataOn30Days bool?

@description('Optional. Ingestion mode for App Insights.')
@allowed(['ApplicationInsights', 'ApplicationInsightsWithDiagnosticSettings', 'LogAnalytics'])
param appInsightsIngestionMode string?

@description('Optional. Specify the type of resource lock for App Insights.')
param appInsightsLock lockType?

@description('Optional. Role assignments for App Insights.')
param appInsightsRoleAssignments roleAssignmentType[]?

@description('Optional. Diagnostic Settings for App Insights.')
param appInsightsDiagnosticSettings diagnosticSettingFullType[]?

// ======================== //
// Networking Advanced      //
// ======================== //

@description('Optional. Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used.')
param dnsServers string[] = []

@description('Optional. The resource ID of a DDoS Protection Plan to associate with the spoke VNet.')
param ddosProtectionPlanResourceId string = ''

@description('Optional. Whether to disable BGP route propagation on the route table. Defaults to true.')
param disableBgpRoutePropagation bool = true

@description('Optional. Role assignments for the spoke virtual network.')
param vnetRoleAssignments roleAssignmentType[]?

@description('Optional. Enable VNet encryption.')
param vnetEncryption bool = false

@description('Optional. VNet encryption enforcement. Only used when vnetEncryption is true.')
@allowed(['AllowUnencrypted', 'DropUnencrypted'])
param vnetEncryptionEnforcement string = 'AllowUnencrypted'

@description('Optional. The flow timeout in minutes for the VNet (max 30). 0 means disabled.')
param flowTimeoutInMinutes int = 0

@description('Optional. Enable VM protection for the VNet.')
param enableVmProtection bool?

@description('Optional. The BGP community for the VNet.')
param virtualNetworkBgpCommunity string?

// ======================== //
// Application Gateway Adv  //
// ======================== //

@description('Optional. SSL certificates for the Application Gateway. Required for HTTPS termination.')
param appGatewaySslCertificates array?

@description('Optional. Managed identities for the Application Gateway. Required for Key Vault-referenced SSL certificates.')
param appGatewayManagedIdentities managedIdentityAllType?

@description('Optional. Trusted root certificates for end-to-end SSL.')
param appGatewayTrustedRootCertificates array?

@description('Optional. The SSL policy type for the Application Gateway.')
@allowed(['Custom', 'CustomV2', 'Predefined'])
param appGatewaySslPolicyType string?

@description('Optional. The predefined SSL policy name for the Application Gateway.')
param appGatewaySslPolicyName string?

@description('Optional. Minimum TLS protocol version for the Application Gateway.')
@allowed(['TLSv1_2', 'TLSv1_3'])
param appGatewaySslPolicyMinProtocolVersion string?

@description('Optional. SSL cipher suites for the Application Gateway.')
param appGatewaySslPolicyCipherSuites string[] = []

@description('Optional. Role assignments for the Application Gateway.')
param appGatewayRoleAssignments roleAssignmentType[]?

@description('Optional. Authentication certificates for Application Gateway backend auth.')
param appGatewayAuthenticationCertificates array = []

@description('Optional. Custom error configurations for the Application Gateway.')
param appGatewayCustomErrorConfigurations array = []

@description('Optional. Whether FIPS mode is enabled on the Application Gateway.')
param appGatewayEnableFips bool = false

@description('Optional. Whether HTTP/2 is enabled on the Application Gateway. Defaults to true.')
param appGatewayEnableHttp2 bool = true

@description('Optional. Whether request buffering is enabled on the Application Gateway.')
param appGatewayEnableRequestBuffering bool = false

@description('Optional. Whether response buffering is enabled on the Application Gateway.')
param appGatewayEnableResponseBuffering bool = false

@description('Optional. Load distribution policies for the Application Gateway.')
param appGatewayLoadDistributionPolicies array = []

@description('Optional. Private endpoints for the Application Gateway.')
param appGatewayPrivateEndpoints array?

@description('Optional. Private link configurations for the Application Gateway.')
param appGatewayPrivateLinkConfigurations array = []

@description('Optional. Redirect configurations for the Application Gateway.')
param appGatewayRedirectConfigurations array = []

@description('Optional. Rewrite rule sets for the Application Gateway.')
param appGatewayRewriteRuleSets array = []

@description('Optional. SSL profiles for the Application Gateway.')
param appGatewaySslProfiles array = []

@description('Optional. Trusted client certificates for mTLS on the Application Gateway.')
param appGatewayTrustedClientCertificates array = []

@description('Optional. URL path maps for path-based routing on the Application Gateway.')
param appGatewayUrlPathMaps array = []

@description('Optional. Backend settings collection (v2) for the Application Gateway.')
param appGatewayBackendSettingsCollection array = []

@description('Optional. Listeners (v2) for the Application Gateway.')
param appGatewayListeners array = []

@description('Optional. Routing rules (v2) for the Application Gateway.')
param appGatewayRoutingRules array = []

// ======================== //
// Front Door Advanced      //
// ======================== //

@description('Optional. Whether to deploy the default WAF custom rule that blocks non-GET/HEAD/OPTIONS methods. Set to false for API backends.')
param enableDefaultWafMethodBlock bool = true

@description('Optional. Custom WAF rules. Only used when enableDefaultWafMethodBlock is false.')
param wafCustomRules object?

@description('Optional. Health probe path for the Front Door origin group.')
param frontDoorHealthProbePath string = '/'

@description('Optional. Health probe interval in seconds for the Front Door origin group.')
param frontDoorHealthProbeIntervalInSeconds int = 100

@description('Optional. Custom domains for the Front Door profile.')
param frontDoorCustomDomains array?

@description('Optional. Rule sets for the Front Door profile.')
param frontDoorRuleSets array?

@description('Optional. Secrets for the Front Door profile (e.g. BYOC certificates).')
param frontDoorSecrets array?

@description('Optional. Role assignments for the Front Door profile.')
param frontDoorRoleAssignments roleAssignmentType[]?

@description('Optional. The time in seconds before the Front Door origin response times out. Defaults to 120.')
param frontDoorOriginResponseTimeoutSeconds int = 120

// ======================== //
// Networking Option        //
// ======================== //

@description('Optional. The networking option to use for ingress. Options: frontDoor (Azure Front Door with WAF), applicationGateway (Application Gateway with WAF), none.')
@allowed(['frontDoor', 'applicationGateway', 'none'])
param networkingOption string = 'frontDoor'

@description('Optional. CIDR of the subnet that will hold the Application Gateway. Required if networkingOption is "applicationGateway".')
param subnetSpokeAppGwAddressSpace string = ''

// ======================== //
// Bring-Your-Own-Service   //
// ======================== //

@description('Optional. The resource ID of an existing App Service Plan. If provided, the module will skip creating a new plan and deploy the web app on the existing one.')
param existingAppServicePlanId string = ''

// ======================== //
// Web App Kind & Container //
// ======================== //

@description('Optional. Kind of web app to deploy. Use "app" for standard web apps, "app,linux" for Linux, "app,linux,container" for Linux containers, etc.')
@allowed([
  'api'
  'app'
  'app,container,windows'
  'app,linux'
  'app,linux,container'
  'functionapp'
  'functionapp,linux'
  'functionapp,linux,container'
  'functionapp,linux,container,azurecontainerapps'
  'functionapp,workflowapp'
  'functionapp,workflowapp,linux'
  'linux,api'
])
param webAppKind string = 'app'

@description('Optional. The container image name for container-based deployments (e.g. "mcr.microsoft.com/appsvc/staticsite:latest").')
param containerImageName string = ''

@description('Optional. The container registry URL for private registries (e.g. "https://myregistry.azurecr.io").')
param containerRegistryUrl string = ''

@description('Optional. The container registry username for private registries.')
param containerRegistryUsername string = ''

@description('Optional. The container registry password for private registries.')
@secure()
param containerRegistryPassword string = ''

// ======================== //
// ASE Advanced             //
// ======================== //

@description('Optional. Role assignments for the ASE.')
param aseRoleAssignments roleAssignmentType[]?

@description('Optional. Custom DNS suffix for the ASE.')
param aseCustomDnsSuffix string?

@description('Optional. Number of IP SSL addresses reserved for the ASE.')
param aseIpsslAddressCount int?

@description('Optional. Front-end VM size for the ASE.')
param aseMultiSize string?

@description('Optional. Managed identities for the ASE.')
param aseManagedIdentities managedIdentityAllType?

@description('Optional. Specify the type of resource lock for the ASE.')
param aseLock lockType?

// ======================== //
// Custom Resource Names    //
// ======================== //

@description('Optional. Custom resource names. Any property not provided falls back to the naming-module default. Use this to comply with organization-specific naming policies without overriding the naming module entirely.')
param customResourceNames {
  @description('Optional. Custom name for the spoke resource group.')
  resourceGroupName: string?

  @description('Optional. Custom name for the App Service Environment.')
  aseName: string?

  @description('Optional. Custom name for the App Service Plan.')
  appServicePlanName: string?

  @description('Optional. Custom name for the Web App.')
  webAppName: string?

  @description('Optional. Custom name for the App Service managed identity.')
  appSvcManagedIdentityName: string?

  @description('Optional. Custom name for the Front Door profile.')
  frontDoorName: string?

  @description('Optional. Custom name for the Front Door endpoint.')
  frontDoorEndpointName: string?

  @description('Optional. Custom name for the Front Door WAF policy.')
  frontDoorWafName: string?

  @description('Optional. Custom name for the Front Door origin group.')
  frontDoorOriginGroupName: string?

  @description('Optional. Custom name for the DevOps subnet.')
  devOpsSubnetName: string?

  @description('Optional. Custom name for the jumpbox NSG.')
  jumpboxNsgName: string?

  @description('Optional. Custom name for the AFD private-endpoint auto-approver managed identity.')
  afdPeAutoApproverName: string?
}?

// ================ //
// Variables        //
// ================ //

var resourceSuffix = '${workloadName}-${environmentName}-${location}'
var resourceGroupName = customResourceNames.?resourceGroupName ?? 'rg-spoke-${resourceSuffix}'

var names = naming.outputs.names
var resourceNames = {
  aseName: customResourceNames.?aseName ?? names.appServiceEnvironment.nameUnique
  aspName: customResourceNames.?appServicePlanName ?? names.appServicePlan.name
  webApp: customResourceNames.?webAppName ?? names.appService.nameUnique
  appSvcUserAssignedManagedIdentity: customResourceNames.?appSvcManagedIdentityName ?? take('${names.managedIdentity.name}-appSvc', 128)
  frontDoorEndPoint: customResourceNames.?frontDoorEndpointName ?? 'webAppLza-${take(uniqueString(resourceGroupName), 6)}'
  frontDoorWaf: customResourceNames.?frontDoorWafName ?? names.frontDoorFirewallPolicy.name
  frontDoor: customResourceNames.?frontDoorName ?? names.frontDoor.name
  frontDoorOriginGroup: customResourceNames.?frontDoorOriginGroupName ?? '${names.frontDoor.name}-originGroup'
  snetDevOps: customResourceNames.?devOpsSubnetName ?? 'snet-devOps-${names.virtualNetwork.name}-spoke'
  jumpboxNsg: customResourceNames.?jumpboxNsgName ?? take('${names.networkSecurityGroup.name}-jumpbox', 80)
  idAfdApprovePeAutoApprover: customResourceNames.?afdPeAutoApproverName ?? take('${names.managedIdentity.name}-AfdApprovePe', 128)
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
// App Service              //
// ======================== //

module webApp './modules/app-service/app-service.module.bicep' = {
  name: '${uniqueString(deployment().name, location)}-webApp'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    enableTelemetry: enableTelemetry
    deployAseV3: deployAseV3
    aseName: resourceNames.aseName
    appServicePlanName: resourceNames.aspName
    webAppName: resourceNames.webApp
    managedIdentityName: resourceNames.appSvcUserAssignedManagedIdentity
    location: location
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    subnetIdForVnetInjection: networking.outputs.snetAppSvcResourceId
    tags: tags
    webAppBaseOs: webAppBaseOs
    zoneRedundant: zoneRedundant
    subnetPrivateEndpointResourceId: networking.outputs.snetPeResourceId
    virtualNetworkLinks: virtualNetworkLinks
    sku: webAppPlanSku
    kind: webAppKind
    existingAppServicePlanId: existingAppServicePlanId
    containerImageName: containerImageName
    containerRegistryUrl: containerRegistryUrl
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
    webAppLock: webAppLock
    webAppRoleAssignments: webAppRoleAssignments
    appServicePlanLock: appServicePlanLock
    appServicePlanRoleAssignments: appServicePlanRoleAssignments
    clientCertEnabled: clientCertEnabled
    clientCertMode: clientCertMode
    disableBasicPublishingCredentials: disableBasicPublishingCredentials
    webAppPublicNetworkAccess: webAppPublicNetworkAccess
    appInsightsPublicNetworkAccessForIngestion: appInsightsPublicNetworkAccessForIngestion
    appInsightsPublicNetworkAccessForQuery: appInsightsPublicNetworkAccessForQuery
    appInsightsRetentionInDays: appInsightsRetentionInDays
    appInsightsSamplingPercentage: appInsightsSamplingPercentage
    appInsightsDisableLocalAuth: appInsightsDisableLocalAuth
    appInsightsDisableIpMasking: appInsightsDisableIpMasking
    appInsightsForceCustomerStorageForProfiler: appInsightsForceCustomerStorageForProfiler
    appInsightsLinkedStorageAccountResourceId: appInsightsLinkedStorageAccountResourceId
    appInsightsFlowType: appInsightsFlowType
    appInsightsRequestSource: appInsightsRequestSource
    appInsightsKind: appInsightsKind
    appInsightsImmediatePurgeDataOn30Days: appInsightsImmediatePurgeDataOn30Days
    appInsightsIngestionMode: appInsightsIngestionMode
    appInsightsLock: appInsightsLock
    appInsightsRoleAssignments: appInsightsRoleAssignments
    appInsightsDiagnosticSettings: appInsightsDiagnosticSettings
    httpsOnly: httpsOnly
    clientCertExclusionPaths: clientCertExclusionPaths
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
    webAppEnabled: webAppEnabled
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
    webAppReserved: webAppReserved
    extendedLocation: extendedLocation
    clientAffinityEnabled: clientAffinityEnabled
    clientAffinityProxyEnabled: clientAffinityProxyEnabled
    clientAffinityPartitioningEnabled: clientAffinityPartitioningEnabled
    skuCapacity: skuCapacity
    workerTierName: workerTierName
    elasticScaleEnabled: elasticScaleEnabled
    appServicePlanVirtualNetworkSubnetId: appServicePlanVirtualNetworkSubnetId
    isCustomMode: isCustomMode
    rdpEnabled: rdpEnabled
    installScripts: installScripts
    planDefaultIdentity: planDefaultIdentity
    registryAdapters: registryAdapters
    storageMounts: storageMounts
    appServicePlanManagedIdentities: appServicePlanManagedIdentities
    aseRoleAssignments: aseRoleAssignments
    aseCustomDnsSuffix: aseCustomDnsSuffix
    aseIpsslAddressCount: aseIpsslAddressCount
    aseMultiSize: aseMultiSize
    aseManagedIdentities: aseManagedIdentities
    aseLock: aseLock
    appserviceDiagnosticSettings: !empty(appserviceDiagnosticSettings)
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
    servicePlanDiagnosticSettings: !empty(servicePlanDiagnosticSettings)
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
    aseDiagnosticSettings: !empty(aseDiagnosticSettings)
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
        hostname: webApp.outputs.webAppHostName
        enabledState: true
        privateLinkOrigin: {
          privateEndpointResourceId: webApp.outputs.webAppResourceId
          privateLinkResourceType: 'sites'
          privateEndpointLocation: webApp.outputs.webAppLocation
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
    appGwName: '${names.applicationGateway.name}-${workloadName}'
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    subnetResourceId: networking.outputs.snetAppGwResourceId
    backendHostName: webApp.outputs.webAppHostName
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
    appServiceManagedIdentityPrincipalId: webApp.outputs.webAppSystemAssignedPrincipalId
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
// Jumpbox VMs              //
// ======================== //

@description('An optional Linux virtual machine deployment to act as a jump box.')
module jumpboxLinuxVM './modules/compute/linux-vm.bicep' = if (deployJumpHost && vmJumpboxOSType == 'linux') {
  name: '${uniqueString(deployment().name, location)}-jumpboxLinuxVM'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmName: names.linuxVirtualMachine.name
    bastionResourceId: bastionResourceId
    vmAdminUsername: adminUsername
    vmAdminPassword: adminPassword
    vmSize: vmSize
    vmVnetName: networking.outputs.vnetSpokeName
    vmSubnetName: resourceNames.snetDevOps
    vmSubnetAddressPrefix: subnetSpokeJumpboxAddressSpace
    vmNetworkInterfaceName: names.networkInterface.name
    vmNetworkSecurityGroupName: names.networkSecurityGroup.name
    vmAuthenticationType: vmAuthenticationType
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
  }
}

@description('An optional Windows virtual machine deployment to act as a jump box.')
module jumpboxWindowsVM './modules/compute/windows-vm.bicep' = if (deployJumpHost && vmJumpboxOSType == 'windows') {
  name: '${uniqueString(deployment().name, location)}-jumpboxWindowsVM'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    vmName: names.windowsVirtualMachine.name
    bastionResourceId: bastionResourceId
    vmAdminUsername: adminUsername
    vmAdminPassword: adminPassword
    vmSize: vmSize
    vmVnetName: networking.outputs.vnetSpokeName
    vmSubnetName: 'snet-jumpbox'
    vmSubnetAddressPrefix: subnetSpokeJumpboxAddressSpace
    vmNetworkInterfaceName: names.networkInterface.name
    vmNetworkSecurityGroupName: resourceNames.jumpboxNsg
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
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
