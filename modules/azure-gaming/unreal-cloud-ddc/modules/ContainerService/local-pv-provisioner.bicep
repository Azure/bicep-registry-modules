var helmChart = 'oci://REPLACEWITHYOURcontainerregistry.azurecr.io/helm/local-pv-provisioner'
var helmName = 'pvprovisioner'
var helmNamespace = 'pv-provisioner'

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
