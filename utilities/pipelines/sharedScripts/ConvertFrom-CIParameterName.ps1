<#
.SYNOPSIS
Decode a GitHub CI input name. CI_ ignores underscores; CI__ preserves them.
Unrelated names and the reserved CI_KEY_VAULT_NAME selector return no parameter name.
#>
function ConvertFrom-CIParameterName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Name
    )

    if ($Name -ieq 'CI_KEY_VAULT_NAME') {
        return $null
    }
    if ($Name.StartsWith('CI__', [System.StringComparison]::OrdinalIgnoreCase)) {
        return $Name.Substring(4)
    }
    if ($Name.StartsWith('CI_', [System.StringComparison]::OrdinalIgnoreCase)) {
        return $Name.Substring(3).Replace('_', '')
    }
    return $null
}
