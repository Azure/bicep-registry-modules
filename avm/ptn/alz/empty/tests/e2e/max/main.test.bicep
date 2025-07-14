targetScope = 'managementGroup'

metadata name = 'Using all parameters possible'
metadata description = 'This instance deploys the module with the maximum set of parameters possible.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'alzempmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

resource tenantRootMgExisting 'Microsoft.Management/managementGroups@2023-04-01' existing = {
  scope: tenant()
  name: tenant().tenantId
}

resource additionalTestManagementGroup 'Microsoft.Management/managementGroups@2023-04-01' = {
  scope: tenant()
  name: 'mg-${namePrefix}-test-${serviceShort}-max-additional'
  properties: {
    displayName: 'Additional Test Management Group - ALZ PTN Empty Max Test'
    details: {
      parent: {
        id: tenantRootMgExisting.id
      }
    }
  }
}
// ============== //
// Test Execution //
// ============== //

var alzCustomRbacRoleDefsJson = [
  loadJsonContent('lib/role_definitions/application_owners.alz_role_definition.json')
  loadJsonContent('lib/role_definitions/network_management.alz_role_definition.json')
  loadJsonContent('lib/role_definitions/network_subnet_contributor.alz_role_definition.json')
  loadJsonContent('lib/role_definitions/security_operations.alz_role_definition.json')
  loadJsonContent('lib/role_definitions/subscription_owner.alz_role_definition.json')
]

var alzCustomRbacRoleDefsJsonParsed = [
  for roleDef in alzCustomRbacRoleDefsJson: {
    name: roleDef.name
    roleName: roleDef.properties.roleName
    description: roleDef.properties.description
    actions: roleDef.properties.permissions[0].actions
    notActions: roleDef.properties.permissions[0].notActions
    dataActions: roleDef.properties.permissions[0].dataActions
    notDataActions: roleDef.properties.permissions[0].notDataActions
  }
]

var additionalTestCustomRbacRoleDefs = [
  {
    name: 'rbac-custom-role-4'
    actions: [
      'Microsoft.Compute/*/read'
    ]
  }
  {
    name: 'rbac-custom-role-3'
    actions: [
      'Microsoft.Storage/*/read'
    ]
  }
]

var unionedCustomRbacRoleDefs = union(alzCustomRbacRoleDefsJsonParsed, additionalTestCustomRbacRoleDefs)

var alzCustomPolicyDefsJson = [
  loadJsonContent('lib/policy_definitions/Audit-Disks-UnusedResourcesCostOptimization.alz_policy_definition.json')
  loadJsonContent('lib/policy_definitions/Deploy-Budget.alz_policy_definition.json')
  loadJsonContent('lib/policy_definitions/Deploy-ASC-SecurityContacts.alz_policy_definition.json')
  {
    name: 'custom-tags-policy-1'
    properties: {
      description: 'Audit resource groups that do not have particular tag'
      displayName: 'Custom audit resource groups missing tags'
      policyType: 'Custom'
      metadata: {
        category: 'Tags'
        version: '1.0.0'
      }
      mode: 'All'
      parameters: {
        tagName: {
          type: 'String'
          metadata: {
            description: 'Name of the tag, such as costCenter'
          }
        }
        effect: {
          type: 'String'
          metadata: {
            displayName: 'Effect'
            description: 'Audit or Disabled the execution of the Policy'
          }
          allowedValues: [
            'Audit'
            'Disabled'
          ]
          defaultValue: 'Audit'
        }
      }
      policyRule: {
        if: {
          allOf: [
            {
              field: 'type'
              equals: 'Microsoft.Resources/subscriptions/resourceGroups'
            }
            {
              field: '[[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              exists: false
            }
          ]
        }
        then: {
          effect: '[[parameters(\'effect\')]'
        }
      }
    }
  }
]

