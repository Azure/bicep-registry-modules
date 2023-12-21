@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Deployment Script to create to get the paired region name.')
param pairedRegionScriptName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
    name: managedIdentityName
    location: location
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid('msi-${location}-${managedIdentity.id}-Reader-RoleAssignment')
    properties: {
        principalId: managedIdentity.properties.principalId
        roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7') // Reader
        principalType: 'ServicePrincipal'
    }
}

resource getPairedRegionScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
    name: pairedRegionScriptName
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
        arguments: '-Location \\"${location}\\"'
        scriptContent: loadTextContent('../../../../../.shared/.scripts/Get-PairedRegion.ps1')
    }
    dependsOn: [
        roleAssignment
    ]
}

@description('The name of the paired region.')
output pairedRegionName string = getPairedRegionScript.properties.outputs.pairedRegionName
