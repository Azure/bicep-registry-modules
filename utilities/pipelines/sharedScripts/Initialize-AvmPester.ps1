<#
.SYNOPSIS
Imports the Pester version configured by Avm.Authoring before test discovery.

.DESCRIPTION
Requires Avm.Authoring 0.21.0 or later for managed PowerShell module resolution.
Installs missing prerequisites, respecting the managed tool auto-install policy.
An incompatible loaded module requires a fresh PowerShell session.

.PARAMETER RepoRootPath
Required. Repository root used to resolve the AVM tool configuration.

.EXAMPLE
Initialize-AvmPester -RepoRootPath $PWD.Path
#>
function Initialize-AvmPester {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RepoRootPath
    )

    $ErrorActionPreference = 'Stop'
    $minimumAuthoringVersion = [version] '0.21.0'
    foreach ($loaded in @(Get-Module -Name 'Avm.Authoring' -All)) {
        if ($loaded.Version -lt $minimumAuthoringVersion) {
            throw "Avm.Authoring $($loaded.Version) is already loaded. Version $minimumAuthoringVersion or later is required to select Pester. Update Avm.Authoring and start a fresh PowerShell session."
        }
    }
    if (-not (Get-Module -ListAvailable -Name 'Avm.Authoring' | Where-Object { $_.Version -ge $minimumAuthoringVersion })) {
        Install-Module -Name 'Avm.Authoring' -MinimumVersion $minimumAuthoringVersion -Repository 'PSGallery' -Scope 'CurrentUser' -Force -SkipPublisherCheck -AllowClobber -ErrorAction Stop
    }
    Import-Module -Name 'Avm.Authoring' -MinimumVersion $minimumAuthoringVersion -Global -ErrorAction Stop

    $toolInput = @{
        Name                   = 'Pester'
        Path                   = $RepoRootPath
        SkipModuleVersionCheck = $true
        ErrorAction            = 'Stop'
    }
    $tools = @(Get-AvmTool @toolInput)
    $version = $null
    if ($tools.Count -ne 1 -or $tools[0].Name -cne 'Pester' -or $tools[0].Kind -cne 'powershell-module' -or
        -not [version]::TryParse([string] $tools[0].Version, [ref] $version)) {
        throw 'Avm.Authoring did not resolve exactly one configured Pester PowerShell module with a valid version.'
    }
    $tool = $tools[0]
    $loadedPester = @(Get-Module -Name 'Pester' -All)
    foreach ($loaded in $loadedPester) {
        if ($loaded.Version -ne $version) {
            throw "Pester $($loaded.Version) is already loaded, but Avm.Authoring requires $version. Start a fresh PowerShell session before running tests."
        }
    }

    if ($tool.Status -eq 'auto-install-disabled') {
        throw "Pester $version is not installed and AVM tool auto-install is disabled. Run Install-AvmTool -Name Pester -Path '$RepoRootPath' -SkipModuleVersionCheck before running tests."
    }
    if ($tool.Status -eq 'not-installed') {
        $null = Install-AvmTool @toolInput
        $tools = @(Get-AvmTool @toolInput)
        if ($tools.Count -ne 1 -or $tools[0].Name -cne 'Pester' -or $tools[0].Kind -cne 'powershell-module' -or
            $tools[0].Version -ne $tool.Version) {
            throw 'Avm.Authoring returned a different Pester configuration after installation.'
        }
        $tool = $tools[0]
    }
    if ($tool.Status -notin @('installed', 'installed-on-module-path') -or [string]::IsNullOrWhiteSpace($tool.Path) -or
        -not (Test-Path -LiteralPath $tool.Path -PathType Leaf)) {
        throw "Avm.Authoring did not resolve an installed Pester $version manifest (status: '$($tool.Status)', path: '$($tool.Path)')."
    }

    $manifestPath = (Get-Item -LiteralPath $tool.Path).FullName
    $moduleBase = Split-Path $manifestPath -Parent
    $pathComparison = $IsWindows ? [StringComparison]::OrdinalIgnoreCase : [StringComparison]::Ordinal
    foreach ($loaded in $loadedPester) {
        if (-not [string]::Equals($loaded.ModuleBase, $moduleBase, $pathComparison)) {
            throw "Pester $version is already loaded from '$($loaded.ModuleBase)', not the configured path '$moduleBase'. Start a fresh PowerShell session before running tests."
        }
    }
    $manifest = Import-PowerShellDataFile -LiteralPath $manifestPath -ErrorAction Stop
    if ((Split-Path $manifestPath -Leaf) -cne 'Pester.psd1' -or [version] $manifest.ModuleVersion -ne $version) {
        throw "The resolved manifest '$manifestPath' does not declare Pester $version."
    }
    if ($manifest.RequiredModules) {
        throw "The resolved Pester manifest '$manifestPath' declares module dependencies that cannot be safely imported by this initializer."
    }

    $pester = Import-Module -Name $manifestPath -Global -PassThru -ErrorAction Stop
    if ($pester.Name -cne 'Pester' -or $pester.Version -ne $version -or
        -not [string]::Equals($pester.ModuleBase, $moduleBase, $pathComparison)) {
        throw "The imported module does not match Pester $version at '$moduleBase'. Start a fresh PowerShell session before running tests."
    }
}
