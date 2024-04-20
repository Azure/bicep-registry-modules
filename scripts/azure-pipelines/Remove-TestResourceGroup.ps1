<#
.SYNOPSIS
  Removes a test resource group.
  
.DESCRIPTION
  This script attempts to remove a resource group. If the resource group cannot be removed, it will try cleaning up all the things
  that prevent removing resource groups, such as resource locks, backup protection, geo-pairing, etc. The source code is largely
  copied from https://github.com/Azure/azure-quickstart-templates/blob/master/test/ci-scripts/Kill-AzResourceGroup.ps1.
  
.PARAMETER ResourceGroupName
  The name of the resource group to remove.
#>
param(
  [string][Parameter(mandatory = $true)] $ResourceGroupName
)

Import-Module .\scripts\azure-pipelines\utils\AzurePipelinesUtils.psm1 -Force
Import-Module .\scripts\azure-pipelines\utils\AzureResourceUtils.psm1 -Force


Invoke-AzurePipelinesTask {
  Write-Host "Removing resource group:" $ResourceGroupName "..."

  # First, try removing and purging soft-delete enabled resources...
  Write-Host "Removing soft-delete enabled resources..." 

  Write-Host "Checking for Key vaults..." 
  Remove-AzKeyVaultInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Cognitive Services accounts..." 
  Remove-AzCognitiveServicesAccountInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for API Management services..." 
  Remove-AzApiManagementServiceInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Operational Insights workspaces..." 
  Remove-AzOperationalInsightsWorkspaceInResourceGroup -ResourceGroupName $ResourceGroupName

  # Try removing the resource group.
  if (Remove-AzResourceGroup -Name $ResourceGroupName -Force -Verbose -ErrorAction "SilentlyContinue") {
    exit
  }

  # Failed to remove the resource group - try cleaning up resources that can prevent removing resource groups.
  Write-Host "Failed to remove the resource group. Try cleaning up resources first..."

  Write-Host "Checking for resource locks..." 
  Remove-AzResourceLockInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Recovery Services vaults..." 
  Remove-AzRecoveryServicesVaultInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Backup vaults..." 
  Remove-AzDataProtectionBackupVaultInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Event Hubs Geo-disaster recovery configurations..." 
  Remove-AzEventHubGeoDRConfigurationInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Service Bus Hubs Geo-disaster recovery configurations and migrations..." 
  Remove-AzServiceBusGeoDRConfigurationAndMigrationInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Web App Swift Virtual Network connections..." 
  Remove-AzWebAppSwiftVnetConnectionInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Redis Cache geo-replication links..." 
  Remove-AzRedisCacheLinkInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Subnet delegations..." 
  Remove-AzSubnetDelegationInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Virtual Hub IP configurations..." 
  Remove-AzVirtualHubIPConfigurationInResourceGroup -ResourceGroupName $ResourceGroupName

  Write-Host "Checking for Private Endpoint connections..." 
  Remove-AzPrivateEndpointConnectionInResourceGroup -ResourceGroupName $ResourceGroupName

  # Finally...
  Write-Host "Removed resources preventing removing the resource group. Attempting to remove the resource group again..."
  Remove-AzResourceGroup -Force -Verbose -Name $ResourceGroupName
}
