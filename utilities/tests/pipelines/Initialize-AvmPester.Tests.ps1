param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'AVM Pester initialization' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Initialize-AvmPester.ps1')

        function Get-AvmTool {
            [CmdletBinding()]
            param ([string] $Name, [string] $Path, [switch] $SkipModuleVersionCheck)
            throw 'Unexpected tool resolution.'
        }
        function Install-AvmTool {
            [CmdletBinding()]
            param ([string] $Name, [string] $Path, [switch] $SkipModuleVersionCheck)
            throw 'Unexpected tool installation.'
        }
    }

    BeforeEach {
        $script:manifestPath = Join-Path $TestDrive 'Pester.psd1'
        Set-Content -LiteralPath $script:manifestPath -Value "@{ ModuleVersion = '5.6.2'; RootModule = 'Pester.psm1' }"
        $script:tool = [pscustomobject] @{
            Name    = 'Pester'
            Version = '5.6.2'
            Kind    = 'powershell-module'
            Status  = 'installed'
            Path    = $script:manifestPath
        }
        $script:importedPester = [pscustomobject] @{
            Name       = 'Pester'
            Version    = [version] '5.6.2'
            ModuleBase = $TestDrive
        }
        Mock Get-Module {} -ParameterFilter { $Name -eq 'Pester' -or $Name -eq 'Avm.Authoring' }
        Mock Get-Module {
            [pscustomobject] @{ Version = [version] '0.21.0' }
        } -ParameterFilter { $Name -eq 'Avm.Authoring' -and $ListAvailable }
        Mock Import-Module {} -ParameterFilter { $Name -eq 'Avm.Authoring' }
        Mock Import-Module { $script:importedPester } -ParameterFilter { $Name -eq $script:manifestPath }
        Mock Install-Module {}
        Mock Get-AvmTool { $script:tool }
        Mock Install-AvmTool {
            $script:tool = [pscustomobject] @{
                Name    = 'Pester'
                Version = '5.6.2'
                Kind    = 'powershell-module'
                Status  = 'installed'
                Path    = $script:manifestPath
            }
        }
    }

    It 'imports the exact configured manifest from <Status> without installing unrelated tools' -ForEach @(
        @{ Status = 'installed' }
        @{ Status = 'installed-on-module-path' }
    ) {
        $script:tool.Status = $Status

        Initialize-AvmPester -RepoRootPath $RepoRootPath | Should -BeNullOrEmpty

        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'Avm.Authoring' -and $MinimumVersion -eq [version] '0.21.0' -and $Global -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Get-AvmTool -Times 1 -Exactly -ParameterFilter {
            $Name -ceq 'Pester' -and $Path -eq $RepoRootPath -and $SkipModuleVersionCheck -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq $script:manifestPath -and $Global -and $PassThru -and -not $Force -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Install-Module -Times 0 -Exactly
    }

    It 'installs only missing Pester and resolves its manifest again using the same root' {
        $script:tool.Status = 'not-installed'
        $script:tool.Path = $null

        Initialize-AvmPester -RepoRootPath $RepoRootPath

        Should -Invoke Install-AvmTool -Times 1 -Exactly -ParameterFilter {
            $Name -ceq 'Pester' -and $Path -eq $RepoRootPath -and $SkipModuleVersionCheck -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Get-AvmTool -Times 2 -Exactly -ParameterFilter {
            $Name -ceq 'Pester' -and $Path -eq $RepoRootPath -and $SkipModuleVersionCheck
        }
        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'does not override disabled automatic installation' {
        $script:tool.Status = 'auto-install-disabled'
        $script:tool.Path = $null

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*auto-install is disabled*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'rejects loaded Pester <LoadedVersion> before installing or importing another engine' -ForEach @(
        @{ LoadedVersion = '5.5.0' }
        @{ LoadedVersion = '5.9.0' }
    ) {
        Mock Get-Module {
            [pscustomobject] @{ Version = [version] $LoadedVersion; ModuleBase = $TestDrive }
        } -ParameterFilter { $Name -eq 'Pester' }
        $script:tool.Status = 'not-installed'

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*already loaded*fresh PowerShell session*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'accepts an already loaded matching version and path without replacing the engine' {
        Mock Get-Module { $script:importedPester } -ParameterFilter { $Name -eq 'Pester' }

        Initialize-AvmPester -RepoRootPath $RepoRootPath

        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter { $Name -eq $script:manifestPath -and -not $Force }
    }

    It 'rejects a matching version loaded from a different path' {
        Mock Get-Module {
            [pscustomobject] @{ Version = [version] '5.6.2'; ModuleBase = (Join-Path $TestDrive 'other') }
        } -ParameterFilter { $Name -eq 'Pester' }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*not the configured path*fresh PowerShell session*'

        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'requires a supported Avm.Authoring when only <Availability> versions are installed' -ForEach @(
        @{ Availability = 'no'; AvailableVersion = $null }
        @{ Availability = 'older'; AvailableVersion = '0.20.0' }
    ) {
        Mock Get-Module {
            if ($AvailableVersion) {
                [pscustomobject] @{ Version = [version] $AvailableVersion }
            }
        } -ParameterFilter { $Name -eq 'Avm.Authoring' -and $ListAvailable }

        Initialize-AvmPester -RepoRootPath $RepoRootPath

        Should -Invoke Install-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'Avm.Authoring' -and $MinimumVersion -eq [version] '0.21.0' -and
            $Repository -eq 'PSGallery' -and $Scope -eq 'CurrentUser' -and $ErrorAction -eq 'Stop'
        }
    }

    It 'does not replace an already loaded older Avm.Authoring' {
        Mock Get-Module {
            [pscustomobject] @{ Version = [version] '0.20.0' }
        } -ParameterFilter { $Name -eq 'Avm.Authoring' -and -not $ListAvailable }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*Avm.Authoring 0.20.0 is already loaded*0.21.0*fresh PowerShell session*'

        Should -Invoke Install-Module -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly
        Should -Invoke Get-AvmTool -Times 0 -Exactly
    }

    It 'rejects <Problem> tool resolution before importing Pester' -ForEach @(
        @{ Problem = 'missing'; Results = @() }
        @{ Problem = 'ambiguous'; Results = @(@{ Name = 'Pester' }, @{ Name = 'Pester' }) }
        @{ Problem = 'incorrect name'; Results = @(@{ Name = 'Other'; Kind = 'powershell-module'; Version = '5.6.2' }) }
        @{ Problem = 'binary'; Results = @(@{ Name = 'Pester'; Kind = 'binary'; Version = '5.6.2' }) }
        @{ Problem = 'invalid version'; Results = @(@{ Name = 'Pester'; Kind = 'powershell-module'; Version = 'invalid' }) }
    ) {
        Mock Get-AvmTool { $Results }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*did not resolve exactly one*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'rejects an unsupported installed status <Status>' -ForEach @(
        @{ Status = 'installed-on-path' }
        @{ Status = 'outdated-on-path' }
        @{ Status = 'unknown' }
    ) {
        $script:tool.Status = $Status

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*did not resolve an installed Pester*'

        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'rejects an absent or invalid manifest path: <Problem>' -ForEach @(
        @{ Problem = 'empty'; RelativePath = '' }
        @{ Problem = 'missing'; RelativePath = 'missing.psd1' }
        @{ Problem = 'directory'; RelativePath = '.' }
    ) {
        $script:tool.Path = $RelativePath ? (Join-Path $TestDrive $RelativePath) : ''

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*did not resolve an installed Pester*'

        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'rejects a manifest declaring another version' {
        Set-Content -LiteralPath $script:manifestPath -Value "@{ ModuleVersion = '5.9.0' }"

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*does not declare Pester 5.6.2*'

        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'does not implicitly autoload dependencies declared by a different Pester manifest' {
        Set-Content -LiteralPath $script:manifestPath -Value "@{ ModuleVersion = '5.6.2'; RequiredModules = @('Other') }"

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*module dependencies*'

        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'rejects configuration changes during installation' {
        $script:tool.Status = 'not-installed'
        Mock Install-AvmTool {
            $script:tool = [pscustomobject] @{ Name = 'Pester'; Kind = 'powershell-module'; Version = '5.9.0' }
        }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*different Pester configuration*'

        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:manifestPath }
    }

    It 'rejects installation that does not produce a usable manifest' {
        $script:tool.Status = 'not-installed'
        Mock Install-AvmTool {}

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*did not resolve an installed Pester*'
    }

    It 'rejects an imported module with an unexpected <Property>' -ForEach @(
        @{ Property = 'Name'; Value = 'Other' }
        @{ Property = 'Version'; Value = [version] '5.9.0' }
        @{ Property = 'ModuleBase'; Value = 'another-directory' }
    ) {
        $script:importedPester.$Property = $Value

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*imported module does not match*'
    }

    It 'propagates resolution errors' {
        Mock Get-AvmTool { throw 'Resolution failed.' }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*Resolution failed.*'
    }

    It 'propagates tool installation errors' {
        $script:tool.Status = 'not-installed'
        Mock Install-AvmTool { throw 'Checksum verification failed.' }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*Checksum verification failed.*'
    }

    It 'propagates Avm.Authoring installation errors' {
        Mock Get-Module {} -ParameterFilter { $Name -eq 'Avm.Authoring' -and $ListAvailable }
        Mock Install-Module { throw 'Authoring installation failed.' }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*Authoring installation failed.*'

        Should -Invoke Get-AvmTool -Times 0 -Exactly
    }

    It 'propagates Avm.Authoring import errors' {
        Mock Import-Module { throw 'Authoring import failed.' } -ParameterFilter { $Name -eq 'Avm.Authoring' }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*Authoring import failed.*'

        Should -Invoke Get-AvmTool -Times 0 -Exactly
    }

    It 'propagates Pester import errors' {
        Mock Import-Module { throw 'Pester import failed.' } -ParameterFilter { $Name -eq $script:manifestPath }

        { Initialize-AvmPester -RepoRootPath $RepoRootPath } | Should -Throw '*Pester import failed.*'
    }
}

Describe 'Pester entry-point initialization' {
    BeforeAll {
        $action = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModulePester' 'action.yml') -Raw)
        $deploymentAction = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw)
        $workflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'platform.on-pull-request-check-metadata.yml') -Raw)
        $namingWorkflow = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'workflows' 'platform.on-pull-request-check-e2e-names.yml') -Raw)
        $script:scripts = @{
            'full static validation' = ($action.runs.steps | Where-Object id -EQ 'pester_run_step').run.Replace('${{ inputs.modulePath }}', 'avm/res/example/module').Replace('${{ inputs.moduleTestFilePath }}', 'utilities/pipelines/staticValidation/compliance/module.tests.ps1')
            'post-deployment tests'  = ($deploymentAction.runs.steps | Where-Object id -EQ 'pester_run_step').run
            'standalone metadata'    = ($workflow.jobs.job_check_metadata.steps | Where-Object shell -EQ 'pwsh').run
            'offline naming tests'   = ($namingWorkflow.jobs.job_check_names.steps | Where-Object name -EQ 'Test naming helper and validator').run
            'local module tests'     = Get-Content -LiteralPath (Join-Path $RepoRootPath 'utilities' 'tools' 'Test-ModuleLocally.ps1') -Raw
            'CI utility tests'       = Get-Content -LiteralPath (Join-Path $RepoRootPath 'utilities' 'tests' 'Test-CI.ps1') -Raw
        }
    }

    It 'initializes the shared engine before any Pester command in <EntryPoint>' -ForEach @(
        @{ EntryPoint = 'full static validation'; PesterCommandCount = 2 }
        @{ EntryPoint = 'post-deployment tests'; PesterCommandCount = 2 }
        @{ EntryPoint = 'standalone metadata'; PesterCommandCount = 2 }
        @{ EntryPoint = 'offline naming tests'; PesterCommandCount = 1 }
        @{ EntryPoint = 'local module tests'; PesterCommandCount = 2 }
        @{ EntryPoint = 'CI utility tests'; PesterCommandCount = 2 }
    ) {
        $parseErrors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($scripts[$EntryPoint], [ref] $null, [ref] $parseErrors)
        $parseErrors | Should -BeNullOrEmpty
        $commands = $ast.FindAll({ param($node) $node -is [System.Management.Automation.Language.CommandAst] }, $true)
        $initializers = @($commands | Where-Object { $_.GetCommandName() -eq 'Initialize-AvmPester' })
        $initializers.Count | Should -Be 1
        $initializer = $initializers[0]
        $initializer.Extent.Text | Should -Match '-RepoRootPath \$(repoRootPath|env:GITHUB_WORKSPACE)'
        $source = @($commands | Where-Object {
                $_.InvocationOperator -eq 'Dot' -and $_.Extent.Text -match "'Initialize-AvmPester.ps1'"
            })
        $source.Count | Should -Be 1
        $source[0].Extent.StartOffset | Should -BeLessThan $initializer.Extent.StartOffset
        $pesterCommands = @($commands | Where-Object { $_.GetCommandName() -in @('New-PesterContainer', 'Invoke-Pester') })
        $pesterCommands.Count | Should -Be $PesterCommandCount
        foreach ($command in $pesterCommands) {
            $initializer.Extent.StartOffset | Should -BeLessThan $command.Extent.StartOffset
        }
        for ($ancestor = $initializer.Parent; $null -ne $ancestor; $ancestor = $ancestor.Parent) {
            $ancestor | Should -Not -BeOfType ([System.Management.Automation.Language.TryStatementAst])
        }
    }

    It 'keeps local initialization limited to PesterTest and PesterTestRecurse' {
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($scripts['local module tests'], [ref] $null, [ref] $null)
        $initializer = $ast.Find({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Initialize-AvmPester'
            }, $true)
        $ancestor = $initializer.Parent
        while ($ancestor -isnot [System.Management.Automation.Language.IfStatementAst]) {
            $ancestor = $ancestor.Parent
        }
        $ancestor.Clauses[0].Item1.Extent.Text | Should -Be '$PesterTest -or $PesterTestRecurse'
    }
}
