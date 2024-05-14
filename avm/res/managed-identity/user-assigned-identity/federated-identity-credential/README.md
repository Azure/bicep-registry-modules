# User Assigned Identity Federated Identity Credential `[Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials]`

This module deploys a User Assigned Identity Federated Identity Credential.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities/federatedIdentityCredentials) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`audiences`](#parameter-audiences) | array | The list of audiences that can appear in the issued token. Should be set to api://AzureADTokenExchange for Azure AD. It says what Microsoft identity platform should accept in the aud claim in the incoming token. This value represents Azure AD in your external identity provider and has no fixed value across identity providers - you might need to create a new application registration in your IdP to serve as the audience of this token. |
| [`issuer`](#parameter-issuer) | string | The URL of the issuer to be trusted. Must match the issuer claim of the external token being exchanged. |
| [`name`](#parameter-name) | string | The name of the secret. |
| [`subject`](#parameter-subject) | string | The identifier of the external software workload within the external identity provider. Like the audience value, it has no fixed format, as each IdP uses their own - sometimes a GUID, sometimes a colon delimited identifier, sometimes arbitrary strings. The value here must match the sub claim within the token presented to Azure AD. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedIdentityName`](#parameter-userassignedidentityname) | string | The name of the parent user assigned identity. Required if the template is used in a standalone deployment. |

### Parameter: `audiences`

The list of audiences that can appear in the issued token. Should be set to api://AzureADTokenExchange for Azure AD. It says what Microsoft identity platform should accept in the aud claim in the incoming token. This value represents Azure AD in your external identity provider and has no fixed value across identity providers - you might need to create a new application registration in your IdP to serve as the audience of this token.

- Required: Yes
- Type: array

### Parameter: `issuer`

The URL of the issuer to be trusted. Must match the issuer claim of the external token being exchanged.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the secret.

- Required: Yes
- Type: string

### Parameter: `subject`

The identifier of the external software workload within the external identity provider. Like the audience value, it has no fixed format, as each IdP uses their own - sometimes a GUID, sometimes a colon delimited identifier, sometimes arbitrary strings. The value here must match the sub claim within the token presented to Azure AD.

- Required: Yes
- Type: string

### Parameter: `userAssignedIdentityName`

The name of the parent user assigned identity. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the federated identity credential. |
| `resourceGroupName` | string | The name of the resource group the federated identity credential was created in. |
| `resourceId` | string | The resource ID of the federated identity credential. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
