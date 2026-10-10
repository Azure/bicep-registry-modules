BeforeAll {
    $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'staticValidation' 'psrule' 'Initialize-PSRuleRepository.ps1')
    function Get-InstalledModule {
        [CmdletBinding()]
        param([string] $Name, [switch] $AllVersions)
        throw 'The installed-module lookup must be mocked.'
    }
    function Find-Module {
        [CmdletBinding()]
        param([string] $Name, [string] $RequiredVersion, [string] $Repository, [switch] $AllowPrerelease)
        throw 'The module lookup must be mocked.'
    }
    function Get-PSRepository {
        [CmdletBinding()]
        param([string] $Name)
        throw 'The repository lookup must be mocked.'
    }
    function Register-PSRepository {
        [CmdletBinding()]
        param([string] $Name, [string] $SourceLocation, [string] $InstallationPolicy)
        throw 'The repository registration must be mocked.'
    }
}

Describe 'PSRule action wiring' {
    BeforeAll {
        Import-Module powershell-yaml -RequiredVersion 0.4.2 -ErrorAction Stop
    }

    It 'uses prepared packages without changing the pinned action in <Kind>' -ForEach @(
        @{ Kind = 'the composite action'; Folders = @('.github', 'actions', 'templates', 'avm-validateModulePSRule', 'action.yml'); Composite = $true }
        @{ Kind = 'the standalone workflow'; Folders = @('.github', 'workflows', 'platform.check.psrule.yml'); Composite = $false }
    ) {
        $file = Join-Path -Path $repoRootPath -ChildPath $Folders[0] -AdditionalChildPath $Folders[1..($Folders.Count - 1)]
        $document = ConvertFrom-Yaml -Yaml (Get-Content -LiteralPath $file -Raw)
        $steps = if ($Composite) { @($document.runs.steps) } else { @($document.jobs.Values | ForEach-Object { $_.steps }) }
        $analysis = @($steps | Where-Object { $_.uses -like 'microsoft/ps-rule@*' })
        $preparation = @($steps | Where-Object { $_.id -eq 'prepare_psrule' })
        $analysis.Count | Should -Be 1
        $preparation.Count | Should -Be 1
        $analysis[0].uses | Should -Be 'microsoft/ps-rule@46451b8f5258c41beb5ae69ed7190ccbba84112c'
        $analysis[0]['if'] | Should -Be '${{ steps.prepare_psrule.outcome == ''success'' }}'
        $analysis[0].with.repository | Should -Be '${{ steps.prepare_psrule.outputs.repository }}'
        $analysis[0].with.modules | Should -Be 'PSRule.Rules.Azure'
        $analysis[0].with.prerelease | Should -BeTrue
        $preparation[0].shell | Should -Be 'pwsh'
        $preparation[0].run | Should -Match 'Initialize-PSRuleRepository -TemporaryPath \$env:RUNNER_TEMP'
        [array]::IndexOf($steps, $preparation[0]) | Should -BeLessThan ([array]::IndexOf($steps, $analysis[0]))
        if ($Composite) {
            $preparation[0]['continue-on-error'] | Should -Be $analysis[0]['continue-on-error']
            $preparation[0].env.CONTINUE_ON_ERROR | Should -Be $analysis[0].env.CONTINUE_ON_ERROR
        }
    }
}

