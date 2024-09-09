metadata name = 'DocumentDB Mongo Clusters'
metadata description = '''This module deploys a DocumentDB Mongo Cluster.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''
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

@description('Optional. Mode to create the mongo cluster.')
param createMode string = 'Default'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

@description('Optional. IP addresses to allow access to the cluster from.')
param networkAcls networkAclsType?

var firewallRules = union(
  map(networkAcls.?customRules ?? [], customRule => {
    name: customRule.?firewallRuleName ?? 'allow-${replace(customRule.startIpAddress, '.', '')}-to-${replace(customRule.endIpAddress, '.', '')}'
    startIpAddress: customRule.startIpAddress
    endIpAddress: customRule.endIpAddress
  }),
  networkAcls.?allowAllIPs ?? false
    ? [
        {
          name: 'allow-all-IPs'
          startIpAddress: '0.0.0.0'
          endIpAddress: '255.255.255.255'
        }
      ]
    : [],
  networkAcls.?allowAzureIPs ?? false
    ? [
        {
          name: 'allow-all-azure-internal-IPs'
          startIpAddress: '0.0.0.0'
          endIpAddress: '0.0.0.0'
        }
      ]
    : []
)

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.documentdb-mongocluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

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

module mongoCluster_configFireWallRules 'firewall-rule/main.bicep' = [
  for (firewallRule, index) in firewallRules: {
    name: '${uniqueString(deployment().name, location)}-firewallRule-${index}'
    params: {
      mongoClusterName: mongoCluster.name
      name: firewallRule.name
      startIpAddress: firewallRule.startIpAddress
      endIpAddress: firewallRule.endIpAddress
    }
  }
]

@description('The name of the mongo cluster.')
output name string = mongoCluster.name

@description('The resource ID of the mongo cluster.')
output mongoClusterResourceId string = mongoCluster.id

@description('The resource ID of the resource group the firewall rule was created in.')
output resourceId string = resourceGroup().id

@description('The name of the resource group the firewall rule was created in.')
output resourceGroupName string = resourceGroup().name

@description('The connection string key of the mongo cluster.')
output connectionStringKey string = mongoCluster.properties.connectionString

@description('The name and resource ID of firewall rule.')
output firewallRules firewallSetType[] = [
  for index in range(0, length(firewallRules ?? [])): {
    name: mongoCluster_configFireWallRules[index].outputs.name
    resourceId: mongoCluster_configFireWallRules[index].outputs.resourceId
  }
]

// =============== //
//   Definitions   //
// =============== //

type networkAclsType = {
  @description('Optional. List of custom firewall rules.')
  customRules: [
    {
      @description('Optional. The name of the custom firewall rule.')
      firewallRuleName: string?

      @description('Required. The starting IP address for the custom firewall rule.')
      startIpAddress: string

      @description('Required. The ending IP address for the custom firewall rule.')
      endIpAddress: string
    }
  ]?

  @description('Required. Indicates whether to allow all IP addresses.')
  allowAllIPs: bool

  @description('Required. Indicates whether to allow all Azure internal IP addresses.')
  allowAzureIPs: bool
}

type firewallSetType = {
  @description('The name of the created firewall rule.')
  name: string

  @description('The resource ID of the created firewall rule.')
  resourceId: string
}
