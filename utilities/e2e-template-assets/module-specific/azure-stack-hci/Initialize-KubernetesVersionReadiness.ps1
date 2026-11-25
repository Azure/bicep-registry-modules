param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $CustomLocationResourceId,
    [Parameter(Mandatory = $false)]
    [System.Version] $KubernetesVersion = '0.0.0',
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string] $OSSku = 'CBLMariner',
    [Parameter(Mandatory = $false)]
    [ValidateRange(0, [int]::MaxValue)]
    [int] $RetryInterval = 60,
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, [int]::MaxValue)]
    [int] $MaxRetryCount = 30
)

$ErrorActionPreference = 'Stop'
$DeploymentScriptOutputs = @{}

function Invoke-AzureWebRequest {
    param (
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'PUT')]
        [string] $Method,
        [Parameter(Mandatory)]
        [uri] $Uri,
        [string] $Body,
        [switch] $AllowNotFound
    )

    $request = @{
        Method             = $Method
        Uri                = $Uri
        Authentication     = 'Bearer'
        Token              = (Get-AzAccessToken -AsSecureString).Token
        SkipHttpErrorCheck = $true
        TimeoutSec         = 30
    }
    if ($Body) {
        $request.ContentType = 'application/json;charset=utf-8'
        $request.Body = $Body
    }
    $response = Invoke-WebRequest @request
    if ($AllowNotFound -and $Method -eq 'GET' -and $response.StatusCode -eq 404) {
        return $null
    }
    $expectedStatusCodes = if ($Method -eq 'GET') { @(200) } else { @(200, 201) }
    if ($response.StatusCode -notin $expectedStatusCodes) {
        throw "Kubernetes version $Method failed with HTTP $($response.StatusCode): $($response.Content)"
    }
    try {
        $content = ConvertFrom-Json -InputObject $response.Content -AsHashtable -ErrorAction Stop
    } catch {
        throw "Kubernetes version $Method returned malformed JSON: $($_.Exception.Message)"
    }
    if ($content -isnot [System.Collections.IDictionary]) {
        throw "Kubernetes version $Method did not return a JSON object."
    }

    $operationUri = $null
    if ($response.Headers['Azure-AsyncOperation']) {
        $operationUri = [uri] (@($response.Headers['Azure-AsyncOperation'])[0])
        if (-not $operationUri.IsAbsoluteUri -or $operationUri.Scheme -ne 'https' -or $operationUri.Authority -ne $Uri.Authority) {
            throw 'Kubernetes version refresh returned an invalid Azure-AsyncOperation URI.'
        }
    }
    return @{
        Content      = $content
        OperationUri = $operationUri
    }
}

function Get-KubernetesResponseState {
    param (
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Content,
        [switch] $Operation
    )

    $state = if ($Operation) { $Content.status } else { $Content.properties.provisioningState }
    if ($state -in @('Failed', 'Canceled', 'Cancelled')) {
        throw "Kubernetes version refresh entered [$state]: $($Content | ConvertTo-Json -Depth 20 -Compress)"
    }
    if ($state -notin @('Succeeded', 'Accepted', 'Pending', 'Creating', 'Updating', 'Provisioning', 'InProgress')) {
        throw "Kubernetes version response has missing or unknown provisioning state [$state]."
    }
    return $state
}

