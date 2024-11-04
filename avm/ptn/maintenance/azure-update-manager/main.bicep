metadata name = 'update-manager-configuration'
metadata description = 'This module creates multiple maintenance windows for Azure update manager and assigns them to existing VMs dynamically using tags .'
metadata owner = 'Azure/module-maintainers'
metadata version = '0.1.0'
metadata category = 'Compute'

targetScope = 'subscription'

//PARAMETERS
@description('Optional. Azure region where the maintenance configurations and associated resources will be deployed to, default to deployment location if not specified.')
param location string = deployment().location

@description('Required. Name of the Resource Group to deploy the maintenance configurations and associated resources.')
param maintenanceConfigurationsResourceGroupName string

@description('Optional. An array of objects which contain the properties of the maintenance configurations to be created.')
param maintenanceConfigurations array = [
  {
    maintenanceConfigName: 'maintenance_ring-01'
    location: location
    installPatches: {
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        packageNameMasksToExclude: []
        packageNameMasksToInclude: []
      }
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        kbNumbersToExclude: []
        kbNumbersToInclude: []
      }
    }
    lock: {}
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: null
      recurEvery: '1Day'
      startDateTime: '2024-09-19 00:00'
      timeZone: 'UTC'
    }
    visibility: 'Custom'
    resourceFilter: {
      resourceGroups: []
      osTypes: [
        'Windows'
        'Linux'
      ]
      locations: []
    }
  }
  {
    maintenanceConfigName: 'maintenance_ring-02'
    location: location
    installPatches: {
      linuxParameters: {
        classificationsToInclude: [
          'Other'
        ]
        packageNameMasksToExclude: []
        packageNameMasksToInclude: []
      }
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'FeaturePack'
          'ServicePack'
        ]
        kbNumbersToExclude: []
        kbNumbersToInclude: []
      }
    }
    lock: {}
    maintenanceWindow: {
      duration: '03:00'
      expirationDateTime: null
      recurEvery: 'Week Saturday,Sunday'
      startDateTime: '2024-09-19 00:00'
      timeZone: 'UTC'
    }
    visibility: 'Custom'
    resourceFilter: {
      resourceGroups: []
      osTypes: [
        'Windows'
        'Linux'
      ]
      locations: []
    }
  }
]

@description('Optional. The name of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager.')
param enableAUMTagName string = 'aum_maintenance'

@description('Optional. The value of the tag that will be used to filter the VMs/ARC enabled servers for enabling Azure Update Manager. Only the VMs/ARC enabled servers with Tags of the combination `<enableAUMTagName>`:`<enableAUMTagValue>` will be considered for Maintenance Configuration dynamic scoping.')
param enableAUMTagValue string = 'Enabled'

@description('Optional. The name of the tag that will be used to filter the VMs/ARC enabled servers to assign to a maintenance configuration. The value of this tag should contain the name of the maintenance configuration which the VM/ARC enabled server should belong to, specified in the parameter `maintenanceConfigurations`.')
param maintenanceConfigEnrollmentTagName string = 'aum_maintenance_config'

@description('Optional. The name of the User Assigned Managed Identity that will be used to deploy the policies.')
@maxLength(63)
param policyDeploymentManagedIdentityName string = 'id-aumpolicy-contributor-01'

@description('Optional. Resource tags, which will be added to all resources.')
param tags object?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//VARIABLES

var maintenanceConfigNames = [
  for (maintenanceConfiguration, i) in maintenanceConfigurations: maintenanceConfiguration.maintenanceConfigName
]

var aumEnablingTag = {
  '${enableAUMTagName}': enableAUMTagValue
}

var aumEnablingTagObject = {
  key: items(aumEnablingTag)[0].key
  value: items(aumEnablingTag)[0].value
}

var osTypes = [
  'Windows'
  'Linux'
]

var resourceTypes = [
  'Microsoft.Compute/virtualMachines'
  'Microsoft.HybridCompute/machines'
]

// MODULES

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.maintenance-azureupdatemanager.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}
@description('Creates a resource group for Azure Update Manager maintenance configurations.')
module maintenanceConfig_rg 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: take('rg-${substring(uniqueString(deployment().name, location), 0, 4)}-deployment', 64)
  params: {
    name: maintenanceConfigurationsResourceGroupName
    location: location
    tags: tags
  }
}
@description('Creates a user-assigned managed identity for policy deployment.')
module id_aumpolicy_contributor 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: take('mi-${substring(uniqueString(deployment().name, location), 0, 4)}-deployment', 64)
  scope: resourceGroup(maintenanceConfigurationsResourceGroupName)
  params: {
    name: policyDeploymentManagedIdentityName
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
  }
  dependsOn: [
    maintenanceConfig_rg
  ]
}

