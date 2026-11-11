<#
.SYNOPSIS
Imports repository-pinned PSRule dependencies for tests that need expansion.

.DESCRIPTION
Uses the already-installed Avm.Authoring module. Missing dependencies are installed
only after a failed exact-version import and when automatic installation is enabled.

.PARAMETER RepoRootPath
The repository root used to resolve the configured tool versions.
#>
function Initialize-PSRuleTest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RepoRootPath
    )

    $ErrorActionPreference = 'Stop'
    foreach ($loaded in @(Get-Module -Name 'Avm.Authoring' -All)) {
        if ($loaded.Version -lt [version] '0.21.0') {
            throw 'Avm.Authoring 0.21.0 or later is required. Start a fresh PowerShell session with the supported module.'
        }
    }
    Import-Module -Name 'Avm.Authoring' -MinimumVersion '0.21.0' -Global -ErrorAction Stop

    foreach ($name in @('PSRule', 'PSRule.Rules.Azure')) {
        $toolInput = @{
            Name = $name
            Path = $RepoRootPath
            SkipModuleVersionCheck = $true
            ErrorAction = 'Stop'
        }
        $tools = @(Get-AvmTool @toolInput)
        $version = $null
        if ($tools.Count -ne 1 -or $tools[0].Name -cne $name -or $tools[0].Kind -cne 'powershell-module' -or
            -not [version]::TryParse([string] $tools[0].Version, [ref] $version)) {
            throw "Avm.Authoring did not resolve exactly one configured $name PowerShell module."
        }
        $tool = $tools[0]
        foreach ($loaded in @(Get-Module -Name $name -All)) {
            if ($loaded.Version -ne $version) {
                throw "$name $($loaded.Version) is already loaded, but $version is required. Start a fresh PowerShell session."
            }
        }
        if ($tool.Status -eq 'auto-install-disabled') {
            throw "$name $version is missing and auto-install is disabled."
        }
        if ($tool.Status -eq 'not-installed') {
            try {
                $null = Import-Module -Name $name -RequiredVersion $version -Global -PassThru -ErrorAction Stop
            } catch [System.IO.FileNotFoundException] {
                if ($_.FullyQualifiedErrorId -notmatch '^Modules_Module(?:WithVersion)?NotFound(?:,|$)') {
                    throw
                }
                $null = Install-AvmTool @toolInput
            }
            $tools = @(Get-AvmTool @toolInput)
            if ($tools.Count -ne 1 -or $tools[0].Name -cne $name -or $tools[0].Kind -cne 'powershell-module' -or
                $tools[0].Version -ne $version.ToString()) {
                throw "The configured $name version changed while resolving its installation."
            }
            $tool = $tools[0]
        }
        if ($tool.Status -notin @('installed', 'installed-on-module-path') -or
            [string]::IsNullOrWhiteSpace($tool.Path) -or -not (Test-Path -LiteralPath $tool.Path -PathType Leaf)) {
            throw "Avm.Authoring did not resolve an installed $name $version manifest (status: '$($tool.Status)')."
        }

        $manifestPath = (Get-Item -LiteralPath $tool.Path).FullName
        $manifestHash = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash
        $manifest = Import-PowerShellDataFile -LiteralPath $manifestPath
        if ((Split-Path $manifestPath -Leaf) -cne "$name.psd1" -or [version] $manifest.ModuleVersion -ne $version) {
            throw "The resolved manifest does not declare $name $version."
        }
        $moduleBase = Split-Path $manifestPath -Parent
        $comparison = $IsWindows ? [StringComparison]::OrdinalIgnoreCase : [StringComparison]::Ordinal
        foreach ($loaded in @(Get-Module -Name $name -All)) {
            if ($loaded.Version -ne $version -or -not [string]::Equals($loaded.ModuleBase, $moduleBase, $comparison)) {
                throw "$name is already loaded from an incompatible version or path. Start a fresh PowerShell session."
            }
        }
        $imported = @(Import-Module -Name $manifestPath -RequiredVersion $version -Global -PassThru -ErrorAction Stop)
        if ((Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash -ne $manifestHash) {
            throw "The $name manifest changed during import."
        }
        if ($imported.Count -ne 1 -or $imported[0].Name -cne $name -or $imported[0].Version -ne $version -or
            -not [string]::Equals($imported[0].ModuleBase, $moduleBase, $comparison)) {
            throw "The imported module does not match the configured $name $version manifest."
        }
    }
}
