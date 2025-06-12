# App ManagedEnvironments `[Microsoft.App/managedEnvironments]`

This module deploys an App Managed Environment (also known as a Container App Environment).

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
| `Microsoft.App/managedEnvironments` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments) |
| `Microsoft.App/managedEnvironments/certificates` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates) |
| `Microsoft.App/managedEnvironments/storages` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/storages) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/managed-environment:<version>`.

- [No App Logging](#example-1-no-app-logging)
- [Using only defaults](#example-2-using-only-defaults)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Enable public access](#example-4-enable-public-access)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _No App Logging_

This instance deploys the module to use Azure Monitor for logging.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'ameamon001'
    // Non-required parameters
    appLogsConfiguration: {
      destination: 'azure-monitor'
    }
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
    "name": {
      "value": "ameamon001"
    },
    // Non-required parameters
    "appLogsConfiguration": {
      "value": {
        "destination": "azure-monitor"
      }
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'ameamon001'
// Non-required parameters
param appLogsConfiguration = {
  destination: 'azure-monitor'
}
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
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
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'amemin001'
    // Non-required parameters
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
    "name": {
      "value": "amemin001"
    },
    // Non-required parameters
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amemin001'
// Non-required parameters
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'amemax001'
    // Non-required parameters
    appInsightsConnectionString: '<appInsightsConnectionString>'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '<customerId>'
        sharedKey: '<sharedKey>'
      }
    }
    certificate: {
      certificateKeyVaultProperties: {
        identityResourceId: '<identityResourceId>'
        keyVaultUrl: '<keyVaultUrl>'
      }
      name: 'dep-cert-amemax'
    }
    dnsSuffix: 'contoso.com'
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    openTelemetryConfiguration: {
      logsConfiguration: {
        destinations: [
          'appInsights'
        ]
      }
      tracesConfiguration: {
        destinations: [
          'appInsights'
        ]
      }
    }
    peerTrafficEncryption: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    storages: [
      {
        accessMode: 'ReadWrite'
        kind: 'SMB'
        shareName: 'smbfileshare'
        storageAccountName: '<storageAccountName>'
      }
      {
        accessMode: 'ReadWrite'
        kind: 'NFS'
        shareName: 'nfsfileshare'
        storageAccountName: '<storageAccountName>'
      }
    ]
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
    "name": {
      "value": "amemax001"
    },
    // Non-required parameters
    "appInsightsConnectionString": {
      "value": "<appInsightsConnectionString>"
    },
    "appLogsConfiguration": {
      "value": {
        "destination": "log-analytics",
        "logAnalyticsConfiguration": {
          "customerId": "<customerId>",
          "sharedKey": "<sharedKey>"
        }
      }
    },
    "certificate": {
      "value": {
        "certificateKeyVaultProperties": {
          "identityResourceId": "<identityResourceId>",
          "keyVaultUrl": "<keyVaultUrl>"
        },
        "name": "dep-cert-amemax"
      }
    },
    "dnsSuffix": {
      "value": "contoso.com"
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "openTelemetryConfiguration": {
      "value": {
        "logsConfiguration": {
          "destinations": [
            "appInsights"
          ]
        },
        "tracesConfiguration": {
          "destinations": [
            "appInsights"
          ]
        }
      }
    },
    "peerTrafficEncryption": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "storages": {
      "value": [
        {
          "accessMode": "ReadWrite",
          "kind": "SMB",
          "shareName": "smbfileshare",
          "storageAccountName": "<storageAccountName>"
        },
        {
          "accessMode": "ReadWrite",
          "kind": "NFS",
          "shareName": "nfsfileshare",
          "storageAccountName": "<storageAccountName>"
        }
      ]
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amemax001'
// Non-required parameters
param appInsightsConnectionString = '<appInsightsConnectionString>'
param appLogsConfiguration = {
  destination: 'log-analytics'
  logAnalyticsConfiguration: {
    customerId: '<customerId>'
    sharedKey: '<sharedKey>'
  }
}
param certificate = {
  certificateKeyVaultProperties: {
    identityResourceId: '<identityResourceId>'
    keyVaultUrl: '<keyVaultUrl>'
  }
  name: 'dep-cert-amemax'
}
param dnsSuffix = 'contoso.com'
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param openTelemetryConfiguration = {
  logsConfiguration: {
    destinations: [
      'appInsights'
    ]
  }
  tracesConfiguration: {
    destinations: [
      'appInsights'
    ]
  }
}
param peerTrafficEncryption = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param storages = [
  {
    accessMode: 'ReadWrite'
    kind: 'SMB'
    shareName: 'smbfileshare'
    storageAccountName: '<storageAccountName>'
  }
  {
    accessMode: 'ReadWrite'
    kind: 'NFS'
    shareName: 'nfsfileshare'
    storageAccountName: '<storageAccountName>'
  }
]
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 4: _Enable public access_

This instance deploys the module with public access enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'amepa001'
    // Non-required parameters
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '<customerId>'
        sharedKey: '<sharedKey>'
      }
    }
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    location: '<location>'
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    publicNetworkAccess: 'Enabled'
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
    "name": {
      "value": "amepa001"
    },
    // Non-required parameters
    "appLogsConfiguration": {
      "value": {
        "destination": "log-analytics",
        "logAnalyticsConfiguration": {
          "customerId": "<customerId>",
          "sharedKey": "<sharedKey>"
        }
      }
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "location": {
      "value": "<location>"
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "publicNetworkAccess": {
      "value": "Enabled"
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amepa001'
// Non-required parameters
param appLogsConfiguration = {
  destination: 'log-analytics'
  logAnalyticsConfiguration: {
    customerId: '<customerId>'
    sharedKey: '<sharedKey>'
  }
}
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param location = '<location>'
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param publicNetworkAccess = 'Enabled'
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment:<version>' = {
  name: 'managedEnvironmentDeployment'
  params: {
    // Required parameters
    name: 'amewaf001'
    // Non-required parameters
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '<customerId>'
        sharedKey: '<sharedKey>'
      }
    }
    dockerBridgeCidr: '172.16.0.1/28'
    infrastructureResourceGroupName: '<infrastructureResourceGroupName>'
    infrastructureSubnetResourceId: '<infrastructureSubnetResourceId>'
    internal: true
    platformReservedCidr: '172.17.17.0/24'
    platformReservedDnsIP: '172.17.17.17'
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    workloadProfiles: [
      {
        maximumCount: 3
        minimumCount: 0
        name: 'CAW01'
        workloadProfileType: 'D4'
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
    "name": {
      "value": "amewaf001"
    },
    // Non-required parameters
    "appLogsConfiguration": {
      "value": {
        "destination": "log-analytics",
        "logAnalyticsConfiguration": {
          "customerId": "<customerId>",
          "sharedKey": "<sharedKey>"
        }
      }
    },
    "dockerBridgeCidr": {
      "value": "172.16.0.1/28"
    },
    "infrastructureResourceGroupName": {
      "value": "<infrastructureResourceGroupName>"
    },
    "infrastructureSubnetResourceId": {
      "value": "<infrastructureSubnetResourceId>"
    },
    "internal": {
      "value": true
    },
    "platformReservedCidr": {
      "value": "172.17.17.0/24"
    },
    "platformReservedDnsIP": {
      "value": "172.17.17.17"
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "workloadProfiles": {
      "value": [
        {
          "maximumCount": 3,
          "minimumCount": 0,
          "name": "CAW01",
          "workloadProfileType": "D4"
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
using 'br/public:avm/res/app/managed-environment:<version>'

// Required parameters
param name = 'amewaf001'
// Non-required parameters
param appLogsConfiguration = {
  destination: 'log-analytics'
  logAnalyticsConfiguration: {
    customerId: '<customerId>'
    sharedKey: '<sharedKey>'
  }
}
param dockerBridgeCidr = '172.16.0.1/28'
param infrastructureResourceGroupName = '<infrastructureResourceGroupName>'
param infrastructureSubnetResourceId = '<infrastructureSubnetResourceId>'
param internal = true
param platformReservedCidr = '172.17.17.0/24'
param platformReservedDnsIP = '172.17.17.17'
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param workloadProfiles = [
  {
    maximumCount: 3
    minimumCount: 0
    name: 'CAW01'
    workloadProfileType: 'D4'
  }
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Container Apps Managed Environment. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dockerBridgeCidr`](#parameter-dockerbridgecidr) | string | CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureResourceGroupName`](#parameter-infrastructureresourcegroupname) | string | Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`infrastructureSubnetResourceId`](#parameter-infrastructuresubnetresourceid) | string | Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`internal`](#parameter-internal) | bool | Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`platformReservedCidr`](#parameter-platformreservedcidr) | string | IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant. |
| [`platformReservedDnsIP`](#parameter-platformreserveddnsip) | string | An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant. |
| [`workloadProfiles`](#parameter-workloadprofiles) | array | Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appInsightsConnectionString`](#parameter-appinsightsconnectionstring) | securestring | Application Insights connection string. |
| [`appLogsConfiguration`](#parameter-applogsconfiguration) | object | The AppLogsConfiguration for the Managed Environment. |
| [`certificate`](#parameter-certificate) | object | A Managed Environment Certificate. |
| [`certificatePassword`](#parameter-certificatepassword) | securestring | Password of the certificate used by the custom domain. |
| [`certificateValue`](#parameter-certificatevalue) | securestring | Certificate to use for the custom domain. PFX or PEM. |
| [`daprAIConnectionString`](#parameter-dapraiconnectionstring) | securestring | Application Insights connection string used by Dapr to export Service to Service communication telemetry. |
| [`daprAIInstrumentationKey`](#parameter-dapraiinstrumentationkey) | securestring | Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry. |
| [`dnsSuffix`](#parameter-dnssuffix) | string | DNS suffix for the environment domain. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`openTelemetryConfiguration`](#parameter-opentelemetryconfiguration) | object | Open Telemetry configuration. |
| [`peerTrafficEncryption`](#parameter-peertrafficencryption) | bool | Whether or not to encrypt peer traffic. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | Whether to allow or block all public traffic. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`storages`](#parameter-storages) | array | The list of storages to mount on the environment. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this Managed Environment is zone-redundant. |

### Parameter: `name`

Name of the Container Apps Managed Environment.

- Required: Yes
- Type: string

### Parameter: `dockerBridgeCidr`

CIDR notation IP range assigned to the Docker bridge, network. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `infrastructureResourceGroupName`

Name of the infrastructure resource group. If not provided, it will be set with a default value. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `[take(format('ME_{0}', parameters('name')), 63)]`

### Parameter: `infrastructureSubnetResourceId`

Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `internal`

Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `platformReservedCidr`

IP range in CIDR notation that can be reserved for environment infrastructure IP addresses. It must not overlap with any other provided IP ranges and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true  to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `platformReservedDnsIP`

An IP address from the IP range defined by "platformReservedCidr" that will be reserved for the internal DNS server. It must not be the first address in the range and can only be used when the environment is deployed into a virtual network. If not provided, it will be set with a default value by the platform. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: string
- Default: `''`

### Parameter: `workloadProfiles`

Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `appInsightsConnectionString`

Application Insights connection string.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `appLogsConfiguration`

The AppLogsConfiguration for the Managed Environment.

- Required: No
- Type: object

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`logAnalyticsConfiguration`](#parameter-applogsconfigurationloganalyticsconfiguration) | object | The Log Analytics configuration. Required if `destination` is `log-analytics`. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-applogsconfigurationdestination) | string | The destination of the logs. |

### Parameter: `appLogsConfiguration.logAnalyticsConfiguration`

The Log Analytics configuration. Required if `destination` is `log-analytics`.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customerId`](#parameter-applogsconfigurationloganalyticsconfigurationcustomerid) | string | The Log Analytics Workspace ID. |
| [`sharedKey`](#parameter-applogsconfigurationloganalyticsconfigurationsharedkey) | securestring | The shared key of the Log Analytics workspace. |

### Parameter: `appLogsConfiguration.logAnalyticsConfiguration.customerId`

The Log Analytics Workspace ID.

- Required: Yes
- Type: string

### Parameter: `appLogsConfiguration.logAnalyticsConfiguration.sharedKey`

The shared key of the Log Analytics workspace.

- Required: Yes
- Type: securestring

### Parameter: `appLogsConfiguration.destination`

The destination of the logs.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'azure-monitor'
    'log-analytics'
    'none'
  ]
  ```

### Parameter: `certificate`

A Managed Environment Certificate.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateKeyVaultProperties`](#parameter-certificatecertificatekeyvaultproperties) | object | A key vault reference. |
| [`certificatePassword`](#parameter-certificatecertificatepassword) | string | The password of the certificate. |
| [`certificateType`](#parameter-certificatecertificatetype) | string | The type of the certificate. |
| [`certificateValue`](#parameter-certificatecertificatevalue) | string | The value of the certificate. PFX or PEM blob. |
| [`name`](#parameter-certificatename) | string | The name of the certificate. |

### Parameter: `certificate.certificateKeyVaultProperties`

A key vault reference.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityResourceId`](#parameter-certificatecertificatekeyvaultpropertiesidentityresourceid) | string | The resource ID of the identity. This is the identity that will be used to access the key vault. |
| [`keyVaultUrl`](#parameter-certificatecertificatekeyvaultpropertieskeyvaulturl) | string | A key vault URL referencing the wildcard certificate that will be used for the custom domain. |

### Parameter: `certificate.certificateKeyVaultProperties.identityResourceId`

The resource ID of the identity. This is the identity that will be used to access the key vault.

- Required: Yes
- Type: string

### Parameter: `certificate.certificateKeyVaultProperties.keyVaultUrl`

A key vault URL referencing the wildcard certificate that will be used for the custom domain.

- Required: Yes
- Type: string

### Parameter: `certificate.certificatePassword`

The password of the certificate.

- Required: No
- Type: string

### Parameter: `certificate.certificateType`

The type of the certificate.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ImagePullTrustedCA'
    'ServerSSLCertificate'
  ]
  ```

### Parameter: `certificate.certificateValue`

The value of the certificate. PFX or PEM blob.

- Required: No
- Type: string

### Parameter: `certificate.name`

The name of the certificate.

- Required: No
- Type: string

### Parameter: `certificatePassword`

Password of the certificate used by the custom domain.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `certificateValue`

Certificate to use for the custom domain. PFX or PEM.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIConnectionString`

Application Insights connection string used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `daprAIInstrumentationKey`

Azure Monitor instrumentation key used by Dapr to export Service to Service communication telemetry.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `dnsSuffix`

DNS suffix for the environment domain.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

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

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `openTelemetryConfiguration`

Open Telemetry configuration.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `peerTrafficEncryption`

Whether or not to encrypt peer traffic.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `publicNetworkAccess`

Whether to allow or block all public traffic.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

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

### Parameter: `storages`

The list of storages to mount on the environment.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-storagesaccessmode) | string | Access mode for storage: "ReadOnly" or "ReadWrite". |
| [`kind`](#parameter-storageskind) | string | Type of storage: "SMB" or "NFS". |
| [`shareName`](#parameter-storagessharename) | string | File share name. |
| [`storageAccountName`](#parameter-storagesstorageaccountname) | string | Storage account name. |

### Parameter: `storages.accessMode`

Access mode for storage: "ReadOnly" or "ReadWrite".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ReadOnly'
    'ReadWrite'
  ]
  ```

### Parameter: `storages.kind`

Type of storage: "SMB" or "NFS".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `storages.shareName`

File share name.

- Required: Yes
- Type: string

### Parameter: `storages.storageAccountName`

Storage account name.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `zoneRedundant`

Whether or not this Managed Environment is zone-redundant.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultDomain` | string | The Default domain of the Managed Environment. |
| `domainVerificationId` | string | The domain verification id for custom domains. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Managed Environment. |
| `resourceGroupName` | string | The name of the resource group the Managed Environment was deployed into. |
| `resourceId` | string | The resource ID of the Managed Environment. |
| `staticIp` | string | The IP address of the Managed Environment. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
