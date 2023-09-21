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
Get a list of all resource/module references in a given module path

.DESCRIPTION
As an output you will receive a hashtable that (for each provider namespace) lists the
- Directly deployed resources (e.g. via "resource myDeployment 'Microsoft.(..)/(..)@(..)'")
- Linked local module templates (e.g. via "module myDeployment '../../main.bicep'")
- Linked remote module tempaltes (e.g. via "module rg 'br/modules:(..):(..)'")

.PARAMETER Path
Optional. The path to search in. Defaults to the 'res' folder.
Note, any local references will only be searched within this path too.

.EXAMPLE
Get-CrossReferencedModuleList

Invoke the function with the default path. Returns an object such as:
{
    "Compute/availabilitySets": {
        "localPathReferences": [
            recovery-service/vault/protection-container/protected-item
            network/public-ip-address
            network/network-interface
        ],
        "remoteReferences": null,
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
        [string] $Path = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'res')
    )

    $resultSet = [ordered]@{}

    # Get all top-level module folders (i.e. one level below the Resource Provider folder)
    $topLevelFolderPaths = (Get-ChildItem -Path $path -Depth 1 -Directory).FullName | Where-Object {
        $_ -notlike '*.shared*' -and # Ignore shared templates
        (($_ -split '[\\|\/]res[\\|\/]')[1] -split '[\\|/]').Count -eq 2 # From '/res/' only consider those which have 2 more path elements (i.e., are resource type folders)
    }

    foreach ($topLevelFolderPath in $topLevelFolderPaths) {

        $moduleTemplatePaths = (Get-ChildItem -Path $topLevelFolderPath -Recurse -Include '*.bicep' -File -Force).FullName | Where-Object {
            $_ -notmatch '.+[\/|\\]tests[\/|\\].+'
        }

        $resourceReferences = [System.Collections.ArrayList]@()
        $localPathReferences = [System.Collections.ArrayList]@()
        $remoteReferences = [System.Collections.ArrayList]@()

        foreach ($templatePath in $moduleTemplatePaths) {
            $content = Get-Content -Path $templatePath

            $resourceReferences += $content | Where-Object { $_ -match "^resource .+ '(.+)' .+$" } | ForEach-Object { $matches[1] }
            $localPathReferences += $content | Where-Object { $_ -match "^module .+ '(.+.bicep)' .+$" } | ForEach-Object { $matches[1] }
            $remoteReferences += $content | Where-Object { $_ -match "^module .+ '(.+:.+)' .+$" } | ForEach-Object { $matches[1] }
        }

        $providerNamespace = Split-Path (Split-Path $topLevelFolderPath -Parent) -Leaf
        $resourceType = Split-Path $topLevelFolderPath -Leaf

        $resultSet["$providerNamespace/$resourceType"] = @{
            resourceReferences  = $resourceReferences | Select-Object -Unique
            localPathReferences = $localPathReferences | Select-Object -Unique
            remoteReferences    = $remoteReferences | Select-Object -Unique
        }
    }

    # Expand local references recursively
    $localReferencesResultSet = [ordered]@{}
    foreach ($resourceType in ($resultSet.Keys | Sort-Object)) {
        $relevantLocalReferences = $resultSet[$resourceType].localPathReferences | Where-Object { $_ -match '^\.\..*$' } # e.g. '../
        if ($relevantLocalReferences) {
            $relevantLocalReferences = $relevantLocalReferences | ForEach-Object {
                # remove main.bicep
                Split-Path $_ -Parent
            } | ForEach-Object {
                # remove leading path elements
                ($_ -replace '\\', '/') -match '^[\.\/]*(.+)$'
            } | ForEach-Object {
                # We have to differentate the case that the referenced resources is inside or outside the same provider namespace (e.g. '../public-ip-address')
                if ($matches[1] -like '*/*') {
                    # Reference outside of namespace
                    $matches[1]
                }
                else {
                    # Reference inside of namespace (-> we rebuild the namespace)
                    '{0}/{1}' -f (Split-Path $resourceType -Parent), $matches[1]
                }
            }
            $localReferencesResultSet[$resourceType] = @() + $relevantLocalReferences
        }
    }

    # Add nested dependencies
    $resolvedlocalReferencesResultSet = @{}
    foreach ($resourceType in $localReferencesResultSet.Keys) {
        $resolvedDependencies = $localReferencesResultSet[$resourceType]
        foreach ($dependency in $localReferencesResultSet[$resourceType]) {
            $resolvedDependencies += Resolve-DependencyList -DependencyMap $localReferencesResultSet -ResourceType $resourceType
        }
        $resolvedlocalReferencesResultSet[$resourceType] = $resolvedDependencies | Select-Object -Unique
    }
    $localReferencesResultSet = $resolvedlocalReferencesResultSet

    foreach ($resourceType in ($resultSet.Keys | Sort-Object)) {
        $resultSet[$resourceType].localPathReferences = $resolvedlocalReferencesResultSet[$resourceType]
    }

    Write-Verbose "The modules in path [$path] have the following local folder dependencies:"
    foreach ($resourceType in $resolvedlocalReferencesResultSet.Keys) {
        Write-Verbose ''
        Write-Verbose "Resource: $resourceType"
        $resolvedlocalReferencesResultSet[$resourceType] | ForEach-Object {
            Write-Verbose "- $_"
        }
    }
    return $resultSet
}
