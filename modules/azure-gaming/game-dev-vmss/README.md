# Azure Game Developer VMSS

Azure Game Developer VMSS Bicep registry module

## Parameters

| Name       | Type     | Required | Description                       |
| :--------- | :------: | :------: | :-------------------------------- |
| `vmssName` | `string` | Yes      | The name of someone to say hi to. |

## Examples

### Using the Azure Game Developer VMSS module

```bicep
module gameDevVMSS 'br/public:azure-gaming/game-dev-vmss:1.0.0' = {
  name: 'gameDevVMSS'
  params: {
    vmssName: 'vmssPool'
  }
}
```
