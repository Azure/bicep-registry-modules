<#
.SYNOPSIS
Get a list of all resource/module references in a given module path

.DESCRIPTION
As an output you will receive a hashtable that (for each provider namespace) lists the
- Directly deployed resources (e.g. via "resource myDeployment 'Microsoft.(..)/(..)@(..)'")
- Linked remote module templates (e.g. via "module rg 'br/modules:(..):(..)'")

.PARAMETER Path
Optional. The path to search in. Defaults to the 'res' folder.

.EXAMPLE
Get-VersionedModuleList

Invoke the function with the default path. Returns an object such as:
{
    "Compute/availabilitySets": {
        "remoteReferences": [
            "avm-res-network-networkinterface"
        ],
        "resourceReferences": [
            "Microsoft.Resources/deployments@2021-04-01",
            "Microsoft.Compute/availabilitySets@2021-07-01",
            "Microsoft.Authorization/locks@2020-05-01",
            "Microsoft.Compute/availabilitySets@2021-04-01",
            "Microsoft.Authorization/roleAssignments@2020-10-01-preview"
        ]
    },
    (...)
}

.EXAMPLE
Get-VersionedModuleList -Path './sql'

Get only the references of the modules in folder path './sql'
#>
function Get-VersionedModuleList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent
    )

    $repoRoot = ($Path -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[0]
    $resultSet = @()

    # Collect data
    $versionJsonPaths = (Get-ChildItem -Path $path -Recurse -File -Filter 'version.json').FullName | Where-Object {
        # No files inthe [/utilities/tools/] folder and none in the [/tests/] folder
        $_ -notmatch '.*[\\|\/]tools[\\|\/].*|.*[\\|\/]tests[\\|\/].*'
    } | Sort-Object -Culture 'en-US'

    # Process data

    foreach ($versionJsonPath in $versionJsonPaths) {

        # $referenceObject = Get-ReferenceObject -ModuleTemplateFilePath $moduleTemplatePath -TemplateMap $templateMap

        # # Convert local absolute references to relative references
        # $referenceObject.localPathReferences = $referenceObject.localPathReferences | ForEach-Object {
        #     $result = $_ -replace ('{0}[\/|\\]' -f [Regex]::Escape($repoRoot)), '' # Remove root
        #     $result = Split-Path $result -Parent # Use only folder name
        #     $result = $result -replace '\\', '/' # Replaces slashes
        #     return $result
        # }

        $moduleFolderPath = Split-Path $versionJsonPath -Parent
        # $moduleFolderRelativePath = ($moduleFolderPath -replace ('{0}[\/|\\]' -f [Regex]::Escape($repoRoot)), '') -replace '\\', '/' # Replaces slashes # Remove root
        ## avm/res/<provider>/<resourceType>
        # $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[2] -replace '\\', '/'

        # since the moduleTemplatePath can contain folders outside of modules, skip those
        # if ($resourceTypeIdentifier -ne '') {
        # $providerNamespace = ($resourceTypeIdentifier -split '[\/|\\]')[0]
        # $resourceType = $resourceTypeIdentifier.Substring($providerNamespace.Length + 1)

        # $resultSet += $moduleFolderRelativePath
        $resultSet += $moduleFolderPath
        # }
    }

    return $resultSet
}
