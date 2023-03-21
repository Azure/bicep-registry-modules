var helmChart = 'oci://tchordestoragecontainerregistry.azurecr.io/helm/tc-local-pv-provisioner'
var helmName = 'tcpvprovisioner'
var helmNamespace = 'tc-pv-provisioner'

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
