#

## Description
Creates SSH key pair and stores them in provided AKV.

{{ Add detailed description for the module. }}

## Parameters

| Name | Type  | Required | Description |
| :--- | :---: | :------: | :---------- |

## Outputs

| Name | Type  | Description |
| :--- | :---: | :---------- |

## Examples

### Example 1

```bicep
// Test with new managed identity
module test0 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
  name: 'test0-${uniqueString(name)}'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    sshKeyName: 'first-key'
  }
}


```

### Example 2

```bicep
// Test with existing managed identity
module test1 'br/public:deployment-scripts/aks-run-command:1.0.1' = {
  dependsOn: [
    test0
  ]
  name: 'test1-${uniqueString(name)}'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    sshKeyName: 'second-key'
    existingManagedIdentityResourceGroupName: resourceGroup().name
    useExistingManagedIdentity: true
    managedIdentityName: prereq.outputs.identityName
    existingManagedIdentitySubId: subscription().subscriptionId
  }
}
```