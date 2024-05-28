targetScope = 'subscription'

metadata name = 'WAF-aligned'
metadata description = 'This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-recoveryservices.vaults-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'rsvwaf'

@description('Optional. A token to inject into the name of each resource.')
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
    location: resourceLocation
    virtualNetworkName: 'dep-${namePrefix}-vnet-${serviceShort}'
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}'
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
      location: resourceLocation
      name: '${namePrefix}${serviceShort}001'
      backupConfig: {
        enhancedSecurityState: 'Disabled'
        softDeleteFeatureState: 'Disabled'
      }
      backupPolicies: [
        {
          name: 'VMpolicy'
          properties: {
            backupManagementType: 'AzureIaasVM'
            instantRPDetails: {}
            instantRpRetentionRangeInDays: 2
            protectedItemsCount: 0
            retentionPolicy: {
              dailySchedule: {
                retentionDuration: {
                  count: 180
                  durationType: 'Days'
                }
                retentionTimes: [
                  '2019-11-07T07:00:00Z'
                ]
              }
              monthlySchedule: {
                retentionDuration: {
                  count: 60
                  durationType: 'Months'
                }
                retentionScheduleFormatType: 'Weekly'
                retentionScheduleWeekly: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  weeksOfTheMonth: [
                    'First'
                  ]
                }
                retentionTimes: [
                  '2019-11-07T07:00:00Z'
                ]
              }
              retentionPolicyType: 'LongTermRetentionPolicy'
              weeklySchedule: {
                daysOfTheWeek: [
                  'Sunday'
                ]
                retentionDuration: {
                  count: 12
                  durationType: 'Weeks'
                }
                retentionTimes: [
                  '2019-11-07T07:00:00Z'
                ]
              }
              yearlySchedule: {
                monthsOfYear: [
                  'January'
                ]
                retentionDuration: {
                  count: 10
                  durationType: 'Years'
                }
                retentionScheduleFormatType: 'Weekly'
                retentionScheduleWeekly: {
                  daysOfTheWeek: [
                    'Sunday'
                  ]
                  weeksOfTheMonth: [
                    'First'
                  ]
                }
                retentionTimes: [
                  '2019-11-07T07:00:00Z'
                ]
              }
            }
            schedulePolicy: {
              schedulePolicyType: 'SimpleSchedulePolicy'
              scheduleRunFrequency: 'Daily'
              scheduleRunTimes: [
                '2019-11-07T07:00:00Z'
              ]
              scheduleWeeklyFrequency: 0
            }
            timeZone: 'UTC'
          }
        }
        {
          name: 'sqlpolicy'
          properties: {
            backupManagementType: 'AzureWorkload'
            protectedItemsCount: 0
            settings: {
              isCompression: true
              issqlcompression: true
              timeZone: 'UTC'
            }
            subProtectionPolicy: [
              {
                policyType: 'Full'
                retentionPolicy: {
                  monthlySchedule: {
                    retentionDuration: {
                      count: 60
                      durationType: 'Months'
                    }
                    retentionScheduleFormatType: 'Weekly'
                    retentionScheduleWeekly: {
                      daysOfTheWeek: [
                        'Sunday'
                      ]
                      weeksOfTheMonth: [
                        'First'
                      ]
                    }
                    retentionTimes: [
                      '2019-11-07T22:00:00Z'
                    ]
                  }
                  retentionPolicyType: 'LongTermRetentionPolicy'
                  weeklySchedule: {
                    daysOfTheWeek: [
                      'Sunday'
                    ]
                    retentionDuration: {
                      count: 104
                      durationType: 'Weeks'
                    }
                    retentionTimes: [
                      '2019-11-07T22:00:00Z'
                    ]
                  }
                  yearlySchedule: {
                    monthsOfYear: [
                      'January'
                    ]
                    retentionDuration: {
                      count: 10
                      durationType: 'Years'
                    }
                    retentionScheduleFormatType: 'Weekly'
                    retentionScheduleWeekly: {
                      daysOfTheWeek: [
                        'Sunday'
                      ]
                      weeksOfTheMonth: [
                        'First'
                      ]
                    }
                    retentionTimes: [
                      '2019-11-07T22:00:00Z'
                    ]
                  }
                }
                schedulePolicy: {
                  schedulePolicyType: 'SimpleSchedulePolicy'
                  scheduleRunDays: [
                    'Sunday'
                  ]
                  scheduleRunFrequency: 'Weekly'
                  scheduleRunTimes: [
                    '2019-11-07T22:00:00Z'
                  ]
                  scheduleWeeklyFrequency: 0
                }
              }
              {
                policyType: 'Differential'
                retentionPolicy: {
                  retentionDuration: {
                    count: 30
                    durationType: 'Days'
                  }
                  retentionPolicyType: 'SimpleRetentionPolicy'
                }
                schedulePolicy: {
                  schedulePolicyType: 'SimpleSchedulePolicy'
                  scheduleRunDays: [
                    'Monday'
                  ]
                  scheduleRunFrequency: 'Weekly'
                  scheduleRunTimes: [
                    '2017-03-07T02:00:00Z'
                  ]
                  scheduleWeeklyFrequency: 0
                }
              }
              {
                policyType: 'Log'
                retentionPolicy: {
                  retentionDuration: {
                    count: 15
                    durationType: 'Days'
                  }
                  retentionPolicyType: 'SimpleRetentionPolicy'
                }
                schedulePolicy: {
                  scheduleFrequencyInMins: 120
                  schedulePolicyType: 'LogSchedulePolicy'
                }
              }
            ]
            workLoadType: 'SQLDataBase'
          }
        }
        {
          name: 'filesharepolicy'
          properties: {
            backupManagementType: 'AzureStorage'
            protectedItemsCount: 0
            retentionPolicy: {
              dailySchedule: {
                retentionDuration: {
                  count: 30
                  durationType: 'Days'
                }
                retentionTimes: [
                  '2019-11-07T04:30:00Z'
                ]
              }
              retentionPolicyType: 'LongTermRetentionPolicy'
            }
            schedulePolicy: {
              schedulePolicyType: 'SimpleSchedulePolicy'
              scheduleRunFrequency: 'Daily'
              scheduleRunTimes: [
                '2019-11-07T04:30:00Z'
              ]
              scheduleWeeklyFrequency: 0
            }
            timeZone: 'UTC'
            workloadType: 'AzureFileShare'
          }
        }
      ]
      backupStorageConfig: {
        crossRegionRestoreFlag: true
        storageModelType: 'GeoRedundant'
      }
      replicationAlertSettings: {
        customEmailAddresses: [
          'test.user@testcompany.com'
        ]
        locale: 'en-US'
        sendToOwners: 'Send'
      }
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: [
            {
              category: 'AllMetrics'
            }
          ]
          eventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
          eventHubAuthorizationRuleResourceId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
          storageAccountResourceId: diagnosticDependencies.outputs.storageAccountResourceId
          workspaceResourceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        }
      ]
      lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
      }
      managedIdentities: {
        systemAssigned: true
        userAssignedResourceIds: [
          nestedDependencies.outputs.managedIdentityResourceId
        ]
      }
      privateEndpoints: [
        {
          ipConfigurations: [
            {
              name: 'myIpConfig-1'
              properties: {
                groupId: 'AzureSiteRecovery'
                memberName: 'SiteRecovery-tel1'
                privateIPAddress: '10.0.0.10'
              }
            }
            {
              name: 'myIPconfig-2'
              properties: {
                groupId: 'AzureSiteRecovery'
                memberName: 'SiteRecovery-prot2'
                privateIPAddress: '10.0.0.11'
              }
            }
            {
              name: 'myIPconfig-3'
              properties: {
                groupId: 'AzureSiteRecovery'
                memberName: 'SiteRecovery-srs1'
                privateIPAddress: '10.0.0.12'
              }
            }
            {
              name: 'myIPconfig-4'
              properties: {
                groupId: 'AzureSiteRecovery'
                memberName: 'SiteRecovery-rcm1'
                privateIPAddress: '10.0.0.13'
              }
            }
            {
              name: 'myIPconfig-5'
              properties: {
                groupId: 'AzureSiteRecovery'
                memberName: 'SiteRecovery-id1'
                privateIPAddress: '10.0.0.14'
              }
            }
          ]
          privateDnsZoneResourceIds: [
            nestedDependencies.outputs.privateDNSZoneResourceId
          ]
          subnetResourceId: nestedDependencies.outputs.subnetResourceId
          tags: {
            'hidden-title': 'This is visible in the resource name'
            Environment: 'Non-Prod'
            Role: 'DeploymentValidation'
          }
        }
      ]
      monitoringSettings: {
        azureMonitorAlertSettings: {
          alertsForAllJobFailures: 'Enabled'
        }
        classicAlertSettings: {
          alertsForCriticalOperations: 'Enabled'
        }
      }
      securitySettings: {
        immutabilitySettings: {
          state: 'Unlocked'
        }
      }
      tags: {
        'hidden-title': 'This is visible in the resource name'
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
