
This module requires prerequisites, that can't be done via ARM/Bicep directly.

### Required Azure Role Assignments

To successfully deploy and manage Azure Stack HCI clusters, ensure the following service principals have the appropriate role assignments at the subscription level:

#### 1. Service Principal Permissions

The service principal referenced as `CI-arbDeploymentAppId` in the Key Vault must have the following roles assigned:

- **Contributor** - For resource operations
- **Reader** - For read access to resources
- **Azure Connected Machine Onboarding** - For onboarding Azure Arc-enabled servers
- **Azure Connected Machine Resource Administrator** - For managing Arc-enabled server resources
- **Key Vault Secrets Officer** - For managing Key Vault secrets
- **User Access Administrator** - For managing role assignments

#### 2. Microsoft.AzureStackHCI Resource Provider Permissions

The Microsoft.AzureStackHCI Resource Provider must have the following role assigned:

- **Azure Connected Machine Resource Manager** - Required for extension reconciliation and hybrid compute operations

To find the correct service principal for role assignment:

1. Use the client ID `1412d89f-b8a8-4111-b4fd-e82905cbd85d` to locate the Microsoft.AzureStackHCI service principal

2. Use the Object ID of this service principal for role assignment

