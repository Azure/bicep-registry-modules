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

.PARAMETER InvokeForDiff
Optional. Build files only for those modules who's files have changed (based on diff of branch to origin/main)

.PARAMETER RepoRootPath
Optional. Path to the root of the repository.

.PARAMETER ForceCacheRefresh
Optional. Define whether or not to force refresh cache data. Note, the cache automatically expires after 1 day.

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

.EXAMPLE
Set-AVMModule -InvokeForDiff

For all modules that have been changed, build the Bicep module template & generate the ReadMe.
#>
function Set-AVMModule {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(ParameterSetName = 'Path', Mandatory = $true)]
        [string] $ModuleFolderPath,

        [Parameter(ParameterSetName = 'Path', Mandatory = $false)]
        [switch] $Recurse,

        [Parameter(ParameterSetName = 'Path', Mandatory = $false)]
        [switch] $SkipFileAndFolderSetup,

        [Parameter(ParameterSetName = 'Diff', Mandatory = $false)]
        [switch] $InvokeForDiff,

        [Parameter(ParameterSetName = 'Diff', Mandatory = $false)]
        [string] $RepoRootPath = (Get-Item -Path $PSScriptRoot).parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [switch] $SkipBuild,

        [Parameter(Mandatory = $false)]
        [switch] $SkipReadMe,

        [Parameter(Mandatory = $false)]
        [switch] $SkipVersionCheck,

        [Parameter(Mandatory = $false)]
        [int] $ThrottleLimit = 5,

        [Parameter(Mandatory = $false)]
        [int] $Depth,

        [Parameter()]
        [switch] $ForceCacheRefresh
    )

    # Load helper scripts
    $readMeFilePath = (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
    $buildRpcFilePath = (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Build-ViaRPC.ps1')

    . (Join-Path $RepoRootPath 'utilities' 'tools' 'helper' 'Set-ModuleFileAndFolderSetup.ps1')
    . (Join-Path $RepoRootPath 'utilities' 'tools' 'helper' 'Test-BicepVersion.ps1')
    . (Join-Path $RepoRootPath 'utilities' 'tools' 'helper' 'Invoke-Async.ps1')
    . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ParentFolderPathList.ps1')
    . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-GitDiff.ps1')
    . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'platform' 'helper' 'Split-Array.ps1')
    . $buildRpcFilePath
    . $readMeFilePath

    # ============ #
    #   Pre-Build  #
    # ============ #
    if ($InvokeForDiff) {
        $resolvedPath = (Test-Path $ModuleFolderPath) ? (Resolve-Path $ModuleFolderPath).Path : $ModuleFolderPath

        $relevantTemplatePaths = @() + (Get-GitDiff -PathOnly -SkipStats | Where-Object { $_ -match '[\/|\\]main\.bicep$' })
        Write-Verbose ('Found [{0}] files in diff' -f $relevantTemplatePaths.Count) -Verbose

        # Handling relevant parent modules that would be affected by a diff in a child
        $parentTemplatePaths = $relevantTemplatePaths | ForEach-Object {
            Get-ParentFolderPathList -Path (Split-Path $_) -Filter 'OnlyModules'
        } | ForEach-Object { Join-Path $_ 'main.bicep' } | Where-Object { Test-Path $_ } | Select-Object -Unique
        Write-Verbose ('Union with [{0}] relevant parent folder template files' -f $parentTemplatePaths.Count) -Verbose
        $relevantTemplatePaths += $parentTemplatePaths
        $relevantTemplatePaths = $relevantTemplatePaths | Sort-Object -Unique

        Write-Verbose ('Running for [{0}] relevant files' -f $relevantTemplatePaths.Count) -Verbose
        $relevantTemplatePaths | ForEach-Object {
            $RelPath = (($_ -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
            Write-Verbose " - $RelPath" -Verbose
        }
    } else {
        $resolvedPath = (Resolve-Path $ModuleFolderPath).Path

        # Build up module file & folder structure if not yet existing. Should only run if an actual module path was provided (and not any of their parent paths)
        if (-not $SkipFileAndFolderSetup -and (($resolvedPath -split '[\\|\/]avm[\\|\/](res|ptn|utl)[\\|\/].+?[\\|\/].+').count -gt 1)) {
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
    }

    if ($relevantTemplatePaths.Count -eq 0) {
        Write-Verbose 'No relevant template paths found.' -Verbose
        return
    }


    if (-not $SkipVersionCheck) {
        Test-BicepVersion
    }

    # ====================== #
    #   Build module files   #
    # ====================== #
    $defaultSplitSize = 50 # The bucket size of templates we want to compile at once (i.e., in each thread)
    if (-not $SkipBuild) {
        $compilationChunks = Split-Array -InputArray $relevantTemplatePaths -SplitSize $defaultSplitSize
        if ($relevantTemplatePaths.Count -le $defaultSplitSize) {
            $compilationChunks = , $compilationChunks
        } else {
            $compilationChunks = $compilationChunks
        }

        $compilationInputObject = @{
            List          = $compilationChunks
            ScriptBlock   = {
                . $using:buildRpcFilePath
                Build-ViaRPC -BicepFilePath $_
            }
            ThrottleLimit = $ThrottleLimit
            ProgressText  = 'Compiled [{0}/{1}] template file batches'
        }
        if ($PSCmdlet.ShouldProcess(('Compiling templates of [{0}] modules in path [{1}]' -f $relevantTemplatePaths.Count, $resolvedPath ?? '<ForDiff>'), 'Execute')) {
            Invoke-Async @compilationInputObject
        }
    }

    # ====================== #
    #   Build readme files   #
    # ====================== #
    if (-not $SkipReadMe) {
        # Load recurring information we'll need for the modules
        .  (Join-Path (Get-Item $PSScriptRoot).Parent.FullName 'pipelines' 'sharedScripts' 'helper' 'Get-CrossReferencedModuleList.ps1')
        # load cross-references
        $crossReferencedModuleList = Get-CrossReferencedModuleList -ForceCacheRefresh:$ForceCacheRefresh

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

        # Collecting & compiling test file paths for usage examples
        # ========================================================
        $testFilePaths = $relevantTemplatePaths | ForEach-Object {
            if (Test-Path (Join-Path (Split-Path $_ -Parent) 'tests' 'e2e')) {
                return (Get-ChildItem -Path (Split-Path $_ -Parent) -Recurse -File -Filter '*.test.bicep').FullName
            }
        }

        $compilationChunks = $testFilePaths ? (Split-Array -InputArray $testFilePaths -SplitSize $defaultSplitSize) : @()
        if ($relevantTemplatePaths.Count -le $defaultSplitSize) {
            $compilationChunks = , $compilationChunks
        } else {
            $compilationChunks = $compilationChunks
        }

        $testFileCompilationInputObject = @{
            List           = $compilationChunks
            ScriptBlock    = {
                . $using:buildRpcFilePath
                return (Build-ViaRPC -BicepFilePath $_ -PassThru)
            }
            ThrottleLimit  = $ThrottleLimit
            ProgressText   = 'Generated [{0}/{1}] test files batches.'
            PassThruObject = @{}
        }


        if ($PSCmdlet.ShouldProcess(('Building [{0}] test templates in path [{1}]' -f $testFilePaths.Count, $resolvedPath ?? '<ForDiff>'), 'Execute')) {
            $compiledTestFilePaths = Invoke-Async @testFileCompilationInputObject
        }

        # ================= #
        #   Build ReadMEs   #
        # ================= #
        $compilationInputObject = @{
            List          = $relevantTemplatePaths
            ScriptBlock   = {
                . $using:readMeFilePath

                $identifierElements = $_ -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]'
                $resourceTypeIdentifier = ('avm/{0}/{1}' -f $identifierElements[1], $identifierElements[2]) -replace '\\', '/' # avm/res/<provider>/<resourceType>
                Write-Output "Generating readme for [$resourceTypeIdentifier]"

                $TemplateFilePath = $_
                $moduleRoot = Split-Path $TemplateFilePath -Parent

                # Select relevant test files
                $relevantTestFilesContent = @{}
                if ($moduleRoot -match '[\/|\\](rg|sub|mg)\-scope$') {
                    $testFolderPath = Split-Path $moduleRoot

                    $scopedModuleFolderName = Split-Path -Path $moduleRoot -Leaf
                    $relevantTestFilePaths = (Get-ChildItem -Path $testFolderPath -Recurse -Filter 'main.test.bicep').FullName | Sort-Object -Culture 'en-US' | Where-Object {
                        $_ -match "[\\|\/]$scopedModuleFolderName.*[\\|\/]main\.test\.bicep$"
                    }
                    foreach ($relevantTestFilePath in $relevantTestFilePaths) {
                        $relevantTestFilesContent[$relevantTestFilePath] = ($using:compiledTestFilePaths)[$relevantTestFilePath]
                    }
                } else {
                    foreach ($filePath in $using:compiledTestFilePaths.Keys) {
                        if ($filePath -match ('{0}[\\|\/]' -f [regex]::Escape($moduleRoot))) {
                            $relevantTestFilesContent[$filePath] = ($using:compiledTestFilePaths)[$filePath]
                        }
                    }
                }

                $readmeInputObject = @{
                    TemplateFilePath  = $TemplateFilePath
                    ForceCacheRefresh = $using:ForceCacheRefresh
                    PreLoadedContent  = @{
                        CrossReferencedModuleList = $using:crossReferencedModuleList
                        TelemetryFileContent      = $using:telemetryFileContent
                        CompiledTestFiles         = $relevantTestFilesContent
                    } + (-not $using:SkipBuild ? @{
                            # If the template was just build, we can pass the JSON into the readme script to be more efficient
                            TemplateFileContent = ConvertFrom-Json (Get-Content (Join-Path (Split-Path $TemplateFilePath -Parent) 'main.json') -Encoding 'utf8' -Raw) -ErrorAction 'Stop' -AsHashtable
                        } : @{})
                }
                Set-ModuleReadMe @readmeInputObject
            }
            ThrottleLimit = $ThrottleLimit
            ProgressText  = 'Generated [{0}/{1}] readme files'
        }
        if ($PSCmdlet.ShouldProcess(('Generating readmes of [{0}] modules in path [{1}]' -f $relevantTemplatePaths.Count, $resolvedPath ?? '<ForDiff>'), 'Execute')) {
            Invoke-Async @compilationInputObject
        }
    }
}
