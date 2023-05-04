# Managed Identity

Azure managed identities provide an easy way for applications to access resources securely in Azure.

## Description

Azure managed identities provide an easy way for applications to access resources securely in Azure. It enables you to authenticate to Azure Active Directory without the need to manage credentials.
Ref: [https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview)

## Parameters

| Name       | Type     | Required | Description                                                                                         |
| :--------- | :------: | :------: | :-------------------------------------------------------------------------------------------------- |
| `name`     | `string` | Yes      | Required. Name of User Assigned Identity.                                                           |
| `location` | `string` | Yes      | Required. Define the Azure Location that the Azure User Assigned Identity should be created within. |
| `tags`     | `object` | No       | Optional. Tags for Azure User Assigned Identity                                                     |
| `roles`    | `array`  | No       | Optional. roles list which will create roleAssignment for userAssignedIdentities.                   |

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
```

### Example 2

```bicep
```