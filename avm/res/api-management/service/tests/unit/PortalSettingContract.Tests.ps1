Describe 'Portal setting secure overlay' {
    BeforeAll {
        $portalRoot = Join-Path (Get-Item $PSScriptRoot).Parent.Parent.FullName 'portalsetting'
        $portalImport = [System.IO.Path]::GetRelativePath($TestDrive, (Join-Path $portalRoot 'main.bicep'))
        $bicep = if ($env:AVM_CONTRACT_TEST_BICEP_PATH) { $env:AVM_CONTRACT_TEST_BICEP_PATH } else { 'bicep' }

        function Build-PortalContract {
            param([string] $Source)

            $fixture = Join-Path $TestDrive "$([guid]::NewGuid()).bicep"
            $Source | Set-Content -LiteralPath $fixture
            $result = & $bicep build $fixture --stdout --no-restore 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($result | Out-String) }
            ($result | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | Out-String) |
                ConvertFrom-Json -AsHashtable
        }
    }

    It 'Constrains only validationKey and leaves other properties open' {
        $template = Build-PortalContract @"
import { portalSettingPropertiesType } from '$portalImport'
param properties portalSettingPropertiesType
"@
        $type = $template.definitions.portalSettingPropertiesType
        $type.type | Should -BeExactly 'object'
        @($type.properties.Keys) | Should -Be @('validationKey')
        $type.properties.validationKey.type | Should -BeExactly 'securestring'
        $type.properties.validationKey.nullable | Should -BeTrue
        $type.additionalProperties | Should -Not -BeFalse
    }

    It 'Preserves native generic-object callers without constraining ordinary siblings' {
        # This is a compile-time compatibility control, not an Azure-valid deployment.
        $template = Build-PortalContract @"
import { portalSettingPropertiesType } from '$portalImport'
param properties portalSettingPropertiesType = {
  enabled: 'previously accepted by the native object type'
  termsOfService: { futureField: [1, true] }
  futureProperty: { nested: true }
}
"@
        $template.parameters.properties.defaultValue.enabled | Should -BeExactly 'previously accepted by the native object type'
        $template.parameters.properties.defaultValue.futureProperty.nested | Should -BeTrue
    }

    It 'Loses ARM leaf protection when the secure decorator is removed' {
        $source = Get-Content -LiteralPath (Join-Path $portalRoot 'main.bicep') -Raw
        $typeSource = $source.Substring($source.IndexOf('@export()'))
        $typeSource | Should -Match '@secure\(\)'
        $template = Build-PortalContract ($typeSource.Replace('@secure()', '') + "`nparam properties portalSettingPropertiesType")
        $template.definitions.portalSettingPropertiesType.properties.validationKey.type | Should -BeExactly 'string'
    }
}
