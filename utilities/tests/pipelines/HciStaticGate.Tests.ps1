param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI static validation gate' {
    BeforeAll {
        $action = ConvertFrom-Yaml -Yaml (Get-Content -Raw -LiteralPath (Join-Path $repoRootPath '.github' 'actions' 'templates' 'avm-validateModulePester' 'action.yml'))
        $script:run = [scriptblock]::Create(($action.runs.steps | Where-Object name -eq 'Run Pester tests').run)
        $script:fixtureRoot = Join-Path $TestDrive 'repository'
        $initializer = Join-Path $script:fixtureRoot 'utilities' 'pipelines' 'sharedScripts' 'Initialize-AvmPester.ps1'
        New-Item -ItemType Directory -Path (Split-Path $initializer) -Force | Out-Null
        Set-Content -LiteralPath $initializer -Value 'function Initialize-AvmPester { param($RepoRootPath) }'
        $script:oldEnvironment = @{
            GITHUB_WORKSPACE = $env:GITHUB_WORKSPACE
            MODULE_PATH = $env:MODULE_PATH
            GITHUB_STEP_SUMMARY = $env:GITHUB_STEP_SUMMARY
        }
        $script:oldLocation = Get-Location

        function Invoke-AvmDocs {
            param($Path, $Ecosystem, [switch] $CheckDrift, [switch] $SkipModuleVersionCheck)
        }
        function Invoke-AvmTestUnit {
            param($Path, $Ecosystem, [switch] $IncludeCompliance, [switch] $Recurse, [switch] $SkipModuleVersionCheck)
        }
    }

    BeforeEach {
        $env:GITHUB_WORKSPACE = $script:fixtureRoot
        $env:MODULE_PATH = 'avm/res/example/module'
        $env:GITHUB_STEP_SUMMARY = Join-Path $TestDrive 'summary.txt'
        Set-Location $TestDrive
        Mock Import-Module {}
        Mock Invoke-AvmDocs { @{ Status = 'pass'; Issues = @() } }
        Mock Invoke-AvmTestUnit { @{ Status = 'pass'; Issues = @() } }
        Mock New-PesterContainer { 'fixture' }
        Mock Invoke-Pester { @{ Result = 'Passed' } }
    }

    AfterAll {
        Set-Location $script:oldLocation
        foreach ($name in $script:oldEnvironment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $script:oldEnvironment[$name], 'Process')
        }
    }

    It 'runs documentation, packaged compliance and governance on success' {
        & $script:run
        Should -Invoke Invoke-AvmDocs -Times 1 -Exactly -ParameterFilter { $CheckDrift -and $SkipModuleVersionCheck }
        Should -Invoke Invoke-AvmTestUnit -Times 1 -Exactly -ParameterFilter { $IncludeCompliance -and $Recurse }
        Should -Invoke Invoke-Pester -Times 1 -Exactly
    }

    It 'stops when documentation drift is detected' {
        Mock Invoke-AvmDocs { @{ Status = 'fail'; Issues = @('drift') } }
        { & $script:run } | Should -Throw '*README validation failed*'
        Should -Invoke Invoke-AvmTestUnit -Times 0 -Exactly
    }

    It 'stops when packaged module checks fail' {
        Mock Invoke-AvmTestUnit { @{ Status = 'fail'; Issues = @('invalid') } }
        { & $script:run } | Should -Throw '*Module validation failed*'
        Should -Invoke Invoke-Pester -Times 0 -Exactly
    }

    It 'fails when repository governance fails' {
        Mock Invoke-Pester { @{ Result = 'Failed' } }
        { & $script:run } | Should -Throw '*Repository governance validation failed*'
    }
}
