Describe 'Portal setting secure overlay' {
    BeforeAll {
        $portalRoot = Join-Path (Get-Item $PSScriptRoot).Parent.Parent.FullName 'portalsetting'
        $portalImport = [System.IO.Path]::GetRelativePath($TestDrive, (Join-Path $portalRoot 'main.bicep'))
        $serviceImport = [System.IO.Path]::GetRelativePath($TestDrive, (Join-Path (Split-Path $portalRoot) 'main.bicep'))
        $bicep = if ($env:AVM_CONTRACT_TEST_BICEP_PATH) { $env:AVM_CONTRACT_TEST_BICEP_PATH } else { 'bicep' }

        function Build-PortalContract {
            param([string] $Source, [string] $FixturePath)

            if (-not $FixturePath) {
                $FixturePath = Join-Path $TestDrive "$([guid]::NewGuid()).bicep"
                $Source | Set-Content -LiteralPath $FixturePath
            }
            $result = & $bicep build $FixturePath --stdout --no-restore 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($result | Out-String) }
            ($result | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | Out-String) |
                ConvertFrom-Json -AsHashtable
        }
    }

    It 'Secures both optional validation keys and leaves other properties open' {
        $template = Build-PortalContract @"
import { portalSettingPropertiesType } from '$portalImport'
param properties portalSettingPropertiesType
"@
        $type = $template.definitions.portalSettingPropertiesType
        $type.type | Should -BeExactly 'object'
        @($type.properties.Keys) | Should -Be @('validationKey', 'validationSecondaryKey')
        foreach ($key in @('validationKey', 'validationSecondaryKey')) {
            $type.properties[$key].type | Should -BeExactly 'securestring'
            $type.properties[$key].nullable | Should -BeTrue
        }
        $type.additionalProperties | Should -Not -BeFalse
    }

    It 'Secures both delegation keys at the parent boundary' {
        $template = Build-PortalContract @"
import { delegationPropertiesType } from '$serviceImport'
param settings delegationPropertiesType
"@
        $properties = $template.definitions.delegationPropertiesType.properties.properties
        foreach ($key in @('validationKey', 'validationSecondaryKey')) {
            $properties.properties[$key].type | Should -BeExactly 'securestring'
            $properties.properties[$key].nullable | Should -BeTrue
        }
    }

    It 'Forwards independent secure primary and secondary keys in the max fixture' {
        $template = Build-PortalContract -FixturePath (Join-Path (Split-Path $PSScriptRoot) 'e2e/max/main.test.bicep')
        $deployment = @($template.resources | Where-Object {
                $_.properties.parameters -and $_.properties.parameters.Contains('portalsettings')
            })
        $deployment.Count | Should -Be 1
        $delegation = @($deployment[0].properties.parameters.portalsettings.value | Where-Object { $_.name -eq 'delegation' })
        $delegation.Count | Should -Be 1
        $delegation[0].properties.validationKey | Should -BeExactly "[parameters('delegationValidationKey')]"
        $delegation[0].properties.validationSecondaryKey | Should -BeExactly "[parameters('delegationValidationSecondaryKey')]"
        foreach ($parameter in @('delegationValidationKey', 'delegationValidationSecondaryKey')) {
            $template.parameters[$parameter].type | Should -BeExactly 'securestring'
            $template.parameters[$parameter].defaultValue | Should -Match 'newGuid\(\)'
        }
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
        foreach ($key in @('validationKey', 'validationSecondaryKey')) {
            $template.definitions.portalSettingPropertiesType.properties[$key].type | Should -BeExactly 'string'
        }
    }
}
