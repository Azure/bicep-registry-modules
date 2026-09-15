<#
.SYNOPSIS
Reject CI fixture references outside the frozen BAMI context before Azure login.

.DESCRIPTION
Checks effective CI parameters, including secure and nested values, without logging
their contents. Scoped fixtures must use a BAMI test or Persistent subscription.
Unscoped directory principal/object IDs are unsupported because their tenant cannot
be established locally. Ordinary credentials and keys are not treated as identities.
#>
function Test-BamiFixtureCompatibility {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $CIParameters,

        [Parameter(Mandatory)]
        [string] $TestSubscriptionIds,

        [Parameter(Mandatory)]
        [string] $PersistentSubscriptionId,

        [Parameter(Mandatory)]
        [string] $TenantId,

        [Parameter(Mandatory)]
        [string] $ClientId,

        [Parameter(Mandatory)]
        [string] $ManagementGroupId
    )

    . (Join-Path $PSScriptRoot 'Get-TestSubscriptionList.ps1')
    $subscriptionIds = @(
        (Get-TestSubscriptionList -TestSubscriptionIds $TestSubscriptionIds).id
        $PersistentSubscriptionId
    )
    $pending = [System.Collections.Generic.Stack[object]]::new()
    foreach ($name in $CIParameters.psbase.Keys) {
        $pending.Push(@{ Name = $name; ParameterName = $name; Value = $CIParameters[$name] })
    }

    while ($pending.Count -gt 0) {
        $item = $pending.Pop()
        $value = $item.Value
        if ($value -is [System.Collections.IDictionary]) {
            foreach ($name in $value.psbase.Keys) {
                $pending.Push(@{ Name = $name; ParameterName = $item.ParameterName; Value = $value[$name] })
            }
            continue
        }
        if ($value -is [array]) {
            foreach ($entry in $value) {
                $pending.Push(@{ Name = $item.Name; ParameterName = $item.ParameterName; Value = $entry })
            }
            continue
        }
        if ($value -is [securestring]) {
            $value = ConvertFrom-SecureString -SecureString $value -AsPlainText
        }
        if ($value -isnot [string]) {
            continue
        }

        if ($value.TrimStart() -match '^[\[{]' -and (Test-Json -Json $value -ErrorAction Ignore)) {
            $pending.Push(@{
                    Name          = $item.Name
                    ParameterName = $item.ParameterName
                    Value         = ConvertFrom-Json -InputObject $value -AsHashtable -NoEnumerate
                })
            continue
        }

        $text = $value.Replace('\/', '/')
        foreach ($match in [regex]::Matches($text, '(?i)/subscriptions/([^/\s"''?#]+)')) {
            if ($match.Groups[1].Value -notin $subscriptionIds) {
                throw "BAMI fixture parameter [$($item.ParameterName)] references a subscription outside the frozen test/Persistent context."
            }
        }
        foreach ($match in [regex]::Matches($text, '(?i)/providers/Microsoft.Management/managementGroups/([^/\s"''?#]+)')) {
            if ($match.Groups[1].Value -ne $ManagementGroupId) {
                throw "BAMI fixture parameter [$($item.ParameterName)] references a management group outside the frozen context."
            }
        }

        $name = $item.Name -replace '[_-]', ''
        $unsupported = switch -Regex ($name) {
            'tenantids?$' { $value -ne $TenantId; break }
            'subscriptionids?$' { $value -notin $subscriptionIds; break }
            'managementgroupids?$' { $value -notin @($ManagementGroupId, "/providers/Microsoft.Management/managementGroups/$ManagementGroupId"); break }
            'clientids?$' { $value -ne $ClientId; break }
            '(principal|object)ids?$' { $true; break }
            '(resource|identity)ids?$' { $value -match '^[0-9a-f-]{36}$'; break }
            default { $false }
        }
        if ($unsupported) {
            throw "BAMI fixture parameter [$($item.ParameterName)] contains an unsupported tenant-bound identifier. Configure a fixture in the selected BAMI context before enabling this module."
        }
    }
}
