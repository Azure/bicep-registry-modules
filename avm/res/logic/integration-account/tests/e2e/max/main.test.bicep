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

// ============ //
// Variables    //
// ============ //
var schemaContent = '''<?xml version="1.0" encoding="utf-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           targetNamespace="http://schemas.example.com/invoice/parameters"
           xmlns="http://schemas.example.com/invoice/parameters"
           elementFormDefault="qualified">
  <xs:element name="parameters">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="discountRate" type="xs:decimal"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>'''

var mapContent = '''<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="discountRate"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/invoice">
    <discountedInvoice>
      <customer>
        <xsl:value-of select="customer"/>
      </customer>
      <originalTotal>
        <xsl:value-of select="totalAmount"/>
      </originalTotal>
      <discountRate>
        <xsl:value-of select="$discountRate"/>
      </discountRate>
      <discountedTotal>
        <xsl:value-of select="format-number(totalAmount * (1 - $discountRate), '#.00')"/>
      </discountedTotal>
    </discountedInvoice>
  </xsl:template>
</xsl:stylesheet>'''

var assemblyContent = 'TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAA4fug4AtAnNIbgBTM0hVGhpcyBwcm9ncmFtIGNhbm5vdCBiZSBydW4gaW4gRE9TIG1vZGUuDQ0KJAAAAAAAAABQRQAATAEDAIIBUIMAAAAAAAAAAOAAIgALATAAAAgAAAAIAAAAAAAAIicAAAAgAAAAQAAAAABAAAAgAAAAAgAABAAAAAAAAAAEAAAAAAAAAACAAAAAAgAAAAAAAAMAYIUAABAAABAAAAAAEAAAEAAAAAAAABAAAAAAAAAAAAAAAM4mAABPAAAAAEAAAHwFAAAAAAAAAAAAAAAAAAAAAAAAAGAAAAwAAADkJQAAVAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAACAAAAAAAAAAAAAAACCAAAEgAAAAAAAAAAAAAAC50ZXh0AAAAKAcAAAAgAAAACAAAAAIAAAAAAAAAAAAAAAAAACAAAGAucnNyYwAAAHwFAAAAQAAAAAYAAAAKAAAAAAAAAAAAAAAAAABAAABALnJlbG9jAAAMAAAAAGAAAAACAAAAEAAAAAAAAAAAAAAAAAAAQAAAQgAAAAAAAAAAAAAAAAAAAAACJwAAAAAAAEgAAAACAAUAaCAAAHwFAAABAAAAAQAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADJyAQAAcCgNAAAKACoiAigOAAAKACoAAEJTSkIBAAEAAAAAAAwAAAB2NC4wLjMwMzE5AAAAAAUAbAAAALwBAAAjfgAAKAIAACQCAAAjU3RyaW5ncwAAAABMBAAAIAAAACNVUwBsBAAAEAAAACNHVUlEAAAAfAQAAAABAAAjQmxvYgAAAAAAAAACAAABRxUAAAkAAAAA+gEzABYAAAEAAAAPAAAAAgAAAAIAAAABAAAADgAAAAwAAAABAAAAAgAAAAAAnQEBAAAAAAAGABMB5wEGAGUB5wEGAFUA1AEPAAcCAAAGAIAAgwEGAEwBtgEGANwAtgEGAJkAtgEGALYAtgEGADMBtgEGAGkAtgEGAPsA5wEGADoA5wEGABsCrwEKABkArwEAAAAACQAAAAAAAQABAAAAEACnAQAAOQABAAEAUCAAAAAAkQABACMAAQBdIAAAAACGGM4BBgACAAAAAQAWAgkAzgEBABEAzgEGABkAzgEKACkAzgEQADEAzgEQADkAzgEQAEEAzgEQAEkAzgEQAFEAzgEQAFkAzgEQAGEAzgEBAGkAzgEGAHkAMAAVAHEAzgEGACcAWwD0AC4ACwApAC4AEwAyAC4AGwBRAC4AIwBaAC4AKwCYAC4AMwCjAC4AOwCuAC4AQwC7AC4ASwCYAC4AUwCYAEMAYwDvAASAAAABAAAAAAAAAAAAAAAAAMgBAAAJAAAAAAAAAAAAAAAaACEAAAAAAAkAAAAAAAAAAAAAABoAEgAAAAAAAAAAAAA8TWFpbj4kADxNb2R1bGU+AFN5c3RlbS5Db25zb2xlAFN5c3RlbS5SdW50aW1lAFdyaXRlTGluZQBDb21waWxlckdlbmVyYXRlZEF0dHJpYnV0ZQBEZWJ1Z2dhYmxlQXR0cmlidXRlAEFzc2VtYmx5VGl0bGVBdHRyaWJ1dGUAVGFyZ2V0RnJhbWV3b3JrQXR0cmlidXRlAEFzc2VtYmx5RmlsZVZlcnNpb25BdHRyaWJ1dGUAQXNzZW1ibHlJbmZvcm1hdGlvbmFsVmVyc2lvbkF0dHJpYnV0ZQBBc3NlbWJseUNvbmZpZ3VyYXRpb25BdHRyaWJ1dGUAUmVmU2FmZXR5UnVsZXNBdHRyaWJ1dGUAQ29tcGlsYXRpb25SZWxheGF0aW9uc0F0dHJpYnV0ZQBBc3NlbWJseVByb2R1Y3RBdHRyaWJ1dGUAQXNzZW1ibHlDb21wYW55QXR0cmlidXRlAFJ1bnRpbWVDb21wYXRpYmlsaXR5QXR0cmlidXRlAFN5c3RlbS5SdW50aW1lLlZlcnNpb25pbmcATXlBcHAuZGxsAFByb2dyYW0AU3lzdGVtAFN5c3RlbS5SZWZsZWN0aW9uAE15QXBwAC5jdG9yAFN5c3RlbS5EaWFnbm9zdGljcwBTeXN0ZW0uUnVudGltZS5Db21waWxlclNlcnZpY2VzAERlYnVnZ2luZ01vZGVzAGFyZ3MAT2JqZWN0AAAAABtIAGUAbABsAG8ALAAgAFcAbwByAGwAZAAhAAAAAAC6dHO6K0cnR7QeijYz5DY9AAQgAQEIAyAAAQUgAQEREQQgAQEOBAABAQ4IsD9ffxHVCjoF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'

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
    location: resourceLocation
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}04'
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
      location: resourceLocation
      schemas: [
        {
          name: 'schema1'
          content: schemaContent
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
          b2bPartnerContent: {
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
            partnerClassification: 'Distributor'
            partnerContact: {
              name: 'John Doe'
              emailAddress: 'john.doe@example.com'
              telephoneNumber: '123-456-7890'
              faxNumber: '123-456-7891'
              supplyChainCode: 'SC123'
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
        {
          b2bPartnerContent: {
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
          content: mapContent
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
          content: assemblyContent
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
