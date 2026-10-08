# Note: The installation commands in this script are optimized for Linux

#region Helper Functions
<#
.SYNOPSIS
Installes given PowerShell modules

.DESCRIPTION
Installes given PowerShell modules
Reuses installed modules that satisfy the request without querying PSGallery.
Retries no-op default repository registration and a known pre-install archive failure once.
Other resolution, installation, and exact-module import failures terminate the command.

.PARAMETER Module
Required. Modules to be installed, must be Object
@{
    Name = 'Name'
    Version = '1.0.0' # Optional
}

.PARAMETER InstalledModule
Optional. Modules that are already installed on the machine. Can be fetched via 'Get-Module -ListAvailable'

.EXAMPLE
Install-CustomModule @{ Name = 'Pester' } C:\Modules

Installes pester and saves it to C:\Modules
#>
function Install-CustomModule {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [Hashtable] $Module,

        [Parameter(Mandatory = $false)]
        [object[]] $InstalledModule = @()
    )

    $alreadyInstalled = @($InstalledModule | Where-Object { $_.Name -eq $Module.Name -and
            (-not $Module.Version -or $_.Version -eq $Module.Version) } |
            Sort-Object -Culture 'en-US' -Property 'Version' -Descending)
    if ($alreadyInstalled.Count -gt 0) {
        Write-Verbose ('Module [{0}] already installed with version [{1}]' -f $alreadyInstalled[0].Name, $alreadyInstalled[0].Version) -Verbose
        return
    }

    $gallery = Get-PSRepository -ErrorAction Stop | Where-Object Name -EQ 'PSGallery'
    for ($attempt = 1; -not $gallery; $attempt++) {
        if (-not $PSCmdlet.ShouldProcess('PSGallery', 'Register default PowerShell repository')) {
            return
        }
        Write-Verbose 'Registering the default PowerShell Gallery repository.' -Verbose
        Register-PSRepository -Default -ErrorAction Stop
        $gallery = Get-PSRepository -ErrorAction Stop | Where-Object Name -EQ 'PSGallery'
        if (-not $gallery) {
            if ($attempt -eq 2) {
                throw 'PSGallery is not available after 2 default registration attempts.'
            }
            Write-Warning 'Default registration did not create PSGallery. Retrying once.'
            Start-Sleep -Seconds 2
        }
    }

    # Install found module
    $moduleImportInputObject = @{
        name       = $Module.Name
        Repository = 'PSGallery'
    }
    if ($Module.Version) {
        $moduleImportInputObject['RequiredVersion'] = $Module.Version
    }

    # Get all modules that match a certain name. In case of e.g. 'Az' it returns several.
    $foundModules = @(Find-Module @moduleImportInputObject -ErrorAction Stop)
    if ($foundModules.Count -eq 0) {
        throw ('Required module [{0}] could not be resolved from PSGallery.' -f $Module.Name)
    }

    foreach ($foundModule in $foundModules) {

        # Check if not to be excluded
        if ($Module.ExcludeModules -and $Module.excludeModules.contains($foundModule.Name)) {
            Write-Verbose ('Module {0} is configured to be ignored.' -f $foundModule.Name) -Verbose
            continue
        }

        Write-Verbose ('Install module [{0}] with version [{1}]' -f $foundModule.Name, $foundModule.Version) -Verbose
        if ($PSCmdlet.ShouldProcess('Module [{0}]' -f $foundModule.Name, 'Install')) {
            for ($attempt = 1; $attempt -le 2; $attempt++) {
                try {
                    $foundModule | Install-Module -Force -SkipPublisherCheck -AllowClobber -ErrorAction Stop
                    break
                } catch {
                    $archiveErrorId = "Package '{0}' failed to be installed because: {1},Microsoft.PowerShell.PackageManagement.Cmdlets.InstallPackage"
                    $archiveErrorMessage = "Package '$($foundModule.Name)' failed to be installed because: End of Central Directory record could not be found."
                    if ($attempt -eq 2 -or $_.FullyQualifiedErrorId -cne $archiveErrorId -or
                        $_.CategoryInfo.Category -ne [System.Management.Automation.ErrorCategory]::InvalidResult -or
                        $_.TargetObject -cne $foundModule.Name -or $_.Exception.Message -cne $archiveErrorMessage -or
                        -not $foundModule.PSObject.Properties['Dependencies'] -or
                        $null -eq $foundModule.Dependencies -or $foundModule.Dependencies.Count -ne 0) {
                        throw
                    }

                    # Retry only the verified fresh-staging contract for dependency-free modules.
                    $powerShellGet = @(Get-Module -Name PowerShellGet -ErrorAction Stop)
                    $packageManagement = @(Get-Module -Name PackageManagement -ErrorAction Stop)
                    $nuGet = @(Get-PackageProvider -ErrorAction Stop | Where-Object Name -EQ 'NuGet')
                    if ($powerShellGet.Count -ne 1 -or $powerShellGet[0].Version -ne [version] '2.2.5' -or
                        $packageManagement.Count -ne 1 -or $packageManagement[0].Version -ne [version] '1.4.8.1' -or
                        $nuGet.Count -ne 1 -or $nuGet[0].Version -ne [version] '3.0.0.1') {
                        throw
                    }
                    Write-Warning ('Module [{0}] version [{1}] returned an invalid archive. Retrying once with a fresh download.' -f $foundModule.Name, $foundModule.Version)
                    Start-Sleep -Seconds 2
                }
            }

            $version = [version] $foundModule.Version
            $installed = @(Get-Module -Name $foundModule.Name -ListAvailable -ErrorAction Stop |
                    Where-Object { $_.Version -eq $version })
            if ($installed.Count -eq 0) {
                throw ('Installation of module [{0}] failed' -f $foundModule.Name)
            }

            $moduleBase = $installed[0].ModuleBase
            $pathComparison = $IsWindows ? [StringComparison]::OrdinalIgnoreCase : [StringComparison]::Ordinal
            foreach ($loaded in (Get-Module -Name $foundModule.Name -ErrorAction Stop)) {
                if ($loaded.Version -ne $version -or -not [string]::Equals($loaded.ModuleBase, $moduleBase, $pathComparison)) {
                    throw ('Module [{0}] is already loaded from a different version or path. Start a fresh PowerShell session.' -f $foundModule.Name)
                }
            }
            $manifestPath = Join-Path $moduleBase "$($foundModule.Name).psd1"
            if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
                throw ('Installation of module [{0}] did not produce its manifest [{1}].' -f $foundModule.Name, $manifestPath)
            }
            $specification = @{ ModuleName = $manifestPath; RequiredVersion = $version }
            $imported = @(Import-Module -FullyQualifiedName $specification -Global -PassThru -ErrorAction Stop)
            if ($imported.Count -ne 1 -or $imported[0].Name -cne $foundModule.Name -or $imported[0].Version -ne $version -or
                -not [string]::Equals($imported[0].ModuleBase, $moduleBase, $pathComparison)) {
                throw ('The imported module does not match [{0}] version [{1}] at [{2}].' -f $foundModule.Name, $version, $moduleBase)
            }
            Write-Verbose ('Module [{0}] is installed with version [{1}]' -f $foundModule.Name, $version) -Verbose
        }
    }
}
#endregion

