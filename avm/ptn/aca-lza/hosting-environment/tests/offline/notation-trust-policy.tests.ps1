param ([string] $NotationExecutable = 'notation')

BeforeAll {
    $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
    . (Join-Path $moduleRoot 'scripts' 'Invoke-VerifiedContainerImage.ps1')
    . (Join-Path $moduleRoot 'tests' 'e2e' 'waf-aligned' 'Test-NotationImageVerification.ps1')
    $nativeNotationCommand = ${function:Invoke-NotationCommand}
    $notation = (Get-Command $NotationExecutable -CommandType Application -ErrorAction Stop).Source
    $version = Invoke-NotationCommand -Executable $notation -Arguments @('version')
    if ($version.ExitCode -ne 0 -or $version.Output -cnotmatch '(?m)^Version:\s+1\.3\.2\s*$') {
        throw 'These offline trust-policy regressions require the production-pinned Notation 1.3.2 CLI.'
    }

    function Get-AzAccessToken { throw 'Offline tests must not access Azure.' }
    function Get-AzContext { throw 'Offline tests must not access Azure.' }
    function Get-AzKeyVaultCertificate { param($VaultName, $Name) throw 'Offline tests must not access Azure.' }
    function New-AzKeyVaultCertificatePolicy {
        param($SubjectName, $IssuerName, $ValidityInMonths, $KeyType, $KeySize, [switch] $KeyNotExportable,
            $KeyUsage, $Ekus, $SecretContentType, [switch] $ReuseKeyOnRenewal)
        throw 'Offline tests must not access Azure.'
    }
    function Add-AzKeyVaultCertificate { param($VaultName, $Name, $CertificatePolicy) throw 'Offline tests must not access Azure.' }
    function Get-AzKeyVaultCertificateOperation { param($VaultName, $Name) throw 'Offline tests must not access Azure.' }
    function Import-AzContainerRegistryImage {
        param($RegistryName, $ResourceGroupName, $SourceRegistryUri, $SourceImage, $SourceResourceId, $TargetTag, $Mode)
        throw 'Offline tests must not access Azure.'
    }

    function New-OfflineSigningCertificate {
        param([string] $Name, [string] $Subject)

        $key = [System.Security.Cryptography.RSA]::Create(2048)
        $script:keys.Add($key)
        $request = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
            $Subject, $key, [System.Security.Cryptography.HashAlgorithmName]::SHA256,
            [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
        )
        $request.CertificateExtensions.Add([System.Security.Cryptography.X509Certificates.X509KeyUsageExtension]::new(
                [System.Security.Cryptography.X509Certificates.X509KeyUsageFlags]::DigitalSignature, $true))
        $usages = [System.Security.Cryptography.OidCollection]::new()
        $null = $usages.Add([System.Security.Cryptography.Oid]::new('1.3.6.1.5.5.7.3.3'))
        $request.CertificateExtensions.Add([System.Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension]::new($usages, $true))
        $certificate = $request.CreateSelfSigned([DateTimeOffset]::UtcNow.AddDays(-1), [DateTimeOffset]::UtcNow.AddMonths(12))
        $script:publicCertificates.Add($certificate)
        [pscustomobject]@{
            Name        = $Name
            KeyId       = "https://offline.invalid/keys/$Name/00000000000000000000000000000000"
            Certificate = $certificate
        }
    }

    function Set-OfflineNotationDirectory {
        param([string] $Directory)

        $null = New-Item -ItemType Directory -Path $Directory -Force
        $env:XDG_CONFIG_HOME = $Directory
        $env:APPDATA = Join-Path $Directory 'appdata'
        $env:DOCKER_CONFIG = Join-Path $Directory 'docker'
        $null = New-Item -ItemType Directory -Path $env:APPDATA -Force
    }

    $expectedSubject = 'CN=aca-lza-sample, O=Azure Verified Modules, ST=Washington, C=US'
    $digest = 'sha256:' + ('a' * 64)
    $signatureDigest = 'sha256:' + ('b' * 64)
    $image = "registry.example.invalid/aca-lza/sample@$digest"
}

