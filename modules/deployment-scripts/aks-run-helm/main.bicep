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

@description('Public Helm Repo Name')
param helmRepo string = 'azure-marketplace'

@description('Public Helm Repo URL')
param helmRepoURL string = 'https://marketplace.azurecr.io/helm/v1/repo'

@description('Helm Apps {helmApp: \'azure-marketplace/wordpress\', helmAppName: \'my-wordpress\'}')
param helmApps array  = []

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

var commands =  [ for (app, i) in helmApps: [
  'helm repo add ${contains(app, 'helmRepo') ? app.helmRepo: helmRepo} ${contains(app, 'helmRepoURL') ? app.helmRepoURL : helmRepoURL}; helm repo update; helm upgrade ${app.helmAppName} ${app.helmApp} --install ${contains(app, 'helmAppParams') ? app.helmAppParams : ''}'
]]

module helmAppInstalls 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
  name: 'helmInstallApps'
  params: {
    aksName: aksName
    location: location
    commands: commands
    forceUpdateTag: forceUpdateTag
    useExistingManagedIdentity: useExistingManagedIdentity
    managedIdentityName: managedIdentityName
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    cleanupPreference: cleanupPreference
  }
}
