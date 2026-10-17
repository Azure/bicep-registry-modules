param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeAll {
    . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Test-TemplateDeploymentWithRetry.ps1')
    $script:aksPreflightJson = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'aks-empty-zones-regional-error.json') -Raw

    function New-PreflightValidationResponse {
        param(
            [string] $Kind,
            [string] $Location,
            [string] $AvailableRegions = 'centralindia,uksouth,ukwest,eastasia,southeastasia,japaneast,japanwest,australiaeast,canadaeast,canadacentral,northeurope,westeurope,koreacentral,southafricanorth,eastus,westus,westus2,westus3,northcentralus,southcentralus,westcentralus,centralus,eastus2'
        )

        # PSResourceManagerError retains null Target/Details when ARM omits them.
        # https://github.com/Azure/azure-powershell/blob/552b98baec16447a481040808e7e101f1ff568d6/src/Resources/ResourceManager/SdkExtensions/NewResourcesExtensions.cs#L97-L131
        if ($Kind -eq 'ProviderLocation') {
            return [pscustomobject]@{
                Code    = 'LocationNotAvailableForResourceType'
                Message = "The provided location '$Location' is not available for resource type 'Microsoft.DesktopVirtualization/hostpools'. List of available regions for the resource type is '$AvailableRegions'."
                Target  = $null
                Details = $null
            }
        }
        $parent = ($script:aksPreflightJson | ConvertFrom-Json).error
        $leaf = [pscustomobject]@{
            Code    = $parent.details[0].code
            Message = $parent.details[0].message.Replace('swedencentral', $Location).Replace("zone(s) '3'", "zone(s) '1'")
            Target  = $null
            Details = $null
        }
        return [pscustomobject]@{
            Code    = $parent.code
            Message = $parent.message
            Target  = $null
            Details = [System.Collections.Generic.List[object]] @($leaf)
        }
    }

    function New-PreflightErrorRecord {
        param([object] $Response, [switch] $JsonDetails)
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Template is not valid.'),
            ($JsonDetails ? 'AzureValidationFailed' : 'TemplateValidationFailed'),
            [System.Management.Automation.ErrorCategory]::InvalidResult,
            $Response
        )
        $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new(
            ($JsonDetails ? $Response : 'Safe diagnostic text is not classification evidence.')
        )
        return $record
    }
}

