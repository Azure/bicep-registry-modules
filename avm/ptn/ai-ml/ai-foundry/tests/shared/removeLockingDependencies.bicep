@description('Required. Name of the Foundry account.')
param accountName string

@description('Required. Name of the Foundry project.')
param projectName string

@description('Required. Location for the Foundry account.')
param location string

#disable-next-line no-hardcoded-location
resource deleteAccountScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'script-purge-account-${accountName}'
  location: location
  kind: 'AzurePowerShell'
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
