param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Metadata-only validation' {

    BeforeAll {
        $script:metadataTestPath = Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'metadata.tests.ps1'
        $script:fixtureRoot = Join-Path $TestDrive 'repository'
        $script:dependencyPath = Join-Path $TestDrive 'modules'
        $script:moduleFixtures = @(
            foreach ($moduleKind in @('res', 'ptn', 'utl')) {
                $parentPath = Join-Path $script:fixtureRoot 'avm' $moduleKind 'example' 'module'
                foreach ($isChildModule in @($false, $true)) {
                    @{
                        Path     = $isChildModule ? (Join-Path $parentPath 'child') : $parentPath
                        Metadata = @{
                            Status      = 'pass'
                            ModuleType  = @{ res = 'resource'; ptn = 'pattern'; utl = 'utility' }[$moduleKind]
                            ChildModule = $isChildModule
                        }
                    }
                }
            }
            foreach ($segment in @('tests', 'examples', 'test', 'modules', 'build', 'out', 'dist', 'node_modules', '.hidden')) {
                @{
                    Path     = Join-Path $script:fixtureRoot 'avm' 'res' 'example' 'module' $segment 'helper'
                    Metadata = @{ Status = 'fail'; ModuleType = 'resource'; ChildModule = $true }
                }
            }
        )
        foreach ($fixture in $script:moduleFixtures) {
            $null = New-Item -Path $fixture.Path -ItemType Directory -Force
            Set-Content -LiteralPath (Join-Path $fixture.Path 'main.bicep') -Value 'This is deliberately invalid Bicep.'
        }

        $dependencyFolder = Join-Path $script:dependencyPath 'Avm.Authoring'
        $null = New-Item -Path $dependencyFolder -ItemType Directory -Force
        Set-Content -LiteralPath (Join-Path $dependencyFolder 'Avm.Authoring.psm1') -Value @'
function Test-AvmModuleMetadata {
    param(
        [string] $Path,
        [ValidateSet('bicep')]
        [string] $Ecosystem,
        [string] $ModuleType,
        [switch] $ChildModule,
        [switch] $SkipModuleVersionCheck
    )

    if (-not $SkipModuleVersionCheck) {
        throw 'Metadata validation must skip the online version check.'
    }
    $metadataPath = Join-Path $Path 'metadata.json'
    if (-not (Test-Path -LiteralPath $metadataPath)) {
        return @{ Status = 'fail'; Issues = @(@{ Code = 'Missing'; Message = 'Missing fixture metadata.' }) }
    }

    $metadata = Get-Content -LiteralPath $metadataPath -Raw | ConvertFrom-Json
    if ($metadata.ModuleType -ne $ModuleType -or $metadata.ChildModule -ne $ChildModule.IsPresent) {
        throw 'Metadata validation used the wrong module kind or child scope.'
    }

    @{
        Status = $metadata.Status
        Issues = $metadata.Status -eq 'pass' ? @() : @(@{ Code = 'Invalid'; Message = 'Invalid fixture metadata.' })
    }
}
Export-ModuleMember -Function Test-AvmModuleMetadata
'@

        function Invoke-MetadataTestFixture {
            param(
                [string[]] $ModuleFolderPaths = $script:moduleFixtures.Path
            )

            $settingsPath = Join-Path $TestDrive 'settings.json'
            $resultPath = Join-Path $TestDrive 'result.json'
            @{
                TestPath          = $script:metadataTestPath
                RepoRootPath      = $script:fixtureRoot
                ModuleFolderPaths = $ModuleFolderPaths
                DependencyPath    = $script:dependencyPath
                ResultPath        = $resultPath
            } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $settingsPath

            # A separate process keeps nested Pester runs from resetting the parent test state.
            $output = pwsh -NoLogo -NoProfile -NonInteractive -Command {
                param($settingsPath)
                $ErrorActionPreference = 'Stop'
                $settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json -AsHashtable
                $env:PSModulePath = "$($settings.DependencyPath)$([System.IO.Path]::PathSeparator)$env:PSModulePath"
                Import-Module Pester -MinimumVersion 5.0.0

                $configuration = New-PesterConfiguration
                $configuration.Run.Container = New-PesterContainer -Path $settings.TestPath -Data @{
                    moduleFolderPaths = $settings.ModuleFolderPaths
                    repoRootPath      = $settings.RepoRootPath
                }
                $configuration.Run.PassThru = $true
                $configuration.Run.Exit = $false
                $configuration.Filter.Tag = 'Metadata'
                $configuration.Output.Verbosity = 'None'
                $result = Invoke-Pester -Configuration $configuration
                @{
                    Result                = $result.Result
                    TotalCount            = $result.TotalCount
                    PassedCount           = $result.PassedCount
                    FailedCount           = $result.FailedCount
                    FailedContainersCount = $result.FailedContainersCount
                    Errors                = @(
                        @($result.Failed.ErrorRecord) + @($result.Containers.ErrorRecord) |
                            Where-Object { $_ } |
                            ForEach-Object { $_.Exception.Message }
                    )
                } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $settings.ResultPath
                exit 0
            } -args $settingsPath 2>&1

            if ($LASTEXITCODE -ne 0) {
                throw "Metadata test process failed: $($output | Out-String)"
            }
            Get-Content -LiteralPath $resultPath -Raw | ConvertFrom-Json
        }
    }

    BeforeEach {
        foreach ($fixture in $script:moduleFixtures) {
            $fixture.Metadata | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $fixture.Path 'metadata.json')
        }
    }

    It 'validates resource, pattern and utility parents and children without compiling Bicep or checking helper modules' {
        $result = Invoke-MetadataTestFixture

        $result.Errors | Should -BeNullOrEmpty
        $result.Result | Should -Be 'Passed'
        $result.TotalCount | Should -Be 6
        $result.PassedCount | Should -Be 6
    }

    It 'rejects <MetadataState> metadata even when the Bicep cannot compile' -ForEach @(
        @{ MetadataState = 'invalid' }
        @{ MetadataState = 'missing' }
        @{ MetadataState = 'malformed' }
    ) {
        $metadataPath = Join-Path $script:moduleFixtures[0].Path 'metadata.json'
        switch ($MetadataState) {
            'invalid' {
                $metadata = $script:moduleFixtures[0].Metadata.Clone()
                $metadata.Status = 'fail'
                $metadata | ConvertTo-Json | Set-Content -LiteralPath $metadataPath
            }
            'missing' { Remove-Item -LiteralPath $metadataPath }
            'malformed' { Set-Content -LiteralPath $metadataPath -Value '{invalid JSON' }
        }

        $result = Invoke-MetadataTestFixture

        $result.Result | Should -Be 'Failed'
        $result.TotalCount | Should -Be 6
        $result.FailedCount | Should -Be 1
        $result.FailedContainersCount | Should -Be 0
        $result.Errors | Should -Not -BeNullOrEmpty
    }

    It 'normalizes module paths under the supplied repository root' {
        $modulePaths = $script:moduleFixtures.Path | ForEach-Object {
            $_.Replace($script:fixtureRoot, (Join-Path $TestDrive 'alternate-root'))
        }
        $result = Invoke-MetadataTestFixture -ModuleFolderPaths $modulePaths

        $result.Errors | Should -BeNullOrEmpty
        $result.Result | Should -Be 'Passed'
        $result.PassedCount | Should -Be 6
    }
}

