# Function App Pattern `[Web/FunctionApp]`

> [!IMPORTANT]
> This README is a placeholder created when the module was scaffolded. Run `utilities/tools/Set-AVMModule.ps1 -ModuleFolderPath 'avm/ptn/web/function-app'` from a machine with access to `mcr.microsoft.com` to regenerate this file (and `main.json`) from `main.bicep`.

Deploys an Azure Function App together with its supporting resources: an App Service Plan, a Storage Account for the Function runtime, and an Application Insights component (with an optional Log Analytics workspace). When `enableWafAlignment` is set to `true`, the module additionally provisions a Key Vault, a Virtual Network and Private Endpoints for the Function App, Storage Account and Key Vault, configures VNet integration, system-assigned managed identity and HTTPS-only / TLS 1.2 enforcement.

You can reference the module as follows:

```bicep
module functionApp 'br/public:avm/ptn/web/function-app:<version>' = {
  params: { /* ... */ }
}
```

For examples, please refer to the module's `tests/e2e` folder.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Cross-referenced modules

This module composes the following AVM resource modules:

| Module | Reference |
| :-- | :-- |
| `avm/res/web/site` | `br/public:avm/res/web/site:0.23.0` |
| `avm/res/web/serverfarm` | `br/public:avm/res/web/serverfarm:0.7.0` |
| `avm/res/storage/storage-account` | `br/public:avm/res/storage/storage-account:0.32.0` |
| `avm/res/insights/component` | `br/public:avm/res/insights/component:0.7.1` |
| `avm/res/operational-insights/workspace` | `br/public:avm/res/operational-insights/workspace:0.15.1` |
| `avm/res/key-vault/vault` | `br/public:avm/res/key-vault/vault:0.13.3` |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
