@sys.description('Optional. The location to deploy to.')
param location string = resourceGroup().location

param tags object = {}

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Optional. Expiration time of Host Pool registration token. Should be between one hour and 30 days from now and the format is like \'2023-12-24T12:00:00.0000000Z\'. If not provided, the expiration time will be set to two days from now.')
param expirationTime string = dateTimeAdd(utcNow(), 'P2D')

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2022-09-09' = {
  name: 'myHostPool'
  location: location
  tags: tags
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
output hostPoolId string = hostPool.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
