. (Join-Path $PSScriptRoot '..' '..' 'sharedScripts' 'Get-DeploymentErrorKind.ps1')

#region helper

function Get-TemplateDeployment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('resourcegroup', 'subscription', 'managementgroup', 'tenant')]
        [string] $DeploymentScope,

        [Parameter(Mandatory)]
        [string] $DeploymentName,

        [Parameter()]
        [string] $SubscriptionId,

        [Parameter()]
        [string] $ResourceGroupName,

        [Parameter()]
        [string] $ManagementGroupId,

        [Parameter()]
        [object] $DefaultProfile
    )

    $context = $DefaultProfile ?? (Get-AzContext -ErrorAction Stop)
    if ($null -eq $context -or (
            $DeploymentScope -in @('resourcegroup', 'subscription') -and
            -not [string]::IsNullOrEmpty($SubscriptionId) -and [guid] $context.Subscription.Id -ne [guid] $SubscriptionId
        )) {
        throw "The current Azure context does not match deployment [$DeploymentName]; status recovery cannot continue."
    }
    $readInputs = @{
        Name           = $DeploymentName
        DefaultProfile = $context
        ErrorAction    = 'Stop'
    }
    $records = @(switch ($DeploymentScope) {
            'resourcegroup' { Get-AzResourceGroupDeployment @readInputs -ResourceGroupName $ResourceGroupName }
            'subscription' { Get-AzDeployment @readInputs }
            'managementgroup' { Get-AzManagementGroupDeployment @readInputs -ManagementGroupId $ManagementGroupId }
            'tenant' { Get-AzTenantDeployment @readInputs }
        })
    if ($records.Count -ne 1 -or $records[0].DeploymentName -cne $DeploymentName) {
        throw "Status recovery did not return exactly the original deployment [$DeploymentName]."
    }
    return $records[0]
}

