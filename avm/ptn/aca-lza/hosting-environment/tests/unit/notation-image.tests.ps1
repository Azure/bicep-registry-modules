BeforeAll {
    $moduleRoot = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path
    . (Join-Path $moduleRoot 'scripts' 'Invoke-VerifiedContainerImage.ps1')
    . (Join-Path $moduleRoot 'tests' 'e2e' 'waf-aligned' 'Test-NotationImageVerification.ps1')

    function Get-AzAccessToken { throw 'Unmocked Azure transport.' }
    function Get-AzContext { throw 'Unmocked Azure transport.' }
    function Get-AzKeyVaultCertificate { param($VaultName, $Name) throw 'Unmocked Azure transport.' }
    function New-AzKeyVaultCertificatePolicy {
        param($SubjectName, $IssuerName, $ValidityInMonths, $KeyType, $KeySize, [switch] $KeyNotExportable,
            $KeyUsage, $Ekus, $SecretContentType, [switch] $ReuseKeyOnRenewal)
        throw 'Unmocked Azure transport.'
    }
    function Add-AzKeyVaultCertificate { param($VaultName, $Name, $CertificatePolicy) throw 'Unmocked Azure transport.' }
    function Get-AzKeyVaultCertificateOperation { param($VaultName, $Name) throw 'Unmocked Azure transport.' }
    function Import-AzContainerRegistryImage {
        param($RegistryName, $ResourceGroupName, $SourceRegistryUri, $SourceImage, $SourceResourceId, $TargetTag, $Mode)
        throw 'Unmocked Azure transport.'
    }

    $rsa = [System.Security.Cryptography.RSA]::Create(2048)
    $request = [System.Security.Cryptography.X509Certificates.CertificateRequest]::new(
        'CN=aca-lza-sample, O=Azure Verified Modules, ST=Washington, C=US', $rsa, [System.Security.Cryptography.HashAlgorithmName]::SHA256,
        [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
    )
    $publicCertificate = $request.CreateSelfSigned([DateTimeOffset]::UtcNow.AddDays(-1), [DateTimeOffset]::UtcNow.AddMonths(12))
    $digest = 'sha256:' + ('a' * 64)
    $signatureDigest = 'sha256:' + ('b' * 64)
    $image = "registry.example.invalid/aca-lza/sample@$digest"
    $testCertificate = [pscustomobject]@{
        Name        = 'aca-lza-image-signing'
        KeyId       = 'https://synthetic.invalid/keys/sample/00000000000000000000000000000000'
        Certificate = $publicCertificate
    }
}

AfterAll {
    $publicCertificate.Dispose()
    $rsa.Dispose()
}

Describe 'ACA-LZA real image publication and fail-closed consumption' {
    BeforeEach {
        $script:commands = [System.Collections.Generic.List[object]]::new()
        $script:verifyExitCode = 0
        $script:verifyError = ''
        $script:signExitCode = 0
        $script:loginExitCode = 0
        $script:loginError = ''
        $script:referrerReads = 0
        $script:createdSignatureCount = 1
        $script:certificateExists = $true
        $script:releases = [System.Collections.Generic.List[string]]::new()
        Mock Invoke-NotationCommand {
            $script:commands.Add(@{ arguments = @($Arguments); standardInput = $StandardInput })
            if ($Arguments[0] -ceq 'login') {
                return @{ ExitCode = $script:loginExitCode; Output = ''; Error = $script:loginError }
            }
            if ($Arguments[0] -ceq 'sign') {
                return @{ ExitCode = $script:signExitCode; Output = ''; Error = 'synthetic signing failure' }
            }
            if ($Arguments[0] -ceq 'verify') {
                return @{ ExitCode = $script:verifyExitCode; Output = 'synthetic output cannot override the exit code'; Error = $script:verifyError }
            }
            @{ ExitCode = 0; Output = ''; Error = '' }
        }
        Mock Get-AzAccessToken { @{ Token = ConvertTo-SecureString 'synthetic-access' -AsPlainText -Force } }
        Mock Get-AzContext { @{ Tenant = @{ Id = '00000000-0000-0000-0000-000000000001' } } }
        Mock Get-AzKeyVaultCertificate {
            if ($Name -or $script:certificateExists) { return $testCertificate }
        }
        Mock New-AzKeyVaultCertificatePolicy { @{ generated = $true } }
        Mock Add-AzKeyVaultCertificate {}
        Mock Get-AzKeyVaultCertificateOperation { @{ Status = 'completed' } }
        Mock Import-AzContainerRegistryImage {}
        Mock Invoke-WebRequest { @{ Headers = @{ 'Docker-Content-Digest' = @($digest) } } }
        Mock Invoke-RestMethod {
            if ($Uri -like '*/oauth2/exchange') { return @{ refresh_token = 'synthetic-refresh' } }
            if ($Uri -like '*/oauth2/token') { return @{ access_token = 'synthetic-repository' } }
            if ($Method -ceq 'Patch') {
                $script:releases.Add($Uri)
                return @{}
            }
            if ($Uri -like '*/referrers/*') {
                $script:referrerReads++
                $descriptors = @()
                if ($script:referrerReads -gt 1) {
                    for ($i = 0; $i -lt $script:createdSignatureCount; $i++) {
                        $descriptors += @{ digest = $signatureDigest.Substring(0, $signatureDigest.Length - 1) + "$i"; artifactType = 'application/vnd.cncf.notary.signature' }
                    }
                }
                return [pscustomobject]@{ schemaVersion = 2; mediaType = 'application/vnd.oci.image.index.v1+json'; manifests = $descriptors }
            }
            throw "Unexpected mocked transport URI [$Uri]."
        }
        $publish = @{
            Executable        = 'synthetic-notation'
            Directory         = $TestDrive
            RegistryName      = 'registry'
            ResourceGroupName = 'synthetic-rg'
            LoginServer       = 'registry.example.invalid'
            VaultName         = 'synthetic-vault'
        }
    }

    It 'Requires immutable digest input before any native verification call: <Reference>' -ForEach @(
        @{ Reference = 'registry.example.invalid/aca-lza/sample:latest' }
        @{ Reference = 'registry.example.invalid/aca-lza/sample@sha256:short' }
    ) {
        { Confirm-NotationImage -Executable 'synthetic-notation' -Image $Reference } | Should -Throw '*immutable SHA256*'
        Should -Invoke Invoke-NotationCommand -Times 0 -Exactly
    }

    It 'Returns the exact immutable reference only after successful native verification' {
        Confirm-NotationImage -Executable 'synthetic-notation' -Image $image | Should -BeExactly $image
        Should -Invoke Invoke-NotationCommand -Times 1 -Exactly -ParameterFilter {
            ($Arguments -join '|') -ceq "verify|$image"
        }
    }

    It 'Does not accept success-shaped output from a failed verifier' {
        $script:verifyExitCode = 1
        $script:verifyError = 'invalid signature'
        { Confirm-NotationImage -Executable 'synthetic-notation' -Image $image } | Should -Throw '*signature verification rejected*'
    }

    It 'Imports and signs the exact digest with non-exportable-key managed-identity authentication before releasing signature and image' {
        $result = Publish-VerifiedContainerImage @publish
        $result.image | Should -BeExactly $image
        $result.strictVerification | Should -BeTrue
        $result.certificateBase64 | Should -BeExactly ([Convert]::ToBase64String($publicCertificate.RawData))
        $result.certificateSubject | Should -BeExactly $publicCertificate.Subject
        @($script:releases).Count | Should -Be 2
        $script:releases[0] | Should -Match '/_manifests/sha256:b{63}0$'
        $script:releases[1] | Should -BeExactly "https://registry.example.invalid/acr/v1/aca-lza/sample/_manifests/$digest"
        Should -Invoke Import-AzContainerRegistryImage -Times 1 -Exactly -ParameterFilter {
            $RegistryName -ceq 'registry' -and $ResourceGroupName -ceq 'synthetic-rg' -and
            $SourceRegistryUri -ceq 'mcr.microsoft.com' -and $SourceImage -ceq 'azuredocs/containerapps-helloworld:latest'
        }
        $sign = @($script:commands | Where-Object { $_.arguments[0] -ceq 'sign' })[0].arguments
        $sign[-1] | Should -BeExactly $image
        $sign | Should -Contain 'credential_type=managedid'
        $sign | Should -Contain 'cose'
        $sign | Should -Contain $testCertificate.KeyId
        $sign | Should -Contain '--force-referrers-tag=false'
        $sign | Should -Not -Contain 'false'
        $login = @($script:commands | Where-Object { $_.arguments[0] -ceq 'login' })[0]
        $login.arguments | Should -Contain '--password-stdin'
        $login.arguments | Should -Not -Contain 'synthetic-refresh'
        $login.standardInput | Should -BeExactly 'synthetic-refresh'
    }

    It 'Never releases an image when signing fails' {
        $script:signExitCode = 1
        { Publish-VerifiedContainerImage @publish } | Should -Throw '*image signing failed*'
        $script:releases.Count | Should -Be 0
        @($script:commands | Where-Object { $_.arguments[0] -ceq 'verify' }).Count | Should -Be 0
    }

    It 'Retains the native <Boundary> login failure without continuing <Consumer>' -ForEach @(
        @{ Boundary = 'credential-store'; NativeError = 'a credentials store is required'; Consumer = 'publication' }
        @{ Boundary = 'authentication'; NativeError = 'failed to validate the credentials: 401 Unauthorized'; Consumer = 'publication' }
        @{ Boundary = 'credential-store'; NativeError = 'a credentials store is required'; Consumer = 'native controls' }
        @{ Boundary = 'authentication'; NativeError = 'failed to validate the credentials: 401 Unauthorized'; Consumer = 'native controls' }
    ) {
        $script:loginExitCode = 1
        $script:loginError = $NativeError
        $execute = if ($Consumer -ceq 'publication') {
            { Publish-VerifiedContainerImage @publish }
        } else {
            {
                Test-NotationImageVerification @publish -TrustedImage $image -TrustedSignatureDigest $signatureDigest `
                    -TrustedCertificate $publicCertificate.RawData -TrustedSubject $publicCertificate.Subject
            }
        }
        $execute | Should -Throw "*registry login failed (exit code 1): $NativeError*"
        Should -Invoke Import-AzContainerRegistryImage -Times 0 -Exactly
        $script:releases.Count | Should -Be 0
        @($script:commands | Where-Object { $_.arguments[0] -in @('sign', 'verify') }).Count | Should -Be 0
    }

    It 'Never releases signature or image after consuming verification rejects it' {
        $script:verifyExitCode = 1
        $script:verifyError = 'invalid signature'
        { Publish-VerifiedContainerImage @publish } | Should -Throw '*signature verification rejected*'
        $script:releases.Count | Should -Be 0
    }

    Describe 'ACA-LZA credential-safe native diagnostics' {
        It 'Redacts known credentials, encodings and unlabelled echoes before returning diagnostics' {
            $secret = 'synthetic-refresh+/= %value'
            $variants = @(
                $secret
                [uri]::EscapeDataString($secret)
                [Net.WebUtility]::UrlEncode($secret)
                [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($secret))
                [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("00000000-0000-0000-0000-000000000000:$secret"))
            )
            $result = Protect-NotationDiagnosticText -Text ($variants -join "`n") -SensitiveValues @($secret)
            foreach ($variant in $variants) { $result.Contains($variant) | Should -BeFalse }
            $result | Should -Match '\[redacted\]'
        }

        It 'Redacts <Kind> while retaining the actionable failure' -ForEach @(
            @{ Kind = 'authorization header'; Text = 'Authorization: Basic unknown-sensitive-value'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'bearer header'; Text = 'Authorization=Bearer unknown-sensitive-value'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'JSON refresh token'; Text = '{"refresh_token":"unknown-sensitive-value"}'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'JSON access token'; Text = '{"access_token":"unknown-sensitive-value"}'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'JSON password'; Text = '{"password":"unknown-sensitive-value"}'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'Docker auth'; Text = '{"auth":"unknown-sensitive-value"}'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'signed URL'; Text = 'https://offline.invalid/path?sig=unknown-sensitive-value'; Secret = 'unknown-sensitive-value' }
            @{ Kind = 'JWT'; Text = 'eyJhbGciOiJub25l.eyJzdWIiOiJvZmZsaW5lIn0.signature'; Secret = 'eyJhbGciOiJub25l.eyJzdWIiOiJvZmZsaW5lIn0.signature' }
        ) {
            $result = Protect-NotationDiagnosticText -Text "native failure: 401 Unauthorized`n$Text"
            $result.Contains($Secret) | Should -BeFalse
            $result | Should -Match 'native failure: 401 Unauthorized'
        }
    }

    It 'Refuses ambiguous newly produced signature ownership before release' {
        $script:createdSignatureCount = 2
        { Publish-VerifiedContainerImage @publish } | Should -Throw '*exactly one newly signed OCI artifact*'
        $script:releases.Count | Should -Be 0
    }

    It 'Creates only the missing named public certificate with a non-exportable digital-signature key' {
        $script:certificateExists = $false
        $null = Get-NotationCertificate -VaultName 'synthetic-vault' -Name 'aca-lza-image-signing' -Subject $publicCertificate.Subject
        Should -Invoke New-AzKeyVaultCertificatePolicy -Times 1 -Exactly -ParameterFilter {
            $KeyNotExportable -and $KeyType -ceq 'RSA' -and $KeyUsage -ceq 'DigitalSignature' -and
            $Ekus -ceq '1.3.6.1.5.5.7.3.3' -and $ReuseKeyOnRenewal
        }
        Should -Invoke Add-AzKeyVaultCertificate -Times 1 -Exactly -ParameterFilter {
            $VaultName -ceq 'synthetic-vault' -and $Name -ceq 'aca-lza-image-signing'
        }
    }

    It 'Pins the exact repository, publisher identity and public certificate without verification overrides' {
        Set-NotationTrust -Executable 'synthetic-notation' -Directory $TestDrive -LoginServer 'registry.example.invalid' `
            -Repository 'aca-lza/sample' -Certificate $publicCertificate.RawData -Subject $publicCertificate.Subject
        $policy = Get-Content -LiteralPath (Join-Path $TestDrive 'trustpolicy.json') -Raw | ConvertFrom-Json
        @($policy.trustPolicies).Count | Should -Be 1
        $policy.trustPolicies[0].registryScopes | Should -Be @('registry.example.invalid/aca-lza/sample')
        $policy.trustPolicies[0].trustedIdentities | Should -Be @("x509.subject: $($publicCertificate.Subject)")
        $policy.trustPolicies[0].signatureVerification.level | Should -BeExactly 'strict'
        @($policy.trustPolicies[0].signatureVerification.PSObject.Properties.Name) | Should -Be @('level')
        [Convert]::ToBase64String([IO.File]::ReadAllBytes((Join-Path $TestDrive 'trusted.cer'))) |
            Should -BeExactly ([Convert]::ToBase64String($publicCertificate.RawData))
    }

    It 'Uses the exact scoped repository token for signature discovery and verified quarantine release' {
        $null = Publish-VerifiedContainerImage @publish
        Should -Invoke Invoke-RestMethod -Times 4 -Exactly -ParameterFilter {
            ($Uri -like '*/referrers/*' -or $Method -ceq 'Patch') -and
            $Headers.Authorization -ceq 'Bearer synthetic-repository'
        }
        Should -Invoke Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
            $Uri -like '*/oauth2/token' -and $Body.scope -ceq 'repository:aca-lza/sample:pull,push'
        }
    }

    It 'Stops before registry import or release if strict trust-policy installation fails' {
        Mock Invoke-NotationCommand {
            @{ ExitCode = ($Arguments[0] -ceq 'policy' ? 1 : 0); Output = ''; Error = 'synthetic policy failure' }
        }
        { Publish-VerifiedContainerImage @publish } | Should -Throw '*trust policy import failed*'
        Should -Invoke Import-AzContainerRegistryImage -Times 0 -Exactly
        $script:releases.Count | Should -Be 0
    }

    It 'Recognizes only actual <Case> verification rejection' -ForEach @(
        @{ Case = 'Unsigned'; NativeError = 'no signature is associated with this artifact' }
        @{ Case = 'Tampered'; NativeError = 'integrity validation failed. Failure reason: signature is invalid. Error: crypto/rsa: verification error' }
        @{ Case = 'Untrusted'; NativeError = 'authenticity validation failed. Failure reason: the signature''s certificate chain does not contain any trusted certificate' }
    ) {
        $script:verifyExitCode = 1
        $script:verifyError = $NativeError
        $result = Confirm-TestSignatureRejection -Executable 'synthetic-notation' -Image $image -Case $Case
        $result.rejected | Should -BeTrue
        $result.case | Should -BeExactly $Case
        $result.errorSha256 | Should -Match '^[a-f0-9]{64}$'
    }

    It 'Does not treat inconclusive or wrong-cause <Case> failure as signature evidence: <NativeError>' -ForEach @(
        @{ Case = 'Tampered'; NativeError = 'signature verification failed: HEAD https://synthetic.invalid/v2/sample: 403 Forbidden' }
        @{ Case = 'Tampered'; NativeError = 'signature verification failed: unable to retrieve digital signature' }
        @{ Case = 'Tampered'; NativeError = 'signature verification failed for all the signatures associated with this artifact' }
        @{ Case = 'Tampered'; NativeError = 'signature verification failed: signing certificate has expired' }
        @{ Case = 'Untrusted'; NativeError = 'no trusted certificates are found to verify authenticity' }
        @{ Case = 'Unsigned'; NativeError = 'signature verification failed for all the signatures associated with this artifact' }
    ) {
        $script:verifyExitCode = 1
        $script:verifyError = $NativeError
        { Confirm-TestSignatureRejection -Executable 'synthetic-notation' -Image $image -Case $Case } | Should -Throw '*did not establish*'
    }

    It 'Does not turn transport failure into <Case> security evidence' -ForEach @(
        @{ Case = 'Unsigned' }
        @{ Case = 'Tampered' }
        @{ Case = 'Untrusted' }
    ) {
        $script:verifyExitCode = 1
        $script:verifyError = 'connection refused'
        { Confirm-TestSignatureRejection -Executable 'synthetic-notation' -Image $image -Case $Case } | Should -Throw '*did not establish*'
    }

    It 'Fails the negative control if the consuming gate actually accepts it' {
        { Confirm-TestSignatureRejection -Executable 'synthetic-notation' -Image $image -Case Unsigned } | Should -Throw '*was accepted*'
    }
}
