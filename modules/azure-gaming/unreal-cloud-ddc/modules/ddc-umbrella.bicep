param aksName string = ''
param location string
param resourceGroupName string
param keyVaultName string
param certificateName string
param locationCertificateName string
param servicePrincipalClientID string
param workerServicePrincipalClientID string = servicePrincipalClientID
param hostname string = 'deploy1.ddc-storage.gaming.azure.com'
param locationHostname string
param replicationSourceHostname string
param keyVaultTenantID string = subscription().tenantId
param loginTenantID string = subscription().tenantId
param helmVersion string = 'latest'
param helmChart string
param helmName string
param helmNamespace string
param siteName string
param imageVersion string
param enableWorker bool = false

@description('this should be enabled in one region - it will delete old ref records no longer in use across the entire system')
param CleanOldRefRecords bool = false

@description('this will delete old blobs that are no longer referenced by any ref - this runs in each region to cleanup that regions blob stores')
param CleanOldBlobs bool = true

param namespacesToReplicate array = []

param restartPods bool = true
param podRollMeSeed string = utcNow()

@description('If this is non-empty, an open telemetry collector will be set up to send data to Application Insights')
param appInsightsKey string = ''


resource clusterUser 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  name: 'id-${aksName}-${location}'
}

var federatedId = clusterUser.properties.clientId

var locationMapping = {
  eastus: 'East US'
  eastus2: 'East US 2'
  westus: 'West US'
  westus2: 'West US 2'
  westus3: 'West US 3'
  centralus: 'Central US'
  northcentralus: 'North Central US'
  southcentralus: 'South Central US'
  northeurope: 'North Europe'
  westeurope: 'West Europe'
  southeastasia: 'Southeast Asia'
  eastasia: 'East Asia'
  japaneast: 'Japan East'
  japanwest: 'Japan West'
  australiaeast: 'Australia East'
  australiasoutheast: 'Australia Southeast'
  brazilsouth: 'Brazil South'
  canadacentral: 'Canada Central'
  canadaeast: 'Canada East'
  centralindia: 'Central India'
  southafricanorth: 'South Africa North'
  uaenorth: 'UAE North'
  koreacentral: 'Korea Central'
  chinanorth3: 'China North 3'
}

var secretStore = {
  enabled: true
  clientID: federatedId
  keyVaultName: keyVaultName
  resourceGroup: resourceGroupName
  subscriptionID: subscription().subscriptionId
  tenantID: keyVaultTenantID
}

var loginDomain = 'microsoftonline'

var serviceCreds = {
  OAuthClientId: workerServicePrincipalClientID
  OAuthClientSecret: 'akv!${keyVaultName}|build-app-secret'
  OAuthLoginUrl: '${environment().authentication.loginEndpoint}${loginTenantID}/oauth2/v2.0/token'
  OAuthScope: 'api://${servicePrincipalClientID}/.default'
}

var global = {
  siteName: siteName
  authMethod: 'JWTBearer'
  jwtAuthority: 'https://login.${loginDomain}.com/${loginTenantID}'
  jwtAudience: 'api://${servicePrincipalClientID}'
  OverrideAppVersion: imageVersion
  ServiceCredentials: serviceCreds
}

var ingress = {
  enabled: true
  hostname: hostname
  path: '/'
  pathType: 'Prefix'
  port: 8080
  tlsSecretName: 'ingress-tls-csi'
  tlsCertName: certificateName
}

var scyllaConnectionString = 'akv!${keyVaultName}|ddc-db-connection-string'
var scyllaDataCenterName = locationMapping[location]

var scyllaSpec = {
  ConnectionString: scyllaConnectionString
  LocalDatacenterName: scyllaDataCenterName
  LocalKeyspaceSuffix: location
  UseAzureCosmosDB: true
  InlineBlobMaxSize: 0
}

var storageConnectionString = 'akv!${keyVaultName}|ddc-storage-connection-string'

// Preparing values parameters.

// Setting up shared suffixes between main and worker.
var scyllaValueSuffixes = [for kvp in items(scyllaSpec): '${kvp.key}=${kvp.value}' ]

// Replace $(FEDERATED_ID) later as federatedId is not supported in loops.
var sharedEnv = {
  AZURE_CLIENT_ID: '$(FEDERATED_ID)'
  AZURE_TENANT_ID: keyVaultTenantID
  AZURE_FEDERATED_TOKEN_FILE: '/var/run/secrets/tokens/azure-identity-token'
}

var sharedEnvPairs = [for (env, index) in items(sharedEnv): [
  'env[${index}].name=${env.key}'
  'env[${index}].value=${env.value}'
]]
var sharedEnvValueSuffixes = flatten(sharedEnvPairs)

var mainChartName = 'unreal-cloud-ddc'

// Worker.

var workerPrefix = '${mainChartName}.worker'
var workerConfigPrefix = '${workerPrefix}.config'

var replicationPrefix = '${workerConfigPrefix}.Replication'
var replicationEnabledValue = '${replicationPrefix}.Enabled=true'
var replicatorPrefix = '${replicationPrefix}.Replicators'
var replicatorValueArrays = [for (namespaceToReplicate, index) in namespacesToReplicate: [
  '${replicatorPrefix}[${index}].ReplicatorName=Replicator${location}'
  '${replicatorPrefix}[${index}].Namespace=${namespaceToReplicate}'
  '${replicatorPrefix}[${index}].Version=Refs'
  '${replicatorPrefix}[${index}].ConnectionString=${replicationSourceHostname}'
]]

var workerReplicatorValues = (length(namespacesToReplicate) > 0) ? concat([replicationEnabledValue], flatten(replicatorValueArrays)) : []

