param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Legacy release eligibility for <ModuleType> modules' -ForEach @(
    @{ ModuleType = 'res' }
    @{ ModuleType = 'ptn' }
    @{ ModuleType = 'utl' }
) {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'publish' 'helper' 'Get-ModulesToPublish.ps1')

        $script:moduleFolderPath = Join-Path $TestDrive 'avm' $ModuleType 'example' 'module'
        foreach ($relativePath in @('.', 'child', 'child/nested', 'sibling', 'unversioned')) {
            $folderPath = Join-Path $script:moduleFolderPath $relativePath
            $null = New-Item -Path $folderPath -ItemType Directory -Force
            foreach ($fileName in @('main.bicep', 'main.json', 'metadata.json', 'README.md')) {
                Set-Content -Path (Join-Path $folderPath $fileName) -Value '{}'
            }
            if ($relativePath -ne 'unversioned') {
                Set-Content -Path (Join-Path $folderPath 'version.json') -Value '{"version":"1.0"}'
            }
        }

        # Fixture the diff provider so these tests cannot fetch upstream or create release tags.
        $diffFolderPath = Join-Path $TestDrive 'utilities' 'pipelines' 'sharedScripts'
        $null = New-Item -Path $diffFolderPath -ItemType Directory -Force
        Set-Content -Path (Join-Path $diffFolderPath 'Get-GitDiff.ps1') -Value @'
function Get-GitDiff {
    [CmdletBinding()]
    param (
        [string] $PathFilter,
        [switch] $PathOnly
    )
    if (-not $PathOnly) {
        throw 'The release selector must request changed file paths.'
    }
    return $script:changedModuleFiles
}
'@
    }

    It 'selects only publishable templates for <Scenario>' -ForEach @(
        @{ Scenario = 'root metadata'; ChangedPaths = @('metadata.json'); Templates = @() }
        @{ Scenario = 'child metadata'; ChangedPaths = @('child/metadata.json'); Templates = @() }
        @{ Scenario = 'nested metadata'; ChangedPaths = @('child/nested/metadata.json'); Templates = @() }
        @{
            Scenario = 'multiple metadata files'
            ChangedPaths = @('metadata.json', 'child/metadata.json', 'child/nested/metadata.json', 'sibling/metadata.json')
            Templates = @()
        }
        @{ Scenario = 'metadata and documentation'; ChangedPaths = @('metadata.json', 'README.md'); Templates = @() }
        @{ Scenario = 'uncompiled source'; ChangedPaths = @('main.bicep'); Templates = @() }
        @{ Scenario = 'compiled source'; ChangedPaths = @('main.bicep', 'main.json'); Templates = @('main.json') }
        @{ Scenario = 'child compiled source'; ChangedPaths = @('child/main.bicep', 'child/main.json'); Templates = @('child/main.json') }
        @{ Scenario = 'version changes'; ChangedPaths = @('version.json'); Templates = @('main.json') }
        @{ Scenario = 'nested version changes'; ChangedPaths = @('child/nested/version.json'); Templates = @('child/nested/main.json') }
        @{
            Scenario = 'parent source with metadata-only children'
            ChangedPaths = @('main.bicep', 'main.json', 'child/metadata.json', 'child/nested/metadata.json')
            Templates = @('main.json')
        }
        @{
            Scenario = 'child source with metadata-only parent and sibling'
            ChangedPaths = @('metadata.json', 'sibling/metadata.json', 'child/main.json')
            Templates = @('child/main.json')
        }
        @{ Scenario = 'unversioned child source'; ChangedPaths = @('unversioned/main.json', 'metadata.json'); Templates = @() }
    ) {
        $script:changedModuleFiles = @($ChangedPaths | ForEach-Object {
                Get-Item -LiteralPath (Join-Path $script:moduleFolderPath $_)
            })

        $result = @(Get-TemplateFileToPublish -ModuleFolderPath $script:moduleFolderPath -RepoRoot $TestDrive -SkipNotVersionedModules)
        $result.Count | Should -Be $Templates.Count
        foreach ($template in $Templates) {
            $result | Should -Contain (Join-Path $script:moduleFolderPath $template)
        }
    }
}
