metadata name = 'VPN Server Configuration'
metadata description = 'This module deploys a VPN Server Configuration for a Virtual Hub P2S Gateway.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the user VPN configuration.')
param name string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The audience for the AAD/Entrance authentication.')
param aadAudience string?

@description('Optional. The issuer for the AAD/Entrance authentication.')
param aadIssuer string?

@description('Optional. The audience for the AAD/Entrance authentication.')
param aadTenant string?

@description('Optional.')
param p2sConfigurationPolicyGroups array = []

@description('Optional.')
param vpnServerConfigurationName string

@description('Optional.')
param radiusClientRootCertificates array = []

@description('Optional. The address of the Radius server.')
param radiusServerAddress string?

@description('Optional. The root certificates of the Radius server.')
param radiusServerRootCertificates array = []

@description('Optional. The list of Radius servers.')
param radiusServers array = []

@description('Optional. The Radius server secret.')
@secure()
param radiusServerSecret string?

@description('Optional. The authentication types for the VPN configuration.')
@allowed([
  'AAD'
  'Certificate'
  'Radius'
])
param vpnAuthenticationTypes array = []

@description('Optional.')
param vpnClientIpsecPolicies array = []

@description('Optional.')
param vpnClientRevokedCertificates array = []

@description('Optional.')
param vpnClientRootCertificates array = []

@description('Optional. The allowed VPN protocols for the configuration.')
@allowed([
  'IkeV2'
  'OpenVPN'
])
param vpnProtocols array = []

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.network-vpnserverconfiguration.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource vpnServerConfig 'Microsoft.Network/vpnServerConfigurations@2024-01-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    aadAuthenticationParameters: {
      aadAudience: aadAudience
      aadIssuer: aadIssuer
      aadTenant: aadTenant
    }
    configurationPolicyGroups: [
      for group in p2sConfigurationPolicyGroups: {
        name: group.userVPNPolicyGroupName
        properties: {
          isDefault: group.isDefault
          policyMembers: group.policyMembers
          priority: group.priority
        }
      }
    ]
    name: vpnServerConfigurationName
    radiusClientRootCertificates: [
      for clientRootroot in radiusClientRootCertificates: {
        name: clientRootroot.name
        thumbprint: clientRootroot.thumbprint
      }
    ]
    radiusServerAddress: radiusServerAddress
    radiusServerRootCertificates: [
      for serverRoot in radiusServerRootCertificates: {
        name: serverRoot.name
        publicCertData: serverRoot.publicCertData
      }
    ]
    radiusServers: [
      for server in radiusServers: {
        radiusServerAddress: server.radiusServerAddress
        radiusServerScore: server.radiusServerScore
        radiusServerSecret: server.radiusServerSecret
      }
    ]
    radiusServerSecret: radiusServerSecret
    vpnAuthenticationTypes: vpnAuthenticationTypes
    vpnClientIpsecPolicies: [
      for policy in vpnClientIpsecPolicies: {
        dhGroup: policy.dhGroup
        ikeEncryption: policy.ikeEncryption
        ikeIntegrity: policy.ikeIntegrity
        ipsecEncryption: policy.ipsecEncryption
        ipsecIntegrity: policy.ipsecIntegrity
        pfsGroup: policy.pfsGroup
        saDataSizeKilobytes: policy.saDataSizeKilobytes
        saLifeTimeSeconds: policy.saLifeTimeSeconds
      }
    ]
    vpnClientRevokedCertificates: [
      for cert in vpnClientRevokedCertificates: {
        name: cert.name
        thumbprint:cert.thumbprint
      }
    ]
    vpnClientRootCertificates: [
      for cert in vpnClientRootCertificates: {
        name: cert.name
        publicCertData: cert.thumbprint
      }
    ]
    vpnProtocols: vpnProtocols
  }
}

resource vpnGateway_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: vpnServerConfig
}

@description('The name of the user VPN configuration.')
output name string = vpnServerConfig.name

@description('The resource ID of the user VPN configuration.')
output resourceId string = vpnServerConfig.id

@description('The name of the resource group the user VPN configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = vpnServerConfig.location

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?
