#Requires -Version 7

param (
    [Parameter(Mandatory = $false)]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.Parent.FullName,

    [Parameter(Mandatory = $false)]
    [array] $moduleFolderPaths = ((Get-ChildItem $repoRootPath -Recurse -Directory -Force).FullName | Where-Object {
            (Get-ChildItem $_ -File -Depth 0 -Include @('main.bicep') -Force).Count -gt 0
        })
)

Describe 'Metadata tests' -Tag 'Metadata' {

    BeforeDiscovery {
        # Internal helper modules do not require metadata.json.
        $metadataExcludedSegments = @('tests', 'examples', 'test', 'modules', 'build', 'out', 'dist', 'node_modules')

        $metadataModuleTestCases = [System.Collections.ArrayList] @()
        foreach ($moduleFolderPath in $moduleFolderPaths) {
            $null, $moduleType, $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]avm[\/|\\](res|ptn|utl)[\/|\\]')
            $resourceTypeIdentifier = $resourceTypeIdentifier -replace '\\', '/'
            $pathSegments = $resourceTypeIdentifier -split '/'

            $isExcluded = $pathSegments | Where-Object { $metadataExcludedSegments -contains $_ -or $_.StartsWith('.') }
            if ($isExcluded) {
                continue
            }

            $metadataModuleTestCases += @{
                moduleFolderName = $resourceTypeIdentifier
                moduleFolderPath = Join-Path $repoRootPath 'avm' $moduleType $resourceTypeIdentifier
                avmModuleType    = @{ res = 'resource'; ptn = 'pattern'; utl = 'utility' }[$moduleType]
                isTopLevelModule = $pathSegments.Count -eq 2
            }
        }
    }

    BeforeAll {
        if (-not (Get-Module -ListAvailable -Name 'Avm.Authoring')) {
            Install-Module -Name 'Avm.Authoring' -Repository 'PSGallery' -Scope 'CurrentUser' -Force -SkipPublisherCheck -AllowClobber
        }
        Import-Module -Name 'Avm.Authoring' -Force
    }

    It '[<moduleFolderName>] Module must contain a valid [` metadata.json `] file.' -TestCases $metadataModuleTestCases {

        param(
            [string] $moduleFolderPath,
            [string] $avmModuleType,
            [bool] $isTopLevelModule
        )

        $testInput = @{
            Path                   = $moduleFolderPath
            Ecosystem              = 'bicep'
            ModuleType             = $avmModuleType
            SkipModuleVersionCheck = $true
        }
        if (-not $isTopLevelModule) {
            $testInput['ChildModule'] = $true
        }

        $result = Test-AvmModuleMetadata @testInput

        $issueSummary = ($result.Issues | ForEach-Object { "[$($_.Code)] $($_.Message)" }) -join '; '
        $result.Status | Should -Be 'pass' -Because "metadata.json must satisfy the AVM Avm.Authoring schema. Issues: $issueSummary"
    }
}