@description('Creates maintenance configurations based on the provided parameters.')
module maintenance_configurations 'br/public:avm/res/maintenance/maintenance-configuration:0.3.0' = [
  for (maintenanceConfiguration, i) in maintenanceConfigurations: {
    name: take(
      'mainconf-${substring(uniqueString(deployment().name, location), 0, 4)}-${maintenanceConfiguration.maintenanceConfigName}-deployment',
      64
    )
    scope: resourceGroup(maintenanceConfigurationsResourceGroupName)
    params: {
      name: maintenanceConfiguration.maintenanceConfigName
      location: location
      installPatches: maintenanceConfiguration.?installPatches
      maintenanceWindow: maintenanceConfiguration.?maintenanceWindow
      visibility: maintenanceConfiguration.?visibility
      lock: maintenanceConfiguration.?lock
      tags: maintenanceConfiguration.?tags
      roleAssignments: maintenanceConfiguration.?roleAssignments
      extensionProperties: {
        InGuestPatchMode: 'User'
      }
      maintenanceScope: 'InGuestPatch'
      enableTelemetry: enableTelemetry
    }
  }
]

@description('Assigns maintenance configurations to resources based on the provided filters.')
module maintenance_configuration_assignments 'modules/configAssignments.bicep' = [
  for (maintenanceConfiguration, i) in maintenanceConfigurations: {
    name: take(
      'mainconfassi-${substring(uniqueString(deployment().name, location), 0, 4)}-${maintenanceConfiguration.maintenanceConfigName}-deployment',
      64
    )
    params: {
      maintenanceConfigResourceGroupName: maintenanceConfigurationsResourceGroupName
      maintenanceConfigName: maintenance_configurations[i].outputs.name
      maintenanceConfigAssignmentName: 'maintenanceConfigAssignment-${maintenanceConfiguration.maintenanceConfigName}'
      filter: {
        resourceTypes: resourceTypes
        resourceGroups: maintenanceConfiguration.resourceFilter.resourceGroups
        osTypes: maintenanceConfiguration.resourceFilter.osTypes
        locations: maintenanceConfiguration.resourceFilter.locations
        tagsettings: {
          filterOperator: 'All'
          tags: {
            '${maintenanceConfigEnrollmentTagName}': [maintenanceConfiguration.maintenanceConfigName]
            '${enableAUMTagName}': [enableAUMTagValue]
          }
        }
      }
    }
  }
]

@description('Assigns the prerequisite policy for Azure Update Manager.')
module setPrereqPolicyAssignment 'modules/policyAssignments.bicep' = {
  name: 'AzureUpdateManagerPrerequisitePolicyAssignment'
  params: {
    name: take('prereqpolassi-${substring(uniqueString(deployment().name, location), 0, 4)}-deployment', 64)
    displayName: 'Azure Update Manager prerequisites settings update based on Tags'
    description: 'Azure Update Manager prerequisites settings update based on Tags of the Azure VMs/ARC enabled Servers'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/9905ca54-1471-49c6-8291-7582c04cd4d4'
    parameters: {
      tagOperator: {
        value: 'All'
      }
      tagValues: {
        value: [aumEnablingTagObject]
      }
      effect: {
        value: 'DeployIfNotExists'
      }
    }
    identity: 'UserAssigned'
    userAssignedIdentityId: id_aumpolicy_contributor.outputs.resourceId
    roleDefinitionIds: ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']
    metadata: {
      assignedBy: 'maintenance/azure-update-manager'
    }
    nonComplianceMessages: []
    enforcementMode: 'Default'
    subscriptionId: subscription().subscriptionId
    notScopes: []
    location: location
    overrides: []
    resourceSelectors: []
  }
}