Describe 'SDK-shaped <kind> validation errors' -ForEach @(
    @{ kind = 'ProviderLocation'; location = 'norwayeast' }
    @{ kind = 'AksZones'; location = 'eastus' }
) {
    BeforeEach {
        $response = New-PreflightValidationResponse -Kind $kind -Location $location
    }

    It 'Accepts the returned validation model for the selected region' {
        Test-RegionalValidationError -ErrorRecord (New-PreflightErrorRecord $response) -ResourceLocation $location | Should -BeTrue
    }

    It 'Accepts the same complete evidence from <source>' -ForEach @(
        @{ source = 'returned SDK list' }, @{ source = 'JSON ErrorDetails' }
        @{ source = 'explicit operation response' }, @{ source = 'ARM envelope' }
    ) {
        $parameters = @{ ResourceLocation = $location }
        switch ($source) {
            'returned SDK list' {
                $parameters.ErrorRecord = New-PreflightErrorRecord ([System.Collections.Generic.List[object]] @($response))
            }
            'JSON ErrorDetails' {
                $parameters.ErrorRecord = New-PreflightErrorRecord (ConvertTo-Json -InputObject $response -Depth 10) -JsonDetails
            }
            'explicit operation response' {
                $parameters.ErrorRecord = New-PreflightErrorRecord $null
                $parameters.ErrorResponse = $response
            }
            'ARM envelope' {
                $parameters.ErrorRecord = New-PreflightErrorRecord @{ status = 'Failed'; error = $response }
            }
        }
        Test-RegionalValidationError @parameters | Should -BeTrue
    }

    It 'Treats absent and null standard optional members equivalently without mutating the response' {
        $original = ConvertTo-Json -InputObject $response -Depth 10
        $record = New-PreflightErrorRecord $response
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation $location | Should -BeTrue
        [object]::ReferenceEquals($record.TargetObject, $response) | Should -BeTrue
        (ConvertTo-Json -InputObject $response -Depth 10) | Should -BeExactly $original
        $record.ErrorDetails.Message | Should -BeExactly 'Safe diagnostic text is not classification evidence.'

        foreach ($node in @($response) + @($response.Details)) {
            if ($null -eq $node) { continue }
            foreach ($name in @('Target', 'Details')) {
                if ($null -eq $node.$name) { $node.PSObject.Properties.Remove($name) }
            }
        }
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation $location | Should -BeTrue
    }

    It 'Does not classify without the selected region or for a fixed secondary region' {
        $record = New-PreflightErrorRecord $response
        foreach ($selected in @($null, '', ' ', 'westus2', "$location,centralus")) {
            Test-RegionalValidationError -ErrorRecord $record -ResourceLocation $selected | Should -BeFalse
        }
        Test-DeploymentRetryError -ErrorRecord $record -ResourceLocation $location -RetryKind Transient | Should -BeFalse
    }

    It 'Rejects meaningful or unrecognized <field> information: <label>' -ForEach @(
        @{ field = 'Target'; label = 'meaningful target'; value = 'another-resource' }
        @{ field = 'Target'; label = 'empty target'; value = '' }
        @{ field = 'Target'; label = 'non-string target'; value = $false }
        @{ field = 'Details'; label = 'empty details'; value = @() }
        @{ field = 'Details'; label = 'malformed details'; value = @{} }
        @{ field = 'InnerError'; label = 'null non-model member'; value = $null }
        @{ field = 'AdditionalInfo'; label = 'null non-model member'; value = $null }
        @{ field = 'AdditionalInfo'; label = 'empty information'; value = @() }
        @{ field = 'AdditionalInfo'; label = 'meaningful information'; value = @{ code = 'AuthorizationFailed' } }
        @{ field = 'UnknownError'; label = 'null unknown member'; value = $null }
        @{ field = 'UnknownError'; label = 'meaningful unknown member'; value = 'QuotaExceeded' }
        @{ field = 'Message'; label = 'null message'; value = $null }
        @{ field = 'Code'; label = 'unknown code'; value = 'Unknown' }
    ) {
        $response | Add-Member -NotePropertyName $field -NotePropertyValue $value -Force
        Test-RegionalValidationError -ErrorRecord (New-PreflightErrorRecord $response) -ResourceLocation $location | Should -BeFalse
    }

    It 'Rejects mixed or unclassified siblings in either order: <kindOfSibling>' -ForEach @(
        @{ kindOfSibling = 'authorization' }, @{ kindOfSibling = 'unknown' }, @{ kindOfSibling = 'unknown null field' }
    ) {
        $sibling = switch ($kindOfSibling) {
            'authorization' { @{ Code = 'AuthorizationFailed'; Message = 'Forbidden'; Target = $null; Details = $null } }
            'unknown' { @{ Code = 'Unknown'; Message = 'Regional failure'; Target = $null; Details = $null } }
            'unknown null field' { @{ Code = 'SkuNotAvailable'; Message = 'SKU not available in this location.'; UnknownError = $null } }
        }
        foreach ($errors in @(@($response, $sibling), @($sibling, $response))) {
            Test-RegionalValidationError -ErrorRecord (New-PreflightErrorRecord $errors) -ResourceLocation $location | Should -BeFalse
        }
    }

    It 'Rejects malformed or ambiguous JSON: <form>' -ForEach @(
        @{ form = 'duplicate code' }, @{ form = 'duplicate null target' }, @{ form = 'case-duplicate target' }
        @{ form = 'escaped duplicate target' }, @{ form = 'trailing data' }, @{ form = 'trailing comma' }, @{ form = 'comment' }
    ) {
        $json = ConvertTo-Json -InputObject $response -Depth 10 -Compress
        $json = switch ($form) {
            'duplicate code' { $json.Replace('"Code":', '"Code":"AuthorizationFailed","Code":') }
            'duplicate null target' { $json.Replace('"Target":null', '"Target":"another-resource","Target":null') }
            'case-duplicate target' { $json.Replace('"Target":null', '"target":"another-resource","Target":null') }
            'escaped duplicate target' { $json.Replace('"Target":null', '"\u0054arget":"another-resource","Target":null') }
            'trailing data' { $json + ' Forbidden' }
            'trailing comma' { $json.Insert($json.Length - 1, ',') }
            'comment' { '/* Forbidden */' + $json }
        }
        Test-RegionalValidationError -ErrorRecord (New-PreflightErrorRecord $json -JsonDetails) -ResourceLocation $location | Should -BeFalse
    }

    It 'Does not override HTTP <status> evidence' -ForEach @(
        @{ status = 401 }, @{ status = 403 }, @{ status = 404 }, @{ status = 429 }, @{ status = 500 }, @{ status = 504 }
    ) {
        $record = New-PreflightErrorRecord $response
        $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation $location | Should -BeFalse
    }

    It 'Does not override the <category> category' -ForEach @(
        @{ category = 'AuthenticationError' }, @{ category = 'PermissionDenied' }
        @{ category = 'SecurityError' }, @{ category = 'OperationStopped' }
    ) {
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Stop.'), 'TemplateValidationFailed',
            [System.Management.Automation.ErrorCategory] $category, $response
        )
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation $location | Should -BeFalse
    }

    It 'Does not override wrapped <exceptionType> evidence' -ForEach @(
        @{ exceptionType = 'System.OperationCanceledException' }
        @{ exceptionType = 'System.Management.Automation.PipelineStoppedException' }
        @{ exceptionType = 'System.UnauthorizedAccessException' }
    ) {
        $inner = New-Object -TypeName $exceptionType -ArgumentList 'Stop.'
        $record = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new('Validation failed.', $inner), 'TemplateValidationFailed',
            [System.Management.Automation.ErrorCategory]::InvalidResult, $response
        )
        Test-RegionalValidationError -ErrorRecord $record -ResourceLocation $location | Should -BeFalse
    }
}

