@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Optional. Name of the Deployment Script that creates the SSH Public Key.')
param generateSshPubKeyScriptName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. Name of the temporary SSH Public Key to create for test.')
param sshKeyName string

@description('Optional. Do not provide a value. Used to force the deployment script to rerun on every redeployment.')
param utcValue string = utcNow()

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
    name: managedIdentityName
    location: location
}

// required for the deployment script to create a new temporary ssh public key object
resource msi_ContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid(resourceGroup().id, 'ManagedIdentityContributor', managedIdentityName)
    properties: {
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c') // Contributor
        principalId: managedIdentity.properties.principalId
        principalType: 'ServicePrincipal'
    }
}

resource createPubKeyScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: generateSshPubKeyScriptName
    location: location
    kind: 'AzurePowerShell'
    identity: {
        type: 'UserAssigned'
        userAssignedIdentities: {
            '${managedIdentity.id}': {}
        }
    }
    properties: {
        azPowerShellVersion: '8.0'
        retentionInterval: 'P1D'
        arguments: '-ResourceGroupName ${resourceGroup().name} -SSHKeyName ${sshKeyName}'
        scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')
        cleanupPreference: 'OnExpiration'
        forceUpdateTag: utcValue
    }
    dependsOn: [
        msi_ContributorRoleAssignment
    ]
}

@description('The public key to be added to the SSH Public Key resource.')
output publicKey string = createPubKeyScript.properties.outputs.publicKey

@description('The resource ID of the managed Identity')
output managedIdentityId string = managedIdentity.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
