var helmChart = 'oci://REPLACEWITHYOURcontainerregistry.azurecr.io/helm/REPLACEWITHYOURHELMCHART'
var helmName = 'helminstalltest'
var helmNamespace = 'default'

var helmArgs = [
  'localProvisioner.enabled=true'
]
var helmArgsString = replace(replace(string(helmArgs), '[', ''), ']', '')

var helmCharts = {
  helmChart: helmChart
  helmName: helmName
  helmNamespace: helmNamespace
  helmValues: helmArgsString
  version: '0.1.0'
}

output helmChart object = helmCharts
