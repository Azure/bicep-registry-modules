param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Test-TemplateDeploymentWithRetry.ps1')

    function New-TestValidationError {
        param([object] $Response, [switch] $ErrorDetails)
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Template is not valid.'),
            ($ErrorDetails ? 'AzureValidationFailed' : 'TemplateValidationFailed'),
            [System.Management.Automation.ErrorCategory]::InvalidResult,
            $Response
        )
        if ($ErrorDetails) {
            $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new(
                ($Response -is [string] ? $Response : (ConvertTo-Json -InputObject $Response -Depth 30))
            )
        }
        return $record
    }
}

Describe 'Template validation error messages' {
    It 'Reports nested Azure codes, messages and targets without unrelated response fields' {
        $response = [pscustomobject]@{
            Error = [pscustomobject]@{
                Code           = 'InvalidTemplateDeployment'
                Message        = 'Deployment validation failed.'
                AdditionalInfo = @{ requestBody = 'private-request-body' }
                Details        = @(
                    @{
                        code       = 'RequestDisallowedByPolicy'
                        message    = 'The resource is blocked by a policy.'
                        target     = 'managedInstance'
                        innererror = @{ code = 'PolicyViolation'; message = 'Use an approved location.' }
                    }
                )
            }
        }

        $message = Get-TemplateValidationErrorMessage -ValidationErrors $response

        $message | Should -Match 'Code: InvalidTemplateDeployment; Message: Deployment validation failed\.'
        $message | Should -Match 'Code: RequestDisallowedByPolicy; Message: The resource is blocked by a policy\.; Target: managedInstance'
        $message | Should -Match 'Code: PolicyViolation; Message: Use an approved location\.'
        $message | Should -Not -Match 'private-request-body|AdditionalInfo|requestBody'
    }

    It 'Redacts supplied values including secure strings, objects and escaped values' {
        $secret = 'private\value"+&'
        $jsonSecret = ConvertTo-Json -InputObject $secret -Compress
        $escapedSecret = $jsonSecret.Substring(1, $jsonSecret.Length - 2)
        $encodedSecret = [System.Uri]::EscapeDataString($secret)
        $response = @{
            Code    = 'InvalidParameter'
            Message = "Rejected $secret, $escapedSecret, $encodedSecret, object-private-value and fixed-base-time."
            Target  = 'object-private-value'
        }
        $parameters = @{
            password = ConvertTo-SecureString -String $secret -AsPlainText -Force
            config   = @{ keys = @([pscustomobject]@{ token = 'object-private-value' }) }
            baseTime = 'fixed-base-time'
            empty    = ''
        }

        $message = Get-TemplateValidationErrorMessage -ValidationErrors $response -AdditionalParameters $parameters

        $message | Should -Match 'Code: InvalidParameter'
        $message | Should -Match 'Message: Rejected \[REDACTED\], \[REDACTED\], \[REDACTED\], \[REDACTED\] and \[REDACTED\]\.'
        $message | Should -Match 'Target: \[REDACTED\]'
        $message | Should -Not -Match 'private|fixed-base-time'
        $response.Message | Should -Match ([regex]::Escape($secret))
    }

    It 'Redacts values read from a JSON parameter file' {
        $parameterFile = Join-Path $TestDrive 'parameters.json'
        '{"parameters":{"password":{"value":"file-private-value"},"config":{"value":{"token":"nested-private-value"}}}}' |
            Set-Content -LiteralPath $parameterFile

        $message = Get-TemplateValidationErrorMessage -ParameterFilePath $parameterFile -ValidationErrors @{
            Code    = 'InvalidParameter'
            Message = 'Rejected file-private-value and nested-private-value.'
        }

        $message | Should -Match 'Code: InvalidParameter; Message: Rejected \[REDACTED\] and \[REDACTED\]\.'
        $message | Should -Not -Match 'private-value'
    }

    It 'Reports codes without messages when parameter-file values cannot be inspected: <name>' -ForEach @(
        @{ name = 'vault reference'; file = 'reference.json'; content = '{"parameters":{"password":{"reference":{"keyVault":{"id":"vault"},"secretName":"password"}}}}' }
        @{ name = 'Bicep parameters'; file = 'main.bicepparam'; content = "using './main.bicep'" }
        @{ name = 'malformed JSON'; file = 'invalid.json'; content = '{"parameters":' }
        @{ name = 'missing file'; file = 'missing.json'; content = $null }
    ) {
        $parameterFile = Join-Path $TestDrive $file
        if ($null -ne $content) { Set-Content -LiteralPath $parameterFile -Value $content }

        $message = Get-TemplateValidationErrorMessage -ParameterFilePath $parameterFile -ValidationErrors @{
            Code    = 'InvalidTemplateDeployment'
            Message = 'Unknown-private-value'
            Target  = 'Unknown-private-value'
            Details = @(@{ Code = 'InvalidParameter'; Message = 'Unknown-private-value' })
        }

        $message | Should -Match 'Code: InvalidTemplateDeployment'
        $message | Should -Match 'Code: InvalidParameter'
        $message | Should -Match 'parameter-file values cannot be safely redacted'
        $message | Should -Not -Match 'Unknown-private-value'
    }
}

