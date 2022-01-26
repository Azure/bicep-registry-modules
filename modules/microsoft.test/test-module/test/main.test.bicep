module testMain '../main.bicep' = {
  name: 'testMain'
  params: {
    dnsPrefix: ''
    servicePrincipalClientId: ''
    servicePrincipalClientSecret: ''
    linuxAdminUsername: ''
    osDiskSizeGB: 1
    sshRSAPublicKey: ''
  }
}
