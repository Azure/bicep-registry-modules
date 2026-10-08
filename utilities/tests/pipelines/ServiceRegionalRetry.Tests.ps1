param (
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeDiscovery {
    $serviceCases = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'service-regional-errors.json') -Raw |
        ConvertFrom-Json -AsHashtable
}

BeforeAll {
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Invoke-TemplateDeploymentWithRetry.ps1')

    function New-ServiceErrorRecord {
        param ([object] $Response)
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Original service failure.'), 'TemplateValidationFailed',
            [System.Management.Automation.ErrorCategory]::InvalidResult, $Response
        )
        $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Sanitized display is not retry evidence.')
        return $record
    }

    function Get-ServiceErrorLeaf {
        param ([object] $Response)
        $node = $Response.error
        while ($node.details) { $node = $node.details[0] }
        return $node
    }
}

# These are synthetic contract examples of the logged messages, not recovered ARM payloads.
Describe 'Selected-region service error: <name>' -ForEach $serviceCases {
    BeforeEach {
        $original = $response | ConvertTo-Json -Depth 20 -Compress
        $sample = $original | ConvertFrom-Json -AsHashtable
        $leaf = Get-ServiceErrorLeaf $sample
        $inputParameters = @{
            ErrorRecord = New-ServiceErrorRecord $sample
            SubscriptionId = '11111111-1111-1111-1111-111111111111'
            ResourceLocation = $region
        }
    }

    It 'Accepts complete selected-region evidence from <source>' -ForEach @(
        @{ source = 'ARM object' }, @{ source = 'raw JSON' }, @{ source = 'SDK optional null members' }
    ) {
        switch ($source) {
            'raw JSON' { $inputParameters.ErrorResponse = $original }
            'SDK optional null members' {
                $leaf.target = $null
                $leaf.details = $null
            }
        }
        Test-RegionalValidationError @inputParameters | Should -BeTrue
        Test-DeploymentRetryError @inputParameters -RetryKind Transient | Should -BeFalse
    }

    It 'Retains the original response and diagnostic record' {
        Test-RegionalValidationError @inputParameters | Should -BeTrue
        ($sample | ConvertTo-Json -Depth 20 -Compress) | Should -BeExactly $original
        [object]::ReferenceEquals($inputParameters.ErrorRecord.TargetObject, $sample) | Should -BeTrue
        $inputParameters.ErrorRecord.ErrorDetails.Message | Should -BeExactly 'Sanitized display is not retry evidence.'
        $inputParameters.ErrorRecord.Exception.Message | Should -BeExactly 'Original service failure.'
    }

    It 'Accepts consistent same-subscription deployment and provider targets' {
        $leaf.target = "/subscriptions/$($inputParameters.SubscriptionId)/resourceGroups/retry-fixture/providers/$provider/environment"
        $inputParameters.ErrorResponse = @{ error = @{
                code = 'DeploymentFailed'
                target = "/subscriptions/$($inputParameters.SubscriptionId)/providers/Microsoft.Resources/deployments/parent"
                details = @($sample.error)
            }
        }
        Test-RegionalValidationError @inputParameters | Should -BeTrue
    }

    It 'Rejects a missing, global, fixed secondary or malformed selected region: <selected>' -ForEach @(
        @{ selected = '' }, @{ selected = 'global' }, @{ selected = 'westus2' }, @{ selected = 'centralus,swedencentral' }
    ) {
        $inputParameters.ResourceLocation = $selected
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Requires the complete provider message: <change>' -ForEach @(
        @{ change = 'generic text' }, @{ change = 'wrong code' }, @{ change = 'wrong code casing' }
        @{ change = 'trailing error' }, @{ change = 'redacted region' }, @{ change = 'global region' }
    ) {
        switch ($change) {
            'generic text' { $leaf.message = "Capacity is not available in region $region." }
            'wrong code' { $leaf.code = 'AuthorizationFailed' }
            'wrong code casing' { $leaf.code = $leaf.code.ToLowerInvariant() }
            'trailing error' { $leaf.message += ' AuthorizationFailed.' }
            'redacted region' { $leaf.message = $leaf.message.Replace($region, '[REDACTED]') }
            'global region' {
                $leaf.message = $leaf.message.Replace($region, 'global')
                $inputParameters.ResourceLocation = 'global'
            }
        }
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects unclassified <field> data' -ForEach @(
        @{ field = 'additionalInfo'; value = $null }, @{ field = 'unknown'; value = $null }
        @{ field = 'details'; value = @() }, @{ field = 'innererror'; value = $null }
        @{ field = 'target'; value = '' }, @{ field = 'message'; value = @('text') }
    ) {
        $leaf[$field] = $value
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects a target outside the failed service and subscription: <target>' -ForEach @(
        @{ target = '/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/retry-fixture/providers/Microsoft.Search/searchServices/service' }
        @{ target = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/retry-fixture/providers/Microsoft.Storage/storageAccounts/service' }
        @{ target = '/providers/Microsoft.Search/searchServices/service' }
        @{ target = 'resourceLocation' }
    ) {
        $leaf.target = $target
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects a conflicting ancestor target even when the leaf target is correct' {
        $leaf.target = "/subscriptions/$($inputParameters.SubscriptionId)/resourceGroups/retry-fixture/providers/$provider/service"
        $inputParameters.ErrorResponse = @{ error = @{
                code = 'DeploymentFailed'
                target = '/subscriptions/22222222-2222-2222-2222-222222222222/providers/Microsoft.Resources/deployments/foreign'
                details = @($sample.error)
            }
        }
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects contradictory resource identities within the same provider and subscription' {
        $leaf.target = "/subscriptions/$($inputParameters.SubscriptionId)/resourceGroups/retry-fixture/providers/$provider/environment"
        $inputParameters.ErrorResponse = @{ error = @{
                code = 'ResourceDeploymentFailure'
                target = "/subscriptions/$($inputParameters.SubscriptionId)/resourceGroups/another-group/providers/$provider/environment"
                details = @($sample.error)
            }
        }
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects mixed or unknown siblings in either order: <siblingKind>' -ForEach @(
        @{ siblingKind = 'permission' }, @{ siblingKind = 'configuration' }, @{ siblingKind = 'unknown metadata' }
    ) {
        $sibling = switch ($siblingKind) {
            'permission' { @{ code = 'AuthorizationFailed'; message = 'Forbidden.' } }
            'configuration' { @{ code = 'InvalidParameter'; message = 'Invalid setting.' } }
            'unknown metadata' { @{ code = 'SkuNotAvailable'; message = 'SKU not available in this region.'; unknown = $null } }
        }
        foreach ($ordered in @(@($sample, $sibling), @($sibling, $sample))) {
            $inputParameters.ErrorResponse = $ordered
            Test-RegionalValidationError @inputParameters | Should -BeFalse
        }
    }

    It 'Rejects malformed or ambiguous raw JSON: <form>' -ForEach @(
        @{ form = 'duplicate code' }, @{ form = 'escaped duplicate code' }, @{ form = 'case duplicate code' }
        @{ form = 'trailing comma' }, @{ form = 'comment' }, @{ form = 'trailing data' }
    ) {
        $inputParameters.ErrorResponse = switch ($form) {
            'duplicate code' { $original.Replace('"code":', '"code":"AuthorizationFailed","code":') }
            'escaped duplicate code' { $original.Replace('"code":', '"\u0063ode":"AuthorizationFailed","code":') }
            'case duplicate code' { $original.Replace('"code":', '"Code":"AuthorizationFailed","code":') }
            'trailing comma' { $original.Insert($original.Length - 1, ',') }
            'comment' { '/* unclassified */' + $original }
            'trailing data' { $original + ' Forbidden' }
        }
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Cannot override HTTP <status> or cancellation evidence' -ForEach @(
        @{ status = 401 }, @{ status = 403 }, @{ status = 429 }, @{ status = 500 }, @{ status = 504 }
    ) {
        $inputParameters.ErrorRecord.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        Test-RegionalValidationError @inputParameters | Should -BeFalse
        $inputParameters.ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Canceled.', [System.OperationCanceledException]::new()),
            'TemplateValidationFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $sample
        )
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }
}

