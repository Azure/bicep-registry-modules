#region helper functions
<#
.SYNOPSIS
Find any nested dependency recursively

.DESCRIPTION
Find any nested dependency recursively

.PARAMETER DependencyMap
Required. The map/dictionary/hashtable of dependencies to search in

.PARAMETER ResourceType
Required. The resource type to search any dependency for

.EXAMPLE
Resolve-DependencyList -DependencyMap @{ a = @('b','c'); b = @('d')} -ResourceType 'a'

Get an array of all dependencies of resource type 'a', as defined in the given DependencyMap. Would return @('b','c','d')
#>
function Resolve-DependencyList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [hashtable] $DependencyMap,

        [Parameter()]
        [string] $ResourceType
    )

    $resolvedDependencies = @()
    if ($DependencyMap.Keys -contains $ResourceType) {
        $resolvedDependencies = $DependencyMap[$ResourceType]
        foreach ($dependency in $DependencyMap[$ResourceType]) {
            $resolvedDependencies += Resolve-DependencyList -DependencyMap $DependencyMap -ResourceType $dependency
        }
    }

    $resolvedDependencies = $resolvedDependencies | Select-Object -Unique

    return $resolvedDependencies
}

<#
.SYNOPSIS
Get all references of a given module template

.DESCRIPTION
Get all references of a given module template.
This includes local references, online/remote references & resource deployments

.PARAMETER ModuleTemplateFilePath
Mandatory. The path to the template to search the references for

.PARAMETER TemplateMap
Mandatory. The hashtable of templatePath-templateContent to search in

.EXAMPLE
Get-ReferenceObject -ModuleTemplateFilePath 'C:\dev\key-vault\vault\main.bicep'

Search all references for module 'key-vault\vault'
#>
function Get-ReferenceObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleTemplateFilePath,

        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateMap
    )

    . (Join-Path (Get-Item $PSScriptRoot).Parent 'Get-LocallyReferencedFileList.ps1')
    $involvedFilePaths = Get-LocallyReferencedFileList -FilePath $ModuleTemplateFilePath -TemplateMap $TemplateMap

    $resultSet = @{
        resourceReferences  = @()
        remoteReferences    = @()
        localPathReferences = $involvedFilePaths | Where-Object {
            $involvedFilePath = $_
            # We only care about module templates
            (Split-Path $involvedFilePath -Leaf) -eq 'main.bicep' -and
            # We only care about a direct references and no children when it comes to returning local references
            (@(@($involvedFilePaths) + @($ModuleTemplateFilePath)) | Where-Object {
                (Split-Path $involvedFilePath) -match ('{0}[\/|\\].+' -f [Regex]::Escape((Split-Path $_ -Parent))) # i.e., if a path has its parent in the list, kick it out
            }).count -eq 0
        }
    }

    foreach ($involvedFilePath in (@($ModuleTemplateFilePath) + @($involvedFilePaths))) {
        $moduleContent = $TemplateMap[$involvedFilePath]

        $resultSet.resourceReferences += @() + $moduleContent | Where-Object { $_ -match "^resource .+ '(.+?)' .+$" } | ForEach-Object { $matches[1] }
        $resultSet.remoteReferences += @() + $moduleContent | Where-Object { $_ -match "^module .+ '(.+:.+?)' .+$" } | ForEach-Object { $matches[1] }
    }

    return @{
        resourceReferences  = $resultSet.resourceReferences | Sort-Object -Culture 'en-US' -Unique
        remoteReferences    = $resultSet.remoteReferences | Sort-Object -Culture 'en-US' -Unique
        localPathReferences = $resultSet.localPathReferences | Sort-Object -Culture 'en-US' -Unique
    }
}
#endregion

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
Get-CrossReferencedModuleList

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
Get-CrossReferencedModuleList -Path './sql'

Get only the references of the modules in folder path './sql'
#>
function Get-CrossReferencedModuleList {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $Path = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent
    )

    $repoRoot = ($Path -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[0]
    $resultSet = [ordered]@{}

    # Collect data
    $moduleTemplatePaths = (Get-ChildItem -Path $path -Recurse -File -Filter '*.bicep').FullName | Where-Object {
        # No files inthe [/utilities/tools/] folder and none in the [/tests/] folder
        $_ -notmatch '.*[\\|\/]tools[\\|\/].*|.*[\\|\/]tests[\\|\/].*'
    } | Sort-Object -Culture 'en-US'
    $templateMap = @{}
    foreach ($moduleTemplatePath in $moduleTemplatePaths) {
        $templateMap[$moduleTemplatePath] = Get-Content -Path $moduleTemplatePath
    }

    # Process data
    foreach ($moduleTemplatePath in $moduleTemplatePaths) {

        $referenceObject = Get-ReferenceObject -ModuleTemplateFilePath $moduleTemplatePath -TemplateMap $templateMap

        # Convert local absolute references to relative references
        $referenceObject.localPathReferences = $referenceObject.localPathReferences | ForEach-Object {
            $result = $_ -replace ('{0}[\/|\\]' -f [Regex]::Escape($repoRoot)), '' # Remove root
            $result = Split-Path $result -Parent # Use only folder name
            $result = $result -replace '\\', '/' # Replaces slashes
            return $result
        }

        $moduleFolderPath = Split-Path $moduleTemplatePath -Parent
        ## avm/res/<provider>/<resourceType>
        $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')[2] -replace '\\', '/'

        $providerNamespace = ($resourceTypeIdentifier -split '[\/|\\]')[0]
        $resourceType = $resourceTypeIdentifier -replace "$providerNamespace[\/|\\]", ''

        $resultSet["$providerNamespace/$resourceType"] = $referenceObject
    }

    return $resultSet
}
