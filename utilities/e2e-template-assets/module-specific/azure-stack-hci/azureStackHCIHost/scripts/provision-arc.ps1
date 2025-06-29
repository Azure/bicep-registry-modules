# TODO: no try, try outside

param(
    [Parameter(Mandatory = $true)]
    [string]$IP, # or name
    [Parameter(Mandatory = $false)]
    [int]$Port = 5985,
    [Parameter(Mandatory = $false)]
    [string]$Authentication = 'Default',
    [Parameter(Mandatory = $true)]
    [string]$LocalAdministratorAccount, # TODO: local admin only
    [Parameter(Mandatory = $true)]
    [string]$LocalAdministratorPassword,
    [Parameter(Mandatory = $true)]
    [string]$ServicePrincipalId,
    [Parameter(Mandatory = $true)]
    [string]$ServicePrincipalSecret,
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,
    [Parameter(Mandatory = $true)]
    [string]$TenantId,
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]$Region
)

$script:ErrorActionPreference = 'Stop'

try {
    $username = ".\$LocalAdministratorAccount"
    $securePassword = ConvertTo-SecureString $LocalAdministratorPassword -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePassword
    $session = New-PSSession -ComputerName $IP -Port $Port -Authentication $Authentication -Credential $credential

    Invoke-Command -Session $session -ScriptBlock {
        $machineName = [System.Net.Dns]::GetHostName()
        $correlationID = New-Guid
        $secureServicePrincipalSecret = ConvertTo-SecureString $Using:ServicePrincipalSecret -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential -ArgumentList $Using:ServicePrincipalId, $secureServicePrincipalSecret
        Connect-AzAccount -ServicePrincipal -Credential $credential -Subscription $Using:SubscriptionId -Tenant $Using:TenantId
        $secureToken = (Get-AzAccessToken -AsSecureString).Token
        $token = [Net.NetworkCredential]::new('', $secureToken).Password

        $azcmagentPath = "$env:ProgramW6432\AzureConnectedMachineAgent\azcmagent.exe"
        & "$azcmagentPath" --version
        & "$azcmagentPath" connect --resource-group "$Using:ResourceGroupName" --resource-name "$machineName" --tenant-id "$Using:TenantId" --location "$Using:Region" --subscription-id "$Using:SubscriptionId" --cloud 'AzureCloud' --correlation-id "$correlationID" --access-token "$token";
        if ($LASTEXITCODE -ne 0) {
            throw 'Arc server connection failed'
        }

        # TODO: work around
        Get-NetAdapter StorageA | Disable-NetAdapter -Confirm:$false
        Get-NetAdapter StorageB | Disable-NetAdapter -Confirm:$false

        Write-Output 'PUT edge device resource to install mandatory extensions'
        $uri = "https://management.azure.com/subscriptions/$Using:SubscriptionId/resourceGroups/$Using:ResourceGroupName/providers/Microsoft.HybridCompute/machines/$machineName/providers/Microsoft.AzureStackHCI/edgeDevices/default?api-version=2024-04-01"
        $body = @{
            'kind'       = 'HCI';
            'properties' = @{};
        }
        $headers = @{
            'Authorization' = "Bearer $token";
        }
        Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body ($body | ConvertTo-Json) -ContentType 'application/json'

        Write-Output 'Waiting for Edge device resource to be ready'
        Start-Sleep -Seconds 600
        $waitInterval = 60
        $maxWaitCount = 30
        $ready = $false
        for ($waitCount = 0; $job.JobState -ne 'Transferred' -and $waitCount -lt $maxWaitCount; $waitCount++) {
            Connect-AzAccount -ServicePrincipal -Credential $credential -Subscription $Using:SubscriptionId -Tenant $Using:TenantId | Out-Null
            $secureToken = (Get-AzAccessToken -AsSecureString).Token
            $token = [Net.NetworkCredential]::new('', $secureToken).Password
            $headers = @{
                'Authorization' = "Bearer $token";
            }
            try {
                $response = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers
                if ($response.properties.provisioningState -eq 'Succeeded') {
                    $ready = $true
                    break
                }
            } catch {
                Write-Output "Failed to get Edge device resource: $_"
            } finally {
                Write-Output 'Waiting for Edge device resource to be ready'
                Start-Sleep -Seconds $waitInterval
            }
        }

        # TODO: work around
        Get-NetAdapter StorageA | Enable-NetAdapter -Confirm:$false
        Get-NetAdapter StorageB | Enable-NetAdapter -Confirm:$false

        if (!$ready) {
            # TODO: is this part still retryable? unless arc can be connected multiple times
            throw 'Edge device resource is not ready after 30 minutes.'
        }
    }

    Write-Output 'Arc server connected and all mandatory extensions are ready!'
} catch {
    Write-Error $_
} finally {
    if ($session) {
        Remove-PSSession -Session $session
    }
}
