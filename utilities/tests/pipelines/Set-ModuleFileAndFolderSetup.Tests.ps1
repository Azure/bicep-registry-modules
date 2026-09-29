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
        $script:telemetryIdPrefixPattern = '^46d3xbcp\.(res|ptn|utl)\.[0-9a-f]{7}$'
    }

    BeforeEach {
        $script:testRootPath = Join-Path $TestDrive ([guid]::NewGuid().ToString())
        $null = New-Item -Path $testRootPath -ItemType 'Directory' -Force
        $script:generatedPrefixCounter = 0
        $script:generatorResult = $null
        $script:generatorCalls = [System.Collections.Generic.List[object]]::new()
        Mock Get-Command {
            return {
                [CmdletBinding()]
                param(
                    [string] $Ecosystem,
                    [string] $Kind,
                    [string[]] $KnownPrefix,
                    [switch] $SkipModuleVersionCheck
                )

                $script:generatorCalls.Add([pscustomobject]@{
                        Ecosystem              = $Ecosystem
                        Kind                   = $Kind
                        KnownPrefix            = @($KnownPrefix)
                        SkipModuleVersionCheck = [bool] $SkipModuleVersionCheck
                    })
                if ($script:generatorResult) {
                    return $script:generatorResult
                }
                $script:generatedPrefixCounter++
                return '46d3xbcp.{0}.{1:x7}' -f $Kind, $script:generatedPrefixCounter
            }
        } -ParameterFilter { $Name -eq 'New-AvmTelemetryIdPrefix' -and $Module -eq 'Avm.Authoring' }
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
            $metadataContent.telemetryIdPrefix | Should -MatchExactly $telemetryIdPrefixPattern
            $metadataContent.telemetryIdPrefix.Length | Should -BeLessOrEqual 50
            $generatorCalls.Count | Should -Be 1
            $generatorCalls[0].Ecosystem | Should -Be 'bicep'
            $generatorCalls[0].Kind | Should -Be 'res'
            $generatorCalls[0].SkipModuleVersionCheck | Should -BeFalse
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
                $content.telemetryIdPrefix | Should -MatchExactly $telemetryIdPrefixPattern
                $content.telemetryIdPrefix.Length | Should -BeLessOrEqual 50
            }
            $generatorCalls.Count | Should -Be 3
            $rootPrefix = (Get-Content -Path $rootMetadataFilePath -Raw | ConvertFrom-Json).telemetryIdPrefix
            $childPrefix = (Get-Content -Path $childMetadataFilePath -Raw | ConvertFrom-Json).telemetryIdPrefix
            $generatorCalls[1].KnownPrefix | Should -Contain $rootPrefix
            $generatorCalls[2].KnownPrefix | Should -Contain $rootPrefix
            $generatorCalls[2].KnownPrefix | Should -Contain $childPrefix
        }
    }

    Context 'Long nested paths' {

        It 'Should allocate a short prefix for a long module path' {
            $moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'api-management' 'service' 'workspace' 'api' 'operation' 'policy'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath

            $metadataContent = Get-Content -Path (Join-Path $moduleFolderPath 'metadata.json') -Raw | ConvertFrom-Json
            $metadataContent.telemetryIdPrefix | Should -MatchExactly $telemetryIdPrefixPattern
            $metadataContent.telemetryIdPrefix.Length | Should -BeLessOrEqual 50
        }
    }

    Context 'Prefix inventory' {

        It 'Should pass all local current and alternative prefixes to the generator' {
            $resourceModulePath = Join-Path $testRootPath 'avm' 'res' 'example' 'resource'
            $utilityModulePath = Join-Path $testRootPath 'avm' 'utl' 'example' 'utility'
            $null = New-Item -Path $resourceModulePath -ItemType Directory -Force
            $null = New-Item -Path $utilityModulePath -ItemType Directory -Force
            @{
                telemetryIdPrefix              = '46d3xbcp.res.123abcd'
                alternativeTelemetryIdPrefixes = @('46d3xbcp.res.456abcd', '46d3xbcp.res.789abcd')
            } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $resourceModulePath 'metadata.json')
            @{
                telemetryIdPrefix              = '46d3xbcp.utl.abc1234'
                alternativeTelemetryIdPrefixes = @('46d3xbcp.utl.def5678')
            } | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $utilityModulePath 'metadata.json')

            $moduleFolderPath = Join-Path $testRootPath 'avm' 'ptn' 'example' 'pattern'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath

            $generatorCalls.Count | Should -Be 1
            $generatorCalls[0].Ecosystem | Should -Be 'bicep'
            $generatorCalls[0].Kind | Should -Be 'ptn'
            $generatorCalls[0].KnownPrefix.Count | Should -Be 5
            foreach ($prefix in @('46d3xbcp.res.123abcd', '46d3xbcp.res.456abcd', '46d3xbcp.res.789abcd', '46d3xbcp.utl.abc1234', '46d3xbcp.utl.def5678')) {
                $generatorCalls[0].KnownPrefix | Should -Contain $prefix
            }
        }

        It 'Should forward the trusted-source version-check opt-out through nested modules' {
            $moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'example' 'module' 'child'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath -SkipModuleVersionCheck

            $generatorCalls.Count | Should -Be 2
            @($generatorCalls | Where-Object { -not $_.SkipModuleVersionCheck }).Count | Should -Be 0
        }

        It 'Should forward the opt-out from Set-AVMModule without building or downloading' {
            . (Join-Path $repoRootPath 'utilities' 'tools' 'Set-AVMModule.ps1')
            $moduleFolderPath = Join-Path $testRootPath 'avm' 'utl' 'example' 'module'
            $null = New-Item -Path $moduleFolderPath -ItemType Directory -Force

            Set-AVMModule -ModuleFolderPath $moduleFolderPath -SkipModuleVersionCheck -SkipVersionCheck -SkipBuild -SkipReadMe

            $generatorCalls.Count | Should -Be 1
            $generatorCalls[0].Kind | Should -Be 'utl'
            $generatorCalls[0].SkipModuleVersionCheck | Should -BeTrue
        }
    }

    Context 'Generator availability' {

        It 'Should fail before creating files when a nested module needs an unavailable generator' {
            $rootModulePath = Join-Path $testRootPath 'avm' 'res' 'example' 'module'
            $null = New-Item -Path $rootModulePath -ItemType Directory -Force
            Set-Content -LiteralPath (Join-Path $rootModulePath 'metadata.json') -Value '{"telemetryIdPrefix":"46d3xbcp.res.123abcd"}'
            $childModulePath = Join-Path $rootModulePath 'child'
            Mock Get-Command { return $null } -ParameterFilter { $Name -eq 'New-AvmTelemetryIdPrefix' -and $Module -eq 'Avm.Authoring' }

            { Set-ModuleFileAndFolderSetup -FullModuleFolderPath $childModulePath } | Should -Throw '*Update-PSResource*'
            Test-Path -LiteralPath (Join-Path $rootModulePath 'main.bicep') | Should -BeFalse
            Test-Path -LiteralPath (Join-Path $childModulePath 'main.bicep') | Should -BeFalse
            $generatorCalls.Count | Should -Be 0
        }

        It 'Should preserve existing metadata without requiring the generator' {
            $moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'example' 'module'
            $null = New-Item -Path $moduleFolderPath -ItemType Directory -Force
            $metadataFilePath = Join-Path $moduleFolderPath 'metadata.json'
            $originalMetadata = '{"telemetryIdPrefix":"46d3xbcp.res.123abcd"}'
            Set-Content -LiteralPath $metadataFilePath -Value $originalMetadata
            Mock Get-Command { return $null } -ParameterFilter { $Name -eq 'New-AvmTelemetryIdPrefix' -and $Module -eq 'Avm.Authoring' }

            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath

            (Get-Content -LiteralPath $metadataFilePath -Raw).Trim() | Should -Be $originalMetadata
            $generatorCalls.Count | Should -Be 0
        }

        It 'Should reject a malformed prefix before creating module files' {
            $script:generatorResult = '46d3xbcp.res.example-module'
            $moduleFolderPath = Join-Path $testRootPath 'avm' 'res' 'example' 'module'

            { Set-ModuleFileAndFolderSetup -FullModuleFolderPath $moduleFolderPath } | Should -Throw '*invalid Bicep prefix*'
            Test-Path -LiteralPath (Join-Path $moduleFolderPath 'main.bicep') | Should -BeFalse
            Test-Path -LiteralPath (Join-Path $moduleFolderPath 'metadata.json') | Should -BeFalse
        }

        It 'Should not require the generator for a WhatIf preview' {
            $rootModulePath = Join-Path $testRootPath 'avm' 'res' 'example' 'module'
            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $rootModulePath
            $existingCalls = $generatorCalls.Count
            $childModulePath = Join-Path $rootModulePath 'child'
            Mock Get-Command { return $null } -ParameterFilter { $Name -eq 'New-AvmTelemetryIdPrefix' -and $Module -eq 'Avm.Authoring' }

            Set-ModuleFileAndFolderSetup -FullModuleFolderPath $childModulePath -WhatIf

            $generatorCalls.Count | Should -Be $existingCalls
            Test-Path -LiteralPath (Join-Path $childModulePath 'metadata.json') | Should -BeFalse
        }
    }
}
