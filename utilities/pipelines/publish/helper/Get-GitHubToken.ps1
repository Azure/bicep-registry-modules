<#
.SYNOPSIS
Get a GitHub token for authenticating to the GitHub API

.DESCRIPTION
Get a GitHub token for authenticating to the GitHub API, either by using a provided Personal Access Token (PAT) or by generating a token using GitHub App authentication.

.PARAMETER GitHubPAT
A GitHub Personal Access Token, used for testing. In production, a GitHub App token should be used instead, which can be generated with the provided App ID and private key.

.PARAMETER AppPrivateKey
A private key for the GitHub App in PEM format. It starts with '-----BEGIN RSA PRIVATE KEY-----' and ends with '-----END RSA PRIVATE KEY-----'.

.PARAMETER AppID
The ID of the GitHub App to use for authentication.

.PARAMETER Organisation
The GitHub organisation where the repository is located. For example: 'Microsoft'.

.PARAMETER Repository
The GitHub repository to authenticate against. For example: 'MCR'.

.EXAMPLE
Get-GitHubToken -GitHubPAT 'your-personal-access-token'
Get-GitHubToken -AppPrivateKey (Get-Content -Path 'path/to/privatekey.pem' -Raw) -AppID 'your-app-id' -Organisation 'Microsoft' -Repository 'MCR'
Get-GitHubToken -AppPrivateKey 'your-private-key' -AppID 'your-app-id' -Organisation 'Microsoft' -Repository 'MCR'

Returns the provided GitHub Personal Access Token (PAT) for authentication.
#>
function Get-GitHubToken {

    [CmdletBinding()]
    param(
        # A GitHub Personal Access Token, used for testing. In production, a GitHub App token should be used instead, which can be generated with the provided App ID and private key.
        [Parameter(Mandatory = $false)]
        [string]
        $GitHubPAT,

        # A private key for the GitHub App in PEM format. It starts with '-----BEGIN RSA PRIVATE KEY-----' and ends with '-----END RSA PRIVATE KEY-----'.
        [Parameter(Mandatory = $false)]
        [string]
        $AppPrivateKey,

        [Parameter(Mandatory = $true)]
        [string]
        $AppID,

        [Parameter(Mandatory = $true)]
        [string]
        $Organisation,

        [Parameter(Mandatory = $true)]
        [string]
        $Repository
    )

    if ($GitHubPAT) {
        Write-Host 'Using provided GitHub Personal Access Token (PAT) for authentication.' -Verbose
        return $GitHubPAT
    }

    # If no PAT provided, use the GitHub App authentication flow to get a token
    if (-not $AppPrivateKey) {
        throw 'Either a GitHub Personal Access Token (PAT) or a GitHub App private key must be provided for authentication.'
    }

    Write-Host 'Generating JWT for GitHub App authentication...' -Verbose
    $jwt = New-GitHubJWT -AppID $AppID -AppPrivateKey $AppPrivateKey

    $headers = @{
        'Accept'        = 'application/vnd.github+json'
        'Authorization' = "Bearer $jwt"
    }

    # get the installation id for the app
    Write-Host 'Retrieving GitHub App installation ID... ' -NoNewline -Verbose
    $res = Invoke-WebRequest -Uri "https://api.github.com/repos/$($Organisation)/$($Repository)/installation" -Headers $headers -Method Get
    $json_res = ConvertFrom-Json($res.Content)
    $instanceID = $json_res.id
    Write-Host "Got instance ID '$instanceID'." -Verbose

    # request a new token
    Write-Host 'Requesting access token for GitHub App installation...' -Verbose
    $res = Invoke-WebRequest -Uri "https://api.github.com/app/installations/$($instanceID)/access_tokens" -Headers $headers -Method Post
    $json_res = ConvertFrom-Json($res.Content)
    $token = $json_res.token

    return $token
}

<#
.SYNOPSIS
Generate a JSON Web Token (JWT) for GitHub App authentication.

.DESCRIPTION
Generates a JWT for a GitHub App using the provided private key and App ID. This JWT can be used to authenticate API requests on behalf of the GitHub App.

.PARAMETER AppPrivateKey
A private key for the GitHub App in PEM format. It starts with '-----BEGIN RSA PRIVATE KEY-----' and ends with '-----END RSA PRIVATE KEY-----'.

.PARAMETER AppID
The ID of the GitHub App to use for authentication.

.EXAMPLE
New-GitHubJWT -AppPrivateKey (Get-Content -Path 'path/to/privatekey.pem' -Raw) -AppID 'your-app-id'

Returns a JWT for the specified GitHub App.
#>
function New-GitHubJWT {
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $AppPrivateKey,

        [Parameter(Mandatory = $true)]
        [string]
        $AppID
    )
    $header = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @{
                    alg = 'RS256'
                    typ = 'JWT'
                }))).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    $payload = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((ConvertTo-Json -InputObject @{
                    iat = [System.DateTimeOffset]::UtcNow.AddSeconds(5).ToUnixTimeSeconds()
                    exp = [System.DateTimeOffset]::UtcNow.AddMinutes(5).ToUnixTimeSeconds()
                    iss = $AppID
                }))).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    $rsa = [System.Security.Cryptography.RSA]::Create()
    $rsa.ImportFromPem($AppPrivateKey)
    $signature = [Convert]::ToBase64String($rsa.SignData(
            [System.Text.Encoding]::UTF8.GetBytes("$header.$payload"),
            [System.Security.Cryptography.HashAlgorithmName]::SHA256,
            [System.Security.Cryptography.RSASignaturePadding]::Pkcs1
        )).TrimEnd('=').Replace('+', '-').Replace('/', '_')
    return "$header.$payload.$signature"
}
