# Container Registries Credential Sets `[Microsoft.ContainerRegistry/registries/credentialSets]`

This module deploys an ACR Credential Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/credentialSets` | [2023-11-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/credentialSets) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authCredentials`](#parameter-authcredentials) | array | List of authentication credentials stored for an upstream. Usually consists of a primary and an optional secondary credential. |
| [`loginServer`](#parameter-loginserver) | string | The credentials are stored for this upstream or login server. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`name`](#parameter-name) | string | The name of the credential set. |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

### Parameter: `authCredentials`

List of authentication credentials stored for an upstream. Usually consists of a primary and an optional secondary credential.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-authcredentialsname) | string | The name of the credential. |
| [`passwordSecretIdentifier`](#parameter-authcredentialspasswordsecretidentifier) | string | KeyVault Secret URI for accessing the password. |
| [`usernameSecretIdentifier`](#parameter-authcredentialsusernamesecretidentifier) | string | KeyVault Secret URI for accessing the username. |

### Parameter: `authCredentials.name`

The name of the credential.

- Required: Yes
- Type: string

### Parameter: `authCredentials.passwordSecretIdentifier`

KeyVault Secret URI for accessing the password.

- Required: Yes
- Type: string

### Parameter: `authCredentials.usernameSecretIdentifier`

KeyVault Secret URI for accessing the username.

- Required: Yes
- Type: string

### Parameter: `loginServer`

The credentials are stored for this upstream or login server.

- Required: Yes
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `name`

The name of the credential set.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Credential Set. |
| `resourceGroupName` | string | The name of the Credential Set. |
| `resourceId` | string | The resource ID of the Credential Set. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
