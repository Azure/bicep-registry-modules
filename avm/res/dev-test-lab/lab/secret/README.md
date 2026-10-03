# DevTest Lab Secrets `[Microsoft.DevTestLab/labs]`

This module deploys a DevTest Lab Secret.

Lab secrets will be accessible to all lab users. Depending on their scope, secrets can be used to securely provide credentials when creating formulas, virtual machines, artifacts, or ARM templates.

You can reference the module as follows:
```bicep
module lab 'br/public:avm/res/dev-test-lab/lab/secret:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DevTestLab/labs/secrets` | 2018-10-15-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_labs_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/labs)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the secret. Secret names can only contain alphanumeric characters and dashes. |
| [`value`](#parameter-value) | securestring | The value of the secret. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabledForArtifacts`](#parameter-enabledforartifacts) | bool | Set a secret for your artifacts (e.g., a personal access token to clone your Git repository via an artifact). At least one of the following must be true: enabledForArtifacts, enabledForVmCreation. |
| [`enabledForVmCreation`](#parameter-enabledforvmcreation) | bool | Set a user password or provide an SSH public key to access your Windows or Linux virtual machines. At least one of the following must be true: enabledForArtifacts, enabledForVmCreation. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

### Parameter: `name`

The name of the secret. Secret names can only contain alphanumeric characters and dashes.

- Required: Yes
- Type: string

### Parameter: `value`

The value of the secret.

- Required: Yes
- Type: securestring

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enabledForArtifacts`

Set a secret for your artifacts (e.g., a personal access token to clone your Git repository via an artifact). At least one of the following must be true: enabledForArtifacts, enabledForVmCreation.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enabledForVmCreation`

Set a user password or provide an SSH public key to access your Windows or Linux virtual machines. At least one of the following must be true: enabledForArtifacts, enabledForVmCreation.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secret. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secret. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