var workerScyllaValues = [for suffix in scyllaValueSuffixes: '${workerConfigPrefix}.Scylla.${suffix}' ]

var workerEnvValues = [for suffix in sharedEnvValueSuffixes: '${workerPrefix}.${suffix}']

var workerOtherValues = [
  '${workerPrefix}.enabled=true'
  '${workerConfigPrefix}.Azure.ConnectionString=${storageConnectionString}'
  '${workerConfigPrefix}.GC.CleanOldRefRecords=${CleanOldRefRecords}'
  '${workerConfigPrefix}.GC.CleanOldBlobs=${CleanOldBlobs}'
]

var workerRestartValues = restartPods ? [ '${workerPrefix}.podAnnotations.rollme=${uniqueString(podRollMeSeed)}' ] : []

var workerValues = enableWorker ? concat(workerOtherValues, workerEnvValues, workerScyllaValues, workerReplicatorValues, workerRestartValues) : []

// Global values.

var globalValues = [
  'global.auth.schemes.Bearer.jwtAuthority=${global.jwtAuthority}'
  'global.auth.schemes.Bearer.jwtAudience=${global.jwtAudience}'
  'global.siteName=${siteName}'
  'global.ServiceCredentials.OAuthClientId=${serviceCreds.OAuthClientId}'
  'global.ServiceCredentials.OAuthClientSecret=${serviceCreds.OAuthClientSecret}'
  'global.ServiceCredentials.OAuthLoginUrl=${serviceCreds.OAuthLoginUrl}'
  'global.ServiceCredentials.OAuthScope=${serviceCreds.OAuthScope}'
]

var locationTlsSecretName = '${ingress.tlsSecretName}-${location}'

var secretStoreValues = [
  'secretStore.enabled=true'
  'secretStore.clientID=${secretStore.clientID}'
  'secretStore.keyvaultName=${secretStore.keyVaultName}'
  'secretStore.resourceGroup=${secretStore.resourceGroup}'
  'secretStore.subscriptionId=${secretStore.subscriptionID}'
  'secretStore.tenantId=${secretStore.tenantID}'
  'secretStore.tlsSecretName=${ingress.tlsSecretName}'
  'secretStore.tlsCertName=${ingress.tlsCertName}'
  'secretStore.extraHosts[0].tlsSecretName=${locationTlsSecretName}'
  'secretStore.extraHosts[0].tlsCertName=${locationCertificateName}'
]

var otelSamplingRatio = '0.01'

var otelEnv = {
  OTEL_SERVICE_NAME: 'unreal-cloud-ddc'
  OTEL_SERVICE_VERSION: '1.0.0'
  OTEL_EXPORTER_OTLP_ENDPOINT: 'http://$(HOST_IP):4317'
  OTEL_SAMPLING_RATIO: otelSamplingRatio
}

var otelEnvPairsSimple = [for (env, index) in items(otelEnv): [
  'env[${index}].name=${env.key}'
  'env[${index}].value=${env.value}'
]]
var otelEnvValueSuffixesSimple = flatten(otelEnvPairsSimple)
var lastEnvIndex = length(otelEnvPairsSimple)
var hostIPEnvValueSuffixes = [
  'env[${lastEnvIndex}].name=HOST_IP'
  'env[${lastEnvIndex}].valueFrom.fieldRef.fieldPath=status.hostIP'
]

var useOtel = (appInsightsKey != '')
var otelEnvValueSuffixes = useOtel ? concat(otelEnvValueSuffixesSimple, hostIPEnvValueSuffixes) : []

var mainEnvValueSuffixes = concat(sharedEnvValueSuffixes, otelEnvValueSuffixes)

var mainEnvValues = [for suffix in mainEnvValueSuffixes: '${mainChartName}.${suffix}']

var mainConfigPrefix = '${mainChartName}.config'
var mainScyllaValues = [for suffix in scyllaValueSuffixes: '${mainConfigPrefix}.Scylla.${suffix}' ]

var mainOtherValues = [
  '${mainConfigPrefix}.Azure.ConnectionString=${storageConnectionString}'
  '${mainConfigPrefix}.GC.CleanOldBlobs=false'
  '${mainChartName}.serviceAccount.annotations.azure\\.workload\\.identity/client-id=${federatedId}'
]

var mainRestartValues = restartPods ? [ '${mainChartName}.podAnnotations.rollme=${uniqueString(podRollMeSeed)}' ] : []

var mainValues = concat(mainEnvValues, mainScyllaValues, mainOtherValues, mainRestartValues)

var ingressAksValues = [
  'ingressAks.enabled=true'
  'ingressAks.tlsEnabled=true'
  'ingressAks.hosts[0].name=${hostname}'
  'ingressAks.hosts[0].tlsSecretName=${ingress.tlsSecretName}'
  'ingressAks.hosts[1].name=${locationHostname}'
  'ingressAks.hosts[1].tlsSecretName=${locationTlsSecretName}'
]

var otelCollectorValues = useOtel ? ['opentelemetry-collector.config.exporters.azuremonitor.instrumentation_key=${appInsightsKey}'] : []

var helmValuesListCombined = concat(globalValues, secretStoreValues, mainValues, workerValues, ingressAksValues, otelCollectorValues)
var helmValuesStringWithTemplate = '"${join(helmValuesListCombined, '","')}"'
var helmValuesString = replace(helmValuesStringWithTemplate, '$(FEDERATED_ID)', federatedId)

var helmCharts = {
  helmChart: helmChart
  helmName: helmName
  helmNamespace: helmNamespace
  helmValues: helmValuesString
  version: helmVersion
}

output helmChart object = helmCharts
