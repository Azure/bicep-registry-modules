#requires -Version 6.0

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
            $null = Unblock-File -Path $downloadPath
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

function Set-PowerShellOutputRedirectionBugFix {

    [CmdletBinding(SupportsShouldProcess)]
    param ()

    $poshMajorVerion = $PSVersionTable.PSVersion.Major

    if ($poshMajorVerion -lt 4) {
        try {
            # http://www.leeholmes.com/blog/2008/07/30/workaround-the-os-handles-position-is-not-what-filestream-expected/ plus comments
            $bindingFlags = [Reflection.BindingFlags] 'Instance,NonPublic,GetField'
            $objectRef = $host.GetType().GetField('externalHostRef', $bindingFlags).GetValue($host)
            $bindingFlags = [Reflection.BindingFlags] 'Instance,NonPublic,GetProperty'
            $consoleHost = $objectRef.GetType().GetProperty('Value', $bindingFlags).GetValue($objectRef, @())
            [void] $consoleHost.GetType().GetProperty('IsStandardOutputRedirected', $bindingFlags).GetValue($consoleHost, @())
            $bindingFlags = [Reflection.BindingFlags] 'Instance,NonPublic,GetField'
            $field = $consoleHost.GetType().GetField('standardOutputWriter', $bindingFlags)

            if ($PSCmdlet.ShouldProcess('OutputWriter field [Out]', 'Set')) {
                $field.SetValue($consoleHost, [Console]::Out)
            }

            [void] $consoleHost.GetType().GetProperty('IsStandardErrorRedirected', $bindingFlags).GetValue($consoleHost, @())
            $field2 = $consoleHost.GetType().GetField('standardErrorWriter', $bindingFlags)

            if ($PSCmdlet.ShouldProcess('OutputWriter field [Error]', 'Set')) {
                $field2.SetValue($consoleHost, [Console]::Error)
            }
        } catch {
            LogInfo( 'Unable to apply redirection fix.')
        }
    }
}

function Get-Downloader {
    param (
        [string]$url
    )

    $downloader = New-Object System.Net.WebClient

    $defaultCreds = [System.Net.CredentialCache]::DefaultCredentials
    if ($null -ne $defaultCreds) {
        $downloader.Credentials = $defaultCreds
    }

    if ($env:chocolateyIgnoreProxy -eq 'true') {
        Write-Debug 'Explicitly bypassing proxy due to user environment variable'
        $downloader.Proxy = [System.Net.GlobalProxySelection]::GetEmptyWebProxy()
    } else {
        # check if a proxy is required
        $explicitProxy = $env:chocolateyProxyLocation
        $explicitProxyUser = $env:chocolateyProxyUser
        $explicitProxyPassword = $env:chocolateyProxyPassword
        if ($null -ne $explicitProxy -and $explicitProxy -ne '') {
            # explicit proxy
            $proxy = New-Object System.Net.WebProxy($explicitProxy, $true)
            if ($null -ne $explicitProxyPassword -and $explicitProxyPassword -ne '') {
                $passwd = ConvertTo-SecureString $explicitProxyPassword -AsPlainText -Force
                $proxy.Credentials = New-Object System.Management.Automation.PSCredential ($explicitProxyUser, $passwd)
            }

            Write-Debug "Using explicit proxy server '$explicitProxy'."
            $downloader.Proxy = $proxy

        } elseif (-not $downloader.Proxy.IsBypassed($url)) {
            # system proxy (pass through)
            $creds = $defaultCreds
            if ($null -eq $creds) {
                Write-Debug 'Default credentials were null. Attempting backup method'
                $cred = Get-Credential
                $creds = $cred.GetNetworkCredential()
            }

            $proxyaddress = $downloader.Proxy.GetProxy($url).Authority
            Write-Debug "Using system proxy server '$proxyaddress'."
            $proxy = New-Object System.Net.WebProxy($proxyaddress)
            $proxy.Credentials = $creds
            $downloader.Proxy = $proxy
        }
    }

    return $downloader
}

