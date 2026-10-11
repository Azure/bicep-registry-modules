<#
.SYNOPSIS
Find global resource names that collide when an e2e template is expanded in two subscriptions.

.DESCRIPTION
Uses PSRule's offline ARM expansion, including nested deployments, conditions, loops and functions.
No Azure connection is used. Resource-group-scoped names and references to existing resources are excluded.
Time-based and random defaults are varied between simulated runs; deployment names and CI prefixes remain identical.
Runtime Key Vault secret payloads are omitted because they cannot be read back as resource properties.
External fixture IDs and runtime-only DNS/script results use constant offline values. Unknown Key Vault
RBAC reference values are checked in both states, rather than assuming a successful deployment outcome.

.PARAMETER TemplateFilePath
The compiled e2e ARM template to check.
#>
function Test-E2eResourceNames {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $TemplateFilePath
    )

    $ErrorActionPreference = 'Stop'
    Import-Module PSRule.Rules.Azure -MinimumVersion 1.47.0 -ErrorAction Stop
    $rules = @{}
    $ruleData = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'global-resource-names.json') -Raw | ConvertFrom-Json -AsHashtable
    foreach ($rule in $ruleData.GetEnumerator()) { $rules[$rule.Key] = $rule.Value }
    $template = Get-Content -LiteralPath $TemplateFilePath -Raw | ConvertFrom-Json -AsHashtable -Depth 100
    if ($template.parameters.namePrefix) {
        $template.parameters.namePrefix.defaultValue = 'gci'
    }
    $externalScope = '/subscriptions/33333333-3333-3333-3333-333333333333/resourceGroups/offline-fixtures'
    $externalResources = @{
        managedHSMResourceId    = "$externalScope/providers/Microsoft.KeyVault/managedHSMs/offline-hsm"
        deploymentMSIResourceId = "$externalScope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/offline-identity"
    }
    foreach ($parameterName in $externalResources.Keys) {
        if ($template.parameters -and $template.parameters[$parameterName] -and $template.parameters[$parameterName].defaultValue -eq '') {
            $template.parameters[$parameterName].defaultValue = $externalResources[$parameterName]
        }
    }

    $runtimeBooleanBindings = [System.Collections.Generic.List[object]]::new()
    function Initialize-OfflineTemplate {
        param([System.Collections.IDictionary] $Template)

        foreach ($parameter in $Template.parameters.Values) {
            # PSRule requires a concrete type for resource-derived, untyped object metadata.
            if (-not $parameter.type -and -not $parameter.'$ref' -and
                $parameter.metadata.'__bicep_resource_derived_type!'.source -match '/(customProperties|metadata)$') {
                $parameter.type = 'object'
            }
            if ($parameter.defaultValue -is [string] -and $parameter.defaultValue -match '^\[[^[]' -and
                $parameter.defaultValue -match '\b(utcNow|newGuid)\(') {
                [pscustomobject]@{ Parameter = $parameter; Expression = $parameter.defaultValue }
            }
        }
        $resources = $Template.resources -is [System.Collections.IDictionary] ? $Template.resources.Values : $Template.resources
        foreach ($resource in $resources) {
            # Constant runtime placeholders cannot make an otherwise fixed name pass the comparison.
            if ($resource.type -eq 'Microsoft.Resources/deploymentScripts' -and $resource.properties -is [System.Collections.IDictionary] -and
                -not $resource.properties.outputs) {
                $resource.properties.outputs = @{
                    secretUrl = 'https://offline-fixtures.vault.azure.net/secrets/offline-certificate/offline-version'
                }
            }
            if ($resource.type -eq 'Microsoft.Network/privateEndpoints' -and $resource.properties -is [System.Collections.IDictionary] -and
                -not $resource.properties.customDnsConfigs) {
                $resource.properties.customDnsConfigs = @(@{ fqdn = 'offline.invalid'; ipAddresses = @('10.0.0.4') })
            }
            if ($resource.type -eq 'Microsoft.KeyVault/vaults/secrets' -and $resource.properties) {
                $null = $resource.properties.Remove('value')
            }
            if ($resource.type -eq 'Microsoft.Resources/deployments') {
                $rbacBinding = $resource.properties.parameters.usesRbacAuthorization
                $rbacExpression = $rbacBinding -is [System.Collections.IDictionary] ? $rbacBinding.value : $rbacBinding
                if ($rbacExpression -match 'reference\(.*enableRbacAuthorization') {
                    $runtimeBooleanBindings.Add($resource.properties.parameters)
                }
            }
            if ($resource.type -eq 'Microsoft.Resources/deployments' -and $resource.properties.template -is [System.Collections.IDictionary]) {
                Initialize-OfflineTemplate -Template $resource.properties.template
            }
        }
        foreach ($variable in $Template.variables.Values) {
            if ($variable -is [System.Collections.IDictionary] -and $variable.'$schema' -and $variable.resources) {
                Initialize-OfflineTemplate -Template $variable
            }
        }
    }

    $dynamicDefaults = @(Initialize-OfflineTemplate -Template $template)
    if ($runtimeBooleanBindings.Count -gt 8) {
        throw 'More than eight unresolved RBAC conditions would require excessive offline expansion. Supply explicit test inputs.'
    }
    $dynamicFunction = [regex]::new("'(?:[^']|'')*'|(?<utc>utcNow\((?:'(?<format>(?:[^']|'')*)')?\))|(?<guid>newGuid\(\))", 'IgnoreCase')

    function Get-ResourceName {
        param([object[]] $Resources)

        foreach ($resource in $Resources) {
            if ($rules.ContainsKey([string]$resource.type)) {
                foreach ($property in $rules[$resource.type]) {
                    $generatedDnsScopes = @('SubscriptionReuse', 'ResourceGroupReuse', 'NoReuse')
                    if ($resource.type -eq 'Microsoft.Network/publicIPAddresses' -and
                        $property -eq 'properties.dnsSettings.domainNameLabel' -and
                        $resource.properties.dnsSettings.domainNameLabelScope -in $generatedDnsScopes) {
                        continue
                    }
                    if ($resource.type -eq 'Microsoft.ContainerInstance/containerGroups' -and
                        $property -eq 'properties.ipAddress.dnsNameLabel' -and
                        $resource.properties.ipAddress.dnsNameLabelReusePolicy -in $generatedDnsScopes) {
                        continue
                    }
                    $name = $resource
                    foreach ($segment in $property.Split('.')) {
                        $name = $name.$segment
                    }
                    if (-not [string]::IsNullOrEmpty($name)) {
                        if ($property -eq 'name') { $name = ([string]$name).Split('/')[-1] }
                        [pscustomobject]@{
                            Key          = '{0}|{1}|{2}' -f $resource.type, $property, $name
                            ResourceType = [string]$resource.type
                            Property     = $property
                            Name         = [string]$name
                            ResourceId   = [string]$resource.id
                            TemplatePath = [string]$resource._PSRule.path
                        }
                    }
                }
            }
            if ($resource.resources) {
                Get-ResourceName -Resources $resource.resources
            }
        }
    }

    $expandedTemplate = New-TemporaryFile
    try {
        $names = @()
        for ($index = 0; $index -lt 2; $index++) {
            $time = [DateTimeOffset]::Parse(@('2026-01-01T00:00:00.000Z', '2027-02-02T11:11:11.111Z')[$index]).UtcDateTime
            $randomGuid = @('11111111-1111-4111-8111-111111111111', '22222222-2222-4222-8222-222222222222')[$index]
            foreach ($default in $dynamicDefaults) {
                $default.Parameter.defaultValue = $dynamicFunction.Replace($default.Expression, {
                        param($match)
                        if ($match.Groups['guid'].Success) { return "'$randomGuid'" }
                        if ($match.Groups['utc'].Success) {
                            $format = $match.Groups['format'].Success ? $match.Groups['format'].Value.Replace("''", "'") : 'yyyyMMddTHHmmssZ'
                            return "'$($time.ToString($format, [Globalization.CultureInfo]::InvariantCulture))'"
                        }
                        return $match.Value
                    })
            }
            $subscriptionId = $index -eq 0 ? '11111111-1111-1111-1111-111111111111' : '22222222-2222-2222-2222-222222222222'
            $nameMap = @{}
            for ($variant = 0; $variant -lt [Math]::Pow(2, $runtimeBooleanBindings.Count); $variant++) {
                for ($binding = 0; $binding -lt $runtimeBooleanBindings.Count; $binding++) {
                    $runtimeBooleanBindings[$binding].usesRbacAuthorization = @{ value = [bool]($variant -band (1 -shl $binding)) }
                }
                $template | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $expandedTemplate.FullName
                $resources = @(Export-AzRuleTemplateData -TemplateFile $expandedTemplate.FullName -PassThru -Name 'e2e-naming-check' -Subscription @{
                        subscriptionId = $subscriptionId
                        tenantId       = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                        displayName    = 'Offline e2e naming check'
                    } -ResourceGroup @{
                        name     = 'e2e-naming-check'
                        location = 'eastus'
                    } -ErrorAction Stop)
                foreach ($name in (Get-ResourceName -Resources $resources)) {
                    if (-not $nameMap.ContainsKey($name.Key)) { $nameMap[$name.Key] = @{} }
                    $nameMap[$name.Key][$name.ResourceId] = $name
                }
            }
            $names += , $nameMap
        }

        [pscustomobject]@{
            TemplateFilePath = $TemplateFilePath
            CheckedNames     = $names[0].Count
            Violations       = @(
                foreach ($key in ($names[0].Keys | Sort-Object)) {
                    if ($names[1].ContainsKey($key)) {
                        foreach ($name in $names[0][$key].Values) {
                            if (@($names[1][$key].Keys | Where-Object { $_ -ne $name.ResourceId }).Count -gt 0) {
                                $name
                                break
                            }
                        }
                    }
                }
            )
        }
    } finally {
        Remove-Item -LiteralPath $expandedTemplate.FullName -Force
    }
}
