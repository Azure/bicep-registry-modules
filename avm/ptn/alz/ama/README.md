# avm/ptn/alz/ama `[Alz/Ama]`

This modules deployes resources for Azure Monitoring Agent (AMA) to be used within Azure Landing Zones

You can reference the module as follows:
```bicep
module ama 'br/public:avm/ptn/alz/ama:<version>' = {
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
| `Microsoft.Insights/dataCollectionRules` | 2021-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_datacollectionrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-04-01/dataCollectionRules)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/alz/ama:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using maximum parameters](#example-2-using-maximum-parameters)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module ama 'br/public:avm/ptn/alz/ama:<version>' = {
  params: {
    // Required parameters
    dataCollectionRuleChangeTrackingName: 'alz-ama-dcr-ct-alzamamin'
    dataCollectionRuleMDFCSQLName: 'alz-ama-dcr-mdfc-sql-alzamamin'
    dataCollectionRuleVMInsightsName: 'alz-ama-dcr-vm-insights-alzamamin'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    userAssignedIdentityName: 'alz-ama-identity-alzamamin'
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
    "dataCollectionRuleChangeTrackingName": {
      "value": "alz-ama-dcr-ct-alzamamin"
    },
    "dataCollectionRuleMDFCSQLName": {
      "value": "alz-ama-dcr-mdfc-sql-alzamamin"
    },
    "dataCollectionRuleVMInsightsName": {
      "value": "alz-ama-dcr-vm-insights-alzamamin"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "userAssignedIdentityName": {
      "value": "alz-ama-identity-alzamamin"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/alz/ama:<version>'

// Required parameters
param dataCollectionRuleChangeTrackingName = 'alz-ama-dcr-ct-alzamamin'
param dataCollectionRuleMDFCSQLName = 'alz-ama-dcr-mdfc-sql-alzamamin'
param dataCollectionRuleVMInsightsName = 'alz-ama-dcr-vm-insights-alzamamin'
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param userAssignedIdentityName = 'alz-ama-identity-alzamamin'
```

</details>
<p>

### Example 2: _Using maximum parameters_

This instance deploys the module with the maximum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module ama 'br/public:avm/ptn/alz/ama:<version>' = {
  params: {
    // Required parameters
    dataCollectionRuleChangeTrackingName: 'alz-ama-dcr-ct-alzamamax'
    dataCollectionRuleMDFCSQLName: 'alz-ama-dcr-mdfc-sql-alzamamax'
    dataCollectionRuleVMInsightsName: 'alz-ama-dcr-vm-insights-alzamamax'
    logAnalyticsWorkspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
    userAssignedIdentityName: 'alz-ama-identity-alzamamax'
    // Non-required parameters
    location: '<location>'
    lockConfig: {
      kind: 'CanNotDelete'
      name: 'lock-alzamamax'
    }
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
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
    "dataCollectionRuleChangeTrackingName": {
      "value": "alz-ama-dcr-ct-alzamamax"
    },
    "dataCollectionRuleMDFCSQLName": {
      "value": "alz-ama-dcr-mdfc-sql-alzamamax"
    },
    "dataCollectionRuleVMInsightsName": {
      "value": "alz-ama-dcr-vm-insights-alzamamax"
    },
    "logAnalyticsWorkspaceResourceId": {
      "value": "<logAnalyticsWorkspaceResourceId>"
    },
    "userAssignedIdentityName": {
      "value": "alz-ama-identity-alzamamax"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "lockConfig": {
      "value": {
        "kind": "CanNotDelete",
        "name": "lock-alzamamax"
      }
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
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
using 'br/public:avm/ptn/alz/ama:<version>'

// Required parameters
param dataCollectionRuleChangeTrackingName = 'alz-ama-dcr-ct-alzamamax'
param dataCollectionRuleMDFCSQLName = 'alz-ama-dcr-mdfc-sql-alzamamax'
param dataCollectionRuleVMInsightsName = 'alz-ama-dcr-vm-insights-alzamamax'
param logAnalyticsWorkspaceResourceId = '<logAnalyticsWorkspaceResourceId>'
param userAssignedIdentityName = 'alz-ama-identity-alzamamax'
// Non-required parameters
param location = '<location>'
param lockConfig = {
  kind: 'CanNotDelete'
  name: 'lock-alzamamax'
}
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionRuleChangeTrackingName`](#parameter-datacollectionrulechangetrackingname) | string | The name of the data collection rule for Change Tracking. |
| [`dataCollectionRuleMDFCSQLName`](#parameter-datacollectionrulemdfcsqlname) | string | The name of the data collection rule for Microsoft Defender for SQL. |
| [`dataCollectionRuleVMInsightsName`](#parameter-datacollectionrulevminsightsname) | string | The name of the data collection rule for VM Insights. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The resource ID of the Log Analytics Workspace. |
| [`userAssignedIdentityName`](#parameter-userassignedidentityname) | string | The name of the User Assigned Identity utilized for Azure Monitoring Agent. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dataCollectionRuleVMInsightsExperience`](#parameter-datacollectionrulevminsightsexperience) | string | The experience for the VM Insights data collection rule. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location to deploy resources to. |
| [`lockConfig`](#parameter-lockconfig) | object | The lock settings for all resources in the solution. |
| [`tags`](#parameter-tags) | object | Tags for all Resources in the solution. |

### Parameter: `dataCollectionRuleChangeTrackingName`

The name of the data collection rule for Change Tracking.

- Required: Yes
- Type: string

### Parameter: `dataCollectionRuleMDFCSQLName`

The name of the data collection rule for Microsoft Defender for SQL.

- Required: Yes
- Type: string

### Parameter: `dataCollectionRuleVMInsightsName`

The name of the data collection rule for VM Insights.

- Required: Yes
- Type: string

### Parameter: `logAnalyticsWorkspaceResourceId`

The resource ID of the Log Analytics Workspace.

- Required: Yes
- Type: string

### Parameter: `userAssignedIdentityName`

The name of the User Assigned Identity utilized for Azure Monitoring Agent.

- Required: Yes
- Type: string

### Parameter: `dataCollectionRuleVMInsightsExperience`

The experience for the VM Insights data collection rule.

- Required: No
- Type: string
- Default: `'PerfAndMap'`
- Allowed:
  ```Bicep
  [
    'PerfAndMap'
    'PerfOnly'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location to deploy resources to.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lockConfig`

The lock settings for all resources in the solution.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockconfigkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockconfigname) | string | Specify the name of lock. |

### Parameter: `lockConfig.kind`

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

### Parameter: `lockConfig.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `tags`

Tags for all Resources in the solution.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `dataCollectionRuleChangeTrackingResourceId` | string | The resource ID of the Data Collection Rule for Change Tracking. |
| `dataCollectionRuleMDFCSQLResourceId` | string | The resource ID of the Data Collection Rule for Microsoft Defender for SQL. |
| `dataCollectionRuleVMInsightsResourceId` | string | The resource ID of the Data Collection Rule for VM Insights. |
| `resourceGroupName` | string | The resource group the deployment script was deployed into. |
| `userAssignedManagedIdentityResourceId` | string | The resource ID of the User Assigned Managed Identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.3` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
