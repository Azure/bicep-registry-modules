. (Join-Path $PSScriptRoot 'Invoke-TemplateDeploymentWithRetry.ps1')

function Invoke-TemplateDeploymentWithPreparation {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param (
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $RetryInput,

        [Parameter()]
        [string] $PreparationParameter = '',

        [Parameter()]
        [System.Collections.IDictionary] $TemplateParameters = @{},

        [Parameter()]
        [string] $GitHubOutputPath
    )

    if ([string]::IsNullOrEmpty($PreparationParameter)) {
        return Invoke-TemplateDeploymentWithRetry @RetryInput
    }

    $definition = $TemplateParameters[$PreparationParameter]
    if ($definition -isnot [System.Collections.IDictionary] -or $definition.type -isnot [string] -or $definition.type -ine 'bool' -or
        $definition.defaultValue -isnot [bool] -or $definition.defaultValue) {
        throw 'The preparation parameter must be a declared ARM bool parameter with defaultValue false.'
    }
    if ([string]::IsNullOrWhiteSpace($GitHubOutputPath) -or
        -not [System.IO.Path]::IsPathFullyQualified($GitHubOutputPath) -or
        -not (Test-Path -LiteralPath $GitHubOutputPath -PathType Leaf)) {
        throw 'Dependency preparation requires an absolute path to an existing GitHub output file.'
    }
    if ($RetryInput.TemplateInput -isnot [System.Collections.IDictionary] -or
        ($null -ne $RetryInput.TemplateInput.AdditionalParameters -and
            $RetryInput.TemplateInput.AdditionalParameters -isnot [System.Collections.IDictionary])) {
        throw 'Dependency preparation requires dictionary template inputs and additional parameters.'
    }

    function Copy-PreparationDictionary {
        param ([System.Collections.IDictionary] $Dictionary)

        $copy = @{}
        if ($null -ne $Dictionary) {
            foreach ($entry in $Dictionary.GetEnumerator()) {
                $copy[$entry.Key] = $entry.Value
            }
        }
        return $copy
    }

    $trackingNames = @('deploymentNames', 'remainingDeploymentNames', 'preflightRejectedDeploymentNames', 'pendingDeletionDeploymentIds')
    function Assert-PreparationTracking {
        param ([object] $Result)

        if ($Result -isnot [System.Collections.IDictionary]) {
            throw 'Deployment did not return authoritative cleanup tracking.'
        }
        foreach ($name in $trackingNames) {
            if (-not $Result.Contains($name) -or $Result[$name] -isnot [array] -or
                @($Result[$name] | Where-Object { $_ -isnot [string] -or [string]::IsNullOrWhiteSpace($_) }).Count -gt 0) {
                throw 'Deployment did not return authoritative cleanup tracking.'
            }
        }
        if ($Result.DeploymentAttempts -isnot [int] -or $Result.DeploymentAttempts -lt 0) {
            throw 'Deployment did not return an authoritative attempt count.'
        }
    }

    $preparationInput = Copy-PreparationDictionary -Dictionary $RetryInput
    $preparationInput.TemplateInput = Copy-PreparationDictionary -Dictionary $RetryInput.TemplateInput
    $preparationInput.TemplateInput.AdditionalParameters = Copy-PreparationDictionary -Dictionary $RetryInput.TemplateInput.AdditionalParameters
    $preparationInput.TemplateInput.AdditionalParameters[$PreparationParameter] = $true
    $preparationInput.RemoveDeployment = $false
    $preparationInput.DoNotThrow = $true

    $preparationResult = Invoke-TemplateDeploymentWithRetry @preparationInput
    Assert-PreparationTracking -Result $preparationResult

    $outputLines = @(
        foreach ($name in $trackingNames) {
            '{0}={1}' -f $name, (ConvertTo-Json -InputObject $preparationResult[$name] -Compress -Depth 5)
        }
        'deploymentAttempts={0}' -f $preparationResult.DeploymentAttempts
    )
    Add-Content -LiteralPath $GitHubOutputPath -Value $outputLines -Encoding utf8 -ErrorAction Stop

    if ($preparationResult.Contains('exception')) {
        if (-not $RetryInput.DoNotThrow) {
            if ($preparationResult.ErrorRecord -is [System.Management.Automation.ErrorRecord]) {
                throw $preparationResult.ErrorRecord
            }
            throw $preparationResult.exception
        }
        return $preparationResult
    }
    if ($preparationResult.ResourceLocation -isnot [string] -or [string]::IsNullOrWhiteSpace($preparationResult.ResourceLocation)) {
        throw 'Dependency preparation did not return its selected resource location.'
    }

    $deploymentInput = Copy-PreparationDictionary -Dictionary $RetryInput
    $deploymentInput.TemplateInput = Copy-PreparationDictionary -Dictionary $RetryInput.TemplateInput
    $deploymentInput.TemplateInput.AdditionalParameters = Copy-PreparationDictionary -Dictionary $RetryInput.TemplateInput.AdditionalParameters
    $deploymentInput.TemplateInput.AdditionalParameters[$PreparationParameter] = $false
    if ([string]::IsNullOrWhiteSpace($deploymentInput.CustomLocation) -and
        [string]::IsNullOrWhiteSpace($deploymentInput.TokenResourceLocation) -and
        [string]::IsNullOrWhiteSpace($deploymentInput.TemplateInput.AdditionalParameters.resourceLocation)) {
        # Retained dependencies must not be relocated by a fresh automatic region selection.
        $deploymentInput.CustomLocation = $preparationResult.ResourceLocation
    }

    Start-Sleep -Seconds 15
    $deploymentResult = Invoke-TemplateDeploymentWithRetry @deploymentInput
    Assert-PreparationTracking -Result $deploymentResult
    $result = Copy-PreparationDictionary -Dictionary $deploymentResult
    foreach ($name in $trackingNames) {
        $result[$name] = @(@($preparationResult[$name]) + @($deploymentResult[$name]) | Select-Object -Unique)
    }
    $result.DeploymentAttempts = [int] ($preparationResult.DeploymentAttempts + $deploymentResult.DeploymentAttempts)
    return $result
}
