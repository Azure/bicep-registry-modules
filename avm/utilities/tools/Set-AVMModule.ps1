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

.PARAMETER SkipBuild
Optional. Set this parameter if you don't want to build/compile the JSON template(s) for the contained `main.bicep` file(s).

.PARAMETER SkipReadMe
Optional. Set this parameter if you don't want to generate the ReadMe file(s) for the module(s).

.PARAMETER SkipFileAndFolderSetup
Optional. Set this parameter if you don't want to setup the file & folder structure for the module(s).

.PARAMETER ThrottleLimit
Optional. The number of parallel threads to use for the generation. Defaults to 5.

.PARAMETER ReadMeScriptFilePath
Optional. The absolute path to the `Set-ModuleReadMe` script. Relevant only if `SkipReadMe` is not set and defaults to the default path of the script in the repository.

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
        [int] $ThrottleLimit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ReadMeScriptFilePath = (Join-Path (Get-Item $PSScriptRoot).Parent.FullName 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
    )

    # Load helper scripts
    . (Join-Path $PSScriptRoot 'helper' 'Set-ModuleFileAndFolderSetup.ps1')

    # Build up module file & folder structure if not yet existing. Should only run if an actual module path was provided (and not any of their parent paths)
    if (-not $SkipFileAndFolderSetup -and ((($ModuleFolderPath -split '\bavm\b')[1].Trim('\,/') -split '[\/|\\]').Count -gt 2)) {
        if ($PSCmdlet.ShouldProcess("File & folder structure for path [$ModuleFolderPath]", "Setup")) {
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $ModuleFolderPath
        }
    }

    if ($Recurse) {
        $relevantTemplatePaths = (Get-ChildItem -Path $ModuleFolderPath -Recurse -File -Filter 'main.bicep').FullName
    }
    else {
        $relevantTemplatePaths = Join-Path $ModuleFolderPath 'main.bicep'
    }

    # Building object with all information we need inside of the context of a thread
    $threadObjects = @() + ($relevantTemplatePaths | ForEach-Object {
            @{
                path          = $_
                scriptsToLoad = @(
                    $ReadMeScriptFilePath
                )
                SkipBuild     = $SkipBuild
                SkipReadMe    = $SkipReadMe
            }
        })

    # Using threading to speed up the process
    if ($PSCmdlet.ShouldProcess(('Building & generation of [{0}] modules in path [{1}]' -f $threadObjects.Count, $ModuleFolderPath), "Execute")) {
        $threadObjects | ForEach-Object -ThrottleLimit $ThrottleLimit -Parallel {
            $resourceTypeIdentifier = 'avm-{0}' -f ($_.path -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] # avm/res/<provider>/<resourceType>

            foreach ($scriptPath in $_.scriptsToLoad) {
                . $scriptPath
            }

            ###############
            ##   Build   ##
            ###############
            if (-not $_.SkipBuild) {
                Write-Output "Building [$resourceTypeIdentifier]"
                bicep build $_.path
            }

            ################
            ##   ReadMe   ##
            ################
            if (-not $_.SkipReadMe) {
                Write-Output "Generating readme for [$resourceTypeIdentifier]"

                # If the template was just build, we can pass the JSON into the readme script to be more efficient
                $readmeTemplateFilePath = (-not $_.SkipBuild) ? (Join-Path (Split-Path $_.path -Parent) 'main.json') : ($_.path)

                Set-ModuleReadMe -TemplateFilePath $readmeTemplateFilePath
            }
        }
    }
}
