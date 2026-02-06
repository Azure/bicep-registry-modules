param(
    [Parameter(Mandatory = $false)]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

$script:repoRootPath = $repoRootPath

Describe 'Test ReadMe generation' {

    BeforeEach {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Build-ViaRPC.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-CrossReferencedModuleList.ps1')

        Mock Invoke-WebRequest { return @{
                Content = (Get-Content -Path (Join-Path $PSScriptRoot 'src' 'telemetry.md'))
                Headers = @{
                    'Content-Type' = 'text/plain'
                }
            }
        } -ParameterFilter { $Uri -eq 'https://aka.ms/avm/static/telemetry' }
        Mock Get-CrossReferencedModuleList { return ((Get-Content -Path (Join-Path $PSScriptRoot 'src' 'crossReferences.json')) | ConvertFrom-Json -AsHashtable) }
        Mock Invoke-WebRequest { return @{ Content = (Get-Content -Path (Join-Path $PSScriptRoot 'src' 'apiSpecs.json') -Raw) } } -ParameterFilter { $Uri -eq 'https://azure.github.io/Azure-Verified-Modules/governance/apiSpecsList.json' }
        Mock Test-Url { return $true }
        # Mock Set-Content { Write-Verbose 'TEST-LOG: Test readme generation completed' -Verbose } -ParameterFilter { $Path -like '*\README.md' }
    }


    # It '[Parent module] Should run' {

    #     $inputObject = @{
    #         TemplateFilePath = 'C:\dev\ip\bicep-registry-modules\Upstream-Azure\avm\res\key-vault\vault\main.bicep'
    #     }
    #     Set-ModuleReadMe @inputObject
    # }

    # It '[Parent module - Prepoulated] Should run' {

    #     $templateFilePath = 'C:\dev\ip\bicep-registry-modules\Upstream-Azure\avm\res\key-vault\vault\main.bicep'
    #     $ModuleRoot = Split-Path $TemplateFilePath -Parent
    #     $compiledTestFilePaths = Build-ViaRPC -BicepFilePath (Get-ChildItem -Path (Split-Path $ModuleRoot -Parent) -Recurse -File -Filter '*.test.bicep').FullName -PassThru

    #     $inputObject = @{
    #         TemplateFilePath = $templateFilePath
    #         PreLoadedContent = @{
    #             TemplateFileContent       = ConvertFrom-Json (Get-Content (Join-Path (Split-Path $TemplateFilePath -Parent) 'main.json') -Encoding 'utf8' -Raw) -ErrorAction 'Stop' -AsHashtable
    #             CrossReferencedModuleList = Get-CrossReferencedModuleList
    #             TelemetryFileContent      = Invoke-WebRequest -Uri 'https://aka.ms/avm/static/telemetry'
    #             CompiledTestFiles         = $compiledTestFilePaths
    #         }
    #     }
    #     Set-ModuleReadMe @inputObject
    # }

    # It '[Child module] Should run' {

    #     $inputObject = @{
    #         TemplateFilePath = 'C:\dev\ip\bicep-registry-modules\Upstream-Azure\avm\res\key-vault\vault\secret\main.bicep'
    #     }
    #     Set-ModuleReadMe @inputObject
    # }

    # It '[Parent module] Should run' {

    #     $inputObject = @{
    #         TemplateFilePath = (Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'key-vault' 'vault' 'main.bicep')
    #     }
    #     Set-ModuleReadMe @inputObject
    # }

    # It '[Child module] Should run' {

    #     $inputObject = @{
    #         TemplateFilePath = (Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'key-vault' 'vault' 'secret' 'main.bicep')
    #     }
    #     Set-ModuleReadMe @inputObject
    # }

    It '[Multi-scope module] Should run' {

        $inputObject = @{
            TemplateFilePath = (Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'authorization' 'role-assignment' 'sub-scope' 'main.bicep')
        }
        Set-ModuleReadMe @inputObject
    }
}

