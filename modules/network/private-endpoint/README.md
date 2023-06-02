# private-endpoint

This module is designed for managing Private Endpoint resources.

## Description

This module is intended for managing Private Endpoints on Azure Resources that support them or creating Private Endpoints with a user created Private Link Service.

Additionally, this can be used for integrating with other Bicep Modules in this repository for managing their Private Endpoints.

## Parameters

| Name                         | Type     | Required | Description                                                                                |
| :--------------------------- | :------: | :------: | :----------------------------------------------------------------------------------------- |
| `name`                       | `string` | Yes      | Required. The name of the Private Endpoint.                                                |
| `location`                   | `string` | Yes      | Required. Location for the Private Endpoint.                                               |
| `privateLinkServiceId`       | `string` | Yes      | Required. The ID of the Private Link Service.                                              |
| `subnetId`                   | `string` | Yes      | Required. The ID of the Subnet to associate with the Private Endpoint.                     |
| `groupIds`                   | `array`  | No       | Optional. The group IDs to associate with the Private Endpoint.                            |
| `privateDnsZones`            | `array`  | No       | Optional. The Private DNS Zones to associate with the Private Endpoint.                    |
| `manualApprovalEnabled`      | `bool`   | No       | Optional. Flag to enable manual approval for the Private Endpoint.                         |
| `customNetworkInterfaceName` | `string` | No       | Optional. The name of the custom Network Interface to associate with the Private Endpoint. |
| `tags`                       | `object` | No       | Optional. Tags to assign too the Private Endpoint.                                         |

## Outputs

| Name              | Type   | Description                                             |
| :---------------- | :----: | :------------------------------------------------------ |
| name              | string | Output. The name of the Private Endpoint.               |
| id                | string | Output. The ID of the Private Endpoint.                 |
| networkInterfaces | array  | Output. The Network Interfaces of the Private Endpoint. |

## Examples

### Example 1

This example shows integrating with an instance of Azure Container Registry.

```bicep
/* Create a resource such as a Container Registry that
    will later be integrated to a network.
*/
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: 'myregistry123'
  location: location
  sku: {
    name: 'Premium'
  }
  properties: {
    adminUserEnabled: false
    publicNetworkAccess: 'Disabled'
    networkRuleBypassOptions: 'AzureServices'
  }
}

/* Create a Virtual Network that the Private Endpoint will be
    created within using the module. Be sure to set privateEndpointNetworkPolicies
    as 'Disabled'.
*/
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: 'myvnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: '${name}-subnet-0'
        properties: {
          addressPrefix: '10.0.0.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

/* Create a Private DNS Zone that will host a DNS
    name for the created Private Endpoint.
*/
resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurecr.io'
  location: 'global'
  properties: {}
}

/* Link the Private DNS Zone with the Virtual Network that
    was previously created.
*/
resource virtualNetworkLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDNSZone
  name: 'myvnetlink'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetwork.id
    }
  }
}

/* The module is called from the Public Registry, and the
    params are set for integrating with ACR.
*/
module privateEndpoint 'br/public:network/private-endpoint:1.0.1' = {
  name: '${uniqueString(deployment().name, location)}-acr-private-endpoint'
  params: {
    location: 'eastus'
    name: 'myendpoint'
    privateLinkServiceId: containerRegistry.id
    subnetId: virtualNetwork.properties.subnets[0].id
    groupIds: [
      'registry'
    ]
    privateDnsZones: [
      {
        name: 'default'
        zoneId: privateDNSZone.id
      }
    ]
    manualApprovalEnabled: false
  }
}
```