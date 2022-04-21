<#
.SYNOPSIS
  Creates a test resource group.
  
.DESCRIPTION
  The script creates a resource group and grants a service principal access to that resource group for deploying the test Bicep file.

.PARAMETER PrincipalId
  The service principal ID (object ID).

.PARAMETER Location
  The Location of the test resource group to create. Defaults to "westus".
#>
Param(
  [Parameter(mandatory = $true)]
  [string]$PrincipalId,

  [string]$Location = "westus"
)

Import-Module .\scripts\azure-pipelines\utils\AzurePipelinesUtils.psm1 -Force
Import-Module .\scripts\azure-pipelines\utils\AzureResourceUtils.psm1 -Force

Invoke-AzurePipelinesTask {
  $pullRequestNumber = $env:SYSTEM_PULLREQUEST_PULLREQUESTNUMBER
  $commitId = $env:BUILD_SOURCEVERSION.Substring(0, 7)
  $timestamp = Get-Date -Format "yyyyMMddHHmmss" -AsUTC
  $guid = [GUID]::NewGuid().ToString('N')
  $resourceGroupName = "$pullRequestNumber-$commitId-$timestamp-$guid"
  
  # Create the resource group and wait for replication.
  New-AzResourceGroup -Name $resourceGroupName -Location $Location -Verbose
  Wait-Replication { (Get-AzResourceGroup -Name $resourceGroupName -Verbose -ErrorAction "SilentlyContinue") -ne $null }
  Set-AzurePipelinesVariable -VariableName "ResourceGroupName" -VariableValue $resourceGroupName
  
  Write-Host "Granting service principal $PrincipalId access to resource group $resourceGroupName..."

  # Can only use -ObjectId instead of -ApplicationId because the connected service principal doesn't have AAD read permision.
  $roleAssignment = New-AzRoleAssignment -ResourceGroupName $resourceGroupName -ObjectId $PrincipalId -RoleDefinitionName "Owner"
  $roleAssignmentPath = "$($roleAssignment.RoleAssignmentId)?api-version=2021-04-01-preview"
  
  # Sometimes it takes a while for an RBAC change to propagate. Calling Wait-Replication to ensure
  # 6 succesive successful GET operations on the role assignment to reduce the chance of getting
  # RBAC errors later due to slow replication.
  Wait-Replication {
    $getResult = Invoke-AzRestMethod -Method "GET" -Path $roleAssignmentPath
    Write-Host $getResult.StatusCode "GET" $roleAssignmentPath

    $getResult.StatusCode -eq 200
  } -SuccessCount 6 -DelayInSeconds 4
}