function Get-DownloadString {
    param (
        [string]$url
    )
    $downloader = Get-Downloader $url

    return $downloader.DownloadString($url)
}

function Get-DownloadedFile {
    param (
        [string]$url,
        [string]$file
    )
    LogInfo( "Downloading $url to $file")
    $downloader = Get-Downloader $url

    $downloader.DownloadFile($url, $file)
}

function Set-SecurityProtocol {

    [CmdletBinding(SupportsShouldProcess)]
    param (
    )

    # Attempt to set highest encryption available for SecurityProtocol.
    # PowerShell will not set this by default (until maybe .NET 4.6.x). This
    # will typically produce a message for PowerShell v2 (just an info
    # message though)
    try {
        # Set TLS 1.2 (3072), then TLS 1.1 (768), then TLS 1.0 (192), finally SSL 3.0 (48)
        # Use integers because the enumeration values for TLS 1.2 and TLS 1.1 won't
        # exist in .NET 4.0, even though they are addressable if .NET 4.5+ is
        # installed (.NET 4.5 is an in-place upgrade).
        if ($PSCmdlet.ShouldProcess('Security protocol', 'Set')) {
            [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192 -bor 48
        }
    } catch {
        LogInfo( 'Unable to set PowerShell to use TLS 1.2 and TLS 1.1 due to old .NET Framework installed. If you see underlying connection closed or trust errors, you may need to do one or more of the following: (1) upgrade to .NET Framework 4.5+ and PowerShell v3, (2) specify internal Chocolatey package location (set $env:chocolateyDownloadUrl prior to install or host the package internally), (3) use the Download + PowerShell method of install. See https://chocolatey.org/install for all install options.')
    }
}

function Install-Choco {

    LogInfo( 'Install choco')

    LogInfo( 'Invoke install.ps1 content')
    $chocTempDir = Join-Path ([System.IO.Path]::GetTempPath()) 'chocolatey'
    $tempDir = Join-Path $chocTempDir 'chocInstall'
    if (-not [System.IO.Directory]::Exists($tempDir)) { [void][System.IO.Directory]::CreateDirectory($tempDir) }
    $file = Join-Path $tempDir 'chocolatey.zip'

    Set-PowerShellOutputRedirectionBugFix

    Set-SecurityProtocol

    LogInfo( 'Getting latest version of the Chocolatey package for download.')
    $url = 'https://chocolatey.org/api/v2/Packages()?$filter=((Id%20eq%20%27chocolatey%27)%20and%20(not%20IsPrerelease))%20and%20IsLatestVersion'
    [xml]$result = Get-DownloadString $url
    $url = $result.feed.entry.content.src

    # Download the Chocolatey package
    LogInfo("Getting Chocolatey from $url.")
    Get-DownloadedFile $url $file

    # Determine unzipping method
    # 7zip is the most compatible so use it by default
    $7zaExe = Join-Path $tempDir '7za.exe'
    $unzipMethod = '7zip'
    if ($env:chocolateyUseWindowsCompression -eq 'true') {
        LogInfo( 'Using built-in compression to unzip')
        $unzipMethod = 'builtin'
    } elseif (-Not (Test-Path ($7zaExe))) {
        LogInfo( 'Downloading 7-Zip commandline tool prior to extraction.')
        # download 7zip
        Get-DownloadedFile 'https://chocolatey.org/7za.exe' "$7zaExe"
    }

    # unzip the package
    LogInfo("Extracting $file to $tempDir...")
    if ($unzipMethod -eq '7zip') {
        LogInfo('Unzip with 7zip')
        $params = "x -o`"$tempDir`" -bd -y `"$file`""
        # use more robust Process as compared to Start-Process -Wait (which doesn't
        # wait for the process to finish in PowerShell v3)
        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = New-Object System.Diagnostics.ProcessStartInfo($7zaExe, $params)
        $process.StartInfo.RedirectStandardOutput = $true
        $process.StartInfo.UseShellExecute = $false
        $process.StartInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
        $process.Start() | Out-Null
        $process.BeginOutputReadLine()
        $process.WaitForExit()
        $exitCode = $process.ExitCode
        $process.Dispose()
        $errorMessage = "Unable to unzip package using 7zip. Perhaps try setting `$env:chocolateyUseWindowsCompression = 'true' and call install again. Error:"
        switch ($exitCode) {
            0 { LogInfo('Processed zip'); break }
            1 { throw "$errorMessage Some files could not be extracted" }
            2 { throw "$errorMessage 7-Zip encountered a fatal error while extracting the files" }
            7 { throw "$errorMessage 7-Zip command line error" }
            8 { throw "$errorMessage 7-Zip out of memory" }
            255 { throw "$errorMessage Extraction cancelled by the user" }
            default { throw "$errorMessage 7-Zip signalled an unknown error (code $exitCode)" }
        }
    } else {
        LogInfo('Unzip without 7zip')
        if ($PSVersionTable.PSVersion.Major -lt 5) {
            try {
                $shellApplication = New-Object -com shell.application
                $zipPackage = $shellApplication.NameSpace($file)
                $destinationFolder = $shellApplication.NameSpace($tempDir)
                $destinationFolder.CopyHere($zipPackage.Items(), 0x10)
            } catch {
                throw "Unable to unzip package using built-in compression. Set `$env:chocolateyUseWindowsCompression = 'false' and call install again to use 7zip to unzip. Error: `n $_"
            }
        } else {
            $null = Expand-Archive -Path $file -DestinationPath $tempDir -Force -PassThru
        }
    }

    # Call chocolatey install
    LogInfo( 'Installing chocolatey on this machine')
    $toolsFolder = Join-Path $tempDir 'tools'
    $chocInstallPS1 = Join-Path $toolsFolder 'chocolateyInstall.ps1'

    & $chocInstallPS1

    LogInfo( 'Ensuring chocolatey commands are on the path')
    $chocInstallVariableName = 'ChocolateyInstall'
    $chocoPath = [Environment]::GetEnvironmentVariable($chocInstallVariableName)
    if ($null -eq $chocoPath -or $chocoPath -eq '') {
        $chocoPath = "$env:ALLUSERSPROFILE\Chocolatey"
    }

    if (-not (Test-Path ($chocoPath))) {
        $chocoPath = "$env:SYSTEMDRIVE\ProgramData\Chocolatey"
    }

    $chocoExePath = Join-Path $chocoPath 'bin'

    if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower()) -eq $false) {
        $env:Path = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    }

    LogInfo( 'Ensuring chocolatey.nupkg is in the lib folder')
    $chocoPkgDir = Join-Path $chocoPath 'lib\chocolatey'
    $nupkg = Join-Path $chocoPkgDir 'chocolatey.nupkg'
    if (-not [System.IO.Directory]::Exists($chocoPkgDir)) { [System.IO.Directory]::CreateDirectory($chocoPkgDir); }
    Copy-Item "$file" "$nupkg" -Force -ErrorAction SilentlyContinue
}


