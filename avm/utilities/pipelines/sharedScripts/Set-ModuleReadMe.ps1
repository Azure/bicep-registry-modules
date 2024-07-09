#requires -version 7.3

#region helper functions
<#
.SYNOPSIS
Test if an URL points to a valid online endpoint

.DESCRIPTION
Test if an URL points to a valid online endpoint

.PARAMETER URL
Mandatory. The URL to check

.PARAMETER Retries
Optional. The amount of times to retry

.EXAMPLE
Test-URl -URL 'www.github.com'

Returns $true if the 'www.github.com' is valid, $false otherwise
#>
function Test-Url {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $URL,

        [Parameter(Mandatory = $false)]
        [int] $Retries = 3
    )

    $currentAttempt = 1

    while ($currentAttempt -le $Retries) {
        try {
            $null = Invoke-WebRequest -Uri $URL
            return $true
        } catch {
            $currentAttempt++
            Start-Sleep -Seconds 1
        }
    }

    return $false
}

<#
.SYNOPSIS
Update the 'Resource Types' section of the given readme file

.DESCRIPTION
Update the 'Resource Types' section of the given readme file

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Resource Types'

.PARAMETER ResourceTypesToExclude
Optional. The resource types to exclude from the list. By default excludes 'Microsoft.Resources/deployments'

.EXAMPLE
Set-ResourceTypesSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Resource Types' section based on the given template file content
#>
function Set-ResourceTypesSection {

    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'ResourceTypesToExclude', Justification = 'Variable used inside Where-Object block.')]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Resource Types',

        [Parameter(Mandatory = $false)]
        [string[]] $ResourceTypesToExclude = @('Microsoft.Resources/deployments')
    )

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        '| Resource Type | API Version |',
        '| :-- | :-- |'
    )

    $RelevantResourceTypeObjects = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $ResourceTypesToExclude -and $_
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object -Culture 'en-US' -Property 'Type'

    $ProgressPreference = 'SilentlyContinue'
    $VerbosePreference = 'SilentlyContinue'
    foreach ($resourceTypeObject in $RelevantResourceTypeObjects) {
        $ProviderNamespace, $ResourceType = $resourceTypeObject.Type -split '/', 2
        # Validate if Reference URL is working
        $TemplatesBaseUrl = 'https://learn.microsoft.com/en-us/azure/templates'

        $ResourceReferenceUrl = '{0}/{1}/{2}/{3}' -f $TemplatesBaseUrl, $ProviderNamespace, $resourceTypeObject.ApiVersion, $ResourceType
        if (-not (Test-Url $ResourceReferenceUrl)) {
            # Validate if Reference URL is working using the latest documented API version (with no API version in the URL)
            $ResourceReferenceUrl = '{0}/{1}/{2}' -f $TemplatesBaseUrl, $ProviderNamespace, $ResourceType
        }
        if (-not (Test-Url $ResourceReferenceUrl)) {
            # Check if the resource is a child resource
            if ($ResourceType.Split('/').length -gt 1) {
                $ResourceReferenceUrl = '{0}/{1}/{2}' -f $TemplatesBaseUrl, $ProviderNamespace, $ResourceType.Split('/')[0]
            } else {
                # Use the default Templates URL (Last resort)
                $ResourceReferenceUrl = '{0}' -f $TemplatesBaseUrl
            }
        }

        $SectionContent += ('| `{0}` | [{1}]({2}) |' -f $resourceTypeObject.type, $resourceTypeObject.apiVersion, $ResourceReferenceUrl)
    }
    $ProgressPreference = 'Continue'
    $VerbosePreference = 'Continue'

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new resource type content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'nextH2'
    }
    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'parameters' section of the given readme file

.DESCRIPTION
Update the 'parameters' section of the given readme file

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER currentFolderPath
Mandatory. The current folder path

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Parameters'

.PARAMETER ColumnsInOrder
Optional. The order of parameter categories to show in the readme parameters section.

.EXAMPLE
Set-ParametersSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Parameters' section based on the given template file content
#>
function Set-ParametersSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory)]
        [string] $currentFolderPath,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Parameters',

        [Parameter(Mandatory = $false)]
        [string[]] $ColumnsInOrder = @('Required', 'Conditional', 'Optional', 'Generated')
    )

    # Invoking recursive function to resolve parameters
    $newSectionContent = Set-DefinitionSection -TemplateFileContent $TemplateFileContent -ColumnsInOrder $ColumnsInOrder

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'nextH2'
    }

    return $updatedFileContent
}

<#
.SYNOPSIS
Update parts of the 'parameters' section of the given readme file, if user defined types are used

.DESCRIPTION
Adds user defined types to the 'parameters' section of the given readme file

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER Properties
Optional. Hashtable of the user defined properties

.PARAMETER ParentName
Optional. Name of the parameter, that has the user defined types

.PARAMETER ParentIdentifierLink
Optional. Link of the parameter, that has the user defined types

.PARAMETER ColumnsInOrder
Optional. The order of parameter categories to show in the readme parameters section.

.EXAMPLE
Set-DefinitionSection -TemplateFileContent @{ resource = @{}; ... } -ColumnsInOrder @('Required', 'Optional')

Top-level invocation. Will start from the TemplateFile's parameters object and recursively crawl through all children. Tables will be ordered by 'Required' first and 'Optional' after.

