param aksName string
param location string
param staticIP string = ''
param additionalCharts array = []

param enableWorkloadIdentity bool = true
#disable-next-line secure-secrets-in-params 
param enableSecretStore bool = true
param enableIngress bool = true
param azureTenantID string = subscription().tenantId

module helmInstallWorkloadID 'workload-id.bicep' = if(enableWorkloadIdentity) { 
  name: 'helmInstallWorkloadID-${uniqueString(aksName, location, resourceGroup().name)}'
  params: {
    azureTenantID: azureTenantID
  }
}

module helmInstallSecretStore 'csi-secret-store.bicep' = if(enableSecretStore) { name: 'helmInstallSecretStore-${uniqueString(aksName, location, resourceGroup().name)}' }

resource publicIP 'Microsoft.Network/publicIPAddresses@2021-03-01' existing = {
  name: staticIP
}

module helmInstallIngress 'nginx-ingress.bicep' = if(enableIngress) {
  name: 'helmInstallIngress-${uniqueString(aksName, location, resourceGroup().name)}'
  params: { staticIP: publicIP.properties.ipAddress }
}

var helmCharts = union(enableWorkloadIdentity ? [helmInstallWorkloadID.outputs.helmChart] : [], enableIngress ? [helmInstallIngress.outputs.helmChart] : [], enableSecretStore ? [helmInstallSecretStore.outputs.helmChart] : [], additionalCharts)

module combo 'helmChartInstall.bicep' = {
  name: 'helmInstallCombo-${uniqueString(aksName, location, resourceGroup().name)}'
  params: {
    aksName: aksName
    location: location
    helmCharts: helmCharts
  }
}
