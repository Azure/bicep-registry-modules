<#
.SYNOPSIS
Sign and strictly verify the ACA-LZA sample before releasing its immutable private-registry image.
.DESCRIPTION
Run in the deployment subnet with the scoped workload managed identity. Keys remain non-exportable
in Key Vault. Use an isolated XDG_CONFIG_HOME and DOCKER_CONFIG; registry credentials are ephemeral.
Production consumers must provision their approved publisher trust roots and call Confirm-NotationImage
before deploying the exact returned digest. This is a deployment gate, not an ACA runtime admission policy.
Reference: https://learn.microsoft.com/azure/container-registry/container-registry-tutorial-sign-build-push
#>
function Invoke-NotationCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string[]] $Arguments,
        [string] $StandardInput
    )

    $startInfo = [System.Diagnostics.ProcessStartInfo]::new($Executable)
    $startInfo.UseShellExecute = $false
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true
    $startInfo.RedirectStandardInput = $true
    foreach ($argument in $Arguments) { $startInfo.ArgumentList.Add($argument) }
    $process = [System.Diagnostics.Process]::new()
    $process.StartInfo = $startInfo
    try {
        $null = $process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        if ($PSBoundParameters.ContainsKey('StandardInput')) {
            $process.StandardInput.WriteLine($StandardInput)
        }
        $process.StandardInput.Close()
        if (-not $process.WaitForExit(180000)) {
            $process.Kill($true)
            throw 'Notation exceeded its three-minute command deadline.'
        }
        @{
            ExitCode = $process.ExitCode
            Output   = $stdout.GetAwaiter().GetResult()
            Error    = $stderr.GetAwaiter().GetResult()
        }
    } finally {
        $process.Dispose()
    }
}

function Initialize-NotationTools {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [string] $Directory)

    $archive = Join-Path $Directory 'notation.tar.gz'
    Invoke-WebRequest -Uri 'https://github.com/notaryproject/notation/releases/download/v1.3.2/notation_1.3.2_linux_amd64.tar.gz' -OutFile $archive -ErrorAction Stop
    if ((Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash -ine 'e1a0f060308086bf8020b2d31defb7c5348f133ca0dba6a1a7820ef3cbb6dfe5') {
        throw 'Notation package SHA256 does not match the pinned release.'
    }
    $binaryDirectory = Join-Path $Directory 'bin'
    $null = New-Item -ItemType Directory -Path $binaryDirectory -Force -ErrorAction Stop
    tar -xzf $archive -C $binaryDirectory notation
    if ($LASTEXITCODE -ne 0) { throw 'Notation package extraction failed.' }
    $executable = Join-Path $binaryDirectory 'notation'
    $plugin = Invoke-NotationCommand -Executable $executable -Arguments @(
        'plugin', 'install', '--url',
        'https://github.com/Azure/notation-azure-kv/releases/download/v1.2.1/notation-azure-kv_1.2.1_linux_amd64.tar.gz',
        '--sha256sum', '67c5ccaaf28dd44d2b6572684d84e344a02c2258af1d65ead3910b3156d3eaf5'
    )
    if ($plugin.ExitCode -ne 0) { throw "Notation Key Vault plug-in installation failed: $($plugin.Error)" }
    $executable
}

function Get-NotationRegistryCredential {
    [CmdletBinding()]
    param ([Parameter(Mandatory)] [string] $LoginServer)

    $access = Get-AzAccessToken -ErrorAction Stop
    $token = if ($access.Token -is [System.Security.SecureString]) {
        [System.Net.NetworkCredential]::new('', $access.Token).Password
    } else { [string] $access.Token }
    try {
        $response = Invoke-RestMethod -Method Post -Uri "https://$LoginServer/oauth2/exchange" -ContentType 'application/x-www-form-urlencoded' -Body @{
            grant_type   = 'access_token'
            service      = $LoginServer
            tenant       = (Get-AzContext -ErrorAction Stop).Tenant.Id
            access_token = $token
        } -ErrorAction Stop
        if ([string]::IsNullOrWhiteSpace($response.refresh_token)) { throw 'ACR did not return a registry credential.' }
        $response.refresh_token
    } finally {
        $token = $null
        $access = $null
    }
}

function Get-NotationRepositoryToken {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $Repository,
        [Parameter(Mandatory)] [string] $RegistryCredential
    )

    $response = Invoke-RestMethod -Method Post -Uri "https://$LoginServer/oauth2/token" -ContentType 'application/x-www-form-urlencoded' -Body @{
        grant_type    = 'refresh_token'
        service       = $LoginServer
        scope         = "repository:${Repository}:pull,push"
        refresh_token = $RegistryCredential
    } -ErrorAction Stop
    if ([string]::IsNullOrWhiteSpace($response.access_token)) { throw 'ACR did not return a scoped repository token.' }
    $response.access_token
}

