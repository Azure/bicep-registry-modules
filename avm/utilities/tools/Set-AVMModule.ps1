#requires -version 7.3
<#
.SYNOPSIS
Create/update all content of an AVM module that can be generated for the user

.DESCRIPTION
Create/update all content of an AVM module that can be generated for the user
This includes
- The `main.json` template(s)
- The `README.md` file(s)

.PARAMETER ModuleFolderPath
Mandatory. The path to the module folder to generate the content for.

.PARAMETER Recurse
Optional. Set this parameter if you not only want to generate the content for one module, but also any nested module in the same path.

.PARAMETER Depth
Optional. Recursion depth for the module search.

.PARAMETER SkipBuild
Optional. Set this parameter if you don't want to build/compile the JSON template(s) for the contained `main.bicep` file(s).

.PARAMETER SkipReadMe
Optional. Set this parameter if you don't want to generate the ReadMe file(s) for the module(s).

.PARAMETER SkipFileAndFolderSetup
Optional. Set this parameter if you don't want to setup the file & folder structure for the module(s).

.PARAMETER ThrottleLimit
Optional. The number of parallel threads to use for the generation.

.PARAMETER SkipVersionCheck
Optional. Do not check for the latest Bicep CLI version.

.EXAMPLE
Set-AVMModule -ModuleFolderPath 'C:\avm\res\key-vault\vault'

For the [key-vault\vault] module, build the Bicep module template & generate its ReadMe.

.EXAMPLE
Set-AVMModule -ModuleFolderPath 'C:\avm\res\key-vault\vault' -Recurse

For the [key-vault\vault] module or any of its children, build the Bicep module template & generate the ReadMe.

.EXAMPLE
Set-AVMModule -ModuleFolderPath 'C:\avm\res\key-vault\vault' -Recurse -SkipReadMe

For the [key-vault\vault] module or any of its children, build only the Bicep module template.

.EXAMPLE
Set-AVMModule -ModuleFolderPath 'C:\avm\res' -Recurse

