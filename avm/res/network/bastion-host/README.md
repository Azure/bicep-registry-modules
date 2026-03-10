# Bastion Hosts `[Microsoft.Network/bastionHosts]`

This module deploys a Bastion Host.

You can reference the module as follows:
```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/bastionHosts)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/bastion-host:<version>`.

- [With a custom public IP address deployed by the module](#example-1-with-a-custom-public-ip-address-deployed-by-the-module)
- [Using only defaults](#example-2-using-only-defaults)
- [Using Developer SKU](#example-3-using-developer-sku)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [Private-only deployment](#example-5-private-only-deployment)
- [WAF-aligned](#example-6-waf-aligned)

### Example 1: _With a custom public IP address deployed by the module_

This instance does not require a pre-deployed public IP but includes its deployment as part of the Bastion module deployment.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/custompip]


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: {
    // Required parameters
    name: 'nbhctmpip001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    location: '<location>'
    publicIPAddressObject: {
      diagnosticSettings: [
        {
          eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
          eventHubName: '<eventHubName>'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          name: 'customSetting'
          storageAccountResourceId: '<storageAccountResourceId>'
          workspaceResourceId: '<workspaceResourceId>'
        }
      ]
      name: 'nbhctmpip001-pip'
      publicIPAllocationMethod: 'Static'
      publicIpPrefixResourceId: ''
      roleAssignments: [
        {
          principalId: '<principalId>'
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
      skuName: 'Standard'
      skuTier: 'Regional'
      tags: {
        Environment: 'Non-Prod'
        'hidden-title': 'This is visible in the resource name'
        Role: 'DeploymentValidation'
      }
    }
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
      "value": "nbhctmpip001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "publicIPAddressObject": {
      "value": {
        "diagnosticSettings": [
          {
            "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
            "eventHubName": "<eventHubName>",
            "metricCategories": [
              {
                "category": "AllMetrics"
              }
            ],
            "name": "customSetting",
            "storageAccountResourceId": "<storageAccountResourceId>",
            "workspaceResourceId": "<workspaceResourceId>"
          }
        ],
        "name": "nbhctmpip001-pip",
        "publicIPAllocationMethod": "Static",
        "publicIpPrefixResourceId": "",
        "roleAssignments": [
          {
            "principalId": "<principalId>",
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ],
        "skuName": "Standard",
        "skuTier": "Regional",
        "tags": {
          "Environment": "Non-Prod",
          "hidden-title": "This is visible in the resource name",
          "Role": "DeploymentValidation"
        }
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/bastion-host:<version>'

// Required parameters
param name = 'nbhctmpip001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param location = '<location>'
param publicIPAddressObject = {
  diagnosticSettings: [
    {
      eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
      eventHubName: '<eventHubName>'
      metricCategories: [
        {
          category: 'AllMetrics'
        }
      ]
      name: 'customSetting'
      storageAccountResourceId: '<storageAccountResourceId>'
      workspaceResourceId: '<workspaceResourceId>'
    }
  ]
  name: 'nbhctmpip001-pip'
  publicIPAllocationMethod: 'Static'
  publicIpPrefixResourceId: ''
  roleAssignments: [
    {
      principalId: '<principalId>'
      principalType: 'ServicePrincipal'
      roleDefinitionIdOrName: 'Reader'
    }
  ]
  skuName: 'Standard'
  skuTier: 'Regional'
  tags: {
    Environment: 'Non-Prod'
    'hidden-title': 'This is visible in the resource name'
    Role: 'DeploymentValidation'
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: {
    // Required parameters
    name: 'nbhmin001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    location: '<location>'
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
      "value": "nbhmin001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/bastion-host:<version>'

// Required parameters
param name = 'nbhmin001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 3: _Using Developer SKU_

This instance deploys the module with the Developer SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/developer]


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: {
    // Required parameters
    name: 'nbhdev001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    location: '<location>'
    skuName: 'Developer'
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
      "value": "nbhdev001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "Developer"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/bastion-host:<version>'

// Required parameters
param name = 'nbhdev001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param location = '<location>'
param skuName = 'Developer'
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: {
    // Required parameters
    name: 'nbhmax001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    availabilityZones: [
      1
      2
      3
    ]
    bastionSubnetPublicIpResourceId: '<bastionSubnetPublicIpResourceId>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableCopyPaste: true
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: 'a9329bd8-d7c8-4915-9dfe-04197fa5bf45'
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
    scaleUnits: 4
    skuName: 'Standard'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nbhmax001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "availabilityZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "bastionSubnetPublicIpResourceId": {
      "value": "<bastionSubnetPublicIpResourceId>"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableCopyPaste": {
      "value": true
    },
    "enableFileCopy": {
      "value": false
    },
    "enableIpConnect": {
      "value": false
    },
    "enableShareableLink": {
      "value": false
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
    "roleAssignments": {
      "value": [
        {
          "name": "a9329bd8-d7c8-4915-9dfe-04197fa5bf45",
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
    "scaleUnits": {
      "value": 4
    },
    "skuName": {
      "value": "Standard"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/bastion-host:<version>'

// Required parameters
param name = 'nbhmax001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param availabilityZones = [
  1
  2
  3
]
param bastionSubnetPublicIpResourceId = '<bastionSubnetPublicIpResourceId>'
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableCopyPaste = true
param enableFileCopy = false
param enableIpConnect = false
param enableShareableLink = false
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param roleAssignments = [
  {
    name: 'a9329bd8-d7c8-4915-9dfe-04197fa5bf45'
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
param scaleUnits = 4
param skuName = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 5: _Private-only deployment_

This instance deploys the module as private-only Bastion deployment.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/private]


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: {
    // Required parameters
    name: 'nbhprv001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    enablePrivateOnlyBastion: true
    enableSessionRecording: true
    location: '<location>'
    skuName: 'Premium'
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
      "value": "nbhprv001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "enablePrivateOnlyBastion": {
      "value": true
    },
    "enableSessionRecording": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "skuName": {
      "value": "Premium"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/bastion-host:<version>'

// Required parameters
param name = 'nbhprv001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param enablePrivateOnlyBastion = true
param enableSessionRecording = true
param location = '<location>'
param skuName = 'Premium'
```

</details>
<p>

### Example 6: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module bastionHost 'br/public:avm/res/network/bastion-host:<version>' = {
  params: {
    // Required parameters
    name: 'nbhwaf001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    bastionSubnetPublicIpResourceId: '<bastionSubnetPublicIpResourceId>'
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableCopyPaste: true
    enableFileCopy: false
    enableIpConnect: false
    enableShareableLink: false
    location: '<location>'
    scaleUnits: 4
    skuName: 'Standard'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nbhwaf001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "bastionSubnetPublicIpResourceId": {
      "value": "<bastionSubnetPublicIpResourceId>"
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableCopyPaste": {
      "value": true
    },
    "enableFileCopy": {
      "value": false
    },
    "enableIpConnect": {
      "value": false
    },
    "enableShareableLink": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "scaleUnits": {
      "value": 4
    },
    "skuName": {
      "value": "Standard"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/bastion-host:<version>'

// Required parameters
param name = 'nbhwaf001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param bastionSubnetPublicIpResourceId = '<bastionSubnetPublicIpResourceId>'
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableCopyPaste = true
param enableFileCopy = false
param enableIpConnect = false
param enableShareableLink = false
param location = '<location>'
param scaleUnits = 4
param skuName = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Azure Bastion resource. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Shared services Virtual Network resource Id. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-availabilityzones) | array | The list of Availability zones to use for the zone-redundant resources. |
| [`bastionSubnetPublicIpResourceId`](#parameter-bastionsubnetpublicipresourceid) | string | The Public IP resource ID to associate to the azureBastionSubnet. If empty, then the Public IP that is created as part of this module will be applied to the azureBastionSubnet. This parameter is ignored when enablePrivateOnlyBastion is true. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableCopyPaste`](#parameter-disablecopypaste) | bool | Choose to disable or enable Copy Paste. For Basic and Developer SKU Copy/Paste is always enabled. |
| [`enableFileCopy`](#parameter-enablefilecopy) | bool | Choose to disable or enable File Copy. Not supported for Basic and Developer SKU. |
| [`enableIpConnect`](#parameter-enableipconnect) | bool | Choose to disable or enable IP Connect. Not supported for Basic and Developer SKU. |
| [`enableKerberos`](#parameter-enablekerberos) | bool | Choose to disable or enable Kerberos authentication. Not supported for Developer SKU. |
| [`enablePrivateOnlyBastion`](#parameter-enableprivateonlybastion) | bool | Choose to disable or enable Private-only Bastion deployment. The Premium SKU is required for this feature. |
| [`enableSessionRecording`](#parameter-enablesessionrecording) | bool | Choose to disable or enable Session Recording feature. The Premium SKU is required for this feature. If Session Recording is enabled, the Native client support will be disabled. |
| [`enableShareableLink`](#parameter-enableshareablelink) | bool | Choose to disable or enable Shareable Link. Not supported for Basic and Developer SKU. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`publicIPAddressObject`](#parameter-publicipaddressobject) | object | Specifies the properties of the Public IP to create and be used by Azure Bastion, if no existing public IP was provided. This parameter is ignored when enablePrivateOnlyBastion is true. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scaleUnits`](#parameter-scaleunits) | int | The scale units for the Bastion Host resource. The Basic and Developer SKU only support 2 scale units. |
| [`skuName`](#parameter-skuname) | string | The SKU of this Bastion Host. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Azure Bastion resource.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkResourceId`

Shared services Virtual Network resource Id.

- Required: Yes
- Type: string

### Parameter: `availabilityZones`

The list of Availability zones to use for the zone-redundant resources.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `bastionSubnetPublicIpResourceId`

The Public IP resource ID to associate to the azureBastionSubnet. If empty, then the Public IP that is created as part of this module will be applied to the azureBastionSubnet. This parameter is ignored when enablePrivateOnlyBastion is true.

- Required: No
- Type: string
- Default: `''`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `disableCopyPaste`

Choose to disable or enable Copy Paste. For Basic and Developer SKU Copy/Paste is always enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableFileCopy`

Choose to disable or enable File Copy. Not supported for Basic and Developer SKU.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableIpConnect`

Choose to disable or enable IP Connect. Not supported for Basic and Developer SKU.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableKerberos`

Choose to disable or enable Kerberos authentication. Not supported for Developer SKU.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateOnlyBastion`

Choose to disable or enable Private-only Bastion deployment. The Premium SKU is required for this feature.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableSessionRecording`

Choose to disable or enable Session Recording feature. The Premium SKU is required for this feature. If Session Recording is enabled, the Native client support will be disabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableShareableLink`

Choose to disable or enable Shareable Link. Not supported for Basic and Developer SKU.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject`

Specifies the properties of the Public IP to create and be used by Azure Bastion, if no existing public IP was provided. This parameter is ignored when enablePrivateOnlyBastion is true.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: '[format(\'{0}-pip\', parameters(\'name\'))]'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-publicipaddressobjectname) | string | The name of the Public IP Address. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-publicipaddressobjectavailabilityzones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. |
| [`ddosSettings`](#parameter-publicipaddressobjectddossettings) | object | The DDoS protection plan configuration associated with the public IP address. |
| [`diagnosticSettings`](#parameter-publicipaddressobjectdiagnosticsettings) | array | Diagnostic settings for the Public IP resource. |
| [`dnsSettings`](#parameter-publicipaddressobjectdnssettings) | object | The DNS settings of the public IP address. |
| [`enableTelemetry`](#parameter-publicipaddressobjectenabletelemetry) | bool | Enable or disable usage telemetry for the Public IP module. |
| [`idleTimeoutInMinutes`](#parameter-publicipaddressobjectidletimeoutinminutes) | int | Idle timeout in minutes for the Public IP resource. |
| [`ipTags`](#parameter-publicipaddressobjectiptags) | array | The list of tags associated with the public IP address. |
| [`location`](#parameter-publicipaddressobjectlocation) | string | Location for the Public IP resource. |
| [`lock`](#parameter-publicipaddressobjectlock) | object | The lock settings of the service. |
| [`publicIPAddressVersion`](#parameter-publicipaddressobjectpublicipaddressversion) | string | IP address version. |
| [`publicIPAllocationMethod`](#parameter-publicipaddressobjectpublicipallocationmethod) | string | The public IP address allocation method. |
| [`publicIpPrefixResourceId`](#parameter-publicipaddressobjectpublicipprefixresourceid) | string | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`roleAssignments`](#parameter-publicipaddressobjectroleassignments) | array | Array of role assignments to create for the Public IP resource. |
| [`skuName`](#parameter-publicipaddressobjectskuname) | string | Name of a public IP address SKU. |
| [`skuTier`](#parameter-publicipaddressobjectskutier) | string | Tier of a public IP address SKU. |
| [`tags`](#parameter-publicipaddressobjecttags) | object | Tags to apply to the Public IP resource. |

### Parameter: `publicIPAddressObject.name`

The name of the Public IP Address.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.availabilityZones`

A list of availability zones denoting the IP allocated for the resource needs to come from.

- Required: No
- Type: array

### Parameter: `publicIPAddressObject.ddosSettings`

The DDoS protection plan configuration associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protectionMode`](#parameter-publicipaddressobjectddossettingsprotectionmode) | string | The DDoS protection policy customizations. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosProtectionPlan`](#parameter-publicipaddressobjectddossettingsddosprotectionplan) | object | The DDoS protection plan associated with the public IP address. |

### Parameter: `publicIPAddressObject.ddosSettings.protectionMode`

The DDoS protection policy customizations.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Enabled'
  ]
  ```

### Parameter: `publicIPAddressObject.ddosSettings.ddosProtectionPlan`

The DDoS protection plan associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-publicipaddressobjectddossettingsddosprotectionplanid) | string | The resource ID of the DDOS protection plan associated with the public IP address. |

### Parameter: `publicIPAddressObject.ddosSettings.ddosProtectionPlan.id`

The resource ID of the DDOS protection plan associated with the public IP address.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings`

Diagnostic settings for the Public IP resource.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-publicipaddressobjectdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-publicipaddressobjectdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-publicipaddressobjectdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-publicipaddressobjectdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-publicipaddressobjectdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-publicipaddressobjectdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-publicipaddressobjectdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-publicipaddressobjectdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-publicipaddressobjectdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `publicIPAddressObject.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `publicIPAddressObject.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-publicipaddressobjectdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-publicipaddressobjectdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-publicipaddressobjectdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `publicIPAddressObject.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `publicIPAddressObject.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-publicipaddressobjectdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-publicipaddressobjectdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `publicIPAddressObject.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `publicIPAddressObject.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.dnsSettings`

The DNS settings of the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabel`](#parameter-publicipaddressobjectdnssettingsdomainnamelabel) | string | The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabelScope`](#parameter-publicipaddressobjectdnssettingsdomainnamelabelscope) | string | The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN. |
| [`fqdn`](#parameter-publicipaddressobjectdnssettingsfqdn) | string | The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
| [`reverseFqdn`](#parameter-publicipaddressobjectdnssettingsreversefqdn) | string | The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. |

### Parameter: `publicIPAddressObject.dnsSettings.domainNameLabel`

The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.dnsSettings.domainNameLabelScope`

The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NoReuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
  ]
  ```

### Parameter: `publicIPAddressObject.dnsSettings.fqdn`

The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.dnsSettings.reverseFqdn`

The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.enableTelemetry`

Enable or disable usage telemetry for the Public IP module.

- Required: No
- Type: bool

### Parameter: `publicIPAddressObject.idleTimeoutInMinutes`

Idle timeout in minutes for the Public IP resource.

- Required: No
- Type: int

### Parameter: `publicIPAddressObject.ipTags`

The list of tags associated with the public IP address.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-publicipaddressobjectiptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-publicipaddressobjectiptagstag) | string | The IP tag. |

### Parameter: `publicIPAddressObject.ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.location`

Location for the Public IP resource.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-publicipaddressobjectlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-publicipaddressobjectlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-publicipaddressobjectlocknotes) | string | Specify the notes of the lock. |

### Parameter: `publicIPAddressObject.lock.kind`

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

### Parameter: `publicIPAddressObject.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.publicIPAddressVersion`

IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `publicIPAddressObject.publicIPAllocationMethod`

The public IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `publicIPAddressObject.publicIpPrefixResourceId`

Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments`

Array of role assignments to create for the Public IP resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-publicipaddressobjectroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-publicipaddressobjectroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-publicipaddressobjectroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-publicipaddressobjectroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-publicipaddressobjectroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-publicipaddressobjectroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-publicipaddressobjectroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-publicipaddressobjectroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `publicIPAddressObject.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `publicIPAddressObject.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `publicIPAddressObject.roleAssignments.principalType`

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

### Parameter: `publicIPAddressObject.skuName`

Name of a public IP address SKU.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `publicIPAddressObject.skuTier`

Tier of a public IP address SKU.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
  ]
  ```

### Parameter: `publicIPAddressObject.tags`

Tags to apply to the Public IP resource.

- Required: No
- Type: object

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

### Parameter: `scaleUnits`

The scale units for the Bastion Host resource. The Basic and Developer SKU only support 2 scale units.

- Required: No
- Type: int
- Default: `2`

### Parameter: `skuName`

The SKU of this Bastion Host.

- Required: No
- Type: string
- Default: `'Basic'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Developer'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `ipConfAzureBastionSubnet` | object | The Public IPconfiguration object for the AzureBastionSubnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name the Azure Bastion. |
| `resourceGroupName` | string | The resource group the Azure Bastion was deployed into. |
| `resourceId` | string | The resource ID the Azure Bastion. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/public-ip-address:0.10.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
