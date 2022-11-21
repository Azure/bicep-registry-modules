@description('The name of the Azure Kubernetes Service')
param aksName string

@description('The location to deploy the resources to')
param location string

@description('How the deployment script should be forced to execute')
param forceUpdateTag string = utcNow()

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-AksRunCommandProxy-${uniqueString(aksName, location)}'

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

@description('Helm Charts {helmChart: azure-marketplace/wordpress, helmName: my-wordpress, helmNamespace: wordpress, helmValues: array, helmRepo: <>, helmRepoURL: <>}')
param helmCharts array

var commands = [for (app, i) in helmCharts: join([
  contains(app, 'helmRepo') ? 'helm repo add ${app.helmRepo} ${app.helmRepoURL} && helm repo update &&' : ''
  'helm upgrade ${app.helmName} ${app.helmChart} --install'
  contains(app, 'helmNamespace') ? '--create-namespace --namespace ${app.helmNamespace}' : ''
  contains(app, 'helmValues') ? '--set ${app.helmValues}' : ''
  contains(app, 'version') ? '--version ${app.version}' : ''
  '|| exit 1'
], ' ')]

var commandString = join(commands,'; ')

module helmChartInstall 'aks-run-command.bicep' = {
  name: 'helmChartMultiInstall-${uniqueString(aksName, location, resourceGroup().name)}'
  params: {
    aksName: aksName
    location: location
    commands: [ commandString ]
    forceUpdateTag: forceUpdateTag
    useExistingManagedIdentity: useExistingManagedIdentity
    managedIdentityName: managedIdentityName
    existingManagedIdentitySubId: existingManagedIdentitySubId
    existingManagedIdentityResourceGroupName: existingManagedIdentityResourceGroupName
    cleanupPreference: cleanupPreference
  }
}
