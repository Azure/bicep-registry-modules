param (
    [array] $moduleFolderPaths = @((Get-Item $PSScriptRoot).Parent.Parent.FullName),

    [string] $repoRootPath = (Get-Item $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities/pipelines/sharedScripts/helper/Build-ViaRPC.ps1')

    $modulePath = Join-Path ($moduleFolderPaths | Sort-Object | Select-Object -First 1) 'main.bicep'
    $compiled = Build-ViaRPC -BicepFilePath $modulePath -PassThru -ErrorAction Stop
    $template = $compiled[$modulePath] | ConvertFrom-Json -AsHashtable
    $proxyType = $template.definitions.explicitProxyType
    $policy = $template.resources.Values | Where-Object type -EQ 'Microsoft.Network/firewallPolicies'
}

Describe 'Firewall policy explicit proxy' {
    It 'keeps explicit proxy optional and nullable without changing DNS defaults' {
        $template.parameters.explicitProxy.'$ref' | Should -BeExactly '#/definitions/explicitProxyType'
        $template.parameters.explicitProxy.nullable | Should -BeTrue
        $template.parameters.explicitProxy.ContainsKey('defaultValue') | Should -BeFalse
        $template.parameters.explicitProxy.defaultValue | Should -BeNullOrEmpty
        $template.parameters.enableProxy.defaultValue | Should -BeFalse
    }

    It 'passes the complete explicit proxy object directly to the resource' {
        $policy.apiVersion | Should -BeExactly '2024-10-01'
        $policy.properties.explicitProxy | Should -BeExactly "[parameters('explicitProxy')]"
    }

    It 'keeps DNS proxy configuration independent of explicit proxy' {
        $policy.properties.dnsSettings | Should -BeExactly "[if(or(parameters('enableProxy'), not(equals(parameters('servers'), null()))), createObject('enableProxy', parameters('enableProxy'), 'servers', coalesce(parameters('servers'), createArray())), null())]"
    }

    It 'exposes exactly the six supported explicit proxy fields' {
        @($proxyType.properties.Keys | Sort-Object) -join ',' | Should -BeExactly 'enableExplicitProxy,enablePacFile,httpPort,httpsPort,pacFile,pacFilePort'
        $proxyType.required | Should -BeNullOrEmpty
    }

    It 'types <field> as an optional boolean' -TestCases @(
        @{ field = 'enableExplicitProxy' }
        @{ field = 'enablePacFile' }
    ) {
        param ($field)

        $proxyType.properties[$field].type | Should -BeExactly 'bool'
        $proxyType.properties[$field].nullable | Should -BeTrue
    }

    It 'constrains optional <field> to the schema port range' -TestCases @(
        @{ field = 'httpPort' }
        @{ field = 'httpsPort' }
        @{ field = 'pacFilePort' }
    ) {
        param ($field)

        $proxyType.properties[$field].type | Should -BeExactly 'int'
        $proxyType.properties[$field].nullable | Should -BeTrue
        $proxyType.properties[$field].minValue | Should -Be 0
        $proxyType.properties[$field].maxValue | Should -Be 64000
    }

    It 'marks the PAC file URL secure because it can contain a SAS token' {
        $proxyType.properties.pacFile.type | Should -BeExactly 'securestring'
        $proxyType.properties.pacFile.nullable | Should -BeTrue
    }

    It 'compiles <scenario> callers' -TestCases @(
        @{ scenario = 'omitted'; settings = '' }
        @{ scenario = 'null'; settings = 'explicitProxy: null' }
        @{ scenario = 'empty'; settings = 'explicitProxy: {}' }
        @{ scenario = 'disabled'; settings = 'explicitProxy: { enableExplicitProxy: false, enablePacFile: false }' }
        @{ scenario = 'HTTP only'; settings = 'explicitProxy: { enableExplicitProxy: true, httpPort: 8080 }' }
        @{ scenario = 'all fields alongside DNS'; settings = "enableProxy: true`nexplicitProxy: { enableExplicitProxy: true, enablePacFile: true, httpPort: 8080, httpsPort: 8443, pacFile: 'https://example.invalid/proxy.pac', pacFilePort: 8090 }" }
    ) {
        param ($settings)

        $fixture = Join-Path $TestDrive 'caller.bicep'
        $relativeModulePath = [System.IO.Path]::GetRelativePath($TestDrive, $modulePath).Replace('\', '/')
        Set-Content -Path $fixture -Value @"
module policy '$relativeModulePath' = {
  name: 'explicit-proxy-test'
  params: {
    name: 'test-policy'
    $settings
  }
}
"@
        $result = Build-ViaRPC -BicepFilePath $fixture -PassThru -ErrorAction Stop
        $result[$fixture] | Should -Not -BeNullOrEmpty
    }
}