Describe 'Regional validation error classification' {
    It 'Classifies <name> conservatively' -ForEach @(
        @{ name = 'location ineligible'; code = 'RequestDisallowedByAzure'; message = 'See https://aka.ms/locationineligible'; expected = $true }
        @{ name = 'new customers not accepted'; code = 'RequestDisallowedByAzure'; message = 'The selected region is currently not accepting new customers: https://aka.ms/locationineligible.'; expected = $true }
        @{ name = 'regional allocation'; code = 'AllocationFailed'; message = 'Insufficient capacity in this region.'; expected = $true }
        @{ name = 'zonal allocation'; code = 'ZonalAllocationFailed'; message = 'Allocation failed in this zone.'; expected = $true }
        @{ name = 'regional capacity'; code = 'InsufficientCapacity'; message = 'Insufficient capacity in the location.'; expected = $true }
        @{ name = 'regional SKU'; code = 'SkuNotAvailable'; message = 'The requested SKU is not available in location centralus.'; expected = $true }
        @{ name = 'unrelated disallow'; code = 'RequestDisallowedByAzure'; message = 'This subscription is not permitted.'; expected = $false }
        @{ name = 'misleading link suffix'; code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible-not'; expected = $false }
        @{ name = 'RBAC'; code = 'AuthorizationFailed'; message = '403 Forbidden'; expected = $false }
        @{ name = 'authentication'; code = 'InvalidAuthenticationToken'; message = 'Token expired'; expected = $false }
        @{ name = 'policy'; code = 'RequestDisallowedByPolicy'; message = 'See https://aka.ms/locationineligible'; expected = $false }
        @{ name = 'unregistered provider'; code = 'MissingSubscriptionRegistration'; message = 'Register this provider'; expected = $false }
        @{ name = 'invalid template'; code = 'InvalidTemplate'; message = 'Invalid resource reference'; expected = $false }
        @{ name = 'unknown regional text'; code = 'Unknown'; message = 'See https://aka.ms/locationineligible'; expected = $false }
        @{ name = 'quota'; code = 'QuotaExceeded'; message = 'Capacity quota in region'; expected = $false }
        @{ name = 'configuration allocation'; code = 'AllocationFailed'; message = 'A configuration constraint failed.'; expected = $false }
        @{ name = 'nonregional SKU'; code = 'SkuNotAvailable'; message = 'SKU is not available for this subscription.'; expected = $false }
        @{ name = 'assertion'; code = 'AssertionFailed'; message = 'Location assertion failed'; expected = $false }
        @{ name = 'unsupported zones'; code = 'AvailabilityZoneNotSupported'; message = "The supported zones for location are ''."; expected = $false }
        @{ name = 'missing code'; code = ''; message = "Capacity is unavailable in region 'norwayeast'."; expected = $false }
    ) {
        $errorRecord = New-TestValidationError -Response @{ code = $code; message = $message }
        Test-RegionalValidationError -ErrorRecord $errorRecord | Should -Be $expected
    }

    It 'Reads a nested ARM error from <source>' -ForEach @(
        @{ source = 'returned validation errors'; asDetails = $false }
        @{ source = 'JSON ErrorDetails'; asDetails = $true }
    ) {
        $response = @{ error = @{
                code    = 'InvalidTemplateDeployment'
                details = @(@{ code = 'RequestDisallowedByAzure'; message = 'See https://aka.ms/locationineligible.' })
            }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response -ErrorDetails:$asDetails) | Should -BeTrue
    }

    It 'Rejects a mixed regional and permanent error tree' {
        $response = @{
            code    = 'InvalidTemplateDeployment'
            details = @(
                @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }
                @{ code = 'AuthorizationFailed'; message = 'Forbidden' }
            )
        }

        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) | Should -BeFalse
    }

    It 'Only accepts ResourceDeploymentFailure when every descendant is regional: <kind>' -ForEach @(
        @{ kind = 'regional'; details = @(@{ code = 'SkuNotAvailable'; message = 'Standard_B12ms is not available in location ItalyNorth.' }); expected = $true }
        @{ kind = 'empty'; details = @(); expected = $false }
        @{ kind = 'unknown'; details = @(@{ code = 'Unknown'; message = 'Region failure.' }); expected = $false }
        @{ kind = 'mixed'; details = @(@{ code = 'SkuNotAvailable'; message = 'SKU not available in location ItalyNorth.' }, @{ code = 'InvalidParameter'; message = 'EncryptionAtHost is not enabled for this subscription.' }); expected = $false }
    ) {
        $response = @{ code = 'DeploymentFailed'; details = @(
                @{ code = 'ResourceDeploymentFailure'; message = 'The resource write operation reached terminal provisioning state Failed.'; details = $details }
            )
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) | Should -Be $expected
    }

    It 'Reads Az PowerShell property casing as well as ARM JSON casing' {
        $response = @{ Code = 'InvalidTemplateDeployment'; Details = @(
                @{ Code = 'RequestDisallowedByAzure'; Message = 'https://aka.ms/locationineligible' }
            )
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) | Should -BeTrue
    }

    It 'Rejects ambiguous duplicate properties with different casing' {
        $response = '{"code":"RequestDisallowedByAzure","Code":"AuthorizationFailed","message":"https://aka.ms/locationineligible"}'
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response -ErrorDetails) | Should -BeFalse
    }

    It 'Rejects <name> even when regional details exist elsewhere' -ForEach @(
        @{ name = 'unknown wrapper'; response = @{ code = 'Unknown'; details = @(@{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }) } }
        @{ name = 'permanent wrapper'; response = @{ code = 'InvalidTemplate'; details = @(@{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }) } }
        @{ name = 'empty wrapper'; response = @{ code = 'InvalidTemplateDeployment'; details = @() } }
        @{ name = 'malformed details'; response = @{ code = 'InvalidTemplateDeployment'; details = @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' } } }
        @{ name = 'null detail'; response = @{ code = 'InvalidTemplateDeployment'; details = @($null) } }
        @{ name = 'unknown inner error'; response = @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible'; innererror = @{ code = 'Unknown' } } }
        @{ name = 'unclassified additional information'; response = @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible'; additionalInfo = @(@{ type = 'PolicyViolation'; info = @{} }) } }
        @{ name = 'contradictory envelope'; response = @{ code = 'AuthorizationFailed'; error = @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' } } }
        @{ name = 'mixed response array'; response = @(@{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }, @{ message = 'Missing code' }) }
    ) {
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) | Should -BeFalse
    }

    It 'Rejects malformed JSON and unstructured exceptions' -ForEach @(
        @{ response = '{"error":'; asDetails = $true }
        @{ response = '403 Forbidden https://aka.ms/locationineligible'; asDetails = $true }
        @{ response = $null; asDetails = $false }
    ) {
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response -ErrorDetails:$asDetails) | Should -BeFalse
    }

    It 'Does not retry HTTP 403 even if the error payload claims a regional failure' {
        $record = New-TestValidationError -Response @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 403 }
        Test-RegionalValidationError -ErrorRecord $record | Should -BeFalse
    }

    It 'Does not retry cancellation with a regional payload' {
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.OperationCanceledException]::new('Cancelled'),
            'TemplateValidationFailed',
            [System.Management.Automation.ErrorCategory]::NotSpecified,
            @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }
        )
        Test-RegionalValidationError -ErrorRecord $record | Should -BeFalse
    }

    It 'Does not retry wrapped permission or cancellation exceptions' -ForEach @(
        @{ innerType = 'System.OperationCanceledException' }
        @{ innerType = 'System.UnauthorizedAccessException' }
    ) {
        $inner = New-Object -TypeName $innerType -ArgumentList 'Stop'
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Validation failed', $inner),
            'TemplateValidationFailed',
            [System.Management.Automation.ErrorCategory]::InvalidResult,
            @{ code = 'RequestDisallowedByAzure'; message = 'https://aka.ms/locationineligible' }
        )
        Test-RegionalValidationError -ErrorRecord $record | Should -BeFalse
    }
}

