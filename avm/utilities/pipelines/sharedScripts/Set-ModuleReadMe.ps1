#requires -version 7.3
#requires -Modules powershell-yaml

<#
.SYNOPSIS
Update the 'Resource Types' section of the given readme file

.DESCRIPTION
Update the 'Resource Types' section of the given readme file
The section is added at the end if it does not exist

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

    # Loading used functions
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        '| Resource Type | API Version |',
        '| :-- | :-- |'
    )

    $RelevantResourceTypeObjects = Get-NestedResourceList $TemplateFileContent | Where-Object {
        $_.type -notin $ResourceTypesToExclude -and $_
    } | Select-Object 'Type', 'ApiVersion' -Unique | Sort-Object Type -Culture 'en-US'

    $ProgressPreference = 'SilentlyContinue'
    $VerbosePreference = 'SilentlyContinue'
    foreach ($resourceTypeObject in $RelevantResourceTypeObjects) {
        $ProviderNamespace, $ResourceType = $resourceTypeObject.Type -split '/', 2
        # Validate if Reference URL is working
        $TemplatesBaseUrl = 'https://learn.microsoft.com/en-us/azure/templates'
        try {
            $ResourceReferenceUrl = '{0}/{1}/{2}/{3}' -f $TemplatesBaseUrl, $ProviderNamespace, $resourceTypeObject.ApiVersion, $ResourceType
            $null = Invoke-WebRequest -Uri $ResourceReferenceUrl
        } catch {
            # Validate if Reference URL is working using the latest documented API version (with no API version in the URL)
            try {
                $ResourceReferenceUrl = '{0}/{1}/{2}' -f $TemplatesBaseUrl, $ProviderNamespace, $ResourceType
                $null = Invoke-WebRequest -Uri $ResourceReferenceUrl
            } catch {
                # Check if the resource is a child resource
                if ($ResourceType.Split('/').length -gt 1) {
                    $ResourceReferenceUrl = '{0}/{1}/{2}' -f $TemplatesBaseUrl, $ProviderNamespace, $ResourceType.Split('/')[0]
                } else {
                    # Use the default Templates URL (Last resort)
                    $ResourceReferenceUrl = '{0}' -f $TemplatesBaseUrl
                }
            }
        }
        $SectionContent += ('| `{0}` | [{1}]({2}) |' -f $resourceTypeObject.type, $resourceTypeObject.apiVersion, $ResourceReferenceUrl)
    }
    $ProgressPreference = 'Continue'
    $VerbosePreference = 'Continue'

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new resource type content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'table'
    }
    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'parameters' section of the given readme file

