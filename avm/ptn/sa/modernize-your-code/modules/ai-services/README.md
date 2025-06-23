# AI Services and Project Module `[Sa/ModernizeYourCodeModulesAiServices]`

This module creates an AI Services resource and an AI Foundry project within it. It supports private networking, OpenAI deployments, and role assignments.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.CognitiveServices/accounts` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts) |
| `Microsoft.CognitiveServices/accounts/deployments` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/deployments) |
| `Microsoft.CognitiveServices/accounts/projects` | [2025-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2025-04-01-preview/accounts/projects) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.Network/privateDnsZones` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Cognitive Services resource. Must be unique in the resource group. |
| [`projectName`](#parameter-projectname) | string | The name of the AI Foundry project to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deployments`](#parameter-deployments) | array | Specifies the OpenAI deployments to create. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`kind`](#parameter-kind) | string | Kind of the Cognitive Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`location`](#parameter-location) | string | The location of the Cognitive Services resource. |
| [`logAnalyticsWorkspaceResourceId`](#parameter-loganalyticsworkspaceresourceid) | string | The resource ID of the Log Analytics workspace to use for diagnostic settings. |
| [`privateNetworking`](#parameter-privatenetworking) | object | Values to establish private networking for the AI Services resource. |
| [`projectDescription`](#parameter-projectdescription) | string | The description of the AI Foundry project to create. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sku`](#parameter-sku) | string | The SKU of the Cognitive Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region. |
| [`tags`](#parameter-tags) | object | Tags to be applied to the resources. |

### Parameter: `name`

Name of the Cognitive Services resource. Must be unique in the resource group.

- Required: Yes
- Type: string

### Parameter: `projectName`

The name of the AI Foundry project to create.

- Required: Yes
- Type: string

### Parameter: `deployments`

Specifies the OpenAI deployments to create.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`model`](#parameter-deploymentsmodel) | object | Properties of Cognitive Services account deployment model. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-deploymentsname) | string | Specify the name of cognitive service account deployment. |
| [`raiPolicyName`](#parameter-deploymentsraipolicyname) | string | The name of RAI policy. |
| [`sku`](#parameter-deploymentssku) | object | The resource model definition representing SKU. |
| [`versionUpgradeOption`](#parameter-deploymentsversionupgradeoption) | string | The version upgrade option. |

### Parameter: `deployments.model`

Properties of Cognitive Services account deployment model.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`format`](#parameter-deploymentsmodelformat) | string | The format of Cognitive Services account deployment model. |
| [`name`](#parameter-deploymentsmodelname) | string | The name of Cognitive Services account deployment model. |
| [`version`](#parameter-deploymentsmodelversion) | string | The version of Cognitive Services account deployment model. |

### Parameter: `deployments.model.format`

The format of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `deployments.model.name`

The name of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `deployments.model.version`

The version of Cognitive Services account deployment model.

- Required: Yes
- Type: string

### Parameter: `deployments.name`

Specify the name of cognitive service account deployment.

- Required: No
- Type: string

### Parameter: `deployments.raiPolicyName`

The name of RAI policy.

- Required: No
- Type: string

### Parameter: `deployments.sku`

The resource model definition representing SKU.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-deploymentsskuname) | string | The name of the resource model definition representing SKU. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-deploymentsskucapacity) | int | The capacity of the resource model definition representing SKU. |
| [`family`](#parameter-deploymentsskufamily) | string | The family of the resource model definition representing SKU. |
| [`size`](#parameter-deploymentsskusize) | string | The size of the resource model definition representing SKU. |
| [`tier`](#parameter-deploymentsskutier) | string | The tier of the resource model definition representing SKU. |

### Parameter: `deployments.sku.name`

The name of the resource model definition representing SKU.

- Required: Yes
- Type: string

### Parameter: `deployments.sku.capacity`

The capacity of the resource model definition representing SKU.

- Required: No
- Type: int

### Parameter: `deployments.sku.family`

The family of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `deployments.sku.size`

The size of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `deployments.sku.tier`

The tier of the resource model definition representing SKU.

- Required: No
- Type: string

### Parameter: `deployments.versionUpgradeOption`

The version upgrade option.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `kind`

Kind of the Cognitive Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
- Default: `'AIServices'`
- Allowed:
  ```Bicep
  [
    'AIServices'
    'AnomalyDetector'
    'CognitiveServices'
    'ComputerVision'
    'ContentModerator'
    'ContentSafety'
    'ConversationalLanguageUnderstanding'
    'CustomVision.Prediction'
    'CustomVision.Training'
    'Face'
    'FormRecognizer'
    'HealthInsights'
    'ImmersiveReader'
    'Internal.AllInOne'
    'LanguageAuthoring'
    'LUIS'
    'LUIS.Authoring'
    'MetricsAdvisor'
    'OpenAI'
    'Personalizer'
    'QnAMaker.v2'
    'SpeechServices'
    'TextAnalytics'
    'TextTranslation'
  ]
  ```

### Parameter: `location`

The location of the Cognitive Services resource.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `logAnalyticsWorkspaceResourceId`

The resource ID of the Log Analytics workspace to use for diagnostic settings.

- Required: No
- Type: string

### Parameter: `privateNetworking`

Values to establish private networking for the AI Services resource.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privatenetworkingsubnetresourceid) | string | The Resource ID of the subnet to establish the Private Endpoint(s). |
| [`virtualNetworkResourceId`](#parameter-privatenetworkingvirtualnetworkresourceid) | string | The Resource ID of the virtual network. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cogServicesPrivateDnsZoneResourceId`](#parameter-privatenetworkingcogservicesprivatednszoneresourceid) | string | The Resource ID of an existing "cognitiveservices" Private DNS Zone Resource to link to the virtual network. If not provided, a new "cognitiveservices" Private DNS Zone(s) will be created. |
| [`openAIPrivateDnsZoneResourceId`](#parameter-privatenetworkingopenaiprivatednszoneresourceid) | string | The Resource ID of an existing "openai" Private DNS Zone Resource to link to the virtual network. If not provided, a new "openai" Private DNS Zone(s) will be created. |

### Parameter: `privateNetworking.subnetResourceId`

The Resource ID of the subnet to establish the Private Endpoint(s).

- Required: Yes
- Type: string

### Parameter: `privateNetworking.virtualNetworkResourceId`

The Resource ID of the virtual network.

- Required: Yes
- Type: string

### Parameter: `privateNetworking.cogServicesPrivateDnsZoneResourceId`

The Resource ID of an existing "cognitiveservices" Private DNS Zone Resource to link to the virtual network. If not provided, a new "cognitiveservices" Private DNS Zone(s) will be created.

- Required: No
- Type: string

### Parameter: `privateNetworking.openAIPrivateDnsZoneResourceId`

The Resource ID of an existing "openai" Private DNS Zone Resource to link to the virtual network. If not provided, a new "openai" Private DNS Zone(s) will be created.

- Required: No
- Type: string

### Parameter: `projectDescription`

The description of the AI Foundry project to create.

- Required: No
- Type: string
- Default: `[parameters('projectName')]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `sku`

The SKU of the Cognitive Services account. Use 'Get-AzCognitiveServicesAccountSku' to determine a valid combinations of 'kind' and 'SKU' for your Azure region.

- Required: No
- Type: string
- Default: `'S0'`
- Allowed:
  ```Bicep
  [
    'S'
    'S0'
    'S1'
    'S2'
    'S3'
    'S4'
    'S5'
    'S6'
    'S7'
    'S8'
  ]
  ```

### Parameter: `tags`

Tags to be applied to the resources.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpoint` | string | The endpoint of the Cognitive Services resource. |
| `name` | string | Name of the Cognitive Services resource. |
| `project` |  | AI Foundry Project information. |
| `resourceGroupName` | string | The resource group the resources were deployed into. |
| `resourceId` | string | Resource ID of the Cognitive Services resource. |
| `systemAssignedMIPrincipalId` | string | Principal ID of the system assigned managed identity for the Cognitive Services resource. This is only available if the resource has a system assigned managed identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