Describe 'AKS preflight empty-zone regional capacity classification' {
    BeforeAll {
        $script:aksResponseJson = Get-Content -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath 'fixtures\aks-empty-zones-regional-error.json') -Raw
    }

    BeforeEach {
        $response = $script:aksResponseJson | ConvertFrom-Json -AsHashtable
        $parentFailure = $response.error
        $script:leaf = $parentFailure.details[0]
    }

    It 'Accepts the observed AKS envelope for <reported> matching selected region <selected>' -ForEach @(
        @{ reported = 'swedencentral'; selected = 'swedencentral' }
        @{ reported = 'swedencentral'; selected = 'Sweden Central' }
        @{ reported = 'Sweden Central'; selected = ' SWEDEN CENTRAL ' }
        @{ reported = 'SwedenCentral'; selected = 'swedencentral' }
        @{ reported = 'norwayeast'; selected = 'Norway East' }
        @{ reported = 'West US 2'; selected = 'westus2' }
    ) {
        $leaf.message = $leaf.message.Replace('swedencentral', $reported)
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation $selected | Should -BeTrue
        $parentFailure.Contains('target') | Should -BeFalse
        $leaf.Contains('target') | Should -BeFalse
    }

    It 'Accepts only valid distinct Azure zone values: <zones>' -ForEach @(
        @{ zones = '1' }, @{ zones = '2' }, @{ zones = '3' }, @{ zones = '1,2' }
        @{ zones = '1,3' }, @{ zones = '2,3' }, @{ zones = '1,2,3' }, @{ zones = '3,1,2' }
    ) {
        $leaf.message = $leaf.message.Replace("zone(s) '3'", "zone(s) '$zones'")
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeTrue
    }

    It 'Reads the complete AKS envelope from <source>' -ForEach @(
        @{ source = 'JSON ErrorDetails' }, @{ source = 'explicit operation response' }
        @{ source = 'explicit JSON response' }, @{ source = 'multiple regional operations' }
    ) {
        $record = New-TestValidationError -Response $response -ErrorDetails
        $parameters = @{ ErrorRecord = $record; ResourceLocation = 'swedencentral' }
        if ($source -ne 'JSON ErrorDetails') {
            $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Formatted SDK text is not classification evidence.')
            $parameters.ErrorResponse = $source -eq 'explicit JSON response' ? $script:aksResponseJson : @($response)
            if ($source -eq 'multiple regional operations') {
                $parameters.ErrorResponse += @{ code = 'SkuNotAvailable'; message = 'SKU not available in this location.' }
            }
        }
        Test-RegionalValidationError @parameters | Should -BeTrue
    }

    It 'Accepts Az property casing without weakening code or message checks' {
        $json = $script:aksResponseJson.Replace('"code":', '"Code":').Replace('"details":', '"Details":').Replace('"message":', '"Message":')
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $json -ErrorDetails) -ResourceLocation 'swedencentral' | Should -BeTrue
    }

    It 'Requires a selected resource location' {
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) | Should -BeFalse
    }

    It 'Rejects <kind> selected location evidence' -ForEach @(
        @{ kind = 'null'; selected = $null }, @{ kind = 'empty'; selected = '' }, @{ kind = 'whitespace'; selected = ' ' }
        @{ kind = 'other region'; selected = 'norwayeast' }, @{ kind = 'partial name'; selected = 'sweden' }
        @{ kind = 'region suffix'; selected = 'swedencentral2' }, @{ kind = 'multiple regions'; selected = 'swedencentral,norwayeast' }
    ) {
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation $selected | Should -BeFalse
    }

    It 'Rejects malformed or invalid requested zones: <zones>' -ForEach @(
        @{ zones = '' }, @{ zones = ' ' }, @{ zones = '0' }, @{ zones = '4' }, @{ zones = '-1' }
        @{ zones = '01' }, @{ zones = '1.0' }, @{ zones = 'one' }, @{ zones = '1,4' }, @{ zones = '1,1' }
        @{ zones = '1,2,3,1' }, @{ zones = ',1' }, @{ zones = '1,' }, @{ zones = '1,,2' }, @{ zones = '1, 2' }
        @{ zones = '1 2' }, @{ zones = '1;2' }, @{ zones = '1/2' }, @{ zones = '[1]' }, @{ zones = "'1'" }
        @{ zones = "1`n" }
    ) {
        $leaf.message = $leaf.message.Replace("zone(s) '3'", "zone(s) '$zones'")
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects a nonempty supported-zone set: <zones>' -ForEach @(
        @{ zones = '1' }, @{ zones = '3' }, @{ zones = '1,2,3' }, @{ zones = ' ' }, @{ zones = 'null' }
    ) {
        $leaf.message = $leaf.message.Replace("are ''", "are '$zones'")
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Requires the immediate, complete AKS managed-cluster preflight context: <kind>' -ForEach @(
        @{ kind = 'missing message' }, @{ kind = 'null message' }, @{ kind = 'non-string message' }
        @{ kind = 'wrong parent code' }, @{ kind = 'wrong parent code casing' }, @{ kind = 'unrelated provider' }
        @{ kind = 'agent pool provider' }, @{ kind = 'multiple providers' }, @{ kind = 'not preflight' }
        @{ kind = 'standalone leaf' }, @{ kind = 'targeted standalone leaf' }, @{ kind = 'intermediate wrapper' }
        @{ kind = 'array detail' }, @{ kind = 'innererror instead of details' }, @{ kind = 'unexpected target' }
        @{ kind = 'missing deployment name' }, @{ kind = 'invalid tracking ID' }, @{ kind = 'invalid API date' }
        @{ kind = 'trailing parent text' }, @{ kind = 'parent newline' }, @{ kind = 'prefixed parent text' }
    ) {
        switch ($kind) {
            'missing message' { $parentFailure.Remove('message') }
            'null message' { $parentFailure.message = $null }
            'non-string message' { $parentFailure.message = @($parentFailure.message) }
            'wrong parent code' { $parentFailure.code = 'DeploymentFailed' }
            'wrong parent code casing' { $parentFailure.code = 'invalidtemplatedeployment' }
            'unrelated provider' { $parentFailure.message = $parentFailure.message.Replace('Microsoft.ContainerService/managedClusters', 'Microsoft.Compute/virtualMachineScaleSets') }
            'agent pool provider' { $parentFailure.message = $parentFailure.message.Replace('managedClusters (', 'managedClusters/agentPools (') }
            'multiple providers' { $parentFailure.message = $parentFailure.message.Replace("(2025-10-01)'", "(2025-10-01)', 'Microsoft.Compute/virtualMachines (2025-04-01)'") }
            'not preflight' { $parentFailure.message = $parentFailure.message.Replace('preflight validation', 'deployment') }
            'standalone leaf' { $response = $leaf }
            'targeted standalone leaf' { $leaf.target = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/retry-fixture/providers/Microsoft.ContainerService/managedClusters/private-cluster'; $response = $leaf }
            'intermediate wrapper' { $parentFailure.details = @(@{ code = 'DeploymentFailed'; details = @($leaf) }) }
            'array detail' { $parentFailure.details = @(, @($leaf)) }
            'innererror instead of details' { $parentFailure.Remove('details'); $parentFailure.innererror = $leaf }
            'unexpected target' { $parentFailure.target = 'another-service' }
            'missing deployment name' { $parentFailure.message = $parentFailure.message.Replace('regional-fixture-test-aks-init', '') }
            'invalid tracking ID' { $parentFailure.message = $parentFailure.message.Replace('22222222-2222-2222-2222-222222222222', 'unknown') }
            'invalid API date' { $parentFailure.message = $parentFailure.message.Replace('2025-10-01', '2025-99-99') }
            'trailing parent text' { $parentFailure.message += ' AuthorizationFailed.' }
            'parent newline' { $parentFailure.message += "`n" }
            'prefixed parent text' { $parentFailure.message = 'Forbidden. ' + $parentFailure.message }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects incomplete or altered leaf messages: <kind>' -ForEach @(
        @{ kind = 'generic zone text' }, @{ kind = 'wrong service' }, @{ kind = 'missing cluster' }
        @{ kind = 'missing group' }, @{ kind = 'missing pool' }, @{ kind = 'invalid pool' }, @{ kind = 'missing region' }
        @{ kind = 'malformed region' }, @{ kind = 'nonempty details' }, @{ kind = 'trailing content' }
        @{ kind = 'trailing newline' }, @{ kind = 'unrelated prefix' }, @{ kind = 'missing details suffix' }
    ) {
        switch ($kind) {
            'generic zone text' { $leaf.message = "The zone(s) '3' for resource 'systempool' is not supported. The supported zones for location 'swedencentral' are ''." }
            'wrong service' { $leaf.message = $leaf.message.Replace('container service', 'database service') }
            'missing cluster' { $leaf.message = $leaf.message.Replace('private-cluster', '') }
            'missing group' { $leaf.message = $leaf.message.Replace('retry-fixture', '') }
            'missing pool' { $leaf.message = $leaf.message.Replace("'systempool'", "''") }
            'invalid pool' { $leaf.message = $leaf.message.Replace("'systempool'", "'system/pool'") }
            'missing region' { $leaf.message = $leaf.message.Replace("'swedencentral'", "''") }
            'malformed region' { $leaf.message = $leaf.message.Replace("'swedencentral'", "'swedencentral,norwayeast'") }
            'nonempty details' { $leaf.message += 'AuthorizationFailed.' }
            'trailing content' { $leaf.message += "The supported zones for location 'swedencentral' are '1,2,3'." }
            'trailing newline' { $leaf.message += "`n" }
            'unrelated prefix' { $leaf.message = 'Forbidden. ' + $leaf.message }
            'missing details suffix' { $leaf.message = $leaf.message.Replace('. Details: ', '.') }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects <code> instead of the genuine availability-zone code' -ForEach @(
        @{ code = 'BadRequest' }, @{ code = 'PropertyChangeNotAllowed' }, @{ code = 'Unknown' }
        @{ code = 'QuotaExceeded' }, @{ code = 'AuthorizationFailed' }, @{ code = 'availabilityzonenotsupported' }
    ) {
        $leaf.code = $code
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects additional or contradictory <level> information: <field>' -ForEach @(
        @{ level = 'envelope'; field = 'status'; value = 'Canceled' }
        @{ level = 'envelope'; field = 'status'; value = @('Failed') }
        @{ level = 'envelope'; field = 'code'; value = 'AuthorizationFailed' }
        @{ level = 'envelope'; field = 'additionalInfo'; value = $null }
        @{ level = 'parent'; field = 'additionalInfo'; value = @() }
        @{ level = 'parent'; field = 'innererror'; value = $null }
        @{ level = 'parent'; field = 'unknownError'; value = 'QuotaExceeded' }
        @{ level = 'leaf'; field = 'additionalInfo'; value = $false }
        @{ level = 'leaf'; field = 'details'; value = @() }
        @{ level = 'leaf'; field = 'innererror'; value = $null }
        @{ level = 'leaf'; field = 'target'; value = 'otherpool' }
        @{ level = 'leaf'; field = 'message'; value = @('AvailabilityZoneNotSupported') }
    ) {
        $node = switch ($level) {
            'envelope' { $response }
            'parent' { $parentFailure }
            'leaf' { $leaf }
        }
        $node[$field] = $value
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects a mixed <code> sibling in either order or as an ancestor' -ForEach @(
        @{ code = 'Unknown' }, @{ code = 'QuotaExceeded' }, @{ code = 'AuthorizationFailed' }
        @{ code = 'InvalidAuthenticationToken' }, @{ code = 'Canceled' }, @{ code = 'PropertyChangeNotAllowed' }
    ) {
        $sibling = @{ code = $code; message = 'Not a regional capacity failure.' }
        foreach ($details in @(@($leaf, $sibling), @($sibling, $leaf))) {
            $parentFailure.details = $details
            Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'swedencentral' | Should -BeFalse
        }
        $parentFailure.details = @($leaf)
        $errors = @{ code = $code; details = @($response) }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $errors) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Does not leak AKS parent context to a sibling' {
        $errors = @($response, @{ code = 'InvalidTemplateDeployment'; details = @($leaf) })
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $errors) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects unclassified information in a regional sibling in either order: <kind>' -ForEach @(
        @{ kind = 'contradictory status' }, @{ kind = 'additional information' }, @{ kind = 'unknown field' }
    ) {
        $sibling = @{ error = @{ code = 'SkuNotAvailable'; message = 'SKU not available in this location.' } }
        switch ($kind) {
            'contradictory status' { $sibling.status = 'Canceled' }
            'additional information' { $sibling.additionalInfo = @{ code = 'AuthorizationFailed' } }
            'unknown field' { $sibling.error.unknownError = 'QuotaExceeded' }
        }
        foreach ($errors in @(@($sibling, $response), @($response, $sibling))) {
            Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $errors) -ResourceLocation 'swedencentral' | Should -BeFalse
        }
    }

    It 'Keeps each contextual capacity error tied to the selected region' {
        $cosmosJson = Get-Content -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath 'fixtures\ml-cosmos-regional-error.json') -Raw
        $cosmos = $cosmosJson.Replace('Norway East', 'Sweden Central') | ConvertFrom-Json -AsHashtable
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response @($response, $cosmos)) -ResourceLocation 'swedencentral' | Should -BeTrue
        $other = $script:aksResponseJson.Replace('swedencentral', 'norwayeast') | ConvertFrom-Json -AsHashtable
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response @($response, $other)) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Rejects malformed, duplicate or trailing JSON evidence: <kind>' -ForEach @(
        @{ kind = 'malformed' }, @{ kind = 'trailing text' }, @{ kind = 'two objects' }, @{ kind = 'comment' }
        @{ kind = 'trailing comma' }, @{ kind = 'duplicate code' }, @{ kind = 'case-duplicate code' }
        @{ kind = 'escaped duplicate code' }, @{ kind = 'duplicate status' }, @{ kind = 'duplicate sibling code' }
    ) {
        $json = switch ($kind) {
            'malformed' { '{"error":' }
            'trailing text' { $script:aksResponseJson + 'Forbidden.' }
            'two objects' { $script:aksResponseJson + $script:aksResponseJson }
            'comment' { '/* AuthorizationFailed */' + $script:aksResponseJson }
            'trailing comma' { $script:aksResponseJson.TrimEnd().Insert($script:aksResponseJson.TrimEnd().Length - 1, ',') }
            'duplicate code' { $script:aksResponseJson.Replace('"code": "AvailabilityZoneNotSupported"', '"code": "AuthorizationFailed", "code": "AvailabilityZoneNotSupported"') }
            'case-duplicate code' { $script:aksResponseJson.Replace('"code": "AvailabilityZoneNotSupported"', '"Code": "AuthorizationFailed", "code": "AvailabilityZoneNotSupported"') }
            'escaped duplicate code' { $script:aksResponseJson.Replace('"code": "AvailabilityZoneNotSupported"', '"\u0063ode": "AuthorizationFailed", "code": "AvailabilityZoneNotSupported"') }
            'duplicate status' { $script:aksResponseJson.Replace('"status": "Failed"', '"status": "Canceled", "status": "Failed"') }
            'duplicate sibling code' { '[{"code":"AuthorizationFailed","code":"SkuNotAvailable","message":"SKU not available in this location."},' + $script:aksResponseJson + ']' }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $json -ErrorDetails) -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Does not override HTTP <status> evidence for the exact AKS envelope' -ForEach @(
        @{ status = 401 }, @{ status = 403 }, @{ status = 404 }, @{ status = 429 }, @{ status = 500 }, @{ status = 504 }
    ) {
        $record = New-TestValidationError -Response $response
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Does not override the <category> category for the exact AKS envelope' -ForEach @(
        @{ category = 'AuthenticationError' }, @{ category = 'PermissionDenied' }
        @{ category = 'SecurityError' }, @{ category = 'OperationStopped' }
    ) {
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Forbidden or stopped.'),
            'TemplateValidationFailed', [System.Management.Automation.ErrorCategory] $category, $response
        )
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Does not override wrapped <type> evidence for the exact AKS envelope' -ForEach @(
        @{ type = 'System.OperationCanceledException' }, @{ type = 'System.Threading.Tasks.TaskCanceledException' }
        @{ type = 'System.Management.Automation.PipelineStoppedException' }, @{ type = 'System.UnauthorizedAccessException' }
    ) {
        $inner = New-Object -TypeName $type -ArgumentList 'Stop'
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Failed', $inner),
            'TemplateValidationFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $response
        )
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'swedencentral' | Should -BeFalse
    }

    It 'Preserves the original response and ErrorRecord' {
        $original = $response | ConvertTo-Json -Depth 20
        $record = New-TestValidationError -Response $response
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'swedencentral' | Should -BeTrue
        [object]::ReferenceEquals($record.TargetObject, $response) | Should -BeTrue
        ($response | ConvertTo-Json -Depth 20) | Should -BeExactly $original
        $record.Exception.Message | Should -BeExactly 'Template is not valid.'
    }
}

