# Azure Stack HCI Cluster `[Microsoft.AzureStackHCI/clusters]`

This module deploys an Azure Stack HCI Cluster on the provided Arc Machines.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.AzureStackHCI/clusters` | [2024-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AzureStackHCI/clusters) |
| `Microsoft.KeyVault/vaults/secrets` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/secrets) |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | [2023-01-31](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2023-01-31/userAssignedIdentities) |
| `Microsoft.Resources/deploymentScripts` | [2023-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts) |

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
    deploymentSettings: {
      clusterNodeNames: '<clusterNodeNames>'
      clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
      customLocationName: 'ashcmin-location'
      defaultGateway: '192.168.1.1'
      deploymentPrefix: '<deploymentPrefix>'
      dnsServers: [
        '192.168.1.254'
      ]
      domainFqdn: 'jumpstart.local'
      domainOUPath: '<domainOUPath>'
      enableStorageAutoIp: true
      endingIPAddress: '192.168.1.65'
      keyVaultName: '<keyVaultName>'
      networkIntents: [
        {
          adapter: [
            'FABRIC'
            'FABRIC2'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'ManagementCompute'
          overrideAdapterProperty: true
          overrideQosPolicy: false
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
          }
          trafficType: [
            'Compute'
            'Management'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
        {
          adapter: [
            'StorageA'
            'StorageB'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'Storage'
          overrideAdapterProperty: true
          overrideQosPolicy: true
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
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
      startingIPAddress: '192.168.1.55'
      storageConnectivitySwitchless: false
      storageNetworks: [
        {
          adapterName: 'StorageA'
          name: 'Storage1Network'
          vlan: '711'
        }
        {
          adapterName: 'StorageB'
          name: 'Storage2Network'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
    }
    hciResourceProviderObjectId: '<hciResourceProviderObjectId>'
    name: '<name>'
    // Non-required parameters
    deploymentUser: 'deployUser'
    deploymentUserPassword: '<deploymentUserPassword>'
    localAdminPassword: '<localAdminPassword>'
    localAdminUser: 'Administrator'
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
    "deploymentSettings": {
      "value": {
        "clusterNodeNames": "<clusterNodeNames>",
        "clusterWitnessStorageAccountName": "<clusterWitnessStorageAccountName>",
        "customLocationName": "ashcmin-location",
        "defaultGateway": "192.168.1.1",
        "deploymentPrefix": "<deploymentPrefix>",
        "dnsServers": [
          "192.168.1.254"
        ],
        "domainFqdn": "jumpstart.local",
        "domainOUPath": "<domainOUPath>",
        "enableStorageAutoIp": true,
        "endingIPAddress": "192.168.1.65",
        "keyVaultName": "<keyVaultName>",
        "networkIntents": [
          {
            "adapter": [
              "FABRIC",
              "FABRIC2"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "ManagementCompute",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": false,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentageSMB": "50",
              "priorityValue8021ActionCluster": "7",
              "priorityValue8021ActionSMB": "3"
            },
            "trafficType": [
              "Compute",
              "Management"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          },
          {
            "adapter": [
              "StorageA",
              "StorageB"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "Storage",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": true,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentageSMB": "50",
              "priorityValue8021ActionCluster": "7",
              "priorityValue8021ActionSMB": "3"
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
        "startingIPAddress": "192.168.1.55",
        "storageConnectivitySwitchless": false,
        "storageNetworks": [
          {
            "adapterName": "StorageA",
            "name": "Storage1Network",
            "vlan": "711"
          },
          {
            "adapterName": "StorageB",
            "name": "Storage2Network",
            "vlan": "712"
          }
        ],
        "subnetMask": "255.255.255.0"
      }
    },
    "hciResourceProviderObjectId": {
      "value": "<hciResourceProviderObjectId>"
    },
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "deploymentUser": {
      "value": "deployUser"
    },
    "deploymentUserPassword": {
      "value": "<deploymentUserPassword>"
    },
    "localAdminPassword": {
      "value": "<localAdminPassword>"
    },
    "localAdminUser": {
      "value": "Administrator"
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
param deploymentSettings = {
  clusterNodeNames: '<clusterNodeNames>'
  clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
  customLocationName: 'ashcmin-location'
  defaultGateway: '192.168.1.1'
  deploymentPrefix: '<deploymentPrefix>'
  dnsServers: [
    '192.168.1.254'
  ]
  domainFqdn: 'jumpstart.local'
  domainOUPath: '<domainOUPath>'
  enableStorageAutoIp: true
  endingIPAddress: '192.168.1.65'
  keyVaultName: '<keyVaultName>'
  networkIntents: [
    {
      adapter: [
        'FABRIC'
        'FABRIC2'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'ManagementCompute'
      overrideAdapterProperty: true
      overrideQosPolicy: false
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentageSMB: '50'
        priorityValue8021ActionCluster: '7'
        priorityValue8021ActionSMB: '3'
      }
      trafficType: [
        'Compute'
        'Management'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
    {
      adapter: [
        'StorageA'
        'StorageB'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'Storage'
      overrideAdapterProperty: true
      overrideQosPolicy: true
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentageSMB: '50'
        priorityValue8021ActionCluster: '7'
        priorityValue8021ActionSMB: '3'
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
  startingIPAddress: '192.168.1.55'
  storageConnectivitySwitchless: false
  storageNetworks: [
    {
      adapterName: 'StorageA'
      name: 'Storage1Network'
      vlan: '711'
    }
    {
      adapterName: 'StorageB'
      name: 'Storage2Network'
      vlan: '712'
    }
  ]
  subnetMask: '255.255.255.0'
}
param hciResourceProviderObjectId = '<hciResourceProviderObjectId>'
param name = '<name>'
// Non-required parameters
param deploymentUser = 'deployUser'
param deploymentUserPassword = '<deploymentUserPassword>'
param localAdminPassword = '<localAdminPassword>'
param localAdminUser = 'Administrator'
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
    deploymentSettings: {
      bitlockerBootVolume: true
      bitlockerDataVolumes: true
      clusterNodeNames: '<clusterNodeNames>'
      clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
      customLocationName: 'ashcwaf-location'
      defaultGateway: '192.168.1.1'
      deploymentPrefix: '<deploymentPrefix>'
      dnsServers: [
        '192.168.1.254'
      ]
      domainFqdn: 'jumpstart.local'
      domainOUPath: '<domainOUPath>'
      driftControlEnforced: true
      enableStorageAutoIp: true
      endingIPAddress: '192.168.1.65'
      keyVaultName: '<keyVaultName>'
      networkIntents: [
        {
          adapter: [
            'FABRIC'
            'FABRIC2'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'ManagementCompute'
          overrideAdapterProperty: true
          overrideQosPolicy: false
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
          }
          trafficType: [
            'Compute'
            'Management'
          ]
          virtualSwitchConfigurationOverrides: {
            enableIov: 'true'
            loadBalancingAlgorithm: 'Dynamic'
          }
        }
        {
          adapter: [
            'StorageA'
            'StorageB'
          ]
          adapterPropertyOverrides: {
            jumboPacket: '9014'
            networkDirect: 'Disabled'
            networkDirectTechnology: 'iWARP'
          }
          name: 'Storage'
          overrideAdapterProperty: true
          overrideQosPolicy: true
          overrideVirtualSwitchConfiguration: false
          qosPolicyOverrides: {
            bandwidthPercentageSMB: '50'
            priorityValue8021ActionCluster: '7'
            priorityValue8021ActionSMB: '3'
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
      sideChannelMitigationEnforced: true
      smbClusterEncryption: true
      smbSigningEnforced: true
      startingIPAddress: '192.168.1.55'
      storageConnectivitySwitchless: false
      storageNetworks: [
        {
          adapterName: 'StorageA'
          name: 'Storage1Network'
          vlan: '711'
        }
        {
          adapterName: 'StorageB'
          name: 'Storage2Network'
          vlan: '712'
        }
      ]
      subnetMask: '255.255.255.0'
    }
    hciResourceProviderObjectId: '<hciResourceProviderObjectId>'
    name: '<name>'
    // Non-required parameters
    deploymentUser: 'deployUser'
    deploymentUserPassword: '<deploymentUserPassword>'
    localAdminPassword: '<localAdminPassword>'
    localAdminUser: 'Administrator'
    servicePrincipalId: '<servicePrincipalId>'
    servicePrincipalSecret: '<servicePrincipalSecret>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
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
    "deploymentSettings": {
      "value": {
        "bitlockerBootVolume": true,
        "bitlockerDataVolumes": true,
        "clusterNodeNames": "<clusterNodeNames>",
        "clusterWitnessStorageAccountName": "<clusterWitnessStorageAccountName>",
        "customLocationName": "ashcwaf-location",
        "defaultGateway": "192.168.1.1",
        "deploymentPrefix": "<deploymentPrefix>",
        "dnsServers": [
          "192.168.1.254"
        ],
        "domainFqdn": "jumpstart.local",
        "domainOUPath": "<domainOUPath>",
        "driftControlEnforced": true,
        "enableStorageAutoIp": true,
        "endingIPAddress": "192.168.1.65",
        "keyVaultName": "<keyVaultName>",
        "networkIntents": [
          {
            "adapter": [
              "FABRIC",
              "FABRIC2"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "ManagementCompute",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": false,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentageSMB": "50",
              "priorityValue8021ActionCluster": "7",
              "priorityValue8021ActionSMB": "3"
            },
            "trafficType": [
              "Compute",
              "Management"
            ],
            "virtualSwitchConfigurationOverrides": {
              "enableIov": "true",
              "loadBalancingAlgorithm": "Dynamic"
            }
          },
          {
            "adapter": [
              "StorageA",
              "StorageB"
            ],
            "adapterPropertyOverrides": {
              "jumboPacket": "9014",
              "networkDirect": "Disabled",
              "networkDirectTechnology": "iWARP"
            },
            "name": "Storage",
            "overrideAdapterProperty": true,
            "overrideQosPolicy": true,
            "overrideVirtualSwitchConfiguration": false,
            "qosPolicyOverrides": {
              "bandwidthPercentageSMB": "50",
              "priorityValue8021ActionCluster": "7",
              "priorityValue8021ActionSMB": "3"
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
        "sideChannelMitigationEnforced": true,
        "smbClusterEncryption": true,
        "smbSigningEnforced": true,
        "startingIPAddress": "192.168.1.55",
        "storageConnectivitySwitchless": false,
        "storageNetworks": [
          {
            "adapterName": "StorageA",
            "name": "Storage1Network",
            "vlan": "711"
          },
          {
            "adapterName": "StorageB",
            "name": "Storage2Network",
            "vlan": "712"
          }
        ],
        "subnetMask": "255.255.255.0"
      }
    },
    "hciResourceProviderObjectId": {
      "value": "<hciResourceProviderObjectId>"
    },
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "deploymentUser": {
      "value": "deployUser"
    },
    "deploymentUserPassword": {
      "value": "<deploymentUserPassword>"
    },
    "localAdminPassword": {
      "value": "<localAdminPassword>"
    },
    "localAdminUser": {
      "value": "Administrator"
    },
    "servicePrincipalId": {
      "value": "<servicePrincipalId>"
    },
    "servicePrincipalSecret": {
      "value": "<servicePrincipalSecret>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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
param deploymentSettings = {
  bitlockerBootVolume: true
  bitlockerDataVolumes: true
  clusterNodeNames: '<clusterNodeNames>'
  clusterWitnessStorageAccountName: '<clusterWitnessStorageAccountName>'
  customLocationName: 'ashcwaf-location'
  defaultGateway: '192.168.1.1'
  deploymentPrefix: '<deploymentPrefix>'
  dnsServers: [
    '192.168.1.254'
  ]
  domainFqdn: 'jumpstart.local'
  domainOUPath: '<domainOUPath>'
  driftControlEnforced: true
  enableStorageAutoIp: true
  endingIPAddress: '192.168.1.65'
  keyVaultName: '<keyVaultName>'
  networkIntents: [
    {
      adapter: [
        'FABRIC'
        'FABRIC2'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'ManagementCompute'
      overrideAdapterProperty: true
      overrideQosPolicy: false
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentageSMB: '50'
        priorityValue8021ActionCluster: '7'
        priorityValue8021ActionSMB: '3'
      }
      trafficType: [
        'Compute'
        'Management'
      ]
      virtualSwitchConfigurationOverrides: {
        enableIov: 'true'
        loadBalancingAlgorithm: 'Dynamic'
      }
    }
    {
      adapter: [
        'StorageA'
        'StorageB'
      ]
      adapterPropertyOverrides: {
        jumboPacket: '9014'
        networkDirect: 'Disabled'
        networkDirectTechnology: 'iWARP'
      }
      name: 'Storage'
      overrideAdapterProperty: true
      overrideQosPolicy: true
      overrideVirtualSwitchConfiguration: false
      qosPolicyOverrides: {
        bandwidthPercentageSMB: '50'
        priorityValue8021ActionCluster: '7'
        priorityValue8021ActionSMB: '3'
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
  sideChannelMitigationEnforced: true
  smbClusterEncryption: true
  smbSigningEnforced: true
  startingIPAddress: '192.168.1.55'
  storageConnectivitySwitchless: false
  storageNetworks: [
    {
      adapterName: 'StorageA'
      name: 'Storage1Network'
      vlan: '711'
    }
    {
      adapterName: 'StorageB'
      name: 'Storage2Network'
      vlan: '712'
    }
  ]
  subnetMask: '255.255.255.0'
}
param hciResourceProviderObjectId = '<hciResourceProviderObjectId>'
param name = '<name>'
// Non-required parameters
param deploymentUser = 'deployUser'
param deploymentUserPassword = '<deploymentUserPassword>'
param localAdminPassword = '<localAdminPassword>'
param localAdminUser = 'Administrator'
param servicePrincipalId = '<servicePrincipalId>'
param servicePrincipalSecret = '<servicePrincipalSecret>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploymentSettings`](#parameter-deploymentsettings) | object | The deployment settings of the cluster. |
| [`hciResourceProviderObjectId`](#parameter-hciresourceproviderobjectid) | securestring | The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the 'Microsoft.AzureStackHCI' provider was registered in the subscription. |
| [`name`](#parameter-name) | string | The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deploymentUser`](#parameter-deploymentuser) | string | The name of the deployment user. Required if useSharedKeyVault is true. |
| [`deploymentUserPassword`](#parameter-deploymentuserpassword) | securestring | The password of the deployment user. Required if useSharedKeyVault is true. |
| [`localAdminPassword`](#parameter-localadminpassword) | securestring | The password of the local admin user. Required if useSharedKeyVault is true. |
| [`localAdminUser`](#parameter-localadminuser) | string | The name of the local admin user. Required if useSharedKeyVault is true. |
| [`servicePrincipalId`](#parameter-serviceprincipalid) | string | The service principal ID for ARB. Required if useSharedKeyVault is true and need ARB service principal id. |
| [`servicePrincipalSecret`](#parameter-serviceprincipalsecret) | securestring | The service principal secret for ARB. Required if useSharedKeyVault is true and need ARB service principal id. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureStackLCMUserCredentialContentType`](#parameter-azurestacklcmusercredentialcontenttype) | string | Content type of the azure stack lcm user credential. |
| [`azureStackLCMUserCredentialTags`](#parameter-azurestacklcmusercredentialtags) | object | Tags of azure stack LCM user credential. |
| [`defaultARBApplicationContentType`](#parameter-defaultarbapplicationcontenttype) | string | Content type of the default ARB application. |
| [`defaultARBApplicationTags`](#parameter-defaultarbapplicationtags) | object | Tags of the default ARB application. |
| [`deploymentOperations`](#parameter-deploymentoperations) | array | The cluster deployment operations to execute. Defaults to "[Validate, Deploy]". |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`keyvaultResourceGroup`](#parameter-keyvaultresourcegroup) | string | Key vault resource group, which is used for for storing secrets for the HCI cluster. |
| [`keyvaultSubscriptionId`](#parameter-keyvaultsubscriptionid) | string | Key vault subscription ID, which is used for for storing secrets for the HCI cluster. |
| [`localAdminCredentialContentType`](#parameter-localadmincredentialcontenttype) | string | Content type of the local admin credential. |
| [`localAdminCredentialTags`](#parameter-localadmincredentialtags) | object | Tags of the local admin credential. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`useSharedKeyVault`](#parameter-usesharedkeyvault) | bool | Specify whether to use the shared key vault for the HCI cluster. |
| [`witnessStorageAccountResourceGroup`](#parameter-witnessstorageaccountresourcegroup) | string | Storage account resource group, which is used as the witness for the HCI Windows Failover Cluster. |
| [`witnessStorageAccountSubscriptionId`](#parameter-witnessstorageaccountsubscriptionid) | string | Storage account subscription ID, which is used as the witness for the HCI Windows Failover Cluster. |
| [`witnessStoragekeyContentType`](#parameter-witnessstoragekeycontenttype) | string | Content type of the witness storage key. |
| [`witnessStoragekeyTags`](#parameter-witnessstoragekeytags) | object | Tags of the witness storage key. |

### Parameter: `deploymentSettings`

The deployment settings of the cluster.

- Required: Yes
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adapter`](#parameter-deploymentsettingsnetworkintentsadapter) | array | The names of the network adapters to include in the intent. |
| [`adapterPropertyOverrides`](#parameter-deploymentsettingsnetworkintentsadapterpropertyoverrides) | object | The adapter property overrides for the network intent. |
| [`name`](#parameter-deploymentsettingsnetworkintentsname) | string | The name of the network intent. |
| [`overrideAdapterProperty`](#parameter-deploymentsettingsnetworkintentsoverrideadapterproperty) | bool | Specify whether to override the adapter property. Use false by default. |
| [`overrideQosPolicy`](#parameter-deploymentsettingsnetworkintentsoverrideqospolicy) | bool | Specify whether to override the qosPolicy property. Use false by default. |
| [`overrideVirtualSwitchConfiguration`](#parameter-deploymentsettingsnetworkintentsoverridevirtualswitchconfiguration) | bool | Specify whether to override the virtualSwitchConfiguration property. Use false by default. |
| [`qosPolicyOverrides`](#parameter-deploymentsettingsnetworkintentsqospolicyoverrides) | object | The qosPolicy overrides for the network intent. |
| [`trafficType`](#parameter-deploymentsettingsnetworkintentstraffictype) | array | The traffic types for the network intent. |
| [`virtualSwitchConfigurationOverrides`](#parameter-deploymentsettingsnetworkintentsvirtualswitchconfigurationoverrides) | object | The virtualSwitchConfiguration overrides for the network intent. |

### Parameter: `deploymentSettings.networkIntents.adapter`

The names of the network adapters to include in the intent.

- Required: Yes
- Type: array

### Parameter: `deploymentSettings.networkIntents.adapterPropertyOverrides`

The adapter property overrides for the network intent.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`jumboPacket`](#parameter-deploymentsettingsnetworkintentsadapterpropertyoverridesjumbopacket) | string | The jumboPacket configuration for the network adapters. |
| [`networkDirect`](#parameter-deploymentsettingsnetworkintentsadapterpropertyoverridesnetworkdirect) | string | The networkDirect configuration for the network adapters. |
| [`networkDirectTechnology`](#parameter-deploymentsettingsnetworkintentsadapterpropertyoverridesnetworkdirecttechnology) | string | The networkDirectTechnology configuration for the network adapters. |

### Parameter: `deploymentSettings.networkIntents.adapterPropertyOverrides.jumboPacket`

The jumboPacket configuration for the network adapters.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.networkIntents.adapterPropertyOverrides.networkDirect`

The networkDirect configuration for the network adapters.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `deploymentSettings.networkIntents.adapterPropertyOverrides.networkDirectTechnology`

The networkDirectTechnology configuration for the network adapters.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'iWARP'
    'RoCEv2'
  ]
  ```

### Parameter: `deploymentSettings.networkIntents.name`

The name of the network intent.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.networkIntents.overrideAdapterProperty`

Specify whether to override the adapter property. Use false by default.

- Required: Yes
- Type: bool

### Parameter: `deploymentSettings.networkIntents.overrideQosPolicy`

Specify whether to override the qosPolicy property. Use false by default.

- Required: Yes
- Type: bool

### Parameter: `deploymentSettings.networkIntents.overrideVirtualSwitchConfiguration`

Specify whether to override the virtualSwitchConfiguration property. Use false by default.

- Required: Yes
- Type: bool

### Parameter: `deploymentSettings.networkIntents.qosPolicyOverrides`

The qosPolicy overrides for the network intent.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bandwidthPercentageSMB`](#parameter-deploymentsettingsnetworkintentsqospolicyoverridesbandwidthpercentagesmb) | string | The bandwidthPercentage for the network intent. Recommend 50. |
| [`priorityValue8021ActionCluster`](#parameter-deploymentsettingsnetworkintentsqospolicyoverridespriorityvalue8021actioncluster) | string | Recommend 7. |
| [`priorityValue8021ActionSMB`](#parameter-deploymentsettingsnetworkintentsqospolicyoverridespriorityvalue8021actionsmb) | string | Recommend 3. |

### Parameter: `deploymentSettings.networkIntents.qosPolicyOverrides.bandwidthPercentageSMB`

The bandwidthPercentage for the network intent. Recommend 50.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.networkIntents.qosPolicyOverrides.priorityValue8021ActionCluster`

Recommend 7.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.networkIntents.qosPolicyOverrides.priorityValue8021ActionSMB`

Recommend 3.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.networkIntents.trafficType`

The traffic types for the network intent.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'Compute'
    'Management'
    'Storage'
  ]
  ```

### Parameter: `deploymentSettings.networkIntents.virtualSwitchConfigurationOverrides`

The virtualSwitchConfiguration overrides for the network intent.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableIov`](#parameter-deploymentsettingsnetworkintentsvirtualswitchconfigurationoverridesenableiov) | string | The enableIov configuration for the network intent. |
| [`loadBalancingAlgorithm`](#parameter-deploymentsettingsnetworkintentsvirtualswitchconfigurationoverridesloadbalancingalgorithm) | string | The loadBalancingAlgorithm configuration for the network intent. |

### Parameter: `deploymentSettings.networkIntents.virtualSwitchConfigurationOverrides.enableIov`

The enableIov configuration for the network intent.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'false'
    'true'
  ]
  ```

### Parameter: `deploymentSettings.networkIntents.virtualSwitchConfigurationOverrides.loadBalancingAlgorithm`

The loadBalancingAlgorithm configuration for the network intent.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'HyperVPort'
    'IPHash'
  ]
  ```

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adapterName`](#parameter-deploymentsettingsstoragenetworksadaptername) | string | The name of the storage adapter. |
| [`name`](#parameter-deploymentsettingsstoragenetworksname) | string | The name of the storage network. |
| [`vlan`](#parameter-deploymentsettingsstoragenetworksvlan) | string | The VLAN for the storage adapter. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAdapterIPInfo`](#parameter-deploymentsettingsstoragenetworksstorageadapteripinfo) | array | The storage adapter IP information for 3-node switchless or manual config deployments. |

### Parameter: `deploymentSettings.storageNetworks.adapterName`

The name of the storage adapter.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.storageNetworks.name`

The name of the storage network.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.storageNetworks.vlan`

The VLAN for the storage adapter.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.storageNetworks.storageAdapterIPInfo`

The storage adapter IP information for 3-node switchless or manual config deployments.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipv4Address`](#parameter-deploymentsettingsstoragenetworksstorageadapteripinfoipv4address) | string | The IPv4 address for the storage adapter. |
| [`physicalNode`](#parameter-deploymentsettingsstoragenetworksstorageadapteripinfophysicalnode) | string | The HCI node name. |
| [`subnetMask`](#parameter-deploymentsettingsstoragenetworksstorageadapteripinfosubnetmask) | string | The subnet mask for the storage adapter. |

### Parameter: `deploymentSettings.storageNetworks.storageAdapterIPInfo.ipv4Address`

The IPv4 address for the storage adapter.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.storageNetworks.storageAdapterIPInfo.physicalNode`

The HCI node name.

- Required: Yes
- Type: string

### Parameter: `deploymentSettings.storageNetworks.storageAdapterIPInfo.subnetMask`

The subnet mask for the storage adapter.

- Required: Yes
- Type: string

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

### Parameter: `hciResourceProviderObjectId`

The service principal object ID of the Azure Stack HCI Resource Provider in this tenant. Can be fetched via `Get-AzADServicePrincipal -ApplicationId 1412d89f-b8a8-4111-b4fd-e82905cbd85d` after the 'Microsoft.AzureStackHCI' provider was registered in the subscription.

- Required: Yes
- Type: securestring

### Parameter: `name`

The name of the Azure Stack HCI cluster - this must be a valid Active Directory computer name and will be the name of your cluster in Azure.

- Required: Yes
- Type: string

### Parameter: `deploymentUser`

The name of the deployment user. Required if useSharedKeyVault is true.

- Required: No
- Type: string

### Parameter: `deploymentUserPassword`

The password of the deployment user. Required if useSharedKeyVault is true.

- Required: No
- Type: securestring

### Parameter: `localAdminPassword`

The password of the local admin user. Required if useSharedKeyVault is true.

- Required: No
- Type: securestring

### Parameter: `localAdminUser`

The name of the local admin user. Required if useSharedKeyVault is true.

- Required: No
- Type: string

### Parameter: `servicePrincipalId`

The service principal ID for ARB. Required if useSharedKeyVault is true and need ARB service principal id.

- Required: No
- Type: string

### Parameter: `servicePrincipalSecret`

The service principal secret for ARB. Required if useSharedKeyVault is true and need ARB service principal id.

- Required: No
- Type: securestring

### Parameter: `azureStackLCMUserCredentialContentType`

Content type of the azure stack lcm user credential.

- Required: No
- Type: string
- Default: `'Secret'`

### Parameter: `azureStackLCMUserCredentialTags`

Tags of azure stack LCM user credential.

- Required: No
- Type: object

### Parameter: `defaultARBApplicationContentType`

Content type of the default ARB application.

- Required: No
- Type: string
- Default: `'Secret'`

### Parameter: `defaultARBApplicationTags`

Tags of the default ARB application.

- Required: No
- Type: object

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `keyvaultResourceGroup`

Key vault resource group, which is used for for storing secrets for the HCI cluster.

- Required: No
- Type: string

### Parameter: `keyvaultSubscriptionId`

Key vault subscription ID, which is used for for storing secrets for the HCI cluster.

- Required: No
- Type: string

### Parameter: `localAdminCredentialContentType`

Content type of the local admin credential.

- Required: No
- Type: string
- Default: `'Secret'`

### Parameter: `localAdminCredentialTags`

Tags of the local admin credential.

- Required: No
- Type: object

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

### Parameter: `witnessStorageAccountResourceGroup`

Storage account resource group, which is used as the witness for the HCI Windows Failover Cluster.

- Required: No
- Type: string

### Parameter: `witnessStorageAccountSubscriptionId`

Storage account subscription ID, which is used as the witness for the HCI Windows Failover Cluster.

- Required: No
- Type: string

### Parameter: `witnessStoragekeyContentType`

Content type of the witness storage key.

- Required: No
- Type: string
- Default: `'Secret'`

### Parameter: `witnessStoragekeyTags`

Tags of the witness storage key.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location of the cluster. |
| `name` | string | The name of the cluster. |
| `resourceGroupName` | string | The resource group of the cluster. |
| `resourceId` | string | The ID of the cluster. |
| `systemAssignedMIPrincipalId` | string | The managed identity of the cluster. |
| `vSwitchName` | string | The name of the vSwitch. |

## Notes

This module requires prerequisites, that can't be done via ARM/Bicep directly.

### Required Azure Role Assignments

To successfully deploy and manage Azure Stack HCI clusters, ensure the following service principals have the appropriate role assignments at the subscription level:

#### 1. Service Principal Permissions

The service principal referenced as `CI-arbDeploymentAppId` in the Key Vault must have the following roles assigned:

- **Contributor** - For resource operations
- **Reader** - For read access to resources
- **Azure Connected Machine Onboarding** - For onboarding Azure Arc-enabled servers
- **Azure Connected Machine Resource Administrator** - For managing Arc-enabled server resources
- **Key Vault Secrets Officer** - For managing Key Vault secrets
- **User Access Administrator** - For managing role assignments

#### 2. Microsoft.AzureStackHCI Resource Provider Permissions

The Microsoft.AzureStackHCI Resource Provider must have the following role assigned:

- **Azure Connected Machine Resource Manager** - Required for extension reconciliation and hybrid compute operations

To find the correct service principal for role assignment:

1. Use the client ID `1412d89f-b8a8-4111-b4fd-e82905cbd85d` to locate the Microsoft.AzureStackHCI service principal

2. Use the Object ID of this service principal for role assignment

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
