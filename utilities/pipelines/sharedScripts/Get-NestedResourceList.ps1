<#
.SYNOPSIS
Get a list of all resources (provider + service) in the given template content

.DESCRIPTION
Get a list of all resources (provider + service) in the given template content. Crawls through any children & nested deployment templates.

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.EXAMPLE
Get-NestedResourceList -TemplateFileContent @{ resource = @{}; ... }

Returns a list of all resources in the given template object
#>
function Get-NestedResourceList {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [Alias('Path')]
        [hashtable] $TemplateFileContent
    )

    $res = @()
    $currLevelResources = @()

    if ($TemplateFileContent.resources) {
        if ($TemplateFileContent.resources -is [System.Collections.Hashtable]) {
            # With the introduction of user defined types, a compiled template's resources are not part of an ordered hashtable instead of an array.
            $currLevelResources += $TemplateFileContent.resources.Keys | ForEach-Object {
                $elem = $TemplateFileContent.resources[$_]
                $elem['identifier'] = $_
                $elem
            } | Where-Object {
                $_.existing -ne $true
            }
        } else {
            # Default array
            $currLevelResources += $TemplateFileContent.resources | ForEach-Object {
                $_['identifier'] = $_.name
                $_
            } | Where-Object {
                $_.existing -ne $true
            }
        }
    }
    foreach ($resource in $currLevelResources) {
        $res += $resource

        if ($resource.type -eq 'Microsoft.Resources/deployments') {
            if ($resource.properties.template -is [System.Collections.Hashtable]) {
                $res += Get-NestedResourceList -TemplateFileContent $resource.properties.template
            }
        } else {
            $res += Get-NestedResourceList -TemplateFileContent $resource
        }
    }
    return $res
}