Describe 'Selected-region provider availability evidence' {
    It 'Accepts canonical or display-name regions and nested provider types' -ForEach @(
        @{ reported = 'norwayeast'; selected = 'Norway East'; resourceType = 'Microsoft.DesktopVirtualization/hostpools' }
        @{ reported = 'Norway East'; selected = ' NORWAYEAST '; resourceType = 'Microsoft.Example/parents/children' }
    ) {
        $response = New-PreflightValidationResponse -Kind ProviderLocation -Location $reported
        $response.Message = $response.Message.Replace('Microsoft.DesktopVirtualization/hostpools', $resourceType)
        Test-RegionalValidationError -ErrorRecord (New-PreflightErrorRecord $response) -ResourceLocation $selected | Should -BeTrue
    }

    It 'Rejects incomplete or contradictory provider evidence: <kind>' -ForEach @(
        @{ kind = 'generic regional wording' }, @{ kind = 'missing provider' }, @{ kind = 'resource ID instead of type' }
        @{ kind = 'missing region' }, @{ kind = 'global location' }, @{ kind = 'empty available regions' }
        @{ kind = 'selected region is available' }, @{ kind = 'duplicate available regions' }
        @{ kind = 'malformed available regions' }, @{ kind = 'global availability' }
        @{ kind = 'trailing error' }, @{ kind = 'trailing newline' }, @{ kind = 'wrong code casing' }
    ) {
        $response = New-PreflightValidationResponse -Kind ProviderLocation -Location norwayeast -AvailableRegions 'eastus,westeurope'
        $selected = 'norwayeast'
        switch ($kind) {
            'generic regional wording' { $response.Message = 'The resource is not available in this region.' }
            'missing provider' { $response.Message = $response.Message.Replace('Microsoft.DesktopVirtualization/hostpools', 'hostpools') }
            'resource ID instead of type' { $response.Message = $response.Message.Replace('Microsoft.DesktopVirtualization/hostpools', '/subscriptions/example/providers/Microsoft.DesktopVirtualization/hostpools/test') }
            'missing region' { $response.Message = $response.Message.Replace("'norwayeast'", "''") }
            'global location' { $response.Message = $response.Message.Replace("'norwayeast'", "'global'"); $selected = 'global' }
            'empty available regions' { $response.Message = $response.Message.Replace('eastus,westeurope', '') }
            'selected region is available' { $response.Message = $response.Message.Replace('eastus,westeurope', 'eastus,norwayeast') }
            'duplicate available regions' { $response.Message = $response.Message.Replace('eastus,westeurope', 'eastus,eastus') }
            'malformed available regions' { $response.Message = $response.Message.Replace('eastus,westeurope', 'eastus,,westeurope') }
            'global availability' { $response.Message = $response.Message.Replace('eastus,westeurope', 'global') }
            'trailing error' { $response.Message += ' AuthorizationFailed.' }
            'trailing newline' { $response.Message += "`n" }
            'wrong code casing' { $response.Code = 'locationnotavailableforresourcetype' }
        }
        Test-RegionalValidationError -ErrorRecord (New-PreflightErrorRecord $response) -ResourceLocation $selected | Should -BeFalse
    }
}

