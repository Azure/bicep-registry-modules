# VPN Server Configuration `[Microsoft.Network/vpnServerConfigurations]`

This module deploys a VPN Server Configuration for a Virtual Hub P2S Gateway.

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
| `Microsoft.Network/vpnServerConfigurations` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/vpnServerConfigurations) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/vpn-server-configuration:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:<version>' = {
  name: 'vpnServerConfigurationDeployment'
  params: {
    // Required parameters
    name: 'vscmin001'
    vpnServerConfigurationName: 'vscmin-vpnServerConfig'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "vscmin001"
    },
    "vpnServerConfigurationName": {
      "value": "vscmin-vpnServerConfig"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:<version>' = {
  name: 'vpnServerConfigurationDeployment'
  params: {
    // Required parameters
    name: 'vscmax001'
    vpnServerConfigurationName: 'vscmax-vpnServerConfig'
    // Non-required parameters
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "vscmax001"
    },
    "vpnServerConfigurationName": {
      "value": "vscmax-vpnServerConfig"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnServerConfiguration 'br/public:avm/res/network/vpn-server-configuration:<version>' = {
  name: 'vpnServerConfigurationDeployment'
  params: {
    // Required parameters
    name: 'vscwaf001'
    vpnServerConfigurationName: 'vscwaf-vpnServerConfig'
    // Non-required parameters
    location: '<location>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "vscwaf001"
    },
    "vpnServerConfigurationName": {
      "value": "vscwaf-vpnServerConfig"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the user VPN configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`radiusServerAddress`](#parameter-radiusserveraddress) | string | The address of the Radius server. Required if configuring Radius. |
| [`radiusServerSecret`](#parameter-radiusserversecret) | securestring | The Radius server secret. Required if configuring Radius. |
| [`vpnClientRootCertificates`](#parameter-vpnclientrootcertificates) | array | The VPN Client root certificates for the configuration. Required if using certificate authentication. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadAudience`](#parameter-aadaudience) | string | The audience for the AAD/Entrance authentication. |
| [`aadIssuer`](#parameter-aadissuer) | string | The issuer for the AAD/Entrance authentication. |
| [`aadTenant`](#parameter-aadtenant) | string | The audience for the AAD/Entrance authentication. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location where all resources will be created. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`p2sConfigurationPolicyGroups`](#parameter-p2sconfigurationpolicygroups) | array | The P2S configuration policy groups for the configuration. |
| [`radiusClientRootCertificates`](#parameter-radiusclientrootcertificates) | array | The root certificates of the Radius client. |
| [`radiusServerRootCertificates`](#parameter-radiusserverrootcertificates) | array | The root certificates of the Radius server. |
| [`radiusServers`](#parameter-radiusservers) | array | The list of Radius servers. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vpnAuthenticationTypes`](#parameter-vpnauthenticationtypes) | array | The authentication types for the VPN configuration. |
| [`vpnClientIpsecPolicies`](#parameter-vpnclientipsecpolicies) | array | The IPsec policies for the configuration. |
| [`vpnClientRevokedCertificates`](#parameter-vpnclientrevokedcertificates) | array | The revoked VPN Client certificates for the configuration. |
| [`vpnProtocols`](#parameter-vpnprotocols) | array | The allowed VPN protocols for the configuration. |
| [`vpnServerConfigurationName`](#parameter-vpnserverconfigurationname) | string | The name of the VpnServerConfiguration that is unique within a resource group. |

### Parameter: `name`

The name of the user VPN configuration.

- Required: Yes
- Type: string

### Parameter: `radiusServerAddress`

The address of the Radius server. Required if configuring Radius.

- Required: No
- Type: string

### Parameter: `radiusServerSecret`

The Radius server secret. Required if configuring Radius.

- Required: No
- Type: securestring

### Parameter: `vpnClientRootCertificates`

The VPN Client root certificates for the configuration. Required if using certificate authentication.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `aadAudience`

The audience for the AAD/Entrance authentication.

- Required: No
- Type: string

### Parameter: `aadIssuer`

The issuer for the AAD/Entrance authentication.

- Required: No
- Type: string

### Parameter: `aadTenant`

The audience for the AAD/Entrance authentication.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location where all resources will be created.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

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

### Parameter: `p2sConfigurationPolicyGroups`

The P2S configuration policy groups for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `radiusClientRootCertificates`

The root certificates of the Radius client.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `radiusServerRootCertificates`

The root certificates of the Radius server.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `radiusServers`

The list of Radius servers.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnAuthenticationTypes`

The authentication types for the VPN configuration.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'AAD'
    'Certificate'
    'Radius'
  ]
  ```

### Parameter: `vpnClientIpsecPolicies`

The IPsec policies for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vpnClientRevokedCertificates`

The revoked VPN Client certificates for the configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vpnProtocols`

The allowed VPN protocols for the configuration.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'IkeV2'
    'OpenVPN'
  ]
  ```

### Parameter: `vpnServerConfigurationName`

The name of the VpnServerConfiguration that is unique within a resource group.

- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the user VPN configuration. |
| `resourceGroupName` | string | The name of the resource group the user VPN configuration was deployed into. |
| `resourceId` | string | The resource ID of the user VPN configuration. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