.DESCRIPTION
Update the 'parameters' section of the given readme file
The section is added at the end if it does not exist

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

    # Get all descriptions
    $descriptions = $TemplateFileContent.parameters.Values.metadata.description

    # Get the module parameter categories
    $paramCategories = $descriptions | ForEach-Object { $_.Split('.')[0] } | Select-Object -Unique

    # Sort categories
    $sortedParamCategories = $ColumnsInOrder | Where-Object { $paramCategories -contains $_ }
    # Add all others that exist but are not specified in the columnsInOrder parameter
    $sortedParamCategories += $paramCategories | Where-Object { $ColumnsInOrder -notcontains $_ }

    # Collect file information
    $currentLevelFolders = Get-ChildItem -Path $currentFolderPath -Directory -Depth 0
    $folderNames = ($null -ne $currentLevelFolders) ? ($currentLevelFolders.FullName | ForEach-Object { Split-Path $_ -Leaf }) : @()

    # Add name as property for later reference
    $TemplateFileContent.parameters.Keys | ForEach-Object { $TemplateFileContent.parameters[$_]['name'] = $_ }

    $newSectionContent = [System.Collections.ArrayList]@()
    # Create parameter blocks
    foreach ($category in $sortedParamCategories) {

        # 1. Prepare
        # Filter to relevant items
        [array] $categoryParameters = $TemplateFileContent.parameters.Values | Where-Object { $_.metadata.description -like "$category. *" } | Sort-Object -Property 'Name' -Culture 'en-US'

        # Check properties for later reference
        $hasDefault = $categoryParameters.defaultValue.count -gt 0
        $hasAllowed = $categoryParameters.allowedValues.count -gt 0

        # 2. Create header including optional columns
        $newSectionContent += @(
            ('**{0} parameters**' -f $category),
            '',
            ('| Parameter Name | Type | {0}{1}Description |' -f ($hasDefault ? 'Default Value | ' : ''), ($hasAllowed ? 'Allowed Values | ' : '')),
            ('| :-- | :-- | {0}{1}:-- |' -f ($hasDefault ? ':-- | ' : ''), ($hasAllowed ? ':-- | ' : ''))
        )

        # 3. Add individual parameters
        foreach ($parameter in $categoryParameters) {

            # Convert parameter name to kebab-case, as that would be the correspondent child module folder to refer to
            # (?<!^): This is a negative lookbehind assertion that ensures the match is not at the beginning of the string. This is used to exclude the first character from being replaced.
            # ([A-Z]): This captures any uppercase letter from A to Z using parentheses.
            $parameterKebabCase = ($parameter.name -creplace '(?<!^)([A-Z])', '-$1').ToLower()

            # Check for local readme references
            if ($folderNames -and $parameterKebabCase -in $folderNames -and $parameter.type -in @('object', 'array')) {
                if ($folderNames -contains $parameterKebabCase) {
                    $type = '_[{0}]({1}/README.md)_ {2}' -f $parameter.name, ($folderNames | Where-Object { $_ -eq $parameterKebabCase }), $parameter.type
                }
            } elseif ($folderNames -and $parameterKebabCase.TrimEnd('-obj') -in $folderNames -and $parameter.type -in @('object', 'array')) {
                if ($folderNames -contains $parameterKebabCase.TrimEnd('-obj')) {
                    $type = '_[{0}]({1}/README.md)_ {2}' -f $parameter.name.TrimEnd('Obj'), ($folderNames | Where-Object { $_ -eq $parameterKebabCase.TrimEnd('-obj') }), $parameter.type
                }
            } else {
                $type = $parameter.type
            }

            # Add external single quotes to all default values of type string except for those using functions
            $defaultValue = ($parameter.defaultValue -is [array]) ? ('[{0}]' -f (($parameter.defaultValue | Sort-Object) -join ', ')) : (($parameter.defaultValue -is [hashtable]) ? '{object}' : (($parameter.defaultValue -is [string]) -and ($parameter.defaultValue -notmatch '\[\w+\(.*\).*\]') ? '''' + $parameter.defaultValue + '''' : $parameter.defaultValue))
            $description = $parameter.metadata.description.Replace("`r`n", '<p>').Replace("`n", '<p>')
            $allowedValue = ($parameter.allowedValues -is [array]) ? ('[{0}]' -f (($parameter.allowedValues | Sort-Object) -join ', ')) : (($parameter.allowedValues -is [hashtable]) ? '{object}' : $parameter.allowedValues)
            # Further, replace all "empty string" default values with actual visible quotes
            if ([regex]::Match($allowedValue, '^(\[\s*,.+)|(\[.+,\s*,)|(.+,\s*\])$').Captures.Count -gt 0) {
                $allowedValue = $allowedValue -replace '\[\s*,', "[''," -replace ',\s*,', ", ''," -replace ',\s*\]', ", '']"
            }

            # Update parameter table content based on parameter category
            ## Remove category from parameter description
            $description = $description.substring("$category. ".Length)
            $defaultValueColumnValue = ($hasDefault ? (-not [String]::IsNullOrEmpty($defaultValue) ? "``$defaultValue`` | " : ' | ') : '')
            $allowedValueColumnValue = ($hasAllowed ? (-not [String]::IsNullOrEmpty($allowedValue) ? "``$allowedValue`` | " : ' | ') : '')
            $newSectionContent += ('| `{0}` | {1} | {2}{3}{4} |' -f $parameter.name, $type, $defaultValueColumnValue, $allowedValueColumnValue, $description)
        }
        $newSectionContent += ''
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
    }

    # Build sub-section 'ParameterUsage'
    if (Test-Path (Join-Path $PSScriptRoot 'moduleReadMeSource')) {
        if ($resourceUsageSourceFiles = Get-ChildItem (Join-Path $PSScriptRoot 'moduleReadMeSource') -Recurse -Filter 'resourceUsage-*') {
            foreach ($sourceFile in $resourceUsageSourceFiles.FullName) {
                $parameterName = (Split-Path $sourceFile -LeafBase).Replace('resourceUsage-', '')
                if ($templateFileContent.parameters.Keys -contains $parameterName) {
                    $subSectionStartIdentifier = '### Parameter Usage: `{0}`' -f $ParameterName

                    # Build result
                    $updateParameterUsageInputObject = @{
                        OldContent             = $updatedFileContent
                        NewContent             = (Get-Content $sourceFile -Raw).Trim()
                        SectionStartIdentifier = $subSectionStartIdentifier
                        ParentStartIdentifier  = $SectionStartIdentifier
                        ContentType            = 'none'
                    }
                    if ($PSCmdlet.ShouldProcess(('Original file with new parameter usage [{0}] content' -f $parameterName), 'Merge')) {
                        $updatedFileContent = Merge-FileWithNewContent @updateParameterUsageInputObject
                    }
                }
            }
        }
    }

    return $updatedFileContent
}

<#
.SYNOPSIS
Update the 'outputs' section of the given readme file

.DESCRIPTION
Update the 'outputs' section of the given readme file
The section is added at the end if it does not exist

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
            '| Output Name | Type | Description |',
            '| :-- | :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object -Culture 'en-US')) {
            $output = $TemplateFileContent.outputs[$outputName]
            $description = $output.metadata.description.Replace("`r`n", '<p>').Replace("`n", '<p>')
            $SectionContent += ("| ``{0}`` | {1} | {2} |" -f $outputName, $output.type, $description)
        }
    } else {
        $SectionContent = [System.Collections.ArrayList]@(
            '| Output Name | Type |',
            '| :-- | :-- |'
        )
        foreach ($outputName in ($templateFileContent.outputs.Keys | Sort-Object -Culture 'en-US')) {
            $output = $TemplateFileContent.outputs[$outputName]
            $SectionContent += ("| ``{0}`` | {1} |" -f $outputName, $output.type)
        }
    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'table'
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

.EXAMPLE
Set-CrossReferencesSection -ModuleRoot 'C:/key-vault/vault' -FullModuleIdentifier 'key-vault/vault' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)
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
        [string] $SectionStartIdentifier = '## Cross-referenced modules'
    )

    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'tools' 'Get-CrossReferencedModuleList.ps1')

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        'This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).',
        '',
        '| Reference | Type |',
        '| :-- | :-- |'
    )

    $dependencies = (Get-CrossReferencedModuleList)[$FullModuleIdentifier]

    if ($dependencies.Keys -contains 'localPathReferences' -and $dependencies['localPathReferences']) {
        foreach ($reference in ($dependencies['localPathReferences'] | Sort-Object)) {
            $SectionContent += ("| ``{0}`` | {1} |" -f $reference, 'Local reference')
        }
    }

    if ($dependencies.Keys -contains 'remoteReferences' -and $dependencies['remoteReferences']) {
        foreach ($reference in ($dependencies['remoteReferences'] | Sort-Object)) {
            $SectionContent += ("| ``{0}`` | {1} |" -f $reference, 'Remote reference')
        }
    }

    if ($SectionContent.Count -eq 4) {
        # No content was added, adding placeholder
        $SectionContent = @('_None_')

    }

    # Build result
    if ($PSCmdlet.ShouldProcess('Original file with new output content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
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
Add-BicepParameterTypeComment -AllParametersList @('name', 'lock') -RequiredParametersList @('name') -BicepParams "name: 'carml'\nlock: 'CanNotDelete'"

Add type comments to given bicep params string, using one required parameter 'name'. Would return:

'
    // Required parameters
    name: 'carml'
    // Non-required parameters
    lock: 'CanNotDelete'
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
Get-OrderedParametersJSON -RequiredParametersList @('name') -ParametersJSON '{ "lock": "CanNotDelete","name": "carml" }'

Order the given JSON object alphabetically. Would result into:

@{
    name: 'carml'
    lock: 'CanNotDelete'
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

    # Load used function(s)
    . (Join-Path $PSScriptRoot 'helper' 'ConvertTo-OrderedHashtable.ps1')

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
Build-OrderedJSONObject -RequiredParametersList @('name') -ParametersJSON '{ "lock": { "value": "CanNotDelete" }, "name": { "value": "carml" } }'

Build a formatted Parameter-JSON object with one required parameter. Would result into:

'{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        // Required parameters
        "name": {
            "value": "carml"
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
ConvertTo-FormattedJSONParameterObject -BicepParamBlock "name: 'carml'\nlock: 'CanNotDelete'" -CurrentFilePath 'c:/main.test.bicep'

Convert the Bicep string "name: 'carml'\nlock: 'CanNotDelete'" into a parameter JSON object. Would result into:

@{
    lock = @{
        value = 'carml'
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
            $isLineWithFunction = $lineValue -match "^['|`"]{1}.*\$\{.+['|`"]{1}$|^['|`"]{0}[a-zA-Z\(]+\(.+" # e.g. (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, "/"))[4] or '${last(...)}' or last() or "test${environment()}"
            $isLineWithPlainValue = $lineValue -match '^\w+$' # e.g. adminPassword: password
            $isLineWithPrimitiveValue = $lineValue -match '^\s*true|false|[0-9]+$' # e.g. isSecure: true

            # Combined checks
            # In case of an output reference like '"virtualWanId": resourceGroupResources.outputs.virtualWWANResourceId' we'll only show "<virtualWanId>" (but NOT e.g. 'reference': {})
            $isLineWithObjectPropertyReference = -not $isLineWithEmptyObjectValue -and -not $isLineWithStringValue -and $isLineWithObjectPropertyReferenceValue
            # In case of a parameter/variable reference like 'adminPassword: password' we'll only show "<adminPassword>" (but NOT e.g. enableMe: true)
            $isLineWithParameterOrVariableReferenceValue = $isLineWithPlainValue -and -not $isLineWithPrimitiveValue
            # In case of any contained line like ''${resourceGroupResources.outputs.managedIdentityResourceId}': {}' we'll only show "managedIdentityResourceId: {}"
            $isLineWithObjectReferenceKeyAndEmptyObjectValue = $isLineWithEmptyObjectValue -and $isLineWithReferenceInLineKey
            # In case of any contained function like '"backupVaultResourceGroup": (split(resourceGroupResources.outputs.recoveryServicesVaultResourceId, "/"))[4]' we'll only show "<backupVaultResourceGroup>"

            if ($isLineWithObjectPropertyReference -or $isLineWithFunction -or $isLineWithParameterOrVariableReferenceValue) {
                $line = '{0}: "<{1}>"' -f ($line -split ':')[0], ([regex]::Match(($line -split ':')[0], '"(.+)"')).Captures.Groups[1].Value
            } elseif ($isLineWithObjectReferenceKeyAndEmptyObjectValue) {
                $line = '"<{0}>": {1}' -f (($line -split ':')[0] -split '\.')[-1].TrimEnd('}"'), $lineValue
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

    # [2.6] Syntax: Add comma everywhere unless:
    # - the current line has an opening 'object: {' or 'array: [' character
    # - the line after the current line has a closing 'object: {' or 'array: [' character
    # - it's the last closing bracket
    for ($index = 0; $index -lt $paramInJSONFormatArray.Count; $index++) {
        if (($paramInJSONFormatArray[$index] -match '[\{|\[]\s*$') -or (($index -lt $paramInJSONFormatArray.Count - 1) -and $paramInJSONFormatArray[$index + 1] -match '^\s*[\]|\}]\s*$') -or ($index -eq $paramInJSONFormatArray.Count - 1)) {
            continue
        }
        $paramInJSONFormatArray[$index] = '{0},' -f $paramInJSONFormatArray[$index].Trim()
    }

    # [2.7] Format the final JSON string to an object to enable processing
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
ConvertTo-FormattedBicep -RequiredParametersList @('name') -JSONParameters @{ lock = @{ value = 'carml' }; lock = @{ value = 'CanNotDelete' } }

Convert the given JSONParameters object with one required parameter to a formatted Bicep object. Would result into:

'
    // Required parameters
    name: 'carml'
    // Non-required parameters
    lock: 'CanNotDelete'
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
    if ($JSONParametersWithoutValue.Keys.Count -gt 0) {
        $orderedJSONParameters = Get-OrderedParametersJSON -ParametersJSON ($JSONParametersWithoutValue | ConvertTo-Json -Depth 99) -RequiredParametersList $RequiredParametersList
    } else {
        $orderedJSONParameters = @{}
    }
    # [2/5] Remove any JSON specific formatting
    $templateParameterObject = $orderedJSONParameters | ConvertTo-Json -Depth 99
    if ($templateParameterObject -ne '{}') {
        $contentInBicepFormat = $templateParameterObject -replace "'", "\'" # Update any [ "field": "[[concat('tags[', parameters('tagName'), ']')]"] to [ "field": "[[concat(\'tags[\', parameters(\'tagName\'), \']\')]"]
        $contentInBicepFormat = $contentInBicepFormat -replace '"', "'" # Update any [xyz: "xyz"] to [xyz: 'xyz']
        $contentInBicepFormat = $contentInBicepFormat -replace ',', '' # Update any [xyz: xyz,] to [xyz: xyz]
        $contentInBicepFormat = $contentInBicepFormat -replace "'(\w+)':", '$1:' # Update any  ['xyz': xyz] to [xyz: xyz]
        $contentInBicepFormat = $contentInBicepFormat -replace "'(.+.getSecret\('.+'\))'", '$1' # Update any  [xyz: 'xyz.GetSecret()'] to [xyz: xyz.GetSecret()]
        $bicepParamsArray = $contentInBicepFormat -split '\n'
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
        AllParametersList      = $JSONParameters.Keys
    }
    $commentedBicepParams = Add-BicepParameterTypeComment @splitInputObject

    return $commentedBicepParams
}

<#
.SYNOPSIS
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.DESCRIPTION
Generate 'Deployment examples' for the ReadMe out of the parameter files currently used to test the template

.PARAMETER ModuleRoot
Mandatory. The file path to the module's root

.PARAMETER FullModuleIdentifier
Mandatory. The full identifier of the module (i.e., ProviderNamespace + ResourceType)

.PARAMETER TemplateFileContent
Mandatory. The template file content object to crawl data from

.PARAMETER ReadMeFileContent
Mandatory. The readme file content array to update

.PARAMETER SectionStartIdentifier
Optional. The identifier of the 'outputs' section. Defaults to '## Deployment examples'

.PARAMETER addJson
Optional. A switch to control whether or not to add a ARM-JSON-Parameter file example. Defaults to true.

.PARAMETER addBicep
Optional. A switch to control whether or not to add a Bicep deployment example. Defaults to true.

.EXAMPLE
Set-DeploymentExamplesSection -ModuleRoot 'C:/key-vault/vault' -FullModuleIdentifier 'key-vault/vault' -TemplateFileContent @{ resource = @{}; ... } -ReadMeFileContent @('# Title', '', '## Section 1', ...)

Update the given readme file's 'Deployment Examples' section based on the given template file content
#>
function Set-DeploymentExamplesSection {

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
        [string] $SectionStartIdentifier = '## Deployment examples'
    )

    # Load used function(s)
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-ModuleTestFileList.ps1')

    # Process content
    $SectionContent = [System.Collections.ArrayList]@(
        'The following module usage examples are retrieved from the content of the files hosted in the module''s `.test` folder.',
        '   >**Note**: The name of each example is based on the name of the file from which it is taken.',
        '',
        '   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.',
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
        $moduleNamePascalCase = $moduleNameCamelCase.Replace($moduleNameCamelCase[0], $moduleNameCamelCase[0].ToString().ToUpper())
    } else {
        # Convert moduleName from kebab-case to camelCase
        $First, $Rest = $moduleName -Split '-', 2
        $moduleNameCamelCase = $First.Tolower() + (Get-Culture).TextInfo.ToTitleCase($Rest) -Replace '-'
        # Convert moduleName from kebab-case to PascalCase
        $moduleNamePascalCase = (Get-Culture).TextInfo.ToTitleCase($moduleName) -Replace '-'
    }

    $testFilePaths = Get-ModuleTestFileList -ModulePath $moduleRoot | ForEach-Object { Join-Path $moduleRoot $_ }
    $RequiredParametersList = $TemplateFileContent.parameters.Keys | Where-Object { $TemplateFileContent.parameters[$_].Keys -notcontains 'defaultValue' } | Sort-Object

    ############################
    ##   Process test files   ##
    ############################
    $pathIndex = 1
    foreach ($testFilePath in $testFilePaths) {

        # Read content
        $rawContentArray = Get-Content -Path $testFilePath
        $rawContent = Get-Content -Path $testFilePath -Encoding 'utf8' | Out-String

        # Format example header
        if ((Split-Path (Split-Path $testFilePath -Parent) -Leaf) -ne '.test') {
            $exampleTitle = Split-Path (Split-Path $testFilePath -Parent) -Leaf
        } else {
            $exampleTitle = ((Split-Path $testFilePath -LeafBase) -replace '\.', ' ') -replace ' parameters', ''
        }
        $textInfo = (Get-Culture -Name 'en-US').TextInfo
        $exampleTitle = $textInfo.ToTitleCase($exampleTitle)
        $SectionContent += @(
            '<h3>Example {0}: {1}</h3>' -f $pathIndex, $exampleTitle
        )

        ## ----------------------------------- ##
        ##   Handle by type (Bicep vs. JSON)   ##
        ## ----------------------------------- ##
        if ((Split-Path $testFilePath -Extension) -eq '.bicep') {

            # ------------------------- #
            #   Prepare Bicep to JSON   #
            # ------------------------- #

            # [1/6] Search for the relevant parameter start & end index
            $bicepTestStartIndex = ($rawContentArray | Select-String ("^module testDeployment '..\/.*main.bicep' = {$") | ForEach-Object { $_.LineNumber - 1 })[0]

            $bicepTestEndIndex = $bicepTestStartIndex
            do {
                $bicepTestEndIndex++
            } while ($rawContentArray[$bicepTestEndIndex] -ne '}')

            $rawBicepExample = $rawContentArray[$bicepTestStartIndex..$bicepTestEndIndex]

            # [2/6] Replace placeholders
            $serviceShort = ([regex]::Match($rawContent, "(?m)^param serviceShort string = '(.+)'\s*$")).Captures.Groups[1].Value

            $rawBicepExampleString = ($rawBicepExample | Out-String)
            $rawBicepExampleString = $rawBicepExampleString -replace '\$\{serviceShort\}', $serviceShort
            $rawBicepExampleString = $rawBicepExampleString -replace '\$\{namePrefix\}[-|\.|_]?', '' # Replacing with empty to not expose prefix and avoid potential deployment conflicts
            $rawBicepExampleString = $rawBicepExampleString -replace '(?m):\s*location\s*$', ': ''<location>'''

            # [3/6] Format header, remove scope property & any empty line
            $rawBicepExample = $rawBicepExampleString -split '\n'
            $rawBicepExample[0] = "module $moduleNameCamelCase './$fullModuleIdentifier/main.bicep' = {"
            $rawBicepExample = $rawBicepExample | Where-Object { $_ -notmatch 'scope: *' } | Where-Object { -not [String]::IsNullOrEmpty($_) }

            # [4/6] Extract param block
            $rawBicepExampleArray = $rawBicepExample -split '\n'
            $moduleDeploymentPropertyIndent = ([regex]::Match($rawBicepExampleArray[1], '^(\s+).*')).Captures.Groups[1].Value.Length
            $paramsStartIndex = ($rawBicepExampleArray | Select-String ("^[\s]{$moduleDeploymentPropertyIndent}params:[\s]*\{") | ForEach-Object { $_.LineNumber - 1 })[0] + 1
            if ($rawBicepExampleArray[$paramsStartIndex].Trim() -ne '}') {
                # Handle case where param block is empty
                $paramsEndIndex = ($rawBicepExampleArray[($paramsStartIndex + 1)..($rawBicepExampleArray.Count)] | Select-String "^[\s]{$moduleDeploymentPropertyIndent}\}" | ForEach-Object { $_.LineNumber - 1 })[0] + $paramsStartIndex
                $paramBlock = ($rawBicepExampleArray[$paramsStartIndex..$paramsEndIndex] | Out-String).TrimEnd()
            } else {
                $paramBlock = ''
                $paramsEndIndex = $paramsStartIndex
            }

            # [5/6] Convert Bicep parameter block to JSON parameter block to enable processing
            $conversionInputObject = @{
                BicepParamBlock = $paramBlock
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

                if ([String]::IsNullOrEmpty($paramBlock)) {
                    # Handle case where param block is empty
                    $formattedBicepExample = $rawBicepExample[0..($paramsStartIndex - 1)] + $rawBicepExample[($paramsEndIndex)..($rawBicepExample.Count)]
                } else {
                    $formattedBicepExample = $rawBicepExample[0..($paramsStartIndex - 1)] + ($bicepExample -split '\n') + $rawBicepExample[($paramsEndIndex + 1)..($rawBicepExample.Count)]
                }

                # Remove any dependsOn as it it test specific
                if ($detected = ($formattedBicepExample | Select-String "^\s{$moduleDeploymentPropertyIndent}dependsOn:\s*\[\s*$" | ForEach-Object { $_.LineNumber - 1 })) {
                    $dependsOnStartIndex = $detected[0]

                    # Find out where the 'dependsOn' ends
                    $dependsOnEndIndex = $dependsOnStartIndex
                    do {
                        $dependsOnEndIndex++
                    } while ($formattedBicepExample[$dependsOnEndIndex] -notmatch '^\s*\]\s*$')

                    # Cut the 'dependsOn' block out
                    $formattedBicepExample = $formattedBicepExample[0..($dependsOnStartIndex - 1)] + $formattedBicepExample[($dependsOnEndIndex + 1)..($formattedBicepExample.Count)]
                }

                # Build result
                $SectionContent += @(
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
                $SectionContent += @(
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
        } else {
            # ------------------------- #
            #   Prepare JSON to Bicep   #
            # ------------------------- #

            $rawContentHashtable = $rawContent | ConvertFrom-Json -Depth 99 -AsHashtable -NoEnumerate

            # First we need to check if we're dealing with classic JSON-Parameter file, or a deployment test file (which contains resource deployments & parameters)
            $isParameterFile = $rawContentHashtable.'$schema' -like '*deploymentParameters*'
            if (-not $isParameterFile) {
                # Case 1: Uses deployment test file (instead of parameter file).
                # [1/4]  Need to extract parameters. The target is to get an object which 1:1 represents a classic JSON-Parameter file (aside from KeyVault references)
                $testResource = $rawContentHashtable.resources | Where-Object { $_.name -like '*-test-*' }

                # [2/4] Build the full ARM-JSON parameter file
                $jsonParameterContent = [ordered]@{
                    '$schema'      = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
                    contentVersion = '1.0.0.0'
                    parameters     = $testResource.properties.parameters
                }
                $jsonParameterContent = ($jsonParameterContent | ConvertTo-Json -Depth 99).TrimEnd()

                # [3/4]  Remove 'externalResourceReferences' that are generated for Bicep's 'existing' resource references. Removing them will make the file more readable
                $jsonParameterContentArray = $jsonParameterContent -split '\n'
                foreach ($row in ($jsonParameterContentArray | Where-Object { $_ -like '*reference(extensionResourceId*' })) {
                    if ($row -match '\[.*reference\(extensionResourceId.+\.([a-zA-Z]+)\..*\].*"') {
                        # e.g. "[reference(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupName')), 'Microsoft.Resources/deployments', format('{0}-diagnosticDependencies', uniqueString(deployment().name, parameters('location')))), '2020-10-01').outputs.logAnalyticsWorkspaceResourceId.value]"
                        # e.g. "[format('{0}', reference(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupName')), 'Microsoft.Resources/deployments', format('{0}-paramNested', uniqueString(deployment().name, parameters('location')))), '2020-10-01').outputs.managedIdentityResourceId.value)]": {}
                        $expectedValue = $matches[1]
                    } elseif ($row -match '\[.*reference\(extensionResourceId.+\.([a-zA-Z]+).*\].*"') {
                        # e.g. "[reference(extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policySetDefinitions', format('dep-[[namePrefix]]-polSet-{0}', parameters('serviceShort'))), '2021-06-01').policyDefinitions[0].policyDefinitionReferenceId]"
                        $expectedValue = $matches[1]
                    } else {
                        throw "Unhandled case [$row] in file [$testFilePath]"
                    }

                    $toReplaceValue = ([regex]::Match($row, '"(\[.+)"')).Captures.Groups[1].Value

                    $jsonParameterContent = $jsonParameterContent.Replace($toReplaceValue, ('<{0}>' -f $expectedValue))
                }

                # [4/4] Removing template specific functions
                $jsonParameterContentArray = $jsonParameterContent -split '\n'
                for ($index = 0; $index -lt $jsonParameterContentArray.Count; $index++) {
                    if ($jsonParameterContentArray[$index] -match '(\s*"value"): "\[.+\]"') {
                        # e.g.
                        # "policyAssignmentId": {
                        #   "value": "[extensionResourceId(managementGroup().id, 'Microsoft.Authorization/policyAssignments', format('dep-[[namePrefix]]-psa-{0}', parameters('serviceShort')))]"
                        $prefix = $matches[1]

                        $headerIndex = $index
                        while (($jsonParameterContentArray[$headerIndex] -notmatch '.+": (\{|\[)+' -or $jsonParameterContentArray[$headerIndex] -like '*"value"*') -and $headerIndex -gt -1) {
                            $headerIndex--
                        }

                        $value = (($jsonParameterContentArray[$headerIndex] -split ':')[0] -replace '"').Trim()
                        $jsonParameterContentArray[$index] = ('{0}: "<{1}>"{2}' -f $prefix, $value, ($jsonParameterContentArray[$index].Trim() -like '*,' ? ',' : ''))
                    } elseif ($jsonParameterContentArray[$index] -match '(\s*)"([\w]+)": "\[.+\]"') {
                        # e.g. "name": "[format('{0}01', parameters('serviceShort'))]"
                        $jsonParameterContentArray[$index] = ('{0}"{1}": "<{1}>"{2}' -f $matches[1], $matches[2], ($jsonParameterContentArray[$index].Trim() -like '*,' ? ',' : ''))
                    } elseif ($jsonParameterContentArray[$index] -match '(\s*)"\[.+\]"') {
                        # -and $jsonParameterContentArray[$index - 1] -like '*"value"*') {
                        # e.g.
                        # "policyDefinitionReferenceIds": {
                        #  "value": [
                        #     "[reference(subscriptionResourceId('Microsoft.Authorization/policySetDefinitions', format('dep-[[namePrefix]]-polSet-{0}', parameters('serviceShort'))), '2021-06-01').policyDefinitions[0].policyDefinitionReferenceId]"
                        $prefix = $matches[1]

                        $headerIndex = $index
                        while (($jsonParameterContentArray[$headerIndex] -notmatch '.+": (\{|\[)+' -or $jsonParameterContentArray[$headerIndex] -like '*"value"*') -and $headerIndex -gt -1) {
                            $headerIndex--
                        }

                        $value = (($jsonParameterContentArray[$headerIndex] -split ':')[0] -replace '"').Trim()

                        $jsonParameterContentArray[$index] = ('{0}"<{1}>"{2}' -f $prefix, $value, ($jsonParameterContentArray[$index].Trim() -like '*,' ? ',' : ''))
                    }
                }
                $jsonParameterContent = $jsonParameterContentArray | Out-String
            } else {
                # Case 2: Uses ARM-JSON parameter file
                $jsonParameterContent = $rawContent.TrimEnd()
            }

            # --------------------- #
            #   Add Bicep example   #
            # --------------------- #
            if ($addBicep) {

                # [1/5] Get all parameters from the parameter object
                $JSONParametersHashTable = (ConvertFrom-Json $jsonParameterContent -AsHashtable -Depth 99).parameters

                # [2/5] Handle the special case of Key Vault secret references (that have a 'reference' instead of a 'value' property)
                # [2.1] Find all references and split them into managable objects
                $keyVaultReferences = $JSONParametersHashTable.Keys | Where-Object { $JSONParametersHashTable[$_].Keys -contains 'reference' }

                if ($keyVaultReferences.Count -gt 0) {
                    $keyVaultReferenceData = @()
                    foreach ($reference in $keyVaultReferences) {
                        $resourceIdElem = $JSONParametersHashTable[$reference].reference.keyVault.id -split '/'
                        $keyVaultReferenceData += @{
                            subscriptionId    = $resourceIdElem[2]
                            resourceGroupName = $resourceIdElem[4]
                            vaultName         = $resourceIdElem[-1]
                            secretName        = $JSONParametersHashTable[$reference].reference.secretName
                            parameterName     = $reference
                        }
                    }
                }

                # [2.2] Remove any duplicates from the referenced key vaults and build 'existing' Key Vault references in Bicep format from them.
                #        Also, add a link to the corresponding Key Vault 'resource' to each identified Key Vault secret reference
                $extendedKeyVaultReferences = @()
                $counter = 0
                foreach ($reference in ($keyVaultReferenceData | Sort-Object -Property 'vaultName' -Unique)) {
                    $counter++
                    $extendedKeyVaultReferences += @(
                        "resource kv$counter 'Microsoft.KeyVault/vaults@2019-09-01' existing = {",
                    ("  name: '{0}'" -f $reference.vaultName),
                    ("  scope: resourceGroup('{0}','{1}')" -f $reference.subscriptionId, $reference.resourceGroupName),
                        '}',
                        ''
                    )

                    # Add attribute for later correct reference
                    $keyVaultReferenceData | Where-Object { $_.vaultName -eq $reference.vaultName } | ForEach-Object {
                        $_['vaultResourceReference'] = "kv$counter"
                    }
                }

                # [3/5] Replace all 'references' with the link to one of the 'existing' Key Vault resources
                foreach ($parameterName in ($JSONParametersHashTable.Keys | Where-Object { $JSONParametersHashTable[$_].Keys -contains 'reference' })) {
                    $matchingTuple = $keyVaultReferenceData | Where-Object { $_.parameterName -eq $parameterName }
                    $JSONParametersHashTable[$parameterName] = "{0}.getSecret('{1}')" -f $matchingTuple.vaultResourceReference, $matchingTuple.secretName
                }

                # [4/5] Convert the JSON parameters to a Bicep parameters block
                $conversionInputObject = @{
                    JSONParameters         = $JSONParametersHashTable
                    RequiredParametersList = $null -ne $RequiredParametersList ? $RequiredParametersList : @()
                }
                $bicepExample = ConvertTo-FormattedBicep @conversionInputObject

                # [5/5] Create the final content block: That means
                # - the 'existing' Key Vault resources
                # - a 'module' header that mimics a module deployment
                # - all parameters in Bicep format
                $SectionContent += @(
                    '',
                    '<details>'
                    ''
                    '<summary>via Bicep module</summary>'
                    ''
                    '```bicep',
                    $extendedKeyVaultReferences,
                    "module $moduleNameCamelCase 'ts/modules:$(($FullModuleIdentifier -replace '\\|\/', '.').ToLower()):1.0.0 = {"
                    "  name: '`${uniqueString(deployment().name)}-$moduleNamePascalCase'"
                    '  params: {'
                    $bicepExample.TrimEnd(),
                    '  }'
                    '}'
                    '```',
                    '',
                    '</details>'
                    '<p>'
                )
            }

            # -------------------- #
            #   Add JSON example   #
            # -------------------- #
            if ($addJson) {

                # [1/2] Get all parameters from the parameter object and order them recursively
                $orderingInputObject = @{
                    ParametersJSON         = (($jsonParameterContent | ConvertFrom-Json).parameters | ConvertTo-Json -Depth 99)
                    RequiredParametersList = $null -ne $RequiredParametersList ? $RequiredParametersList : @()
                }
                $orderedJSONExample = Build-OrderedJSONObject @orderingInputObject

                # [2/2] Create the final content block
                $SectionContent += @(
                    '',
                    '<details>',
                    '',
                    '<summary>via JSON Parameter file</summary>',
                    '',
                    '```json',
                    $orderedJSONExample.TrimEnd(),
                    '```',
                    '',
                    '</details>'
                    '<p>'
                )
            }
        }

        $SectionContent += @(
            ''
        )

        $pathIndex++
    }

    ######################
    ##   Built result   ##
    ######################
    if ($SectionContent) {
        if ($PSCmdlet.ShouldProcess('Original file with new template references content', 'Merge')) {
            return Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $SectionContent -SectionStartIdentifier $SectionStartIdentifier
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
    if ($PSCmdlet.ShouldProcess('Original file with new parameters content', 'Merge')) {
        $updatedFileContent = Merge-FileWithNewContent -oldContent $ReadMeFileContent -newContent $newSectionContent -SectionStartIdentifier $SectionStartIdentifier -contentType 'none'
    }

    return $updatedFileContent
}

<#
.SYNOPSIS
Initialize the readme file

.DESCRIPTION
If no readme file exists, the initial content is generated (e.g., the skeleton of the section headers).
If a readme file does exist, its title and description are updated with whatever is documented as metadata in the template file.

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

    . (Join-Path $PSScriptRoot 'helper' 'Get-SpecsAlignedResourceName.ps1')
    . (Join-Path (Split-Path $PSScriptRoot -Parent) 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')


    $moduleName = $TemplateFileContent.metadata.name
    $moduleDescription = $TemplateFileContent.metadata.description
    $formattedResourceType = Get-SpecsAlignedResourceName -ResourceIdentifier $FullModuleIdentifier

    $inTemplateResourceType = (Get-NestedResourceList $TemplateFileContent).type | Select-Object -Unique | Where-Object {
        $_ -match "^$formattedResourceType$"
    }

    if (-not $inTemplateResourceType) {
        Write-Warning "No resource type like [$formattedResourceType] found in template. Falling back to it as identifier."
        $inTemplateResourceType = $formattedResourceType
    }

    if (-not (Test-Path $ReadMeFilePath) -or ([String]::IsNullOrEmpty((Get-Content $ReadMeFilePath -Raw)))) {

        $initialContent = @(
            "# $moduleName ``[$inTemplateResourceType]``",
            '',
            $moduleDescription,
            ''
            '## Resource Types',
            '',
            '## Parameters',
            '',
            '## Outputs'
        )
        $readMeFileContent = $initialContent
    } else {
        $readMeFileContent = Get-Content -Path $ReadMeFilePath -Encoding 'utf8'
        $readMeFileContent[0] = "# $moduleName ``[$inTemplateResourceType]``"

        # We want to inject the description right below the header and before the [Resource Types] section

        # Find start- and end-index of description section
        $startIndex = 1 # One after the readme header
        $endIndex = $startIndex

        while (-not ($endIndex -ge $readMeFileContent.Count - 1) -and -not $readMeFileContent[$endIndex].StartsWith('#')) {
            $endIndex++
        }

        # Build result
        $startContent = @(
            $readMeFileContent[0],
            ''
        )
        $newContent = @(
            $moduleDescription,
            ''
        )
        $endContent = $readMeFileContent[$endIndex..($readMeFileContent.Count - 1)]

        $readMeFileContent = (($startContent + $newContent + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    }

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

.PARAMETER TemplateFileContent
Optional. The template file content to process. If not provided, the template file content will be read from the TemplateFilePath file.
Using this property is useful if you already compiled the bicep template before invoking this function and want to avoid re-compiling it.

.PARAMETER ReadMeFilePath
Optional. The path to the readme to update. If not provided assumes a 'README.md' file in the same folder as the template

.PARAMETER SectionsToRefresh
Optional. The sections to update. By default it refreshes all that are supported.
Currently supports: 'Resource Types', 'Parameters', 'Outputs', 'Template references'

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:\main.bicep'

Update the readme in path 'C:\README.md' based on the bicep template in path 'C:\main.bicep'

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/network/load-balancer/main.bicep' -SectionsToRefresh @('Parameters', 'Outputs')

Generate the Module ReadMe only for specific sections. Updates only the sections `Parameters` & `Outputs`. Other sections remain untouched.

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/network/load-balancer/main.bicep' -TemplateFileContent @{...}

(Re)Generate the readme file for template 'loadBalancer' based on the content provided in the TemplateFileContent parameter

.EXAMPLE
Set-ModuleReadMe -TemplateFilePath 'C:/network/load-balancer/main.bicep' -ReadMeFilePath 'C:/differentFolder'

Generate the Module ReadMe files into a specific folder path

.EXAMPLE
$templatePaths = (Get-ChildItem 'C:/network' -Filter 'main.bicep' -Recurse).FullName
$templatePaths | ForEach-Object -Parallel { . '<PathToRepo>/utilities/tools/Set-ModuleReadMe.ps1' ; Set-ModuleReadMe -TemplateFilePath $_ }

Generate the Module ReadMe for any template in a folder path

.NOTES
The script autopopulates the Parameter Usage section of the ReadMe with the matching content in path './moduleReadMeSource'.
The content is added in case the given template has a parameter that matches the suffix of one of the files in that path.
To account for more parameter, just add another markdown file with the naming pattern 'resourceUsage-<parameterName>'
#>
function Set-ModuleReadMe {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [hashtable] $TemplateFileContent,

        [Parameter(Mandatory = $false)]
        [string] $ReadMeFilePath = (Join-Path (Split-Path $TemplateFilePath -Parent) 'README.md'),

        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'Resource Types',
            'Parameters',
            'Outputs',
            'CrossReferences',
            'Template references',
            'Navigation',
            'Deployment examples'
        )]
        [string[]] $SectionsToRefresh = @(
            'Resource Types',
            'Parameters',
            'Outputs',
            'CrossReferences',
            'Template references',
            'Navigation',
            'Deployment examples'
        )
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper' 'Merge-FileWithNewContent.ps1')

    # Check template & make full path
    $TemplateFilePath = Resolve-Path -Path $TemplateFilePath -ErrorAction Stop

    if (-not (Test-Path $TemplateFilePath -PathType 'Leaf')) {
        throw "[$TemplateFilePath] is no valid file path."
    }

    if (-not $TemplateFileContent) {
        if ((Split-Path -Path $TemplateFilePath -Extension) -eq '.bicep') {
            $templateFileContent = bicep build $TemplateFilePath --stdout | ConvertFrom-Json -AsHashtable
        } else {
            $templateFileContent = ConvertFrom-Json (Get-Content $TemplateFilePath -Encoding 'utf8' -Raw) -ErrorAction Stop -AsHashtable
        }
    }

    if (-not $templateFileContent) {
        throw "Failed to compile [$TemplateFilePath]"
    }

    $moduleRoot = Split-Path $TemplateFilePath -Parent
    $fullModuleIdentifier = $moduleRoot.Replace('\', '/').split('modules/')[-1]
    # Custom modules are modules having the same resource type but different properties based on the name
    # E.g., web/site/config--appsetting vs web/site/config--authsettingv2
    $customModuleSeparator = '--'
    if ($fullModuleIdentifier.Contains($customModuleSeparator)) {
        $fullModuleIdentifier = $fullModuleIdentifier.split($customModuleSeparator)[0]
    }

    # Initialize readme
    $inputObject = @{
        ReadMeFilePath       = $ReadMeFilePath
        FullModuleIdentifier = $FullModuleIdentifier
        TemplateFileContent  = $templateFileContent
    }
    $readMeFileContent = Initialize-ReadMe @inputObject

    # Set content
    if ($SectionsToRefresh -contains 'Resource Types') {
        # Handle [Resource Types] section
        # ===============================
        $inputObject = @{
            ReadMeFileContent   = $readMeFileContent
            TemplateFileContent = $templateFileContent
        }
        $readMeFileContent = Set-ResourceTypesSection @inputObject
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
        }
        $readMeFileContent = Set-CrossReferencesSection @inputObject
    }

    $testFolderPath = Join-Path $moduleRoot '.test'
    $hasTests = (Test-Path $testFolderPath) ? (Get-ChildItem -Path $testFolderPath -Recurse -Include 'main.test.*').count -gt 0 : $false
    if ($SectionsToRefresh -contains 'Deployment examples' -and $hasTests) {
        # Handle [Deployment examples] section
        # ===================================
        $inputObject = @{
            ModuleRoot           = $ModuleRoot
            FullModuleIdentifier = $fullModuleIdentifier
            ReadMeFileContent    = $readMeFileContent
            TemplateFileContent  = $templateFileContent
        }
        $readMeFileContent = Set-DeploymentExamplesSection @inputObject
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

    if ($PSCmdlet.ShouldProcess("File in path [$ReadMeFilePath]", 'Overwrite')) {
        Set-Content -Path $ReadMeFilePath -Value $readMeFileContent -Force -Encoding 'utf8'
        Write-Verbose "File [$ReadMeFilePath] updated" -Verbose
    }
}
