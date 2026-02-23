# Integration Account Agreements `[Microsoft.Logic/integrationAccounts/agreements]`

This module deploys an Integration Account Agreement.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Logic/integrationAccounts/agreements` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_agreements.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/agreements)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agreementType`](#parameter-agreementtype) | string | The agreement type. |
| [`content`](#parameter-content) | object | The agreement content. |
| [`guestIdentity`](#parameter-guestidentity) | object | The business identity of the guest partner. |
| [`guestPartner`](#parameter-guestpartner) | string | The integration account partner that is set as guest partner for this agreement. |
| [`hostIdentity`](#parameter-hostidentity) | object | The business identity of the host partner. |
| [`hostPartner`](#parameter-hostpartner) | string | The integration account partner that is set as host partner for this agreement. |
| [`name`](#parameter-name) | string | The Name of the agreement resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) |  | The agreement metadata. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `agreementType`

The agreement type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AS2'
    'Edifact'
    'NotSpecified'
    'X12'
  ]
  ```

### Parameter: `content`

The agreement content.

- Required: Yes
- Type: object

### Parameter: `guestIdentity`

The business identity of the guest partner.

- Required: Yes
- Type: object

### Parameter: `guestPartner`

The integration account partner that is set as guest partner for this agreement.

- Required: Yes
- Type: string

### Parameter: `hostIdentity`

The business identity of the host partner.

- Required: Yes
- Type: object

### Parameter: `hostPartner`

The integration account partner that is set as host partner for this agreement.

- Required: Yes
- Type: string

### Parameter: `name`

The Name of the agreement resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The agreement metadata.

- Required: No
- Type: 

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account agreement. |
| `resourceGroupName` | string | The resource group the integration account agreement was deployed into. |
| `resourceId` | string | The resource ID of the integration account agreement. |
