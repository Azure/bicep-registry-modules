# CognitiveServices

This module deploys CognitiveServices (Microsoft.CognitiveServices/accounts) and optionally available integrations.

## Description

The Bicep module deploys an Azure Cognitive Service to a specified location, allowing customization of parameters such as service type, name, tags, and network access settings. It supports advanced features like private endpoints, RBAC role assignments, and user-owned storage, providing a flexible and comprehensive solution for deploying and configuring Azure Cognitive Services.

## Parameters

| Name                            | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :------------------------------ | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `kind`                          | `string` | No       | The kind of Cognitive Service to create. See: https://learn.microsoft.com/en-us/azure/cognitive-services/create-account-bicep for available kinds.                                                                                                                                                                                                                                           |
| `prefix`                        | `string` | No       | Prefix of Resource Name. Not used if name is provided                                                                                                                                                                                                                                                                                                                                        |
| `location`                      | `string` | No       | The location into which your Azure resources should be deployed.                                                                                                                                                                                                                                                                                                                             |
| `name`                          | `string` | No       | The name of the Cognitive Service.                                                                                                                                                                                                                                                                                                                                                           |
| `tags`                          | `object` | No       | The tags to apply to each resource.                                                                                                                                                                                                                                                                                                                                                          |
| `customSubDomainName`           | `string` | No       | A custom subdomain to reach the Cognitive Service.                                                                                                                                                                                                                                                                                                                                           |
| `publicNetworkAccess`           | `bool`   | No       | The Public Network Access setting of the Cognitive Service. When false, only requests from Private Endpoints can access it.                                                                                                                                                                                                                                                                  |
| `privateEndpoints`              | `array`  | No       | A list of private endpoints to connect to the Cognitive Service.                                                                                                                                                                                                                                                                                                                             |
| `skuName`                       | `string` | No       | The name of the SKU. Be aware that not all SKUs may be available for your Subscription. See: https://learn.microsoft.com/en-us/rest/api/cognitiveservices/accountmanagement/resource-skus                                                                                                                                                                                                    |
| `roleAssignments`               | `array`  | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |
| `identityType`                  | `string` | No       | The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.                                                                                                                                      |
| `userAssignedIdentities`        | `object` | No       | The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"                                                                                                               |
| `lock`                          | `string` | No       | Specify the type of lock on Cosmos DB account resource.                                                                                                                                                                                                                                                                                                                                      |
| `apiProperties`                 | `object` | No       | The api properties for special APIs. More info: https://learn.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts?pivots=deployment-language-bicep#apiproperties                                                                                                                                                                                                        |
| `disableLocalAuth`              | `bool`   | No       | Indicates whether requests using non-AAD authentication are blocked                                                                                                                                                                                                                                                                                                                          |
| `dynamicThrottlingEnabled`      | `bool`   | No       | Enables rate limiting autoscale feature. Requires paid subscription. https://learn.microsoft.com/en-us/azure/cognitive-services/autoscale                                                                                                                                                                                                                                                    |
| `encryption`                    | `object` | No       | The encryption settings of the Cognitive Service.                                                                                                                                                                                                                                                                                                                                            |
| `locations`                     | `object` | No       | The multiregion settings of Cognitive Services account.                                                                                                                                                                                                                                                                                                                                      |
| `networkAcls`                   | `object` | No       | A collection of rules governing the accessibility from specific network locations.                                                                                                                                                                                                                                                                                                           |
| `migrationToken`                | `string` | No       | The migration token for the Cognitive Service.                                                                                                                                                                                                                                                                                                                                               |
| `restore`                       | `bool`   | No       | Specifies whether to a soft-deleted Cognitive Service should be restored. If false, the Cognitive Service needs to be purged before another with the same name can be created.                                                                                                                                                                                                               |
| `restrictOutboundNetworkAccess` | `bool`   | No       | Set this to true for data loss prevention. Will block all outbound traffic except to allowedFqdnList. https://learn.microsoft.com/en-us/azure/cognitive-services/cognitive-services-data-loss-prevention                                                                                                                                                                                     |
| `allowedFqdnList`               | `array`  | No       | List of allowed FQDNs(Fully Qualified Domain Name) for egress from the Cognitive Service.                                                                                                                                                                                                                                                                                                    |
| `userOwnedStorage`              | `array`  | No       | The user owned storage accounts for the Cognitive Service.                                                                                                                                                                                                                                                                                                                                   |
| `deployments`                   | `array`  | No       | The deployments for Cognitive Services that support them. See: https://docs.microsoft.com/en-us/azure/templates/microsoft.cognitiveservices/accounts/deployments for available properties.                                                                                                                                                                                                   |

## Outputs

| Name       | Type     | Description   |
| :--------- | :------: | :------------ |
| `name`     | `string` | Resource Name |
| `id`       | `string` | Resource Id   |
| `endpoint` | `string` | Endpoint      |

## Examples

### Example 1

Deploys a SpeechService Cognitive Service

```bicep
module speechService 'br/public:ai/cognitiveservices:1.0.2' = {
  name: 'speechService'
  params: {
    kind: 'SpeechServices'
    skuName: 'S0'
    name: 'speech-${uniqueString(resourceGroup().id, location)}'
    location: location
  }
}
```

### Example 2

Deploys an OpenAI Cognitive Service with a model deployment

```bicep
module openAI 'br/public:ai/cognitiveservices:1.0.2' = {
  name: 'openai'
  params: {
    skuName: 'S0'
    kind: 'OpenAI'
    name: 'openai-${uniqueString(resourceGroup().id, location)}'
    location: location
    deployments: [
      {
        name: 'model-deployment-${uniqueString(resourceGroup().id, location)}'
        sku: {
          name: 'Standard'
          capacity: 120
        }
        properties: {
          model: {
            format: 'OpenAI'
            name: 'text-davinci-002'
            version: 1
          }
          raiPolicyName: 'Microsoft.Default'
        }
      }
    ]
  }
}
```

### Example 3

Deploys a Content Moderator Cognitive Service

```bicep
module contentModerator 'br/public:ai/cognitiveservices:1.0.2' = {
  name: 'contentModerator'
  params: {
    skuName: 'S0'
    kind: 'ContentModerator'
    name: 'cm-${uniqueString(resourceGroup().id, location)}'
    location: location
  }
}
```

### Example 4

Deploys a Speech Service with role assignments and private endpoints

```bicep
module speechService 'br/public:ai/cognitiveservices:1.0.2' = {
  name: 'test-04-speech'
  params: {
    name: 'test-04-speech-${uniqueName}'
    kind: 'SpeechServices'
    skuName: 'S0'
    location: location
    publicNetworkAccess: false
    customSubDomainName: 'test02service'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech Contributor'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech User'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
   ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
        groupId: 'account'
      }
    ]
  }
}
```