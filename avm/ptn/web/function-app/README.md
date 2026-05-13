# Function App Pattern `[Web/FunctionApp]`

Deploys an Azure Function App together with its supporting resources: an App Service Plan, a Storage Account for the Function runtime, and an Application Insights component (with an optional Log Analytics workspace). When `enableWafAlignment` is set to `true`, the module additionally provisions a Key Vault, a Virtual Network and Private Endpoints for the Function App, Storage Account and Key Vault, configures VNet integration, system-assigned managed identity and HTTPS-only / TLS 1.2 enforcement.

You can reference the module as follows:
```bicep
module functionApp 'br/public:avm/ptn/web/function-app:<version>' = {
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
| `Microsoft.Insights/components` | 2020-02-02 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-02-02/components)</li></ul> |
| `microsoft.insights/components/linkedStorageAccounts` | 2020-03-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_components_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2020-03-01-preview/components/linkedStorageAccounts)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults)</li></ul> |
| `Microsoft.KeyVault/vaults/accessPolicies` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_accesspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/accessPolicies)</li></ul> |
| `Microsoft.KeyVault/vaults/keys` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_keys.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.OperationalInsights/workspaces` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataExports` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_dataexports.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/dataExports)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/dataSources` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_datasources.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/dataSources)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedServices` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/linkedServices)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/linkedStorageAccounts` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_linkedstorageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/linkedStorageAccounts)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/savedSearches` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_savedsearches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/savedSearches)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/storageInsightConfigs` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_storageinsightconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/storageInsightConfigs)</li></ul> |
| `Microsoft.OperationalInsights/workspaces/tables` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationalinsights_workspaces_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2025-07-01/workspaces/tables)</li></ul> |
| `Microsoft.OperationsManagement/solutions` | 2015-11-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.operationsmanagement_solutions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationsManagement/2015-11-01-preview/solutions)</li></ul> |
| `Microsoft.SecurityInsights/onboardingStates` | 2025-09-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.securityinsights_onboardingstates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.SecurityInsights/2025-09-01/onboardingStates)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/objectReplicationPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_objectreplicationpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/objectReplicationPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/tableServices/tables)</li></ul> |
| `Microsoft.Web/certificates` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/certificates)</li></ul> |
| `Microsoft.Web/serverfarms` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_serverfarms.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/serverfarms)</li></ul> |
| `Microsoft.Web/sites` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites)</li></ul> |
| `Microsoft.Web/sites/basicPublishingCredentialsPolicies` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_basicpublishingcredentialspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/basicPublishingCredentialsPolicies)</li></ul> |
| `Microsoft.Web/sites/config` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/config)</li></ul> |
| `Microsoft.Web/sites/extensions` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/extensions)</li></ul> |
| `Microsoft.Web/sites/hostNameBindings` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_hostnamebindings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/sites/hostNameBindings)</li></ul> |
| `Microsoft.Web/sites/hybridConnectionNamespaces/relays` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_hybridconnectionnamespaces_relays.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/hybridConnectionNamespaces/relays)</li></ul> |
| `Microsoft.Web/sites/slots` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots)</li></ul> |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_basicpublishingcredentialspolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/basicPublishingCredentialsPolicies)</li></ul> |
| `Microsoft.Web/sites/slots/config` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_config.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/config)</li></ul> |
| `Microsoft.Web/sites/slots/extensions` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/extensions)</li></ul> |
| `Microsoft.Web/sites/slots/hostNameBindings` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_hostnamebindings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/sites/slots/hostNameBindings)</li></ul> |
| `Microsoft.Web/sites/slots/hybridConnectionNamespaces/relays` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_slots_hybridconnectionnamespaces_relays.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/slots/hybridConnectionNamespaces/relays)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/web/function-app:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module functionApp 'br/public:avm/ptn/web/function-app:<version>' = {
  params: {
    // Required parameters
    functionAppName: 'wfamin001'
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
    "functionAppName": {
      "value": "wfamin001"
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
using 'br/public:avm/ptn/web/function-app:<version>'

// Required parameters
param functionAppName = 'wfamin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module with the WAF-aligned baseline enabled (Key Vault, VNet integration, Private Endpoints, managed identity, HTTPS-only and TLS 1.2 enforcement).

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module functionApp 'br/public:avm/ptn/web/function-app:<version>' = {
  params: {
    // Required parameters
    functionAppName: 'wfawaf001'
    // Non-required parameters
    appServicePlanSkuCapacity: 1
    appServicePlanSkuName: 'EP1'
    enableWafAlignment: true
    functionAppKind: 'functionapp,linux'
    functionAppSubnetResourceId: '<functionAppSubnetResourceId>'
    functionAppTags: {
      'azd-service-name': 'api'
    }
    functionWorkerRuntime: 'dotnet-isolated'
    location: '<location>'
    privateEndpointSubnetResourceId: '<privateEndpointSubnetResourceId>'
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
    "functionAppName": {
      "value": "wfawaf001"
    },
    // Non-required parameters
    "appServicePlanSkuCapacity": {
      "value": 1
    },
    "appServicePlanSkuName": {
      "value": "EP1"
    },
    "enableWafAlignment": {
      "value": true
    },
    "functionAppKind": {
      "value": "functionapp,linux"
    },
    "functionAppSubnetResourceId": {
      "value": "<functionAppSubnetResourceId>"
    },
    "functionAppTags": {
      "value": {
        "azd-service-name": "api"
      }
    },
    "functionWorkerRuntime": {
      "value": "dotnet-isolated"
    },
    "location": {
      "value": "<location>"
    },
    "privateEndpointSubnetResourceId": {
      "value": "<privateEndpointSubnetResourceId>"
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
using 'br/public:avm/ptn/web/function-app:<version>'

// Required parameters
param functionAppName = 'wfawaf001'
// Non-required parameters
param appServicePlanSkuCapacity = 1
param appServicePlanSkuName = 'EP1'
param enableWafAlignment = true
param functionAppKind = 'functionapp,linux'
param functionAppSubnetResourceId = '<functionAppSubnetResourceId>'
param functionAppTags = {
  'azd-service-name': 'api'
}
param functionWorkerRuntime = 'dotnet-isolated'
param location = '<location>'
param privateEndpointSubnetResourceId = '<privateEndpointSubnetResourceId>'
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
| [`functionAppName`](#parameter-functionappname) | string | The name of the Function App. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationInsightsName`](#parameter-applicationinsightsname) | string | The name of the Application Insights component. Defaults to `<functionAppName>-ai`. |
| [`appServicePlanName`](#parameter-appserviceplanname) | string | The name of the App Service Plan to create. Defaults to `<functionAppName>-asp`. |
| [`appServicePlanSkuCapacity`](#parameter-appserviceplanskucapacity) | int | Number of workers for the App Service Plan. |
| [`appServicePlanSkuName`](#parameter-appserviceplanskuname) | string | The SKU of the App Service Plan that hosts the Function App. Defaults to `Y1` (Consumption). For WAF-aligned deployments consider `EP1` or higher to support VNet integration and zone redundancy. |
| [`appSettingsKeyValuePairs`](#parameter-appsettingskeyvaluepairs) | object | Application settings (`name`/`value` pairs) to merge into the Function App configuration. These are merged on top of the AVM defaults set by this module and override any keys with the same name. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enableWafAlignment`](#parameter-enablewafalignment) | bool | When `true`, applies the AVM WAF-aligned baseline: Key Vault, Virtual Network with subnets for integration and private endpoints, system-assigned managed identity on the Function App, HTTPS-only and TLS 1.2 enforcement, public network access disabled on the Storage Account and Private Endpoints for the Function App, Storage Account and Key Vault. |
| [`functionAppKind`](#parameter-functionappkind) | string | The kind of Function App to deploy. |
| [`functionAppSubnetResourceId`](#parameter-functionappsubnetresourceid) | string | The resource ID of the subnet to use for Function App regional VNet integration. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided. |
| [`functionAppTags`](#parameter-functionapptags) | object | Additional tags to apply only to the Function App resource (merged on top of `tags`). Typically used to surface the AZD service mapping via the `azd-service-name` tag. |
| [`functionWorkerRuntime`](#parameter-functionworkerruntime) | string | The runtime stack of the Function App, e.g. `dotnet-isolated`, `node`, `python`, `java`, `powershell`. |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the Key Vault created when `enableWafAlignment` is `true`. Defaults to `<functionAppName>-kv` (truncated to 24 chars). |
| [`location`](#parameter-location) | string | The Azure region into which all resources will be deployed. |
| [`logAnalyticsWorkspaceName`](#parameter-loganalyticsworkspacename) | string | The name of an existing Log Analytics workspace to associate with Application Insights. If left empty and `enableWafAlignment` is `true`, a new workspace named `<functionAppName>-law` is created. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | Resource ID of an existing Log Analytics workspace to associate with Application Insights. When provided, takes precedence over `logAnalyticsWorkspaceName` and no workspace is created. |
| [`privateEndpointSubnetResourceId`](#parameter-privateendpointsubnetresourceid) | string | The resource ID of the subnet to use for Private Endpoints. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided. |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the Storage Account that backs the Function App runtime. Must be globally unique, 3-24 lowercase alphanumeric characters. Defaults to a deterministic name derived from `functionAppName`. |
| [`tags`](#parameter-tags) | object | Resource tags to apply to all created resources. |

### Parameter: `functionAppName`

The name of the Function App.

- Required: Yes
- Type: string

### Parameter: `applicationInsightsName`

The name of the Application Insights component. Defaults to `<functionAppName>-ai`.

- Required: No
- Type: string
- Default: `[format('{0}-ai', parameters('functionAppName'))]`

### Parameter: `appServicePlanName`

The name of the App Service Plan to create. Defaults to `<functionAppName>-asp`.

- Required: No
- Type: string
- Default: `[format('{0}-asp', parameters('functionAppName'))]`

### Parameter: `appServicePlanSkuCapacity`

Number of workers for the App Service Plan.

- Required: No
- Type: int
- Default: `1`
- MinValue: 1

### Parameter: `appServicePlanSkuName`

The SKU of the App Service Plan that hosts the Function App. Defaults to `Y1` (Consumption). For WAF-aligned deployments consider `EP1` or higher to support VNet integration and zone redundancy.

- Required: No
- Type: string
- Default: `'Y1'`

### Parameter: `appSettingsKeyValuePairs`

Application settings (`name`/`value` pairs) to merge into the Function App configuration. These are merged on top of the AVM defaults set by this module and override any keys with the same name.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableWafAlignment`

When `true`, applies the AVM WAF-aligned baseline: Key Vault, Virtual Network with subnets for integration and private endpoints, system-assigned managed identity on the Function App, HTTPS-only and TLS 1.2 enforcement, public network access disabled on the Storage Account and Private Endpoints for the Function App, Storage Account and Key Vault.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `functionAppKind`

The kind of Function App to deploy.

- Required: No
- Type: string
- Default: `'functionapp,linux'`
- Allowed:
  ```Bicep
  [
    'functionapp'
    'functionapp,linux'
  ]
  ```

### Parameter: `functionAppSubnetResourceId`

The resource ID of the subnet to use for Function App regional VNet integration. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided.

- Required: No
- Type: string
- Default: `''`

### Parameter: `functionAppTags`

Additional tags to apply only to the Function App resource (merged on top of `tags`). Typically used to surface the AZD service mapping via the `azd-service-name` tag.

- Required: No
- Type: object

### Parameter: `functionWorkerRuntime`

The runtime stack of the Function App, e.g. `dotnet-isolated`, `node`, `python`, `java`, `powershell`.

- Required: No
- Type: string
- Default: `'dotnet-isolated'`
- Allowed:
  ```Bicep
  [
    'dotnet'
    'dotnet-isolated'
    'java'
    'node'
    'powershell'
    'python'
  ]
  ```

### Parameter: `keyVaultName`

The name of the Key Vault created when `enableWafAlignment` is `true`. Defaults to `<functionAppName>-kv` (truncated to 24 chars).

- Required: No
- Type: string
- Default: `[take(format('{0}-kv', parameters('functionAppName')), 24)]`

### Parameter: `location`

The Azure region into which all resources will be deployed.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsWorkspaceName`

The name of an existing Log Analytics workspace to associate with Application Insights. If left empty and `enableWafAlignment` is `true`, a new workspace named `<functionAppName>-law` is created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `logAnalyticsWorkspaceResourceId`

Resource ID of an existing Log Analytics workspace to associate with Application Insights. When provided, takes precedence over `logAnalyticsWorkspaceName` and no workspace is created.

- Required: No
- Type: string
- Default: `''`

### Parameter: `privateEndpointSubnetResourceId`

The resource ID of the subnet to use for Private Endpoints. Required when `enableWafAlignment` is `true` and `virtualNetworkResourceId` is not provided.

- Required: No
- Type: string
- Default: `''`

### Parameter: `storageAccountName`

The name of the Storage Account that backs the Function App runtime. Must be globally unique, 3-24 lowercase alphanumeric characters. Defaults to a deterministic name derived from `functionAppName`.

- Required: No
- Type: string
- Default: `[take(toLower(replace(format('{0}sa{1}', parameters('functionAppName'), uniqueString(resourceGroup().id, parameters('functionAppName'))), '-', '')), 24)]`

### Parameter: `tags`

Resource tags to apply to all created resources.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationInsightsConnectionString` | string | The connection string of the Application Insights component. |
| `applicationInsightsName` | string | The name of the Application Insights component. |
| `applicationInsightsResourceId` | string | The resource ID of the Application Insights component. |
| `appServicePlanName` | string | The name of the App Service Plan. |
| `appServicePlanResourceId` | string | The resource ID of the App Service Plan. |
| `functionAppDefaultHostname` | string | The default hostname of the deployed Function App. |
| `functionAppName` | string | The name of the deployed Function App. |
| `functionAppResourceId` | string | The resource ID of the deployed Function App. |
| `functionAppSystemAssignedMIPrincipalId` | string | The principal ID of the system-assigned managed identity on the Function App, if enabled. |
| `keyVaultName` | string | The name of the Key Vault created when `enableWafAlignment` is `true`. |
| `keyVaultResourceId` | string | The resource ID of the Key Vault created when `enableWafAlignment` is `true`. |
| `location` | string | The location the resources were deployed into. |
| `logAnalyticsWorkspaceResourceId` | string | The resource ID of the Log Analytics workspace created or referenced by this module, if any. |
| `resourceGroupName` | string | The name of the resource group the resources were deployed into. |
| `storageAccountName` | string | The name of the Storage Account that backs the Function App runtime. |
| `storageAccountResourceId` | string | The resource ID of the Storage Account that backs the Function App runtime. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/insights/component:0.7.1` | Remote reference |
| `br/public:avm/res/key-vault/vault:0.13.3` | Remote reference |
| `br/public:avm/res/operational-insights/workspace:0.15.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.32.0` | Remote reference |
| `br/public:avm/res/web/serverfarm:0.7.0` | Remote reference |
| `br/public:avm/res/web/site:0.23.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
