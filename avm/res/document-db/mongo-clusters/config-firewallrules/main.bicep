metadata name = 'DocumentDB Mongo Clusters Config FireWall Rules'
metadata description = 'This module config firewall rules for DocumentDB Mongo Cluster.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Whether to allow all IPs or not. Warning: No IP addresses will be blocked and any host on the Internet can access the coordinator in this server group. It is strongly recommended to use this rule only temporarily and only on test clusters that do not contain sensitive data.')
param allowAllIPsFirewall bool = false

@description('Optional. Whether to allow Azure internal IPs or not.')
param allowAzureIPsFirewall bool = false

@description('Optional. IP addresses to allow access to the cluster from.')
param allowedSingleIPs array = []

@description('Required. Name of the Mongo Cluster.')
param mongoClusterName string

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2024-02-15-preview' existing = {
  name: mongoClusterName
}

resource firewall_all 'Microsoft.DocumentDB/mongoClusters/firewallRules@2024-02-15-preview' = if (allowAllIPsFirewall) {
  name: 'allow-all-IPs'
  parent: mongoCluster
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource firewall_azure 'Microsoft.DocumentDB/mongoClusters/firewallRules@2024-02-15-preview' = if (allowAzureIPsFirewall) {
  name: 'allow-all-azure-internal-IPs'
  parent: mongoCluster
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource firewall_single 'Microsoft.DocumentDB/mongoClusters/firewallRules@2024-02-15-preview' = [
  for ip in allowedSingleIPs: {
    name: 'allow-single-${replace(ip, '.', '')}'
    parent: mongoCluster
    properties: {
      startIpAddress: ip
      endIpAddress: ip
    }
  }
]

@description('The name of the resource group the mongo cluster was created in.')
output resourceGroupName string = resourceGroup().name
