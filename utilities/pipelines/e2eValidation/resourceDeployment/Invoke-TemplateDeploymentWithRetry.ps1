. (Join-Path $PSScriptRoot 'Test-TemplateDeployment.ps1')
. (Join-Path $PSScriptRoot '..' 'regionSelector' 'Get-AvailableResourceLocation.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'Get-LocallyReferencedFileList.ps1')
. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'tokenReplacement' 'Convert-TokensInFileList.ps1')
. (Join-Path $PSScriptRoot 'New-TemplateDeployment.ps1')
. (Join-Path $PSScriptRoot '..' 'resourceRemoval' 'Initialize-DeploymentRemoval.ps1')

<#
.SYNOPSIS
Classify wholly regional structured errors without overriding permission or cancellation evidence.

.PARAMETER ResourceLocation
Optional. Selected resource location. Required for ML workspace Cosmos DB capacity and AKS preflight
empty-zone failures, which must name this same region rather than a fixed secondary region.
#>
function Test-RegionalValidationError {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord,

        [Parameter()]
        [AllowNull()]
        [object] $ErrorResponse,

        [Parameter()]
        [string] $ResourceLocation
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

    if ($PSBoundParameters.ContainsKey('ErrorResponse')) {
        $response = $ErrorResponse
    } elseif ($ErrorRecord.FullyQualifiedErrorId -like 'TemplateValidationFailed*') {
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

    $guidPattern = '[0-9a-fA-F]{8}-(?:[0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}'
    $classification = @{ HasCosmosCapacityError = $false; HasAksZoneCapacityError = $false; HasUnclassifiedInformation = $false }

    function Test-MachineLearningCosmosCapacityError {
        param ([string] $Message)

        if ([string]::IsNullOrWhiteSpace($ResourceLocation)) { return $false }
        $sdkPattern = 'Microsoft\.Azure\.Documents\.Common/[0-9]+\.[0-9]+\.[0-9]+'
        $wrapperPattern = "\ALong running operation failed with status 'Failed'\. Additional Info:'Database account creation failed\. " +
        "Operation Id: $guidPattern, Error : Message: (?<json>\{.*\}), Request URI: /serviceReservation, RequestStats: , SDK: $sdkPattern(?:, $sdkPattern)*'\z"
        $wrapper = [regex]::Match($Message, $wrapperPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if (-not $wrapper.Success) { return $false }

        try {
            $document = [System.Text.Json.JsonDocument]::Parse($wrapper.Groups['json'].Value)
        } catch [System.Text.Json.JsonException] {
            return $false
        }
        try {
            if ($document.RootElement.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) { return $false }
            $cosmos = @{}
            foreach ($property in $document.RootElement.EnumerateObject()) {
                if ($property.Name -notin @('code', 'message') -or $cosmos.ContainsKey($property.Name) -or
                    $property.Value.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
                    return $false
                }
                $cosmos[$property.Name] = $property.Value.GetString()
            }
            if ($cosmos.Count -ne 2 -or $cosmos.code -cne 'ServiceUnavailable') { return $false }
            $messagePattern = '\ASorry, we are currently experiencing high demand in (?<region>[A-Za-z0-9]+(?: [A-Za-z0-9]+)*) region, ' +
            'and cannot fulfill your request at this time (?<time>[A-Z][a-z]{2}, [0-9]{2} [A-Z][a-z]{2} [0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2} GMT)\. ' +
            'To request region access for your subscription, please follow this link https://aka\.ms/cosmosdbquota for more details on how to create a region access request\.' +
            "\r\nActivityId: $guidPattern, $sdkPattern\z"
            $capacity = [regex]::Match($cosmos.message, $messagePattern)
            $timestamp = [datetime]::MinValue
            return $capacity.Success -and
            [datetime]::TryParseExact($capacity.Groups['time'].Value, 'r', [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None, [ref] $timestamp) -and
            ($capacity.Groups['region'].Value -replace '\s', '').ToLowerInvariant() -eq ($ResourceLocation -replace '\s', '').ToLowerInvariant()
        } finally {
            $document.Dispose()
        }
    }

    function Test-AksPreflightZoneCapacityError {
        param ([string] $Message, [string] $ParentMessage)

        if ([string]::IsNullOrWhiteSpace($ResourceLocation)) { return $false }
        $parent = $ParentMessage.Split("'")
        if ($parent.Count -ne 7 -or $parent[0] -cne 'The template deployment ' -or
            $parent[1] -cnotmatch '\A[A-Za-z0-9_.()-]+\z' -or
            $parent[2] -cne ' is not valid according to the validation procedure. The following resource provider(s) - ' -or
            $parent[4] -cne ' reported preflight validation errors. Tracking id is ' -or
            $parent[5] -cnotmatch "\A$guidPattern\z" -or $parent[6] -cne '. See inner errors for details.') {
            return $false
        }
        $provider = [regex]::Match($parent[3], '\AMicrosoft\.ContainerService/managedClusters \((?<version>[0-9]{4}-[0-9]{2}-[0-9]{2})\)\z')
        $apiDate = [datetime]::MinValue
        if (-not $provider.Success -or -not [datetime]::TryParseExact($provider.Groups['version'].Value, 'yyyy-MM-dd',
                [System.Globalization.CultureInfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref] $apiDate)) {
            return $false
        }

        $parts = $Message.Split("'")
        if ($parts.Count -ne 9 -or
            $parts[0] -cnotmatch '\APreflight validation check for resource\(s\) for container service [A-Za-z0-9_-]+ in resource group [A-Za-z0-9_.()-]+ failed\. Message: The zone\(s\) \z' -or
            $parts[2] -cne ' for resource ' -or $parts[3] -cnotmatch '\A[a-z][a-z0-9]{0,11}\z' -or
            $parts[4] -cne ' is not supported. The supported zones for location ' -or
            $parts[5] -cnotmatch '\A[A-Za-z0-9]+(?: [A-Za-z0-9]+)*\z' -or
            $parts[6] -cne ' are ' -or $parts[7] -cne '' -or $parts[8] -cne '. Details: ') {
            return $false
        }
        $zones = $parts[1].Split(',')
        if ($zones.Count -gt 3 -or @($zones | Where-Object { $_ -cnotin @('1', '2', '3') }).Count -gt 0 -or
            @($zones | Select-Object -Unique).Count -ne $zones.Count) {
            return $false
        }
        return ($parts[5] -replace '\s', '').ToLowerInvariant() -eq ($ResourceLocation -replace '\s', '').ToLowerInvariant()
    }

    function Test-RegionalErrorNode {
        param (
            [object] $Node,
            [int] $Depth = 0,
            [string] $WorkspaceTarget,
            [string] $AksPreflightMessage
        )

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
            if (@($Node.Keys | Where-Object { $_ -notin @('error', 'status') }).Count -gt 0 -or
                ($Node.Contains('status') -and ($Node.status -isnot [string] -or $Node.status -cne 'Failed'))) {
                $classification.HasUnclassifiedInformation = $true
            }
            return Test-RegionalErrorNode -Node $Node.error -Depth ($Depth + 1)
        }
        if ($Node.code -isnot [string] -or [string]::IsNullOrWhiteSpace($Node.code)) {
            return $false
        }
        if ($Node.additionalInfo) {
            return $false
        }
        if (@($Node.Keys | Where-Object { $_ -notin @('code', 'message', 'target', 'details', 'innererror') }).Count -gt 0 -or
            ($Node.Contains('message') -and $Node.message -isnot [string]) -or
            ($Node.Contains('target') -and ($Node.target -isnot [string] -or [string]::IsNullOrWhiteSpace($Node.target)))) {
            $classification.HasUnclassifiedInformation = $true
        }

        $children = @()
        if ($null -ne $Node.details) {
            if ($Node.details -isnot [array]) { return $false }
            $children += $Node.details
        }
        if ($null -ne $Node.innererror) {
            $children += , $Node.innererror
        }
        $childWorkspaceTarget = ''
        if ($Node.code -eq 'ResourceDeploymentFailure' -and $Node.target -is [string] -and
            $Node.target -match "\A/subscriptions/$guidPattern/resourceGroups/[A-Za-z0-9_.()-]+/providers/Microsoft\.MachineLearningServices/workspaces/[A-Za-z0-9_-]+\z") {
            $childWorkspaceTarget = $Node.target
        }
        $childAksPreflightMessage = ''
        if ($Node.code -ceq 'InvalidTemplateDeployment' -and $Node.message -is [string] -and
            -not $Node.Contains('target') -and -not $Node.Contains('innererror')) {
            $childAksPreflightMessage = $Node.message
        }
        foreach ($child in $children) {
            if (-not (Test-RegionalErrorNode -Node $child -Depth ($Depth + 1) -WorkspaceTarget $childWorkspaceTarget `
                        -AksPreflightMessage $childAksPreflightMessage)) { return $false }
        }

        if ($Node.code -in @('InvalidTemplateDeployment', 'DeploymentFailed', 'ResourceDeploymentFailure', 'MultipleErrorsOccurred')) {
            return $children.Count -gt 0
        }
        if ($Node.message -isnot [string]) { return $false }
        switch ($Node.code) {
            'AvailabilityZoneNotSupported' {
                if ($Node.code -cne 'AvailabilityZoneNotSupported' -or $classification.HasUnclassifiedInformation -or
                    [string]::IsNullOrEmpty($AksPreflightMessage) -or
                    $Node.Contains('target') -or $Node.Contains('details') -or $Node.Contains('innererror')) {
                    return $false
                }
                $isAksZoneCapacityError = Test-AksPreflightZoneCapacityError -Message $Node.message -ParentMessage $AksPreflightMessage
                if ($isAksZoneCapacityError) { $classification.HasAksZoneCapacityError = $true }
                return $isAksZoneCapacityError
            }
            'BadRequest' {
                if ($classification.HasUnclassifiedInformation -or [string]::IsNullOrEmpty($WorkspaceTarget) -or
                    $Node.Contains('details') -or $Node.Contains('innererror') -or
                    ($Node.Contains('target') -and $Node.target -ne $WorkspaceTarget)) {
                    return $false
                }
                $isCosmosCapacityError = Test-MachineLearningCosmosCapacityError -Message $Node.message
                if ($isCosmosCapacityError) { $classification.HasCosmosCapacityError = $true }
                return $isCosmosCapacityError
            }
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

    $regional = Test-RegionalErrorNode -Node $errors
    if ($regional -and $classification.HasAksZoneCapacityError -and $response -is [string]) {
        try {
            $document = [System.Text.Json.JsonDocument]::Parse($response)
        } catch [System.Text.Json.JsonException] {
            return $false
        }
        try {
            $nodes = [System.Collections.Generic.Stack[System.Text.Json.JsonElement]]::new()
            $nodes.Push($document.RootElement)
            while ($nodes.Count -gt 0) {
                $node = $nodes.Pop()
                if ($node.ValueKind -eq [System.Text.Json.JsonValueKind]::Object) {
                    $names = @{}
                    foreach ($property in $node.EnumerateObject()) {
                        if ($names.ContainsKey($property.Name)) { return $false }
                        $names[$property.Name] = $true
                        $nodes.Push($property.Value)
                    }
                } elseif ($node.ValueKind -eq [System.Text.Json.JsonValueKind]::Array) {
                    foreach ($child in $node.EnumerateArray()) { $nodes.Push($child) }
                }
            }
        } finally {
            $document.Dispose()
        }
    }
    return $regional -and (-not ($classification.HasCosmosCapacityError -or $classification.HasAksZoneCapacityError) -or
        -not $classification.HasUnclassifiedInformation)
}

function Restore-RegionTokenFile {
    param ([hashtable] $Files)
    foreach ($path in $Files.Keys) {
        [System.IO.File]::WriteAllBytes($path, $Files[$path])
    }
}

function Join-TemplateDeploymentError {
    param (
        [System.Management.Automation.ErrorRecord] $Previous,
        [System.Management.Automation.ErrorRecord] $Current
    )

    if ($null -eq $Previous -or [object]::ReferenceEquals($Previous.Exception, $Current.Exception)) {
        return $Current
    }
    $message = @(
        $Previous.ErrorDetails.Message ?? $Previous.Exception.Message
        $Current.ErrorDetails.Message ?? $Current.Exception.Message
    ) -join [Environment]::NewLine
    $record = [System.Management.Automation.ErrorRecord]::new(
        [System.AggregateException]::new('Template retry failed.', [System.Exception[]] @($Previous.Exception, $Current.Exception)),
        'TemplateDeploymentRetryFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $Previous
    )
    $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($message)
    return $record
}

<#
.SYNOPSIS
Validate and deploy with shared regional and deployment attempt budgets.

.DESCRIPTION
Each distinct region is validated once. Existing safe same-region retries share the total
deployment limit. Relocation requires an automatically selected movable location, a confirmed
failed deployment, wholly regional structured errors, and complete resource/record cleanup.
Pins, global resources and resource-group scope never relocate. Retained resources are not
cleaned between attempts. Metadata location, non-location parameters and tokens stay fixed.
Results distinguish all submitted names from names still requiring final cleanup.

.PARAMETER TemplateInput
Required. Common template, scope and parameter inputs. Only one parameter file is supported.

.PARAMETER ModuleRoot
Required. Module path used to find supported resource regions.

.PARAMETER CustomLocation
Optional. Caller-pinned resource location.

.PARAMETER TokenResourceLocation
Optional. Resource location supplied by local or custom tokens.

.PARAMETER RegionLimit
Optional. Maximum distinct region candidates, including validation-only failures. Defaults to three.

.PARAMETER DeploymentLimit
Optional. Maximum total deployment attempts across all regions, including failed preparation. Defaults to three.

.PARAMETER RemoveDeployment
Optional. Allow intermediate cleanup and relocation. False preserves resources and only permits safe same-region retries.

.PARAMETER ValidationOnly
Optional. Validate without deployment and return the selected location.

.PARAMETER DoNotThrow
Optional. Return failure details and outstanding cleanup names instead of throwing. Cancellation always propagates.

.OUTPUTS
ValidationOnly returns the selected location. Otherwise returns DeploymentOutput or Exception and the original
ErrorRecord, ResourceLocation, AttemptedLocations, DeploymentAttempts, all DeploymentNames, outstanding
RemainingDeploymentNames, and the PreflightRejectedDeploymentNames subset.
#>
function Invoke-TemplateDeploymentWithRetry {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string], [hashtable])]
    param (
        [Parameter(Mandatory)]
        [hashtable] $TemplateInput,

        [Parameter(Mandatory)]
        [string] $ModuleRoot,

        [Parameter()]
        [string] $CustomLocation,

        [Parameter()]
        [string] $TokenResourceLocation,

        [Parameter()]
        [ValidateRange(1, 3)]
        [int] $RegionLimit = 3,

        [Parameter()]
        [ValidateRange(1, 3)]
        [int] $DeploymentLimit = 3,

        [Parameter()]
        [bool] $RemoveDeployment = $true,

        [Parameter()]
        [switch] $ValidationOnly,

        [Parameter()]
        [switch] $DoNotThrow
    )

    if (-not $PSCmdlet.ShouldProcess($TemplateInput.TemplateFilePath, ($ValidationOnly ? 'Validate' : 'Validate and deploy'))) {
        return
    }
    if ($TemplateInput.ParameterFilePath -and (@($TemplateInput.ParameterFilePath).Count -ne 1 -or
            (Test-Path -LiteralPath $TemplateInput.ParameterFilePath -PathType Container))) {
        throw 'Coordinated retries require a single parameter file, not a directory or multiple files.'
    }
    $validationParameters = $TemplateInput.Clone()
    foreach ($name in @('DoNotThrow', 'RetryLimit', 'AttemptNumber', 'AdditionalTags')) {
        $validationParameters.Remove($name)
    }
    $validationParameters.AdditionalParameters = ($TemplateInput.AdditionalParameters ?? @{}).Clone()
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
    $attemptedLocations = [System.Collections.Generic.List[string]]::new()
    $deploymentNames = [System.Collections.Generic.List[string]]::new()
    $remainingNames = [System.Collections.Generic.List[string]]::new()
    $preflightNames = [System.Collections.Generic.List[string]]::new()
    $deploymentAttempts = 0
    $needsValidation = $true
    $completed = $false
    $cancelled = $false
    $lastError = $null
    $failure = $null
    $result = @{}

    try {
        while ($ValidationOnly -or $deploymentAttempts -lt $DeploymentLimit) {
            if ($needsValidation) {
                if ($attemptedLocations.Count -ge $RegionLimit) {
                    throw 'The regional candidate budget is exhausted.'
                }
                if ($pinnedLocations.Count -gt 0) {
                    $selection = @{ Location = $pinnedLocations[0]; IsGlobal = $false }
                } else {
                    $selectionInput = @{
                        ModuleRoot                  = $ModuleRoot
                        GlobalResourceGroupLocation = $validationParameters.DeploymentMetadataLocation
                        UnavailableRegions          = @($attemptedLocations)
                        AsObject                    = $true
                    }
                    if ($validationParameters.RepoRoot) {
                        $selectionInput.RepoRoot = $validationParameters.RepoRoot
                    }
                    $selection = Get-AvailableResourceLocation @selectionInput
                }
                $location = $selection.Location
                if ([string]::IsNullOrWhiteSpace($location) -or $location -in $attemptedLocations) {
                    throw 'Region selection returned an empty or previously rejected resource location.'
                }
                $attemptedLocations.Add($location)
                Write-Verbose "Validating resource location [$location], attempt [$($attemptedLocations.Count)/$RegionLimit]." -Verbose
                if ($tokenFiles.Count -gt 0 -and -not (Convert-TokensInFileList -FilePathList @($tokenFiles.Keys) -Tokens @{ resourceLocation = $location } -ErrorAction Stop)) {
                    throw 'Resource location token replacement failed.'
                }
                if ($hasLocationParameter) {
                    $validationParameters.AdditionalParameters.resourceLocation = $location
                }
                try {
                    Test-TemplateDeployment @validationParameters -ErrorAction Stop
                } catch {
                    $lastError = $_
                    if (-not $canRetry -or $selection.IsGlobal -or $attemptedLocations.Count -ge $RegionLimit -or
                        -not (Test-RegionalValidationError -ErrorRecord $_ -ResourceLocation $location)) {
                        throw
                    }
                    Write-Warning "Regional validation failed in [$location]; selecting another eligible region."
                    Restore-RegionTokenFile -Files $tokenFiles
                    continue
                }
                $needsValidation = $false
                if ($ValidationOnly) {
                    $completed = $true
                    break
                }
            }

            $deploymentAttempts++
            $deploymentInput = $TemplateInput.Clone()
            $deploymentInput.AdditionalParameters = $validationParameters.AdditionalParameters
            $deploymentInput.DoNotThrow = $true
            $deploymentInput.RetryLimit = 1
            $deploymentInput.AttemptNumber = $deploymentAttempts
            $attemptResult = New-TemplateDeployment @deploymentInput -ErrorAction Stop
            foreach ($name in @($attemptResult.DeploymentNames)) {
                if ($name -in $deploymentNames) {
                    throw "Deployment [$name] was submitted more than once; no further retries are safe."
                }
                $deploymentNames.Add($name)
                $remainingNames.Add($name)
            }
            foreach ($name in @($attemptResult.PreflightRejectedDeploymentNames)) {
                $preflightNames.Add($name)
            }
            if (-not $attemptResult.ContainsKey('Exception')) {
                $result.DeploymentOutput = $attemptResult.DeploymentOutput
                $completed = $true
                break
            }
            $lastError = $attemptResult.ErrorRecord
            if ($null -eq $lastError) {
                throw "Deployment failed without retry evidence: $($attemptResult.Exception)"
            }
            Write-Verbose (Get-TemplateValidationErrorMessage -Summary 'Template deployment failed.' `
                    -ValidationErrors @{ Message = $lastError.ErrorDetails.Message ?? $lastError.Exception.Message } `
                    -AdditionalParameters $validationParameters.AdditionalParameters -ParameterFilePath $validationParameters.ParameterFilePath) -Verbose
            if ($deploymentAttempts -ge $DeploymentLimit) {
                throw $lastError
            }

            if ($canRetry -and -not $selection.IsGlobal -and $RemoveDeployment -and
                $attemptedLocations.Count -lt $RegionLimit -and $attemptResult.FailureQueryAllowed) {
                $stateInput = @{
                    DeploymentScope   = $scope
                    DeploymentName    = $attemptResult.DeploymentNames[-1]
                    SubscriptionId    = $validationParameters.SubscriptionId
                    ResourceGroupName = $validationParameters.ResourceGroupName
                    ManagementGroupId = $validationParameters.ManagementGroupId
                }
                $deployment = Get-TemplateDeployment @stateInput -ErrorAction Stop
                if ($deployment.ProvisioningState -ne 'Failed') {
                    throw "Deployment [$($stateInput.DeploymentName)] is [$($deployment.ProvisioningState)]; no retry is safe."
                }
                $errorInput = $stateInput.Clone()
                $errorInput.Remove('SubscriptionId')
                $errors = Get-ErrorMessageForScope @errorInput -AsObject -ErrorAction Stop
                $classificationError = $lastError
                if ($attemptResult.RecoveredFailure) {
                    $classificationError = [System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException]::new('Deployment failure confirmed after timeout recovery.'),
                        'ConfirmedDeploymentFailure', [System.Management.Automation.ErrorCategory]::InvalidResult, $null
                    )
                } elseif ($lastError.CategoryInfo.Category -eq 'OperationStopped') {
                    $classificationError = [System.Management.Automation.ErrorRecord]::new(
                        $lastError.Exception, 'ConfirmedDeploymentFailure', [System.Management.Automation.ErrorCategory]::InvalidResult, $null
                    )
                }
                if (Test-RegionalValidationError -ErrorRecord $classificationError -ErrorResponse $errors -ResourceLocation $location) {
                    Write-Warning "Regional deployment failure in [$location]; cleaning confirmed failed attempts before selecting another region."
                    $cleanupInput = @{
                        TemplateFilePath                 = $validationParameters.TemplateFilePath
                        DeploymentNames                  = @($remainingNames)
                        PreflightRejectedDeploymentNames = @($preflightNames | Where-Object { $_ -in $remainingNames })
                        SubscriptionId                   = $validationParameters.SubscriptionId
                        ResourceGroupName                = $validationParameters.ResourceGroupName
                        ManagementGroupId                = $validationParameters.ManagementGroupId
                        RequireCompleteRemoval           = $true
                    }
                    try {
                        $cleanup = Initialize-DeploymentRemoval @cleanupInput -ErrorAction Stop
                    } catch {
                        foreach ($name in @($_.Exception.Data['RemovedDeploymentNames'])) {
                            $null = $remainingNames.Remove($name)
                        }
                        throw
                    }
                    if ($null -eq $cleanup -or @($cleanup.RemovedDeploymentNames).Count -ne $remainingNames.Count -or
                        @(Compare-Object -ReferenceObject @($remainingNames) -DifferenceObject @($cleanup.RemovedDeploymentNames)).Count -gt 0) {
                        throw 'Cleanup did not confirm removal of every outstanding deployment; regional relocation is blocked.'
                    }
                    $remainingNames.Clear()
                    Restore-RegionTokenFile -Files $tokenFiles
                    $needsValidation = $true
                    continue
                }
            }
            if (-not $attemptResult.RetryAllowed) {
                throw $lastError
            }
            Write-Verbose "Retrying deployment in [$location] within the shared [$deploymentAttempts/$DeploymentLimit] attempt budget." -Verbose
            Start-Sleep -Seconds 5
        }
    } catch [System.Management.Automation.PipelineStoppedException] {
        $cancelled = $true
        throw
    } catch {
        if ((Get-DeploymentErrorKind -ErrorRecord $_) -eq 'Cancellation') {
            $cancelled = $true
            throw
        }
        $failure = Join-TemplateDeploymentError -Previous $lastError -Current $_
    } finally {
        if (-not $completed) {
            try {
                Restore-RegionTokenFile -Files $tokenFiles
            } catch {
                if ($cancelled) {
                    Write-Warning "Region token restoration also failed during cancellation: $($_.Exception.Message)"
                } else {
                    $failure = Join-TemplateDeploymentError -Previous $failure -Current $_
                }
            }
        }
    }

    if ($failure) {
        $message = $failure.ErrorDetails.Message ?? $failure.Exception.Message
        if (-not $ValidationOnly) {
            $message = Get-TemplateValidationErrorMessage -Summary 'Template deployment failed.' `
                -ValidationErrors @{ Message = $message } -AdditionalParameters $validationParameters.AdditionalParameters `
                -ParameterFilePath $validationParameters.ParameterFilePath
        }
        if (-not $DoNotThrow) {
            $displayError = [System.Management.Automation.ErrorRecord]::new(
                $failure.Exception, $failure.FullyQualifiedErrorId, $failure.CategoryInfo.Category, $failure.TargetObject
            )
            $displayError.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($message)
            throw $displayError
        }
        $result.Exception = $message
        $result.ErrorRecord = $failure
    }
    if ($ValidationOnly -and $completed) {
        return $location
    }
    $result.DeploymentNames = @($deploymentNames)
    $result.RemainingDeploymentNames = @($remainingNames)
    $result.PreflightRejectedDeploymentNames = @($preflightNames)
    $result.ResourceLocation = $location
    $result.AttemptedLocations = @($attemptedLocations)
    $result.DeploymentAttempts = $deploymentAttempts
    return $result
}
