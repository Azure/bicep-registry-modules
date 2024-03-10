<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been replaced by the following equivalent module in Azure Verified Modules (AVM): [avm/res/network/virtual-network](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/virtual-network).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Virtual Networks

This module deploys Microsoft.Network Virtual Networks and optionally available children or extensions

## Details

Use this module within other Bicep templates to simpllfy the usage of a Virtual Network, with resources like Virtual Machines, or Virtual Machine Scale Sets.

## Parameters

| Name                                    | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                    |
| :-------------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                                  | `string` | Yes      | Required. The Virtual Network (vNet) Name.                                                                                                                                                                                                                                                                                                                                                                     |
| `location`                              | `string` | No       | Optional. Location for all resources.                                                                                                                                                                                                                                                                                                                                                                          |
| `addressPrefixes`                       | `array`  | Yes      | Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.                                                                                                                                                                                                                                                                                                                                   |
| `subnets`                               | `array`  | No       | Optional. An Array of subnets to deploy to the Virtual Network.                                                                                                                                                                                                                                                                                                                                                |
| `dnsServers`                            | `array`  | No       | Optional. DNS Servers associated to the Virtual Network.                                                                                                                                                                                                                                                                                                                                                       |
| `ddosProtectionPlanId`                  | `string` | No       | Optional. Resource ID of the DDoS protection plan to assign the VNET to. If it's left blank, DDoS protection will not be configured. If it's provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription.                                                                               |
| `virtualNetworkPeerings`                | `array`  | No       | Optional. Virtual Network Peerings configurations                                                                                                                                                                                                                                                                                                                                                              |
| `diagnosticLogsRetentionInDays`         | `int`    | No       | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.                                                                                                                                                                                                                                                                                                 |
| `diagnosticStorageAccountId`            | `string` | No       | Optional. Resource ID of the diagnostic storage account.                                                                                                                                                                                                                                                                                                                                                       |
| `diagnosticWorkspaceId`                 | `string` | No       | Optional. Resource ID of the diagnostic log analytics workspace.                                                                                                                                                                                                                                                                                                                                               |
| `diagnosticEventHubAuthorizationRuleId` | `string` | No       | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.                                                                                                                                                                                                                                                     |
| `diagnosticEventHubName`                | `string` | No       | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.                                                                                                                                                                                                                                                       |
| `lock`                                  | `string` | No       | Optional. Specify the type of lock.                                                                                                                                                                                                                                                                                                                                                                            |
| `roleAssignments`                       | `array`  | No       | Optional. Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' |
| `tags`                                  | `object` | No       | Optional. Tags of the resource.                                                                                                                                                                                                                                                                                                                                                                                |
| `logsToEnable`                          | `array`  | No       | Optional. The name of logs that will be streamed.                                                                                                                                                                                                                                                                                                                                                              |
| `metricsToEnable`                       | `array`  | No       | Optional. The name of metrics that will be streamed.                                                                                                                                                                                                                                                                                                                                                           |
| `newOrExistingNSG`                      | `string` | No       | Create a new, use an existing, or provide no default NSG.                                                                                                                                                                                                                                                                                                                                                      |
| `networkSecurityGroupName`              | `string` | No       | Name of default NSG to use for subnets.                                                                                                                                                                                                                                                                                                                                                                        |

## Outputs

| Name                | Type     | Description                                              |
| :------------------ | :------: | :------------------------------------------------------- |
| `resourceGroupName` | `string` | The resource group the virtual network was deployed into |
| `resourceId`        | `string` | The resource ID of the virtual network                   |
| `name`              | `string` | The name of the virtual network                          |
| `subnetNames`       | `array`  | The names of the deployed subnets                        |
| `subnetResourceIds` | `array`  | The resource IDs of the deployed subnets                 |

## Examples

### Example 1

An example of how to deploy a virtual network using the minimum required parameters.

```bicep
module minvnet 'br/public:network/virtual-network:1.1.3' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-minvnet'
  params: {
    name: 'carml-az-vnet-min-01'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
  }
}
```

### Example 2

An example of how to deploy a virtual network with multiple subnets, role assignment and diagnostic settings.

```bicep
module genvnet 'br/public:network/virtual-network:1.1.3' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-genvnet'
  params: {
    name: 'carml-az-vnet-gen-01'
    location: 'WestEurope'
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '10.0.255.0/24'
      }
      {
        name: 'carml-az-subnet-x-001'
        addressPrefix: '10.0.0.0/24'
        networkSecurityGroupId: '/subscriptions/111111-1111-1111-1111-111111111111/resourceGroups/validation-rg/providers/Microsoft.Network/networkSecurityGroups/adp-carml-az-nsg-x-001'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
        routeTableId: '/subscriptions/111111-1111-1111-1111-111111111111/resourceGroups/validation-rg/providers/Microsoft.Network/routeTables/adp-carml-az-udr-x-001'
      }
      {
        name: 'carml-az-subnet-x-002'
        addressPrefix: '10.0.3.0/24'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
      }
      {
        name: 'carml-az-subnet-x-003'
        addressPrefix: '10.0.6.0/24'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          '222222-2222-2222-2222-2222222222'
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    diagnosticLogsRetentionInDays: 7
    diagnosticStorageAccountId: '/subscriptions/111111-1111-1111-1111-111111111111/resourceGroups/validation-rg/providers/Microsoft.Storage/storageAccounts/adpcarmlazsafa001'
    diagnosticWorkspaceId: '/subscriptions/111111-1111-1111-1111-111111111111/resourcegroups/validation-rg/providers/microsoft.operationalinsights/workspaces/adp-carml-az-law-appi-001'
    diagnosticEventHubAuthorizationRuleId: '/subscriptions/111111-1111-1111-1111-111111111111/resourceGroups/validation-rg/providers/Microsoft.EventHub/namespaces/adp-carml-az-evhns-x-001/AuthorizationRules/RootManageSharedAccessKey'
    diagnosticEventHubName: 'adp-carml-az-evh-x-001'
  }
}
```

### Example 3

An example that deploys a virtual network with one subnet including a bi-directional peering to another virtual network.

```bicep
module peervnet 'br/public:network/virtual-network:1.1.3' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-peervnet'
  params: {
    name: 'carml-az-vnet-peer-01'
    location: 'WestEurope'
    addressPrefixes: [
      '10.0.0.0/24'
    ]

    subnets: [
      {
        'name': 'GatewaySubnet'
        'addressPrefix': '10.0.0.0/26'
      }
    ]

    virtualNetworkPeerings: [
      {
        remoteVirtualNetworkId: '/subscriptions/111111-1111-1111-1111-111111111111/resourceGroups/validation-rg/providers/Microsoft.Network/virtualNetworks/adp-carml-az-vnet-x-001'
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        useRemoteGateways: false
        remotePeeringEnabled: true
        remotePeeringName: 'customName'
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
      }
    ]
  }
}
```
