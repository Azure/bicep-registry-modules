# Service Fabric Clusters `[Microsoft.ServiceFabric/clusters]`

This module deploys a Service Fabric Cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ServiceFabric/clusters` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters) |
| `Microsoft.ServiceFabric/clusters/applicationTypes` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceFabric/2021-06-01/clusters/applicationTypes) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/service-fabric/cluster:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/service-fabric/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    managementEndpoint: 'https://sfcmin001.westeurope.cloudapp.azure.com:19080'
    name: 'sfcmin001'
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        name: 'Node01'
      }
    ]
    reliabilityLevel: 'None'
    // Non-required parameters
    certificate: {
      thumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
    }
    location: '<location>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "managementEndpoint": {
      "value": "https://sfcmin001.westeurope.cloudapp.azure.com:19080"
    },
    "name": {
      "value": "sfcmin001"
    },
    "nodeTypes": {
      "value": [
        {
          "applicationPorts": {
            "endPort": 30000,
            "startPort": 20000
          },
          "clientConnectionEndpointPort": 19000,
          "durabilityLevel": "Bronze",
          "ephemeralPorts": {
            "endPort": 65534,
            "startPort": 49152
          },
          "httpGatewayEndpointPort": 19080,
          "isPrimary": true,
          "name": "Node01"
        }
      ]
    },
    "reliabilityLevel": {
      "value": "None"
    },
    // Non-required parameters
    "certificate": {
      "value": {
        "thumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130"
      }
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/service-fabric/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    managementEndpoint: 'https://sfcmax001.westeurope.cloudapp.azure.com:19080'
    name: 'sfcmax001'
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Silver'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        isStateless: false
        multipleAvailabilityZones: false
        name: 'Node01'
        placementProperties: {}
        reverseProxyEndpointPort: ''
        vmInstanceCount: 5
      }
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 64000
          httpGatewayEndpointPort: 19007
          isPrimary: true
          name: 'Node02'
          startPort: 49000
          vmInstanceCount: 5
        }
      }
    ]
    reliabilityLevel: 'Silver'
    // Non-required parameters
    addOnFeatures: [
      'BackupRestoreService'
      'DnsService'
      'RepairManager'
      'ResourceMonitorService'
    ]
    applicationTypes: [
      {
        name: 'WordCount'
      }
    ]
    azureActiveDirectory: {
      clientApplication: '<clientApplication>'
      clusterApplication: 'cf33fea8-b30f-424f-ab73-c48d99e0b222'
      tenantId: '<tenantId>'
    }
    certificateCommonNames: {
      commonNames: [
        {
          certificateCommonName: 'certcommon'
          certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        }
      ]
      x509StoreName: 'My'
    }
    clientCertificateCommonNames: [
      {
        certificateCommonName: 'clientcommoncert1'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        isAdmin: false
      }
      {
        certificateCommonName: 'clientcommoncert2'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC131'
        isAdmin: false
      }
    ]
    diagnosticsStorageAccountConfig: {
      blobEndpoint: '<blobEndpoint>'
      protectedAccountKeyName: 'StorageAccountKey1'
      queueEndpoint: '<queueEndpoint>'
      storageAccountName: '<storageAccountName>'
      tableEndpoint: '<tableEndpoint>'
    }
    fabricSettings: [
      {
        name: 'Security'
        parameters: [
          {
            name: 'ClusterProtectionLevel'
            value: 'EncryptAndSign'
          }
        ]
      }
      {
        name: 'UpgradeService'
        parameters: [
          {
            name: 'AppPollIntervalInSeconds'
            value: '60'
          }
        ]
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maxUnusedVersionsToKeep: 2
    notifications: [
      {
        isEnabled: true
        notificationCategory: 'WaveProgress'
        notificationLevel: 'Critical'
        notificationTargets: [
          {
            notificationChannel: 'EmailUser'
            receivers: [
              'SomeReceiver'
            ]
          }
        ]
      }
    ]
    roleAssignments: [
      {
        name: '26b52f01-eebc-4056-a516-41541369258c'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    tags: {
      clusterName: 'sfcmax001'
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Service Fabric'
    }
    upgradeDescription: {
      deltaHealthPolicy: {
        maxPercentDeltaUnhealthyApplications: 0
        maxPercentDeltaUnhealthyNodes: 0
        maxPercentUpgradeDomainDeltaUnhealthyNodes: 0
      }
      forceRestart: false
      healthCheckRetryTimeout: '00:45:00'
      healthCheckStableDuration: '00:01:00'
      healthCheckWaitDuration: '00:00:30'
      healthPolicy: {
        maxPercentUnhealthyApplications: 0
        maxPercentUnhealthyNodes: 0
      }
      upgradeDomainTimeout: '02:00:00'
      upgradeReplicaSetCheckTimeout: '1.00:00:00'
      upgradeTimeout: '02:00:00'
    }
    vmImage: 'Linux'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "managementEndpoint": {
      "value": "https://sfcmax001.westeurope.cloudapp.azure.com:19080"
    },
    "name": {
      "value": "sfcmax001"
    },
    "nodeTypes": {
      "value": [
        {
          "applicationPorts": {
            "endPort": 30000,
            "startPort": 20000
          },
          "clientConnectionEndpointPort": 19000,
          "durabilityLevel": "Silver",
          "ephemeralPorts": {
            "endPort": 65534,
            "startPort": 49152
          },
          "httpGatewayEndpointPort": 19080,
          "isPrimary": true,
          "isStateless": false,
          "multipleAvailabilityZones": false,
          "name": "Node01",
          "placementProperties": {},
          "reverseProxyEndpointPort": "",
          "vmInstanceCount": 5
        },
        {
          "applicationPorts": {
            "endPort": 30000,
            "startPort": 20000
          },
          "clientConnectionEndpointPort": 19000,
          "durabilityLevel": "Bronze",
          "ephemeralPorts": {
            "endPort": 64000,
            "httpGatewayEndpointPort": 19007,
            "isPrimary": true,
            "name": "Node02",
            "startPort": 49000,
            "vmInstanceCount": 5
          }
        }
      ]
    },
    "reliabilityLevel": {
      "value": "Silver"
    },
    // Non-required parameters
    "addOnFeatures": {
      "value": [
        "BackupRestoreService",
        "DnsService",
        "RepairManager",
        "ResourceMonitorService"
      ]
    },
    "applicationTypes": {
      "value": [
        {
          "name": "WordCount"
        }
      ]
    },
    "azureActiveDirectory": {
      "value": {
        "clientApplication": "<clientApplication>",
        "clusterApplication": "cf33fea8-b30f-424f-ab73-c48d99e0b222",
        "tenantId": "<tenantId>"
      }
    },
    "certificateCommonNames": {
      "value": {
        "commonNames": [
          {
            "certificateCommonName": "certcommon",
            "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130"
          }
        ],
        "x509StoreName": "My"
      }
    },
    "clientCertificateCommonNames": {
      "value": [
        {
          "certificateCommonName": "clientcommoncert1",
          "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130",
          "isAdmin": false
        },
        {
          "certificateCommonName": "clientcommoncert2",
          "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC131",
          "isAdmin": false
        }
      ]
    },
    "diagnosticsStorageAccountConfig": {
      "value": {
        "blobEndpoint": "<blobEndpoint>",
        "protectedAccountKeyName": "StorageAccountKey1",
        "queueEndpoint": "<queueEndpoint>",
        "storageAccountName": "<storageAccountName>",
        "tableEndpoint": "<tableEndpoint>"
      }
    },
    "fabricSettings": {
      "value": [
        {
          "name": "Security",
          "parameters": [
            {
              "name": "ClusterProtectionLevel",
              "value": "EncryptAndSign"
            }
          ]
        },
        {
          "name": "UpgradeService",
          "parameters": [
            {
              "name": "AppPollIntervalInSeconds",
              "value": "60"
            }
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "maxUnusedVersionsToKeep": {
      "value": 2
    },
    "notifications": {
      "value": [
        {
          "isEnabled": true,
          "notificationCategory": "WaveProgress",
          "notificationLevel": "Critical",
          "notificationTargets": [
            {
              "notificationChannel": "EmailUser",
              "receivers": [
                "SomeReceiver"
              ]
            }
          ]
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "26b52f01-eebc-4056-a516-41541369258c",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "tags": {
      "value": {
        "clusterName": "sfcmax001",
        "hidden-title": "This is visible in the resource name",
        "resourceType": "Service Fabric"
      }
    },
    "upgradeDescription": {
      "value": {
        "deltaHealthPolicy": {
          "maxPercentDeltaUnhealthyApplications": 0,
          "maxPercentDeltaUnhealthyNodes": 0,
          "maxPercentUpgradeDomainDeltaUnhealthyNodes": 0
        },
        "forceRestart": false,
        "healthCheckRetryTimeout": "00:45:00",
        "healthCheckStableDuration": "00:01:00",
        "healthCheckWaitDuration": "00:00:30",
        "healthPolicy": {
          "maxPercentUnhealthyApplications": 0,
          "maxPercentUnhealthyNodes": 0
        },
        "upgradeDomainTimeout": "02:00:00",
        "upgradeReplicaSetCheckTimeout": "1.00:00:00",
        "upgradeTimeout": "02:00:00"
      }
    },
    "vmImage": {
      "value": "Linux"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module cluster 'br/public:avm/res/service-fabric/cluster:<version>' = {
  name: 'clusterDeployment'
  params: {
    // Required parameters
    managementEndpoint: 'https://sfcwaf001.westeurope.cloudapp.azure.com:19080'
    name: 'sfcwaf001'
    nodeTypes: [
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Silver'
        ephemeralPorts: {
          endPort: 65534
          startPort: 49152
        }
        httpGatewayEndpointPort: 19080
        isPrimary: true
        isStateless: false
        multipleAvailabilityZones: false
        name: 'Node01'
        placementProperties: {}
        reverseProxyEndpointPort: ''
        vmInstanceCount: 5
      }
      {
        applicationPorts: {
          endPort: 30000
          startPort: 20000
        }
        clientConnectionEndpointPort: 19000
        durabilityLevel: 'Bronze'
        ephemeralPorts: {
          endPort: 64000
          httpGatewayEndpointPort: 19007
          isPrimary: true
          name: 'Node02'
          startPort: 49000
          vmInstanceCount: 5
        }
      }
    ]
    reliabilityLevel: 'Silver'
    // Non-required parameters
    addOnFeatures: [
      'BackupRestoreService'
      'DnsService'
      'RepairManager'
      'ResourceMonitorService'
    ]
    applicationTypes: [
      {
        name: 'WordCount'
      }
    ]
    azureActiveDirectory: {
      clientApplication: '<clientApplication>'
      clusterApplication: 'cf33fea8-b30f-424f-ab73-c48d99e0b222'
      tenantId: '<tenantId>'
    }
    certificate: {
      thumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
      x509StoreName: 'My'
    }
    clientCertificateCommonNames: [
      {
        certificateCommonName: 'clientcommoncert1'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC130'
        isAdmin: false
      }
      {
        certificateCommonName: 'clientcommoncert2'
        certificateIssuerThumbprint: '0AC113D5E1D94C401DDEB0EE2B1B96CC131'
        isAdmin: false
      }
    ]
    diagnosticsStorageAccountConfig: {
      blobEndpoint: '<blobEndpoint>'
      protectedAccountKeyName: 'StorageAccountKey1'
      queueEndpoint: '<queueEndpoint>'
      storageAccountName: '<storageAccountName>'
      tableEndpoint: '<tableEndpoint>'
    }
    fabricSettings: [
      {
        name: 'Security'
        parameters: [
          {
            name: 'ClusterProtectionLevel'
            value: 'EncryptAndSign'
          }
        ]
      }
      {
        name: 'UpgradeService'
        parameters: [
          {
            name: 'AppPollIntervalInSeconds'
            value: '60'
          }
        ]
      }
    ]
    location: '<location>'
    maxUnusedVersionsToKeep: 2
    notifications: [
      {
        isEnabled: true
        notificationCategory: 'WaveProgress'
        notificationLevel: 'Critical'
        notificationTargets: [
          {
            notificationChannel: 'EmailUser'
            receivers: [
              'SomeReceiver'
            ]
          }
        ]
      }
    ]
    tags: {
      clusterName: 'sfcwaf001'
      'hidden-title': 'This is visible in the resource name'
      resourceType: 'Service Fabric'
    }
    upgradeDescription: {
      deltaHealthPolicy: {
        maxPercentDeltaUnhealthyApplications: 0
        maxPercentDeltaUnhealthyNodes: 0
        maxPercentUpgradeDomainDeltaUnhealthyNodes: 0
      }
      forceRestart: false
      healthCheckRetryTimeout: '00:45:00'
      healthCheckStableDuration: '00:01:00'
      healthCheckWaitDuration: '00:00:30'
      healthPolicy: {
        maxPercentUnhealthyApplications: 0
        maxPercentUnhealthyNodes: 0
      }
      upgradeDomainTimeout: '02:00:00'
      upgradeReplicaSetCheckTimeout: '1.00:00:00'
      upgradeTimeout: '02:00:00'
    }
    vmImage: 'Linux'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "managementEndpoint": {
      "value": "https://sfcwaf001.westeurope.cloudapp.azure.com:19080"
    },
    "name": {
      "value": "sfcwaf001"
    },
    "nodeTypes": {
      "value": [
        {
          "applicationPorts": {
            "endPort": 30000,
            "startPort": 20000
          },
          "clientConnectionEndpointPort": 19000,
          "durabilityLevel": "Silver",
          "ephemeralPorts": {
            "endPort": 65534,
            "startPort": 49152
          },
          "httpGatewayEndpointPort": 19080,
          "isPrimary": true,
          "isStateless": false,
          "multipleAvailabilityZones": false,
          "name": "Node01",
          "placementProperties": {},
          "reverseProxyEndpointPort": "",
          "vmInstanceCount": 5
        },
        {
          "applicationPorts": {
            "endPort": 30000,
            "startPort": 20000
          },
          "clientConnectionEndpointPort": 19000,
          "durabilityLevel": "Bronze",
          "ephemeralPorts": {
            "endPort": 64000,
            "httpGatewayEndpointPort": 19007,
            "isPrimary": true,
            "name": "Node02",
            "startPort": 49000,
            "vmInstanceCount": 5
          }
        }
      ]
    },
    "reliabilityLevel": {
      "value": "Silver"
    },
    // Non-required parameters
    "addOnFeatures": {
      "value": [
        "BackupRestoreService",
        "DnsService",
        "RepairManager",
        "ResourceMonitorService"
      ]
    },
    "applicationTypes": {
      "value": [
        {
          "name": "WordCount"
        }
      ]
    },
    "azureActiveDirectory": {
      "value": {
        "clientApplication": "<clientApplication>",
        "clusterApplication": "cf33fea8-b30f-424f-ab73-c48d99e0b222",
        "tenantId": "<tenantId>"
      }
    },
    "certificate": {
      "value": {
        "thumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130",
        "x509StoreName": "My"
      }
    },
    "clientCertificateCommonNames": {
      "value": [
        {
          "certificateCommonName": "clientcommoncert1",
          "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC130",
          "isAdmin": false
        },
        {
          "certificateCommonName": "clientcommoncert2",
          "certificateIssuerThumbprint": "0AC113D5E1D94C401DDEB0EE2B1B96CC131",
          "isAdmin": false
        }
      ]
    },
    "diagnosticsStorageAccountConfig": {
      "value": {
        "blobEndpoint": "<blobEndpoint>",
        "protectedAccountKeyName": "StorageAccountKey1",
        "queueEndpoint": "<queueEndpoint>",
        "storageAccountName": "<storageAccountName>",
        "tableEndpoint": "<tableEndpoint>"
      }
    },
    "fabricSettings": {
      "value": [
        {
          "name": "Security",
          "parameters": [
            {
              "name": "ClusterProtectionLevel",
              "value": "EncryptAndSign"
            }
          ]
        },
        {
          "name": "UpgradeService",
          "parameters": [
            {
              "name": "AppPollIntervalInSeconds",
              "value": "60"
            }
          ]
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "maxUnusedVersionsToKeep": {
      "value": 2
    },
    "notifications": {
      "value": [
        {
          "isEnabled": true,
          "notificationCategory": "WaveProgress",
          "notificationLevel": "Critical",
          "notificationTargets": [
            {
              "notificationChannel": "EmailUser",
              "receivers": [
                "SomeReceiver"
              ]
            }
          ]
        }
      ]
    },
    "tags": {
      "value": {
        "clusterName": "sfcwaf001",
        "hidden-title": "This is visible in the resource name",
        "resourceType": "Service Fabric"
      }
    },
    "upgradeDescription": {
      "value": {
        "deltaHealthPolicy": {
          "maxPercentDeltaUnhealthyApplications": 0,
          "maxPercentDeltaUnhealthyNodes": 0,
          "maxPercentUpgradeDomainDeltaUnhealthyNodes": 0
        },
        "forceRestart": false,
        "healthCheckRetryTimeout": "00:45:00",
        "healthCheckStableDuration": "00:01:00",
        "healthCheckWaitDuration": "00:00:30",
        "healthPolicy": {
          "maxPercentUnhealthyApplications": 0,
          "maxPercentUnhealthyNodes": 0
        },
        "upgradeDomainTimeout": "02:00:00",
        "upgradeReplicaSetCheckTimeout": "1.00:00:00",
        "upgradeTimeout": "02:00:00"
      }
    },
    "vmImage": {
      "value": "Linux"
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementEndpoint`](#parameter-managementendpoint) | string | The http management endpoint of the cluster. |
| [`name`](#parameter-name) | string | Name of the Service Fabric cluster. |
| [`nodeTypes`](#parameter-nodetypes) | array | The list of node types in the cluster. |
| [`reliabilityLevel`](#parameter-reliabilitylevel) | string | The reliability level sets the replica set size of system services. Learn about ReliabilityLevel (https://learn.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-capacity). - None - Run the System services with a target replica set count of 1. This should only be used for test clusters. - Bronze - Run the System services with a target replica set count of 3. This should only be used for test clusters. - Silver - Run the System services with a target replica set count of 5. - Gold - Run the System services with a target replica set count of 7. - Platinum - Run the System services with a target replica set count of 9. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificate`](#parameter-certificate) | object | The certificate to use for securing the cluster. The certificate provided will be used for node to node security within the cluster, SSL certificate for cluster management endpoint and default admin client. Required if the certificateCommonNames parameter is not used. |
| [`certificateCommonNames`](#parameter-certificatecommonnames) | object | Describes a list of server certificates referenced by common name that are used to secure the cluster. Required if the certificate parameter is not used. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addOnFeatures`](#parameter-addonfeatures) | array | The list of add-on features to enable in the cluster. |
| [`applicationTypes`](#parameter-applicationtypes) | array | Array of Service Fabric cluster application types. |
| [`azureActiveDirectory`](#parameter-azureactivedirectory) | object | The settings to enable AAD authentication on the cluster. |
| [`clientCertificateCommonNames`](#parameter-clientcertificatecommonnames) | array | The list of client certificates referenced by common name that are allowed to manage the cluster. Cannot be used if the clientCertificateThumbprints parameter is used. |
| [`clientCertificateThumbprints`](#parameter-clientcertificatethumbprints) | array | The list of client certificates referenced by thumbprint that are allowed to manage the cluster. Cannot be used if the clientCertificateCommonNames parameter is used. |
| [`clusterCodeVersion`](#parameter-clustercodeversion) | string | The Service Fabric runtime version of the cluster. This property can only by set the user when upgradeMode is set to "Manual". To get list of available Service Fabric versions for new clusters use ClusterVersion API. To get the list of available version for existing clusters use availableClusterVersions. |
| [`diagnosticsStorageAccountConfig`](#parameter-diagnosticsstorageaccountconfig) | object | The storage account information for storing Service Fabric diagnostic logs. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`eventStoreServiceEnabled`](#parameter-eventstoreserviceenabled) | bool | Indicates if the event store service is enabled. |
| [`fabricSettings`](#parameter-fabricsettings) | array | The list of custom fabric settings to configure the cluster. |
| [`infrastructureServiceManager`](#parameter-infrastructureservicemanager) | bool | Indicates if infrastructure service manager is enabled. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maxUnusedVersionsToKeep`](#parameter-maxunusedversionstokeep) | int | Number of unused versions per application type to keep. |
| [`notifications`](#parameter-notifications) | array | Indicates a list of notification channels for cluster events. |
| [`reverseProxyCertificate`](#parameter-reverseproxycertificate) | object | Describes the certificate details. |
| [`reverseProxyCertificateCommonNames`](#parameter-reverseproxycertificatecommonnames) | object | Describes a list of server certificates referenced by common name that are used to secure the cluster. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sfZonalUpgradeMode`](#parameter-sfzonalupgrademode) | string | This property controls the logical grouping of VMs in upgrade domains (UDs). This property cannot be modified if a node type with multiple Availability Zones is already present in the cluster. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`upgradeDescription`](#parameter-upgradedescription) | object | Describes the policy used when upgrading the cluster. |
| [`upgradeMode`](#parameter-upgrademode) | string | The upgrade mode of the cluster when new Service Fabric runtime version is available. |
| [`upgradePauseEndTimestampUtc`](#parameter-upgradepauseendtimestamputc) | string | Indicates the end date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC). |
| [`upgradePauseStartTimestampUtc`](#parameter-upgradepausestarttimestamputc) | string | Indicates the start date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC). |
| [`upgradeWave`](#parameter-upgradewave) | string | Indicates when new cluster runtime version upgrades will be applied after they are released. By default is Wave0. |
| [`vmImage`](#parameter-vmimage) | string | The VM image VMSS has been configured with. Generic names such as Windows or Linux can be used. |
| [`vmssZonalUpgradeMode`](#parameter-vmsszonalupgrademode) | string | This property defines the upgrade mode for the virtual machine scale set, it is mandatory if a node type with multiple Availability Zones is added. |
| [`waveUpgradePaused`](#parameter-waveupgradepaused) | bool | Boolean to pause automatic runtime version upgrades to the cluster. |

### Parameter: `managementEndpoint`

The http management endpoint of the cluster.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the Service Fabric cluster.

- Required: Yes
- Type: string

### Parameter: `nodeTypes`

The list of node types in the cluster.

- Required: Yes
- Type: array

### Parameter: `reliabilityLevel`

The reliability level sets the replica set size of system services. Learn about ReliabilityLevel (https://learn.microsoft.com/en-us/azure/service-fabric/service-fabric-cluster-capacity). - None - Run the System services with a target replica set count of 1. This should only be used for test clusters. - Bronze - Run the System services with a target replica set count of 3. This should only be used for test clusters. - Silver - Run the System services with a target replica set count of 5. - Gold - Run the System services with a target replica set count of 7. - Platinum - Run the System services with a target replica set count of 9.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Bronze'
    'Gold'
    'None'
    'Platinum'
    'Silver'
  ]
  ```

### Parameter: `certificate`

The certificate to use for securing the cluster. The certificate provided will be used for node to node security within the cluster, SSL certificate for cluster management endpoint and default admin client. Required if the certificateCommonNames parameter is not used.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`thumbprint`](#parameter-certificatethumbprint) | string | The thumbprint of the primary certificate. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`thumbprintSecondary`](#parameter-certificatethumbprintsecondary) | string | The thumbprint of the secondary certificate. |
| [`x509StoreName`](#parameter-certificatex509storename) | string | The local certificate store location. |

### Parameter: `certificate.thumbprint`

The thumbprint of the primary certificate.

- Required: Yes
- Type: string

### Parameter: `certificate.thumbprintSecondary`

The thumbprint of the secondary certificate.

- Required: No
- Type: string

### Parameter: `certificate.x509StoreName`

The local certificate store location.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AddressBook'
    'AuthRoot'
    'CertificateAuthority'
    'Disallowed'
    'My'
    'Root'
    'TrustedPeople'
    'TrustedPublisher'
  ]
  ```

### Parameter: `certificateCommonNames`

Describes a list of server certificates referenced by common name that are used to secure the cluster. Required if the certificate parameter is not used.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`commonNames`](#parameter-certificatecommonnamescommonnames) | array | The list of server certificates referenced by common name that are used to secure the cluster. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`x509StoreName`](#parameter-certificatecommonnamesx509storename) | string | The local certificate store location. |

### Parameter: `certificateCommonNames.commonNames`

The list of server certificates referenced by common name that are used to secure the cluster.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateCommonName`](#parameter-certificatecommonnamescommonnamescertificatecommonname) | string | The common name of the server certificate. |
| [`certificateIssuerThumbprint`](#parameter-certificatecommonnamescommonnamescertificateissuerthumbprint) | string | The issuer thumbprint of the server certificate. |

### Parameter: `certificateCommonNames.commonNames.certificateCommonName`

The common name of the server certificate.

- Required: Yes
- Type: string

### Parameter: `certificateCommonNames.commonNames.certificateIssuerThumbprint`

The issuer thumbprint of the server certificate.

- Required: Yes
- Type: string

### Parameter: `certificateCommonNames.x509StoreName`

The local certificate store location.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AddressBook'
    'AuthRoot'
    'CertificateAuthority'
    'Disallowed'
    'My'
    'Root'
    'TrustedPeople'
    'TrustedPublisher'
  ]
  ```

### Parameter: `addOnFeatures`

The list of add-on features to enable in the cluster.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'BackupRestoreService'
    'DnsService'
    'RepairManager'
    'ResourceMonitorService'
  ]
  ```

### Parameter: `applicationTypes`

Array of Service Fabric cluster application types.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `azureActiveDirectory`

The settings to enable AAD authentication on the cluster.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `clientCertificateCommonNames`

The list of client certificates referenced by common name that are allowed to manage the cluster. Cannot be used if the clientCertificateThumbprints parameter is used.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateCommonName`](#parameter-clientcertificatecommonnamescertificatecommonname) | string | The common name of the client certificate. |
| [`certificateIssuerThumbprint`](#parameter-clientcertificatecommonnamescertificateissuerthumbprint) | string | The issuer thumbprint of the client certificate. |
| [`isAdmin`](#parameter-clientcertificatecommonnamesisadmin) | bool | Indicates if the client certificate has admin access to the cluster. Non admin clients can perform only read only operations on the cluster. |

### Parameter: `clientCertificateCommonNames.certificateCommonName`

The common name of the client certificate.

- Required: Yes
- Type: string

### Parameter: `clientCertificateCommonNames.certificateIssuerThumbprint`

The issuer thumbprint of the client certificate.

- Required: Yes
- Type: string

### Parameter: `clientCertificateCommonNames.isAdmin`

Indicates if the client certificate has admin access to the cluster. Non admin clients can perform only read only operations on the cluster.

- Required: Yes
- Type: bool

### Parameter: `clientCertificateThumbprints`

The list of client certificates referenced by thumbprint that are allowed to manage the cluster. Cannot be used if the clientCertificateCommonNames parameter is used.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateThumbprint`](#parameter-clientcertificatethumbprintscertificatethumbprint) | string | The thumbprint of the client certificate. |
| [`isAdmin`](#parameter-clientcertificatethumbprintsisadmin) | bool | Indicates if the client certificate has admin access to the cluster. Non admin clients can perform only read only operations on the cluster. |

### Parameter: `clientCertificateThumbprints.certificateThumbprint`

The thumbprint of the client certificate.

- Required: Yes
- Type: string

### Parameter: `clientCertificateThumbprints.isAdmin`

Indicates if the client certificate has admin access to the cluster. Non admin clients can perform only read only operations on the cluster.

- Required: Yes
- Type: bool

### Parameter: `clusterCodeVersion`

The Service Fabric runtime version of the cluster. This property can only by set the user when upgradeMode is set to "Manual". To get list of available Service Fabric versions for new clusters use ClusterVersion API. To get the list of available version for existing clusters use availableClusterVersions.

- Required: No
- Type: string

### Parameter: `diagnosticsStorageAccountConfig`

The storage account information for storing Service Fabric diagnostic logs.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventStoreServiceEnabled`

Indicates if the event store service is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `fabricSettings`

The list of custom fabric settings to configure the cluster.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `infrastructureServiceManager`

Indicates if infrastructure service manager is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `maxUnusedVersionsToKeep`

Number of unused versions per application type to keep.

- Required: No
- Type: int
- Default: `3`

### Parameter: `notifications`

Indicates a list of notification channels for cluster events.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `reverseProxyCertificate`

Describes the certificate details.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `reverseProxyCertificateCommonNames`

Describes a list of server certificates referenced by common name that are used to secure the cluster.

- Required: No
- Type: object
- Default: `{}`

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

### Parameter: `sfZonalUpgradeMode`

This property controls the logical grouping of VMs in upgrade domains (UDs). This property cannot be modified if a node type with multiple Availability Zones is already present in the cluster.

- Required: No
- Type: string
- Default: `'Hierarchical'`
- Allowed:
  ```Bicep
  [
    'Hierarchical'
    'Parallel'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `upgradeDescription`

Describes the policy used when upgrading the cluster.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `upgradeMode`

The upgrade mode of the cluster when new Service Fabric runtime version is available.

- Required: No
- Type: string
- Default: `'Automatic'`
- Allowed:
  ```Bicep
  [
    'Automatic'
    'Manual'
  ]
  ```

### Parameter: `upgradePauseEndTimestampUtc`

Indicates the end date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC).

- Required: No
- Type: string

### Parameter: `upgradePauseStartTimestampUtc`

Indicates the start date and time to pause automatic runtime version upgrades on the cluster for an specific period of time on the cluster (UTC).

- Required: No
- Type: string

### Parameter: `upgradeWave`

Indicates when new cluster runtime version upgrades will be applied after they are released. By default is Wave0.

- Required: No
- Type: string
- Default: `'Wave0'`
- Allowed:
  ```Bicep
  [
    'Wave0'
    'Wave1'
    'Wave2'
  ]
  ```

### Parameter: `vmImage`

The VM image VMSS has been configured with. Generic names such as Windows or Linux can be used.

- Required: No
- Type: string

### Parameter: `vmssZonalUpgradeMode`

This property defines the upgrade mode for the virtual machine scale set, it is mandatory if a node type with multiple Availability Zones is added.

- Required: No
- Type: string
- Default: `'Hierarchical'`
- Allowed:
  ```Bicep
  [
    'Hierarchical'
    'Parallel'
  ]
  ```

### Parameter: `waveUpgradePaused`

Boolean to pause automatic runtime version upgrades to the cluster.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpoint` | string | The Service Fabric Cluster endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Service Fabric Cluster name. |
| `resourceGroupName` | string | The Service Fabric Cluster resource group. |
| `resourceId` | string | The Service Fabric Cluster resource ID. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
