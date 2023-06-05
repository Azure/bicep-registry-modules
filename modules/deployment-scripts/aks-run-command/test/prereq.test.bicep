param aksName string =  'crtest${uniqueString(newGuid())}'
//param forceUpdateTag  string = utcNow()
param location string = resourceGroup().location

resource aks 'Microsoft.ContainerService/managedClusters@2022-01-02-preview' = {
  location: location
#disable-next-line use-stable-resource-identifiers
  name: aksName
  properties: {
    dnsPrefix: aksName
    enableRBAC: true
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    agentPoolProfiles: [
      {
        name: 'np01'
        mode: 'System'
        vmSize: 'Standard_DS2_v2'
        count: 2
      }
    ]
    nodeResourceGroup: 'mc_${aksName}'
  }
  identity: {
    type: 'SystemAssigned'
  }
}
output aksName string = aks.name

// @description('Delaying the main.test.bicep. Allowing the run commands to execute too quickly results in an error') //Ref: Failed to run command in managed cluster due to kubernetes failure. details: failed to execute on pod after retry: SPDYExecutor.SentAADToken retry failed: error dialing backend:
// resource sleepybyes 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
//   name: 'AKS-PostDeploy-Wait'
//   location: location
//   kind: 'AzureCLI'
//   dependsOn: [
//     aks
//   ]
//   properties: {
//     forceUpdateTag: forceUpdateTag
//     azCliVersion: '2.35.0'
//     timeout: 'PT30M'
//     retentionInterval: 'P1D'
//     scriptContent: 'sleep 120s'
//     cleanupPreference: 'OnSuccess'
//   }
// }
