param (
    [Parameter()]
    [string] $repoRootPath,

    [Parameter()]
    [string[]] $moduleFolderPaths
)

BeforeDiscovery {
    $aad = @{
        aadTenant              = 'https://login.microsoftonline.com/test'
        aadAudience            = 'test-audience'
        aadIssuer              = 'test-issuer'
        vpnAuthenticationTypes = @('AAD')
        vpnClientProtocols     = @('OpenVPN')
    }
    $explicitCertificate = $aad.Clone()
    $explicitCertificate.vpnAuthenticationTypes = @('AAD', 'Certificate')
    $root = @{ name = 'CustomRoot'; publicCertData = 'root-data' }
    $intermediate = @{ name = 'Intermediate'; publicCertData = 'intermediate-data' }
    $scenarios = @(
        @{ name = 'legacy-only'; legacy = 'root-data'; certificates = @(); aad = $aad; names = @('RootCert1'); data = @('root-data'); authentication = @('AAD', 'Certificate') }
        @{ name = 'array-only'; legacy = ''; certificates = @($root, $intermediate); aad = $aad; names = @('CustomRoot', 'Intermediate'); data = @('root-data', 'intermediate-data'); authentication = @('AAD', 'Certificate') }
        @{ name = 'combined'; legacy = 'root-data'; certificates = @($intermediate); aad = $aad; names = @('RootCert1', 'Intermediate'); data = @('root-data', 'intermediate-data'); authentication = @('AAD', 'Certificate') }
        @{ name = 'explicit authentication'; legacy = 'root-data'; certificates = @(); aad = $explicitCertificate; names = @('RootCert1'); data = @('root-data'); authentication = @('AAD', 'Certificate') }
        @{ name = 'Entra-only'; legacy = ''; certificates = @(); aad = $aad; names = @(); data = @(); authentication = @('AAD') }
        @{ name = 'non-P2S'; legacy = ''; certificates = @(); aad = $null; names = @(); data = @(); authentication = @() }
    )
}

Describe 'VPN client certificate configuration' {
    BeforeAll {
        $moduleRoot = (Get-Item (Join-Path $PSScriptRoot '..' '..')).FullName
        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.bicep') -Raw
        # Evaluate the module's actual configuration expressions, not a second implementation.
        $expressions = [regex]::Match($source, '(?ms)^var legacyClientRootCertificates = .*?(?=^var builtInRoleNames)').Value
        $expressions | Should -Not -BeNullOrEmpty
    }

    It 'Preserves certificate data, ordering and authentication for <name> inputs' -ForEach $scenarios {
        @{ legacy = $legacy; certificates = $certificates; aad = $aad } |
            ConvertTo-Json -Depth 10 | Set-Content -LiteralPath (Join-Path $TestDrive 'inputs.json')
        $parameterPath = Join-Path $TestDrive 'configuration.bicepparam'
        $outputPath = Join-Path $TestDrive 'configuration.json'
        @"
using none
var input = loadJsonContent('inputs.json')
var clientRootCertData = input.legacy
var clientRootCertificates = input.certificates
var vpnClientAadConfiguration = any(input.aad)
var vpnClientAddressPoolPrefix = '172.16.10.0/24'
var clientRevokedCertThumbprint = '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
$expressions
param configuration = vpnClientConfiguration
"@ | Set-Content -LiteralPath $parameterPath
        $diagnostics = bicep build-params $parameterPath --outfile $outputPath 2>&1
        if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
        $configuration = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters.configuration.value

        $deployed = @($configuration.vpnClientRootCertificates | Where-Object { $null -ne $_ })
        $deployed.Count | Should -Be $names.Count
        for ($index = 0; $index -lt $names.Count; $index++) {
            $deployed[$index].name | Should -Be $names[$index]
            $deployed[$index].properties.publicCertData | Should -Be $data[$index]
        }
        @($configuration.vpnAuthenticationTypes | Where-Object { $null -ne $_ }) | Should -Be $authentication
        if ($aad) {
            $configuration.vpnClientProtocols | Should -Be @('OpenVPN')
        }
        if ($names.Count -gt 0) {
            $configuration.vpnClientRevokedCertificates[0].properties.thumbprint | Should -Be '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
        }
        else {
            $configuration.vpnClientRevokedCertificates | Should -BeNullOrEmpty
        }
        if (-not $aad) {
            $configuration | Should -BeNullOrEmpty
        }
    }

    It 'Uses public-only test certificates with a real root-signed intermediate chain' {
        $certificates = Get-Content -LiteralPath (Join-Path $moduleRoot 'tests' 'e2e' 'p2sEntraCertificate' 'certificates.json') -Raw | ConvertFrom-Json
        $root = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([Convert]::FromBase64String($certificates.root))
        $intermediate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new([Convert]::FromBase64String($certificates.intermediate))
        $chain = [System.Security.Cryptography.X509Certificates.X509Chain]::new()
        try {
            $root.HasPrivateKey | Should -BeFalse
            $intermediate.HasPrivateKey | Should -BeFalse
            $intermediate.Issuer | Should -Be $root.Subject
            $intermediate.Subject | Should -Not -Be $root.Subject
            $chain.ChainPolicy.TrustMode = 'CustomRootTrust'
            $chain.ChainPolicy.CustomTrustStore.Add($root)
            $chain.ChainPolicy.RevocationMode = 'NoCheck'
            $chain.ChainPolicy.VerificationTime = [datetime] '2026-11-04'
            $chain.Build($intermediate) | Should -BeTrue
            $chain.ChainElements.Count | Should -Be 2
        }
        finally {
            $chain.Dispose()
            $intermediate.Dispose()
            $root.Dispose()
        }
    }
}
