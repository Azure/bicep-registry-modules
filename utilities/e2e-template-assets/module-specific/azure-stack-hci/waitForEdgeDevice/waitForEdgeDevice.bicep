@description('Required. The names of the HCI cluster nodes (Arc machine names).')
param clusterNodeNames array

@description('Required. The location to deploy resources into.')
param location string

@description('Optional. Maximum number of polling attempts (each attempt waits 60 seconds).')
param maxPollAttempts int = 60

@description('Optional. Seconds to wait between polling attempts.')
param pollIntervalSeconds int = 60

// This deployment script waits for all edge devices in the cluster to reach 'Succeeded' provisioning state.
// The HCI cluster module returns after ARM accepts the deploymentSettings resource, but the edge devices
// continue provisioning asynchronously. Resources like marketplace gallery images require the edge device
// to be fully provisioned before they can be created.
resource waitForEdgeDevice 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'wait-edgeDevice-ready'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '12.3'
    retentionInterval: 'PT6H'
    timeout: 'PT2H'
    arguments: '-ClusterNodeNames "${clusterNodeNamesStr}" -ResourceGroupName "${resourceGroup().name}" -SubscriptionId "${subscription().subscriptionId}" -MaxPollAttempts ${maxPollAttempts} -PollIntervalSeconds ${pollIntervalSeconds}'
    scriptContent: loadTextContent('./waitForEdgeDevice.ps1')
  }
}

var clusterNodeNamesStr = join(clusterNodeNames, ',')
