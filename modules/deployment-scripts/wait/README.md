<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Deployment Delay

A Deployment Script that introduces a delay to the deployment process.

## Details

When deploying Azure services together, it is sometimes necessary to introduce delays into the deployment to allow metadata time to propagate. This module can be declared, and referenced explicitly in the dependsOn properties of other Bicep resources in order to delay the resource deployment.

## Parameters

| Name          | Type     | Required | Description                             |
| :------------ | :------: | :------: | :-------------------------------------- |
| `scriptName`  | `string` | No       | The delay script resource name          |
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

module delayDeployment 'br/public:deployment-scripts/wait:1.1.1' = {
  name: 'delayDeployment'
  params: {
    waitSeconds: waitSeconds
    location: location
  }
}
```
