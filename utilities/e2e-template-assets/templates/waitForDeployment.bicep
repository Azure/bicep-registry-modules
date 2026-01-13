// .TEMPLATE:
// ----------
// waitForDeployment.bicep
//
// .DESCRIPTION
// -----------
// This template deploys a deployment script that waits for a specified resource to finish deploying
// by periodically checking its provisioning state. This can be useful as the provisioning state can sometimes
// report as 'Succeeded' before the resources are fully operational.
//
// .PARAMETERS
// -----------
// - waitForResourceId: The Resource ID of the resource to wait for deployment completion.
// - managedIdentityName: The name of the managed identity to create for the deployment script.
// - deploymentScriptName: The name of the deployment script resource.
// - location: The location where the resources will be deployed.
// - maxRetries: The maximum retries when waiting for the resource deployment to complete.
// - waitIntervalInSeconds: The interval between checks for resource deployment status, in seconds.
//
// .EXAMPLE
// --------
// module waitForDeployment '../../../../../../../utilities/e2e-template-assets/templates/waitForDeployment.bicep' = {
//   scope: resourceGroup
//   params: {
//     waitForResourceId: testDeployment[0].outputs.resourceId
//     managedIdentityName: '${namePrefix}-mi-${serviceShort}'
//     deploymentScriptName: '${namePrefix}-ds-${serviceShort}'
//   }
// }

@description('Required. The Resource ID of the resource to wait for deployment completion.')
param waitForResourceId string

@description('Optional. The name of the managed identity to create for the deployment script.')
param managedIdentityName string = 'waitForDeploymentMsi'

@description('Optional. The name of the deployment script resource.')
param deploymentScriptName string = 'waitForDeploymentScript'

@description('Optional. The location where the resources will be deployed.')
param location string = resourceGroup().location

@description('Optional. The maximum retries when waiting for the resource deployment to complete.')
param maxRetries int = 60

@description('Optional. The interval between checks for resource deployment status, in seconds.')
param waitIntervalInSeconds int = 30

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

// Required role assignment to allow the deployment script to read resource status
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, msi.id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    principalId: msi.properties.principalId
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'b24988ac-6180-42a0-ab88-20f7382dd24c'
    ) // Contributor role
    principalType: 'ServicePrincipal'
  }
}

resource waitForDeploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: deploymentScriptName
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msi.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    retentionInterval: 'PT1H'
    arguments: '-ResourceId "${waitForResourceId}" -MaxRetries "${maxRetries}" -WaitIntervalInSeconds "${waitIntervalInSeconds}"'
    scriptContent: loadTextContent('../scripts/Wait-ForResourceDeployment.ps1')
  }
}
