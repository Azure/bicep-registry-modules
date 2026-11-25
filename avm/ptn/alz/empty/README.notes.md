
For Custom Policy Set Definitions, the property of `properties.policyDefinitions.policyDefinitionId` for each child policy definition in a policy set definition must be provided. If you are trying to provide the ID of a policy definition that you are also creating in this module, or it exists at the same management group scope, you can use the following input syntax to ensure the correct resource ID for the policy definition is used:

```bicep
{customPolicyDefinitionScopeId}/providers/Microsoft.Authorization/policyDefinitions/<policy-definition-name>
```

The `{customPolicyDefinitionScopeId}` is replaced by resource ID of the management group that this module is creating or deploying to. This will ensure that the correct resource ID is used for the policy definition without you having to hardcode the management group ID in the policy set definitions.

