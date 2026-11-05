param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Deployed VPN client certificate configuration' {
    BeforeAll {
        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $response = Invoke-AzRestMethod -Method GET -Path "${resourceId}?api-version=2024-07-01" -ErrorAction Stop
        $response.StatusCode | Should -Be 200
        $gateway = $response.Content | ConvertFrom-Json -AsHashtable
        $configuration = $gateway.properties.vpnClientConfiguration
        $scenario = $TestInputData.DeploymentOutputs.certificateScenario.Value
        $scenario | Should -BeIn @('legacy', 'array', 'combined')
        $certificates = Get-Content -LiteralPath (Join-Path $TestInputData.ModuleTestFolderPath 'certificates.json') -Raw | ConvertFrom-Json
    }

    It 'Completes provisioning with certificate and Entra authentication over OpenVPN' {
        $gateway.properties.provisioningState | Should -Be 'Succeeded'
        $configuration.vpnAuthenticationTypes | Should -Contain 'AAD'
        $configuration.vpnAuthenticationTypes | Should -Contain 'Certificate'
        $configuration.vpnClientProtocols | Should -Be @('OpenVPN')
    }

    It 'Retains the root before its intermediate with the expected public data' {
        $deployed = @($configuration.vpnClientRootCertificates)
        $deployed.Count | Should -Be ($scenario -eq 'legacy' ? 1 : 2)
        $deployed[0].name | Should -Be 'RootCert1'
        $deployed[0].properties.publicCertData | Should -Be $certificates.root
        if ($scenario -ne 'legacy') {
            $deployed[1].name | Should -Be 'IntermediateCert1'
            $deployed[1].properties.publicCertData | Should -Be $certificates.intermediate
        }
    }

    It 'Retains the configured certificate revocation' {
        $configuration.vpnClientRevokedCertificates.Count | Should -Be 1
        $configuration.vpnClientRevokedCertificates[0].properties.thumbprint | Should -Be '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
    }
}
