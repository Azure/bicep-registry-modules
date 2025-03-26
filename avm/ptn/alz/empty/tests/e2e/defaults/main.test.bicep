targetScope = 'managementGroup'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-ptn-pl-pdns-zones-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'plpdnsmin'

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

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
  }
]

param enableTelemetry bool = false

var alzCustomRbacRoleDefsJson = [
  loadJsonContent('../lib/role_definitions/application_owners.alz_role_definition.json')
  loadJsonContent('../lib/role_definitions/network_management.alz_role_definition.json')
  loadJsonContent('../lib/role_definitions/network_subnet_contributor.alz_role_definition.json')
  loadJsonContent('../lib/role_definitions/security_operations.alz_role_definition.json')
  loadJsonContent('../lib/role_definitions/subscription_owner.alz_role_definition.json')
]

// level 1
module intRoot '../main.bicep' = {
  name: 'intRoot'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz'
    managementGroupRoleAssignments: [
      {
        principalId: 'd543c6f0-89ce-4d51-a9fd-5b61986278a9'
        roleDefinitionIdOrName: 'Security Reader'
      }
      {
        principalId: deployer().objectId
        roleDefinitionIdOrName: 'Reader'
      }
      {
        principalId: 'd543c6f0-89ce-4d51-a9fd-5b61986278a9'
        roleDefinitionIdOrName: alzCustomRbacRoleDefsJson[4].name
      }
    ]
    managementGroupCustomRoleDefinitions: [
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
    managementGroupPolicyAssignments: [
      {
        name: 'allowed-vm-skus-root'
        displayName: 'Allowed virtual machine size SKUs'
        identity: 'None'
        enforcementMode: 'Default'
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3'
        parameters: {
          listOfAllowedSKUs: {
            value: [
              'Standard_D2_v5'
              'Standard_E8_v5'
            ]
          }
        }
      }
    ]
  }
}

// level 2
module platform '../main.bicep' = {
  name: 'platform'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-platform'
    managementGroupParentId: intRoot.outputs.managementGroupId
    managementGroupCustomRoleDefinitions: [
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
  }
}

module landingZones '../main.bicep' = {
  name: 'landingZones'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-landing-zones'
    managementGroupParentId: intRoot.outputs.managementGroupId
    managementGroupPolicyAssignments: [
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
          intRoot.outputs.managementGroupId
          'alz-sandbox'
        ]
        additionalSubscriptionIDsToAssignRbacTo: [
          'e38d562b-27f3-44db-9472-022f370a6f2d'
        ]
        additionalResourceGroupResourceIDsToAssignRbacTo: [
          '/subscriptions/e38d562b-27f3-44db-9472-022f370a6f2d/resourceGroups/test-rg'
        ]
      }
    ]
  }
}

module decommissioned '../main.bicep' = {
  name: 'decommissioned'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-decommissioned'
    managementGroupParentId: intRoot.outputs.managementGroupId
  }
}

module sandbox '../main.bicep' = {
  name: 'sandbox'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-sandbox'
    managementGroupParentId: intRoot.outputs.managementGroupId
  }
}

// level 3
//// platform children
module management '../main.bicep' = {
  name: 'management'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-platform-management'
    managementGroupParentId: platform.outputs.managementGroupId
  }
}

module connectivity '../main.bicep' = {
  name: 'connectivity'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-platform-connectivity'
    managementGroupParentId: platform.outputs.managementGroupId
  }
}

module identity '../main.bicep' = {
  name: 'identity'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-platform-identity'
    managementGroupParentId: platform.outputs.managementGroupId
  }
}

//// landingZones children
module corp '../main.bicep' = {
  name: 'corp'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-landing-zones-corp'
    managementGroupParentId: landingZones.outputs.managementGroupId
    subscriptionsToPlaceInManagementGroup: [
      'e38d562b-27f3-44db-9472-022f370a6f2d'
    ]
  }
}

module online '../main.bicep' = {
  name: 'online'
  params: {
    enableTelemetry: enableTelemetry
    managementGroupName: 'alz-landing-zones-online'
    managementGroupParentId: landingZones.outputs.managementGroupId
  }
}

// Outputs

output intRoot_managementGroupCustomRoleDefinitionIds array = intRoot.outputs.managementGroupCustomRoleDefinitionIds
output platform_managementGroupCustomRoleDefinitionIds array = platform.outputs.managementGroupCustomRoleDefinitionIds
output landingZones_managementGroupCustomRoleDefinitionIds array = landingZones.outputs.managementGroupCustomRoleDefinitionIds
output decommissioned_managementGroupCustomRoleDefinitionIds array = decommissioned.outputs.managementGroupCustomRoleDefinitionIds
output sandbox_managementGroupCustomRoleDefinitionIds array = sandbox.outputs.managementGroupCustomRoleDefinitionIds
output management_managementGroupCustomRoleDefinitionIds array = management.outputs.managementGroupCustomRoleDefinitionIds
output connectivity_managementGroupCustomRoleDefinitionIds array = connectivity.outputs.managementGroupCustomRoleDefinitionIds
output identity_managementGroupCustomRoleDefinitionIds array = identity.outputs.managementGroupCustomRoleDefinitionIds
output corp_managementGroupCustomRoleDefinitionIds array = corp.outputs.managementGroupCustomRoleDefinitionIds
output online_managementGroupCustomRoleDefinitionIds array = online.outputs.managementGroupCustomRoleDefinitionIds
