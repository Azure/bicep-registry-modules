# Azd Container App Upsert `[Azd/ContainerAppUpsert]`

Creates or updates an existing Azure Container App.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/containerApps` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-03-01/containerApps) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/azd/container-app-upsert:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module containerAppUpsert 'br/public:avm/ptn/azd/container-app-upsert:<version>' = {
  name: 'containerAppUpsertDeployment'
  params: {
    // Required parameters
    containerAppsEnvironmentName: '<containerAppsEnvironmentName>'
    name: 'acaumin001'
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
    "containerAppsEnvironmentName": {
      "value": "<containerAppsEnvironmentName>"
    },
    "name": {
      "value": "acaumin001"
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
using 'br/public:avm/ptn/azd/container-app-upsert:<version>'

// Required parameters
param containerAppsEnvironmentName = '<containerAppsEnvironmentName>'
param name = 'acaumin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module containerAppUpsert 'br/public:avm/ptn/azd/container-app-upsert:<version>' = {
  name: 'containerAppUpsertDeployment'
  params: {
    // Required parameters
    containerAppsEnvironmentName: '<containerAppsEnvironmentName>'
    name: '<name>'
    // Non-required parameters
    containerRegistryName: '<containerRegistryName>'
    daprEnabled: true
    env: [
      {
        name: 'ContainerAppStoredSecretName'
        secretRef: 'containerappstoredsecret'
      }
      {
        name: 'ContainerAppKeyVaultStoredSecretName'
        secretRef: 'keyvaultstoredsecret'
      }
    ]
    exists: true
    identityName: '<identityName>'
    identityPrincipalId: '<identityPrincipalId>'
    identityType: 'UserAssigned'
    location: '<location>'
    secrets: {
      secureList: [
        {
          name: 'containerappstoredsecret'
          value: '<value>'
        }
        {
          identity: '<identity>'
          keyVaultUrl: '<keyVaultUrl>'
          name: 'keyvaultstoredsecret'
        }
      ]
    }
    tags: {
      Env: 'test'
      'hidden-title': 'This is visible in the resource name'
    }
    userAssignedIdentityResourceId: '<userAssignedIdentityResourceId>'
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
    "containerAppsEnvironmentName": {
      "value": "<containerAppsEnvironmentName>"
    },
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "containerRegistryName": {
      "value": "<containerRegistryName>"
    },
    "daprEnabled": {
      "value": true
    },
    "env": {
      "value": [
        {
          "name": "ContainerAppStoredSecretName",
          "secretRef": "containerappstoredsecret"
        },
        {
          "name": "ContainerAppKeyVaultStoredSecretName",
          "secretRef": "keyvaultstoredsecret"
        }
      ]
    },
    "exists": {
      "value": true
    },
    "identityName": {
      "value": "<identityName>"
    },
    "identityPrincipalId": {
      "value": "<identityPrincipalId>"
    },
    "identityType": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "<location>"
    },
    "secrets": {
      "value": {
        "secureList": [
          {
            "name": "containerappstoredsecret",
            "value": "<value>"
          },
          {
            "identity": "<identity>",
            "keyVaultUrl": "<keyVaultUrl>",
            "name": "keyvaultstoredsecret"
          }
        ]
      }
    },
    "tags": {
      "value": {
        "Env": "test",
        "hidden-title": "This is visible in the resource name"
      }
    },
    "userAssignedIdentityResourceId": {
      "value": "<userAssignedIdentityResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/azd/container-app-upsert:<version>'

// Required parameters
param containerAppsEnvironmentName = '<containerAppsEnvironmentName>'
param name = '<name>'
// Non-required parameters
param containerRegistryName = '<containerRegistryName>'
param daprEnabled = true
param env = [
  {
    name: 'ContainerAppStoredSecretName'
    secretRef: 'containerappstoredsecret'
  }
  {
    name: 'ContainerAppKeyVaultStoredSecretName'
    secretRef: 'keyvaultstoredsecret'
  }
]
param exists = true
param identityName = '<identityName>'
param identityPrincipalId = '<identityPrincipalId>'
param identityType = 'UserAssigned'
param location = '<location>'
param secrets = {
  secureList: [
    {
      name: 'containerappstoredsecret'
      value: '<value>'
    }
    {
      identity: '<identity>'
      keyVaultUrl: '<keyVaultUrl>'
      name: 'keyvaultstoredsecret'
    }
  ]
}
param tags = {
  Env: 'test'
  'hidden-title': 'This is visible in the resource name'
}
param userAssignedIdentityResourceId = '<userAssignedIdentityResourceId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerAppsEnvironmentName`](#parameter-containerappsenvironmentname) | string | Name of the environment for container apps. |
| [`name`](#parameter-name) | string | The name of the Container App. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`containerCpuCoreCount`](#parameter-containercpucorecount) | string | The number of CPU cores allocated to a single container instance, e.g., 0.5. |
| [`containerMaxReplicas`](#parameter-containermaxreplicas) | int | The maximum number of replicas to run. Must be at least 1. |
| [`containerMemory`](#parameter-containermemory) | string | The amount of memory allocated to a single container instance, e.g., 1Gi. |
| [`containerMinReplicas`](#parameter-containerminreplicas) | int | The minimum number of replicas to run. Must be at least 2. |
| [`containerName`](#parameter-containername) | string | The name of the container. |
| [`containerRegistryHostSuffix`](#parameter-containerregistryhostsuffix) | string | Hostname suffix for container registry. Set when deploying to sovereign clouds. |
| [`containerRegistryName`](#parameter-containerregistryname) | string | The name of the container registry. |
| [`daprAppId`](#parameter-daprappid) | string | The Dapr app ID. |
| [`daprAppProtocol`](#parameter-daprappprotocol) | string | The protocol used by Dapr to connect to the app, e.g., HTTP or gRPC. |
| [`daprEnabled`](#parameter-daprenabled) | bool | Enable or disable Dapr for the container app. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`env`](#parameter-env) | array | The environment variables for the container. |
| [`exists`](#parameter-exists) | bool | Specifies if the resource already exists. |
| [`external`](#parameter-external) | bool | Specifies if the resource ingress is exposed externally. |
| [`identityName`](#parameter-identityname) | string | The name of the user-assigned identity. |
| [`identityPrincipalId`](#parameter-identityprincipalid) | string | The principal ID of the principal to assign the role to. |
| [`identityType`](#parameter-identitytype) | string | The type of identity for the resource. |
| [`imageName`](#parameter-imagename) | string | The name of the container image. |
| [`ingressEnabled`](#parameter-ingressenabled) | bool | Specifies if Ingress is enabled for the container app. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`secrets`](#parameter-secrets) | secureObject | The secrets required for the container. |
| [`serviceBinds`](#parameter-servicebinds) | array | The service binds associated with the container. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`targetPort`](#parameter-targetport) | int | The target port for the container. |
| [`userAssignedIdentityResourceId`](#parameter-userassignedidentityresourceid) | string | The resource id of the user-assigned identity. |

### Parameter: `containerAppsEnvironmentName`

Name of the environment for container apps.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Container App.

- Required: Yes
- Type: string

### Parameter: `containerCpuCoreCount`

The number of CPU cores allocated to a single container instance, e.g., 0.5.

- Required: No
- Type: string
- Default: `'0.5'`

### Parameter: `containerMaxReplicas`

The maximum number of replicas to run. Must be at least 1.

- Required: No
- Type: int
- Default: `10`

### Parameter: `containerMemory`

The amount of memory allocated to a single container instance, e.g., 1Gi.

- Required: No
- Type: string
- Default: `'1.0Gi'`

### Parameter: `containerMinReplicas`

The minimum number of replicas to run. Must be at least 2.

- Required: No
- Type: int
- Default: `2`

### Parameter: `containerName`

The name of the container.

- Required: No
- Type: string
- Default: `'main'`

### Parameter: `containerRegistryHostSuffix`

Hostname suffix for container registry. Set when deploying to sovereign clouds.

- Required: No
- Type: string
- Default: `'azurecr.io'`

### Parameter: `containerRegistryName`

The name of the container registry.

- Required: No
- Type: string
- Default: `''`

### Parameter: `daprAppId`

The Dapr app ID.

- Required: No
- Type: string
- Default: `[parameters('containerName')]`

### Parameter: `daprAppProtocol`

The protocol used by Dapr to connect to the app, e.g., HTTP or gRPC.

- Required: No
- Type: string
- Default: `'http'`
- Allowed:
  ```Bicep
  [
    'grpc'
    'http'
  ]
  ```

### Parameter: `daprEnabled`

Enable or disable Dapr for the container app.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `env`

The environment variables for the container.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-envname) | string | Environment variable name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretRef`](#parameter-envsecretref) | string | Name of the Container App secret from which to pull the environment variable value. |
| [`value`](#parameter-envvalue) | string | Non-secret environment variable value. |

### Parameter: `env.name`

Environment variable name.

- Required: Yes
- Type: string

### Parameter: `env.secretRef`

Name of the Container App secret from which to pull the environment variable value.

- Required: No
- Type: string

### Parameter: `env.value`

Non-secret environment variable value.

- Required: No
- Type: string

### Parameter: `exists`

Specifies if the resource already exists.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `external`

Specifies if the resource ingress is exposed externally.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `identityName`

The name of the user-assigned identity.

- Required: No
- Type: string
- Default: `''`

### Parameter: `identityPrincipalId`

The principal ID of the principal to assign the role to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `identityType`

The type of identity for the resource.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `imageName`

The name of the container image.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ingressEnabled`

Specifies if Ingress is enabled for the container app.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `secrets`

The secrets required for the container.

- Required: No
- Type: secureObject
- Default: `{}`

### Parameter: `serviceBinds`

The service binds associated with the container.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `targetPort`

The target port for the container.

- Required: No
- Type: int
- Default: `80`

### Parameter: `userAssignedIdentityResourceId`

The resource id of the user-assigned identity.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `defaultDomain` | string | The Default domain of the Container App. |
| `imageName` | string | The name of the container image. |
| `name` | string | The name of the Container App. |
| `resourceGroupName` | string | The name of the resource group the Container App was deployed into. |
| `resourceId` | string | The resource ID of the Container App. |
| `uri` | string | The uri of the Container App. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/azd/acr-container-app:0.1.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
