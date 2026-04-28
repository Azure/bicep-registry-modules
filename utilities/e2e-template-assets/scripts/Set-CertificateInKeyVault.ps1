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

    $maxRetries = 10
    $retryCount = 0
    $WaitIntervalInSeconds = 10
    while (-not (Get-AzKeyVaultCertificateOperation -VaultName $KeyVaultName -Name $CertName -Verbose).Status -eq 'completed' -and $retryCount -lt $maxRetries) {
        Write-Verbose ('    [⏱️] Waiting {0} seconds for certificate creation to finish. [{1}/{2}]' -f $WaitIntervalInSeconds, $retryCount, $MaxRetries) -Verbose
        Start-Sleep $WaitIntervalInSeconds
        $retryCount++
    }
    if ($retryCount -eq $maxRetries) {
        throw "Certificate creation operation did not complete after [$maxRetries] attempts. Please review."
    }

    Write-Verbose 'Certificate created' -Verbose
}

$secretId = $certificate.SecretId

$maxRetries = 10
$retryCount = 0
$WaitIntervalInSeconds = 10
while ([String]::IsNullOrEmpty($secretId) -and $retryCount -lt $maxRetries) {
    Write-Verbose ('    [⏱️] Waiting {0} seconds until certificate can be fetched. [{1}/{2}]' -f $WaitIntervalInSeconds, $retryCount, $MaxRetries) -Verbose

    Start-Sleep $WaitIntervalInSeconds
    $certificate = Get-AzKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -ErrorAction 'Stop'
    $secretId = $certificate.SecretId
    $retryCount++
}
if ($retryCount -eq $maxRetries -and [String]::IsNullOrEmpty($secretId)) {
    throw "Failed to fetch certificate secret reference after [$maxRetries] attempts. Please review."
}

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    secretUrl = $secretId
}
