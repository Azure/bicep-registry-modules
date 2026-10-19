function Get-TestOciBytes {
    param (
        [Parameter(Mandatory)] [string] $Uri,
        [Parameter(Mandatory)] [string] $Token,
        [Parameter(Mandatory)] [string] $Directory
    )

    $file = Join-Path $Directory ([guid]::NewGuid().ToString('N'))
    try {
        $null = Invoke-WebRequest -Uri $Uri -Headers @{ Authorization = "Bearer $Token" } -OutFile $file -ErrorAction Stop
        , [System.IO.File]::ReadAllBytes($file)
    } finally {
        if ([System.IO.File]::Exists($file)) { [System.IO.File]::Delete($file) }
    }
}

function Add-TestOciBlob {
    param (
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $Repository,
        [Parameter(Mandatory)] [string] $Token,
        [Parameter(Mandatory)] [byte[]] $Content
    )

    $digest = 'sha256:' + [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($Content)).ToLowerInvariant()
    $start = Invoke-WebRequest -Method Post -Uri "https://$LoginServer/v2/$Repository/blobs/uploads/" `
        -Headers @{ Authorization = "Bearer $Token" } -ErrorAction Stop
    $location = [string] @($start.Headers.Location)[0]
    $upload = [uri]::new([uri] "https://$LoginServer", $location)
    if ($start.StatusCode -ne 202 -or $upload.Host -cne $LoginServer -or $upload.Scheme -cne 'https' -or
        $upload.AbsolutePath -cnotlike "/v2/$Repository/blobs/uploads/*") {
        throw 'OCI upload did not return an owned registry upload location.'
    }
    $separator = [string]::IsNullOrEmpty($upload.Query) ? '?' : '&'
    $null = Invoke-WebRequest -Method Put -Uri "$($upload.AbsoluteUri)${separator}digest=$digest" `
        -Headers @{ Authorization = "Bearer $Token" } -ContentType 'application/octet-stream' -Body $Content -ErrorAction Stop
    $digest
}

function Confirm-TestSignatureRejection {
    param (
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string] $Image,
        [Parameter(Mandatory)] [ValidateSet('Unsigned', 'Tampered', 'Untrusted')] [string] $Case
    )

    try {
        $null = Confirm-NotationImage -Executable $Executable -Image $Image
    } catch {
        $message = $_.Exception.Message
        $expected = switch ($Case) {
            Unsigned { 'no signature is associated with' }
            Tampered { 'signature is invalid\. Error:' }
            Untrusted { 'the signature''s certificate chain does not contain any trusted certificate' }
        }
        if ($message -notmatch $expected -or
            $message -match 'unauthorized|authentication failed|connection refused|timed? out|no such host|certificate signed by unknown authority') {
            throw "[$Case] did not establish the intended signature rejection: $message"
        }
        return @{
            case            = $Case
            rejected        = $true
            errorSha256     = [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($message))).ToLowerInvariant()
        }
    }
    throw "[$Case] was accepted by the real consuming verification gate."
}

