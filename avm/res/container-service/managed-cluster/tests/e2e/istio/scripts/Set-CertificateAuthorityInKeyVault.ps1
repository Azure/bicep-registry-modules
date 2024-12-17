<#
.SYNOPSIS
Generate a new Certificate Authority and store it as secret in the given Key Vault.

.DESCRIPTION
Generate a new Certificate Authority and store it as secret in the given Key Vault.

.PARAMETER KeyVaultName
Mandatory. The name of the Key Vault to add a new certificate to, or fetch the secret reference it from

.PARAMETER RootOrganization
Mandatory. The name of the organization to which the Root Certificate is issued. It helps identify the legal entity that owns the root certificate

.PARAMETER CAOrganization
Mandatory. The name of the organization to which the Certificate Authority is issued. It helps identify the legal entity that owns the certificate authority

.PARAMETER CertSubjectName
Mandatory. The subject distinguished name is the name of the user of the certificate authority. The distinguished name for the certificate is a textual representation of the subject or issuer of the certificate

.EXAMPLE
./Set-CertificateAuthorityInKeyVault.ps1 -KeyVaultName 'myVault' -RootOrganization 'Istio' -CAOrganization 'Istio' -CertSubjectName 'istiod.aks-istio-system.com'

Generate a Certificate Authority and store it in the Key Vault 'myVault' with the provided organizations and subject name
#>
param(
    [Parameter(Mandatory = $true)]
    [string] $KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string] $RootOrganization,

    [Parameter(Mandatory = $true)]
    [string] $CAOrganization,

    [Parameter(Mandatory = $true)]
    [string] $CertSubjectName
)

$rootKeyFile = 'root-key.pem'
$rootKeySize = 4096

Write-Verbose ('Generating root key [{0}]' -f $rootKeyFile) -Verbose

openssl genrsa -out $rootKeyFile $rootKeySize

$rootKeyContent = Get-Content -Path $rootKeyFile -Raw
$rootKeyContentSecureString = ConvertTo-SecureString -String $rootKeyContent -AsPlainText -Force
$rootKeySecretName = 'root-key'
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $rootKeySecretName -SecretValue $rootKeyContentSecureString

$rootConfFile = 'root-ca.conf'
$rootCommonName = 'Root CA'
$rootConfContent = @"
[ req ]
encrypt_key = no
prompt = no
utf8 = yes
default_md = sha256
default_bits = $($rootKeySize)
req_extensions = req_ext
x509_extensions = req_ext
distinguished_name = req_dn
[ req_ext ]
subjectKeyIdentifier = hash
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, nonRepudiation, keyEncipherment, keyCertSign
[ req_dn ]
O = $($RootOrganization)
CN = $($rootCommonName)
"@

Write-Verbose ('Generating openssl config file [{0}]' -f $rootConfFile) -Verbose

$rootConfContent | Set-Content -Path $rootConfFile

$rootCertCSRFile = 'root-cert.csr'

Write-Verbose ('Generating certificate signing request [{0}]' -f $rootCertCSRFile) -Verbose

openssl req -sha256 -new -key $rootKeyFile -config $rootConfFile -out $rootCertCSRFile

$rootCertFile = 'root-cert.pem'
$rootCertDays = 3650

Write-Verbose ('Generating root cert [{0}]' -f $rootCertFile) -Verbose

openssl x509 -req -sha256 -days $rootCertDays -signkey $rootKeyFile -extensions req_ext -extfile $rootConfFile -in $rootCertCSRFile -out $rootCertFile

$rootCertContent = Get-Content -Path $rootCertFile -Raw
$rootCertContentSecureString = ConvertTo-SecureString -String $rootCertContent -AsPlainText -Force
$rootCertSecretName = 'root-cert'
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $rootCertSecretName -SecretValue $rootCertContentSecureString

$caKeyFile = 'ca-key.pem'
$caKeySize = '4096'

Write-Verbose ('Generating ca key [{0}]' -f $caKeyFile) -Verbose

openssl genrsa -out $caKeyFile $caKeySize

$caKeyContent = Get-Content -Path $caKeyFile -Raw
$caKeyContentSecureString = ConvertTo-SecureString -String $caKeyContent -AsPlainText -Force
$caKeySecretName = 'ca-key'
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $caKeySecretName -SecretValue $caKeyContentSecureString

$caConfFile = 'ca.conf'
$caCommonName = 'Intermediate CA'
$caConfLocation = Split-Path -Leaf (Get-Location)
$caConfContent = @"
[ req ]
encrypt_key = no
prompt = no
utf8 = yes
default_md = sha256
default_bits = $($caKeySize)
req_extensions = req_ext
x509_extensions = req_ext
distinguished_name = req_dn
[ req_ext ]
subjectKeyIdentifier = hash
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, nonRepudiation, keyEncipherment, keyCertSign
subjectAltName=@san
[ san ]
DNS.1 = $($CertSubjectName)
[ req_dn ]
O = $($CAOrganization)
CN = $($caCommonName)
L = $($caConfLocation)
"@

Write-Verbose ('Generating openssl config file [{0}]' -f $caConfFile) -Verbose

$caConfContent | Set-Content -Path $caConfFile

$caCertCSRFile = 'ca-cert.csr'

Write-Verbose ('Generating certificate signing request [{0}]' -f $caCertCSRFile) -Verbose

openssl req -sha256 -new -key $caKeyFile -config $caConfFile -out $caCertCSRFile

$caCertFile = 'ca-cert.pem'
$caCertDays = 3650

Write-Verbose ('Generating ca cert [{0}]' -f $caCertFile) -Verbose

openssl x509 -req -sha256 -days $caCertDays -CA $rootCertFile -CAkey $rootKeyFile -CAcreateserial -extensions req_ext -extfile $caConfFile -in $caCertCSRFile -out $caCertFile

$caCertContent = Get-Content -Path $caCertFile -Raw
$caCertContentSecureString = ConvertTo-SecureString -String $caCertContent -AsPlainText -Force
$caCertSecretName = 'ca-cert'
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $caCertSecretName -SecretValue $caCertContentSecureString

Write-Verbose 'Generating cert chain' -Verbose

$certChainContent = $caCertContent + $rootCertContent
$certChainContentSecureString = ConvertTo-SecureString -String $certChainContent -AsPlainText -Force
$certChainSecretName = 'cert-chain'
Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $certChainSecretName -SecretValue $certChainContentSecureString

# Write into Deployment Script output stream
$DeploymentScriptOutputs = @{
    rootKeySecretName   = $rootKeySecretName
    rootCertSecretName  = $rootCertSecretName
    caKeySecretName     = $caKeySecretName
    caCertSecretName    = $caCertSecretName
    certChainSecretName = $certChainSecretName
}
