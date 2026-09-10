<#
.SYNOPSIS
Resolve additional test parameters from GitHub Actions and the legacy CI Key Vault.

.DESCRIPTION
Matches CI_ GitHub names and CI- Key Vault names to template parameters without
regard to case. GitHub secrets override variables; Key Vault only supplies missing
parameters. GitHub values are converted to the declared ARM parameter types.

.PARAMETER TemplateParameters
The parameters object from the compiled test template.

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
        [string] $GitHubVariables = '{}',

        [Parameter()]
        [string] $GitHubSecrets = '{}',

        [Parameter()]
        [string] $KeyVaultName
    )

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
            if ($entry.Key -notmatch '^CI_.+') {
                continue
            }
            if ($source.Values.ContainsKey($entry.Key)) {
                throw "The GitHub $sourceName context contains duplicate CI_ names differing only in case."
            }
            $source.Values[$entry.Key] = $entry.Value
        }
    }

    $parameters = @{}
    $parameterNames = @{}
    # Parameter names can shadow dictionary properties such as Keys and Count.
    foreach ($parameterName in $TemplateParameters.psbase.Keys) {
        $parameterNames[$parameterName] = $parameterName
        $githubName = "CI_$parameterName"
        if ($sources.Secrets.Values.ContainsKey($githubName)) {
            $value = $sources.Secrets.Values[$githubName]
            $isSecret = $true
        } elseif ($sources.Variables.Values.ContainsKey($githubName)) {
            $value = $sources.Variables.Values[$githubName]
            $isSecret = $false
        } else {
            continue
        }

        if ($value -isnot [string]) {
            throw "The GitHub value for parameter [$parameterName] must be a string."
        }

        $parameterType = $TemplateParameters[$parameterName].type
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
