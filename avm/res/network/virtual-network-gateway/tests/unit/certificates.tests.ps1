param (
    [Parameter()]
    [string] $repoRootPath,

    [Parameter()]
    [string[]] $moduleFolderPaths
)

Describe 'VPN client certificate configuration' {
    BeforeAll {
        $moduleRoot = (Get-Item (Join-Path $PSScriptRoot '..' '..')).FullName
        $source = Get-Content -LiteralPath (Join-Path $moduleRoot 'main.bicep') -Raw
        $expressions = [regex]::Match($source, '(?ms)^var legacyClientRootCertificates = .*?(?=^var builtInRoleNames)').Value
        $expressions | Should -Not -BeNullOrEmpty
        $certificates = Get-Content -LiteralPath (Join-Path $moduleRoot 'tests' 'e2e' 'p2sEntraCertificate' 'certificates.json') -Raw | ConvertFrom-Json
        $results = @{}
        foreach ($scenario in @('none', 'legacy', 'array', 'combined', 'aadOnly', 'alreadyCertificate')) {
            $legacy = if ($scenario -in @('legacy', 'combined', 'alreadyCertificate')) { "'root-data'" } else { "''" }
            $additional = if ($scenario -in @('array', 'combined')) {
                if ($scenario -eq 'array') {
                    "[{ name: 'CustomRoot', publicCertData: 'root-data' }, { name: 'Intermediate', publicCertData: 'intermediate-data' }]"
                } else {
                    "[{ name: 'Intermediate', publicCertData: 'intermediate-data' }]"
                }
            } else { '[]' }
            $aad = if ($scenario -eq 'none') { 'any(null)' } else {
                $authenticationTypes = if ($scenario -eq 'alreadyCertificate') { "['AAD', 'Certificate']" } else { "['AAD']" }
                "{ aadTenant: 'https://login.microsoftonline.com/test', aadAudience: 'test-audience', aadIssuer: 'test-issuer', vpnAuthenticationTypes: $authenticationTypes, vpnClientProtocols: ['OpenVPN'] }"
            }
            $parameterPath = Join-Path $TestDrive "$scenario.bicepparam"
            $outputPath = Join-Path $TestDrive "$scenario.json"
            @"
using none
var clientRootCertData = $legacy
var clientRootCertificates = $additional
var vpnClientAadConfiguration = $aad
var vpnClientAddressPoolPrefix = '172.16.10.0/24'
var clientRevokedCertThumbprint = '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
$expressions
param result = { configuration: vpnClientConfiguration }
"@ | Set-Content -LiteralPath $parameterPath
            $diagnostics = bicep build-params $parameterPath --outfile $outputPath 2>&1
            if ($LASTEXITCODE -ne 0) { throw ($diagnostics | Out-String) }
            $results[$scenario] = (Get-Content -LiteralPath $outputPath -Raw | ConvertFrom-Json -AsHashtable).parameters.result.value.configuration
        }
    }

    It 'Preserves the legacy RootCert1 name and public certificate data' {
        $certs = @($results.legacy.vpnClientRootCertificates)
        $certs.Count | Should -Be 1
        $certs[0].name | Should -Be 'RootCert1'
        $certs[0].properties.publicCertData | Should -Be 'root-data'
    }

    It 'Accepts multiple named certificates without the legacy input' {
        $certs = @($results.array.vpnClientRootCertificates)
        $certs.Count | Should -Be 2
        $certs[0].name | Should -Be 'CustomRoot'
        $certs[0].properties.publicCertData | Should -Be 'root-data'
        $certs[1].name | Should -Be 'Intermediate'
        $certs[1].properties.publicCertData | Should -Be 'intermediate-data'
    }

    It 'Places the legacy root before additional intermediates' {
        $certs = @($results.combined.vpnClientRootCertificates)
        $certs.Count | Should -Be 2
        $certs[0].name | Should -Be 'RootCert1'
        $certs[0].properties.publicCertData | Should -Be 'root-data'
        $certs[1].name | Should -Be 'Intermediate'
        $certs[1].properties.publicCertData | Should -Be 'intermediate-data'
    }

    It 'Enables certificate authentication and revocation for every certificate input configuration' {
        foreach ($scenario in @('legacy', 'array', 'combined')) {
            $results[$scenario].vpnAuthenticationTypes | Should -Be @('AAD', 'Certificate')
            $results[$scenario].vpnClientProtocols | Should -Be @('OpenVPN')
            $results[$scenario].vpnClientRevokedCertificates[0].properties.thumbprint | Should -Be '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
        }
    }

    It 'Does not duplicate explicit Certificate authentication' {
        $results.alreadyCertificate.vpnAuthenticationTypes | Should -Be @('AAD', 'Certificate')
    }

    It 'Leaves certificate configuration absent for Entra-only and non-P2S gateways' {
        $results.aadOnly.vpnClientRootCertificates | Should -BeNullOrEmpty
        $results.aadOnly.vpnClientRevokedCertificates | Should -BeNullOrEmpty
        $results.aadOnly.vpnAuthenticationTypes | Should -Be @('AAD')
        $results.none | Should -BeNullOrEmpty
    }

    It 'Uses public-only test certificates with a real root-signed intermediate chain' {
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
        } finally {
            $chain.Dispose()
            $intermediate.Dispose()
            $root.Dispose()
        }
    }
}