.EXAMPLE
Set-DefinitionSection -TemplateFileContent @{ resource = @{}; ... } -Properties @{ @{ name = @{ type = 'string'; 'allowedValues' = @('A1','A2','A3','A4','A5','A6'); 'nullable' = $true; (...) } -ParentName 'diagnosticSettings' -ParentIdentifierLink '#parameter-diagnosticsettings'

Child-level invocation during recursion.

.NOTES
The function is recursive and will also output grand, great grand children, ... .
#>
function Set-DefinitionSection {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $false)]
        [hashtable] $Properties,

        [Parameter(Mandatory = $false)]
        [string] $ParentName,

        [Parameter(Mandatory = $false)]
        [string] $ParentIdentifierLink,

        [Parameter(Mandatory = $false)]
        [string[]] $ColumnsInOrder = @('Required', 'Conditional', 'Optional', 'Generated')
    )

    if (-not $Properties) {
        # Top-level invocation
        # Get all descriptions
        $descriptions = $TemplateFileContent.parameters.Values.metadata.description
        # Add name as property for later reference
        $TemplateFileContent.parameters.Keys | ForEach-Object { $TemplateFileContent.parameters[$_]['name'] = $_ }

        # Error handling: Throw error if any parameter is missing a category
        if ($paramsWithoutCategory = $TemplateFileContent.parameters.Values | Where-Object { $_.metadata.description -notmatch '^\w+?\.' }) {
            $formattedParam = $paramsWithoutCategory | ForEach-Object { [PSCustomObject]@{ name = $_.name; description = $_.metadata.description } } | ConvertTo-Json -Compress
            Write-Error ("Each parameter description should start with a category like [Required. / Optional. / Conditional. ]. The following parameters are missing such a category: `n$formattedParam`n")
        }
    } else {
        $descriptions = $Properties.Values.metadata.description
        # Add name as property for later reference
        $Properties.Keys | ForEach-Object { $Properties[$_]['name'] = $_ }

        # Error handling: Throw error if any parameter is missing a category
        if ($paramsWithoutCategory = $Properties.Values | Where-Object { $_.metadata.description -notmatch '^\w+?\.' }) {
            $formattedParam = $paramsWithoutCategory | ForEach-Object { [PSCustomObject]@{ name = $_.name; description = $_.metadata.description } } | ConvertTo-Json -Compress
            Write-Error ("Each parameter description should start with a category like [Required. / Optional. / Conditional. ]. The following parameters are missing such a category: `n$formattedParam`n")
        }
    }

    # Get the module parameter categories
    $paramCategories = $descriptions | ForEach-Object { $_.Split('.')[0] } | Select-Object -Unique

    # Sort categories
    $sortedParamCategories = $ColumnsInOrder | Where-Object { $paramCategories -contains $_ }
    # Add all others that exist but are not specified in the columnsInOrder parameter
    $sortedParamCategories += $paramCategories | Where-Object { $ColumnsInOrder -notcontains $_ }
    $newSectionContent = [System.Collections.ArrayList]@()
    $tableSectionContent = [System.Collections.ArrayList]@()
    $listSectionContent = [System.Collections.ArrayList]@()

    foreach ($category in $sortedParamCategories) {

        # 1. Prepare
        # Filter to relevant items
        if (-not $Properties) {
            # Top-level invocation
            [array] $categoryParameters = $TemplateFileContent.parameters.Values | Where-Object { $_.metadata.description -like "$category. *" } | Sort-Object -Culture 'en-US' -Property 'Name'
        } else {
            $categoryParameters = $Properties.Values | Where-Object { $_.metadata.description -like "$category. *" } | Sort-Object -Culture 'en-US' -Property 'Name'
        }

        $tableSectionContent += @(
            ('**{0} parameters**' -f $category),
            '',
            '| Parameter | Type | Description |',
            '| :-- | :-- | :-- |'
        )

        foreach ($parameter in $categoryParameters) {

            ######################
            #   Gather details   #
            ######################

            $paramIdentifier = (-not [String]::IsNullOrEmpty($ParentName)) ? '{0}.{1}' -f $ParentName, $parameter.name : $parameter.name
            $paramHeader = '### Parameter: `{0}`' -f $paramIdentifier
            $paramIdentifierLink = (-not [String]::IsNullOrEmpty($ParentIdentifierLink)) ? ('{0}{1}' -f $ParentIdentifierLink, $parameter.name).ToLower() :  ('#{0}' -f $paramHeader.TrimStart('#').Trim().ToLower()) -replace '[:|`]' -replace ' ', '-'

            # definition type (if any)
            if ($parameter.Keys -contains '$ref') {
                $identifier = Split-Path $parameter.'$ref' -Leaf
                $definition = $TemplateFileContent.definitions[$identifier]
                $type = $definition['type']
                $rawAllowedValues = $definition['allowedValues']
            } elseif ($parameter.Keys -contains 'items' -and $parameter.items.type -in @('object', 'array') -or $parameter.type -eq 'object') {
                # Array has nested non-primitive type (array/object) - and if array, the the UDT itself is declared as the array
                $definition = $parameter
                $type = $parameter.type
                $rawAllowedValues = $parameter.allowedValues
            } elseif ($parameter.Keys -contains 'items' -and $parameter.items.keys -contains '$ref') {
                # Array has nested non-primitive type (array) - and the parameter is defined as an array of the UDT
                $identifier = Split-Path $parameter.items.'$ref' -Leaf
                $definition = $TemplateFileContent.definitions[$identifier]
                $type = $parameter.type
                $rawAllowedValues = $definition['allowedValues']
            } else {
                $definition = $null
                $type = $parameter.type
                $rawAllowedValues = $parameter.allowedValues
            }

            $isRequired = (Get-IsParameterRequired -TemplateFileContent $TemplateFileContent -Parameter $parameter) ? 'Yes' : 'No'
            $description = $parameter.ContainsKey('metadata') ? $parameter['metadata']['description'].substring("$category. ".Length).Replace("`n- ", '<li>').Replace("`r`n", '<p>').Replace("`n", '<p>') : $null
            $example = ($parameter.ContainsKey('metadata') -and $parameter['metadata'].ContainsKey('example')) ? $parameter['metadata']['example'] : $null

            #####################
            #   Table content   #
            #####################

            # build table for definition properties
            $tableSectionContent += ('| [`{0}`]({1}) | {2} | {3} |' -f $parameter.name, $paramIdentifierLink, $type, $description)

            ####################
            #   List content   #
            ####################

            # Format default values
            # =====================
            if ($parameter.defaultValue -is [array]) {
                if ($parameter.defaultValue.count -eq 0) {
                    $defaultValue = '[]'
                } else {
                    $bicepJSONDefaultParameterObject = @{ $parameter.name = ($parameter.defaultValue ?? @()) } # Wrapping on object to work with formatted Bicep script
                    $bicepRawformattedDefault = ConvertTo-FormattedBicep -JSONParameters $bicepJSONDefaultParameterObject
                    $leadingSpacesToTrim = ($bicepRawformattedDefault -match '^(\s+).+') ? $matches[1].Length : 0
                    $bicepCleanedFormattedDefault = $bicepRawformattedDefault -replace ('{0}: ' -f $parameter.name) # Unwrapping the object
                    $defaultValue = $bicepCleanedFormattedDefault -split '\n' | ForEach-Object { $_ -replace "^\s{$leadingSpacesToTrim}" }  # Removing excess leading spaces
                }
            } elseif ($parameter.defaultValue -is [hashtable]) {
                if ($parameter.defaultValue.count -eq 0) {
                    $defaultValue = '{}'
                } else {
                    $bicepDefaultValue = ConvertTo-FormattedBicep -JSONParameters $parameter.defaultValue
                    $defaultValue = "{`n$bicepDefaultValue`n}"
                }
            } elseif ($parameter.defaultValue -is [string] -and ($parameter.defaultValue -notmatch '\[\w+\(.*\).*\]')) {
                $defaultValue = '''' + $parameter.defaultValue + ''''
            } else {
                $defaultValue = $parameter.defaultValue
            }

            if (-not [String]::IsNullOrEmpty($defaultValue)) {
                if (($defaultValue -split '\n').count -eq 1) {
                    $formattedDefaultValue = '- Default: `{0}`' -f $defaultValue
                } else {
                    $formattedDefaultValue = @(
                        '- Default:',
                        '  ```Bicep',
                ($defaultValue -split '\n' | ForEach-Object { "  $_" } | Out-String).TrimEnd(),
                        '  ```'
                    )
                }
            } else {
                $formattedDefaultValue = $null
            }

            # Format allowed values
            # =====================
            if ($rawAllowedValues -is [array]) {
                $bicepJSONAllowedParameterObject = @{ $parameter.name = ($rawAllowedValues ?? @()) } # Wrapping on object to work with formatted Bicep script
                $bicepRawformattedAllowed = ConvertTo-FormattedBicep -JSONParameters $bicepJSONAllowedParameterObject
                $leadingSpacesToTrim = ($bicepRawformattedAllowed -match '^(\s+).+') ? $matches[1].Length : 0
                $bicepCleanedFormattedAllowed = $bicepRawformattedAllowed -replace ('{0}: ' -f $parameter.name) # Unwrapping the object
                $allowedValues = $bicepCleanedFormattedAllowed -split '\n' | ForEach-Object { $_ -replace "^\s{$leadingSpacesToTrim}" }  # Removing excess leading spaces
            } elseif ($rawAllowedValues -is [hashtable]) {
                $bicepAllowedValues = ConvertTo-FormattedBicep -JSONParameters $rawAllowedValues
                $allowedValues = "{`n$bicepAllowedValues`n}"
            } else {
                $allowedValues = $rawAllowedValues
            }

            if (-not [String]::IsNullOrEmpty($allowedValues)) {
                if (($allowedValues -split '\n').count -eq 1) {
                    $formattedAllowedValues = '- Default: `{0}`' -f $allowedValues
                } else {
                    $formattedAllowedValues = @(
                        '- Allowed:',
                        '  ```Bicep',
                ($allowedValues -split '\n' | Where-Object { -not [String]::IsNullOrEmpty($_) } | ForEach-Object { "  $_" } | Out-String).TrimEnd(),
                        '  ```'
                    )
                }
            } else {
                $formattedAllowedValues = $null
            }

            # Format example
            # ==============
            if (-not [String]::IsNullOrEmpty($example)) {
                # allign content to the left by removing trailing whitespaces
                $leadingSpacesToTrim = ($example -match '^(\s+).+') ? $matches[1].Length : 0
                $exampleLines = $example -split '\n'
                # Removing excess leading spaces
                $example = ($exampleLines | Where-Object { -not [String]::IsNullOrEmpty($_) } | ForEach-Object { "  $_" -replace "^\s{$leadingSpacesToTrim}" } | Out-String).TrimEnd()

                if ($exampleLines.count -eq 1) {
                    $formattedExample = '- Example: `{0}`' -f $example.TrimStart()
                } else {
                    $formattedExample = @(
                        '- Example:',
                        '  ```Bicep',
                        $example,
                        '  ```'
                    )
                }
            } else {
                $formattedExample = $null
            }

            # Build list item
            # ===============
            $listSectionContent += @(
                $paramHeader,
            ($parameter.ContainsKey('metadata') ? '' : $null),
                $description
            ($parameter.ContainsKey('metadata') ? '' : $null),
            ('- Required: {0}' -f $isRequired),
            ('- Type: {0}' -f $type),
            ((-not [String]::IsNullOrEmpty($formattedDefaultValue)) ? $formattedDefaultValue : $null),
            ((-not [String]::IsNullOrEmpty($formattedAllowedValues)) ? $formattedAllowedValues : $null),
            ((-not [String]::IsNullOrEmpty($formattedExample)) ? $formattedExample : $null)
                ''
            ) | Where-Object { $null -ne $_ }

            #recursive call for children
            if ($definition) {
                # 'items' refers to an array
                # 'properties' is the default for UDTs, 'additionalProperties' represents a used '*' identifier
                if ($definition.Keys -contains 'items' -and ($definition.items.properties.Keys -or $definition.items.additionalProperties.Keys)) {
                    if ($definition.items.properties.Keys) {
                        $childProperties = $definition.items.properties
                        $sectionContent = Set-DefinitionSection -TemplateFileContent $TemplateFileContent -Properties $childProperties -ParentName $paramIdentifier -ParentIdentifierLink $paramIdentifierLink -ColumnsInOrder $ColumnsInOrder
                        $listSectionContent += $sectionContent
                    }
                    if ($definition.items.additionalProperties.Keys) {
                        $childProperties = $definition.items.additionalProperties
                        $formattedProperties = @{ '>Any_other_property<' = $childProperties }
                        $sectionContent = Set-DefinitionSection -TemplateFileContent $TemplateFileContent -Properties $formattedProperties -ParentName $paramIdentifier -ParentIdentifierLink $paramIdentifierLink -ColumnsInOrder $ColumnsInOrder
                        $listSectionContent += $sectionContent
                    }
                } elseif ($definition.type -eq 'object' -and ($definition.properties.Keys -or $definition.additionalProperties.Keys)) {
                    if ($definition.properties.Keys) {
                        $childProperties = $definition.properties
                        $sectionContent = Set-DefinitionSection -TemplateFileContent $TemplateFileContent -Properties $childProperties -ParentName $paramIdentifier -ParentIdentifierLink $paramIdentifierLink -ColumnsInOrder $ColumnsInOrder
                        $listSectionContent += $sectionContent
                    }
                    if ($definition.additionalProperties.Keys) {
                        $childProperties = $definition.additionalProperties
                        $formattedProperties = @{ '>Any_other_property<' = $childProperties }
                        $sectionContent = Set-DefinitionSection -TemplateFileContent $TemplateFileContent -Properties $formattedProperties -ParentName $paramIdentifier -ParentIdentifierLink $paramIdentifierLink -ColumnsInOrder $ColumnsInOrder
                        $listSectionContent += $sectionContent
                    }
                }
            }
        }

        $tableSectionContent += ''
    }

    $newSectionContent += $tableSectionContent
    $newSectionContent += $listSectionContent
    return $newSectionContent
}

