targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-automation.account-${serviceShort}-rg'

// Enforce uksouth to avoid restrictions around zone redundancy in certain regions
#disable-next-line no-hardcoded-location
var enforcedLocation = 'westeurope'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'aamax'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = 'bep'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: enforcedLocation
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      diagnosticSettings: [
        {
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      gallerySolutions: [
        {
          name: 'Updates(${last(split(diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId, '/'))})'
          plan: {
            product: 'OMSGallery/Updates'
            publisher: 'Microsoft'
          }
        }
      ]
      jobSchedules: [
        {
          runbookName: 'TestRunbook'
          scheduleName: 'TestSchedule'
        }
      ]
      credentials: [
        {
          name: 'Credential01'
          description: 'Description of Credential01'
          userName: 'userName01'
          password: password
        }
        {
          name: 'Credential02'
          userName: 'username02'
          password: password
        }
      ]
      disableLocalAuth: true
      linkedWorkspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
      location: enforcedLocation
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      modules: [
        {
          name: 'PSWindowsUpdate'
          uri: 'https://www.powershellgallery.com/api/v2/package'
          version: 'latest'
        }
      ]
      powershell72Modules: [
        {
          name: 'powershell-yaml'
          uri: 'https://www.powershellgallery.com/api/v2/package'
          version: 'latest'
        }
      ]
      python3Packages: [
        {
          name: 'geniz-0.0.1-py3-none-any.whl'
          uri: 'https://files.pythonhosted.org/packages/8f/4b/c61bb7b176b34dd0c9ab0f3d821234c1e9f81f3ba5a609a1cf9032c852e7'
          version: 'latest'
        }
      ]
      python2Packages: [
        {
          name: 'pycx2-1.0.3-py2-none-any.whl'
          uri: 'https://files.pythonhosted.org/packages/59/8c/40f66c4ac7564a68edd629a7836536af53d10b2d89f78c63e77cfcd9d460'
          version: 'latest'
        }
      ]
      privateEndpoints: [
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          service: 'Webhook'
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          service: 'Webhook'
          subnetResourceId: nestedDependencies.outputs.customSubnet2ResourceId
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
        {
          privateDnsZoneGroup: {
            privateDnsZoneGroupConfigs: [
              {
                privateDnsZoneResourceId: nestedDependencies.outputs.privateDNSZoneResourceId
              }
            ]
          }
          service: 'DSCAndHybridWorker'
          subnetResourceId: nestedDependencies.outputs.customSubnet1ResourceId
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
      ]
      roleAssignments: [
        {
          name: 'de334944-f952-4273-8ab3-bd523380034c'
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
      runbooks: [
        {
          description: 'Test runbook'
          name: 'TestRunbook'
          type: 'PowerShell'
          uri: 'https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.automation/101-automation/scripts/AzureAutomationTutorial.ps1'
          version: '1.0.0.0'
        }
      ]
      schedules: [
        {
          advancedSchedule: {}
          expiryTime: '9999-12-31T13:00'
          frequency: 'Hour'
          interval: 12
          name: 'TestSchedule'
          startTime: ''
          timeZone: 'Europe/Berlin'
        }
      ]
      softwareUpdateConfigurations: [
        {
          excludeUpdates: [
            '123456'
          ]
          frequency: 'Month'
          includeUpdates: [
            '654321'
          ]
          interval: 1
          maintenanceWindow: 'PT4H'
          monthlyOccurrences: [
            {
              day: 'Friday'
              occurrence: 3
            }
          ]
          name: 'Windows_ZeroDay'
          operatingSystem: 'Windows'
          rebootSetting: 'IfRequired'
          scopeByTags: {
            Update: [
              'Automatic-Wave1'
            ]
          }
          startTime: '22:00'
          updateClassifications: [
            'Critical'
            'Definition'
            'FeaturePack'
            'Security'
            'ServicePack'
            'Tools'
            'UpdateRollup'
            'Updates'
          ]
        }
        {
          excludeUpdates: [
            'icacls'
          ]
          frequency: 'OneTime'
          includeUpdates: [
            'kernel'
          ]
          maintenanceWindow: 'PT4H'
          name: 'Linux_ZeroDay'
          operatingSystem: 'Linux'
          rebootSetting: 'IfRequired'
          startTime: '22:00'
          updateClassifications: [
            'Critical'
            'Other'
            'Security'
          ]
        }
      ]
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      variables: [
        {
          description: 'TestStringDescription'
          name: 'TestString'
          value: '\'TestString\''
        }
        {
          description: 'TestIntegerDescription'
          name: 'TestInteger'
          value: '500'
        }
        {
          description: 'TestBooleanDescription'
          name: 'TestBoolean'
          value: 'false'
        }
        {
          description: 'TestDateTimeDescription'
          isEncrypted: false
          name: 'TestDateTime'
          value: '\'\\/Date(1637934042656)\\/\''
        }
        {
          description: 'TestEncryptedDescription'
          name: 'TestEncryptedVariable'
          value: '\'TestEncryptedValue\''
        }
      ]
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
