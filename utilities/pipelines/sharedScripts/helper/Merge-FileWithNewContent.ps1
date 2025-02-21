#region Helper functions
<#
.SYNOPSIS
Find the array index that represents the end of the current section

.DESCRIPTION
Find the array index that represents the end of the current section
This index is identified by iterating through the subsequent array positions until a new chapter character (#) is found

.PARAMETER ReadMeFileContent
Mandatory. The content array to search in

.PARAMETER startIndex
Mandatory. The index to start the search from. Should usually be the current section's header index

.EXAMPLE
Get-EndIndex -ReadMeFileContent @('# Title', '', '## Section 1', ...) -startIndex = 13

Start from index '13' onward for the index that concludes the current section in the given content array
#>
function Get-EndIndex {

    param(
        [Parameter(Mandatory)]
        [object[]] $ReadMeFileContent,

        [Parameter(Mandatory)]
        [int] $startIndex,

        [Parameter(Mandatory = $false)]
        [ValidateSet('table', 'list', 'none')]
        [string] $ContentType = 'none'
    )

    # shift one further
    $endIndex = $startIndex + 1

    if ($endIndex -ge $readMeFileContent.Count) {
        # We are at the end of the file
        return $startIndex
    }

    switch ($ContentType) {
        'list' {
            # Identify end of list
            while ($ReadMeFileContent[$endIndex].StartsWith('- ') -and -not ($endIndex -ge $readMeFileContent.Count - 1) -and -not $ReadMeFileContent[$endIndex].StartsWith('#')) {
                $endIndex++
            }
        }
        'table' {
            # Identify end of table
            while ($ReadMeFileContent[$endIndex].StartsWith('|') -and -not ($endIndex -ge $readMeFileContent.Count - 1) -and -not $ReadMeFileContent[$endIndex].StartsWith('#')) {
                $endIndex++
            }
        }
        Default {
            # Identify next section
            while (-not $ReadMeFileContent[$endIndex].StartsWith('#') -and -not ($endIndex -ge $readMeFileContent.Count - 1)) {
                $endIndex++
            }
        }
    }

    if ($ReadMeFileContent[$endIndex].StartsWith('#')) {
        # We're already in the next section. Hence the section was empty
        $endIndex--
    }

    return $endIndex
}
#endregion

<#
.SYNOPSIS
Merge the sections prior & after the updated content with the new content into on connected content array

.DESCRIPTION
Merge the sections prior & after the updated content with the new content into on connected content array

.PARAMETER OldContent
Mandatory. The original content to update

.PARAMETER NewContent
Mandatory. The new content to merge into the original

.PARAMETER SectionStartIdentifier
Mandatory. The identifier/header to search for. If not found, the new section is added at the end of the content array

.PARAMETER ParentStartIdentifier
Optional. Tell the function that you're currently processing a sub-section (indented by one #) by providing the parent identifier

.EXAMPLE
Merge-FileWithNewContent -OldContent @('# Title', '', '## Section 1', ...) -NewContent @('# Title', '', '## Section 1', ...) -SectionStartIdentifier '## Resource Types'

Update the original content of the '## Resource Types' section with the newly provided
#>
function Merge-FileWithNewContent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [object[]] $OldContent,

        [Parameter(Mandatory)]
        [object[]] $newContent,

        [Parameter(Mandatory = $false)]
        [string] $ParentStartIdentifier = '',

        [Parameter(Mandatory)]
        [string] $SectionStartIdentifier,

        [Parameter(Mandatory = $false)]
        [ValidateSet('table', 'list', 'none', 'nextH2')]
        [string] $ContentType = 'none'
    )

    $startIndex = 0
    while (-not ($OldContent[$startIndex] -eq $SectionStartIdentifier) -and -not ($startIndex -ge $OldContent.Count - 1)) {
        $startIndex++
    }

    # In case we're processing a child section (indented by one #) we should search until the main section starts / end of file is reached
    if ($startIndex -eq $OldContent.Count - 1 -and -not [String]::IsNullOrEmpty($ParentStartIdentifier)) {
        $level = $ParentStartIdentifier.TrimStart().Split(' ')[0]

        $parentSectionStartIndex = 0
        while (-not ($OldContent[$parentSectionStartIndex] -like "*$ParentStartIdentifier") -and -not ($parentSectionStartIndex -ge $OldContent.Count - 1)) {
            $parentSectionStartIndex++
        }

        $startIndex = $parentSectionStartIndex + 1
        while (-not ($OldContent[$startIndex] -like "$level *") -and -not ($startIndex -ge $OldContent.Count - 1)) {
            $startIndex++
        }

        if ($OldContent[$startIndex] -like "$level *") {
            $startIndex--
        }
    }


    if ($startIndex -eq $OldContent.Count - 1 -and [String]::IsNullOrEmpty($ParentStartIdentifier)) {
        # Section is not existing (end of file)
        $startContent = $OldContent
        if ($OldContent[$startIndex] -ne $SectionStartIdentifier ) {
            # Add newline if necessary
            if (-not [String]::IsNullOrEmpty($OldContent[$startIndex])) {
                $startContent += @('')
            }
            # Add section header
            $startContent = $startContent + @($SectionStartIdentifier)
        }
        $endContent = @()
    } else {
        switch ($ContentType) {
            'table' {
                $tableStartIndex = $startIndex + 1
                while (-not $OldContent[$tableStartIndex].StartsWith('|') -and -not ($tableStartIndex -ge $OldContent.count) -and -not ($OldContent[$tableStartIndex].StartsWith('#'))) {
                    $tableStartIndex++
                }
                if ($OldContent[$tableStartIndex].StartsWith('#')) {
                    # Seems like there is no table yet
                    $tableStartIndex = $startIndex + 1
                }

                $startContent = $OldContent[0..($tableStartIndex - 1)]

                if ($startIndex -eq $ReadMeFileContent.Count - 1) {
                    # Not found section until end of file. Assuming it does not exist
                    $endContent = @()
                    if ($ReadMeFileContent[$startIndex] -notcontains $SectionStartIdentifier) {
                        $newContent = @('', $SectionStartIdentifier) + $newContent
                    }
                } else {
                    $endIndex = Get-EndIndex -ReadMeFileContent $OldContent -startIndex $tableStartIndex -ContentType $ContentType
                    if ($endIndex -ne $OldContent.Count - 1) {
                        $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                    }
                }
            }
            'list' {
                $listStartIndex = $startIndex + 1
                while (-not $OldContent[$listStartIndex].StartsWith('- ') -and -not ($listStartIndex -ge $OldContent.count) -and -not ($OldContent[$listStartIndex].StartsWith('# '))) {
                    $listStartIndex++
                }
                if ($OldContent[$listStartIndex].StartsWith('#')) {
                    # Seems like there is no table yet
                    $listStartIndex = $listStartIndex + 1
                }

                $startContent = $OldContent[0..($listStartIndex - 1)]

                if ($startIndex -eq $ReadMeFileContent.Count - 1) {
                    # Not found section until end of file. Assuming it does not exist
                    $endContent = @()
                    if ($ReadMeFileContent[$startIndex] -notcontains $SectionStartIdentifier) {
                        $newContent = @('', $SectionStartIdentifier) + $newContent
                    }
                } else {
                    $endIndex = Get-EndIndex -ReadMeFileContent $OldContent -startIndex $listStartIndex -ContentType $ContentType
                    if ($endIndex -ne $OldContent.Count - 1) {
                        $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                    }
                }
            }
            'none' {
                if ($OldContent[$startIndex + 1] -like "$level *" -and -not [String]::IsNullOrEmpty($ParentStartIdentifier)) {
                    # section was not found - let's insert it at the end of the sub-section
                    $startContent = $OldContent[0..($startIndex)]
                    $newContent = @($SectionStartIdentifier, '') + $newContent
                    $endContent = $OldContent[($startIndex + 1)..($OldContent.Count - 1)]
                } else {
                    # section was found
                    $startContent = $OldContent[0..($startIndex)]
                    $endIndex = Get-EndIndex -ReadMeFileContent $OldContent -startIndex $startIndex -ContentType $ContentType
                    if ($endIndex -ne $OldContent.Count - 1) {
                        $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                    }
                }
            }
            'nextH2' {
                $endIndex = $startIndex + 1

                while (-not $OldContent[$endIndex].StartsWith('## ') -and -not (($endIndex + 1) -ge $OldContent.count)) {
                    $endIndex++
                }

                $startContent = $OldContent[0..($startIndex)]
                if ($endIndex -ne $OldContent.Count - 1) {
                    $endContent = $OldContent[$endIndex..($OldContent.Count - 1)]
                }
            }
            Default {}
        }
    }

    # Add a little space
    if ($startContent -and (-not [String]::IsNullOrEmpty($startContent[-1]))) { $startContent += @('') }
    if ($endContent -and (-not [String]::IsNullOrEmpty($endContent[0]))) { $endContent = @('') + $endContent }

    # Build result
    $newContent = (($startContent + $newContent + $endContent) | Out-String).TrimEnd().Replace("`r", '').Split("`n")
    return $newContent
}
