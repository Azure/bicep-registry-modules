<#
.SYNOPSIS
Get a list of all versioned module references in a given module path

.DESCRIPTION
Given a module path, this function returns a list of all modules under that path which are versioned.
A versioned module is a module having a version.json file in the same path of its main.bicep template. This is by default for all top level modules and for child modules selected for publiching.

.PARAMETER Path
Optional. The path to search in. Defaults to the 'root' folder.

.EXAMPLE
Get-VersionedModuleList -Path './sql'

Get only the references of the versioned modules (i.e. having a version.json file in their path) in folder path './sql'
#>
function Get-VersionedModuleList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent
    )

    $resultSet = @()

    # Collect data
    $versionJsonPaths = (Get-ChildItem -Path $path -Recurse -File -Filter 'version.json').FullName | Where-Object {
        # No files in the [/tools/] folder and none in the [/tests/] folder
        $_ -notmatch '.*[\\|\/]tools[\\|\/].*|.*[\\|\/]tests[\\|\/].*'
    } | Sort-Object -Culture 'en-US'

    # Process data
    foreach ($versionJsonPath in $versionJsonPaths) {
        $moduleFolderPath = Split-Path $versionJsonPath -Parent
        $resultSet += $moduleFolderPath
    }

    return $resultSet
}
