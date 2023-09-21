<#
.SYNOPSIS
Parse a Pester output containing checks & results and generate formatted markdown file out of it.

.DESCRIPTION
Parse a Pester output containing checks & results and generate formatted markdown file out of it.

.PARAMETER PesterTestResults
Mandatory. The Pester tests results to parse. Can be fetched by running Pester with the `-PassThru` parameter. For example:

@{
    Containers            = '[+] C:/ResourceModules/utilities/pipelines/staticValidation/module.tests.ps1'
    Result                = 'Passed'
    FailedCount           = 0
    FailedBlocksCount     = 0
    FailedContainersCount = 0
    PassedCount           = 36
    SkippedCount          = 1
    NotRunCount           = 0
    TotalCount            = 37
    Duration              = '00:00:41.8816077'
    Executed              = true
    ExecutedAt            = '2023-04-01T12:27:19.5807422+02:00'
    Version               = '5.4.0'
    PSVersion             = '7.3.3'
    PSBoundParameters     = 'System.Management.Automation.PSBoundParametersDictionary'
    Plugins               = null
    PluginConfiguration   = null
    PluginData            = null
    Configuration         = 'PesterConfiguration'
    DiscoveryDuration     = '00:00:16.1489218'
    UserDuration          = '00:00:22.4714890'
    FrameworkDuration     = '00:00:03.2611969'
    Failed                = ''
    FailedBlocks          = ''
    FailedContainers      = ''
    Passed                = '[+] [key-vault/vault/secret] Module should contain a [main.json/main.bicep] file. [+] ...'
    NotRun                = ''
    Tests                 = '[+] [key-vault/vault/secret] Module should contain a [main.json/main.bicep] file. [+] ...'
    CodeCoverage          = null
}

.PARAMETER OutputFilePath
Optional. The path to the formatted .md file to be created.

.PARAMETER GitHubRepository
Optional. The repository containing the test file. If provided it will be used to generate a URL to the exact line of the test.
For example: 'Azure/ResourceModules'

.PARAMETER BranchName
Optional. The branch the pipeline was triggered from. If provided it will be used to generate a URL to the exact line of the test.
For example: 'users/carml/testBranch'

.EXAMPLE
Set-PesterGitHubOutput -PesterTestResults @{...}

Generate a markdown file [output.md] in the current folder, out of the Pester test results input, listing all passed and failed tests.

.EXAMPLE
Set-PesterGitHubOutput -PesterTestResults @{...} -OutputFilePath 'C:/Pester-output.md' -GitHubRepository 'Azure/ResourceModules' -BranchName 'users/carml/testBranch'