<#
.SYNOPSIS
Update the 'outputs' section of the given readme file

.DESCRIPTION
Update the 'outputs' section of the given readme file

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Outputs'

.EXAMPLE
Set-OutputsSection -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Outputs' section based on the given template file content
#>
function Set-OutputsSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Outputs'
    )

    # Process content
    if ($TemplateFileContent.outputs.Values.metadata) {
        # Template has output descriptions
        $SectionContent = [System.Collections.ArrayList]@(
            '| Output | Type | Description |',
            '| :-- | :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object -Culture 'en-US')) {
            $output = $TemplateFileContent.outputs[$outputName]
            $description = $output.metadata.description.Replace("`r`n", '<p>').Replace("`n", '<p>')
            $SectionContent += ("| ``{0}`` | {1} | {2} |" -f $outputName, $output.type, $description)
        }
    } else {
        $SectionContent = [System.Collections.ArrayList]@(
            '| Output | Type |',
            '| :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object -Culture 'en-US')) {
            $output = $TemplateFileContent.outputs[$outputName]
            $SectionContent += ("| ``{0}`` | {1} |" -f $outputName, $output.type)
        }
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'nextH2'
    }
    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'Data Collection' section of the given readme file

.DESCRIPTION
Update the 'Data Collection' section of the given readme file

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the section. Defaults to '## Data Collection'

.PARAMETER PreLoadedContent
Optional. Pre-Loaded content. May be used to reuse the same data for multiple invocations. For example:
@{
    TelemetryFileContent = @() // Optional. The text of the telemetry notice to add to each readme.
}

.EXAMPLE
Set-DataCollectionSection -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Data Collection' section
#>
function Set-DataCollectionSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [hashtable] $PreLoadedContent = @{},

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Data Collection'
    )

    # Load content, if required
    if ($PreLoadedContent.Keys -notcontains 'TelemetryFileContent') {

        $telemetryUrl = 'https://aka.ms/avm/static/telemetry'
        try {
            $rawResponse = Invoke-WebRequest -Uri $telemetryUrl
            if (($rawResponse.Headers['Content-Type'] | Out-String) -like '*text/plain*') {
                $telemetryFileContent = $rawResponse.Content -split '\n'
            } else {
                Write-Warning "Failed to fetch telemetry information from [$telemetryUrl]." # Incorrect Url (e.g., points to HTML)
                return $ReadMeFileContent
            }
        } catch {
            Write-Warning "Failed to fetch telemetry information from [$telemetryUrl]." # Invalid url
            return $ReadMeFileContent
        }
    } else {
        $telemetryFileContent = $PreLoadedContent.TelemetryFileContent
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $telemetryFileContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'nextH2'
    }
    return $updatedFileContent
}

<#
.SYNOPSIS
Add module references (cross-references) to the module's readme

.DESCRIPTION
Add module references (cross-references) to the module's readme. This includes both local (i.e., file path), as well as remote references (e.g., ACR)

.PARAMETER ModuleRoot
Mandatory. The file path to the module's root

.PARAMETER FullModuleIdentifier
Mandatory. The full identifier of the module (i.e., ProviderNamespace + ResourceType)

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Cross-referenced modules'

.PARAMETER PreLoadedContent
Optional. Pre-Loaded content. May be used to reuse the same data for multiple invocations. For example:
@{
    CrossReferencedModuleList = @{} // Optional. Cross Module References to consider when refreshing the readme. Can be provided to speed up the generation. If not provided, is fetched by this script.
}

.EXAMPLE
Set-CrossReferencesSection -ModuleRoot 'C:/key-vault/vault' -FullModuleIdentifier 'key-vault/vault' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...) -PreLoadedContent @{ CrossReferencedModuleList = @{ ... } }
Update the given readme file's 'Cross-referenced modules' section based on the given template file content
#>
function Set-CrossReferencesSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleRoot,

        [Parameter(Mandatory = $true)]
        [string] $FullModuleIdentifier,

        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [hashtable] $PreLoadedContent = @{},

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Cross-referenced modules'
    )

    # Load content, if required
    if ($PreLoadedContent.Keys -notcontains 'CrossReferencedModuleList') {
        $CrossReferencedModuleList = Get-CrossReferencedModuleList
    } else {
        $CrossReferencedModuleList = $PreLoadedContent.CrossReferencedModuleList
    }

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        'This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).',
        '',
        '| Reference | Type |',
        '| :-- | :-- |'
    )

    $dependencies = $CrossReferencedModuleList[$FullModuleIdentifier]

    if ($dependencies.Keys -contains 'localPathReferences' -and $dependencies['localPathReferences']) {
        foreach ($reference in ($dependencies['localPathReferences'] | Sort-Object -Culture 'en-US')) {
            $SectionContent += ("| ``{0}`` | {1} |" -f $reference, 'Local reference')
        }
    }

    if ($dependencies.Keys -contains 'remoteReferences' -and $dependencies['remoteReferences']) {
        foreach ($reference in ($dependencies['remoteReferences'] | Sort-Object -Culture 'en-US')) {
            $SectionContent += ("| ``{0}`` | {1} |" -f $reference, 'Remote reference')
        }
    }

    if ($SectionContent.Count -eq 4) {
        # No content was added, adding placeholder
        $SectionContent = @('_None_')

    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'nextH2'
    }
    return $updatedFileContent
}

<#
.SYNOPSIS
Add comments to indicate required & non-required parameters to the given Bicep example

.DESCRIPTION
Add comments to indicate required & non-required parameters to the given Bicep example.
'Required' is only added if the example has at least one required parameter
'Non-Required' is only added if the example has at least one required parameter and at least one non-required parameter

.PARAMETER BicepParams
Mandatory. The Bicep parameter block to add the comments to (i.e., should contain everything in between the brackets of a 'params: {...} block)

.PARAMETER AllParametersList
Mandatory. A list of all top-level (i.e. non-nested) parameter names

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
Add-BicepParameterTypeComment -AllParametersList @('name', 'lock') -RequiredParametersList @('name') -BicepParams "name: 'module'\nlock: 'CanNotDelete'"

Add type comments to given bicep params string, using one required parameter 'name'. Would return:

'
    // Required parameters
    name: 'module'
    // Non-required parameters
    lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
    }
'
#>
function Add-BicepParameterTypeComment {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string] $BicepParams,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $AllParametersList = @(),

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    if ($RequiredParametersList.Count -ge 1 -and $AllParametersList.Count -ge 2) {

        $BicepParamsArray = $BicepParams -split '\n'

        # [1/4] Check where the 'last' required parameter is located in the example (and what its indent is)
        $parameterToSplitAt = $RequiredParametersList[-1]
        $requiredParameterIndent = ([regex]::Match($BicepParamsArray[0], '^(\s+).*')).Captures.Groups[1].Value.Length

        # [2/4] Add a comment where the required parameters start
        $BicepParamsArray = @('{0}// Required parameters' -f (' ' * $requiredParameterIndent)) + $BicepParamsArray[(0 .. ($BicepParamsArray.Count))]

        # [3/4] Find the location if the last required parameter
        $requiredParameterStartIndex = ($BicepParamsArray | Select-String ('^[\s]{0}{1}:.+' -f "{$requiredParameterIndent}", $parameterToSplitAt) | ForEach-Object { $_.LineNumber - 1 })[0]

        # [4/4] If we have more than only required parameters, let's add a corresponding comment
        if ($AllParametersList.Count -gt $RequiredParametersList.Count) {
            $nextLineIndent = ([regex]::Match($BicepParamsArray[$requiredParameterStartIndex + 1], '^(\s+).*')).Captures.Groups[1].Value.Length
            if ($nextLineIndent -gt $requiredParameterIndent) {
                # Case Param is object/array: Search in rest of array for the next closing bracket with the same indent - and then add the search index (1) & initial index (1) count back in
                $requiredParameterEndIndex = ($BicepParamsArray[($requiredParameterStartIndex + 1)..($BicepParamsArray.Count)] | Select-String "^[\s]{$requiredParameterIndent}\S+" | ForEach-Object { $_.LineNumber - 1 })[0] + 1 + $requiredParameterStartIndex
            } else {
                # Case Param is single line bool/string/int: Add an index (1) for the 'required' comment
                $requiredParameterEndIndex = $requiredParameterStartIndex
            }

            # Add a comment where the non-required parameters start
            $BicepParamsArray = $BicepParamsArray[0..$requiredParameterEndIndex] + ('{0}// Non-required parameters' -f (' ' * $requiredParameterIndent)) + $BicepParamsArray[(($requiredParameterEndIndex + 1) .. ($BicepParamsArray.Count))]
        }

        return ($BicepParamsArray | Out-String).TrimEnd()
    }

    return $BicepParams
}

