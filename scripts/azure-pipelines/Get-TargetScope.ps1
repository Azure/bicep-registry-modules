<#
.SYNOPSIS
  Gets the target scope of the module.
  
.DESCRIPTION
  The script gets the target scope of the main module file.

.PARAMETER ChangedModuleDirectory
  The directory of the changed module.
#>
param(
  [Parameter(mandatory = $True)]
  [string]$ChangedModuleDirectory
)

Import-Module .\scripts\azure-pipelines\utils\AzurePipelinesUtils.psm1 -Force

$armTemplateFilePath = Join-Path $ChangedModuleDirectory -ChildPath "main.json"
$targetScope = ""

if (Test-Path $armTemplateFilePath -PathType "Leaf") {
  $armTemplateFile = Get-Content -Raw -Path $armTemplateFilePath | ConvertFrom-Json
  $armTemplateSchema = $armTemplateFile.'$schema'
  $armTemplateSchemaPattern = "https?://schema\.management\.azure\.com/schemas/[0-9a-zA-Z-]+/{0}Template\.json#?"
  
  $targetScope = switch -Regex ($armTemplateSchema) {
    $($armTemplateSchemaPattern -f "deployment") { "resourceGroup" }
    $($armTemplateSchemaPattern -f "subscriptionDeployment") { "subscription" }
    $($armTemplateSchemaPattern -f "managementGroupDeployment") { "managementGroup" }
    $($armTemplateSchemaPattern -f "tenantDeployment") { "tenant" }
    default { "" }
  }
}

Set-AzurePipelinesVariable -VariableName "TargetScope" -VariableValue $targetScope
