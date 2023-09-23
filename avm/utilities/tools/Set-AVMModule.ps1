#requires -version 7.3
function Set-AVMModule {

    [CmdletBinding()]
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
        [int] $ThrottleLimit = 5,

        [Parameter(Mandatory = $false)]
        [string] $ReadMeScriptFilePath = (Join-Path (Get-Item $PSScriptRoot).Parent.FullName 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
    )

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
            Set-ModuleReadMe $_.path
        }
    }
}
Set-AVMModule -ModuleFolderPath 'C:\dev\ip\Azure-bicep-registry-modules\eriqua-fork\avm\res\network\private-endpoint' -Recurse