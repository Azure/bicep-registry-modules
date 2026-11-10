BeforeAll {
    $fixturePath = Join-Path $PSScriptRoot '..' 'e2e' 'max' 'main.test.bicep'
    $output = Join-Path $TestDrive 'max.json'
    $diagnostics = bicep build $fixturePath --no-restore --outfile $output 2>&1
    if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
    $template = Get-Content -LiteralPath $output -Raw | ConvertFrom-Json -AsHashtable
    $resources = $template.resources -is [System.Collections.IDictionary] ? @($template.resources.Values) : @($template.resources)
    $dependencies = @($resources | Where-Object {
            $_.type -eq 'Microsoft.Resources/deployments' -and $_.properties.parameters.ContainsKey('databricksApplicationObjectId')
        })
    if ($dependencies.Count -ne 1) { throw 'Expected one Databricks maximum fixture dependency module.' }
}

Describe 'Databricks maximum fixture CI identity' {
    It 'Declares the existing secure CI-secret input without embedding an object ID' {
        $parameter = $template.parameters.azureDatabricksEnterpriseApplicationObjectId
        $parameter.type | Should -Be 'secureString'
        $parameter.defaultValue | Should -Be ''
        $parameter.metadata.description | Should -Match 'CI-AzureDatabricksEnterpriseApplicationObjectId'
        $template.parameters.ContainsKey('builtInServicePrincipalObjectId') | Should -BeFalse
    }

    It 'Passes that CI input to the dependency module' {
        $dependencies[0].properties.parameters.databricksApplicationObjectId.value |
            Should -Be "[parameters('azureDatabricksEnterpriseApplicationObjectId')]"
    }

    It 'Does not require the Microsoft Graph extension' {
        $template.ContainsKey('extensions') | Should -BeFalse
        $source = Get-Content -LiteralPath $fixturePath -Raw
        $source | Should -Not -Match 'extension microsoftGraphV1|Microsoft\.Graph/servicePrincipals'
    }
}
