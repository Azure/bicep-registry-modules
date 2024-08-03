#region Functions
function LogInfo($message) {
    Log 'Info' $message
}
function LogError($message) {
    Log 'Error' $message
}
function LogWarning($message) {
    Log 'Warning' $message
}

function Log {

    <#
    .SYNOPSIS
    Creates a log file and stores logs based on categories with tab seperation

    .PARAMETER category
    Category to put into the trace

    .PARAMETER message
    Message to be loged

    .EXAMPLE
    Log 'Info' 'Message'

    #>

    Param (
        [Parameter(Mandatory = $false)]
        [string] $category = 'Info',

        [Parameter(Mandatory = $true)]
        [string] $message
    )

    $date = Get-Date
    $content = "[$date]`t$category`t`t$message`n"
    Write-Verbose $Content -Verbose

    $FilePath = Join-Path ([System.IO.Path]::GetTempPath()) 'log.log'
    if (-not (Test-Path $FilePath)) {
        Write-Verbose "Log file not found, create new in path: [$FilePath]" -Verbose
        $null = New-Item -ItemType 'File' -Path $FilePath -Force
    }
    Add-Content -Path $FilePath -Value $content -ErrorAction 'Stop'
}

function Copy-FileAndFolderList {

    param(
        [string] $sourcePath,
        [string] $targetPath
    )

    $itemsFrom = Get-ChildItem $sourcePath
    foreach ($item in $itemsFrom) {
        if ($item.PSIsContainer) {
            $subsourcePath = $sourcePath + '\' + $item.BaseName
            $subtargetPath = $targetPath + '\' + $item.BaseName
            $null = Copy-FileAndFolderList -sourcePath $subsourcePath -targetPath $subtargetPath
        } else {
            $sourceItemPath = $sourcePath + '\' + $item.Name
            $targetItemPath = $targetPath + '\' + $item.Name
            if (-not (Test-Path $targetItemPath)) {
                # only copies non-existing files
                if (-not (Test-Path $targetPath)) {
                    # if folder doesn't exist, creates it
                    $null = New-Item -ItemType 'directory' -Path $targetPath
                }
                $null = Copy-Item $sourceItemPath $targetItemPath
            } else {
                Write-Verbose "[$sourceItemPath] already exists"
            }
        }
    }
}