<#
.SYNOPSIS
Observe the original deployment after a request timeout without submitting it again.
#>
function Wait-TemplateDeployment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('resourcegroup', 'subscription', 'managementgroup', 'tenant')]
        [string] $DeploymentScope,

        [Parameter(Mandatory)]
        [string] $DeploymentName,

        [Parameter()]
        [string] $SubscriptionId,

        [Parameter()]
        [string] $ResourceGroupName,

        [Parameter()]
        [string] $ManagementGroupId,

        [Parameter()]
        [ValidateRange(1, 3600)]
        [int] $TimeoutSeconds = 3600,

        [Parameter()]
        [ValidateRange(1, 60)]
        [int] $PollIntervalSeconds = 15
    )

    $context = Get-AzContext -ErrorAction Stop
    if ($null -eq $context -or (
            $DeploymentScope -in @('resourcegroup', 'subscription') -and
            -not [string]::IsNullOrEmpty($SubscriptionId) -and [guid] $context.Subscription.Id -ne [guid] $SubscriptionId
        )) {
        throw "The current Azure context does not match deployment [$DeploymentName]; status recovery cannot continue."
    }
    $deadline = (Get-Date).ToUniversalTime().AddSeconds($TimeoutSeconds)
    $consecutiveTimeouts = 0
    while ((Get-Date).ToUniversalTime() -lt $deadline) {
        try {
            $deployment = Get-TemplateDeployment -DeploymentScope $DeploymentScope -DeploymentName $DeploymentName `
                -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId -DefaultProfile $context
            $consecutiveTimeouts = 0
        } catch [System.Management.Automation.PipelineStoppedException] {
            throw
        } catch {
            if ((Get-DeploymentErrorKind -ErrorRecord $_) -ne 'Timeout') {
                throw
            }
            $consecutiveTimeouts++
            if ($consecutiveTimeouts -ge 3) {
                throw [System.TimeoutException]::new(
                    "Status recovery for deployment [$DeploymentName] stopped after three consecutive request timeouts.", $_.Exception
                )
            }
            Write-Warning "Status read for deployment [$DeploymentName] timed out ($consecutiveTimeouts/3); no deployment is being resubmitted."
            $deployment = $null
        }

        if ($null -ne $deployment) {
            if ($deployment.ProvisioningState -in @('Succeeded', 'Failed')) {
                return $deployment
            }
            if ($deployment.ProvisioningState -notin @('Accepted', 'Running', 'Creating', 'Updating')) {
                throw "Deployment [$DeploymentName] has unsupported recovery state [$($deployment.ProvisioningState)]."
            }
            Write-Verbose "Deployment [$DeploymentName] remains [$($deployment.ProvisioningState)]; observing the same deployment." -Verbose
        }

        $remainingSeconds = ($deadline - (Get-Date).ToUniversalTime()).TotalSeconds
        if ($remainingSeconds -gt 0) {
            Start-Sleep -Seconds ([Math]::Min($PollIntervalSeconds, $remainingSeconds))
        }
    }
    throw [System.TimeoutException]::new("Status recovery for deployment [$DeploymentName] exceeded the $TimeoutSeconds-second recovery window.")
}

function Test-DeploymentPreflightRejection {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord,

        [Parameter(Mandatory)]
        [string] $DeploymentName
    )

    if ($ErrorRecord.CategoryInfo.Category -in @('AuthenticationError', 'PermissionDenied', 'SecurityError', 'OperationStopped')) {
        return $false
    }
    if ((Get-DeploymentErrorKind -ErrorRecord $ErrorRecord) -ne 'Other') {
        return $false
    }
    for ($exception = $ErrorRecord.Exception; $null -ne $exception; $exception = $exception.InnerException) {
        if ($exception -is [System.OperationCanceledException] -or
            $exception -is [System.Management.Automation.PipelineStoppedException] -or
            $exception -is [System.UnauthorizedAccessException] -or
            $exception -is [System.TimeoutException] -or
            $exception -is [System.Net.Http.HttpRequestException]) {
            return $false
        }
        $statusCode = $exception.Response.StatusCode ?? $exception.StatusCode
        if ($null -ne $statusCode) {
            try {
                if ([int] $statusCode -ne 400) { return $false }
            } catch {
                return $false
            }
        }
    }

    $response = $ErrorRecord.Exception.Body
    $message = $ErrorRecord.Exception.Message
    if ($ErrorRecord.ErrorDetails.Message) {
        $message = $ErrorRecord.ErrorDetails.Message
        try {
            $response = $message | ConvertFrom-Json -ErrorAction Stop
        } catch {
            $response = $null
        }
    }
    if ($null -eq $response) {
        # Az also reports preflight rejection as a timestamped, top-level error string.
        $match = [regex]::Match($message, '^(?:\d{2}:\d{2}:\d{2} - )?Error: Code=(?<code>[^;]+); Message=(?<message>[\s\S]+)$')
        if (-not $match.Success) {
            return $false
        }
        $response = @{ code = $match.Groups['code'].Value; message = $match.Groups['message'].Value }
    }
    if ($response -is [array]) {
        return $false
    }
    if ($response.error) {
        if ($response.code -or $response.message) {
            return $false
        }
        $response = $response.error
    }

    $expectedMessage = "The template deployment '$DeploymentName' is not valid according to the validation procedure."
    return $response.code -ceq 'InvalidTemplateDeployment' -and
    $response.message -is [string] -and
    $response.message.StartsWith($expectedMessage, [System.StringComparison]::Ordinal) -and
    $response.message.Contains('reported preflight validation errors.')
}

<#
.SYNOPSIS
If a deployment failed, get its error message

.DESCRIPTION
If a deployment failed, get its error message based on the deployment name in the given scope

.PARAMETER DeploymentScope
Mandatory. The scope to fetch the deployment from (e.g. resourcegroup, tenant,...)

.PARAMETER DeploymentName
Mandatory. The name of the deployment to search for (e.g. 'storageAccounts-20220105T0701282538Z')

.PARAMETER ResourceGroupName
Optional. The resource group to search the deployment in, if the scope is 'resourcegroup'

.PARAMETER ManagementGroupId
Optional. The management group to search the deployment in, if the scope is 'managementgroup'

.PARAMETER AsObject
Optional. Return structured failed-operation errors. Unknown states cannot authorize relocation.

.EXAMPLE
Get-ErrorMessageForScope -DeploymentScope 'resourcegroup' -DeploymentName 'storageAccounts-20220105T0701282538Z' -ResourceGroupName 'validation-rg'

Get the error message of any failed deployment into resource group 'validation-rg' that has the name 'storageAccounts-20220105T0701282538Z'

.EXAMPLE
Get-ErrorMessageForScope -DeploymentScope 'subscription' -DeploymentName 'resourcegroups-20220106T0401282538Z'

Get the error message of any failed deployment into the current subscription that has the name 'storageAccounts-20220105T0701282538Z'
#>
function Get-ErrorMessageForScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $DeploymentScope,

        [Parameter(Mandatory)]
        [string] $DeploymentName,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = '',

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter()]
        [switch] $AsObject
    )

    switch ($deploymentScope) {
        'resourcegroup' {
            $deployments = Get-AzResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $ResourceGroupName -ErrorAction Stop
            break
        }
        'subscription' {
            $deployments = Get-AzDeploymentOperation -DeploymentName $deploymentName -ErrorAction Stop
            break
        }
        'managementgroup' {
            $deployments = Get-AzManagementGroupDeploymentOperation -DeploymentName $deploymentName -ManagementGroupId $ManagementGroupId -ErrorAction Stop
            break
        }
        'tenant' {
            $deployments = Get-AzTenantDeploymentOperation -DeploymentName $deploymentName -ErrorAction Stop
            break
        }
    }
    $failedOperations = @($deployments | Where-Object { $_.ProvisioningState -ne 'Succeeded' })
    if ($AsObject) {
        $errors = [System.Collections.Generic.List[object]]::new()
        foreach ($operation in $failedOperations) {
            if ($operation.ProvisioningState -ne 'Failed') {
                throw "Deployment [$DeploymentName] has an operation in state [$($operation.ProvisioningState)]; regional retry is unsafe."
            }
            if ($operation.StatusMessage -is [string]) {
                try {
                    $errors.Add((ConvertFrom-Json -InputObject $operation.StatusMessage -AsHashtable -NoEnumerate -ErrorAction Stop))
                } catch {
                    Write-Warning "Deployment [$DeploymentName] has an unstructured operation error; it cannot authorize regional relocation."
                    $errors.Add($null)
                }
            } else {
                $errors.Add($operation.StatusMessage)
            }
        }
        return , @($errors)
    }
    return $failedOperations.StatusMessage
}

<#
.SYNOPSIS
Run a template deployment using a given parameter file

.DESCRIPTION
Run a template deployment using a given parameter file.
Works on a resource group, subscription, managementgroup and tenant level
Returns every attempted DeploymentNames entry and an optional PreflightRejectedDeploymentNames subset.
Cleanup must confirm DeploymentNotFound before treating a preflight rejection as an uncreated deployment.
After a submitted request times out, observe the same deployment for up to 60 minutes.
Only confirmed failure permits another submission; unknown outcomes retain attempted names for cleanup.

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file

.PARAMETER ParameterFilePath
Optional. Path to the parameter file from root. Can be a single file, multiple files, or directory that contains (.json) files.

.PARAMETER DeploymentMetadataLocation
Mandatory. The location to store the deployment metadata.

.PARAMETER ResourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER SubscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER ManagementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER AdditionalTags
Optional. Provde a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue',myKey2 = 'myValue2'}.

.PARAMETER AdditionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER RetryLimit
Optional. Maximum total attempts, including the first. Between 1 and 3; defaults to 3.
Submitted deployments retry only after confirmed failure or preflight rejection.

.PARAMETER AttemptNumber
Optional. Starting attempt ordinal for deployment names. Coordinated retries supply the global ordinal with RetryLimit=1.

.PARAMETER DoNotThrow
Optional. Do not throw an exception if it failed. Still returns the error message though

.PARAMETER RepoRoot
Mandatory. Path to the root of the repository.

.OUTPUTS
Returns DeploymentNames, PreflightRejectedDeploymentNames and DeploymentOutput or Exception.
With DoNotThrow, failures also include the original ErrorRecord and existing RetryAllowed decision.
FailureQueryAllowed permits an authoritative state lookup, not retry or cleanup on its own.
RecoveredFailure identifies a failed deployment whose timeout recovery completed without uncertainty.

.EXAMPLE
New-TemplateDeploymentInner -TemplateFilePath 'C:/key-vault/vault/main.json' -ParameterFilePath 'C:/key-vault/vault/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Deploy the main.json of the KeyVault module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeploymentInner -TemplateFilePath 'C:/key-vault/vault/main.bicep' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Deploy the main.bicep of the KeyVault module using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeploymentInner -TemplateFilePath 'C:/resources/resource-group/main.json' -DeploymentMetadataLocation 'WestEurope'

Deploy the main.json of the ResourceGroup module without a parameter file in location 'WestEurope'
#>
function New-TemplateDeploymentInner {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ParameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = '',

        [Parameter(Mandatory = $true)]
        [string] $DeploymentMetadataLocation,

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $AdditionalTags,

        [Parameter(Mandatory = $false)]
        [Hashtable] $AdditionalParameters,

        [Parameter(Mandatory = $false)]
        [switch] $DoNotThrow,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3)]
        [int] $RetryLimit = 3,

        [Parameter()]
        [ValidateRange(1, 3)]
        [int] $AttemptNumber = 1,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
    }

    process {
        $deploymentNamePrefix = Split-Path -Path (Split-Path $TemplateFilePath -Parent) -LeafBase
        if ([String]::IsNullOrEmpty($deploymentNamePrefix)) {
            $deploymentNamePrefix = 'templateDeployment-{0}' -f (Split-Path $TemplateFilePath -LeafBase)
        }

        # Convert, e.g., [C:\myFork\avm\res\kubernetes-configuration\flux-configuration\tests\e2e\defaults\main.test.bicep] to [a-r-kc-fc-defaults]
        $shortPathElems = ((Split-Path $TemplateFilePath) -replace ('{0}[\\|\/]' -f [regex]::Escape($repoRoot))) -split '[\\|\/]' | Where-Object { $_ -notin @('tests', 'e2e') }
        # Shorten all elements but the last
        $reducedElem = $shortPathElems[0 .. ($shortPathElems.Count - 2)] | ForEach-Object {
            $shortPathElem = $_
            if ($shortPathElem -match '-') {
                ($shortPathElem -split '-' | ForEach-Object { $_[0] }) -join ''
            } else {
                $shortPathElem[0]
            }
        }
        # Add the last back and join the elements together
        $deploymentNamePrefix = ($reducedElem + @($shortPathElems[-1])) -join '-'

        $DeploymentInputs = @{
            TemplateFile = $TemplateFilePath
            Verbose      = $true
            ErrorAction  = 'Stop'
        }

        # Parameter file provided yes/no
        if (-not [String]::IsNullOrEmpty($ParameterFilePath)) {
            $DeploymentInputs['TemplateParameterFile'] = $ParameterFilePath
        }

        # Additional parameter object provided yes/no
        if ($AdditionalParameters) {
            $DeploymentInputs += $AdditionalParameters
        }

        # Additional tags provides yes/no
        # Append tags to parameters if resource supports them (all tags must be in one object)
        if ($AdditionalTags) {

            # Parameter tags
            if (-not [String]::IsNullOrEmpty($ParameterFilePath)) {
                $parameterFileTags = (ConvertFrom-Json (Get-Content -Raw -Path $ParameterFilePath) -AsHashtable).parameters.tags.value
            }
            if (-not $parameterFileTags) { $parameterFileTags = @{} }

            # Pipeline tags
            if ($AdditionalTags) { $parameterFileTags += $AdditionalTags } # If additionalTags object is provided, append tag to the resource

            # Overwrites parameter file tags parameter
            Write-Verbose ("additionalTags: $(($AdditionalTags) ? ($AdditionalTags | ConvertTo-Json) : '[]')")
            $DeploymentInputs += @{Tags = $parameterFileTags }
        }

        #######################
        ## INVOKE DEPLOYMENT ##
        #######################
        $deploymentScope = Get-ScopeOfTemplateFile -TemplateFilePath $TemplateFilePath
        [bool]$Stoploop = $false
        [int]$retryCount = 1
        $usedDeploymentNames = @()
        $preflightRejectedDeploymentNames = @()

        do {
            # Generate a valid deployment name. Must match ^[-\w\._\(\)]+$
            $suffix = '-t{0}-{1}' -f ($AttemptNumber + $retryCount - 1), (Get-Date -Format 'yyyyMMddTHHMMssffffZ')
            $deploymentName = $deploymentNamePrefix.Substring(0, [Math]::Min($deploymentNamePrefix.Length, 64 - $suffix.Length)) + $suffix
            if ($deploymentName -notmatch '^[-\w\._\(\)]+$') {
                throw "Generated deployment name [$deploymentName] contains unsupported characters."
            }

            Write-Verbose "Deploying with deployment name [$deploymentName]" -Verbose
            $DeploymentInputs['DeploymentName'] = $deploymentName
            $res = $null
            $submissionStarted = $false
            $submissionReturned = $false

            try {
                switch ($deploymentScope) {
                    'resourcegroup' {
                        if (-not [String]::IsNullOrEmpty($SubscriptionId)) {
                            Write-Verbose ('Setting context to subscription [{0}]' -f $SubscriptionId)
                            $null = Set-AzContext -Subscription $SubscriptionId -ErrorAction Stop
                        }
                        if (-not (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction 'SilentlyContinue')) {
                            $resourceGroupLocation = $AdditionalParameters.resourceLocation ?? $DeploymentMetadataLocation
                            if ($PSCmdlet.ShouldProcess("Resource group [$ResourceGroupName] in (metadata) location [$resourceGroupLocation]", 'Create')) {
                                $null = New-AzResourceGroup -Name $ResourceGroupName -Location $resourceGroupLocation
                            }
                        }
                        if ($PSCmdlet.ShouldProcess('Resource group level deployment', 'Create')) {
                            $submissionStarted = $true
                            $usedDeploymentNames += $deploymentName
                            $res = New-AzResourceGroupDeployment @DeploymentInputs -ResourceGroupName $ResourceGroupName
                        }
                        break
                    }
                    'subscription' {
                        if (-not [String]::IsNullOrEmpty($SubscriptionId)) {
                            Write-Verbose ('Setting context to subscription [{0}]' -f $SubscriptionId)
                            $null = Set-AzContext -Subscription $SubscriptionId -ErrorAction Stop
                        }
                        if ($PSCmdlet.ShouldProcess('Subscription level deployment', 'Create')) {
                            $submissionStarted = $true
                            $usedDeploymentNames += $deploymentName
                            $res = New-AzSubscriptionDeployment @DeploymentInputs -Location $DeploymentMetadataLocation
                        }
                        break
                    }
                    'managementgroup' {
                        if ($PSCmdlet.ShouldProcess('Management group level deployment', 'Create')) {
                            $submissionStarted = $true
                            $usedDeploymentNames += $deploymentName
                            $res = New-AzManagementGroupDeployment @DeploymentInputs -Location $DeploymentMetadataLocation -ManagementGroupId $ManagementGroupId
                        }
                        break
                    }
                    'tenant' {
                        if ($PSCmdlet.ShouldProcess('Tenant level deployment', 'Create')) {
                            $submissionStarted = $true
                            $usedDeploymentNames += $deploymentName
                            $res = New-AzTenantDeployment @DeploymentInputs -Location $DeploymentMetadataLocation
                        }
                        break
                    }
                    default {
                        throw "[$deploymentScope] is a non-supported template scope"
                        $Stoploop = $true
                    }
                }
                $submissionReturned = $true
                if ($submissionStarted -and $null -eq $res) {
                    throw "Deployment [$deploymentName] returned no result; the submission outcome is unknown."
                }
                if ($res.ProvisioningState -eq 'Failed') {
                    # Deployment failed but no exception was thrown. Hence we must do it for the command.

                    $errorInputObject = @{
                        DeploymentScope   = $deploymentScope
                        DeploymentName    = $deploymentName
                        ResourceGroupName = $ResourceGroupName
                        ManagementGroupId = $ManagementGroupId
                    }
                    $exceptionMessage = Get-ErrorMessageForScope @errorInputObject

                    throw "Deployed failed with provisioning state [Failed]. Error Message: [$exceptionMessage]. Please review the Azure logs of deployment [$deploymentName] in scope [$deploymentScope] for further details."
                }
                if ($submissionStarted -and $res.ProvisioningState -ne 'Succeeded') {
                    throw "Deployment [$deploymentName] returned provisioning state [$($res.ProvisioningState)]; the submission outcome is unknown."
                }
                $Stoploop = $true
            } catch [System.Management.Automation.PipelineStoppedException] {
                throw
            } catch {
                $deploymentError = $_
                $errorKind = Get-DeploymentErrorKind -ErrorRecord $deploymentError
                $recoveryFailed = $false
                if ($errorKind -eq 'Cancellation') {
                    throw
                }
                if ($submissionStarted -and $null -eq $res -and $errorKind -eq 'Timeout') {
                    Write-Warning "Request for deployment [$deploymentName] timed out; observing its status without resubmitting. $($deploymentError.Exception.Message)"
                    try {
                        $res = Wait-TemplateDeployment -DeploymentScope $deploymentScope -DeploymentName $deploymentName `
                            -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId
                    } catch [System.Management.Automation.PipelineStoppedException] {
                        throw
                    } catch {
                        if ((Get-DeploymentErrorKind -ErrorRecord $_) -eq 'Cancellation') {
                            throw
                        }
                        $exception = [System.AggregateException]::new(
                            "Status recovery for deployment [$deploymentName] failed; the submission outcome remains unknown.",
                            [System.Exception[]] @($deploymentError.Exception, $_.Exception)
                        )
                        $deploymentError = [System.Management.Automation.ErrorRecord]::new(
                            $exception, 'DeploymentTimeoutRecoveryFailed', [System.Management.Automation.ErrorCategory]::OperationTimeout, $deploymentName
                        )
                        $recoveryFailed = $true
                    }
                    if ($res.ProvisioningState -eq 'Succeeded') {
                        $Stoploop = $true
                        continue
                    }
                    if ($res.ProvisioningState -eq 'Failed') {
                        $errorKind = 'Other'
                        try {
                            $failureDetails = Get-ErrorMessageForScope -DeploymentScope $deploymentScope -DeploymentName $deploymentName `
                                -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId
                            $exception = [System.InvalidOperationException]::new(
                                "Deployment [$deploymentName] was confirmed Failed during timeout recovery. Error Message: [$failureDetails]. Original request error: $($deploymentError.Exception.Message)",
                                $deploymentError.Exception
                            )
                        } catch [System.Management.Automation.PipelineStoppedException] {
                            throw
                        } catch {
                            if ((Get-DeploymentErrorKind -ErrorRecord $_) -eq 'Cancellation') {
                                throw
                            }
                            $exception = [System.AggregateException]::new(
                                "Deployment [$deploymentName] was confirmed Failed during timeout recovery, but its failure details could not be read.",
                                [System.Exception[]] @($deploymentError.Exception, $_.Exception)
                            )
                            $recoveryFailed = $true
                        }
                        $deploymentError = [System.Management.Automation.ErrorRecord]::new(
                            $exception, 'DeploymentFailedAfterTimeout', [System.Management.Automation.ErrorCategory]::InvalidResult, $deploymentName
                        )
                    }
                }
                $preflightRejected = $submissionStarted -and $null -eq $res -and (Test-DeploymentPreflightRejection -ErrorRecord $deploymentError -DeploymentName $deploymentName)
                if ($preflightRejected) {
                    $preflightRejectedDeploymentNames += $deploymentName
                    Write-Verbose "Deployment [$deploymentName] was rejected by preflight validation; cleanup will check whether a deployment record exists." -Verbose
                }
                $failedDeploymentMessage = "^(?:\d{2}:\d{2}:\d{2} - )?The deployment '$([regex]::Escape($deploymentName))' failed with error\(s\)\. (?:Showing \d+ out of \d+ error\(s\)\. Status Message: (?:(?!\(Code:)[^\r\n])* )?\(Code: DeploymentFailed\)(?:\s|$)"
                $confirmedFailure = $res.ProvisioningState -eq 'Failed' -or ($errorKind -eq 'Other' -and $deploymentError.Exception.Message -cmatch $failedDeploymentMessage)
                $unknownSubmission = $submissionStarted -and -not $preflightRejected -and -not $confirmedFailure
                $retryAllowed = -not $unknownSubmission -and -not $recoveryFailed -and $errorKind -notin @('Timeout', 'Transport')
                if ($retryCount -ge $RetryLimit -or -not $retryAllowed) {
                    if ($DoNotThrow) {
                        $exceptionMessage = $deploymentError.Exception.Message
                        if ([String]::IsNullOrEmpty($exceptionMessage)) {
                            $exceptionMessage = "Deployment attempt [$deploymentName] failed without an error message (submission started: [$submissionStarted])."
                        }

                        return @{
                            DeploymentNames                  = $usedDeploymentNames
                            PreflightRejectedDeploymentNames = $preflightRejectedDeploymentNames
                            Exception                        = $exceptionMessage
                            ErrorRecord                      = $deploymentError
                            RetryAllowed                     = $retryAllowed
                            FailureQueryAllowed              = $submissionStarted -and -not $preflightRejected -and -not $recoveryFailed -and
                            $errorKind -eq 'Other' -and (($null -eq $res -and -not $submissionReturned) -or $res.ProvisioningState -eq 'Failed')
                            RecoveredFailure                 = $deploymentError.FullyQualifiedErrorId -eq 'DeploymentFailedAfterTimeout' -and -not $recoveryFailed
                        }
                    } else {
                        throw $deploymentError
                    }
                    $Stoploop = $true
                } else {
                    Write-Verbose "Resource deployment Failed.. ($retryCount/$RetryLimit) Retrying in 5 Seconds.. `n"
                    Write-Verbose ($deploymentError.Exception.Message | Out-String) -Verbose
                    Start-Sleep -Seconds 5
                    $retryCount++
                }
            }
        }
        until ($Stoploop -eq $true -or $retryCount -gt $RetryLimit)

        Write-Verbose 'Result' -Verbose
        Write-Verbose '------' -Verbose
        Write-Verbose ($res | Out-String) -Verbose
        return @{
            DeploymentNames                  = $usedDeploymentNames
            PreflightRejectedDeploymentNames = $preflightRejectedDeploymentNames
            DeploymentOutput                 = $res.Outputs
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
#endregion

<#
.SYNOPSIS
Run a template deployment using a given parameter file

.DESCRIPTION
Run a template deployment using a given parameter file.
Works on a resource group, subscription, managementgroup and tenant level
Returns every attempted DeploymentNames entry and an optional PreflightRejectedDeploymentNames subset.
Cleanup must confirm DeploymentNotFound before treating a preflight rejection as an uncreated deployment.
After a submitted request times out, observe the same deployment for up to 60 minutes.
Only confirmed failure permits another submission; unknown outcomes retain attempted names for cleanup.

.PARAMETER TemplateFilePath
Mandatory. The path to the deployment file

.PARAMETER ParameterFilePath
Optional. Path to the parameter file from root. Can be a single file, multiple files, or directory that contains (.json) files.

.PARAMETER DeploymentMetadataLocation
Mandatory. The location to store the deployment metadata.

.PARAMETER ResourceGroupName
Optional. Name of the resource group to deploy into. Mandatory if deploying into a resource group (resource group level)

.PARAMETER SubscriptionId
Optional. ID of the subscription to deploy into. Mandatory if deploying into a subscription (subscription level) using a Management groups service connection

.PARAMETER ManagementGroupId
Optional. Name of the management group to deploy into. Mandatory if deploying into a management group (management group level)

.PARAMETER AdditionalTags
Optional. Provide a Key Value Pair (Object) that will be appended to the Parameter file tags. Example: @{myKey = 'myValue', myKey2 = 'myValue2'}.

.PARAMETER AdditionalParameters
Optional. Additional parameters you can provide with the deployment. E.g. @{ resourceGroupName = 'myResourceGroup' }

.PARAMETER RetryLimit
Optional. Maximum total attempts, including the first. Between 1 and 3; defaults to 3.
Submitted deployments retry only after confirmed failure or preflight rejection.

.PARAMETER AttemptNumber
Optional. Starting attempt ordinal for deployment names. Coordinated retries supply the global ordinal with RetryLimit=1.

.PARAMETER DoNotThrow
Optional. Do not throw an exception if it failed. Still returns the error message though

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.OUTPUTS
Returns DeploymentNames, PreflightRejectedDeploymentNames and DeploymentOutput or Exception.
With DoNotThrow, failures also include the original ErrorRecord and existing RetryAllowed decision.
FailureQueryAllowed permits an authoritative state lookup, not retry or cleanup on its own.
RecoveredFailure identifies a failed deployment whose timeout recovery completed without uncertainty.

.EXAMPLE
New-TemplateDeployment -TemplateFilePath 'C:/key-vault/vault/main.bicep' -ParameterFilePath 'C:/key-vault/vault/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope' -ResourceGroupName 'aLegendaryRg'

Deploy the main.bicep of the 'key-vault/vault' module with the parameter file 'parameters.json' using the resource group 'aLegendaryRg' in location 'WestEurope'

.EXAMPLE
New-TemplateDeployment -TemplateFilePath 'C:/resources/resource-group/main.bicep' -DeploymentMetadataLocation 'WestEurope'

Deploy the main.bicep of the 'resources/resource-group' module in location 'WestEurope' without a parameter file

.EXAMPLE
New-TemplateDeployment -TemplateFilePath 'C:/resources/resource-group/main.json' -ParameterFilePath 'C:/resources/resource-group/.test/parameters.json' -DeploymentMetadataLocation 'WestEurope'

Deploy the main.json of the 'resources/resource-group' module with the parameter file 'parameters.json' in location 'WestEurope'
#>
function New-TemplateDeployment {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $true)]
        [string] $DeploymentMetadataLocation,

        [Parameter(Mandatory = $false)]
        [string[]] $ParameterFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName = '',

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [Hashtable] $AdditionalParameters,

        [Parameter(Mandatory = $false)]
        [PSCustomObject] $AdditionalTags,

        [Parameter(Mandatory = $false)]
        [switch] $DoNotThrow,

        [Parameter(Mandatory = $false)]
        [ValidateRange(1, 3)]
        [int] $RetryLimit = 3,

        [Parameter()]
        [ValidateRange(1, 3)]
        [int] $AttemptNumber = 1,

        [Parameter(Mandatory = $false)]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Load helper functions
        . (Join-Path $repoRoot 'utilities' 'pipelines' 'sharedScripts' 'Get-ScopeOfTemplateFile.ps1')
    }

    process {
        ## Assess Provided Parameter Path
        if ((-not [String]::IsNullOrEmpty($ParameterFilePath)) -and (Test-Path -Path $ParameterFilePath -PathType 'Container') -and $ParameterFilePath.Length -eq 1) {
            ## Transform Path to Files
            $ParameterFilePath = Get-ChildItem $ParameterFilePath -Recurse -Filter *.json | Select-Object -ExpandProperty FullName
            Write-Verbose "Detected Parameter File(s)/Directory - Count: `n $($ParameterFilePath.Count)"
        }

        ## Iterate through each file
        $deploymentInputObject = @{
            TemplateFilePath           = $TemplateFilePath
            AdditionalTags             = $AdditionalTags
            AdditionalParameters       = $AdditionalParameters
            DeploymentMetadataLocation = $DeploymentMetadataLocation
            ResourceGroupName          = $ResourceGroupName
            SubscriptionId             = $SubscriptionId
            ManagementGroupId          = $ManagementGroupId
            DoNotThrow                 = $DoNotThrow
            RetryLimit                 = $RetryLimit
            AttemptNumber              = $AttemptNumber
            RepoRoot                   = $RepoRoot
        }
        if ($ParameterFilePath) {
            if ($ParameterFilePath -is [array]) {
                $deploymentResult = [System.Collections.ArrayList]@()
                foreach ($path in $ParameterFilePath) {
                    if ($PSCmdlet.ShouldProcess("Deployment for parameter file [$ParameterFilePath]", 'Trigger')) {
                        $deploymentResult += New-TemplateDeploymentInner @deploymentInputObject -ParameterFilePath $path
                    }
                }
                return $deploymentResult
            } else {
                if ($PSCmdlet.ShouldProcess("Deployment for single parameter file [$ParameterFilePath]", 'Trigger')) {
                    return New-TemplateDeploymentInner @deploymentInputObject -ParameterFilePath $ParameterFilePath
                }
            }
        } else {
            if ($PSCmdlet.ShouldProcess('Deployment without parameter file', 'Trigger')) {
                return New-TemplateDeploymentInner @deploymentInputObject
            }
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