Describe 'Pre-deployment <kind> relocation with actual validation and region selection' -ForEach @(
    @{ kind = 'ProviderLocation'; location = 'norwayeast' }
    @{ kind = 'AksZones'; location = 'eastus' }
) {
    BeforeAll {
        function Get-AzResourceProvider {
            [CmdletBinding()]
            param([string[]] $ProviderNamespace)
            throw 'Unexpected Azure provider query.'
        }
        function Get-AzLocation {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure location query.'
        }
        function Set-AzContext {
            [CmdletBinding()]
            param([string] $Subscription)
            throw 'Unexpected Azure context change.'
        }
        function Test-AzSubscriptionDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime)
            throw 'Unexpected Azure validation.'
        }
        function Test-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $ResourceGroupName, [string] $resourceLocation, [string] $baseTime)
            throw 'Unexpected Azure validation.'
        }
        function Get-AzResourceGroup {
            [CmdletBinding()]
            param([string] $Name)
            throw 'Unexpected Azure resource group lookup.'
        }
        function New-AzResourceGroup {
            [CmdletBinding()]
            param([string] $Name, [string] $Location)
            throw 'Unexpected Azure resource group creation.'
        }
    }

    BeforeEach {
        $savedTemp = $env:TEMP
        $savedTmp = $env:TMP
        $savedTmpDir = $env:TMPDIR
        $env:TEMP = $TestDrive
        $env:TMP = $TestDrive
        $env:TMPDIR = $TestDrive
        '{"Microsoft.RetryTest":{"widgets":{}}}' | Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
        $templatePath = Join-Path $TestDrive 'main.test.json'
        $template = @{
            '$schema'  = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = @{ resourceLocation = @{ type = 'string' }; baseTime = @{ type = 'string' } }
            variables  = @{ regionToken = '#_resourceLocation_#'; unchanged = 'fixed-value' }
        }
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $original = [System.IO.File]::ReadAllBytes($templatePath)
        $templateInput = @{
            TemplateFilePath           = $templatePath
            DeploymentMetadataLocation = 'westeurope'
            SubscriptionId             = '11111111-1111-1111-1111-111111111111'
            RepoRoot                   = $repoRootPath
            AdditionalParameters       = @{ resourceLocation = ''; baseTime = 'fixed-base-time' }
        }
        $retryInput = @{ TemplateInput = $templateInput; ModuleRoot = 'avm/res/retry-test/widget'; DoNotThrow = $true }
        $script:preflightKind = $kind
        $script:initialLocation = $location
        $script:regions = @($location, 'centralus', 'belgiumcentral', 'austriaeast')
        $script:requests = [System.Collections.Generic.List[object]]::new()
        $script:failureMode = 'first'
        $script:lastResponse = [System.Collections.Generic.List[object]] @(
            (New-PreflightValidationResponse -Kind $kind -Location $location -AvailableRegions westus3)
        )
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        Mock Get-Random { $Maximum - 1 }
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'widgets'; Locations = $script:regions }) }
        }
        Mock Get-AzLocation {
            foreach ($region in $script:regions) {
                @{ Location = $region; DisplayName = $region; RegionCategory = 'Recommended'; PairedRegion = 'eastus2' }
            }
        }
        Mock Set-AzContext {}
        Mock Get-AzResourceGroup { @{ Name = 'existing-group' } }
        Mock New-AzResourceGroup { throw 'Unexpected resource group creation.' }
        Mock Test-AzResourceGroupDeployment { , $script:lastResponse }
        Mock Test-AzSubscriptionDeployment {
            $script:requests.Add(@{
                    Region   = $resourceLocation
                    Metadata = $Location
                    BaseTime = $baseTime
                    Template = Get-Content -LiteralPath $TemplateFile -Raw | ConvertFrom-Json -AsHashtable
                })
            if ($script:failureMode -eq 'first' -and $script:requests.Count -gt 1) { return }
            $reported = $resourceLocation ? $resourceLocation : $script:initialLocation
            if ($script:failureMode -eq 'secondary region') { $reported = 'westus2' }
            $response = New-PreflightValidationResponse -Kind $script:preflightKind -Location $reported -AvailableRegions westus3
            $script:lastResponse = [System.Collections.Generic.List[object]] @($response)
            switch ($script:failureMode) {
                'mixed errors' { $script:lastResponse.Add(@{ Code = 'AuthorizationFailed'; Message = 'Forbidden' }) }
                'unknown information' { $response | Add-Member -NotePropertyName UnknownError -NotePropertyValue $null }
                'HTTP 403' {
                    $record = New-PreflightErrorRecord $script:lastResponse
                    $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 403 }
                    throw $record
                }
                'cancellation' { throw [System.OperationCanceledException]::new('Validation cancelled.') }
            }
            , $script:lastResponse
        }
        Mock New-TemplateDeployment {
            @{ DeploymentOutput = @{ ProvisioningState = 'Succeeded' }; DeploymentNames = @('preflight-fixture-t1') }
        }
        Mock Initialize-DeploymentRemoval { throw 'Unexpected cleanup before deployment.' }
        Mock Get-TemplateDeployment { throw 'Unexpected deployment history query.' }
        Mock Get-ErrorMessageForScope { throw 'Unexpected deployment operation query.' }
        Mock Start-Sleep { throw 'Unexpected retry delay.' }
    }

    AfterEach {
        $env:TEMP = $savedTemp
        $env:TMP = $savedTmp
        $env:TMPDIR = $savedTmpDir
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
        Should -Invoke Get-TemplateDeployment -Times 0 -Exactly
        Should -Invoke Get-ErrorMessageForScope -Times 0 -Exactly
        Should -Invoke New-AzResourceGroup -Times 0 -Exactly
    }

    It 'Validates another eligible region before submitting once, preserving other inputs' {
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeFalse
        $result.AttemptedLocations | Should -Be @($location, 'centralus')
        $result.DeploymentAttempts | Should -Be 1
        $result.DeploymentNames | Should -Be @('preflight-fixture-t1')
        @($script:requests.Region) | Should -Be @($location, 'centralus')
        @($script:requests.Template.variables.regionToken) | Should -Be @($location, 'centralus')
        @($script:requests.Template.variables.unchanged | Select-Object -Unique) | Should -Be @('fixed-value')
        @($script:requests.Metadata | Select-Object -Unique) | Should -Be @('westeurope')
        @($script:requests.BaseTime | Select-Object -Unique) | Should -Be @('fixed-base-time')
        $templateInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
        Should -Invoke New-TemplateDeployment -Times 1 -Exactly -ParameterFilter {
            $AdditionalParameters.resourceLocation -eq 'centralus' -and $RetryLimit -eq 1 -and $AttemptNumber -eq 1
        }
    }

    It 'Uses the same repair for validation-only callers without submitting anything' {
        Test-TemplateDeploymentWithRetry -ValidationInput $templateInput -ModuleRoot $retryInput.ModuleRoot | Should -Be 'centralus'
        @($script:requests.Region) | Should -Be @($location, 'centralus')
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly
    }

    It 'Exhausts exactly three candidates without deployment, preserves the original error and restores tokens' {
        $script:failureMode = 'all'
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.AttemptedLocations | Should -Be @($location, 'centralus', 'belgiumcentral')
        @($script:requests.Region) | Should -Be @($location, 'centralus', 'belgiumcentral')
        $result.DeploymentAttempts | Should -Be 0
        $result.DeploymentNames.Count | Should -Be 0
        $result.RemainingDeploymentNames.Count | Should -Be 0
        $result.ContainsKey('DeploymentOutput') | Should -BeFalse
        $result.Exception | Should -Match 'Template is not valid'
        $result.Exception | Should -Match '\[REDACTED\]'
        $result.Exception | Should -Not -Match 'belgiumcentral|fixed-base-time'
        [object]::ReferenceEquals($result.ErrorRecord.TargetObject, $script:lastResponse) | Should -BeTrue
        (ConvertTo-Json -InputObject $result.ErrorRecord.TargetObject -Depth 10) | Should -Match 'belgiumcentral'
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($original))
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly
    }

    It 'Does not relocate with <restriction>, even when the classifier recognizes the error' -ForEach @(
        @{ restriction = 'custom pin' }, @{ restriction = 'CI pin' }, @{ restriction = 'token pin' }
        @{ restriction = 'no movable input' }, @{ restriction = 'global resource' }, @{ restriction = 'resource-group scope' }
    ) {
        $script:failureMode = 'all'
        switch ($restriction) {
            'custom pin' { $retryInput.CustomLocation = $location }
            'CI pin' { $templateInput.AdditionalParameters.resourceLocation = $location }
            'token pin' { $retryInput.TokenResourceLocation = $location }
            'no movable input' {
                $templateInput.AdditionalParameters.Remove('resourceLocation')
                $template.variables.Remove('regionToken')
            }
            'global resource' { $script:regions = @('Global') }
            'resource-group scope' {
                $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                $templateInput.ResourceGroupName = 'existing-group'
            }
        }
        $template | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $templatePath
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeTrue
        $result.AttemptedLocations.Count | Should -Be 1
        $result.DeploymentAttempts | Should -Be 0
        Test-RegionalValidationError -ErrorRecord $result.ErrorRecord -ResourceLocation $result.ResourceLocation | Should -BeTrue
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly
    }

    It 'Refuses relocation for <failureMode> evidence' -ForEach @(
        @{ failureMode = 'secondary region' }, @{ failureMode = 'mixed errors' }
        @{ failureMode = 'unknown information' }, @{ failureMode = 'HTTP 403' }
    ) {
        $script:failureMode = $failureMode
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeTrue
        $result.AttemptedLocations | Should -Be @($location)
        $result.DeploymentAttempts | Should -Be 0
        Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly
    }

    It 'Propagates cancellation without relocation or submission' {
        $script:failureMode = 'cancellation'
        { Invoke-TemplateDeploymentWithRetry @retryInput } | Should -Throw '*Validation cancelled*'
        @($script:requests.Region) | Should -Be @($location)
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($original))
        Should -Invoke New-TemplateDeployment -Times 0 -Exactly
    }
}
