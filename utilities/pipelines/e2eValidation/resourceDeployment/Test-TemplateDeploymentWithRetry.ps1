. (Join-Path $PSScriptRoot 'Test-TemplateDeployment.ps1')
. (Join-Path $PSScriptRoot '..' 'regionSelector' 'Get-AvailableResourceLocation.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'Get-LocallyReferencedFileList.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')

function Test-RegionalValidationError {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord
    )

    if ($ErrorRecord.CategoryInfo.Category -in @('AuthenticationError', 'PermissionDenied', 'SecurityError', 'OperationStopped')) {
        return $false
    }
    for ($exception = $ErrorRecord.Exception; $null -ne $exception; $exception = $exception.InnerException) {
        if ($exception -is [System.OperationCanceledException] -or
            $exception -is [System.Management.Automation.PipelineStoppedException] -or
            $exception -is [System.UnauthorizedAccessException]) {
            return $false
        }
        $statusCode = $exception.Response.StatusCode ?? $exception.StatusCode
        if ($statusCode -and [int] $statusCode -notin @(400, 409, 503)) {
            return $false
        }
    }

    if ($ErrorRecord.FullyQualifiedErrorId -like 'TemplateValidationFailed*') {
        $response = $ErrorRecord.TargetObject
    } elseif ($ErrorRecord.ErrorDetails.Message) {
        $response = $ErrorRecord.ErrorDetails.Message
    } else {
        return $false
    }

    try {
        $errors = $response -is [string] ? ($response | ConvertFrom-Json -AsHashtable -NoEnumerate -ErrorAction Stop) :
        ($response | ConvertTo-Json -Depth 30 -WarningAction Stop | ConvertFrom-Json -AsHashtable -NoEnumerate -ErrorAction Stop)
    } catch {
        return $false
    }

    function Test-RegionalErrorNode {
        param ([object] $Node, [int] $Depth = 0)

        if ($Depth -gt 20 -or $null -eq $Node) {
            return $false
        }
        if ($Node -is [array]) {
            if ($Node.Count -eq 0) { return $false }
            foreach ($child in $Node) {
                if (-not (Test-RegionalErrorNode -Node $child -Depth ($Depth + 1))) { return $false }
            }
            return $true
        }
        if ($Node -isnot [System.Collections.IDictionary]) {
            return $false
        }
        $properties = @{}
        foreach ($key in $Node.psbase.Keys) {
            if ($properties.ContainsKey($key)) { return $false }
            $properties[$key] = $Node[$key]
        }
        $Node = $properties
        if ($Node.Contains('error')) {
            if ($Node.Contains('code') -or $Node.Contains('details') -or $Node.Contains('innererror')) { return $false }
            return Test-RegionalErrorNode -Node $Node.error -Depth ($Depth + 1)
        }
        if ($Node.code -isnot [string] -or [string]::IsNullOrWhiteSpace($Node.code)) {
            return $false
        }
        if ($Node.additionalInfo) {
            return $false
        }

        $children = @()
        if ($null -ne $Node.details) {
            if ($Node.details -isnot [array]) { return $false }
            $children += $Node.details
        }
        if ($null -ne $Node.innererror) {
            $children += , $Node.innererror
        }
        foreach ($child in $children) {
            if (-not (Test-RegionalErrorNode -Node $child -Depth ($Depth + 1))) { return $false }
        }

        if ($Node.code -in @('InvalidTemplateDeployment', 'DeploymentFailed', 'MultipleErrorsOccurred')) {
            return $children.Count -gt 0
        }
        if ($Node.message -isnot [string]) { return $false }
        switch ($Node.code) {
            'RequestDisallowedByAzure' {
                return $Node.message -match 'https://aka\.ms/locationineligible(?:[?#\s).,;:''"]|$)'
            }
            { $_ -in @('AllocationFailed', 'ZonalAllocationFailed', 'InsufficientCapacity') } {
                return $Node.message -match '\b(capacity|allocation)\b' -and $Node.message -match '\b(region|location|zone)\b'
            }
            'SkuNotAvailable' {
                return $Node.message -match '\b(capacity|not available)\b' -and $Node.message -match '\b(region|location)\b'
            }
            default { return $false }
        }
    }

    return Test-RegionalErrorNode -Node $errors
}

<#
.SYNOPSIS
Validate a test template in at most three distinct eligible resource regions.

.DESCRIPTION
Only wholly regional validation failures can select another supported, allowed region.
Explicit custom, CI-parameter and token locations are pinned. Explicitly global resources
and resource-group-scope templates never relocate. Unknown provider locations fail closed.
Only resourceLocation parameters and tokens change; deployment metadata stays in its original location.
Each failed attempt restores pristine region-token files before another region is selected.
Deployment, post-deployment tests and deployment-name cleanup remain outside this loop.

