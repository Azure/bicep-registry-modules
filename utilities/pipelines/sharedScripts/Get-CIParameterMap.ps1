<#
.SYNOPSIS
Resolve additional test parameters from GitHub Actions and the legacy CI Key Vault.

.DESCRIPTION
Matches GitHub names without regard to case: CI_ removes separator underscores,
while CI__ preserves literal underscores. Key Vault CI- names remain literal.
GitHub secrets override variables; Key Vault only supplies missing parameters.
Within each GitHub source, CI_ takes precedence over CI__. Multiple aliases in the
winning prefix must not target the same template parameter.
GitHub values are converted to the declared ARM parameter types.

.PARAMETER TemplateParameters
The parameters object from the compiled test template.

.PARAMETER TemplateDefinitions
The definitions object used to resolve user-defined parameter types.

.PARAMETER GitHubVariables
The JSON-serialized, resolved GitHub Actions vars context.

.PARAMETER GitHubSecrets
The JSON-serialized, resolved GitHub Actions secrets context.

.PARAMETER KeyVaultName
Optional legacy vault supplying CI- secrets for parameters not configured in GitHub.
#>
function Get-CIParameterMap {

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'GitHub Actions supplies strings; secure ARM parameters require SecureString values.')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.IDictionary] $TemplateParameters,

        [Parameter()]
        [System.Collections.IDictionary] $TemplateDefinitions = @{},

        [Parameter()]
        [string] $GitHubVariables = '{}',

        [Parameter()]
        [string] $GitHubSecrets = '{}',

        [Parameter()]
        [string] $KeyVaultName
    )

    . (Join-Path $PSScriptRoot 'ConvertFrom-CIParameterName.ps1')
    . (Join-Path $PSScriptRoot 'Select-CIParameterAlias.ps1')

    $parameterNames = @{}
    # Parameter names can shadow dictionary properties such as Keys and Count.
    foreach ($parameterName in $TemplateParameters.psbase.Keys) {
        if ($parameterNames.ContainsKey($parameterName)) {
            throw "Template parameter [$parameterName] differs from another parameter only in case and cannot be resolved from GitHub inputs."
        }
        $parameterNames[$parameterName] = $parameterName
    }

    $sources = @{
        Variables = @{ Json = $GitHubVariables; Values = @{} }
        Secrets   = @{ Json = $GitHubSecrets; Values = @{} }
    }
    foreach ($sourceName in @('Variables', 'Secrets')) {
        $source = $sources[$sourceName]
        if ([string]::IsNullOrWhiteSpace($source.Json)) {
            continue
        }

        try {
            $values = ConvertFrom-Json -InputObject $source.Json -AsHashtable -ErrorAction Stop
        } catch [System.ArgumentException] {
            throw "The GitHub $sourceName context must be a valid JSON object."
        }
        if ($values -isnot [System.Collections.IDictionary]) {
            throw "The GitHub $sourceName context must be a JSON object."
        }

        foreach ($entry in $values.GetEnumerator()) {
            $name = ConvertFrom-CIParameterName -Name $entry.Key
            if ([string]::IsNullOrEmpty($name) -or -not $parameterNames.ContainsKey($name)) {
                continue
            }
            $parameterName = $parameterNames[$name]
            if (-not $source.Values.ContainsKey($parameterName)) {
                $source.Values[$parameterName] = @()
            }
            $source.Values[$parameterName] += $entry.Key
        }

        foreach ($parameterName in @($source.Values.psbase.Keys)) {
            $names = @(Select-CIParameterAlias -Name $source.Values[$parameterName])
            if ($names.Count -gt 1) {
                throw "Multiple GitHub $sourceName names [$($names -join ', ')] in the preferred prefix map to parameter [$parameterName]."
            }
            $source.Values[$parameterName] = @{
                Name  = $names[0]
                Value = $values[$names[0]]
            }
        }
    }

    $parameters = @{}
    foreach ($parameterName in $TemplateParameters.psbase.Keys) {
        if ($sources.Secrets.Values.ContainsKey($parameterName)) {
            $entry = $sources.Secrets.Values[$parameterName]
            $isSecret = $true
        } elseif ($sources.Variables.Values.ContainsKey($parameterName)) {
            $entry = $sources.Variables.Values[$parameterName]
            $isSecret = $false
        } else {
            continue
        }
        $value = $entry.Value
        $githubName = $entry.Name

        if ($value -isnot [string]) {
            throw "The GitHub value for parameter [$parameterName] must be a string."
        }

        $definition = $TemplateParameters[$parameterName]
        $visitedDefinitions = [System.Collections.Generic.HashSet[string]]::new()
        while (-not $definition.type -and $definition.Contains('$ref')) {
            $reference = [string] $definition['$ref']
            if (-not $reference.StartsWith('#/definitions/', [System.StringComparison]::Ordinal)) {
                throw "Parameter [$parameterName] has an unsupported type reference."
            }
            $definitionName = $reference.Substring('#/definitions/'.Length).Replace('~1', '/').Replace('~0', '~')
            if (-not $TemplateDefinitions.Contains($definitionName) -or -not $visitedDefinitions.Add($definitionName)) {
                throw "Parameter [$parameterName] has an unresolved or circular type reference."
            }
            $definition = $TemplateDefinitions[$definitionName]
        }
        $parameterType = $definition.type
        if ($isSecret -and $parameterType -notin @('secureString', 'secureObject')) {
            Write-Warning "GitHub secret [$githubName] targets non-secure parameter [$parameterName]. Sensitive values require a secureString or secureObject test parameter."
        }

        switch ($parameterType) {
            'string' {
                $parameters[$parameterName] = $value
            }
            'secureString' {
                $parameters[$parameterName] = $value.Length -eq 0 ? [securestring]::new() : (ConvertTo-SecureString -String $value -AsPlainText -Force)
            }
            { $_ -in @('int', 'bool', 'array', 'object', 'secureObject') } {
                try {
                    $convertedValue = ConvertFrom-Json -InputObject $value -AsHashtable -NoEnumerate -ErrorAction Stop
                } catch [System.ArgumentException] {
                    throw "The GitHub value for parameter [$parameterName] must be valid JSON of type [$parameterType]."
                }

                $validType = switch ($parameterType) {
                    'int' { $convertedValue -is [int] -or $convertedValue -is [long] }
                    'bool' { $convertedValue -is [bool] }
                    'array' { $convertedValue -is [array] }
                    default { $convertedValue -is [System.Collections.IDictionary] }
                }
                if (-not $validType) {
                    throw "The GitHub value for parameter [$parameterName] must be JSON of type [$parameterType]."
                }
                $parameters[$parameterName] = $convertedValue
            }
            default {
                throw "Parameter [$parameterName] has unsupported ARM type [$parameterType] for GitHub CI inputs."
            }
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($KeyVaultName) -and $parameters.psbase.Count -lt $TemplateParameters.psbase.Count) {
        $vaultSecrets = Get-AzKeyVaultSecret -VaultName $KeyVaultName -ErrorAction Stop |
            Where-Object { $_.Name -match '^CI-.+' }
        foreach ($vaultSecret in $vaultSecrets) {
            $name = $vaultSecret.Name.Substring(3)
            if (-not $parameterNames.ContainsKey($name) -or $parameters.ContainsKey($name)) {
                continue
            }

            $secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $vaultSecret.Name -ErrorAction Stop
            if ($secret.SecretValue -isnot [securestring]) {
                throw "Key Vault did not return a secure value for CI parameter [$name]."
            }
            $parameters[$parameterNames[$name]] = $secret.SecretValue
        }
    }

    return $parameters
}