Generate a markdown file [C:/Pester-output.md], out of the Pester test results input, including links to the exact test line numbers in the originating GitHub repository [Azure/ResourceModules] in branch [users/carml/testBranch].
#>
function Set-PesterGitHubOutput {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject] $PesterTestResults,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath = './output.md',

        [Parameter(Mandatory = $false)]
        [string] $GitHubRepository,

        [Parameter(Mandatory = $false)]
        [string] $BranchName
    )

    $passedTests = $PesterTestResults.Passed
    $failedTests = $PesterTestResults.Failed
    $skippedTests = $PesterTestResults.Skipped

    Write-Verbose ('Formatting [{0}] passed tests' -f $passedTests.Count)
    Write-Verbose ('Formatting [{0}] failed tests' -f $failedTests.Count)
    Write-Verbose ('Formatting [{0}] skipped tests' -f $skippedTests.Count)

    ######################
    # Set output content #
    ######################

    # Header
    $fileContent = [System.Collections.ArrayList]@(
        '# Pester validation summary ',
        ''
    )

    ## Header table
    $fileContent += [System.Collections.ArrayList]@(
        '| Total No. of Processed Tests| Passed Tests :white_check_mark: | Failed Tests :x: | Skipped Tests :paperclip: |',
        '| :-- | :-- | :-- | :-- |'
            ('| {0} | {1} | {2} | {3} |' -f $PesterTestResults.TotalCount, $passedTests.count , $failedTests.count, $skippedTests.count),
        ''
    )

    ######################
    ##   Failed Tests   ##
    ######################
    Write-Verbose 'Adding failed tests'
    $fileContent += [System.Collections.ArrayList]@(
        '',
        '<details>',
        '<summary>List of failed Tests</summary>',
        ''
    )

    if ($failedTests.Count -gt 0) {
        Write-Verbose 'Adding failed tests'
        $fileContent += [System.Collections.ArrayList]@(
            '| Name | Error | Source |',
            '| :-- | :-- | :-- |'
        )
        foreach ($failedTest in ($failedTests | Sort-Object -Property { $PSItem.ExpandedName })) {

            $intermediateNameElements = $failedTest.Path
            $intermediateNameElements[-1] = '**{0}**' -f $failedTest.ExpandedName
            $testName = (($intermediateNameElements -join ' / ' | Out-String) -replace '\|', '\|').Trim()

            $errorTestLine = $failedTest.ErrorRecord.TargetObject.Line
            $errorTestFile = (Split-Path $failedTest.ErrorRecord.TargetObject.File -Leaf).Trim()
            $errorMessage = $failedTest.ErrorRecord.TargetObject.Message.Trim() -replace '\n', '<br>' # Replace new lines with <br> to enable line breaks in markdown

            $testReference = '{0}:{1}' -f $errorTestFile, $errorTestLine
            if (-not [String]::IsNullOrEmpty($GitHubRepository) -and -not [String]::IsNullOrEmpty($BranchName)) {
                # Creating URL to test file to enable users to 'click' on it
                $testReference = "[$testReference](https://github.com/$GitHubRepository/blob/$BranchName/utilities/pipelines/staticValidation/module.tests.ps1#L$errorTestLine)"
            }

            $fileContent += '| {0} | {1} | <code>{2}</code> |' -f $testName, $errorMessage, $testReference
        }
    } else {
        $fileContent += ('No tests failed.')
    }

    $fileContent += [System.Collections.ArrayList]@(
        '',
        '</details>',
        ''
    )

    ######################
    ##   Passed Tests   ##
    ######################
    Write-Verbose 'Adding passed tests'
    $fileContent += [System.Collections.ArrayList]@(
        '',
        '<details>',
        '<summary>List of passed Tests</summary>',
        ''
    )

    if (($passedTests.Count -gt 0)) {

        $fileContent += [System.Collections.ArrayList]@(
            '| Name | Source |',
            '| :-- | :-- |'
        )
        foreach ($passedTest in ($passedTests | Sort-Object -Property { $PSItem.ExpandedName }) ) {

            $intermediateNameElements = $passedTest.Path
            $intermediateNameElements[-1] = '**{0}**' -f $passedTest.ExpandedName
            $testName = (($intermediateNameElements -join ' / ' | Out-String) -replace '\|', '\|').Trim()

            $testLine = $passedTest.ScriptBlock.StartPosition.StartLine
            $testFile = (Split-Path $passedTest.ScriptBlock.File -Leaf).Trim()

            $testReference = '{0}:{1}' -f $testFile, $testLine
            if (-not [String]::IsNullOrEmpty($GitHubRepository) -and -not [String]::IsNullOrEmpty($BranchName)) {
                # Creating URL to test file to enable users to 'click' on it
                $testReference = "[$testReference](https://github.com/$GitHubRepository/blob/$BranchName/utilities/pipelines/staticValidation/module.tests.ps1#L$testLine)"
            }

            $fileContent += '| {0} | <code>{1}</code> |' -f $testName, $testReference
        }
    } else {
        $fileContent += ('No tests passed.')
    }

    $fileContent += [System.Collections.ArrayList]@(
        '',
        '</details>',
        ''
    )

    #######################
    ##   Skipped Tests   ##
    #######################

    Write-Verbose 'Adding skipped tests'
    $fileContent += [System.Collections.ArrayList]@(
        '',
        '<details>',
        '<summary>List of skipped Tests</summary>',
        ''
    )

    if ($skippedTests.Count -gt 0) {

        $fileContent += [System.Collections.ArrayList]@(
            '| Name | Reason | Source |',
            '| :-- | :-- | :-- |'
        )
        foreach ($skippedTest in ($skippedTests | Sort-Object -Property { $PSItem.ExpandedName }) ) {

            $intermediateNameElements = $skippedTest.Path
            $intermediateNameElements[-1] = '**{0}**' -f $skippedTest.ExpandedName
            $testName = (($intermediateNameElements -join ' / ' | Out-String) -replace '\|', '\|').Trim()

            $reason = ('Test {0}' -f $skippedTest.ErrorRecord.Exception.Message -replace '\|', '\|').Trim()

            $testLine = $passedTest.ScriptBlock.StartPosition.StartLine
            $testFile = (Split-Path $passedTest.ScriptBlock.File -Leaf).Trim()

            $testReference = '{0}:{1}' -f $testFile, $testLine
            if (-not [String]::IsNullOrEmpty($GitHubRepository) -and -not [String]::IsNullOrEmpty($BranchName)) {
                # Creating URL to test file to enable users to 'click' on it
                $testReference = "[$testReference](https://github.com/$GitHubRepository/blob/$BranchName/utilities/pipelines/staticValidation/module.tests.ps1#L$testLine)"
            }

            $fileContent += '| {0} | {1} | <code>{2}</code> |' -f $testName, $reason, $testReference
        }
    } else {
        $fileContent += ('No tests were skipped.')
    }

    $fileContent += [System.Collections.ArrayList]@(
        '',
        '</details>',
        ''
    )

    if ($PSCmdlet.ShouldProcess("Test results file in path [$OutputFilePath]", 'Create')) {
        $null = New-Item -Path $OutputFilePath -Force -Value ($fileContent | Out-String)
    }
    Write-Verbose "Create results file [$outputFilePath]"
}
