. (Join-Path $PSScriptRoot 'Invoke-DeploymentRead.ps1')

function Test-DeploymentResponseJson {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Json
    )

    try {
        $document = [System.Text.Json.JsonDocument]::Parse($Json)
    } catch [System.Text.Json.JsonException] {
        return $false
    }
    try {
        $nodes = [System.Collections.Generic.Stack[System.Text.Json.JsonElement]]::new()
        $nodes.Push($document.RootElement)
        while ($nodes.Count -gt 0) {
            $node = $nodes.Pop()
            if ($node.ValueKind -eq [System.Text.Json.JsonValueKind]::Object) {
                $names = @{}
                foreach ($property in $node.EnumerateObject()) {
                    if ($names.ContainsKey($property.Name)) { return $false }
                    $names[$property.Name] = $true
                    $nodes.Push($property.Value)
                }
            } elseif ($node.ValueKind -eq [System.Text.Json.JsonValueKind]::Array) {
                foreach ($child in $node.EnumerateArray()) { $nodes.Push($child) }
            }
        }
        return $true
    } finally {
        $document.Dispose()
    }
}

function Get-DeploymentResourceId {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('DeploymentName')]
        [string] $Name,
        [Parameter(Mandatory)]
        [ValidateSet('resourcegroup', 'subscription', 'managementgroup', 'tenant')]
        [string] $Scope,
        [string] $SubscriptionId,
        [string] $ResourceGroupName,
        [string] $ManagementGroupId
    )

    $prefix = switch ($Scope) {
        'resourcegroup' { "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName" }
        'subscription' { "/subscriptions/$SubscriptionId" }
        'managementgroup' { "/providers/Microsoft.Management/managementGroups/$ManagementGroupId" }
        'tenant' { '' }
    }
    return "$prefix/providers/Microsoft.Resources/deployments/$Name"
}

function Test-ExistingGraphLookup {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [object] $Operation,
        [System.Text.Json.JsonElement] $Export,
        [string] $Scope
    )

    function Get-UniqueJsonProperty {
        param ([object] $Object, [string] $Name)
        if ($null -eq $Object -or $Object.ValueKind -ne 'Object') { return $null }
        $properties = @($Object.EnumerateObject() | Where-Object { $_.Name -ieq $Name })
        if ($properties.Count -ne 1 -or $properties[0].Name -cne $Name) { return $null }
        return $properties[0].Value
    }

    $target = $Operation.targetResource
    $extension = $target.extension
    if ($Operation.provisioningOperation -cne 'Create' -or $Operation.provisioningState -cne 'Succeeded' -or
        $null -ne $Operation.statusCode -or $null -ne $Operation.statusMessage -or
        $target -isnot [System.Management.Automation.PSCustomObject] -or $null -ne $target.PSObject.Properties['id'] -or
        $target.resourceType -isnot [string] -or $target.resourceType -cne 'Microsoft.Graph/servicePrincipals@v1.0' -or
        $target.symbolicName -isnot [string] -or [string]::IsNullOrWhiteSpace($target.symbolicName) -or
        $extension -isnot [System.Management.Automation.PSCustomObject] -or
        $extension.name -isnot [string] -or $extension.name -cne 'MicrosoftGraph' -or
        $extension.version -isnot [string] -or $extension.version -cne '1.0.0' -or
        $extension.alias -isnot [string] -or [string]::IsNullOrWhiteSpace($extension.alias) -or
        $Export.ValueKind -ne 'Object' -or @($Export.EnumerateObject() | Where-Object { $_.Name -ieq 'error' }).Count -gt 0) {
        return $false
    }
    $template = Get-UniqueJsonProperty $Export 'template'
    $language = Get-UniqueJsonProperty $template 'languageVersion'
    $schema = Get-UniqueJsonProperty $template '$schema'
    if ($language.ValueKind -ne 'String' -or $language.GetString() -cne '2.0' -or $schema.ValueKind -ne 'String') {
        return $false
    }
    . (Join-Path $PSScriptRoot 'Get-ScopeOfTemplateFile.ps1')
    if ((Get-ScopeOfTemplateFile -TemplateFileContent @{ '$schema' = $schema.GetString() }) -ne $Scope) {
        return $false
    }
    $declaration = Get-UniqueJsonProperty (Get-UniqueJsonProperty $template 'resources') $target.symbolicName
    $existing = Get-UniqueJsonProperty $declaration 'existing'
    $type = Get-UniqueJsonProperty $declaration 'type'
    $alias = Get-UniqueJsonProperty $declaration 'import'
    if ($existing.ValueKind -ne 'True' -or $type.ValueKind -ne 'String' -or $type.GetString() -cne $target.resourceType -or
        $alias.ValueKind -ne 'String' -or $alias.GetString() -cne $extension.alias) {
        return $false
    }
    $import = Get-UniqueJsonProperty (Get-UniqueJsonProperty $template 'imports') $extension.alias
    $provider = Get-UniqueJsonProperty $import 'provider'
    $version = Get-UniqueJsonProperty $import 'version'
    return $provider.ValueKind -eq 'String' -and $provider.GetString() -ceq $extension.name -and
    $version.ValueKind -eq 'String' -and $version.GetString() -ceq $extension.version
}

