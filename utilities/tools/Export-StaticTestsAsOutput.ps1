#region helper
<#
.SYNOPSIS
Get an outline of all Pester test cases implemented in the given test file, in markdown format

.DESCRIPTION
Get an outline of all Pester test cases implemented in the given test file
The output is returned as Markdown

.PARAMETER TestFilePath
Mandatory. The path to the test file to get the content from.

.PARAMETER OutputFilePath
Mandatory. The path to the output file to write the content to.

.PARAMETER Force
Optional. Overwrite the output file if it already exists.

.EXAMPLE
Export-TestsAsMarkdown -TestFilePath 'path/to/module.tests.ps1' -OutputFilePath 'path/to/testmd.md' -Force

Get an outline of all Pester tests implemented in the test file 'path/to/module.tests.ps1' and export it to the file 'path/to/testmd.md' in markdown format, overwriting it if it already exists.
#>
function Export-TestsAsMarkdown {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TestFilePath,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath,

        [Parameter(Mandatory = $false)]
        [switch] $Force
    )

    $content = Get-Content $TestFilePath

    $relevantContent = [System.Collections.ArrayList]@()
    foreach ($line in $content) {
        if ($line -match "^\s*Describe '(.*?)'.*$") {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $relevantContent += "- **$formatted**"
        } elseif ( $line -match "^\s*Context '(.*?)'.*$" ) {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $relevantContent += "  - **$formatted**"
        } elseif ( $line -match "^\s*It '(.*?)'.*$" ) {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $relevantContent += "    1. $formatted"
        }
    }

    if ($OutputFilePath) {
        if ($PSCmdlet.ShouldProcess("markdown to path [$OutputFilePath]", 'Export')) {
            Set-Content -Path $OutputFilePath -Value $relevantContent -Force:$Force
            Write-Verbose "File [$OutputFilePath] updated" -Verbose
        }
    }

    return $relevantContent
}
#endregion

#region helper
<#
.SYNOPSIS
Get an outline of all Pester test cases implemented in the given test file in CSV format

.DESCRIPTION
Get an outline of all Pester test cases implemented in the given test file
The output is returned as CSV

.PARAMETER TestFilePath
Mandatory. The path to the test file to get the content from.

.PARAMETER OutputFilePath
Mandatory. The path to the output file to write the content to.

.PARAMETER Force
Optional. Overwrite the output file if it already exists.

.EXAMPLE
Export-TestsAsCsv -TestFilePath 'path/to/module.tests.ps1' -OutputFilePath 'path/to/test.csv' -Force

Get an outline of all Pester tests implemented in the test file 'path/to/module.tests.ps1' and export it to the file 'path/to/testmd.md' in markdown format, overwriting it if it already exists.
#>
function Export-TestsAsCsv {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TestFilePath,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath,

        [Parameter(Mandatory = $false)]
        [switch] $Force
    )

    $content = Get-Content $TestFilePath

    $relevantContent = [System.Collections.ArrayList]@()
    foreach ($line in $content) {
        if ($line -match "^\s*Describe '(.*?)'.*$") {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $describe = $formatted
        } elseif ( $line -match "^\s*Context '(.*?)'.*$" ) {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $context = $formatted
        } elseif ( $line -match "^\s*It '(.*?)'.*$" ) {
            $formatted = $Matches[1]
            $formatted = (($formatted -split '\s*\[<.+?>\]\s*') -join ' ').Trim()
            $it = $formatted
            $Record = [ordered] @{
                'Describe' = $describe
                'Context'  = $context
                'It'       = $it
            }
            $testObj = New-Object -Type PSObject -Property $Record
            $relevantContent += $testObj
        }
    }

    if ($OutputFilePath) {
        if ($PSCmdlet.ShouldProcess("csv to path [$OutputFilePath]", 'Export')) {
            $relevantContent | Export-Csv -Path $OutputFilePath -Force:$Force #-NoTypeInformation
            Write-Verbose "File [$OutputFilePath] updated" -Verbose
        }
    }
    return $relevantContent
}
#endregion

<#
.SYNOPSIS
Export Pester tests from a given test file to a specified output format.

.DESCRIPTION
This function extracts Pester tests from a specified test file and exports them to a desired output format (CSV or Markdown). The output can be written to a file or returned as an array of strings.

.PARAMETER TestFilePath
Mandatory. The path to the test file to get the content from.

.PARAMETER OutputFormat
Mandatory. The output format to use. Valid values are 'csv' and 'md'.

.PARAMETER OutputFilePath
Optional. The path to the output file to write the content to. If not provided, the output will be returned as an array of strings.

.PARAMETER Force
Optional. Overwrite the output file if it already exists.

.EXAMPLE
Export-StaticTestsAsOutput -TestFilePath 'path/to/module.tests.ps1' -OutputFormat 'md' -OutputFilePath 'path/to/testmd.md' -Force

Get an outline of all Pester tests implemented in the test file 'path/to/module.tests.ps1' and export it to the file 'path/to/testmd.md' in markdown format, overwriting it if it already exists.

.EXAMPLE
Export-StaticTestsAsOutput -TestFilePath 'path/to/module.tests.ps1' -OutputFormat 'csv' -OutputFilePath 'path/to/testcsv.csv'

Get an outline of all Pester tests implemented in the test file 'path/to/module.tests.ps1' and export it to the file 'path/to/testcsv.csv' in CSV format, without overwriting it if it already exists.
#>
function Export-StaticTestsAsOutput {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TestFilePath,

        [Parameter(Mandatory = $true)]
        [ValidateSet('csv', 'md')]
        [string] $OutputFormat,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath,

        [Parameter(Mandatory = $false)]
        [switch] $Force
    )

    Write-Verbose "Checking test file path: $TestFilePath" -Verbose
    if (-not (Test-Path -Path $TestFilePath)) {
        throw "Test file path '$TestFilePath' does not exist."
    }
    if ($OutputFilePath) {
        if (-not $Force) {
            Write-Verbose "Checking output file path: $OutputFilePath" -Verbose
            if (Test-Path -Path $OutputFilePath) {
                throw "Output file path '$OutputFilePath' already exists. To overwrite it use the -Force switch."
            }
        }
        Write-Verbose "Checking output file directory: $(Split-Path -Path $OutputFilePath)" -Verbose
        if (-not (Test-Path -Path (Split-Path -Path $OutputFilePath))) {
            throw "Output file parent directory '$(Split-Path -Path $OutputFilePath)' does not exist."
        }
    }

    switch ($OutputFormat) {
        'md' {
            $relevantContent = Export-TestsAsMarkdown -TestFilePath $TestFilePath -OutputFilePath $OutputFilePath -Force:$Force
        }
        'csv' {
            $relevantContent = Export-TestsAsCsv -TestFilePath $TestFilePath -OutputFilePath $OutputFilePath -Force:$Force
        }
    }

    return $relevantContent
}