function Set-NotationTrust {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string] $Directory,
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $Repository,
        [Parameter(Mandatory)] [byte[]] $Certificate,
        [Parameter(Mandatory)] [string] $Subject
    )

    $certificatePath = Join-Path $Directory 'trusted.cer'
    [System.IO.File]::WriteAllBytes($certificatePath, $Certificate)
    $store = $Repository.Replace('/', '-')
    $add = Invoke-NotationCommand -Executable $Executable -Arguments @('cert', 'add', '--type', 'ca', '--store', $store, $certificatePath)
    if ($add.ExitCode -ne 0) { throw "Notation trust store import failed: $($add.Error)" }
    $policy = @{
        version       = '1.0'
        trustPolicies = @(@{
            name                  = 'aca-lza-image'
            registryScopes        = @("$LoginServer/$Repository")
            signatureVerification = @{ level = 'strict' }
            trustStores           = @("ca:$store")
            trustedIdentities     = @("x509.subject: $Subject")
        })
    }
    $policyPath = Join-Path $Directory 'trustpolicy.json'
    $policy | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $policyPath -Encoding utf8NoBOM
    $import = Invoke-NotationCommand -Executable $Executable -Arguments @('policy', 'import', '--force', $policyPath)
    if ($import.ExitCode -ne 0) { throw "Notation trust policy import failed: $($import.Error)" }
}

function Confirm-NotationImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string] $Image
    )

    if ($Image -cnotmatch '^[a-z0-9.-]+/[a-z0-9._/-]+@sha256:[a-f0-9]{64}$') {
        throw 'Image verification requires an immutable SHA256 image reference, not a tag.'
    }
    $result = Invoke-NotationCommand -Executable $Executable -Arguments @('verify', $Image)
    if ($result.ExitCode -ne 0) { throw "Image signature verification rejected [$Image]: $($result.Error)" }
    $Image
}

function Get-NotationCertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $VaultName,
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string] $Subject
    )

    $existing = @(Get-AzKeyVaultCertificate -VaultName $VaultName -ErrorAction Stop | Where-Object Name -CEQ $Name)
    if ($existing.Count -gt 1) { throw 'Signing certificate name is not unique in the owned vault.' }
    $certificate = if ($existing.Count -eq 1) {
        Get-AzKeyVaultCertificate -VaultName $VaultName -Name $Name -ErrorAction Stop
    } else { $null }
    if (-not $certificate) {
        $policy = New-AzKeyVaultCertificatePolicy -SubjectName $Subject -IssuerName Self -ValidityInMonths 12 `
            -KeyType RSA -KeySize 2048 -KeyNotExportable -KeyUsage DigitalSignature -Ekus '1.3.6.1.5.5.7.3.3' `
            -SecretContentType 'application/x-pem-file' -ReuseKeyOnRenewal -ErrorAction Stop
        $null = Add-AzKeyVaultCertificate -VaultName $VaultName -Name $Name -CertificatePolicy $policy -ErrorAction Stop
        for ($attempt = 0; $attempt -lt 30; $attempt++) {
            $operation = Get-AzKeyVaultCertificateOperation -VaultName $VaultName -Name $Name -ErrorAction Stop
            if ($operation.Status -ieq 'completed') { break }
            if ($operation.Status -ine 'inProgress') { throw "Signing certificate creation failed: $($operation.StatusDetails)" }
            Start-Sleep -Seconds 10
        }
        if ($operation.Status -ine 'completed') { throw 'Signing certificate creation exceeded five minutes.' }
        $certificate = Get-AzKeyVaultCertificate -VaultName $VaultName -Name $Name -ErrorAction Stop
    }
    if (-not $certificate -or $certificate.Certificate.Subject -cne $Subject -or
        [string]::IsNullOrWhiteSpace($certificate.KeyId) -or $certificate.Certificate.NotAfter.ToUniversalTime() -le [DateTime]::UtcNow) {
        throw 'Signing certificate is missing, expired, or does not match the expected publisher identity.'
    }
    $certificate
}

