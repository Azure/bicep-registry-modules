#Requires -Version 7

function Invoke-HciArmRequest {
    param(
        [Parameter(Mandatory)] [ValidateSet('GET', 'POST')] [string] $Method,
        [Parameter(Mandatory)] [string] $Path,
        [Parameter(Mandatory)] [object] $Context
    )

    $response = Invoke-AzRestMethod -Method $Method -Path $Path -DefaultProfile $Context
    $body = if ([string]::IsNullOrWhiteSpace([string] $response.Content)) {
        $null
    } else {
        $response.Content | ConvertFrom-Json -Depth 100
    }

    [pscustomobject]@{
        StatusCode = [int] $response.StatusCode
        Body       = $body
    }
}

function Get-HciImageVersionState {
    param(
        [Parameter(Mandatory)] [string] $ImageVersionResourceId,
        [Parameter(Mandatory)] [object] $Context
    )

    $response = Invoke-HciArmRequest -Method GET -Path "${ImageVersionResourceId}?api-version=2024-03-03" -Context $Context
    if ($response.StatusCode -eq 404) {
        return [pscustomobject]@{ Exists = $false; ProvisioningState = '' }
    }
    if ($response.StatusCode -ne 200) {
        throw "Image version lookup failed with HTTP $($response.StatusCode)."
    }

    [pscustomobject]@{
        Exists           = $true
        ProvisioningState = [string] $response.Body.properties.provisioningState
    }
}

function Get-HciImageTemplateRunState {
    param(
        [Parameter(Mandatory)] [string] $ImageTemplateResourceId,
        [Parameter(Mandatory)] [object] $Context
    )

    $response = Invoke-HciArmRequest -Method GET -Path "${ImageTemplateResourceId}?api-version=2025-10-01" -Context $Context
    if ($response.StatusCode -ne 200) {
        throw "Image Builder template lookup failed with HTTP $($response.StatusCode)."
    }

    $statusProperty = $response.Body.properties.PSObject.Properties['lastRunStatus']
    $status = if ($statusProperty) { $statusProperty.Value } else { $null }
    $startTimeProperty = if ($status) { $status.PSObject.Properties['startTime'] } else { $null }
    [pscustomobject]@{
        RunState    = if ($status) { [string] $status.runState } else { '' }
        RunSubState = if ($status) { [string] $status.runSubState } else { '' }
        Message     = if ($status) { [string] $status.message } else { '' }
        StartTime   = if ($startTimeProperty) { [string] $startTimeProperty.Value } else { '' }
    }
}

function Wait-HciImageBuild {
    param(
        [Parameter(Mandatory)] [string] $ImageTemplateResourceId,
        [Parameter(Mandatory)] [object] $Context,
        [ValidateRange(1, 1440)] [int] $TimeoutMinutes,
        [ValidateRange(1, 300)] [int] $PollIntervalSeconds,
        [string] $PreviousRunStartTime = '',
        [switch] $RequireNewRun
    )

    $deadline = [DateTimeOffset]::UtcNow.AddMinutes($TimeoutMinutes)
    $currentRunObserved = -not $RequireNewRun
    while ([DateTimeOffset]::UtcNow -lt $deadline) {
        $status = Get-HciImageTemplateRunState -ImageTemplateResourceId $ImageTemplateResourceId -Context $Context
        if (-not $currentRunObserved) {
            $currentRunObserved = (
                -not [string]::IsNullOrWhiteSpace($status.StartTime) -and
                $status.StartTime -cne $PreviousRunStartTime
            )
            if (-not $currentRunObserved) {
                Start-Sleep -Seconds $PollIntervalSeconds
                continue
            }
        }

        switch ($status.RunState) {
            'Succeeded' { return $status }
            'Failed' { throw "Azure VM Image Builder failed: $($status.Message)" }
            'Canceled' { throw "Azure VM Image Builder was canceled: $($status.Message)" }
        }

        Start-Sleep -Seconds $PollIntervalSeconds
    }

    throw "Azure VM Image Builder did not finish within $TimeoutMinutes minutes. The build was not canceled."
}

function Invoke-HciImageBuild {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string] $ImageTemplateResourceId,
        [Parameter(Mandatory)] [string] $ImageVersionResourceId,
        [Parameter(Mandatory)] [object] $Context,
        [ValidateRange(1, 1440)] [int] $TimeoutMinutes = 570,
        [ValidateRange(1, 300)] [int] $PollIntervalSeconds = 30
    )

    $versionState = Get-HciImageVersionState -ImageVersionResourceId $ImageVersionResourceId -Context $Context
    if ($versionState.Exists -and $versionState.ProvisioningState -eq 'Succeeded') {
        return [pscustomobject]@{
            buildStarted           = $false
            imageVersionResourceId = $ImageVersionResourceId
            ready                  = $true
        }
    }

    $templateState = Get-HciImageTemplateRunState -ImageTemplateResourceId $ImageTemplateResourceId -Context $Context
    $activeRun = $templateState.RunState -in @('Running', 'Pending', 'Canceling')
    if ($versionState.Exists -and -not $activeRun) {
        throw "The desired HCI image version exists but is not ready, and Image Builder is not running. Image provisioning state: '$($versionState.ProvisioningState)'."
    }

    $requireNewRun = $false
    if (-not $versionState.Exists -and -not $activeRun) {
        $response = Invoke-HciArmRequest -Method POST -Path "${ImageTemplateResourceId}/run?api-version=2025-10-01" -Context $Context
        if ($response.StatusCode -notin @(200, 202)) {
            throw "Azure VM Image Builder run submission failed with HTTP $($response.StatusCode)."
        }
        $requireNewRun = $true
    }

    $null = Wait-HciImageBuild `
        -ImageTemplateResourceId $ImageTemplateResourceId `
        -Context $Context `
        -TimeoutMinutes $TimeoutMinutes `
        -PollIntervalSeconds $PollIntervalSeconds `
        -PreviousRunStartTime $templateState.StartTime `
        -RequireNewRun:$requireNewRun

    $completedVersion = Get-HciImageVersionState -ImageVersionResourceId $ImageVersionResourceId -Context $Context
    if (-not $completedVersion.Exists -or $completedVersion.ProvisioningState -ne 'Succeeded') {
        throw 'Azure VM Image Builder reported success, but the desired gallery image version is not ready.'
    }

    [pscustomobject]@{
        buildStarted           = -not $versionState.Exists -and -not $activeRun
        imageVersionResourceId = $ImageVersionResourceId
        ready                  = $true
    }
}
