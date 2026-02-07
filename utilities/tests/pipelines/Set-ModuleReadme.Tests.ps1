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

    It '[Set-ModuleReadMe] Parent module: Should generate correct readme' {

        $moduleFolderPath = Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'key-vault' 'vault'
        $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $readMeFilePath = Join-Path $moduleFolderPath 'README.md'

        # Get current hash
        $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

        # Generate ReadMe
        $inputObject = @{
            TemplateFilePath = $templateFilePath
            ErrorAction      = 'Stop'
            ErrorVariable    = 'InvocationError'
        }
        try {
            Set-ModuleReadMe @inputObject
        } catch {
            $InvocationError[-1] | Should -BeNullOrEmpty -Because "Failed to apply the `Set-ModuleReadMe` function due to an error during the function's execution. Please review the inner error(s)."
        }

        # Get hash after 'update'
        $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

        # Compare
        $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
        if (-not $filesAreTheSame) {
            $diffResponse = git diff $readMeFilePath
            Write-Warning ($diffResponse | Out-String) -Verbose

            # Reset readme file to original state
            git checkout HEAD -- $readMeFilePath
        }

        $mdFormattedDiff = ($diffResponse -join '</br>') -replace '\|', '\|'
        $filesAreTheSame | Should -Be $true -Because ('The file hashes before and after applying the `/utilities/tools/Set-AVMModule.ps1` and more precisely the `/utilities/pipelines/sharedScripts/Set-ModuleReadMe.ps1` function should be identical and should not have diff </br><pre>{0}</pre>. Please re-run the `Set-AVMModule` function for this module.' -f $mdFormattedDiff)
    }

    It '[Set-ModuleReadMe] Parent module: Should generate corrrect readme with pre-populated dependencies' {

        $moduleFolderPath = Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'key-vault' 'vault'
        $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $readMeFilePath = Join-Path $moduleFolderPath 'README.md'
        $compiledTestFilePaths = Build-ViaRPC -BicepFilePath (Get-ChildItem -Path $moduleFolderPath -Recurse -File -Filter '*.test.bicep').FullName -PassThru

        # Get current hash
        $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

        # Generate ReadMe
        $inputObject = @{
            TemplateFilePath = $templateFilePath
            PreLoadedContent = @{
                TemplateFileContent       = ConvertFrom-Json (bicep build $templateFilePath --stdout | Out-String) -ErrorAction 'Stop' -AsHashtable
                CrossReferencedModuleList = Get-CrossReferencedModuleList
                TelemetryFileContent      = Invoke-WebRequest -Uri 'https://aka.ms/avm/static/telemetry'
                CompiledTestFiles         = $compiledTestFilePaths
            }
            ErrorAction      = 'Stop'
            ErrorVariable    = 'InvocationError'
        }
        try {
            Set-ModuleReadMe @inputObject
        } catch {
            $InvocationError[-1] | Should -BeNullOrEmpty -Because "Failed to apply the `Set-ModuleReadMe` function due to an error during the function's execution. Please review the inner error(s)."
        }

        # Get hash after 'update'
        $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

        # Compare
        $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
        if (-not $filesAreTheSame) {
            $diffResponse = git diff $readMeFilePath
            Write-Warning ($diffResponse | Out-String) -Verbose

            # Reset readme file to original state
            # git checkout HEAD -- $readMeFilePath
        }

        $mdFormattedDiff = ($diffResponse -join '</br>') -replace '\|', '\|'
        $filesAreTheSame | Should -Be $true -Because ('The file hashes before and after applying the `/utilities/tools/Set-AVMModule.ps1` and more precisely the `/utilities/pipelines/sharedScripts/Set-ModuleReadMe.ps1` function should be identical and should not have diff </br><pre>{0}</pre>. Please re-run the `Set-AVMModule` function for this module.' -f $mdFormattedDiff)
    }

    It '[Set-ModuleReadMe] Child module: Should generate correct readme' {

        $moduleFolderPath = Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'key-vault' 'vault' 'secret'
        $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $readMeFilePath = Join-Path $moduleFolderPath 'README.md'

        # Get current hash
        $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

        # Generate ReadMe
        $inputObject = @{
            TemplateFilePath = $templateFilePath
            ErrorAction      = 'Stop'
            ErrorVariable    = 'InvocationError'
        }
        try {
            Set-ModuleReadMe @inputObject
        } catch {
            $InvocationError[-1] | Should -BeNullOrEmpty -Because "Failed to apply the `Set-ModuleReadMe` function due to an error during the function's execution. Please review the inner error(s)."
        }

        # Get hash after 'update'
        $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

        # Compare
        $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
        if (-not $filesAreTheSame) {
            $diffResponse = git diff $readMeFilePath
            Write-Warning ($diffResponse | Out-String) -Verbose

            # Reset readme file to original state
            git checkout HEAD -- $readMeFilePath
        }

        $mdFormattedDiff = ($diffResponse -join '</br>') -replace '\|', '\|'
        $filesAreTheSame | Should -Be $true -Because ('The file hashes before and after applying the `/utilities/tools/Set-AVMModule.ps1` and more precisely the `/utilities/pipelines/sharedScripts/Set-ModuleReadMe.ps1` function should be identical and should not have diff </br><pre>{0}</pre>. Please re-run the `Set-AVMModule` function for this module.' -f $mdFormattedDiff)

    }

    It '[Set-ModuleReadMe] Multi-scope module: Should generate correct readme' {

        $moduleFolderPath = Join-Path $PSScriptRoot 'src' 'testModules' 'avm' 'res' 'authorization' 'role-assignment' 'sub-scope'
        $templateFilePath = Join-Path $moduleFolderPath 'main.bicep'
        $readMeFilePath = Join-Path $moduleFolderPath 'README.md'

        # Get current hash
        $fileHashBefore = (Get-FileHash $readMeFilePath).Hash

        # Generate ReadMe
        $inputObject = @{
            TemplateFilePath = $templateFilePath
            ErrorAction      = 'Stop'
            ErrorVariable    = 'InvocationError'
        }
        try {
            Set-ModuleReadMe @inputObject
        } catch {
            $InvocationError[-1] | Should -BeNullOrEmpty -Because "Failed to apply the `Set-ModuleReadMe` function due to an error during the function's execution. Please review the inner error(s)."
        }

        # Get hash after 'update'
        $fileHashAfter = (Get-FileHash $readMeFilePath).Hash

        # Compare
        $filesAreTheSame = $fileHashBefore -eq $fileHashAfter
        if (-not $filesAreTheSame) {
            $diffResponse = git diff $readMeFilePath
            Write-Warning ($diffResponse | Out-String) -Verbose

            # Reset readme file to original state
            git checkout HEAD -- $readMeFilePath
        }

        $mdFormattedDiff = ($diffResponse -join '</br>') -replace '\|', '\|'
        $filesAreTheSame | Should -Be $true -Because ('The file hashes before and after applying the `/utilities/tools/Set-AVMModule.ps1` and more precisely the `/utilities/pipelines/sharedScripts/Set-ModuleReadMe.ps1` function should be identical and should not have diff </br><pre>{0}</pre>. Please re-run the `Set-AVMModule` function for this module.' -f $mdFormattedDiff)

    }
}

