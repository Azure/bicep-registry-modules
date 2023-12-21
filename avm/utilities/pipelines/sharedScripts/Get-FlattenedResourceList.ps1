<#
.SYNOPSIS
Flatten the (nested) resources of a given template file content

.DESCRIPTION
Flatten the (nested) resources of a given template file content. Keys are either the identifier in the template file or a concatenation of the parent and their child identifiers
For example:
- batchAccount_roleAssignments
- batchAccount_privateEndpoints.privateEndpoint_roleAssignments

.PARAMETER TemplateFileContent
Optional. The template file content who's resources to extract

.PARAMETER Identifier
Optional. A parent identifier to prepend to a resource's identifier

.EXAMPLE
Get-FlattenedResourceList -TemplateFileContent $templateContent @{ resource = @{}; ... }
Extract all resources from the given template file content and return them as a flat hashtable

.NOTES
This only works if the template uses language version 2 (i.e., resources are defined in an object instead of an array)
#>
function Get-FlattenedResourceList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $false)]
        [string] $Identifier
    )

    $result = @{}

    if ($TemplateFileContent.Keys -contains 'resources') {
        # Collect the immediate defined resource(s)
        if ($TemplateFileContent.resources.count -gt 1) {
            $TemplateFileContent.resources.Keys | ForEach-Object {
                $levelIdentifier = $Identifier ? "$Identifier.$_" : $_
                $result[$levelIdentifier] = $TemplateFileContent.resources.$_
            }
        }

        foreach ($innerKey in $TemplateFileContent['resources'].Keys) {
            # Only investigate items that have an actual nested template (and are not just resource properties)
            if ($TemplateFileContent['resources'][$innerKey].Keys -contains 'properties' -and $TemplateFileContent['resources'][$innerKey].properties.Keys -contains 'template') {
                $template = $TemplateFileContent['resources'][$innerKey].properties.template
                # But only if the nested template has resources
                if ($template.resources.count -gt 0) {
                    $result += Get-FlattenedResourceList -TemplateFileContent $template -Identifier $innerKey
                }
            }
        }
    }
}