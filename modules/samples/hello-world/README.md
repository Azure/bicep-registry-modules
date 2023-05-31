# Hello World

A "Hello World" sample Bicep registry module

## Description

{{ Add detailed description for the module. }}

## Parameters

| Name   | Type     | Required | Description                       |
| :----- | :------: | :------: | :-------------------------------- |
| `name` | `string` | Yes      | The name of someone to say hi to. |

## Outputs

| Name     | Type   | Description        |
| :------- | :----: | :----------------- |
| greeting | string | The hello message. |

## Examples

### Using the hello world module

```bicep
module helloWorld 'br/public:samples/hello-world:1.0.1' = {
  name: 'helloWorld'
  params: {
    name: 'Bicep developers'
  }
}

output greeting string = helloWorld.outputs.greeting
```