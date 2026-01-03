targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module with most of its features enabled.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-logic-integrationaccount-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'iamax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The object ID of the Logic Apps Service Enterprise Application. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-logicAppsServiceEnterpriseApplicationObjectId\'.')
@secure()
param logicAppsServiceEnterpriseApplicationObjectId string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-01'
    logicAppsServiceEnterpriseApplicationObjectId: logicAppsServiceEnterpriseApplicationObjectId
  }
}

// Diagnostics
// ===========
module diagnosticDependencies '../../../../../../../utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-diagnosticDependencies'
  params: {
    storageAccountName: 'dep${namePrefix}diasa${serviceShort}01'
    logAnalyticsWorkspaceName: 'dep-${namePrefix}-law-${serviceShort}'
    eventHubNamespaceEventHubName: 'dep-${namePrefix}-evh-${serviceShort}01'
    eventHubNamespaceName: 'dep-${namePrefix}-evhns-${serviceShort}01'
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
      location: resourceLocation
      schemas: [
        {
          name: 'schema1'
          content: loadTextContent('schema-content.xml')
          schemaType: 'Xml'
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          tags: {
            tag1: 'value1'
            tag2: 'value2'
          }
        }
      ]
      partners: [
        {
          name: 'partner1'
          b2b: {
            businessIdentities: [
              {
                qualifier: 'ZZ'
                value: '1234567890'
              }
              {
                qualifier: 'ZZZ'
                value: '0987654321'
              }
            ]
          }
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          tags: {
            tag1: 'value1'
            tag2: 'value2'
          }
        }
        {
          b2b: {
            businessIdentities: [
              {
                qualifier: 'ZZ'
                value: '0987654321'
              }
              {
                qualifier: 'ZZZ'
                value: '1122334455'
              }
            ]
          }
          name: 'partner2'
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          tags: {
            tag1: 'value1'
            tag2: 'value2'
          }
        }
      ]
      maps: [
        {
          name: 'map1'
          content: loadTextContent('map-content.xslt')
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          tags: {
            tag1: 'value1'
            tag2: 'value2'
          }
        }
      ]
      assemblies: [
        {
          name: 'assembly1'
          assemblyName: 'name1'
          content: loadTextContent('assembly-content.txt')
        }
      ]
      agreements: [
        {
          name: 'agreement1'
          agreementType: 'X12'
          guestPartner: 'partner1'
          hostPartner: 'partner2'
          guestIdentity: {
            qualifier: 'ZZ'
            value: '1234567890'
          }
          hostIdentity: {
            qualifier: 'ZZ'
            value: '0987654321'
          }
          content: {
            x12: {
              receiveAgreement: {
                protocolSettings: {
                  acknowledgementSettings: {
                    acknowledgementControlNumberLowerBound: 1
                    acknowledgementControlNumberUpperBound: 999999999
                    batchFunctionalAcknowledgements: true
                    batchImplementationAcknowledgements: false
                    batchTechnicalAcknowledgements: true
                    needFunctionalAcknowledgement: false
                    needImplementationAcknowledgement: false
                    needLoopForValidMessages: false
                    needTechnicalAcknowledgement: false
                    rolloverAcknowledgementControlNumber: true
                    sendSynchronousAcknowledgement: false
                  }
                  envelopeSettings: {
                    controlStandardsId: 85
                    controlVersionNumber: '00401'
                    enableDefaultGroupHeaders: true
                    groupControlNumberLowerBound: 1
                    groupControlNumberUpperBound: 999999999
                    groupHeaderAgencyCode: 'T'
                    groupHeaderDateFormat: 'CCYYMMDD'
                    groupHeaderTimeFormat: 'HHMM'
                    groupHeaderVersion: '00401'
                    interchangeControlNumberLowerBound: 1
                    interchangeControlNumberUpperBound: 999999999
                    overwriteExistingTransactionSetControlNumber: true
                    receiverApplicationId: 'RECEIVER'
                    rolloverGroupControlNumber: true
                    rolloverInterchangeControlNumber: true
                    rolloverTransactionSetControlNumber: true
                    senderApplicationId: 'SENDER'
                    transactionSetControlNumberLowerBound: 1
                    transactionSetControlNumberUpperBound: 999999999
                    usageIndicator: 'Test'
                    useControlStandardsIdAsRepetitionCharacter: false
                  }
                  framingSettings: {
                    characterSet: 'UTF8'
                    componentSeparator: 58
                    dataElementSeparator: 42
                    replaceCharacter: 36
                    replaceSeparatorsInPayload: false
                    segmentTerminator: 126
                    segmentTerminatorSuffix: 'None'
                  }
                  messageFilter: {
                    messageFilterType: 'Include'
                  }
                  processingSettings: {
                    convertImpliedDecimal: true
                    createEmptyXmlTagsForTrailingSeparators: true
                    maskSecurityInfo: true
                    preserveInterchange: true
                    suspendInterchangeOnError: true
                    useDotAsDecimalSeparator: true
                  }
                  schemaReferences: [
                    {
                      messageId: '850'
                      schemaName: 'schema1'
                      schemaVersion: '00401'
                    }
                  ]
                  securitySettings: {
                    authorizationQualifier: '00'
                    securityQualifier: '00'
                  }
                  validationSettings: {
                    allowLeadingAndTrailingSpacesAndZeroes: false
                    checkDuplicateGroupControlNumber: false
                    checkDuplicateInterchangeControlNumber: false
                    checkDuplicateTransactionSetControlNumber: false
                    interchangeControlNumberValidityDays: 30
                    trailingSeparatorPolicy: 'NotAllowed'
                    trimLeadingAndTrailingSpacesAndZeroes: true
                    validateCharacterSet: true
                    validateEDITypes: true
                    validateXSDTypes: false
                  }
                }
                receiverBusinessIdentity: {
                  qualifier: 'ZZ'
                  value: '1234567890'
                }
                senderBusinessIdentity: {
                  qualifier: 'ZZ'

                  value: '0987654321'
                }
              }
              sendAgreement: {
                protocolSettings: {
                  acknowledgementSettings: {
                    acknowledgementControlNumberLowerBound: 1
                    acknowledgementControlNumberUpperBound: 999999999
                    batchFunctionalAcknowledgements: true
                    batchImplementationAcknowledgements: false
                    batchTechnicalAcknowledgements: true
                    needFunctionalAcknowledgement: false
                    needImplementationAcknowledgement: false
                    needLoopForValidMessages: false
                    needTechnicalAcknowledgement: false
                    rolloverAcknowledgementControlNumber: true
                    sendSynchronousAcknowledgement: false
                  }
                  envelopeSettings: {
                    controlStandardsId: 85
                    controlVersionNumber: '00401'
                    enableDefaultGroupHeaders: true
                    groupControlNumberLowerBound: 1
                    groupControlNumberUpperBound: 999999999
                    groupHeaderAgencyCode: 'T'
                    groupHeaderDateFormat: 'CCYYMMDD'
                    groupHeaderTimeFormat: 'HHMM'
                    groupHeaderVersion: '00401'
                    interchangeControlNumberLowerBound: 1
                    interchangeControlNumberUpperBound: 999999999
                    overwriteExistingTransactionSetControlNumber: true
                    receiverApplicationId: 'RECEIVER'
                    rolloverGroupControlNumber: true
                    rolloverInterchangeControlNumber: true
                    rolloverTransactionSetControlNumber: true
                    senderApplicationId: 'SENDER'
                    transactionSetControlNumberLowerBound: 1
                    transactionSetControlNumberUpperBound: 999999999
                    usageIndicator: 'Test'
                    useControlStandardsIdAsRepetitionCharacter: false
                  }
                  framingSettings: {
                    characterSet: 'UTF8'
                    componentSeparator: 58
                    dataElementSeparator: 42
                    replaceCharacter: 36
                    replaceSeparatorsInPayload: false
                    segmentTerminator: 126
                    segmentTerminatorSuffix: 'None'
                  }
                  messageFilter: {
                    messageFilterType: 'Include'
                  }
                  processingSettings: {
                    convertImpliedDecimal: true
                    createEmptyXmlTagsForTrailingSeparators: true
                    maskSecurityInfo: true
                    preserveInterchange: true
                    suspendInterchangeOnError: true
                    useDotAsDecimalSeparator: true
                  }
                  schemaReferences: [
                    {
                      messageId: '850'
                      schemaName: 'schema1'
                      schemaVersion: '00401'
                    }
                  ]
                  securitySettings: {
                    authorizationQualifier: '00'
                    securityQualifier: '00'
                  }
                  validationSettings: {
                    allowLeadingAndTrailingSpacesAndZeroes: false
                    checkDuplicateGroupControlNumber: false
                    checkDuplicateInterchangeControlNumber: false
                    checkDuplicateTransactionSetControlNumber: false
                    interchangeControlNumberValidityDays: 30
                    trailingSeparatorPolicy: 'NotAllowed'
                    trimLeadingAndTrailingSpacesAndZeroes: true
                    validateCharacterSet: true
                    validateEDITypes: true
                    validateXSDTypes: false
                  }
                }
                receiverBusinessIdentity: {
                  qualifier: 'ZZ'
                  value: '1234567890'
                }
                senderBusinessIdentity: {
                  qualifier: 'ZZ'
                  value: '0987654321'
                }
              }
            }
          }
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          tags: {
            tag1: 'value1'
            tag2: 'value2'
          }
        }
      ]
      certificates: [
        {
          name: 'certificate1'
          key: {
            keyVault: {
              id: nestedDependencies.outputs.keyVaultResourceId
            }
            keyName: nestedDependencies.outputs.keyVaultKeyName
          }
          metadata: {
            key1: 'value1'
            key2: 'value2'
          }
          tags: {
            tag1: 'value1'
            tag2: 'value2'
          }
        }
      ]
      diagnosticSettings: [
        {
          name: 'customSetting'
          metricCategories: []
          logCategoriesAndGroups: [
            {
              categoryGroup: 'allLogs'
              enabled: true
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
      roleAssignments: [
        {
          name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
        Environment: 'Non-Prod'
        Role: 'DeploymentValidation'
      }
    }
  }
]