<#
.SYNOPSIS
Sort the given JSON paramters into required & non-required parameters, each sorted alphabetically

.DESCRIPTION
Sort the given JSON paramters into required & non-required parameters, each sorted alphabetically

.PARAMETER ParametersJSON
Mandatory. The JSON parameters block to process (ideally already without 'value' property)

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
Get-OrderedParametersJSON -RequiredParametersList @('name') -ParametersJSON '{ "lock": "CanNotDelete","name": "module" }'

Order the given JSON object alphabetically. Would result into:

@{
    name: 'module'
    lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
    }
}
#>
function Get-OrderedParametersJSON {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ParametersJSON,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    # [1/3] Get all parameters from the parameter object and order them recursively
    $orderedContentInJSONFormat = ConvertTo-OrderedHashtable -JSONInputObject $parametersJSON

    # [2/3] Sort 'required' parameters to the front
    $orderedJSONParameters = [ordered]@{}
    $orderedTopLevelParameterNames = $orderedContentInJSONFormat.psbase.Keys # We must use PS-Base to handle conflicts of HashTable properties & keys (e.g. for a key 'keys').
    # [2.1] Add required parameters first
    $orderedTopLevelParameterNames | Where-Object { $_ -in $RequiredParametersList } | ForEach-Object { $orderedJSONParameters[$_] = $orderedContentInJSONFormat[$_] }
    # [2.2] Add rest after
    $orderedTopLevelParameterNames | Where-Object { $_ -notin $RequiredParametersList } | ForEach-Object { $orderedJSONParameters[$_] = $orderedContentInJSONFormat[$_] }

    # [3/3] Handle empty dictionaries (in case the parmaeter file was empty)
    if ($orderedJSONParameters.count -eq 0) {
        $orderedJSONParameters = ''
    }

    return $orderedJSONParameters
}

<#
.SYNOPSIS
Sort the given JSON parameters into a new JSON parameter object, all parameter sorted into required & non-required parameters, each sorted alphabetically

.DESCRIPTION
Sort the given JSON parameters into a new JSON parameter object, all parameter sorted into required & non-required parameters, each sorted alphabetically.
The location where required & non-required parameters start is highlighted with by a corresponding comment

.PARAMETER ParametersJSON
Mandatory. The parameter JSON object to process

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
Build-OrderedJSONObject -RequiredParametersList @('name') -ParametersJSON '{ "lock": { "value": "CanNotDelete" }, "name": { "value": "module" } }'

Build a formatted Parameter-JSON object with one required parameter. Would result into:

