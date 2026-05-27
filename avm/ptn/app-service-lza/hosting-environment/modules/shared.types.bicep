// ======================== //
// Shared User-Defined Types //
// ======================== //

import {
  diagnosticSettingFullType
  diagnosticSettingMetricsOnlyType
  diagnosticSettingLogsOnlyType
  lockType
  roleAssignmentType
  managedIdentityAllType
} from 'br/public:avm/utl/types/avm-common-types:0.7.0'

// ======================== //
// Existing types            //
// ======================== //

@export()
@description('Describes a virtual network link for a private DNS zone.')
type virtualNetworkLinkType = {
  @description('Required. The name of the virtual network link.')
  name: string

  @description('Required. The resource ID of the virtual network.')
  virtualNetworkResourceId: string

  @description('Optional. Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled.')
  registrationEnabled: bool?
}

@export()
@description('Describes a cluster setting for the App Service Environment.')
type clusterSettingType = {
  @description('Required. The name of the cluster setting.')
  name: string

  @description('Required. The value of the cluster setting.')
  value: string
}

@export()
@description('User-defined type for site configuration properties.')
type siteConfigType = {
  @description('Optional. Whether the web app should always be loaded.')
  alwaysOn: bool?

  @description('Optional. State of FTP / FTPS service.')
  ftpsState: ('AllAllowed' | 'Disabled' | 'FtpsOnly')?

  @description('Optional. Configures the minimum version of TLS required for SSL requests.')
  minTlsVersion: ('1.0' | '1.1' | '1.2' | '1.3')?

  @description('Optional. Health check path. Used by App Service load balancers to determine instance health.')
  healthCheckPath: string?

  @description('Optional. Whether HTTP 2.0 is enabled.')
  http20Enabled: bool?

  @description('Optional. Linux app framework and version string for container deployments (e.g. "DOCKER|image:tag").')
  linuxFxVersion: string?

  @description('Optional. Windows app framework and version string for container deployments (e.g. "DOCKER|image:tag").')
  windowsFxVersion: string?
}

// ======================== //
// Spoke Network Config     //
// ======================== //

