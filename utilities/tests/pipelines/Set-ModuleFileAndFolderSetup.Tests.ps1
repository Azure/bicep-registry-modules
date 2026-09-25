param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Set-ModuleFileAndFolderSetup' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'tools' 'helper' 'Set-ModuleFileAndFolderSetup.ps1')

        # AVM module metadata schema (https://raw.githubusercontent.com/Azure/azure-verified-modules-tools/main/src/Avm.Authoring/Resources/Schemas/v1/avm-module-metadata.schema.json)
        $script:expectedSchemaUri = 'https://raw.githubusercontent.com/Azure/azure-verified-modules-tools/main/src/Avm.Authoring/Resources/Schemas/v1/avm-module-metadata.schema.json'
        $script:canonicalTypePattern = '^[a-z0-9-]+(/[a-z0-9-]+)*$'
        $script:telemetryIdPrefixPattern = '^46d3x(bcp|trf)\.(res|ptn|utl)\.[a-z0-9_-]+$'
    }

    BeforeEach {
        $script:testRootPath = Join-Path $TestDrive ([guid]::NewGuid().ToString())
        $null = New-Item -Path $testRootPath -ItemType 'Directory' -Force
    }

    Context 'Root module' {

        BeforeEach {
            $script:moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'storage' 'storage-account'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath
            $script:metadataFilePath = Join-Path $moduleFolderPath 'metadata.json'
            $script:metadataContent = Get-Content -Path $metadataFilePath -Raw | ConvertFrom-Json
        }

        It 'Should create a [metadata.json] file' {
            Test-Path $metadataFilePath | Should -Be $true
        }

        It 'Should reference the AVM module metadata schema' {
            $metadataContent.'$schema' | Should -Be $expectedSchemaUri
        }

        It 'Should set a non-empty [moduleDisplayName] & [moduleDescription]' {
            $metadataContent.moduleDisplayName | Should -Not -BeNullOrEmpty
            $metadataContent.moduleDescription | Should -Not -BeNullOrEmpty
            $metadataContent.moduleDisplayName | Should -Be 'Storage Account'
            $metadataContent.moduleDescription | Should -Be 'This module deploys Storage Account.'
        }

        It 'Should set a schema-compliant [canonicalType]' {
            $metadataContent.canonicalType | Should -Match $canonicalTypePattern
            $metadataContent.canonicalType | Should -Be 'storage/storage-account'
        }

        It 'Should set a schema-compliant [telemetryIdPrefix] of no more than 50 characters' {
            $metadataContent.telemetryIdPrefix | Should -Match $telemetryIdPrefixPattern
            $metadataContent.telemetryIdPrefix.Length | Should -BeLessOrEqual 50
        }

        It 'Should load the telemetry prefix from the local [metadata.json] in the scaffolded template' {
            $mainBicepContent = Get-Content -LiteralPath (Join-Path $moduleFolderPath 'main.bicep') -Raw
            $mainBicepContent | Should -Match ([regex]::Escape("var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')"))
            $mainBicepContent | Should -Not -Match '46d3xbcp\.'
        }

        It 'Should set an (empty) [owners] array' {
            $metadataContent.PSObject.Properties.Name | Should -Contain 'owners'
            @($metadataContent.owners).Count | Should -Be 0
        }

        It 'Should not overwrite an existing [metadata.json] file' {
            $customContent = '{"$schema":"custom","moduleDisplayName":"Custom","moduleDescription":"Custom.","canonicalType":"custom/type","owners":["someUser"]}'
            Set-Content -Path $metadataFilePath -Value $customContent -NoNewline

            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath

            (Get-Content -Path $metadataFilePath -Raw) | Should -Be $customContent
        }
    }

    Context 'Nested child modules' {

        BeforeEach {
            $script:moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'storage' 'storage-account' 'blob-service' 'container'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath

            $script:rootMetadataFilePath = Join-Path $testRootPath 'avm' 'res' 'storage' 'storage-account' 'metadata.json'
            $script:childMetadataFilePath = Join-Path $testRootPath 'avm' 'res' 'storage' 'storage-account' 'blob-service' 'metadata.json'
            $script:grandchildMetadataFilePath = Join-Path $moduleFolderPath 'metadata.json'
        }

        It 'Should create a [metadata.json] file for the root module and every nested child module' {
            Test-Path $rootMetadataFilePath | Should -Be $true
            Test-Path $childMetadataFilePath | Should -Be $true
            Test-Path $grandchildMetadataFilePath | Should -Be $true
        }

        It 'Should set an [owners] array on the root module only' {
            $rootContent = Get-Content -Path $rootMetadataFilePath -Raw | ConvertFrom-Json
            $childContent = Get-Content -Path $childMetadataFilePath -Raw | ConvertFrom-Json
            $grandchildContent = Get-Content -Path $grandchildMetadataFilePath -Raw | ConvertFrom-Json

            $rootContent.PSObject.Properties.Name | Should -Contain 'owners'
            $childContent.PSObject.Properties.Name | Should -Not -Contain 'owners'
            $grandchildContent.PSObject.Properties.Name | Should -Not -Contain 'owners'
        }

        It 'Should derive the child [canonicalType] & [moduleDisplayName] from the nested folder path' {
            $childContent = Get-Content -Path $childMetadataFilePath -Raw | ConvertFrom-Json
            $childContent.canonicalType | Should -Be 'storage/storage-account/blob-service'
            $childContent.moduleDisplayName | Should -Be 'Blob Service'

            $grandchildContent = Get-Content -Path $grandchildMetadataFilePath -Raw | ConvertFrom-Json
            $grandchildContent.canonicalType | Should -Be 'storage/storage-account/blob-service/container'
            $grandchildContent.moduleDisplayName | Should -Be 'Container'
        }

        It 'Should set a schema-compliant [telemetryIdPrefix] of no more than 50 characters for every level' {
            foreach ($path in @($rootMetadataFilePath, $childMetadataFilePath, $grandchildMetadataFilePath)) {
                $content = Get-Content -Path $path -Raw | ConvertFrom-Json
                $content.telemetryIdPrefix | Should -Match $telemetryIdPrefixPattern
                $content.telemetryIdPrefix.Length | Should -BeLessOrEqual 50
            }
        }
    }

    Context 'Long nested paths' {

        It 'Should shorten an over-length [telemetryIdPrefix] to fit within the 50 character limit' {
            $moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'api-management' 'service' 'workspace' 'api' 'operation' 'policy'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath

            $metadataContent = Get-Content -Path (Join-Path $moduleFolderPath 'metadata.json') -Raw | ConvertFrom-Json
            $metadataContent.telemetryIdPrefix | Should -Match $telemetryIdPrefixPattern
            $metadataContent.telemetryIdPrefix.Length | Should -BeLessOrEqual 50
        }
    }
}
