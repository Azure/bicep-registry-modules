metadata name = 'PIM Role Assignments (All scopes)'
metadata description = 'This module deploys a PIM Role Assignment at a Management Group, Subscription or Resource Group scope.'

targetScope = 'managementGroup'

@sys.description('Required. You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleDefinitionIdOrName string

@sys.description('Required. The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).')
param principalId string

@sys.description('Optional. Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group.')
param resourceGroupName string = ''

@sys.description('Optional. Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
param subscriptionId string = ''

@sys.description('Optional. Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.')
param managementGroupId string = managementGroup().name

@sys.description('Optional. Location deployment metadata.')
param location string = deployment().location

@description('Required. The type of the PIM role assignment whether its active or eligible.')
param pimRoleAssignmentType pimRoleAssignmentTypeType

@sys.description('Optional. The justification for the role eligibility.')
param justification string = ''

@sys.description('Required. The type of the role assignment eligibility request.')
param requestType requestTypeType

@sys.description('Optional. The resultant role eligibility assignment id or the role eligibility assignment id being updated.')
param targetRoleEligibilityScheduleId string = ''

@sys.description('Optional. The role eligibility assignment instance id being updated.')
param targetRoleEligibilityScheduleInstanceId string = ''

@sys.description('Optional. The resultant role assignment schedule id or the role assignment schedule id being updated.')
param targetRoleAssignmentScheduleId string = ''

@sys.description('Optional. The role assignment schedule instance id being updated.')
param targetRoleAssignmentScheduleInstanceId string = ''

@sys.description('Optional. Ticket Info of the role eligibility.')
param ticketInfo ticketInfoType?

@sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to.')
param condition string = ''

@sys.description('Optional. Version of the condition. Currently accepted value is "2.0".')
@allowed([
  '2.0'
])
param conditionVersion string = '2.0'

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.authorization-pimroleassignment.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  location: location
}

module roleAssignment_mg 'modules/management-group.bicep' = if (empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-PimRoleAssignment-MG-Module'
  scope: managementGroup(managementGroupId)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    managementGroupId: managementGroupId
    requestType: requestType
    justification: justification
    targetRoleEligibilityScheduleId: targetRoleEligibilityScheduleId
    targetRoleEligibilityScheduleInstanceId: targetRoleEligibilityScheduleInstanceId
    targetRoleAssignmentScheduleId: targetRoleAssignmentScheduleId
    targetRoleAssignmentScheduleInstanceId: targetRoleAssignmentScheduleInstanceId
    ticketInfo: ticketInfo
    conditionVersion: !empty(condition) ? conditionVersion : null
    condition: condition
    pimRoleAssignmentType: pimRoleAssignmentType
  }
}

module roleAssignment_sub 'modules/subscription.bicep' = if (!empty(subscriptionId) && empty(resourceGroupName)) {
  name: '${uniqueString(deployment().name, location)}-PimRoleAssignment-Sub-Module'
  scope: subscription(subscriptionId)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    subscriptionId: subscriptionId
    requestType: requestType
    justification: justification
    targetRoleEligibilityScheduleId: targetRoleEligibilityScheduleId
    targetRoleEligibilityScheduleInstanceId: targetRoleEligibilityScheduleInstanceId
    ticketInfo: ticketInfo
    conditionVersion: !empty(condition) ? conditionVersion : null
    condition: condition
    pimRoleAssignmentType: pimRoleAssignmentType
  }
}

module roleAssignment_rg 'modules/resource-group.bicep' = if (!empty(resourceGroupName) && !empty(subscriptionId)) {
  name: '${uniqueString(deployment().name, location)}-PimRoleAssignment-RG-Module'
  scope: resourceGroup(subscriptionId, resourceGroupName)
  params: {
    roleDefinitionIdOrName: roleDefinitionIdOrName
    principalId: principalId
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
    requestType: requestType
    justification: justification
    targetRoleEligibilityScheduleId: targetRoleEligibilityScheduleId
    targetRoleEligibilityScheduleInstanceId: targetRoleEligibilityScheduleInstanceId
    ticketInfo: ticketInfo
    conditionVersion: !empty(condition) ? conditionVersion : null
    condition: condition
    pimRoleAssignmentType: pimRoleAssignmentType
  }
}

