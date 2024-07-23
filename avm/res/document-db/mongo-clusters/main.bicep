metadata name = 'DocumentDB Mongo Clusters'
metadata description = 'This module deploys a DocumentDB Mongo Cluster.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Mongo Cluster.')
param name string

@description('Optional. Default to current resource group scope location. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the Database Account resource.')
param tags object?

@description('Required. Username for admin user.')
param administratorLogin string

@secure()
@description('Required. Password for admin user.')
@minLength(8)
@maxLength(128)
param administratorLoginPassword string

@description('Optional. Whether to allow all IPs or not. Warning: No IP addresses will be blocked and any host on the Internet can access the coordinator in this server group. It is strongly recommended to use this rule only temporarily and only on test clusters that do not contain sensitive data.')
param allowAllIPsFirewall bool = false

@description('Optional. Whether to allow Azure internal IPs or not.')
param allowAzureIPsFirewall bool = false

@description('Optional. IP addresses to allow access to the cluster from.')
param allowedSingleIPs array = []

@description('Optional. Mode to create the mongo cluster.')
param createMode string = 'Default'

@description('Optional. Whether high availability is enabled on the node group.')
param highAvailabilityMode bool = false

@description('Required. Number of nodes in the node group.')
param nodeCount int

@description('Optional. Deployed Node type in the node group.')
param nodeType string = 'Shard'

@description('Required. SKU defines the CPU and memory that is provisioned for each node.')
param sku string

@description('Required. Disk storage size for the node group in GB.')
param storage int

resource mongoCluster 'Microsoft.DocumentDB/mongoClusters@2024-02-15-preview' = {
  name: name
  tags: tags
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    createMode: createMode
    nodeGroupSpecs: [
      {
        diskSizeGB: storage
        enableHa: highAvailabilityMode
        kind: nodeType
        nodeCount: nodeCount
        sku: sku
      }
    ]
  }
}

module configFireWallRules './config-firewallrules/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-configfwr'
  params: {
    mongoClusterName: mongoCluster.name
    allowAllIPsFirewall: allowAllIPsFirewall
    allowAzureIPsFirewall: allowAzureIPsFirewall
    allowedSingleIPs: allowedSingleIPs
  }
}

@description('The name of the mongo cluster.')
output name string = mongoCluster.name

@description('The resource ID of the mongo cluster.')
output resourceId string = mongoCluster.id

@description('The name of the resource group the mongo cluster was created in.')
output resourceGroupName string = resourceGroup().name

@description('The connection string key of the mongo cluster.')
output connectionStringKey string = mongoCluster.properties.connectionString
