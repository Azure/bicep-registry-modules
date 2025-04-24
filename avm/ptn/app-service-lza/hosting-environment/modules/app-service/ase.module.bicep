import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

@description('Required. Name of the App Service Environment.')
@minLength(1)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'None'
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'CanNotDelete'

@description('Optional. Resource tags.')
param tags object = {}

@description('Optional. Custom settings for changing the behavior of the App Service Environment.')
param clusterSettings array = [
  {
    name: 'DisableTls1.0'
    value: '1'
  }
]

@description('Conditional. The URL referencing the Azure Key Vault certificate secret that should be used as the default SSL/TLS certificate for sites with the custom domain suffix. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2.')
param customDnsSuffixCertificateUrl string = ''

@description('Conditional. The user-assigned identity to use for resolving the key vault certificate reference. If not specified, the system-assigned ASE identity will be used if available. Required if customDnsSuffix is not empty. Cannot be used when kind is set to ASEv2.')
param customDnsSuffixKeyVaultReferenceIdentity string = ''

@description('Optional. The Dedicated Host Count. If `zoneRedundant` is false, and you want physical hardware isolation enabled, set to 2. Otherwise 0. Cannot be used when kind is set to ASEv2.')
param dedicatedHostCount int = 0

@description('Optional. DNS suffix of the App Service Environment.')
param dnsSuffix string = ''

@description('Optional. Scale factor for frontends.')
param frontEndScaleFactor int = 15

@description('Optional. Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment. - None, Web, Publishing, Web,Publishing. "None" Exposes the ASE-hosted apps on an internet-accessible IP address.')
@allowed([
  'None'
  'Web'
  'Publishing'
  'Web, Publishing'
])
param internalLoadBalancingMode string = 'Web, Publishing'

@description('Optional. Property to enable and disable new private endpoint connection creation on ASE. Ignored when kind is set to ASEv2. If you wish to add a Premium AFD in front of the ASEv3, set this to true.')
param allowNewPrivateEndpointConnections bool = false

@description('Optional. Property to enable and disable FTP on ASEV3. Ignored when kind is set to ASEv2.')
param ftpEnabled bool = false

@description('Optional. Customer provided Inbound IP Address. Only able to be set on Ase create. Ignored when kind is set to ASEv2.')
param inboundIpAddressOverride string = ''

@description('Optional. Property to enable and disable Remote Debug on ASEv3. Ignored when kind is set to ASEv2.')
param remoteDebugEnabled bool = false

@description('Optional. Specify preference for when and how the planned maintenance is applied.')
@allowed([
  'Early'
  'Late'
  'Manual'
  'None'
])
param upgradePreference string = 'None'

@description('Required. ResourceId for the subnet.')
param subnetResourceId string

@description('Optional. Switch to make the App Service Environment zone redundant. If enabled, the minimum App Service plan instance count will be three, otherwise 1. If enabled, the `dedicatedHostCount` must be set to `-1`.')
param zoneRedundant bool = false

@description('Optional. Diagnostic Settings for the ASE.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Required. The resource ID of the existing virtual network links to the private DNS zone. If not specified, no virtual network links will be created.')
param virtualNetworkLinks array

module ase 'br/public:avm/res/web/hosting-environment:0.3.0' = {
  name: '${uniqueString(deployment().name, location)}-ase-avm'
  params: {
    name: name
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
    subnetResourceId: subnetResourceId
    clusterSettings: clusterSettings
    dedicatedHostCount: dedicatedHostCount != 0 ? dedicatedHostCount : null
    frontEndScaleFactor: frontEndScaleFactor
    internalLoadBalancingMode: internalLoadBalancingMode
    zoneRedundant: zoneRedundant
    networkConfiguration: {
      allowNewPrivateEndpointConnections: allowNewPrivateEndpointConnections
      ftpEnabled: ftpEnabled
      inboundIpAddressOverride: inboundIpAddressOverride
      remoteDebugEnabled: remoteDebugEnabled
    }
    customDnsSuffixCertificateUrl: customDnsSuffixCertificateUrl
    customDnsSuffixKeyVaultReferenceIdentity: customDnsSuffixKeyVaultReferenceIdentity
    dnsSuffix: !empty(dnsSuffix) ? dnsSuffix : null
    upgradePreference: upgradePreference
    diagnosticSettings: diagnosticSettings
    lock: { kind: lock, name: '${name}-${lock}-lock' }
  }
}

module asePrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-ase-dnszone'
  params: {
    name: '${ase.outputs.name}.appserviceenvironment.net'
    virtualNetworkLinks: virtualNetworkLinks
    enableTelemetry: enableTelemetry
    tags: tags
    a: [
      {
        name: '*'
        aRecords: [
          {
            ipv4Address: aseExisting.properties.networkingConfiguration.properties.internalInboundIpAddresses[0]
          }
        ]
        ttl: 3600
      }
      {
        name: '*.scm'
        aRecords: [
          {
            ipv4Address: aseExisting.properties.networkingConfiguration.properties.internalInboundIpAddresses[0]
          }
        ]
        ttl: 3600
      }
      {
        name: '@'
        aRecords: [
          {
            ipv4Address: aseExisting.properties.networkingConfiguration.properties.internalInboundIpAddresses[0]
          }
        ]
        ttl: 3600
      }
    ]
  }
}

resource aseExisting 'Microsoft.Web/hostingEnvironments@2023-12-01' existing = {
  name: name
}

@description('The resource ID of the App Service Environment.')
output resourceId string = ase.outputs.resourceId

@description('The resource group the App Service Environment was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the App Service Environment.')
output name string = ase.outputs.name

@description('The location the resource was deployed into.')
output location string = ase.outputs.location

@description('The Internal ingress IP of the ASE.')
output internalInboundIpAddress string = aseExisting.properties.networkingConfiguration.properties.internalInboundIpAddresses[0]
