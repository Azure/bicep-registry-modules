# Azure App Configuration

Bicep module for simplified deployment Azure App Configuration resources and optionally available integrations.

## Description

This Bicep Module simplifies the deployment of a Azure App Configuration resource by providing a reusable set of parameters and resources. It allows for the creation of a new resource with all supported parameters and offers configuration options such as geo-replication,  key based data encryption. It also supports adding private endpoints and role assignments.

## Parameters

| Name                             | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                       | `string` | No       | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.. Default is the location of the resource group.                                                                                                                                                                                                                         |
| `prefix`                         | `string` | No       | Prefix of appconf resource name. Not used if name is provided.                                                                                                                                                                                                                                                                                                                               |
| `name`                           | `string` | No       | Specifies the name of the App Configuration instance. Changing this forces a new resource to be created. It must me unique across Azure. Valid characters: Alphanumerics,underscores, and hyphens.                                                                                                                                                                                           |
| `skuName`                        | `string` | No       | The SKU name of the configuration store.                                                                                                                                                                                                                                                                                                                                                     |
| `createMode`                     | `string` | No       | Indicates whether the configuration store need to be recovered.                                                                                                                                                                                                                                                                                                                              |
| `softDeleteRetentionInDays`      | `int`    | No       | The amount of time in days that the configuration store will be retained when it is soft deleted.  This field only works for "Standard" sku.                                                                                                                                                                                                                                                 |
| `publicNetworkAccess`            | `string` | No       | The Public Network Access setting of the App Configuration store. When Disabled, only requests from Private Endpoints can access the App Configuration store.                                                                                                                                                                                                                                |
| `disableLocalAuth`               | `bool`   | No       | Disables all authentication methods other than AAD authentication.                                                                                                                                                                                                                                                                                                                           |
| `enablePurgeProtection`          | `bool`   | No       | Enables the purge protection feature for the configuration store.  This field only works for "Standard" sku.                                                                                                                                                                                                                                                                                 |
| `appConfigurationStoreKeyValues` | `array`  | No       | List of key-value pair to add in the appConfiguration.                                                                                                                                                                                                                                                                                                                                       |
| `appConfigEncryption`            | `object` | No       | The configuration used to encrypt the data in the configuration store.                                                                                                                                                                                                                                                                                                                       |
| `replicas`                       | `array`  | No       | The list of replicas for the configuration store with "name" and "location" parameters.                                                                                                                                                                                                                                                                                                      |
| `tags`                           | `object` | No       | The key-value pair tags to associate with the resource.                                                                                                                                                                                                                                                                                                                                      |
| `identityType`                   | `string` | No       | TSpecifies the type of Managed Service Identity that should be configured on this App Configuration. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities.                                                                                                                                                             |
| `userAssignedIdentities`         | `object` | No       | The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"                                                                                                               |
| `lock`                           | `string` | No       | Specify the type of lock on app conf resource.                                                                                                                                                                                                                                                                                                                                               |
| `roleAssignments`                | `array`  | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |
| `privateEndpoints`               | `array`  | No       | Private Endpoints that should be created for app conf.                                                                                                                                                                                                                                                                                                                                       |
| `diagnosticSettingsProperties`   | `object` | No       | Provide appConfiguration diagnostic settings properties.                                                                                                                                                                                                                                                                                                                                     |

## Outputs

| Name                              | Type   | Description                                                                       |
| :-------------------------------- | :----: | :-------------------------------------------------------------------------------- |
| id                                | string | The resource id of the App Configuration instance.                                |
| name                              | string | The name of the App Configuration instance.                                       |
| systemAssignedIdentityPrincipalId | string | Object Id of system assigned managed identity for app configuration (if enabled). |

## Examples

### Example 1

An example of how to deploy Azure App Configuration resource using the minimum required parameters.

```bicep
module appConfiguration 'br/public:app/app-configuration:1.1.1' = {
  name: 'appconf-${uniqueString(deployment().name, location)}-deployment'
  params: {
    prefix: 'appconf-test01'
    location: location
    skuName: 'Standard'
  }
}

output appConfigurationResourceId string = appConfiguration.outputs.id
```

### Example 2

An example of how to deploy a _Standard_ SKU enabled app configuration along with _role assignments_ access.

```bicep
module appConfiguration 'br/public:app/app-configuration:1.1.1' = {
  name: 'appconf-${uniqueString(deployment().name, location)}-deployment'
  params: {
    prefix: 'appconf-test02'
    location: location
    skuName: 'Standard'
    softDeleteRetentionInDays: 2
    enablePurgeProtection: false
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'App Configuration Data Owner'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
  }
}

output appConfigurationResourceId string = appConfiguration.outputs.id
```

### Example 3

An example of how to deploy app configuration along with multiple geo located _replicas_ and _private endpoints_.

```bicep
module appConfiguration 'br/public:app/app-configuration:1.1.1' = {
  name: 'appconf-${uniqueString(deployment().name, location)}-deployment'
  params: {
    prefix: 'appconf-test03'
    location: location
    skuName: 'Standard'
    publicNetworkAccess: 'Disabled'
    replicas: [
      {
        name: 'centralindia'
        location: 'centralindia'
      }
      {
        name: 'northeurope'
        location: 'northeurope'
      }
    ]
    identityType: 'SystemAssigned'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: false
      }
      {
        name: 'endpoint2'
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
      }
    ]
  }
}

output appConfigurationResourceId string = appConfiguration.outputs.id
output systemAssignedIdentityPrincipalId string = appConfigurationResourceId.outputs.systemAssignedIdentityPrincipalId
```

### Example 4

An example of how to deploy _key based data encryption_ enabled app configuration. Please note `userAssignedIdentity` must have added to keyvault access policies with `get`, `wrapkey` and `unwrapkey` permissions.

```bicep
module appConfiguration 'br/public:app/app-configuration:1.1.1' = {
  name: 'appconf-${uniqueString(deployment().name, location)}-deployment'
  params: {
    prefix: 'appconf-test05'
    location: location
    skuName: 'Standard'
    identityType: 'UserAssigned'
    userAssignedIdentities: {
        "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{managedIdentityName}": {}
    }
    appConfigEncryption: {
      keyIdentifier: 'https://{keyVautName}.vault.azure.net/keys/{keyName}/{keyIdentifierHash}'
      identityClientId: '{userAssigned managedIdentity ClientID}'
    }
  }
}

output appConfigurationResourceId string = appConfiguration.outputs.id
```
