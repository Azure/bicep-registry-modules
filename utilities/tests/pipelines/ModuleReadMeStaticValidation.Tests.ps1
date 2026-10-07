param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

$script:repoRootPath = $repoRootPath

Describe 'README static validation regressions' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Set-ModuleReadMe.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-NestedResourceList.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'helper' 'Get-SpecsAlignedResourceName.ps1')
    }

    Context 'Usage example comments' {

        It 'preserves the literal value in <BicepParamBlock>' -ForEach @(
            @{ BicepParamBlock = "trustPolicyStatus: 'disabled' // Deprecated in 2028. Ref: https://example.test"; ParameterName = 'trustPolicyStatus'; Expected = 'disabled' }
            @{ BicepParamBlock = "dailyQuotaGb: '0.25' // 'float' values are not supported. See https://example.test"; ParameterName = 'dailyQuotaGb'; Expected = '0.25' }
            @{ BicepParamBlock = "dailyQuotaGb: '0.5' // The provider expects a float."; ParameterName = 'dailyQuotaGb'; Expected = '0.5' }
            @{ BicepParamBlock = "enabled: true // Enable the feature."; ParameterName = 'enabled'; Expected = $true }
            @{ BicepParamBlock = "count: 3 // Number of instances."; ParameterName = 'count'; Expected = 3 }
            @{ BicepParamBlock = "endpoint: 'https://example.test/path//segment' // Preserve the URL."; ParameterName = 'endpoint'; Expected = 'https://example.test/path//segment' }
            @{ BicepParamBlock = "message: 'Keep // in this string.' // Ignore this comment."; ParameterName = 'message'; Expected = 'Keep // in this string.' }
        ) {
            $result = ConvertTo-FormattedJSONParameterObject -BicepParamBlock "  $BicepParamBlock" -CurrentFilePath 'main.test.bicep'

            $result[$ParameterName].value | Should -BeExactly $Expected
        }

        It 'preserves nested image references and commented array values' {
            $block = @'
  imageReference: {
    publisher: 'Canonical'
    // Keep the supported image.
    sku: '20_04-lts-gen2' // Note: 22.04 does not support DependencyAgent
  }
  endpoints: [
    'https://example.test/path//segment' // Preserve the entire URL.
    'https://example.test/other'
  ]
'@

            $result = ConvertTo-FormattedJSONParameterObject -BicepParamBlock $block -CurrentFilePath 'main.test.bicep'

            $result.imageReference.value.sku | Should -BeExactly '20_04-lts-gen2'
            $result.endpoints.value | Should -Be @('https://example.test/path//segment', 'https://example.test/other')
        }

        It 'continues replacing expressions with placeholders while ignoring comment content' {
            $block = @'
  resourceId: dependencies.outputs.resourceId // Required dependency.
  location: resourceLocation // Deployment location.
  quota: json('0.25') // Converted quota.
  name: '${namePrefix}-example' // Unique name.
  literal: 'value' // Ignore ${dependencies.outputs.name} and "quoted" text.
'@

            $result = ConvertTo-FormattedJSONParameterObject -BicepParamBlock $block -CurrentFilePath 'main.test.bicep'

            $result.resourceId.value | Should -BeExactly '<resourceId>'
            $result.location.value | Should -BeExactly '<location>'
            $result.quota.value | Should -BeExactly '<quota>'
            $result.name.value | Should -BeExactly '<name>'
            $result.literal.value | Should -BeExactly 'value'
        }
    }

    Context 'Canonical resource types' {

        BeforeEach {
            $modulePath = Join-Path $TestDrive ([guid]::NewGuid().ToString()) 'avm' 'res' 'example' 'parent' 'child'
            $null = New-Item -Path $modulePath -ItemType Directory -Force
            $script:metadataPath = Join-Path $modulePath 'metadata.json'
            $script:readMeInput = @{
                ReadMeFilePath       = Join-Path $modulePath 'README.md'
                TemplateFilePath     = Join-Path $modulePath 'main.bicep'
                FullModuleIdentifier = 'example/parent/child'
                TemplateFileContent  = @{
                    metadata  = @{ name = 'Example'; description = 'Example resource.' }
                    resources = @(
                        @{ type = 'Microsoft.Example/parents' }
                    )
                }
            }
            Mock Get-SpecsAlignedResourceName { 'Microsoft.Example/parents' }
        }

        It 'uses canonical metadata for <ModuleIdentifier>' -ForEach @(
            @{ ModuleIdentifier = 'storage/storage-account/object-replication-policy/policy'; ResourceType = 'Microsoft.Storage/storageAccounts/objectReplicationPolicies' }
            @{ ModuleIdentifier = 'dev-test-lab/lab/secret'; ResourceType = 'Microsoft.DevTestLab/labs/secrets' }
            @{ ModuleIdentifier = 'db-for-my-sql/flexible-server/advanced-threat-protection'; ResourceType = 'Microsoft.DBforMySQL/flexibleServers/advancedThreatProtectionSettings' }
        ) {
            Set-Content -LiteralPath $script:metadataPath -Value (@{ canonicalType = $ResourceType } | ConvertTo-Json)
            $script:readMeInput.FullModuleIdentifier = $ModuleIdentifier
            $script:readMeInput.TemplateFileContent.resources += @{ type = $ResourceType }

            $result = Initialize-ReadMe @script:readMeInput

            $result[0] | Should -BeExactly ('# Example `[{0}]`' -f $ResourceType)
            Should -Invoke Get-SpecsAlignedResourceName -Times 0 -Exactly
        }

        It 'retains resource inference for <Metadata> metadata' -ForEach @(
            @{ Metadata = 'missing'; Content = $null }
            @{ Metadata = 'legacy'; Content = '{"canonicalType":"example/parent/child"}' }
            @{ Metadata = 'empty'; Content = '{}' }
        ) {
            if ($null -ne $Content) {
                Set-Content -LiteralPath $script:metadataPath -Value $Content
            }

            $result = Initialize-ReadMe @script:readMeInput

            $result[0] | Should -BeExactly '# Example `[Microsoft.Example/parents]`'
            Should -Invoke Get-SpecsAlignedResourceName -Times 1 -Exactly
        }

        It 'reports malformed metadata rather than silently guessing the resource type' {
            Set-Content -LiteralPath $script:metadataPath -Value '{invalid JSON'

            { Initialize-ReadMe @script:readMeInput } | Should -Throw
        }
    }
}
