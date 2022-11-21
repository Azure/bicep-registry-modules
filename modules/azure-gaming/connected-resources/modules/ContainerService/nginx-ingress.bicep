@description('The name of the Azure Resource Group')
param resourceGroupName string = resourceGroup().name

@description('The IP of the Azure Public IP Address')
param staticIP string

var helmRepo = 'ingress-nginx'
var helmRepoURL = 'https://kubernetes.github.io/ingress-nginx'
var helmChart = 'ingress-nginx/ingress-nginx'
var helmName = 'ingress-nginx'
var namespace = 'ingress-basic'

var helmArgs = [
  'ingress-nginx.controller.replicaCount=2'
  'ingress-nginx.controller.labels.azure\\.workload\\.identity/use="true"'
  'ingress-nginx.controller.nodeSelector.kubernetes\\.io/os=linux'
  'ingress-nginx.controller.nodeSelector.kubernetes\\.io/arch=linux'
  'ingress-nginx.controller.image.repository=mcr.microsoft.com/oss/kubernetes/ingress/nginx-ingress-controller'
  'ingress-nginx.controller.image.tag=v1.0.4'
  'ingress-nginx.controller.image.digest=""'
  'ingress-nginx.controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/os=linux'
  'ingress-nginx.controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/arch=amd64'
  'ingress-nginx.controller.admissionWebhooks.patch.image.repository=mcr.microsoft.com/oss/kubernetes/ingress/nginx-ingress-controller'
  'ingress-nginx.controller.admissionWebhooks.patch.image.tag=v1.1.1'
  'ingress-nginx.controller.admissionWebhooks.patch.image.digest=""'
  'ingress-nginx.controller.defaultBackend.nodeSelector.kubernetes\\.io/os=linux'
  'ingress-nginx.controller.defaultBackend.nodeSelector.kubernetes\\.io/arch=amd64'
  'ingress-nginx.controller.defaultBackend.image.repository=mcr.microsoft.com/oss/kubernetes/defaultbackend'
  'ingress-nginx.controller.defaultBackend.image.tag=1.4'
  'ingress-nginx.controller.defaultBackend.image.digest=""'
  'ingress-nginx.controller.service.loadBalancerIP=${staticIP}'
  'ingress-nginx.controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group="${resourceGroupName}"'
]
var helmArgsString = replace(replace(string(helmArgs), '[', ''), ']', '')

var helmCharts = {
  helmRepo: helmRepo
  helmRepoURL: helmRepoURL
  helmChart: helmChart
  helmName: helmName
  helmNamespace: namespace
  helmValues: helmArgsString
  version: '4.1.3'
}

output helmChart object = helmCharts
