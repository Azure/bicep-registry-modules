
<#
.SYNOPSIS
Bulk delete all deployments on the given management group scope

.DESCRIPTION
Bulk delete all deployments on the given management group scope

.PARAMETER ManagementGroupId
Mandatory. The Resource ID of the Management Group to remove the deployments from.

.PARAMETER DeploymentStatusToExclude
Optional. The status to exlude from removals. Can be multiple. By default, we exclude any deployment that is in state 'running' or 'failed'.

.PARAMETER maxDeploymentRetentionInDays
Optional. The time to keep deployments with a status to exclude. In other words, if a deployment is in a status to exclude, but older than the threshold, it will be deleted.

.EXAMPLE
Clear-ManagementGroupDeploymentHistory -ManagementGroupId 'MyManagementGroupId'

Bulk remove all 'non-running' & 'non-failed' deployments from the Management Group with ID 'MyManagementGroupId'

.EXAMPLE
Clear-ManagementGroupDeploymentHistory -ManagementGroupId 'MyManagementGroupId' -DeploymentStatusToExclude @('running')

Bulk remove all 'non-running' deployments from the Management Group with ID 'MyManagementGroupId'
#>
function Clear-ManagementGroupDeploymentHistory {


    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [string[]] $DeploymentStatusToExclude = @('running', 'failed'),

        [Parameter(Mandatory = $false)]
        [int] $maxDeploymentRetentionInDays = 14
    )

    # Load helper functions
    . (Join-Path (Split-Path $PSScriptRoot) 'helper' 'Split-Array.ps1')

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # Enables web reponse
    $deploymentThreshold = (Get-Date).AddDays(-1 * $maxDeploymentRetentionInDays)

    $getInputObject = @{
        Method  = 'GET'
        Uri     = "https://management.azure.com/providers/Microsoft.Management/managementGroups/$ManagementGroupId/providers/Microsoft.Resources/deployments/?api-version=2021-04-01"
        Headers = @{
            Authorization = 'Bearer {0}' -f ((Get-AzAccessToken -AsSecureString).Token | ConvertFrom-SecureString -AsPlainText)
        }
    }
    try {
        $response = Invoke-RestMethod @getInputObject
    } catch {
        Write-Warning "Management Group [$ManagementGroupId] not found or not authorized. Skipping removal."
        return
    }

    if (($response | Get-Member -MemberType 'NoteProperty').Name -notcontains 'value') {
        throw ('Fetching deployments failed with error [{0}]' -f ($reponse | Out-String))
    }

    Write-Verbose ('Found [{0}] deployments in management group [{1}]' -f $response.value.Count, $ManagementGroupId) -Verbose

    $relevantDeployments = $response.value | Where-Object {
        $_.properties.provisioningState -notin $DeploymentStatusToExclude -or
        ([DateTime]$_.properties.timestamp) -lt $deploymentThreshold -and
        $_.properties.provisioningState -ne 'running' # we should never delete 'running' deployments
    }

    Write-Verbose ('Filtering [{0}] deployments out as they are in state [{1}] or newer than [{2}] days ({3})' -f ($response.value.Count - $relevantDeployments.Count), ($DeploymentStatusToExclude -join '/'), $maxDeploymentRetentionInDays, $deploymentThreshold.ToString('yyyy-MM-dd')) -Verbose

    if (-not $relevantDeployments) {
        Write-Verbose 'No deployments found' -Verbose
        return
    }

    $rawDeploymentChunks = Split-Array -InputArray $relevantDeployments -SplitSize 100
    if ($relevantDeployments.Count -le 100) {
        $relevantDeploymentChunks = , $rawDeploymentChunks
    } else {
        $relevantDeploymentChunks = $rawDeploymentChunks
    }

    Write-Verbose ('Triggering the removal of [{0}] deployments from management group [{1}]' -f $relevantDeployments.Count, $ManagementGroupId) -Verbose

    foreach ($deployments in $relevantDeploymentChunks) {

        $requests = $deployments | ForEach-Object {
            @{ httpMethod            = 'DELETE'
                name                 = (New-Guid).Guid # Each batch request needs a unique ID
                requestHeaderDetails = @{
                    commandName = 'HubsExtension.Microsoft.Resources/deployments.BulkDelete.execute'
                }
                url                  = '/providers/Microsoft.Management/managementGroups/{0}/providers/Microsoft.Resources/deployments/{1}?api-version=2019-08-01' -f $ManagementGroupId, $_.name
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
            } | ConvertTo-Json -Depth 4
        }
        if ($PSCmdlet.ShouldProcess(('Removal of [{0}] deployments' -f $requests.Count), 'Request')) {
            $null = Invoke-RestMethod @removeInputObject
        }
    }
    Write-Verbose 'Script execution finished. Note that the removal can take a few minutes to propagate.' -Verbose
}
