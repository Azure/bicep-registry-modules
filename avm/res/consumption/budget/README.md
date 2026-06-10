# Consumption Budgets (Multi-Scope) `[Microsoft.Consumption/budgets]`

This module's child-modules deploy a Consumption Budget at a Management Group (mg-scope), Subscription (sub-scope) or Resource Group (rg-scope) scope.

> While this template is **not** published, you can find the actual published modules in the subfolders
> - `mg-scope`
> - `sub-scope`
> - `rg-scope`


You can reference the module as follows:
```bicep
module budget 'br/public:avm/res/consumption/budget:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

_None_

## Usage examples

**Note**: This is a multi-scoped module. This means, you will find the 'Usage Examples' in the documentation of the correspondingly scoped child modules:
- `/mg-scope/README.md`
- `/rg-scope/README.md`
- `/sub-scope/README.md`

## Parameters

_None_

## Outputs

_None_
