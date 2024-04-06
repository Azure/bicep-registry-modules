targetScope = 'subscription'

metadata name = 'Using only defaults'
metadata description = 'This instance deploys the module with the minimum set of required parameters.'

// ========== //
// Parameters //
// ========== //

@sys.description('Optional. The location to deploy resources to.')
param location string = deployment().location

@sys.description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'pirsubmin'

@sys.description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'dep-${namePrefix}-polDef-ModSubTag-${serviceShort}'
  properties: {
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            equals: 'Microsoft.Resources/subscriptions'
            field: 'type'
          }
          {
            field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
          ]
          operations: [
            {
              operation: 'add'
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              value: '[parameters(\'tagValue\')]'
            }
          ]
        }
      }
    }
    parameters: {
      effect: {
        allowedValues: [
          'Modify'
        ]
        defaultValue: 'Modify'
        type: 'String'
      }
      tagName: {
        type: 'String'
        defaultValue: 'testTag'
      }
      tagValue: {
        type: 'String'
        defaultValue: 'testValue'
      }
    }
  }
}

resource policySet 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'dep-${namePrefix}-polSet-${serviceShort}'
  properties: {
    policyDefinitions: [
      {
        parameters: {
          effect: {
            value: 'Modify'
          }
        }
        policyDefinitionId: policyDefinition.id
        policyDefinitionReferenceId: policyDefinition.name
      }
    ]
  }
}

resource policySetAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'dep-${namePrefix}-psa-${serviceShort}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Test case assignment'
    policyDefinitionId: policySet.id
  }
}

resource tagContributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: '4a9ae827-6dc8-4573-8ac7-8239d42aa03f'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, tagContributorRoleDefinition.id)
  properties: {
    principalId: policySetAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: tagContributorRoleDefinition.id
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../subscription/main.bicep' = {
  name: '${uniqueString(deployment().name)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    location: location
    policyAssignmentId: policySetAssignment.id
    policyDefinitionReferenceId: policySet.properties.policyDefinitions[0].policyDefinitionReferenceId
    filtersLocations: []
  }
}

// ================ //
// Outputs          //
// ================ //

@sys.description('The name of the remediation.')
output name string = testDeployment.outputs.name

@sys.description('The resource ID of the remediation.')
output resourceId string = testDeployment.outputs.resourceId

@sys.description('The location the resource was deployed into.')
output location string = testDeployment.outputs.location
