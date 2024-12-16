metadata name = 'avm/ptn/authorization/role-definition'
metadata description = 'This module deploys a custom role definition to a Management Group.'
metadata owner = '@jtracey93'

targetScope = 'managementGroup'

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. The location of the telemetry deployment to be created. Default is location of deployment.')
param location string = deployment().location

@sys.description('Required. The name of the custom role definition.')
param name string

@sys.description('Optional. The description of the custom role definition.')
param description string?

@sys.description('Optional. The assignable scopes of the custom role definition. If not specified, the management group being targeted in the parameter managementGroupName will be used.')
param assignableScopes array?

@sys.description('Optional. The permission actions of the custom role definition.')
param actions array?

@sys.description('Optional. The permission not actions of the custom role definition.')
param notActions array?

@sys.description('Optional. The permission data actions of the custom role definition.')
param dataActions array?

@sys.description('Optional. The permission not data actions of the custom role definition.')
param notDataActions array?

@sys.description('Optional. The display name of the custom role definition. If not specified, the name will be used.')
param roleName string?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.authorization-roledefinition.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource res_roleDefinition_mg 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' = {
  name: contains(name, '-') && length(name) == 36 && length(split(name, '-')) == 5 ? name : guid(name)
  properties: {
    roleName: roleDefinition.?roleName ?? roleDefinition.name
    description: roleDefinition.?description
    type: 'CustomRole'
    assignableScopes: roleDefinition.?assignableScopes ?? [
      managementGroup().id
    ]
    permissions: [
      {
        actions: roleDefinition.?actions ?? []
        notActions: roleDefinition.?notActions ?? []
        dataActions: roleDefinition.?dataActions ?? []
        notDataActions: roleDefinition.?notDataActions ?? []
      }
    ]
  }
}

// ============ //
// Outputs      //
// ============ //

@description('An object containing the resourceId, roleDefinitionId, and displayName of the custom role definition.')
output managementGroupCustomRoleDefinitionIds object = {
  resourceId: res_roleDefinition_mg.id
  roleDefinitionId: res_roleDefinition_mg.name
  displayName: res_roleDefinition_mg.properties.roleName
}
