# IaaS VM with CosmosDB Tier 4 `[App/IaasVmCosmosdbTier4]`

Creates an IaaS VM with CosmosDB Tier 4 resiliency configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Automanage/configurationProfileAssignments` | [2022-05-04](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automanage/2022-05-04/configurationProfileAssignments) |
| `Microsoft.Compute/disks` | [2024-03-02](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-03-02/disks) |
| `Microsoft.Compute/sshPublicKeys` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/sshPublicKeys) |
| `Microsoft.Compute/virtualMachines` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2024-07-01/virtualMachines) |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |
| `Microsoft.DevTestLab/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/schedules) |
| `Microsoft.DocumentDB/databaseAccounts` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/gremlinDatabases/graphs) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/mongodbDatabases/collections) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases) |
| `Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlDatabases/containers) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleAssignments) |
| `Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/sqlRoleDefinitions) |
| `Microsoft.DocumentDB/databaseAccounts/tables` | [2024-11-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-11-15/databaseAccounts/tables) |
| `Microsoft.GuestConfiguration/guestConfigurationAssignments` | [2020-06-25](https://learn.microsoft.com/en-us/azure/templates/Microsoft.GuestConfiguration/2020-06-25/guestConfigurationAssignments) |
| `Microsoft.Insights/dataCollectionRuleAssociations` | [2023-03-11](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-03-11/dataCollectionRuleAssociations) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.KeyVault/vaults/secrets` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets) |
| `Microsoft.Maintenance/configurationAssignments` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2024-11-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities) |
| `Microsoft.Network/loadBalancers` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers) |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers/backendAddressPools) |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers/inboundNatRules) |
| `Microsoft.Network/networkInterfaces` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/networkInterfaces) |
| `Microsoft.Network/networkSecurityGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups) |
| `Microsoft.Network/privateDnsZones` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones) |
| `Microsoft.Network/privateDnsZones/A` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A) |
| `Microsoft.Network/privateDnsZones/AAAA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA) |
| `Microsoft.Network/privateDnsZones/CNAME` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME) |
| `Microsoft.Network/privateDnsZones/MX` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX) |
| `Microsoft.Network/privateDnsZones/PTR` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR) |
| `Microsoft.Network/privateDnsZones/SOA` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA) |
| `Microsoft.Network/privateDnsZones/SRV` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV) |
| `Microsoft.Network/privateDnsZones/TXT` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT) |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2024-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks) |
| `Microsoft.Network/privateEndpoints` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |
| `Microsoft.Network/publicIPAddresses` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworks` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.RecoveryServices/vaults` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-04-01/vaults) |
| `Microsoft.RecoveryServices/vaults/backupconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupconfig) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-10-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupFabrics/protectionContainers/protectedItems) |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | [2024-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2024-10-01/vaults/backupPolicies) |
| `Microsoft.RecoveryServices/vaults/backupstorageconfig` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupstorageconfig) |
| `Microsoft.RecoveryServices/vaults/replicationAlertSettings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationAlertSettings) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers) |
| `Microsoft.RecoveryServices/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationFabrics/replicationProtectionContainers/replicationProtectionContainerMappings) |
| `Microsoft.RecoveryServices/vaults/replicationPolicies` | [2023-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-06-01/vaults/replicationPolicies) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |
| `Microsoft.Storage/storageAccounts` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers/immutabilityPolicies) |
| `Microsoft.Storage/storageAccounts/fileServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices) |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices/shares) |
| `Microsoft.Storage/storageAccounts/localUsers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers) |
| `Microsoft.Storage/storageAccounts/managementPolicies` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies) |
| `Microsoft.Storage/storageAccounts/queueServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices) |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues) |
| `Microsoft.Storage/storageAccounts/tableServices` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices) |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/app/iaas-vm-cosmosdb-tier4:<version>`.

