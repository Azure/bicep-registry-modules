metadata name = 'Static Web Apps'
metadata description = 'This module deploys a Static Web App.'

@description('Required. The name of the static site.')
@minLength(1)
@maxLength(40)
param name string

@allowed([
  'Free'
  'Standard'
])
@description('Optional. The service tier and name of the resource SKU.')
param sku string = 'Free'

@description('Optional. False if config file is locked for this static web app; otherwise, true.')
param allowConfigFileUpdates bool = true

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. State indicating whether staging environments are allowed or not allowed for a static web app.')
param stagingEnvironmentPolicy string = 'Enabled'

@allowed([
  'Disabled'
  'Disabling'
  'Enabled'
  'Enabling'
])
@description('Optional. State indicating the status of the enterprise grade CDN serving traffic to the static web app.')
param enterpriseGradeCdnStatus string = 'Disabled'

@description('Optional. Build properties for the static site.')
param buildProperties object?

@description('Optional. Template Options for the static site.')
param templateProperties object?

@description('Optional. The provider that submitted the last deployment to the primary environment of the static site.')
param provider string = 'None'

@secure()
@description('Optional. The Personal Access Token for accessing the GitHub repository.')
param repositoryToken string?

@description('Optional. The name of the GitHub repository.')
param repositoryUrl string?

@description('Optional. The branch name of the GitHub repository.')
param branch string?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Note, requires the \'sku\' to be \'Standard\'.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Object with "resourceId" and "location" of the a user defined function app.')
param linkedBackend object = {}

@description('Optional. Static site app settings.')
param appSettings object = {}

@description('Optional. Function app settings.')
param functionAppSettings object = {}

@description('Optional. The custom domains associated with this static site. The deployment will fail as long as the validation records are not present.')
param customDomains array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Conditional. Due the nature of Azure Static Apps, a partition ID is added to the app URL upon creation. Enabling the creation of the private DNS Zone will provision a DNS Zone with the correct partition ID, this is required for private endpoint connectivity to be enabled. You can choose to disable this option and create your own private DNS Zone by leveraging the output of the partitionId within this module. Default is `Enabled`, However the Private DNS Zone will only be created following if a `privateEndpoint` configuration is supplied.')
@allowed([
  'Enabled'
  'Disabled'
])
param createPrivateDnsZone string = 'Enabled'

@description('Conditional. The Virtual Network Resource Id to use for the private DNS Zone Vnet Link. Required if `createPrivateDnsZone` is set to `Enabled` and a Private Endpoint Configuration is supplied.')
param virtualNetworkResourceId string = ''

@description('Condiitonal. If you choose to create your own private DNS Zone, you can provide the resource ID of the private DNS Zone here. Required if `createPrivateDnsZone` is enabled and a `privateEndpoint` configuration is supplied.')
param customPrivateDnsZoneResourceId string = ''

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Web Plan Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2cc479cb-7b4d-49a8-b449-8c00fd0f0a4b'
  )
  'Website Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'de139f84-1756-47ae-9be6-808fbbe84772'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.web-staticSite.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource staticSite 'Microsoft.Web/staticSites@2024-04-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  sku: {
    name: sku
    tier: sku
  }
  properties: {
    allowConfigFileUpdates: allowConfigFileUpdates
    stagingEnvironmentPolicy: stagingEnvironmentPolicy
    enterpriseGradeCdnStatus: enterpriseGradeCdnStatus
    provider: !empty(provider) ? provider : 'None'
    branch: branch
    buildProperties: buildProperties
    repositoryToken: repositoryToken
    repositoryUrl: repositoryUrl
    templateProperties: templateProperties
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) ? 'Disabled' : null)
  }
}

module staticSite_linkedBackend 'linked-backend/main.bicep' = if (!empty(linkedBackend)) {
  name: '${uniqueString(deployment().name, location)}-StaticSite-UserDefinedFunction'
  params: {
    staticSiteName: staticSite.name
    backendResourceId: linkedBackend.resourceId
    region: linkedBackend.?location ?? location
  }
}

module staticSite_appSettings 'config/main.bicep' = if (!empty(appSettings)) {
  name: '${uniqueString(deployment().name, location)}-StaticSite-appSettings'
  params: {
    kind: 'appsettings'
    staticSiteName: staticSite.name
    properties: appSettings
  }
}

module staticSite_functionAppSettings 'config/main.bicep' = if (!empty(functionAppSettings)) {
  name: '${uniqueString(deployment().name, location)}-StaticSite-functionAppSettings'
  params: {
    kind: 'functionappsettings'
    staticSiteName: staticSite.name
    properties: functionAppSettings
  }
}

