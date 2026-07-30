targetScope = 'subscription'

// This module supports both subscription and resource group scope deployments
// Use the deploymentScope parameter to specify which scope to use
metadata name = 'Microsoft Edge Site (Multi-Scope)'
metadata description = '''
This module's child-modules deploy a Microsoft Edge Site at a Subscription (sub-scope) or Resource Group (rg-scope) scope.

> While this template is **not** published, you can find the actual published modules in the subfolders
> - `sub-scope`
> - `rg-scope`

'''