- [Using only defaults](#example-1-using-only-defaults)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module iaasVmCosmosdbTier4 'br/public:avm/ptn/app/iaas-vm-cosmosdb-tier4:<version>' = {
  name: 'iaasVmCosmosdbTier4Deployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    encryptionAtHost: false
    location: '<location>'
    tags: {
      Application: 'IaaSVMCosmosDB'
      CostCenter: 'IT'
      Environment: 'Test'
      Owner: 'TeamName'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "encryptionAtHost": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "Application": "IaaSVMCosmosDB",
        "CostCenter": "IT",
        "Environment": "Test",
        "Owner": "TeamName"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/app/iaas-vm-cosmosdb-tier4:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param encryptionAtHost = false
param location = '<location>'
param tags = {
  Application: 'IaaSVMCosmosDB'
  CostCenter: 'IT'
  Environment: 'Test'
  Owner: 'TeamName'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the solution which is used to generate unique resource names. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

**General parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tags`](#parameter-tags) | object | Tags for all resources. Should include standard tags like Environment, Owner, CostCenter, etc. |

**Security parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminUsername`](#parameter-adminusername) | string | Admin username for the virtual machine. |
| [`applicationNsgRules`](#parameter-applicationnsgrules) | array | Network security group rules for the application subnet. |
| [`encryptionAtHost`](#parameter-encryptionathost) | bool | Enables encryption at host for the virtual machine. |
| [`sshPublicKey`](#parameter-sshpublickey) | securestring | SSH public key for the virtual machine. If empty, a new SSH key will be generated. |
| [`vmNsgRules`](#parameter-vmnsgrules) | array | Network security group rules for the VM. |

**Networking parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loadBalancerConfiguration`](#parameter-loadbalancerconfiguration) | object | Load balancer configuration. |
| [`subnets`](#parameter-subnets) | array | Subnet configuration for the virtual network. |
| [`virtualMachineNicConfigurations`](#parameter-virtualmachinenicconfigurations) | array | Virtual machine NIC configurations. |
| [`vnetAddressPrefix`](#parameter-vnetaddressprefix) | string | Address prefix for the virtual network. |

**Compute parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualMachineImageReference`](#parameter-virtualmachineimagereference) | object | Virtual machine image reference configuration. |
| [`virtualMachineZone`](#parameter-virtualmachinezone) | int | Virtual machine availability zone. Set to 0 for no zone. |
| [`vmSize`](#parameter-vmsize) | string | Size of the virtual machine. |

**Storage parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountConfiguration`](#parameter-storageaccountconfiguration) | object | Storage account SKU configuration. |
| [`virtualMachineOsDisk`](#parameter-virtualmachineosdisk) | object | Virtual machine OS disk configuration. |

**Identity parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualMachineManagedIdentities`](#parameter-virtualmachinemanagedidentities) | object | Virtual machine managed identity configuration. |

### Parameter: `name`

Name of the solution which is used to generate unique resource names.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags for all resources. Should include standard tags like Environment, Owner, CostCenter, etc.

- Required: No
- Type: object
- Example: `System.Management.Automation.OrderedHashtable`

### Parameter: `adminUsername`

Admin username for the virtual machine.

- Required: No
- Type: string
- Default: `'azureuser'`

### Parameter: `applicationNsgRules`

Network security group rules for the application subnet.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'DenyManagementOutbound'
      properties: {
        access: 'Deny'
        destinationAddressPrefix: '*'
        destinationPortRanges: [
          '22'
          '3389'
          '5985'
          '5986'
        ]
        direction: 'Outbound'
        priority: 4000
        protocol: '*'
        sourceAddressPrefix: '*'
        sourcePortRange: '*'
      }
    }
  ]
  ```

### Parameter: `encryptionAtHost`

Enables encryption at host for the virtual machine.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `sshPublicKey`

SSH public key for the virtual machine. If empty, a new SSH key will be generated.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `vmNsgRules`

Network security group rules for the VM.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'HTTP'
      properties: {
        access: 'Allow'
        destinationAddressPrefix: '*'
        destinationPortRange: '80'
        direction: 'Inbound'
        priority: 300
        protocol: 'Tcp'
        sourceAddressPrefix: 'VirtualNetwork'
        sourcePortRange: '*'
      }
    }
    {
      name: 'DenyManagementOutbound'
      properties: {
        access: 'Deny'
        destinationAddressPrefix: '*'
        destinationPortRanges: [
          '22'
          '3389'
          '5985'
          '5986'
        ]
        direction: 'Outbound'
        priority: 4000
        protocol: '*'
        sourceAddressPrefix: '*'
        sourcePortRange: '*'
      }
    }
  ]
  ```

### Parameter: `loadBalancerConfiguration`

Load balancer configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      backendPort: 80
      frontendPort: 80
  }
  ```

### Parameter: `subnets`

Subnet configuration for the virtual network.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      addressPrefix: '10.0.0.0/24'
      name: 'snet-application'
    }
    {
      addressPrefix: '10.0.1.0/24'
      name: 'snet-privateendpoints'
    }
    {
      addressPrefix: '10.0.2.0/24'
      name: 'snet-bootdiagnostics'
    }
    {
      addressPrefix: '10.0.3.0/26'
      name: 'AzureBastionSubnet'
    }
  ]
  ```

### Parameter: `virtualMachineNicConfigurations`

Virtual machine NIC configurations.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      deleteOption: 'Delete'
      ipConfigurations: [
        {
          name: 'ipconfig1'
        }
      ]
      name: 'primary-nic'
    }
  ]
  ```

### Parameter: `vnetAddressPrefix`

Address prefix for the virtual network.

- Required: No
- Type: string
- Default: `'10.0.0.0/16'`

### Parameter: `virtualMachineImageReference`

Virtual machine image reference configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      offer: 'ubuntu-24_04-lts'
      publisher: 'canonical'
      sku: 'server'
      version: 'latest'
  }
  ```

### Parameter: `virtualMachineZone`

Virtual machine availability zone. Set to 0 for no zone.

- Required: No
- Type: int
- Default: `1`

### Parameter: `vmSize`

Size of the virtual machine.

- Required: No
- Type: string
- Default: `'Standard_D2s_v3'`

### Parameter: `storageAccountConfiguration`

Storage account SKU configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: 'Standard_GRS'
      tier: 'Standard'
  }
  ```

### Parameter: `virtualMachineOsDisk`

Virtual machine OS disk configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      caching: 'ReadWrite'
      createOption: 'FromImage'
      diskSizeGB: 30
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
  }
  ```

### Parameter: `virtualMachineManagedIdentities`

Virtual machine managed identity configuration.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      systemAssigned: true
  }
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `cosmosDbResourceId` | string | Resource. The resource ID of the CosmosDB MongoDB vCore cluster. |
| `loadBalancerResourceId` | string | Resource. The resource ID of the load balancer. |
| `name` | string | Resource. The name of the virtual machine. |
| `resourceGroupName` | string | Resource. Resource Group Name. |
| `resourceId` | string | Resource. The resource ID. |
| `storageAccountResourceId` | string | Resource. The resource ID of the storage account. |
| `storagePrivateEndpointResourceId` | string | Resource. The resource ID of the storage private endpoint. |
| `virtualMachineResourceId` | string | Resource. The resource ID of the virtual machine. |
| `virtualNetworkResourceId` | string | Resource. The resource ID of the virtual network. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/compute/virtual-machine:0.15.0` | Remote reference |
| `br/public:avm/res/document-db/database-account:0.15.0` | Remote reference |
| `br/public:avm/res/network/load-balancer:0.4.2` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.7.1` | Remote reference |
| `br/public:avm/res/network/private-endpoint:0.11.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |
| `br/public:avm/res/recovery-services/vault:0.9.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.22.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
