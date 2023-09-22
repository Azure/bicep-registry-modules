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

function Get-ReferenceObject {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $ModuleTemplateFilePath
    )

    $moduleContent = Get-Content -Path $ModuleTemplateFilePath

    $resourceReferences = $moduleContent | Where-Object { $_ -match "^resource .+ '(.+)' .+$" } | ForEach-Object { $matches[1] }
    $remoteReferences = $moduleContent | Where-Object { $_ -match "^module .+ '(.+:.+)' .+$" } | ForEach-Object { $matches[1] }

    return @{
        resourceReferences = @() + ($resourceReferences | Select-Object -Unique)
        remoteReferences   = @() + ($remoteReferences | Select-Object -Unique)
    }
}
#endregion

<#
.SYNOPSIS
Get a list of all resource/module references in a given module path

.DESCRIPTION
As an output you will receive a hashtable that (for each provider namespace) lists the
- Directly deployed resources (e.g. via "resource myDeployment 'Microsoft.(..)/(..)@(..)'")
- Linked remote module tempaltes (e.g. via "module rg 'br/modules:(..):(..)'")

.PARAMETER Path
Optional. The path to search in. Defaults to the 'res' folder.

.EXAMPLE
Get-CrossReferencedModuleList

Invoke the function with the default path. Returns an object such as:
{
    "Compute/availabilitySets": {
        "remoteReferences": [
            "avm-res-recoveryservice-vault-protectioncontainer-protecteditem",
            "avm-res-network-publicipaddress",
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

    $resultSet = [ordered]@{}

    $moduleTemplatePaths = (Get-ChildItem -Path $path -Recurse -File -Filter 'main.bicep').FullName
    foreach ($moduleTemplatePath in $moduleTemplatePaths) {

        $referenceObject = Get-ReferenceObject -ModuleTemplateFilePath $moduleTemplatePath

        # Add additional level of nesting for children of template path
        $childModuleTemplatePaths = (Get-ChildItem -Path $moduleTemplatePath -Recurse -File -Filter 'main.bicep').FullName | Where-Object { $_ -ne $moduleTemplatePath }
        foreach ($childModuleTemplatePath in $childModuleTemplatePaths) {
            $childReferenceObject = Get-ReferenceObject -ModuleTemplateFilePath $childModuleTemplatePath

            $referenceObject.resourceReferences = ($referenceObject.resourceReferences + $childReferenceObject.resourceReferences) | Select-Object -Unique
            $referenceObject.remoteReferences += ($referenceObject.remoteReferences + $childReferenceObject.remoteReferences) | Select-Object -Unique
        }

        $moduleFolderPath = Split-Path $moduleTemplatePath -Parent
        ## avm/res/<provider>/<resourceType>
        $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/'

        $providerNamespace = ($resourceTypeIdentifier -split '[\/|\\]')[0]
        $resourceType = $resourceTypeIdentifier -replace "$providerNamespace[\/|\\]", ''

        $resultSet["$providerNamespace/$resourceType"] = $referenceObject
    }

    return $resultSet
}
