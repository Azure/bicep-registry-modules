param azureTenantID string = subscription().tenantId
var namespace = 'azure-workload-identity-system'

var helmCharts = {
  helmRepo: 'azure-workload-identity'
  helmRepoURL: 'https://azure.github.io/azure-workload-identity/charts'
  helmChart: 'azure-workload-identity/workload-identity-webhook'
  helmName: 'workload-identity-webhook'
  helmNamespace: namespace
  helmValues: 'azureTenantID=${azureTenantID}'
}

output helmChart object = helmCharts