<#
.SYNOPSIS
Get all deployment operations at a given scope

.DESCRIPTION
Get all deployment operations at a given scope, following every operation page.
Responses retain extension metadata needed to verify existing extensible resources.
Each operation-page GET retries typed request timeouts at most twice without replaying earlier pages.
By default, results include only 'create' operations, excluding 'read' operations for existing resources.

.PARAMETER Name
Mandatory. The deployment name to search for

.PARAMETER ResourceGroupName
Optional. The name of the resource group for scope 'resourcegroup'. Relevant for resource-group-level deployments.

.PARAMETER SubscriptionId
Optional. The ID of the subscription to fetch deployments from. Relevant for subscription- & resource-group-level deployments.

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group-level deployments.

.PARAMETER Scope
Mandatory. The scope to search in

.PARAMETER ProvisioningOperationsToInclude
Optional. The provisioning operations to include in the result set. By default, only 'create' operations are included.

.PARAMETER IncludeAllOperations
Optional. Return every operation without filtering or a success sentinel, for structured failure inspection.

.PARAMETER RequireCompleteRemoval
Optional. Require terminal operations and complete target IDs before authorizing relocation.
An ID-less existing Graph lookup additionally requires an exact declaration in that deployment's exported template.

.PARAMETER ResolvedResourceIds
Optional. Preserve known create targets when a later operation page fails.

.EXAMPLE
Get-DeploymentOperationAtScope -Scope 'subscription' -Name 'v73rhp24d7jya-test-apvmiaiboaai'

Get all deployment operations for a deployment with name 'v73rhp24d7jya-test-apvmiaiboaai' at scope 'subscription'

