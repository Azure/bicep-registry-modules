
function Test-CI {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $RepoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.FullName,

        [Parameter()]
        [string] $BranchName = (git branch --show-current),

        [Parameter()]
        [string] $TestFile = '.*',

        [Parameter()]
        [string] $TestCase # TODO: Add support
    )

    # Load used functions
    . (Join-Path $RepoRootPath 'avm' 'utilities' 'pipelines' 'staticValidation' 'compliance' 'Set-PesterGitHubOutput.ps1')

    $testFiles = (Get-ChildItem -Path (Join-Path $RepoRootPath 'avm' 'utilities' 'tests') -Recurse -File -Filter '*.tests.ps1').FullName | Where-Object {
        $_ -match $TestFile
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

    # ----------------------------------------- #
    # Create formatted Pester Test Results File #
    # ----------------------------------------- #

    $functionInput = @{
        RepoRootPath      = $RepoRootPath
        PesterTestResults = $testResults
        OutputFilePath    = Join-Path $RepoRootPath 'avm' 'utilities' 'tests' 'Pester-output.md'
        GitHubRepository  = $RepoRootPath
        BranchName        = $BranchName
    }

    Write-Verbose 'Invoke Pester formatting function with' -Verbose
    Write-Verbose ($functionInput | ConvertTo-Json -Depth 0 | Out-String) -Verbose

    Set-PesterGitHubOutput @functionInput -Verbose

    return $functionInput.OutputFilePath
}