Describe 'Machine Learning Cosmos regional capacity classification' {
    BeforeAll {
        $script:cosmosResponseJson = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'ml-cosmos-regional-error.json') -Raw
    }

    BeforeEach {
        $response = $script:cosmosResponseJson | ConvertFrom-Json -AsHashtable
        $workspaceFailure = $response.error.details[0]
        $leaf = $workspaceFailure.details[0]
        $jsonStart = $leaf.message.IndexOf('Error : Message: ') + 'Error : Message: '.Length
        $jsonEnd = $leaf.message.LastIndexOf(', Request URI: /serviceReservation')
        $script:embeddedJson = $leaf.message.Substring($jsonStart, $jsonEnd - $jsonStart)
    }

    It 'Accepts the captured envelope with <display> matching selected location <selected>' -ForEach @(
        @{ display = 'Norway East'; selected = 'norwayeast' }
        @{ display = 'Norway East'; selected = 'Norway East' }
        @{ display = 'Norway East'; selected = ' NORWAY EAST ' }
        @{ display = 'norwayeast'; selected = 'Norway East' }
        @{ display = 'NorwayEast'; selected = 'norwayeast' }
        @{ display = 'West US 2'; selected = 'westus2' }
    ) {
        $leaf.message = $leaf.message.Replace('Norway East', $display)
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation $selected | Should -BeTrue
    }

    It 'Reads the complete ML envelope from <source>' -ForEach @(
        @{ source = 'JSON ErrorDetails' }, @{ source = 'explicit operation response' }, @{ source = 'multiple regional operations' }
    ) {
        $record = New-TestValidationError -Response $response -ErrorDetails
        $parameters = @{ ErrorRecord = $record; ResourceLocation = 'norwayeast' }
        if ($source -ne 'JSON ErrorDetails') {
            $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Formatted SDK text is not classification evidence.')
            $parameters.ErrorResponse = @($response)
            if ($source -eq 'multiple regional operations') {
                $parameters.ErrorResponse += @{ code = 'SkuNotAvailable'; message = 'SKU not available in this location.' }
            }
        }
        Test-RegionalValidationError @parameters | Should -BeTrue
    }

    It 'Parses embedded JSON rather than depending on property order or formatting' {
        $cosmos = $embeddedJson | ConvertFrom-Json -AsHashtable
        $formatted = [ordered]@{ message = $cosmos.message; code = $cosmos.code } | ConvertTo-Json
        $leaf.message = $leaf.message.Replace($embeddedJson, $formatted)
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeTrue
    }

    It 'Rejects a missing selected resource location' {
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) | Should -BeFalse
    }

    It 'Rejects <kind> selected location evidence' -ForEach @(
        @{ kind = 'null'; location = $null }
        @{ kind = 'empty'; location = '' }
        @{ kind = 'whitespace'; location = ' ' }
        @{ kind = 'secondary region'; location = 'swedencentral' }
        @{ kind = 'partial region'; location = 'norway' }
        @{ kind = 'region suffix'; location = 'norwayeast2' }
    ) {
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation $location | Should -BeFalse
    }

    It 'Requires the immediate ML resource-failure target: <kind>' -ForEach @(
        @{ kind = 'missing' }, @{ kind = 'empty' }, @{ kind = 'non-string' }
        @{ kind = 'different service' }, @{ kind = 'child resource' }, @{ kind = 'trailing slash' }
        @{ kind = 'relative target' }, @{ kind = 'prefixed target' }, @{ kind = 'invalid subscription' }
        @{ kind = 'query suffix' }, @{ kind = 'conflicting leaf target' }, @{ kind = 'standalone leaf' }
        @{ kind = 'standalone targeted leaf' }, @{ kind = 'intermediate wrapper' }, @{ kind = 'array detail' }
    ) {
        switch ($kind) {
            'missing' { $workspaceFailure.Remove('target') }
            'empty' { $workspaceFailure.target = '' }
            'non-string' { $workspaceFailure.target = @($workspaceFailure.target) }
            'different service' { $workspaceFailure.target = $workspaceFailure.target.Replace('Microsoft.MachineLearningServices/workspaces', 'Microsoft.DocumentDB/databaseAccounts') }
            'child resource' { $workspaceFailure.target += '/connections/connection' }
            'trailing slash' { $workspaceFailure.target += '/' }
            'relative target' { $workspaceFailure.target = 'Microsoft.MachineLearningServices/workspaces/encrypted-workspace' }
            'prefixed target' { $workspaceFailure.target = 'unrelated' + $workspaceFailure.target }
            'invalid subscription' { $workspaceFailure.target = $workspaceFailure.target.Replace('11111111-1111-1111-1111-111111111111', 'not-a-subscription') }
            'query suffix' { $workspaceFailure.target += '?other=true' }
            'conflicting leaf target' { $leaf.target = $workspaceFailure.target + '-other' }
            'standalone leaf' { $response = $leaf }
            'standalone targeted leaf' { $leaf.target = $workspaceFailure.target; $response = $leaf }
            'intermediate wrapper' { $workspaceFailure.details = @(@{ code = 'DeploymentFailed'; details = @($leaf) }) }
            'array detail' { $workspaceFailure.details = @(, @($leaf)) }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Accepts a consistent explicit leaf target and case-insensitive ARM target' {
        $leaf.target = $workspaceFailure.target.ToUpperInvariant()
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeTrue
    }

    It 'Does not leak workspace context to a sibling error' {
        $response.error.details += @{ code = 'ResourceDeploymentFailure'; details = @($leaf) }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects unclassified information in a <position> regional sibling: <kind>' -ForEach @(
        @{ position = 'preceding'; kind = 'envelope additionalInfo' }
        @{ position = 'following'; kind = 'envelope additionalInfo' }
        @{ position = 'preceding'; kind = 'contradictory status' }
        @{ position = 'following'; kind = 'contradictory status' }
        @{ position = 'preceding'; kind = 'unknown error field' }
        @{ position = 'following'; kind = 'unknown error field' }
    ) {
        $sibling = @{ error = @{ code = 'SkuNotAvailable'; message = 'SKU not available in this location.' } }
        switch ($kind) {
            'envelope additionalInfo' { $sibling.additionalInfo = @{ code = 'AuthorizationFailed' } }
            'contradictory status' { $sibling.status = 'Canceled' }
            'unknown error field' { $sibling.error.unknownError = 'QuotaExceeded' }
        }
        $errors = $position -eq 'preceding' ? @($sibling, $response) : @($response, $sibling)
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $errors) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects extra or contradictory information at the <level> level: <field>' -ForEach @(
        @{ level = 'envelope'; field = 'additionalInfo'; value = @{ code = 'AuthorizationFailed' } }
        @{ level = 'envelope'; field = 'message'; value = 'Forbidden.' }
        @{ level = 'envelope'; field = 'status'; value = 'Canceled' }
        @{ level = 'envelope'; field = 'status'; value = @('Failed') }
        @{ level = 'deployment'; field = 'additionalInfo'; value = @() }
        @{ level = 'deployment'; field = 'unknownError'; value = 'QuotaExceeded' }
        @{ level = 'deployment'; field = 'message'; value = @{ code = 'Forbidden' } }
        @{ level = 'workspace'; field = 'additionalInfo'; value = @{ code = 'InvalidParameter' } }
        @{ level = 'workspace'; field = 'additionalInfo'; value = $null }
        @{ level = 'workspace'; field = 'unknownError'; value = 'QuotaExceeded' }
        @{ level = 'leaf'; field = 'additionalInfo'; value = @{ code = 'Forbidden' } }
        @{ level = 'leaf'; field = 'additionalInfo'; value = $false }
        @{ level = 'leaf'; field = 'details'; value = @() }
        @{ level = 'leaf'; field = 'details'; value = @(@{ code = 'SkuNotAvailable'; message = 'SKU not available in this location.' }) }
        @{ level = 'leaf'; field = 'innererror'; value = $null }
        @{ level = 'leaf'; field = 'innererror'; value = @{ code = 'InvalidParameter'; message = 'Invalid key.' } }
        @{ level = 'leaf'; field = 'unknownError'; value = 'QuotaExceeded' }
    ) {
        $node = switch ($level) {
            'envelope' { $response }
            'deployment' { $response.error }
            'workspace' { $workspaceFailure }
            'leaf' { $leaf }
        }
        $node[$field] = $value
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects a <code> ancestor or additional permanent descendant' -ForEach @(
        @{ code = 'Unknown' }, @{ code = 'QuotaExceeded' }, @{ code = 'AuthorizationFailed' }
        @{ code = 'InvalidAuthenticationToken' }, @{ code = 'InvalidTemplate' }, @{ code = 'BadRequest' }
    ) {
        $response.error.details += @{ code = $code; message = 'Permanent or unknown failure.' }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
        $response.error.details = @($workspaceFailure)
        $response.error.code = $code
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects an otherwise valid failure from another region in the same response array' {
        $other = $script:cosmosResponseJson.Replace('Norway East', 'Sweden Central') | ConvertFrom-Json -AsHashtable
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response @($response, $other)) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects case-duplicate ARM fields above the embedded payload' {
        $ambiguous = $script:cosmosResponseJson.Replace('"code": "BadRequest"', '"code": "BadRequest", "Code": "AuthorizationFailed"')
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $ambiguous -ErrorDetails) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects <kind> embedded JSON without selecting a positive fragment' -ForEach @(
        @{ kind = 'malformed' }, @{ kind = 'trailing comma' }, @{ kind = 'comment' }, @{ kind = 'two objects' }
        @{ kind = 'array' }, @{ kind = 'missing code' }, @{ kind = 'missing message' }, @{ kind = 'non-string code' }
        @{ kind = 'non-string message' }, @{ kind = 'duplicate code' }, @{ kind = 'case-duplicate code' }
        @{ kind = 'escaped duplicate code' }, @{ kind = 'duplicate message' }, @{ kind = 'case-duplicate message' }
        @{ kind = 'extra details' }, @{ kind = 'extra additionalInfo' }, @{ kind = 'unknown property' }
    ) {
        $replacement = switch ($kind) {
            'malformed' { $embeddedJson.Replace('{"code":', '{"code" ') }
            'trailing comma' { $embeddedJson.Insert($embeddedJson.Length - 1, ',') }
            'comment' { $embeddedJson.Replace('{"code":', '{/* extra */"code":') }
            'two objects' { "$embeddedJson $embeddedJson" }
            'array' { "[$embeddedJson]" }
            'missing code' { $embeddedJson.Replace('"code":"ServiceUnavailable",', '') }
            'missing message' { '{"code":"ServiceUnavailable"}' }
            'non-string code' { $embeddedJson.Replace('"code":"ServiceUnavailable"', '"code":["ServiceUnavailable"]') }
            'non-string message' { '{"code":"ServiceUnavailable","message":null}' }
            'duplicate code' { $embeddedJson.Replace('{"code":', '{"code":"AuthorizationFailed","code":') }
            'case-duplicate code' { $embeddedJson.Replace('{"code":', '{"Code":"AuthorizationFailed","code":') }
            'escaped duplicate code' { $embeddedJson.Replace('{"code":', '{"\u0063ode":"AuthorizationFailed","code":') }
            'duplicate message' { $embeddedJson.Replace('"message":', '"message":"Forbidden.","message":') }
            'case-duplicate message' { $embeddedJson.Replace('"message":', '"Message":"Forbidden.","message":') }
            'extra details' { $embeddedJson.Replace('{"code":', '{"details":[],"code":') }
            'extra additionalInfo' { $embeddedJson.Replace('{"code":', '{"additionalInfo":{"code":"InvalidParameter"},"code":') }
            'unknown property' { $embeddedJson.Replace('{"code":', '{"unknown":"Forbidden","code":') }
        }
        $leaf.message = $leaf.message.Replace($embeddedJson, $replacement)
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects an embedded <code> code despite the high-demand wording' -ForEach @(
        @{ code = 'BadRequest' }, @{ code = 'QuotaExceeded' }, @{ code = 'AuthorizationFailed' }
        @{ code = 'InvalidAuthenticationToken' }, @{ code = 'InvalidParameter' }, @{ code = 'Forbidden' }
        @{ code = 'RequestRateTooLarge' }, @{ code = 'ServiceBusy' }, @{ code = 'serviceunavailable' }, @{ code = '' }
    ) {
        $leaf.message = $leaf.message.Replace('"code":"ServiceUnavailable"', ('"code":"' + $code + '"'))
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects a generic <code> even with the full Cosmos message' -ForEach @(
        @{ code = 'BadRequest' }, @{ code = 'ServiceUnavailable' }
    ) {
        $leaf.code = $code
        $leaf.message = ($embeddedJson | ConvertFrom-Json).message
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects captured AKS PropertyChangeNotAllowed JSON in <context>' -ForEach @(
        @{ context = 'the observed AKS envelope' }, @{ context = 'an ML workspace wrapper' }, @{ context = 'a mixed Cosmos response' }
    ) {
        $aks = '{"code":"BadRequest","target":"/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/retry-fixture/providers/Microsoft.ContainerService/managedClusters/automatic-cluster","message":"{\r\n  \"code\": \"PropertyChangeNotAllowed\",\r\n  \"details\": null,\r\n  \"message\": \"Changing property \\\"agentPoolProfile.availabilityZone\\\" is not allowed in an api-version before \\\"2026-01-02-preview\\\".\",\r\n  \"subcode\": \"\",\r\n  \"target\": \"agentPoolProfile.availabilityZone\"\r\n}"}' |
            ConvertFrom-Json -AsHashtable
        switch ($context) {
            'the observed AKS envelope' { $response.error.details = @($aks) }
            'an ML workspace wrapper' { $leaf.message = $aks.message }
            'a mixed Cosmos response' { $response.error.details += $aks }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects <kind> Cosmos messages' -ForEach @(
        @{ kind = 'configuration'; message = 'Invalid database account configuration.' }
        @{ kind = 'quota'; message = 'The subscription has exceeded its database account quota in Norway East.' }
        @{ kind = 'key access'; message = 'The encryption key could not be accessed.' }
        @{ kind = 'permission'; message = 'This subscription is not authorized to create accounts in Norway East.' }
        @{ kind = 'authentication'; message = 'Authentication token expired.' }
        @{ kind = 'generic availability'; message = 'Service unavailable in Norway East.' }
    ) {
        $cosmos = $embeddedJson | ConvertFrom-Json -AsHashtable
        $cosmos.message = "$message See https://aka.ms/cosmosdbquota for more information."
        $leaf.message = $leaf.message.Replace($embeddedJson, ($cosmos | ConvertTo-Json -Compress))
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects missing or misleading quota links: <link>' -ForEach @(
        @{ link = '' }, @{ link = 'http://aka.ms/cosmosdbquota' }, @{ link = 'https://aka.ms/cosmosdbquota-not' }
        @{ link = 'https://aka.ms/cosmosdbquota/other' }, @{ link = 'https://aka.ms/cosmosdbquota?other=true' }
        @{ link = 'https://aka.ms/cosmosdbquota#other' }, @{ link = 'https://aka.ms/cosmosdbquota.example.invalid' }
        @{ link = 'https://aka.ms.example.invalid/cosmosdbquota' }, @{ link = 'https://example.invalid/cosmosdbquota' }
    ) {
        $leaf.message = $leaf.message.Replace('https://aka.ms/cosmosdbquota', $link)
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Rejects a changed wrapper or diagnostic suffix: <kind>' -ForEach @(
        @{ kind = 'unrelated prefix' }, @{ kind = 'additional trailing failure' }, @{ kind = 'missing wrapper' }
        @{ kind = 'other operation' }, @{ kind = 'invalid operation ID' }, @{ kind = 'different URI' }
        @{ kind = 'nonempty request stats' }, @{ kind = 'SDK failure text' }, @{ kind = 'invalid activity ID' }
        @{ kind = 'invalid timestamp' }, @{ kind = 'embedded trailing permission failure' }, @{ kind = 'region access without high demand' }
    ) {
        switch ($kind) {
            'unrelated prefix' { $leaf.message = 'Forbidden. ' + $leaf.message }
            'additional trailing failure' { $leaf.message += ' Another resource failed permanently.' }
            'missing wrapper' { $leaf.message = $embeddedJson }
            'other operation' { $leaf.message = $leaf.message.Replace('Database account creation failed.', 'Database account update failed.') }
            'invalid operation ID' { $leaf.message = $leaf.message.Replace('22222222-2222-2222-2222-222222222222', 'unknown') }
            'different URI' { $leaf.message = $leaf.message.Replace('/serviceReservation', '/databaseAccounts') }
            'nonempty request stats' { $leaf.message = $leaf.message.Replace('RequestStats: ,', 'RequestStats: AuthorizationFailed,') }
            'SDK failure text' { $leaf.message = $leaf.message.Replace("2.14.0'", "2.14.0, Forbidden'") }
            'invalid activity ID' { $leaf.message = $leaf.message.Replace('33333333-3333-3333-3333-333333333333', 'unknown') }
            'invalid timestamp' { $leaf.message = $leaf.message.Replace('Mon, 05 Oct 2026', 'Mon, 99 Oct 2026') }
            'embedded trailing permission failure' { $leaf.message = $leaf.message.Replace('2.14.0"}', '2.14.0. Forbidden."}') }
            'region access without high demand' { $leaf.message = $leaf.message.Replace('experiencing high demand', 'denying subscription access') }
        }
        Test-RegionalValidationError -ErrorRecord (New-TestValidationError -Response $response) -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Does not override HTTP <status> evidence' -ForEach @(
        @{ status = 401 }, @{ status = 403 }, @{ status = 404 }, @{ status = 429 }, @{ status = 500 }, @{ status = 504 }
    ) {
        $record = New-TestValidationError -Response $response
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Does not override the <category> category' -ForEach @(
        @{ category = 'AuthenticationError' }, @{ category = 'PermissionDenied' }
        @{ category = 'SecurityError' }, @{ category = 'OperationStopped' }
    ) {
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Forbidden or stopped.'),
            'TemplateValidationFailed', [System.Management.Automation.ErrorCategory] $category, $response
        )
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Does not override wrapped <type> evidence' -ForEach @(
        @{ type = 'System.OperationCanceledException' }, @{ type = 'System.Threading.Tasks.TaskCanceledException' }
        @{ type = 'System.Management.Automation.PipelineStoppedException' }, @{ type = 'System.UnauthorizedAccessException' }
    ) {
        $inner = New-Object -TypeName $type -ArgumentList 'Stop'
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Failed', $inner),
            'TemplateValidationFailed', [System.Management.Automation.ErrorCategory]::InvalidResult, $response
        )
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'norwayeast' | Should -BeFalse
    }

    It 'Preserves the original response and error record during classification' {
        $original = $response | ConvertTo-Json -Depth 20
        $record = New-TestValidationError -Response $response
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation 'norwayeast' | Should -BeTrue
        [object]::ReferenceEquals($record.TargetObject, $response) | Should -BeTrue
        ($response | ConvertTo-Json -Depth 20) | Should -BeExactly $original
        $record.Exception.Message | Should -BeExactly 'Template is not valid.'
    }
}