.NOTES
Raw responses retain structured statusMessage.error; Az deployment-operation cmdlets format it as text.
#>
function Get-DeploymentOperationAtScope {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('DeploymentName')]
        [string] $Name,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'Create', # any resource creation
            'Read', # E.g., 'existing' resources
            'EvaluateDeploymentOutput' # Nobody knows
        )]
        [string[]] $ProvisioningOperationsToInclude = @('Create'),

        [Parameter(Mandatory)]
        [ValidateSet(
            'resourcegroup',
            'subscription',
            'managementgroup',
            'tenant'
        )]
        [string] $Scope,

        [Parameter()]
        [switch] $IncludeAllOperations,

        [Parameter()]
        [switch] $RequireCompleteRemoval,

        [Parameter()]
        [System.Collections.Generic.List[string]] $ResolvedResourceIds
    )


    $resourceId = Get-DeploymentResourceId -Name $Name -Scope $Scope -SubscriptionId $SubscriptionId `
        -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId
    $operationsPath = "$resourceId/operations"
    $path = "${operationsPath}?api-version=2025-04-01"

    ##############################################
    # Get all deployment children based on scope #
    ##############################################

    $deploymentOperations = @()
    $visitedPages = [System.Collections.Generic.HashSet[string]]::new()
    do {
        if (-not $visitedPages.Add($path) -or $visitedPages.Count -gt 1000) {
            throw "Deployment [$Name] returned repeated or excessive operation pages."
        }
        $response = Invoke-DeploymentRead -Read {
            Invoke-AzRestMethod -Method 'GET' -Path $path -ErrorAction Stop
        }
        if (($IncludeAllOperations -or $RequireCompleteRemoval) -and (
                $response -is [array] -or
                ($response.StatusCode -isnot [int] -and $response.StatusCode -isnot [System.Net.HttpStatusCode]) -or
                $response.Content -isnot [string] -or
                -not (Test-DeploymentResponseJson -Json $response.Content))) {
            throw "Deployment [$Name] returned invalid or ambiguous operation JSON or HTTP status; regional retry is unsafe."
        }
        $content = $response.Content | ConvertFrom-Json -NoEnumerate -ErrorAction Stop

        if ($response.StatusCode -ne 200) {
            if ($response.StatusCode -eq 404 -and $content.error.code -eq 'DeploymentNotFound') {
                $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException]::new("Deployment [$Name] was not found in scope [$Scope]."),
                        'DeploymentNotFound',
                        [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                        $Name
                    ))
            }
            if (-not $RequireCompleteRemoval -and -not $IncludeAllOperations -and $Scope -eq 'resourcegroup' -and
                $response.StatusCode -eq 404 -and $content.error.code -eq 'ResourceGroupNotFound') {
                Write-Verbose "Resource group [$ResourceGroupName] no longer exists. No contained resources remain to remove." -Verbose
                return $true
            }
            throw ('Failed to fetch deployment operations for deployment [{0}] in scope [{1}]: HTTP [{2}], error [{3}].' -f $Name, $Scope, $response.StatusCode, $content.error.code)
        }
        if ($content -isnot [System.Management.Automation.PSCustomObject] -or $content.value -isnot [array]) {
            throw "Invalid deployment operations response for deployment [$Name] in scope [$Scope]."
        }
        if (($IncludeAllOperations -or $RequireCompleteRemoval) -and
            @($content.PSObject.Properties.Name | Where-Object { $_ -cnotin @('value', 'nextLink') }).Count -gt 0) {
            throw "Deployment [$Name] returned mixed or unknown operation response fields; regional retry is unsafe."
        }
        foreach ($operation in $content.value) {
            if ($IncludeAllOperations -and ($operation -isnot [System.Management.Automation.PSCustomObject] -or
                    $operation.properties -isnot [System.Management.Automation.PSCustomObject] -or
                    $operation.properties.provisioningOperation -isnot [string] -or
                    [string]::IsNullOrWhiteSpace($operation.properties.provisioningOperation))) {
                throw "Deployment [$Name] returned an invalid operation."
            }
            $deploymentOperations += , $operation.properties
            $targetId = $operation.properties.targetResource.id
            if ($null -ne $ResolvedResourceIds -and $operation.properties.provisioningOperation -eq 'Create' -and
                -not [string]::IsNullOrWhiteSpace($targetId) -and $targetId -notmatch '/Microsoft\.Resources/deployments/') {
                $ResolvedResourceIds.Add($targetId)
            }
        }
        $path = $null
        if ($IncludeAllOperations -and $null -ne $content.nextLink -and
            ($content.nextLink -isnot [string] -or [string]::IsNullOrWhiteSpace($content.nextLink))) {
            throw "Deployment [$Name] returned an invalid operation page link."
        }
        if ($content.nextLink) {
            $endpoint = [uri] (Get-AzContext -ErrorAction Stop).Environment.ResourceManagerUrl
            $nextPage = [uri]::new($endpoint, [string] $content.nextLink)
            if ($nextPage.Scheme -ne 'https' -or $nextPage.Authority -ne $endpoint.Authority -or
                $nextPage.AbsolutePath -ine $operationsPath -or $nextPage.UserInfo -or $nextPage.Fragment) {
                throw "Deployment [$Name] returned an operation page outside its original scope."
            }
            $path = $nextPage.PathAndQuery
        }
    } while ($path)

    if ($RequireCompleteRemoval) {
        $templateExport = $null
        try {
            foreach ($operation in $deploymentOperations) {
                if ($operation.provisioningState -isnot [string] -or $operation.provisioningState -notin @('Succeeded', 'Failed')) {
                    throw "Deployment [$Name] has an incomplete operation; cleanup cannot authorize regional relocation."
                }
                if ($operation.provisioningOperation -eq 'Create' -and
                    ($operation.targetResource.id -isnot [string] -or [string]::IsNullOrWhiteSpace($operation.targetResource.id))) {
                    if ($operation.targetResource.resourceType -is [string] -and
                        $operation.targetResource.resourceType -ceq 'Microsoft.Graph/servicePrincipals@v1.0') {
                        if ($null -eq $templateExport) {
                            $response = Invoke-AzRestMethod -Method POST -Path "${resourceId}/exportTemplate?api-version=2025-04-01" -ErrorAction Stop
                            if ($response.StatusCode -is [array] -or $response.StatusCode -ne 200 -or $response.Content -isnot [string]) {
                                throw "Cannot export deployment [$Name] in scope [$Scope]: HTTP [$($response.StatusCode)]."
                            }
                            $templateExport = [System.Text.Json.JsonDocument]::Parse(
                                $response.Content, [System.Text.Json.JsonDocumentOptions]@{ MaxDepth = 100 }
                            )
                        }
                        if (Test-ExistingGraphLookup -Operation $operation -Export $templateExport.RootElement -Scope $Scope) {
                            continue
                        }
                    }
                    throw "Deployment [$Name] has an incomplete operation; cleanup cannot authorize regional relocation."
                }
            }
        } finally {
            if ($null -ne $templateExport) { $templateExport.Dispose() }
        }
    }
    if ($IncludeAllOperations) {
        return , $deploymentOperations
    }
    $deploymentOperationsFiltered = $deploymentOperations | Where-Object { $_.provisioningOperation -in $ProvisioningOperationsToInclude }
    return $deploymentOperationsFiltered ?? $true # Returning true to indicate that the deployment was found, but did not contain any relevant operations
}
