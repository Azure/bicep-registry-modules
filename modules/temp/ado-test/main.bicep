resource aks 'Microsoft.ContainerService/managedClusters@2022-01-02-preview' = {
  #disable-next-line no-hardcoded-location
  location: 'westus2'
  name: 'shengloltestaks'
  properties: {
    dnsPrefix: 'shengloltestaks'
    enableRBAC: true
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    agentPoolProfiles: [
      {
        name: 'np01'
        mode: 'System'
        vmSize: 'Standard_DS2_v2'
        count: 2
      }
    ]
    nodeResourceGroup: 'aslfjalsdjfsadf7asjlfjsafljsadlfjaslfd8asfjalsfjasdf8asfdjalsjfadsjflajflsajfa78234jasljfasf8sa24jljasldfjalsdjflasjdfayadkfnsadjf'
  }
  identity: {
    type: 'SystemAssigned'
  }
}
