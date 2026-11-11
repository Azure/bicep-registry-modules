
### Considerations

This template is using a **Tenant level deployment**, meaning the user/principal deploying it needs to have the [proper access](https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/deploy-to-tenant#required-access)

If owner access is excessive, the following rights roles will grant enough rights:

- **Automation Job Operator** at **tenant** level (scope '/')
- **Management Group Contributor** at the top management group that needs to be managed

Consider using the following script:

```powershell
$PrincipalID = "<The object ID of the identity here>"
$TopMGID = "<The group ID of the management group here>"
New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/" -RoleDefinitionName "Automation Job Operator"
New-AzRoleAssignment -ObjectId $PrincipalID -Scope "/providers/Microsoft.Management/managementGroups/$TopMGID" -RoleDefinitionName "Management Group Contributor"
```

