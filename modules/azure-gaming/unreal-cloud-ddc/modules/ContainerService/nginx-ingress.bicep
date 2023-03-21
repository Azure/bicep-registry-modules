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
  'controller.replicaCount=2'
  'controller.nodeSelector.kubernetes\\.io/os=linux'
  'controller.nodeSelector.kubernetes\\.io/arch=amd64'
  'controller.image.repository=mcr.microsoft.com/oss/kubernetes/ingress/nginx-ingress-controller'
  'controller.image.tag=v1.0.4'
  'controller.image.digest=null'
  'controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/os=linux'
  'controller.admissionWebhooks.patch.nodeSelector.kubernetes\\.io/arch=amd64'
  'controller.admissionWebhooks.patch.image.repository=mcr.microsoft.com/oss/kubernetes/ingress/kube-webhook-certgen'
  'controller.admissionWebhooks.patch.image.tag=v1.1.1'
  'controller.admissionWebhooks.patch.image.digest=null'
  'controller.defaultBackend.nodeSelector.kubernetes\\.io/os=linux'
  'controller.defaultBackend.nodeSelector.kubernetes\\.io/arch=amd64'
  'controller.defaultBackend.image.repository=mcr.microsoft.com/oss/kubernetes/defaultbackend'
  'controller.defaultBackend.image.tag=1.4'
  'controller.defaultBackend.image.digest=null'
  'controller.service.externalTrafficPolicy=Local'
  'controller.service.loadBalancerIP=${staticIP}'
  'controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group="${resourceGroupName}"'
]

var helmStringArgs = [
  'controller.labels.azure\\.workload\\.identity/use=true'
]

var helmValues = '"${join(helmArgs, '","')}"'
var helmStringValues = '"${join(helmStringArgs, '","')}"'

var helmCharts = {
  helmRepo: helmRepo
  helmRepoURL: helmRepoURL
  helmChart: helmChart
  helmName: helmName
  helmNamespace: namespace
  helmValues: helmValues
  helmStringValues: helmStringValues
  version: '4.1.3'
}

output helmChart object = helmCharts
