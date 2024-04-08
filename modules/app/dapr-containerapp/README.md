<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-new-standard-for-bicep-modules---avm-%EF%B8%8F).

# dapr container app

A dapr optimised container app

## Details

This module deploys a dapr Container App to be deployed with an optimised configuration.
When used in combination with the dapr-ContainerApps-Environment module, the infrastructure required to deploy your applications is greatly simplified.

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
| `createUserManagedId`    | `bool`   | No       | Will create a user managed identity for the application to access other Azure resoruces as                                                                  |
| `tags`                   | `object` | No       | Any tags that are to be applied to the Container App                                                                                                        |

## Outputs

| Name                        | Type     | Description                                                                  |
| :-------------------------- | :------: | :--------------------------------------------------------------------------- |
| `containerAppFQDN`          | `string` | If ingress is enabled, this is the FQDN that the Container App is exposed on |
| `userAssignedIdPrincipalId` | `string` | The PrinicpalId of the Container Apps Managed Identity                       |

## Examples

### Stateful workload

```bicep
module myenv 'br/public:app/dapr-containerapps-environment:1.0.1' = {
  name: 'state'
  params: {
    location: location
    nameseed: 'stateSt1'
    applicationEntityName: 'appdata'
    daprComponentType: 'state.azure.blobstorage'
    daprComponentScopes: [
      'nodeapp'
    ]
  }
}

module appNodeService 'br/public:app/dapr-containerapp:1.0.3' = {
  name: 'stateNodeApp'
  params: {
    location: location
    containerAppName: 'nodeapp'
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-node:latest'
    targetPort: 3000
    externalIngress: false
    createUserManagedId: false
    environmentVariables: [
      {
        name: 'APP_PORT'
        value: '3000'
      }
    ]
  }
}

module appPythonClient 'br/public:app/dapr-containerapp:1.0.3' = {
  name: 'statePyApp'
  params: {
    location: location
    containerAppName: 'pythonapp'
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerImage: 'ghcr.io/dapr/samples/hello-k8s-python:latest'
    enableIngress: false
    createUserManagedId: false
    daprAppProtocol: ''
  }
}
```

Reference sample for workload: [dapr microservices](https://docs.microsoft.com/en-us/azure/container-apps/microservices-dapr-azure-resource-manager)

### Pub-Sub workload

```bicep
module myenv 'br/public:app/dapr-containerapps-environment:1.0.1' = {
  name: 'pubsub'
  params: {
    location: location
    nameseed: 'pubsub-sb1'
    applicationEntityName: 'orders'
    daprComponentType: 'pubsub.azure.servicebus'
  }
}

module appSubscriber 'br/public:app/dapr-containerapp:1.0.3' = {
  name: 'subscriber'
  params: {
    location: location
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerAppName: 'subscriber-orders'
    containerImage: 'ghcr.io/gordonby/dapr-sample-pubsub-orders:0.1'
    environmentVariables: pubSubAppEnvVars
    targetPort: 5001
  }
}

module appPublisher 'br/public:app/dapr-containerapp:1.0.3' = {
  name: 'publisher'
  params: {
    location: location
    containerAppEnvName: myenv.outputs.containerAppEnvironmentName
    containerAppName: 'publisher-checkout'
    containerImage: 'ghcr.io/gordonby/dapr-sample-pubsub-checkout:0.1'
    environmentVariables: pubSubAppEnvVars
    enableIngress: false
  }
}

var pubSubAppEnvVars = [ {
  name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
  value: myenv.outputs.appInsightsInstrumentationKey
}
{
  name: 'AZURE_KEY_VAULT_ENDPOINT'
  value: keyvault.properties.vaultUri
}
]

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = existing {
  name: 'yourkeyvault'
  location: location
}
```

Reference sample for workload : [dapr pub sub](https://github.com/dapr/quickstarts/tree/master/pub_sub/javascript/sdk)
