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
        $deployed = @($configuration.vpnClientRootCertificates)
        $certificates = Get-Content -LiteralPath (Join-Path $TestInputData.ModuleTestFolderPath 'certificates.json') -Raw | ConvertFrom-Json
    }

    It 'Completes gateway provisioning' {
        $gateway.properties.provisioningState | Should -Be 'Succeeded'
    }

    It 'Enables Entra authentication' {
        $configuration.vpnAuthenticationTypes | Should -Contain 'AAD'
    }

    It 'Enables certificate authentication' {
        $configuration.vpnAuthenticationTypes | Should -Contain 'Certificate'
    }

    It 'Uses the OpenVPN protocol' {
        $configuration.vpnClientProtocols | Should -Be @('OpenVPN')
    }

    It 'Retains exactly two root and intermediate certificates' {
        $deployed.Count | Should -Be 2
    }

    It 'Retains the root certificate in the first position' {
        $deployed[0].name | Should -Be 'RootCert1'
    }

    It 'Retains the expected root certificate public data' {
        $deployed[0].properties.publicCertData | Should -Be $certificates.root
    }

    It 'Retains the intermediate certificate in the second position' {
        $deployed[1].name | Should -Be 'IntermediateCert1'
    }

    It 'Retains the expected intermediate certificate public data' {
        $deployed[1].properties.publicCertData | Should -Be $certificates.intermediate
    }

    It 'Retains exactly one revoked certificate' {
        $configuration.vpnClientRevokedCertificates.Count | Should -Be 1
    }

    It 'Retains the configured revoked certificate thumbprint' {
        $configuration.vpnClientRevokedCertificates[0].properties.thumbprint | Should -Be '1f24c630cda418ef2069ffad4fdd5f463a1b69aa'
    }
}
