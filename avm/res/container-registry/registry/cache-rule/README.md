# Container Registries Cache `[Microsoft.ContainerRegistry/registries/cacheRules]`

Cache for Azure Container Registry (Preview) feature allows users to cache container images in a private container registry. Cache for ACR, is a preview feature available in Basic, Standard, and Premium service tiers ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache)).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ContainerRegistry/registries/cacheRules` | [2023-06-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/registries/cacheRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentialSetResourceId`](#parameter-credentialsetresourceid) | string | The resource ID of the credential store which is associated with the cache rule. |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |
| [`sourceRepository`](#parameter-sourcerepository) | string | Source repository pulled from upstream. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the cache rule. Will be derived from the source repository name if not defined. |
| [`targetRepository`](#parameter-targetrepository) | string | Target repository specified in docker pull command. E.g.: docker pull myregistry.azurecr.io/{targetRepository}:{tag}. |

### Parameter: `credentialSetResourceId`

The resource ID of the credential store which is associated with the cache rule.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `sourceRepository`

Source repository pulled from upstream.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the cache rule. Will be derived from the source repository name if not defined.

- Required: No
- Type: string
- Default: `[replace(replace(parameters('sourceRepository'), '/', '-'), '.', '-')]`

### Parameter: `targetRepository`

Target repository specified in docker pull command. E.g.: docker pull myregistry.azurecr.io/{targetRepository}:{tag}.

- Required: No
- Type: string
- Default: `[parameters('sourceRepository')]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The Name of the Cache Rule. |
| `resourceGroupName` | string | The name of the Cache Rule. |
| `resourceId` | string | The resource ID of the Cache Rule. |
