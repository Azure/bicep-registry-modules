. (Join-Path $PSScriptRoot 'Connect-AzAccountWithGitHubOidc.ps1')

function Invoke-AzStorageOperationWithOidcRetry {
    <#
    .SYNOPSIS
    Runs a storage-related scriptblock and, if it fails with what looks like an
    OIDC / federated-credential / auth error, refreshes the GitHub OIDC login
    via Connect-AzAccountWithGitHubOidc and retries up to -MaxAttempts times
    with exponential backoff.

    .PARAMETER ScriptBlock
    The storage operation(s) to execute. Should use -ErrorAction Stop on Az
    cmdlets so non-terminating errors are caught here.

    .PARAMETER MaxAttempts
    Maximum number of attempts. Default 3.

    .PARAMETER InitialDelaySeconds
    Initial backoff in seconds; doubles on each retry. Default 2.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [scriptblock] $ScriptBlock,
        [int] $MaxAttempts         = 3,
        [int] $InitialDelaySeconds = 2,

        # OIDC re-login params - default to env vars set by azure/login.
        [string] $TenantId       = $env:AZURE_TENANT_ID,
        [string] $ClientId       = $env:AZURE_CLIENT_ID,
        [string] $SubscriptionId = $env:AZURE_SUBSCRIPTION_ID,
        [string] $Audience       = 'api://AzureADTokenExchange'
    )

    # Substrings indicating the failure was an authentication / OIDC issue
    # (i.e., re-logging in might fix it) rather than a real storage problem.
    $authErrorPatterns = @(
        'ClientAssertionCredential',
        'AADSTS70021',          # No matching federated identity record found
        'AADSTS700024',         # Client assertion is not within its valid time range
        'AADSTS700016',         # Application not found in the directory
        'AADSTS50013',          # Assertion is invalid
        'invalid_client',
        'expired',
        'authentication failed',
        'Could not get the storage context',
        'Run Connect-AzAccount'
    )

    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            return & $ScriptBlock
        } catch {
            $msg = "$($_.Exception.Message) $($_.Exception.InnerException.Message)"
            $isAuthError = $false
            foreach ($pattern in $authErrorPatterns) {
                if ($msg -like "*$pattern*") { $isAuthError = $true; break }
            }

            if (-not $isAuthError -or $attempt -eq $MaxAttempts) {
                throw
            }

            $delay = [int]($InitialDelaySeconds * [math]::Pow(2, $attempt - 1))
            Write-Warning ('Storage operation failed with auth-shaped error (attempt {0}/{1}): {2}' -f `
                           $attempt, $MaxAttempts, $_.Exception.Message)
            Write-Warning ('Refreshing GitHub OIDC login and retrying in {0}s...' -f $delay)
            Start-Sleep -Seconds $delay

            try {
                Connect-AzAccountWithGitHubOidc -TenantId       $TenantId `
                                                -ClientId       $ClientId `
                                                -SubscriptionId $SubscriptionId `
                                                -Audience       $Audience
            } catch {
                Write-Warning "OIDC re-login itself failed on attempt $attempt`: $($_.Exception.Message)"
                # Loop will retry both the login and the operation on the next iteration.
            }
        }
    }
}
