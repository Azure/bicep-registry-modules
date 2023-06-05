# Managed Identity

Azure managed identities provide an easy way for applications to access resources securely in Azure.

## Description

Azure managed identities provide an easy way for applications to access resources securely in Azure. It enables you to authenticate to Azure Active Directory without the need to manage credentials.
Ref: [https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

## Parameters

| Name                   | Type     | Required | Description                                                                                         |
| :--------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------- |
| `prefix`               | `string` | No       | Prefix of User Assigned Identity Resource Name. This param is ignored when name is provided.        |
| `name`                 | `string` | No       | Required. Name of User Assigned Identity.                                                           |
| `location`             | `string` | Yes      | Required. Define the Azure Location that the Azure User Assigned Identity should be created within. |
| `tags`                 | `object` | No       | Optional. Tags for Azure User Assigned Identity                                                     |
| `federatedCredentials` | `array`  | No       | Optional. List of federatedCredentials to be configured with Managed Identity, default set to []    |
| `roles`                | `array`  | No       | Optional. roles list which will create roleAssignment for userAssignedIdentities, default set to [] |

## Outputs

| Name        | Type   | Description                                                                             |
| :---------- | :----: | :-------------------------------------------------------------------------------------- |
| id          | string | Id of the User Assigned Identity created.                                               |
| name        | string | Name of the User Assigned Identity created.                                             |
| principalId | string | The id of the service principal object associated with the created identity.            |
| tenantId    | string | The id of the tenant which the identity belongs to.                                     |
| clientId    | string | The id of the app associated with the identity. This is a random generated UUID by MSI. |

## Examples

### Example 1

```bicep
@description('Simple example, only creates Managed Identity.')
module managedIdentity 'br/public:identity/user-assigned-identity:1.0.1' = {
  name: 'test-${name}'
  params: {
    name: 'my-managedIdentity-1'
    location: location
    tags: tags
  }
}
```

### Example 2

```bicep
@description('''
In example, It will create Managed Identity, assign given role assignments at resource Group level,
lastly also creates Federated credentials as per given input list of federatedCredentials array param.
''')
module managedIdentity 'br/public:identity/user-assigned-identity:1.0.1' = {
  name: 'test-${name}'
  params: {
    name: 'my-managedIdentity-2'
    location: location
    tags: tags
    roles: [
      {
        name: 'Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        principalType: 'ServicePrincipal'
      }
      {
        name: 'Azure Kubernetes Service RBAC Admin'
        roleDefinitionId: '3498e952-d568-435e-9b2c-8d77e338d7f7'
        principalType: 'ServicePrincipal'
      }
    ]
    federatedCredentials: [
      {
        name: take(replace('federatedCredential-github-test2-${name}', '.', '-'), 5)
        issuer: 'https://token.actions.githubusercontent.com'
        subject: 'repo:Azure/https://github.com/Azure/bicep-registry-modules:ref:refs/heads/main'
        audiences: [
          'api://AzureADTokenExchange'
        ]
      }
      {
        name: take(replace('federatedCredential-aks-test2-${name}', '.', '-'), 5)
        issuer: 'https://cluster.issuer.url/xxxxx/xxxxx/'
        subject: 'system:serviceaccount:mynamespace-name:myserviceaccount-name'
        audiences: [
          'api://AzureADTokenExchange'
        ]
      }
    ]
  }
}
```