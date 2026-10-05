param(
    [Parameter(Mandatory = $true)]
    [string]$ClusterNodeNames,

    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [int]$MaxPollAttempts = 60,

    [Parameter(Mandatory = $false)]
    [int]$PollIntervalSeconds = 60
)

$ErrorActionPreference = 'Stop'

$nodeNames = $ClusterNodeNames -split ','
Write-Output "Waiting for edge device provisioning to complete for nodes: $($nodeNames -join ', ')"
Write-Output "Resource Group: $ResourceGroupName, Subscription: $SubscriptionId"
Write-Output "Max attempts: $MaxPollAttempts, Poll interval: ${PollIntervalSeconds}s"

$allReady = $false

for ($attempt = 1; $attempt -le $MaxPollAttempts; $attempt++) {
    $allNodesReady = $true

    foreach ($nodeName in $nodeNames) {
        $uri = "https://management.azure.com/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.HybridCompute/machines/$nodeName/providers/Microsoft.AzureStackHCI/edgeDevices/default?api-version=2024-04-01"

        try {
            $token = (Get-AzAccessToken -AsSecureString).Token
            $plainToken = [System.Net.NetworkCredential]::new('', $token).Password
            $headers = @{ 'Authorization' = "Bearer $plainToken" }
            $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType 'application/json'
            $state = $response.properties.provisioningState

            Write-Output "  [$attempt/$MaxPollAttempts] Node '$nodeName' edgeDevice provisioningState: $state"

            if ($state -ne 'Succeeded') {
                $allNodesReady = $false
            }
        } catch {
            Write-Output "  [$attempt/$MaxPollAttempts] Node '$nodeName' edgeDevice query failed: $_"
            $allNodesReady = $false
        }
    }

    if ($allNodesReady) {
        $allReady = $true
        Write-Output "All edge devices are in 'Succeeded' state after $attempt attempts."
        break
    }

    if ($attempt -lt $MaxPollAttempts) {
        Write-Output "  Not all edge devices ready. Waiting ${PollIntervalSeconds}s before next poll..."
        Start-Sleep -Seconds $PollIntervalSeconds
    }
}

if (-not $allReady) {
    throw "Edge device provisioning did not complete within $MaxPollAttempts attempts ($([math]::Round($MaxPollAttempts * $PollIntervalSeconds / 60)) minutes). The cluster may still be bootstrapping. Please check the Azure Stack HCI cluster deployment status."
}

Write-Output 'Edge device provisioning complete. Cluster is ready for marketplace image deployment.'
