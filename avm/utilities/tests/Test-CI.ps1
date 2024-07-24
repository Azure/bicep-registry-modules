<#
.SYNOPSIS
This script executes either all CI-focused Pester tests, or a specific test file and generates a markdown with the test results.

.DESCRIPTION
This script executes either all CI-focused Pester tests, or a specific test file and generates a markdown with the test results.
It only considers test files in its current or sub-folders

.PARAMETER RepoRootPath
Optional. The root of the repository. Used to correctly resolve paths.

.PARAMETER BranchName
Optional. The branch to test for.

.PARAMETER GitHubRepository
Optional. The repository containing the test file. If provided it will be used to generate a URL to the exact line of the test.
For example: 'Azure/ResourceModules'

.PARAMETER TestFileRegex
Optional. The regex to use when searching for test files

.PARAMETER SkipOutput
Optional. Set if you don't want the script to generate the results markdown

.EXAMPLE
Test-CI

Invoke all CI-focused Pester tests and generate a markdown file with the test results.

.EXAMPLE
Test-CI -TestFileRegex '.*Ordered.*' -SkipOutput

Invoke all CI-focused Pester tests that match the regex '.*Ordered.*' skip the generation of the markdown file containing the test results.
#>
function Test-CI {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $RepoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName,

        [Parameter()]
        [string] $BranchName = (git branch --show-current),

        [Parameter(Mandatory )]
        [string] $GitHubRepository,

        [Parameter()]
        [string] $TestFileRegex = '.*',

        [Parameter()]
        [switch] $SkipOutput
    )

    # Load used functions
    . (Join-Path $RepoRootPath 'avm' 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Set-PesterGitHubOutput.ps1')

    $testFiles = (Get-ChildItem -Path (Join-Path $RepoRootPath 'avm' 'utilities' 'tests') -Recurse -File -Filter '*.tests.ps1').FullName | Where-Object {
        $_ -match $TestFileRegex
    }

    if (-not $testFiles) {
        Write-Warning "Skipping test execution as no test files matching the regex [$TestFileRegex] were found."
        return
    }

    # ------------------- #
    # Invoke Pester tests #
    # ------------------- #
    $pesterConfiguration = @{
        Run    = @{
            Container = New-PesterContainer -Path $testFiles -Data @{
                RepoRootPath = $RepoRootPath
            }
            PassThru  = $true
        }
        Output = @{
            Verbosity = 'Detailed'
        }
    }

    Write-Verbose 'Invoke test with' -Verbose
    Write-Verbose ($pesterConfiguration | ConvertTo-Json -Depth 4 | Out-String) -Verbose

    $testResults = Invoke-Pester -Configuration $pesterConfiguration

    if (-not $SkipOutput) {
        # ----------------------------------------- #
        # Create formatted Pester Test Results File #
        # ----------------------------------------- #

        $functionInput = @{
            RepoRootPath      = $RepoRootPath
            PesterTestResults = $testResults
            OutputFilePath    = Join-Path $RepoRootPath 'avm' 'utilities' 'tests' 'Pester-output.md'
            GitHubRepository  = $GitHubRepository
            BranchName        = $BranchName
        }

        Write-Verbose 'Invoke Pester formatting function with' -Verbose
        Write-Verbose ($functionInput | ConvertTo-Json -Depth 0 | Out-String) -Verbose

        Set-PesterGitHubOutput @functionInput -Verbose

        return $functionInput.OutputFilePath
    }
}