@sys.description('The GUID of the PIM Role Assignment.')
output name string = empty(subscriptionId) && empty(resourceGroupName)
  ? roleAssignment_mg.outputs.name
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? roleAssignment_sub.outputs.name
      : roleAssignment_rg.outputs.name)

@sys.description('The resource ID of the PIM Role Assignment.')
output resourceId string = empty(subscriptionId) && empty(resourceGroupName)
  ? roleAssignment_mg.outputs.resourceId
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? roleAssignment_sub.outputs.resourceId
      : roleAssignment_rg.outputs.resourceId)

@sys.description('The scope this PIM Role Assignment applies to.')
output scope string = empty(subscriptionId) && empty(resourceGroupName)
  ? roleAssignment_mg.outputs.scope
  : (!empty(subscriptionId) && empty(resourceGroupName)
      ? roleAssignment_sub.outputs.scope
      : roleAssignment_rg.outputs.scope)

// ================ //
// Definitions      //
// ================ //

@export()
@sys.description('Optional. The request type of the role assignment.')
type requestTypeType =
  | 'AdminAssign'
  | 'AdminExtend'
  | 'AdminRemove'
  | 'AdminRenew'
  | 'AdminUpdate'
  | 'SelfActivate'
  | 'SelfDeactivate'
  | 'SelfExtend'
  | 'SelfRenew'

@export()
@description('The type for a ticket info.')
type ticketInfoType = {
  @sys.description('Optional. The ticket number for the role eligibility assignment.')
  ticketNumber: string?

  @sys.description('Optional. The ticket system name for the role eligibility assignment.')
  ticketSystem: string?
}

@export()
@discriminator('roleAssignmentType')
@description('The type of the PIM role assignment whether its active or eligible.')
type pimRoleAssignmentTypeType = pimActiveRoleAssignmentType | pimEligibleRoleAssignmentType

@description('The type for an active PIM role assignment.')
type pimActiveRoleAssignmentType = {
  @description('Required. The type of the role assignment.')
  roleAssignmentType: 'Active'

  @description('Optional. The linked role eligibility schedule id - to activate an eligibility.')
  linkedRoleEligibilityScheduleId: string?

  @description('Optional. The resultant role assignment schedule id or the role assignment schedule id being updated.')
  targetRoleAssignmentScheduleId: string?

  @description('Optional. The role assignment schedule instance id being updated.')
  targetRoleAssignmentScheduleInstanceId: string?

  @description('Required. The schedule information for the role assignment.')
  scheduleInfo: roleAssignmentScheduleType
}

@description('The type for a PIM-eligible role assignment.')
type pimEligibleRoleAssignmentType = {
  @description('Required. The type of the role assignment.')
  roleAssignmentType: 'Eligible'

  @description('Optional. The resultant role eligibility schedule id or the role eligibility schedule id being updated.')
  targetRoleEligibilityScheduleId: string?

  @description('Optional. The role eligibility assignment instance id being updated.')
  targetRoleEligibilityScheduleInstanceId: string?

  @description('Required. The schedule information for the role assignment.')
  scheduleInfo: roleAssignmentScheduleType
}

@discriminator('durationType')
@description('The schedule information for the role assignment.')
type roleAssignmentScheduleType =
  | permenantRoleAssignmentScheduleType
  | timeBoundDurationRoleAssignmentScheduleType
  | timeBoundDateTimeRoleAssignmentScheduleType

@description('The type for a permanent role assignment schedule.')
type permenantRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'NoExpiration'
}

@description('The type for a time-bound role assignment schedule.')
type timeBoundDurationRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'AfterDuration'

  @description('Required. The duration for the role assignment.')
  duration: string

  @description('Required. The start time for the role assignment.')
  startTime: string
}

@description('The type for a date-bound role assignment schedule.')
type timeBoundDateTimeRoleAssignmentScheduleType = {
  @description('Required. The type of the duration.')
  durationType: 'AfterDateTime'

  @description('Required. The end date and time for the role assignment.')
  endDateTime: string

  @description('Required. The start date and time for the role assignment.')
  startTime: string
}