function Get-KubernetesVersionReadiness {
    param (
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Content,
        [Parameter(Mandatory)]
        [System.Version] $Version,
        [Parameter(Mandatory)]
        [string] $OSSku
    )

    $minorVersions = $Content.properties.values
    if ($minorVersions -isnot [array] -or $minorVersions.Count -eq 0) {
        throw 'Kubernetes version catalog has no minor versions.'
    }
    $patches = @{}
    $minors = @{}
    foreach ($minor in $minorVersions) {
        if ($minor -isnot [System.Collections.IDictionary] -or $minor.version -notmatch '^\d+\.\d+$') {
            throw 'Kubernetes version catalog contains a malformed minor version.'
        }
        if ($minors.ContainsKey($minor.version)) {
            throw "Kubernetes version catalog contains duplicate minor [$($minor.version)]."
        }
        $minors[$minor.version] = $true
        if ($minor.Contains('isPreview') -and $minor.isPreview -isnot [bool]) {
            throw "Kubernetes minor [$($minor.version)] has malformed preview metadata."
        }
        if ($Version -eq [version] '0.0.0' -and $minor.isPreview -eq $true) {
            continue
        }
        if ($minor.patchVersions -isnot [System.Collections.IDictionary] -or $minor.patchVersions.Count -eq 0) {
            throw "Kubernetes minor [$($minor.version)] has no patch versions."
        }
        foreach ($patch in $minor.patchVersions.GetEnumerator()) {
            if ($patch.Key -notmatch '^\d+\.\d+\.\d+$' -or ([version] $patch.Key).ToString(2) -ne $minor.version) {
                throw "Kubernetes minor [$($minor.version)] contains invalid patch [$($patch.Key)]."
            }
            $patches[$patch.Key] = $patch.Value
        }
    }

    if ($patches.Count -eq 0) {
        throw 'Kubernetes version catalog has no stable patch versions.'
    }
    $selectedVersion = if ($Version -eq [version] '0.0.0') {
        $patches.Keys | Sort-Object { [version] $_ } -Descending | Select-Object -First 1
    } else {
        $Version.ToString(3)
    }
    if (-not $patches.ContainsKey($selectedVersion)) {
        throw "Kubernetes version [$selectedVersion] is unsupported. Available versions: $(($patches.Keys | Sort-Object { [version] $_ }) -join ', ')."
    }
    $patch = $patches[$selectedVersion]
    if ($patch -isnot [System.Collections.IDictionary] -or $patch.readiness -isnot [array]) {
        throw "Kubernetes version [$selectedVersion] has malformed readiness metadata."
    }
    $readiness = @($patch.readiness | Where-Object { $_.osType -eq 'Linux' -and $_.osSku -eq $OSSku })
    if ($readiness.Count -ne 1 -or $readiness[0].ready -isnot [bool]) {
        throw "Kubernetes version [$selectedVersion] must have exactly one Boolean Linux/$OSSku readiness record."
    }
    return @{
        Version = $selectedVersion
        Ready   = $readiness[0].ready
        Detail  = $readiness[0].errorMessage
    }
}

if ($KubernetesVersion.Build -lt 0 -or $KubernetesVersion.Revision -ge 0) {
    throw 'KubernetesVersion must be a complete major.minor.patch version.'
}

$url = [uri] "https://management.azure.com${CustomLocationResourceId}/providers/Microsoft.HybridContainerService/kubernetesVersions/default?api-version=2024-01-01"
$body = @{ extendedLocation = @{ type = 'CustomLocation'; name = $CustomLocationResourceId } } | ConvertTo-Json -Compress
$refreshStarted = $false
$operationUri = $null
$lastStatus = 'A fresh Kubernetes version catalog is required.'

for ($attempt = 1; $attempt -le $MaxRetryCount; $attempt++) {
    $refreshRequired = $false
    if ($operationUri) {
        $response = Invoke-AzureWebRequest -Method GET -Uri $operationUri
        $state = Get-KubernetesResponseState -Content $response.Content -Operation
        $lastStatus = "Kubernetes version refresh operation is [$state]."
        if ($state -eq 'Succeeded') {
            $operationUri = $null
        }
    } else {
        $response = Invoke-AzureWebRequest -Method GET -Uri $url -AllowNotFound
        if (-not $response) {
            $refreshRequired = -not $refreshStarted
            $lastStatus = 'Kubernetes version catalog is not yet available.'
        } else {
            $state = Get-KubernetesResponseState -Content $response.Content
            if ($state -eq 'Succeeded') {
                if ($refreshStarted) {
                    $readiness = Get-KubernetesVersionReadiness -Content $response.Content -Version $KubernetesVersion -OSSku $OSSku
                    if ($readiness.Ready) {
                        $DeploymentScriptOutputs = @{ kubernetesVersion = $readiness.Version }
                        Write-Information "Kubernetes version [$($readiness.Version)] is ready for Linux/$OSSku." -InformationAction Continue
                        return
                    }
                    $lastStatus = "Kubernetes version [$($readiness.Version)] is not ready for Linux/${OSSku}: $($readiness.Detail)"
                }
                # GET can return a completed, cached snapshot; PUT requests fresh readiness.
                $refreshRequired = $true
            } else {
                # Do not submit another PUT while the current refresh is still provisioning.
                $refreshStarted = $true
                $lastStatus = "Kubernetes version catalog is [$state]."
            }
        }

        if ($refreshRequired -and $attempt -lt $MaxRetryCount) {
            $response = Invoke-AzureWebRequest -Method PUT -Uri $url -Body $body
            $null = Get-KubernetesResponseState -Content $response.Content
            $operationUri = $response.OperationUri
            $refreshStarted = $true
        }
    }

    Write-Information "Attempt $attempt/${MaxRetryCount}: $lastStatus" -InformationAction Continue
    if ($attempt -lt $MaxRetryCount) {
        Start-Sleep -Seconds $RetryInterval
    }
}

throw "Kubernetes version readiness exhausted $MaxRetryCount attempts. $lastStatus"
