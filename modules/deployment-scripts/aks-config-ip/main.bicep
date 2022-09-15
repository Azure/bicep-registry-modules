@description('The name of the Azure Kubernetes Service')
param aksName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-AksRunCommandProxy'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('Azure Public IP to attach to AKS')
param publicIP string

@description('Resource Group of Azure Public IP')
param publicIPResourceGroup string = resourceGroup().name

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

var helmRepo = 'ingress-nginx'
var helmRepoURL = 'https://kubernetes.github.io/ingress-nginx'
var helmApp = 'ingress-nginx/ingress-nginx'
var helmAppName = 'ingress-nginx'
var helmAppParams = '--set ingress-nginx.controller.service.loadBalancerIP=${publicIP} --set ingress-nginx.controller.service.annotations."service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"="${publicIPResourceGroup}"'

module helmAppInstalls 'br/public:deployment-scripts/aks-run-helm:1.0.1' = {
  name: 'helmInstall-${helmAppName}'
  params: {
    aksName: aksName
    location: location
    forceUpdateTag: forceUpdateTag
    useExistingManagedIdentity: useExistingManagedIdentity
    managedIdentityName: managedIdentityName
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    cleanupPreference: cleanupPreference
    helmRepo: helmRepo
    helmRepoURL: helmRepoURL
    helmApps: [{helmApp: helmApp, helmAppName: helmAppName, helmAppParams: helmAppParams}]
  }
}
