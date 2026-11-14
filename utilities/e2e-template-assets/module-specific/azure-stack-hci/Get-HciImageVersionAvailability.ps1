function Get-HciImageVersionAvailability {
    [CmdletBinding()]
    param (
        [Parameter()]
        [AllowNull()]
        [object] $ImageVersionResource,

        [Parameter(Mandatory)]
        [string[]] $RequiredRegions
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $canWait = $true
    if ($null -eq $ImageVersionResource) {
        $issues.Add('Version not found.')
    } else {
        $properties = $ImageVersionResource.properties
        $provisioningState = [string] $properties.provisioningState
        if ($provisioningState -ne 'Succeeded') {
            $issues.Add("Provisioning state [$provisioningState].")
            $canWait = $provisioningState -in @('Creating', 'Updating')
        }
        if ($properties.publishingProfile.excludeFromLatest -eq $true) {
            $issues.Add('Version is excluded from latest.')
            $canWait = $false
        }
        foreach ($region in $RequiredRegions) {
            $targets = @($properties.publishingProfile.targetRegions | Where-Object {
                ([string] $_.name).Replace(' ', '').ToLowerInvariant() -eq $region
            })
            if ($targets.Count -ne 1) {
                $issues.Add("Region [$region] is missing or duplicated in publishingProfile.targetRegions.")
                $canWait = $false
                continue
            }
            $replicas = @($properties.replicationStatus.summary | Where-Object {
                ([string] $_.region).Replace(' ', '').ToLowerInvariant() -eq $region
            })
            if ($replicas.Count -ne 1) {
                $issues.Add("Region [$region] has no unambiguous replication status.")
                continue
            }
            if ($replicas[0].state -ne 'Completed') {
                $replicaDetails = if ($replicas[0].PSObject.Properties.Name -contains 'details') { $replicas[0].details } else { '' }
                $issues.Add("Region [$region] replication state [$($replicas[0].state)]. $replicaDetails")
                if ($replicas[0].state -eq 'Failed') {
                    $canWait = $false
                }
            }
        }
    }
    return [pscustomobject] @{
        Ready   = $issues.Count -eq 0
        CanWait = $canWait
        Details = $issues -join ' '
    }
}
