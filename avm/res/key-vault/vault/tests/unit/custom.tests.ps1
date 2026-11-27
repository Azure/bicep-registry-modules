BeforeAll {
    $template = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..' '..' 'main.json') -Raw | ConvertFrom-Json -AsHashtable -Depth 100
}

Describe 'Public network access' {
    It 'accepts perimeter access without changing the default or bypassing the parameter' {
        $template.parameters.publicNetworkAccess.allowedValues | Should -Contain 'SecuredByPerimeter'
        $template.parameters.publicNetworkAccess.defaultValue | Should -Be ''
        $template.resources.keyVault.properties.publicNetworkAccess | Should -Match "parameters\('publicNetworkAccess'\)"
    }
}
