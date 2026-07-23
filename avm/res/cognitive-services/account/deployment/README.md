# Cognitive Services Account Deployment `[Microsoft.CognitiveServices/accounts/deployments]`

This module deploys a Cognitive Services account model deployment.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.CognitiveServices/accounts/deployments` | 2026-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cognitiveservices_accounts_deployments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.CognitiveServices/2026-05-01/accounts/deployments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accountName`](#parameter-accountname) | string | The name of the parent Cognitive Services account. |
| [`model`](#parameter-model) | object | Properties of the Cognitive Services account deployment model. |
| [`name`](#parameter-name) | string | The name of the Cognitive Services account deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`modelProviderData`](#parameter-modelproviderdata) | object | Model-provider attestation required for GA partner models such as Anthropic Claude. |
| [`raiPolicyName`](#parameter-raipolicyname) | string | The name of the RAI policy. |
| [`sku`](#parameter-sku) | object | The resource model definition representing the SKU. |
| [`versionUpgradeOption`](#parameter-versionupgradeoption) | string | The version upgrade option. |

### Parameter: `accountName`

The name of the parent Cognitive Services account.

- Required: Yes
- Type: string

### Parameter: `model`

Properties of the Cognitive Services account deployment model.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the Cognitive Services account deployment.

- Required: Yes
- Type: string

### Parameter: `modelProviderData`

Model-provider attestation required for GA partner models such as Anthropic Claude.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`countryCode`](#parameter-modelproviderdatacountrycode) | string | Two-letter ISO 3166-1 alpha-2 country or region code. |
| [`industry`](#parameter-modelproviderdataindustry) | string | The organization industry accepted by the resource provider. |
| [`organizationName`](#parameter-modelproviderdataorganizationname) | string | Legal entity name of the organization deploying the model. |

### Parameter: `modelProviderData.countryCode`

Two-letter ISO 3166-1 alpha-2 country or region code.

- Required: Yes
- Type: string

### Parameter: `modelProviderData.industry`

The organization industry accepted by the resource provider.

- Required: Yes
- Type: string

### Parameter: `modelProviderData.organizationName`

Legal entity name of the organization deploying the model.

- Required: Yes
- Type: string

### Parameter: `raiPolicyName`

The name of the RAI policy.

- Required: No
- Type: string

### Parameter: `sku`

The resource model definition representing the SKU.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      capacity: 1
      name: 'Standard'
  }
  ```

### Parameter: `versionUpgradeOption`

The version upgrade option.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Cognitive Services account deployment. |
| `resourceGroupName` | string | The name of the resource group in which the deployment was created. |
| `resourceId` | string | The resource ID of the Cognitive Services account deployment. |
