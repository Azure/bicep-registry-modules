param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Deployment cleanup login conditions' {
    BeforeAll {
        $actionPath = Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml'
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $actionPath -Raw)
        $steps = @($action.runs.steps)
        $logins = @($steps | Where-Object { $_.uses -like 'azure/login@*' })
        $initialLogin = $logins[0]
        $refreshLogin = $logins[1]
        $deployment = $steps | Where-Object { $_.id -eq 'deploy_step' }
        $postDeploymentTests = $steps | Where-Object { $_.id -eq 'pester_run_step' }
        $cleanup = $steps | Where-Object { $_.name -eq 'Remove deployed resources' }

        function Test-ActionStepCondition {
            param(
                [string] $Condition,
                [ValidateSet('success', 'failure', 'cancelled')]
                [string] $JobStatus,
                [string] $RemoveDeployment = 'true',
                [string] $DeploymentNames = '["owned-deployment"]',
                [string] $SkipDeployment = 'false'
            )

            $expression = $Condition.Replace('${{', '').Replace('}}', '').Trim()
            if ($expression -notmatch '\b(success|failure|cancelled|always)\s*\(') {
                $expression = "success() && ($expression)"
            }
            $expression = $expression.
            Replace('success()', '$($JobStatus -eq ''success'')').
            Replace('failure()', '$($JobStatus -eq ''failure'')').
            Replace('cancelled()', '$($JobStatus -eq ''cancelled'')').
            Replace('always()', '$true').
            Replace('inputs.removeDeployment', '$RemoveDeployment').
            Replace('steps.deploy_step.outputs.deploymentNames', '$DeploymentNames').
            Replace('env.skip_deployment_ci', '$SkipDeployment').
            Replace('&&', '-and').Replace('||', '-or').Replace('!=', '-ne').Replace('==', '-eq')
            $conditionScript = [scriptblock]::Create("param(`$JobStatus, `$RemoveDeployment, `$DeploymentNames, `$SkipDeployment) $expression")
            return [bool](. $conditionScript $JobStatus $RemoveDeployment $DeploymentNames $SkipDeployment)
        }
    }

    It 'honors the initial login implicit success check for <jobStatus>' -ForEach @(
        @{ jobStatus = 'success'; expected = $true }
        @{ jobStatus = 'failure'; expected = $false }
        @{ jobStatus = 'cancelled'; expected = $false }
    ) {
        Test-ActionStepCondition -Condition $initialLogin.if -JobStatus $jobStatus | Should -Be $expected
    }

    It 'honors the actual login, post-test and cleanup conditions for <scenario>' -ForEach @(
        @{ scenario = 'successful deployment'; jobStatus = 'success'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'false'; refresh = $true; postTests = $true; remove = $true }
        @{ scenario = 'successful retained resources'; jobStatus = 'success'; removeDeployment = 'false'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'false'; refresh = $true; postTests = $true; remove = $false }
        @{ scenario = 'success without an owned deployment'; jobStatus = 'success'; removeDeployment = 'true'; deploymentNames = ''; skipDeployment = 'false'; refresh = $true; postTests = $true; remove = $false }
        @{ scenario = 'retained success without an owned deployment'; jobStatus = 'success'; removeDeployment = 'false'; deploymentNames = ''; skipDeployment = 'false'; refresh = $true; postTests = $true; remove = $false }
        @{ scenario = 'failed deployment with eligible cleanup'; jobStatus = 'failure'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'false'; refresh = $true; postTests = $false; remove = $true }
        @{ scenario = 'failure without an owned deployment'; jobStatus = 'failure'; removeDeployment = 'true'; deploymentNames = ''; skipDeployment = 'false'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'failed retained resources'; jobStatus = 'failure'; removeDeployment = 'false'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'false'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'retained failure without an owned deployment'; jobStatus = 'failure'; removeDeployment = 'false'; deploymentNames = ''; skipDeployment = 'false'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'skipped deployment after success'; jobStatus = 'success'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'true'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'skipped deployment after failure'; jobStatus = 'failure'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'true'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'cancelled deployment'; jobStatus = 'cancelled'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'false'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'cancelled retained resources'; jobStatus = 'cancelled'; removeDeployment = 'false'; deploymentNames = '["owned-deployment"]'; skipDeployment = 'false'; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'unset skip flag after success'; jobStatus = 'success'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = ''; refresh = $false; postTests = $false; remove = $false }
        @{ scenario = 'unset skip flag after failure'; jobStatus = 'failure'; removeDeployment = 'true'; deploymentNames = '["owned-deployment"]'; skipDeployment = ''; refresh = $false; postTests = $false; remove = $false }
    ) {
        $conditionInput = @{
            JobStatus        = $jobStatus
            RemoveDeployment = $removeDeployment
            DeploymentNames  = $deploymentNames
            SkipDeployment   = $skipDeployment
        }

        Test-ActionStepCondition -Condition $refreshLogin.if @conditionInput | Should -Be $refresh
        Test-ActionStepCondition -Condition $postDeploymentTests.if @conditionInput | Should -Be $postTests
        Test-ActionStepCondition -Condition $cleanup.if @conditionInput | Should -Be $remove
    }

    It 'preserves both pinned login actions and their original inputs' {
        $logins.Count | Should -Be 2
        foreach ($login in $logins) {
            $login.name | Should -Be 'Azure Login - Default'
            $login.uses | Should -Be 'azure/login@7184910d9eb2b1c5e48f7073824a90609bb9b6d6'
            @($login.with.Keys | Sort-Object) | Should -Be @('client-id', 'enable-AzPSSession', 'subscription-id', 'tenant-id')
            $login.with.'client-id' | Should -Be '${{ env.VALIDATE_CLIENT_ID }}'
            $login.with.'tenant-id' | Should -Be '${{ env.VALIDATE_TENANT_ID }}'
            $login.with.'subscription-id' | Should -Be '${{ steps.get-test-subscription.outputs.subscriptionId }}'
            $login.with.'enable-AzPSSession' | Should -BeTrue
        }
        $initialLogin.if | Should -Be 'env.skip_deployment_ci == ''false'''
    }

    It 'keeps refresh immediately after deployment and before post-tests and cleanup' {
        [array]::IndexOf($steps, $initialLogin) | Should -BeLessThan ([array]::IndexOf($steps, $deployment))
        [array]::IndexOf($steps, $refreshLogin) | Should -Be ([array]::IndexOf($steps, $deployment) + 1)
        [array]::IndexOf($steps, $postDeploymentTests) | Should -Be ([array]::IndexOf($steps, $refreshLogin) + 1)
        [array]::IndexOf($steps, $cleanup) | Should -BeGreaterThan ([array]::IndexOf($steps, $postDeploymentTests))
    }

    It 'does not suppress refresh failure or broaden the post-test and cleanup guards' {
        $refreshLogin.ContainsKey('continue-on-error') | Should -BeFalse
        $postDeploymentTests.if | Should -Be 'env.skip_deployment_ci == ''false'''
        $cleanup.if | Should -Be '${{ (success() || failure()) && inputs.removeDeployment == ''true'' && steps.deploy_step.outputs.deploymentNames != '''' && env.skip_deployment_ci == ''false'' }}'
    }
}
