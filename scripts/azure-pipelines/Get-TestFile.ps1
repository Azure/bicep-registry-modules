<#
.SYNOPSIS
  Gets the module test file.
  
.DESCRIPTION
  The script gets path to the test file in the directory of the changed module.

.PARAMETER ChangedModuleDirectory
  The directory of the changed module.
#>
param(
  [Parameter(mandatory = $True)]
  [string]$ChangedModuleDirectory
)

$testFilePath = Join-Path $ChangedModuleDirectory -ChildPath "test\main.test.bicep"
$testFilePath = if (Test-Path $testFilePath -PathType "Leaf") { $testFilePath } else { "" }

Set-AzurePipelinesVariable -VariableName "TestFilePath" -VariableValue $testFilePath
