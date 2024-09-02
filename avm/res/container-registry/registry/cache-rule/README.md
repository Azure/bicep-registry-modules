# Container Registries Cache `[Microsoft.ContainerRegistry/registries/cacheRules]`

Cache for Azure Container Registry (Preview) feature allows users to cache container images in a private container registry. Cache for ACR, is a preview feature available in Basic, Standard, and Premium service tiers ([ref](https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache)).

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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
| [`name`](#parameter-name) | string | The name of the cache rule. Will be dereived from the source repository name if not defined. |
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

The name of the cache rule. Will be dereived from the source repository name if not defined.

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
