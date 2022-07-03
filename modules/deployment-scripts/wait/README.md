# Deployment Delay

A Deployment Script that introduces a delay to the deployment process.

## Parameters

| Name          | Type     | Required | Description                             |
| :------------ | :------: | :------: | :-------------------------------------- |
| `waitSeconds` | `int`    | Yes      | The number of seconds to wait for       |
| `location`    | `string` | No       | The location to deploy the resources to |

## Outputs

| Name | Type | Description |
| :--- | :--: | :---------- |

## Examples

### Delaying by 60 seconds

```bicep
param location string = resourceGroup().location
param waitSeconds int =  60

module delayDeployment '../main.bicep' = {
  name: 'delayDeployment'
  params: {
    waitSeconds: waitSeconds
    location: location
  }
}
```