@export()
@description('Configuration for the spoke virtual network and ingress networking.')
type spokeNetworkConfigType = {
  @description('Optional. Custom name for the spoke resource group. Falls back to naming-module default.')
  resourceGroupName: string?

  @description('Optional. CIDR of the spoke VNet (e.g. "10.240.0.0/20").')
  vnetAddressSpace: string?

  @description('Optional. CIDR of the App Service / ASE subnet. ASEv3 needs a /24.')
  appSvcSubnetAddressSpace: string?

  @description('Optional. CIDR of the private endpoint subnet.')
  privateEndpointSubnetAddressSpace: string?

  @description('Optional. CIDR of the Application Gateway subnet. Required when ingressOption is "applicationGateway".')
  appGwSubnetAddressSpace: string?

  @description('Optional. Resource ID of an existing hub VNet to peer with. If empty, no peering is created.')
  hubVnetResourceId: string?

  @description('Optional. Internal IP of the Azure Firewall in the hub. If set, a UDR is created for egress.')
  firewallInternalIp: string?

  @description('Optional. Ingress option: "frontDoor", "applicationGateway", or "none".')
  ingressOption: ('frontDoor' | 'applicationGateway' | 'none')?

  @description('Optional. Set to true to route all egress traffic through the firewall.')
  enableEgressLockdown: bool?

  @description('Optional. Custom DNS servers for the spoke VNet. If empty, Azure-provided DNS is used.')
  dnsServers: string[]?

  @description('Optional. Resource ID of a DDoS Protection Plan to associate with the spoke VNet.')
  ddosProtectionPlanResourceId: string?

  @description('Optional. Whether to disable BGP route propagation on the route table.')
  disableBgpRoutePropagation: bool?

  @description('Optional. Enable VNet encryption.')
  encryption: bool?

  @description('Optional. VNet encryption enforcement policy.')
  encryptionEnforcement: ('AllowUnencrypted' | 'DropUnencrypted')?

  @description('Optional. The flow timeout in minutes for the VNet (max 30). 0 = disabled.')
  flowTimeoutInMinutes: int?

  @description('Optional. Enable VM protection for the VNet.')
  enableVmProtection: bool?

  @description('Optional. The BGP community for the VNet.')
  bgpCommunity: string?

  @description('Optional. Resource lock for the spoke virtual network.')
  lock: lockType?

  @description('Optional. Role assignments for the spoke virtual network.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Diagnostic settings for the spoke virtual network.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

// ======================== //
// Service Plan Config       //
// ======================== //

@export()
@description('Configuration for the App Service Plan.')
type servicePlanConfigType = {
  @description('Optional. Custom name for the App Service Plan. Falls back to naming-module default.')
  name: string?

  @description('Optional. The SKU name for the App Service Plan (e.g. "P1V3").')
  sku: string?

  @description('Optional. The SKU capacity (number of workers).')
  skuCapacity: int?

  @description('Optional. Deploy the plan in a zone redundant manner.')
  zoneRedundant: bool?

  @description('Optional. Kind of server OS: "windows" or "linux".')
  kind: ('windows' | 'linux')?

  @description('Optional. Resource ID of an existing App Service Plan. Skips creating a new plan if provided.')
  existingPlanId: string?

  @description('Optional. Target worker tier name.')
  workerTierName: string?

  @description('Optional. Whether elastic scale is enabled.')
  elasticScaleEnabled: bool?

  @description('Optional. Maximum number of total workers for ElasticScaleEnabled plans.')
  maximumElasticWorkerCount: int?

  @description('Optional. If true, apps can be scaled independently.')
  perSiteScaling: bool?

  @description('Optional. Scaling worker count.')
  targetWorkerCount: int?

  @description('Optional. The instance size of the hosting plan (0=small, 1=medium, 2=large).')
  targetWorkerSize: (0 | 1 | 2)?

  @description('Optional. Resource ID of a subnet for App Service Plan VNet integration.')
  virtualNetworkSubnetId: string?

  @description('Optional. Whether the App Service Plan uses custom mode.')
  isCustomMode: bool?

  @description('Optional. Whether RDP is enabled.')
  rdpEnabled: bool?

  @description('Optional. Install scripts for the App Service Plan.')
  installScripts: array?

  @description('Optional. The default identity for the App Service Plan.')
  planDefaultIdentity: ('DefaultIdentity')?

  @description('Optional. Registry adapter configuration.')
  registryAdapters: array?

  @description('Optional. Storage mount configuration.')
  storageMounts: array?

  @description('Optional. Managed identities for the App Service Plan.')
  managedIdentities: managedIdentityAllType?

  @description('Optional. Resource lock for the App Service Plan.')
  lock: lockType?

  @description('Optional. Role assignments for the App Service Plan.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Diagnostic settings for the App Service Plan.')
  diagnosticSettings: diagnosticSettingMetricsOnlyType[]?
}

// ======================== //
// Web App Config            //
// ======================== //

@export()
@description('Container image configuration for the web app.')
type containerConfigType = {
  @description('Optional. The container image name (e.g. "mcr.microsoft.com/appsvc/staticsite:latest").')
  imageName: string?

  @description('Optional. The container registry URL (e.g. "https://myregistry.azurecr.io").')
  registryUrl: string?

  @description('Optional. The container registry username.')
  registryUsername: string?

  @secure()
  @description('Optional. The container registry password.')
  registryPassword: string?
}

@export()
@description('Configuration for the Web App.')
type appServiceConfigType = {
  @description('Optional. Custom name for the Web App. Falls back to naming-module default.')
  name: string?

  @description('Optional. Custom name for the App Service managed identity. Falls back to naming-module default.')
  managedIdentityName: string?

  @description('Optional. Kind of web app (e.g. "app", "app,linux", "app,linux,container", "functionapp").')
  kind: ('api' | 'app' | 'app,container,windows' | 'app,linux' | 'app,linux,container' | 'functionapp' | 'functionapp,linux' | 'functionapp,linux,container' | 'functionapp,linux,container,azurecontainerapps' | 'functionapp,workflowapp' | 'functionapp,workflowapp,linux' | 'linux,api')?

  @description('Optional. Require HTTPS only.')
  httpsOnly: bool?

  @description('Optional. Enable client certificate authentication (mTLS).')
  clientCertEnabled: bool?

  @description('Optional. Client certificate mode. Only used when clientCertEnabled is true.')
  clientCertMode: ('Optional' | 'OptionalInteractiveUser' | 'Required')?

  @description('Optional. Client certificate exclusion paths (comma-separated).')
  clientCertExclusionPaths: string?

  @description('Optional. Disable basic publishing credentials (FTP/SCM). Defaults to true.')
  disableBasicPublishingCredentials: bool?

  @description('Optional. Public network access for the web app.')
  publicNetworkAccess: ('Enabled' | 'Disabled' | '')?

  @description('Optional. Site redundancy mode.')
  redundancyMode: ('ActiveActive' | 'Failover' | 'GeoRedundant' | 'Manual' | 'None')?

  @description('Optional. Stop SCM (Kudu) site when the app is stopped.')
  scmSiteAlsoStopped: bool?

  @description('Optional. The site configuration object.')
  siteConfig: siteConfigType?

  @description('Optional. Function App configuration object.')
  functionAppConfig: object?

  @description('Optional. Managed environment resource ID for Azure Container Apps.')
  managedEnvironmentResourceId: string?

  @description('Optional. Outbound VNet routing configuration.')
  outboundVnetRouting: object?

  @description('Optional. Hostname SSL states for managing SSL bindings.')
  hostNameSslStates: array?

  @description('Optional. Enable end-to-end encryption (used with ASE).')
  e2eEncryptionEnabled: bool?

  @description('Optional. Resource ID of the identity for Key Vault references.')
  keyVaultAccessIdentityResourceId: string?

  @description('Optional. Hybrid connection relays to connect the app with.')
  hybridConnectionRelays: array?

  @description('Optional. Extensions configuration for the web app.')
  extensions: array?

  @description('Optional. Setting to false disables the app (takes it offline).')
  enabled: bool?

  @description('Optional. Cloning info for creating from a source app.')
  cloningInfo: object?

  @description('Optional. Size of the function container.')
  containerSize: int?

  @description('Optional. Maximum allowed daily memory-time quota.')
  dailyMemoryTimeQuota: int?

  @description('Optional. Whether customer-provided storage account is required.')
  storageAccountRequired: bool?

  @description('Optional. Azure Storage account mounts (BYOS). Each key is a mount name; value specifies accountName, shareName, mountPath, accessKey, type (AzureFiles|AzureBlob), and protocol (Smb|Nfs|Http).')
  storageAccounts: object?

  @description('Optional. DNS-related settings for the site.')
  dnsConfiguration: object?

  @description('Optional. Default hostname uniqueness scope.')
  autoGeneratedDomainNameLabelScope: ('NoReuse' | 'ResourceGroupReuse' | 'SubscriptionReuse' | 'TenantReuse')?

  @description('Optional. Whether to enable SSH access.')
  sshEnabled: bool?

  @description('Optional. Dapr configuration (Container Apps).')
  daprConfig: object?

  @description('Optional. IP mode of the app.')
  ipMode: ('IPv4' | 'IPv4AndIPv6' | 'IPv6')?

  @description('Optional. Function app resource requirements.')
  resourceConfig: object?

  @description('Optional. Workload profile name for function app.')
  workloadProfileName: string?

  @description('Optional. Disable public hostnames of the app.')
  hostNamesDisabled: bool?

  @description('Optional. True if reserved (Linux). Overrides auto-detection.')
  reserved: bool?

  @description('Optional. Extended location of the web app resource.')
  extendedLocation: object?

  @description('Optional. Enable client affinity on the web app.')
  clientAffinityEnabled: bool?

  @description('Optional. Proxy-based client affinity.')
  clientAffinityProxyEnabled: bool?

  @description('Optional. Partitioned client affinity using CHIPS cookies.')
  clientAffinityPartitioningEnabled: bool?

  @description('Optional. Container configuration for container-based deployments.')
  container: containerConfigType?

  @description('Optional. Resource lock for the Web App.')
  lock: lockType?

  @description('Optional. Role assignments for the Web App.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Diagnostic settings for the Web App.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

// ======================== //
// Key Vault Config          //
// ======================== //

@export()
@description('Configuration for the Key Vault.')
type keyVaultConfigType = {
  @description('Optional. Custom name for the Key Vault. Falls back to naming-module default.')
  name: string?

  @description('Optional. Enable purge protection. Defaults to true.')
  enablePurgeProtection: bool?

  @description('Optional. Soft delete retention in days. Defaults to 90.')
  softDeleteRetentionInDays: int?

  @description('Optional. Access policies (non-RBAC mode).')
  accessPolicies: array?

  @description('Optional. Secrets to create.')
  secrets: array?

  @description('Optional. Keys to create.')
  keys: array?

  @description('Optional. Enable for template deployment.')
  enableVaultForTemplateDeployment: bool?

  @description('Optional. Enable for disk encryption.')
  enableVaultForDiskEncryption: bool?

  @description('Optional. Create mode: "default" or "recover".')
  createMode: ('default' | 'recover')?

  @description('Optional. The SKU: "standard" or "premium".')
  sku: ('standard' | 'premium')?

  @description('Optional. Enable RBAC authorization. Defaults to true.')
  enableRbacAuthorization: bool?

  @description('Optional. Enable for deployment.')
  enableVaultForDeployment: bool?

  @description('Optional. Network ACLs for the Key Vault.')
  networkAcls: object?

  @description('Optional. Public network access for the Key Vault.')
  publicNetworkAccess: ('Enabled' | 'Disabled' | '')?

  @description('Optional. Resource lock for the Key Vault.')
  lock: lockType?

  @description('Optional. Additional role assignments beyond the default App Service identity.')
  additionalRoleAssignments: roleAssignmentType[]?

  @description('Optional. Diagnostic settings for the Key Vault.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

// ======================== //
// App Insights Config       //
// ======================== //

@export()
@description('Configuration for Application Insights.')
type appInsightsConfigType = {
  @description('Optional. Public network access for ingestion.')
  publicNetworkAccessForIngestion: ('Enabled' | 'Disabled')?

  @description('Optional. Public network access for query.')
  publicNetworkAccessForQuery: ('Enabled' | 'Disabled')?

  @description('Optional. Data retention in days.')
  retentionInDays: (30 | 60 | 90 | 120 | 180 | 270 | 365 | 550 | 730)?

  @description('Optional. Sampling percentage (1-100).')
  samplingPercentage: int?

  @description('Optional. Disable non-AAD based auth.')
  disableLocalAuth: bool?

  @description('Optional. Disable IP masking (false = mask IPs for privacy).')
  disableIpMasking: bool?

  @description('Optional. Force customer storage for profiler.')
  forceCustomerStorageForProfiler: bool?

  @description('Optional. Linked storage account resource ID.')
  linkedStorageAccountResourceId: string?

  @description('Optional. Flow type.')
  flowType: string?

  @description('Optional. Request source.')
  requestSource: string?

  @description('Optional. Kind of App Insights resource.')
  kind: string?

  @description('Optional. Purge data immediately after 30 days.')
  immediatePurgeDataOn30Days: bool?

  @description('Optional. Ingestion mode.')
  ingestionMode: ('ApplicationInsights' | 'ApplicationInsightsWithDiagnosticSettings' | 'LogAnalytics')?

  @description('Optional. Resource lock for App Insights.')
  lock: lockType?

  @description('Optional. Role assignments for App Insights.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Diagnostic settings for App Insights.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

// ======================== //
// Application Gateway Config //
// ======================== //

@export()
@description('Configuration for the Application Gateway.')
type appGatewayConfigType = {
  @description('Optional. Custom name for the Application Gateway. Falls back to naming-module default.')
  name: string?

  @description('Optional. Health probe path for backend health checks. Defaults to "/".')
  healthProbePath: string?

  @description('Optional. SSL certificates for HTTPS termination.')
  sslCertificates: array?

  @description('Optional. Managed identities for Key Vault-referenced SSL certificates.')
  managedIdentities: managedIdentityAllType?

  @description('Optional. Trusted root certificates for end-to-end SSL.')
  trustedRootCertificates: array?

  @description('Optional. SSL policy type.')
  sslPolicyType: ('Custom' | 'CustomV2' | 'Predefined')?

  @description('Optional. Predefined SSL policy name.')
  sslPolicyName: string?

  @description('Optional. Minimum TLS protocol version.')
  sslPolicyMinProtocolVersion: ('TLSv1_2' | 'TLSv1_3')?

  @description('Optional. SSL cipher suites.')
  sslPolicyCipherSuites: string[]?

  @description('Optional. Role assignments for the Application Gateway.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Authentication certificates for backend auth.')
  authenticationCertificates: array?

  @description('Optional. Custom error configurations.')
  customErrorConfigurations: array?

  @description('Optional. Whether FIPS mode is enabled.')
  enableFips: bool?

  @description('Optional. Whether HTTP/2 is enabled. Defaults to true.')
  enableHttp2: bool?

  @description('Optional. Whether request buffering is enabled.')
  enableRequestBuffering: bool?

  @description('Optional. Whether response buffering is enabled.')
  enableResponseBuffering: bool?

  @description('Optional. Load distribution policies.')
  loadDistributionPolicies: array?

  @description('Optional. Private endpoints for the Application Gateway.')
  privateEndpoints: array?

  @description('Optional. Private link configurations.')
  privateLinkConfigurations: array?

  @description('Optional. Redirect configurations.')
  redirectConfigurations: array?

  @description('Optional. Rewrite rule sets.')
  rewriteRuleSets: array?

  @description('Optional. SSL profiles.')
  sslProfiles: array?

  @description('Optional. Trusted client certificates for mTLS.')
  trustedClientCertificates: array?

  @description('Optional. URL path maps for path-based routing.')
  urlPathMaps: array?

  @description('Optional. Backend settings collection (v2).')
  backendSettingsCollection: array?

  @description('Optional. Listeners (v2).')
  listeners: array?

  @description('Optional. Routing rules (v2).')
  routingRules: array?

  @description('Optional. Resource lock for the Application Gateway.')
  lock: lockType?

  @description('Optional. Diagnostic settings for the Application Gateway.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

// ======================== //
// Front Door Config         //
// ======================== //

@export()
@description('Configuration for Azure Front Door.')
type frontDoorConfigType = {
  @description('Optional. Custom name for the Front Door profile. Falls back to naming-module default.')
  name: string?

  @description('Optional. Custom name for the Front Door endpoint. Falls back to naming-module default.')
  endpointName: string?

  @description('Optional. Custom name for the Front Door WAF policy. Falls back to naming-module default.')
  wafName: string?

  @description('Optional. Custom name for the Front Door origin group. Falls back to naming-module default.')
  originGroupName: string?

  @description('Optional. Custom name for the AFD private-endpoint auto-approver managed identity. Falls back to naming-module default.')
  afdPeAutoApproverName: string?

  @description('Optional. Deploy the default WAF rule that blocks non-GET/HEAD/OPTIONS methods.')
  enableDefaultWafMethodBlock: bool?

  @description('Optional. Custom WAF rules. Only used when enableDefaultWafMethodBlock is false.')
  wafCustomRules: object?

  @description('Optional. Health probe path for the origin group.')
  healthProbePath: string?

  @description('Optional. Health probe interval in seconds.')
  healthProbeIntervalInSeconds: int?

  @description('Optional. Custom domains for the Front Door profile.')
  customDomains: array?

  @description('Optional. Rule sets for the Front Door profile.')
  ruleSets: array?

  @description('Optional. Secrets for the Front Door profile (e.g. BYOC certificates).')
  secrets: array?

  @description('Optional. Role assignments for the Front Door profile.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Origin response timeout in seconds. Defaults to 120.')
  originResponseTimeoutSeconds: int?

  @description('Optional. Auto-approve the private endpoint connection to AFD.')
  autoApprovePrivateEndpoint: bool?

  @description('Optional. Resource lock for the Front Door profile.')
  lock: lockType?

  @description('Optional. Diagnostic settings for Front Door.')
  diagnosticSettings: diagnosticSettingFullType[]?
}

// ======================== //
// ASE Config                //
// ======================== //

@export()
@description('Configuration for the App Service Environment v3.')
type aseConfigType = {
  @description('Optional. Custom name for the App Service Environment. Falls back to naming-module default.')
  name: string?

  @description('Optional. Custom settings for ASE behavior.')
  clusterSettings: clusterSettingType[]?

  @description('Optional. Custom DNS suffix for the ASE.')
  customDnsSuffix: string?

  @description('Optional. Number of IP SSL addresses reserved.')
  ipsslAddressCount: int?

  @description('Optional. Front-end VM size.')
  multiSize: string?

  @description('Optional. Managed identities for the ASE.')
  managedIdentities: managedIdentityAllType?

  @description('Optional. Key Vault certificate URL for the custom DNS suffix.')
  customDnsSuffixCertificateUrl: string?

  @description('Optional. User-assigned identity for resolving the ASE Key Vault certificate.')
  customDnsSuffixKeyVaultReferenceIdentity: string?

  @description('Optional. Dedicated Host Count. Set to 2 for physical isolation when zoneRedundant is false.')
  dedicatedHostCount: int?

  @description('Optional. DNS suffix of the ASE.')
  dnsSuffix: string?

  @description('Optional. Scale factor for ASE frontends.')
  frontEndScaleFactor: int?

  @description('Optional. Which endpoints to serve internally in the VNet.')
  internalLoadBalancingMode: ('None' | 'Web' | 'Publishing' | 'Web, Publishing')?

  @description('Optional. Allow new private endpoint connections on the ASE.')
  allowNewPrivateEndpointConnections: bool?

  @description('Optional. Enable FTP on the ASE.')
  ftpEnabled: bool?

  @description('Optional. Customer-provided inbound IP address.')
  inboundIpAddressOverride: string?

  @description('Optional. Enable remote debug on the ASE.')
  remoteDebugEnabled: bool?

  @description('Optional. Maintenance upgrade preference.')
  upgradePreference: ('Early' | 'Late' | 'Manual' | 'None')?

  @description('Optional. Resource lock for the ASE.')
  lock: lockType?

  @description('Optional. Role assignments for the ASE.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Diagnostic settings for the ASE.')
  diagnosticSettings: diagnosticSettingLogsOnlyType[]?
}