Describe 'ACA-LZA actual trust policies with offline Notation 1.3.2' {
    BeforeEach {
        $savedEnvironment = @{}
        foreach ($name in @('XDG_CONFIG_HOME', 'APPDATA', 'DOCKER_CONFIG')) {
            $savedEnvironment[$name] = [Environment]::GetEnvironmentVariable($name)
        }
        Set-OfflineNotationDirectory -Directory (Join-Path $TestDrive ([guid]::NewGuid().ToString('N')))
        $script:keys = [System.Collections.Generic.List[object]]::new()
        $script:publicCertificates = [System.Collections.Generic.List[object]]::new()
        $script:certificates = @{}
        $script:policies = [System.Collections.Generic.List[object]]::new()
        $script:nativeImports = [System.Collections.Generic.List[object]]::new()
        $script:registryCommands = [System.Collections.Generic.List[object]]::new()
        $script:releases = [System.Collections.Generic.List[string]]::new()
        $script:producerReferrerReads = 0
        $script:controlReferrerReads = @{}
        $script:envelope = [byte[]] (0..127)
        $script:configuration = [Text.Encoding]::UTF8.GetBytes('{}')
        $script:envelopeDigest = 'sha256:' + [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($script:envelope)).ToLowerInvariant()
        $script:configurationDigest = 'sha256:' + [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($script:configuration)).ToLowerInvariant()
        Mock Get-AzAccessToken { @{ Token = ConvertTo-SecureString 'offline-access' -AsPlainText -Force } }
        Mock Get-AzContext { @{ Tenant = @{ Id = '00000000-0000-0000-0000-000000000001' }; Subscription = @{ Id = '00000000-0000-0000-0000-000000000002' } } }
        Mock Get-AzKeyVaultCertificate {
            if ($Name) { return $script:certificates[$Name] }
            @($script:certificates.Values)
        }
        Mock New-AzKeyVaultCertificatePolicy {
            $script:policies.Add(@{ SubjectName = $SubjectName; KeyNotExportable = $KeyNotExportable.IsPresent; KeyUsage = $KeyUsage; Ekus = $Ekus })
            @{ SubjectName = $SubjectName }
        }
        Mock Add-AzKeyVaultCertificate {
            $script:certificates[$Name] = New-OfflineSigningCertificate -Name $Name -Subject $CertificatePolicy.SubjectName
        }
        Mock Get-AzKeyVaultCertificateOperation { @{ Status = 'completed' } }
        Mock Import-AzContainerRegistryImage {
            if ($SourceResourceId) { throw 'Registry has exports disabled.' }
        }
        Mock Invoke-NotationCommand {
            if ($Arguments[0] -in @('cert', 'policy')) {
                $result = . $nativeNotationCommand -Executable $Executable -Arguments $Arguments
                if ($Arguments[0] -ceq 'policy') {
                    $script:nativeImports.Add(@{
                            exitCode = $result.ExitCode
                            error = $result.Error
                            policy = Get-Content -LiteralPath $Arguments[-1] -Raw | ConvertFrom-Json
                            certificate = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path (Split-Path $Arguments[-1]) 'trusted.cer')))
                        })
                }
                return $result
            }
            if ($Arguments[0] -ceq 'login') { throw 'Persistent registry login must not be used.' }
            if ($Arguments[0] -cin @('sign', 'verify')) {
                $RegistryCredential | Should -BeExactly 'offline-refresh'
                $Arguments | Should -Not -Contain 'offline-refresh'
                $script:registryCommands.Add(@{ verb = $Arguments[0]; arguments = @($Arguments); credential = $RegistryCredential })
            }
            if ($Arguments[0] -ceq 'sign') { return @{ ExitCode = 0; Output = ''; Error = '' } }
            if ($Arguments[0] -ceq 'verify') {
                $errorText = switch -Regex ($Arguments[-1]) {
                    '/unsigned@' { 'no signature is associated with this artifact' }
                    '/tampered@' { 'signature is invalid. Error: offline integrity rejection' }
                    '/untrusted@' { 'the signature''s certificate chain does not contain any trusted certificate' }
                    '/aca-lza/sample@' { '' }
                    default { throw 'Unexpected offline verification reference.' }
                }
                return @{ ExitCode = ($errorText ? 1 : 0); Output = ''; Error = $errorText }
            }
            throw "Unexpected command outside the real offline cert/policy boundary: $($Arguments[0])"
        }
        Mock Invoke-WebRequest {
            if ($OutFile) {
                $bytes = $Uri.AbsoluteUri.EndsWith($script:envelopeDigest) ? $script:envelope : $script:configuration
                [IO.File]::WriteAllBytes($OutFile, $bytes)
                return
            }
            if ($Method -ceq 'Post' -and $Uri -match '/v2/(.+)/blobs/uploads/$') {
                return @{ StatusCode = 202; Headers = @{ Location = "https://registry.example.invalid/v2/$($Matches[1])/blobs/uploads/offline" } }
            }
            if ($Method -ceq 'Put') { return @{} }
            if ($Uri -match '/manifests/(sample|negative)$') { return @{ Headers = @{ 'Docker-Content-Digest' = @($digest) } } }
            throw "Unexpected offline HTTP request [$Uri]."
        }
        Mock Invoke-RestMethod {
            if ($Uri -like '*/oauth2/exchange') { return @{ refresh_token = 'offline-refresh' } }
            if ($Uri -like '*/oauth2/token') { return @{ access_token = 'offline-repository' } }
            if ($Method -ceq 'Patch') { $script:releases.Add($Uri); return @{} }
            if ($Uri -match '/v2/aca-lza/sample/referrers/') {
                $script:producerReferrerReads++
                $descriptors = $script:producerReferrerReads -gt 1 ? @(@{ digest = $signatureDigest; artifactType = 'application/vnd.cncf.notary.signature' }) : @()
                return @{ schemaVersion = 2; mediaType = 'application/vnd.oci.image.index.v1+json'; manifests = $descriptors }
            }
            if ($Uri -match '/v2/(aca-lza/verify-[a-f0-9]+/(unsigned|tampered|untrusted))/referrers/') {
                $repository = $Matches[1]
                $script:controlReferrerReads[$repository]++
                $descriptors = ($script:controlReferrerReads[$repository] -gt 1 -and $Matches[2] -cne 'unsigned') ? @(@{ digest = $signatureDigest }) : @()
                return @{ schemaVersion = 2; mediaType = 'application/vnd.oci.image.index.v1+json'; manifests = $descriptors }
            }
            if ($Uri -ceq "https://registry.example.invalid/v2/aca-lza/sample/manifests/$signatureDigest") {
                return @{
                    config = @{ mediaType = 'application/vnd.cncf.notary.signature'; digest = $script:configurationDigest }
                    subject = @{ digest = $digest }
                    layers = @(@{ digest = $script:envelopeDigest; mediaType = 'application/cose'; size = $script:envelope.Length })
                }
            }
            throw "Unexpected offline REST request [$Uri]."
        }
        $publish = @{
            Executable = $notation
            Directory = $env:XDG_CONFIG_HOME
            RegistryName = 'registry'
            ResourceGroupName = 'offline-rg'
            LoginServer = 'registry.example.invalid'
            VaultName = 'offline-vault'
        }
    }

    AfterEach {
        foreach ($certificate in $script:publicCertificates) { $certificate.Dispose() }
        foreach ($key in $script:keys) { $key.Dispose() }
        foreach ($name in $savedEnvironment.Keys) {
            [Environment]::SetEnvironmentVariable($name, $savedEnvironment[$name])
        }
    }

    It 'Imports actual generated producer, verifier and all three control policies with the pinned CLI' {
        $published = Publish-VerifiedContainerImage @publish
        $trusted = $script:certificates['aca-lza-image-signing'].Certificate
        $published.certificateSubject | Should -BeExactly $trusted.Subject
        $script:policies[0].SubjectName | Should -BeExactly $expectedSubject
        $script:policies[0].KeyNotExportable | Should -BeTrue
        $script:policies[0].KeyUsage | Should -BeExactly 'DigitalSignature'
        $script:policies[0].Ekus | Should -BeExactly '1.3.6.1.5.5.7.3.3'

        $verificationDirectory = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        Set-OfflineNotationDirectory -Directory $verificationDirectory
        $verified = Test-NotationImageVerification -Executable $notation -Directory $verificationDirectory `
            -RegistryName 'registry' -ResourceGroupName 'offline-rg' -LoginServer 'registry.example.invalid' -VaultName 'offline-vault' `
            -TrustedImage $published.image -TrustedSignatureDigest $published.signatureDigest `
            -TrustedCertificate ([Convert]::FromBase64String($published.certificateBase64)) -TrustedSubject $published.certificateSubject

        $script:nativeImports.Count | Should -Be 5
        foreach ($import in $script:nativeImports) {
            $import.exitCode | Should -Be 0
            @($import.policy.trustPolicies).Count | Should -Be 1
            $statement = $import.policy.trustPolicies[0]
            $statement.signatureVerification.level | Should -BeExactly 'strict'
            @($statement.signatureVerification.PSObject.Properties.Name) | Should -Be @('level')
            $statement.trustedIdentities | Should -Be @("x509.subject: $($trusted.Subject)")
            $scope = $statement.registryScopes[0]
            $scope | Should -Match '^registry\.example\.invalid/aca-lza/(sample|verify-[a-f0-9]+/(unsigned|tampered|untrusted))$'
            $statement.trustStores | Should -Be @('ca:' + $scope.Split('/', 2)[1].Replace('/', '-'))
            $import.certificate | Should -BeExactly $published.certificateBase64
        }
        @($script:nativeImports | ForEach-Object { $_.policy.trustPolicies[0].registryScopes[0] } | Select-Object -Unique).Count | Should -Be 4
        @($verified.controls.case) | Should -Be @('Unsigned', 'Tampered', 'Untrusted')
        Should -Invoke Import-AzContainerRegistryImage -Times 3 -Exactly -ParameterFilter {
            -not $SourceResourceId -and $SourceRegistryUri -ceq 'mcr.microsoft.com' -and
            $SourceImage -ceq "azuredocs/containerapps-helloworld@$digest" -and $Mode -ceq 'NoForce'
        }
        $script:registryCommands.Count | Should -Be 7
        @($script:registryCommands | Where-Object verb -CEQ 'sign').Count | Should -Be 2
        @($script:registryCommands | Where-Object verb -CEQ 'verify').Count | Should -Be 5
        foreach ($command in $script:registryCommands) {
            $command.credential | Should -BeExactly 'offline-refresh'
            $command.arguments | Should -Not -Contain '--password'
        }
        $other = $script:certificates['aca-lza-untrusted-test-signing'].Certificate
        $other.Subject | Should -BeExactly $trusted.Subject
        [Convert]::ToBase64String($other.RawData) | Should -Not -BeExactly $published.certificateBase64
        @($script:policies | Where-Object { -not $_.KeyNotExportable }).Count | Should -Be 0
    }

    It 'Rejects malformed actual generated trust identities at the real CLI boundary: <Subject>' -ForEach @(
        @{ Subject = 'CN=aca-lza-sample' }
        @{ Subject = 'CN=aca-lza-sample, O=Azure Verified Modules, C=US' }
    ) {
        $certificate = New-OfflineSigningCertificate -Name 'offline' -Subject $expectedSubject
        {
            Set-NotationTrust -Executable $notation -Directory $env:XDG_CONFIG_HOME -LoginServer 'registry.example.invalid' `
                -Repository 'aca-lza/sample' -Certificate $certificate.Certificate.RawData -Subject $Subject
        } | Should -Throw '*trust policy import failed*has no mandatory RDN attribute*'
        $script:nativeImports.Count | Should -Be 1
        $script:nativeImports[0].exitCode | Should -Not -Be 0
    }

    It 'Stops publication before registry import or release when the real CLI rejects the certificate identity' {
        $cnOnly = New-OfflineSigningCertificate -Name 'aca-lza-image-signing' -Subject 'CN=aca-lza-sample'
        Mock Get-NotationCertificate { $cnOnly }
        { Publish-VerifiedContainerImage @publish } | Should -Throw '*trust policy import failed*has no mandatory RDN attribute*'
        Should -Invoke Import-AzContainerRegistryImage -Times 0 -Exactly
        $script:releases.Count | Should -Be 0
        $script:nativeImports[0].exitCode | Should -Not -Be 0
    }

    It 'Accepts only equivalent X509 subject formatting without losing mandatory identity attributes' {
        $script:certificates['aca-lza-image-signing'] = New-OfflineSigningCertificate -Name 'aca-lza-image-signing' -Subject $expectedSubject
        $certificate = Get-NotationCertificate -VaultName 'offline-vault' -Name 'aca-lza-image-signing' -Subject $expectedSubject
        $certificate.Certificate.Subject | Should -Match 'CN=aca-lza-sample'
        $certificate.Certificate.Subject | Should -Match '(ST|S)=Washington'
    }

    It 'Recognizes the actual native COSE rejection for the <Case> control' -ForEach @(
        @{ Case = 'Tampered' }
        @{ Case = 'Untrusted' }
    ) {
        $savedExperimental = $env:NOTATION_EXPERIMENTAL
        $env:NOTATION_EXPERIMENTAL = '1'
        try {
            $layout = Join-Path $TestDrive 'native-layout'
            $blobDirectory = Join-Path $layout 'blobs' 'sha256'
            $null = New-Item -ItemType Directory -Path $blobDirectory -Force
            function Add-OfflineLayoutBlob {
                param([byte[]] $Bytes)
                $hash = [Convert]::ToHexString([Security.Cryptography.SHA256]::HashData($Bytes)).ToLowerInvariant()
                [IO.File]::WriteAllBytes((Join-Path $blobDirectory $hash), $Bytes)
                @{ digest = "sha256:$hash"; size = $Bytes.Length }
            }
            function Add-OfflineLayoutJson {
                param([object] $Value)
                Add-OfflineLayoutBlob -Bytes ([Text.Encoding]::UTF8.GetBytes(($Value | ConvertTo-Json -Depth 30 -Compress)))
            }
            $config = Add-OfflineLayoutJson -Value @{}
            $config.mediaType = 'application/vnd.oci.empty.v1+json'
            $artifact = Add-OfflineLayoutJson -Value @{
                schemaVersion = 2
                mediaType = 'application/vnd.oci.image.manifest.v1+json'
                config = $config
                layers = @()
            }
            $artifact.mediaType = 'application/vnd.oci.image.manifest.v1+json'
            @{ imageLayoutVersion = '1.0.0' } | ConvertTo-Json | Set-Content (Join-Path $layout 'oci-layout')
            @{ schemaVersion = 2; manifests = @($artifact) } | ConvertTo-Json -Depth 5 |
                Set-Content (Join-Path $layout 'index.json')
            $nativeReference = "$layout@$($artifact.digest)"
            $script:nativeControlImage = "registry.example.invalid/aca-lza/sample@$($artifact.digest)"
            Mock Invoke-NotationCommand {
                if ($Arguments[0] -ceq 'verify') {
                    $Arguments = @($Arguments | Select-Object -SkipLast 1) +
                        @('--oci-layout', '--scope', 'registry.example.invalid/aca-lza/sample', $nativeReference)
                }
                if ($Arguments[0] -cin @('sign', 'verify')) {
                    return . $nativeNotationCommand -Executable $Executable -Arguments $Arguments -RegistryCredential $RegistryCredential
                }
                . $nativeNotationCommand -Executable $Executable -Arguments $Arguments
            }
            $generated = Invoke-NotationCommand -Executable $notation -Arguments @('cert', 'generate-test', '--default', 'offline-control')
            $generated.ExitCode | Should -Be 0 -Because $generated.Error
            $certificatePath = Get-ChildItem -LiteralPath $env:APPDATA -Recurse -Filter 'offline-control.crt' | Select-Object -First 1
            $certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new($certificatePath.FullName)
            try {
                Set-NotationTrust -Executable $notation -Directory $env:XDG_CONFIG_HOME -LoginServer 'registry.example.invalid' `
                    -Repository 'aca-lza/sample' -Certificate $certificate.RawData -Subject $certificate.Subject
            } finally {
                $certificate.Dispose()
            }
            $signed = Invoke-NotationCommand -Executable $notation -Arguments @('sign', '--oci-layout', '--signature-format', 'cose', $nativeReference) `
                -RegistryCredential 'offline-refresh'
            $signed.ExitCode | Should -Be 0 -Because $signed.Error
            Confirm-NotationImage -Executable $notation -Image $script:nativeControlImage -RegistryCredential 'offline-refresh' |
                Should -BeExactly $script:nativeControlImage

            $index = Get-Content (Join-Path $layout 'index.json') -Raw | ConvertFrom-Json -AsHashtable
            if ($Case -ceq 'Tampered') {
                $signatureDescriptors = @($index.manifests | Where-Object { $_.digest -cne $artifact.digest })
                $signatureDescriptors.Count | Should -Be 1
                $descriptor = $signatureDescriptors[0]
                $manifest = Get-Content (Join-Path $blobDirectory $descriptor.digest.Split(':')[1]) -Raw | ConvertFrom-Json -AsHashtable
                $envelope = [IO.File]::ReadAllBytes((Join-Path $blobDirectory $manifest.layers[0].digest.Split(':')[1]))
                $envelope[-1] = $envelope[-1] -bxor 1
                $modified = Add-OfflineLayoutBlob -Bytes $envelope
                $manifest.layers[0].digest = $modified.digest
                $manifest.layers[0].size = $modified.size
                $changed = Add-OfflineLayoutJson -Value $manifest
                $descriptor.digest = $changed.digest
                $descriptor.size = $changed.size
                $index | ConvertTo-Json -Depth 30 | Set-Content (Join-Path $layout 'index.json')
            } else {
                $index.manifests = @($artifact)
                $index | ConvertTo-Json -Depth 30 | Set-Content (Join-Path $layout 'index.json')
                $generated = Invoke-NotationCommand -Executable $notation -Arguments @('cert', 'generate-test', 'offline-untrusted')
                $generated.ExitCode | Should -Be 0 -Because $generated.Error
                $signed = Invoke-NotationCommand -Executable $notation `
                    -Arguments @('sign', '--oci-layout', '--signature-format', 'cose', '--key', 'offline-untrusted', $nativeReference) `
                    -RegistryCredential 'offline-refresh'
                $signed.ExitCode | Should -Be 0 -Because $signed.Error
            }

            $rejected = Confirm-TestSignatureRejection -Executable $notation -Image $script:nativeControlImage `
                -Case $Case -RegistryCredential 'offline-refresh'
            $rejected.case | Should -BeExactly $Case
            $rejected.rejected | Should -BeTrue
        } finally {
            $env:NOTATION_EXPERIMENTAL = $savedExperimental
        }
    }

    It 'Rejects a different exact publisher identity before installing policy: <Subject>' -ForEach @(
        @{ Subject = 'CN=other-signer, O=Azure Verified Modules, ST=Washington, C=US' }
        @{ Subject = 'CN=aca-lza-sample, O=Other Publisher, ST=Washington, C=US' }
        @{ Subject = 'CN=aca-lza-sample, O=Azure Verified Modules, ST=Oregon, C=US' }
        @{ Subject = 'CN=aca-lza-sample, O=Azure Verified Modules, ST=Washington, C=CA' }
    ) {
        $script:certificates['aca-lza-image-signing'] = New-OfflineSigningCertificate -Name 'aca-lza-image-signing' -Subject $Subject
        {
            Get-NotationCertificate -VaultName 'offline-vault' -Name 'aca-lza-image-signing' -Subject $expectedSubject
        } | Should -Throw '*does not match the expected publisher identity*'
        $script:nativeImports.Count | Should -Be 0
        Should -Invoke Add-AzKeyVaultCertificate -Times 0 -Exactly
    }
}
