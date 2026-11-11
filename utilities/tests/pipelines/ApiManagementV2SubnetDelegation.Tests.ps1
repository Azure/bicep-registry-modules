param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'API Management PremiumV2 fixture subnet delegation' {
    BeforeAll {
        $fixturePath = Join-Path $repoRootPath 'avm' 'res' 'api-management' 'service' 'tests' 'e2e' 'v2max' 'dependencies.bicep'
        $compiledPath = Join-Path $TestDrive 'dependencies.json'
        $diagnostics = bicep build $fixturePath --outfile $compiledPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $template = Get-Content -LiteralPath $compiledPath -Raw | ConvertFrom-Json -AsHashtable
    }

    It 'Delegates the default subnet in region <region> to API Management' -ForEach @(
        @{ region = 1 }
        @{ region = 2 }
    ) {
        $virtualNetworks = @($template.resources | Where-Object {
                $_.type -eq 'Microsoft.Network/virtualNetworks' -and $_.location -eq "[parameters('locationRegion$region')]"
            })
        $virtualNetworks.Count | Should -Be 1
        $subnets = @($virtualNetworks[0].properties.subnets | Where-Object { $_.name -eq 'default' })
        $subnets.Count | Should -Be 1
        $delegations = @($subnets[0].properties.delegations)
        $delegations.Count | Should -Be 1
        $delegations[0].properties.serviceName | Should -Be 'Microsoft.ApiManagement/service'
    }
}
