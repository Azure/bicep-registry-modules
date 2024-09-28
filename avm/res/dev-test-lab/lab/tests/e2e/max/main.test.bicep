targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-devtestlab.labs-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dtllmax'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    diskEncryptionSetName: 'dep-${namePrefix}-des-${serviceShort}'
    storageAccountName: 'dep${namePrefix}sa${serviceShort}'
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      location: resourceGroup.location
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      roleAssignments: [
        {
          name: 'b08c589c-2c79-41bd-8195-d5e62ad12f67'
          roleDefinitionIdOrName: 'Owner'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          name: guid('Custom seed ${namePrefix}${serviceShort}')
          roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
        {
          roleDefinitionIdOrName: subscriptionResourceId(
            'Microsoft.Authorization/roleDefinitions',
            'acdd72a7-3385-48ef-bd42-f606fba81ae7'
          )
          principalId: nestedDependencies.outputs.managedIdentityPrincipalId
          principalType: 'ServicePrincipal'
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        resourceType: 'DevTest Lab'
        labName: '${namePrefix}${serviceShort}001'
      }
      announcement: {
        enabled: 'Enabled'
        expirationDate: '2028-12-30T13:00:00.000Z'
        markdown: 'DevTest Lab announcement text. <br> New line. It also supports Markdown'
        title: 'DevTest announcement title'
      }
      environmentPermission: 'Contributor'
      extendedProperties: {
        RdpConnectionType: '7'
      }
      labStorageType: 'Premium'
      artifactsStorageAccount: nestedDependencies.outputs.storageAccountResourceId
      premiumDataDisks: 'Enabled'
      support: {
        enabled: 'Enabled'
        markdown: 'DevTest Lab support text. <br> New line. It also supports Markdown'
      }
      managedIdentities: {
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      managementIdentitiesResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
      vmCreationResourceGroupId: resourceGroup.id
      browserConnect: 'Enabled'
      disableAutoUpgradeCseMinorVersion: true
      isolateLabResources: 'Enabled'
      encryptionType: 'EncryptionAtRestWithCustomerKey'
      encryptionDiskEncryptionSetId: nestedDependencies.outputs.diskEncryptionSetResourceId
      virtualnetworks: [
        {
          name: nestedDependencies.outputs.virtualNetworkName
          externalProviderResourceId: nestedDependencies.outputs.virtualNetworkResourceId
          description: 'lab virtual network description'
          allowedSubnets: [
            {
              labSubnetName: nestedDependencies.outputs.subnet1Name
              resourceId: nestedDependencies.outputs.subnet1ResourceId
              allowPublicIp: 'Allow'
            }
            {
              labSubnetName: nestedDependencies.outputs.subnet2Name
              resourceId: nestedDependencies.outputs.subnet2ResourceId
              allowPublicIp: 'Deny'
            }
          ]
          subnetOverrides: [
            {
              labSubnetName: nestedDependencies.outputs.subnet1Name
              resourceId: nestedDependencies.outputs.subnet1ResourceId
              useInVmCreationPermission: 'Allow'
              usePublicIpAddressPermission: 'Allow'
              sharedPublicIpAddressConfiguration: {
                allowedPorts: [
                  {
                    transportProtocol: 'Tcp'
                    backendPort: 3389
                  }
                  {
                    transportProtocol: 'Tcp'
                    backendPort: 22
                  }
                ]
              }
            }
            {
              labSubnetName: nestedDependencies.outputs.subnet2Name
              resourceId: nestedDependencies.outputs.subnet2ResourceId
              useInVmCreationPermission: 'Deny'
              usePublicIpAddressPermission: 'Deny'
            }
          ]
        }
      ]
      policies: [
        {
          name: nestedDependencies.outputs.subnet1Name
          evaluatorType: 'MaxValuePolicy'
          factData: nestedDependencies.outputs.subnet1ResourceId
          factName: 'UserOwnedLabVmCountInSubnet'
          threshold: '1'
        }
        {
          name: 'MaxVmsAllowedPerUser'
          evaluatorType: 'MaxValuePolicy'
          factName: 'UserOwnedLabVmCount'
          threshold: '2'
        }
        {
          name: 'MaxPremiumVmsAllowedPerUser'
          evaluatorType: 'MaxValuePolicy'
          factName: 'UserOwnedLabPremiumVmCount'
          status: 'Disabled'
          threshold: '1'
        }
        {
          name: 'MaxVmsAllowedPerLab'
          evaluatorType: 'MaxValuePolicy'
          factName: 'LabVmCount'
          threshold: '3'
        }
        {
          name: 'MaxPremiumVmsAllowedPerLab'
          evaluatorType: 'MaxValuePolicy'
          factName: 'LabPremiumVmCount'
          threshold: '2'
        }
        {
          name: 'AllowedVmSizesInLab'
          evaluatorType: 'AllowedValuesPolicy'
          factData: ''
          factName: 'LabVmSize'
          threshold: ' ${string('["Basic_A0","Basic_A1"]')}'
          status: 'Enabled'
        }
        {
          name: 'ScheduleEditPermission'
          evaluatorType: 'AllowedValuesPolicy'
          factName: 'ScheduleEditPermission'
          threshold: ' ${string('["None","Modify"]')}'
        }
        {
          name: 'GalleryImage'
          evaluatorType: 'AllowedValuesPolicy'
          factName: 'GalleryImage'
          threshold: ' ${string('["{\\"offer\\":\\"WindowsServer\\",\\"publisher\\":\\"MicrosoftWindowsServer\\",\\"sku\\":\\"2019-Datacenter-smalldisk\\",\\"osType\\":\\"Windows\\",\\"version\\":\\"latest\\"}","{\\"offer\\":\\"WindowsServer\\",\\"publisher\\":\\"MicrosoftWindowsServer\\",\\"sku\\":\\"2022-datacenter-smalldisk\\",\\"osType\\":\\"Windows\\",\\"version\\":\\"latest\\"}"]')}'
        }
        {
          name: 'EnvironmentTemplate'
          description: 'Public Environment Policy'
          evaluatorType: 'AllowedValuesPolicy'
          factName: 'EnvironmentTemplate'
          threshold: ' ${string('[""]')}'
        }
      ]
      schedules: [
        {
          name: 'LabVmsShutdown'
          taskType: 'LabVmsShutdownTask'
          status: 'Enabled'
          timeZoneId: 'AUS Eastern Standard Time'
          dailyRecurrence: {
            time: '0000'
          }
          notificationSettings: {
            status: 'Enabled'
            timeInMinutes: 30
          }
        }
        {
          name: 'LabVmAutoStart'
          taskType: 'LabVmsStartupTask'
          status: 'Enabled'
          timeZoneId: 'AUS Eastern Standard Time'
          weeklyRecurrence: {
            time: '0700'
            weekdays: [
              'Monday'
              'Tuesday'
              'Wednesday'
              'Thursday'
              'Friday'
            ]
          }
        }
      ]
      notificationchannels: [
        {
          name: 'autoShutdown'
          description: 'Integration configured for auto-shutdown'
          events: [
            'AutoShutdown'
          ]
          emailRecipient: 'mail@contosodtlmail.com'
          webHookUrl: 'https://webhook.contosotest.com'
          notificationLocale: 'en'
        }
        {
          name: 'costThreshold'
          events: [
            'Cost'
          ]
          webHookUrl: 'https://webhook.contosotest.com'
        }
      ]
      artifactsources: [
        {
          name: 'Public Repo'
          displayName: 'Public Artifact Repo'
          status: 'Enabled'
          uri: 'https://github.com/Azure/azure-devtestlab.git'
          sourceType: 'GitHub'
          folderPath: '/Artifacts'
        }
        {
          name: 'Public Environment Repo'
          displayName: 'Public Environment Repo'
          status: 'Disabled'
          uri: 'https://github.com/Azure/azure-devtestlab.git'
          sourceType: 'GitHub'
          branchRef: 'master'
          armTemplateFolderPath: '/Environments'
          tags: {
            'hidden-title': 'This is visible in the resource name'
            resourceType: 'DevTest Lab'
            labName: '${namePrefix}${serviceShort}001'
          }
        }
        {
          name: 'Private Repo'
          displayName: 'Private Artifact Repo'
          status: 'Disabled'
          uri: 'https://github.com/Azure/azure-devtestlab.git'
          folderPath: '/Artifacts'
          armTemplateFolderPath: '/ArmTemplates'
          branchRef: 'main'
          securityToken: guid(baseTime)
        }
      ]
      costs: {
        status: 'Enabled'
        cycleType: 'CalendarMonth'
        target: 450
        currencyCode: 'AUD'
        thresholdValue100DisplayOnChart: 'Enabled'
        thresholdValue100SendNotificationWhenExceeded: 'Enabled'
        thresholdValue125DisplayOnChart: 'Disabled'
        thresholdValue75DisplayOnChart: 'Enabled'
      }
    }
  }
]