<#
.SYNOPSIS
Configure the current agent

.DESCRIPTION
Configure the current agent with e.g. the necessary PowerShell modules.

.PARAMETER PSModules
Optional. The PowerShell modules that should be installed on the agent.

@(
    @{ Name = 'Az.Accounts' },
    @{ Name = 'Az.Compute' },
    @{ Name = 'Az.Resources' },
    @{ Name = 'Az.ContainerRegistry' },
    @{ Name = 'Az.KeyVault' },
    @{ Name = 'Az.RecoveryServices' },
    @{ Name = 'Az.Monitor' },
    @{ Name = 'Az.CognitiveServices' },
    @{ Name = 'Az.OperationalInsights' },
    @{
        Name = 'Pester'
        Version = '5.3.1' # Version is optional
    }
)

.PARAMETER InstallLatestPwshVersion
Optional. Enable to install the latest PowerShell version

.EXAMPLE
Set-EnvironmentOnAgent

Install the default PowerShell modules to configure the agent

.EXAMPLE
$modules = @(
    @{ Name = 'Az.Accounts' },
    @{ Name = 'Az.Resources' }
)
Set-EnvironmentOnAgent -PSModules $modules

Install the given PowerShell modules to configure the agent.
#>
function Set-EnvironmentOnAgent {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Hashtable[]] $PSModules = @(),

        [Parameter(Mandatory = $false)]
        [switch] $InstallLatestPwshVersion
    )

    ############################
    ##   PowerShell version   ##
    ############################

    Write-Verbose 'Powershell version:' -Verbose
    $PSVersionTable

    ###########################
    ##   Install Azure CLI   ##
    ###########################

    # AzCLI is pre-installed on GitHub hosted runners.
    # https://github.com/actions/virtual-environments#available-environments

    Write-Verbose 'Az CLI version:' -Verbose
    az --version
    <#
    Write-Verbose ("Install azure cli start") -Verbose
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    Write-Verbose ("Install azure cli end") -Verbose
    #>

    ##############################
    ##   Install Bicep for CLI   #
    ##############################

    # Bicep CLI is pre-installed on GitHub hosted runners.
    # https://github.com/actions/virtual-environments#available-environments
    # Adding a step to explicitly install the latest Bicep CLI because there is
    # always a delay in updating Bicep CLI in the job runner environments.

    Write-Verbose 'Preinstalled Bicep CLI version:' -Verbose
    bicep --version

    Write-Verbose ('Install latest Bicep CLI') -Verbose
    # Fetch the latest Bicep CLI binary
    curl -Lo bicep 'https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64'
    # Mark it as executable
    chmod +x ./bicep
    # Add Bicep to your PATH (requires admin)
    sudo mv ./bicep /usr/local/bin/bicep

    Write-Verbose 'Bicep CLI version after install:' -Verbose
    bicep --version

    ###############################
    ##   Install Extensions CLI   #
    ###############################

    # Azure CLI extension for DevOps is pre-installed on GitHub hosted runners.
    # https://github.com/actions/virtual-environments#available-environments

    Write-Verbose 'AZ CLI extensions:' -Verbose
    az extension list | ConvertFrom-Json | Select-Object -Property 'name', 'version', 'preview', 'experimental'

    <#
    Write-Verbose ('Install cli exentions start') -Verbose
    $Extensions = @(
        'azure-devops'
    )
    foreach ($extension in $Extensions) {
        if ((az extension list-available -o json | ConvertFrom-Json).Name -notcontains $extension) {
            Write-Verbose "Adding CLI extension '$extension'" -Verbose
            az extension add --name $extension
        }
    }
    Write-Verbose ('Install cli exentions end') -Verbose
    #>

    ####################################
    ##   Install PowerShell Modules   ##
    ####################################

    $count = 1
    Write-Verbose ('Try installing:') -Verbose
    $PSModules | ForEach-Object {
        Write-Verbose ('- {0}. [{1}]' -f $count, $_.Name) -Verbose
        $count++
    }

    # MS-hosted agents have pre-installed modules in a specific path. Let's make them discoverable if available.
    # Always create the $profile if it does not exist (to avoid later need of case handling)
    if (-not (Test-Path $profile)) {
        $null = New-Item -Path $profile -Force
    }
    if ((Test-Path '/usr/share/') -and ((Get-ChildItem -Path '/usr/share/az_*' -Directory).Count -gt 0)) {
        $preInstalledModulePaths = Get-ChildItem -Path '/usr/share/az_*' -Directory
        $maximumVersionPath = '/usr/share/az_{0}' -f (($preInstalledModulePaths | ForEach-Object { ($_ -split 'az_')[1] }) | ForEach-Object { [version]$_ } | Measure-Object -Maximum ).Maximum
        Write-Verbose "Found pre-installed modules in path [$maximumVersionPath]. Adding it PSModulePath environment variable." -Verbose

        if ($IsWindows) {
            # Set step module path (process)
            $env:PSModulePath += ";$maximumVersionPath"
            # Set job module path (machine)
            [Environment]::SetEnvironmentVariable('PSModulePath', ('{0};{1}' -f ([Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')), $maximumVersionPath), 'Machine')
            # Set PS-Profile (for non-ps tasks)
            Add-Content -Path $profile -Value "`$env:PSModulePath += `";$maximumVersionPath`""
        } else {
            # Set step module path (process)
            $env:PSModulePath += ":$maximumVersionPath"
            # Set job module path (machine)
            [Environment]::SetEnvironmentVariable('PSModulePath', ('{0}:{1}' -f ([Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')), $maximumVersionPath), 'Machine')
            # Set PS-Profile (for non-ps tasks)
            Add-Content -Path $profile -Value "`$env:PSModulePath += `":$maximumVersionPath`""
        }
    }

    # Load already installed modules
    $installedModules = Get-Module -ListAvailable

    Write-Verbose ('Install-CustomModule start') -Verbose
    $count = 1
    Foreach ($Module in $PSModules) {
        Write-Verbose ('=====================') -Verbose
        Write-Verbose ('HANDLING MODULE [{0}/{1}] [{2}] ' -f $count, $PSModules.Count, $Module.Name) -Verbose
        Write-Verbose ('=====================') -Verbose
        # Installing New Modules and Removing Old
        $null = Install-CustomModule -Module $Module -InstalledModule $installedModules
        $count++
    }

    Write-Verbose ('Install-CustomModule end') -Verbose
}

if ($InstallLatestPwshVersion) {
    Write-Verbose '=======================' -Verbose
    Write-Verbose 'PowerShell installation' -Verbose
    Write-Verbose '=======================' -Verbose

    # Update the list of packages
    sudo apt-get update
    # Install pre-requisite packages.
    sudo apt-get install -y wget apt-transport-https software-properties-common
    # Download the Microsoft repository GPG keys
    wget -q "https://packages.microsoft.com/config/ubuntu/`$(lsb_release -rs)/packages-microsoft-prod.deb"
    # Register the Microsoft repository GPG keys
    sudo dpkg -i packages-microsoft-prod.deb
    # Update the list of packages after we added packages.microsoft.com
    sudo apt-get update
    # Install PowerShell
    sudo apt-get install -y powershell
}
