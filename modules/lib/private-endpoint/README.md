# private-endpoint

This module is designed for managing Private Endpoint resources within other Bicep Modules.

## Description

This module is designed for integrating with other Bicep Modules in this repository and is not intended for direct use. As a 'library' module it is intended to reduce repetition of common Bicep code across all of the Bicep Modules in this repository. This module is intended for managing Private Endpoints on Azure Resources that support them.

## Parameters

| Name                    | Type     | Required | Description                                                 |
| :---------------------- | :------: | :------: | :---------------------------------------------------------- |
| `location`              | `string` | Yes      | Location for all Private Endpoint(s).                       |
| `privateEndpoints`      | `array`  | No       | Array of Private Endpoint(s) to create.                     |
| `tags`                  | `object` | No       | Tags to assign for all Private Endpoint(s).                 |
| `manualApprovalEnabled` | `bool`   | No       | Flag to enable manual approval for all Private Endpoint(s). |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Example 1 - Container Registry

This example mimics integrating with the Azure Container Registry Module.

```bicep
/* The user supplies their configuration, which would be similar to the below:
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: virtualNetwork.properties.subnets[0].id
      }
      {
        name: 'endpoint2'
        subnetId: virtualNetwork.properties.subnets[1].id
        privateDnsZoneId: privateDNSZone.id
      }
    ]
*/
@description('Define Private Endpoints that should be created for Azure Container Registry.')
param privateEndpoints array = []

@description('Should Private Endpoints be created with manual approval only?')
param privateEndpointsManualApproval bool = []

/* The module then has a variable that consumes the privateEndpoint param and
    injects some other default configuration, specific to the module.
*/
var varPrivateEndpoints = [for privateEndpoint in privateEndpoints: {
  name: '${privateEndpoint.name}-${containerRegistry.name}'
  privateLinkServiceId: containerRegistry.id
  groupIds: [
    'registry'
  ]
  subnetId: privateEndpoint.subnetId
  privateDnsZones: contains(privateEndpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: privateEndpoint.privateDnsZoneId
    }
  ] : []
}]

/* The module can then be called from the Public Registry, and the
    variable varPrivateEndpoints is set.
*/
module test_02 'br/public:lib/private-endpoint:1.0.1' = {
  name: '${uniqueString(deployment().name, location)}-acr-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    manualApprovalEnabled: privateEndpointsManualApproval
  }
}
```