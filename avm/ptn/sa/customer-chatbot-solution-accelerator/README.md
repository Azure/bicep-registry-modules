# Customer Chatbot Solution Accelerator `[Sa/CustomerChatbotSolutionAccelerator]`

This module deploys the Customer Chatbot Solution Accelerator.

|**Post-Deployment Step** |
|-------------|
| After completing the deployment, follow the steps in the Post-Deployment Guide to configure and verify your environment. |

> **Note:** This module is not intended for broad, generic use, as it was designed by the Commercial Solution Areas CTO team, as a Microsoft Solution Accelerator. Feature requests and bug fix requests are welcome if they support the needs of this organization but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case. This module will likely be updated to leverage AVM resource modules in the future. This may result in breaking changes in upcoming versions when these features are implemented.


You can reference the module as follows:
```bicep
module customerChatbot 'br/public:avm/ptn/sa/customer-chatbot-solution-accelerator:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/sa/customer-chatbot-solution-accelerator:<version>`.

- **Example 1: Sandbox**

<details>

<summary>via Bicep module</summary>

```bicep
module customerChatbotSolutionAccelerator 'br/public:avm/ptn/sa/customer-chatbot-solution-accelerator:<version>' = {
  name: 'customerChatbotSolutionAcceleratorDeployment'
  params: {
    // Required parameters
    name: 'customer-chatbot'
    location: '<location>'
  }
}
```

</details>
<p>

- **Example 2: WAF-Aligned**

<details>

<summary>via Bicep module</summary>

```bicep
module customerChatbotSolutionAccelerator 'br/public:avm/ptn/sa/customer-chatbot-solution-accelerator:<version>' = {
  name: 'customerChatbotSolutionAcceleratorDeployment'
  params: {
    // Required parameters
    name: 'customer-chatbot'
    location: '<location>'
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the solution. |
| [`location`](#parameter-location) | string | The Azure region where the resources will be deployed. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the solution.

- Required: Yes
- Type: string

### Parameter: `location`

The Azure region where the resources will be deployed.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `true`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceGroupName` | string | The name of the resource group the module was deployed to. |
| `name` | string | The name of the solution. |
| `location` | string | The location the module was deployed to. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep Registry or Template Specs modules that are referenced in this module).

| Reference | Type |
| :-- | :-- |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
