# Speech Service

This module deploys a Speech Service instance (Microsoft.CognitiveServices/accounts) with optional additions.

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name                  | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :-------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`            | `string` | No       | The location into which your Azure resources should be deployed.                                                                                                                                                                                                                                                                                                                             |
| `prefix`              | `string` | No       | Prefix of Resource Name. Not used if name is provided                                                                                                                                                                                                                                                                                                                                        |
| `name`                | `string` | No       | The name of the Speech service.                                                                                                                                                                                                                                                                                                                                                              |
| `tags`                | `object` | No       | The tags to apply to each resource.                                                                                                                                                                                                                                                                                                                                                          |
| `customSubDomainName` | `string` | No       | A custom subdomain to reach the Speech Service.                                                                                                                                                                                                                                                                                                                                              |
| `publicNetworkAccess` | `string` | No       | The Public Network Access setting of the Speech Service. When Disabled, only requests from Private Endpoints can access the Speech Service.                                                                                                                                                                                                                                                  |
| `privateEndpoints`    | `array`  | No       | A list of private endpoints to connect to the Speech Service.                                                                                                                                                                                                                                                                                                                                |
| `skuName`             | `string` | No       | The name of the SKU                                                                                                                                                                                                                                                                                                                                                                          |
| `roleAssignments`     | `array`  | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |

## Outputs

| Name     | Type   | Description   |
| :------- | :----: | :------------ |
| name     | string | Resource Name |
| id       | string | Resource Id   |
| endpoint | string | Endpoint      |

## Examples

### Example 1

Deploying a minimally configured Speech Service.

```
module speechService 'br/public:cognitiveservices/speech:1.0.0' = {
  name: 'cog-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: location
    name: 'cog-${uniqueString(deployment().name, location)}'
  }
}

output speechServiceEndpoint string = speechService.outputs.endpoint
```

### Example 2

Deploying a Speech Service with role assignments.

```
module speechService 'br/public:cognitiveservices/speech:1.0.0' = {
  name: 'cog-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: location
    name: 'cog-${uniqueString(deployment().name, location)}'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech User'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0e75ca1e-0464-4b4d-8b93-68208a576181') // Cognitive Services Speech Contributor
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
  }
}

output speechServiceEndpoint string = speechService.outputs.endpoint
```