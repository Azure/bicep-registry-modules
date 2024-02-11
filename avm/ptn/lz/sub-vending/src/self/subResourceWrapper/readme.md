# `/subResourcesWrapper/deploy.bicep` Parameters

This module is used by the [`bicep-lz-vending`](https://aka.ms/sub-vending/bicep) module to help orchestrate the deployment

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
virtualNetworkVwanEnableInternetSecurity | No       | Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.
virtualNetworkVwanAssociatedRouteTableResourceId | No       | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.
virtualNetworkVwanPropagatedRouteTablesResourceIds | No       | An array of virtual hub route table resource IDs to propogate routes to. If left blank/empty default route table will be propogated to only.
virtualNetworkVwanPropagatedLabels | No       | An array of virtual hub route table labels to propogate routes to. If left blank/empty default label will be propogated to only.
vHubRoutingIntentEnabled | No       | Indicates whether routing intent is enabled on the Virtual HUB within the virtual WAN.
roleAssignmentEnabled | No       | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.
roleAssignments | No       | Supply an array of objects containing the details of the role assignments to create.
disableTelemetry | No       | Disable telemetry collection by this module. For more information on the telemetry collected by this module, that is controlled by this parameter, see this page in the wiki: [Telemetry Tracking Using Customer Usage Attribution (PID)](https://github.com/Azure/bicep-lz-vending/wiki/Telemetry)
deploymentScriptResourceGroupName | Yes      | The name of the resource group to create the deployment script for resource providers registration.
deploymentScriptLocation | No       | The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc.
deploymentScriptName | Yes      | The name of the deployment script to register resource providers
deploymentScriptVirtualNetworkName | No       | The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.
deploymentScriptNetworkSecurityGroupName | No       | The name of the network security group for the deployment script private subnet.
virtualNetworkDeploymentScriptAddressPrefix | No       | The address prefix of the private virtual network for the deployment script.
resourceProviders | No       | An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.  - Type: `{}` Object - Default value: `{   'Microsoft.ApiManagement'             : []     'Microsoft.AppPlatform'             : []     'Microsoft.Authorization'           : []     'Microsoft.Automation'              : []     'Microsoft.AVS'                     : []     'Microsoft.Blueprint'               : []     'Microsoft.BotService'              : []     'Microsoft.Cache'                   : []     'Microsoft.Cdn'                     : []     'Microsoft.CognitiveServices'       : []     'Microsoft.Compute'                 : []     'Microsoft.ContainerInstance'       : []     'Microsoft.ContainerRegistry'       : []     'Microsoft.ContainerService'        : []     'Microsoft.CostManagement'          : []     'Microsoft.CustomProviders'         : []     'Microsoft.Databricks'              : []     'Microsoft.DataLakeAnalytics'       : []     'Microsoft.DataLakeStore'           : []     'Microsoft.DataMigration'           : []     'Microsoft.DataProtection'          : []     'Microsoft.DBforMariaDB'            : []     'Microsoft.DBforMySQL'              : []     'Microsoft.DBforPostgreSQL'         : []     'Microsoft.DesktopVirtualization'   : []     'Microsoft.Devices'                 : []     'Microsoft.DevTestLab'              : []     'Microsoft.DocumentDB'              : []     'Microsoft.EventGrid'               : []     'Microsoft.EventHub'                : []     'Microsoft.HDInsight'               : []     'Microsoft.HealthcareApis'          : []     'Microsoft.GuestConfiguration'      : []     'Microsoft.KeyVault'                : []     'Microsoft.Kusto'                   : []     'microsoft.insights'                : []     'Microsoft.Logic'                   : []     'Microsoft.MachineLearningServices' : []     'Microsoft.Maintenance'             : []     'Microsoft.ManagedIdentity'         : []     'Microsoft.ManagedServices'         : []     'Microsoft.Management'              : []     'Microsoft.Maps'                    : []     'Microsoft.MarketplaceOrdering'     : []     'Microsoft.Media'                   : []     'Microsoft.MixedReality'            : []     'Microsoft.Network'                 : []     'Microsoft.NotificationHubs'        : []     'Microsoft.OperationalInsights'     : []     'Microsoft.OperationsManagement'    : []     'Microsoft.PolicyInsights'          : []     'Microsoft.PowerBIDedicated'        : []     'Microsoft.Relay'                   : []     'Microsoft.RecoveryServices'        : []     'Microsoft.Resources'               : []     'Microsoft.Search'                  : []     'Microsoft.Security'                : []     'Microsoft.SecurityInsights'        : []     'Microsoft.ServiceBus'              : []     'Microsoft.ServiceFabric'           : []     'Microsoft.Sql'                     : []     'Microsoft.Storage'                 : []     'Microsoft.StreamAnalytics'         : []     'Microsoft.TimeSeriesInsights'      : []     'Microsoft.Web'                     : [] }`
deploymentScriptManagedIdentityName | Yes      | The name of the user managed identity for the resource providers registration deployment script.
deploymentScriptStorageAccountName | Yes      | The name of the storage account for the deployment script.

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

### virtualNetworkVwanEnableInternetSecurity

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.

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

### vHubRoutingIntentEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Indicates whether routing intent is enabled on the Virtual HUB within the virtual WAN.

- Default value: `False`

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

### deploymentScriptResourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the resource group to create the deployment script for resource providers registration.

### deploymentScriptLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc.

- Default value: `[deployment().location]`

### deploymentScriptName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the deployment script to register resource providers

### deploymentScriptVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

### deploymentScriptNetworkSecurityGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the network security group for the deployment script private subnet.

### virtualNetworkDeploymentScriptAddressPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The address prefix of the private virtual network for the deployment script.

### resourceProviders

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.

- Type: `{}` Object
- Default value: `{
  'Microsoft.ApiManagement'             : []
    'Microsoft.AppPlatform'             : []
    'Microsoft.Authorization'           : []
    'Microsoft.Automation'              : []
    'Microsoft.AVS'                     : []
    'Microsoft.Blueprint'               : []
    'Microsoft.BotService'              : []
    'Microsoft.Cache'                   : []
    'Microsoft.Cdn'                     : []
    'Microsoft.CognitiveServices'       : []
    'Microsoft.Compute'                 : []
    'Microsoft.ContainerInstance'       : []
    'Microsoft.ContainerRegistry'       : []
    'Microsoft.ContainerService'        : []
    'Microsoft.CostManagement'          : []
    'Microsoft.CustomProviders'         : []
    'Microsoft.Databricks'              : []
    'Microsoft.DataLakeAnalytics'       : []
    'Microsoft.DataLakeStore'           : []
    'Microsoft.DataMigration'           : []
    'Microsoft.DataProtection'          : []
    'Microsoft.DBforMariaDB'            : []
    'Microsoft.DBforMySQL'              : []
    'Microsoft.DBforPostgreSQL'         : []
    'Microsoft.DesktopVirtualization'   : []
    'Microsoft.Devices'                 : []
    'Microsoft.DevTestLab'              : []
    'Microsoft.DocumentDB'              : []
    'Microsoft.EventGrid'               : []
    'Microsoft.EventHub'                : []
    'Microsoft.HDInsight'               : []
    'Microsoft.HealthcareApis'          : []
    'Microsoft.GuestConfiguration'      : []
    'Microsoft.KeyVault'                : []
    'Microsoft.Kusto'                   : []
    'microsoft.insights'                : []
    'Microsoft.Logic'                   : []
    'Microsoft.MachineLearningServices' : []
    'Microsoft.Maintenance'             : []
    'Microsoft.ManagedIdentity'         : []
    'Microsoft.ManagedServices'         : []
    'Microsoft.Management'              : []
    'Microsoft.Maps'                    : []
    'Microsoft.MarketplaceOrdering'     : []
    'Microsoft.Media'                   : []
    'Microsoft.MixedReality'            : []
    'Microsoft.Network'                 : []
    'Microsoft.NotificationHubs'        : []
    'Microsoft.OperationalInsights'     : []
    'Microsoft.OperationsManagement'    : []
    'Microsoft.PolicyInsights'          : []
    'Microsoft.PowerBIDedicated'        : []
    'Microsoft.Relay'                   : []
    'Microsoft.RecoveryServices'        : []
    'Microsoft.Resources'               : []
    'Microsoft.Search'                  : []
    'Microsoft.Security'                : []
    'Microsoft.SecurityInsights'        : []
    'Microsoft.ServiceBus'              : []
    'Microsoft.ServiceFabric'           : []
    'Microsoft.Sql'                     : []
    'Microsoft.Storage'                 : []
    'Microsoft.StreamAnalytics'         : []
    'Microsoft.TimeSeriesInsights'      : []
    'Microsoft.Web'                     : []
}`

- Default value: `@{Microsoft.ApiManagement=System.Object[]; Microsoft.AppPlatform=System.Object[]; Microsoft.Authorization=System.Object[]; Microsoft.Automation=System.Object[]; Microsoft.AVS=System.Object[]; Microsoft.Blueprint=System.Object[]; Microsoft.BotService=System.Object[]; Microsoft.Cache=System.Object[]; Microsoft.Cdn=System.Object[]; Microsoft.CognitiveServices=System.Object[]; Microsoft.Compute=System.Object[]; Microsoft.ContainerInstance=System.Object[]; Microsoft.ContainerRegistry=System.Object[]; Microsoft.ContainerService=System.Object[]; Microsoft.CostManagement=System.Object[]; Microsoft.CustomProviders=System.Object[]; Microsoft.Databricks=System.Object[]; Microsoft.DataLakeAnalytics=System.Object[]; Microsoft.DataLakeStore=System.Object[]; Microsoft.DataMigration=System.Object[]; Microsoft.DataProtection=System.Object[]; Microsoft.DBforMariaDB=System.Object[]; Microsoft.DBforMySQL=System.Object[]; Microsoft.DBforPostgreSQL=System.Object[]; Microsoft.DesktopVirtualization=System.Object[]; Microsoft.Devices=System.Object[]; Microsoft.DevTestLab=System.Object[]; Microsoft.DocumentDB=System.Object[]; Microsoft.EventGrid=System.Object[]; Microsoft.EventHub=System.Object[]; Microsoft.HDInsight=System.Object[]; Microsoft.HealthcareApis=System.Object[]; Microsoft.GuestConfiguration=System.Object[]; Microsoft.KeyVault=System.Object[]; Microsoft.Kusto=System.Object[]; microsoft.insights=System.Object[]; Microsoft.Logic=System.Object[]; Microsoft.MachineLearningServices=System.Object[]; Microsoft.Maintenance=System.Object[]; Microsoft.ManagedIdentity=System.Object[]; Microsoft.ManagedServices=System.Object[]; Microsoft.Management=System.Object[]; Microsoft.Maps=System.Object[]; Microsoft.MarketplaceOrdering=System.Object[]; Microsoft.Media=System.Object[]; Microsoft.MixedReality=System.Object[]; Microsoft.Network=System.Object[]; Microsoft.NotificationHubs=System.Object[]; Microsoft.OperationalInsights=System.Object[]; Microsoft.OperationsManagement=System.Object[]; Microsoft.PolicyInsights=System.Object[]; Microsoft.PowerBIDedicated=System.Object[]; Microsoft.Relay=System.Object[]; Microsoft.RecoveryServices=System.Object[]; Microsoft.Resources=System.Object[]; Microsoft.Search=System.Object[]; Microsoft.Security=System.Object[]; Microsoft.SecurityInsights=System.Object[]; Microsoft.ServiceBus=System.Object[]; Microsoft.ServiceFabric=System.Object[]; Microsoft.Sql=System.Object[]; Microsoft.Storage=System.Object[]; Microsoft.StreamAnalytics=System.Object[]; Microsoft.TimeSeriesInsights=System.Object[]; Microsoft.Web=System.Object[]}`

### deploymentScriptManagedIdentityName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the user managed identity for the resource providers registration deployment script.

### deploymentScriptStorageAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the storage account for the deployment script.

## Outputs

Name | Type | Description
---- | ---- | -----------
failedProviders | string |
failedFeatures | string |

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
        "virtualNetworkVwanEnableInternetSecurity": {
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
        "vHubRoutingIntentEnabled": {
            "value": false
        },
        "roleAssignmentEnabled": {
            "value": false
        },
        "roleAssignments": {
            "value": []
        },
        "disableTelemetry": {
            "value": false
        },
        "deploymentScriptResourceGroupName": {
            "value": ""
        },
        "deploymentScriptLocation": {
            "value": "[deployment().location]"
        },
        "deploymentScriptName": {
            "value": ""
        },
        "deploymentScriptVirtualNetworkName": {
            "value": ""
        },
        "deploymentScriptNetworkSecurityGroupName": {
            "value": ""
        },
        "virtualNetworkDeploymentScriptAddressPrefix": {
            "value": ""
        },
        "resourceProviders": {
            "value": {
                "Microsoft.ApiManagement": [],
                "Microsoft.AppPlatform": [],
                "Microsoft.Authorization": [],
                "Microsoft.Automation": [],
                "Microsoft.AVS": [],
                "Microsoft.Blueprint": [],
                "Microsoft.BotService": [],
                "Microsoft.Cache": [],
                "Microsoft.Cdn": [],
                "Microsoft.CognitiveServices": [],
                "Microsoft.Compute": [],
                "Microsoft.ContainerInstance": [],
                "Microsoft.ContainerRegistry": [],
                "Microsoft.ContainerService": [],
                "Microsoft.CostManagement": [],
                "Microsoft.CustomProviders": [],
                "Microsoft.Databricks": [],
                "Microsoft.DataLakeAnalytics": [],
                "Microsoft.DataLakeStore": [],
                "Microsoft.DataMigration": [],
                "Microsoft.DataProtection": [],
                "Microsoft.DBforMariaDB": [],
                "Microsoft.DBforMySQL": [],
                "Microsoft.DBforPostgreSQL": [],
                "Microsoft.DesktopVirtualization": [],
                "Microsoft.Devices": [],
                "Microsoft.DevTestLab": [],
                "Microsoft.DocumentDB": [],
                "Microsoft.EventGrid": [],
                "Microsoft.EventHub": [],
                "Microsoft.HDInsight": [],
                "Microsoft.HealthcareApis": [],
                "Microsoft.GuestConfiguration": [],
                "Microsoft.KeyVault": [],
                "Microsoft.Kusto": [],
                "microsoft.insights": [],
                "Microsoft.Logic": [],
                "Microsoft.MachineLearningServices": [],
                "Microsoft.Maintenance": [],
                "Microsoft.ManagedIdentity": [],
                "Microsoft.ManagedServices": [],
                "Microsoft.Management": [],
                "Microsoft.Maps": [],
                "Microsoft.MarketplaceOrdering": [],
                "Microsoft.Media": [],
                "Microsoft.MixedReality": [],
                "Microsoft.Network": [],
                "Microsoft.NotificationHubs": [],
                "Microsoft.OperationalInsights": [],
                "Microsoft.OperationsManagement": [],
                "Microsoft.PolicyInsights": [],
                "Microsoft.PowerBIDedicated": [],
                "Microsoft.Relay": [],
                "Microsoft.RecoveryServices": [],
                "Microsoft.Resources": [],
                "Microsoft.Search": [],
                "Microsoft.Security": [],
                "Microsoft.SecurityInsights": [],
                "Microsoft.ServiceBus": [],
                "Microsoft.ServiceFabric": [],
                "Microsoft.Sql": [],
                "Microsoft.Storage": [],
                "Microsoft.StreamAnalytics": [],
                "Microsoft.TimeSeriesInsights": [],
                "Microsoft.Web": []
            }
        },
        "deploymentScriptManagedIdentityName": {
            "value": ""
        },
        "deploymentScriptStorageAccountName": {
            "value": ""
        }
    }
}
```