Describe 'Bounded template validation with actual runtime helpers' {
    BeforeAll {
        function Get-AzResourceProvider {
            [CmdletBinding()]
            param([string[]] $ProviderNamespace)
            throw 'Unexpected provider query.'
        }
        function Get-AzLocation {
            [CmdletBinding()]
            param()
            throw 'Unexpected location query.'
        }
        function Set-AzContext {
            [CmdletBinding()]
            param([string] $Subscription)
            throw 'Unexpected Azure context change.'
        }
        function Test-AzSubscriptionDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime)
            throw 'Unexpected subscription validation.'
        }
        function Test-AzManagementGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $ManagementGroupId, [string] $resourceLocation, [string] $baseTime)
            throw 'Unexpected management group validation.'
        }
        function Test-AzTenantDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime)
            throw 'Unexpected tenant validation.'
        }
        function Get-AzResourceGroup {
            [CmdletBinding()]
            param([string] $Name)
            throw 'Unexpected resource group query.'
        }
        function New-AzResourceGroup {
            [CmdletBinding()]
            param([string] $Name, [string] $Location)
            throw 'Unexpected resource group creation.'
        }
        function Test-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $ResourceGroupName, [string] $resourceLocation, [string] $baseTime)
            throw 'Unexpected resource group validation.'
        }
    }

    BeforeEach {
        $savedTemp = $env:TEMP
        $savedTmpDir = $env:TMPDIR
        $env:TEMP = $TestDrive
        $env:TMPDIR = $TestDrive
        '{"Microsoft.RetryTest":{"widgets":{}}}' | Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
        $templatePath = Join-Path $TestDrive ("template-{0}.json" -f [guid]::NewGuid())
        $template = @{
            '$schema'  = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = @{ resourceLocation = @{ type = 'string' }; baseTime = @{ type = 'string' } }
            variables  = @{ regionToken = '#_resourceLocation_#'; unchanged = 'centralus' }
        }
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $original = [System.IO.File]::ReadAllBytes($templatePath)
        $validationInput = @{
            TemplateFilePath           = $templatePath
            DeploymentMetadataLocation = 'WestEurope'
            SubscriptionId             = '11111111-1111-1111-1111-111111111111'
            ManagementGroupId          = 'test-management-group'
            RepoRoot                   = $repoRootPath
            AdditionalParameters       = @{ resourceLocation = ''; baseTime = 'fixed-base-time' }
        }
        $script:requests = [System.Collections.Generic.List[object]]::new()
        $script:providerLocations = @('Central US', 'East US', 'Korea Central')
        $script:regionalFailure = @{
            Code    = 'InvalidTemplateDeployment'
            Message = 'sensitive-error-payload'
            Details = @(@{ Code = 'RequestDisallowedByAzure'; Message = 'Selected region is not accepting new customers. See https://aka.ms/locationineligible. sensitive-error-payload' })
        }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Get-Random { 0 }
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'widgets'; Locations = $script:providerLocations }) }
        }
        Mock Get-AzLocation {
            @(
                @{ Location = 'centralus'; DisplayName = 'Central US'; RegionCategory = 'Recommended'; PairedRegion = 'eastus2' }
                @{ Location = 'eastus'; DisplayName = 'East US'; RegionCategory = 'Recommended'; PairedRegion = 'westus' }
                @{ Location = 'koreacentral'; DisplayName = 'Korea Central'; RegionCategory = 'Recommended'; PairedRegion = 'koreasouth' }
            )
        }
        Mock Set-AzContext {}
        Mock Get-AzResourceGroup { $null }
        Mock New-AzResourceGroup {}
        Mock Test-AzResourceGroupDeployment { $script:regionalFailure }
        Mock Test-AzSubscriptionDeployment {
            $script:requests.Add(@{
                    Region   = $resourceLocation
                    Metadata = $Location
                    BaseTime = $baseTime
                    Template = Get-Content -LiteralPath $TemplateFile -Raw | ConvertFrom-Json -AsHashtable
                })
            if ($resourceLocation -eq 'centralus') { $script:regionalFailure }
        }
        Mock Test-AzManagementGroupDeployment {
            if ($resourceLocation -eq 'centralus') { $script:regionalFailure }
        }
        Mock Test-AzTenantDeployment {
            if ($resourceLocation -eq 'centralus') { $script:regionalFailure }
        }
    }

    AfterEach {
        $env:TEMP = $savedTemp
        $env:TMPDIR = $savedTmpDir
    }

    It 'Revalidates a different allowed region and leaves only its region tokens for deployment' {
        $location = Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget'

        $location | Should -Be 'eastus'
        @($script:requests.Region) | Should -Be @('centralus', 'eastus')
        @($script:requests.Template.variables.regionToken) | Should -Be @('centralus', 'eastus')
        @($script:requests.Template.variables.unchanged) | Should -Be @('centralus', 'centralus')
        @($script:requests.Metadata | Sort-Object -Unique) | Should -Be @('WestEurope')
        @($script:requests.BaseTime | Sort-Object -Unique) | Should -Be @('fixed-base-time')
        (Get-Content -LiteralPath $templatePath -Raw | ConvertFrom-Json).variables.regionToken | Should -Be 'eastus'
        $validationInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
        Should -Invoke Set-AzContext -Times 2 -Exactly -ParameterFilter { $Subscription -eq $validationInput.SubscriptionId }
    }

    It 'Bounds regional failures at three distinct candidates and restores pristine files on exhaustion' {
        Mock Test-AzSubscriptionDeployment { $script:requests.Add($resourceLocation); $script:regionalFailure }

        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } |
            Should -Throw '*Template is not valid*'

        @($script:requests) | Should -Be @('centralus', 'eastus', 'koreacentral')
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($original))
    }

    It 'Displays nested Azure error details on a terminal failure and preserves the response' {
        $script:failure = @{
            Code    = 'InvalidTemplateDeployment'
            Message = 'Deployment validation failed for fixed-base-time.'
            Details = @(@{ Code = 'QuotaExceeded'; Message = 'Requested 16 vCores, available 8.'; Target = 'managedInstance' })
        }
        Mock Test-AzSubscriptionDeployment { $script:failure }
        $caughtError = $null

        try {
            Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget'
        } catch {
            $caughtError = $_
        }

        $caughtError | Should -Not -BeNullOrEmpty
        $caughtError.FullyQualifiedErrorId | Should -Match '^TemplateValidationFailed'
        [object]::ReferenceEquals($caughtError.TargetObject, $script:failure) | Should -BeTrue
        $caughtError.ErrorDetails.Message | Should -Match 'Code: QuotaExceeded; Message: Requested 16 vCores, available 8\.; Target: managedInstance'
        $caughtError.ErrorDetails.Message | Should -Not -Match 'fixed-base-time'
        ($caughtError | Out-String) | Should -Match 'QuotaExceeded'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Retains readable Azure details when regional retries are exhausted' {
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        $caughtError = $null

        try {
            Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget'
        } catch {
            $caughtError = $_
        }

        $caughtError | Should -Not -BeNullOrEmpty
        $caughtError.ErrorDetails.Message | Should -Match 'Code: InvalidTemplateDeployment'
        $caughtError.ErrorDetails.Message | Should -Match 'Code: RequestDisallowedByAzure'
        Test-RegionalValidationError -ErrorRecord $caughtError | Should -BeTrue
        Should -Invoke Test-AzSubscriptionDeployment -Times 3 -Exactly
    }

    It 'Refreshes region tokens in locally referenced Bicep files from pristine inputs' {
        $bicepPath = Join-Path $TestDrive 'main.test.bicep'
        $childPath = Join-Path $TestDrive 'child.bicep'
        @'
targetScope = 'subscription'
param resourceLocation string
module child './child.bicep' = {
  name: 'child'
  params: {
    location: '#_resourceLocation_#'
  }
}
'@ | Set-Content -LiteralPath $bicepPath
        "param location string = '#_resourceLocation_#'`nvar unrelated = 'centralus'" | Set-Content -LiteralPath $childPath
        $validationInput.TemplateFilePath = $bicepPath
        Mock Test-AzSubscriptionDeployment {
            Get-Content -LiteralPath $TemplateFile -Raw | Should -Match "location: '$resourceLocation'"
            Get-Content -LiteralPath $childPath -Raw | Should -Match "param location string = '$resourceLocation'"
            Get-Content -LiteralPath $childPath -Raw | Should -Match "unrelated = 'centralus'"
            if ($resourceLocation -eq 'centralus') { $script:regionalFailure }
        }
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' | Should -Be 'eastus'
        Get-Content -LiteralPath $childPath -Raw | Should -Match "param location string = 'eastus'"
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Retries structured ErrorDetails exceptions as well as returned validation errors' {
        Mock Test-AzSubscriptionDeployment {
            if ($resourceLocation -eq 'centralus') {
                throw (New-TestValidationError -Response @{ error = $script:regionalFailure } -ErrorDetails)
            }
        }
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' | Should -Be 'eastus'
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Stops without validation or file mutation when provider location metadata is still missing' {
        $script:providerLocations = @()
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } |
            Should -Throw '*No location metadata*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($original))
    }

    It 'Does not validate or retry after token replacement fails' {
        Mock Convert-TokensInFileList { $false }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } |
            Should -Throw '*token replacement failed*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Honors a smaller total-attempt limit' {
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' -RetryLimit 2 } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Rejects an invalid attempt limit <limit>' -ForEach @(@{ limit = 0 }, @{ limit = 4 }) {
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' -RetryLimit $limit } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Stops when supported candidates are exhausted without returning to the metadata location' {
        $script:providerLocations = @('Central US')
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } |
            Should -Throw '*No supported, allowed regions remain*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-Random -Times 1 -Exactly
    }

    It 'Does not retry <code> errors' -ForEach @(
        @{ code = 'AuthorizationFailed' }, @{ code = 'InvalidAuthenticationToken' }, @{ code = 'InvalidTemplate' },
        @{ code = 'MissingSubscriptionRegistration' }, @{ code = 'AssertionFailed' }
    ) {
        Mock Test-AzSubscriptionDeployment { @{ Code = $code; Message = 'sensitive-error-payload' } }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Does not retry mixed errors' {
        $script:regionalFailure.Details += @{ Code = 'AuthorizationFailed'; Message = 'Forbidden' }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Rejects malformed returned errors instead of reporting successful validation' {
        Mock Test-AzSubscriptionDeployment { @{ Code = ''; Message = 'Malformed validation failure' } }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw '*Template is not valid*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Propagates a thrown authentication error without another candidate' {
        Mock Test-AzSubscriptionDeployment { throw '403 Forbidden' }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw '*403 Forbidden*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Propagates cancellation and restores region-token files' {
        Mock Test-AzSubscriptionDeployment { throw [System.OperationCanceledException]::new('Validation cancelled') }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw '*Validation cancelled*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($original))
    }

    It 'Stops before reselection when restoring a failed attempt cannot complete' {
        Mock Test-AzSubscriptionDeployment {
            Remove-Item -LiteralPath $TemplateFile
            $null = New-Item -Path $TemplateFile -ItemType Directory
            $script:regionalFailure
        }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw '*denied*'
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Keeps explicit <source> locations pinned without querying provider metadata' -ForEach @(
        @{ source = 'custom'; custom = 'WestEurope'; token = ''; parameter = '' }
        @{ source = 'token'; custom = ''; token = 'WestEurope'; parameter = '' }
        @{ source = 'CI'; custom = ''; token = ''; parameter = 'WestEurope' }
    ) {
        $validationInput.AdditionalParameters.resourceLocation = $parameter
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' -CustomLocation $custom -TokenResourceLocation $token } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter { $resourceLocation -eq 'westeurope' }
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Rejects conflicting pins rather than silently overriding customLocation' {
        $validationInput.AdditionalParameters.resourceLocation = 'eastus'
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' -CustomLocation 'centralus' } |
            Should -Throw '*Conflicting resource locations*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Does not relocate an explicitly global resource' {
        $script:providerLocations = @('Global')
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter { $resourceLocation -eq 'WestEurope' }
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
        Should -Invoke Get-AzLocation -Times 0 -Exactly
    }

    It 'Does not relocate or recreate a resource-group-scope validation target' {
        $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $validationInput.ResourceGroupName = 'existing-validation-name'
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw
        Should -Invoke New-AzResourceGroup -Times 1 -Exactly -ParameterFilter {
            $Name -eq 'existing-validation-name' -and $Location -eq 'centralus'
        }
        Should -Invoke Test-AzResourceGroupDeployment -Times 1 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Does not retry when the template has no changeable region input' {
        $template.variables.Remove('regionToken')
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $validationInput.AdditionalParameters.Remove('resourceLocation')
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Keeps a successful nonregional flow to one attempt' {
        Mock Test-AzSubscriptionDeployment {}
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' | Should -Be 'centralus'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Does not print error payloads or parameter values during regional recovery' {
        $messages = Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' 3>&1 4>&1
        ($messages | Out-String) | Should -Match 'centralus.*1/3'
        ($messages | Out-String) | Should -Match 'eastus.*2/3'
        ($messages | Out-String) | Should -Not -Match 'sensitive-error-payload|fixed-base-time'
    }

    It 'Revalidates <scope> scope without changing deployment metadata' -ForEach @(
        @{ scope = 'managementGroup'; schema = 'managementGroupDeploymentTemplate'; command = 'Test-AzManagementGroupDeployment' }
        @{ scope = 'tenant'; schema = 'tenantDeploymentTemplate'; command = 'Test-AzTenantDeployment' }
    ) {
        $template.'$schema' = "https://schema.management.azure.com/schemas/2019-08-01/$schema.json#"
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/retry-test/widget' | Should -Be 'eastus'
        Should -Invoke $command -Times 2 -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
    }
}