function Test-NotationImageVerification {
    param (
        [Parameter(Mandatory)] [string] $Executable,
        [Parameter(Mandatory)] [string] $Directory,
        [Parameter(Mandatory)] [string] $RegistryName,
        [Parameter(Mandatory)] [string] $ResourceGroupName,
        [Parameter(Mandatory)] [string] $LoginServer,
        [Parameter(Mandatory)] [string] $VaultName,
        [Parameter(Mandatory)] [string] $TrustedImage,
        [Parameter(Mandatory)] [string] $TrustedSignatureDigest,
        [Parameter(Mandatory)] [byte[]] $TrustedCertificate,
        [Parameter(Mandatory)] [string] $TrustedSubject
    )

    if ($TrustedImage -cnotmatch "^$([regex]::Escape($LoginServer))/aca-lza/sample@(sha256:[a-f0-9]{64})$" -or
        $TrustedSignatureDigest -cnotmatch '^sha256:[a-f0-9]{64}$') {
        throw 'Native signature tests require the exact owned, verified sample and signature digests.'
    }
    $digest = $TrustedImage.Split('@')[1]
    $sourceRepository = 'aca-lza/sample'
    $credential = Get-NotationRegistryCredential -LoginServer $LoginServer
    try {
        $login = Invoke-NotationCommand -Executable $Executable -Arguments @(
            'login', $LoginServer, '--username', '00000000-0000-0000-0000-000000000000', '--password-stdin'
        ) -StandardInput $credential
        if ($login.ExitCode -ne 0) { throw 'Native signature test registry login failed.' }
        Set-NotationTrust -Executable $Executable -Directory $Directory -LoginServer $LoginServer -Repository $sourceRepository `
            -Certificate $TrustedCertificate -Subject $TrustedSubject
        $positive = Confirm-NotationImage -Executable $Executable -Image $TrustedImage
        $sourceToken = Get-NotationRepositoryToken -LoginServer $LoginServer -Repository $sourceRepository -RegistryCredential $credential
        $signature = Invoke-RestMethod -Uri "https://$LoginServer/v2/$sourceRepository/manifests/$TrustedSignatureDigest" `
            -Headers @{ Authorization = "Bearer $sourceToken"; Accept = 'application/vnd.oci.image.manifest.v1+json' } -ErrorAction Stop
        if ($signature.artifactType -cne 'application/vnd.cncf.notary.signature' -or $signature.subject.digest -cne $digest -or
            $signature.layers.Count -ne 1 -or $signature.layers[0].mediaType -cne 'application/cose') {
            throw 'The native trusted signature does not match the expected COSE artifact and original image.'
        }
        $envelope = Get-TestOciBytes -Uri "https://$LoginServer/v2/$sourceRepository/blobs/$($signature.layers[0].digest)" -Token $sourceToken -Directory $Directory
        $configuration = Get-TestOciBytes -Uri "https://$LoginServer/v2/$sourceRepository/blobs/$($signature.config.digest)" -Token $sourceToken -Directory $Directory
        $originalEnvelopeDigest = 'sha256:' + [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData($envelope)).ToLowerInvariant()
        if ($originalEnvelopeDigest -cne $signature.layers[0].digest -or $envelope.Length -lt 64) {
            throw 'The original signature envelope bytes did not match the authoritative OCI descriptor.'
        }
        $suffix = [guid]::NewGuid().ToString('N')
        $registryId = "/subscriptions/$((Get-AzContext -ErrorAction Stop).Subscription.Id)/resourceGroups/$ResourceGroupName/providers/Microsoft.ContainerRegistry/registries/$RegistryName"
        $checks = @()
        foreach ($case in @('Unsigned', 'Tampered', 'Untrusted')) {
            $repository = "aca-lza/verify-$suffix/$($case.ToLowerInvariant())"
            $null = Import-AzContainerRegistryImage -RegistryName $RegistryName -ResourceGroupName $ResourceGroupName `
                -SourceResourceId $registryId -SourceImage "$sourceRepository@$digest" -TargetTag "${repository}:negative" -Mode NoForce -ErrorAction Stop
            $token = Get-NotationRepositoryToken -LoginServer $LoginServer -Repository $repository -RegistryCredential $credential
            $target = Invoke-WebRequest -Uri "https://$LoginServer/v2/$repository/manifests/negative" -Headers @{
                Authorization = "Bearer $token"
                Accept        = 'application/vnd.oci.image.index.v1+json,application/vnd.docker.distribution.manifest.list.v2+json,application/vnd.oci.image.manifest.v1+json,application/vnd.docker.distribution.manifest.v2+json'
            } -ErrorAction Stop
            if ([string] @($target.Headers['Docker-Content-Digest'])[0] -cne $digest) {
                throw 'Negative test image was not the exact original image digest.'
            }
            $before = @(Get-NotationSignatures -LoginServer $LoginServer -Repository $repository -Digest $digest -Token $token)
            if ($before.Count -ne 0) { throw 'The fresh negative test repository unexpectedly already contained signatures.' }
            Set-NotationTrust -Executable $Executable -Directory $Directory -LoginServer $LoginServer -Repository $repository `
                -Certificate $TrustedCertificate -Subject $TrustedSubject
            if ($case -ceq 'Tampered') {
                $modified = [byte[]] $envelope.Clone()
                $modified[-1] = $modified[-1] -bxor 1
                $modifiedDigest = Add-TestOciBlob -LoginServer $LoginServer -Repository $repository -Token $token -Content $modified
                $configDigest = Add-TestOciBlob -LoginServer $LoginServer -Repository $repository -Token $token -Content $configuration
                if ($modifiedDigest -ceq $originalEnvelopeDigest -or $configDigest -cne $signature.config.digest) {
                    throw 'Native tampering did not change only the COSE signature envelope.'
                }
                $changed = $signature | ConvertTo-Json -Depth 30 | ConvertFrom-Json -AsHashtable -Depth 30
                $changed.layers[0].digest = $modifiedDigest
                $changed.layers[0].size = $modified.Length
                $body = $changed | ConvertTo-Json -Depth 30 -Compress
                $manifestDigest = 'sha256:' + [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($body))).ToLowerInvariant()
                $null = Invoke-WebRequest -Method Put -Uri "https://$LoginServer/v2/$repository/manifests/$manifestDigest" `
                    -Headers @{ Authorization = "Bearer $token" } -ContentType 'application/vnd.oci.image.manifest.v1+json' -Body $body -ErrorAction Stop
            } elseif ($case -ceq 'Untrusted') {
                $other = Get-NotationCertificate -VaultName $VaultName -Name 'aca-lza-untrusted-test-signing' -Subject $TrustedSubject
                if ([Convert]::ToBase64String($other.Certificate.RawData) -ceq [Convert]::ToBase64String($TrustedCertificate)) {
                    throw 'Untrusted-root test unexpectedly reused the trusted public certificate.'
                }
                $sign = Invoke-NotationCommand -Executable $Executable -Arguments @(
                    'sign', '--signature-format', 'cose', '--id', $other.KeyId, '--plugin', 'azure-kv',
                    '--plugin-config', 'self_signed=true', '--plugin-config', 'credential_type=managedid',
                    '--force-referrers-tag=false', "$LoginServer/$repository@$digest"
                )
                if ($sign.ExitCode -ne 0) { throw "Untrusted test publisher could not produce its actual signature: $($sign.Error)" }
            }
            $present = @(Get-NotationSignatures -LoginServer $LoginServer -Repository $repository -Digest $digest -Token $token)
            $expectedCount = $case -ceq 'Unsigned' ? 0 : 1
            if ($present.Count -ne $expectedCount) { throw 'Negative test signature presence did not match its declared case.' }
            $checks += Confirm-TestSignatureRejection -Executable $Executable -Image "$LoginServer/$repository@$digest" -Case $case
        }
        @{
            trustedImage       = $positive
            trustedAccepted    = $true
            controls           = $checks
            privateKeyExported = $false
        }
    } finally {
        $credential = $null
        $sourceToken = $null
        $token = $null
    }
}
