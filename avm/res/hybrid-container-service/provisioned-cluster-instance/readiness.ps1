param (
    [string] $customLocationResourceId,
    [string] $kubernetesVersion = '',
    [string] $osSku
)

$ErrorActionPreference = 'Stop'
Invoke-WebRequest -Uri 'https://aka.ms/InstallAzureCLIDeb' -UseBasicParsing | bash
az --version

while ($true) {
    if (`$env:ACTIONS_ID_TOKEN_REQUEST_TOKEN) {
        $resp = Invoke-WebRequest -Uri "`$env:ACTIONS_ID_TOKEN_REQUEST_URL&audience=api://AzureADTokenExchange" -Headers @{'Authorization' = "bearer `$env:ACTIONS_ID_TOKEN_REQUEST_TOKEN" }
        $token = (Write-Output $resp.Content | ConvertFrom-Json).value

        az login --federated-token $token --tenant `$env:ARM_TENANT_ID -u `$env:ARM_CLIENT_ID --service-principal
        az account set --subscription `$env:ARM_SUBSCRIPTION_ID
    }
    # delete the default version to avoid unsynchronized state between ARM and on-prem
    $accessToken = $(az account get-access-token --query accessToken)
    $url = "https://management.azure.com${customLocationResourceId}/providers/Microsoft.HybridContainerService/kubernetesVersions/default?api-version=2024-01-01"
    Write-Output "Deleting default version to keep sync: $url"
    az rest --headers "Authorization=Bearer $accessToken" 'Content-Type=application/json;charset=utf-8' --uri $url --method DELETE
    while ($true) {
        $state = az rest --headers "Authorization=Bearer $accessToken" 'Content-Type=application/json;charset=utf-8' --uri $url --method GET
        if (-not $state) {
            break
        }
        Start-Sleep 5
    }

    Write-Host 'After deleting, puting...'
    $requestBody = '{\"extendedLocation\":{\"type\":\"CustomLocation\",\"name\":\"$customLocationResourceId\"}}'.Replace('$customLocationResourceId', $customLocationResourceId)
    az rest --headers "Authorization=Bearer $accessToken" 'Content-Type=application/json;charset=utf-8' `
        --uri $url `
        --method PUT `
        --body $requestBody

    Start-Sleep 60
    Write-Output 'Getting versions'
    $state = az rest --headers "Authorization=Bearer $accessToken" 'Content-Type=application/json;charset=utf-8' --uri $url --method GET
    $state = "$state".Replace("`n", '').Replace("`r", '').Replace("`t", '').Replace(' ', '')
    Write-Output $state

    $pos = $state.IndexOf('{')
    $state = $state.Substring($pos)
    $quotePos = $state.IndexOf('"')

    # Workaround for warning messages in the CLI
    if ($quotePos -gt 1) {
        Write-Output 'workaround for warning messages in the CLI'
        $state = $state.Substring($quotePos)
        $state = "{$state"
    }
    $ready = $false

    # Default to the latest version
    if ($kubernetesVersion -eq '[PLACEHOLDER]') {
        $json = $state | ConvertFrom-Json
        $latestPatchVersion = $json.properties.values |
            ForEach-Object {
                $_.patchVersions.PSObject.Properties |
                    ForEach-Object {
                        [PSCustomObject]@{
                            Version = [version]$_.Name
                            Patch   = $_.Name
                        }
                    }
                } | Sort-Object Version -Descending | Select-Object -First 1

        Write-Verbose "Using kubernetes version = $($latestPatchVersion.Patch)" -Verbose
        $kubernetesVersion = $latestPatchVersion.Patch
    }

    foreach ($version in (Write-Output $state | ConvertFrom-Json).properties.values) {
        if (!$kubernetesVersion.StartsWith($version.version)) {
            continue
        }

        if ($version.patchVersions.PSobject.Properties.name -notcontains $kubernetesVersion) {
            break
        }

        foreach ($readiness in $version.patchVersions.$kubernetesVersion.readiness) {
            if ($readiness.osSku -eq $osSku) {
                $ready = $readiness.ready
            }
        }
    }

    if ($ready) {
        Write-Output "Kubernetes version $kubernetesVersion is ready for osSku $osSku."
        break
    }

    Write-Output "Kubernetes version $kubernetesVersion is not ready yet for osSku $osSku. Retrying in 10 seconds."
    Start-Sleep 10
}
