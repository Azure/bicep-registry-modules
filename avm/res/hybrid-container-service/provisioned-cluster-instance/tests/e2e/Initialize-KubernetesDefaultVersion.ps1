param (
    [Parameter(Mandatory = $true)]
    [string] $CustomLocationResourceId,
    [Parameter(Mandatory = $false)]
    [System.Version] $KubernetesVersion = '0.0.0',
    [Parameter(Mandatory = $false)]
    [string] $OSSku = 'CBLMariner',
    [Parameter(Mandatory = $false)]
    [int]$RetryInterval = 60,
    [Parameter(Mandatory = $false)]
    [int]$MaxRetryCount = 30
)

$ErrorActionPreference = 'Stop';

Add-Type -AssemblyName Microsoft.PowerShell.Commands.Utility;

function Invoke-AzureWebRequest {
    param(
        [Parameter(Mandatory = $false)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = 'GET',
        [Parameter(Mandatory = $true)]
        [Uri]$Uri,
        [Parameter(Mandatory = $false)]
        [string]$Body = '',
        [Parameter(Mandatory = $false)]
        [int]$RetryInterval = 60,
        [Parameter(Mandatory = $false)]
        [int]$MaxRetryCount = 2,
        [Parameter(Mandatory = $false)]
        [switch]$Expect404,
        [Parameter(Mandatory = $false)]
        [switch]$WaitFor404,
        [Parameter(Mandatory = $false)]
        [switch]$WaitFor200
    )

    $token = (Get-AzAccessToken -AsSecureString).Token;
    for ($attempt = 0; $attempt -lt $MaxRetryCount; $attempt++) {
        try {
            if ($Body -eq '') {
                Invoke-WebRequest -Method $Method -Uri $Uri -Authentication Bearer -Token $token | ConvertFrom-Json | Tee-Object -Variable response;
            } else {
                Invoke-WebRequest -Method $Method -Uri $Uri -Authentication Bearer -Token $token -ContentType 'application/json;charset=utf-8' -Body $Body | ConvertFrom-Json | Tee-Object -Variable response;
            }
            if ($WaitFor404) {
                Start-Sleep -Seconds $RetryInterval;
                continue;
            } else {
                $response.Content;
                break;
            }
        } catch {
            if ($_.Exception.Response.StatusCode -eq 401) {
                Write-Output '401';
                $token = (Get-AzAccessToken -AsSecureString).Token;
                continue;
            } elseif ($_.Exception.Response.StatusCode -eq 404) {
                Write-Output '404';
                if ($Expect404 -or $WaitFor404) {
                    break;
                } elseif ($waitFor200) {
                    Start-Sleep -Seconds $RetryInterval;
                    continue;
                } else {
                    throw;
                }
            } else {
                throw;
            }
        }
    }
    if ($attempt -eq $MaxRetryCount) {
        throw 'Attempts exhausted.';
    }
}

$url = "https://management.azure.com${CustomLocationResourceId}/providers/Microsoft.HybridContainerService/kubernetesVersions/default?api-version=2024-01-01";

Invoke-AzureWebRequest -Method DELETE -Uri $url -Expect404;
Invoke-AzureWebRequest -Method GET -Uri $url -MaxRetryCount 10 -WaitFor404;
$body = "{'extendedLocation':{'type':'CustomLocation','name':'$CustomLocationResourceId'}}";
Invoke-AzureWebRequest -Method PUT -Uri $url -MaxRetryCount 10 -Body $body;

for ($attempt = 0; $attempt -lt $MaxRetryCount; $attempt++) {
    try {
        $content = Invoke-AzureWebRequest -Method GET -Uri $url -MaxRetryCount 10 -WaitFor200;
        if ($KubernetesVersion -eq '0.0.0') {
            $content.properties.values | Sort-Object { [System.Version]$_.version } -Descending | Select-Object -First 1 -ExpandProperty patchVersions | Tee-Object -Variable minor;
        } else {
            $content.properties.values | Where-Object { $KubernetesVersion.StartsWith($_.version) } | Select-Object -ExpandProperty patchVersions | Tee-Object -Variable minor;
        }
        if ($minor.Count -ne 1) {
            throw 'Minor Version is not found.';
        }
        if ($KubernetesVersion -eq '0.0.0') {
            $minor[0].PSObject.Properties | Sort-Object { [System.Version]$_.Name } -Descending | Select-Object -First 1 | Tee-Object -Variable patch;
        } else {
            $minor[0].PSObject.Properties | Where-Object { $KubernetesVersion -eq $_.Name } | Tee-Object -Variable patch;
        }
        if ($patch.Count -ne 1) {
            throw 'Patch Version is not found.';
        }
        $patch.Value.readiness | Where-Object { $_.osSku -eq $OSSku -and $_.ready } | Tee-Object -Variable found;
        if ($found.Count -gt 0) {
            break;
        } else {
            throw 'Patch Version is not ready.';
        }
    } catch {
        Write-Output $_;
        if ($attempt -ge $MaxRetryCount) {
            throw;
        }
        Start-Sleep -Seconds $RetryInterval;
    }
}