Describe 'Provider-specific service error boundaries' {
    BeforeEach {
        $cases = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'service-regional-errors.json') -Raw |
            ConvertFrom-Json -AsHashtable
    }

    It 'Does not generalize semantic-search BadRequest to other errors or unofficial availability URLs' -ForEach @(
        @{ text = "Semantic Search is not available in 'norwayeast' region." }
        @{ text = "Semantic Search is not available in 'norwayeast' region. Please refer to https://aka.ms/semanticsearchavailability-extra for list of available regions." }
        @{ text = "Semantic Search is not available in 'norwayeast' region. Please refer to https://example.invalid/semanticsearchavailability for list of available regions." }
        @{ text = 'Access to Semantic Search is denied.' }
    ) {
        $sample = $cases[1].response
        (Get-ServiceErrorLeaf $sample).message = $text
        Test-RegionalValidationError -ErrorRecord (New-ServiceErrorRecord $sample) -ResourceLocation norwayeast | Should -BeFalse
    }

    It 'Does not infer the MySQL failure location from the selected candidate or resource ID' {
        $sample = @{ error = @{
                code = 'ZoneNotAvailableForRegion'
                target = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/retry-fixture/providers/Microsoft.DBforMySQL/flexibleServers/server'
                message = 'The requested size for resource is currently not available in this zone. Please try another zone or deploy to a different location'
            }
        }
        Test-RegionalValidationError -ErrorRecord (New-ServiceErrorRecord $sample) -ResourceLocation koreacentral `
            -SubscriptionId '11111111-1111-1111-1111-111111111111' | Should -BeFalse
    }

    It 'Accepts the same complete Container Apps diagnostic with Windows line endings' {
        $sample = $cases[2].response
        $leaf = Get-ServiceErrorLeaf $sample
        $leaf.message = $leaf.message.Replace("`n", "`r`n")

        Test-RegionalValidationError -ErrorRecord (New-ServiceErrorRecord $sample) -ResourceLocation centralus `
            -SubscriptionId '11111111-1111-1111-1111-111111111111' | Should -BeTrue
    }

    It 'Requires Container Apps identity and consistent complete embedded AKS evidence: <change>' -ForEach @(
        @{ change = 'missing managed-environment target' }, @{ change = 'wrong managed-environment provider' }
        @{ change = 'wrong subscription' }, @{ change = 'missing subscription' }, @{ change = 'body permission code' }
        @{ change = 'duplicate body code' }, @{ change = 'case duplicate body code' }, @{ change = 'escaped duplicate body code' }
        @{ change = 'mixed body details' }, @{ change = 'unknown body field' }, @{ change = 'body region mismatch' }
        @{ change = 'malformed body' }, @{ change = 'nonempty subcode' }, @{ change = 'HTTP 403' }
        @{ change = 'missing availability link' }, @{ change = 'unclassified trailing line' }, @{ change = 'duplicate HTTP header' }
    ) {
        $sample = $cases[2].response
        $leaf = Get-ServiceErrorLeaf $sample
        $subscription = '11111111-1111-1111-1111-111111111111'
        switch ($change) {
            'missing managed-environment target' { $sample.error.details[0].Remove('target') }
            'wrong managed-environment provider' {
                $sample.error.details[0].target = $sample.error.details[0].target.Replace('Microsoft.App/managedEnvironments', 'Microsoft.ContainerService/managedClusters')
            }
            'wrong subscription' { $subscription = '22222222-2222-2222-2222-222222222222' }
            'missing subscription' { $subscription = '' }
            'body permission code' { $leaf.message = $leaf.message.Replace('"code": "AKSCapacityHeavyUsage"', '"code": "AuthorizationFailed"') }
            'duplicate body code' { $leaf.message = $leaf.message.Replace('"code":', '"code": "AuthorizationFailed", "code":') }
            'case duplicate body code' { $leaf.message = $leaf.message.Replace('"code":', '"Code": "AuthorizationFailed", "code":') }
            'escaped duplicate body code' { $leaf.message = $leaf.message.Replace('"code":', '"\u0063ode": "AuthorizationFailed", "code":') }
            'mixed body details' { $leaf.message = $leaf.message.Replace('"details": null', '"details": [{"code": "AuthorizationFailed"}]') }
            'unknown body field' { $leaf.message = $leaf.message.Replace('"details": null', '"details": null, "unknown": null') }
            'body region mismatch' { $leaf.message = $leaf.message.Replace('"message": "AKS is experiencing heavy usage in region centralus.', '"message": "AKS is experiencing heavy usage in region westus2.') }
            'malformed body' { $leaf.message = $leaf.message.Replace('"subcode": ""', '"subcode": ') }
            'nonempty subcode' { $leaf.message = $leaf.message.Replace('"subcode": ""', '"subcode": "PermissionDenied"') }
            'HTTP 403' { $leaf.message = $leaf.message.Replace('400 (Bad Request)', '403 (Forbidden)') }
            'missing availability link' { $leaf.message = $leaf.message.Replace('https://aka.ms/akscapacityheavyusage', 'https://example.invalid/capacity') }
            'unclassified trailing line' { $leaf.message += "AuthorizationFailed`n" }
            'duplicate HTTP header' { $leaf.message += "Content-Type: text/plain`n" }
        }
        Test-RegionalValidationError -ErrorRecord (New-ServiceErrorRecord $sample) -ResourceLocation centralus `
            -SubscriptionId $subscription | Should -BeFalse
    }
}
