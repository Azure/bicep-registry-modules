# User Assigned Identity Federated Identity Credential `[Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials]`

This module deploys a User Assigned Identity Federated Identity Credential.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

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
