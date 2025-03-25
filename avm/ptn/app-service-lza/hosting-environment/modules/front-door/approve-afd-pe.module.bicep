@description('Optional. The location to deploy the Redis cache service.')
param location string

@description('Default value is OK. Sets how the deployment script should be forced to execute even if the script resource has not changed. Can be current time stamp')
param utcValue string = utcNow()

@description('Optional. The name of the user-assigned identity to be used to auto-approve the private endpoint connection of the AFD. Changing this forces a new resource to be created.')
param idAfdPeAutoApproverName string = guid(resourceGroup().id, 'userAssignedIdentity')

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

var roleAssignmentName = guid(resourceGroup().id, 'contributor')
var contributorRoleDefinitionId = resourceId(
  'Microsoft.Authorization/roleDefinitions',
  'b24988ac-6180-42a0-ab88-20f7382dd24c'
)
var deploymentScriptName = 'runAfdApproval'

var uami = resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', idAfdPeAutoApproverName)

@description('The User Assigned Managed Identity that will be given Contributor role on the Resource Group in order to auto-approve the Private Endpoint Connection of the AFD.')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: '${uniqueString(deployment().name, location)}-uami'
  params: {
    name: idAfdPeAutoApproverName
    location: location
    enableTelemetry: enableTelemetry
    tags: tags
  }
}

@description('The role assignment that will be created to give the User Assigned Managed Identity Contributor role on the Resource Group in order to auto-approve the Private Endpoint Connection of the AFD.')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: roleAssignmentName
  scope: resourceGroup()
  properties: {
    roleDefinitionId: contributorRoleDefinitionId
    principalId: userAssignedIdentity.outputs.principalId
    principalType: 'ServicePrincipal'
  }
}

@description('The deployment script that will be used to auto-approve the Private Endpoint Connection of the AFD.')
resource runAfdApproval 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: deploymentScriptName

  location: location
  tags: tags
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uami}': {}
    }
  }
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.47.0'
    timeout: 'PT30M'
    environmentVariables: [
      {
        name: 'ResourceGroupName'
        value: resourceGroup().name
      }
    ]
    scriptContent: 'rg_name="$ResourceGroupName"; webapp_ids=$(az webapp list -g $rg_name --query "[].id" -o tsv); for webapp_id in $webapp_ids; do fd_conn_ids=$(az network private-endpoint-connection list --id $webapp_id --query "[?properties.provisioningState == \'Pending\'].id" -o tsv); for fd_conn_id in $fd_conn_ids; do az network private-endpoint-connection approve --id "$fd_conn_id" --description "ApprovedByCli"; done; done'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    roleAssignment
  ]
}

@description('The logs of the deployment script that will be used to auto-approve the Private Endpoint Connection of the AFD.')
resource log 'Microsoft.Resources/deploymentScripts/logs@2023-08-01' existing = {
  parent: runAfdApproval
  name: 'default'
}

@description('The output of the deployment script that will be used to auto-approve the Private Endpoint Connection of the AFD.')
output logs string = log.properties.log
