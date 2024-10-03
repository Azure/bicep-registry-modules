<#
.SYNOPSIS
Based on a `git diff`, calculate which stages to run in the pipeline

.DESCRIPTION
Based on a `git diff`, calculate which stages to run in the pipeline
- If any files that justify a deployment test have changed, run all tests (e.g., bicep files, ARM template files)
- Else, if any files that justify a static test have changed, run static tests only (e.g., markdown files, unit test files)
- Else run no tests

.PARAMETER Commit
Mandatory. The commit to compare

.PARAMETER ModulePath
Mandatory. The path to filter changed files down to

.EXAMPLE
Get-CalculatedJobControlObject -Commit 'e1f088f7f807db040e79e17d28a656d40dbb2cd8' -ModulePath 'avm/res/key-vault/vault'

Calculate which pipeline stages should be run based on the currently changed files.
#>
function Get-CalculatedJobControlObject {

    [CmdletBinding()]
    param (
        # [Parameter(Mandatory = $true)]
        # [string] $Commit,

        [Parameter(Mandatory = $true)]
        [string] $ModulePath,

        [Parameter(Mandatory = $true)]
        [string] $GitHubEvent,

        [Parameter(Mandatory = $false)]
        [hashtable] $WorkflowParameters,

        [Parameter(Mandatory = $true)]
        [string] $WorkflowPath,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.FullName
    )

    # Loading helper function
    . (Join-Path $repoRoot 'avm' 'utilities' 'pipelines' 'workflows' 'Get-GitHubWorkflowDefaultInput.ps1')

    # CASE 1 Workflow Dispatch
    # ========================
    if ($GitHubEvent -eq 'workflow_dispatch') {
        $RunStaticValidation = $WorkflowParameters.staticDeployment
        $RunDeploymentValidation = $WorkflowParameters.triggerDeployment
        $RunDeploymentRemoval = $WorkflowParameters.RunDeploymentRemoval
        $RunPublishing = $true
    } else {
        # CASE 2 - Literally anything else
        # ================================
        $workflowParameters = Get-GitHubWorkflowDefaultInput -WorkflowPath $WorkflowPath
        $RunDeploymentRemoval = $WorkflowParameters.RunDeploymentRemoval

        # Note: Currently it's not possible to fetch the filters from the triggering workflow. Hence, we'll have to hardcode them here
        $pathFilters = @(
            '.github/actions/templates/avm-',
            '.github/actions/templates/avm.template.module.yml',
            $WorkflowPath,
            $ModulePath,
            'avm/utilities/pipelines/'
        )

        # TODO: What to do with the `Commit param` ?
        if ((git branch --show-current) -eq 'main') {
            # If already in main, we'd want to compare with the previous commit
            $diffFiles = git diff HEAD^ --name-only -- $pathFilters | Sort-Object -Unique
        } else {
            # If in a branch, we'd want to compare with main
            $diffFiles = git diff 'origin/main' --name-only -- $pathFilters | Sort-Object -Unique
        }

        if ($diffFiles) {

            $RunStaticValidation = $true
            $RunDeploymentValidation = $true
            $RunDeploymentRemoval = $true
            $RunPublishing = $true

            $markdownRegex = '(.+\.md)'
            $unitTestRegex = '(.+[\\|\/]tests[\\|\/]unit[\\|\/].*)'
            $versionRegex = '(.+[\\|\/]version\.json)'
            $staticTestRelevantFiles = $diffFiles | Where-Object {
                $_ -match "$markdownRegex|$unitTestRegex|$versionRegex"
            }
            Write-Verbose 'Changed files that justify static tests:' -Verbose
            $staticTestRelevantFiles | ForEach-Object {
                Write-Verbose "- [$_]" -Verbose
            }

            if ($staticTestRelevantFiles.Count -eq $diffFiles.count) {
                # All files that changed only justify static tests
                Write-Verbose 'Only files that justify static tests were changed.'
                $RunDeploymentValidation = $false
            } else {
                # Also other module files were changed which justify deployment tests
                $deploymentTestRelevantFiles = $diffFiles | Where-Object {
                    $_ -notIn $staticTestRelevantFiles
                }
                Write-Verbose 'Changed files that justify deployment tests:' -Verbose
                $deploymentTestRelevantFiles | ForEach-Object {
                    Write-Verbose "- [$_]" -Verbose
                }
            }
        } else {
            # Run no action
            $RunStaticValidation = $false
            $RunDeploymentValidation = $false
            $RunDeploymentRemoval = $false
            $RunPublishing = $false
        }
    }

    return @{
        RunStaticValidation     = $RunStaticValidation
        RunDeploymentValidation = $RunDeploymentValidation
        RunDeploymentRemoval    = $RunDeploymentRemoval
        RunPublishing           = $RunPublishing
    }
}

# $inputObject = @{
#     # Commit       = 'e1f088f7f807db040e79e17d28a656d40dbb2cd8'
#     ModulePath   = 'avm/res/key-vault/vault'
#     GitHubEvent  = 'push'
#     WorkflowPath = 'C:/dev/ip/Azure-bicep-registry-modules/alexanderSehr-fork/.github/workflows/avm.res.key-vault.vault.yml'

#     # GitHubEvent        = 'workflow_dispatch'
#     # WorkflowParameters = @{
#     #     deploymentValidation = "false"
#     #     staticValidation     = "true"
#     #     RunDeploymentRemoval     = "true"
#     # }
# }
# Get-CalculatedJobControlObject @inputObject -Verbose
