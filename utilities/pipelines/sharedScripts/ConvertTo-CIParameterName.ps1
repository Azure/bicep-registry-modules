<#
.SYNOPSIS
Create a readable GitHub CI_ name, or a CI__ name when literal spelling is needed.
#>
function ConvertTo-CIParameterName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('^[A-Za-z_][A-Za-z0-9_]*$')]
        [string] $ParameterName
    )

    if ($ParameterName.Contains('_')) {
        return 'CI__{0}' -f $ParameterName.ToUpperInvariant()
    }

    $words = [regex]::Replace($ParameterName, '([A-Z]+)([A-Z][a-z])', '$1_$2')
    $words = [regex]::Replace($words, '([a-z0-9])([A-Z])', '$1_$2')
    $name = 'CI_{0}' -f $words.ToUpperInvariant()
    if ($name -eq 'CI_KEY_VAULT_NAME') {
        return 'CI__{0}' -f $ParameterName.ToUpperInvariant()
    }
    if ($name.Length -gt 100) {
        return 'CI_{0}' -f $ParameterName.ToUpperInvariant()
    }
    return $name
}
