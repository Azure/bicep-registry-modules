<#
.SYNOPSIS
Read optional runner-local deployment parameters and cleanup protection.

.PARAMETER FilePath
JSON file containing parameterOverrides (parameter names mapped to strings) and
protectedResourceIds (exact subscription-scoped resource IDs). An omitted file adds no data.
#>
function Get-ModuleDeploymentData {
    [CmdletBinding()]
    param ([string] $FilePath)

    $result = @{ ParameterOverrides = @{}; ProtectedResourceIds = @() }
    if ([string]::IsNullOrEmpty($FilePath)) { return $result }
    if ([string]::IsNullOrWhiteSpace($FilePath) -or -not [IO.Path]::IsPathFullyQualified($FilePath) -or
        -not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
        throw 'Deployment data must identify an existing absolute file path.'
    }
    try {
        $document = [System.Text.Json.JsonDocument]::Parse([IO.File]::ReadAllText($FilePath))
    } catch [System.Text.Json.JsonException] {
        throw 'Deployment data must be a valid JSON object.'
    }
    try {
        if ($document.RootElement.ValueKind -ne 'Object') {
            throw 'Deployment data must be a JSON object.'
        }
        $fields = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        foreach ($property in $document.RootElement.EnumerateObject()) {
            if ($property.Name -cnotin @('parameterOverrides', 'protectedResourceIds') -or -not $fields.Add($property.Name)) {
                throw 'Deployment data permits only unique parameterOverrides and protectedResourceIds fields.'
            }
            if ($property.Name -ceq 'parameterOverrides') {
                if ($property.Value.ValueKind -ne 'Object') {
                    throw 'Deployment parameter overrides must be a JSON object of string values.'
                }
                foreach ($parameter in $property.Value.EnumerateObject()) {
                    if ([string]::IsNullOrWhiteSpace($parameter.Name) -or $parameter.Name -match '[\r\n]' -or
                        $result.ParameterOverrides.ContainsKey($parameter.Name) -or $parameter.Value.ValueKind -ne 'String') {
                        throw 'Deployment parameter overrides require unique parameter names and string values.'
                    }
                    $result.ParameterOverrides[$parameter.Name] = $parameter.Value.GetString()
                }
                continue
            }
            if ($property.Value.ValueKind -ne 'Array') {
                throw 'Protected resource IDs must be a JSON array.'
            }
            $ids = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
            foreach ($item in $property.Value.EnumerateArray()) {
                if ($item.ValueKind -ne 'String') { throw 'Protected resource IDs must be strings.' }
                $id = $item.GetString()
                $subscriptionId = [guid]::Empty
                if ($id -notmatch '^/subscriptions/(?<subscription>[^/]+)/(?:resourceGroups/[^/\r\n?#]+(?:/providers/[^/\r\n?#]+(?:/[^/\r\n?#]+/[^/\r\n?#]+)+)?|providers/[^/\r\n?#]+(?:/[^/\r\n?#]+/[^/\r\n?#]+)+)$' -or
                    -not [guid]::TryParseExact($Matches.subscription, 'D', [ref] $subscriptionId) -or
                    $subscriptionId -eq [guid]::Empty -or $id -cne $id.Trim() -or
                    @($id.Split('/') | Where-Object { $_ -in @('.', '..') }).Count -gt 0 -or -not $ids.Add($id)) {
                    throw 'Cleanup protection requires unique, exact subscription-scoped resource IDs.'
                }
                $result.ProtectedResourceIds += $id
            }
        }
    } finally {
        $document.Dispose()
    }
    return $result
}

<#
.SYNOPSIS
Convert caller overrides using the same ARM type rules as ordinary CI parameters.
#>
function Resolve-ModuleDeploymentParameterOverride {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [AllowEmptyCollection()] [System.Collections.IDictionary] $ParameterOverrides,
        [Parameter(Mandatory)] [AllowEmptyCollection()] [System.Collections.IDictionary] $TemplateParameters,
        [System.Collections.IDictionary] $TemplateDefinitions = @{}
    )

    . (Join-Path $PSScriptRoot 'Get-CIParameterMap.ps1')
    $variables = @{}
    foreach ($name in $ParameterOverrides.psbase.Keys) {
        if (-not $TemplateParameters.Contains($name)) {
            throw "Deployment override targets an undeclared template parameter [$name]."
        }
        $variables["CI__$name"] = $ParameterOverrides[$name]
    }
    Get-CIParameterMap -TemplateParameters $TemplateParameters -TemplateDefinitions $TemplateDefinitions `
        -GitHubVariables ($variables | ConvertTo-Json -Depth 10 -Compress)
}