module staticSite_customDomains 'custom-domain/main.bicep' = [
  for (customDomain, index) in customDomains: {
    name: '${uniqueString(deployment().name, location)}-StaticSite-customDomains-${index}'
    params: {
      name: customDomain
      staticSiteName: staticSite.name
      validationMethod: indexOf(customDomain, '.') == lastIndexOf(customDomain, '.')
        ? 'dns-txt-token'
        : 'cname-delegation'
    }
  }
]

resource staticSite_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: staticSite
}

resource staticSite_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(staticSite.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: staticSite
  }
]

module staticSite_privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = if (!empty(privateEndpoints) && createPrivateDnsZone == 'Enabled') {
  name: '${uniqueString(deployment().name, location)}-staticSite-PrivateDnsZone'
  params: {
    name: 'privatelink.${staticSite.properties.defaultHostname}.azurestaticapps.net'
    enableTelemetry: enableReferencedModulesTelemetry
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
  }
}

module staticSite_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-staticSite-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(staticSite.id, '/'))}-${privateEndpoint.?service ?? 'staticSites'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(staticSite.id, '/'))}-${privateEndpoint.?service ?? 'staticSites'}-${index}'
              properties: {
                privateLinkServiceId: staticSite.id
                groupIds: [
                  privateEndpoint.?service ?? 'staticSites'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(staticSite.id, '/'))}-${privateEndpoint.?service ?? 'staticSites'}-${index}'
              properties: {
                privateLinkServiceId: staticSite.id
                groupIds: [
                  privateEndpoint.?service ?? 'staticSites'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: {
        privateDnsZoneGroupConfigs: [
          {
            privateDnsZoneResourceId: (createPrivateDnsZone != 'Disabled')
              ? staticSite_privateDnsZone.outputs.resourceId
              : customPrivateDnsZoneResourceId
          }
        ]
      }
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

@description('The name of the static site.')
output name string = staticSite.name

@description('The resource ID of the static site.')
output resourceId string = staticSite.id

@description('The resource group the static site was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = staticSite.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = staticSite.location

@description('The default autogenerated hostname for the static site.')
output defaultHostname string = staticSite.properties.defaultHostname

@description('The private endpoints of the static site.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: staticSite_privateEndpoints[index].outputs.name
    resourceId: staticSite_privateEndpoints[index].outputs.resourceId
    groupId: staticSite_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: staticSite_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: staticSite_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// ================ //
// Definitions      //
// ================ //
@export()
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

// @description('An AVM-aligned type for a private endpoint. To be used if the private endpoint\'s default service / groupId can be assumed (i.e., for services that only have one Private Endpoint type like \'vault\' for key vault).')
// type privateEndpointSingleServiceType = {
//   @description('Optional. The name of the Private Endpoint.')
//   name: string?

//   @description('Optional. The location to deploy the Private Endpoint to.')
//   location: string?

//   @description('Optional. The name of the private link connection to create.')
//   privateLinkServiceConnectionName: string?

//   @description('Optional. The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.')
//   service: string?

//   @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
//   subnetResourceId: string

//   @description('Optional. The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.')
//   resourceGroupResourceId: string?

//   @description('Optional. The private DNS Zone Group to configure for the Private Endpoint.')
//   privateDnsZoneGroup: privateEndpointPrivateDnsZoneGroupType?

//   @description('Optional. If Manual Private Link Connection is required.')
//   isManualConnection: bool?

//   @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
//   @maxLength(140)
//   manualConnectionRequestMessage: string?

//   @description('Optional. Custom DNS configurations.')
//   customDnsConfigs: privateEndpointCustomDnsConfigType[]?

//   @description('Optional. A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.')
//   ipConfigurations: privateEndpointIpConfigurationType[]?

//   @description('Optional. Application security groups in which the Private Endpoint IP configuration is included.')
//   applicationSecurityGroupResourceIds: string[]?

//   @description('Optional. The custom name of the network interface attached to the Private Endpoint.')
//   customNetworkInterfaceName: string?

//   @description('Optional. Specify the type of lock.')
//   lock: lockType?

//   @description('Optional. Array of role assignments to create.')
//   roleAssignments: roleAssignmentType[]?

//   @description('Optional. Tags to be applied on all resources/Resource Groups in this deployment.')
//   tags: object?

//   @description('Optional. Enable/Disable usage telemetry for module.')
//   enableTelemetry: bool?
// }

// type privateEndpointCustomDnsConfigType = {
//   @description('Optional. FQDN that resolves to private endpoint IP address.')
//   fqdn: string?

//   @description('Required. A list of private IP addresses of the private endpoint.')
//   ipAddresses: string[]
// }

// type privateEndpointIpConfigurationType = {
//   @description('Required. The name of the resource that is unique within a resource group.')
//   name: string

//   @description('Required. Properties of private endpoint IP configurations.')
//   properties: {
//     @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
//     groupId: string

//     @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
//     memberName: string

//     @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
//     privateIPAddress: string
//   }
// }
