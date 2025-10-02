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

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.App/containerApps` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps)</li></ul> |
| `Microsoft.App/containerApps/authConfigs` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_containerapps_authconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-01-01/containerApps/authConfigs)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |

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
    containerProbes: [
      {
        httpGet: {
          httpHeaders: [
            {
              name: 'Custom-Header'
              value: 'Awesome'
            }
          ]
          path: '/health'
          port: 8080
        }
        initialDelaySeconds: 3
        periodSeconds: 3
        type: 'Liveness'
      }
    ]
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
    secrets: [
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
    "containerProbes": {
      "value": [
        {
          "httpGet": {
            "httpHeaders": [
              {
                "name": "Custom-Header",
                "value": "Awesome"
              }
            ],
            "path": "/health",
            "port": 8080
          },
          "initialDelaySeconds": 3,
          "periodSeconds": 3,
          "type": "Liveness"
        }
      ]
    },
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
      "value": [
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
param containerProbes = [
  {
    httpGet: {
      httpHeaders: [
        {
          name: 'Custom-Header'
          value: 'Awesome'
        }
      ]
      path: '/health'
      port: 8080
    }
    initialDelaySeconds: 3
    periodSeconds: 3
    type: 'Liveness'
  }
]
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
param secrets = [
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
| [`containerProbes`](#parameter-containerprobes) | array | List of probes for the container. |
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
| [`secrets`](#parameter-secrets) | array | The secrets required for the container. |
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
- MinValue: 1

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
- MinValue: 1

### Parameter: `containerName`

The name of the container.

- Required: No
- Type: string
- Default: `'main'`

### Parameter: `containerProbes`

List of probes for the container.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`failureThreshold`](#parameter-containerprobesfailurethreshold) | int | Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. |
| [`httpGet`](#parameter-containerprobeshttpget) | object | HTTPGet specifies the http request to perform. |
| [`initialDelaySeconds`](#parameter-containerprobesinitialdelayseconds) | int | Number of seconds after the container has started before liveness probes are initiated. |
| [`periodSeconds`](#parameter-containerprobesperiodseconds) | int | How often (in seconds) to perform the probe. Default to 10 seconds. |
| [`successThreshold`](#parameter-containerprobessuccessthreshold) | int | Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup. |
| [`tcpSocket`](#parameter-containerprobestcpsocket) | object | The TCP socket specifies an action involving a TCP port. TCP hooks not yet supported. |
| [`terminationGracePeriodSeconds`](#parameter-containerprobesterminationgraceperiodseconds) | int | Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate. Maximum value is 3600 seconds (1 hour). |
| [`timeoutSeconds`](#parameter-containerprobestimeoutseconds) | int | Number of seconds after which the probe times out. Defaults to 1 second. |
| [`type`](#parameter-containerprobestype) | string | The type of probe. |

### Parameter: `containerProbes.failureThreshold`

Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 10

### Parameter: `containerProbes.httpGet`

HTTPGet specifies the http request to perform.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`path`](#parameter-containerprobeshttpgetpath) | string | Path to access on the HTTP server. |
| [`port`](#parameter-containerprobeshttpgetport) | int | Name or number of the port to access on the container. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`host`](#parameter-containerprobeshttpgethost) | string | Host name to connect to. Defaults to the pod IP. |
| [`httpHeaders`](#parameter-containerprobeshttpgethttpheaders) | array | HTTP headers to set in the request. |
| [`scheme`](#parameter-containerprobeshttpgetscheme) | string | Scheme to use for connecting to the host. Defaults to HTTP. |

### Parameter: `containerProbes.httpGet.path`

Path to access on the HTTP server.

- Required: Yes
- Type: string

### Parameter: `containerProbes.httpGet.port`

Name or number of the port to access on the container.

- Required: Yes
- Type: int

### Parameter: `containerProbes.httpGet.host`

Host name to connect to. Defaults to the pod IP.

- Required: No
- Type: string

### Parameter: `containerProbes.httpGet.httpHeaders`

HTTP headers to set in the request.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containerprobeshttpgethttpheadersname) | string | Name of the header. |
| [`value`](#parameter-containerprobeshttpgethttpheadersvalue) | string | Value of the header. |

### Parameter: `containerProbes.httpGet.httpHeaders.name`

Name of the header.

- Required: Yes
- Type: string

### Parameter: `containerProbes.httpGet.httpHeaders.value`

Value of the header.

- Required: Yes
- Type: string

### Parameter: `containerProbes.httpGet.scheme`

Scheme to use for connecting to the host. Defaults to HTTP.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'HTTP'
    'HTTPS'
  ]
  ```

### Parameter: `containerProbes.initialDelaySeconds`

Number of seconds after the container has started before liveness probes are initiated.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 60

### Parameter: `containerProbes.periodSeconds`

How often (in seconds) to perform the probe. Default to 10 seconds.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 240

### Parameter: `containerProbes.successThreshold`

Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness and startup.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 10

### Parameter: `containerProbes.tcpSocket`

The TCP socket specifies an action involving a TCP port. TCP hooks not yet supported.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-containerprobestcpsocketport) | int | Number of the port to access on the container. Name must be an IANA_SVC_NAME. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`host`](#parameter-containerprobestcpsockethost) | string | Host name to connect to, defaults to the pod IP. |

### Parameter: `containerProbes.tcpSocket.port`

Number of the port to access on the container. Name must be an IANA_SVC_NAME.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 65535

### Parameter: `containerProbes.tcpSocket.host`

Host name to connect to, defaults to the pod IP.

- Required: No
- Type: string

### Parameter: `containerProbes.terminationGracePeriodSeconds`

Optional duration in seconds the pod needs to terminate gracefully upon probe failure. The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process. If this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this value overrides the value provided by the pod spec. Value must be non-negative integer. The value zero indicates stop immediately via the kill signal (no opportunity to shut down). This is an alpha field and requires enabling ProbeTerminationGracePeriod feature gate. Maximum value is 3600 seconds (1 hour).

- Required: No
- Type: int

### Parameter: `containerProbes.timeoutSeconds`

Number of seconds after which the probe times out. Defaults to 1 second.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 240

### Parameter: `containerProbes.type`

The type of probe.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Liveness'
    'Readiness'
    'Startup'
  ]
  ```

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
- Type: array

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultUrl`](#parameter-secretskeyvaulturl) | string | The URL of the Azure Key Vault secret referenced by the Container App. Required if `value` is null. |
| [`value`](#parameter-secretsvalue) | securestring | The container app secret value, if not fetched from the Key Vault. Required if `keyVaultUrl` is not null. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identity`](#parameter-secretsidentity) | string | Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity. |
| [`name`](#parameter-secretsname) | string | The name of the container app secret. |

### Parameter: `secrets.keyVaultUrl`

The URL of the Azure Key Vault secret referenced by the Container App. Required if `value` is null.

- Required: No
- Type: string

### Parameter: `secrets.value`

The container app secret value, if not fetched from the Key Vault. Required if `keyVaultUrl` is not null.

- Required: No
- Type: securestring

### Parameter: `secrets.identity`

Resource ID of a managed identity to authenticate with Azure Key Vault, or System to use a system-assigned identity.

- Required: No
- Type: string

### Parameter: `secrets.name`

The name of the container app secret.

- Required: No
- Type: string

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
| `br/public:avm/ptn/azd/acr-container-app:0.2.0` | Remote reference |
| `br/public:avm/res/app/container-app:0.18.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
