# Deployment Delay

A Deployment Script that introduces a delay to the deployment process.

## Description

When deploying Azure services together, it is sometimes necessary to introduce delays into the deployment to allow metadata time to propagate. This module can be declared, and referenced explicitly in the dependsOn properties of other Bicep resources in order to delay the resource deployment.

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

module delayDeployment 'br/public:deployment-scripts/wait:1.0.1' = {
  name: 'delayDeployment'
  params: {
    waitSeconds: waitSeconds
    location: location
  }
}
```