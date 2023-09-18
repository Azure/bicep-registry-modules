<#
.SYNOPSIS
Get the relative file paths of all test files in the given module.

.DESCRIPTION
Get the relative file paths of all test files (*.json / main.test.bicep) in the given module.
The relative path is returned instead of the full one to make paths easier to read in the pipeline.

.PARAMETER ModulePath
Mandatory. The module path to search in.

.PARAMETER SearchFolder
Optional. The folder to search for files in

.PARAMETER TestFilePattern
Optional. The pattern of test files to search for. For example '*.json'

.EXAMPLE
Get-ModuleTestFileList -ModulePath 'C:\ResourceModules\modules\compute\virtual-machine'

Returns the relative file paths of all test files of the virtual-machine module in the default test folder ('.test').

.EXAMPLE
Get-ModuleTestFileList -ModulePath 'C:\ResourceModules\modules\compute\virtual-machine' -SearchFolder 'parameters'

Returns the relative file paths of all test files of the virtual-machine module in folder 'parameters'.
#>
function Get-ModuleTestFileList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath,

        [Parameter(Mandatory = $false)]
        [string] $SearchFolder = '.test',

        [Parameter(Mandatory = $false)]
        [string[]] $TestFilePattern = @('*.json', 'main.test.bicep')
    )

    $deploymentTests = @()
    if (Test-Path (Join-Path $ModulePath $SearchFolder)) {
        $deploymentTests += (Get-ChildItem -Path (Join-Path $ModulePath $SearchFolder) -Recurse -Include $TestFilePattern -File).FullName | Where-Object {
            $_ -ne (Join-Path (Join-Path $ModulePath $SearchFolder) 'main.test.bicep') # Excluding PBR test file
        }
    }

    if (-not $deploymentTests) {
        throw "No deployment test files found for module [$ModulePath]"
    }

    $deploymentTests = $deploymentTests | ForEach-Object {
        $_.Replace($ModulePath, '').Trim('\').Trim('/')
    }

    Write-Verbose 'Found parameter files'
    $deploymentTests | ForEach-Object { Write-Verbose "- $_" }

    return $deploymentTests
}
