param (
    [Parameter(Mandatory = $true)]
    [array] $moduleFolderPaths,

    [Parameter(Mandatory = $true)]
    [string] $repoRootPath
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-TestSubscriptionTag.ps1')
    $moduleRoot = Join-Path $repoRootPath 'avm' 'res' 'azure-stack-hci' 'gallery-image'
    $template = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.json') -Raw | ConvertFrom-Json -AsHashtable
    $image = @($template.resources.Values | Where-Object type -EQ 'Microsoft.AzureStackHCI/galleryImages')
    $testTemplates = @{}
    foreach ($case in @('defaults', 'max', 'waf-aligned')) {
        $path = Join-Path $moduleRoot 'tests' 'e2e' $case 'main.test.bicep'
        $compiled = bicep build $path --stdout
        if ($LASTEXITCODE -ne 0) { throw "Failed to compile the $case test template." }
        $testTemplates[$case] = $compiled | ConvertFrom-Json -AsHashtable
    }
}

Describe 'Customer image import contract' {
    It 'Selects the reserved Azure Local subscription pool for CI' {
        Get-TestSubscriptionTag -ModulePath 'avm/res/azure-stack-hci/gallery-image' -RepoRootPath $repoRootPath |
            Should -BeExactly 'Azure Local'
    }

    It 'Deploys exactly one gallery image using the GA API' {
        $image.Count | Should -Be 1
        $image[0].apiVersion | Should -BeExactly '2024-01-01'
    }

    It 'Requires a nonempty secure source path without a default' {
        $template.parameters.imagePath.type | Should -BeExactly 'securestring'
        $template.parameters.imagePath.minLength | Should -Be 1
        $template.parameters.imagePath.ContainsKey('defaultValue') | Should -BeFalse
    }

    It 'Forwards the source path without rewriting SAS URLs or local paths' {
        $image[0].properties.imagePath | Should -BeExactly "[parameters('imagePath')]"
    }

    It 'Targets the supplied custom location and optional storage container' {
        $image[0].extendedLocation.type | Should -BeExactly 'CustomLocation'
        $image[0].extendedLocation.name | Should -BeExactly "[parameters('customLocationResourceId')]"
        $image[0].properties.containerId | Should -BeExactly "[parameters('containerResourceId')]"
    }

    It 'Defaults to Gen2 without selecting a cloud-init data source' {
        $template.parameters.hyperVGeneration.defaultValue | Should -BeExactly 'V2'
        $template.parameters.cloudInitDataSource.defaultValue | Should -BeNullOrEmpty
    }

    It 'Exposes only safe identity and location outputs' {
        @($template.outputs.Keys).Count | Should -Be 4
        foreach ($key in @('name', 'resourceId', 'resourceGroupName', 'location')) {
            $template.outputs.ContainsKey($key) | Should -BeTrue
        }
        ($template.outputs | ConvertTo-Json -Depth 20) | Should -Not -Match 'imagePath|list[A-Z]'
        $template.outputs.location.value | Should -BeExactly "[reference('galleryImage', '2024-01-01', 'full').location]"
    }

    It 'Does not forward the source path to telemetry, tags, or resource names' {
        ($template.resources.avmTelemetry | ConvertTo-Json -Depth 30) | Should -Not -Match 'imagePath'
        $image[0].name | Should -BeExactly "[parameters('name')]"
        $image[0].tags | Should -BeExactly "[parameters('tags')]"
    }

    It 'Keeps the source secure across all test deployment boundaries' {
        foreach ($case in $testTemplates.Keys) {
            $test = $testTemplates[$case]
            $test.parameters.imagePath.type | Should -BeExactly 'securestring' -Because $case
            $test.parameters.imagePath.ContainsKey('defaultValue') | Should -BeFalse -Because $case
            $deployment = $test.resources.testDeployment
            $deployment.properties.parameters.imagePath.value | Should -BeExactly "[parameters('imagePath')]" -Because $case
            $deployment.properties.template.parameters.imagePath.type | Should -BeExactly 'securestring' -Because $case
        }
    }

    It 'Includes sequential unchanged redeployment for each test case' {
        foreach ($case in $testTemplates.Keys) {
            $deployment = $testTemplates[$case].resources.testDeployment
            $deployment.copy.count | Should -BeExactly "[length(createArray('init', 'idem'))]" -Because $case
            $deployment.copy.mode | Should -BeExactly 'serial' -Because $case
            $deployment.copy.batchSize | Should -Be 1 -Because $case
            $deployment.properties.parameters.name.value | Should -Not -Match 'copyIndex' -Because $case
        }
    }
}