'{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        // Required parameters
        "name": {
            "value": "module"
        },
        // Non-required parameters
        "lock": {
            "value": "CanNotDelete"
        }
    }
}'
#>
function Build-OrderedJSONObject {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ParametersJSON,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    # [1/9] Sort parameter alphabetically
    $orderedJSONParameters = Get-OrderedParametersJSON -ParametersJSON $ParametersJSON -RequiredParametersList $RequiredParametersList

    # [2/9] Build the ordered parameter file syntax back up
    $jsonExample = ([ordered]@{
            '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
            contentVersion = '1.0.0.0'
            parameters     = (-not [String]::IsNullOrEmpty($orderedJSONParameters)) ? $orderedJSONParameters : @{}
        } | ConvertTo-Json -Depth 99)

    # [3/8] If we have at least one required and one other parameter we want to add a comment
    if ($RequiredParametersList.Count -ge 1 -and $OrderedJSONParameters.Keys.Count -ge 2) {

        $jsonExampleArray = $jsonExample -split '\n'

        # [4/8] Check where the 'last' required parameter is located in the example (and what its indent is)
        $parameterToSplitAt = $RequiredParametersList[-1]
        $parameterStartIndex = ($jsonExampleArray | Select-String '.*"parameters": \{.*' | ForEach-Object { $_.LineNumber - 1 })[0]
        $requiredParameterIndent = ([regex]::Match($jsonExampleArray[($parameterStartIndex + 1)], '^(\s+).*')).Captures.Groups[1].Value.Length

        # [5/8] Add a comment where the required parameters start
        $jsonExampleArray = $jsonExampleArray[0..$parameterStartIndex] + ('{0}// Required parameters' -f (' ' * $requiredParameterIndent)) + $jsonExampleArray[(($parameterStartIndex + 1) .. ($jsonExampleArray.Count))]

        # [6/8] Find the location if the last required parameter
        $requiredParameterStartIndex = ($jsonExampleArray | Select-String "^[\s]{$requiredParameterIndent}`"$parameterToSplitAt`": \{.*" | ForEach-Object { $_.LineNumber - 1 })[0]

        # [7/8] If we have more than only required parameters, let's add a corresponding comment
        if ($orderedJSONParameters.Keys.Count -gt $RequiredParametersList.Count ) {
            # Search in rest of array for the next closing bracket with the same indent - and then add the search index (1) & initial index (1) count back in
            $requiredParameterEndIndex = ($jsonExampleArray[($requiredParameterStartIndex + 1)..($jsonExampleArray.Count)] | Select-String "^[\s]{$requiredParameterIndent}\}" | ForEach-Object { $_.LineNumber - 1 })[0] + 1 + $requiredParameterStartIndex

            # Add a comment where the non-required parameters start
            $jsonExampleArray = $jsonExampleArray[0..$requiredParameterEndIndex] + ('{0}// Non-required parameters' -f (' ' * $requiredParameterIndent)) + $jsonExampleArray[(($requiredParameterEndIndex + 1) .. ($jsonExampleArray.Count))]
        }

        # [8/8] Convert the processed array back into a string
        return $jsonExampleArray | Out-String
    }

    return $jsonExample
}

<#
.SYNOPSIS
Convert the given Bicep parameter block to JSON parameter block

.DESCRIPTION
Convert the given Bicep parameter block to JSON parameter block

.PARAMETER BicepParamBlock
Mandatory. The Bicep parameter block to process

.PARAMETER CurrentFilePath
Mandatory. The Path of the file containing the param block

.EXAMPLE
ConvertTo-FormattedJSONParameterObject -BicepParamBlock "name: 'module'\nlock: 'CanNotDelete'" -CurrentFilePath 'c:/main.test.bicep'

Convert the Bicep string "name: 'module'\nlock: 'CanNotDelete'" into a parameter JSON object. Would result into:

@{
    lock = @{
        value = 'module'
    }
    lock = @{
        value = 'CanNotDelete'
    }
}
#>
function ConvertTo-FormattedJSONParameterObject {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $BicepParamBlock,

        [Parameter()]
        [string] $CurrentFilePath
    )

    if ([String]::IsNullOrEmpty($BicepParamBlock)) {
        # Case: No mandatory parameters
        return @{}
    }

    # [1/4] Detect top level params for later processing
    $bicepParamBlockArray = $BicepParamBlock -split '\n'
    $topLevelParamIndent = ([regex]::Match($bicepParamBlockArray[0], '^(\s+).*')).Captures.Groups[1].Value.Length
    $topLevelParams = $bicepParamBlockArray | Where-Object { $_ -match "^\s{$topLevelParamIndent}[0-9a-zA-Z]+:.*" } | ForEach-Object { ($_ -split ':')[0].Trim() }

    # [2/4] Add JSON-specific syntax to the Bicep param block to enable us to treat is as such
    # [2.1] Syntax: Outer brackets
    $paramInJsonFormat = @(
        '{',
        $BicepParamBlock
        '}'
    ) | Out-String

    # [2.2] Syntax: All double quotes must be escaped & single-quotes are double-quotes
    $paramInJsonFormat = $paramInJsonFormat -replace '"', '\"'
    $paramInJsonFormat = $paramInJsonFormat -replace "'", '"'

    # [2.3] Split the object to format line-by-line (& also remove any empty lines)
    $paramInJSONFormatArray = $paramInJsonFormat -split '\n' | Where-Object { -not [String]::IsNullOrEmpty($_.Trim()) }

    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {

        $line = $paramInJSONFormatArray[$index]

        if ($line -match '^\s*\/\/.*') {
            # Line is comment
            continue
        }

        # [2.4] Syntax:
        # - Everything left of a leftest ':' should be wrapped in quotes (as a parameter name is always a string)
        # - However, we don't want to accidently catch something like "CriticalAddonsOnly=true:NoSchedule"
        [regex]$pattern = '^\s*\"{0}([0-9a-zA-Z_]+):'
        $line = $pattern.replace($line, '"$1":', 1)

        # [2.5] Syntax: Replace Bicep resource ID references
        $mayHaveValue = $line -match '\s*.+:\s+'
        if ($mayHaveValue) {

            $lineValue = ($line -split '\s*.+:\s+')[1].Trim() # i.e. optional spaces, followed by a name ("xzy"), followed by ':', folowed by at least a space

            # Individual checks
            $isLineWithEmptyObjectValue = $line -match '^.+:\s*{\s*}\s*$' # e.g. test: {}
            $isLineWithObjectPropertyReferenceValue = $lineValue -like '*.*' # e.g. resourceGroupResources.outputs.virtualWWANResourceId`
            $isLineWithReferenceInLineKey = ($line -split ':')[0].Trim() -like '*.*'

            $isLineWithStringValue = $lineValue -match '".+"' # e.g. "value"
            $isLineWithStringNestedFunction = $lineValue -match "^['|`"]{1}.*\$\{.+['|`"]{1}$|^['|`"]{0}[a-zA-Z\(]+\(.+" # e.g. (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, "/"))[4] or '${last(...)}' or last() or "test${environment()}"
            $isLineWithPlainValue = $lineValue -match '^\w+$' # e.g. adminPassword: password
            $isLineWithPrimitiveValue = $lineValue -match '^\s*true|false|[0-9]+$' # e.g. isSecure: true

            # Special case: Multi-line function
            $isLineWithMultilineFunction = $lineValue -match '[a-zA-Z]+\s*\([^\)]*\){0}\s*$' # e.g. roleDefinitionIdOrName: subscriptionResourceId( \n 'Microsoft.Authorization/roleDefinitions', \n 'acdd72a7-3385-48ef-bd42-f606fba81ae7' \n )
            if ($isLineWithMultilineFunction) {
                # Search leading indent so that we can use it to identify at which line the function ends
                $indent = ([regex]::Match($paramInJSONFormatArray[$index], '^(\s+)')).Captures.Groups[1].Value.Length

                $functionStartIndex = $index
                $functionEndIndex = $functionStartIndex
                do {
                    $functionEndIndex++
                } while ($paramInJSONFormatArray[$functionEndIndex] -match "^\s{$($indent+1),}" -and $functionEndIndex -lt $paramInJSONFormatArray.Count)

                if ($functionEndIndex -eq $paramInJSONFormatArray.Count) {
                    throw "End index of a multi-line function block for test file [$CurrentFilePath] not found."
                }

                # Overwrite the first line with a default value (i.e., "property": "<property>")
                $line = '{0}: "<{1}>"' -f ($line -split ':')[0], ([regex]::Match(($line -split ':')[0], '"(.+)"')).Captures.Groups[1].Value

                $linesOfFunction = $functionEndIndex - $functionStartIndex

                # Nullify all but first line
                for ($functionIndex = 1; $functionIndex -le $linesOfFunction; $functionIndex++) {
                    $functionLineIndex = $index + $functionIndex
                    $paramInJSONFormatArray[$functionLineIndex] = $null
                }

                # Increase index to skip the function lines
                $index += $indexToIncrease
            } else {
                # Combined checks
                # In case of an output reference like '"virtualWanId": resourceGroupResources.outputs.virtualWWANResourceId' we'll only show "<virtualWanId>" (but NOT e.g. 'reference': {})
                $isLineWithObjectPropertyReference = -not $isLineWithEmptyObjectValue -and -not $isLineWithStringValue -and $isLineWithObjectPropertyReferenceValue
                # In case of a parameter/variable reference like 'adminPassword: password' we'll only show "<adminPassword>" (but NOT e.g. enableMe: true)
                $isLineWithParameterOrVariableReferenceValue = $isLineWithPlainValue -and -not $isLineWithPrimitiveValue
                # In case of any contained line like ''${resourceGroupResources.outputs.managedIdentityResourceId}': {}' we'll only show "managedIdentityResourceId: {}"
                $isLineWithObjectReferenceKeyAndEmptyObjectValue = $isLineWithEmptyObjectValue -and $isLineWithReferenceInLineKey
                # In case of any contained function like '"backupVaultResourceGroup": (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, "/"))[4]' we'll only show "<backupVaultResourceGroup>"

                if ($isLineWithObjectPropertyReference -or $isLineWithStringNestedFunction -or $isLineWithParameterOrVariableReferenceValue) {
                    $line = '{0}: "<{1}>"' -f ($line -split ':')[0], ([regex]::Match(($line -split ':')[0], '"(.+)"')).Captures.Groups[1].Value
                } elseif ($isLineWithObjectReferenceKeyAndEmptyObjectValue) {
                    $line = '"<{0}>": {1}' -f (($line -split ':')[0] -split '\.')[-1].TrimEnd('}"'), $lineValue
                }
            }
        } else {
            if ($line -notlike '*"*"*' -and $line -like '*.*') {
                # In case of a array value like '[ \n -> resourceGroupResources.outputs.managedIdentityPrincipalId <- \n ]' we'll only show "<managedIdentityPrincipalId>""
                $line = '"<{0}>"' -f $line.Split('.')[-1].Trim()
            } elseif ($line -match '^\s*[a-zA-Z]+\s*$') {
                # If there is simply only a value such as a variable reference, we'll wrap it as a string to replace. For example a reference of a variable `addressPrefix` will be replaced with `"<addressPrefix>"`
                $line = '"<{0}>"' -f $line.Trim()
            }
        }

        $paramInJSONFormatArray[$index] = $line
    }

    # [2.6] Remove empty lines
    $paramInJSONFormatArray = $paramInJSONFormatArray | Where-Object { $_ }

    # [2.7] Syntax: Add comma everywhere unless:
    # - the current line has an opening 'object: {' or 'array: [' character
    # - the line after the current line has a closing 'object: {' or 'array: [' character
    # - it's the last closing bracket
    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {
        if (($paramInJSONFormatArray[$index] -match '[\{|\[]\s*$') -or (($index -lt $paramInJSONFormatArray.Count - 1) -and $paramInJSONFormatArray[$index + 1] -match '^\s*[\]|\}]\s*$') -or ($index -eq $paramInJSONFormatArray.Count - 1)) {
            continue
        }
        $paramInJSONFormatArray[$index] = '{0},' -f $paramInJSONFormatArray[$index].Trim()
    }

    # [2.8] Format the final JSON string to an object to enable processing
    try {
        $paramInJsonFormatObject = $paramInJSONFormatArray | Out-String | ConvertFrom-Json -AsHashtable -Depth 99 -ErrorAction 'Stop'
    } catch {
        throw ('Failed to process file [{0}]. Please check if it properly formatted. Original error message: [{1}]' -f $CurrentFilePath, $_.Exception.Message)
    }
    # [3/4] Inject top-level 'value`' properties
    $paramInJsonFormatObjectWithValue = @{}
    foreach ($paramKey in $topLevelParams) {
        $paramInJsonFormatObjectWithValue[$paramKey] = @{
            value = $paramInJsonFormatObject[$paramKey]
        }
    }

    # [4/4] Return result
    return $paramInJsonFormatObjectWithValue
}

<#
.SYNOPSIS
Convert the given parameter JSON object into a formatted Bicep object (i.e., sorted & with required/non-required comments)

.DESCRIPTION
Convert the given parameter JSON object into a formatted Bicep object (i.e., sorted & with required/non-required comments)

.PARAMETER JSONParameters
Mandatory. The parameter JSON object to process.

.PARAMETER RequiredParametersList
Mandatory. A list of all required top-level (i.e. non-nested) parameter names

.EXAMPLE
ConvertTo-FormattedBicep -RequiredParametersList @('name') -JSONParameters @{ lock = @{ value = 'module' }; lock = @{ value = 'CanNotDelete' } }

Convert the given JSONParameters object with one required parameter to a formatted Bicep object. Would result into:

'
    // Required parameters
    name: 'module'
    // Non-required parameters
    lock: {
        kind: 'CanNotDelete'
        name: 'myCustomLockName'
    }
'
#>
function ConvertTo-FormattedBicep {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $JSONParameters,

        [Parameter(Mandatory = $false)]
        [AllowEmptyCollection()]
        [string[]] $RequiredParametersList = @()
    )

    # [0/5] Remove 'value' parameter property, if any (e.g. when dealing with a classic parameter file)
    $JSONParametersWithoutValue = @{}
    foreach ($parameterName in $JSONParameters.psbase.Keys) {
        $keysOnLevel = $JSONParameters[$parameterName].Keys
        if ($keysOnLevel.count -eq 1 -and $keysOnLevel -eq 'value') {
            $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName].value
        } else {
            $JSONParametersWithoutValue[$parameterName] = $JSONParameters[$parameterName]
        }
    }

    # [1/5] Order parameters recursively
    if ($JSONParametersWithoutValue.psbase.Keys.Count -gt 0) {
        $orderedJSONParameters = Get-OrderedParametersJSON -ParametersJSON ($JSONParametersWithoutValue | ConvertTo-Json -Depth 99) -RequiredParametersList $RequiredParametersList
    } else {
        $orderedJSONParameters = @{}
    }
    # [2/5] Remove any JSON specific formatting
    $templateParameterObject = $orderedJSONParameters | ConvertTo-Json -Depth 99
    if ($templateParameterObject -ne '{}') {
        $bicepParamsArray = $templateParameterObject -split '\r?\n' | ForEach-Object {
            $line = $_
            $line = $line -replace "'", "\'" # Update any [ "field": "[[concat('tags[', parameters('tagName'), ']')]"] to [ "field": "[[concat(\'tags[\', parameters(\'tagName\'), \']\')]"]
            $line = $line -replace '"', "'" # Update any [xyz: "xyz"] to [xyz: 'xyz']
            $line = $line -replace ',$', '' # Update any [xyz: abc,xyz,] to [xyz: abc,xyz]
            $line = $line -replace "'(\w+)':", '$1:' # Update any  ['xyz': xyz] to [xyz: xyz]
            $line = $line -replace "'(.+.getSecret\('.+'\))'", '$1' # Update any  [xyz: 'xyz.GetSecret()'] to [xyz: xyz.GetSecret()]
            $line
        }
        $bicepParamsArray = $bicepParamsArray[1..($bicepParamsArray.count - 2)]

        # [3/5] Format 'getSecret' references
        $bicepParamsArray = $bicepParamsArray | ForEach-Object {
            if ($_ -match ".+: '(\w+)\.getSecret\(\\'([0-9a-zA-Z-<>]+)\\'\)'") {
                # e.g. change [pfxCertificate: 'kv1.getSecret(\'<certSecretName>\')'] to [pfxCertificate: kv1.getSecret('<certSecretName>')]
                "{0}: {1}.getSecret('{2}')" -f ($_ -split ':')[0], $matches[1], $matches[2]
            } else {
                $_
            }
        }
    } else {
        $bicepParamsArray = @()
    }

    # [4/5] Format params with indent
    $bicepParams = ($bicepParamsArray | ForEach-Object { "  $_" } | Out-String).TrimEnd()

    # [5/5]  Add comment where required & optional parameters start
    $splitInputObject = @{
        BicepParams            = $bicepParams
        RequiredParametersList = $RequiredParametersList
        AllParametersList      = $JSONParameters.psBase.Keys
    }
    $commentedBicepParams = Add-BicepParameterTypeComment @splitInputObject

    return $commentedBicepParams
}

<#
.SYNOPSIS
Generate 'Usage examples' for the ReadMe out of the parameter files currently used to test the template

.DESCRIPTION
Generate 'Usage examples' for the ReadMe out of the parameter files currently used to test the template

.PARAMETER ModuleRoot
Mandatory. The file path to the module's root

.PARAMETER FullModuleIdentifier
Mandatory. The full identifier of the module (i.e., ProviderNamespace + ResourceType)

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Usage examples'

.PARAMETER addJson
Optional. A switch to control whether or not to add a ARM-JSON-Parameter file example. Defaults to true.

.PARAMETER addBicep
Optional. A switch to control whether or not to add a Bicep usage example. Defaults to true.

.EXAMPLE
Set-UsageExamplesSection -ModuleRoot 'C:/key-vault/vault' -FullModuleIdentifier 'key-vault/vault' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Usage Examples' section based on the given template file content
#>
function Set-UsageExamplesSection {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleRoot,

        [Parameter(Mandatory = $true)]
        [string] $FullModuleIdentifier,

        [Parameter(Mandatory)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $true)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [bool] $addJson = $true,

        [Parameter(Mandatory = $false)]
        [bool] $addBicep = $true,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Usage examples'
    )

    $brLink = Get-BRMRepositoryName -TemplateFilePath $TemplateFilePath
    $targetVersion = '<version>'

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        "The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.",
        '',
        '>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.',
        '',
        ('>**Note**: To reference the module, please use the following syntax `br/public:{0}:{1}`.' -f $brLink, $targetVersion),
        ''
    )

    #####################
    ##   Init values   ##
    #####################
    $specialConversionHash = @{
        'public-ip-addresses' = 'publicIPAddresses'
        'public-ip-prefixes'  = 'publicIPPrefixes'
    }
    # Get moduleName as $fullModuleIdentifier leaf
    $moduleName = $fullModuleIdentifier.Split('/')[1]
    if ($specialConversionHash.ContainsKey($moduleName)) {
        # Convert moduleName using specialConversionHash
        $moduleNameCamelCase = $specialConversionHash[$moduleName]
    } else {
        # Convert moduleName from kebab-case to camelCase
        $First, $Rest = $moduleName -Split '-', 2
        $moduleNameCamelCase = $First.Tolower() + (Get-Culture).TextInfo.ToTitleCase($Rest) -Replace '-'
    }

    $testFilePaths = (Get-ChildItem -Path $ModuleRoot -Recurse -Filter 'main.test.bicep').FullName | Sort-Object -Culture 'en-US'

    $RequiredParametersList = $TemplateFileContent.parameters.Keys | Where-Object {
        Get-IsParameterRequired -TemplateFileContent $TemplateFileContent -Parameter $TemplateFileContent.parameters[$_]
    } | Sort-Object -Culture 'en-US'

    ############################
    ##   Process test files   ##
    ############################

    # Prepare data (using thread-safe multithreading) to consume later
    $buildTestFileMap = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()
    $testFilePaths | ForEach-Object -Parallel {
        $dict = $using:buildTestFileMap

        $folderName = Split-Path (Split-Path -Path $_) -Leaf
        $builtTemplate = (bicep build $_ --stdout 2>$null) | Out-String

        if ([String]::IsNullOrEmpty($builtTemplate)) {
            throw "Failed to build template [$_]. Try running the command ``bicep build $_ --stdout`` locally for troubleshooting. Make sure you have the latest Bicep CLI installed."
        }
        $templateHashTable = ConvertFrom-Json $builtTemplate -AsHashtable

        $null = $dict.TryAdd($folderName, $templateHashTable)
    }

    # Process data
    $pathIndex = 1
    $usageExampleSectionHeaders = @()
    $testFilesContent = @()
    foreach ($testFilePath in $testFilePaths) {

        # Read content
        $rawContentArray = Get-Content -Path $testFilePath
        $folderName = Split-Path (Split-Path -Path $testFilePath) -Leaf
        $compiledTestFileContent = $buildTestFileMap[$folderName]
        $rawContent = Get-Content -Path $testFilePath -Encoding 'utf8' | Out-String

        # Format example header
        if ($compiledTestFileContent.metadata.Keys -contains 'name') {
            $exampleTitle = $compiledTestFileContent.metadata.name
        } else {
            if ((Split-Path (Split-Path $testFilePath -Parent) -Leaf) -ne '.test') {
                $exampleTitle = Split-Path (Split-Path $testFilePath -Parent) -Leaf
            } else {
                $exampleTitle = ((Split-Path $testFilePath -LeafBase) -replace '\.', ' ') -replace ' parameters', ''
            }
            $textInfo = (Get-Culture -Name 'en-US').TextInfo
            $exampleTitle = $textInfo.ToTitleCase($exampleTitle)
        }

        $fullTestFileTitle = '### Example {0}: _{1}_' -f $pathIndex, $exampleTitle
        $testFilesContent += @(
            $fullTestFileTitle
        )
        $usageExampleSectionHeaders += @{
            title  = $exampleTitle
            header = $fullTestFileTitle
        }

        # If a description is added in the template's metadata, we can add it too
        if ($compiledTestFileContent.metadata.Keys -contains 'description') {
            $testFilesContent += @(
                '',
                $compiledTestFileContent.metadata.description,
                ''
            )
        }

        # ------------------------- #
        #   Prepare Bicep to JSON   #
        # ------------------------- #

        # [1/6] Search for the relevant parameter start & end index
        $bicepTestStartIndex = ($rawContentArray | Select-String ("^module testDeployment '..\/.*main.bicep' = ") | ForEach-Object { $_.LineNumber - 1 })[0]

        $bicepTestEndIndex = $bicepTestStartIndex
        do {
            $bicepTestEndIndex++
        } while ($rawContentArray[$bicepTestEndIndex] -notin @('}', '}]', ']') -and $bicepTestEndIndex -lt $rawContentArray.Count)

        if ($bicepTestEndIndex -eq $rawContentArray.Count) {
            throw "End index of test block for test file [$testFilePath] not found."
        }

        $rawBicepExample = $rawContentArray[$bicepTestStartIndex..$bicepTestEndIndex]

        if (-not ($rawBicepExample | Select-String ('\s+params:.*'))) {
            # Handle case where params are not provided
            $paramsBlockArray = @()
        } else {
            # Extract params block out of the Bicep example
            $paramsStartIndex = ($rawBicepExample | Select-String ('\s+params:.*') | ForEach-Object { $_.LineNumber - 1 })[0]
            $paramsIndent = ($rawBicepExample[$paramsStartIndex] | Select-String '(\s+).*').Matches.Groups[1].Length


            # Handle case where params are empty
            if ($rawBicepExample[$paramsStartIndex] -match '^.*params:\s*\{\s*\}\s*$') {
                $paramsBlockArray = @()
            } else {
                # Handle case where params are provided
                $paramsEndIndex = $paramsStartIndex
                do {
                    $paramsEndIndex++
                } while ($rawBicepExample[$paramsEndIndex] -notMatch "^\s{$paramsIndent}\}" -and
                    $rawBicepExample[$paramsEndIndex] -notMatch "^\s{$paramsIndent}\}\]" -and
                    $rawBicepExample[$paramsEndIndex] -notMatch "^\s{$paramsIndent}\]" -and
                    $paramsEndIndex -lt $rawBicepExample.Count)

                if ($paramsEndIndex -eq $rawBicepExample.Count) {
                    throw "End index of 'params' block for test file [$testFilePath] not found."
                }

                $paramsBlock = $rawBicepExample[($paramsStartIndex + 1) .. ($paramsEndIndex - 1)]
                $paramsBlockArray = $paramsBlock -replace "^\s{$paramsIndent}" # Remove excess leading spaces

                # [2/6] Replace placeholders
                $serviceShort = ([regex]::Match($rawContent, "(?m)^param serviceShort string = '(.+)'\s*$")).Captures.Groups[1].Value

                $paramsBlockString = ($paramsBlockArray | Out-String)
                $paramsBlockString = $paramsBlockString -replace '\$\{serviceShort\}', $serviceShort
                $paramsBlockString = $paramsBlockString -replace '\$\{namePrefix\}[-|\.|_]?', '' # Replacing with empty to not expose prefix and avoid potential deployment conflicts
                $paramsBlockString = $paramsBlockString -replace '(?m):\s*location\s*$', ': ''<location>'''

                # [3/6] Format header, remove scope property & any empty line
                $paramsBlockArray = $paramsBlockString -split '\n' | Where-Object { -not [String]::IsNullOrEmpty($_) }
                $paramsBlockArray = $paramsBlockArray | ForEach-Object { "  $_" }
            }
        }

        # [5/6] Convert Bicep parameter block to JSON parameter block to enable processing
        $conversionInputObject = @{
            BicepParamBlock = ($paramsBlockArray | Out-String).TrimEnd()
            CurrentFilePath = $testFilePath
        }
        $paramsInJSONFormat = ConvertTo-FormattedJSONParameterObject @conversionInputObject

        # [6/6] Convert JSON parameters back to Bicep and order & format them
        $conversionInputObject = @{
            JSONParameters         = $paramsInJSONFormat
            RequiredParametersList = $RequiredParametersList
        }
        $bicepExample = ConvertTo-FormattedBicep @conversionInputObject

        # --------------------- #
        #   Add Bicep example   #
        # --------------------- #
        if ($addBicep) {

            $formattedBicepExample = @(
                "module $moduleNameCamelCase 'br/public:$($brLink):$($targetVersion)' = {",
                "  name: '$($moduleNameCamelCase)Deployment'"
                '  params: {'
            ) + $bicepExample +
            @( '  }',
                '}'
            )

            # Build result
            $testFilesContent += @(
                '',
                '<details>'
                ''
                '<summary>via Bicep module</summary>'
                ''
                '```bicep',
                    ($formattedBicepExample | ForEach-Object { "$_" }).TrimEnd(),
                '```',
                '',
                '</details>',
                '<p>'
            )
        }

        # -------------------- #
        #   Add JSON example   #
        # -------------------- #
        if ($addJson) {

            # [1/2] Get all parameters from the parameter object and order them recursively
            $orderingInputObject = @{
                ParametersJSON         = $paramsInJSONFormat | ConvertTo-Json -Depth 99
                RequiredParametersList = $RequiredParametersList
            }
            $orderedJSONExample = Build-OrderedJSONObject @orderingInputObject

            # [2/2] Create the final content block
            $testFilesContent += @(
                '',
                '<details>'
                ''
                '<summary>via JSON Parameter file</summary>'
                ''
                '```json',
                $orderedJSONExample.Trim()
                '```',
                '',
                '</details>',
                '<p>'
            )
        }


        $testFilesContent += @(
            ''
        )

        $pathIndex++
    }
    foreach ($rawHeader in $usageExampleSectionHeaders) {
        $navigationHeader = (($rawHeader.header -replace '<\/?.+?>|[^A-Za-z0-9\s-]').Trim() -replace '\s+', '-').ToLower() # Remove any html and non-identifer elements
        $SectionContent += '- [{0}](#{1})' -f $rawHeader.title, $navigationHeader
    }
    $SectionContent += ''


    $SectionContent += $testFilesContent

    ######################
    ##   Built result   ##
    ######################
    if ($SectionContent) {
        if ($PSCmdlet.ShouldProcess('Original file with new template references content', 'Merge')) {
            return Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -ContentType 'nextH2'
        }
    } else {
        return $ReadMeFileContent
    }
}

