# Elastic SANs `[Microsoft.ElasticSan/elasticSans]`

This module deploys an Elastic SAN.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ElasticSan/elasticSans` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans) |
| `Microsoft.ElasticSan/elasticSans/volumegroups` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups) |
| `Microsoft.ElasticSan/elasticSans/volumegroups/snapshots` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/snapshots) |
| `Microsoft.ElasticSan/elasticSans/volumegroups/volumes` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ElasticSan/2023-01-01/elasticSans/volumegroups/volumes) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/elastic-san/elastic-san:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    name: 'esanmin001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "esanmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

param name = 'esanmin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    name: 'esanmax001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "esanmax001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

param name = 'esanmax001'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module elasticSan 'br/public:avm/res/elastic-san/elastic-san:<version>' = {
  name: 'elasticSanDeployment'
  params: {
    name: 'esanwaf001'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "esanwaf001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/elastic-san/elastic-san:<version>'

param name = 'esanwaf001'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Elastic SAN. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must be between 3 and 24 characters long. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZone`](#parameter-availabilityzone) | int | Configuration of the availability zone for the Elastic SAN. Required if `Sku` is `Premium_LRS`. If this parameter is not provided, the `Sku` parameter will default to Premium_ZRS. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseSizeTiB`](#parameter-basesizetib) | int | Size of the Elastic SAN base capacity in Tebibytes (TiB). The supported capacity ranges from 1 Tebibyte (TiB) to 400 Tebibytes (TiB). |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extendedCapacitySizeTiB`](#parameter-extendedcapacitysizetib) | int | Size of the Elastic SAN additional capacity in Tebibytes (TiB). The supported capacity ranges from 0 Tebibyte (TiB) to 600 Tebibytes (TiB). |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether or not public network access is allowed for this resource. For security reasons it should be `Disabled`, which necessitates the use of private endpoints. If not specified, public access will be `Disabled` by default when private endpoints are used without Virtual Network Rules. Setting public network access to `Disabled` while using Virtual Network Rules will result in an error. |
| [`sku`](#parameter-sku) | string | Specifies the SKU for the Elastic SAN. |
| [`tags`](#parameter-tags) | object | Tags of the Elastic SAN resource. |
| [`volumeGroups`](#parameter-volumegroups) | array | List of Elastic SAN Volume Groups to be created in the Elastic SAN. An Elastic SAN can have a maximum of 200 volume groups. |

### Parameter: `name`

Name of the Elastic SAN. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must be between 3 and 24 characters long.

- Required: Yes
- Type: string

### Parameter: `availabilityZone`

Configuration of the availability zone for the Elastic SAN. Required if `Sku` is `Premium_LRS`. If this parameter is not provided, the `Sku` parameter will default to Premium_ZRS. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `baseSizeTiB`

Size of the Elastic SAN base capacity in Tebibytes (TiB). The supported capacity ranges from 1 Tebibyte (TiB) to 400 Tebibytes (TiB).

- Required: No
- Type: int
- Default: `1`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedCapacitySizeTiB`

Size of the Elastic SAN additional capacity in Tebibytes (TiB). The supported capacity ranges from 0 Tebibyte (TiB) to 600 Tebibytes (TiB).

- Required: No
- Type: int
- Default: `0`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `publicNetworkAccess`

Whether or not public network access is allowed for this resource. For security reasons it should be `Disabled`, which necessitates the use of private endpoints. If not specified, public access will be `Disabled` by default when private endpoints are used without Virtual Network Rules. Setting public network access to `Disabled` while using Virtual Network Rules will result in an error.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `sku`

Specifies the SKU for the Elastic SAN.

- Required: No
- Type: string
- Default: `'Premium_ZRS'`
- Allowed:
  ```Bicep
  [
    'Premium_LRS'
    'Premium_ZRS'
  ]
  ```

### Parameter: `tags`

Tags of the Elastic SAN resource.

- Required: No
- Type: object

### Parameter: `volumeGroups`

List of Elastic SAN Volume Groups to be created in the Elastic SAN. An Elastic SAN can have a maximum of 200 volume groups.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsname) | string | The name of the Elastic SAN Volume Group. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. The name must be between 3 and 63 characters long. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customerManagedKey`](#parameter-volumegroupscustomermanagedkey) | object | The customer managed key definition. |
| [`managedIdentities`](#parameter-volumegroupsmanagedidentities) | object | The managed identity definition for this resource. |
| [`privateEndpoints`](#parameter-volumegroupsprivateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Private endpoints are not currently supported for Elastic SANs using zone-redundant storage (ZRS). |
| [`virtualNetworkRules`](#parameter-volumegroupsvirtualnetworkrules) | array | List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint. Each Elastic SAN Volume Group supports up to 200 virtual network rules. |
| [`volumes`](#parameter-volumegroupsvolumes) | array | List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group. Elastic SAN Volume Group can contain up to 1,000 volumes. |

### Parameter: `volumeGroups.name`

The name of the Elastic SAN Volume Group. The name can only contain lowercase letters, numbers and hyphens, and must begin and end with a letter or a number. Each hyphen must be preceded and followed by an alphanumeric character. The name must be between 3 and 63 characters long.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.customerManagedKey`

The customer managed key definition.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-volumegroupscustomermanagedkeykeyname) | string | The name of the customer managed key to use for encryption. |
| [`keyVaultResourceId`](#parameter-volumegroupscustomermanagedkeykeyvaultresourceid) | string | The resource ID of a key vault to reference a customer managed key for encryption from. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-volumegroupscustomermanagedkeykeyversion) | string | The version of the customer managed key to reference for encryption. If not provided, using 'latest'. |
| [`userAssignedIdentityResourceId`](#parameter-volumegroupscustomermanagedkeyuserassignedidentityresourceid) | string | User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use. |

### Parameter: `volumeGroups.customerManagedKey.keyName`

The name of the customer managed key to use for encryption.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.customerManagedKey.keyVaultResourceId`

The resource ID of a key vault to reference a customer managed key for encryption from.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.customerManagedKey.keyVersion`

The version of the customer managed key to reference for encryption. If not provided, using 'latest'.

- Required: No
- Type: string

### Parameter: `volumeGroups.customerManagedKey.userAssignedIdentityResourceId`

User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.

- Required: No
- Type: string

### Parameter: `volumeGroups.managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-volumegroupsmanagedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-volumegroupsmanagedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `volumeGroups.managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `volumeGroups.managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `volumeGroups.privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. Private endpoints are not currently supported for Elastic SANs using zone-redundant storage (ZRS).

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-volumegroupsprivateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-volumegroupsprivateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the Private Endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-volumegroupsprivateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-volumegroupsprivateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the Private Endpoint. |
| [`enableTelemetry`](#parameter-volumegroupsprivateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-volumegroupsprivateendpointsipconfigurations) | array | A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints. |
| [`isManualConnection`](#parameter-volumegroupsprivateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-volumegroupsprivateendpointslocation) | string | The location to deploy the Private Endpoint to. |
| [`lock`](#parameter-volumegroupsprivateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-volumegroupsprivateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-volumegroupsprivateendpointsname) | string | The name of the Private Endpoint. |
| [`privateDnsZoneGroup`](#parameter-volumegroupsprivateendpointsprivatednszonegroup) | object | The private DNS Zone Group to configure for the Private Endpoint. |
| [`privateLinkServiceConnectionName`](#parameter-volumegroupsprivateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-volumegroupsprivateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different Resource Group than the main resource. |
| [`roleAssignments`](#parameter-volumegroupsprivateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-volumegroupsprivateendpointsservice) | string | The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint. |
| [`tags`](#parameter-volumegroupsprivateendpointstags) | object | Tags to be applied on all resources/Resource Groups in this deployment. |

### Parameter: `volumeGroups.privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the Private Endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `volumeGroups.privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipAddresses`](#parameter-volumegroupsprivateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-volumegroupsprivateendpointscustomdnsconfigsfqdn) | string | FQDN that resolves to private endpoint IP address. |

### Parameter: `volumeGroups.privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `volumeGroups.privateEndpoints.customDnsConfigs.fqdn`

FQDN that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the Private Endpoint.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations`

A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsprivateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-volumegroupsprivateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-volumegroupsprivateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-volumegroupsprivateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-volumegroupsprivateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `volumeGroups.privateEndpoints.location`

The location to deploy the Private Endpoint to.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-volumegroupsprivateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-volumegroupsprivateendpointslockname) | string | Specify the name of lock. |

### Parameter: `volumeGroups.privateEndpoints.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `volumeGroups.privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.name`

The name of the Private Endpoint.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup`

The private DNS Zone Group to configure for the Private Endpoint.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneGroupConfigs`](#parameter-volumegroupsprivateendpointsprivatednszonegroupprivatednszonegroupconfigs) | array | The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsprivateendpointsprivatednszonegroupname) | string | The name of the Private DNS Zone Group. |

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs`

The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-volumegroupsprivateendpointsprivatednszonegroupprivatednszonegroupconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsprivateendpointsprivatednszonegroupprivatednszonegroupconfigsname) | string | The name of the private DNS Zone Group config. |

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.privateDnsZoneGroupConfigs.name`

The name of the private DNS Zone Group config.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.privateDnsZoneGroup.name`

The name of the Private DNS Zone Group.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different Resource Group than the main resource.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-volumegroupsprivateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-volumegroupsprivateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-volumegroupsprivateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-volumegroupsprivateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-volumegroupsprivateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-volumegroupsprivateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-volumegroupsprivateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-volumegroupsprivateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `volumeGroups.privateEndpoints.service`

The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.

- Required: No
- Type: string

### Parameter: `volumeGroups.privateEndpoints.tags`

Tags to be applied on all resources/Resource Groups in this deployment.

- Required: No
- Type: object

### Parameter: `volumeGroups.virtualNetworkRules`

List of Virtual Network Rules, permitting virtual network subnet to connect to the resource through service endpoint. Each Elastic SAN Volume Group supports up to 200 virtual network rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkSubnetResourceId`](#parameter-volumegroupsvirtualnetworkrulesvirtualnetworksubnetresourceid) | string | The resource ID of the subnet in the virtual network. |

### Parameter: `volumeGroups.virtualNetworkRules.virtualNetworkSubnetResourceId`

The resource ID of the subnet in the virtual network.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.volumes`

List of Elastic SAN Volumes to be created in the Elastic SAN Volume Group. Elastic SAN Volume Group can contain up to 1,000 volumes.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsvolumesname) | string | The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must also be between 3 and 63 characters long. |
| [`sizeGiB`](#parameter-volumegroupsvolumessizegib) | int | Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`snapshots`](#parameter-volumegroupsvolumessnapshots) | array | List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume. |

### Parameter: `volumeGroups.volumes.name`

The name of the Elastic SAN Volume. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must also be between 3 and 63 characters long.

- Required: Yes
- Type: string

### Parameter: `volumeGroups.volumes.sizeGiB`

Size of the Elastic SAN Volume in Gibibytes (GiB). The supported capacity ranges from 1 Gibibyte (GiB) to 64 Tebibyte (TiB), equating to 65536 Gibibytes (GiB).

- Required: Yes
- Type: int

### Parameter: `volumeGroups.volumes.snapshots`

List of Elastic SAN Volume Snapshots to be created in the Elastic SAN Volume.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-volumegroupsvolumessnapshotsname) | string | The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must also be between 3 and 63 characters long. |

### Parameter: `volumeGroups.volumes.snapshots.name`

The name of the Elastic SAN Volume Snapshot. The name can only contain lowercase letters, numbers, hyphens and underscores, and must begin and end with a letter or a number. Each hyphen and underscore must be preceded and followed by an alphanumeric character. The name must also be between 3 and 63 characters long.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed Elastic SAN. |
| `resourceGroupName` | string | The resource group of the deployed Elastic SAN. |
| `resourceId` | string | The resource ID of the deployed Elastic SAN. |
| `volumeGroups` | array | Details on the deployed Elastic SAN Volume Groups. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.9.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
