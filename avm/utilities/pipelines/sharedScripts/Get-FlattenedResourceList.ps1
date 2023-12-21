<#
.SYNOPSIS
Flatten the (nested) resources of a given template file content

.DESCRIPTION
Flatten the (nested) resources of a given template file content. Keys are either the identifier in the template file, a concatenation of the parent and their child identifiers, or the identifier with a numbered suffix in case a nested template uses a different language version
For example:
- batchAccount_roleAssignments
- batchAccount_privateEndpoints.privateEndpoint_roleAssignments
- batchAccount_roleAssignments_0

This is a relevant differentiation as the language version changes based on whether newer features like user-defined types are implemented in the template.
As a consequence, the resources in the template are either defined in an array (language version 1) or an object (language version 2). This function supports both.

.PARAMETER TemplateFileContent
Optional. The template file content who's resources to extract

.PARAMETER Identifier
Optional. A parent identifier to prepend to a resource's identifier

.EXAMPLE
Get-FlattenedResourceList -TemplateFileContent $templateContent @{ resource = @{}; ... }

Extract all resources from the given template file content and return them as a flat hashtable
#>
function Get-FlattenedResourceList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $false)]
        [string] $Identifier
    )

    if ($TemplateFileContent.Keys -contains 'resources') {
        if ($TemplateFileContent.resources -is [array]) {
            # Language version 1
            $result = @()
            foreach ($resource in $TemplateFileContent.resources) {

                if ($resource.existing) {
                    continue
                }

                $result += $resource

                if ($resource.Keys -contains 'properties' -and $resource.properties.Keys -contains 'template') {
                    $template = $resource.properties.template
                    if ($template.resources.count -gt 0) {
                        $innerReturn = Get-FlattenedResourceList -TemplateFileContent $template
                        if ($innerReturn) {
                            if ($innerReturn -is [array] -or $innerReturn.Keys -contains 'apiVersion') {
                                # child uses language version 1
                                $result += $innerReturn
                            } else {
                                # child uses language version 2
                                $result += $innerReturn.values
                            }
                        }
                    }
                }
            }
        } else {
            # Language version 2
            $result = @{}
            if ($TemplateFileContent.resources.values.count -gt 1) {
                # if it's 1 then we're looking at a single resource that was already added
                $counter = 0 # Counter used for nested Language Version 1 resources that don't have an resource identifier
                foreach ($innerKey in $TemplateFileContent.resources.Keys) {

                    $resource = $TemplateFileContent.resources.$innerKey
                    if ($resource.existing) {
                        continue
                    }

                    # Collect the immediate defined resource(s)
                    $levelIdentifier = $Identifier ? "$Identifier.$innerKey" : $innerKey
                    $result[$levelIdentifier] = $resource

                    # Only investigate items that have an actual nested template (and are not just resource properties)
                    if ($resource.Keys -contains 'properties' -and $resource.properties.Keys -contains 'template') {
                        $template = $resource.properties.template
                        # But only if the nested template has resources
                        if ($template.resources.count -gt 0) {
                            $innerReturn = Get-FlattenedResourceList -TemplateFileContent $template -Identifier $innerKey
                            if ($innerReturn) {
                                if ($innerReturn.Keys -contains 'apiVersion') {
                                    # child uses language version 1
                                    $innerLevelIdentifier = '{0}_{1}' -f $levelIdentifier, $counter
                                    $result[$innerLevelIdentifier] = $innerReturn
                                    $counter++
                                } else {
                                    # child uses language version 2
                                    $result += $innerReturn
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return $result
}
