Describe 'Automation variable secure contract' {
    BeforeAll {
        $moduleRoot = (Get-Item $PSScriptRoot).Parent.Parent.FullName
        $moduleImport = [System.IO.Path]::GetRelativePath($TestDrive, (Join-Path $moduleRoot 'main.bicep'))
        $bicep = if ($env:AVM_CONTRACT_TEST_BICEP_PATH) { $env:AVM_CONTRACT_TEST_BICEP_PATH } else { 'bicep' }
        $fixture = Join-Path $TestDrive 'variable.bicep'
        @"
import { variableType } from '$moduleImport'
param variables variableType[] = []
"@ | Set-Content -LiteralPath $fixture
        $output = & $bicep build $fixture --stdout --no-restore 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($output | Out-String) }
        $template = ($output | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | Out-String) |
            ConvertFrom-Json -AsHashtable
    }

    It 'Keeps value secure and required without sealing additional caller properties' {
        $template.definitions.variableType.properties.value.type | Should -BeExactly 'securestring'
        $template.definitions.variableType.properties.value.nullable | Should -Not -BeTrue
        $template.definitions.variableType.additionalProperties | Should -Not -BeFalse
        $template.parameters.variables.defaultValue.Count | Should -Be 0
    }
}
