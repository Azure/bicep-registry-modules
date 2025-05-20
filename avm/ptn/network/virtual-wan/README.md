# avm/ptn/network/virtual-wan `[Network/VirtualWan]`

Azure Virtual WAN

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
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/azureFirewalls` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/azureFirewalls) |
| `Microsoft.Network/expressRouteGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/expressRouteGateways) |
| `Microsoft.Network/p2svpnGateways` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/p2svpnGateways) |
| `Microsoft.Network/publicIPAddresses` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses) |
| `Microsoft.Network/virtualHubs` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualHubs) |
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubRouteTables) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualHubs/hubVirtualNetworkConnections) |
| `Microsoft.Network/virtualHubs/routingIntent` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualHubs/routingIntent) |
| `Microsoft.Network/virtualWans` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualWans) |
| `Microsoft.Network/vpnGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways) |
| `Microsoft.Network/vpnGateways/natRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways/natRules) |
| `Microsoft.Network/vpnGateways/vpnConnections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways/vpnConnections) |
| `Microsoft.Network/vpnServerConfigurations` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/vpnServerConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/network/virtual-wan:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using only defaults](#example-2-using-only-defaults)
- [Using only defaults](#example-3-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualWan 'br/public:avm/ptn/network/virtual-wan:<version>' = {
  name: 'virtualWanDeployment'
  params: {
    // Required parameters
    virtualWanParameters: {
      location: '<location>'
      virtualWanName: 'dep-vw-nvwanmin'
    }
    // Non-required parameters
    virtualHubParameters: [
      {
        hubAddressPrefix: '10.0.0.0/24'
        hubLocation: '<hubLocation>'
        hubName: '<hubName>'
      }
    ]
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
    // Required parameters
    "virtualWanParameters": {
      "value": {
        "location": "<location>",
        "virtualWanName": "dep-vw-nvwanmin"
      }
    },
    // Non-required parameters
    "virtualHubParameters": {
      "value": [
        {
          "hubAddressPrefix": "10.0.0.0/24",
          "hubLocation": "<hubLocation>",
          "hubName": "<hubName>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/network/virtual-wan:<version>'

// Required parameters
param virtualWanParameters = {
  location: '<location>'
  virtualWanName: 'dep-vw-nvwanmin'
}
// Non-required parameters
param virtualHubParameters = [
  {
    hubAddressPrefix: '10.0.0.0/24'
    hubLocation: '<hubLocation>'
    hubName: '<hubName>'
  }
]
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualWan 'br/public:avm/ptn/network/virtual-wan:<version>' = {
  name: 'virtualWanDeployment'
  params: {
    // Required parameters
    virtualWanParameters: {
      location: '<location>'
      virtualWanName: 'dep-vw-nvwamax'
    }
    // Non-required parameters
    virtualHubParameters: [
      {
        hubAddressPrefix: '10.0.0.0/24'
        hubLocation: '<hubLocation>'
        hubName: '<hubName>'
      }
    ]
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
    // Required parameters
    "virtualWanParameters": {
      "value": {
        "location": "<location>",
        "virtualWanName": "dep-vw-nvwamax"
      }
    },
    // Non-required parameters
    "virtualHubParameters": {
      "value": [
        {
          "hubAddressPrefix": "10.0.0.0/24",
          "hubLocation": "<hubLocation>",
          "hubName": "<hubName>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/network/virtual-wan:<version>'

// Required parameters
param virtualWanParameters = {
  location: '<location>'
  virtualWanName: 'dep-vw-nvwamax'
}
// Non-required parameters
param virtualHubParameters = [
  {
    hubAddressPrefix: '10.0.0.0/24'
    hubLocation: '<hubLocation>'
    hubName: '<hubName>'
  }
]
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualWan 'br/public:avm/ptn/network/virtual-wan:<version>' = {
  name: 'virtualWanDeployment'
  params: {
    // Required parameters
    virtualWanParameters: {
      location: '<location>'
      virtualWanName: 'dep-vw-nvwanwaf'
    }
    // Non-required parameters
    virtualHubParameters: [
      {
        hubAddressPrefix: '10.0.0.0/24'
        hubLocation: '<hubLocation>'
        hubName: '<hubName>'
      }
    ]
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
    // Required parameters
    "virtualWanParameters": {
      "value": {
        "location": "<location>",
        "virtualWanName": "dep-vw-nvwanwaf"
      }
    },
    // Non-required parameters
    "virtualHubParameters": {
      "value": [
        {
          "hubAddressPrefix": "10.0.0.0/24",
          "hubLocation": "<hubLocation>",
          "hubName": "<hubName>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/network/virtual-wan:<version>'

// Required parameters
param virtualWanParameters = {
  location: '<location>'
  virtualWanName: 'dep-vw-nvwanwaf'
}
// Non-required parameters
param virtualHubParameters = [
  {
    hubAddressPrefix: '10.0.0.0/24'
    hubLocation: '<hubLocation>'
    hubName: '<hubName>'
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualWanParameters`](#parameter-virtualwanparameters) | object | The parameters for the Virtual WAN. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`lock`](#parameter-lock) | object | The lock settings for the Virtual WAN and associated components. |
| [`virtualHubParameters`](#parameter-virtualhubparameters) | array | The parameters for the Virtual Hubs and associated networking components, required if configuring Virtual Hubs. |

**Option parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Azure region where the Virtual WAN will be created. |

### Parameter: `virtualWanParameters`

The parameters for the Virtual WAN.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualWanName`](#parameter-virtualwanparametersvirtualwanname) | string | The name of the Virtual WAN. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBranchToBranchTraffic`](#parameter-virtualwanparametersallowbranchtobranchtraffic) | bool | Whether to allow branch-to-branch traffic within the Virtual WAN. |
| [`allowVnetToVnetTraffic`](#parameter-virtualwanparametersallowvnettovnettraffic) | bool | Whether to allow VNet-to-VNet traffic within the Virtual WAN. |
| [`disableVpnEncryption`](#parameter-virtualwanparametersdisablevpnencryption) | bool | Whether to disable VPN encryption for the Virtual WAN. |
| [`location`](#parameter-virtualwanparameterslocation) | string | The Azure region where the Virtual WAN will be created. Defaults to the resource group location if not specified. |
| [`lock`](#parameter-virtualwanparameterslock) | object | Lock settings for the Virtual WAN and associated resources. |
| [`p2sVpnParameters`](#parameter-virtualwanparametersp2svpnparameters) | object | Point-to-site VPN server configuration parameters for the Virtual WAN. |
| [`roleAssignments`](#parameter-virtualwanparametersroleassignments) | array | Role assignments to be applied to the Virtual WAN. |
| [`tags`](#parameter-virtualwanparameterstags) | object | Tags to be applied to the Virtual WAN. |
| [`type`](#parameter-virtualwanparameterstype) | string | The type of Virtual WAN. Allowed values are Standard or Basic. |

### Parameter: `virtualWanParameters.virtualWanName`

The name of the Virtual WAN.

- Required: Yes
- Type: string

### Parameter: `virtualWanParameters.allowBranchToBranchTraffic`

Whether to allow branch-to-branch traffic within the Virtual WAN.

- Required: No
- Type: bool

### Parameter: `virtualWanParameters.allowVnetToVnetTraffic`

Whether to allow VNet-to-VNet traffic within the Virtual WAN.

- Required: No
- Type: bool

### Parameter: `virtualWanParameters.disableVpnEncryption`

Whether to disable VPN encryption for the Virtual WAN.

- Required: No
- Type: bool

### Parameter: `virtualWanParameters.location`

The Azure region where the Virtual WAN will be created. Defaults to the resource group location if not specified.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.lock`

Lock settings for the Virtual WAN and associated resources.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-virtualwanparameterslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-virtualwanparameterslockname) | string | Specify the name of lock. |

### Parameter: `virtualWanParameters.lock.kind`

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

### Parameter: `virtualWanParameters.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters`

Point-to-site VPN server configuration parameters for the Virtual WAN.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`createP2sVpnServerConfiguration`](#parameter-virtualwanparametersp2svpnparameterscreatep2svpnserverconfiguration) | bool | Whether to create a new P2S VPN server configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadAudience`](#parameter-virtualwanparametersp2svpnparametersaadaudience) | string | Azure AD audience for VPN authentication. |
| [`aadIssuer`](#parameter-virtualwanparametersp2svpnparametersaadissuer) | string | Azure AD issuer for VPN authentication. |
| [`aadTenant`](#parameter-virtualwanparametersp2svpnparametersaadtenant) | string | Azure AD tenant for VPN authentication. |
| [`p2sConfigurationPolicyGroups`](#parameter-virtualwanparametersp2svpnparametersp2sconfigurationpolicygroups) | array | Policy groups for P2S VPN configuration. |
| [`p2sVpnServerConfigurationName`](#parameter-virtualwanparametersp2svpnparametersp2svpnserverconfigurationname) | string | Name of the P2S VPN server configuration. |
| [`radiusClientRootCertificates`](#parameter-virtualwanparametersp2svpnparametersradiusclientrootcertificates) | array | List of RADIUS client root certificates. |
| [`radiusServerAddress`](#parameter-virtualwanparametersp2svpnparametersradiusserveraddress) | string | RADIUS server address. |
| [`radiusServerRootCertificates`](#parameter-virtualwanparametersp2svpnparametersradiusserverrootcertificates) | array | List of RADIUS server root certificates. |
| [`radiusServers`](#parameter-virtualwanparametersp2svpnparametersradiusservers) | array | List of RADIUS servers. |
| [`radiusServerSecret`](#parameter-virtualwanparametersp2svpnparametersradiusserversecret) | string | RADIUS server secret. |
| [`vpnAuthenticationTypes`](#parameter-virtualwanparametersp2svpnparametersvpnauthenticationtypes) | array | VPN authentication types supported. |
| [`vpnClientIpsecPolicies`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpolicies) | array | List of VPN client IPsec policies. |
| [`vpnClientRevokedCertificates`](#parameter-virtualwanparametersp2svpnparametersvpnclientrevokedcertificates) | array | List of revoked VPN client certificates. |
| [`vpnClientRootCertificates`](#parameter-virtualwanparametersp2svpnparametersvpnclientrootcertificates) | array | List of VPN client root certificates. |
| [`vpnProtocols`](#parameter-virtualwanparametersp2svpnparametersvpnprotocols) | string | Supported VPN protocols. |

### Parameter: `virtualWanParameters.p2sVpnParameters.createP2sVpnServerConfiguration`

Whether to create a new P2S VPN server configuration.

- Required: Yes
- Type: bool

### Parameter: `virtualWanParameters.p2sVpnParameters.aadAudience`

Azure AD audience for VPN authentication.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.aadIssuer`

Azure AD issuer for VPN authentication.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.aadTenant`

Azure AD tenant for VPN authentication.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.p2sConfigurationPolicyGroups`

Policy groups for P2S VPN configuration.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.p2sVpnServerConfigurationName`

Name of the P2S VPN server configuration.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.radiusClientRootCertificates`

List of RADIUS client root certificates.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.radiusServerAddress`

RADIUS server address.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.radiusServerRootCertificates`

List of RADIUS server root certificates.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.radiusServers`

List of RADIUS servers.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.radiusServerSecret`

RADIUS server secret.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnAuthenticationTypes`

VPN authentication types supported.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies`

List of VPN client IPsec policies.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dhGroup`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciesdhgroup) | string | The Diffie-Hellman group used in IKE phase 1. Required if using IKEv2. |
| [`ikeEncryption`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciesikeencryption) | string | The encryption algorithm used in IKE phase 1. Required if using IKEv2. |
| [`ikeIntegrity`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciesikeintegrity) | string | The integrity algorithm used in IKE phase 1. Required if using IKEv2. |
| [`ipsecEncryption`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciesipsecencryption) | string | The encryption algorithm used in IKE phase 2. Required if using IKEv2. |
| [`ipsecIntegrity`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciesipsecintegrity) | string | The integrity algorithm used in IKE phase 2. Required if using IKEv2. |
| [`pfsGroup`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciespfsgroup) | string | The Perfect Forward Secrecy (PFS) group used in IKE phase 2. Required if using IKEv2. |
| [`saDataSizeKilobytes`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciessadatasizekilobytes) | int | The size of the SA data in kilobytes. Required if using IKEv2. |
| [`salfetimeSeconds`](#parameter-virtualwanparametersp2svpnparametersvpnclientipsecpoliciessalfetimeseconds) | int | The lifetime of the SA in seconds. Required if using IKEv2. |

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.dhGroup`

The Diffie-Hellman group used in IKE phase 1. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.ikeEncryption`

The encryption algorithm used in IKE phase 1. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.ikeIntegrity`

The integrity algorithm used in IKE phase 1. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.ipsecEncryption`

The encryption algorithm used in IKE phase 2. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.ipsecIntegrity`

The integrity algorithm used in IKE phase 2. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.pfsGroup`

The Perfect Forward Secrecy (PFS) group used in IKE phase 2. Required if using IKEv2.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.saDataSizeKilobytes`

The size of the SA data in kilobytes. Required if using IKEv2.

- Required: No
- Type: int

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientIpsecPolicies.salfetimeSeconds`

The lifetime of the SA in seconds. Required if using IKEv2.

- Required: No
- Type: int

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientRevokedCertificates`

List of revoked VPN client certificates.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnClientRootCertificates`

List of VPN client root certificates.

- Required: No
- Type: array

### Parameter: `virtualWanParameters.p2sVpnParameters.vpnProtocols`

Supported VPN protocols.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IkeV2'
    'OpenVPN'
  ]
  ```

### Parameter: `virtualWanParameters.roleAssignments`

Role assignments to be applied to the Virtual WAN.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-virtualwanparametersroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-virtualwanparametersroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-virtualwanparametersroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-virtualwanparametersroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-virtualwanparametersroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-virtualwanparametersroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-virtualwanparametersroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-virtualwanparametersroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `virtualWanParameters.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `virtualWanParameters.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `virtualWanParameters.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `virtualWanParameters.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `virtualWanParameters.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `virtualWanParameters.roleAssignments.principalType`

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

### Parameter: `virtualWanParameters.tags`

Tags to be applied to the Virtual WAN.

- Required: No
- Type: object

### Parameter: `virtualWanParameters.type`

The type of Virtual WAN. Allowed values are Standard or Basic.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `lock`

The lock settings for the Virtual WAN and associated components.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

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

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `virtualHubParameters`

The parameters for the Virtual Hubs and associated networking components, required if configuring Virtual Hubs.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hubAddressPrefix`](#parameter-virtualhubparametershubaddressprefix) | string | The address prefix for the Virtual Hub. |
| [`hubLocation`](#parameter-virtualhubparametershublocation) | string | The Azure region where the Virtual Hub will be created. |
| [`hubName`](#parameter-virtualhubparametershubname) | string | The name of the Virtual Hub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBranchToBranchTraffic`](#parameter-virtualhubparametersallowbranchtobranchtraffic) | bool | Whether to allow branch-to-branch traffic within the Virtual Hub. |
| [`expressRouteParameters`](#parameter-virtualhubparametersexpressrouteparameters) | object | ExpressRoute parameters for the Virtual Hub. |
| [`hubRouteTables`](#parameter-virtualhubparametershubroutetables) | array | The route tables for the Virtual Hub. |
| [`hubRoutingPreference`](#parameter-virtualhubparametershubroutingpreference) | string | The routing preference for the Virtual Hub. |
| [`hubVirtualNetworkConnections`](#parameter-virtualhubparametershubvirtualnetworkconnections) | array | The virtual network connections for the Virtual Hub. |
| [`p2sVpnParameters`](#parameter-virtualhubparametersp2svpnparameters) | object | Point-to-site VPN parameters for the Virtual Hub. |
| [`s2sVpnParameters`](#parameter-virtualhubparameterss2svpnparameters) | object | Site-to-site VPN parameters for the Virtual Hub. |
| [`secureHubParameters`](#parameter-virtualhubparameterssecurehubparameters) | object | Secure Hub parameters for the Virtual Hub. |
| [`sku`](#parameter-virtualhubparameterssku) | string | SKU for the Virtual Hub. |
| [`tags`](#parameter-virtualhubparameterstags) | object | Tags to be applied to the Virtual Hub. |
| [`virtualRouterAsn`](#parameter-virtualhubparametersvirtualrouterasn) | int | ASN for the Virtual Router. |
| [`virtualRouterIps`](#parameter-virtualhubparametersvirtualrouterips) | array | IP addresses for the Virtual Router. |

### Parameter: `virtualHubParameters.hubAddressPrefix`

The address prefix for the Virtual Hub.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubLocation`

The Azure region where the Virtual Hub will be created.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubName`

The name of the Virtual Hub.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.allowBranchToBranchTraffic`

Whether to allow branch-to-branch traffic within the Virtual Hub.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters`

ExpressRoute parameters for the Virtual Hub.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deployExpressRouteGateway`](#parameter-virtualhubparametersexpressrouteparametersdeployexpressroutegateway) | bool | Whether to deploy an ExpressRoute Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowNonVirtualWanTraffic`](#parameter-virtualhubparametersexpressrouteparametersallownonvirtualwantraffic) | bool | Allow non-Virtual WAN traffic. |
| [`autoScaleConfigurationBoundsMax`](#parameter-virtualhubparametersexpressrouteparametersautoscaleconfigurationboundsmax) | int | Maximum bound for autoscale configuration. |
| [`autoScaleConfigurationBoundsMin`](#parameter-virtualhubparametersexpressrouteparametersautoscaleconfigurationboundsmin) | int | Minimum bound for autoscale configuration. |
| [`expressRouteConnections`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnections) | array | ExpressRoute connections. |
| [`expressRouteGatewayName`](#parameter-virtualhubparametersexpressrouteparametersexpressroutegatewayname) | string | Name of the ExpressRoute Gateway. |

### Parameter: `virtualHubParameters.expressRouteParameters.deployExpressRouteGateway`

Whether to deploy an ExpressRoute Gateway.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.allowNonVirtualWanTraffic`

Allow non-Virtual WAN traffic.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.autoScaleConfigurationBoundsMax`

Maximum bound for autoscale configuration.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.expressRouteParameters.autoScaleConfigurationBoundsMin`

Minimum bound for autoscale configuration.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections`

ExpressRoute connections.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expressRouteCircuitId`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsexpressroutecircuitid) | string | Resource ID of the ExpressRoute circuit. |
| [`name`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsname) | string | Name of the ExpressRoute connection. |
| [`routingIntent`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsroutingintent) | object | Routing intent for the connection. |
| [`routingWeight`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsroutingweight) | int | Routing weight for the connection. |
| [`sharedKey`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionssharedkey) | string | Shared key for the connection. |
| [`usePolicyBasedTrafficSelectors`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsusepolicybasedtrafficselectors) | bool | Use policy-based traffic selectors. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionBandwidth`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsconnectionbandwidth) | int | Connection bandwidth. |
| [`enableBgp`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsenablebgp) | bool | Enable BGP for the connection. |
| [`enableInternetSecurity`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsenableinternetsecurity) | bool | Enable internet security for the connection. |
| [`enableRateLimiting`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsenableratelimiting) | bool | Enable rate limiting. |
| [`ipsecPolicies`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsipsecpolicies) | array | IPsec policies for the connection. |
| [`trafficSelectorPolicies`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionstrafficselectorpolicies) | array | Traffic selector policies for the connection. |

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.expressRouteCircuitId`

Resource ID of the ExpressRoute circuit.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.name`

Name of the ExpressRoute connection.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.routingIntent`

Routing intent for the connection.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`internetToFirewall`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsroutingintentinternettofirewall) | bool | Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0). |
| [`privateToFirewall`](#parameter-virtualhubparametersexpressrouteparametersexpressrouteconnectionsroutingintentprivatetofirewall) | bool | Configures Routing Intent to forward Private traffic to the firewall (RFC1918). |

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.routingIntent.internetToFirewall`

Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0).

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.routingIntent.privateToFirewall`

Configures Routing Intent to forward Private traffic to the firewall (RFC1918).

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.routingWeight`

Routing weight for the connection.

- Required: Yes
- Type: int

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.sharedKey`

Shared key for the connection.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.usePolicyBasedTrafficSelectors`

Use policy-based traffic selectors.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.connectionBandwidth`

Connection bandwidth.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.enableBgp`

Enable BGP for the connection.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.enableInternetSecurity`

Enable internet security for the connection.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.enableRateLimiting`

Enable rate limiting.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.ipsecPolicies`

IPsec policies for the connection.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteConnections.trafficSelectorPolicies`

Traffic selector policies for the connection.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.expressRouteParameters.expressRouteGatewayName`

Name of the ExpressRoute Gateway.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.hubRouteTables`

The route tables for the Virtual Hub.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualhubparametershubroutetablesname) | string | The route table name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labels`](#parameter-virtualhubparametershubroutetableslabels) | array | List of labels associated with this route table. |
| [`routes`](#parameter-virtualhubparametershubroutetablesroutes) | array | List of all routes. |

### Parameter: `virtualHubParameters.hubRouteTables.name`

The route table name.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubRouteTables.labels`

List of labels associated with this route table.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.hubRouteTables.routes`

List of all routes.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinations`](#parameter-virtualhubparametershubroutetablesroutesdestinations) | array | The address prefix for the route. |
| [`destinationType`](#parameter-virtualhubparametershubroutetablesroutesdestinationtype) | string | The destination type for the route. |
| [`name`](#parameter-virtualhubparametershubroutetablesroutesname) | string | The name of the route. |
| [`nextHop`](#parameter-virtualhubparametershubroutetablesroutesnexthop) | string | The next hop IP address for the route. |
| [`nextHopType`](#parameter-virtualhubparametershubroutetablesroutesnexthoptype) | string | The next hop type for the route. |

### Parameter: `virtualHubParameters.hubRouteTables.routes.destinations`

The address prefix for the route.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.hubRouteTables.routes.destinationType`

The destination type for the route.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CIDR'
  ]
  ```

### Parameter: `virtualHubParameters.hubRouteTables.routes.name`

The name of the route.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubRouteTables.routes.nextHop`

The next hop IP address for the route.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubRouteTables.routes.nextHopType`

The next hop type for the route.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ResourceId'
  ]
  ```

### Parameter: `virtualHubParameters.hubRoutingPreference`

The routing preference for the Virtual Hub.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ASPath'
    'ExpressRoute'
    'VpnGateway'
  ]
  ```

### Parameter: `virtualHubParameters.hubVirtualNetworkConnections`

The virtual network connections for the Virtual Hub.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualhubparametershubvirtualnetworkconnectionsname) | string | The connection name. |
| [`remoteVirtualNetworkResourceId`](#parameter-virtualhubparametershubvirtualnetworkconnectionsremotevirtualnetworkresourceid) | string | Resource ID of the virtual network to link to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableInternetSecurity`](#parameter-virtualhubparametershubvirtualnetworkconnectionsenableinternetsecurity) | bool | Enable internet security. |
| [`routingConfiguration`](#parameter-virtualhubparametershubvirtualnetworkconnectionsroutingconfiguration) | object | Routing Configuration indicating the associated and propagated route tables for this connection. |

### Parameter: `virtualHubParameters.hubVirtualNetworkConnections.name`

The connection name.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubVirtualNetworkConnections.remoteVirtualNetworkResourceId`

Resource ID of the virtual network to link to.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.hubVirtualNetworkConnections.enableInternetSecurity`

Enable internet security.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.hubVirtualNetworkConnections.routingConfiguration`

Routing Configuration indicating the associated and propagated route tables for this connection.

- Required: No
- Type: object

### Parameter: `virtualHubParameters.p2sVpnParameters`

Point-to-site VPN parameters for the Virtual Hub.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionConfigurationsName`](#parameter-virtualhubparametersp2svpnparametersconnectionconfigurationsname) | string | Name of the connection configurations. |
| [`deployP2SVpnGateway`](#parameter-virtualhubparametersp2svpnparametersdeployp2svpngateway) | bool | Whether to deploy a P2S VPN Gateway. |
| [`vpnClientAddressPoolAddressPrefixes`](#parameter-virtualhubparametersp2svpnparametersvpnclientaddresspooladdressprefixes) | array | Address prefixes for the VPN client address pool. |
| [`vpnGatewayName`](#parameter-virtualhubparametersp2svpnparametersvpngatewayname) | string | Name of the VPN Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customDnsServers`](#parameter-virtualhubparametersp2svpnparameterscustomdnsservers) | array | Custom DNS servers for the P2S VPN Gateway. |
| [`enableInternetSecurity`](#parameter-virtualhubparametersp2svpnparametersenableinternetsecurity) | bool | Enable internet security for the P2S VPN Gateway. |
| [`inboundRouteMapResourceId`](#parameter-virtualhubparametersp2svpnparametersinboundroutemapresourceid) | string | Resource ID of the inbound route map. |
| [`isRoutingPreferenceInternet`](#parameter-virtualhubparametersp2svpnparametersisroutingpreferenceinternet) | bool | Whether routing preference is internet. |
| [`outboundRouteMapResourceId`](#parameter-virtualhubparametersp2svpnparametersoutboundroutemapresourceid) | string | Resource ID of the outbound route map. |
| [`propagatedLabelNames`](#parameter-virtualhubparametersp2svpnparameterspropagatedlabelnames) | array | Names of propagated labels. |
| [`propagatedRouteTableNames`](#parameter-virtualhubparametersp2svpnparameterspropagatedroutetablenames) | array | Names of propagated route tables. |
| [`vnetRoutesStaticRoutes`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutes) | object | Static routes for VNet routes. |
| [`vpnGatewayAssociatedRouteTable`](#parameter-virtualhubparametersp2svpnparametersvpngatewayassociatedroutetable) | string | Associated route table for the VPN Gateway. |
| [`vpnGatewayScaleUnit`](#parameter-virtualhubparametersp2svpnparametersvpngatewayscaleunit) | int | Scale unit for the VPN Gateway. |

### Parameter: `virtualHubParameters.p2sVpnParameters.connectionConfigurationsName`

Name of the connection configurations.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.deployP2SVpnGateway`

Whether to deploy a P2S VPN Gateway.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.p2sVpnParameters.vpnClientAddressPoolAddressPrefixes`

Address prefixes for the VPN client address pool.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.p2sVpnParameters.vpnGatewayName`

Name of the VPN Gateway.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.customDnsServers`

Custom DNS servers for the P2S VPN Gateway.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.p2sVpnParameters.enableInternetSecurity`

Enable internet security for the P2S VPN Gateway.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.p2sVpnParameters.inboundRouteMapResourceId`

Resource ID of the inbound route map.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.isRoutingPreferenceInternet`

Whether routing preference is internet.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.p2sVpnParameters.outboundRouteMapResourceId`

Resource ID of the outbound route map.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.propagatedLabelNames`

Names of propagated labels.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.p2sVpnParameters.propagatedRouteTableNames`

Names of propagated route tables.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes`

Static routes for VNet routes.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticRoutes`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutesstaticroutes) | array | The static route configuration for the P2S VPN Gateway. |
| [`staticRoutesConfig`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutesstaticroutesconfig) | object | The static route configuration for the P2S VPN Gateway. |

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes.staticRoutes`

The static route configuration for the P2S VPN Gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutesstaticroutesaddressprefixes) | array | The address prefixes of the static route. |
| [`name`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutesstaticroutesname) | string | The name of the static route. |
| [`nextHopIpAddress`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutesstaticroutesnexthopipaddress) | string | The next hop IP of the static route. |

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes.staticRoutes.addressPrefixes`

The address prefixes of the static route.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes.staticRoutes.name`

The name of the static route.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes.staticRoutes.nextHopIpAddress`

The next hop IP of the static route.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes.staticRoutesConfig`

The static route configuration for the P2S VPN Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vnetLocalRouteOverrideCriteria`](#parameter-virtualhubparametersp2svpnparametersvnetroutesstaticroutesstaticroutesconfigvnetlocalrouteoverridecriteria) | string | Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke. |

### Parameter: `virtualHubParameters.p2sVpnParameters.vnetRoutesStaticRoutes.staticRoutesConfig.vnetLocalRouteOverrideCriteria`

Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.p2sVpnParameters.vpnGatewayAssociatedRouteTable`

Associated route table for the VPN Gateway.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'defaultRouteTable'
    'noneRouteTable'
  ]
  ```

### Parameter: `virtualHubParameters.p2sVpnParameters.vpnGatewayScaleUnit`

Scale unit for the VPN Gateway.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.s2sVpnParameters`

Site-to-site VPN parameters for the Virtual Hub.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deployS2SVpnGateway`](#parameter-virtualhubparameterss2svpnparametersdeploys2svpngateway) | bool | Whether to deploy a S2S VPN Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bgpSettings`](#parameter-virtualhubparameterss2svpnparametersbgpsettings) | object | BGP settings for the VPN Gateway. |
| [`enableBgpRouteTranslationForNat`](#parameter-virtualhubparameterss2svpnparametersenablebgproutetranslationfornat) | bool | Enable BGP route translation for NAT. |
| [`isRoutingPreferenceInternet`](#parameter-virtualhubparameterss2svpnparametersisroutingpreferenceinternet) | bool | Whether routing preference is internet. |
| [`lock`](#parameter-virtualhubparameterss2svpnparameterslock) | object | Lock settings for the VPN Gateway. |
| [`natRules`](#parameter-virtualhubparameterss2svpnparametersnatrules) | array | NAT rules for the VPN Gateway. |
| [`vpnConnections`](#parameter-virtualhubparameterss2svpnparametersvpnconnections) | array | VPN connections for the VPN Gateway. |
| [`vpnGatewayName`](#parameter-virtualhubparameterss2svpnparametersvpngatewayname) | string | Name of the VPN Gateway. |
| [`vpnGatewayScaleUnit`](#parameter-virtualhubparameterss2svpnparametersvpngatewayscaleunit) | int | Scale unit for the VPN Gateway. |

### Parameter: `virtualHubParameters.s2sVpnParameters.deployS2SVpnGateway`

Whether to deploy a S2S VPN Gateway.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.bgpSettings`

BGP settings for the VPN Gateway.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`asn`](#parameter-virtualhubparameterss2svpnparametersbgpsettingsasn) | int | ASN for BGP. |
| [`bgpPeeringAddress`](#parameter-virtualhubparameterss2svpnparametersbgpsettingsbgppeeringaddress) | string | BGP peering address. |
| [`bgpPeeringAddresses`](#parameter-virtualhubparameterss2svpnparametersbgpsettingsbgppeeringaddresses) | array | BGP peering addresses. |
| [`peerWeight`](#parameter-virtualhubparameterss2svpnparametersbgpsettingspeerweight) | int | Peer weight for BGP. |

### Parameter: `virtualHubParameters.s2sVpnParameters.bgpSettings.asn`

ASN for BGP.

- Required: Yes
- Type: int

### Parameter: `virtualHubParameters.s2sVpnParameters.bgpSettings.bgpPeeringAddress`

BGP peering address.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.bgpSettings.bgpPeeringAddresses`

BGP peering addresses.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.s2sVpnParameters.bgpSettings.peerWeight`

Peer weight for BGP.

- Required: Yes
- Type: int

### Parameter: `virtualHubParameters.s2sVpnParameters.enableBgpRouteTranslationForNat`

Enable BGP route translation for NAT.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.isRoutingPreferenceInternet`

Whether routing preference is internet.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.lock`

Lock settings for the VPN Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-virtualhubparameterss2svpnparameterslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-virtualhubparameterss2svpnparameterslockname) | string | Specify the name of lock. |

### Parameter: `virtualHubParameters.s2sVpnParameters.lock.kind`

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

### Parameter: `virtualHubParameters.s2sVpnParameters.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.natRules`

NAT rules for the VPN Gateway.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections`

VPN connections for the VPN Gateway.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsname) | string | Name of the VPN connection. |
| [`remoteVpnSiteResourceId`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsremotevpnsiteresourceid) | string | Resource ID of the remote VPN site. |
| [`routingWeight`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsroutingweight) | int | Routing weight for the connection. |
| [`sharedKey`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionssharedkey) | string | Shared key for the connection. |
| [`useLocalAzureIpAddress`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsuselocalazureipaddress) | bool | Use local Azure IP address. |
| [`usePolicyBasedTrafficSelectors`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsusepolicybasedtrafficselectors) | bool | Use policy-based traffic selectors. |
| [`vpnConnectionProtocolType`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsvpnconnectionprotocoltype) | string | VPN connection protocol type. |
| [`vpnGatewayName`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsvpngatewayname) | string | Name of the VPN Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionBandwidth`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsconnectionbandwidth) | int | Connection bandwidth. |
| [`enableBgp`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsenablebgp) | bool | Enable BGP for the connection. |
| [`enableInternetSecurity`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsenableinternetsecurity) | bool | Enable internet security for the connection. |
| [`enableRateLimiting`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsenableratelimiting) | bool | Enable rate limiting. |
| [`ipsecPolicies`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsipsecpolicies) | array | IPsec policies for the connection. |
| [`routingConfiguration`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsroutingconfiguration) | object | Routing configuration for the connection. |
| [`trafficSelectorPolicies`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionstrafficselectorpolicies) | array | Traffic selector policies for the connection. |
| [`vpnLinkConnections`](#parameter-virtualhubparameterss2svpnparametersvpnconnectionsvpnlinkconnections) | array | VPN link connections for the connection. |

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.name`

Name of the VPN connection.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.remoteVpnSiteResourceId`

Resource ID of the remote VPN site.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.routingWeight`

Routing weight for the connection.

- Required: Yes
- Type: int

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.sharedKey`

Shared key for the connection.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.useLocalAzureIpAddress`

Use local Azure IP address.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.usePolicyBasedTrafficSelectors`

Use policy-based traffic selectors.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.vpnConnectionProtocolType`

VPN connection protocol type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'IKEv1'
    'IKEv2'
  ]
  ```

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.vpnGatewayName`

Name of the VPN Gateway.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.connectionBandwidth`

Connection bandwidth.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.enableBgp`

Enable BGP for the connection.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.enableInternetSecurity`

Enable internet security for the connection.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.enableRateLimiting`

Enable rate limiting.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.ipsecPolicies`

IPsec policies for the connection.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.routingConfiguration`

Routing configuration for the connection.

- Required: Yes
- Type: object

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.trafficSelectorPolicies`

Traffic selector policies for the connection.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnConnections.vpnLinkConnections`

VPN link connections for the connection.

- Required: Yes
- Type: array

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnGatewayName`

Name of the VPN Gateway.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.s2sVpnParameters.vpnGatewayScaleUnit`

Scale unit for the VPN Gateway.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.secureHubParameters`

Secure Hub parameters for the Virtual Hub.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploySecureHub`](#parameter-virtualhubparameterssecurehubparametersdeploysecurehub) | bool | Whether to deploy a Secure Hub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalPublicIpConfigurationResourceIds`](#parameter-virtualhubparameterssecurehubparametersadditionalpublicipconfigurationresourceids) | array | Additional public IP configuration resource IDs. |
| [`azureFirewallName`](#parameter-virtualhubparameterssecurehubparametersazurefirewallname) | string | Name of the Azure Firewall. |
| [`azureFirewallPublicIPCount`](#parameter-virtualhubparameterssecurehubparametersazurefirewallpublicipcount) | int | Number of public IPs for the Azure Firewall. |
| [`azureFirewallSku`](#parameter-virtualhubparameterssecurehubparametersazurefirewallsku) | string | SKU for the Azure Firewall. |
| [`diagnosticSettings`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettings) | array | Diagnostic settings for the Azure Firewall in the Secure Hub. |
| [`firewallPolicyResourceId`](#parameter-virtualhubparameterssecurehubparametersfirewallpolicyresourceid) | string | Resource ID of the firewall policy. |
| [`publicIPAddressObject`](#parameter-virtualhubparameterssecurehubparameterspublicipaddressobject) | object | Public IP address object for the Azure Firewall. |
| [`publicIPResourceID`](#parameter-virtualhubparameterssecurehubparameterspublicipresourceid) | string | Resource ID of the public IP address. |

### Parameter: `virtualHubParameters.secureHubParameters.deploySecureHub`

Whether to deploy a Secure Hub.

- Required: Yes
- Type: bool

### Parameter: `virtualHubParameters.secureHubParameters.additionalPublicIpConfigurationResourceIds`

Additional public IP configuration resource IDs.

- Required: No
- Type: array

### Parameter: `virtualHubParameters.secureHubParameters.azureFirewallName`

Name of the Azure Firewall.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.azureFirewallPublicIPCount`

Number of public IPs for the Azure Firewall.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.secureHubParameters.azureFirewallSku`

SKU for the Azure Firewall.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings`

Diagnostic settings for the Azure Firewall in the Secure Hub.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-virtualhubparameterssecurehubparametersdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.firewallPolicyResourceId`

Resource ID of the firewall policy.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.publicIPAddressObject`

Public IP address object for the Azure Firewall.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualhubparameterssecurehubparameterspublicipaddressobjectname) | string | Name of the public IP address. |
| [`publicIPAllocationMethod`](#parameter-virtualhubparameterssecurehubparameterspublicipaddressobjectpublicipallocationmethod) | string | Allocation method for the public IP address. |
| [`publicIPPrefixResourceId`](#parameter-virtualhubparameterssecurehubparameterspublicipaddressobjectpublicipprefixresourceid) | string | Resource ID of the public IP prefix. |
| [`skuName`](#parameter-virtualhubparameterssecurehubparameterspublicipaddressobjectskuname) | string | SKU name for the public IP address. |
| [`skuTier`](#parameter-virtualhubparameterssecurehubparameterspublicipaddressobjectskutier) | string | SKU tier for the public IP address. |

### Parameter: `virtualHubParameters.secureHubParameters.publicIPAddressObject.name`

Name of the public IP address.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.publicIPAddressObject.publicIPAllocationMethod`

Allocation method for the public IP address.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Static'
  ]
  ```

### Parameter: `virtualHubParameters.secureHubParameters.publicIPAddressObject.publicIPPrefixResourceId`

Resource ID of the public IP prefix.

- Required: Yes
- Type: string

### Parameter: `virtualHubParameters.secureHubParameters.publicIPAddressObject.skuName`

SKU name for the public IP address.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Standard'
  ]
  ```

### Parameter: `virtualHubParameters.secureHubParameters.publicIPAddressObject.skuTier`

SKU tier for the public IP address.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Regional'
  ]
  ```

### Parameter: `virtualHubParameters.secureHubParameters.publicIPResourceID`

Resource ID of the public IP address.

- Required: No
- Type: string

### Parameter: `virtualHubParameters.sku`

SKU for the Virtual Hub.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `virtualHubParameters.tags`

Tags to be applied to the Virtual Hub.

- Required: No
- Type: object

### Parameter: `virtualHubParameters.virtualRouterAsn`

ASN for the Virtual Router.

- Required: No
- Type: int

### Parameter: `virtualHubParameters.virtualRouterIps`

IP addresses for the Virtual Router.

- Required: No
- Type: array

### Parameter: `location`

Azure region where the Virtual WAN will be created.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `virtualHubs` | array | The array containing the Virtual Hub information |
| `virtualWan` | object | Object containing the Virtual WAN information |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
