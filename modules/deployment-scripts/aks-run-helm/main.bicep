metadata name = 'AKS Run Helm Script'
metadata description = 'An Azure CLI Deployment Script that allows you to run a Helm command at a Kubernetes cluster.'
metadata owner = 'dciborow'

@description('The name of the Azure Kubernetes Service')
param aksName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag string = utcNow()

@description('An array of Azure RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeeded array = [
  'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor
  '7f6c6a51-bcf8-42ba-9220-52d62157d7db' //Azure Kubernetes Service RBAC Reader
]

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
param helmApps array = []

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

module helmAppInstalls 'br/public:deployment-scripts/aks-run-command:2.0.2' = [for (app, i) in helmApps: {
  name: 'helmInstall-${app.helmAppName}-${i}'
  params: {
    aksName: aksName
    location: location
    commands: [
      'helm repo add ${helmRepo} ${helmRepoURL} && helm repo update && helm upgrade --install ${app.helmAppName} ${app.helmApp} ${contains(app, 'helmAppParams') ? app.helmAppParams : ''}'
    ]
    forceUpdateTag: forceUpdateTag
    rbacRolesNeeded: rbacRolesNeeded
    newOrExistingManagedIdentity: useExistingManagedIdentity ? 'existing' : 'new'
    managedIdentityName: managedIdentityName
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    cleanupPreference: cleanupPreference
  }
}]

@description('Helm Command Output Values')
output helmOutputs array = [for (app, i) in helmApps: {
  appName: app.helmAppName
  outputs: helmAppInstalls[i].outputs.commandOutput
}]
