param (
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Test-scoped PSRule dependencies' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'tests' 'helper' 'Initialize-PSRuleTest.ps1')

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
        $script:tools = @{}
        $script:imports = @{}
        $script:loaded = @{}
        $script:events = [Collections.Generic.List[string]]::new()
        foreach ($definition in @(
            @{ Name = 'PSRule'; Version = '2.9.0' }
            @{ Name = 'PSRule.Rules.Azure'; Version = '1.47.0' }
        )) {
            $directory = Join-Path $TestDrive $definition.Name
            $null = New-Item -ItemType Directory -Path $directory -Force
            $path = Join-Path $directory "$($definition.Name).psd1"
            Set-Content -LiteralPath $path -Value "@{ ModuleVersion = '$($definition.Version)' }"
            $script:tools[$definition.Name] = [pscustomobject]@{
                Name = $definition.Name
                Version = $definition.Version
                Kind = 'powershell-module'
                Status = 'installed'
                Path = $path
            }
            $script:imports[$definition.Name] = [pscustomobject]@{
                Name = $definition.Name
                Version = [version] $definition.Version
                ModuleBase = $directory
            }
        }
        Mock Get-Module {
            if ($script:loaded.ContainsKey([string] $Name)) { $script:loaded[[string] $Name] }
        } -ParameterFilter {
            $Name -in @('Avm.Authoring', 'PSRule', 'PSRule.Rules.Azure')
        }
        Mock Import-Module {} -ParameterFilter { $Name -eq 'Avm.Authoring' }
        Mock Import-Module {
            $script:events.Add("import-missing:$Name")
            $errorRecord = [System.Management.Automation.ErrorRecord]::new(
                [IO.FileNotFoundException]::new("Missing configured module $Name."),
                'Modules_ModuleWithVersionNotFound',
                [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                $Name
            )
            throw $errorRecord
        } -ParameterFilter { $Name -in @('PSRule', 'PSRule.Rules.Azure') }
        Mock Import-Module {
            $moduleName = [IO.Path]::GetFileNameWithoutExtension($Name)
            $script:events.Add("import-manifest:$moduleName")
            $script:imports[$moduleName]
        } -ParameterFilter { $Name -in @($script:tools.Values.Path) }
        Mock Get-AvmTool { $script:tools[$Name] }
        Mock Install-AvmTool {
            $script:events.Add("install:$Name")
            $script:tools[$Name].Status = 'installed'
            $script:tools[$Name].Path = Join-Path $TestDrive $Name "$Name.psd1"
        }
    }

    It 'imports engine then rules from <Status> without installing' -ForEach @(
        @{ Status = 'installed' }
        @{ Status = 'installed-on-module-path' }
    ) {
        foreach ($tool in $script:tools.Values) { $tool.Status = $Status }

        Initialize-PSRuleTest -RepoRootPath $RepoRootPath | Should -BeNullOrEmpty

        $script:events.ToArray() | Should -Be @('import-manifest:PSRule', 'import-manifest:PSRule.Rules.Azure')
        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'Avm.Authoring' -and $MinimumVersion -eq [version] '0.21.0' -and $Global -and $ErrorAction -eq 'Stop'
        }
        foreach ($tool in $script:tools.Values) {
            Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter {
                $Name -eq $tool.Path -and $RequiredVersion -eq [version] $tool.Version -and
                $Global -and $PassThru -and -not $Force -and $ErrorAction -eq 'Stop'
            }
        }
    }

    It 'installs only after exact configured imports report genuinely missing modules' {
        foreach ($tool in $script:tools.Values) { $tool.Status = 'not-installed'; $tool.Path = $null }

        Initialize-PSRuleTest -RepoRootPath $RepoRootPath

        $script:events.ToArray() | Should -Be @(
            'import-missing:PSRule', 'install:PSRule', 'import-manifest:PSRule',
            'import-missing:PSRule.Rules.Azure', 'install:PSRule.Rules.Azure', 'import-manifest:PSRule.Rules.Azure'
        )
        Should -Invoke Install-AvmTool -Times 2 -Exactly -ParameterFilter {
            $Name -in @('PSRule', 'PSRule.Rules.Azure') -and $Path -eq $RepoRootPath -and
            $SkipModuleVersionCheck -and $ErrorAction -eq 'Stop'
        }
        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter { $Name -eq 'PSRule' -and $RequiredVersion -eq [version] '2.9.0' }
        Should -Invoke Import-Module -Times 1 -Exactly -ParameterFilter { $Name -eq 'PSRule.Rules.Azure' -and $RequiredVersion -eq [version] '1.47.0' }
    }

    It 'does not explicitly install the available engine when only the rules are missing' {
        $script:tools['PSRule.Rules.Azure'].Status = 'not-installed'
        $script:tools['PSRule.Rules.Azure'].Path = $null

        Initialize-PSRuleTest -RepoRootPath $RepoRootPath

        Should -Invoke Install-AvmTool -Times 1 -Exactly -ParameterFilter { $Name -eq 'PSRule.Rules.Azure' }
        Should -Invoke Install-AvmTool -Times 0 -Exactly -ParameterFilter { $Name -eq 'PSRule' }
    }

    It 'respects disabled auto-install for <ModuleName>' -ForEach @(
        @{ ModuleName = 'PSRule' }
        @{ ModuleName = 'PSRule.Rules.Azure' }
    ) {
        $script:tools[$ModuleName].Status = 'auto-install-disabled'
        $script:tools[$ModuleName].Path = $null

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*auto-install is disabled*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
    }

    It 'rejects an incompatible loaded <ModuleName> before replacing it' -ForEach @(
        @{ ModuleName = 'PSRule' }
        @{ ModuleName = 'PSRule.Rules.Azure' }
    ) {
        $script:loaded[$ModuleName] = [pscustomobject]@{ Version = [version] '9.0.0'; ModuleBase = $TestDrive }
        $script:tools[$ModuleName].Status = 'not-installed'

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*already loaded*fresh PowerShell session*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
    }

    It 'rejects a matching version loaded from a different manifest directory' {
        $script:loaded['PSRule'] = [pscustomobject]@{ Version = [version] '2.9.0'; ModuleBase = (Join-Path $TestDrive 'other') }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*incompatible version or path*fresh PowerShell session*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:tools['PSRule'].Path }
    }

    It 'accepts already loaded modules only when their configured versions and paths match' {
        foreach ($name in $script:imports.Keys) { $script:loaded[$name] = $script:imports[$name] }

        Initialize-PSRuleTest -RepoRootPath $RepoRootPath

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Force }
        $script:events.ToArray() | Should -Be @('import-manifest:PSRule', 'import-manifest:PSRule.Rules.Azure')
    }

    It 'propagates non-missing import failures without installation' {
        Mock Import-Module { throw [IO.FileLoadException]::new('Assembly loading failed.') } -ParameterFilter {
            $Name -eq $script:tools['PSRule'].Path
        }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*Assembly loading failed*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
    }

    It 'does not install when the initial exact-version import fails for a non-missing reason' {
        $script:tools['PSRule'].Status = 'not-installed'
        $script:tools['PSRule'].Path = $null
        Mock Import-Module { throw [UnauthorizedAccessException]::new('Module access denied.') } -ParameterFilter {
            $Name -eq 'PSRule'
        }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*Module access denied*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
    }

    It 'does not treat a missing assembly as a missing configured module' {
        $script:tools['PSRule'].Status = 'not-installed'
        $script:tools['PSRule'].Path = $null
        Mock Import-Module {
            throw [System.Management.Automation.ErrorRecord]::new(
                [IO.FileNotFoundException]::new('Dependent assembly missing.'),
                'MissingDependencyAssembly',
                [System.Management.Automation.ErrorCategory]::ResourceUnavailable,
                $Name
            )
        } -ParameterFilter { $Name -eq 'PSRule' }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*Dependent assembly missing*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
    }

    It 'propagates installation failures without retrying or skipping' {
        $script:tools['PSRule'].Status = 'not-installed'
        $script:tools['PSRule'].Path = $null
        Mock Install-AvmTool { throw [IO.IOException]::new('Pinned package installation failed.') }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*Pinned package installation failed*'

        Should -Invoke Install-AvmTool -Times 1 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:tools['PSRule.Rules.Azure'].Path }
    }

    It 'rejects a configuration change during installation' {
        $script:tools['PSRule'].Status = 'not-installed'
        $script:tools['PSRule'].Path = $null
        Mock Install-AvmTool { $script:tools['PSRule'].Version = '3.0.0' }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*configured PSRule version changed*'
    }

    It 'rejects installation that does not produce a manifest' {
        $script:tools['PSRule'].Status = 'not-installed'
        $script:tools['PSRule'].Path = $null
        Mock Install-AvmTool {}

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*did not resolve an installed PSRule*'
    }

    It 'rejects an incorrect manifest version before importing it' {
        Set-Content -LiteralPath $script:tools['PSRule'].Path -Value "@{ ModuleVersion = '3.0.0' }"

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*does not declare PSRule 2.9.0*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Import-Module -Times 0 -Exactly -ParameterFilter { $Name -eq $script:tools['PSRule'].Path }
    }

    It 'rejects a manifest that changes during import' {
        Mock Import-Module {
            Add-Content -LiteralPath $Name -Value '# changed'
            $script:imports['PSRule']
        } -ParameterFilter { $Name -eq $script:tools['PSRule'].Path }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*PSRule manifest changed during import*'
    }

    It 'rejects an imported module that differs from the configured manifest' {
        $script:imports['PSRule'].Version = [version] '3.0.0'

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*imported module does not match*'
    }

    It 'fails explicitly when Avm.Authoring is not available' {
        Mock Import-Module { throw [IO.FileNotFoundException]::new('Avm.Authoring is not installed.') } -ParameterFilter { $Name -eq 'Avm.Authoring' }

        { Initialize-PSRuleTest -RepoRootPath $RepoRootPath } | Should -Throw '*Avm.Authoring is not installed*'

        Should -Invoke Install-AvmTool -Times 0 -Exactly
        Should -Invoke Get-AvmTool -Times 0 -Exactly
    }
}