@description('Enables periodic assessment on Azure VMs based on tags for each OS type.')
@batchSize(1)
module configurePeriodicCheckingAzureVMsWin 'modules/policyAssignments.bicep' = [
  for osType in osTypes: {
    name: take(
      'periodiccheckvmpolassi-${substring(uniqueString(deployment().name, location), 0, 4)}-${osType}-deployment',
      64
    )
    params: {
      name: 'AUMConfigurePeriodicCheckingAzVMPolicyAssignment${osType}'
      displayName: 'Azure Update Manager enabling periodic assessment on Azure VMs based on Tags for ${osType}'
      description: 'This policy enables periodic checking for updates on Azure based on Tags of the Azure VMs for ${osType}'
      policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15'
      parameters: {
        tagOperator: {
          value: 'All'
        }
        tagValues: {
          value: aumEnablingTag
        }
        osType: {
          value: osType
        }
      }
      identity: 'UserAssigned'
      userAssignedIdentityId: id_aumpolicy_contributor.outputs.resourceId
      roleDefinitionIds: ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']
      metadata: {
        assignedBy: 'maintenance/azure-update-manager'
      }
      nonComplianceMessages: []
      enforcementMode: 'Default'
      subscriptionId: subscription().subscriptionId
      notScopes: []
      location: location
      overrides: []
      resourceSelectors: []
    }
  }
]

@description('Enables periodic assessment on ARC Servers based on tags for each OS type.')
@batchSize(1)
module configurePeriodicCheckingARCServersWindows 'modules/policyAssignments.bicep' = [
  for osType in osTypes: {
    name: take(
      'periodiccheckarcpolassi-${substring(uniqueString(deployment().name, location), 0, 4)}-${osType}-deployment',
      64
    )
    params: {
      name: 'AUMConfigurePeriodicCheckingARCVMPolicyAssignment${osType}'
      displayName: 'Azure Update Manager enabling periodic assessment on ARC Servers based on Tags for ${osType}'
      description: 'This policy enables periodic checking for updates on Azure based on Tags of the ARC Servers for ${osType}'
      policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/bfea026e-043f-4ff4-9d1b-bf301ca7ff46'
      parameters: {
        tagOperator: {
          value: 'All'
        }
        tagValues: {
          value: aumEnablingTag
        }
        osType: {
          value: osType
        }
      }
      identity: 'UserAssigned'
      userAssignedIdentityId: id_aumpolicy_contributor.outputs.resourceId
      roleDefinitionIds: ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']
      metadata: {
        assignedBy: 'maintenance/azure-update-manager'
      }
      nonComplianceMessages: []
      enforcementMode: 'Default'
      subscriptionId: subscription().subscriptionId
      notScopes: []
      location: location
      overrides: []
      resourceSelectors: []
    }
  }
]

