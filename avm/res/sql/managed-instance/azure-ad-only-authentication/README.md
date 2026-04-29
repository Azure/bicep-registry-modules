# SQL Managed Instance Azure AD Only Authentications `[Microsoft.Sql/managedInstances/azureADOnlyAuthentications]`

This module deploys a SQL Managed Instance Azure AD Only Authentication setting.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Sql/managedInstances/azureADOnlyAuthentications` | 2024-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.sql_managedinstances_azureadonlyauthentications.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2024-05-01-preview/managedInstances/azureADOnlyAuthentications)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureADOnlyAuthentication`](#parameter-azureadonlyauthentication) | bool | Whether Azure Active Directory-only authentication is enabled. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

### Parameter: `azureADOnlyAuthentication`

Whether Azure Active Directory-only authentication is enabled.

- Required: Yes
- Type: bool

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed Azure AD Only Authentication resource. |
| `resourceGroupName` | string | The resource group of the deployed Azure AD Only Authentication resource. |
| `resourceId` | string | The resource ID of the deployed Azure AD Only Authentication resource. |
