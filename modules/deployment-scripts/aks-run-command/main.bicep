@description('The name of the Azure Kubernetes Service')
param aksName string

@description('The location to deploy the resources to')
param location string = resourceGroup().location

@description('How the deployment script should be forced to execute')
param forceUpdateTag  string = utcNow()

@description('An array of Azure RoleIds that are required for the DeploymentScript resource')
param rbacRolesNeeded array = [
  'b24988ac-6180-42a0-ab88-20f7382dd24c' //Contributor
  '7f6c6a51-bcf8-42ba-9220-52d62157d7db' //Azure Kubernetes Service RBAC Reader
]

@description('Does the Managed Identity already exists, or should be created')
param useExistingManagedIdentity bool = false

@description('Name of the Managed Identity resource')
param managedIdentityName string = 'id-AksRunCommandProxy'

@description('For an existing Managed Identity, the Subscription Id it is located in')
param existingManagedIdentitySubId string = subscription().subscriptionId

@description('For an existing Managed Identity, the Resource Group it is located in')
param existingManagedIdentityResourceGroupName string = resourceGroup().name

@description('An array of commands to run')
param commands array

@description('A delay before the script import operation starts. Primarily to allow Azure AAD Role Assignments to propagate')
param initialScriptDelay string = '120s'

@allowed([
  'OnSuccess'
  'OnExpiration'
  'Always'
])
@description('When the script resource is cleaned up')
param cleanupPreference string = 'OnSuccess'

resource aks 'Microsoft.ContainerService/managedClusters@2022-09-01' existing = {
  name: aksName
}

resource newDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = if (!useExistingManagedIdentity) {
  name: managedIdentityName
  location: location
}

resource existingDepScriptId 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = if (useExistingManagedIdentity ) {
  name: managedIdentityName
  scope: resourceGroup(existingManagedIdentitySubId, existingManagedIdentityResourceGroupName)
}

resource rbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for roleDefId in rbacRolesNeeded: {
  name: guid(aks.id, roleDefId, useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id)
  scope: aks
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefId)
    principalId: useExistingManagedIdentity ? existingDepScriptId.properties.principalId : newDepScriptId.properties.principalId
    principalType: 'ServicePrincipal'
  }
}]

@batchSize(1)
resource runAksCommand 'Microsoft.Resources/deploymentScripts@2020-10-01' = [for (command, i) in commands: {
  name: 'AKS-Run-${aks.name}-${deployment().name}-${i}'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${useExistingManagedIdentity ? existingDepScriptId.id : newDepScriptId.id}': {}
    }
  }
  kind: 'AzureCLI'
  dependsOn: [
    rbac
  ]
  properties: {
    forceUpdateTag: forceUpdateTag
    azCliVersion: '2.35.0'
    timeout: 'PT10M'
    retentionInterval: 'P1D'
    environmentVariables: [
      {
        name: 'RG'
        value: resourceGroup().name
      }
      {
        name: 'aksName'
        value: aksName
      }
      {
        name: 'command'
        value: command
      }
      {
        name: 'initialDelay'
        value: initialScriptDelay
      }
      {
        name: 'loopIndex'
        value: string(i)
      }
    ]
    scriptContent: '''
      #!/bin/bash
      set -e

      if [ "$loopIndex" == "0" ] && [ "$initialDelay" != "0" ]
      then
        echo "Waiting on RBAC replication ($initialDelay)"
        sleep $initialDelay

        #Force RBAC refresh
        az logout
        az login --identity
      fi

      echo "Sending command $command to AKS Cluster $aksName in $RG"
      cmdOut=$(az aks command invoke -g $RG -n $aksName -o json --command "${command}")
      echo $cmdOut

      jsonOutputString=$cmdOut
      echo $jsonOutputString > $AZ_SCRIPTS_OUTPUT_PATH
    '''
    cleanupPreference: cleanupPreference
  }
}]

@description('Array of command output from each Deployment Script AKS run command')
output commandOutput array = [for (command, i) in commands: {
  Index: i
  Name: runAksCommand[i].name
  CommandOutput: runAksCommand[i].properties.outputs
}]
