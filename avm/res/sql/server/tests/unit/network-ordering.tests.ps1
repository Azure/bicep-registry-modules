Describe 'SQL private endpoint and connection policy ordering' {
    BeforeAll {
        $modulePath = Join-Path $PSScriptRoot '..' '..' 'main.bicep'
        $compiledPath = Join-Path $TestDrive 'server.json'
        $diagnostics = bicep build $modulePath --no-restore --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    }

    It 'Finishes private endpoint updates before updating their connection policy' {
        $template.resources.server_connection_policy.dependsOn | Should -Contain 'server_privateEndpoints'
    }
}
