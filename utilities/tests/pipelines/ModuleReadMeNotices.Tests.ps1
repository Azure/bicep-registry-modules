param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Module README notices' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
    }

    BeforeEach {
        $script:modulePath = Join-Path $TestDrive ([guid]::NewGuid().ToString()) 'avm' 'ptn' 'example' 'module'
        $null = New-Item -Path $script:modulePath -ItemType Directory -Force
        $script:templatePath = Join-Path $script:modulePath 'main.bicep'
        $script:readMePath = Join-Path $script:modulePath 'README.md'
        Set-Content -LiteralPath $script:templatePath -Value 'This fixture must not be compiled.'
        Set-Content -LiteralPath (Join-Path $script:modulePath 'version.json') -Value '{"version":"1.0.0"}'
        Set-Content -LiteralPath $script:readMePath -Value @(
            '# Original title'
            ''
            '> Legacy orphan notice'
            ''
            '## Notes'
            ''
            'Keep these manual notes.'
        )
        $script:readMeInput = @{
            TemplateFilePath  = $script:templatePath
            PreLoadedContent  = @{
                TemplateFileContent = @{
                    metadata   = @{ name = 'Example Module'; description = 'A preserved module description.' }
                    parameters = @{ name = @{ type = 'string'; metadata = @{ description = 'Required. The name.' } } }
                    outputs    = @{ name = @{ type = 'string'; value = '[parameters(''name'')]'; metadata = @{ description = 'The name.' } } }
                }
            }
            SectionsToRefresh = @('Parameters', 'Outputs', 'Navigation')
            PassThru          = $true
            ErrorAction       = 'Stop'
        }
        Mock Invoke-WebRequest { throw 'README notice tests must not access the network.' }
        Mock Invoke-RestMethod { throw 'README notice tests must not access the network.' }
    }

    AfterEach {
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
    }

    It 'ignores legacy markers and removes old notices without changing other generated content' {
        $baseline = Set-ModuleReadMe @script:readMeInput
        Set-Content -LiteralPath (Join-Path $script:modulePath 'ORPHANED.md') -Value 'Legacy orphan notice'

        $result = Set-ModuleReadMe @script:readMeInput

        $result | Should -BeExactly $baseline
        $result | Should -Not -Match 'Legacy orphan notice'
        $result | Should -Match 'A preserved module description\.'
        $result | Should -Match 'Keep these manual notes\.'
        $result | Should -Match '## Parameters'
        $result | Should -Match '## Outputs'
        $result | Should -Match 'br/public:avm/ptn/example/module:<version>'
        Get-Content -LiteralPath $script:readMePath -Raw | Should -Match 'Legacy orphan notice'
    }

    It 'does not require README changes when ownership is removed or adopted' {
        $metadataPath = Join-Path $script:modulePath 'metadata.json'
        Set-Content -LiteralPath $metadataPath -Value '{"owners":[]}'
        $ownerless = Set-ModuleReadMe @script:readMeInput

        Set-Content -LiteralPath $metadataPath -Value '{"owners":["@Azure/module-owners"]}'
        $adopted = Set-ModuleReadMe @script:readMeInput

        $adopted | Should -BeExactly $ownerless
        $ownerless | Should -Not -Match 'orphan'
    }

    It 'preserves <NoticeFile> behavior while ignoring the old orphan marker' -ForEach @(
        @{ NoticeFile = 'DEPRECATED.md' }
        @{ NoticeFile = 'MOVED-TO-AVM.md' }
    ) {
        Set-Content -LiteralPath (Join-Path $script:modulePath $NoticeFile) -Value 'Important retained notice'
        $baseline = Set-ModuleReadMe @script:readMeInput
        Set-Content -LiteralPath (Join-Path $script:modulePath 'ORPHANED.md') -Value 'Legacy orphan notice'

        $result = Set-ModuleReadMe @script:readMeInput

        $result | Should -BeExactly $baseline
        $result | Should -Match '> Important retained notice'
        $result | Should -Not -Match 'Legacy orphan notice'
    }

    It 'preserves both deprecation and moved notices for an unversioned module' {
        Remove-Item -LiteralPath (Join-Path $script:modulePath 'version.json')
        Set-Content -LiteralPath (Join-Path $script:modulePath 'DEPRECATED.md') -Value 'Retained deprecation notice'
        Set-Content -LiteralPath (Join-Path $script:modulePath 'MOVED-TO-AVM.md') -Value 'Retained moved notice'

        $result = Set-ModuleReadMe @script:readMeInput

        $result | Should -Match '> Retained deprecation notice'
        $result | Should -Match '> Retained moved notice'
        $result | Should -Not -Match 'br/public:'
    }
}