function Get-NotationSignatures {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $Repository,
        [Parameter(Mandatory)] [string] $Digest,
        [Parameter(Mandatory)] [string] $Token
    )

    $response = Invoke-RestMethod -Uri "https://$LoginServer/v2/$Repository/referrers/${Digest}?artifactType=application%2Fvnd.cncf.notary.signature" `
        -Headers @{ Authorization = "Bearer $Token" } -ErrorAction Stop
    if ($response.schemaVersion -ne 2 -or $response.mediaType -cne 'application/vnd.oci.image.index.v1+json') {
        throw 'ACR did not return a supported OCI signature referrers index.'
    }
    @($response.manifests)
}

function Set-VerifiedImageRelease {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $Repository,
        [Parameter(Mandatory)] [string] $Digest,
        [Parameter(Mandatory)] [string] $Token
    )

    if ($Digest -cnotmatch '^sha256:[a-f0-9]{64}$') { throw 'Quarantine release requires an exact verified digest.' }
    $null = Invoke-RestMethod -Method Patch -Uri "https://$LoginServer/acr/v1/$Repository/_manifests/$Digest" `
        -Headers @{ Authorization = "Bearer $Token" } -ContentType 'application/json' `
        -Body (@{ quarantineState = 'Passed'; quarantineDetails = '{"state":"Notation strict signature verification passed"}' } | ConvertTo-Json -Compress) -ErrorAction Stop
}

function Publish-VerifiedContainerImage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string] $Directory,
        [Parameter(Mandatory)] [string] $RegistryName,
        [Parameter(Mandatory)] [string] $ResourceGroupName,
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $VaultName,
        [string] $Repository = 'aca-lza/sample'
    )

    $subject = 'CN=aca-lza-sample'
    $certificate = Get-NotationCertificate -VaultName $VaultName -Name 'aca-lza-image-signing' -Subject $subject
    Set-NotationTrust -Executable $Executable -Directory $Directory -LoginServer $LoginServer -Repository $Repository `
        -Certificate $certificate.Certificate.RawData -Subject $subject
    $credential = Get-NotationRegistryCredential -LoginServer $LoginServer
    try {
        $login = Invoke-NotationCommand -Executable $Executable -Arguments @('login', $LoginServer, '--username', '00000000-0000-0000-0000-000000000000', '--password-stdin') -StandardInput $credential
        if ($login.ExitCode -ne 0) { throw 'Notation managed-identity registry login failed.' }
        $null = Import-AzContainerRegistryImage -RegistryName $RegistryName -ResourceGroupName $ResourceGroupName `
            -SourceRegistryUri 'mcr.microsoft.com' -SourceImage 'azuredocs/containerapps-helloworld:latest' `
            -TargetTag "${Repository}:sample" -Mode Force -ErrorAction Stop
        $token = Get-NotationRepositoryToken -LoginServer $LoginServer -Repository $Repository -RegistryCredential $credential
        $manifest = Invoke-WebRequest -Uri "https://$LoginServer/v2/$Repository/manifests/sample" -Headers @{
            Authorization = "Bearer $token"
            Accept        = 'application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json,application/vnd.oci.image.manifest.v1+json,application/vnd.docker.distribution.manifest.v2+json'
        } -ErrorAction Stop
        $digest = [string] @($manifest.Headers['Docker-Content-Digest'])[0]
        if ($digest -cnotmatch '^sha256:[a-f0-9]{64}$') { throw 'Imported image did not have an authoritative SHA256 digest.' }
        $image = "$LoginServer/$Repository@$digest"
        $before = @(Get-NotationSignatures -LoginServer $LoginServer -Repository $Repository -Digest $digest -Token $token)
        $sign = Invoke-NotationCommand -Executable $Executable -Arguments @(
            'sign', '--signature-format', 'cose', '--id', $certificate.KeyId, '--plugin', 'azure-kv',
            '--plugin-config', 'self_signed=true', '--plugin-config', 'credential_type=managedid',
            '--force-referrers-tag=false', $image
        )
        if ($sign.ExitCode -ne 0) { throw "Notation image signing failed: $($sign.Error)" }
        $verified = Confirm-NotationImage -Executable $Executable -Image $image
        $after = @(Get-NotationSignatures -LoginServer $LoginServer -Repository $Repository -Digest $digest -Token $token)
        $created = @($after | Where-Object { $_.digest -cnotin @($before.digest) })
        if ($created.Count -ne 1 -or $created[0].artifactType -cne 'application/vnd.cncf.notary.signature') {
            throw 'Could not identify exactly one newly signed OCI artifact; refusing quarantine release.'
        }
        Set-VerifiedImageRelease -LoginServer $LoginServer -Repository $Repository -Digest $created[0].digest -Token $token
        Set-VerifiedImageRelease -LoginServer $LoginServer -Repository $Repository -Digest $digest -Token $token
        @{
            image               = $verified
            signatureDigest     = $created[0].digest
            certificateBase64   = [Convert]::ToBase64String($certificate.Certificate.RawData)
            certificateSubject  = $subject
            strictVerification  = $true
        }
    } finally {
        $credential = $null
        $token = $null
    }
}