<#
.SYNOPSIS
Generate a table of content section for the given readme file

.DESCRIPTION
Generate a table of content section for the given readme file

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'navigation' section. Defaults to '## Navigation'

.EXAMPLE
Set-TableOfContent -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme's '## Navigation' section to reflect the latest file structure
#>
function Set-TableOfContent {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory = $false)]
        [string] $SectionStartIdentifier = '## Navigation'
    )

    $newSectionContent = [System.Collections.ArrayList]@()

    $contentPointer = 1
    while ($ReadMeFileContent[$contentPointer] -notlike '#*') {
        $contentPointer++
    }

    $headers = $ReadMeFileContent.Split('\n') | Where-Object { $_ -like '## *' }

    if ($headers -notcontains $SectionStartIdentifier) {
        $beforeContent = $ReadMeFileContent[0 .. ($contentPointer - 1)]
        $afterContent = $ReadMeFileContent[$contentPointer .. ($ReadMeFileContent.Count - 1)]

        $ReadMeFileContent = $beforeContent + @($SectionStartIdentifier, '') + $afterContent
    }

    $headers | Where-Object { $_ -ne $SectionStartIdentifier } | ForEach-Object {
        $newSectionContent += '- [{0}](#{1})' -f $_.Replace('#', '').Trim(), $_.Replace('#', '').Trim().Replace(' ', '-').Replace('.', '')
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new navigation content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'nextH2'
    }

    return $updatedFileContent
}

