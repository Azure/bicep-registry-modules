<#
.SYNOPSIS
Generate a new PFX Certificate and store it alongside its password as Secrets in the given Key Vault.

.DESCRIPTION
Generate a new PFX Certificate and store it alongside its password as Secrets in the given Key Vault.

.PARAMETER KeyVaultName
Mandatory. The name of the Key Vault to store the Certificate & Password in

.PARAMETER ResourceGroupName
Mandatory. The name of the Resource Group containing the Key Vault to store the Certificate & Password in

.PARAMETER NamePrefix
Mandatory. The name prefix to use for the certificate, which is used as prefix to .onmicrosoft.com to generate the CN for the certificate.

.PARAMETER CertPWSecretName
Mandatory. The name of the Secret to store the Certificate's password in

.PARAMETER CertSecretName
Mandatory. The name of the Secret to store the Secret in

.EXAMPLE
./Set-PfxCertificateInKeyVault.ps1 -KeyVaultName 'myVault' -ResourceGroupName 'vault-rg' -CertPWSecretName 'pfxCertificatePassword' -CertSecretName 'pfxBase64Certificate'

Generate a Certificate and store it as the Secret 'pfxCertificatePassword' in the Key Vault 'vault-rg' of Resource Group 'storage-rg' alongside its password as the Secret 'pfxCertificatePassword'
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string] $NamePrefix,

    [Parameter(Mandatory = $true)]
    [string] $CertPWSecretName,

    [Parameter(Mandatory = $true)]
    [string] $CertSecretName
)

$password = "$ResourceGroupName/$KeyVaultName/$CertSecretName"
$pfxPassword = ConvertTo-SecureString -String $password -AsPlainText -Force

# Install open-ssl if not available
apt-get install openssl

# Generate certificate
$cn = '*.' + $namePrefix + '.onmicrosoft.com'
$subject = '/CN=' + $cn + '/O=contoso/C=US'
Write-Verbose ('Generating certificate for [{0}]' -f $cn) -Verbose
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout './privateKey.key' -out './certificate.crt' -subj $subject -addext 'extendedKeyUsage = serverAuth'

# Sign certificate
openssl pkcs12 -export -out 'aadds.pfx' -inkey './privateKey.key' -in './certificate.crt' -passout pass:$password

# Convert certificate to string
$rawCertByteStream = Get-Content './aadds.pfx' -AsByteStream
Write-Verbose 'Convert to secure string' -Verbose
$pfxCertificate = ConvertTo-SecureString -String ([System.Convert]::ToBase64String($rawCertByteStream)) -AsPlainText -Force

# Set values
@(
    @{ name = $CertPWSecretName; secretValue = $pfxPassword }
    @{ name = $CertSecretName; secretValue = $pfxCertificate }
) | ForEach-Object {
    $null = Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $_.name -SecretValue $_.secretValue
    Write-Verbose ('Added secret [{0}] to key vault [{1}]' -f $_.name, $keyVaultName) -Verbose
}