Describe 'PSRule repository preparation' {
    BeforeEach {
        $script:installed = @()
        $script:engineVersions = @()
        Mock Get-InstalledModule {
            if ($Name -eq 'PSRule' -and $AllVersions) { return $script:engineVersions }
            $script:installed
        }
        Mock Find-Module {
            if ($Name -eq 'PSRule') { return [pscustomobject]@{ Name = 'PSRule'; Version = '2.9.0' } }
            [pscustomobject]@{ Name = 'PSRule.Rules.Azure'; Version = '1.48.0-preview2' }
        }
        Mock Get-PSRepository { [pscustomobject]@{ SourceLocation = 'https://www.powershellgallery.com/api/v2' } }
        Mock Save-PSRulePackageSet { $Destination }
        Mock Register-PSRepository {}
    }

    It 'does not contact a repository when both action requirements are already registered' {
        $script:installed = @(
            [pscustomobject]@{ Name = 'PSRule'; Version = '2.9.0' }
            [pscustomobject]@{ Name = 'PSRule.Rules.Azure'; Version = '1.47.0' }
        )
        $script:engineVersions = @($script:installed[0])
        Initialize-PSRuleRepository -TemporaryPath $TestDrive | Should -Be 'PSGallery'
        Should -Invoke Find-Module -Exactly 0
        Should -Invoke Save-PSRulePackageSet -Exactly 0
        Should -Invoke Register-PSRepository -Exactly 0
    }

    It 'recognizes the pinned engine even when a higher installed version is listed first' {
        $script:installed = @(
            [pscustomobject]@{ Name = 'PSRule'; Version = '3.0.0' }
            [pscustomobject]@{ Name = 'PSRule.Rules.Azure'; Version = '1.48.0-preview2' }
        )
        $script:engineVersions = @($script:installed[0], [pscustomobject]@{ Name = 'PSRule'; Version = '2.9.0' })
        Initialize-PSRuleRepository -TemporaryPath $TestDrive | Should -Be 'PSGallery'
        Should -Invoke Find-Module -Exactly 0
        Should -Invoke Register-PSRepository -Exactly 0
    }

    It 'resolves the exact action engine and latest prerelease-enabled rules only once' {
        $result = Initialize-PSRuleRepository -TemporaryPath $TestDrive
        $result | Should -BeLike 'avm-psrule-*'
        Should -Invoke Find-Module -Exactly 1 -ParameterFilter { $Name -eq 'PSRule' -and $RequiredVersion -eq '2.9.0' -and -not $AllowPrerelease }
        Should -Invoke Find-Module -Exactly 1 -ParameterFilter { $Name -eq 'PSRule.Rules.Azure' -and $AllowPrerelease -and -not $RequiredVersion }
        Should -Invoke Save-PSRulePackageSet -Exactly 1 -ParameterFilter {
            $Package.Count -eq 2 -and $Package[0].Version -eq '2.9.0' -and
            $Package[1].Version -eq '1.48.0-preview2' -and $Package[1].AllowPrerelease -and
            $Source -eq 'https://www.powershellgallery.com/api/v2'
        }
        Should -Invoke Register-PSRepository -Exactly 1 -ParameterFilter {
            $Name -eq $result -and $SourceLocation -eq (Join-Path $TestDrive $result) -and $InstallationPolicy -eq 'Trusted'
        }
    }

    It 'does not resolve or replace rules already registered for the action' {
        $script:installed = @([pscustomobject]@{ Name = 'PSRule.Rules.Azure'; Version = '1.42.0' })
        $null = Initialize-PSRuleRepository -TemporaryPath $TestDrive
        Should -Invoke Find-Module -Exactly 0 -ParameterFilter { $Name -eq 'PSRule.Rules.Azure' }
        Should -Invoke Save-PSRulePackageSet -Exactly 1 -ParameterFilter { $Package.Count -eq 1 -and $Package[0].Name -eq 'PSRule' }
    }

    It 'does not resolve the already registered engine as a new root' {
        $script:installed = @([pscustomobject]@{ Name = 'PSRule'; Version = '2.9.0' })
        $script:engineVersions = $script:installed
        $null = Initialize-PSRuleRepository -TemporaryPath $TestDrive
        Should -Invoke Find-Module -Exactly 0 -ParameterFilter { $Name -eq 'PSRule' }
        Should -Invoke Save-PSRulePackageSet -Exactly 1 -ParameterFilter { $Package.Count -eq 1 -and $Package[0].Name -eq 'PSRule.Rules.Azure' }
    }

    It 'fails closed on unreadable installation metadata instead of falling back to an install' {
        Mock Get-InstalledModule { throw [IO.IOException]::new('Module metadata is unreadable.') }
        { Initialize-PSRuleRepository -TemporaryPath $TestDrive } | Should -Throw '*metadata is unreadable*'
        Should -Invoke Find-Module -Exactly 0
        Should -Invoke Register-PSRepository -Exactly 0
    }

    It 'does not register a repository when archive preparation fails' {
        Mock Save-PSRulePackageSet { throw [IO.InvalidDataException]::new('Archive recovery exhausted.') }
        { Initialize-PSRuleRepository -TemporaryPath $TestDrive } | Should -Throw '*recovery exhausted*'
        Should -Invoke Register-PSRepository -Exactly 0
    }

    It 'does not silently change the action engine version' {
        Mock Find-Module { [pscustomobject]@{ Name = 'PSRule'; Version = '3.0.0' } } -ParameterFilter { $Name -eq 'PSRule' }
        { Initialize-PSRuleRepository -TemporaryPath $TestDrive } | Should -Throw '*engine could not be resolved*'
        Should -Invoke Save-PSRulePackageSet -Exactly 0
    }
}
