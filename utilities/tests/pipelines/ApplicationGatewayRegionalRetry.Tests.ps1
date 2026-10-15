param (
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Invoke-TemplateDeploymentWithRetry.ps1')
    $fixtureJson = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'application-gateway-regional-error.json') -Raw
}

Describe 'Captured Application Gateway regional capacity' -Tag 'ApplicationGatewayRegional' {
    BeforeEach {
        $response = $fixtureJson | ConvertFrom-Json -AsHashtable
        $resource = $response.error.details[0]
        $leaf = $resource.details[0]
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Original Application Gateway failure.'),
            'TemplateValidationFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $response
        )
        $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Display text is not retry evidence.')
        $inputParameters = @{
            ErrorRecord = $record
            SubscriptionId = '11111111-1111-1111-1111-111111111111'
            ResourceLocation = 'swedencentral'
        }
    }

    It 'Accepts the native Failed envelope from <source> without allowing same-region replay' -ForEach @(
        @{ source = 'ARM object with empty leaf details' }, @{ source = 'raw JSON' }
        @{ source = 'SDK optional null members' }, @{ source = 'omitted optional leaf details' }
    ) {
        switch ($source) {
            'raw JSON' { $inputParameters.ErrorResponse = $fixtureJson }
            'SDK optional null members' { $leaf.target = $null; $leaf.details = $null }
            'omitted optional leaf details' { $leaf.Remove('details') }
        }
        $original = $response | ConvertTo-Json -Depth 20 -Compress

        Test-RegionalValidationError @inputParameters | Should -BeTrue
        Test-DeploymentRetryError @inputParameters -RetryKind Transient | Should -BeFalse
        ($response | ConvertTo-Json -Depth 20 -Compress) | Should -BeExactly $original
        [object]::ReferenceEquals($record.TargetObject, $response) | Should -BeTrue
        $record.ErrorDetails.Message | Should -BeExactly 'Display text is not retry evidence.'
    }

    It 'Accepts consistent gateway and deployment targets with HTTP <status>' -ForEach @(
        @{ status = 400 }, @{ status = 409 }, @{ status = 503 }
    ) {
        $leaf.target = $resource.target.ToUpperInvariant()
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        $inputParameters.ErrorResponse = @{ error = @{
                code = 'DeploymentFailed'
                target = "/subscriptions/$($inputParameters.SubscriptionId)/providers/Microsoft.Resources/deployments/root"
                details = @($response)
            }
        }

        Test-RegionalValidationError @inputParameters | Should -BeTrue
    }

    It 'Rejects incomplete or contradictory capacity evidence: <change>' -ForEach @(
        @{ change = 'missing code' }, @{ change = 'null code' }, @{ change = 'array code' }
        @{ change = 'wrong code' }, @{ change = 'wrong code casing' }, @{ change = 'generic capacity message' }
        @{ change = 'missing message' }, @{ change = 'array message' }, @{ change = 'trailing error' }
        @{ change = 'wrong message casing' }, @{ change = 'trailing newline' }
        @{ change = 'nonarray details' }, @{ change = 'nonempty regional details' }
        @{ change = 'innererror' }, @{ change = 'null innererror' }
        @{ change = 'unknown leaf property' }, @{ change = 'unknown ancestor property' }
        @{ change = 'unknown envelope property' }, @{ change = 'additional information' }
        @{ change = 'successful envelope' }, @{ change = 'malformed envelope status' }
        @{ change = 'lowercase envelope status' }, @{ change = 'empty wrapper details' }
        @{ change = 'bare message' }, @{ change = 'bare leaf without a gateway target' }
    ) {
        switch ($change) {
            'missing code' { $leaf.Remove('code') }
            'null code' { $leaf.code = $null }
            'array code' { $leaf.code = @($leaf.code) }
            'wrong code' { $leaf.code = 'ApplicationGatewayUnknownFailure' }
            'wrong code casing' { $leaf.code = $leaf.code.ToLowerInvariant() }
            'generic capacity message' { $leaf.message = 'Temporary capacity issue in this region or zone. Try another region.' }
            'missing message' { $leaf.Remove('message') }
            'array message' { $leaf.message = @($leaf.message) }
            'trailing error' { $leaf.message += ' AuthorizationFailed.' }
            'wrong message casing' { $leaf.message = $leaf.message.ToLowerInvariant() }
            'trailing newline' { $leaf.message += "`n" }
            'nonarray details' { $leaf.details = @{} }
            'nonempty regional details' { $leaf.details = @(@{ code = 'SkuNotAvailable'; message = 'SKU not available in this region.' }) }
            'innererror' { $leaf.innererror = @{ code = 'AuthorizationFailed'; message = 'Forbidden.' } }
            'null innererror' { $leaf.innererror = $null }
            'unknown leaf property' { $leaf.unknown = $null }
            'unknown ancestor property' { $resource.unknown = $null }
            'unknown envelope property' { $response.unknown = $null }
            'additional information' { $leaf.additionalInfo = @(@{ type = 'PermissionFailure' }) }
            'successful envelope' { $response.status = 'Succeeded' }
            'malformed envelope status' { $response.status = @('Failed') }
            'lowercase envelope status' { $response.status = 'failed' }
            'empty wrapper details' { $resource.details = @() }
            'bare message' { $inputParameters.ErrorResponse = $leaf.message }
            'bare leaf without a gateway target' { $inputParameters.ErrorResponse = $leaf }
        }

        Test-RegionalValidationError @inputParameters | Should -BeFalse
        Test-DeploymentRetryError @inputParameters -RetryKind Transient | Should -BeFalse
    }

    It 'Requires an unambiguous same-subscription gateway identity: <change>' -ForEach @(
        @{ change = 'missing target' }, @{ change = 'null target' }, @{ change = 'empty target' }
        @{ change = 'array target' }, @{ change = 'another subscription' }, @{ change = 'another provider' }
        @{ change = 'deployment target only' }, @{ change = 'extension resource' }, @{ change = 'child resource' }
        @{ change = 'query string' }, @{ change = 'fragment' }, @{ change = 'trailing slash' }
        @{ change = 'missing resource name' }, @{ change = 'foreign ancestor' }, @{ change = 'conflicting gateway ancestor' }
        @{ change = 'conflicting leaf' }, @{ change = 'missing subscription' }, @{ change = 'malformed subscription' }
        @{ change = 'empty GUID subscription' }
    ) {
        switch ($change) {
            'missing target' { $resource.Remove('target') }
            'null target' { $resource.target = $null }
            'empty target' { $resource.target = '' }
            'array target' { $resource.target = @($resource.target) }
            'another subscription' { $resource.target = $resource.target.Replace($inputParameters.SubscriptionId, '22222222-2222-2222-2222-222222222222') }
            'another provider' { $resource.target = $resource.target.Replace('applicationGateways', 'virtualNetworks') }
            'deployment target only' { $resource.target = $response.error.target }
            'extension resource' { $resource.target = $resource.target.Replace('/providers/Microsoft.Network/', '/providers/Microsoft.Storage/storageAccounts/parent/providers/Microsoft.Network/') }
            'child resource' { $resource.target += '/frontendIPConfigurations/frontend' }
            'query string' { $resource.target += '?api-version=2025-01-01' }
            'fragment' { $resource.target += '#gateway' }
            'trailing slash' { $resource.target += '/' }
            'missing resource name' { $resource.target = $resource.target.Replace('/gateway', '/') }
            'foreign ancestor' { $response.error.target = $response.error.target.Replace($inputParameters.SubscriptionId, '22222222-2222-2222-2222-222222222222') }
            'conflicting gateway ancestor' { $response.error.target = $resource.target.Replace('/gateway', '/other-gateway') }
            'conflicting leaf' { $leaf.target = $resource.target.Replace('/gateway', '/other-gateway') }
            'missing subscription' { $inputParameters.SubscriptionId = '' }
            'malformed subscription' { $inputParameters.SubscriptionId = 'not-a-guid' }
            'empty GUID subscription' { $inputParameters.SubscriptionId = [guid]::Empty.ToString() }
        }

        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects a missing or global selected location: <location>' -ForEach @(
        @{ location = '' }, @{ location = ' ' }, @{ location = 'global' }, @{ location = 'Global ' }
    ) {
        $inputParameters.ResourceLocation = $location
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Rejects mixed <kind> evidence in either sibling order' -ForEach @(
        @{ kind = 'authorization'; code = 'AuthorizationFailed' }
        @{ kind = 'authentication'; code = 'InvalidAuthenticationToken' }
        @{ kind = 'configuration'; code = 'InvalidParameter' }
        @{ kind = 'quota'; code = 'QuotaExceeded' }
        @{ kind = 'unknown'; code = 'UnknownError' }
        @{ kind = 'unclassified metadata'; code = 'SkuNotAvailable' }
    ) {
        $sibling = @{ code = $code; message = 'SKU not available in this region.' }
        if ($kind -eq 'unclassified metadata') { $sibling.unknown = $null }
        foreach ($siblings in @(@($resource, $sibling), @($sibling, $resource))) {
            $response.error.details = $siblings
            Test-RegionalValidationError @inputParameters | Should -BeFalse
        }
    }

    It 'Rejects malformed or ambiguous raw JSON: <form>' -ForEach @(
        @{ form = 'duplicate code' }, @{ form = 'escaped duplicate code' }, @{ form = 'case duplicate code' }
        @{ form = 'trailing comma' }, @{ form = 'comment' }, @{ form = 'trailing data' }, @{ form = 'truncated' }
    ) {
        $inputParameters.ErrorResponse = switch ($form) {
            'duplicate code' { $fixtureJson.Replace('"code":', '"code":"AuthorizationFailed","code":') }
            'escaped duplicate code' { $fixtureJson.Replace('"code":', '"\u0063ode":"AuthorizationFailed","code":') }
            'case duplicate code' { $fixtureJson.Replace('"code":', '"Code":"AuthorizationFailed","code":') }
            'trailing comma' { $fixtureJson.TrimEnd().Insert($fixtureJson.TrimEnd().Length - 1, ',') }
            'comment' { '/* unclassified */' + $fixtureJson }
            'trailing data' { $fixtureJson + ' Forbidden' }
            'truncated' { $fixtureJson.TrimEnd().Substring(0, $fixtureJson.TrimEnd().Length - 1) }
        }

        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Cannot override HTTP <status> evidence' -ForEach @(
        @{ status = 401 }, @{ status = 403 }, @{ status = 404 }, @{ status = 408 }
        @{ status = 429 }, @{ status = 500 }, @{ status = 504 }
        @{ status = 'Forbidden' }, @{ status = @(409) }
    ) {
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Cannot override the <category> error category' -ForEach @(
        @{ category = 'AuthenticationError' }, @{ category = 'PermissionDenied' }
        @{ category = 'SecurityError' }, @{ category = 'OperationStopped' }
    ) {
        $inputParameters.ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
            $record.Exception, 'TemplateValidationFailed', $category, $response
        )
        Test-RegionalValidationError @inputParameters | Should -BeFalse
    }

    It 'Cannot override <kind> exceptions' -ForEach @(
        @{ kind = 'authorization'; type = [System.UnauthorizedAccessException] }
        @{ kind = 'cancellation'; type = [System.OperationCanceledException] }
        @{ kind = 'pipeline cancellation'; type = [System.Management.Automation.PipelineStoppedException] }
    ) {
        $exception = $type::new('Forbidden or canceled.')
        foreach ($outer in @(
                $exception,
                [System.InvalidOperationException]::new('Wrapped failure.', $exception),
                [System.AggregateException]::new([System.Exception[]] @([System.InvalidOperationException]::new('Failure.'), $exception))
            )) {
            $inputParameters.ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $outer, 'TemplateValidationFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $response
            )
            Test-RegionalValidationError @inputParameters | Should -BeFalse
        }
    }
}