Describe 'Metadata workflow wiring' {

    BeforeAll {
        $workflowPath = Join-Path $repoRootPath '.github' 'workflows' 'platform.on-pull-request-check-metadata.yml'
        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $workflowPath -Raw)
        $script:validationScript = ($workflow.jobs.job_check_metadata.steps | Where-Object { $_.shell -eq 'pwsh' }).run
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($script:validationScript, [ref] $null, [ref] $parseErrors)
        if ($parseErrors.Count -gt 0) {
            throw "Unable to parse the metadata workflow: $($parseErrors -join '; ')"
        }
        $failureGuard = $ast.Find({
                param($node)
                $node -is [System.Management.Automation.Language.IfStatementAst] -and
                $node.Clauses[0].Item1.Extent.Text -match '\$testResults\.'
            }, $true)
        $script:failureCondition = [scriptblock]::Create("param(`$testResults) $($failureGuard.Clauses[0].Item1.Extent.Text)")
    }

    It 'runs the standalone metadata container rather than the compiling compliance container' {
        $script:validationScript | Should -Match "'metadata.tests.ps1'"
        $script:validationScript | Should -Not -Match "'module.tests.ps1'"
    }

    It 'retains the shared metadata checks in full compliance validation' {
        $moduleTestPath = Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'module.tests.ps1'
        Get-Content -LiteralPath $moduleTestPath -Raw |
            Should -Match ([regex]::Escape(". (Join-Path `$PSScriptRoot 'metadata.tests.ps1')"))
    }

    It 'does not validate ownership against legacy markers or lagging public index owners' {
        $moduleTestPath = Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'compliance' 'module.tests.ps1'
        Get-Content -LiteralPath $moduleTestPath -Raw |
            Should -Not -Match 'ORPHANED\.md|PrimaryModuleOwnerGHHandle'
    }

    It 'treats a <Result> run with zero failed assertions as failure: <ShouldFail>' -ForEach @(
        @{ Result = 'Passed'; ShouldFail = $false }
        @{ Result = 'Failed'; ShouldFail = $true }
        @{ Result = 'NotRun'; ShouldFail = $true }
    ) {
        $testResults = [pscustomobject] @{ Result = $Result; FailedCount = 0 }

        (. $script:failureCondition $testResults) | Should -Be $ShouldFail
    }
}
