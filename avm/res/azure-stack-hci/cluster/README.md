# Azure Stack HCI Cluster `[Microsoft.AzureStackHCI/clusters]`

This module deploys an Azure Stack HCI Cluster on the provided Arc Machines.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.AzureStackHCI/clusters` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters) |
| `Microsoft.AzureStackHCI/clusters/deploymentSettings` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters/deploymentSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/azure-stack-hci/cluster:<version>`.

- [Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration](#example-1-deploy-azure-stack-hci-cluster-in-azure-with-a-2-node-switched-configuration)
- [Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned](#example-2-deploy-azure-stack-hci-cluster-in-azure-with-a-2-node-switched-configuration-waf-aligned)

### Example 1: _Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration_

This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    deploymentSettings: {
      clusterNodeNames: '<clusterNodeNames>'
      clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
      customLocationName: 'ashc2nmin-location'
      defaultGateway: '172.20.0.1'
      deploymentPrefix: '<deploymentPrefix>'
      dnsServers: [
        '172.20.0.1'
      ]
      domainFqdn: 'hci.local'
      domainOUPath: '<domainOUPath>'
      enableStorageAutoIp: true
      endingIPAddress: '172.20.0.7'
      keyVaultName: '<keyVaultName>'
      networkIntents: [
        {
          adapter: [
            'mgmt'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'management'
          overrideAdapterProperty: true
          overrideQosPolicy: false
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          trafficType: [
            'Management'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
        {
          adapter: [
            'comp0'
            'comp1'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'compute'
          overrideAdapterProperty: true
          overrideQosPolicy: false
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          trafficType: [
            'Compute'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
        {
          adapter: [
            'smb0'
            'smb1'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'storage'
          overrideAdapterProperty: true
          overrideQosPolicy: true
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          trafficType: [
            'Storage'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
      ]
      startingIPAddress: '172.20.0.2'
      storageConnectivitySwitchless: false
      storageNetworks: [
        {
          adapterName: 'smb0'
          vlan: '711'
        }
        {
          adapterName: 'smb1'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
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
    "deploymentSettings": {
      "value": {
        "clusterNodeNames": "<clusterNodeNames>",
        "clusterWitnessStorageAccountName": "<clusterWitnessStorageAccountName>",
        "customLocationName": "ashc2nmin-location",
        "defaultGateway": "172.20.0.1",
        "deploymentPrefix": "<deploymentPrefix>",
        "dnsServers": [
          "172.20.0.1"
        ],
        "domainFqdn": "hci.local",
        "domainOUPath": "<domainOUPath>",
        "enableStorageAutoIp": true,
        "endingIPAddress": "172.20.0.7",
        "keyVaultName": "<keyVaultName>",
        "networkIntents": [
          {
            "adapter": [
              "mgmt"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "management",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": false,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentage_SMB": "50",
              "priorityValue8021Action_Cluster": "7",
              "priorityValue8021Action_SMB": "3"
            },
            "trafficType": [
              "Management"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          },
          {
            "adapter": [
              "comp0",
              "comp1"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "compute",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": false,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentage_SMB": "50",
              "priorityValue8021Action_Cluster": "7",
              "priorityValue8021Action_SMB": "3"
            },
            "trafficType": [
              "Compute"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          },
          {
            "adapter": [
              "smb0",
              "smb1"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "storage",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": true,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentage_SMB": "50",
              "priorityValue8021Action_Cluster": "7",
              "priorityValue8021Action_SMB": "3"
            },
            "trafficType": [
              "Storage"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          }
        ],
        "startingIPAddress": "172.20.0.2",
        "storageConnectivitySwitchless": false,
        "storageNetworks": [
          {
            "adapterName": "smb0",
            "vlan": "711"
          },
          {
            "adapterName": "smb1",
            "vlan": "712"
          }
        ],
        "subnetMask": "255.255.255.0"
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
using 'br/public:avm/res/azure-stack-hci/cluster:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param deploymentSettings = {
  clusterNodeNames: '<clusterNodeNames>'
  clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
  customLocationName: 'ashc2nmin-location'
  defaultGateway: '172.20.0.1'
  deploymentPrefix: '<deploymentPrefix>'
  dnsServers: [
    '172.20.0.1'
  ]
  domainFqdn: 'hci.local'
  domainOUPath: '<domainOUPath>'
  enableStorageAutoIp: true
  endingIPAddress: '172.20.0.7'
  keyVaultName: '<keyVaultName>'
  networkIntents: [
    {
      adapter: [
        'mgmt'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'management'
      overrideAdapterProperty: true
      overrideQosPolicy: false
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentage_SMB: '50'
        priorityValue8021Action_Cluster: '7'
        priorityValue8021Action_SMB: '3'
      }
      trafficType: [
        'Management'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
    {
      adapter: [
        'comp0'
        'comp1'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'compute'
      overrideAdapterProperty: true
      overrideQosPolicy: false
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentage_SMB: '50'
        priorityValue8021Action_Cluster: '7'
        priorityValue8021Action_SMB: '3'
      }
      trafficType: [
        'Compute'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
    {
      adapter: [
        'smb0'
        'smb1'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'storage'
      overrideAdapterProperty: true
      overrideQosPolicy: true
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentage_SMB: '50'
        priorityValue8021Action_Cluster: '7'
        priorityValue8021Action_SMB: '3'
      }
      trafficType: [
        'Storage'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
  ]
  startingIPAddress: '172.20.0.2'
  storageConnectivitySwitchless: false
  storageNetworks: [
    {
      adapterName: 'smb0'
      vlan: '711'
    }
    {
      adapterName: 'smb1'
      vlan: '712'
    }
  ]
  subnetMask: '255.255.255.0'
}
```

</details>
<p>

### Example 2: _Deploy Azure Stack HCI Cluster in Azure with a 2 node switched configuration WAF aligned_

This test deploys an Azure VM to host a 2 node switched Azure Stack HCI cluster, validates the cluster configuration, and then deploys the cluster WAF aligned.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/azure-stack-hci/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    deploymentSettings: {
      clusterNodeNames: '<clusterNodeNames>'
      clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
      customLocationName: 'ashc2nwaf-location'
      defaultGateway: '172.20.0.1'
      deploymentPrefix: '<deploymentPrefix>'
      dnsServers: [
        '172.20.0.1'
      ]
      domainFqdn: 'hci.local'
      domainOUPath: '<domainOUPath>'
      enableStorageAutoIp: true
      endingIPAddress: '172.20.0.7'
      keyVaultName: '<keyVaultName>'
      networkIntents: [
        {
          adapter: [
            'mgmt'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'management'
          overrideAdapterProperty: true
          overrideQosPolicy: false
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          trafficType: [
            'Management'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
        {
          adapter: [
            'comp0'
            'comp1'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'compute'
          overrideAdapterProperty: true
          overrideQosPolicy: false
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          trafficType: [
            'Compute'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
        {
          adapter: [
            'smb0'
            'smb1'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'storage'
          overrideAdapterProperty: true
          overrideQosPolicy: true
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentage_SMB: '50'
            priorityValue8021Action_Cluster: '7'
            priorityValue8021Action_SMB: '3'
          }
          trafficType: [
            'Storage'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
      ]
      startingIPAddress: '172.20.0.2'
      storageConnectivitySwitchless: false
      storageNetworks: [
        {
          adapterName: 'smb0'
          vlan: '711'
        }
        {
          adapterName: 'smb1'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
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
    "deploymentSettings": {
      "value": {
        "clusterNodeNames": "<clusterNodeNames>",
        "clusterWitnessStorageAccountName": "<clusterWitnessStorageAccountName>",
        "customLocationName": "ashc2nwaf-location",
        "defaultGateway": "172.20.0.1",
        "deploymentPrefix": "<deploymentPrefix>",
        "dnsServers": [
          "172.20.0.1"
        ],
        "domainFqdn": "hci.local",
        "domainOUPath": "<domainOUPath>",
        "enableStorageAutoIp": true,
        "endingIPAddress": "172.20.0.7",
        "keyVaultName": "<keyVaultName>",
        "networkIntents": [
          {
            "adapter": [
              "mgmt"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "management",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": false,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentage_SMB": "50",
              "priorityValue8021Action_Cluster": "7",
              "priorityValue8021Action_SMB": "3"
            },
            "trafficType": [
              "Management"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          },
          {
            "adapter": [
              "comp0",
              "comp1"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "compute",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": false,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentage_SMB": "50",
              "priorityValue8021Action_Cluster": "7",
              "priorityValue8021Action_SMB": "3"
            },
            "trafficType": [
              "Compute"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          },
          {
            "adapter": [
              "smb0",
              "smb1"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "storage",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": true,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentage_SMB": "50",
              "priorityValue8021Action_Cluster": "7",
              "priorityValue8021Action_SMB": "3"
            },
            "trafficType": [
              "Storage"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          }
        ],
        "startingIPAddress": "172.20.0.2",
        "storageConnectivitySwitchless": false,
        "storageNetworks": [
          {
            "adapterName": "smb0",
            "vlan": "711"
          },
          {
            "adapterName": "smb1",
            "vlan": "712"
          }
        ],
        "subnetMask": "255.255.255.0"
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
using 'br/public:avm/res/azure-stack-hci/cluster:<version>'

// Required parameters
param name = '<name>'
// Non-required parameters
param deploymentSettings = {
  clusterNodeNames: '<clusterNodeNames>'
  clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
  customLocationName: 'ashc2nwaf-location'
  defaultGateway: '172.20.0.1'
  deploymentPrefix: '<deploymentPrefix>'
  dnsServers: [
    '172.20.0.1'
  ]
  domainFqdn: 'hci.local'
  domainOUPath: '<domainOUPath>'
  enableStorageAutoIp: true
  endingIPAddress: '172.20.0.7'
  keyVaultName: '<keyVaultName>'
  networkIntents: [
    {
      adapter: [
        'mgmt'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'management'
      overrideAdapterProperty: true
      overrideQosPolicy: false
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentage_SMB: '50'
        priorityValue8021Action_Cluster: '7'
        priorityValue8021Action_SMB: '3'
      }
      trafficType: [
        'Management'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
    {
      adapter: [
        'comp0'
        'comp1'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'compute'
      overrideAdapterProperty: true
      overrideQosPolicy: false
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentage_SMB: '50'
        priorityValue8021Action_Cluster: '7'
        priorityValue8021Action_SMB: '3'
      }
      trafficType: [
        'Compute'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
    {
      adapter: [
        'smb0'
        'smb1'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'storage'
      overrideAdapterProperty: true
      overrideQosPolicy: true
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentage_SMB: '50'
        priorityValue8021Action_Cluster: '7'
        priorityValue8021Action_SMB: '3'
      }
      trafficType: [
        'Storage'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
  ]
  startingIPAddress: '172.20.0.2'
  storageConnectivitySwitchless: false
  storageNetworks: [
    {
      adapterName: 'smb0'
      vlan: '711'
    }
    {
      adapterName: 'smb1'
      vlan: '712'
    }
  ]
  subnetMask: '255.255.255.0'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploymentOperations`](#parameter-deploymentoperations) | array | The cluster deployment operations to execute. Defaults to "[Validate, Deploy]". |
| [`deploymentSettings`](#parameter-deploymentsettings) | object | The deployment settings of the cluster. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`useSharedKeyVault`](#parameter-usesharedkeyvault) | bool | Specify whether to use the shared key vault for the HCI cluster. |

### Parameter: `name`

The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.

- Required: Yes
- Type: string

### Parameter: `deploymentOperations`

The cluster deployment operations to execute. Defaults to "[Validate, Deploy]".

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'Deploy'
    'Validate'
  ]
  ```
- Allowed:
  ```Bicep
  [
    'Deploy'
    'Validate'
  ]
  ```

### Parameter: `deploymentSettings`

The deployment settings of the cluster.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterNodeNames`](#parameter-deploymentsettingsclusternodenames) | array | Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2]. |
| [`clusterWitnessStorageAccountName`](#parameter-deploymentsettingsclusterwitnessstorageaccountname) | string | The name of the storage account to be used as the witness for the HCI Windows Failover Cluster. |
| [`customLocationName`](#parameter-deploymentsettingscustomlocationname) | string | The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01. |
| [`defaultGateway`](#parameter-deploymentsettingsdefaultgateway) | string | The default gateway of the Management Network. Example: 192.168.0.1. |
| [`deploymentPrefix`](#parameter-deploymentsettingsdeploymentprefix) | string | The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$. |
| [`dnsServers`](#parameter-deploymentsettingsdnsservers) | array | The DNS servers accessible from the Management Network for the HCI cluster. |
| [`domainFqdn`](#parameter-deploymentsettingsdomainfqdn) | string | The domain name of the Active Directory Domain Services. Example: "contoso.com". |
| [`domainOUPath`](#parameter-deploymentsettingsdomainoupath) | string | The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com". |
| [`endingIPAddress`](#parameter-deploymentsettingsendingipaddress) | string | The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs. |
| [`keyVaultName`](#parameter-deploymentsettingskeyvaultname) | string | The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster. |
| [`networkIntents`](#parameter-deploymentsettingsnetworkintents) | array | An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster. |
| [`startingIPAddress`](#parameter-deploymentsettingsstartingipaddress) | string | The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs. |
| [`storageConnectivitySwitchless`](#parameter-deploymentsettingsstorageconnectivityswitchless) | bool | Specify whether the Storage Network connectivity is switched or switchless. |
| [`storageNetworks`](#parameter-deploymentsettingsstoragenetworks) | array | An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations. |
| [`subnetMask`](#parameter-deploymentsettingssubnetmask) | string | The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bitlockerBootVolume`](#parameter-deploymentsettingsbitlockerbootvolume) | bool | When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent. |
| [`bitlockerDataVolumes`](#parameter-deploymentsettingsbitlockerdatavolumes) | bool | When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes. |
| [`cloudId`](#parameter-deploymentsettingscloudid) | string | If using a shared key vault or non-legacy secret naming, pass the properties.cloudId guid from the pre-created HCI cluster resource. |
| [`credentialGuardEnforced`](#parameter-deploymentsettingscredentialguardenforced) | bool | Enables the Credential Guard. |
| [`driftControlEnforced`](#parameter-deploymentsettingsdriftcontrolenforced) | bool | When set to true, the security baseline is re-applied regularly. |
| [`drtmProtection`](#parameter-deploymentsettingsdrtmprotection) | bool | The hardware-dependent Secure Boot setting. |
| [`enableStorageAutoIp`](#parameter-deploymentsettingsenablestorageautoip) | bool | Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false. |
| [`episodicDataUpload`](#parameter-deploymentsettingsepisodicdataupload) | bool | The diagnostic data for deploying a HCI cluster. |
| [`hvciProtection`](#parameter-deploymentsettingshvciprotection) | bool | The Hypervisor-protected Code Integrity setting. |
| [`isEuropeanUnionLocation`](#parameter-deploymentsettingsiseuropeanunionlocation) | bool | The location data for deploying a HCI cluster. |
| [`sideChannelMitigationEnforced`](#parameter-deploymentsettingssidechannelmitigationenforced) | bool | When set to true, all the side channel mitigations are enabled. |
| [`smbClusterEncryption`](#parameter-deploymentsettingssmbclusterencryption) | bool | When set to true, cluster east-west traffic is encrypted. |
| [`smbSigningEnforced`](#parameter-deploymentsettingssmbsigningenforced) | bool | When set to true, the SMB default instance requires sign in for the client and server services. |
| [`storageConfigurationMode`](#parameter-deploymentsettingsstorageconfigurationmode) | string | The storage volume configuration mode. See documentation for details. |
| [`streamingDataClient`](#parameter-deploymentsettingsstreamingdataclient) | bool | The metrics data for deploying a HCI cluster. |
| [`wdacEnforced`](#parameter-deploymentsettingswdacenforced) | bool | Limits the applications and the code that you can run on your Azure Stack HCI cluster. |

### Parameter: `deploymentSettings.clusterNodeNames`

Names of the cluster node Arc Machine resources. These are the name of the Arc Machine resources created when the new HCI nodes were Arc initialized. Example: [hci-node-1, hci-node-2].

- Required: Yes
- Type: array

### Parameter: `deploymentSettings.clusterWitnessStorageAccountName`

The name of the storage account to be used as the witness for the HCI Windows Failover Cluster.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.customLocationName`

The name of the Custom Location associated with the Arc Resource Bridge for this cluster. This value should reflect the physical location and identifier of the HCI cluster. Example: cl-hci-den-clu01.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.defaultGateway`

The default gateway of the Management Network. Example: 192.168.0.1.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.deploymentPrefix`

The prefix for the resource for the deployment. This value is used in key vault and storage account names in this template, as well as for the deploymentSettings.properties.deploymentConfiguration.scaleUnits.deploymentData.namingPrefix property which requires regex pattern: ^[a-zA-Z0-9-]{1,8}$.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.dnsServers`

The DNS servers accessible from the Management Network for the HCI cluster.

- Required: Yes
- Type: array

### Parameter: `deploymentSettings.domainFqdn`

The domain name of the Active Directory Domain Services. Example: "contoso.com".

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.domainOUPath`

The ADDS OU path - ex "OU=HCI,DC=contoso,DC=com".

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.endingIPAddress`

The ending IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.keyVaultName`

The name of the key vault to be used for storing secrets for the HCI cluster. This currently needs to be unique per HCI cluster.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.networkIntents`

An array of Network ATC Network Intent objects that define the Compute, Management, and Storage network configuration for the cluster.

- Required: Yes
- Type: array

### Parameter: `deploymentSettings.startingIPAddress`

The starting IP address for the Infrastructure Network IP pool. There must be at least 6 IPs between startingIPAddress and endingIPAddress and this pool should be not include the node IPs.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.storageConnectivitySwitchless`

Specify whether the Storage Network connectivity is switched or switchless.

- Required: Yes
- Type: bool

### Parameter: `deploymentSettings.storageNetworks`

An array of JSON objects that define the storage network configuration for the cluster. Each object should contain the adapterName, VLAN properties, and (optionally) IP configurations.

- Required: Yes
- Type: array

### Parameter: `deploymentSettings.subnetMask`

The subnet mask pf the Management Network for the HCI cluster - ex: 255.255.252.0.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.bitlockerBootVolume`

When set to true, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.bitlockerDataVolumes`

When set to true, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.cloudId`

If using a shared key vault or non-legacy secret naming, pass the properties.cloudId guid from the pre-created HCI cluster resource.

- Required: No
- Type: string

### Parameter: `deploymentSettings.credentialGuardEnforced`

Enables the Credential Guard.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.driftControlEnforced`

When set to true, the security baseline is re-applied regularly.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.drtmProtection`

The hardware-dependent Secure Boot setting.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.enableStorageAutoIp`

Enable storage auto IP assignment. This should be true for most deployments except when deploying a three-node switchless cluster, in which case storage IPs should be configured before deployment and this value set to false.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.episodicDataUpload`

The diagnostic data for deploying a HCI cluster.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.hvciProtection`

The Hypervisor-protected Code Integrity setting.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.isEuropeanUnionLocation`

The location data for deploying a HCI cluster.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.sideChannelMitigationEnforced`

When set to true, all the side channel mitigations are enabled.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.smbClusterEncryption`

When set to true, cluster east-west traffic is encrypted.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.smbSigningEnforced`

When set to true, the SMB default instance requires sign in for the client and server services.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.storageConfigurationMode`

The storage volume configuration mode. See documentation for details.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Express'
    'InfraOnly'
    'KeepStorage'
  ]
  ```

### Parameter: `deploymentSettings.streamingDataClient`

The metrics data for deploying a HCI cluster.

- Required: No
- Type: bool

### Parameter: `deploymentSettings.wdacEnforced`

Limits the applications and the code that you can run on your Azure Stack HCI cluster.

- Required: No
- Type: bool

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Azure Stack HCI Administrator'`
  - `'Windows Admin Center Administrator Login'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `useSharedKeyVault`

Specify whether to use the shared key vault for the HCI cluster.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the cluster. |
| `name` | string | The name of the cluster. |
| `resourceGroupName` | string | The resource group of the cluster. |
| `resourceId` | string | The ID of the cluster. |
| `systemAssignedMIPrincipalId` | string | The managed identity of the cluster. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