function Install-CustomModule {

    <#
    .SYNOPSIS
    Installes given PowerShell modules

    .DESCRIPTION
    Installes given PowerShell modules

    .PARAMETER Module
    Required. Modules to be installed, must be Object
    @{
        Name = 'Name'
        Version = '1.0.0' # Optional
    }

    .PARAMETER InstalledModuleList
    Optional. Modules that are already installed on the machine. Can be fetched via 'Get-Module -ListAvailable'

    .EXAMPLE
    Install-CustomModule @{ Name = 'Pester' } C:\Modules

    Installes pester and saves it to C:\Modules
    #>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [Hashtable] $Module,

        [Parameter(Mandatory = $false)]
        [object[]] $InstalledModuleList = @()
    )

    # Remove exsisting module in session
    if (Get-Module $Module -ErrorAction 'SilentlyContinue') {
        try {
            Remove-Module $Module -Force
        } catch {
            LogError('Unable to remove module [{0}] because of exception [{1}]. Stack Trace: [{2}]' -f $Module.Name, $_.Exception, $_.ScriptStackTrace)
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
    $foundModules = Find-Module @moduleImportInputObject

    foreach ($foundModule in $foundModules) {

        # Check if already installed as required
        if ($alreadyInstalled = $InstalledModule | Where-Object { $_.Name -eq $Module.Name }) {
            if ($Module.Version) {
                $alreadyInstalled = $alreadyInstalled | Where-Object { $_.Version -eq $Module.Version }
            } else {
                # Get latest in case of multiple
                $alreadyInstalled = ($alreadyInstalled | Sort-Object -Property Version -Descending)[0]
            }
            LogInfo('[{0}] Module is already installed with version [{1}]' -f $alreadyInstalled.Name, $alreadyInstalled.Version) -Verbose
            continue
        }

        # Check if not to be excluded
        if ($Module.ExcludeModules -and $Module.excludeModules.contains($foundModule.Name)) {
            LogInfo('[{0}] Module is configured to be ignored.' -f $foundModule.Name) -Verbose
            continue
        }

        if ($PSCmdlet.ShouldProcess('Module [{0}]' -f $foundModule.Name, 'Install')) {
            $dependenciesAlreadyAvailable = Get-AreDependenciesAvailable -InstalledModuleList $InstalledModuleList -Module $foundModule
            if ($dependenciesAlreadyAvailable) {
                LogInfo('[{0}] Install module with version [{1}] exluding dependencies.' -f $foundModule.Name, $foundModule.Version) -Verbose
                Install-RawModule -ModuleName $foundModule.Name -ModuleVersion $foundModule.Version
            } else {
                LogInfo('[{0}] Install module with version [{1}] including dependencies' -f $foundModule.Name, $foundModule.Version) -Verbose
                $foundModule | Install-Module -Force -SkipPublisherCheck -AllowClobber
            }
        }

        if ($installed = (Get-Module -Name $foundModule.Name -ListAvailable | Where-Object { $_.Version -eq $foundModule.Version })) {

            # Adding new module to list of 'already installed' modules
            $InstalledModuleList += $installed

            $installPath = Split-Path (Split-Path (Split-Path $installed[0].Path))
            LogInfo('[{0}] Module was installed in path [{2}]' -f $installed[0].Name, $installed[0].Version, $installPath) -Verbose
        } else {
            LogError('Installation of module [{0}] failed' -f $foundModule.Name)
        }
    }
}

function Install-RawModule {
    <#
    .SYNOPSIS
    Install a module without any of its dependencies

    .DESCRIPTION
    Modules are downloaded from the PSGallery and stored in the first path of the PSModulePath environment variable

    .PARAMETER ModuleName
    Mandatory. The name of the module to install

    .PARAMETER ModuleVersion
    Mandatory. The name of the module version to install

    .EXAMPLE
    Install-RawModule -ModuleName 'Az.Compute' -ModuleVersion '4.27.0'

    Install module 'Az.Compute' in version '4.27.0' in the default PSModule installation path
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleName,

        [Parameter(Mandatory)]
        [string] $ModuleVersion
    )

    $url = "https://www.powershellgallery.com/api/v2/package/$ModuleName/$ModuleVersion"

    $downloadFolder = Join-Path ([System.IO.Path]::GetTempPath()) 'modulesToInstall'
    $downloadPath = Join-Path $downloadFolder "$ModuleName.$ModuleVersion.zip" # Assuming [.zip] instead of [.nupkg]
    $expandedRootPath = Join-Path $downloadFolder 'formattedModules'
    $expandedPath = Join-Path $expandedRootPath (Split-Path $downloadPath -LeafBase)
    $newModuleRootFolder = Join-Path $expandedRootPath $ModuleName
    $newModuleRawVersionFolder = (Join-Path $newModuleRootFolder (Split-Path $expandedPath -Leaf))

    if ($IsWindows) { $psModulesPath = ($env:PSModulePath -split ';')[0] }
    else { $psModulesPath = ($env:PSModulePath -split ':')[0] }

    $finalVersionPath = Join-Path $psModulesPath $ModuleName $ModuleVersion

    # 1. Download nupkg package
    if (-not (Test-Path $downloadFolder)) {
        if ($PSCmdlet.ShouldProcess("Folder [$downloadFolder]", 'Create')) {
            $null = New-Item $downloadFolder -ItemType 'Directory'
        }
    }
    try {
        if (-not (Test-Path $downloadPath)) {
            if ($PSCmdlet.ShouldProcess("From url [$url] to path [$downloadPath]", 'Download')) {
                (New-Object System.Net.WebClient).DownloadFile($Url, $downloadPath)
            }
        }
    } catch {
        LogError("Download FAILED: $_")
    }

    if ($IsWindows) {
        # Not supported in Linux
        if ($PSCmdlet.ShouldProcess("File in path [$downloadFolder]", 'Unblock')) {
            Unblock-File -Path $downloadPath
        }
    }

    # 2. Expand Achive
    if (-not (Test-Path $expandedPath)) {
        if ($PSCmdlet.ShouldProcess("File [$downloadPath] to path [$expandedPath]", 'Expand/Unzip')) {
            $null = Expand-Archive -Path $downloadPath -DestinationPath $expandedPath -PassThru
        }
    }

    # 3. Remove files & folders - Optional
    foreach ($fileOrFolderToRemove in @('PSGetModuleInfo.xml', '[Content_Types].xml', '_rels', 'package')) {
        $filePath = Join-Path $expandedPath $fileOrFolderToRemove
        if (Test-Path -LiteralPath $filePath) {
            if ($PSCmdlet.ShouldProcess("Item [$filePath]", 'Remove')) {
                $null = Remove-Item -LiteralPath $filePath -Force -Recurse -ErrorAction 'SilentlyContinue'
            }
        }
    }

    # 4. Rename folder
    $modulename, $moduleVersion = [regex]::Match((Split-Path $downloadPath -LeafBase), '([a-zA-Z.]+)\.([0-9.]+)').Captures.Groups.value[1, 2]
    # Rename-Item -Path $expandedPath -NewName
    if (-not (Test-Path $newModuleRootFolder)) {
        if ($PSCmdlet.ShouldProcess("Folder [$newModuleRootFolder]", 'Create')) {
            $null = New-Item -Path $newModuleRootFolder -ItemType 'Directory'
        }
        if ($PSCmdlet.ShouldProcess("All items from [$expandedPath] to path [$newModuleRootFolder]", 'Move')) {
            $null = Move-Item -LiteralPath $expandedPath -Destination $newModuleRootFolder -Force
        }
        if ($PSCmdlet.ShouldProcess("Folder [$newModuleRawVersionFolder] to name [$ModuleVersion]", 'Rename')) {
            $null = Rename-Item -Path (Join-Path $newModuleRootFolder (Split-Path $expandedPath -Leaf)) -NewName $ModuleVersion
        }
    }

    # 5. Move folder
    if (-not (Test-Path $finalVersionPath)) {
        if ($PSCmdlet.ShouldProcess("All items from [$newModuleRootFolder] to path [$psModulesPath]", 'Move')) {
            $null = Move-Item -LiteralPath $newModuleRootFolder -Destination $psModulesPath -Force
        }
    }
}

