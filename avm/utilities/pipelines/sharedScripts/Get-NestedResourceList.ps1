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
        $currLevelResources += $TemplateFileContent.resources
    }
    foreach ($resource in $currLevelResources) {
        $res += $resource

        if ($resource.type -eq 'Microsoft.Resources/deployments') {
            $res += Get-NestedResourceList -TemplateFileContent $resource.properties.template
        } else {
            $res += Get-NestedResourceList -TemplateFileContent $resource
        }
    }
    return $res
}