For all modules in path [C:\avm\res], build the Bicep module template & generate the ReadMe.
#>
function Set-AVMModule {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $false)]
        [switch] $Recurse,

        [Parameter(Mandatory = $false)]
        [switch] $SkipBuild,

        [Parameter(Mandatory = $false)]
        [switch] $SkipReadMe,

        [Parameter(Mandatory = $false)]
        [switch] $SkipFileAndFolderSetup,

        [Parameter(Mandatory = $false)]
        [switch] $SkipVersionCheck,

        [Parameter(Mandatory = $false)]
        [int] $ThrottleLimit = 5,

        [Parameter(Mandatory = $false)]
        [int] $Depth
    )

    # # Load helper scripts
    . (Join-Path $PSScriptRoot 'helper' 'Set-ModuleFileAndFolderSetup.ps1')

    $resolvedPath = (Resolve-Path $ModuleFolderPath).Path

    # Build up module file & folder structure if not yet existing. Should only run if an actual module path was provided (and not any of their parent paths)
    if (-not $SkipFileAndFolderSetup -and ((($resolvedPath -split '\bavm\b')[1].Trim('\,/') -split '[\/|\\]').Count -gt 2)) {
        if ($PSCmdlet.ShouldProcess("File & folder structure for path [$resolvedPath]", 'Setup')) {
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $resolvedPath
        }
    }

    if ($Recurse) {
        $childInput = @{
            Path    = $resolvedPath
            Recurse = $Recurse
            File    = $true
            Filter  = 'main.bicep'
        }
        if ($Depth) {
            $childInput.Depth = $Depth
        }
        $relevantTemplatePaths = (Get-ChildItem @childInput).FullName
    } else {
        $relevantTemplatePaths = Join-Path $resolvedPath 'main.bicep'
    }

    if (-not $SkipVersionCheck) {

        # Get latest release from Azure/Bicep repository
        # ----------------------------------------------
        $latestReleaseUrl = 'https://api.github.com/repos/azure/bicep/releases/latest'
        try {
            $latestReleaseObject = Invoke-RestMethod -Uri $latestReleaseUrl -Method 'GET'
        } catch {
            Write-Warning "Skipping Bicep version check as url [$latestReleaseUrl] did not return a response."
        }
        if ($latestReleaseObject) {
            # Only run if connected to the internet / url returns a response
            $releaseTag = $latestReleaseObject.tag_name
            $latestReleaseVersion = [version]($releaseTag -replace 'v', '')
            $latestReleaseUrl = $latestReleaseObject.html_url

            # Get latest installed Bicep CLI version
            # --------------------------------------
            $latestInstalledVersionOutput = bicep --version

            if ($latestInstalledVersionOutput -match ' ([0-9]+\.[0-9]+\.[0-9]+) ') {
                $latestInstalledVersion = [version]$matches[1]
            }

            # Compare the versions
            # --------------------
            if ($latestInstalledVersion -ne $latestReleaseVersion) {
                Write-Warning """
You're not using the latest available Bicep CLI version [$latestReleaseVersion] but [$latestInstalledVersion].
You can find the latest release at: $latestReleaseUrl.

On Windows, you can use winget to update the Bicep CLI by running 'winget update Microsoft.Bicep' or chocolatey via 'choco upgrade bicep'.
For other OSs, please refer to the Bicep documentation (https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install).

Note: The 'Bicep CLI' version (bicep --version) is not the same as the 'Azure CLI Bicep extension' version (az bicep version).
"""
            } else {
                Write-Verbose "You're using the latest available Bicep CLI version [$latestInstalledVersion]."
            }
        }
    }

    # Load recurring information we'll need for the modules
    if (-not $SkipReadMe) {
        .  (Join-Path (Get-Item $PSScriptRoot).Parent.FullName 'pipelines' 'sharedScripts' 'helper' 'Get-CrossReferencedModuleList.ps1')
        # load cross-references
        $crossReferencedModuleList = Get-CrossReferencedModuleList

        # load AVM references (done to reduce WebRequests to GitHub repository)
        # Telemetry
        $telemetryUrl = 'https://aka.ms/avm/static/telemetry'
        try {
            $rawResponse = Invoke-WebRequest -Uri $telemetryUrl
            if (($rawResponse.Headers['Content-Type'] | Out-String) -like '*text/plain*') {
                $TelemetryFileContent = $rawResponse.Content -split '\n'
            } else {
                Write-Warning "Failed to fetch telemetry information from [$telemetryUrl]. NOTE: You should re-run the script again at a later stage to ensure all data is collected and the readme correctly populated." # Incorrect Url (e.g., points to HTML)
                $TelemetryFileContent = $null
            }
        } catch {
            Write-Warning "Failed to fetch telemetry information from [$telemetryUrl]. NOTE: You should re-run the script again at a later stage to ensure all data is collected and the readme correctly populated." # Invalid url
            $TelemetryFileContent = $null
        }

        # create reference as it must be loaded in the thread to work
        $ReadMeScriptFilePath = (Join-Path (Get-Item $PSScriptRoot).Parent.FullName 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
    } else {
        # Instatiate values to enable safe $using usage
        $crossReferencedModuleList = $null
        $ReadMeScriptFilePath = $null
        $TelemetryFileContent = $null
    }

    # Using threading to speed up the process
    if ($PSCmdlet.ShouldProcess(('Building & generation of [{0}] modules in path [{1}]' -f $relevantTemplatePaths.Count, $resolvedPath), 'Execute')) {
        try {
            $job = $relevantTemplatePaths | ForEach-Object -ThrottleLimit $ThrottleLimit -AsJob -Parallel {
                $identifierElements = $_ -split '[\/|\\]avm[\/|\\](res|ptn)[\/|\\]'
                $resourceTypeIdentifier = ('avm/{0}/{1}' -f $identifierElements[1], $identifierElements[2]) -replace '\\', '/' # avm/res/<provider>/<resourceType>

                ###############
                ##   Build   ##
                ###############
                if (-not $using:SkipBuild) {
                    Write-Output "Building [$resourceTypeIdentifier]"
                    bicep build $_
                }

                ################
                ##   ReadMe   ##
                ################
                if (-not $using:SkipReadMe) {
                    Write-Output "Generating readme for [$resourceTypeIdentifier]"

                    . $using:ReadMeScriptFilePath
                    $readmeInputObject = @{
                        TemplateFilePath = $_
                        PreLoadedContent = @{
                            CrossReferencedModuleList = $using:crossReferencedModuleList
                            TelemetryFileContent      = $using:TelemetryFileContent
                        } + (-not $using:SkipBuild ? @{
                                # If the template was just build, we can pass the JSON into the readme script to be more efficient
                                TemplateFileContent = ConvertFrom-Json (Get-Content (Join-Path (Split-Path $_ -Parent) 'main.json') -Encoding 'utf8' -Raw) -ErrorAction 'Stop' -AsHashtable
                            } : @{})
                    }
                    Set-ModuleReadMe @readmeInputObject
                }
            }

            do {
                # Sleep a bit to allow the threads to run - adjust as desired.
                Start-Sleep -Seconds 0.5

                # Determine how many jobs have completed so far.
                $completedJobsCount = ($job.ChildJobs | Where-Object { $_.State -notin @('NotStarted', 'Running') }).Count

                # Relay any pending output from the child jobs.
                $job | Receive-Job

                # Update the progress display.
                [int] $percent = ($completedJobsCount / $job.ChildJobs.Count) * 100
                Write-Progress -Activity ("Processed [$completedJobsCount/{0}] files" -f $relevantTemplatePaths.Count) -Status "$percent% complete" -PercentComplete $percent

            } while ($completedJobsCount -lt $job.ChildJobs.Count)

            # Clean up the job.
            $job | Remove-Job
        } finally {
            # In case the user cancelled the process, we need to make sure to stop all running jobs
            $job | Remove-Job -Force -ErrorAction 'SilentlyContinue'
        }
    }
}
