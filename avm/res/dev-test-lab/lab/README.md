# DevTest Labs `[Microsoft.DevTestLab/labs]`

This module deploys a DevTest Lab.

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
| `Microsoft.DevTestLab/labs` | [2018-10-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/labs) |
| `Microsoft.DevTestLab/labs/artifactsources` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/artifactsources) |
| `Microsoft.DevTestLab/labs/costs` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/costs) |
| `Microsoft.DevTestLab/labs/notificationchannels` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/notificationchannels) |
| `Microsoft.DevTestLab/labs/policysets/policies` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/policysets/policies) |
| `Microsoft.DevTestLab/labs/schedules` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/schedules) |
| `Microsoft.DevTestLab/labs/virtualnetworks` | [2018-09-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/2018-09-15/labs/virtualnetworks) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/dev-test-lab/lab:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module lab 'br/public:avm/res/dev-test-lab/lab:<version>' = {
  name: 'labDeployment'
  params: {
    // Required parameters
    name: 'dtllmin001'
    // Non-required parameters
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
    "name": {
      "value": "dtllmin001"
    },
    // Non-required parameters
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
module lab 'br/public:avm/res/dev-test-lab/lab:<version>' = {
  name: 'labDeployment'
  params: {
    // Required parameters
    name: 'dtllmax001'
    // Non-required parameters
    announcement: {
      enabled: 'Enabled'
      expirationDate: '2028-12-30T13:00:00Z'
      markdown: 'DevTest Lab announcement text. <br> New line. It also supports Markdown'
      title: 'DevTest announcement title'
    }
    artifactsources: [
      {
        displayName: 'Public Artifact Repo'
        folderPath: '/Artifacts'
        name: 'Public Repo'
        sourceType: 'GitHub'
        status: 'Enabled'
        uri: 'https://github.com/Azure/azure-devtestlab.git'
      }
      {
        armTemplateFolderPath: '/Environments'
        branchRef: 'master'
        displayName: 'Public Environment Repo'
        name: 'Public Environment Repo'
        sourceType: 'GitHub'
        status: 'Disabled'
        tags: {
          'hidden-title': 'This is visible in the resource name'
          labName: 'dtllmax001'
          resourceType: 'DevTest Lab'
        }
        uri: 'https://github.com/Azure/azure-devtestlab.git'
      }
      {
        armTemplateFolderPath: '/ArmTemplates'
        branchRef: 'main'
        displayName: 'Private Artifact Repo'
        folderPath: '/Artifacts'
        name: 'Private Repo'
        securityToken: '<securityToken>'
        status: 'Disabled'
        uri: 'https://github.com/Azure/azure-devtestlab.git'
      }
    ]
    artifactsStorageAccount: '<artifactsStorageAccount>'
    browserConnect: 'Enabled'
    costs: {
      currencyCode: 'AUD'
      cycleType: 'CalendarMonth'
      status: 'Enabled'
      target: 450
      thresholdValue100DisplayOnChart: 'Enabled'
      thresholdValue100SendNotificationWhenExceeded: 'Enabled'
      thresholdValue125DisplayOnChart: 'Disabled'
      thresholdValue75DisplayOnChart: 'Enabled'
    }
    disableAutoUpgradeCseMinorVersion: true
    encryptionDiskEncryptionSetId: '<encryptionDiskEncryptionSetId>'
    encryptionType: 'EncryptionAtRestWithCustomerKey'
    environmentPermission: 'Contributor'
    extendedProperties: {
      RdpConnectionType: '7'
    }
    isolateLabResources: 'Enabled'
    labStorageType: 'Premium'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    managementIdentitiesResourceIds: [
      '<managedIdentityResourceId>'
    ]
    notificationchannels: [
      {
        description: 'Integration configured for auto-shutdown'
        emailRecipient: 'mail@contosodtlmail.com'
        events: [
          'AutoShutdown'
        ]
        name: 'autoShutdown'
        notificationLocale: 'en'
        webHookUrl: 'https://webhook.contosotest.com'
      }
      {
        events: [
          'Cost'
        ]
        name: 'costThreshold'
        webHookUrl: 'https://webhook.contosotest.com'
      }
    ]
    policies: [
      {
        evaluatorType: 'MaxValuePolicy'
        factData: '<factData>'
        factName: 'UserOwnedLabVmCountInSubnet'
        name: '<name>'
        threshold: '1'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'UserOwnedLabVmCount'
        name: 'MaxVmsAllowedPerUser'
        threshold: '2'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'UserOwnedLabPremiumVmCount'
        name: 'MaxPremiumVmsAllowedPerUser'
        status: 'Disabled'
        threshold: '1'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'LabVmCount'
        name: 'MaxVmsAllowedPerLab'
        threshold: '3'
      }
      {
        evaluatorType: 'MaxValuePolicy'
        factName: 'LabPremiumVmCount'
        name: 'MaxPremiumVmsAllowedPerLab'
        threshold: '2'
      }
      {
        evaluatorType: 'AllowedValuesPolicy'
        factData: ''
        factName: 'LabVmSize'
        name: 'AllowedVmSizesInLab'
        status: 'Enabled'
        threshold: '<threshold>'
      }
      {
        evaluatorType: 'AllowedValuesPolicy'
        factName: 'ScheduleEditPermission'
        name: 'ScheduleEditPermission'
        threshold: '<threshold>'
      }
      {
        evaluatorType: 'AllowedValuesPolicy'
        factName: 'GalleryImage'
        name: 'GalleryImage'
        threshold: '<threshold>'
      }
      {
        description: 'Public Environment Policy'
        evaluatorType: 'AllowedValuesPolicy'
        factName: 'EnvironmentTemplate'
        name: 'EnvironmentTemplate'
        threshold: '<threshold>'
      }
    ]
    premiumDataDisks: 'Enabled'
    roleAssignments: [
      {
        name: 'b08c589c-2c79-41bd-8195-d5e62ad12f67'
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
    schedules: [
      {
        dailyRecurrence: {
          time: '0000'
        }
        name: 'LabVmsShutdown'
        notificationSettings: {
          status: 'Enabled'
          timeInMinutes: 30
        }
        status: 'Enabled'
        taskType: 'LabVmsShutdownTask'
        timeZoneId: 'AUS Eastern Standard Time'
      }
      {
        name: 'LabVmAutoStart'
        status: 'Enabled'
        taskType: 'LabVmsStartupTask'
        timeZoneId: 'AUS Eastern Standard Time'
        weeklyRecurrence: {
          time: '0700'
          weekdays: [
            'Friday'
            'Monday'
            'Thursday'
            'Tuesday'
            'Wednesday'
          ]
        }
      }
    ]
    support: {
      enabled: 'Enabled'
      markdown: 'DevTest Lab support text. <br> New line. It also supports Markdown'
    }
    tags: {
      'hidden-title': 'This is visible in the resource name'
      labName: 'dtllmax001'
      resourceType: 'DevTest Lab'
    }
    virtualnetworks: [
      {
        allowedSubnets: [
          {
            allowPublicIp: 'Allow'
            labSubnetName: '<labSubnetName>'
            resourceId: '<resourceId>'
          }
          {
            allowPublicIp: 'Deny'
            labSubnetName: '<labSubnetName>'
            resourceId: '<resourceId>'
          }
        ]
        description: 'lab virtual network description'
        externalProviderResourceId: '<externalProviderResourceId>'
        name: '<name>'
        subnetOverrides: [
          {
            labSubnetName: '<labSubnetName>'
            resourceId: '<resourceId>'
            sharedPublicIpAddressConfiguration: {
              allowedPorts: [
                {
                  backendPort: 3389
                  transportProtocol: 'Tcp'
                }
                {
                  backendPort: 22
                  transportProtocol: 'Tcp'
                }
              ]
            }
            useInVmCreationPermission: 'Allow'
            usePublicIpAddressPermission: 'Allow'
          }
          {
            labSubnetName: '<labSubnetName>'
            resourceId: '<resourceId>'
            useInVmCreationPermission: 'Deny'
            usePublicIpAddressPermission: 'Deny'
          }
        ]
      }
    ]
    vmCreationResourceGroupId: '<vmCreationResourceGroupId>'
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
    "name": {
      "value": "dtllmax001"
    },
    // Non-required parameters
    "announcement": {
      "value": {
        "enabled": "Enabled",
        "expirationDate": "2028-12-30T13:00:00Z",
        "markdown": "DevTest Lab announcement text. <br> New line. It also supports Markdown",
        "title": "DevTest announcement title"
      }
    },
    "artifactsources": {
      "value": [
        {
          "displayName": "Public Artifact Repo",
          "folderPath": "/Artifacts",
          "name": "Public Repo",
          "sourceType": "GitHub",
          "status": "Enabled",
          "uri": "https://github.com/Azure/azure-devtestlab.git"
        },
        {
          "armTemplateFolderPath": "/Environments",
          "branchRef": "master",
          "displayName": "Public Environment Repo",
          "name": "Public Environment Repo",
          "sourceType": "GitHub",
          "status": "Disabled",
          "tags": {
            "hidden-title": "This is visible in the resource name",
            "labName": "dtllmax001",
            "resourceType": "DevTest Lab"
          },
          "uri": "https://github.com/Azure/azure-devtestlab.git"
        },
        {
          "armTemplateFolderPath": "/ArmTemplates",
          "branchRef": "main",
          "displayName": "Private Artifact Repo",
          "folderPath": "/Artifacts",
          "name": "Private Repo",
          "securityToken": "<securityToken>",
          "status": "Disabled",
          "uri": "https://github.com/Azure/azure-devtestlab.git"
        }
      ]
    },
    "artifactsStorageAccount": {
      "value": "<artifactsStorageAccount>"
    },
    "browserConnect": {
      "value": "Enabled"
    },
    "costs": {
      "value": {
        "currencyCode": "AUD",
        "cycleType": "CalendarMonth",
        "status": "Enabled",
        "target": 450,
        "thresholdValue100DisplayOnChart": "Enabled",
        "thresholdValue100SendNotificationWhenExceeded": "Enabled",
        "thresholdValue125DisplayOnChart": "Disabled",
        "thresholdValue75DisplayOnChart": "Enabled"
      }
    },
    "disableAutoUpgradeCseMinorVersion": {
      "value": true
    },
    "encryptionDiskEncryptionSetId": {
      "value": "<encryptionDiskEncryptionSetId>"
    },
    "encryptionType": {
      "value": "EncryptionAtRestWithCustomerKey"
    },
    "environmentPermission": {
      "value": "Contributor"
    },
    "extendedProperties": {
      "value": {
        "RdpConnectionType": "7"
      }
    },
    "isolateLabResources": {
      "value": "Enabled"
    },
    "labStorageType": {
      "value": "Premium"
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
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "managementIdentitiesResourceIds": {
      "value": [
        "<managedIdentityResourceId>"
      ]
    },
    "notificationchannels": {
      "value": [
        {
          "description": "Integration configured for auto-shutdown",
          "emailRecipient": "mail@contosodtlmail.com",
          "events": [
            "AutoShutdown"
          ],
          "name": "autoShutdown",
          "notificationLocale": "en",
          "webHookUrl": "https://webhook.contosotest.com"
        },
        {
          "events": [
            "Cost"
          ],
          "name": "costThreshold",
          "webHookUrl": "https://webhook.contosotest.com"
        }
      ]
    },
    "policies": {
      "value": [
        {
          "evaluatorType": "MaxValuePolicy",
          "factData": "<factData>",
          "factName": "UserOwnedLabVmCountInSubnet",
          "name": "<name>",
          "threshold": "1"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "UserOwnedLabVmCount",
          "name": "MaxVmsAllowedPerUser",
          "threshold": "2"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "UserOwnedLabPremiumVmCount",
          "name": "MaxPremiumVmsAllowedPerUser",
          "status": "Disabled",
          "threshold": "1"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "LabVmCount",
          "name": "MaxVmsAllowedPerLab",
          "threshold": "3"
        },
        {
          "evaluatorType": "MaxValuePolicy",
          "factName": "LabPremiumVmCount",
          "name": "MaxPremiumVmsAllowedPerLab",
          "threshold": "2"
        },
        {
          "evaluatorType": "AllowedValuesPolicy",
          "factData": "",
          "factName": "LabVmSize",
          "name": "AllowedVmSizesInLab",
          "status": "Enabled",
          "threshold": "<threshold>"
        },
        {
          "evaluatorType": "AllowedValuesPolicy",
          "factName": "ScheduleEditPermission",
          "name": "ScheduleEditPermission",
          "threshold": "<threshold>"
        },
        {
          "evaluatorType": "AllowedValuesPolicy",
          "factName": "GalleryImage",
          "name": "GalleryImage",
          "threshold": "<threshold>"
        },
        {
          "description": "Public Environment Policy",
          "evaluatorType": "AllowedValuesPolicy",
          "factName": "EnvironmentTemplate",
          "name": "EnvironmentTemplate",
          "threshold": "<threshold>"
        }
      ]
    },
    "premiumDataDisks": {
      "value": "Enabled"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "b08c589c-2c79-41bd-8195-d5e62ad12f67",
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
    "schedules": {
      "value": [
        {
          "dailyRecurrence": {
            "time": "0000"
          },
          "name": "LabVmsShutdown",
          "notificationSettings": {
            "status": "Enabled",
            "timeInMinutes": 30
          },
          "status": "Enabled",
          "taskType": "LabVmsShutdownTask",
          "timeZoneId": "AUS Eastern Standard Time"
        },
        {
          "name": "LabVmAutoStart",
          "status": "Enabled",
          "taskType": "LabVmsStartupTask",
          "timeZoneId": "AUS Eastern Standard Time",
          "weeklyRecurrence": {
            "time": "0700",
            "weekdays": [
              "Friday",
              "Monday",
              "Thursday",
              "Tuesday",
              "Wednesday"
            ]
          }
        }
      ]
    },
    "support": {
      "value": {
        "enabled": "Enabled",
        "markdown": "DevTest Lab support text. <br> New line. It also supports Markdown"
      }
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "labName": "dtllmax001",
        "resourceType": "DevTest Lab"
      }
    },
    "virtualnetworks": {
      "value": [
        {
          "allowedSubnets": [
            {
              "allowPublicIp": "Allow",
              "labSubnetName": "<labSubnetName>",
              "resourceId": "<resourceId>"
            },
            {
              "allowPublicIp": "Deny",
              "labSubnetName": "<labSubnetName>",
              "resourceId": "<resourceId>"
            }
          ],
          "description": "lab virtual network description",
          "externalProviderResourceId": "<externalProviderResourceId>",
          "name": "<name>",
          "subnetOverrides": [
            {
              "labSubnetName": "<labSubnetName>",
              "resourceId": "<resourceId>",
              "sharedPublicIpAddressConfiguration": {
                "allowedPorts": [
                  {
                    "backendPort": 3389,
                    "transportProtocol": "Tcp"
                  },
                  {
                    "backendPort": 22,
                    "transportProtocol": "Tcp"
                  }
                ]
              },
              "useInVmCreationPermission": "Allow",
              "usePublicIpAddressPermission": "Allow"
            },
            {
              "labSubnetName": "<labSubnetName>",
              "resourceId": "<resourceId>",
              "useInVmCreationPermission": "Deny",
              "usePublicIpAddressPermission": "Deny"
            }
          ]
        }
      ]
    },
    "vmCreationResourceGroupId": {
      "value": "<vmCreationResourceGroupId>"
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
module lab 'br/public:avm/res/dev-test-lab/lab:<version>' = {
  name: 'labDeployment'
  params: {
    // Required parameters
    name: 'dtllwaf001'
    // Non-required parameters
    location: '<location>'
    tags: {
      'hidden-title': 'This is visible in the resource name'
      labName: 'dtllwaf001'
      resourceType: 'DevTest Lab'
    }
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
    "name": {
      "value": "dtllwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "tags": {
      "value": {
        "hidden-title": "This is visible in the resource name",
        "labName": "dtllwaf001",
        "resourceType": "DevTest Lab"
      }
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
| [`name`](#parameter-name) | string | The name of the lab. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`encryptionDiskEncryptionSetId`](#parameter-encryptiondiskencryptionsetid) | string | The Disk Encryption Set Resource ID used to encrypt OS and data disks created as part of the the lab. Required if encryptionType is set to "EncryptionAtRestWithCustomerKey". |
| [`notificationchannels`](#parameter-notificationchannels) | array | Notification Channels to create for the lab. Required if the schedules property "notificationSettingsStatus" is set to "Enabled. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`announcement`](#parameter-announcement) | object | The properties of any lab announcement associated with this lab. |
| [`artifactsources`](#parameter-artifactsources) | array | Artifact sources to create for the lab. |
| [`artifactsStorageAccount`](#parameter-artifactsstorageaccount) | string | The resource ID of the storage account used to store artifacts and images by the lab. Also used for defaultStorageAccount, defaultPremiumStorageAccount and premiumDataDiskStorageAccount properties. If left empty, a default storage account will be created by the lab and used. |
| [`browserConnect`](#parameter-browserconnect) | string | Enable browser connect on virtual machines if the lab's VNETs have configured Azure Bastion. |
| [`costs`](#parameter-costs) | object | Costs to create for the lab. |
| [`disableAutoUpgradeCseMinorVersion`](#parameter-disableautoupgradecseminorversion) | bool | Disable auto upgrade custom script extension minor version. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`encryptionType`](#parameter-encryptiontype) | string | Specify how OS and data disks created as part of the lab are encrypted. |
| [`environmentPermission`](#parameter-environmentpermission) | string | The access rights to be granted to the user when provisioning an environment. |
| [`extendedProperties`](#parameter-extendedproperties) | object | Extended properties of the lab used for experimental features. |
| [`isolateLabResources`](#parameter-isolatelabresources) | string | Enable lab resources isolation from the public internet. |
| [`labStorageType`](#parameter-labstoragetype) | string | Type of storage used by the lab. It can be either Premium or Standard. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. For new labs created after 8/10/2020, the lab's system assigned identity is set to On by default and lab owner will not be able to turn this off for the lifecycle of the lab. |
| [`managementIdentitiesResourceIds`](#parameter-managementidentitiesresourceids) | array | The resource ID(s) to assign to the virtual machines associated with this lab. |
| [`mandatoryArtifactsResourceIdsLinux`](#parameter-mandatoryartifactsresourceidslinux) | array | The ordered list of artifact resource IDs that should be applied on all Linux VM creations by default, prior to the artifacts specified by the user. |
| [`mandatoryArtifactsResourceIdsWindows`](#parameter-mandatoryartifactsresourceidswindows) | array | The ordered list of artifact resource IDs that should be applied on all Windows VM creations by default, prior to the artifacts specified by the user. |
| [`policies`](#parameter-policies) | array | Policies to create for the lab. |
| [`premiumDataDisks`](#parameter-premiumdatadisks) | string | The setting to enable usage of premium data disks. When its value is "Enabled", creation of standard or premium data disks is allowed. When its value is "Disabled", only creation of standard data disks is allowed. Default is "Disabled". |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`schedules`](#parameter-schedules) | array | Schedules to create for the lab. |
| [`support`](#parameter-support) | object | The properties of any lab support message associated with this lab. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualnetworks`](#parameter-virtualnetworks) | array | Virtual networks to create for the lab. |
| [`vmCreationResourceGroupId`](#parameter-vmcreationresourcegroupid) | string | Resource Group allocation for virtual machines. If left empty, virtual machines will be deployed in their own Resource Groups. Default is the same Resource Group for DevTest Lab. |

### Parameter: `name`

The name of the lab.

- Required: Yes
- Type: string

### Parameter: `encryptionDiskEncryptionSetId`

The Disk Encryption Set Resource ID used to encrypt OS and data disks created as part of the the lab. Required if encryptionType is set to "EncryptionAtRestWithCustomerKey".

- Required: No
- Type: string
- Default: `''`

### Parameter: `notificationchannels`

Notification Channels to create for the lab. Required if the schedules property "notificationSettingsStatus" is set to "Enabled.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`events`](#parameter-notificationchannelsevents) | array | The list of event for which this notification is enabled. Can be "AutoShutdown" or "Cost". |
| [`name`](#parameter-notificationchannelsname) | string | The name of the notification channel. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailRecipient`](#parameter-notificationchannelsemailrecipient) | string | The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty. |
| [`webHookUrl`](#parameter-notificationchannelswebhookurl) | string | The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-notificationchannelsdescription) | string | The description of the notification. |
| [`notificationLocale`](#parameter-notificationchannelsnotificationlocale) | string | The locale to use when sending a notification (fallback for unsupported languages is EN). |
| [`tags`](#parameter-notificationchannelstags) | object | The tags of the notification channel. |

### Parameter: `notificationchannels.events`

The list of event for which this notification is enabled. Can be "AutoShutdown" or "Cost".

- Required: Yes
- Type: array

### Parameter: `notificationchannels.name`

The name of the notification channel.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'autoShutdown'
    'costThreshold'
  ]
  ```

### Parameter: `notificationchannels.emailRecipient`

The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.

- Required: No
- Type: string

### Parameter: `notificationchannels.webHookUrl`

The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.

- Required: No
- Type: string

### Parameter: `notificationchannels.description`

The description of the notification.

- Required: No
- Type: string

### Parameter: `notificationchannels.notificationLocale`

The locale to use when sending a notification (fallback for unsupported languages is EN).

- Required: No
- Type: string

### Parameter: `notificationchannels.tags`

The tags of the notification channel.

- Required: No
- Type: object

### Parameter: `announcement`

The properties of any lab announcement associated with this lab.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `artifactsources`

Artifact sources to create for the lab.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-artifactsourcesname) | string | The name of the artifact source. |
| [`uri`](#parameter-artifactsourcesuri) | string | The artifact source's URI. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`armTemplateFolderPath`](#parameter-artifactsourcesarmtemplatefolderpath) | string | The folder containing Azure Resource Manager templates. Required if "folderPath" is empty. |
| [`folderPath`](#parameter-artifactsourcesfolderpath) | string | The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branchRef`](#parameter-artifactsourcesbranchref) | string | The artifact source's branch reference (e.g. main or master). |
| [`displayName`](#parameter-artifactsourcesdisplayname) | string | The display name of the artifact source. Default is the name of the artifact source. |
| [`securityToken`](#parameter-artifactsourcessecuritytoken) | securestring | The security token to authenticate to the artifact source. Private artifacts use the system-identity of the lab to store the security token for the artifact source in the lab's managed Azure Key Vault. Access to the Azure Key Vault is granted automatically only when the lab is created with a system-assigned identity. |
| [`sourceType`](#parameter-artifactsourcessourcetype) | string | The artifact source's type. |
| [`status`](#parameter-artifactsourcesstatus) | string | Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled". |
| [`tags`](#parameter-artifactsourcestags) | object | The tags of the artifact source. |

### Parameter: `artifactsources.name`

The name of the artifact source.

- Required: Yes
- Type: string

### Parameter: `artifactsources.uri`

The artifact source's URI.

- Required: Yes
- Type: string

### Parameter: `artifactsources.armTemplateFolderPath`

The folder containing Azure Resource Manager templates. Required if "folderPath" is empty.

- Required: No
- Type: string

### Parameter: `artifactsources.folderPath`

The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty.

- Required: No
- Type: string

### Parameter: `artifactsources.branchRef`

The artifact source's branch reference (e.g. main or master).

- Required: No
- Type: string

### Parameter: `artifactsources.displayName`

The display name of the artifact source. Default is the name of the artifact source.

- Required: No
- Type: string

### Parameter: `artifactsources.securityToken`

The security token to authenticate to the artifact source. Private artifacts use the system-identity of the lab to store the security token for the artifact source in the lab's managed Azure Key Vault. Access to the Azure Key Vault is granted automatically only when the lab is created with a system-assigned identity.

- Required: No
- Type: securestring

### Parameter: `artifactsources.sourceType`

The artifact source's type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'GitHub'
    'StorageAccount'
    'VsoGit'
  ]
  ```

### Parameter: `artifactsources.status`

Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `artifactsources.tags`

The tags of the artifact source.

- Required: No
- Type: object

### Parameter: `artifactsStorageAccount`

The resource ID of the storage account used to store artifacts and images by the lab. Also used for defaultStorageAccount, defaultPremiumStorageAccount and premiumDataDiskStorageAccount properties. If left empty, a default storage account will be created by the lab and used.

- Required: No
- Type: string
- Default: `''`

### Parameter: `browserConnect`

Enable browser connect on virtual machines if the lab's VNETs have configured Azure Bastion.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs`

Costs to create for the lab.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cycleType`](#parameter-costscycletype) | string | Reporting cycle type. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cycleEndDateTime`](#parameter-costscycleenddatetime) | string | Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom". |
| [`cycleStartDateTime`](#parameter-costscyclestartdatetime) | string | Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`currencyCode`](#parameter-costscurrencycode) | string | The currency code of the cost. Default is "USD". |
| [`status`](#parameter-costsstatus) | string | Target cost status. |
| [`tags`](#parameter-coststags) | object | The tags of the resource. |
| [`target`](#parameter-coststarget) | int | Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds. |
| [`thresholdValue100DisplayOnChart`](#parameter-coststhresholdvalue100displayonchart) | string | Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue100SendNotificationWhenExceeded`](#parameter-coststhresholdvalue100sendnotificationwhenexceeded) | string | Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue125DisplayOnChart`](#parameter-coststhresholdvalue125displayonchart) | string | Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue125SendNotificationWhenExceeded`](#parameter-coststhresholdvalue125sendnotificationwhenexceeded) | string | Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue25DisplayOnChart`](#parameter-coststhresholdvalue25displayonchart) | string | Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue25SendNotificationWhenExceeded`](#parameter-coststhresholdvalue25sendnotificationwhenexceeded) | string | Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue50DisplayOnChart`](#parameter-coststhresholdvalue50displayonchart) | string | Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue50SendNotificationWhenExceeded`](#parameter-coststhresholdvalue50sendnotificationwhenexceeded) | string | Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |
| [`thresholdValue75DisplayOnChart`](#parameter-coststhresholdvalue75displayonchart) | string | Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts. |
| [`thresholdValue75SendNotificationWhenExceeded`](#parameter-coststhresholdvalue75sendnotificationwhenexceeded) | string | Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded. |

### Parameter: `costs.cycleType`

Reporting cycle type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CalendarMonth'
    'Custom'
  ]
  ```

### Parameter: `costs.cycleEndDateTime`

Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".

- Required: No
- Type: string

### Parameter: `costs.cycleStartDateTime`

Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".

- Required: No
- Type: string

### Parameter: `costs.currencyCode`

The currency code of the cost. Default is "USD".

- Required: No
- Type: string

### Parameter: `costs.status`

Target cost status.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.tags`

The tags of the resource.

- Required: No
- Type: object

### Parameter: `costs.target`

Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds.

- Required: No
- Type: int

### Parameter: `costs.thresholdValue100DisplayOnChart`

Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue100SendNotificationWhenExceeded`

Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue125DisplayOnChart`

Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue125SendNotificationWhenExceeded`

Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue25DisplayOnChart`

Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue25SendNotificationWhenExceeded`

Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue50DisplayOnChart`

Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue50SendNotificationWhenExceeded`

Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue75DisplayOnChart`

Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `costs.thresholdValue75SendNotificationWhenExceeded`

Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `disableAutoUpgradeCseMinorVersion`

Disable auto upgrade custom script extension minor version.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `encryptionType`

Specify how OS and data disks created as part of the lab are encrypted.

- Required: No
- Type: string
- Default: `'EncryptionAtRestWithPlatformKey'`
- Allowed:
  ```Bicep
  [
    'EncryptionAtRestWithCustomerKey'
    'EncryptionAtRestWithPlatformKey'
  ]
  ```

### Parameter: `environmentPermission`

The access rights to be granted to the user when provisioning an environment.

- Required: No
- Type: string
- Default: `'Reader'`
- Allowed:
  ```Bicep
  [
    'Contributor'
    'Reader'
  ]
  ```

### Parameter: `extendedProperties`

Extended properties of the lab used for experimental features.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `isolateLabResources`

Enable lab resources isolation from the public internet.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `labStorageType`

Type of storage used by the lab. It can be either Premium or Standard.

- Required: No
- Type: string
- Default: `'Premium'`
- Allowed:
  ```Bicep
  [
    'Premium'
    'Standard'
    'StandardSSD'
  ]
  ```

### Parameter: `location`

Location for all Resources.

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

### Parameter: `managedIdentities`

The managed identity definition for this resource. For new labs created after 8/10/2020, the lab's system assigned identity is set to On by default and lab owner will not be able to turn this off for the lifecycle of the lab.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Currently, a single user-assigned identity is supported per lab. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Currently, a single user-assigned identity is supported per lab.

- Required: Yes
- Type: array

### Parameter: `managementIdentitiesResourceIds`

The resource ID(s) to assign to the virtual machines associated with this lab.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `mandatoryArtifactsResourceIdsLinux`

The ordered list of artifact resource IDs that should be applied on all Linux VM creations by default, prior to the artifacts specified by the user.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `mandatoryArtifactsResourceIdsWindows`

The ordered list of artifact resource IDs that should be applied on all Windows VM creations by default, prior to the artifacts specified by the user.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `policies`

Policies to create for the lab.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`evaluatorType`](#parameter-policiesevaluatortype) | string | The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy). |
| [`factName`](#parameter-policiesfactname) | string | The fact name of the policy. |
| [`name`](#parameter-policiesname) | string | The name of the policy. |
| [`threshold`](#parameter-policiesthreshold) | string | The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-policiesdescription) | string | The description of the policy. |
| [`factData`](#parameter-policiesfactdata) | string | The fact data of the policy. |
| [`status`](#parameter-policiesstatus) | string | The status of the policy. Default is "Enabled". |

### Parameter: `policies.evaluatorType`

The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AllowedValuesPolicy'
    'MaxValuePolicy'
  ]
  ```

### Parameter: `policies.factName`

The fact name of the policy.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'EnvironmentTemplate'
    'GalleryImage'
    'LabPremiumVmCount'
    'LabTargetCost'
    'LabVmCount'
    'LabVmSize'
    'ScheduleEditPermission'
    'UserOwnedLabPremiumVmCount'
    'UserOwnedLabVmCount'
    'UserOwnedLabVmCountInSubnet'
  ]
  ```

### Parameter: `policies.name`

The name of the policy.

- Required: Yes
- Type: string

### Parameter: `policies.threshold`

The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy).

- Required: Yes
- Type: string

### Parameter: `policies.description`

The description of the policy.

- Required: No
- Type: string

### Parameter: `policies.factData`

The fact data of the policy.

- Required: No
- Type: string

### Parameter: `policies.status`

The status of the policy. Default is "Enabled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `premiumDataDisks`

The setting to enable usage of premium data disks. When its value is "Enabled", creation of standard or premium data disks is allowed. When its value is "Disabled", only creation of standard data disks is allowed. Default is "Disabled".

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalIds' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DevTest Labs User'`
  - `'Owner'`
  - `'Reader'`
  - `'Resource Policy Contributor'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`
  - `'Virtual Machine Contributor'`

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

### Parameter: `schedules`

Schedules to create for the lab.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-schedulesname) | string | The name of the schedule. |
| [`taskType`](#parameter-schedulestasktype) | string | The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dailyRecurrence`](#parameter-schedulesdailyrecurrence) | object | The daily recurrence of the schedule. |
| [`hourlyRecurrence`](#parameter-scheduleshourlyrecurrence) | object | If the schedule will occur multiple times a day, specify the hourly recurrence. |
| [`notificationSettings`](#parameter-schedulesnotificationsettings) | object | The notification settings for the schedule. |
| [`status`](#parameter-schedulesstatus) | string | The status of the schedule (i.e. Enabled, Disabled). Default is "Enabled". |
| [`tags`](#parameter-schedulestags) | object | The tags of the schedule. |
| [`targetResourceId`](#parameter-schedulestargetresourceid) | string | The resource ID to which the schedule belongs. |
| [`timeZoneId`](#parameter-schedulestimezoneid) | string | The time zone ID of the schedule. Defaults to "Pacific Standard time". |
| [`weeklyRecurrence`](#parameter-schedulesweeklyrecurrence) | object | If the schedule will occur only some days of the week, specify the weekly recurrence. |

### Parameter: `schedules.name`

The name of the schedule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LabVmAutoStart'
    'LabVmsShutdown'
  ]
  ```

### Parameter: `schedules.taskType`

The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'LabVmsShutdownTask'
    'LabVmsStartupTask'
  ]
  ```

### Parameter: `schedules.dailyRecurrence`

The daily recurrence of the schedule.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`time`](#parameter-schedulesdailyrecurrencetime) | string | The time of day the schedule will occur. |

### Parameter: `schedules.dailyRecurrence.time`

The time of day the schedule will occur.

- Required: Yes
- Type: string

### Parameter: `schedules.hourlyRecurrence`

If the schedule will occur multiple times a day, specify the hourly recurrence.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minute`](#parameter-scheduleshourlyrecurrenceminute) | int | Minutes of the hour the schedule will run. |

### Parameter: `schedules.hourlyRecurrence.minute`

Minutes of the hour the schedule will run.

- Required: Yes
- Type: int

### Parameter: `schedules.notificationSettings`

The notification settings for the schedule.

- Required: No
- Type: object

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`emailRecipient`](#parameter-schedulesnotificationsettingsemailrecipient) | string | The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty. |
| [`webHookUrl`](#parameter-schedulesnotificationsettingswebhookurl) | string | The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`notificationLocale`](#parameter-schedulesnotificationsettingsnotificationlocale) | string | The locale to use when sending a notification (fallback for unsupported languages is EN). |
| [`status`](#parameter-schedulesnotificationsettingsstatus) | string | If notifications are enabled for this schedule (i.e. Enabled, Disabled). Default is Disabled. |
| [`timeInMinutes`](#parameter-schedulesnotificationsettingstimeinminutes) | int | Time in minutes before event at which notification will be sent. Default is 30 minutes if status is Enabled and not specified. |

### Parameter: `schedules.notificationSettings.emailRecipient`

The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.

- Required: No
- Type: string

### Parameter: `schedules.notificationSettings.webHookUrl`

The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.

- Required: No
- Type: string

### Parameter: `schedules.notificationSettings.notificationLocale`

The locale to use when sending a notification (fallback for unsupported languages is EN).

- Required: No
- Type: string

### Parameter: `schedules.notificationSettings.status`

If notifications are enabled for this schedule (i.e. Enabled, Disabled). Default is Disabled.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `schedules.notificationSettings.timeInMinutes`

Time in minutes before event at which notification will be sent. Default is 30 minutes if status is Enabled and not specified.

- Required: No
- Type: int

### Parameter: `schedules.status`

The status of the schedule (i.e. Enabled, Disabled). Default is "Enabled".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `schedules.tags`

The tags of the schedule.

- Required: No
- Type: object

### Parameter: `schedules.targetResourceId`

The resource ID to which the schedule belongs.

- Required: No
- Type: string

### Parameter: `schedules.timeZoneId`

The time zone ID of the schedule. Defaults to "Pacific Standard time".

- Required: No
- Type: string

### Parameter: `schedules.weeklyRecurrence`

If the schedule will occur only some days of the week, specify the weekly recurrence.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`time`](#parameter-schedulesweeklyrecurrencetime) | string | The time of day the schedule will occur. |
| [`weekdays`](#parameter-schedulesweeklyrecurrenceweekdays) | array | The days of the week for which the schedule is set (e.g. Sunday, Monday, Tuesday, etc.). |

### Parameter: `schedules.weeklyRecurrence.time`

The time of day the schedule will occur.

- Required: Yes
- Type: string

### Parameter: `schedules.weeklyRecurrence.weekdays`

The days of the week for which the schedule is set (e.g. Sunday, Monday, Tuesday, etc.).

- Required: Yes
- Type: array

### Parameter: `support`

The properties of any lab support message associated with this lab.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualnetworks`

Virtual networks to create for the lab.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalProviderResourceId`](#parameter-virtualnetworksexternalproviderresourceid) | string | The external provider resource ID of the virtual network. |
| [`name`](#parameter-virtualnetworksname) | string | The name of the virtual network. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedSubnets`](#parameter-virtualnetworksallowedsubnets) | array | The allowed subnets of the virtual network. |
| [`description`](#parameter-virtualnetworksdescription) | string | The description of the virtual network. |
| [`subnetOverrides`](#parameter-virtualnetworkssubnetoverrides) | array | The subnet overrides of the virtual network. |
| [`tags`](#parameter-virtualnetworkstags) | object | The tags of the virtual network. |

### Parameter: `virtualnetworks.externalProviderResourceId`

The external provider resource ID of the virtual network.

- Required: Yes
- Type: string

### Parameter: `virtualnetworks.name`

The name of the virtual network.

- Required: Yes
- Type: string

### Parameter: `virtualnetworks.allowedSubnets`

The allowed subnets of the virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labSubnetName`](#parameter-virtualnetworksallowedsubnetslabsubnetname) | string | The name of the subnet as seen in the lab. |
| [`resourceId`](#parameter-virtualnetworksallowedsubnetsresourceid) | string | The resource ID of the allowed subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowPublicIp`](#parameter-virtualnetworksallowedsubnetsallowpublicip) | string | The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)). |

### Parameter: `virtualnetworks.allowedSubnets.labSubnetName`

The name of the subnet as seen in the lab.

- Required: Yes
- Type: string

### Parameter: `virtualnetworks.allowedSubnets.resourceId`

The resource ID of the allowed subnet.

- Required: Yes
- Type: string

### Parameter: `virtualnetworks.allowedSubnets.allowPublicIp`

The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Default'
    'Deny'
  ]
  ```

### Parameter: `virtualnetworks.description`

The description of the virtual network.

- Required: No
- Type: string

### Parameter: `virtualnetworks.subnetOverrides`

The subnet overrides of the virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labSubnetName`](#parameter-virtualnetworkssubnetoverrideslabsubnetname) | string | The name given to the subnet within the lab. |
| [`resourceId`](#parameter-virtualnetworkssubnetoverridesresourceid) | string | The resource ID of the subnet. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sharedPublicIpAddressConfiguration`](#parameter-virtualnetworkssubnetoverridessharedpublicipaddressconfiguration) | object | The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)). |
| [`useInVmCreationPermission`](#parameter-virtualnetworkssubnetoverridesuseinvmcreationpermission) | string | Indicates whether this subnet can be used during virtual machine creation (i.e. Allow, Deny). |
| [`usePublicIpAddressPermission`](#parameter-virtualnetworkssubnetoverridesusepublicipaddresspermission) | string | Indicates whether public IP addresses can be assigned to virtual machines on this subnet (i.e. Allow, Deny). |
| [`virtualNetworkPoolName`](#parameter-virtualnetworkssubnetoverridesvirtualnetworkpoolname) | string | The virtual network pool associated with this subnet. |

### Parameter: `virtualnetworks.subnetOverrides.labSubnetName`

The name given to the subnet within the lab.

- Required: Yes
- Type: string

### Parameter: `virtualnetworks.subnetOverrides.resourceId`

The resource ID of the subnet.

- Required: Yes
- Type: string

### Parameter: `virtualnetworks.subnetOverrides.sharedPublicIpAddressConfiguration`

The permission policy of the subnet for allowing public IP addresses (i.e. Allow, Deny)).

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedPorts`](#parameter-virtualnetworkssubnetoverridessharedpublicipaddressconfigurationallowedports) | array | Backend ports that virtual machines on this subnet are allowed to expose. |

### Parameter: `virtualnetworks.subnetOverrides.sharedPublicIpAddressConfiguration.allowedPorts`

Backend ports that virtual machines on this subnet are allowed to expose.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendPort`](#parameter-virtualnetworkssubnetoverridessharedpublicipaddressconfigurationallowedportsbackendport) | int | Backend port of the target virtual machine. |
| [`transportProtocol`](#parameter-virtualnetworkssubnetoverridessharedpublicipaddressconfigurationallowedportstransportprotocol) | string | Protocol type of the port. |

### Parameter: `virtualnetworks.subnetOverrides.sharedPublicIpAddressConfiguration.allowedPorts.backendPort`

Backend port of the target virtual machine.

- Required: Yes
- Type: int

### Parameter: `virtualnetworks.subnetOverrides.sharedPublicIpAddressConfiguration.allowedPorts.transportProtocol`

Protocol type of the port.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `virtualnetworks.subnetOverrides.useInVmCreationPermission`

Indicates whether this subnet can be used during virtual machine creation (i.e. Allow, Deny).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Default'
    'Deny'
  ]
  ```

### Parameter: `virtualnetworks.subnetOverrides.usePublicIpAddressPermission`

Indicates whether public IP addresses can be assigned to virtual machines on this subnet (i.e. Allow, Deny).

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Default'
    'Deny'
  ]
  ```

### Parameter: `virtualnetworks.subnetOverrides.virtualNetworkPoolName`

The virtual network pool associated with this subnet.

- Required: No
- Type: string

### Parameter: `virtualnetworks.tags`

The tags of the virtual network.

- Required: No
- Type: object

### Parameter: `vmCreationResourceGroupId`

Resource Group allocation for virtual machines. If left empty, virtual machines will be deployed in their own Resource Groups. Default is the same Resource Group for DevTest Lab.

- Required: No
- Type: string
- Default: `[resourceGroup().id]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the lab. |
| `resourceGroupName` | string | The resource group the lab was deployed into. |
| `resourceId` | string | The resource ID of the lab. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |
| `uniqueIdentifier` | string | The unique identifier for the lab. Used to track tags that the lab applies to each resource that it creates. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
