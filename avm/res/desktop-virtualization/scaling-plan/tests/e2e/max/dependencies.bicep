@sys.description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. Expiration time of Host Pool registration token. Should be between one hour and 30 days from now and the format is like \'2023-12-24T12:00:00.0000000Z\'. If not provided, the expiration time will be set to two days from now.')
param expirationTime string = dateTimeAdd(utcNow(), 'P2D')

#disable-next-line use-recent-api-versions
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: managedIdentityName
  location: location
}

#disable-next-line use-recent-api-versions
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-03-01-preview' = {
  name: 'myHostPool'
  location: location
  tags: {}
  properties: {
    friendlyName: 'hostPoolFriendlyName'
    description: 'myDescription'
    hostPoolType: 'Pooled'
    customRdpProperty: ''
    personalDesktopAssignmentType: 'Automatic'
    preferredAppGroupType: 'Desktop'
    maxSessionLimit: 5
    loadBalancerType: 'BreadthFirst'
    startVMOnConnect: false
    validationEnvironment: false
    registrationInfo: {
      expirationTime: expirationTime
      token: null
      registrationTokenOperation: 'Update'
    }
    agentUpdate: {
      useSessionHostLocalTime: true
    }
    ring: -1
    ssoadfsAuthority: ''
    ssoClientId: ''
    ssoClientSecretKeyVaultPath: ''
    ssoSecretType: ''
  }
}

@description('The resource ID of the created host pool.')
output hostPoolResourceId string = hostPool.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
