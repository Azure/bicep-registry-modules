metadata name = 'Cognitive Services'
metadata description = 'This module deploys a Cognitive Service.'

@description('Required. The name of Cognitive Services account.')
param name string

@description('Required. Kind of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'AIServices'
  'AnomalyDetector'
  'CognitiveServices'
  'ComputerVision'
  'ContentModerator'
  'ContentSafety'
  'ConversationalLanguageUnderstanding'
  'CustomVision.Prediction'
  'CustomVision.Training'
  'Face'
  'FormRecognizer'
  'HealthInsights'
  'ImmersiveReader'
  'Internal.AllInOne'
  'LUIS'
  'LUIS.Authoring'
  'LanguageAuthoring'
  'MetricsAdvisor'
  'OpenAI'
  'Personalizer'
  'QnAMaker.v2'
  'SpeechServices'
  'TextAnalytics'
  'TextTranslation'
])
param kind string

@description('Required. The name of the AI Foundry project to create.')
param projectName string

@description('Required. The description of the AI Foundry project to create.')
param projectDescription string

@description('Optional. SKU of the Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
@allowed([
  'C2'
  'C3'
  'C4'
  'F0'
  'F1'
  'S'
  'S0'
  'S1'
  'S10'
  'S2'
  'S3'
  'S4'
  'S5'
  'S6'
  'S7'
  'S8'
  'S9'
])
param sku string = 'S0'

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string?

@description('Conditional. Subdomain name used for token-based authentication. Required if \'networkAcls\' or \'privateEndpoints\' are set.')
param customSubDomainName string?

@description('Optional. A collection of rules governing the accessibility from specific network locations.')
param networkAcls object?

@description('Optional. The network injection subnet resource Id for the Cognitive Services account. This allows to use the AI Services account with a virtual network.')
param networkInjectionSubnetResourceId string?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. List of allowed FQDN.')
param allowedFqdnList array?

@description('Optional. The API properties for special APIs.')
param apiProperties object?

@description('Optional. Allow only Azure AD authentication. Should be enabled for security reasons.')
param disableLocalAuth bool = true

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

@description('Optional. The flag to enable dynamic throttling.')
param dynamicThrottlingEnabled bool = false

@secure()
@description('Optional. Resource migration token.')
param migrationToken string?

@description('Optional. Restore a soft-deleted cognitive service at deployment time. Will fail if no such soft-deleted resource exists.')
param restore bool = false

@description('Optional. Restrict outbound network access.')
param restrictOutboundNetworkAccess bool = true

@description('Optional. The storage accounts for this resource.')
param userOwnedStorage array?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Array of deployments about cognitive service accounts to create.')
param deployments deploymentType[]?

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource cognitiveServiceNew 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  name: name
  kind: kind
  identity: identity
  location: location
  tags: tags
  sku: {
    name: sku
  }
  properties: {
    customSubDomainName: customSubDomainName
    allowProjectManagement: true
    networkAcls: !empty(networkAcls ?? {})
      ? {
          defaultAction: networkAcls.?defaultAction
          virtualNetworkRules: networkAcls.?virtualNetworkRules ?? []
          ipRules: networkAcls.?ipRules ?? []
        }
      : null
    publicNetworkAccess: publicNetworkAccess != null
      ? publicNetworkAccess
      : (!empty(networkAcls) ? 'Enabled' : 'Disabled')
    allowedFqdnList: allowedFqdnList
    apiProperties: apiProperties
    disableLocalAuth: disableLocalAuth
    #disable-next-line BCP036
    networkInjections: networkInjectionSubnetResourceId != null
      ? [
          {
            scenario: 'agent'
            subnetArmId: networkInjectionSubnetResourceId
            useMicrosoftManagedNetwork: false
          }
        ]
      : null
    // true is not supported today
    encryption: !empty(customerManagedKey)
      ? {
          keySource: 'Microsoft.KeyVault'
          keyVaultProperties: {
            identityClientId: !empty(customerManagedKey.?userAssignedIdentityResourceId ?? '')
              ? cMKUserAssignedIdentity!.properties.clientId
              : null
            keyVaultUri: cMKKeyVault!.properties.vaultUri
            keyName: customerManagedKey!.keyName
            keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
              ? customerManagedKey!.?keyVersion
              : last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
          }
        }
      : null
    migrationToken: migrationToken
    restore: restore
    restrictOutboundNetworkAccess: restrictOutboundNetworkAccess
    userOwnedStorage: userOwnedStorage
    dynamicThrottlingEnabled: dynamicThrottlingEnabled
  }
}

