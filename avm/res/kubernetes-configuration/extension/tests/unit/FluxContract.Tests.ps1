Describe 'Flux native-property secure overlay' {
    BeforeAll {
        $moduleRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $moduleImport = [System.IO.Path]::GetRelativePath($TestDrive, (Join-Path $moduleRoot 'main.bicep'))
        $bicep = if ($env:AVM_CONTRACT_TEST_BICEP_PATH) { $env:AVM_CONTRACT_TEST_BICEP_PATH } else { 'bicep' }
        $fixture = Join-Path $TestDrive 'flux.bicep'
        @"
import { fluxConfigurationType } from '$moduleImport'
param optionalConfigurations fluxConfigurationType[]?
param fluxConfigurations fluxConfigurationType[] = [
  {}
  { azureBlob: { containerName: 'previously-accepted' }, futureProperty: true }
]
"@ | Set-Content -LiteralPath $fixture
        $output = & $bicep build $fixture --stdout --no-restore 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($output | Out-String) }
        $template = ($output | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | Out-String) |
            ConvertFrom-Json -AsHashtable
    }

    It 'Preserves native optionality and accepts unforwarded provider properties' {
        foreach ($property in @('namespace', 'scope', 'kustomizations')) {
            $template.definitions.fluxConfigurationType.properties[$property].nullable | Should -BeTrue
            $template.definitions.fluxConfigurationType.properties[$property].metadata.'__bicep_resource_derived_type!'.source |
                Should -BeLike "Microsoft.KubernetesConfiguration/fluxConfigurations@2025-04-01#*/$property"
        }
        $template.definitions.fluxConfigurationType.additionalProperties | Should -Not -BeFalse
        $template.parameters.optionalConfigurations.nullable | Should -BeTrue
    }

    It 'Protects only the configuration settings dictionary, not ordinary sibling properties' {
        $properties = $template.definitions.fluxConfigurationType.properties
        $properties.configurationProtectedSettings.type | Should -BeExactly 'secureObject'
        $properties.configurationProtectedSettings.nullable | Should -BeTrue
        $properties.namespace.type | Should -BeExactly 'string'
        $properties.scope.type | Should -BeExactly 'string'
        $properties.kustomizations.type | Should -BeExactly 'object'
    }
}
