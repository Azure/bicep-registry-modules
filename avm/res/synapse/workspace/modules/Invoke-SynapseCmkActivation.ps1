function Get-SynapseCmkClock {
    [System.Diagnostics.Stopwatch]::GetTimestamp() / [double] [System.Diagnostics.Stopwatch]::Frequency
}

function Get-SynapseCmkTimeRemaining {
    param([double] $Deadline)

    $remaining = $Deadline - (Get-SynapseCmkClock)
    if ($remaining -le 0) {
        throw [System.TimeoutException]::new('The Synapse workspace key activation deadline expired.')
    }
    return $remaining
}

function Invoke-SynapseCmkRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'PUT')]
        [string] $Method,

        [Parameter(Mandatory)]
        [string] $Path,

        [string] $Payload,

        [Parameter(Mandatory)]
        [double] $Deadline
    )

    $null = Get-SynapseCmkTimeRemaining -Deadline $Deadline
    $request = @{
        Method      = $Method
        Path        = $Path
        AsJob       = $true
        ErrorAction = 'Stop'
        Confirm     = $false
    }
    if ($Method -eq 'PUT') { $request.Payload = $Payload }

    $job = $null
    try {
        $job = Invoke-AzRestMethod @request
        $remaining = Get-SynapseCmkTimeRemaining -Deadline $Deadline
        $completed = Wait-Job -Id $job.Id -Timeout ([int] [Math]::Ceiling($remaining)) -ErrorAction Stop
        $null = Get-SynapseCmkTimeRemaining -Deadline $Deadline
        if (-not $completed) {
            throw [System.TimeoutException]::new('The Synapse workspace key request did not complete before the activation deadline.')
        }
        $responses = @(Receive-Job -Id $job.Id -ErrorAction Stop)
        $null = Get-SynapseCmkTimeRemaining -Deadline $Deadline
        if ($responses.Count -ne 1 -or $null -eq $responses[0]) {
            throw 'Expected exactly one response from the Synapse workspace key request.'
        }
        return $responses[0]
    } finally {
        if ($null -ne $job) {
            if ($job.State -notin @('Completed', 'Failed', 'Stopped')) {
                Stop-Job -Id $job.Id -ErrorAction Stop
            }
            Remove-Job -Id $job.Id -ErrorAction Stop
        }
    }
}

function Test-SynapseCmkPermissionError {
    param (
        [object] $ErrorDetail,
        [int] $Depth = 0
    )

    if ($Depth -gt 16 -or $ErrorDetail -isnot [System.Collections.IDictionary] -or
        $ErrorDetail.code -isnot [string]) { return $false }
    foreach ($key in $ErrorDetail.psbase.Keys) {
        if (@('code', 'message', 'target', 'details', 'additionalInfo') -cnotcontains $key) { return $false }
    }
    if ($ErrorDetail.additionalInfo) { return $false }
    $details = @()
    if ($null -ne $ErrorDetail.details) {
        if ($ErrorDetail.details -isnot [System.Collections.IList]) { return $false }
        $details = @($ErrorDetail.details)
    }
    if ($ErrorDetail.code -ceq 'CustomerManagedKeyPermissionMissing') {
        return $details.Count -eq 0
    }
    if ($ErrorDetail.code -cne 'ValidationFailed' -or $details.Count -eq 0) { return $false }
    foreach ($detail in $details) {
        if (-not (Test-SynapseCmkPermissionError -ErrorDetail $detail -Depth ($Depth + 1))) { return $false }
    }
    return $true
}

function Write-SynapseCmkHttpFailure {
    [CmdletBinding()]
    param (
        [string] $Method,
        [object] $Response
    )

    $exception = [System.InvalidOperationException]::new(
        "Synapse workspace key $Method returned HTTP $($Response.StatusCode): $($Response.Content)"
    )
    $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
            $exception,
            'SynapseCmkRequestFailed',
            [System.Management.Automation.ErrorCategory]::InvalidResult,
            $Response
        ))
}