module cognitive_service_dependencies './dependencies.bicep' = {
  params: {
    projectName: projectName
    projectDescription: projectDescription
    name: cognitiveServiceNew.name
    location: location
    deployments: deployments
    diagnosticSettings: diagnosticSettings
    lock: lock
    privateEndpoints: privateEndpoints
    roleAssignments: roleAssignments
    secretsExportConfiguration: secretsExportConfiguration
    sku: sku
    tags: tags
  }
}

@description('The name of the cognitive services account.')
output name string = cognitiveServiceNew.name

@description('The resource ID of the cognitive services account.')
output resourceId string = cognitiveServiceNew.id

@description('The resource group the cognitive services account was deployed into.')
output subscriptionId string = subscription().subscriptionId

@description('The resource group the cognitive services account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The service endpoint of the cognitive services account.')
output endpoint string = cognitiveServiceNew.properties.endpoint

@description('The service endpoint of the cognitive services account.')
output openaiEndpoint string = cognitiveServiceNew.properties.endpoints['OpenAI Language Model Instance API']

@description('All endpoints available for the cognitive services account, types depends on the cognitive service kind.')
output endpoints endpointType = cognitiveServiceNew.properties.endpoints

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = cognitiveServiceNew.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = cognitiveServiceNew.location

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = cognitive_service_dependencies!.outputs.exportedSecrets

@description('The private endpoints of the congitive services account.')
output privateEndpoints privateEndpointOutputType[] = cognitive_service_dependencies!.outputs.privateEndpoints

import { aiProjectOutputType } from './project.bicep'
output aiProjectInfo aiProjectOutputType = cognitive_service_dependencies!.outputs.aiProjectInfo

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type for the private endpoint output.')
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

@export()
@description('The type for a cognitive services account deployment.')
type deploymentType = {
  @description('Optional. Specify the name of cognitive service account deployment.')
  name: string?

  @description('Required. Properties of Cognitive Services account deployment model.')
  model: {
    @description('Required. The name of Cognitive Services account deployment model.')
    name: string

    @description('Required. The format of Cognitive Services account deployment model.')
    format: string

    @description('Required. The version of Cognitive Services account deployment model.')
    version: string
  }

  @description('Optional. The resource model definition representing SKU.')
  sku: {
    @description('Required. The name of the resource model definition representing SKU.')
    name: string

    @description('Optional. The capacity of the resource model definition representing SKU.')
    capacity: int?

    @description('Optional. The tier of the resource model definition representing SKU.')
    tier: string?

    @description('Optional. The size of the resource model definition representing SKU.')
    size: string?

    @description('Optional. The family of the resource model definition representing SKU.')
    family: string?
  }?

  @description('Optional. The name of RAI policy.')
  raiPolicyName: string?

  @description('Optional. The version upgrade option.')
  versionUpgradeOption: string?
}

@export()
@description('The type for a cognitive services account endpoint.')
type endpointType = {
  @description('Type of the endpoint.')
  name: string?
  @description('The endpoint URI.')
  endpoint: string?
}

@export()
@description('The type of the secrets exported to the provided Key Vault.')
type secretsExportConfigurationType = {
  @description('Required. The key vault name where to store the keys and connection strings generated by the modules.')
  keyVaultResourceId: string

  @description('Optional. The name for the accessKey1 secret to create.')
  accessKey1Name: string?

  @description('Optional. The name for the accessKey2 secret to create.')
  accessKey2Name: string?
}
