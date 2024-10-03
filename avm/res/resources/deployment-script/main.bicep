metadata name = 'Deployment Scripts'
metadata description = 'This module deploys Deployment Scripts.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //
@description('Required. Name of the Deployment Script.')
@maxLength(90)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. Specifies the Kind of the Deployment Script.')
@allowed([
  'AzureCLI'
  'AzurePowerShell'
])
param kind string

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Azure PowerShell module version to be used. See a list of supported Azure PowerShell versions: https://mcr.microsoft.com/v2/azuredeploymentscripts-powershell/tags/list.')
param azPowerShellVersion string?

@description('Optional. Azure CLI module version to be used. See a list of supported Azure CLI versions: https://mcr.microsoft.com/v2/azure-cli/tags/list.')
param azCliVersion string?

@description('Optional. Script body. Max length: 32000 characters. To run an external script, use primaryScriptURI instead.')
param scriptContent string?

@description('Optional. Uri for the external script. This is the entry point for the external script. To run an internal script, use the scriptContent parameter instead.')
param primaryScriptUri string?

@description('Optional. The environment variables to pass over to the script.')
param environmentVariables environmentVariableType[]?

@description('Optional. List of supporting files for the external script (defined in primaryScriptUri). Does not work with internal scripts (code defined in scriptContent).')
param supportingScriptUris array?

@description('Optional. List of subnet IDs to use for the container group. This is required if you want to run the deployment script in a private network. When using a private network, the `Storage File Data Privileged Contributor` role needs to be assigned to the user-assigned managed identity and the deployment principal needs to have permissions to list the storage account keys. Also, Shared-Keys must not be disabled on the used storage account [ref](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-vnet).')
param subnetResourceIds string[]?

@description('Optional. Command-line arguments to pass to the script. Arguments are separated by spaces.')
param arguments string?

@description('Optional. Interval for which the service retains the script resource after it reaches a terminal state. Resource will be deleted when this duration expires. Duration is based on ISO 8601 pattern (for example P7D means one week).')
param retentionInterval string = 'P1D'

@description('Generated. Do not provide a value! This date value is used to make sure the script run every time the template is deployed.')
param baseTime string = utcNow('yyyy-MM-dd-HH-mm-ss')

@description('Optional. When set to false, script will run every time the template is deployed. When set to true, the script will only run once.')
param runOnce bool = false

@description('Optional. The clean up preference when the script execution gets in a terminal state. Specify the preference on when to delete the deployment script resources. The default value is Always, which means the deployment script resources are deleted despite the terminal state (Succeeded, Failed, canceled).')
@allowed([
  'Always'
  'OnSuccess'
  'OnExpiration'
])
param cleanupPreference string = 'Always'

@description('Optional. Container group name, if not specified then the name will get auto-generated. Not specifying a \'containerGroupName\' indicates the system to generate a unique name which might end up flagging an Azure Policy as non-compliant. Use \'containerGroupName\' when you have an Azure Policy that expects a specific naming convention or when you want to fully control the name. \'containerGroupName\' property must be between 1 and 63 characters long, must contain only lowercase letters, numbers, and dashes and it cannot start or end with a dash and consecutive dashes are not allowed.')
param containerGroupName string?

@description('Optional. The resource ID of the storage account to use for this deployment script. If none is provided, the deployment script uses a temporary, managed storage account.')
param storageAccountResourceId string = ''

@description('Optional. Maximum allowed script execution time specified in ISO 8601 format. Default value is PT1H - 1 hour; \'PT30M\' - 30 minutes; \'P5D\' - 5 days; \'P1Y\' 1 year.')
param timeout string?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =========== //
// Variables   //
// =========== //

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

var subnetIds = [
  for subnetResourceId in (subnetResourceIds ?? []): {
    id: subnetResourceId
  }
]

var containerSettings = {
  containerGroupName: containerGroupName
  subnetIds: !empty(subnetIds ?? []) ? subnetIds : null
}

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourcesIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourcesIds ?? {}) ? 'UserAssigned' : null
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = if (!empty(storageAccountResourceId)) {
  name: last(split((!empty(storageAccountResourceId) ? storageAccountResourceId : 'dummyAccount'), '/'))!
  scope: resourceGroup(
    split((!empty(storageAccountResourceId) ? storageAccountResourceId : '//'), '/')[2],
    split((!empty(storageAccountResourceId) ? storageAccountResourceId : '////'), '/')[4]
  )
}

var storageAccountSettings = !empty(storageAccountResourceId)
  ? {
      storageAccountKey: empty(subnetResourceIds) ? listKeys(storageAccount.id, '2023-01-01').keys[0].value : null
      storageAccountName: last(split(storageAccountResourceId, '/'))
    }
  : null

// ================ //
// Resources        //
// ================ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.resources-deploymentscript.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  kind: any(kind)
  properties: {
    azPowerShellVersion: kind == 'AzurePowerShell' ? azPowerShellVersion : null
    azCliVersion: kind == 'AzureCLI' ? azCliVersion : null
    containerSettings: !empty(containerSettings) ? containerSettings : null
    storageAccountSettings: !empty(storageAccountResourceId) ? storageAccountSettings : null
    arguments: arguments
    environmentVariables: environmentVariables
    scriptContent: !empty(scriptContent) ? scriptContent : null
    primaryScriptUri: !empty(primaryScriptUri) ? primaryScriptUri : null
    supportingScriptUris: !empty(supportingScriptUris) ? supportingScriptUris : null
    cleanupPreference: cleanupPreference
    forceUpdateTag: runOnce ? resourceGroup().name : baseTime
    retentionInterval: retentionInterval
    timeout: timeout
  }
}

resource deploymentScript_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: deploymentScript
}

resource deploymentScript_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(deploymentScript.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: deploymentScript
  }
]

resource deploymentScriptLogs 'Microsoft.Resources/deploymentScripts/logs@2023-08-01' existing = {
  name: 'default'
  parent: deploymentScript
}

// ================ //
// Outputs          //
// ================ //

@description('The resource ID of the deployment script.')
output resourceId string = deploymentScript.id

@description('The resource group the deployment script was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the deployment script.')
output name string = deploymentScript.name

@description('The location the resource was deployed into.')
output location string = deploymentScript.location

@description('The output of the deployment script.')
output outputs object = deploymentScript.properties.?outputs ?? {}

@description('The logs of the deployment script.')
output deploymentScriptLogs string[] = split(deploymentScriptLogs.properties.log, '\n')

// ================ //
// Definitions      //
// ================ //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourcesIds: string[]
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type environmentVariableType = {
  @description('Required. The name of the environment variable.')
  name: string

  @description('Required. The value of the secure environment variable.')
  @secure()
  secureValue: string?

  @description('Required. The value of the environment variable.')
  value: string?
}