function Get-AreDependenciesAvailable {
    <#
    .SYNOPSIS
    Check if all depenencies for a given module are already available in the required minimum version.

    .DESCRIPTION
    Check if all depenencies for a given module are already available in the required minimum version.
    Returns '$true' if they are, otherwise '$false'

    .PARAMETER InstalledModuleList
    Optional. A list of already installed modules.

    .PARAMETER Module
    Optional. The module to check the dependencies  for

    .EXAMPLE
    Get-AreDependenciesAvailable -InstalledModuleList (Get-Module -ListAvailable) -Module (Find-Module 'Az.Compute')

    Check if all dependencies of 'Az.Compute' are part of the already installed modules.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [object[]] $InstalledModuleList = @(),

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $Module
    )

    foreach ($depenency in $Module.dependencies) {

        $dependencyModuleName = $depenency.Name
        $dependencyModuleMinimumVersion = [version] ($depenency.minimumVersion)

        $matchingModulesByName = $InstalledModuleList | Where-Object { $_.Name -eq $dependencyModuleName }
        $matchingModules = $matchingModulesByName | Where-Object { ([version] $_.Version) -ge $dependencyModuleMinimumVersion }

        if ($matchingModules.Count -eq 0) {
            return $false
        }
    }

    return $true
}
#endregion


$StartTime = Get-Date
$progressPreference = 'SilentlyContinue'
LogInfo('#############################################')
LogInfo('#   Entering Initialize-LinuxSoftware.ps1   #')
LogInfo('#############################################')

###########################
##   Install Azure CLI   ##
###########################
LogInfo('Install azure cli start')
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
LogInfo('Install azure cli end')

###############################
##   Install Extensions CLI   #
###############################

LogInfo('Install cli exentions start')
$Extensions = @(
    'azure-devops'
)
foreach ($extension in $Extensions) {
    if ((az extension list-available -o json | ConvertFrom-Json).Name -notcontains $extension) {
        Write-Verbose "Adding CLI extension '$extension'"
        az extension add --name $extension
    }
}
LogInfo('Install cli exentions end')

##########################
##   Install Az Bicep    #
##########################
LogInfo('Install az bicep exention start')
az bicep install
LogInfo('Install az bicep exention end')

#########################
##   Install Kubectl    #
#########################
LogInfo('Install kubectl start')
sudo az aks install-cli
LogInfo('Install kubectl end')

########################
##   Install Docker    #
########################
LogInfo('Install docker start')
sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | sudo apt-key add -

LogInfo('Install docker - Add repository')
sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable' -y

LogInfo('Install docker - adp update')
sudo apt-get update

LogInfo('Install docker - adp-cache docker-ce policy')
apt-cache policy 'docker-ce'

LogInfo('Install docker - adp update')
sudo apt-get update

LogInfo('Install docker - adp-get install docker-ce')
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y 'docker-ce'

LogInfo('Install docker - chmod')
sudo chmod 666 '/var/run/docker.sock' # All users can read and write but cannot execute the file/folder
LogInfo('Install docker end')

###########################
##   Install Terraform   ##
###########################
LogInfo('Install Terraform start')
$terraformReleasesUrl = 'https://api.github.com/repos/hashicorp/terraform/releases/latest'
$latestTerraformVersion = (Invoke-WebRequest -Uri $terraformReleasesUrl -UseBasicParsing | ConvertFrom-Json).name.Replace('v', '')
LogInfo("Fetched latest available version: [$latestTerraformVersion]")