<#
.SYNOPSIS
Initialize the readme file

.DESCRIPTION
Create the initial skeleton of the section headers, name & description.

.PARAMETER ReadMeFilePath
Required. The path to the readme file to initialize.

.PARAMETER FullModuleIdentifier
Required. The full identifier of the module. For example: 'sql/managed-instance/administrator'

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.EXAMPLE
Initialize-ReadMe -ReadMeFilePath 'C:/ResourceModules/modules/sql/managed-instances/administrators/readme.md' -FullModuleIdentifier 'sql/managed-instance/administrator' -TemplateFileContent @{ resource = @{}; ... }

Initialize the readme of the 'sql/managed-instance/administrator' module
#>
function Initialize-ReadMe {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ReadMeFilePath,

        [Parameter(Mandatory = $true)]
        [string] $FullModuleIdentifier,

        [Parameter(Mandatory = $true)]
        [hashtable] $TemplateFileContent
    )

    $moduleName = $TemplateFileContent.metadata.name
    $moduleDescription = $TemplateFileContent.metadata.description

    if ($ReadMeFilePath -match 'avm.(?:res)') {
        # Resource module
        $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $FullModuleIdentifier

        $inTemplateResourceType = (Get-NestedResourceList $TemplateFileContent).type | Select-Object -Unique | Where-Object {
            $_ -match "^$formattedResourceType$"
        }

        if ($inTemplateResourceType) {
            $headerType = $inTemplateResourceType
        } else {
            Write-Warning "No resource type like [$formattedResourceType] found in template. Falling back to it as identifier."
            $headerType = $formattedResourceType
        }
    } else {
        # Non-resource modules always need a custom identifier
        $parentIdentifierName, $childIdentifierName = $FullModuleIdentifier -Split '[\/|\\]', 2 # e.g. 'lz' & 'sub-vending'
        $formattedParentIdentifierName = (Get-Culture).TextInfo.ToTitleCase(($parentIdentifierName -Replace '[^0-9A-Z]', ' ')) -Replace ' '
        $formattedChildIdentifierName = (Get-Culture).TextInfo.ToTitleCase(($childIdentifierName -Replace '[^0-9A-Z]', ' ')) -Replace ' '
        $headerType = "$formattedParentIdentifierName/$formattedChildIdentifierName"
    }

    $hasTests = (Get-ChildItem -Path (Split-Path $ReadMeFilePath) -Recurse -Filter 'main.test.bicep' -File -Force).count -gt 0

    # Orphaned readme existing?
    $orphanedReadMeFilePath = Join-Path (Split-Path $ReadMeFilePath -Parent) 'ORPHANED.md'
    if (Test-Path $orphanedReadMeFilePath) {
        $orphanedReadMeContent = Get-Content -Path $orphanedReadMeFilePath | ForEach-Object { "> $_" }
    }

    # Moved readme existing?
    $movedReadMeFilePath = Join-Path (Split-Path $ReadMeFilePath -Parent) 'MOVED-TO-AVM.md'
    if (Test-Path $movedReadMeFilePath) {
        $movedReadMeContent = Get-Content -Path $movedReadMeFilePath | ForEach-Object { "> $_" }
    }

    $initialContent = @(
        "# $moduleName ``[$headerType]``",
        '',
        ((Test-Path $orphanedReadMeFilePath) ? $orphanedReadMeContent : $null),
        ((Test-Path $orphanedReadMeFilePath) ? '' : $null),
        ((Test-Path $movedReadMeFilePath) ? $movedReadMeContent : $null),
        ((Test-Path $movedReadMeFilePath) ? '' : $null),
        $moduleDescription,
        ''
        '## Resource Types',
        ''
        ($hasTests ? '## Usage examples' : $null),
        ($hasTests ? '' : $null),
        '## Parameters',
        '',
        '## Outputs',
        '',
        '## Cross-referenced modules',
        '',
        '## Notes'
    ) | Where-Object { $null -ne $_ } # Filter null values
    $readMeFileContent = $initialContent

    return $readMeFileContent
}
#endregion

