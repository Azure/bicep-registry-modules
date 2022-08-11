# dapr container app

A dapr optimised container app

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                     | Type     | Required | Description                                                                                                                                                 |
| :----------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `containerAppName`       | `string` | No       | Specifies the name of the container app.                                                                                                                    |
| `containerAppEnvName`    | `string` | Yes      | Specifies the name of the container app environment to target, must be in the same resourceGroup.                                                           |
| `location`               | `string` | No       | Specifies the location for all resources.                                                                                                                   |
| `containerImage`         | `string` | No       | Specifies the docker container image to deploy.                                                                                                             |
| `targetPort`             | `int`    | No       | Specifies the container port.                                                                                                                               |
| `daprAppPort`            | `int`    | No       | Specifies the dapr app port.                                                                                                                                |
| `daprAppProtocol`        | `string` | No       | Tells Dapr which protocol your application is using. Valid options are http and grpc. Default is http                                                       |
| `revisionMode`           | `string` | No       | Controls how active revisions are handled for the Container app                                                                                             |
| `cpuCore`                | `string` | No       | Number of CPU cores the container can use. Can be with a maximum of two decimals places. Max of 2.0. Valid values include, 0.5 1.25 1.4                     |
| `memorySize`             | `string` | No       | Amount of memory (in gibibytes, GiB) allocated to the container up to 4GiB. Can be with a maximum of two decimals. Ratio with CPU cores must be equal to 2. |
| `minReplicas`            | `int`    | No       | Minimum number of replicas that will be deployed                                                                                                            |
| `maxReplicas`            | `int`    | No       | Maximum number of replicas that will be deployed                                                                                                            |
| `externalIngress`        | `bool`   | No       | Should the app be exposed on an external endpoint                                                                                                           |
| `enableIngress`          | `bool`   | No       | Does the app expect traffic, or should it operate headless                                                                                                  |
| `revisionSuffix`         | `string` | No       | Revisions to the container app need to be unique                                                                                                            |
| `environmentVariables`   | `array`  | No       | Any environment variables that your container needs                                                                                                         |
| `azureContainerRegistry` | `string` | No       | An ACR name can be optionally passed if thats where the container app image is homed                                                                        |
| `tags`                   | `object` | No       | Any tags that are to be applied to the Container App                                                                                                        |

## Outputs

| Name                      | Type   | Description                                                                  |
| :------------------------ | :----: | :--------------------------------------------------------------------------- |
| containerAppFQDN          | string | If ingress is enabled, this is the FQDN that the Container App is exposed on |
| userAssignedIdPrincipalId | string | The PrinicpalId of the Container Apps Managed Identity                       |

## Examples

### Example 1

```bicep
```

### Example 2

```bicep
```