.NOTES
Eligible errors are RequestDisallowedByAzure with the locationineligible link, or
AllocationFailed, ZonalAllocationFailed, InsufficientCapacity and SkuNotAvailable
with a regional capacity/availability message. Every nested error must qualify.
Malformed, mixed, permission, authentication, configuration and assertion errors stop.

.PARAMETER ValidationInput
Required. Parameters passed to Test-TemplateDeployment. An empty resourceLocation parameter permits automatic selection.

.PARAMETER ModuleRoot
Required. Module path used to find supported resource regions.

.PARAMETER CustomLocation
Optional. Caller-pinned resource location.

.PARAMETER TokenResourceLocation
Optional. Resource location supplied by local or custom tokens.

.PARAMETER RetryLimit
Optional. Maximum total validation attempts, including the first. Defaults to three.
#>
function Test-TemplateDeploymentWithRetry {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [hashtable] $ValidationInput,

        [Parameter(Mandatory)]
        [string] $ModuleRoot,

        [Parameter()]
        [string] $CustomLocation,

        [Parameter()]
        [string] $TokenResourceLocation,

        [Parameter()]
        [ValidateRange(1, 3)]
        [int] $RetryLimit = 3
    )

    $validationParameters = $ValidationInput.Clone()
    $validationParameters.AdditionalParameters = ($ValidationInput.AdditionalParameters ?? @{}).Clone()
    $pinnedLocations = @(@($CustomLocation, $TokenResourceLocation, $validationParameters.AdditionalParameters.resourceLocation) |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            ForEach-Object { ($_ -replace '\s', '').ToLowerInvariant() } | Sort-Object -Unique)
    if ($pinnedLocations.Count -gt 1) {
        throw 'Conflicting resource locations were supplied by customLocation, CI parameters or tokens.'
    }

    $scope = Get-ScopeOfTemplateFile -TemplateFilePath $validationParameters.TemplateFilePath
    $tokenFiles = @{}
    $paths = @($validationParameters.TemplateFilePath) + @(Get-LocallyReferencedFileList -FilePath $validationParameters.TemplateFilePath)
    foreach ($path in ($paths | Sort-Object -Unique)) {
        if ((Get-Content -LiteralPath $path -Raw -ErrorAction Stop) -match '#_resourceLocation_#') {
            $tokenFiles[$path] = [System.IO.File]::ReadAllBytes($path)
        }
    }
    $hasLocationParameter = $validationParameters.AdditionalParameters.ContainsKey('resourceLocation')
    $canRetry = $pinnedLocations.Count -eq 0 -and $scope -ne 'resourcegroup' -and ($hasLocationParameter -or $tokenFiles.Count -gt 0)
    $attemptedLocations = @()

    for ($attempt = 1; $attempt -le $RetryLimit; $attempt++) {
        if ($pinnedLocations.Count -gt 0) {
            $selection = @{ Location = $pinnedLocations[0]; IsGlobal = $false }
        } else {
            $selectionInput = @{
                ModuleRoot                  = $ModuleRoot
                GlobalResourceGroupLocation = $validationParameters.DeploymentMetadataLocation
                UnavailableRegions          = $attemptedLocations
                AsObject                    = $true
            }
            if ($validationParameters.RepoRoot) {
                $selectionInput.RepoRoot = $validationParameters.RepoRoot
            }
            $selection = Get-AvailableResourceLocation @selectionInput
        }
        $location = $selection.Location
        if ($location -in $attemptedLocations) {
            throw 'Region selection returned a previously rejected resource location.'
        }
        $attemptedLocations += $location
        Write-Verbose "Validating resource location [$location], attempt [$attempt/$RetryLimit]." -Verbose
        $validated = $false

        try {
            if ($tokenFiles.Count -gt 0) {
                if (-not (Convert-TokensInFileList -FilePathList @($tokenFiles.Keys) -Tokens @{ resourceLocation = $location } -ErrorAction Stop)) {
                    throw 'Resource location token replacement failed.'
                }
            }
            if ($hasLocationParameter) {
                $validationParameters.AdditionalParameters.resourceLocation = $location
            }
            try {
                Test-TemplateDeployment @validationParameters -ErrorAction Stop
                $validated = $true
                return $location
            } catch {
                if (-not $canRetry -or $selection.IsGlobal -or $attempt -eq $RetryLimit -or -not (Test-RegionalValidationError -ErrorRecord $_)) {
                    Write-Warning "Template validation failed after [$attempt] attempt(s) in [$($attemptedLocations -join ', ')]; no regional retry."
                    throw
                }
                Write-Warning "Regional validation failed in [$location] on attempt [$attempt/$RetryLimit]; selecting another eligible region."
            }
        } finally {
            if (-not $validated) {
                foreach ($path in $tokenFiles.Keys) {
                    [System.IO.File]::WriteAllBytes($path, $tokenFiles[$path])
                }
            }
        }
    }
}
