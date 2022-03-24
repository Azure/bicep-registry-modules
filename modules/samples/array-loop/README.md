# Array Loop

A sample Bicep registry module demonstrating array iterations.

## Parameters

| Name    | Type    | Required | Description                |
| :------ | :-----: | :------: | :------------------------- |
| `names` | `array` | No       | An array containing names. |

## Outputs

| Name            | Type  | Description                                                          |
| :-------------- | :---: | :------------------------------------------------------------------- |
| namesByVariable | array | An output demonstrating iterating array items with an item variable. |
| out3            | array | An output demonstrating iterating array items with an index.         |

## Examples

### Using the module

```bicep
module arrayLoop 'br/public:samples/array-loop' = {
  name: 'arrayLoop'
}
```