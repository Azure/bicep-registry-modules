<#
.SYNOPSIS
Parse an input csv file containing the output of the PSRule pre-flight checks and generate formatted markdown file out of it.

.DESCRIPTION
Parse input csv file containing the output of the PSRule pre-flight checks and generate formatted markdown file out of it.

.PARAMETER inputFilePath
Mandatory. The path to the output file created by PSRule in csv format.

.PARAMETER outputFilePath
Optional. The path to the formatted .md file to be created.

.PARAMETER skipPassedRulesReport
Optional. Whether to add the detail of passed PSRule to the output markdown file or to limit the list to the failed ones.

.EXAMPLE
Set-PSRuleGitHubOutput -inputFilePath 'C:/PSRule-output.csv'

Generate a markdown file 'output.md' in the current folder, out of the 'C:/PSRule-output.csv' input, listing all passed and failed rules.

.EXAMPLE
Set-PSRuleGitHubOutput -inputFilePath 'C:/PSRule-output.csv' -outputFilePath 'C:/PSRule-output.md' -skipPassedRulesReport

Generate a markdown file 'C:/PSRule-output.md', out of the 'C:/PSRule-output.csv' input, listing only the failed rules.
#>
function Set-PSRuleGitHubOutput {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [String] $InputFilePath,

        [Parameter(Mandatory = $false)]
        [string] $OutputFilePath = './output.md',

        [Parameter(Mandatory = $false)]
        [switch] $SkipPassedRulesReport
    )

    ###########################################
    # Import CSV output and filter by results #
    ###########################################

    if (-not (Test-Path $inputFilePath)) {
        Write-Warning ('Input File [{0}] not found' -f $inputFilePath)
        return ''
    } else {
        $results = Import-Csv -Path $inputFilePath
        $passedRules += $results | Where-Object { $_.Outcome -EQ 'Pass' } | Sort-Object -Culture 'en-US' -Property 'TargetName', 'RuleName' -Unique
        $failedRules += $results | Where-Object { $_.Outcome -EQ 'Fail' } | Sort-Object -Culture 'en-US' -Property 'TargetName', 'RuleName' -Unique

        ######################
        # Set output content #
        ######################

        # Header
        $header = [System.Collections.ArrayList]@(
            '# PSRule pre-flight validation summary ',
            ''
        )
        Out-File -FilePath $outputFilePath -NoClobber -InputObject $header

        if ($failedRules.Count -eq 0) {
            # No failure content
            $noFailuresContent = ('## :rocket: All [{0}] rules passed, YAY! :rocket:' -f $results.Count)
            Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $noFailuresContent
        } else {
            # Failure content

            ## Header table
            $headerTable = [System.Collections.ArrayList]@(
                '| Total No. of Processed Rules| Passed Rules :white_check_mark: | Failed Rules :x: |',
                '| :-- | :-- | :-- |'
            ('| {0} | {1} | {2} |' -f $results.Count, $passedRules.Count , $failedRules.Count),
                ''
            )
            Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $headerTable

            ## List of failed rules
            $failContent = [System.Collections.ArrayList]@(
                '',
                '<details>',
                '<summary>List of Failed Rules</summary>',
                '',
                '## Failed Rules',
                '',
                '| RuleName | TargetName |  Synopsis |',
                '| :-- | :-- | :-- |'
            )
            foreach ($content in $failedRules ) {
                # Shorten the target name for deployment resoure type
                if ($content.TargetType -eq 'Microsoft.Resources/deployments') {
                    $content.TargetName = $content.TargetName.replace('/home/runner/work/bicep-registry-modules/bicep-registry-modules/avm/', '')
                }

                # Build hyperlinks to PSRule documentation for the rules
                $TemplatesBaseUrl = 'https://azure.github.io/PSRule.Rules.Azure/en/rules'
                try {
                    $PSRuleReferenceUrl = '{0}/{1}' -f $TemplatesBaseUrl, $content.RuleName
                    $null = Invoke-WebRequest -Uri $PSRuleReferenceUrl
                    $resourceLink = '[{0}]({1})' -f $content.RuleName, $PSRuleReferenceUrl
                } catch {
                    Write-Warning ('Unable to build url for rule [{0}]' -f $content.RuleName)
                    $resourceLink = $content.RuleName
                }
                $failContent += ('| {0} | `{1}` | {2} | ' -f $resourceLink, $content.TargetName, $content.Synopsis)
            }
            $failContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
            # Append to output
            Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $failContent
        }

        if (($passedRules.Count -gt 0) -and -not $skipPassedRulesReport) {
            # List of passed rules
            $passContent = [System.Collections.ArrayList]@(
                '',
                '<details>',
                '<summary>List of Passed Rules</summary>',
                '',
                '## Passed Rules',
                '',
                '| RuleName | TargetName |  Synopsis |',
                '| :-- | :-- |  :-- |'
            )
            foreach ($content in $passedRules ) {
                # Shorten the target name for deployment resoure type
                if ($content.TargetType -eq 'Microsoft.Resources/deployments') {
                    $content.TargetName = $content.TargetName.replace('/home/runner/work/bicep-registry-modules/bicep-registry-modules/avm/', '')
                }

                # Build hyperlinks to PSRule documentation for the rules
                $TemplatesBaseUrl = 'https://azure.github.io/PSRule.Rules.Azure/en/rules'
                try {
                    $PSRuleReferenceUrl = '{0}/{1}' -f $TemplatesBaseUrl, $content.RuleName
                    $null = Invoke-WebRequest -Uri $PSRuleReferenceUrl
                    $resourceLink = '[{0}]({1})' -f $content.RuleName, $PSRuleReferenceUrl
                } catch {
                    Write-Warning ('Unable to build url for rule [{0}]' -f $content.RuleName)
                    $resourceLink = $content.RuleName
                }
                $passContent += ('| {0} | `{1}` | {2} |  ' -f $resourceLink, $content.TargetName, $content.Synopsis)

            }
            $passContent += [System.Collections.ArrayList]@(
                '',
                '</details>',
                ''
            )
            # Append to output
            Out-File -FilePath $outputFilePath -Append -NoClobber -InputObject $passContent
        }
    }
}
