# Hosting Environment Network Configuration `[Microsoft.Web/hostingEnvironments/configurations]`

This module deploys a Hosting Environment Network Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/hostingEnvironments/configurations` | [2022-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/hostingEnvironments/configurations) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hostingEnvironmentName`](#parameter-hostingenvironmentname) | string | The name of the parent Hosting Environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowNewPrivateEndpointConnections`](#parameter-allownewprivateendpointconnections) | bool | Property to enable and disable new private endpoint connection creation on ASE. |
| [`ftpEnabled`](#parameter-ftpenabled) | bool | Property to enable and disable FTP on ASEV3. |
| [`inboundIpAddressOverride`](#parameter-inboundipaddressoverride) | string | Customer provided Inbound IP Address. Only able to be set on Ase create. |
| [`remoteDebugEnabled`](#parameter-remotedebugenabled) | bool | Property to enable and disable Remote Debug on ASEv3. |

### Parameter: `hostingEnvironmentName`

The name of the parent Hosting Environment. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allowNewPrivateEndpointConnections`

Property to enable and disable new private endpoint connection creation on ASE.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `ftpEnabled`

Property to enable and disable FTP on ASEV3.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `inboundIpAddressOverride`

Customer provided Inbound IP Address. Only able to be set on Ase create.

- Required: No
- Type: string
- Default: `''`

### Parameter: `remoteDebugEnabled`

Property to enable and disable Remote Debug on ASEv3.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the configuration. |
| `resourceGroupName` | string | The resource group of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |
