@description('Required. Name of the Foundry account.')
param accountName string

@description('Required. Name of the Foundry project.')
param projectName string

@description('Required. Location for the Foundry account.')
param location string

resource scriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'id-script-purge-account-${accountName}'
  location: location
}

resource contributorRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
  scope: resourceGroup()
}

resource resourceGroupContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: resourceGroup()
  name: guid(scriptIdentity.id, contributorRole.id, resourceGroup().id)
  properties: {
    principalId: scriptIdentity.properties.principalId
    roleDefinitionId: contributorRole.id
    principalType: 'ServicePrincipal'
  }
}

#disable-next-line no-hardcoded-location
resource deleteAccountScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'script-purge-account-${accountName}'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${scriptIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '11.0'
    arguments: '-SubscriptionId \'${subscription().subscriptionId}\' -ResourceGroupName \'${resourceGroup().name}\' -CognitiveServiceAccountName \'${accountName}\' -ProjectName \'${projectName}\' -Location \'${location}\' -ArmEndpoint \'${environment().resourceManager}\''
    scriptContent: '''
    param(
      [Parameter(Mandatory = $true)]
      [string]$SubscriptionId,

      [Parameter(Mandatory = $true)]
      [string]$ResourceGroupName,

      [Parameter(Mandatory = $true)]
      [string]$CognitiveServiceAccountName,

      [Parameter(Mandatory = $true)]
      [string]$ProjectName,

      [Parameter(Mandatory = $true)]
      [string]$Location,

      [Parameter(Mandatory = $true)]
      [string]$ArmEndpoint,

      [Parameter(Mandatory = $false)]
      [string]$ApiVersion = "2025-06-01"
    )

    # Delete Cognitive Services project
    Invoke-AzRestMethod -Method DELETE -Uri "${ArmEndpoint}subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.CognitiveServices/accounts/$CognitiveServiceAccountName/projects/$ProjectName?api-version=$ApiVersion"

    # Delete Cognitive Services account
    Remove-AzCognitiveServicesAccount -ResourceGroupName $ResourceGroupName -Name $CognitiveServiceAccountName -Force

    # Purge deleted Cognitive Services account
    Invoke-AzRestMethod -Method DELETE -Uri "${ArmEndpoint}subscriptions/$SubscriptionId/providers/Microsoft.CognitiveServices/locations/$Location/resourceGroups/$ResourceGroupName/deletedAccounts/$CognitiveServiceAccountName?api-version=$ApiVersion"
    '''
    timeout: 'P1D'
    cleanupPreference: 'Always'
    retentionInterval: 'P1D'
  }
}