@description('Defines a policy to enforce tags on Azure VMs/ARC enabled servers for Azure Update Manager maintenance.')
module requireAUMTagPolicyDefinition 'modules/policyDefinition.bicep' = {
  name: take('aumtagpoldef-${substring(uniqueString(deployment().name, location), 0, 4)}-deployment', 64)
  params: {
    name: 'requireAUMTagPolicyDefinition'
    displayName: 'Require tags on Azure VMs/ARC enabled servers for Azure Update Manager maintenance'
    description: 'Enforces existence of tags on Azure VMs/ARC enabled servers for Azure Update Manager maintenance. Does not apply to other resources/resource groups.'
    mode: 'Indexed'
    metadata: {
      version: '1.0.0'
      category: 'Tags'
    }
    parameters: {
      maintenanceConfigEnrollmentTagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag name to specify the corresponding Maintenance Configuration'
          description: 'Name of the Tag to specify the Maintenance Configuration to which the resource belongs. For example \'aum_maintenance_ring\''
        }
        defaultValue: maintenanceConfigEnrollmentTagName
      }
      maintenanceConfigNames: {
        type: 'Array'
        metadata: {
          displayName: 'Available AUM Maintenance Configurations'
          description: 'Available AUM Maintenance Configuration names. For example [Ring-01,Ring-02]'
        }
        defaultValue: maintenanceConfigNames
      }
      maintenanceEnablingTagName: {
        type: 'String'
        metadata: {
          displayName: 'Tag name to enable AUM maintenance'
          description: 'Name of the tag that enables AUM maintenance. For example \'aum_maintenance\''
        }
        defaultValue: enableAUMTagName
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            anyOf: [
              {
                field: 'type'
                equals: 'Microsoft.Compute/virtualMachines'
              }
              {
                field: 'type'
                equals: 'Microsoft.HybridCompute/machines'
              }
            ]
          }
          {
            anyOf: [
              {
                not: {
                  field: '[concat(\'tags[\', parameters(\'maintenanceConfigEnrollmentTagName\'), \']\')]'
                  in: '[parameters(\'maintenanceConfigNames\')]'
                }
              }
              {
                not: {
                  field: '[concat(\'tags[\', parameters(\'maintenanceEnablingTagName\'), \']\')]'
                  exists: true
                }
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

@description('Assigns the policy to enforce tags on Azure VMs/ARC enabled servers for Azure Update Manager maintenance.')
module requireAUMTagPolicyAssignment 'modules/policyAssignments.bicep' = {
  name: take('aumtagpolassi-${substring(uniqueString(deployment().name, location), 0, 4)}-deployment', 64)
  params: {
    name: 'requireAUMTagPolicyAssignment'
    displayName: 'Require AUM maintenance ring tag on Azure VMs/ARC enabled servers'
    description: 'Enforces existence of a tag on Azure VMs/ARC enabled servers.'
    policyDefinitionId: requireAUMTagPolicyDefinition.outputs.resourceId
    parameters: {
      maintenanceConfigEnrollmentTagName: {
        value: maintenanceConfigEnrollmentTagName
      }
      maintenanceConfigNames: {
        value: maintenanceConfigNames
      }
      maintenanceEnablingTagName: {
        value: enableAUMTagName
      }
    }
    identity: 'UserAssigned'
    userAssignedIdentityId: id_aumpolicy_contributor.outputs.resourceId
    roleDefinitionIds: []
    metadata: {
      assignedBy: 'maintenance/azure-update-manager'
    }
    nonComplianceMessages: [
      {
        message: 'Please ensure that the following tags are applied to the VMs/ARC Servers - ${enableAUMTagName}: [Enabled/Disabled], ${maintenanceConfigEnrollmentTagName}: ${replace(replace(string(maintenanceConfigNames),'"',''),',','/')} '
      }
    ]
    enforcementMode: 'Default'
    subscriptionId: subscription().subscriptionId
    notScopes: []
    location: location
    overrides: []
    resourceSelectors: []
  }
}

// OUTPUTS
@description('The resource IDs of the maintenance configurations.')
output maintenanceConfigurationIds array = [
  for i in range(0, length(maintenanceConfigurations)): {
    id: maintenance_configurations[i].outputs.resourceId
  }
]

//User Defined Types
@description('Defines the structure of a maintenance configuration.')
type maintenanceConfigurationType = {
  @description('The name of the maintenance configuration.')
  maintenanceConfigName: string
  @description('The location where the maintenance configuration will be created.')
  location: string
  @description('The patch installation settings for the maintenance configuration.')
  installPatches: {
    @description('The patch installation settings for Linux.')
    linuxParameters: {
      @description('The classifications of patches to include for Linux.')
      classificationsToInclude: array?
      @description('The package name masks to exclude for Linux.')
      packageNameMasksToExclude: array?
      @description('The package name masks to include for Linux.')
      packageNameMasksToInclude: array?
    }
    @description('The reboot setting for the maintenance configuration.')
    rebootSetting: string
    @description('The patch installation settings for Windows.')
    windowsParameters: {
      @description('The classifications of patches to include for Windows.')
      classificationsToInclude: array?
      @description('The KB numbers to exclude for Windows.')
      kbNumbersToExclude: array?
      @description('The KB numbers to include for Windows.')
      kbNumbersToInclude: array?
    }
  }
  @description('The lock settings for the maintenance configuration.')
  lock: object
  @description('The maintenance window settings for the maintenance configuration.')
  maintenanceWindow: {
    @description('The duration of the maintenance window.')
    duration: string
    @description('The expiration date and time of the maintenance window.')
    expirationDateTime: string?
    @description('The recurrence interval of the maintenance window.')
    recurEvery: string
    @description('The start date and time of the maintenance window.')
    startDateTime: string
    @description('''Name of the timezone.
    List of timezones can be obtained by executing `[System.TimeZoneInfo]::GetSystemTimeZones()` in PowerShell.
    Example: `Pacific Standard Time`, `UTC`, `W. Europe Standard Time`, `Korea Standard Time`, `Cen. Australia Standard Time`.
    ''')
    timeZone: string
  }
  @description('The visibility of the maintenance configuration.')
  visibility: visibilityType
  @description('The resource filter settings for the maintenance configuration.')
  resourceFilter: {
    @description('The resource groups to include in the maintenance configuration.')
    resourceGroups: array?
    @description('The OS types to include in the maintenance configuration.')
    osTypes: array?
    @description('The locations to include in the maintenance configuration.')
    locations: array?
  }
  @description('The tags to apply to the maintenance configuration.')
  tags: object?
  @description('The role assignments for the maintenance configuration.')
  roleAssignments: array?
}[]
@description('Defines the structure of visibility.')
type visibilityType = '' | 'Custom' | 'Public' | null
