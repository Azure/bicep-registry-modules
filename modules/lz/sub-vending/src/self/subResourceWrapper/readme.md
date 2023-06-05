# `/subResourcesWrapper/deploy.bicep` Parameters

These are the input parameters for the Bicep module: [`deploy.bicep`](./deploy.bicep)

This is the sub-orchestration module that is used and called by the [`main.bicep`](../../../main.bicep)  module to deploy the resources into the subscription that has been created (or an existing one provided), based on the parameter input values that are provided to it at deployment time from the `main.bicep` orchestration module.

> ⚠️ It is not intended for this module to be called outside of being a sub-orchestration module for the `main.bicep` module ⚠️

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
subscriptionId | Yes      |
subscriptionManagementGroupAssociationEnabled | No       | Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.
subscriptionManagementGroupId | No       | The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.
subscriptionTags | No       | An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.
virtualNetworkEnabled | No       | Whether to create a virtual network or not.
virtualNetworkResourceGroupName | No       | The name of the resource group to create the virtual network in.
virtualNetworkResourceGroupLockEnabled | No       | Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.
virtualNetworkResourceGroupTags | No       | An object of tag key/value pairs to be appended to the Resource Group that the Virtual Network is created in. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.
virtualNetworkLocation | No       | The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.
virtualNetworkName | No       | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.
virtualNetworkTags | No       | An object of tag key/value pairs to be set on the Virtual Network that is created. NOTE: Tags will be overwritten on resoruce if any exist already.
virtualNetworkAddressSpace | No       | The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`
virtualNetworkDnsServers | No       | The custom DNS servers to use on the virtual network, e.g. `["10.4.1.4", "10.2.1.5"]. If left empty (default) then Azure DNS will be used for the virtual network.`
virtualNetworkDdosPlanId | No       | The resoruce ID of an existing DDoS Network Protection Plan that you wish to link to this virtual network.
virtualNetworkPeeringEnabled | No       | Whether to enable peering/connection with the supplied hub virtual network or virtual hub.
hubNetworkResourceId | No       | The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.
virtualNetworkUseRemoteGateways | No       | Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.
virtualNetworkVwanAssociatedRouteTableResourceId | No       | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.
virtualNetworkVwanPropagatedRouteTablesResourceIds | No       | An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.
virtualNetworkVwanPropagatedLabels | No       | An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.
roleAssignmentEnabled | No       | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.
roleAssignments | No       | Supply an array of objects containing the details of the role assignments to create.
disableTelemetry | No       | Disable telemetry collection by this module. For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)



### subscriptionManagementGroupAssociationEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to move the subscription to the specified management group supplied in the pararmeter subscriptionManagementGroupId.

- Default value: `True`

### subscriptionManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The destination management group ID for the new subscription. Note: Do not supply the display name. The management group ID forms part of the Azure resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.

### subscriptionTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object of tag key/value pairs to be appended to a subscription. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.

### virtualNetworkEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to create a virtual network or not.

- Default value: `False`

### virtualNetworkResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the resource group to create the virtual network in.

### virtualNetworkResourceGroupLockEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.

- Default value: `True`

### virtualNetworkResourceGroupTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object of tag key/value pairs to be appended to the Resource Group that the Virtual Network is created in. NOTE: Tags will only be overwriten if existing tag exists with same key; values provided here win.

### virtualNetworkLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The location of the virtual network. Use region shortnames e.g. uksouth, eastus, etc.

- Default value: `[deployment().location]`

### virtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

### virtualNetworkTags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object of tag key/value pairs to be set on the Virtual Network that is created. NOTE: Tags will be overwritten on resoruce if any exist already.

### virtualNetworkAddressSpace

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The address space of the virtual network, supplied as multiple CIDR blocks, e.g. `["10.0.0.0/16","172.16.0.0/12"]`

### virtualNetworkDnsServers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The custom DNS servers to use on the virtual network, e.g. `["10.4.1.4", "10.2.1.5"]. If left empty (default) then Azure DNS will be used for the virtual network.`

### virtualNetworkDdosPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resoruce ID of an existing DDoS Network Protection Plan that you wish to link to this virtual network.

### virtualNetworkPeeringEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable peering/connection with the supplied hub virtual network or virtual hub.

- Default value: `False`

### hubNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the virtual network or virtual wan hub in the hub to which the created virtual network will be peered/connected to via vitrual network peering or a vitrual hub connection.

### virtualNetworkUseRemoteGateways

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.

- Default value: `True`

### virtualNetworkVwanAssociatedRouteTableResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.

### virtualNetworkVwanPropagatedRouteTablesResourceIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.

### virtualNetworkVwanPropagatedLabels

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.

### roleAssignmentEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.

- Default value: `False`

### roleAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Supply an array of objects containing the details of the role assignments to create.

### disableTelemetry

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Disable telemetry collection by this module. For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)

- Default value: `False`

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "src/self/subResourceWrapper/deploy.json"
    },
    "parameters": {
        "subscriptionId": {
            "value": ""
        },
        "subscriptionManagementGroupAssociationEnabled": {
            "value": true
        },
        "subscriptionManagementGroupId": {
            "value": ""
        },
        "subscriptionTags": {
            "value": {}
        },
        "virtualNetworkEnabled": {
            "value": false
        },
        "virtualNetworkResourceGroupName": {
            "value": ""
        },
        "virtualNetworkResourceGroupLockEnabled": {
            "value": true
        },
        "virtualNetworkResourceGroupTags": {
            "value": {}
        },
        "virtualNetworkLocation": {
            "value": "[deployment().location]"
        },
        "virtualNetworkName": {
            "value": ""
        },
        "virtualNetworkTags": {
            "value": {}
        },
        "virtualNetworkAddressSpace": {
            "value": []
        },
        "virtualNetworkDnsServers": {
            "value": []
        },
        "virtualNetworkDdosPlanId": {
            "value": ""
        },
        "virtualNetworkPeeringEnabled": {
            "value": false
        },
        "hubNetworkResourceId": {
            "value": ""
        },
        "virtualNetworkUseRemoteGateways": {
            "value": true
        },
        "virtualNetworkVwanAssociatedRouteTableResourceId": {
            "value": ""
        },
        "virtualNetworkVwanPropagatedRouteTablesResourceIds": {
            "value": []
        },
        "virtualNetworkVwanPropagatedLabels": {
            "value": []
        },
        "roleAssignmentEnabled": {
            "value": false
        },
        "roleAssignments": {
            "value": []
        },
        "disableTelemetry": {
            "value": false
        }
    }
}
```
