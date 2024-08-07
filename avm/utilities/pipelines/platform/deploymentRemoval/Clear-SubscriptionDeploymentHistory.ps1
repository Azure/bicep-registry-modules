
<#
.SYNOPSIS
Bulk delete all deployments on the given subscription scope

.DESCRIPTION
Bulk delete all deployments on the given subscription scope

.PARAMETER subscriptionId
Optional. The ID of the subscription to remove the deployments from. Defaults to the current context.

.PARAMETER DeploymentStatusToExclude
Optional. The status to exlude from removals. Can be multiple. By default, we exclude any deployment that is in state 'running' or 'failed'.

.PARAMETER maxDeploymentRetentionInDays
Optional. The time to keep deployments with a status to exclude. In other words, if a deployment is in a status to exclude, but older than the threshold, it will be deleted.

.EXAMPLE
Clear-SubscriptionDeploymentHistory -subscriptionId '11111111-1111-1111-1111-111111111111'

Bulk remove all 'non-running' & 'non-failed' deployments from the subscription with ID '11111111-1111-1111-1111-111111111111'

.EXAMPLE
Clear-SubscriptionDeploymentHistory -subscriptionId '11111111-1111-1111-1111-111111111111' -DeploymentStatusToExclude @('running')

Bulk remove all 'non-running' deployments from the subscription with ID '11111111-1111-1111-1111-111111111111'
#>
function Clear-SubscriptionDeploymentHistory {


    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $subscriptionId = (Get-AzContext).Subscription.Id,

        [Parameter(Mandatory = $false)]
        [string[]] $DeploymentStatusToExclude = @('running', 'failed'),

        [Parameter(Mandatory = $false)]
        [int] $maxDeploymentRetentionInDays = 14
    )

    # Load helper functions
    . (Join-Path (Split-Path $PSScriptRoot) 'helper' 'Split-Array.ps1')

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # Enables web reponse
    $deploymentThreshold = (Get-Date).AddDays(-1 * $maxDeploymentRetentionInDays)

    # Setting context explicitely in case the principal has permissions on multiple
    Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
    $null = Set-AzContext -Subscription $subscriptionId

    $getInputObject = @{
        Method  = 'GET'
        Uri     = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.Resources/deployments?api-version=2020-06-01"
        Headers = @{
            Authorization = 'Bearer {0}' -f ((Get-AzAccessToken -AsSecureString).Token | ConvertFrom-SecureString -AsPlainText)
        }
    }
    $response = Invoke-RestMethod @getInputObject

    if (($response | Get-Member -MemberType 'NoteProperty').Name -notcontains 'value') {
        throw ('Fetching deployments failed with error [{0}]' -f ($reponse | Out-String))
    }

    Write-Verbose ('Found [{0}] deployments in subscription [{1}]' -f $response.value.Count, $subscriptionId) -Verbose

    $relevantDeployments = $response.value | Where-Object {
        $_.properties.provisioningState -notin $DeploymentStatusToExclude -or
        ([DateTime]$_.properties.timestamp) -lt $deploymentThreshold -and
        $_.properties.provisioningState -ne 'running' # we should never delete 'running' deployments
    }

    Write-Verbose ('Filtering [{0}] deployments out as they are in state [{1}] or newer than [{2}] days ({3})' -f ($response.value.Count - $relevantDeployments.Count), ($DeploymentStatusToExclude -join '/'), $maxDeploymentRetentionInDays, $deploymentThreshold.ToString('yyyy-MM-dd')) -Verbose

    if (-not $relevantDeployments) {
        Write-Verbose ('No deployments for subscription [{0}] found' -f $subscriptionId) -Verbose
        return
    }

    $rawDeploymentChunks = Split-Array -InputArray $relevantDeployments -SplitSize 100
    if ($relevantDeployments.Count -le 100) {
        $relevantDeploymentChunks = , $rawDeploymentChunks
    } else {
        $relevantDeploymentChunks = $rawDeploymentChunks
    }

    Write-Verbose ('Triggering the removal of [{0}] deployments from subscription [{1}]' -f $relevantDeployments.Count, $subscriptionId) -Verbose

    foreach ($deployments in $relevantDeploymentChunks) {

        $requests = $deployments | ForEach-Object {
            @{ httpMethod            = 'DELETE'
                name                 = (New-Guid).Guid # Each batch request needs a unique ID
                requestHeaderDetails = @{
                    commandName = 'HubsExtension.Microsoft.Resources/deployments.BulkDelete.execute'
                }
                url                  = '/subscriptions/{0}/providers/Microsoft.Resources/deployments/{1}?api-version=2019-08-01' -f $subscriptionId, $_.name
            }
        }

        if ($requests -is [hashtable]) {
            $requests = , $requests
        }

        $removeInputObject = @{
            Method  = 'POST'
            Uri     = 'https://management.azure.com/batch?api-version=2020-06-01'
            Headers = @{
                Authorization  = 'Bearer {0}' -f ((Get-AzAccessToken -AsSecureString).Token | ConvertFrom-SecureString -AsPlainText)
                'Content-Type' = 'application/json'
            }
            Body    = @{
                requests = $requests
            } | ConvertTo-Json -Depth 4 -EnumsAsStrings
        }
        if ($PSCmdlet.ShouldProcess(('Removal of [{0}] deployments' -f $requests.Count), 'Request')) {
            $null = Invoke-RestMethod @removeInputObject
        }
    }
    Write-Verbose 'Script execution finished. Note that the removal can take a few minutes to propagate.' -Verbose
}