function Uninstall-AzureRM {
    <#
    .SYNOPSIS
    Removes AzureRM from system

    .EXAMPLE
    Uninstall-AzureRM
    Removes AzureRM from system

    #>

    LogInfo('Remove Modules from context start')
    Get-Module 'AzureRM.*' | Remove-Module
    LogInfo('Remaining AzureRM modules: {0}' -f ((Get-Module 'AzureRM.*').Name -join ' | '))
    LogInfo('Remove Modules from context end')

    # Uninstall AzureRm Modules
    try {
        Get-Module 'AzureRm.*' -ListAvailable | Uninstall-Module -Force
    } catch {
        LogError("Unable to remove AzureRM Module: $($_.Exception) found, $($_.ScriptStackTrace)")
    }

    try {
        $AzureRMModuleFolder = 'C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ResourceManager\AzureResourceManager'
        if (Test-Path $AzureRMModuleFolder) {
            $null = Remove-Item $AzureRMModuleFolder -Force -Recurse
            LogInfo("Removed $AzureRMModuleFolder")
        }
    } catch {
        LogError("Unable to remove $AzureRMModuleFolder")
    }

    LogInfo('Remaining installed AzureRMModule: {0}' -f ((Get-Module 'AzureRM.*' -ListAvailable).Name -join ' | '))
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
#endregion

$StartTime = Get-Date
$progressPreference = 'SilentlyContinue'
LogInfo('###############################################')
LogInfo('#   Entering Initialize-WindowsSoftware.ps1   #')
LogInfo('###############################################')

LogInfo( 'Set Execution Policy')
Set-ExecutionPolicy Bypass -Scope Process -Force

#######################
##   Install Choco    #
#######################
LogInfo('Install-Choco start')
$null = Install-Choco
LogInfo('Install-Choco end')

##########################
##   Install Azure CLI   #
##########################
LogInfo('Install azure cli start')
$null = choco install azure-cli -y -v
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

########################
##   Install docker    #
########################
LogInfo('Install docker start')
choco install docker
LogInfo('Install docker end')

#########################
##   Install Kubectl    #
#########################
LogInfo('Install kubectl start')
$null = choco install kubernetes-cli -y -v
LogInfo('Install kubectl end')

########################
##   Install Docker    #
########################
LogInfo('Install docker start')
$null = choco install docker -y -v
# $null = choco install docker-desktop
LogInfo('Install docker end')

#################################
##   Install PowerShell Core    #
#################################
LogInfo('Install powershell core start')
$null = choco install powershell-core -y -v
LogInfo('Install powershell core end')

###########################
##   Install Terraform   ##
###########################
LogInfo('Install Terraform start')
$null = choco install terraform -y -v
LogInfo('Install Terraform end')

#######################
##   Install Nuget   ##
#######################
LogInfo('Update Package Provider Nuget start')
$null = Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
LogInfo('Update Package Provider Nuget end')

#######################
##   Install AzCopy   #
#######################
LogInfo('Install az copy start')
Invoke-WebRequest -Uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile 'AzCopy.zip' -UseBasicParsing
$null = Expand-Archive './AzCopy.zip' './AzCopy' -Force -PassThru
Get-ChildItem './AzCopy/*/azcopy.exe' | Move-Item -Destination 'C:\Users\user\AzCopy\AzCopy.exe'
$userenv = [System.Environment]::GetEnvironmentVariable('Path', 'User')
[System.Environment]::SetEnvironmentVariable('PATH', $userenv + ';C:\Users\user\AzCopy', 'User')
LogInfo('Install az copy end')

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
    @{ Name = 'Pester' },
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
$targetPath = 'C:\program files\powershell\7\Modules'
$sourcePaths = @('C:\Users\packer\Documents\PowerShell\Modules')
foreach ($sourcePath in $sourcePaths) {
    if (Test-Path $sourcePath) {
        LogInfo("Copying from [$sourcePath] to [$targetPath]")
        $null = Copy-FileAndFolderList -sourcePath $sourcePath -targetPath $targetPath
    }
}
LogInfo('Copy PS modules end')

#########################################
##   Post Installation Configuration   ##
#########################################
if (Get-Module AzureRm* -ListAvailable) {
    LogInfo('Un-install ARM start')
    Uninstall-AzureRm
    LogInfo('Un-install ARM end')
}

$elapsedTime = (Get-Date) - $StartTime
$totalTime = '{0:HH:mm:ss}' -f ([datetime]$elapsedTime.Ticks)
LogInfo("Execution took [$totalTime]")
LogInfo('##############################################')
LogInfo('#   Exiting Initialize-WindowsSoftware.ps1   #')
LogInfo('##############################################')

return 0
#endregion
