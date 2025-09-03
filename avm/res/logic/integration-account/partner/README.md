# Integration Account Partners `[Microsoft.Logic/integrationAccounts/partners]`

This module deploys an Integration Account Partner.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Logic/integrationAccounts/partners` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_partners.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/partners)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The Name of the partner resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`b2bPartnerContent`](#parameter-b2bpartnercontent) | object | B2B partner content settings. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) | object | The partner metadata. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

The Name of the partner resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `b2bPartnerContent`

B2B partner content settings.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`businessIdentities`](#parameter-b2bpartnercontentbusinessidentities) | array | The list of partner business identities. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`partnerClassification`](#parameter-b2bpartnercontentpartnerclassification) | string | The partner classification. |
| [`partnerContact`](#parameter-b2bpartnercontentpartnercontact) | object | The RosettaNet partner properties. |

### Parameter: `b2bPartnerContent.businessIdentities`

The list of partner business identities.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`qualifier`](#parameter-b2bpartnercontentbusinessidentitiesqualifier) | string | The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32. |
| [`value`](#parameter-b2bpartnercontentbusinessidentitiesvalue) | string | The user defined business identity value. |

### Parameter: `b2bPartnerContent.businessIdentities.qualifier`

The business identity qualifier e.g. as2identity, ZZ, ZZZ, 31, 32.

- Required: Yes
- Type: string

### Parameter: `b2bPartnerContent.businessIdentities.value`

The user defined business identity value.

- Required: Yes
- Type: string

### Parameter: `b2bPartnerContent.partnerClassification`

The partner classification.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Carrier'
    'Distributor'
    'EndUser'
    'EndUserGovernment'
    'Financier'
    'FreightForwarder'
    'Manufacturer'
    'MarketPlace'
    'Retailer'
    'Shopper'
  ]
  ```

### Parameter: `b2bPartnerContent.partnerContact`

The RosettaNet partner properties.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailAddress`](#parameter-b2bpartnercontentpartnercontactemailaddress) | string | The email address of the partner. |
| [`faxNumber`](#parameter-b2bpartnercontentpartnercontactfaxnumber) | string | The fax number of the partner. |
| [`name`](#parameter-b2bpartnercontentpartnercontactname) | string | The name of the contact person. |
| [`supplyChainCode`](#parameter-b2bpartnercontentpartnercontactsupplychaincode) | string | The supply chain code of the partner. |
| [`telephoneNumber`](#parameter-b2bpartnercontentpartnercontacttelephonenumber) | string | The phone number of the partner. |

### Parameter: `b2bPartnerContent.partnerContact.emailAddress`

The email address of the partner.

- Required: No
- Type: string

### Parameter: `b2bPartnerContent.partnerContact.faxNumber`

The fax number of the partner.

- Required: No
- Type: string

### Parameter: `b2bPartnerContent.partnerContact.name`

The name of the contact person.

- Required: No
- Type: string

### Parameter: `b2bPartnerContent.partnerContact.supplyChainCode`

The supply chain code of the partner.

- Required: No
- Type: string

### Parameter: `b2bPartnerContent.partnerContact.telephoneNumber`

The phone number of the partner.

- Required: No
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The partner metadata.

- Required: No
- Type: object

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account partner. |
| `resourceGroupName` | string | The resource group the integration account partner was deployed into. |
| `resourceId` | string | The resource ID of the integration account partner. |