LogInfo("Using version: [$latestTerraformVersion]")
sudo DEBIAN_FRONTEND=noninteractive apt-get install unzip
wget ('https://releases.hashicorp.com/terraform/{0}/terraform_{0}_linux_amd64.zip' -f $latestTerraformVersion)
unzip ('terraform_{0}_linux_amd64.zip' -f $latestTerraformVersion )
sudo mv terraform /usr/local/bin/
terraform --version
LogInfo('Install Terraform end')

#######################
##   Install AzCopy   #
#######################
# Cleanup
sudo rm ./downloadazcopy-v10-linux*
sudo rm ./azcopy_linux_amd64_*
sudo rm /usr/bin/azcopy

# Download
wget https://aka.ms/downloadazcopy-v10-linux -O 'downloadazcopy-v10-linux.tar.gz'

# Expand (to azcopy_linux_amd64_x.x.x)
tar -xzvf downloadazcopy-v10-linux.tar.gz

# Move
sudo cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

##################################
##   Install .NET (for Nuget)   ##
##################################
# Source: https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#1804-
LogInfo('Install dotnet (for nuget) start')

# .NET-Core SDK
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y dotnet-sdk-8.0

# .NET-Core Runtime
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y aspnetcore-runtime-8.0

LogInfo('Install dotnet (for nuget) end')

###########################
##   Install BICEP CLI   ##
###########################
LogInfo('Install BICEP start')

# Fetch the latest Bicep CLI binary
curl -Lo bicep 'https://github.com/Azure/bicep/releases/latest/download/bicep-linux-x64'
# Mark it as executable
chmod +x ./bicep
# Add bicep to your PATH (requires admin)
sudo mv ./bicep /usr/local/bin/bicep
LogInfo('Install BICEP end')

###############################
##   Install PowerShellGet   ##
###############################
LogInfo('Install latest PowerShellGet start')
$null = Install-Module 'PowerShellGet' -Force
LogInfo('Install latest PowerShellGet end')

LogInfo('Import PowerShellGet start')
$null = Import-PackageProvider PowerShellGet -Force
LogInfo('Import PowerShellGet end')

####################################
##   Install PowerShell Modules   ##
####################################
$Modules = @(
    @{ Name = 'Pester'; Version = '5.1.1' },
    @{ Name = 'PSScriptAnalyzer' },
    @{ Name = 'powershell-yaml' },
    @{ Name = 'Azure.*'; ExcludeModules = @('Azure.Storage') }, # Azure.Storage has AzureRM dependency
    @{ Name = 'Logging' },
    @{ Name = 'PoshRSJob' },
    @{ Name = 'ThreadJob' },
    @{ Name = 'JWTDetails' },
    @{ Name = 'OMSIngestionAPI' },
    @{ Name = 'Az.*' },
    @{ Name = 'AzureAD' },
    @{ Name = 'ImportExcel' }
)
$count = 0
LogInfo('Try installing:')
$modules | ForEach-Object {
    LogInfo('- [{0}]. [{1}]' -f $count, $_.Name)
    $count++
}

# Load already installed modules
$installedModules = Get-Module -ListAvailable

LogInfo('Install-CustomModule start')
$count = 0
Foreach ($Module in $Modules) {
    LogInfo('=====================')
    LogInfo('HANDLING MODULE [{0}] [{1}/{2}]' -f $Module.Name, $count, $Modules.Count)
    LogInfo('=====================')
    # Installing New Modules and Removing Old
    $null = Install-CustomModule -Module $Module -InstalledModuleList $installedModules
    $count++
}
LogInfo('Install-CustomModule end')


#########################################
##   Post Installation Configuration   ##
#########################################
LogInfo('Copy PS modules to expected location start')
$targetPath = '/opt/microsoft/powershell/7/Modules'
$sourcePaths = @('/home/packer/.local/share/powershell/Modules', '/root/.local/share/powershell/Modules')
foreach ($sourcePath in $sourcePaths) {
    if (Test-Path $sourcePath) {
        LogInfo("Copying from [$sourcePath] to [$targetPath]")
        $null = Copy-FileAndFolderList -sourcePath $sourcePath -targetPath $targetPath
    }
}
LogInfo('Copy PS modules end')

$elapsedTime = (Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)
LogInfo("Execution took [$totalTime]")
LogInfo('############################################')
LogInfo('#   Exiting Initialize-LinuxSoftware.ps1   #')
LogInfo('############################################')

return 0
#endregion
