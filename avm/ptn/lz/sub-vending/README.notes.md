
- The `Microsoft.Subscription/aliases/write` action is required at the `/` (tenant) scope as this is where the API operates, as per [Microsoft.Subscription aliases template reference documentation](https://learn.microsoft.com/azure/templates/microsoft.subscription/aliases?pivots=deployment-language-bicep#bicep-resource-definition)
  - You may need to elevate to User Access Administrator role to be able to assign the relevant role to the identity you wish to be able to create the subscription at the `/` (tenant) scope, as per [Elevate access to manage all Azure subscriptions and management groups](https://learn.microsoft.com/azure/role-based-access-control/elevate-access-global-admin)

