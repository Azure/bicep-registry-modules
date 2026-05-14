function Connect-AzAccountWithGitHubOidc {
    <#
    .SYNOPSIS
    Mints a fresh GitHub Actions OIDC JWT and (re-)authenticates the current Az
    PowerShell context using the federated-credential flow.

    .DESCRIPTION
    Equivalent to what azure/login@v3 does internally (see
    Azure/login src/PowerShell/AzPSScriptBuilder.ts loginWithOIDC). Safe to call
    multiple times within the same job - each call mints a new short-lived JWT
    from the runner's OIDC endpoint and re-issues Connect-AzAccount with it.

    Requires:
      - The workflow grants 'permissions: id-token: write'.
      - azure/login@v3 has already run once (so AZURE_TENANT_ID / AZURE_CLIENT_ID
        / AZURE_SUBSCRIPTION_ID are available, unless explicitly passed in).

    .PARAMETER TenantId
    AAD tenant ID. Defaults to $env:AZURE_TENANT_ID (set by azure/login).

    .PARAMETER ClientId
    AAD application (client) ID with the configured federated credential.
    Defaults to $env:AZURE_CLIENT_ID (set by azure/login).

    .PARAMETER SubscriptionId
    Azure subscription ID to set as default. Defaults to $env:AZURE_SUBSCRIPTION_ID.

    .PARAMETER Audience
    Audience claim requested in the GitHub OIDC JWT.
    Defaults to 'api://AzureADTokenExchange', which is what AAD federated
    credentials expect by default and what azure/login uses.
    #>
    [CmdletBinding()]
    param(
        [string] $TenantId       = $env:AZURE_TENANT_ID,
        [string] $ClientId       = $env:AZURE_CLIENT_ID,
        [string] $SubscriptionId = $env:AZURE_SUBSCRIPTION_ID,
        [string] $Audience       = 'api://AzureADTokenExchange'
    )

    if (-not $env:ACTIONS_ID_TOKEN_REQUEST_URL -or -not $env:ACTIONS_ID_TOKEN_REQUEST_TOKEN) {
        throw "GitHub OIDC env vars not present. The workflow must grant 'permissions: id-token: write' and this function must run inside a GitHub Actions job."
    }
    if (-not $TenantId -or -not $ClientId) {
        throw 'TenantId and ClientId are required (either via parameters or AZURE_TENANT_ID / AZURE_CLIENT_ID env vars set by azure/login).'
    }

    $uri = '{0}&audience={1}' -f $env:ACTIONS_ID_TOKEN_REQUEST_URL, [uri]::EscapeDataString($Audience)

    $jwt      = $null
    $response = $null
    try {
        try {
            $response = Invoke-RestMethod -Uri $uri `
                                          -Headers @{ Authorization = "bearer $env:ACTIONS_ID_TOKEN_REQUEST_TOKEN" } `
                                          -ErrorAction Stop
        } catch {
            # Sanitize: never re-throw the original exception (it can include the request URL/headers).
            $statusCode = $null
            try { $statusCode = $_.Exception.Response.StatusCode } catch { $null = $_ }
            throw "Failed to obtain GitHub OIDC token (HTTP $statusCode)."
        }

        $jwt = $response.value
        if ([string]::IsNullOrWhiteSpace($jwt)) {
            throw 'GitHub OIDC endpoint returned an empty token.'
        }

        # Defense-in-depth: register a runner mask via the workflow command file
        # (NOT via stdout) so that if any future code path ever logs $jwt, the
        # runner redacts it. Mirrors what azure/login does via core.setSecret().
        if ($env:GITHUB_ENV) {
            try {
                Add-Content -Path $env:GITHUB_ENV -Value "::add-mask::$jwt" -Encoding utf8 -ErrorAction Stop
            } catch {
                Write-Verbose "Could not register runner mask for OIDC JWT: $($_.Exception.Message)" -Verbose
            }
        }

        # Belt-and-braces: if azure/login wrote the JWT to a file and Az.Storage's
        # ClientAssertionCredential is still configured to re-read that file on each
        # token exchange, overwrite it with the fresh JWT so the file-backed
        # credential keeps working too. No-op if the env var is not set.
        if ($env:AZURE_FEDERATED_TOKEN_FILE) {
            try {
                Set-Content -Path $env:AZURE_FEDERATED_TOKEN_FILE -Value $jwt -NoNewline -Encoding utf8 -ErrorAction Stop
            } catch {
                Write-Verbose "Could not refresh AZURE_FEDERATED_TOKEN_FILE: $($_.Exception.Message)" -Verbose
            }
        }

        $connectParams = @{
            ServicePrincipal   = $true
            ApplicationId      = $ClientId
            Tenant             = $TenantId
            FederatedToken     = $jwt
            InformationAction  = 'Ignore'
            WarningAction      = 'SilentlyContinue'
            ErrorAction        = 'Stop'
        }
        if ($SubscriptionId) { $connectParams['Subscription'] = $SubscriptionId }

        Connect-AzAccount @connectParams | Out-Null

        Write-Verbose "Re-authenticated to Azure via GitHub OIDC (audience=$Audience, client=$ClientId, tenant=$TenantId)." -Verbose
    } finally {
        # Best-effort scrub of plaintext token from memory. PowerShell strings
        # are immutable so we can't zero bytes, but releasing the reference
        # and forcing GC minimizes the exposure window.
        $jwt      = $null
        $response = $null
        [GC]::Collect()
        [GC]::WaitForPendingFinalizers()
    }
}
