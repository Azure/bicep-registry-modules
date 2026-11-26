Describe 'API Management private endpoint deployment ordering' {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..' '..' 'main.bicep'
        $compiledPath = Join-Path $TestDrive 'service.json'
        $diagnostics = bicep build $modulePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
        $endpointCall = $template.resources.service_privateEndpoints
        $childModules = @($template.resources.Keys | Where-Object {
                $_ -ne 'service_privateEndpoints' -and
                $template.resources[$_].type -eq 'Microsoft.Resources/deployments' -and
                $template.resources[$_].Contains('copy')
            })
    }

    It 'Waits for every APIM child module collection before updating private endpoints' {
        $childModules.Count | Should -BeGreaterThan 0
        foreach ($childModule in $childModules) {
            $endpointCall.dependsOn | Should -Contain $childModule -Because "$childModule must finish before Private Link updates the service"
        }
    }
}
