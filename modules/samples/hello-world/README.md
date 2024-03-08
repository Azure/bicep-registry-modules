<h1 style="color: steelblue;">⚠️ Upcoming changes ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-upcoming-changes-%EF%B8%8F).

# Hello World

A "שָׁלוֹם עוֹלָם" sample Bicep registry module

## Details

{{ Add detailed description for the module. }}

## Parameters

| Name   | Type     | Required | Description                       |
| :----- | :------: | :------: | :-------------------------------- |
| `name` | `string` | Yes      | The name of someone to say hi to. |

## Outputs

| Name       | Type     | Description        |
| :--------- | :------: | :----------------- |
| `greeting` | `string` | The hello message. |

## Examples

### Using the hello world module

```bicep
module helloWorld 'br/public:samples/hello-world:1.0.4' = {
  name: 'helloWorld'
  params: {
    name: 'Bicep developers'
  }
}

output greeting string = helloWorld.outputs.greeting
```
