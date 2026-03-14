# Azure Security Center (Defender for Cloud) `[Security/SecurityCenter]`

This module deploys an Azure Security Center (Defender for Cloud) Configuration.

You can reference the module as follows:
```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Security/deviceSecurityGroups` | 2019-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_devicesecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/deviceSecurityGroups)</li></ul> |
| `Microsoft.Security/iotSecuritySolutions` | 2019-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_iotsecuritysolutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2019-08-01/iotSecuritySolutions)</li></ul> |
| `Microsoft.Security/pricings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_pricings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2024-01-01/pricings)</li></ul> |
| `Microsoft.Security/securityContacts` | 2023-12-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.security_securitycontacts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Security/2023-12-01-preview/securityContacts)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/security/security-center:<version>`.

- [Using default parameter set](#example-1-using-default-parameter-set)
- [Using default parameter set](#example-2-using-default-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using default parameter set_

This instance deploys the module with default parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: {
    appServicesPricingTier: 'Standard'
    armPricingTier: 'Standard'
    containerRegistryPricingTier: 'Standard'
    containersTier: 'Standard'
    cosmosDbsTier: 'Standard'
    dnsPricingTier: 'Standard'
    keyVaultsPricingTier: 'Standard'
    kubernetesServicePricingTier: 'Standard'
    location: '<location>'
    openSourceRelationalDatabasesTier: 'Standard'
    sqlServersPricingTier: 'Standard'
    sqlServerVirtualMachinesPricingTier: 'Standard'
    storageAccountsMalwareScanningSettings: {
      capGBPerMonthPerStorageAccount: 5000
      onUploadMalwareScanningEnabled: 'True'
      sensitiveDataDiscoveryEnabled: 'True'
    }
    storageAccountsPricingTier: 'Standard'
    virtualMachinesPricingTier: 'Standard'
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
    "appServicesPricingTier": {
      "value": "Standard"
    },
    "armPricingTier": {
      "value": "Standard"
    },
    "containerRegistryPricingTier": {
      "value": "Standard"
    },
    "containersTier": {
      "value": "Standard"
    },
    "cosmosDbsTier": {
      "value": "Standard"
    },
    "dnsPricingTier": {
      "value": "Standard"
    },
    "keyVaultsPricingTier": {
      "value": "Standard"
    },
    "kubernetesServicePricingTier": {
      "value": "Standard"
    },
    "location": {
      "value": "<location>"
    },
    "openSourceRelationalDatabasesTier": {
      "value": "Standard"
    },
    "sqlServersPricingTier": {
      "value": "Standard"
    },
    "sqlServerVirtualMachinesPricingTier": {
      "value": "Standard"
    },
    "storageAccountsMalwareScanningSettings": {
      "value": {
        "capGBPerMonthPerStorageAccount": 5000,
        "onUploadMalwareScanningEnabled": "True",
        "sensitiveDataDiscoveryEnabled": "True"
      }
    },
    "storageAccountsPricingTier": {
      "value": "Standard"
    },
    "virtualMachinesPricingTier": {
      "value": "Standard"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/security/security-center:<version>'

param appServicesPricingTier = 'Standard'
param armPricingTier = 'Standard'
param containerRegistryPricingTier = 'Standard'
param containersTier = 'Standard'
param cosmosDbsTier = 'Standard'
param dnsPricingTier = 'Standard'
param keyVaultsPricingTier = 'Standard'
param kubernetesServicePricingTier = 'Standard'
param location = '<location>'
param openSourceRelationalDatabasesTier = 'Standard'
param sqlServersPricingTier = 'Standard'
param sqlServerVirtualMachinesPricingTier = 'Standard'
param storageAccountsMalwareScanningSettings = {
  capGBPerMonthPerStorageAccount: 5000
  onUploadMalwareScanningEnabled: 'True'
  sensitiveDataDiscoveryEnabled: 'True'
}
param storageAccountsPricingTier = 'Standard'
param virtualMachinesPricingTier = 'Standard'
```

</details>
<p>

### Example 2: _Using default parameter set_

This instance deploys the module with default parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: {
    appServicesPricingTier: 'Standard'
    armPricingTier: 'Standard'
    containerRegistryPricingTier: 'Standard'
    containersTier: 'Standard'
    cosmosDbsTier: 'Standard'
    deviceSecurityGroupProperties: {}
    dnsPricingTier: 'Standard'
    ioTSecuritySolutionProperties: {}
    keyVaultsPricingTier: 'Standard'
    kubernetesServicePricingTier: 'Standard'
    location: '<location>'
    openSourceRelationalDatabasesTier: 'Standard'
    securityContactProperties: {
      emails: 'foo@contoso.com'
      isEnabled: true
      notificationsByRole: {
        roles: [
          'owner'
        ]
        state: 'On'
      }
      notificationsSources: [
        {
          minimalSeverity: 'High'
          sourceType: 'Alert'
        }
        {
          minimalRiskLevel: 'High'
          sourceType: 'AttackPath'
        }
      ]
    }
    sqlServersPricingTier: 'Standard'
    sqlServerVirtualMachinesPricingTier: 'Standard'
    storageAccountsMalwareScanningSettings: {
      capGBPerMonthPerStorageAccount: 5000
      onUploadMalwareScanningEnabled: 'True'
      sensitiveDataDiscoveryEnabled: 'True'
    }
    storageAccountsPricingTier: 'Standard'
    virtualMachinesPricingTier: 'Standard'
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
    "appServicesPricingTier": {
      "value": "Standard"
    },
    "armPricingTier": {
      "value": "Standard"
    },
    "containerRegistryPricingTier": {
      "value": "Standard"
    },
    "containersTier": {
      "value": "Standard"
    },
    "cosmosDbsTier": {
      "value": "Standard"
    },
    "deviceSecurityGroupProperties": {
      "value": {}
    },
    "dnsPricingTier": {
      "value": "Standard"
    },
    "ioTSecuritySolutionProperties": {
      "value": {}
    },
    "keyVaultsPricingTier": {
      "value": "Standard"
    },
    "kubernetesServicePricingTier": {
      "value": "Standard"
    },
    "location": {
      "value": "<location>"
    },
    "openSourceRelationalDatabasesTier": {
      "value": "Standard"
    },
    "securityContactProperties": {
      "value": {
        "emails": "foo@contoso.com",
        "isEnabled": true,
        "notificationsByRole": {
          "roles": [
            "owner"
          ],
          "state": "On"
        },
        "notificationsSources": [
          {
            "minimalSeverity": "High",
            "sourceType": "Alert"
          },
          {
            "minimalRiskLevel": "High",
            "sourceType": "AttackPath"
          }
        ]
      }
    },
    "sqlServersPricingTier": {
      "value": "Standard"
    },
    "sqlServerVirtualMachinesPricingTier": {
      "value": "Standard"
    },
    "storageAccountsMalwareScanningSettings": {
      "value": {
        "capGBPerMonthPerStorageAccount": 5000,
        "onUploadMalwareScanningEnabled": "True",
        "sensitiveDataDiscoveryEnabled": "True"
      }
    },
    "storageAccountsPricingTier": {
      "value": "Standard"
    },
    "virtualMachinesPricingTier": {
      "value": "Standard"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/security/security-center:<version>'

param appServicesPricingTier = 'Standard'
param armPricingTier = 'Standard'
param containerRegistryPricingTier = 'Standard'
param containersTier = 'Standard'
param cosmosDbsTier = 'Standard'
param deviceSecurityGroupProperties = {}
param dnsPricingTier = 'Standard'
param ioTSecuritySolutionProperties = {}
param keyVaultsPricingTier = 'Standard'
param kubernetesServicePricingTier = 'Standard'
param location = '<location>'
param openSourceRelationalDatabasesTier = 'Standard'
param securityContactProperties = {
  emails: 'foo@contoso.com'
  isEnabled: true
  notificationsByRole: {
    roles: [
      'owner'
    ]
    state: 'On'
  }
  notificationsSources: [
    {
      minimalSeverity: 'High'
      sourceType: 'Alert'
    }
    {
      minimalRiskLevel: 'High'
      sourceType: 'AttackPath'
    }
  ]
}
param sqlServersPricingTier = 'Standard'
param sqlServerVirtualMachinesPricingTier = 'Standard'
param storageAccountsMalwareScanningSettings = {
  capGBPerMonthPerStorageAccount: 5000
  onUploadMalwareScanningEnabled: 'True'
  sensitiveDataDiscoveryEnabled: 'True'
}
param storageAccountsPricingTier = 'Standard'
param virtualMachinesPricingTier = 'Standard'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module securityCenter 'br/public:avm/ptn/security/security-center:<version>' = {
  params: {
    appServicesPricingTier: 'Standard'
    armPricingTier: 'Standard'
    containerRegistryPricingTier: 'Standard'
    containersTier: 'Standard'
    cosmosDbsTier: 'Standard'
    dnsPricingTier: 'Standard'
    keyVaultsPricingTier: 'Standard'
    kubernetesServicePricingTier: 'Standard'
    location: '<location>'
    openSourceRelationalDatabasesTier: 'Standard'
    sqlServersPricingTier: 'Standard'
    sqlServerVirtualMachinesPricingTier: 'Standard'
    storageAccountsMalwareScanningSettings: {
      capGBPerMonthPerStorageAccount: 5000
      onUploadMalwareScanningEnabled: 'True'
      sensitiveDataDiscoveryEnabled: 'True'
    }
    storageAccountsPricingTier: 'Standard'
    virtualMachinesPricingTier: 'Standard'
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
    "appServicesPricingTier": {
      "value": "Standard"
    },
    "armPricingTier": {
      "value": "Standard"
    },
    "containerRegistryPricingTier": {
      "value": "Standard"
    },
    "containersTier": {
      "value": "Standard"
    },
    "cosmosDbsTier": {
      "value": "Standard"
    },
    "dnsPricingTier": {
      "value": "Standard"
    },
    "keyVaultsPricingTier": {
      "value": "Standard"
    },
    "kubernetesServicePricingTier": {
      "value": "Standard"
    },
    "location": {
      "value": "<location>"
    },
    "openSourceRelationalDatabasesTier": {
      "value": "Standard"
    },
    "sqlServersPricingTier": {
      "value": "Standard"
    },
    "sqlServerVirtualMachinesPricingTier": {
      "value": "Standard"
    },
    "storageAccountsMalwareScanningSettings": {
      "value": {
        "capGBPerMonthPerStorageAccount": 5000,
        "onUploadMalwareScanningEnabled": "True",
        "sensitiveDataDiscoveryEnabled": "True"
      }
    },
    "storageAccountsPricingTier": {
      "value": "Standard"
    },
    "virtualMachinesPricingTier": {
      "value": "Standard"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/security/security-center:<version>'

param appServicesPricingTier = 'Standard'
param armPricingTier = 'Standard'
param containerRegistryPricingTier = 'Standard'
param containersTier = 'Standard'
param cosmosDbsTier = 'Standard'
param dnsPricingTier = 'Standard'
param keyVaultsPricingTier = 'Standard'
param kubernetesServicePricingTier = 'Standard'
param location = '<location>'
param openSourceRelationalDatabasesTier = 'Standard'
param sqlServersPricingTier = 'Standard'
param sqlServerVirtualMachinesPricingTier = 'Standard'
param storageAccountsMalwareScanningSettings = {
  capGBPerMonthPerStorageAccount: 5000
  onUploadMalwareScanningEnabled: 'True'
  sensitiveDataDiscoveryEnabled: 'True'
}
param storageAccountsPricingTier = 'Standard'
param virtualMachinesPricingTier = 'Standard'
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appServicesPricingTier`](#parameter-appservicespricingtier) | string | The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`armPricingTier`](#parameter-armpricingtier) | string | The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`containerRegistryPricingTier`](#parameter-containerregistrypricingtier) | string | The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`containersTier`](#parameter-containerstier) | string | The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`cosmosDbsTier`](#parameter-cosmosdbstier) | string | The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`deviceSecurityGroupProperties`](#parameter-devicesecuritygroupproperties) | object | Device Security group data. |
| [`dnsPricingTier`](#parameter-dnspricingtier) | string | The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ioTSecuritySolutionProperties`](#parameter-iotsecuritysolutionproperties) | object | Security Solution data. |
| [`keyVaultsPricingTier`](#parameter-keyvaultspricingtier) | string | The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`kubernetesServicePricingTier`](#parameter-kubernetesservicepricingtier) | string | The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`openSourceRelationalDatabasesTier`](#parameter-opensourcerelationaldatabasestier) | string | The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`securityContactProperties`](#parameter-securitycontactproperties) | object | Security contact data. |
| [`sqlServersPricingTier`](#parameter-sqlserverspricingtier) | string | The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`sqlServerVirtualMachinesPricingTier`](#parameter-sqlservervirtualmachinespricingtier) | string | The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`storageAccountsMalwareScanningSettings`](#parameter-storageaccountsmalwarescanningsettings) | object | If the pricing tier value for StorageAccounts is Standard. Choose the settings for malware scanning. |
| [`storageAccountsPricingTier`](#parameter-storageaccountspricingtier) | string | The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |
| [`virtualMachinesPricingTier`](#parameter-virtualmachinespricingtier) | string | The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard. |

### Parameter: `appServicesPricingTier`

The pricing tier value for AppServices. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `armPricingTier`

The pricing tier value for ARM. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `containerRegistryPricingTier`

The pricing tier value for ContainerRegistry. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `containersTier`

The pricing tier value for containers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `cosmosDbsTier`

The pricing tier value for CosmosDbs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `deviceSecurityGroupProperties`

Device Security group data.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `dnsPricingTier`

The pricing tier value for DNS. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ioTSecuritySolutionProperties`

Security Solution data.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `keyVaultsPricingTier`

The pricing tier value for KeyVaults. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `kubernetesServicePricingTier`

The pricing tier value for KubernetesService. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `openSourceRelationalDatabasesTier`

The pricing tier value for OpenSourceRelationalDatabases. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `securityContactProperties`

Security contact data.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `sqlServersPricingTier`

The pricing tier value for SqlServers. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `sqlServerVirtualMachinesPricingTier`

The pricing tier value for SqlServerVirtualMachines. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `storageAccountsMalwareScanningSettings`

If the pricing tier value for StorageAccounts is Standard. Choose the settings for malware scanning.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`onUploadMalwareScanningEnabled`](#parameter-storageaccountsmalwarescanningsettingsonuploadmalwarescanningenabled) | string | Enable or disable on-upload malware scanning for storage accounts. - True or False. |
| [`sensitiveDataDiscoveryEnabled`](#parameter-storageaccountsmalwarescanningsettingssensitivedatadiscoveryenabled) | string | Enable or disable sensitive data discovery for storage accounts. - True or False. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capGBPerMonthPerStorageAccount`](#parameter-storageaccountsmalwarescanningsettingscapgbpermonthperstorageaccount) | int | If on-upload malware scanning is enabled, set a cap for the amount of GB per month per storage account that can be scanned. If not set, there will be no cap applied. |

### Parameter: `storageAccountsMalwareScanningSettings.onUploadMalwareScanningEnabled`

Enable or disable on-upload malware scanning for storage accounts. - True or False.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'False'
    'True'
  ]
  ```

### Parameter: `storageAccountsMalwareScanningSettings.sensitiveDataDiscoveryEnabled`

Enable or disable sensitive data discovery for storage accounts. - True or False.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'False'
    'True'
  ]
  ```

### Parameter: `storageAccountsMalwareScanningSettings.capGBPerMonthPerStorageAccount`

If on-upload malware scanning is enabled, set a cap for the amount of GB per month per storage account that can be scanned. If not set, there will be no cap applied.

- Required: No
- Type: int

### Parameter: `storageAccountsPricingTier`

The pricing tier value for StorageAccounts. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

### Parameter: `virtualMachinesPricingTier`

The pricing tier value for VMs. Azure Security Center is provided in two pricing tiers: free and standard, with the standard tier available with a trial period. The standard tier offers advanced security capabilities, while the free tier offers basic security features. - Free or Standard.

- Required: No
- Type: string
- Default: `'Free'`
- Allowed:
  ```Bicep
  [
    'Free'
    'Standard'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the security center. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
