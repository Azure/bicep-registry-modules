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
        @{ name = 'missing code'; code = ''; message = 'https://aka.ms/locationineligible'; expected = $false }
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
        $env:TEMP = $TestDrive
        '{"Microsoft.DevTestLab":{"labs":{}}}' | Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
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
            @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = $script:providerLocations }) }
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
    }

    It 'Revalidates a different allowed region and leaves only its region tokens for deployment' {
        $location = Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab'

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

        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } |
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
            Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab'
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
            Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab'
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
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' | Should -Be 'eastus'
        Get-Content -LiteralPath $childPath -Raw | Should -Match "param location string = 'eastus'"
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Retries structured ErrorDetails exceptions as well as returned validation errors' {
        Mock Test-AzSubscriptionDeployment {
            if ($resourceLocation -eq 'centralus') {
                throw (New-TestValidationError -Response @{ error = $script:regionalFailure } -ErrorDetails)
            }
        }
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' | Should -Be 'eastus'
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Stops without validation or file mutation when provider location metadata is still missing' {
        $script:providerLocations = @()
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } |
            Should -Throw '*No location metadata*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($original))
    }

    It 'Does not validate or retry after token replacement fails' {
        Mock Convert-TokensInFileList { $false }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } |
            Should -Throw '*token replacement failed*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Honors a smaller total-attempt limit' {
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' -RetryLimit 2 } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 2 -Exactly
    }

    It 'Rejects an invalid attempt limit <limit>' -ForEach @(@{ limit = 0 }, @{ limit = 4 }) {
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' -RetryLimit $limit } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Stops when supported candidates are exhausted without returning to the metadata location' {
        $script:providerLocations = @('Central US')
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } |
            Should -Throw '*No supported, allowed regions remain*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-Random -Times 1 -Exactly
    }

    It 'Does not retry <code> errors' -ForEach @(
        @{ code = 'AuthorizationFailed' }, @{ code = 'InvalidAuthenticationToken' }, @{ code = 'InvalidTemplate' },
        @{ code = 'MissingSubscriptionRegistration' }, @{ code = 'AssertionFailed' }
    ) {
        Mock Test-AzSubscriptionDeployment { @{ Code = $code; Message = 'sensitive-error-payload' } }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Does not retry mixed errors' {
        $script:regionalFailure.Details += @{ Code = 'AuthorizationFailed'; Message = 'Forbidden' }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Rejects malformed returned errors instead of reporting successful validation' {
        Mock Test-AzSubscriptionDeployment { @{ Code = ''; Message = 'Malformed validation failure' } }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw '*Template is not valid*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Propagates a thrown authentication error without another candidate' {
        Mock Test-AzSubscriptionDeployment { throw '403 Forbidden' }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw '*403 Forbidden*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Propagates cancellation and restores region-token files' {
        Mock Test-AzSubscriptionDeployment { throw [System.OperationCanceledException]::new('Validation cancelled') }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw '*Validation cancelled*'
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
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw '*denied*'
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
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' -CustomLocation $custom -TokenResourceLocation $token } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter { $resourceLocation -eq 'westeurope' }
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Rejects conflicting pins rather than silently overriding customLocation' {
        $validationInput.AdditionalParameters.resourceLocation = 'eastus'
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' -CustomLocation 'centralus' } |
            Should -Throw '*Conflicting resource locations*'
        Should -Invoke Test-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Does not relocate an explicitly global resource' {
        $script:providerLocations = @('Global')
        Mock Test-AzSubscriptionDeployment { $script:regionalFailure }
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter { $resourceLocation -eq 'WestEurope' }
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
        Should -Invoke Get-AzLocation -Times 0 -Exactly
    }

    It 'Does not relocate or recreate a resource-group-scope validation target' {
        $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $validationInput.ResourceGroupName = 'existing-validation-name'
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw
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
        { Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' } | Should -Throw
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Keeps a successful nonregional flow to one attempt' {
        Mock Test-AzSubscriptionDeployment {}
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' | Should -Be 'centralus'
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
    }

    It 'Does not print error payloads or parameter values during regional recovery' {
        $messages = Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' 3>&1 4>&1
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
        Test-TemplateDeploymentWithRetry -ValidationInput $validationInput -ModuleRoot 'avm/res/dev-test-lab/lab' | Should -Be 'eastus'
        Should -Invoke $command -Times 2 -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
    }
}
