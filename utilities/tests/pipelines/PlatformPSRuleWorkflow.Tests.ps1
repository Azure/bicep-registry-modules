param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Standalone PSRule token configuration' {
    BeforeAll {
        Import-Module powershell-yaml -ErrorAction Stop
        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $repoRootPath '.github' 'workflows' 'platform.check.psrule.yml') -Raw)
        $tokenStep = $workflow.jobs.job_psrule.steps | Where-Object { $_.name -eq 'Replace tokens in relevant files' }
        $tokenScript = [scriptblock]::Create($tokenStep.with.inlineScript)
        $environmentNames = @($workflow.env.Keys) + @($tokenStep.env.Keys) + @(
            'GITHUB_WORKSPACE', 'localToken_namePrefix', 'localToken_customValue'
        )
        $generalId = '11111111-1111-4111-8111-111111111111'
        $reservedId = '22222222-2222-4222-8222-222222222222'
        $legacyId = '33333333-3333-4333-8333-333333333333'
        $generalPool = ConvertTo-Json -InputObject @(@{ id = $generalId; name = 'fork-general' }) -Compress
        $legacyPool = ConvertTo-Json -InputObject @(@{ id = $legacyId; name = 'legacy-general' }) -Compress
        $mixedPool = ConvertTo-Json -InputObject @(
            @{ id = $reservedId; name = 'fork-reserved'; tag = 'Azure Local' }
            @{ id = $generalId; name = 'fork-general'; tag = 'General' }
        ) -Compress

        function Resolve-TestSetting {
            param([string] $Value, [hashtable] $Context)

            if (-not $Value.StartsWith('${{')) {
                return $Value
            }
            if ($Value -notmatch '^\$\{\{ ((?:vars|secrets)\.[A-Z_]+(?: \|\| (?:vars|secrets)\.[A-Z_]+)*) \}\}$') {
                throw "Unexpected setting expression [$Value]."
            }
            foreach ($name in ($Matches[1] -split ' \|\| ')) {
                if (-not [string]::IsNullOrEmpty($Context[$name])) {
                    return $Context[$name]
                }
            }
            return ''
        }

        function Invoke-TestTokenReplacement {
            param([hashtable] $Context)

            foreach ($name in $workflow.env.Keys) {
                [Environment]::SetEnvironmentVariable($name, (Resolve-TestSetting -Value $workflow.env[$name] -Context $Context))
            }
            foreach ($name in $tokenStep.env.Keys) {
                [Environment]::SetEnvironmentVariable($name, (Resolve-TestSetting -Value $tokenStep.env[$name] -Context $Context))
            }
            . $tokenScript
        }

        function New-TestTemplate {
            param([string] $ModulePath, [string] $Case = 'defaults')

            $path = Join-Path $env:GITHUB_WORKSPACE $ModulePath 'tests' 'e2e' $Case 'main.test.bicep'
            $null = New-Item -Path (Split-Path $path) -ItemType Directory -Force
            @'
param subscriptionId string = '#_subscriptionId_#'
param managementGroupId string = '#_managementGroupId_#'
param namePrefix string = '#_namePrefix_#'
param customValue string = '#_customValue_#'
'@ | Set-Content -LiteralPath $path
            return $path
        }

        function Add-TestSharedReference {
            param([string] $TemplatePath, [string] $DependencyPath)

            $reference = [IO.Path]::GetRelativePath((Split-Path $TemplatePath), $DependencyPath).Replace('\', '/')
            "module dependency '$reference' = {`n  name: 'dependency'`n}" | Add-Content -LiteralPath $TemplatePath
        }
    }

    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in (@($environmentNames) + @((Get-ChildItem env: | Where-Object Name -Like 'localToken_*').Name) | Sort-Object -Unique)) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
            [Environment]::SetEnvironmentVariable($name, $null)
        }
        $env:GITHUB_WORKSPACE = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        foreach ($relativePath in @(
                'utilities\pipelines\sharedScripts\Get-TestSubscriptionList.ps1',
                'utilities\pipelines\sharedScripts\Get-TestSubscriptionTag.ps1',
                'utilities\pipelines\sharedScripts\Get-LocallyReferencedFileList.ps1',
                'utilities\pipelines\sharedScripts\tokenReplacement\Convert-TokensInFileList.ps1',
                'utilities\pipelines\sharedScripts\tokenReplacement\helper\Convert-TokenInFile.ps1'
            )) {
            $destination = Join-Path $env:GITHUB_WORKSPACE $relativePath
            $null = New-Item -Path (Split-Path $destination) -ItemType Directory -Force
            Copy-Item -LiteralPath (Join-Path $repoRootPath $relativePath) -Destination $destination
        }
        '{"avm/res/azure-stack-hci/cluster":"Azure Local"}' |
            Set-Content -LiteralPath (Join-Path $env:GITHUB_WORKSPACE '.reserved-test-subscriptions.json')
        $generalPath = New-TestTemplate -ModulePath 'avm/res/audit/general'
        $originalContent = Get-Content -LiteralPath $generalPath -Raw
        $context = @{
            'vars.VALIDATE_SUBSCRIPTION_IDS' = $generalPool
            'vars.VALIDATE_MANAGEMENT_GROUP_ID' = 'fork-management-group'
            'secrets.TOKEN_NAMEPREFIX' = 'github-prefix'
        }
        Mock Invoke-WebRequest { throw 'Unexpected network access.' }
        Mock Invoke-RestMethod { throw 'Unexpected network access.' }
    }

    AfterEach {
        foreach ($name in $savedEnvironment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'preserves the existing policy evaluation, fixture filter and fork trigger behavior' {
        $workflow.on.schedule[0].cron | Should -Be '0 12 * * 0'
        $workflow.on.workflow_dispatch.inputs.psruleBaseline.default | Should -Be 'Azure.Default'
        $workflow.env.targetPath | Should -Be 'avm/'
        $workflow.env.psRuleFilterRegex | Should -Be '(defaults|waf-aligned)'
        $workflow.jobs.job_psrule.environment | Should -Be 'avm-validation'
        $workflow.jobs.job_init_psrule_pipeline.if |
            Should -Be '${{ !cancelled() && !(github.repository != ''Azure/bicep-registry-modules'' && github.event_name != ''workflow_dispatch'') }}'
        $analysis = $workflow.jobs.job_psrule.steps | Where-Object { $_.name -eq 'Run PSRule analysis' }
        $analysis.uses | Should -Be 'microsoft/ps-rule@46451b8f5258c41beb5ae69ed7190ccbba84112c'
        $analysis.with.repository | Should -Be '${{ steps.prepare_psrule.outputs.repository }}'
        $analysis.with.modules | Should -Be 'PSRule.Rules.Azure'
        $analysis.with.prerelease | Should -BeTrue
        $analysis.with.baseline | Should -Be '${{(fromJson(needs.job_init_psrule_pipeline.outputs.workflowInput)).psruleBaseline }}'
        $analysis.with.inputPath | Should -Be '${{(fromJson(needs.job_init_psrule_pipeline.outputs.workflowInput)).targetPath }}'
        $analysis.with.outputFormat | Should -Be 'Csv'
        $analysis.with.outputPath | Should -Be '${{ env.PSRuleOutputFilePath }}'
        $analysis.with.option | Should -Be '${{ github.workspace }}/${{ env.psrulePath}}/ps-rule.yaml'
        $analysis.with.source | Should -Be '${{ env.psrulePath}}/.ps-rule/'
        $analysis.with.summary | Should -BeFalse
        $tokenStep.env.TEST_SUBSCRIPTION_IDS |
            Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_IDS || vars.TEST_SUBSCRIPTION_IDS || secrets.VALIDATE_SUBSCRIPTION_IDS || secrets.TEST_SUBSCRIPTION_IDS }}'
        $tokenStep.env.VALIDATE_SUBSCRIPTION_ID | Should -Be '${{ vars.VALIDATE_SUBSCRIPTION_ID || secrets.VALIDATE_SUBSCRIPTION_ID }}'
        $workflow.env.ARM_MGMTGROUP_ID |
            Should -Be '${{ vars.VALIDATE_MANAGEMENT_GROUP_ID || vars.ARM_MGMTGROUP_ID || secrets.VALIDATE_MANAGEMENT_GROUP_ID || secrets.ARM_MGMTGROUP_ID }}'
        $tokenStep.with.inlineScript | Should -Not -Match '\$\{\{|ConvertTo-Json|Connect-AzAccount'
    }

    It 'uses canonical fork Variables and exact module roots without inheriting parent reservations' {
        $context['vars.VALIDATE_SUBSCRIPTION_IDS'] = $mixedPool
        $context['vars.TEST_SUBSCRIPTION_IDS'] = $legacyPool
        $context['secrets.VALIDATE_SUBSCRIPTION_IDS'] = $legacyPool
        $context['secrets.VALIDATE_SUBSCRIPTION_ID'] = $legacyId
        $context['secrets.ARM_MGMTGROUP_ID'] = 'old-secret-group'
        $reservedPath = New-TestTemplate -ModulePath 'avm/res/azure-stack-hci/cluster' -Case 'waf-aligned'
        $childPath = New-TestTemplate -ModulePath 'avm/res/azure-stack-hci/cluster/deployment-setting'

        $messages = @(Invoke-TestTokenReplacement -Context $context 4>&1)

        Get-Content -LiteralPath $generalPath -Raw | Should -Match $generalId
        Get-Content -LiteralPath $childPath -Raw | Should -Match $generalId
        Get-Content -LiteralPath $reservedPath -Raw | Should -Match $reservedId
        Get-Content -LiteralPath $generalPath -Raw | Should -Match 'fork-management-group'
        Get-Content -LiteralPath $generalPath -Raw | Should -Not -Match $legacyId
        ($messages | Out-String) | Should -Not -Match "$generalId|$reservedId|fork-management-group|fork-reserved|fork-general"
    }

    It 'resolves <poolSource> and <groupSource> ahead of lower-priority settings' -ForEach @(
        @{ poolSource = 'vars.VALIDATE_SUBSCRIPTION_IDS'; groupSource = 'vars.VALIDATE_MANAGEMENT_GROUP_ID'; lowerPool = 'vars.TEST_SUBSCRIPTION_IDS'; lowerGroup = 'vars.ARM_MGMTGROUP_ID' }
        @{ poolSource = 'vars.TEST_SUBSCRIPTION_IDS'; groupSource = 'vars.ARM_MGMTGROUP_ID'; lowerPool = 'secrets.VALIDATE_SUBSCRIPTION_IDS'; lowerGroup = 'secrets.VALIDATE_MANAGEMENT_GROUP_ID' }
        @{ poolSource = 'secrets.VALIDATE_SUBSCRIPTION_IDS'; groupSource = 'secrets.VALIDATE_MANAGEMENT_GROUP_ID'; lowerPool = 'secrets.TEST_SUBSCRIPTION_IDS'; lowerGroup = 'secrets.ARM_MGMTGROUP_ID' }
        @{ poolSource = 'secrets.TEST_SUBSCRIPTION_IDS'; groupSource = 'secrets.ARM_MGMTGROUP_ID'; lowerPool = 'vars.VALIDATE_SUBSCRIPTION_ID'; lowerGroup = '' }
    ) {
        $context.Clear()
        $context[$poolSource] = $generalPool
        $context[$groupSource] = 'selected-group'
        $context[$lowerPool] = $lowerPool -eq 'vars.VALIDATE_SUBSCRIPTION_ID' ? $legacyId : $legacyPool
        if ($lowerGroup) { $context[$lowerGroup] = 'ignored-group' }

        $null = Invoke-TestTokenReplacement -Context $context

        $content = Get-Content -LiteralPath $generalPath -Raw
        $content | Should -Match $generalId
        $content | Should -Match 'selected-group'
        $content | Should -Not -Match "$legacyId|ignored-group"
    }

    It 'retains the General singleton fallback from <source>' -ForEach @(
        @{ source = 'vars.VALIDATE_SUBSCRIPTION_ID' }
        @{ source = 'secrets.VALIDATE_SUBSCRIPTION_ID' }
    ) {
        $context.Clear()
        $context['secrets.VALIDATE_SUBSCRIPTION_ID'] = $legacyId
        $context[$source] = $generalId
        $context['vars.ARM_MGMTGROUP_ID'] = 'fork-alias-group'

        $null = Invoke-TestTokenReplacement -Context $context

        Get-Content -LiteralPath $generalPath -Raw | Should -Match $generalId
        Get-Content -LiteralPath $generalPath -Raw | Should -Match 'fork-alias-group'
    }

    It 'preserves local tokens, name-prefix precedence and the selected fixture set' {
        $env:localToken_customValue = 'source-custom'
        $env:localToken_namePrefix = 'source-prefix'
        $excludedPath = New-TestTemplate -ModulePath 'avm/res/audit/general' -Case 'max'
        $ignoredPath = New-TestTemplate -ModulePath 'avm/res/audit/general' -Case 'waf-aligned'
        'Deployment-only exclusion' | Set-Content -LiteralPath (Join-Path (Split-Path $ignoredPath) '.e2eignore')

        $null = Invoke-TestTokenReplacement -Context $context

        $content = Get-Content -LiteralPath $generalPath -Raw
        $content | Should -Match 'source-custom'
        $content | Should -Match 'source-prefix'
        $content | Should -Not -Match 'github-prefix'
        Get-Content -LiteralPath $excludedPath -Raw | Should -BeExactly $originalContent
        Get-Content -LiteralPath $ignoredPath -Raw | Should -Match $generalId
    }

    It 'preserves unconfigured identity tokens instead of inventing a subscription' {
        $context.Remove('vars.VALIDATE_SUBSCRIPTION_IDS')
        $context.Remove('vars.VALIDATE_MANAGEMENT_GROUP_ID')

        $null = Invoke-TestTokenReplacement -Context $context

        $content = Get-Content -LiteralPath $generalPath -Raw
        $content | Should -Match '#_subscriptionId_#'
        $content | Should -Match '#_managementGroupId_#'
        $content | Should -Match 'github-prefix'
    }

    It 'rejects malformed preferred <source> <label> without fallback or file changes' -ForEach @(
        @{ source = 'vars.VALIDATE_SUBSCRIPTION_IDS'; label = 'JSON'; value = '[invalid' }
        @{ source = 'vars.VALIDATE_SUBSCRIPTION_IDS'; label = 'whitespace'; value = ' ' }
        @{ source = 'vars.VALIDATE_SUBSCRIPTION_IDS'; label = 'empty array'; value = '[]' }
        @{ source = 'vars.VALIDATE_SUBSCRIPTION_IDS'; label = 'unknown field'; value = '[{"id":"11111111-1111-4111-8111-111111111111","name":"test","tga":"Azure Local"}]' }
        @{ source = 'vars.TEST_SUBSCRIPTION_IDS'; label = 'JSON'; value = '[invalid' }
        @{ source = 'vars.TEST_SUBSCRIPTION_IDS'; label = 'whitespace'; value = ' ' }
        @{ source = 'vars.TEST_SUBSCRIPTION_IDS'; label = 'empty array'; value = '[]' }
        @{ source = 'vars.TEST_SUBSCRIPTION_IDS'; label = 'unknown field'; value = '[{"id":"11111111-1111-4111-8111-111111111111","name":"test","tga":"Azure Local"}]' }
    ) {
        $context.Remove('vars.VALIDATE_SUBSCRIPTION_IDS')
        $context['vars.TEST_SUBSCRIPTION_IDS'] = $legacyPool
        $context['secrets.VALIDATE_SUBSCRIPTION_IDS'] = $legacyPool
        $context['secrets.VALIDATE_SUBSCRIPTION_ID'] = $legacyId
        $context[$source] = $value

        { Invoke-TestTokenReplacement -Context $context } | Should -Throw

        Get-Content -LiteralPath $generalPath -Raw | Should -BeExactly $originalContent
    }

    It 'rejects a missing reserved pool before rewriting any earlier General files' {
        $reservedPath = New-TestTemplate -ModulePath 'avm/res/azure-stack-hci/cluster'
        $context['secrets.VALIDATE_SUBSCRIPTION_ID'] = $legacyId

        { Invoke-TestTokenReplacement -Context $context } | Should -Throw '*No test subscriptions match required tag*'

        Get-Content -LiteralPath $generalPath -Raw | Should -BeExactly $originalContent
        Get-Content -LiteralPath $reservedPath -Raw | Should -BeExactly $originalContent
    }

    It 'does not use a singleton fallback for a reserved module' {
        $reservedPath = New-TestTemplate -ModulePath 'avm/res/azure-stack-hci/cluster'
        $context.Remove('vars.VALIDATE_SUBSCRIPTION_IDS')
        $context['secrets.VALIDATE_SUBSCRIPTION_ID'] = $legacyId

        { Invoke-TestTokenReplacement -Context $context } | Should -Throw '*legacy subscription cannot be used*'

        Get-Content -LiteralPath $generalPath -Raw | Should -BeExactly $originalContent
        Get-Content -LiteralPath $reservedPath -Raw | Should -BeExactly $originalContent
    }

    It 'rejects an invalid reservation map before replacing tokens' {
        '{"avm/res/azure-stack-hci/cluster":[]}' |
            Set-Content -LiteralPath (Join-Path $env:GITHUB_WORKSPACE '.reserved-test-subscriptions.json')

        { Invoke-TestTokenReplacement -Context $context } | Should -Throw '*must be a subscription tag string*'

        Get-Content -LiteralPath $generalPath -Raw | Should -BeExactly $originalContent
    }

    It 'replaces shared dependency tokens compatible with both subscription pools' {
        $context['vars.VALIDATE_SUBSCRIPTION_IDS'] = $mixedPool
        $reservedPath = New-TestTemplate -ModulePath 'avm/res/azure-stack-hci/cluster'
        $sharedPath = Join-Path $env:GITHUB_WORKSPACE 'utilities' 'shared.bicep'
        "param namePrefix string = '#_namePrefix_#'" | Set-Content -LiteralPath $sharedPath
        Add-TestSharedReference -TemplatePath $generalPath -DependencyPath $sharedPath
        Add-TestSharedReference -TemplatePath $reservedPath -DependencyPath $sharedPath

        $null = Invoke-TestTokenReplacement -Context $context

        Get-Content -LiteralPath $sharedPath -Raw | Should -Match 'github-prefix'
        Get-Content -LiteralPath $generalPath -Raw | Should -Match $generalId
        Get-Content -LiteralPath $reservedPath -Raw | Should -Match $reservedId
    }

    It 'rejects conflicting subscription tokens in a shared dependency before any file changes' {
        $context['vars.VALIDATE_SUBSCRIPTION_IDS'] = $mixedPool
        $reservedPath = New-TestTemplate -ModulePath 'avm/res/azure-stack-hci/cluster'
        $sharedPath = Join-Path $env:GITHUB_WORKSPACE 'utilities' 'shared.bicep'
        "param subscriptionId string = '#_subscriptionId_#'" | Set-Content -LiteralPath $sharedPath
        Add-TestSharedReference -TemplatePath $generalPath -DependencyPath $sharedPath
        Add-TestSharedReference -TemplatePath $reservedPath -DependencyPath $sharedPath
        $before = @{}
        foreach ($path in @($generalPath, $reservedPath, $sharedPath)) {
            $before[$path] = Get-Content -LiteralPath $path -Raw
        }

        { Invoke-TestTokenReplacement -Context $context } | Should -Throw '*conflicting module subscription tokens*'

        foreach ($path in $before.Keys) {
            Get-Content -LiteralPath $path -Raw | Should -BeExactly $before[$path]
        }
    }
}
