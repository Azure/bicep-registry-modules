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

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

@description('Helm Charts {helmChart: azure-marketplace/wordpress, helmName: my-wordpress, helmNamespace: wordpress, helmValues: [], helmRepo: <>, helmRepoURL: <>}')
param helmCharts array  = []

var commands =  [ for (app, i) in helmCharts: [
  'helm repo add ${app.helmRepo} ${app.helmRepoURL}'
  'helm repo update'
  'helm upgrade ${app.helmName} ${app.helmChart} --install'
  contains(app, 'helmNamespace') ? '--create-namespace --namespace ${app.helmNamespace}' : ''
  contains(app, 'helmValues') ? app.helmValues : ''
  '|| exit 1'
]]

module helmChartInstall 'br/public:deployment-scripts/aks-run-command:1.0.1' = [ for (command, i) in commands: {
  name: 'helmChartInstall-${helmCharts[i].helmName}'
  params: {
    aksName: aksName
    location: location
    commands: [ '${command[0]} && ${command[1]} && ${command[2]} ${command[3]} ${command[4]} ${command[5]}' ]
    forceUpdateTag: forceUpdateTag
    useExistingManagedIdentity: useExistingManagedIdentity
    managedIdentityName: managedIdentityName
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    cleanupPreference: cleanupPreference
  }
}]