function Test-SynapseCmkKeyActive {
    param (
        [object] $Response,
        [string] $KeyResourceId,
        [string] $KeyVaultUrl
    )

    if ($Response.StatusCode -ne 200) { Write-SynapseCmkHttpFailure -Method GET -Response $Response }
    $key = $Response.Content | ConvertFrom-Json -AsHashtable -Depth 32 -ErrorAction Stop
    if ($key -isnot [System.Collections.IDictionary] -or
        -not [string]::Equals($key.id, $KeyResourceId, [System.StringComparison]::OrdinalIgnoreCase) -or
        $key.properties -isnot [System.Collections.IDictionary] -or
        -not [string]::Equals($key.properties.keyVaultUrl, $KeyVaultUrl, [System.StringComparison]::Ordinal) -or
        $key.properties.isActiveCMK -isnot [bool]) {
        $properties = $null
        if ($key -is [System.Collections.IDictionary]) { $properties = $key.properties }
        $diagnostics = [ordered]@{
            responseIsObject = $key -is [System.Collections.IDictionary]
            responseType = if ($null -eq $key) { 'null' } else { $key.GetType().FullName }
        }
        foreach ($field in @(
                @{ name = 'id'; container = $key }
                @{ name = 'properties'; container = $key }
                @{ name = 'keyVaultUrl'; container = $properties }
                @{ name = 'isActiveCMK'; container = $properties }
            )) {
            $container = $field.container
            $present = $container -is [System.Collections.IDictionary] -and
                $container.psbase.Keys -icontains $field.name
            $value = $null
            if ($present) { $value = $container.($field.name) }
            $valid = switch ($field.name) {
                'id' {
                    $value -is [string] -and
                    [string]::Equals($value, $KeyResourceId, [System.StringComparison]::OrdinalIgnoreCase)
                }
                'properties' { $value -is [System.Collections.IDictionary] }
                'keyVaultUrl' {
                    $value -is [string] -and
                    [string]::Equals($value, $KeyVaultUrl, [System.StringComparison]::Ordinal)
                }
                'isActiveCMK' { $value -is [bool] }
            }
            $diagnostics[$field.name] = @{
                present = $present
                type = if (-not $present) { 'missing' } elseif ($null -eq $value) { 'null' } else { $value.GetType().FullName }
                length = if ($value -is [string]) { $value.Length } else { $null }
                valid = $valid
            }
        }
        throw "The Synapse workspace key response does not match the expected resource ID, key URL and activation boolean. Validation diagnostics: $($diagnostics | ConvertTo-Json -Depth 4 -Compress)"
    }
    return $key.properties.isActiveCMK
}

function Invoke-SynapseCmkActivation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('(?i)^/subscriptions/[0-9a-f-]{36}/resourceGroups/[^/?#]+/providers/Microsoft\.Synapse/workspaces/[^/?#]+/keys/[^/?#]+$')]
        [string] $KeyResourceId,

        [Parameter(Mandatory)]
        [ValidatePattern('^https://[^/?#@]+/keys/[^/?#]+(/[^/?#]+)?$')]
        [string] $KeyVaultUrl,

        [ValidateRange(1, 600)]
        [int] $TimeoutSeconds = 600
    )

    $deadline = (Get-SynapseCmkClock) + $TimeoutSeconds
    $path = "${KeyResourceId}?api-version=2021-06-01"
    $payload = @{ properties = @{ isActiveCMK = $true; keyVaultUrl = $KeyVaultUrl } } |
        ConvertTo-Json -Compress
    $activationAccepted = $false
    $delaySeconds = 5

    while ($true) {
        $response = Invoke-SynapseCmkRequest -Method GET -Path $path -Deadline $deadline
        $active = Test-SynapseCmkKeyActive -Response $response -KeyResourceId $KeyResourceId -KeyVaultUrl $KeyVaultUrl
        $null = Get-SynapseCmkTimeRemaining -Deadline $deadline
        if ($active) {
            return @{ keyResourceId = $KeyResourceId; isActiveCMK = $true }
        }

        if (-not $activationAccepted) {
            $response = Invoke-SynapseCmkRequest -Method PUT -Path $path -Payload $payload -Deadline $deadline
            if ($response.StatusCode -eq 200) {
                $null = Test-SynapseCmkKeyActive -Response $response -KeyResourceId $KeyResourceId -KeyVaultUrl $KeyVaultUrl
                $activationAccepted = $true
                continue
            }

            $retryable = $false
            if ($response.StatusCode -eq 400) {
                try {
                    $body = $response.Content | ConvertFrom-Json -AsHashtable -Depth 32 -ErrorAction Stop
                    $retryable = $body -is [System.Collections.IDictionary] -and $body.psbase.Count -eq 1 -and
                    $body.Contains('error') -and
                    (Test-SynapseCmkPermissionError -ErrorDetail $body.error)
                } catch [System.ArgumentException] {
                    $retryable = $false
                }
            }
            if (-not $retryable) { Write-SynapseCmkHttpFailure -Method PUT -Response $response }
            Write-Warning 'Synapse CMK activation reported CustomerManagedKeyPermissionMissing after the vault grant; retrying within the activation deadline.'
        }

        $remaining = Get-SynapseCmkTimeRemaining -Deadline $deadline
        Start-Sleep -Milliseconds ([int] [Math]::Ceiling([Math]::Min($delaySeconds, $remaining) * 1000))
        $delaySeconds = [Math]::Min($delaySeconds * 2, 30)
    }
}
