<#
.SYNOPSIS
Prefer CI_ names over CI__ names already matched to the same parameter and source.
Returns all names in the winning prefix so callers can detect remaining ambiguity.
#>
function Select-CIParameterAlias {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Name
    )

    $readableNames = @($Name | Where-Object {
            -not $_.StartsWith('CI__', [System.StringComparison]::OrdinalIgnoreCase)
        })
    if ($readableNames.Count -gt 0) {
        return $readableNames
    }
    return $Name
}
