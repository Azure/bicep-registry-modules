<#
.SYNOPSIS
Generate a new Key Vault Certificate or fetch its secret reference if already existing.

.DESCRIPTION
Generate a new Key Vault Certificate or fetch its secret reference if already existing.

.PARAMETER KeyVaultName
Mandatory. The name of the Key Vault to add a new certificate to, or fetch the secret reference it from

.PARAMETER CertName
Mandatory. The name of the certificate to generate or fetch the secret reference from

.PARAMETER CertSubjectName
Optional. The subject distinguished name is the name of the user of the certificate. The distinguished name for the certificate is a textual representation of the subject or issuer of the certificate. Default name is "CN=fabrikam.com"

.EXAMPLE
./Set-CertificateInKeyVault.ps1 -KeyVaultName 'myVault' -CertName 'myCert' -CertSubjectName 'CN=fabrikam.com'

Generate a new Key Vault Certificate with the default or provided subject name, or fetch its secret reference if already existing as 'myCert' in Key Vault 'myVault'
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string] $CertName,

    [Parameter(Mandatory = $false)]
    [string] $CertSubjectName = 'CN=fabrikam.com'
)

$certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'SilentlyContinue'

if (-not $certificate) {
    $policyInputObject = @{
        SecretContentType = 'application/x-pkcs12'
        SubjectName       = $CertSubjectName
        IssuerName        = 'Self'
        ValidityInMonths  = 12
        ReuseKeyOnRenewal = $true
    }
    $certPolicy = New-AzKeyVaultCertificatePolicy @policyInputObject

    $null = Add-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -CertificatePolicy $certPolicy
    Write-Verbose ('Initiated creation of certificate [{0}] in key vault [{1}]' -f $CertName, $KeyVaultName) -Verbose

    while (-not (Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName).Status -eq 'completed') {
        Write-Verbose 'Waiting 10 seconds for certificate creation' -Verbose
        Start-Sleep 10
    }

    Write-Verbose 'Certificate created' -Verbose
}

$secretId = $certificate.SecretId
while ([String]::IsNullOrEmpty($secretId)) {
    Write-Verbose 'Waiting 10 seconds until certificate can be fetched' -Verbose
    Start-Sleep 10
    $certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'Stop'
    $secretId = $certificate.SecretId
}

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    secretUrl = $secretId
}
