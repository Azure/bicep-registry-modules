# Logic App Integration Account `[Microsoft.Logic/integrationAccounts]`

This module deploys a Logic App Integration Account.

You can reference the module as follows:
```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Logic/integrationAccounts` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts)</li></ul> |
| `Microsoft.Logic/integrationAccounts/agreements` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_agreements.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/agreements)</li></ul> |
| `Microsoft.Logic/integrationAccounts/assemblies` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_assemblies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/assemblies)</li></ul> |
| `Microsoft.Logic/integrationAccounts/certificates` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/certificates)</li></ul> |
| `Microsoft.Logic/integrationAccounts/maps` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_maps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/maps)</li></ul> |
| `Microsoft.Logic/integrationAccounts/partners` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_partners.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/partners)</li></ul> |
| `Microsoft.Logic/integrationAccounts/schemas` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_schemas.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/schemas)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/logic/integration-account:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  params: {
    name: 'liamin001'
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
    "name": {
      "value": "liamin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/logic/integration-account:<version>'

param name = 'liamin001'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  params: {
    // Required parameters
    name: 'iamax001'
    // Non-required parameters
    agreements: [
      {
        agreementType: 'X12'
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
        guestIdentity: {
          qualifier: 'ZZ'
          value: '1234567890'
        }
        guestPartner: 'partner1'
        hostIdentity: {
          qualifier: 'ZZ'
          value: '0987654321'
        }
        hostPartner: 'partner2'
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'agreement1'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
    assemblies: [
      {
        assemblyName: 'name1'
        content: '<content>'
        name: 'assembly1'
      }
    ]
    certificates: [
      {
        key: {
          keyName: '<keyName>'
          keyVault: {
            id: '<id>'
          }
        }
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'certificate1'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
        metricCategories: []
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    maps: [
      {
        content: '<content>'
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'map1'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
    partners: [
      {
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
        name: 'partner1'
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
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'partner2'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
    roleAssignments: [
      {
        name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
    schemas: [
      {
        content: '<content>'
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'schema1'
        schemaType: 'Xml'
        tags: {
          tag1: 'value1'
          tag2: 'value2'
        }
      }
    ]
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
    "name": {
      "value": "iamax001"
    },
    // Non-required parameters
    "agreements": {
      "value": [
        {
          "agreementType": "X12",
          "content": {
            "x12": {
              "receiveAgreement": {
                "protocolSettings": {
                  "acknowledgementSettings": {
                    "acknowledgementControlNumberLowerBound": 1,
                    "acknowledgementControlNumberUpperBound": 999999999,
                    "batchFunctionalAcknowledgements": true,
                    "batchImplementationAcknowledgements": false,
                    "batchTechnicalAcknowledgements": true,
                    "needFunctionalAcknowledgement": false,
                    "needImplementationAcknowledgement": false,
                    "needLoopForValidMessages": false,
                    "needTechnicalAcknowledgement": false,
                    "rolloverAcknowledgementControlNumber": true,
                    "sendSynchronousAcknowledgement": false
                  },
                  "envelopeSettings": {
                    "controlStandardsId": 85,
                    "controlVersionNumber": "00401",
                    "enableDefaultGroupHeaders": true,
                    "groupControlNumberLowerBound": 1,
                    "groupControlNumberUpperBound": 999999999,
                    "groupHeaderAgencyCode": "T",
                    "groupHeaderDateFormat": "CCYYMMDD",
                    "groupHeaderTimeFormat": "HHMM",
                    "groupHeaderVersion": "00401",
                    "interchangeControlNumberLowerBound": 1,
                    "interchangeControlNumberUpperBound": 999999999,
                    "overwriteExistingTransactionSetControlNumber": true,
                    "receiverApplicationId": "RECEIVER",
                    "rolloverGroupControlNumber": true,
                    "rolloverInterchangeControlNumber": true,
                    "rolloverTransactionSetControlNumber": true,
                    "senderApplicationId": "SENDER",
                    "transactionSetControlNumberLowerBound": 1,
                    "transactionSetControlNumberUpperBound": 999999999,
                    "usageIndicator": "Test",
                    "useControlStandardsIdAsRepetitionCharacter": false
                  },
                  "framingSettings": {
                    "characterSet": "UTF8",
                    "componentSeparator": 58,
                    "dataElementSeparator": 42,
                    "replaceCharacter": 36,
                    "replaceSeparatorsInPayload": false,
                    "segmentTerminator": 126,
                    "segmentTerminatorSuffix": "None"
                  },
                  "messageFilter": {
                    "messageFilterType": "Include"
                  },
                  "processingSettings": {
                    "convertImpliedDecimal": true,
                    "createEmptyXmlTagsForTrailingSeparators": true,
                    "maskSecurityInfo": true,
                    "preserveInterchange": true,
                    "suspendInterchangeOnError": true,
                    "useDotAsDecimalSeparator": true
                  },
                  "schemaReferences": [
                    {
                      "messageId": "850",
                      "schemaName": "schema1",
                      "schemaVersion": "00401"
                    }
                  ],
                  "securitySettings": {
                    "authorizationQualifier": "00",
                    "securityQualifier": "00"
                  },
                  "validationSettings": {
                    "allowLeadingAndTrailingSpacesAndZeroes": false,
                    "checkDuplicateGroupControlNumber": false,
                    "checkDuplicateInterchangeControlNumber": false,
                    "checkDuplicateTransactionSetControlNumber": false,
                    "interchangeControlNumberValidityDays": 30,
                    "trailingSeparatorPolicy": "NotAllowed",
                    "trimLeadingAndTrailingSpacesAndZeroes": true,
                    "validateCharacterSet": true,
                    "validateEDITypes": true,
                    "validateXSDTypes": false
                  }
                },
                "receiverBusinessIdentity": {
                  "qualifier": "ZZ",
                  "value": "1234567890"
                },
                "senderBusinessIdentity": {
                  "qualifier": "ZZ",
                  "value": "0987654321"
                }
              },
              "sendAgreement": {
                "protocolSettings": {
                  "acknowledgementSettings": {
                    "acknowledgementControlNumberLowerBound": 1,
                    "acknowledgementControlNumberUpperBound": 999999999,
                    "batchFunctionalAcknowledgements": true,
                    "batchImplementationAcknowledgements": false,
                    "batchTechnicalAcknowledgements": true,
                    "needFunctionalAcknowledgement": false,
                    "needImplementationAcknowledgement": false,
                    "needLoopForValidMessages": false,
                    "needTechnicalAcknowledgement": false,
                    "rolloverAcknowledgementControlNumber": true,
                    "sendSynchronousAcknowledgement": false
                  },
                  "envelopeSettings": {
                    "controlStandardsId": 85,
                    "controlVersionNumber": "00401",
                    "enableDefaultGroupHeaders": true,
                    "groupControlNumberLowerBound": 1,
                    "groupControlNumberUpperBound": 999999999,
                    "groupHeaderAgencyCode": "T",
                    "groupHeaderDateFormat": "CCYYMMDD",
                    "groupHeaderTimeFormat": "HHMM",
                    "groupHeaderVersion": "00401",
                    "interchangeControlNumberLowerBound": 1,
                    "interchangeControlNumberUpperBound": 999999999,
                    "overwriteExistingTransactionSetControlNumber": true,
                    "receiverApplicationId": "RECEIVER",
                    "rolloverGroupControlNumber": true,
                    "rolloverInterchangeControlNumber": true,
                    "rolloverTransactionSetControlNumber": true,
                    "senderApplicationId": "SENDER",
                    "transactionSetControlNumberLowerBound": 1,
                    "transactionSetControlNumberUpperBound": 999999999,
                    "usageIndicator": "Test",
                    "useControlStandardsIdAsRepetitionCharacter": false
                  },
                  "framingSettings": {
                    "characterSet": "UTF8",
                    "componentSeparator": 58,
                    "dataElementSeparator": 42,
                    "replaceCharacter": 36,
                    "replaceSeparatorsInPayload": false,
                    "segmentTerminator": 126,
                    "segmentTerminatorSuffix": "None"
                  },
                  "messageFilter": {
                    "messageFilterType": "Include"
                  },
                  "processingSettings": {
                    "convertImpliedDecimal": true,
                    "createEmptyXmlTagsForTrailingSeparators": true,
                    "maskSecurityInfo": true,
                    "preserveInterchange": true,
                    "suspendInterchangeOnError": true,
                    "useDotAsDecimalSeparator": true
                  },
                  "schemaReferences": [
                    {
                      "messageId": "850",
                      "schemaName": "schema1",
                      "schemaVersion": "00401"
                    }
                  ],
                  "securitySettings": {
                    "authorizationQualifier": "00",
                    "securityQualifier": "00"
                  },
                  "validationSettings": {
                    "allowLeadingAndTrailingSpacesAndZeroes": false,
                    "checkDuplicateGroupControlNumber": false,
                    "checkDuplicateInterchangeControlNumber": false,
                    "checkDuplicateTransactionSetControlNumber": false,
                    "interchangeControlNumberValidityDays": 30,
                    "trailingSeparatorPolicy": "NotAllowed",
                    "trimLeadingAndTrailingSpacesAndZeroes": true,
                    "validateCharacterSet": true,
                    "validateEDITypes": true,
                    "validateXSDTypes": false
                  }
                },
                "receiverBusinessIdentity": {
                  "qualifier": "ZZ",
                  "value": "1234567890"
                },
                "senderBusinessIdentity": {
                  "qualifier": "ZZ",
                  "value": "0987654321"
                }
              }
            }
          },
          "guestIdentity": {
            "qualifier": "ZZ",
            "value": "1234567890"
          },
          "guestPartner": "partner1",
          "hostIdentity": {
            "qualifier": "ZZ",
            "value": "0987654321"
          },
          "hostPartner": "partner2",
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "agreement1",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
    },
    "assemblies": {
      "value": [
        {
          "assemblyName": "name1",
          "content": "<content>",
          "name": "assembly1"
        }
      ]
    },
    "certificates": {
      "value": [
        {
          "key": {
            "keyName": "<keyName>",
            "keyVault": {
              "id": "<id>"
            }
          },
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "certificate1",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs",
              "enabled": true
            }
          ],
          "metricCategories": [],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
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
    "maps": {
      "value": [
        {
          "content": "<content>",
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "map1",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
    },
    "partners": {
      "value": [
        {
          "b2b": {
            "businessIdentities": [
              {
                "qualifier": "ZZ",
                "value": "1234567890"
              },
              {
                "qualifier": "ZZZ",
                "value": "0987654321"
              }
            ]
          },
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "partner1",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        },
        {
          "b2b": {
            "businessIdentities": [
              {
                "qualifier": "ZZ",
                "value": "0987654321"
              },
              {
                "qualifier": "ZZZ",
                "value": "1122334455"
              }
            ]
          },
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "partner2",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "1f98c16b-ea00-4686-8b81-05353b594ea3",
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
    "schemas": {
      "value": [
        {
          "content": "<content>",
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "schema1",
          "schemaType": "Xml",
          "tags": {
            "tag1": "value1",
            "tag2": "value2"
          }
        }
      ]
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
using 'br/public:avm/res/logic/integration-account:<version>'

// Required parameters
param name = 'iamax001'
// Non-required parameters
param agreements = [
  {
    agreementType: 'X12'
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
    guestIdentity: {
      qualifier: 'ZZ'
      value: '1234567890'
    }
    guestPartner: 'partner1'
    hostIdentity: {
      qualifier: 'ZZ'
      value: '0987654321'
    }
    hostPartner: 'partner2'
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'agreement1'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param assemblies = [
  {
    assemblyName: 'name1'
    content: '<content>'
    name: 'assembly1'
  }
]
param certificates = [
  {
    key: {
      keyName: '<keyName>'
      keyVault: {
        id: '<id>'
      }
    }
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'certificate1'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metricCategories: []
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param maps = [
  {
    content: '<content>'
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'map1'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param partners = [
  {
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
    name: 'partner1'
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
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'partner2'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param roleAssignments = [
  {
    name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
param schemas = [
  {
    content: '<content>'
    metadata: {
      key1: 'value1'
      key2: 'value2'
    }
    name: 'schema1'
    schemaType: 'Xml'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module integrationAccount 'br/public:avm/res/logic/integration-account:<version>' = {
  params: {
    // Required parameters
    name: 'liawaf001'
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
            enabled: true
          }
        ]
        metricCategories: []
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    maps: [
      {
        content: '<content>'
        mapType: 'Xslt'
        metadata: {
          description: 'Transform purchase order to internal format'
          version: '1.0'
        }
        name: 'PurchaseOrderTransform'
      }
    ]
    partners: [
      {
        b2b: {
          businessIdentities: [
            {
              qualifier: 'ZZ'
              value: 'CONTOSO-SUPPLIER-001'
            }
          ]
        }
        metadata: {
          description: 'Primary supplier partner'
        }
        name: 'ContosoSupplier'
      }
      {
        b2b: {
          businessIdentities: [
            {
              qualifier: 'ZZ'
              value: 'FABRIKAM-BUYER-001'
            }
          ]
        }
        metadata: {
          description: 'Primary buyer partner'
        }
        name: 'FabrikamBuyer'
      }
    ]
    schemas: [
      {
        content: '<content>'
        metadata: {
          description: 'Purchase order validation schema'
          version: '1.0'
        }
        name: 'PurchaseOrderSchema'
        schemaType: 'Xml'
      }
    ]
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
    "name": {
      "value": "liawaf001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs",
              "enabled": true
            }
          ],
          "metricCategories": [],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "maps": {
      "value": [
        {
          "content": "<content>",
          "mapType": "Xslt",
          "metadata": {
            "description": "Transform purchase order to internal format",
            "version": "1.0"
          },
          "name": "PurchaseOrderTransform"
        }
      ]
    },
    "partners": {
      "value": [
        {
          "b2b": {
            "businessIdentities": [
              {
                "qualifier": "ZZ",
                "value": "CONTOSO-SUPPLIER-001"
              }
            ]
          },
          "metadata": {
            "description": "Primary supplier partner"
          },
          "name": "ContosoSupplier"
        },
        {
          "b2b": {
            "businessIdentities": [
              {
                "qualifier": "ZZ",
                "value": "FABRIKAM-BUYER-001"
              }
            ]
          },
          "metadata": {
            "description": "Primary buyer partner"
          },
          "name": "FabrikamBuyer"
        }
      ]
    },
    "schemas": {
      "value": [
        {
          "content": "<content>",
          "metadata": {
            "description": "Purchase order validation schema",
            "version": "1.0"
          },
          "name": "PurchaseOrderSchema",
          "schemaType": "Xml"
        }
      ]
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
using 'br/public:avm/res/logic/integration-account:<version>'

// Required parameters
param name = 'liawaf001'
// Non-required parameters
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    logCategoriesAndGroups: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metricCategories: []
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param maps = [
  {
    content: '<content>'
    mapType: 'Xslt'
    metadata: {
      description: 'Transform purchase order to internal format'
      version: '1.0'
    }
    name: 'PurchaseOrderTransform'
  }
]
param partners = [
  {
    b2b: {
      businessIdentities: [
        {
          qualifier: 'ZZ'
          value: 'CONTOSO-SUPPLIER-001'
        }
      ]
    }
    metadata: {
      description: 'Primary supplier partner'
    }
    name: 'ContosoSupplier'
  }
  {
    b2b: {
      businessIdentities: [
        {
          qualifier: 'ZZ'
          value: 'FABRIKAM-BUYER-001'
        }
      ]
    }
    metadata: {
      description: 'Primary buyer partner'
    }
    name: 'FabrikamBuyer'
  }
]
param schemas = [
  {
    content: '<content>'
    metadata: {
      description: 'Purchase order validation schema'
      version: '1.0'
    }
    name: 'PurchaseOrderSchema'
    schemaType: 'Xml'
  }
]
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
| [`name`](#parameter-name) | string | Name of the integration account to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agreements`](#parameter-agreements) | array | All agreements to create. |
| [`assemblies`](#parameter-assemblies) | array | All assemblies to create. |
| [`certificates`](#parameter-certificates) | array | All certificates to create. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maps`](#parameter-maps) | array | All maps to create. |
| [`partners`](#parameter-partners) | array | All partners to create. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`schemas`](#parameter-schemas) | array | All schemas to create. |
| [`sku`](#parameter-sku) | string | Integration account sku name. |
| [`state`](#parameter-state) | string | The state. Allowed values are Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the integration account to create.

- Required: Yes
- Type: string

### Parameter: `agreements`

All agreements to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`agreementType`](#parameter-agreementsagreementtype) | string | The agreement type. |
| [`content`](#parameter-agreementscontent) | object | The agreement content settings. |
| [`guestIdentity`](#parameter-agreementsguestidentity) | object | The guest identity for the agreement. |
| [`guestPartner`](#parameter-agreementsguestpartner) | string | The guest partner name for the agreement. |
| [`hostIdentity`](#parameter-agreementshostidentity) | object | The host identity for the agreement. |
| [`hostPartner`](#parameter-agreementshostpartner) | string | The host partner name for the agreement. |
| [`name`](#parameter-agreementsname) | string | The name of the agreement resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-agreementslocation) | string | Resource location. |
| [`metadata`](#parameter-agreementsmetadata) |  | The agreement metadata. |
| [`tags`](#parameter-agreementstags) | object | Resource tags. |

### Parameter: `agreements.agreementType`

The agreement type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AS2'
    'Edifact'
    'NotSpecified'
    'X12'
  ]
  ```

### Parameter: `agreements.content`

The agreement content settings.

- Required: Yes
- Type: object

### Parameter: `agreements.guestIdentity`

The guest identity for the agreement.

- Required: Yes
- Type: object

### Parameter: `agreements.guestPartner`

The guest partner name for the agreement.

- Required: Yes
- Type: string

### Parameter: `agreements.hostIdentity`

The host identity for the agreement.

- Required: Yes
- Type: object

### Parameter: `agreements.hostPartner`

The host partner name for the agreement.

- Required: Yes
- Type: string

### Parameter: `agreements.name`

The name of the agreement resource.

- Required: Yes
- Type: string

### Parameter: `agreements.location`

Resource location.

- Required: No
- Type: string

### Parameter: `agreements.metadata`

The agreement metadata.

- Required: No
- Type: 

### Parameter: `agreements.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `assemblies`

All assemblies to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assemblyName`](#parameter-assembliesassemblyname) | string | The assembly name. |
| [`content`](#parameter-assembliescontent) | string | The assembly content. |
| [`name`](#parameter-assembliesname) | string | The Name of the assembly resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-assembliescontenttype) | string | The assembly content type. |
| [`location`](#parameter-assemblieslocation) | string | Resource location. |
| [`metadata`](#parameter-assembliesmetadata) |  | The assembly metadata. |
| [`tags`](#parameter-assembliestags) | object | Resource tags. |

### Parameter: `assemblies.assemblyName`

The assembly name.

- Required: Yes
- Type: string

### Parameter: `assemblies.content`

The assembly content.

- Required: Yes
- Type: string

### Parameter: `assemblies.name`

The Name of the assembly resource.

- Required: Yes
- Type: string

### Parameter: `assemblies.contentType`

The assembly content type.

- Required: No
- Type: string

### Parameter: `assemblies.location`

Resource location.

- Required: No
- Type: string

### Parameter: `assemblies.metadata`

The assembly metadata.

- Required: No
- Type: 

### Parameter: `assemblies.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `certificates`

All certificates to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-certificatesname) | string | The Name of the certificate resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-certificateskey) | object | The key details in the key vault. |
| [`location`](#parameter-certificateslocation) | string | Resource location. |
| [`metadata`](#parameter-certificatesmetadata) |  | The certificate metadata. |
| [`publicCertificate`](#parameter-certificatespubliccertificate) | string | The public certificate. |
| [`tags`](#parameter-certificatestags) | object | Resource tags. |

### Parameter: `certificates.name`

The Name of the certificate resource.

- Required: Yes
- Type: string

### Parameter: `certificates.key`

The key details in the key vault.

- Required: No
- Type: object

### Parameter: `certificates.location`

Resource location.

- Required: No
- Type: string

### Parameter: `certificates.metadata`

The certificate metadata.

- Required: No
- Type: 

### Parameter: `certificates.publicCertificate`

The public certificate.

- Required: No
- Type: string

### Parameter: `certificates.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `maps`

All maps to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-mapscontent) | string | The content of the map. |
| [`name`](#parameter-mapsname) | string | The name of the map resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-mapscontenttype) | string | The content type of the map. |
| [`location`](#parameter-mapslocation) | string | Resource location. |
| [`mapType`](#parameter-mapsmaptype) | string | The map type. Default is "Xslt". |
| [`metadata`](#parameter-mapsmetadata) | object | The metadata. |
| [`parametersSchema`](#parameter-mapsparametersschema) | object | The parameters schema of integration account map. |
| [`tags`](#parameter-mapstags) | object | Resource tags. |

### Parameter: `maps.content`

The content of the map.

- Required: Yes
- Type: string

### Parameter: `maps.name`

The name of the map resource.

- Required: Yes
- Type: string

### Parameter: `maps.contentType`

The content type of the map.

- Required: No
- Type: string

### Parameter: `maps.location`

Resource location.

- Required: No
- Type: string

### Parameter: `maps.mapType`

The map type. Default is "Xslt".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Liquid'
    'NotSpecified'
    'Xslt'
    'Xslt20'
    'Xslt30'
  ]
  ```

### Parameter: `maps.metadata`

The metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-mapsmetadata>any_other_property<) | string | A metadata key-value pair. |

### Parameter: `maps.metadata.>Any_other_property<`

A metadata key-value pair.

- Required: No
- Type: string

### Parameter: `maps.parametersSchema`

The parameters schema of integration account map.

- Required: No
- Type: object

### Parameter: `maps.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `partners`

All partners to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-partnersname) | string | The Name of the partner resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`b2b`](#parameter-partnersb2b) | object | The B2B partner content settings. |
| [`metadata`](#parameter-partnersmetadata) | object | The metadata. |
| [`tags`](#parameter-partnerstags) | object | Resource tags. |

### Parameter: `partners.name`

The Name of the partner resource.

- Required: Yes
- Type: string

### Parameter: `partners.b2b`

The B2B partner content settings.

- Required: No
- Type: object

### Parameter: `partners.metadata`

The metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-partnersmetadata>any_other_property<) | string | A metadata key-value pair. |

### Parameter: `partners.metadata.>Any_other_property<`

A metadata key-value pair.

- Required: No
- Type: string

### Parameter: `partners.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'App Compliance Automation Administrator'`
  - `'App Compliance Automation Reader'`
  - `'Contributor'`
  - `'Log Analytics Contributor'`
  - `'Log Analytics Reader'`
  - `'Logic App Contributor'`
  - `'Logic App Operator'`
  - `'Managed Application Contributor Role'`
  - `'Managed Application Operator Role'`
  - `'Managed Application Publisher Operator'`
  - `'Monitoring Contributor'`
  - `'Monitoring Metrics Publisher'`
  - `'Monitoring Reader'`
  - `'Resource Policy Contributor'`
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

### Parameter: `schemas`

All schemas to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`content`](#parameter-schemascontent) | string | The schema content. |
| [`name`](#parameter-schemasname) | string | The Name of the schema resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-schemascontenttype) | string | The schema content type. |
| [`documentName`](#parameter-schemasdocumentname) | string | The document name. |
| [`location`](#parameter-schemaslocation) | string | Resource location. |
| [`metadata`](#parameter-schemasmetadata) | object | The metadata. |
| [`schemaType`](#parameter-schemasschematype) | string | The schema type. |
| [`tags`](#parameter-schemastags) | object | Resource tags. |
| [`targetNamespace`](#parameter-schemastargetnamespace) | string | The target namespace of the schema. |

### Parameter: `schemas.content`

The schema content.

- Required: Yes
- Type: string

### Parameter: `schemas.name`

The Name of the schema resource.

- Required: Yes
- Type: string

### Parameter: `schemas.contentType`

The schema content type.

- Required: No
- Type: string

### Parameter: `schemas.documentName`

The document name.

- Required: No
- Type: string

### Parameter: `schemas.location`

Resource location.

- Required: No
- Type: string

### Parameter: `schemas.metadata`

The metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-schemasmetadata>any_other_property<) | string | A metadata key-value pair. |

### Parameter: `schemas.metadata.>Any_other_property<`

A metadata key-value pair.

- Required: No
- Type: string

### Parameter: `schemas.schemaType`

The schema type.

- Required: No
- Type: string

### Parameter: `schemas.tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `schemas.targetNamespace`

The target namespace of the schema.

- Required: No
- Type: string

### Parameter: `sku`

Integration account sku name.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Free'
    'NotSpecified'
    'Standard'
  ]
  ```

### Parameter: `state`

The state. Allowed values are Completed, Deleted, Disabled, Enabled, NotSpecified, Suspended.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Completed'
    'Deleted'
    'Disabled'
    'Enabled'
    'NotSpecified'
    'Suspended'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the integration account. |
| `resourceGroupName` | string | The resource group the integration account was deployed into. |
| `resourceId` | string | The resource ID of the integration account. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