<#
.SYNOPSIS
Update/add the readme that matches the given template file

.DESCRIPTION
Update/add the readme that matches the given template file
Supports both ARM & bicep templates.

.PARAMETER TemplateFilePath
Mandatory. The path to the template to update

.PARAMETER ReadMeFilePath
Optional. The path to the readme to update. If not provided assumes a 'README.md' file in the same folder as the template

.PARAMETER SectionsToRefresh
Optional. The sections to update. By default it refreshes all that are supported.
Currently supports: 'Resource Types', 'Parameters', 'Outputs', 'Template references'

.PARAMETER PreLoadedContent
Optional. Pre-Loaded content. May be used to reuse the same data for multiple invocations. For example:
@{
    CrossReferencedModuleList = @{} // Optional. Cross Module References to consider when refreshing the readme. Can be provided to speed up the generation. If not provided, is fetched by this script.
    TemplateFileContent       = @{} // Optional. The template file content to process. If not provided, the template file content will be read from the TemplateFilePath file.
    TelemetryFileContent      = @() // Optional. The text of the telemetry notice to add to each readme.
}

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:\main.bicep'

Update the readme in path 'C:\README.md' based on the bicep template in path 'C:\main.bicep'

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/network/load-balancer/main.bicep' -SectionsToRefresh @('Parameters', 'Outputs')

Generate the Module ReadMe only for specific sections. Updates only the sections `Parameters` & `Outputs`. Other sections remain untouched.

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/network/load-balancer/main.bicep' -PreLoadedContent @{ TemplateFileContent = @{...} }

(Re)Generate the readme file for template 'loadBalancer' based on the content provided in the PreLoadedContent.TemplateFileContent parameter

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/network/load-balancer/main.bicep' -ReadMeFilePath 'C:/differentFolder'

Generate the Module ReadMe files into a specific folder path

.EXAMPLE
$templatePaths = (Get-ChildItem 'C:/network' -Filter 'main.bicep' -Recurse).FullName
$templatePaths | ForEach-Object -Parallel { . '<PathToRepo>/utilities/tools/Set-ModuleReadMe.ps1' ; Set-ModuleReadMe -TemplateFilePath $_ }

Generate the Module ReadMe for any template in a folder path
#>
function Set-ModuleReadMe {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ReadMeFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) 'README.md'),

        [Parameter(Mandatory = $false)]
        [hashtable] $PreLoadedContent = @{},

        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'Resource Types',
            'Usage examples',
            'Parameters',
            'Outputs',
            'CrossReferences',
            'Template references',
            'Navigation',
            'DataCollection'
        )]
        [string[]] $SectionsToRefresh = @(
            'Resource Types',
            'Usage examples',
            'Parameters',
            'Outputs',
            'CrossReferences',
            'Template references',
            'Navigation',
            'DataCollection'
        )
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'Get-NestedResourceList.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-IsParameterRequired.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-SpecsAlignedResourceName.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'ConvertTo-OrderedHashtable.ps1')
    . (Join-Path $PSScriptRoot 'Get-BRMRepositoryName.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-CrossReferencedModuleList.ps1')

    # Check template & make full path
    $TemplateFilePath = Resolve-Path -Path $TemplateFilePath -ErrorAction Stop

    if (-not (Test-Path $TemplateFilePath -PathType 'Leaf')) {
        throw "[$TemplateFilePath] is no valid file path."
    }

    # Build template, if required
    if ($PreLoadedContent.Keys -notcontains 'TemplateFileContent') {
        if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
            $templateFileContent = bicep build $TemplateFilePath --stdout | ConvertFrom-Json -AsHashtable
        } else {
            $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Encoding 'utf8' -Raw) -ErrorAction 'Stop' -AsHashtable
        }
    } else {
        $templateFileContent = $PreLoadedContent.TemplateFileContent
    }

    if (-not $templateFileContent) {
        throw "Failed to compile [$TemplateFilePath]"
    }

    $moduleRoot = Split-Path $TemplateFilePath -Parent
    $fullModuleIdentifier = ($moduleRoot -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/'
    # Custom modules are modules having the same resource type but different properties based on the name
    # E.g., web/site/config--appsetting vs web/site/config--authsettingv2
    $customModuleSeparator = '--'
    if ($fullModuleIdentifier.Contains($customModuleSeparator)) {
        $fullModuleIdentifier = $fullModuleIdentifier.split($customModuleSeparator)[0]
    }

    # ===================== #
    #   Preparation steps   #
    # ===================== #
    # Read original readme, if any. Then delete it to build from scratch
    if ((Test-Path $ReadMeFilePath) -and -not ([String]::IsNullOrEmpty((Get-Content $ReadMeFilePath -Raw)))) {
        $readMeFileContent = Get-Content -Path $ReadMeFilePath -Encoding 'utf8'
    }
    # Make sure we preserve any manual notes a user might have added in the corresponding section
    if ($match = $readMeFileContent | Select-String -Pattern '## Notes') {
        $startIndex = $match.LineNumber

        $endIndex = $startIndex + 1

        while (-not (($endIndex + 1) -gt $readMeFileContent.count) -and $readMeFileContent[($endIndex + 1)] -notlike '## *') {
            $endIndex++
        }

        $notes = $readMeFileContent[($startIndex - 1)..$endIndex]
    } else {
        $notes = @()
    }

    # Initialize readme
    $inputObject = @{
        ReadMeFilePath       = $ReadMeFilePath
        FullModuleIdentifier = $FullModuleIdentifier
        TemplateFileContent  = $templateFileContent
    }
    $readMeFileContent = Initialize-ReadMe @inputObject

    # =============== #
    #   Set content   #
    # =============== #
    if ($SectionsToRefresh -contains 'Resource Types') {
        # Handle [Resource Types] section
        # ===============================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-ResourceTypesSection @inputObject
    }

    $hasTests = (Get-ChildItem -Path $moduleRoot -Recurse -Filter 'main.test.bicep' -File -Force).count -gt 0
    if ($SectionsToRefresh -contains 'Usage examples' -and $hasTests) {
        # Handle [Usage examples] section
        # ===================================
        $inputObject = @{
            ModuleRoot           = $ModuleRoot
            FullModuleIdentifier = $fullModuleIdentifier
            ReadMeFileContent    = $readMeFileContent
            TemplateFileContent  = $templateFileContent
        }
        $readMeFileContent = Set-UsageExamplesSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Parameters') {
        # Handle [Parameters] section
        # ===========================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
            currentFolderPath   = (Split-Path $TemplateFilePath -Parent)
        }
        $readMeFileContent = Set-ParametersSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Outputs') {
        # Handle [Outputs] section
        # ========================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-OutputsSection @inputObject
    }

    if ($SectionsToRefresh -contains 'CrossReferences') {
        # Handle [CrossReferences] section
        # ========================
        $inputObject = @{
            ModuleRoot           = $ModuleRoot
            FullModuleIdentifier = $fullModuleIdentifier
            ReadMeFileContent    = $readMeFileContent
            TemplateFileContent  = $templateFileContent
            PreLoadedContent     = $PreLoadedContent
        }
        $readMeFileContent = Set-CrossReferencesSection @inputObject
    }

    # Handle [Notes] section
    # ========================
    if ($notes) {
        $readMeFileContent += @( '' )
        $readMeFileContent += $notes
    }

    if ($SectionsToRefresh -contains 'DataCollection') {
        # Handle [DataCollection] section
        # ========================
        $inputObject = @{
            ReadMeFileContent = $readMeFileContent
            PreLoadedContent  = $PreLoadedContent
        }
        $readMeFileContent = Set-DataCollectionSection @inputObject
    }

    if ($SectionsToRefresh -contains 'Navigation') {
        # Handle [Navigation] section
        # ===================================
        $inputObject = @{
            ReadMeFileContent = $readMeFileContent
        }
        $readMeFileContent = Set-TableOfContent @inputObject
    }

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($readMeFileContent | Out-String)

    if (Test-Path $ReadMeFilePath) {
        if ($PSCmdlet.ShouldProcess("File in path [$ReadMeFilePath]", 'Overwrite')) {
            Set-Content -Path $ReadMeFilePath -Value $readMeFileContent -Force -Encoding 'utf8'
        }
        Write-Verbose "File [$ReadMeFilePath] updated" -Verbose
    } else {
        if ($PSCmdlet.ShouldProcess("File in path [$ReadMeFilePath]", 'Create')) {
            $null = New-Item -Path $ReadMeFilePath -Value ($readMeFileContent | Out-String) -Force
        }
        Write-Verbose "File [$ReadMeFilePath] created" -Verbose
    }
}
