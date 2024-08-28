@description('Required: The name of the user VPN configuration.')
param userVpnConfigName string

@description('Optional. Location where all resources will be created.')
param location string = resourceGroup().location

@description('Optional. The audience for the AAD/Entrance authentication.')
param aadAudience string

@description('Optional. The issuer for the AAD/Entrance authentication.')
param aadIssuer string

@description('Optional. The audience for the AAD/Entrance authentication.')
param aadTenant string

param uservpnconfig array = []

@description('')
param p2sConfigurationPolicyGroups array

resource vpnServerConfig 'Microsoft.Network/vpnServerConfigurations@2024-01-01' = {
  name: userVpnConfigName
  location: location
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
    vpnProtocols: [
      'OpenVPN'
    ]
  }
}

@description('The name of the user VPN configuration.')
output name string = vpnServerConfig.name

@description('The resource ID of the user VPN configuration.')
output resourceId string = vpnServerConfig.id

@description('The name of the resource group the user VPN configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = vpnServerConfig.location
