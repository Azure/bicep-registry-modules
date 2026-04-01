$ErrorActionPreference = 'Stop'
$clusterUri = $env:CLUSTER_URI
$subId = $env:SUBSCRIPTION_ID

# Retry configuration - ADX principal assignments can take 5-10 minutes to propagate
# Increased from 20×15s to 30×20s for better handling of slow AAD propagation in CI
$maxRetries = 30
$retryDelaySeconds = 20
$initialWaitSeconds = 180  # Wait 3 minutes before first attempt for permission propagation

Write-Output '=== Configure ADX Managed Identity Policy ==='
Write-Output "Cluster URI: $clusterUri"
Write-Output "Subscription: $subId"
Write-Output "Max retries: $maxRetries (waiting ${retryDelaySeconds}s between attempts)"

# Initial wait for permission propagation - ADX role assignments can take 2-5 minutes
Write-Output "Waiting ${initialWaitSeconds} seconds for ADX role assignment propagation..."
Start-Sleep -Seconds $initialWaitSeconds
Write-Output 'Initial wait complete. Starting policy configuration attempts...'

function Invoke-KqlCommandWithRetry {
    param(
        [string]$Uri,
        [hashtable]$Headers,
        [string]$Body,
        [string]$CommandDescription
    )

    $attempt = 0
    $lastError = $null

    while ($attempt -lt $maxRetries) {
        $attempt++
        try {
            Write-Output "[$CommandDescription] Attempt $attempt of $maxRetries..."
            $response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Headers -Body $Body
            Write-Output "[$CommandDescription] Success on attempt $attempt"
            return $response
        } catch {
            $lastError = $_
            $statusCode = $_.Exception.Response.StatusCode.value__

            # Only retry on 401 (Unauthorized) or 403 (Forbidden) - permission propagation issues
            if ($statusCode -eq 401 -or $statusCode -eq 403) {
                if ($attempt -lt $maxRetries) {
                    Write-Output "[$CommandDescription] Got HTTP $statusCode - permission not yet propagated. Waiting ${retryDelaySeconds}s before retry..."
                    Start-Sleep -Seconds $retryDelaySeconds
                } else {
                    Write-Output "[$CommandDescription] Max retries reached. Permission propagation timeout."
                }
            } else {
                # Non-permission error, don't retry
                Write-Output "[$CommandDescription] Got HTTP $statusCode - not a permission error, failing immediately."
                throw
            }
        }
    }

    # If we exhausted retries, throw the last error
    throw $lastError
}

try {
    # Get access token for Kusto - use the global Kusto resource for proper audience
    # The audience must be https://kusto.kusto.windows.net (NOT the cluster-specific URI)
    # See: https://learn.microsoft.com/en-us/azure/data-explorer/kusto/api/rest/authentication
    $kustoResource = 'https://kusto.kusto.windows.net'
    Write-Output 'Acquiring access token for Kusto...'
    Write-Output "Target resource: $kustoResource"
    Write-Output "Cluster URI: $clusterUri"
    $kustoToken = (Get-AzAccessToken -ResourceUrl $kustoResource).Token
    Write-Output 'Token acquired successfully'

    $headers = @{
        'Authorization' = "Bearer $kustoToken"
        'Content-Type'  = 'application/json; charset=utf-8'
    }

    # The policy command allows the cluster's system-assigned managed identity for NativeIngestion
    # Using "system" as ObjectId refers to the cluster's own managed identity
    # This is required for ADF to use managed_identity=system in ingestion commands
    $kqlCommand = '.alter-merge cluster policy managed_identity ```[{"ObjectId":"system","AllowedUsages":"NativeIngestion"}]```'

    $body = @{
        db  = 'Ingestion'  # Any database works for cluster-level commands
        csl = $kqlCommand
    } | ConvertTo-Json -Compress

    Write-Output "Executing KQL command: $kqlCommand"

    $mgmtUri = "$clusterUri/v1/rest/mgmt"
    $response = Invoke-KqlCommandWithRetry -Uri $mgmtUri -Headers $headers -Body $body -CommandDescription 'Set MI Policy'

    Write-Output 'Policy configured successfully'
    Write-Output "Response: $($response | ConvertTo-Json -Depth 5)"

    # Verify the policy was applied
    $verifyCommand = '.show cluster policy managed_identity'
    $verifyBody = @{
        db  = 'Ingestion'
        csl = $verifyCommand
    } | ConvertTo-Json -Compress

    $verifyResponse = Invoke-KqlCommandWithRetry -Uri $mgmtUri -Headers $headers -Body $verifyBody -CommandDescription 'Verify Policy'
    Write-Output "Current policy: $($verifyResponse | ConvertTo-Json -Depth 5)"

    $DeploymentScriptOutputs = @{
        status  = 'success'
        message = 'Managed identity policy configured for NativeIngestion'
    }

} catch {
    Write-Error "Failed to configure managed identity policy: $_"
    Write-Error $_.Exception.Message
    if ($_.Exception.Response) {
        try {
            $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            Write-Error $reader.ReadToEnd()
        } catch {
            Write-Error 'Could not read response body'
        }
    }
    $DeploymentScriptOutputs = @{
        status = 'error'
        error  = $_.ToString()
    }
    throw
}