var alzCustomPolicySetDefsJson = [
  loadJsonContent('lib/policy_set_definitions/Audit-TrustedLaunch.alz_policy_set_definition.json')
  loadJsonContent('lib/policy_set_definitions/Deploy-MDFC-Config_20240319.alz_policy_set_definition.json')
  {
    name: 'custom-tags-policy-set-definition-1'
    properties: {
      description: 'Custom tags policy set definition'
      displayName: 'Custom tags policy set definition'
      policyType: 'Custom'
      metadata: {
        category: 'Tags'
        version: '1.0.0'
      }
      parameters: {
        tagName: {
          type: 'String'
          metadata: {
            description: 'Name of the tag, such as costCenter'
          }
        }
        effect: {
          type: 'String'
          metadata: {
            displayName: 'Effect'
            description: 'Audit or Disabled the execution of the Policy'
          }
          allowedValues: [
            'Audit'
            'Disabled'
          ]
          defaultValue: 'Audit'
        }
      }
      policyDefinitions: [
        {
          policyDefinitionId: '{customPolicyDefinitionScopeId}/providers/Microsoft.Authorization/policyDefinitions/custom-tags-policy-1'
          policyDefinitionReferenceId: 'custom-tags-policy-1'
          parameters: {
            tagName: {
              value: '[[[parameters(\'tagName\')]'
            }
            effect: {
              value: '[[[parameters(\'effect\')]'
            }
          }
        }
      ]
    }
  }
]

var managementGroupCustomPolicyDefinitions = [
  for policy in alzCustomPolicyDefsJson: {
    name: policy.name
    properties: {
      description: policy.properties.description
      displayName: policy.properties.displayName
      metadata: policy.properties.metadata
      mode: policy.properties.mode
      parameters: policy.properties.parameters
      policyType: policy.properties.policyType
      policyRule: policy.properties.policyRule
    }
  }
]

var managementGroupCustomPolicySetDefinitions = [
  for policy in alzCustomPolicySetDefsJson: {
    name: policy.name
    properties: {
      description: policy.properties.description
      displayName: policy.properties.displayName
      metadata: policy.properties.metadata
      parameters: policy.properties.parameters
      policyType: policy.properties.policyType
      version: policy.properties.?version
      policyDefinitions: policy.properties.policyDefinitions
    }
  }
]

var managementGroupRoleAssignments = [
  {
    principalId: deployer().objectId
    roleDefinitionIdOrName: 'Security Reader'
  }
  {
    principalId: deployer().objectId
    roleDefinitionIdOrName: 'Reader'
  }
  {
    principalId: deployer().objectId
    roleDefinitionIdOrName: alzCustomRbacRoleDefsJson[4].name
  }
]

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      createOrUpdateManagementGroup: true
      managementGroupName: 'mg-${namePrefix}-test-${serviceShort}'
      managementGroupDisplayName: 'AVM ALZ PTN Empty Max Test'
      managementGroupRoleAssignments: managementGroupRoleAssignments
      managementGroupCustomRoleDefinitions: unionedCustomRbacRoleDefs
      managementGroupPolicyAssignments: [
        {
          name: 'allowed-vm-skus-root'
          displayName: 'Allowed virtual machine size SKUs'
          identity: 'None'
          enforcementMode: 'Default'
          policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
          definitionVersion: '1.*.*'
          parameters: {
            listOfAllowedSKUs: {
              value: [
                'Standard_D2_v5'
                'Standard_E8_v5'
              ]
            }
          }
        }
        {
          name: 'diag-activity-log-lz'
          displayName: 'Configure Azure Activity logs to stream to specified Log Analytics workspace'
          identity: 'SystemAssigned'
          enforcementMode: 'Default'
          policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
          parameters: {
            logAnalytics: {
              value: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-landing-zones/providers/Microsoft.OperationalInsights/workspaces/la-landing-zones'
            }
          }
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
            '/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293'
          ]
          additionalManagementGroupsIDsToAssignRbacTo: [
            additionalTestManagementGroup.name
          ]
        }
        {
          name: 'tags-policy'
          displayName: 'Tag checking'
          identity: 'None'
          enforcementMode: 'Default'
          policyDefinitionId: '/providers/Microsoft.Management/managementGroups/mg-${namePrefix}-test-${serviceShort}/providers/Microsoft.Authorization/policySetDefinitions/custom-tags-policy-set-definition-1'
          parameters: {
            tagName: {
              value: 'costCenter'
            }
            effect: {
              value: 'Audit'
            }
          }
        }
      ]
      managementGroupCustomPolicyDefinitions: managementGroupCustomPolicyDefinitions
      managementGroupCustomPolicySetDefinitions: managementGroupCustomPolicySetDefinitions
    }
  }
]
