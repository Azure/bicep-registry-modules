param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

BeforeDiscovery {
    $serviceRegionalCases = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'service-regional-errors.json') -Raw |
        ConvertFrom-Json -AsHashtable
}

Describe 'Coordinated regional deployment retries with actual cleanup' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Invoke-TemplateDeploymentWithRetry.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Get-DeploymentTargetResourceList.ps1')
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Remove-Deployment.ps1')

        function Set-AzContext {
            [CmdletBinding()]
            param([string] $Subscription, [object] $Context)
            throw 'Unexpected Azure context change.'
        }
        function Get-AzContext {
            [CmdletBinding()]
            param()
            throw 'Unexpected Azure context lookup.'
        }
        function Test-AzSubscriptionDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure validation.'
        }
        function Test-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $ResourceGroupName, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure validation.'
        }
        function Test-AzManagementGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $ManagementGroupId, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure validation.'
        }
        function Test-AzTenantDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure validation.'
        }
        function New-AzSubscriptionDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function New-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $ResourceGroupName, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function New-AzManagementGroupDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $ManagementGroupId, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret, [object] $DefaultProfile)
            throw 'Unexpected Azure deployment.'
        }
        function New-AzTenantDeployment {
            [CmdletBinding()]
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
            throw 'Unexpected Azure deployment.'
        }
        function Get-AzDeployment {
            [CmdletBinding()]
            param([string] $Name, [object] $DefaultProfile)
            throw 'Unexpected Azure status lookup.'
        }
        function Get-AzResourceGroupDeployment {
            [CmdletBinding()]
            param([string] $Name, [string] $ResourceGroupName, [object] $DefaultProfile)
            throw 'Unexpected Azure status lookup.'
        }
        function Get-AzManagementGroupDeployment {
            [CmdletBinding()]
            param([string] $Name, [string] $ManagementGroupId, [object] $DefaultProfile)
            throw 'Unexpected Azure status lookup.'
        }
        function Get-AzTenantDeployment {
            [CmdletBinding()]
            param([string] $Name, [object] $DefaultProfile)
            throw 'Unexpected Azure status lookup.'
        }
        function Get-AzDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName)
            throw 'Unexpected Azure operation lookup.'
        }
        function Get-AzResourceGroupDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName, [string] $ResourceGroupName)
            throw 'Unexpected Azure operation lookup.'
        }
        function Get-AzManagementGroupDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName, [string] $ManagementGroupId)
            throw 'Unexpected Azure operation lookup.'
        }
        function Get-AzTenantDeploymentOperation {
            [CmdletBinding()]
            param([string] $DeploymentName)
            throw 'Unexpected Azure operation lookup.'
        }
        function Get-AzResourceGroup {
            [CmdletBinding()]
            param([string] $Name)
            throw 'Unexpected Azure group lookup.'
        }
        function Get-AzResource {
            [CmdletBinding()]
            param([string] $ResourceId)
            throw 'Unexpected Azure resource lookup.'
        }
        function Get-AzResourceLock {
            [CmdletBinding()]
            param([string] $Scope)
            throw 'Unexpected Azure lock lookup.'
        }
        function Remove-AzResource {
            [CmdletBinding()]
            param([string] $ResourceId, [switch] $Force)
            throw 'Unexpected Azure resource removal.'
        }
        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path)
            throw 'Unexpected Azure REST request.'
        }

        function New-FixtureResponse {
            param([int] $StatusCode = 200, [object] $Content = @{})
            @{ StatusCode = $StatusCode; Content = ConvertTo-Json -InputObject $Content -Depth 20 -Compress }
        }

        function New-FixtureOperation {
            param([string] $Id, [string] $State = 'Succeeded', [string] $Operation = 'Create', [object] $StatusMessage)
            @{ properties = @{
                    provisioningOperation = $Operation
                    provisioningState     = $State
                    targetResource        = @{ id = $Id }
                    statusMessage         = $StatusMessage
                }
            }
        }

        function New-FixturePreflightOperation {
            param(
                [string] $Id,
                [string] $ResourceTypeAndVersion = 'Microsoft.Compute/virtualMachineScaleSets (2024-11-01)',
                [string] $Sku = 'Standard_B12ms',
                [string] $Location = 'centralus'
            )
            $name = $Id.Split('/')[-1]
            $operation = New-FixtureOperation -Id $Id -State Failed -StatusMessage @{
                status = 'Failed'
                error  = @{
                    code    = 'InvalidTemplateDeployment'
                    message = "The template deployment '$name' is not valid according to the validation procedure. The following resource provider(s) - '$ResourceTypeAndVersion' reported preflight validation errors. Tracking id is 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'. See inner errors for details."
                    details = @(@{
                            code    = 'SkuNotAvailable'
                            message = "The requested VM size for resource 'Following SKUs have failed for Capacity Restrictions: $Sku' is currently not available in location '$Location'. Please try another size or deploy to a different location or different zone."
                        })
                }
            }
            $operation.properties.statusCode = 'BadRequest'
            $operation.properties.targetResource.resourceType = 'Microsoft.Resources/deployments'
            $operation.properties.targetResource.resourceName = $name
            return $operation
        }

        function New-FixtureGraphOperation {
            $operation = New-FixtureOperation
            $operation.properties.targetResource = @{
                resourceType = 'Microsoft.Graph/servicePrincipals@v1.0'
                symbolicName = 'backupManagementService'
                extension    = @{ name = 'MicrosoftGraph'; alias = 'microsoftGraphV1'; version = '1.0.0' }
            }
            return $operation
        }

        function Initialize-FixtureMachineLearningCosmosFailure {
            $script:cosmosResponseJson = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'fixtures' 'ml-cosmos-regional-error.json') -Raw
            $script:regionalError = $script:cosmosResponseJson | ConvertFrom-Json -AsHashtable
            $script:regions = @('norwayeast', 'swedencentral', 'eastus')
            $script:incidentMessage = "The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s). Status Message: " +
            'Machine Learning workspace database account creation failed. (Code: BadRequest)'
        }

        function Assert-FixtureParameters {
            param([string] $Path, [string] $Region, [string] $BaseTime, [securestring] $Secret)
            $BaseTime | Should -BeExactly 'fixed-base-time'
            ConvertFrom-SecureString -SecureString $Secret -AsPlainText | Should -BeExactly 'secret-not-for-logs'
            $content = Get-Content -LiteralPath $Path -Raw
            $content | Should -Not -Match '#_resourceLocation_#'
            if ($Path.EndsWith('.json')) {
                $template = $content | ConvertFrom-Json
                if ($template.variables.regionToken) { $template.variables.regionToken | Should -Be $Region }
                $template.variables.fixedToken | Should -Be 'fixed-nonregional-value'
            } else {
                $content | Should -Match ([regex]::Escape("location: '$Region'"))
                Get-Content -LiteralPath $script:childPath -Raw | Should -Match ([regex]::Escape("= '$Region'"))
            }
        }

        function New-FixtureResourceFailure {
            param([string] $ResourceId, [hashtable] $Leaf, [switch] $Nested)
            $failure = @{
                code = 'ResourceDeploymentFailure'; target = $ResourceId
                message = "The resource write operation failed to complete successfully, because it reached terminal provisioning state 'Failed'."
                details = @($Leaf)
            }
            if ($Nested) {
                $failure = @{
                    code = 'ResourceDeploymentFailure'; target = "${script:nestedId}-PrivateEndpoint-0"
                    details = @(@{
                            code = 'DeploymentFailed'; target = "${script:nestedId}-PrivateEndpoint-0"
                            details = @($failure)
                        })
                }
            }
            return @{
                status = 'Failed'
                error = @{
                    code = 'DeploymentFailed'; target = $script:nestedId
                    message = 'At least one resource deployment operation failed. Please list deployment operations for details.'
                    details = @($failure)
                }
            }
        }

        function Invoke-FixtureValidation {
            param([string] $Path, [string] $Region, [string] $BaseTime, [securestring] $Secret)
            Assert-FixtureParameters $Path $Region $BaseTime $Secret
            $script:trace.Add("validate:$Region")
            $script:validations.Add($Region)
            if ($Region -in $script:validationFailures) { $script:regionalError }
        }

        function Invoke-FixtureSubmission {
            param([string] $Name, [string] $Path, [string] $Region, [string] $BaseTime, [securestring] $Secret)
            Assert-FixtureParameters $Path $Region $BaseTime $Secret
            $script:trace.Add("submit:$Region")
            $script:names.Add($Name)
            $script:submissions.Add($Region)
            $outcome = $script:outcomes[$script:names.Count - 1]
            if (-not $outcome) { throw 'Unexpected extra deployment submission.' }
            if ($outcome -eq 'Preflight') {
                throw [System.Management.Automation.ErrorRecord]::new(
                    [System.InvalidOperationException]::new("08:51:48 - Error: Code=InvalidTemplateDeployment; Message=The template deployment '$Name' is not valid according to the validation procedure. The resource provider reported preflight validation errors."),
                    'DeploymentPreflightRejected', [System.Management.Automation.ErrorCategory]::InvalidOperation, $null
                )
            }
            if ($script:alive.Contains($script:groupId) -and $script:resourceRegion -ne $Region) {
                throw 'Dependencies still exist in a different region.'
            }
            $script:resourceRegion = $Region
            $null = $script:alive.Add($script:groupId)
            $null = $script:alive.Add($script:vnetId)
            $scope = Get-ScopeOfTemplateFile -TemplateFilePath $Path
            $rootId = Get-DeploymentResourceId -Scope $scope -Name $Name -SubscriptionId $script:subscriptionId `
                -ResourceGroupName 'retry-fixture' -ManagementGroupId 'test-management-group'
            $script:roots.Add($rootId)
            $script:records[$rootId] = @{
                State      = 'Failed'
                Operations = @(
                    (New-FixtureOperation -Id $script:groupId)
                    (New-FixtureOperation -Id $script:nestedId -State Failed -StatusMessage $script:regionalError)
                )
            }
            $script:records[$script:nestedId] = @{
                State      = 'Succeeded'
                Operations = @(
                    (New-FixtureOperation -Id $script:vnetId)
                    (New-FixtureOperation -Id '/subscriptions/other/resourceGroups/existing/providers/Microsoft.Storage/storageAccounts/not-owned' -Operation Read)
                )
            }
            $script:operationError = $script:regionalError
            switch ($outcome) {
                'Succeeded' {
                    $script:records[$rootId].State = 'Succeeded'
                    return @{ ProvisioningState = 'Succeeded'; Outputs = @{ region = @{ type = 'string'; value = $Region } } }
                }
                'Regional' { throw ($script:incidentMessage -f $Name) }
                'NestedReadNotFound' {
                    $message = "Deployment 'dependencies' could not be found."
                    $exception = [System.InvalidOperationException]::new($message)
                    $exception | Add-Member -NotePropertyName Body -NotePropertyValue @{ Code = 'DeploymentNotFound'; Message = $message }
                    $exception | Add-Member -NotePropertyName Request -NotePropertyValue @{
                        Method = [System.Net.Http.HttpMethod]::Get
                        RequestUri = [uri] "https://management.azure.com$script:nestedId/operations?api-version=2024-11-01"
                    }
                    $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{
                        StatusCode = [System.Net.HttpStatusCode]::NotFound
                        Content = ConvertTo-Json -InputObject @{ error = @{ code = 'DeploymentNotFound'; message = $message } } -Compress
                    }
                    throw [System.Management.Automation.ErrorRecord]::new(
                        $exception, 'ResourceManagerCloudException', [System.Management.Automation.ErrorCategory]::ObjectNotFound, $Name
                    )
                }
                'Legacy' {
                    $script:operationError = @{ error = @{ code = 'QuotaExceeded'; message = 'Nonregional quota failure.' } }
                    $script:records[$rootId].Operations[1].properties.statusMessage = $script:operationError
                    throw "The deployment '$Name' failed with error(s). (Code: DeploymentFailed) QuotaExceeded"
                }
                'FailedResult' { return @{ ProvisioningState = 'Failed' } }
                'Timeout' { throw [System.TimeoutException]::new('Original submission timed out.') }
                'Forbidden' {
                    $script:records[$rootId].State = $script:forbiddenState
                    $exception = [System.InvalidOperationException]::new('Original management-group submission returned HTTP 403.')
                    $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 403 }
                    $record = [System.Management.Automation.ErrorRecord]::new(
                        $exception, 'Forbidden', [System.Management.Automation.ErrorCategory]::OperationStopped, $rootId
                    )
                    $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Original authorization diagnostic; OperationID: fixture-operation.')
                    throw $record
                }
                'Transport' { throw [System.Net.Http.HttpRequestException]::new('Transport outcome unknown.') }
                'Cancel' { throw [System.OperationCanceledException]::new('Deployment cancelled.') }
                'NoResult' { return }
                'Running' { return @{ ProvisioningState = 'Running' } }
                default { throw "Unknown fixture outcome [$outcome]." }
            }
        }

        function Get-FixtureStatus {
            param([string] $Name, [string] $Scope, [string] $ResourceGroupName, [string] $ManagementGroupId, [object] $DefaultProfile)
            $id = Get-DeploymentResourceId -Scope $Scope -Name $Name -SubscriptionId $DefaultProfile.Subscription.Id `
                -ResourceGroupName $ResourceGroupName -ManagementGroupId $ManagementGroupId
            $script:trace.Add("state:$id")
            if (-not $script:records.ContainsKey($id)) {
                $exception = [System.InvalidOperationException]::new("Deployment '$Name' could not be found. StatusCode: 404")
                $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 404 }
                $exception | Add-Member -NotePropertyName Body -NotePropertyValue @{ Code = 'DeploymentNotFound' }
                throw [System.Management.Automation.ErrorRecord]::new(
                    $exception, 'DeploymentNotFound', [System.Management.Automation.ErrorCategory]::ObjectNotFound, $id
                )
            }
            @{
                DeploymentName    = $Name
                Id                = $id
                ProvisioningState = $script:records[$id].State
                Outputs           = @{ region = @{ type = 'string'; value = $script:resourceRegion } }
            }
        }

        function Invoke-FixtureRest {
            param([string] $Method, [string] $Path)
            $id = $Path.Split('?')[0]
            $script:trace.Add("${Method}:$id")
            if ($script:restOverrides.ContainsKey("$Method $Path")) {
                $override = $script:restOverrides["$Method $Path"]
                if ($override -is [System.Exception]) { throw $override }
                return $override
            }
            if ($Method -eq 'GET' -and $id.EndsWith('/operations')) {
                $recordId = $id.Substring(0, $id.Length - '/operations'.Length)
                if ($script:records.ContainsKey($recordId)) {
                    return New-FixtureResponse -Content @{ value = @($script:records[$recordId].Operations) }
                }
                return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
            }
            if ($Method -eq 'POST' -and $id.EndsWith('/exportTemplate')) {
                $recordId = $id.Substring(0, $id.Length - '/exportTemplate'.Length)
                if ($script:records[$recordId].Template) {
                    return New-FixtureResponse -Content @{ template = $script:records[$recordId].Template }
                }
                return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
            }
            if ($Method -eq 'GET' -and $id -eq $script:groupId) {
                if ($script:alive.Contains($id)) { return New-FixtureResponse -Content @{ id = $id } }
                return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'ResourceGroupNotFound' } }
            }
            if ($Method -eq 'DELETE' -and $id -in $script:roots) {
                $script:records.Remove($id)
                return New-FixtureResponse -StatusCode 204
            }
            if ($Method -eq 'GET' -and $id -in $script:roots) {
                if ($script:records.ContainsKey($id)) {
                    return New-FixtureResponse -Content @{ id = $id; properties = @{ provisioningState = $script:records[$id].State } }
                }
                return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
            }
            throw "Unexpected REST fixture request [$Method $Path]."
        }
    }

    BeforeEach {
        $script:subscriptionId = '11111111-1111-1111-1111-111111111111'
        $script:groupId = "/subscriptions/$script:subscriptionId/resourceGroups/retry-fixture"
        $script:vnetId = "$script:groupId/providers/Microsoft.Network/virtualNetworks/dependencies"
        $script:nestedId = "$script:groupId/providers/Microsoft.Resources/deployments/dependencies"
        $script:azContext = @{
            Subscription = @{ Id = $script:subscriptionId }
            Tenant       = @{ Id = '22222222-2222-2222-2222-222222222222' }
            Environment  = @{ ResourceManagerUrl = 'https://management.azure.com/' }
        }
        $script:clock = [datetime]::new(2026, 10, 3, 8, 51, 48, [DateTimeKind]::Utc)
        $script:regions = @('italynorth', 'swedencentral', 'eastus')
        $script:outcomes = @('Regional', 'Succeeded')
        $script:forbiddenState = 'Succeeded'
        $script:validationFailures = @()
        $script:records = @{}
        $script:restOverrides = @{}
        $script:requiredRemovalSubscription = $null
        $script:alive = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $script:names = [System.Collections.Generic.List[string]]::new()
        $script:roots = [System.Collections.Generic.List[string]]::new()
        $script:submissions = [System.Collections.Generic.List[string]]::new()
        $script:validations = [System.Collections.Generic.List[string]]::new()
        $script:removed = [System.Collections.Generic.List[string]]::new()
        $script:trace = [System.Collections.Generic.List[string]]::new()
        $script:regionalError = @{ error = @{
                code    = 'InvalidTemplateDeployment'
                message = 'A nested deployment failed preflight validation.'
                details = @(@{ code = 'SkuNotAvailable'; message = "The requested SKU 'ExampleSku' is not available in location 'ItalyNorth'." })
            }
        }
        $script:operationStatusMessage = "A nested deployment failed preflight validation. (Code: InvalidTemplateDeployment)`n" +
        " - The requested SKU 'ExampleSku' is not available in location 'ItalyNorth'. (Code: SkuNotAvailable)`n"
        $script:incidentMessage = "08:51:48 - The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s). Status Message: " +
        "A nested deployment failed preflight validation. (Code: InvalidTemplateDeployment) - " +
        "The requested SKU 'ExampleSku' is not available in location 'ItalyNorth'. " +
        'Please try another size or deploy to a different location or different zone. See https://aka.ms/azureskunotavailable for details. (Code:SkuNotAvailable)'

        $templatePath = Join-Path $TestDrive 'main.test.json'
        $template = @{
            '$schema'  = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
            parameters = @{ resourceLocation = @{ type = 'string' }; baseTime = @{ type = 'string' }; adminSecret = @{ type = 'secureString' } }
            variables  = @{ regionToken = '#_resourceLocation_#'; fixedToken = 'fixed-nonregional-value' }
        }
        $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
        $originalBytes = [System.IO.File]::ReadAllBytes($templatePath)
        $templateInput = @{
            TemplateFilePath           = $templatePath
            DeploymentMetadataLocation = 'WestEurope'
            SubscriptionId             = $script:subscriptionId
            ManagementGroupId          = 'test-management-group'
            ResourceGroupName          = 'retry-fixture'
            RepoRoot                   = $repoRootPath
            AdditionalParameters       = @{
                resourceLocation = ''
                baseTime         = 'fixed-base-time'
                adminSecret      = ConvertTo-SecureString -String 'secret-not-for-logs' -AsPlainText -Force
            }
        }
        $retryInput = @{ TemplateInput = $templateInput; ModuleRoot = 'avm/res/retry-test/widget'; DoNotThrow = $true }

        Mock Invoke-WebRequest { throw 'Unexpected network access.' }
        Mock Invoke-RestMethod { throw 'Unexpected network access.' }
        Mock Get-Date { if ($Format) { $script:clock.ToString($Format) } else { $script:clock } }
        Mock Start-Sleep { $script:clock = $script:clock.AddSeconds($Seconds) }
        Mock Get-AvailableResourceLocation {
            $remaining = @($script:regions | Where-Object { $_ -notin $UnavailableRegions })
            if (-not $remaining.Count) { throw 'No eligible regions remain.' }
            @{ Location = $remaining[0]; IsGlobal = $false }
        }
        Mock Set-AzContext {
            if ($Context) {
                $script:azContext = $Context
            } else {
                $script:azContext = @{ Subscription = @{ Id = $Subscription }; Tenant = $script:azContext.Tenant; Environment = $script:azContext.Environment }
            }
        }
        Mock Get-AzContext { $script:azContext }
        Mock Test-AzSubscriptionDeployment { Invoke-FixtureValidation $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock Test-AzResourceGroupDeployment { Invoke-FixtureValidation $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock Test-AzManagementGroupDeployment { Invoke-FixtureValidation $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock Test-AzTenantDeployment { Invoke-FixtureValidation $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock New-AzSubscriptionDeployment { Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock New-AzResourceGroupDeployment { Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock New-AzManagementGroupDeployment { Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock New-AzTenantDeployment { Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret }
        Mock Get-AzDeployment { Get-FixtureStatus $Name subscription '' '' $DefaultProfile }
        Mock Get-AzResourceGroupDeployment { Get-FixtureStatus $Name resourcegroup $ResourceGroupName '' $DefaultProfile }
        Mock Get-AzManagementGroupDeployment { Get-FixtureStatus $Name managementgroup '' $ManagementGroupId $DefaultProfile }
        Mock Get-AzTenantDeployment { Get-FixtureStatus $Name tenant '' '' $DefaultProfile }
        Mock Get-AzDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = $script:operationStatusMessage } }
        Mock Get-AzResourceGroupDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = $script:operationStatusMessage } }
        Mock Get-AzManagementGroupDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = $script:operationStatusMessage } }
        Mock Get-AzTenantDeploymentOperation { @{ ProvisioningState = 'Failed'; StatusMessage = $script:operationStatusMessage } }
        Mock Get-AzResourceGroup { @{ ResourceId = $script:groupId } }
        Mock Get-AzResource { throw 'Unexpected resource lookup outside a confirmed removed parent.' }
        Mock Get-AzResourceLock {}
        Mock Remove-AzResource {
            if ($script:requiredRemovalSubscription) {
                $script:azContext.Subscription.Id | Should -Be $script:requiredRemovalSubscription
            }
            $script:trace.Add("remove:$ResourceId")
            $script:removed.Add($ResourceId)
            foreach ($id in @($script:alive | Where-Object { $_ -eq $ResourceId -or $_.StartsWith("$ResourceId/") })) {
                $null = $script:alive.Remove($id)
            }
            foreach ($id in @($script:records.Keys | Where-Object { $_.StartsWith("$ResourceId/") })) {
                $script:records.Remove($id)
            }
        }
        Mock Invoke-AzRestMethod { Invoke-FixtureRest $Method $Path }
    }

    It 'Relocates using raw regional errors despite SDK-formatted operation messages only after confirmed cleanup' {
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeFalse
        @($script:submissions) | Should -Be @('italynorth', 'swedencentral')
        @($script:validations) | Should -Be @('italynorth', 'swedencentral')
        $result.DeploymentOutput.region.value | Should -Be 'swedencentral'
        $result.DeploymentNames | Should -Be @($script:names)
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        @($script:names | Select-Object -Unique).Count | Should -Be 2
        $script:removed | Should -Contain $script:groupId
        @($script:removed | Where-Object { $_ -eq $script:vnetId -or $script:vnetId.StartsWith("$_/") }).Count | Should -BeGreaterThan 0
        $script:trace | Should -Contain "GET:$script:nestedId/operations"
        @($script:removed | Where-Object { $_ -notlike "$script:groupId*" }).Count | Should -Be 0
        $root = $script:roots[0]
        $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$root")
        $script:trace.IndexOf("DELETE:$root") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
        $script:trace.IndexOf('validate:swedencentral') | Should -BeLessThan $script:trace.IndexOf('submit:swedencentral')
        $templateInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
        (Get-Content -LiteralPath $templatePath -Raw | ConvertFrom-Json).variables.regionToken | Should -Be 'swedencentral'
        Should -Invoke New-AzSubscriptionDeployment -Times 2 -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
    }

    Context 'Regional service failure: <name>' -Tag 'ServiceRegional' -ForEach $serviceRegionalCases {
        BeforeEach {
            $script:regionalError = $response | ConvertTo-Json -Depth 20 | ConvertFrom-Json -AsHashtable
            $script:serviceErrorTemplate = $response | ConvertTo-Json -Depth 20
            $script:serviceErrorRegion = $region
            $script:serviceErrorFollowsRegion = $false
            $script:regions = @($region, 'westeurope', 'northeurope')
            $script:incidentMessage = "The deployment '{0}' failed with error(s). Selected resource location '$region'."
            $script:serviceId = "$script:groupId/providers/$provider/environment"
            Mock New-AzSubscriptionDeployment {
                if ($script:serviceErrorFollowsRegion) {
                    $script:regionalError = $script:serviceErrorTemplate.Replace($script:serviceErrorRegion, $resourceLocation) |
                        ConvertFrom-Json -AsHashtable
                }
                try {
                    Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
                } finally {
                    if ($script:records.ContainsKey($script:nestedId) -and $script:records[$script:roots[-1]].State -eq 'Failed') {
                        $script:records[$script:nestedId].Operations +=
                        New-FixtureOperation -Id $script:serviceId -State Failed -StatusMessage $script:regionalError
                        $null = $script:alive.Add($script:serviceId)
                    }
                }
            }
        }

        It 'Revalidates and resubmits only after exact resource and history cleanup' {
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:submissions) | Should -Be @($region, 'westeurope')
            @($script:validations) | Should -Be @($region, 'westeurope')
            $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            $script:trace | Should -Contain "GET:$script:nestedId/operations"
            $script:trace | Should -Contain "GET:$script:groupId"
            $script:trace.IndexOf("remove:$script:groupId") |
                Should -BeLessThan $script:trace.IndexOf("DELETE:$($script:roots[0])")
            $script:trace.IndexOf("DELETE:$($script:roots[0])") |
                Should -BeLessThan $script:trace.IndexOf('validate:westeurope')
            $script:trace.IndexOf('validate:westeurope') | Should -BeLessThan $script:trace.IndexOf('submit:westeurope')
            $templateInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
            Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
        }

        It 'Classifies original validation responses with the selected subscription before any submission' {
            $script:validationFailures = @($region)
            $script:outcomes = @('Succeeded')

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:validations) | Should -Be @($region, 'westeurope')
            @($script:submissions) | Should -Be @('westeurope')
            $result.DeploymentAttempts | Should -Be 1
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Preserves the shared three-region and three-submission budgets' {
            $script:outcomes = @('Regional', 'Regional', 'Regional')
            $script:serviceErrorFollowsRegion = $true

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeTrue
            $result.AttemptedLocations | Should -Be @($region, 'westeurope', 'northeurope')
            $result.DeploymentAttempts | Should -Be 3
            @($script:submissions).Count | Should -Be 3
            $result.RemainingDeploymentNames | Should -Be @($script:names[2])
            Should -Invoke Remove-AzResource -Times 2 -Exactly -ParameterFilter { $ResourceId -eq $script:groupId }
        }

        It 'Retains safe failure for <constraint>' -ForEach @(
            @{ constraint = 'a custom pin' }, @{ constraint = 'a token pin' }
            @{ constraint = 'global selection' }, @{ constraint = 'retained resources' }
        ) {
            switch ($constraint) {
                'a custom pin' { $retryInput.CustomLocation = $region }
                'a token pin' { $retryInput.TokenResourceLocation = $region }
                'global selection' {
                    Mock Get-AvailableResourceLocation { @{ Location = $script:regions[0]; IsGlobal = $true } }
                }
                'retained resources' { $retryInput.RemoveDeployment = $false }
            }

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeTrue
            @($script:submissions).Count | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Does not move the selected resource region to address a fixed secondary region' {
            $script:regionalError = ($script:regionalError | ConvertTo-Json -Depth 20).Replace($region, 'westus2') |
                ConvertFrom-Json -AsHashtable

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeTrue
            @($script:submissions).Count | Should -Be 1
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Cannot relocate after incomplete cleanup confirmation' {
            Mock Initialize-DeploymentRemoval { @{ RemovedDeploymentNames = @() } }

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeTrue
            $result.Exception | Should -Match 'Cleanup did not confirm removal'
            @($script:submissions).Count | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter { $RequireCompleteRemoval }
        }

        It 'Reads all operation pages before rejecting an unrelated permission error' {
            Mock Invoke-AzRestMethod {
                $result = Invoke-FixtureRest $Method $Path
                if ($Method -eq 'GET' -and $Path -like "$($script:roots[0])/operations?*") {
                    $body = $result.Content | ConvertFrom-Json -AsHashtable
                    if ($Path -like '*skiptoken*') {
                        $body = @{ value = @(
                                (New-FixtureOperation -Id $script:serviceId -State Failed -StatusMessage @{
                                    error = @{ code = 'AuthorizationFailed'; message = 'Forbidden.' }
                                })
                            )
                        }
                    } else {
                        $body.nextLink = "https://management.azure.com$Path&`$skiptoken=next"
                    }
                    $result.Content = $body | ConvertTo-Json -Depth 20 -Compress
                }
                return $result
            }

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeTrue
            @($script:submissions).Count | Should -Be 1
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path -like '*skiptoken*' }
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }
    }

    It 'Rejects <form> in raw operation pages before JSON conversion can discard evidence' -Tag 'ServiceRegional' -ForEach @(
        @{ form = 'duplicate code' }, @{ form = 'escaped duplicate code' }, @{ form = 'comment' }, @{ form = 'trailing comma' }
    ) {
        $script:jsonForm = $form
        Mock Invoke-AzRestMethod {
            $result = Invoke-FixtureRest $Method $Path
            if ($Method -eq 'GET' -and $Path -like "$($script:roots[0])/operations?*") {
                $result.Content = switch ($script:jsonForm) {
                    'duplicate code' { $result.Content.Replace('"code":"SkuNotAvailable"', '"code":"AuthorizationFailed","code":"SkuNotAvailable"') }
                    'escaped duplicate code' { $result.Content.Replace('"code":"SkuNotAvailable"', '"\u0063ode":"AuthorizationFailed","code":"SkuNotAvailable"') }
                    'comment' { '/* unclassified */' + $result.Content }
                    'trailing comma' { $result.Content.Insert($result.Content.Length - 1, ',') }
                }
            }
            return $result
        }

        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeTrue
        @($script:submissions).Count | Should -Be 1
        Should -Invoke Remove-AzResource -Times 0 -Exactly
    }

    It 'Does not infer a MySQL error region from the selected validation candidate' -Tag 'ServiceRegional' {
        $script:regions = @('koreacentral', 'westeurope', 'eastus')
        $script:regionalError = @{ error = @{
                code = 'ZoneNotAvailableForRegion'
                message = 'The requested size for resource is currently not available in this zone. Please try another zone or deploy to a different location'
            }
        }

        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeTrue
        $result.AttemptedLocations | Should -Be @('koreacentral')
        @($script:submissions) | Should -Be @('koreacentral')
        Should -Invoke Remove-AzResource -Times 0 -Exactly
    }

    Context 'Preflight-rejected nested deployment discovery' -Tag 'NestedPreflight' {
        BeforeEach {
            $script:preflightId = "$script:groupId/providers/Microsoft.Resources/deployments/xw3pmls5ubqw4-test-cvmsswinuni-init"
            $script:preflightOperation = New-FixturePreflightOperation -Id $script:preflightId
            $script:parentId = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/failed-parent"
            $script:roots.Add($script:parentId)
            $script:records[$script:parentId] = @{
                State      = 'Failed'
                Operations = @(
                    $script:preflightOperation
                    (New-FixtureOperation -Id $script:nestedId -Operation Read)
                    (New-FixtureOperation -Id $script:nestedId)
                    (New-FixtureOperation -Id $script:groupId)
                )
            }
            $script:records[$script:nestedId] = @{
                State      = 'Succeeded'
                Operations = @((New-FixtureOperation -Id $script:vnetId))
            }
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] =
            New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
            $null = $script:alive.Add($script:groupId)
            $null = $script:alive.Add($script:vnetId)
            $discoveryInput = @{ DeploymentNames = 'failed-parent'; Scope = 'subscription'; RequireCompleteRemoval = $true }
        }

        It 'Omits only the absent rejected child while retaining siblings and resources across <pages> operation pages' -ForEach @(
            @{ pages = 1 }, @{ pages = 2 }
        ) {
            if ($pages -eq 2) {
                $page = "${script:parentId}/operations?api-version=2025-04-01"
                $nextPage = "$page&`$skiptoken=next"
                $script:restOverrides["GET $page"] = New-FixtureResponse -Content @{
                    value = @($script:records[$script:parentId].Operations[1..3]); nextLink = "https://management.azure.com$nextPage"
                }
                $script:restOverrides["GET $nextPage"] = New-FixtureResponse -Content @{ value = @($script:preflightOperation) }
            }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -BeNullOrEmpty
            $result.resourcesToRemove | Should -Contain $script:groupId
            $result.resourcesToRemove | Should -Contain $script:vnetId
            $result.deploymentIds | Should -Be @($script:nestedId, $script:parentId)
            $script:trace | Should -Contain "GET:$script:preflightId"
            $script:trace | Should -Contain "GET:$script:nestedId/operations"
            $script:trace | Should -Not -Contain "GET:$script:preflightId/operations"
            Should -Invoke Get-AzResourceGroupDeployment -Times 0 -Exactly -ParameterFilter {
                $Name -eq 'xw3pmls5ubqw4-test-cvmsswinuni-init'
            }
        }

        It 'Accepts explicit matching error targets and a numeric HTTP status string' {
            $script:preflightOperation.properties.statusCode = '400'
            $script:preflightOperation.properties.statusMessage.error.target = $script:preflightId
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] = New-FixtureResponse -StatusCode 404 -Content @{
                error = @{ code = 'DeploymentNotFound'; target = $script:preflightId }
            }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -BeNullOrEmpty
            $result.deploymentIds | Should -Be @($script:nestedId, $script:parentId)
        }

        It 'Cleans the captured <scenario> preflight shape without deleting the missing child history' -ForEach @(
            @{ scenario = 'Windows disks'; name = 'test-vmwindisk-init' }
            @{ scenario = 'Windows ZRS'; name = 'test-vmwinzrs-init' }
        ) {
            $script:preflightId = "$script:groupId/providers/Microsoft.Resources/deployments/$name"
            $script:preflightOperation = New-FixturePreflightOperation -Id $script:preflightId `
                -ResourceTypeAndVersion 'Microsoft.Compute/virtualMachines (2025-11-01)' -Sku 'Standard_D4ads_v5' -Location 'eastus'
            $siblingRead = New-FixtureOperation -Id $script:nestedId -Operation Read
            $siblingRead.properties.targetResource.apiVersion = '2025-04-01'
            $script:records[$script:parentId].Operations = @(
                $script:preflightOperation
                $siblingRead
                (New-FixtureOperation -Id $script:nestedId)
                (New-FixtureOperation -Id $script:groupId)
            )
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] =
            New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }

            $result = Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                -DeploymentNames 'failed-parent' -RequireCompleteRemoval

            $result.RemovedDeploymentNames | Should -Be @('failed-parent')
            $script:alive.Count | Should -Be 0
            $script:trace | Should -Contain "GET:$script:nestedId/operations"
            $script:trace | Should -Contain "DELETE:$script:parentId"
            $script:trace | Should -Not -Contain "DELETE:$script:preflightId"
            $script:trace | Should -Not -Contain "GET:$script:preflightId/operations"
        }

        It 'Fails closed for the captured ID-less Graph Create in <scenario>, even with terminal operations' -ForEach @(
            @{ scenario = 'Linux VM max'; action = $false; count = 5 }
            @{ scenario = 'VM WAF'; action = $false; count = 5 }
            @{ scenario = 'Windows VM max'; action = $true; count = 6 }
        ) {
            $diagnosticId = "$script:groupId/providers/Microsoft.Resources/deployments/diagnosticDependencies"
            $graphOperation = New-FixtureGraphOperation
            $script:records[$script:parentId].Operations = @(
                $script:preflightOperation
                (New-FixtureOperation -Id $script:nestedId)
                (New-FixtureOperation -Id $diagnosticId)
                (New-FixtureOperation -Id $script:groupId)
                $graphOperation
            )
            if ($action) {
                $siblingAction = New-FixtureOperation -Id $script:nestedId -Operation Action
                $siblingAction.properties.targetResource.actionName = 'listOutputsWithSecureValues'
                $siblingAction.properties.targetResource.apiVersion = '2025-04-01'
                $script:records[$script:parentId].Operations += $siblingAction
            }

            $script:records[$script:parentId].Operations.Count | Should -Be $count
            $result = Get-DeploymentTargetResourceList @discoveryInput

            $result.resolveError | Should -Match 'incomplete operation|export'
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
            $script:trace | Should -Not -Contain "GET:$script:preflightId"
        }

        Context 'Existing Graph lookups matched to the exact deployed template' -Tag 'ExistingGraph' {
            BeforeEach {
                $template.languageVersion = '2.0'
                $template.imports = @{ microsoftGraphV1 = @{ provider = 'MicrosoftGraph'; version = '1.0.0' } }
                $template.resources = @{
                    backupManagementService = @{
                        condition = "[equals(parameters('builtInServicePrincipalObjectId'), null())]"
                        existing = $true
                        import = 'microsoftGraphV1'
                        type = 'Microsoft.Graph/servicePrincipals@v1.0'
                        properties = @{ appId = '262044b1-e2ce-469f-a196-69ab7ada62d3' }
                    }
                }
                $script:graphOperation = New-FixtureGraphOperation
                $script:records[$script:parentId].Operations += $script:graphOperation
                $script:records[$script:parentId].Template = $template
            }

            It 'Cleans the captured <scenario> graph with authoritative existing-only proof across <pages> pages' -ForEach @(
                @{ scenario = 'Linux VM max'; pages = 1; action = $false }
                @{ scenario = 'VM WAF'; pages = 1; action = $false }
                @{ scenario = 'Windows VM max'; pages = 1; action = $true }
                @{ scenario = 'Linux VM max'; pages = 2; action = $false }
                @{ scenario = 'VM WAF'; pages = 2; action = $false }
                @{ scenario = 'Windows VM max'; pages = 2; action = $true }
            ) {
                $diagnosticId = "$script:groupId/providers/Microsoft.Resources/deployments/diagnosticDependencies"
                $script:records[$diagnosticId] = @{ State = 'Succeeded'; Operations = @() }
                $script:preflightOperation = New-FixturePreflightOperation -Id $script:preflightId `
                    -ResourceTypeAndVersion 'Microsoft.Compute/virtualMachines (2025-11-01)' -Sku 'Standard_D4ads_v5' -Location 'eastus'
                $script:records[$script:parentId].Operations = @(
                    $script:preflightOperation
                    (New-FixtureOperation -Id $script:nestedId)
                    (New-FixtureOperation -Id $diagnosticId)
                    (New-FixtureOperation -Id $script:groupId)
                    $script:graphOperation
                )
                if ($action) {
                    $siblingAction = New-FixtureOperation -Id $script:nestedId -Operation Action
                    $siblingAction.properties.targetResource.actionName = 'listOutputsWithSecureValues'
                    $script:records[$script:parentId].Operations += $siblingAction
                }
                if ($pages -eq 2) {
                    $page = "${script:parentId}/operations?api-version=2025-04-01"
                    $nextPage = "$page&`$skiptoken=next"
                    $script:restOverrides["GET $page"] = New-FixtureResponse -Content @{
                        value = @($script:records[$script:parentId].Operations[0..3]); nextLink = "https://management.azure.com$nextPage"
                    }
                    $script:restOverrides["GET $nextPage"] = New-FixtureResponse -Content @{
                        value = @($script:records[$script:parentId].Operations | Select-Object -Skip 4)
                    }
                }

                $result = Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                    -DeploymentNames 'failed-parent' -RequireCompleteRemoval

                $result.RemovedDeploymentNames | Should -Be @('failed-parent')
                $script:alive.Count | Should -Be 0
                $script:trace | Should -Contain "GET:$script:nestedId/operations"
                $script:trace | Should -Contain "GET:$diagnosticId/operations"
                $script:trace | Should -Contain "DELETE:$script:parentId"
                $script:trace | Should -Not -Contain "DELETE:$script:preflightId"
                $script:trace | Should -Not -Contain "GET:$script:preflightId/operations"
                @($script:trace | Where-Object { $_ -like 'remove:*' }) | Should -Be @("remove:$script:groupId")
                Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
                    $Method -eq 'POST' -and $Path -eq "${script:parentId}/exportTemplate?api-version=2025-04-01"
                }
                Should -Invoke Start-Sleep -Times 0 -Exactly
            }

            It 'Refuses to omit an ID-less Graph operation with <kind>' -ForEach @(
                @{ kind = 'a writable declaration' }, @{ kind = 'a missing existing flag' }, @{ kind = 'a string existing flag' }
                @{ kind = 'a missing symbol' }, @{ kind = 'an array symbol' }, @{ kind = 'a different symbol' }
                @{ kind = 'a different resource type' }, @{ kind = 'an array resource type' }
                @{ kind = 'a missing extension' }, @{ kind = 'an array extension' }, @{ kind = 'a different extension provider' }
                @{ kind = 'a different extension alias' }, @{ kind = 'a different extension version' }
                @{ kind = 'a missing import' }, @{ kind = 'an array import' }, @{ kind = 'a different declaration type' }
                @{ kind = 'a missing provider import' }, @{ kind = 'a different imported provider' }, @{ kind = 'a different imported version' }
                @{ kind = 'duplicate declaration symbols' }, @{ kind = 'duplicate import aliases' }, @{ kind = 'an unsupported template scope' }
                @{ kind = 'an unsupported template language' }, @{ kind = 'a failed operation' }, @{ kind = 'a running operation' }
                @{ kind = 'an empty target ID' }, @{ kind = 'an explicit null target ID' }, @{ kind = 'an array target ID' }
                @{ kind = 'a contradictory error message' }, @{ kind = 'a contradictory HTTP status' }
                @{ kind = 'an array template' }, @{ kind = 'an array resource declaration' }, @{ kind = 'an array import declaration' }
                @{ kind = 'an unproven provider version' }
            ) {
                $operation = $script:graphOperation.properties
                $declaration = $template.resources.backupManagementService
                switch ($kind) {
                    'a writable declaration' { $declaration.existing = $false }
                    'a missing existing flag' { $declaration.Remove('existing') }
                    'a string existing flag' { $declaration.existing = 'true' }
                    'a missing symbol' { $operation.targetResource.Remove('symbolicName') }
                    'an array symbol' { $operation.targetResource.symbolicName = @('backupManagementService') }
                    'a different symbol' { $operation.targetResource.symbolicName = 'newServicePrincipal' }
                    'a different resource type' { $operation.targetResource.resourceType = 'Microsoft.Graph/applications@v1.0' }
                    'an array resource type' { $operation.targetResource.resourceType = @('Microsoft.Graph/servicePrincipals@v1.0') }
                    'a missing extension' { $operation.targetResource.Remove('extension') }
                    'an array extension' { $operation.targetResource.extension = @($operation.targetResource.extension) }
                    'a different extension provider' { $operation.targetResource.extension.name = 'UnknownProvider' }
                    'a different extension alias' { $operation.targetResource.extension.alias = 'anotherImport' }
                    'a different extension version' { $operation.targetResource.extension.version = '2.0.0' }
                    'a missing import' { $declaration.Remove('import') }
                    'an array import' { $declaration.import = @('microsoftGraphV1') }
                    'a different declaration type' { $declaration.type = 'Microsoft.Graph/applications@v1.0' }
                    'a missing provider import' { $template.Remove('imports') }
                    'a different imported provider' { $template.imports.microsoftGraphV1.provider = 'UnknownProvider' }
                    'a different imported version' { $template.imports.microsoftGraphV1.version = '2.0.0' }
                    'duplicate declaration symbols' {
                        $template.resources = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::Ordinal)
                        $template.resources.Add('backupManagementService', $declaration)
                        $template.resources.Add('BACKUPMANAGEMENTSERVICE', @{ existing = $false })
                    }
                    'duplicate import aliases' {
                        $template.imports = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::Ordinal)
                        $template.imports.Add('microsoftGraphV1', @{ provider = 'MicrosoftGraph'; version = '1.0.0' })
                        $template.imports.Add('MICROSOFTGRAPHV1', @{ provider = 'UnknownProvider'; version = '1.0.0' })
                    }
                    'an unsupported template scope' { $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#' }
                    'an unsupported template language' { $template.languageVersion = '1.0' }
                    'a failed operation' { $operation.provisioningState = 'Failed' }
                    'a running operation' { $operation.provisioningState = 'Running' }
                    'an empty target ID' { $operation.targetResource.id = '' }
                    'an explicit null target ID' { $operation.targetResource.id = $null }
                    'an array target ID' { $operation.targetResource.id = @($null) }
                    'a contradictory error message' { $operation.statusMessage = @{ error = @{ code = 'AuthorizationFailed' } } }
                    'a contradictory HTTP status' { $operation.statusCode = 'Forbidden' }
                    'an array template' { $script:records[$script:parentId].Template = @($template) }
                    'an array resource declaration' { $template.resources.backupManagementService = @($declaration) }
                    'an array import declaration' { $template.imports.microsoftGraphV1 = @($template.imports.microsoftGraphV1) }
                    'an unproven provider version' {
                        $operation.targetResource.extension.version = '2.0.0'
                        $template.imports.microsoftGraphV1.version = '2.0.0'
                    }
                }

                $result = Get-DeploymentTargetResourceList @discoveryInput

                $result.resolveError | Should -Not -BeNullOrEmpty
                Should -Invoke Remove-AzResource -Times 0 -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
            }

            It 'Does not use root existing declarations to skip an unknown nested Graph operation' {
                $script:records[$script:nestedId].Operations += New-FixtureGraphOperation
                $result = Get-DeploymentTargetResourceList @discoveryInput
                $result.resolveError | Should -Not -BeNullOrEmpty
                $script:trace | Should -Contain "POST:$script:nestedId/exportTemplate"
                $script:trace | Should -Not -Contain "DELETE:$script:parentId"
            }

            It 'Preserves the returned Graph operation while fetching its exact template only once' {
                $script:records[$script:parentId].Operations += New-FixtureGraphOperation
                $operations = Get-DeploymentOperationAtScope -Name 'failed-parent' -Scope subscription `
                    -SubscriptionId $script:subscriptionId -IncludeAllOperations -RequireCompleteRemoval
                @($operations | Where-Object { $_.targetResource.symbolicName -eq 'backupManagementService' }).Count | Should -Be 2
                @($operations | Where-Object { $_.targetResource.symbolicName -eq 'backupManagementService' }).provisioningOperation | Should -Be @('Create', 'Create')
                Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
            }

            It 'Does not use Graph proof to authorize a malformed root state' {
                $script:records[$script:parentId].State = @('Failed')
                $result = Get-DeploymentTargetResourceList @discoveryInput
                $result.resolveError | Should -Not -BeNullOrEmpty
                Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            }

            It 'Restores the original context when a nested cross-subscription export is refused' {
                $otherSubscription = '22222222-2222-2222-2222-222222222222'
                $otherNestedId = $script:nestedId.Replace($script:subscriptionId, $otherSubscription)
                $script:records[$otherNestedId] = $script:records[$script:nestedId]
                $script:records[$otherNestedId].Operations += New-FixtureGraphOperation
                foreach ($operation in $script:records[$script:parentId].Operations) {
                    if ($operation.properties.targetResource.id -eq $script:nestedId) {
                        $operation.properties.targetResource.id = $otherNestedId
                    }
                }
                $result = Get-DeploymentTargetResourceList @discoveryInput
                $result.resolveError | Should -Not -BeNullOrEmpty
                $script:trace | Should -Contain "POST:$otherNestedId/exportTemplate"
                $script:azContext.Subscription.Id | Should -Be $script:subscriptionId
                Should -Invoke Remove-AzResource -Times 0 -Exactly
            }

            It 'Relocates only after cleaning an attempt with a server-proven existing Graph lookup' {
                $script:records = @{}
                $script:roots.Clear()
                $script:alive.Clear()
                $script:graphTemplate = $template
                Mock New-AzSubscriptionDeployment {
                    try {
                        Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
                    } finally {
                        $rootId = $script:roots[-1]
                        $script:records[$rootId].Operations += New-FixtureGraphOperation
                        $script:records[$rootId].Template = $script:graphTemplate
                    }
                }
                $result = Invoke-TemplateDeploymentWithRetry @retryInput
                $result.ContainsKey('Exception') | Should -BeFalse
                @($script:submissions) | Should -Be @('italynorth', 'swedencentral')
                $result.DeploymentAttempts | Should -Be 2
                $result.RemainingDeploymentNames | Should -Be @($script:names[1])
                $script:trace.IndexOf("POST:$($script:roots[0])/exportTemplate") | Should -BeLessThan $script:trace.IndexOf("remove:$script:groupId")
                $script:trace.IndexOf("DELETE:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
            }

            It 'Fails closed when exact-record export returns <failure>' -ForEach @(
                @{ failure = '403' }, @{ failure = '404' }, @{ failure = '500' }
                @{ failure = 'invalid JSON' }, @{ failure = 'no template' }, @{ failure = 'an array response' }
                @{ failure = 'duplicate template properties' }, @{ failure = 'duplicate existing properties' }
                @{ failure = 'duplicate provider properties' }, @{ failure = 'an error with a template' }
            ) {
                $response = New-FixtureResponse -Content @{ template = $template }
                switch ($failure) {
                    { $_ -in @('403', '404', '500') } {
                        $response = New-FixtureResponse -StatusCode ([int] $failure) -Content @{ error = @{ code = 'ExportFailed' } }
                    }
                    'invalid JSON' { $response.Content = 'invalid' }
                    'no template' { $response.Content = '{}' }
                    'an array response' { $response.Content = "[$($response.Content)]" }
                    'duplicate template properties' {
                        $json = ConvertTo-Json -InputObject $template -Depth 20 -Compress
                        $response.Content = "{`"template`":$json,`"template`":$json}"
                    }
                    'duplicate existing properties' { $response.Content = $response.Content.Replace('"existing":true', '"existing":false,"existing":true') }
                    'duplicate provider properties' { $response.Content = $response.Content.Replace('"provider":"MicrosoftGraph"', '"provider":"Other","provider":"MicrosoftGraph"') }
                    'an error with a template' { $response = New-FixtureResponse -Content @{ template = $template; error = @{ code = 'AuthorizationFailed' } } }
                }
                $script:restOverrides["POST ${script:parentId}/exportTemplate?api-version=2025-04-01"] = $response
                $result = Get-DeploymentTargetResourceList @discoveryInput
                $result.resolveError | Should -Not -BeNullOrEmpty
                Should -Invoke Remove-AzResource -Times 0 -Exactly
                Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
                    $Method -eq 'POST' -and $Path -eq "${script:parentId}/exportTemplate?api-version=2025-04-01"
                }
            }
        }

        It 'Requires a unique failed Create with direct child preflight evidence: <kind>' -ForEach @(
            @{ kind = 'missing operation type' }, @{ kind = 'array operation type' }
            @{ kind = 'successful Create' }, @{ kind = 'running Create' }, @{ kind = 'missing operation state' }
            @{ kind = 'array operation state' }, @{ kind = 'missing HTTP status' }, @{ kind = 'HTTP authorization failure' }
            @{ kind = 'array HTTP status' }, @{ kind = 'missing resource type' }, @{ kind = 'wrong resource type' }
            @{ kind = 'missing resource name' }, @{ kind = 'wrong resource name' }, @{ kind = 'array resource name' }
            @{ kind = 'missing status message' }, @{ kind = 'text status message' }, @{ kind = 'JSON-string status message' }
            @{ kind = 'array status message' }, @{ kind = 'successful status message' }, @{ kind = 'array status' }
            @{ kind = 'missing error' }, @{ kind = 'array error' }, @{ kind = 'array error code' }
            @{ kind = 'unrelated validation error' }, @{ kind = 'different deployment message' }
            @{ kind = 'different error target' }, @{ kind = 'array error target' }
            @{ kind = 'descendant preflight failure' }, @{ kind = 'contradictory error wrapper' }
            @{ kind = 'missing details' }, @{ kind = 'malformed details' }, @{ kind = 'malformed detail' }
            @{ kind = 'duplicate failed Create' }, @{ kind = 'successful Create for the same target' }
            @{ kind = 'successful Read of the same target' }, @{ kind = 'rejection on a Read instead of Create' }
        ) {
            $operation = $script:preflightOperation.properties
            switch ($kind) {
                'missing operation type' { $operation.Remove('provisioningOperation') }
                'array operation type' { $operation.provisioningOperation = @('Create') }
                'successful Create' { $operation.provisioningState = 'Succeeded' }
                'running Create' { $operation.provisioningState = 'Running' }
                'missing operation state' { $operation.Remove('provisioningState') }
                'array operation state' { $operation.provisioningState = @('Failed') }
                'missing HTTP status' { $operation.Remove('statusCode') }
                'HTTP authorization failure' { $operation.statusCode = 'Forbidden' }
                'array HTTP status' { $operation.statusCode = @('BadRequest') }
                'missing resource type' { $operation.targetResource.Remove('resourceType') }
                'wrong resource type' { $operation.targetResource.resourceType = 'Microsoft.Compute/virtualMachineScaleSets' }
                'missing resource name' { $operation.targetResource.Remove('resourceName') }
                'wrong resource name' { $operation.targetResource.resourceName = 'another-child' }
                'array resource name' { $operation.targetResource.resourceName = @($operation.targetResource.resourceName) }
                'missing status message' { $operation.Remove('statusMessage') }
                'text status message' { $operation.statusMessage = $operation.statusMessage.error.message }
                'JSON-string status message' { $operation.statusMessage = ConvertTo-Json $operation.statusMessage -Depth 10 -Compress }
                'array status message' { $operation.statusMessage = @($operation.statusMessage) }
                'successful status message' { $operation.statusMessage.status = 'Succeeded' }
                'array status' { $operation.statusMessage.status = @('Failed') }
                'missing error' { $operation.statusMessage.Remove('error') }
                'array error' { $operation.statusMessage.error = @($operation.statusMessage.error) }
                'array error code' { $operation.statusMessage.error.code = @('InvalidTemplateDeployment') }
                'unrelated validation error' { $operation.statusMessage.error.message = 'An arbitrary template validation failure.' }
                'different deployment message' { $operation.statusMessage.error.message = $operation.statusMessage.error.message.Replace('xw3pmls5ubqw4-test-cvmsswinuni-init', 'grandchild') }
                'different error target' { $operation.statusMessage.error.target = "${script:preflightId}-other" }
                'array error target' { $operation.statusMessage.error.target = @($script:preflightId) }
                'descendant preflight failure' {
                    $operation.statusMessage.error = @{
                        code = 'DeploymentFailed'; message = 'A descendant failed.'; details = @($operation.statusMessage.error)
                    }
                }
                'contradictory error wrapper' { $operation.statusMessage.code = 'DeploymentFailed' }
                'missing details' { $operation.statusMessage.error.Remove('details') }
                'malformed details' { $operation.statusMessage.error.details = 'SkuNotAvailable' }
                'malformed detail' { $operation.statusMessage.error.details = @(@{ code = @('SkuNotAvailable'); message = 'Unavailable.' }) }
                'duplicate failed Create' { $script:records[$script:parentId].Operations += $script:preflightOperation }
                'successful Create for the same target' { $script:records[$script:parentId].Operations += New-FixtureOperation -Id $script:preflightId }
                'successful Read of the same target' { $script:records[$script:parentId].Operations += New-FixtureOperation -Id $script:preflightId -Operation Read }
                'rejection on a Read instead of Create' {
                    $operation.provisioningOperation = 'Read'
                    $script:records[$script:parentId].Operations += New-FixtureOperation -Id $script:preflightId -State Failed
                }
            }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Not -BeNullOrEmpty
            $result.deploymentIds | Should -Not -Contain $script:preflightId
            $script:trace | Should -Not -Contain "GET:$script:preflightId"
            $script:removed.Count | Should -Be 0
        }

        It 'Rejects ambiguous same-child evidence on a later operation page' {
            $page = "${script:parentId}/operations?api-version=2025-04-01"
            $nextPage = "$page&`$skiptoken=next"
            $script:restOverrides["GET $page"] = New-FixtureResponse -Content @{
                value = $script:records[$script:parentId].Operations; nextLink = "https://management.azure.com$nextPage"
            }
            $script:restOverrides["GET $nextPage"] = New-FixtureResponse -Content @{
                value = @((New-FixtureOperation -Id $script:preflightId -Operation Read))
            }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Not -BeNullOrEmpty
            Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path -eq $nextPage }
            $script:trace | Should -Not -Contain "GET:$script:preflightId"
        }

        It 'Rejects <kind> absence responses even with valid rejection evidence' -ForEach @(
            @{ kind = 'generic 404'; status = 404; content = @{ error = @{ code = 'NotFound' } } }
            @{ kind = 'missing resource group'; status = 404; content = @{ error = @{ code = 'ResourceGroupNotFound' } } }
            @{ kind = 'wrong HTTP status'; status = 403; content = @{ error = @{ code = 'DeploymentNotFound' } } }
            @{ kind = 'array response'; status = 404; content = @(@{ error = @{ code = 'DeploymentNotFound' } }) }
            @{ kind = 'array error'; status = 404; content = @{ error = @(@{ code = 'DeploymentNotFound' }) } }
            @{ kind = 'array code'; status = 404; content = @{ error = @{ code = @('DeploymentNotFound') } } }
            @{ kind = 'wrong error target'; status = 404; content = @{ error = @{ code = 'DeploymentNotFound'; target = '/providers/Microsoft.Resources/deployments/another-child' } } }
            @{ kind = 'different record'; status = 200; content = @{ id = '/providers/Microsoft.Resources/deployments/another-child' } }
        ) {
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] = New-FixtureResponse -StatusCode $status -Content $content
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Not -BeNullOrEmpty
            $result.deploymentIds | Should -Not -Contain $script:parentId
            $script:removed.Count | Should -Be 0
        }

        It 'Does not suppress <kind> with a DeploymentNotFound error ID' -ForEach @(
            @{ kind = 'authorization'; exceptionType = [System.UnauthorizedAccessException] }
            @{ kind = 'timeout'; exceptionType = [System.TimeoutException] }
            @{ kind = 'transport'; exceptionType = [System.Net.Http.HttpRequestException] }
            @{ kind = 'cancellation'; exceptionType = [System.OperationCanceledException] }
        ) {
            Mock Invoke-AzRestMethod {
                throw [System.Management.Automation.ErrorRecord]::new(
                    $exceptionType::new('Child lookup failed.'), 'DeploymentNotFound',
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound, $script:preflightId
                )
            } -ParameterFilter { $Path -eq "${script:preflightId}?api-version=2021-04-01" }
            if ($kind -eq 'cancellation') {
                { Get-DeploymentTargetResourceList @discoveryInput } | Should -Throw '*Child lookup failed*'
            } else {
                $result = Get-DeploymentTargetResourceList @discoveryInput
                $result.resolveError | Should -Match 'Child lookup failed'
            }
            $script:removed.Count | Should -Be 0
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Does not infer a missing or <state> parent from child rejection evidence' -ForEach @(
            @{ state = 'missing' }, @{ state = 'Succeeded' }, @{ state = 'Running' }, @{ state = 'Canceled' }
        ) {
            if ($state -eq 'missing') {
                $script:records.Remove($script:parentId)
            } else {
                $script:records[$script:parentId].State = $state
            }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Not -BeNullOrEmpty
            $result.deploymentIds | Should -BeNullOrEmpty
            $script:trace | Should -Not -Contain "GET:$script:preflightId"
        }

        It 'Traverses an existing <state> child instead of trusting historical rejection evidence' -ForEach @(
            @{ state = 'Failed' }, @{ state = 'Succeeded' }
        ) {
            $resourceId = "$script:groupId/providers/Microsoft.Network/virtualNetworks/child-resource"
            $script:records[$script:preflightId] = @{ State = $state; Operations = @((New-FixtureOperation -Id $resourceId)) }
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] = New-FixtureResponse -Content @{ id = $script:preflightId }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -BeNullOrEmpty
            $result.resourcesToRemove | Should -Contain $resourceId
            $result.deploymentIds | Should -Be @($script:preflightId, $script:nestedId, $script:parentId)
            $script:trace | Should -Contain "GET:$script:preflightId/operations"
        }

        It 'Still blocks cleanup when an existing child has <kind>' -ForEach @(
            @{ kind = 'nonterminal state' }, @{ kind = 'missing status after record lookup' }
            @{ kind = 'missing operations' }, @{ kind = 'missing descendant' }
        ) {
            $script:records[$script:preflightId] = @{ State = 'Failed'; Operations = @() }
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] = New-FixtureResponse -Content @{ id = $script:preflightId }
            switch ($kind) {
                'nonterminal state' { $script:records[$script:preflightId].State = 'Running' }
                'missing status after record lookup' { $script:records.Remove($script:preflightId) }
                'missing operations' {
                    $script:restOverrides["GET ${script:preflightId}/operations?api-version=2025-04-01"] =
                    New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
                }
                'missing descendant' {
                    $script:records[$script:preflightId].Operations = @((New-FixtureOperation -Id "${script:preflightId}-grandchild" -State Failed))
                }
            }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Not -BeNullOrEmpty
            $result.deploymentIds | Should -Not -Contain $script:parentId
        }

        It 'Does not infer an absent grandchild from a succeeded intermediate parent' {
            $script:records[$script:parentId].Operations = $script:records[$script:parentId].Operations[1..3]
            $script:records[$script:nestedId].Operations += $script:preflightOperation
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Match 'could not be found'
            $script:trace | Should -Not -Contain "GET:$script:preflightId"
            $result.deploymentIds | Should -Not -Contain $script:parentId
        }

        It 'Keeps a nonterminal successful sibling blocking cleanup after confirming child absence' {
            $script:records[$script:nestedId].State = 'Running'
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Match 'Running'
            $script:trace | Should -Contain "GET:$script:preflightId"
            $result.deploymentIds | Should -Not -Contain $script:parentId
        }

        It 'Uses the exact <scope> child ID and restores the discovery context' -ForEach @(
            @{ scope = 'resource group in another subscription'; prefix = '/subscriptions/22222222-2222-2222-2222-222222222222/resourceGroups/elsewhere' }
            @{ scope = 'subscription'; prefix = '/subscriptions/22222222-2222-2222-2222-222222222222' }
            @{ scope = 'management group'; prefix = '/providers/Microsoft.Management/managementGroups/elsewhere' }
            @{ scope = 'tenant'; prefix = '' }
        ) {
            $script:preflightId = "$prefix/providers/Microsoft.Resources/deployments/xw3pmls5ubqw4-test-cvmsswinuni-init"
            $script:preflightOperation.properties.targetResource.id = $script:preflightId
            $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] =
            New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -BeNullOrEmpty
            $result.deploymentIds | Should -Be @($script:nestedId, $script:parentId)
            $script:trace | Should -Contain "GET:$script:preflightId"
            $script:azContext.Subscription.Id | Should -Be $script:subscriptionId
        }

        It 'Restores cross-subscription context after a rejected child lookup <kind>' -ForEach @(
            @{ kind = 'fails'; exceptionType = [System.UnauthorizedAccessException] }
            @{ kind = 'is cancelled'; exceptionType = [System.OperationCanceledException] }
        ) {
            $script:preflightId = $script:preflightId.Replace($script:subscriptionId, '22222222-2222-2222-2222-222222222222')
            $script:preflightOperation.properties.targetResource.id = $script:preflightId
            Mock Invoke-AzRestMethod { throw $exceptionType::new('Child lookup failed.') } -ParameterFilter {
                $Path -eq "${script:preflightId}?api-version=2021-04-01"
            }
            if ($kind -eq 'is cancelled') {
                { Get-DeploymentTargetResourceList @discoveryInput } | Should -Throw '*Child lookup failed*'
            } else {
                $result = Get-DeploymentTargetResourceList @discoveryInput
                $result.resolveError | Should -Match 'Child lookup failed'
            }
            $script:azContext.Subscription.Id | Should -Be $script:subscriptionId
            Should -Invoke Set-AzContext -Times 1 -Exactly -ParameterFilter {
                $PesterBoundParameters.ContainsKey('Context') -and $Context.Subscription.Id -eq $script:subscriptionId
            }
            $script:removed.Count | Should -Be 0
        }

        It 'Does not use rejection evidence when the parsed lookup scope differs from the target ID' {
            $script:preflightOperation.properties.targetResource.id =
            "$script:preflightId/providers/Microsoft.Resources/deployments/xw3pmls5ubqw4-test-cvmsswinuni-init"
            $result = Get-DeploymentTargetResourceList @discoveryInput
            $result.resolveError | Should -Not -BeNullOrEmpty
            $script:trace | Should -Not -Contain "GET:$script:preflightId"
            $result.deploymentIds | Should -Not -Contain $script:parentId
        }
    }

    It 'Cleans rejected-child failures before relocation within the shared budgets: <outcomes>' -Tag 'NestedPreflight' -ForEach @(
        @{ outcomes = @('Regional', 'Succeeded') }
        @{ outcomes = @('Regional', 'Regional', 'Succeeded') }
        @{ outcomes = @('Regional', 'Regional', 'Regional') }
    ) {
        $script:outcomes = $outcomes
        $script:regions = @('centralus', 'swedencentral', 'eastus')
        $script:preflightId = "$script:groupId/providers/Microsoft.Resources/deployments/xw3pmls5ubqw4-test-cvmsswinuni-init"
        $script:regionalError = (New-FixturePreflightOperation -Id $script:preflightId).properties.statusMessage
        $script:incidentMessage = "The deployment '{0}' failed with error(s). (Code: DeploymentFailed) " +
        $script:regionalError.error.message + ' (Code: InvalidTemplateDeployment) ' +
        $script:regionalError.error.details[0].message + ' (Code: SkuNotAvailable)'
        $script:restOverrides["GET ${script:preflightId}?api-version=2021-04-01"] =
        New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
        Mock Invoke-AzRestMethod {
            $id = $Path.Split('?')[0] -replace '/operations$', ''
            if ($Method -eq 'GET' -and $Path.Contains('/operations?') -and $id -in $script:roots) {
                $script:records[$id].Operations = @(
                    (New-FixturePreflightOperation -Id $script:preflightId)
                    (New-FixtureOperation -Id $script:nestedId -Operation Read)
                    (New-FixtureOperation -Id $script:nestedId)
                    (New-FixtureOperation -Id $script:groupId)
                )
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        if ($outcomes[-1] -eq 'Succeeded') {
            $result.ContainsKey('Exception') | Should -BeFalse
        } else {
            $result.Exception | Should -Match 'Standard_B12ms'
        }
        $result.DeploymentAttempts | Should -Be $outcomes.Count
        $result.AttemptedLocations | Should -Be $script:regions[0..($outcomes.Count - 1)]
        $result.DeploymentNames | Should -Be @($script:names)
        $result.RemainingDeploymentNames | Should -Be @($script:names[-1])
        $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
        for ($index = 0; $index -lt $outcomes.Count - 1; $index++) {
            $root = $script:roots[$index]
            $script:records.ContainsKey($root) | Should -BeFalse
            $script:trace.IndexOf("DELETE:$root") | Should -BeLessThan $script:trace.IndexOf("validate:$($script:regions[$index + 1])")
        }
        $script:removed.Count | Should -BeGreaterThan 0
        $script:trace | Should -Contain "GET:$script:nestedId/operations"
        $script:trace | Should -Not -Contain "DELETE:$script:preflightId"
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
    }

    Context 'AKS managed-cluster preflight with no supported zones' {
        BeforeEach {
            $script:aksResponseJson = Get-Content -LiteralPath (Join-Path -Path $PSScriptRoot -ChildPath 'fixtures\aks-empty-zones-regional-error.json') -Raw
            $script:regionalError = $script:aksResponseJson | ConvertFrom-Json -AsHashtable
            $script:regions = @('swedencentral', 'norwayeast', 'eastus')
            $script:incidentMessage = "The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s). Status Message: " +
            'AKS managed-cluster preflight failed. (Code: AvailabilityZoneNotSupported)'
        }

        It 'Relocates after successful validation and a failed nested deployment only after confirmed cleanup' {
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:validations) | Should -Be @('swedencentral', 'norwayeast')
            @($script:submissions) | Should -Be @('swedencentral', 'norwayeast')
            $result.DeploymentOutput.region.value | Should -Be 'norwayeast'
            $result.AttemptedLocations | Should -Be @('swedencentral', 'norwayeast')
            $result.DeploymentAttempts | Should -Be 2
            $result.DeploymentNames | Should -Be @($script:names)
            $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:regionalError.error.Contains('target') | Should -BeFalse
            $script:regionalError.error.details[0].Contains('target') | Should -BeFalse
            $script:records[$script:roots[1]].Operations[1].properties.targetResource.id | Should -Be $script:nestedId
            $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
            $script:resourceRegion | Should -Be 'norwayeast'
            $script:removed | Should -Contain $script:groupId
            $script:trace | Should -Contain "GET:$script:nestedId/operations"
            $root = $script:roots[0]
            foreach ($step in @("remove:$script:groupId", "GET:$script:groupId", "DELETE:$root", "GET:$root")) {
                $script:trace | Should -Contain $step
            }
            $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.LastIndexOf("GET:$script:groupId")
            $script:trace.LastIndexOf("GET:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$root")
            $script:trace.IndexOf("DELETE:$root") | Should -BeLessThan $script:trace.LastIndexOf("GET:$root")
            $script:trace.LastIndexOf("GET:$root") | Should -BeLessThan $script:trace.IndexOf('validate:norwayeast')
            $script:trace.IndexOf('validate:norwayeast') | Should -BeLessThan $script:trace.IndexOf('submit:norwayeast')
            $templateInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
            Should -Invoke New-AzSubscriptionDeployment -Times 2 -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
            Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
        }

        It 'Passes the selected region to validation without submitting or cleaning the rejected candidate' {
            $script:validationFailures = @('swedencentral')
            $script:outcomes = @('Succeeded')
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:validations) | Should -Be @('swedencentral', 'norwayeast')
            @($script:submissions) | Should -Be @('norwayeast')
            $result.DeploymentAttempts | Should -Be 1
            $script:removed.Count | Should -Be 0
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Preserves the shared three-candidate and three-submission budgets' {
            $script:outcomes = @('Regional', 'Regional', 'Regional')
            Mock New-AzSubscriptionDeployment {
                $script:regionalError = $script:aksResponseJson.Replace('swedencentral', $resourceLocation) | ConvertFrom-Json -AsHashtable
                Invoke-FixtureSubmission -Name $DeploymentName -Path $TemplateFile -Region $resourceLocation -BaseTime $baseTime -Secret $adminSecret
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'AKS managed-cluster preflight failed'
            @($script:submissions) | Should -Be $script:regions
            @($script:validations) | Should -Be $script:regions
            $result.AttemptedLocations | Should -Be $script:regions
            $result.DeploymentAttempts | Should -Be 3
            $result.RemainingDeploymentNames | Should -Be @($script:names[2])
            $script:removed.Count | Should -Be 2
        }

        It 'Does not change existing same-region retries when relocation is pinned' {
            $retryInput.CustomLocation = 'swedencentral'
            $script:outcomes = @('Regional', 'Regional', 'Regional')
            $script:incidentMessage = "The deployment '{0}' failed with error(s). (Code: DeploymentFailed) AKS managed-cluster preflight failed."
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'AKS managed-cluster preflight failed'
            @($script:submissions) | Should -Be @('swedencentral', 'swedencentral', 'swedencentral')
            @($script:validations) | Should -Be @('swedencentral')
            $result.DeploymentAttempts | Should -Be 3
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $script:removed.Count | Should -Be 0
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Never relocates AKS zone failures with <restriction>' -ForEach @(
            @{ restriction = 'custom location' }, @{ restriction = 'CI location' }, @{ restriction = 'token location' }
            @{ restriction = 'retained resources' }, @{ restriction = 'global resources' }
            @{ restriction = 'resource-group scope' }, @{ restriction = 'no movable input' }
        ) {
            switch ($restriction) {
                'custom location' { $retryInput.CustomLocation = 'swedencentral' }
                'CI location' { $templateInput.AdditionalParameters.resourceLocation = 'swedencentral' }
                'token location' { $retryInput.TokenResourceLocation = 'Sweden Central' }
                'retained resources' { $retryInput.RemoveDeployment = $false }
                'global resources' { Mock Get-AvailableResourceLocation { @{ Location = 'swedencentral'; IsGlobal = $true } } }
                'resource-group scope' {
                    $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                    $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
                }
                'no movable input' {
                    $template.variables.Remove('regionToken')
                    $templateInput.AdditionalParameters.Remove('resourceLocation')
                    $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'AKS managed-cluster preflight failed'
            $script:validations.Count | Should -Be 1
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Rejects a mismatched error region during <phase>' -ForEach @(
            @{ phase = 'validation' }, @{ phase = 'deployment' }
        ) {
            $script:regionalError = $script:aksResponseJson.Replace('swedencentral', 'norwayeast') | ConvertFrom-Json -AsHashtable
            if ($phase -eq 'validation') { $script:validationFailures = @('swedencentral') }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Not -BeNullOrEmpty
            $result.AttemptedLocations | Should -Be @('swedencentral')
            $script:validations.Count | Should -Be 1
            $script:submissions.Count | Should -Be ($phase -eq 'validation' ? 0 : 1)
            $script:removed.Count | Should -Be 0
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
        }

        It 'Requires an authoritative Failed root instead of <state>' -ForEach @(
            @{ state = 'Running' }, @{ state = 'Accepted' }, @{ state = 'Canceled' }
            @{ state = 'Succeeded' }, @{ state = 'Unknown' }, @{ state = '' }
        ) {
            Mock Get-AzDeployment { @{ DeploymentName = $Name; ProvisioningState = $state } }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'no retry is safe'
            $script:validations.Count | Should -Be 1
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Does not relocate when root status cannot be read' {
            Mock Get-AzDeployment { throw [System.UnauthorizedAccessException]::new('Root lookup forbidden.') }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'Root lookup forbidden'
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Retains cleanup ownership when <failure>' -ForEach @(
            @{ failure = 'resource removal fails'; expected = 'removal failed' }
            @{ failure = 'resources remain'; expected = 'still exists after cleanup' }
            @{ failure = 'record deletion fails'; expected = 'record removal failed' }
            @{ failure = 'record remains'; expected = 'record .* still exists after cleanup' }
        ) {
            switch ($failure) {
                'resource removal fails' { Mock Remove-AzResource { throw 'Removal failed.' } }
                'resources remain' { Mock Remove-AzResource {} }
                'record deletion fails' {
                    Mock Invoke-AzRestMethod {
                        if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 403 }
                        Invoke-FixtureRest -Method $Method -Path $Path
                    }
                }
                'record remains' {
                    Mock Invoke-AzRestMethod {
                        if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 202 }
                        Invoke-FixtureRest -Method $Method -Path $Path
                    }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match $expected
            $result.Exception | Should -Match 'AKS managed-cluster preflight failed'
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $script:validations.Count | Should -Be 1
            $script:submissions.Count | Should -Be 1
            $script:records.ContainsKey($script:roots[0]) | Should -BeTrue
        }

        It 'Rejects <proof> cleanup confirmation' -ForEach @(
            @{ proof = 'null' }, @{ proof = 'empty' }, @{ proof = 'wrong name' }, @{ proof = 'extra name' }
        ) {
            Mock Initialize-DeploymentRemoval {
                $RequireCompleteRemoval | Should -BeTrue
                switch ($proof) {
                    'null' { return }
                    'empty' { @{ RemovedDeploymentNames = @() } }
                    'wrong name' { @{ RemovedDeploymentNames = @('another-deployment') } }
                    'extra name' { @{ RemovedDeploymentNames = @($DeploymentNames) + @('another-deployment') } }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'Cleanup did not confirm removal'
            $script:validations.Count | Should -Be 1
            $script:submissions.Count | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
        }

        It 'Stops on a mixed <code> failure instead of relocating' -ForEach @(
            @{ code = 'Unknown' }, @{ code = 'AuthorizationFailed' }, @{ code = 'QuotaExceeded' }, @{ code = 'BadRequest' }
        ) {
            $message = $code -eq 'BadRequest' ?
            '{"code":"PropertyChangeNotAllowed","details":null,"message":"Changing property \"agentPoolProfile.availabilityZone\" is not allowed in an api-version before \"2026-01-02-preview\".","subcode":"","target":"agentPoolProfile.availabilityZone"}' :
            'Not a regional capacity failure.'
            $script:regionalError.error.details += @{ code = $code; message = $message }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'AKS managed-cluster preflight failed'
            $script:validations.Count | Should -Be 1
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
        }

        It 'Propagates cancellation without querying or cleaning a claimed AKS failure' {
            $script:outcomes = @('Cancel', 'Succeeded')
            { Invoke-TemplateDeploymentWithRetry @retryInput } | Should -Throw '*cancelled*'
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
            Should -Invoke Get-AzDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Preserves the original exception when AKS error evidence is rejected' {
            $script:regionalError.error.details[0].message = $script:regionalError.error.details[0].message.Replace("are ''", "are '1,2'")
            Mock New-AzSubscriptionDeployment {
                try {
                    Invoke-FixtureSubmission -Name $DeploymentName -Path $TemplateFile -Region $resourceLocation -BaseTime $baseTime -Secret $adminSecret
                } catch {
                    $script:originalAksError = $_
                    throw
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            [object]::ReferenceEquals($result.ErrorRecord.Exception, $script:originalAksError.Exception) | Should -BeTrue
            $result.Exception | Should -Match 'AKS managed-cluster preflight failed'
            $script:removed.Count | Should -Be 0
            $script:submissions.Count | Should -Be 1
        }
    }

    It 'Revalidates ML Cosmos capacity in another region only after resources and deployment records are confirmed absent' {
        Initialize-FixtureMachineLearningCosmosFailure
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeFalse
        @($script:validations) | Should -Be @('norwayeast', 'swedencentral')
        @($script:submissions) | Should -Be @('norwayeast', 'swedencentral')
        $result.DeploymentOutput.region.value | Should -Be 'swedencentral'
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
        $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
        $script:resourceRegion | Should -Be 'swedencentral'
        $root = $script:roots[0]
        $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.LastIndexOf("GET:$script:groupId")
        $script:trace.LastIndexOf("GET:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$root")
        $script:trace.IndexOf("DELETE:$root") | Should -BeLessThan $script:trace.LastIndexOf("GET:$root")
        $script:trace.LastIndexOf("GET:$root") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
        $script:trace.IndexOf('validate:swedencentral') | Should -BeLessThan $script:trace.IndexOf('submit:swedencentral')
        $result.AttemptedLocations | Should -Be @('norwayeast', 'swedencentral')
        $result.DeploymentAttempts | Should -Be 2
        $templateInput.AdditionalParameters.resourceLocation | Should -BeExactly ''
        Should -Invoke New-AzSubscriptionDeployment -Times 2 -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
    }

    It 'Passes the selected resource region into ML Cosmos validation before submitting anything' {
        Initialize-FixtureMachineLearningCosmosFailure
        $script:validationFailures = @('norwayeast')
        $script:outcomes = @('Succeeded')
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.ContainsKey('Exception') | Should -BeFalse
        @($script:validations) | Should -Be @('norwayeast', 'swedencentral')
        @($script:submissions) | Should -Be @('swedencentral')
        $result.DeploymentAttempts | Should -Be 1
        $script:removed.Count | Should -Be 0
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Preserves the three-region and three-submission limits for repeated ML Cosmos capacity failures' {
        Initialize-FixtureMachineLearningCosmosFailure
        $script:outcomes = @('Regional', 'Regional', 'Regional')
        Mock New-AzSubscriptionDeployment {
            $script:regionalError = $script:cosmosResponseJson.Replace('Norway East', $resourceLocation) | ConvertFrom-Json -AsHashtable
            Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match 'Machine Learning workspace database account creation failed'
        @($script:submissions) | Should -Be $script:regions
        @($script:validations) | Should -Be $script:regions
        $result.DeploymentAttempts | Should -Be 3
        $result.AttemptedLocations | Should -Be $script:regions
        $result.RemainingDeploymentNames | Should -Be @($script:names[2])
        $script:removed.Count | Should -Be 2
    }

    It 'Spends only three candidate slots on ML Cosmos validation failures without submitting deployments' {
        Initialize-FixtureMachineLearningCosmosFailure
        $script:validationFailures = $script:regions
        Mock Test-AzSubscriptionDeployment {
            $script:regionalError = $script:cosmosResponseJson.Replace('Norway East', $resourceLocation) | ConvertFrom-Json -AsHashtable
            Invoke-FixtureValidation $TemplateFile $resourceLocation $baseTime $adminSecret
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Not -BeNullOrEmpty
        $result.AttemptedLocations | Should -Be $script:regions
        $result.DeploymentAttempts | Should -Be 0
        $script:submissions.Count | Should -Be 0
        $script:removed.Count | Should -Be 0
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Never relocates ML Cosmos capacity with <pin>' -ForEach @(
        @{ pin = 'custom location' }, @{ pin = 'CI location' }, @{ pin = 'token location' }
        @{ pin = 'retained resources' }, @{ pin = 'global resources' }, @{ pin = 'resource-group scope' }, @{ pin = 'no movable input' }
    ) {
        Initialize-FixtureMachineLearningCosmosFailure
        switch ($pin) {
            'custom location' { $retryInput.CustomLocation = 'norwayeast' }
            'CI location' { $templateInput.AdditionalParameters.resourceLocation = 'norwayeast' }
            'token location' { $retryInput.TokenResourceLocation = 'Norway East' }
            'retained resources' { $retryInput.RemoveDeployment = $false }
            'global resources' { Mock Get-AvailableResourceLocation { @{ Location = 'norwayeast'; IsGlobal = $true } } }
            'resource-group scope' {
                $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
            }
            'no movable input' {
                $template.variables.Remove('regionToken')
                $templateInput.AdditionalParameters.Remove('resourceLocation')
                $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match 'Machine Learning workspace database account creation failed'
        $script:validations.Count | Should -Be 1
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Does not relocate a fixed secondary Cosmos region during <phase>' -ForEach @(
        @{ phase = 'validation' }, @{ phase = 'deployment' }
    ) {
        Initialize-FixtureMachineLearningCosmosFailure
        $script:regionalError = $script:cosmosResponseJson.Replace('Norway East', 'Sweden Central') | ConvertFrom-Json -AsHashtable
        if ($phase -eq 'validation') { $script:validationFailures = @('norwayeast') }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Not -BeNullOrEmpty
        $result.AttemptedLocations | Should -Be @('norwayeast')
        $script:validations.Count | Should -Be 1
        $script:submissions.Count | Should -Be ($phase -eq 'validation' ? 0 : 1)
        $script:removed.Count | Should -Be 0
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
    }

    It 'Requires an authoritative Failed root for ML Cosmos despite a <state> response' -ForEach @(
        @{ state = 'Running' }, @{ state = 'Accepted' }, @{ state = 'Canceled' }, @{ state = 'Succeeded' }, @{ state = 'Unknown' }
    ) {
        Initialize-FixtureMachineLearningCosmosFailure
        Mock Get-AzDeployment { @{ DeploymentName = $Name; ProvisioningState = $state } }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match 'no retry is safe'
        $script:validations.Count | Should -Be 1
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Retains ML Cosmos cleanup ownership when <failure>' -ForEach @(
        @{ failure = 'resource removal fails'; expected = 'removal failed' }
        @{ failure = 'resources remain'; expected = 'still exists after cleanup' }
        @{ failure = 'record deletion fails'; expected = 'record removal failed' }
        @{ failure = 'record remains'; expected = 'record .* still exists after cleanup' }
    ) {
        Initialize-FixtureMachineLearningCosmosFailure
        switch ($failure) {
            'resource removal fails' { Mock Remove-AzResource { throw 'Removal failed.' } }
            'resources remain' { Mock Remove-AzResource {} }
            'record deletion fails' {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 403 }
                    Invoke-FixtureRest $Method $Path
                }
            }
            'record remains' {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 202 }
                    Invoke-FixtureRest $Method $Path
                }
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match $expected
        $result.Exception | Should -Match 'Machine Learning workspace database account creation failed'
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        $script:validations.Count | Should -Be 1
        $script:submissions.Count | Should -Be 1
        $script:records.ContainsKey($script:roots[0]) | Should -BeTrue
    }

    It 'Rejects <proof> cleanup confirmation before ML Cosmos relocation' -ForEach @(
        @{ proof = 'null' }, @{ proof = 'empty' }, @{ proof = 'wrong name' }, @{ proof = 'extra name' }
    ) {
        Initialize-FixtureMachineLearningCosmosFailure
        Mock Initialize-DeploymentRemoval {
            $RequireCompleteRemoval | Should -BeTrue
            switch ($proof) {
                'null' { return }
                'empty' { @{ RemovedDeploymentNames = @() } }
                'wrong name' { @{ RemovedDeploymentNames = @('another-deployment') } }
                'extra name' { @{ RemovedDeploymentNames = @($DeploymentNames) + @('another-deployment') } }
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match 'Cleanup did not confirm removal'
        $script:validations.Count | Should -Be 1
        $script:submissions.Count | Should -Be 1
        $result.RemainingDeploymentNames | Should -Be @($script:names)
    }

    It 'Rejects ML Cosmos evidence when a later operation page has <kind>' -ForEach @(
        @{ kind = 'permanent error' }, @{ kind = 'running operation' }, @{ kind = 'missing error' }, @{ kind = 'another Cosmos region' }
        @{ kind = 'extra error information' }
    ) {
        Initialize-FixtureMachineLearningCosmosFailure
        Mock Invoke-AzRestMethod {
            $root = $script:roots[0]
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2025-04-01") {
                return New-FixtureResponse -Content @{
                    value = @($script:records[$root].Operations[1])
                    nextLink = "https://management.azure.com${root}/operations?api-version=2025-04-01&`$skiptoken=next"
                }
            }
            if ($Method -eq 'GET' -and $Path.EndsWith('&$skiptoken=next')) {
                $operation = switch ($kind) {
                    'permanent error' { New-FixtureOperation -State Failed -StatusMessage @{ error = @{ code = 'InvalidParameter'; message = 'Invalid encryption key.' } } }
                    'running operation' { New-FixtureOperation -State Running -StatusMessage $script:regionalError }
                    'missing error' { New-FixtureOperation -State Failed }
                    'another Cosmos region' {
                        New-FixtureOperation -State Failed -StatusMessage ($script:cosmosResponseJson.Replace('Norway East', 'Sweden Central') | ConvertFrom-Json -AsHashtable)
                    }
                    'extra error information' {
                        New-FixtureOperation -State Failed -StatusMessage @{
                            error = @{ code = 'SkuNotAvailable'; message = 'SKU not available in this location.' }
                            additionalInfo = @{ code = 'AuthorizationFailed' }
                        }
                    }
                }
                return New-FixtureResponse -Content @{ value = @($operation) }
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Not -BeNullOrEmpty
        $script:submissions.Count | Should -Be 1
        $script:validations.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path.EndsWith('&$skiptoken=next') }
    }

    It 'Preserves the original ML exception when the Cosmos region does not match' {
        Initialize-FixtureMachineLearningCosmosFailure
        $script:regionalError = $script:cosmosResponseJson.Replace('Norway East', 'Sweden Central') | ConvertFrom-Json -AsHashtable
        Mock New-AzSubscriptionDeployment {
            try {
                Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
            } catch {
                $script:originalMlError = $_
                throw
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        [object]::ReferenceEquals($result.ErrorRecord.Exception, $script:originalMlError.Exception) | Should -BeTrue
        $result.Exception | Should -Match 'Machine Learning workspace database account creation failed'
        $script:removed.Count | Should -Be 0
        $script:submissions.Count | Should -Be 1
    }

    It 'Preserves SDK-formatted display messages at <scope> scope' -ForEach @(
        @{ scope = 'subscription'; command = 'Get-AzDeploymentOperation' }
        @{ scope = 'resourcegroup'; command = 'Get-AzResourceGroupDeploymentOperation' }
        @{ scope = 'managementgroup'; command = 'Get-AzManagementGroupDeploymentOperation' }
        @{ scope = 'tenant'; command = 'Get-AzTenantDeploymentOperation' }
    ) {
        $message = Get-ErrorMessageForScope -DeploymentScope $scope -DeploymentName 'display-fixture' `
            -ResourceGroupName 'retry-fixture' -ManagementGroupId 'test-management-group'
        $message | Should -BeExactly $script:operationStatusMessage
        Should -Invoke $command -Times 1 -Exactly -ParameterFilter { $DeploymentName -eq 'display-fixture' }
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Reads every raw operation page without filtering operation types at <scope> scope' -ForEach @(
        @{ scope = 'subscription'; prefix = '/subscriptions/11111111-1111-1111-1111-111111111111' }
        @{ scope = 'resourcegroup'; prefix = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/retry-fixture' }
        @{ scope = 'managementgroup'; prefix = '/providers/Microsoft.Management/managementGroups/test-management-group' }
        @{ scope = 'tenant'; prefix = '' }
    ) {
        $id = "$prefix/providers/Microsoft.Resources/deployments/structured-fixture"
        $script:records[$id] = @{ Operations = @(
                (New-FixtureOperation -Id $script:groupId)
                (New-FixtureOperation -Operation Action -State Failed -StatusMessage $script:regionalError)
            )
        }
        $firstPage = "${id}/operations?api-version=2025-04-01"
        $nextPage = "$firstPage&`$skiptoken=next"
        $script:restOverrides["GET $firstPage"] = New-FixtureResponse -Content @{
            value    = @($script:records[$id].Operations[0])
            nextLink = "https://management.azure.com$nextPage"
        }
        $script:restOverrides["GET $nextPage"] = New-FixtureResponse -Content @{ value = @($script:records[$id].Operations[1]) }
        $errors = Get-ErrorMessageForScope -DeploymentScope $scope -DeploymentName 'structured-fixture' `
            -ResourceGroupName 'retry-fixture' -ManagementGroupId 'test-management-group' -AsObject

        $errors | Should -HaveCount 1
        $errors[0].error.code | Should -BeExactly 'InvalidTemplateDeployment'
        $errors[0].error.details[0].code | Should -BeExactly 'SkuNotAvailable'
        $errors[0].error.details[0].message | Should -BeExactly $script:regionalError.error.details[0].message
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq $firstPage
        }
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and $Path -eq $nextPage
        }
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
        Should -Invoke Get-AzResourceGroupDeploymentOperation -Times 0 -Exactly
        Should -Invoke Get-AzManagementGroupDeploymentOperation -Times 0 -Exactly
        Should -Invoke Get-AzTenantDeploymentOperation -Times 0 -Exactly
    }

    It 'Does not treat missing operations as successful empty evidence at <scope> scope' -ForEach @(
        @{ scope = 'subscription'; code = 'DeploymentNotFound' }
        @{ scope = 'resourcegroup'; code = 'DeploymentNotFound' }
        @{ scope = 'resourcegroup'; code = 'ResourceGroupNotFound' }
        @{ scope = 'managementgroup'; code = 'DeploymentNotFound' }
        @{ scope = 'tenant'; code = 'DeploymentNotFound' }
    ) {
        Mock Invoke-AzRestMethod { New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = $code } } }
        {
            Get-ErrorMessageForScope -DeploymentScope $scope -DeploymentName 'missing-fixture' `
                -ResourceGroupName 'retry-fixture' -ManagementGroupId 'test-management-group' -AsObject
        } | Should -Throw '*complete deployment operation pages*'
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
    }

    It 'Rejects an incomplete <scope> scope before reading operations' -ForEach @(
        @{ scope = 'subscription'; missing = 'subscription' }
        @{ scope = 'resourcegroup'; missing = 'subscription' }
        @{ scope = 'resourcegroup'; missing = 'resource group' }
        @{ scope = 'managementgroup'; missing = 'management group' }
    ) {
        $resourceGroup = 'retry-fixture'
        $managementGroup = 'test-management-group'
        switch ($missing) {
            'subscription' { $script:azContext.Subscription = $null }
            'resource group' { $resourceGroup = '' }
            'management group' { $managementGroup = '' }
        }
        {
            Get-ErrorMessageForScope -DeploymentScope $scope -DeploymentName 'scope-fixture' `
                -ResourceGroupName $resourceGroup -ManagementGroupId $managementGroup -AsObject
        } | Should -Throw '*complete deployment operation pages*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Does not relocate from <kind> raw operation data despite regional SDK text' -ForEach @(
        @{ kind = 'missing operation list' }, @{ kind = 'non-array operation list' }, @{ kind = 'array response' }
        @{ kind = 'null response' }, @{ kind = 'string response' }
        @{ kind = 'empty operation list' }, @{ kind = 'successful operations only' }
        @{ kind = 'null operation' }, @{ kind = 'missing properties' }, @{ kind = 'array properties' }
        @{ kind = 'missing operation type' }, @{ kind = 'array operation type' }
        @{ kind = 'missing state' }, @{ kind = 'array state' }, @{ kind = 'Running state' }
        @{ kind = 'Accepted state' }, @{ kind = 'Canceled state' }, @{ kind = 'unknown state' }
        @{ kind = 'missing error' }, @{ kind = 'text error' }, @{ kind = 'JSON-string error' }, @{ kind = 'array error' }
        @{ kind = 'blank leaf code' }, @{ kind = 'empty error object' }, @{ kind = 'mixed error' }
    ) {
        Mock Invoke-AzRestMethod {
            $root = $script:roots[0]
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2025-04-01") {
                $failure = New-FixtureOperation -Id $script:nestedId -State Failed -StatusMessage $script:regionalError
                $content = @{ value = @($script:records[$root].Operations[1], $failure) }
                switch ($kind) {
                    'missing operation list' { $content.Remove('value') }
                    'non-array operation list' { $content.value = $failure }
                    'array response' { return New-FixtureResponse -Content @($content) }
                    'null response' { return New-FixtureResponse -Content $null }
                    'string response' { return New-FixtureResponse -Content 'unexpected-response' }
                    'empty operation list' { $content.value = @() }
                    'successful operations only' { $content.value = @((New-FixtureOperation -Id $script:groupId)) }
                    'null operation' { $content.value[1] = $null }
                    'missing properties' { $content.value[1] = @{} }
                    'array properties' { $failure.properties = @($failure.properties) }
                    'missing operation type' { $failure.properties.Remove('provisioningOperation') }
                    'array operation type' { $failure.properties.provisioningOperation = @('Create') }
                    'missing state' { $failure.properties.Remove('provisioningState') }
                    'array state' { $failure.properties.provisioningState = @('Failed') }
                    'Running state' { $failure.properties.provisioningState = 'Running' }
                    'Accepted state' { $failure.properties.provisioningState = 'Accepted' }
                    'Canceled state' { $failure.properties.provisioningState = 'Canceled' }
                    'unknown state' { $failure.properties.provisioningState = 'Unknown' }
                    'missing error' { $failure.properties.Remove('statusMessage') }
                    'text error' { $failure.properties.statusMessage = $script:operationStatusMessage }
                    'JSON-string error' { $failure.properties.statusMessage = ConvertTo-Json $script:regionalError -Depth 10 -Compress }
                    'array error' { $failure.properties.statusMessage = @($script:regionalError) }
                    'blank leaf code' { $failure.properties.statusMessage = @{ error = @{ code = ''; message = 'Capacity is not available in this location.' } } }
                    'empty error object' { $failure.properties.statusMessage = @{} }
                    'mixed error' { $failure.properties.statusMessage = @{ error = @{ code = 'AuthorizationFailed'; message = 'Access denied.' } } }
                }
                return New-FixtureResponse -Content $content
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Not -BeNullOrEmpty
        $script:submissions.Count | Should -Be 1
        $script:validations.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($originalBytes))
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
    }

    It 'Includes nonregional failures from <operation> operations before considering relocation' -ForEach @(
        @{ operation = 'Read' }, @{ operation = 'Delete' }, @{ operation = 'Action' }
        @{ operation = 'EvaluateDeploymentOutput' }, @{ operation = 'NotSpecified' }
    ) {
        Mock Invoke-AzRestMethod {
            $root = $script:roots[0]
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2025-04-01") {
                return New-FixtureResponse -Content @{ value = @($script:records[$root].Operations) + @(
                        (New-FixtureOperation -Operation $operation -State Failed -StatusMessage @{
                            error = @{ code = 'InvalidTemplate'; message = 'Invalid configuration.' }
                        })
                    )
                }
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Not -BeNullOrEmpty
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
    }

    It 'Rejects <kind> operation-page failures without exposing raw response data' -ForEach @(
        @{ kind = 'invalid JSON' }, @{ kind = 'HTTP failure' }, @{ kind = 'transport exception' }
    ) {
        Mock Invoke-AzRestMethod {
            switch ($kind) {
                'invalid JSON' { return @{ StatusCode = 200; Content = '{"value": raw-response-secret' } }
                'HTTP failure' { return New-FixtureResponse -StatusCode 403 -Content @{ error = @{ code = 'raw-response-secret' } } }
                'transport exception' { throw [System.Net.Http.HttpRequestException]::new('raw-response-secret') }
            }
        }
        $log = @(Invoke-TemplateDeploymentWithRetry @retryInput 3>&1 4>&1)
        $result = $log | Where-Object { $_ -is [hashtable] }
        ($log | Out-String) | Should -Not -Match 'raw-response-secret'
        $result.Exception | Should -Match 'complete deployment operation pages'
        $result.Exception | Should -Not -Match 'raw-response-secret'
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames | Should -Be @($script:names)
    }

    It 'Preserves independent budgets with outcomes <outcomes> and rejected validations <rejected>' -ForEach @(
        @{ outcomes = @('Regional', 'Regional', 'Regional'); rejected = @(); regions = @('italynorth', 'swedencentral', 'eastus'); validations = 3 }
        @{ outcomes = @('Legacy', 'Regional', 'Succeeded'); rejected = @(); regions = @('italynorth', 'italynorth', 'swedencentral'); validations = 2 }
        @{ outcomes = @('Regional', 'Legacy', 'Succeeded'); rejected = @(); regions = @('italynorth', 'swedencentral', 'swedencentral'); validations = 2 }
        @{ outcomes = @('Legacy', 'Legacy', 'Succeeded'); rejected = @('italynorth', 'swedencentral'); regions = @('eastus', 'eastus', 'eastus'); validations = 3 }
        @{ outcomes = @('Regional', 'Succeeded'); rejected = @('italynorth'); regions = @('swedencentral', 'eastus'); validations = 3 }
    ) {
        $script:outcomes = $outcomes
        $script:validationFailures = $rejected
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        @($script:submissions) | Should -Be $regions
        $script:validations.Count | Should -Be $validations
        $result.DeploymentAttempts | Should -Be $regions.Count
        $result.AttemptedLocations.Count | Should -BeLessOrEqual 3
        @($result.AttemptedLocations | Select-Object -Unique).Count | Should -Be $result.AttemptedLocations.Count
        if ($outcomes[-1] -eq 'Succeeded') {
            $result.ContainsKey('Exception') | Should -BeFalse
        } else {
            $result.Exception | Should -Match 'ExampleSku'
            $result.RemainingDeploymentNames | Should -Be @($script:names[-1])
            [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($originalBytes))
        }
    }

    It 'Keeps safe same-region retries for <pin> without intermediate cleanup' -ForEach @(
        @{ pin = 'custom' }, @{ pin = 'CI' }, @{ pin = 'token' }, @{ pin = 'retention' }, @{ pin = 'global' }, @{ pin = 'resourcegroup' }, @{ pin = 'no movable input' }
    ) {
        $script:outcomes = @('Legacy', 'Succeeded')
        switch ($pin) {
            'custom' { $retryInput.CustomLocation = 'italynorth' }
            'CI' { $templateInput.AdditionalParameters.resourceLocation = 'italynorth' }
            'token' { $retryInput.TokenResourceLocation = 'italynorth' }
            'retention' { $retryInput.RemoveDeployment = $false }
            'global' { Mock Get-AvailableResourceLocation { @{ Location = 'italynorth'; IsGlobal = $true } } }
            'resourcegroup' {
                $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
            }
            'no movable input' {
                $template.variables.Remove('regionToken')
                $templateInput.AdditionalParameters.Remove('resourceLocation')
                $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        $script:submissions.Count | Should -Be 2
        @($script:submissions | Select-Object -Unique).Count | Should -Be 1
        $script:validations.Count | Should -Be 1
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        $script:removed.Count | Should -Be 0
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
    }

    It 'Never relocates a <kind> error tree' -ForEach @(
        @{ kind = 'mixed'; code = 'AuthorizationFailed' }
        @{ kind = 'quota'; code = 'QuotaExceeded' }
        @{ kind = 'configuration'; code = 'InvalidTemplate' }
        @{ kind = 'authentication'; code = 'InvalidAuthenticationToken' }
        @{ kind = 'unknown'; code = 'Unknown' }
    ) {
        $script:regionalError.error.details += @{ code = $code; message = 'Permanent error.' }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'ExampleSku'
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames | Should -Be @($script:names)
    }

    It 'Stops on authoritative <state> instead of trusting a deployment error string' -ForEach @(
        @{ state = 'Running' }, @{ state = 'Accepted' }, @{ state = 'Canceled' }, @{ state = 'Succeeded' }, @{ state = 'Unknown' }
    ) {
        Mock Get-AzDeployment { @{ DeploymentName = $Name; ProvisioningState = $state } }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'no retry is safe'
        $result.Exception | Should -Match 'ExampleSku'
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
    }

    It 'Rejects <shape> status identity evidence' -ForEach @(
        @{ shape = 'missing' }, @{ shape = 'mismatched' }, @{ shape = 'ambiguous' }
    ) {
        Mock Get-AzDeployment {
            switch ($shape) {
                'missing' { return }
                'mismatched' { @{ DeploymentName = 'other'; ProvisioningState = 'Failed' } }
                'ambiguous' { @(@{ DeploymentName = $Name; ProvisioningState = 'Failed' }, @{ DeploymentName = $Name; ProvisioningState = 'Failed' }) }
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'exactly the original deployment'
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
    }

    It 'Stops when <phase> lookup fails and preserves both diagnostics' -ForEach @(
        @{ phase = 'status'; expected = 'Lookup failed' }
        @{ phase = 'details'; expected = 'complete deployment operation pages' }
        @{ phase = 'cleanup discovery'; expected = 'Lookup failed' }
    ) {
        switch ($phase) {
            'status' { Mock Get-AzDeployment { throw [System.Net.Http.HttpRequestException]::new('Lookup failed.') } }
            'details' { Mock Invoke-AzRestMethod { throw [System.UnauthorizedAccessException]::new('Lookup failed.') } }
            'cleanup discovery' {
                Mock Invoke-AzRestMethod {
                    if ($Path.Split('?')[0] -eq "$script:nestedId/operations") { throw [System.TimeoutException]::new('Lookup failed.') }
                    Invoke-FixtureRest $Method $Path
                }
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match $expected
        $result.Exception | Should -Match 'ExampleSku'
        $script:submissions.Count | Should -Be 1
        $result.RemainingDeploymentNames | Should -Be @($script:names)
    }

    It 'Retains cleanup ownership and stops when <failure>' -ForEach @(
        @{ failure = 'resource removal throws'; expected = 'removal failed' }
        @{ failure = 'resources remain'; expected = 'still exists after cleanup' }
        @{ failure = 'record deletion fails'; expected = 'record removal failed' }
        @{ failure = 'record still exists'; expected = 'record .* still exists after cleanup' }
    ) {
        switch ($failure) {
            'resource removal throws' { Mock Remove-AzResource { throw 'Removal failed.' } }
            'resources remain' { Mock Remove-AzResource {} }
            'record deletion fails' {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 403 -Content @{ error = @{ code = 'AuthorizationFailed' } } }
                    Invoke-FixtureRest $Method $Path
                }
            }
            'record still exists' {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 202 }
                    Invoke-FixtureRest $Method $Path
                }
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'ExampleSku'
        $result.Exception | Should -Match $expected
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        $script:submissions.Count | Should -Be 1
        $script:validations.Count | Should -Be 1
        $script:records.ContainsKey($script:roots[0]) | Should -BeTrue
    }

    Context 'Captured terminal resource failures' -Tag 'CapturedResourceFailures' {
        BeforeEach {
            $script:vnetId = "$script:groupId/providers/Microsoft.Network/privateEndpoints/failed-resource"
            $script:incidentMessage = "10:00:00 - The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s). " +
            'Status Message: The resource write operation failed to complete successfully, because it reached terminal provisioning state Failed. ' +
            '(Code: ResourceDeploymentFailure) - An error occurred. (Code:InternalServerError)'
            $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId `
                -Leaf @{ code = 'InternalServerError'; message = 'An error occurred.'; details = @() }
            Mock Get-AzResourceGroupDeployment {
                if ($Name -eq 'dependencies') { $script:records[$script:nestedId].State = 'Failed' }
                Get-FixtureStatus $Name resourcegroup $ResourceGroupName '' $DefaultProfile
            }
        }

        It 'Retries a script-free <scenario> failure in the same region only after confirmed cleanup' -ForEach @(
            @{ scenario = 'Application Gateway WAF'; resourceType = 'Microsoft.Network/applicationGateways'; nested = $false }
            @{ scenario = 'PostgreSQL max'; resourceType = 'Microsoft.DBforPostgreSQL/flexibleServers'; nested = $false }
            @{ scenario = 'managed-environment private endpoint'; resourceType = 'Microsoft.Network/privateEndpoints'; nested = $true }
        ) {
            $script:vnetId = "$script:groupId/providers/$resourceType/failed-resource"
            $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId -Nested:$nested `
                -Leaf @{ code = 'InternalServerError'; message = 'An error occurred.'; details = @() }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:submissions) | Should -Be @('italynorth', 'italynorth')
            @($script:validations) | Should -Be @('italynorth')
            $result.AttemptedLocations | Should -Be @('italynorth')
            $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            $script:trace.IndexOf("DELETE:$($script:roots[0])") | Should -BeLessThan $script:trace.LastIndexOf('submit:italynorth')
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Uses one region and at most three submissions for repeated confirmed transient resource failures' {
            $script:outcomes = @('Regional', 'Regional', 'Regional')
            $result = Invoke-TemplateDeploymentWithRetry @retryInput -RegionLimit 1
            $result.Exception | Should -Match 'InternalServerError'
            $result.DeploymentAttempts | Should -Be 3
            $result.AttemptedLocations | Should -Be @('italynorth')
            @($script:submissions) | Should -Be @('italynorth', 'italynorth', 'italynorth')
            $result.RemainingDeploymentNames | Should -Be @($script:names[2])
            $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
            $script:records.ContainsKey($script:roots[1]) | Should -BeFalse
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Keeps the captured <scenario> with a <placement> deployment script ineligible for same-region replay' -ForEach @(
            @{ scenario = 'Application Gateway WAF'; resourceType = 'Microsoft.Network/applicationGateways'; scriptName = 'dep-gci-ds-nagwaf'; placement = 'root' }
            @{ scenario = 'Application Gateway WAF'; resourceType = 'Microsoft.Network/applicationGateways'; scriptName = 'dep-gci-ds-nagwaf'; placement = 'nested' }
            @{ scenario = 'managed-environment private endpoint'; resourceType = 'Microsoft.Network/privateEndpoints'; scriptName = 'dep-gci-ds-amemax'; placement = 'root' }
            @{ scenario = 'managed-environment private endpoint'; resourceType = 'Microsoft.Network/privateEndpoints'; scriptName = 'dep-gci-ds-amemax'; placement = 'nested' }
        ) {
            $script:vnetId = "$script:groupId/providers/$resourceType/failed-resource"
            $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId `
                -Leaf @{ code = 'InternalServerError'; message = 'An error occurred.' }
            $script:scriptId = "$script:groupId/providers/Microsoft.Resources/deploymentScripts/$scriptName"
            Mock New-AzSubscriptionDeployment {
                try {
                    Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
                } finally {
                    $rootId = $script:roots[-1]
                    $operation = New-FixtureOperation -Id $script:scriptId
                    if ($placement -eq 'nested') {
                        $dependencyId = "$script:groupId/providers/Microsoft.Resources/deployments/script-dependencies"
                        $script:records[$dependencyId] = @{ State = 'Succeeded'; Operations = @($operation) }
                        $operation = New-FixtureOperation -Id $dependencyId
                    }
                    $script:records[$rootId].Operations += $operation
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'InternalServerError'
            $result.Exception | Should -Match 'deployment scripts'
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $script:submissions.Count | Should -Be 1
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
        }

        It 'Shares validation and submission budgets for <kinds> with <regionLimit> regions' -ForEach @(
            @{ kinds = @('Transient', 'Regional', 'Success'); regionLimit = 3; succeeds = $true; expectedRegions = @('italynorth', 'italynorth', 'swedencentral') }
            @{ kinds = @('Regional', 'Transient', 'Success'); regionLimit = 3; succeeds = $true; expectedRegions = @('italynorth', 'swedencentral', 'swedencentral') }
            @{ kinds = @('Transient', 'Regional', 'Regional'); regionLimit = 3; succeeds = $false; expectedRegions = @('italynorth', 'italynorth', 'swedencentral') }
            @{ kinds = @('Regional', 'Transient', 'Regional'); regionLimit = 2; succeeds = $false; expectedRegions = @('italynorth', 'swedencentral', 'swedencentral') }
            @{ kinds = @('Transient', 'Regional', 'Success'); regionLimit = 1; succeeds = $false; expectedRegions = @('italynorth', 'italynorth') }
        ) {
            $script:outcomes = @($kinds | ForEach-Object { $_ -eq 'Success' ? 'Succeeded' : 'Regional' })
            Mock New-AzSubscriptionDeployment {
                if ($kinds[$script:names.Count] -eq 'Regional') {
                    $script:incidentMessage = "The deployment '{0}' failed. (Code:SkuNotAvailable)"
                    $script:regionalError = @{ error = @{ code = 'SkuNotAvailable'; message = 'Capacity is not available in this location.' } }
                } else {
                    $script:incidentMessage = "The deployment '{0}' failed. (Code:InternalServerError)"
                    $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId `
                        -Leaf @{ code = 'InternalServerError'; message = 'An error occurred.' }
                }
                Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput -RegionLimit $regionLimit
            $result.ContainsKey('Exception') | Should -Be (-not $succeeds)
            @($script:submissions) | Should -Be $expectedRegions
            $result.DeploymentAttempts | Should -Be $expectedRegions.Count
            @($script:validations) | Should -Be @($expectedRegions | Select-Object -Unique)
            $result.AttemptedLocations | Should -Be @($expectedRegions | Select-Object -Unique)
            $result.RemainingDeploymentNames | Should -Be @($script:names[-1])
            $result.DeploymentAttempts | Should -BeLessOrEqual 3
            $result.AttemptedLocations.Count | Should -BeLessOrEqual $regionLimit
        }

        It 'Does not change regional cleanup eligibility for an attempt with deployment scripts' {
            $script:regionalError = @{ error = @{ code = 'SkuNotAvailable'; message = 'Capacity is not available in this location.' } }
            Mock Get-AzResourceGroupDeployment {
                $script:records[$script:nestedId].Operations += New-FixtureOperation `
                    -Id "$script:groupId/providers/Microsoft.Resources/deploymentScripts/dependency"
                Get-FixtureStatus $Name resourcegroup $ResourceGroupName '' $DefaultProfile
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:submissions) | Should -Be @('italynorth', 'swedencentral')
        }

        It 'Rejects the script exclusion flag without complete discovery' {
            { Remove-Deployment -RequireNoDeploymentScripts } | Should -Throw '*requires complete*discovery*'
            Should -Invoke Get-AzContext -Times 0 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Keeps transient retries blocked by <restriction>' -ForEach @(
            @{ restriction = 'a custom pin' }, @{ restriction = 'a token pin' }
            @{ restriction = 'a CI parameter pin' }, @{ restriction = 'a global selection' }
            @{ restriction = 'resource-group scope' }, @{ restriction = 'retained resources' }
        ) {
            switch ($restriction) {
                'a custom pin' { $retryInput.CustomLocation = 'italynorth' }
                'a token pin' { $retryInput.TokenResourceLocation = 'italynorth' }
                'a CI parameter pin' { $templateInput.AdditionalParameters.resourceLocation = 'italynorth' }
                'a global selection' { Mock Get-AvailableResourceLocation { @{ Location = 'italynorth'; IsGlobal = $true } } }
                'resource-group scope' {
                    $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                    $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
                }
                'retained resources' { $retryInput.RemoveDeployment = $false }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'InternalServerError'
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
        }

        It 'Does not treat <kind> as a confirmed transient resource failure' -ForEach @(
            @{ kind = 'a bare InternalServerError' }, @{ kind = 'a missing resource target' }
            @{ kind = 'an array target' }, @{ kind = 'another subscription' }, @{ kind = 'a deployment target' }
            @{ kind = 'a mixed quota failure' }, @{ kind = 'a mixed regional failure' }
            @{ kind = 'an unknown leaf' }, @{ kind = 'an empty failure list' }, @{ kind = 'additional error information' }
            @{ kind = 'an unsupported resource type' }, @{ kind = 'an extension under an unsupported resource' }
            @{ kind = 'a mixed authorization failure' }, @{ kind = 'a contradictory resource state' }
        ) {
            $node = $script:regionalError.error.details[0]
            switch ($kind) {
                'a bare InternalServerError' { $script:regionalError = @{ error = @{ code = 'InternalServerError'; message = 'An error occurred.' } } }
                'a missing resource target' { $node.Remove('target') }
                'an array target' { $node.target = @($node.target) }
                'another subscription' { $node.target = $node.target.Replace($script:subscriptionId, '22222222-2222-2222-2222-222222222222') }
                'a deployment target' { $node.target = $script:nestedId }
                'a mixed quota failure' { $node.details += @{ code = 'QuotaExceeded'; message = 'Quota exceeded.' } }
                'a mixed regional failure' { $node.details += @{ code = 'SkuNotAvailable'; message = 'Capacity is not available in this location.' } }
                'an unknown leaf' { $node.details[0].code = 'UnknownError' }
                'an empty failure list' { $node.details = @() }
                'additional error information' { $node.details[0].additionalInfo = @(@{ type = 'PermissionFailure' }) }
                'an unsupported resource type' { $node.target = "$script:groupId/providers/Microsoft.Network/virtualNetworks/unproven" }
                'an extension under an unsupported resource' {
                    $node.target = "$script:groupId/providers/Microsoft.Network/virtualNetworks/parent/providers/Microsoft.Network/privateEndpoints/child"
                }
                'a mixed authorization failure' { $node.details += @{ code = 'AuthorizationFailed'; message = 'Access denied.' } }
                'a contradictory resource state' { $node.status = 'Succeeded' }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'InternalServerError'
            $script:submissions.Count | Should -Be 1
            $script:removed.Count | Should -Be 0
            $result.RemainingDeploymentNames | Should -Be @($script:names)
        }

        It 'Does not replay a generic server error with <state> root state' -ForEach @(
            @{ state = 'Running' }, @{ state = 'Accepted' }, @{ state = 'Succeeded' }, @{ state = 'Canceled' }, @{ state = $null }
            @{ state = @('Failed') }
        ) {
            Mock Get-AzDeployment { @{ DeploymentName = $Name; ProvisioningState = $state } }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'InternalServerError'
            $script:submissions.Count | Should -Be 1
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Does not inspect operations or replay with <kind> root identity' -ForEach @(
            @{ kind = 'a different' }, @{ kind = 'a missing' }, @{ kind = 'an ambiguous' }
        ) {
            Mock Get-AzDeployment {
                switch ($kind) {
                    'a different' { @{ DeploymentName = 'another-root'; ProvisioningState = 'Failed' } }
                    'a missing' { @{ ProvisioningState = 'Failed' } }
                    'an ambiguous' {
                        @{ DeploymentName = $Name; ProvisioningState = 'Failed' }
                        @{ DeploymentName = $Name; ProvisioningState = 'Failed' }
                    }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'InternalServerError'
            $script:submissions.Count | Should -Be 1
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Never promotes a validation-stage HTTP 500 to transient or regional deployment recovery' {
            Mock Test-AzSubscriptionDeployment {
                $exception = [System.InvalidOperationException]::new('Validation server error.')
                $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 500 }
                $record = [System.Management.Automation.ErrorRecord]::new(
                    $exception, 'ServerError', [System.Management.Automation.ErrorCategory]::InvalidResult, $null
                )
                $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new(
                    (ConvertTo-Json -InputObject $script:regionalError -Depth 20)
                )
                throw $record
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput -ValidationOnly
            $result.Exception | Should -Not -BeNullOrEmpty
            $result.AttemptedLocations | Should -Be @('italynorth')
            Should -Invoke Test-AzSubscriptionDeployment -Times 1 -Exactly
            Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
            Should -Invoke Get-AzDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Does not lose the original server error or retry when cleanup fails' {
            Mock Remove-AzResource { throw 'Cleanup failed.' }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'InternalServerError'
            $result.Exception | Should -Match 'removal failed'
            $result.ErrorRecord.TargetObject.Exception.Message | Should -Match 'InternalServerError'
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            $script:submissions.Count | Should -Be 1
        }

        It 'Does not use structured retry evidence to override <kind> exceptions' -ForEach @(
            @{ kind = 'authorization'; type = [System.UnauthorizedAccessException] }
            @{ kind = 'timeout'; type = [System.TimeoutException] }
            @{ kind = 'transport'; type = [System.Net.Http.HttpRequestException] }
            @{ kind = 'cancellation'; type = [System.OperationCanceledException] }
            @{ kind = 'secondary aggregate authorization'; type = [System.UnauthorizedAccessException] }
        ) {
            $exception = $type::new('Uncertain or forbidden.')
            if ($kind -eq 'secondary aggregate authorization') {
                $exception = [System.AggregateException]::new([System.Exception[]] @(
                        [System.InvalidOperationException]::new('An error occurred.'), $exception
                    ))
            }
            $record = [System.Management.Automation.ErrorRecord]::new(
                $exception, 'FailedRequest', [System.Management.Automation.ErrorCategory]::InvalidResult, $null
            )
            Test-DeploymentRetryError -ErrorRecord $record -ErrorResponse $script:regionalError `
                -SubscriptionId $script:subscriptionId -RetryKind Transient | Should -BeFalse
        }

        It 'Uses an HTTP 500 only with a subsequently confirmed failed root and structured resource failure' {
            Mock New-AzSubscriptionDeployment {
                try {
                    Invoke-FixtureSubmission $DeploymentName $TemplateFile $resourceLocation $baseTime $adminSecret
                } catch {
                    $exception = [System.InvalidOperationException]::new($_.Exception.Message)
                    $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 500 }
                    throw [System.Management.Automation.ErrorRecord]::new(
                        $exception, 'ServerError', [System.Management.Automation.ErrorCategory]::InvalidResult, $DeploymentName
                    )
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.ContainsKey('Exception') | Should -BeFalse
            @($script:submissions) | Should -Be @('italynorth', 'italynorth')
            $script:trace.IndexOf("state:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf("remove:$script:groupId")
        }

        Context 'Container Instances capacity without a leaf code' {
            BeforeEach {
                $script:regions = @('koreacentral', 'swedencentral', 'eastus')
                $script:vnetId = "$script:groupId/providers/Microsoft.ContainerInstance/containerGroups/capacity"
                $script:capacityMessage = "The requested resource is not available in the location 'koreacentral' at this moment. " +
                "Please retry with a different resource request or in another location. Resource requested: '4' CPU '4' GB memory 'Linux' OS"
                $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId -Leaf @{ message = $script:capacityMessage }
                $script:incidentMessage = "10:00:00 - The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s). " +
                "Status Message: The resource write operation failed to complete successfully. (Code: ResourceDeploymentFailure) - $script:capacityMessage (Code:)"
            }

            It 'Relocates the captured <scenario> capacity shape only after complete removal' -ForEach @(
                @{ scenario = 'max'; name = 'capacity-max-1' }
                @{ scenario = 'WAF'; name = 'capacity-waf' }
            ) {
                $script:vnetId = "$script:groupId/providers/Microsoft.ContainerInstance/containerGroups/$name"
                $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId -Leaf @{ message = $script:capacityMessage }
                $result = Invoke-TemplateDeploymentWithRetry @retryInput
                $result.ContainsKey('Exception') | Should -BeFalse
                @($script:submissions) | Should -Be @('koreacentral', 'swedencentral')
                $result.RemainingDeploymentNames | Should -Be @($script:names[1])
                $script:trace.IndexOf("DELETE:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
            }

            It 'Does not authorize relocation from <kind>' -ForEach @(
                @{ kind = 'a missing provider target' }, @{ kind = 'a different provider' }, @{ kind = 'another subscription' }
                @{ kind = 'an array target' }, @{ kind = 'a different location' }, @{ kind = 'a generic message' }
                @{ kind = 'an extra message suffix' }, @{ kind = 'an explicit empty code' }, @{ kind = 'an explicit null code' }
                @{ kind = 'an unknown code' }, @{ kind = 'another error property' }, @{ kind = 'a mixed quota failure' }
                @{ kind = 'a bare message-only node' }, @{ kind = 'CPU above the standard request size' }
                @{ kind = 'memory above the standard request size' }, @{ kind = 'zero CPU' }
                @{ kind = 'a disguised property count' }, @{ kind = 'an innererror instead of details' }
                @{ kind = 'contradictory successful status' }
            ) {
                $node = $script:regionalError.error.details[0]
                switch ($kind) {
                    'a missing provider target' { $node.Remove('target') }
                    'a different provider' { $node.target = "$script:groupId/providers/Microsoft.Network/virtualNetworks/capacity" }
                    'another subscription' { $node.target = $node.target.Replace($script:subscriptionId, '22222222-2222-2222-2222-222222222222') }
                    'an array target' { $node.target = @($node.target) }
                    'a different location' { $node.details[0].message = $script:capacityMessage.Replace('koreacentral', 'westus') }
                    'a generic message' { $node.details[0].message = 'Not available in the location. Retry elsewhere.' }
                    'an extra message suffix' { $node.details[0].message += ' Also failed because quota was exceeded.' }
                    'an explicit empty code' { $node.details[0].code = '' }
                    'an explicit null code' { $node.details[0].code = $null }
                    'an unknown code' { $node.details[0].code = 'UnknownError' }
                    'another error property' { $node.details[0].innererror = @{ code = 'QuotaExceeded' } }
                    'a mixed quota failure' { $node.details += @{ code = 'QuotaExceeded'; message = 'Regional quota exceeded.' } }
                    'a bare message-only node' { $script:regionalError = @{ message = $script:capacityMessage } }
                    'CPU above the standard request size' { $node.details[0].message = $script:capacityMessage.Replace("'4' CPU", "'8' CPU") }
                    'memory above the standard request size' { $node.details[0].message = $script:capacityMessage.Replace("'4' GB", "'32' GB") }
                    'zero CPU' { $node.details[0].message = $script:capacityMessage.Replace("'4' CPU", "'0' CPU") }
                    'a disguised property count' { $node.details[0].Count = 1 }
                    'an innererror instead of details' { $node.innererror = $node.details[0]; $node.Remove('details') }
                    'contradictory successful status' { $script:regionalError.status = 'Succeeded' }
                }
                $result = Invoke-TemplateDeploymentWithRetry @retryInput
                $result.Exception | Should -Not -BeNullOrEmpty
                $script:submissions.Count | Should -Be 1
                $script:removed.Count | Should -Be 0
                $result.RemainingDeploymentNames | Should -Be @($script:names)
            }
        }
    }

    Context 'Asynchronous deployment history removal' -Tag 'HistoryRemoval' {
        BeforeEach {
            $script:historyReads = 0
            $script:historyDeletes = 0
            $script:historyReadyAfter = 1
            $script:historyState = 'Failed'
            $script:historyLookupError = $null
            Mock Invoke-AzRestMethod {
                $id = $Path.Split('?')[0]
                if ($id -eq $script:roots[0] -and $Method -eq 'DELETE') {
                    $script:trace.Add("DELETE:$id")
                    $script:historyDeletes++
                    return New-FixtureResponse -StatusCode 202
                }
                if ($id -eq $script:roots[0] -and $Method -eq 'GET') {
                    $script:trace.Add("GET:$id")
                    $script:historyReads++
                    if ($script:historyLookupError) { throw $script:historyLookupError }
                    if ($script:historyReads -le $script:historyReadyAfter) {
                        return New-FixtureResponse -Content @{ id = $id; properties = @{ provisioningState = $script:historyState } }
                    }
                    $script:records.Remove($id)
                    return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
                }
                Invoke-FixtureRest $Method $Path
            }
        }

        It 'Confirms delayed history deletion before relocating the <scenario> cleanup with <resourceCount> targets' -ForEach @(
            @{ scenario = 'Windows VMSS defaults'; resourceCount = 3 }
            @{ scenario = 'Windows VMSS max'; resourceCount = 18 }
            @{ scenario = 'Linux VMSS max'; resourceCount = 20 }
        ) {
            $script:regionalError = @{ error = @{
                    code    = 'DeploymentFailed'
                    details = @(@{
                            code    = 'ResourceDeploymentFailure'
                            details = @(@{ code = 'SkuNotAvailable'; message = "Standard_D4ads_v5 is not available in location 'eastus'." })
                        })
                }
            }
            Mock Get-AzResourceGroupDeployment {
                if ($Name -eq 'dependencies') {
                    $script:records[$script:nestedId].Operations = @(
                        New-FixtureOperation -Id $script:vnetId
                        for ($index = 2; $index -lt $resourceCount; $index++) {
                            New-FixtureOperation -Id "$script:groupId/providers/Microsoft.Network/virtualNetworks/dependency-$index"
                        }
                    )
                }
                Get-FixtureStatus $Name resourcegroup $ResourceGroupName '' $DefaultProfile
            }

            $log = @(Invoke-TemplateDeploymentWithRetry @retryInput 4>&1)
            $result = $log | Where-Object { $_ -is [hashtable] }
            $log | Out-String | Should -Match "Total number of deployment target resources after fetching deployments \[$resourceCount\]"
            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentAttempts | Should -Be 2
            $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            $result.PendingDeletionDeploymentIds | Should -BeNullOrEmpty
            $script:historyReads | Should -Be 2
            $script:historyDeletes | Should -Be 1
            @($script:trace | Where-Object { $_ -like 'remove:*' }) | Should -Be @("remove:$script:groupId")
            $script:trace.LastIndexOf("GET:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
            $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$($script:roots[0])")
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Waits through Deleting before authorizing regional relocation' {
            $script:historyState = 'Deleting'

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentAttempts | Should -Be 2
            $result.PendingDeletionDeploymentIds | Should -BeNullOrEmpty
            $script:historyReads | Should -Be 2
            $script:historyDeletes | Should -Be 1
            $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$($script:roots[0])")
            $script:trace.LastIndexOf("GET:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Keeps ownership when history remains and confirms it in final cleanup without rediscovering deleted resources' {
            $script:historyReadyAfter = 3

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'still exists after cleanup'
            $result.Exception | Should -Match 'ExampleSku'
            $result.ErrorRecord.TargetObject.Exception.Message | Should -Match 'ExampleSku'
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PendingDeletionDeploymentIds | Should -Be @($script:roots[0])
            $script:historyReads | Should -Be 3
            $script:historyDeletes | Should -Be 1
            $script:alive.Count | Should -Be 0
            $script:submissions.Count | Should -Be 1
            $script:validations.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
            $beforeFinalCleanup = $script:trace.Count

            Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                -DeploymentNames $result.RemainingDeploymentNames -PendingDeletionDeploymentIds $result.PendingDeletionDeploymentIds

            $script:historyReads | Should -Be 4
            $script:historyDeletes | Should -Be 1
            $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
            @($script:trace | Select-Object -Skip $beforeFinalCleanup) | Should -Be @("GET:$($script:roots[0])")
            Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
        }

        It 'Still fails final cleanup if an accepted deletion remains visible after the bounded confirmation window' {
            $script:historyReadyAfter = 100
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.PendingDeletionDeploymentIds | Should -Be @($script:roots[0])
            {
                Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                    -DeploymentNames $result.RemainingDeploymentNames -PendingDeletionDeploymentIds $result.PendingDeletionDeploymentIds
            } | Should -Throw '*still exists after cleanup*'
            $script:historyReads | Should -Be 6
            $script:historyDeletes | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke Start-Sleep -Times 4 -Exactly -ParameterFilter { $Seconds -eq 15 }
            Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
        }

        It 'Does not retry a history confirmation <kind> or discard the original deployment error' -ForEach @(
            @{ kind = 'authorization failure'; exceptionType = [System.UnauthorizedAccessException] }
            @{ kind = 'timeout'; exceptionType = [System.TimeoutException] }
            @{ kind = 'transport failure'; exceptionType = [System.Net.Http.HttpRequestException] }
            @{ kind = 'cancellation'; exceptionType = [System.OperationCanceledException] }
        ) {
            $script:historyLookupError = $exceptionType::new('History confirmation failed.')
            if ($kind -eq 'cancellation') {
                { Invoke-TemplateDeploymentWithRetry @retryInput } | Should -Throw '*History confirmation failed*'
            } else {
                $result = Invoke-TemplateDeploymentWithRetry @retryInput
                $result.Exception | Should -Match 'History confirmation failed'
                $result.Exception | Should -Match 'ExampleSku'
                $result.RemainingDeploymentNames | Should -Be @($script:names)
                $result.PendingDeletionDeploymentIds | Should -Be @($script:roots[0])
            }
            $script:historyReads | Should -Be 1
            $script:historyDeletes | Should -Be 1
            $script:submissions.Count | Should -Be 1
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Does not publish record-only cleanup evidence after <failure>' -ForEach @(
            @{ failure = 'resource removal failure' }, @{ failure = 'unconfirmed resource absence' }
            @{ failure = 'rejected history deletion' }, @{ failure = 'uncertain history deletion' }
        ) {
            switch ($failure) {
                'resource removal failure' { Mock Remove-AzResource { throw 'Removal failed.' } }
                'unconfirmed resource absence' { Mock Remove-AzResource {} }
                'rejected history deletion' {
                    Mock Invoke-AzRestMethod { New-FixtureResponse -StatusCode 403 } -ParameterFilter { $Method -eq 'DELETE' }
                }
                'uncertain history deletion' {
                    Mock Invoke-AzRestMethod { throw [System.TimeoutException]::new('Deletion response unknown.') } -ParameterFilter { $Method -eq 'DELETE' }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'ExampleSku'
            $result.PendingDeletionDeploymentIds | Should -BeNullOrEmpty
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $script:submissions.Count | Should -Be 1
        }
    }

    It 'Rejects <state> visible history after an accepted deletion without polling an uncertain record' -Tag 'HistoryRemoval' -ForEach @(
        @{ state = 'Running' }, @{ state = 'Accepted' }, @{ state = 'Canceled' }, @{ state = $null }, @{ state = @('Failed') }
    ) {
        $id = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/owned"
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 202 }
            New-FixtureResponse -Content @{ id = $id; properties = @{ provisioningState = $state } }
        }
        { Complete-DeploymentRemoval -DeploymentIds $id -DeploymentNamesById @{ $id = 'owned' } } | Should -Throw '*Cannot confirm removal*'
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' }
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Reconciles only the accepted root history deletion at <scope> scope' -Tag 'HistoryRemoval' -ForEach @(
        @{ scope = 'subscription'; schema = 'subscriptionDeploymentTemplate' }
        @{ scope = 'resourcegroup'; schema = 'deploymentTemplate' }
        @{ scope = 'managementgroup'; schema = 'managementGroupDeploymentTemplate' }
        @{ scope = 'tenant'; schema = 'tenantDeploymentTemplate' }
    ) {
        $template.'$schema' = "https://schema.management.azure.com/schemas/2019-08-01/$schema.json#"
        $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
        $id = Get-DeploymentResourceId -Scope $scope -Name 'pending' -SubscriptionId $script:subscriptionId `
            -ResourceGroupName 'retry-fixture' -ManagementGroupId 'test-management-group'
        $script:roots.Add($id)
        Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
            -ResourceGroupName 'retry-fixture' -ManagementGroupId 'test-management-group' `
            -DeploymentNames pending -PendingDeletionDeploymentIds $id.ToUpperInvariant() -PreflightRejectedDeploymentNames pending
        @($script:trace) | Should -Be @("GET:$($id.ToUpperInvariant())")
        Should -Invoke Remove-AzResource -Times 0 -Exactly
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Cleans other owned resources before reporting an unconfirmed pending root deletion' -Tag 'HistoryRemoval' {
        $pendingId = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/pending"
        $ordinaryId = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/ordinary"
        $script:roots.Add($pendingId)
        $script:roots.Add($ordinaryId)
        $script:records[$pendingId] = @{ State = 'Failed'; Operations = @() }
        $script:records[$ordinaryId] = @{ State = 'Failed'; Operations = @((New-FixtureOperation -Id $script:groupId)) }
        $null = $script:alive.Add($script:groupId)

        {
            Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                -DeploymentNames pending, ordinary -PendingDeletionDeploymentIds $pendingId
        } | Should -Throw '*still exists after cleanup*'

        $script:alive.Count | Should -Be 0
        $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("GET:$pendingId")
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Path -like "$pendingId/operations*" -or $Method -eq 'DELETE' }
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
    }

    It 'Rejects pending history metadata with <kind>' -Tag 'HistoryRemoval' -ForEach @(
        @{ kind = 'strict relocation cleanup'; names = @('owned'); strict = $true }
        @{ kind = 'no submitted names'; names = @(); strict = $false }
        @{ kind = 'duplicate submitted names'; names = @('owned', 'owned'); strict = $false }
    ) {
        $id = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/owned"
        {
            Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                -DeploymentNames $names -PendingDeletionDeploymentIds $id -RequireCompleteRemoval:$strict
        } | Should -Throw '*pending*deletion*metadata*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke Remove-AzResource -Times 0 -Exactly
    }

    It 'Rejects record-only cleanup metadata for <kind> before any discovery or deletion' -Tag 'HistoryRemoval' -ForEach @(
        @{ kind = 'another root'; ids = @('/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/other') }
        @{ kind = 'another subscription'; ids = @('/subscriptions/22222222-2222-2222-2222-222222222222/providers/Microsoft.Resources/deployments/owned') }
        @{ kind = 'a nested deployment'; ids = @('/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/retry-fixture/providers/Microsoft.Resources/deployments/owned') }
        @{ kind = 'duplicate IDs'; ids = @('/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/owned', '/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/owned') }
    ) {
        {
            Initialize-DeploymentRemoval -TemplateFilePath $templatePath -SubscriptionId $script:subscriptionId `
                -DeploymentNames owned -PendingDeletionDeploymentIds $ids
        } | Should -Throw '*pending*deletion*metadata*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        Should -Invoke Remove-AzResource -Times 0 -Exactly
    }

    It 'Rejects a <kind> history absence response instead of completing relocation' -Tag 'HistoryRemoval' -ForEach @(
        @{ kind = 'generic 404'; status = 404; content = @{ error = @{ code = 'NotFound' } } }
        @{ kind = 'wrong-scope 404'; status = 404; content = @{ error = @{ code = 'ResourceGroupNotFound' } } }
        @{ kind = 'authorization failure'; status = 403; content = @{ error = @{ code = 'DeploymentNotFound' } } }
        @{ kind = 'different record'; status = 200; content = @{ id = '/providers/Microsoft.Resources/deployments/other' } }
        @{ kind = 'array body'; status = 404; content = @(@{ error = @{ code = 'DeploymentNotFound' } }) }
        @{ kind = 'array error'; status = 404; content = @{ error = @(@{ code = 'DeploymentNotFound' }) } }
        @{ kind = 'array code'; status = 404; content = @{ error = @{ code = @('DeploymentNotFound') } } }
        @{ kind = 'wrong error target'; status = 404; content = @{ error = @{ code = 'DeploymentNotFound'; target = '/providers/Microsoft.Resources/deployments/other' } } }
        @{ kind = 'array error target'; status = 404; content = @{ error = @{ code = 'DeploymentNotFound'; target = @('/providers/Microsoft.Resources/deployments/other') } } }
        @{ kind = 'array present identity'; status = 200; content = @{ id = @('/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/owned'); properties = @{ provisioningState = 'Failed' } } }
        @{ kind = 'array present record'; status = 200; content = @(@{ id = '/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/owned'; properties = @{ provisioningState = 'Failed' } }) }
    ) {
        $id = "/subscriptions/$script:subscriptionId/providers/Microsoft.Resources/deployments/owned"
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'DELETE') { return New-FixtureResponse -StatusCode 202 }
            New-FixtureResponse -StatusCode $status -Content $content
        }
        { Complete-DeploymentRemoval -DeploymentIds $id -DeploymentNamesById @{ $id = 'owned' } } | Should -Throw '*Cannot confirm removal*'
        Should -Invoke Start-Sleep -Times 0 -Exactly
    }

    It 'Propagates cancellation during <phase> without another submission' -ForEach @(
        @{ phase = 'submission' }, @{ phase = 'status' }, @{ phase = 'details' }, @{ phase = 'discovery' }
        @{ phase = 'removal' }, @{ phase = 'record deletion' }, @{ phase = 'absence confirmation' }
    ) {
        switch ($phase) {
            'submission' { $script:outcomes = @('Cancel') }
            'status' { Mock Get-AzDeployment { throw [System.OperationCanceledException]::new('Cancelled.') } }
            'details' { Mock Invoke-AzRestMethod { throw [System.OperationCanceledException]::new('Cancelled.') } }
            'discovery' {
                Mock Invoke-AzRestMethod {
                    if ($Path.Split('?')[0] -eq "$script:nestedId/operations") { throw [System.OperationCanceledException]::new('Cancelled.') }
                    Invoke-FixtureRest $Method $Path
                }
            }
            'removal' { Mock Remove-AzResource { throw [System.OperationCanceledException]::new('Cancelled.') } }
            'record deletion' {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'DELETE') { throw [System.OperationCanceledException]::new('Cancelled.') }
                    Invoke-FixtureRest $Method $Path
                }
            }
            'absence confirmation' {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'GET' -and $Path.Split('?')[0] -eq $script:groupId) {
                        throw [System.OperationCanceledException]::new('Cancelled.')
                    }
                    Invoke-FixtureRest $Method $Path
                }
            }
        }
        { Invoke-TemplateDeploymentWithRetry @retryInput } | Should -Throw '*cancel*'
        $script:submissions.Count | Should -Be 1
        Should -Invoke Start-Sleep -Times 0 -Exactly
        [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($originalBytes))
    }

    Context 'Container Instance cleanup read recovery' -Tag 'DeploymentReadRecovery' {
        BeforeEach {
            $script:regions = @('norwayeast', 'swedencentral', 'eastus')
            $script:vnetId = "$script:groupId/providers/Microsoft.ContainerInstance/containerGroups/capacity-waf"
            $script:capacityMessage = "The requested resource is not available in the location 'norwayeast' at this moment. " +
            "Please retry with a different resource request or in another location. Resource requested: '4' CPU '4' GB memory 'Linux' OS"
            $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId -Leaf @{ message = $script:capacityMessage }
            $script:incidentMessage = "The deployment '{0}' failed with error(s). (Code: DeploymentFailed) $script:capacityMessage"
            $script:cleanupReads = 0
            $script:timeoutLimit = 2
            $script:readFailure = [System.Threading.Tasks.TaskCanceledException]::new(
                'The request was canceled due to the configured HttpClient.Timeout of 100 seconds elapsing.',
                [System.TimeoutException]::new('The operation was canceled.', [System.Threading.Tasks.TaskCanceledException]::new())
            )
        }

        It 'Retries only the failed <read> before authorizing complete cleanup and relocation' -ForEach @(
            @{ read = 'nested operations' }, @{ read = 'nested status' }
        ) {
            if ($read -eq 'nested operations') {
                Mock Invoke-AzRestMethod {
                    if ($Method -eq 'GET' -and $Path -eq "$script:nestedId/operations?api-version=2025-04-01" -and
                        ++$script:cleanupReads -le $script:timeoutLimit) {
                        throw $script:readFailure
                    }
                    Invoke-FixtureRest $Method $Path
                }
            } else {
                Mock Get-AzResourceGroupDeployment {
                    if (++$script:cleanupReads -le $script:timeoutLimit) { throw $script:readFailure }
                    Get-FixtureStatus -Name $Name -Scope resourcegroup -ResourceGroupName $ResourceGroupName -DefaultProfile $DefaultProfile
                }
            }

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentAttempts | Should -Be 2
            $script:cleanupReads | Should -Be 3
            @($script:submissions) | Should -Be @('norwayeast', 'swedencentral')
            $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$($script:roots[0])")
            $script:trace.IndexOf("DELETE:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
            Should -Invoke New-AzSubscriptionDeployment -Times 2 -Exactly
            Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
        }

        It 'Keeps cleanup incomplete after exhausted operation reads without removal or resubmission' {
            Mock Invoke-AzRestMethod {
                if ($Method -eq 'GET' -and $Path -eq "$script:nestedId/operations?api-version=2025-04-01") {
                    $script:cleanupReads++
                    throw $script:readFailure
                }
                Invoke-FixtureRest $Method $Path
            }

            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'Complete cleanup discovery failed'
            $result.Exception | Should -Match 'HttpClient.Timeout'
            $script:cleanupReads | Should -Be 3
            $result.DeploymentAttempts | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
        }
    }

    It 'Keeps Container App terminal ResourceNotFound distinct from a nested deployment polling 404' -Tag 'DeploymentReadRecovery' {
        $script:regions = @('centralus', 'koreacentral', 'eastus')
        $script:outcomes = @('Regional', 'Regional')
        $script:regionalError = @{ error = @{ code = 'SkuNotAvailable'; message = 'Capacity is not available in this location.' } }
        Mock Wait-TemplateDeployment { throw 'Provider ResourceNotFound must not enter submission-status recovery.' }
        Mock New-AzSubscriptionDeployment {
            if ($script:names.Count -eq 1) {
                $message = "The Resource 'Microsoft.App/containerApps/gciacafunc001' under resource group 'dep-gci-app.containerApps-acafunc-rg' was not found. " +
                'For more details please go to https://aka.ms/ARMResourceNotFoundFix'
                $script:incidentMessage = "14:05:34 - The deployment '{0}' failed with error(s). Showing 1 out of 1 error(s).`n" +
                'Status Message: At least one resource deployment operation failed. Please list deployment operations for details. ' +
                "Please see https://aka.ms/arm-deployment-operations for usage details. (Code: DeploymentFailed)`n - $message (Code:ResourceNotFound)"
                $script:regionalError = @{ error = @{
                        code = 'DeploymentFailed'
                        details = @(@{ code = 'ResourceNotFound'; message = $message })
                    } }
            }
            try {
                Invoke-FixtureSubmission -Name $DeploymentName -Path $TemplateFile -Region $resourceLocation -BaseTime $baseTime -Secret $adminSecret
            } finally {
                if ($script:names.Count -eq 2) {
                    $script:records[$script:roots[-1]].Operations +=
                    New-FixtureOperation -Id "${script:nestedId}-test-acafunc-init" -State Succeeded
                }
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match 'ResourceNotFound'
        $result.Exception | Should -Match 'Microsoft.App/containerApps/gciacafunc001'
        $result.DeploymentOutput | Should -BeNullOrEmpty
        $result.DeploymentAttempts | Should -Be 2
        @($script:submissions) | Should -Be @('centralus', 'koreacentral')
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
        $script:records[$script:roots[1]].State | Should -BeExactly 'Failed'
        $script:trace.IndexOf("DELETE:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('submit:koreacentral')
        Should -Invoke Wait-TemplateDeployment -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 2 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter {
            $Method -eq 'DELETE' -and $Path.StartsWith($script:roots[1])
        }
    }

    It 'Does not inspect or replay <outcome> uncertainty' -ForEach @(
        @{ outcome = 'Transport' }, @{ outcome = 'NoResult' }, @{ outcome = 'Running' }
    ) {
        $script:outcomes = @($outcome)
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Not -BeNullOrEmpty
        $script:submissions.Count | Should -Be 1
        Should -Invoke Get-AzDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Uses recovered Failed evidence after a typed timeout without resubmitting the original deployment' {
        $script:outcomes = @('Timeout', 'Succeeded')
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        @($script:submissions) | Should -Be @('italynorth', 'swedencentral')
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
        Should -Invoke Get-AzDeployment -Times 3 -Exactly -ParameterFilter { $Name -eq $script:names[0] }
    }

    Context 'Nested deployment read reconciliation within shared budgets' -Tag 'DeploymentReadRecovery' {
        BeforeEach {
            $script:outcomes = @('NestedReadNotFound', 'Succeeded')
            $script:readRecoveryStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Running', 'Failed'))
            Mock Get-AzDeployment {
                if ($script:readRecoveryStates.Count -gt 0) {
                    $script:records[$script:roots[-1]].State = $script:readRecoveryStates.Dequeue()
                }
                $state = Get-FixtureStatus -Name $Name -Scope subscription -DefaultProfile $DefaultProfile
                $script:trace.Add("observed:$($state.ProvisioningState)")
                $state
            }
        }

        It 'Recovers only original outputs with <kind> limits' -ForEach @(
            @{ kind = 'single-attempt'; limit = 1; remove = $true; pin = '' }
            @{ kind = 'normal'; limit = 3; remove = $true; pin = '' }
            @{ kind = 'retained-resources'; limit = 3; remove = $false; pin = '' }
            @{ kind = 'pinned-region'; limit = 3; remove = $true; pin = 'italynorth' }
            @{ kind = 'global'; limit = 3; remove = $true; pin = '' }
        ) {
            $script:readRecoveryStates = [System.Collections.Generic.Queue[string]]::new([string[]] @('Running', 'Succeeded'))
            if ($kind -eq 'global') {
                Mock Get-AvailableResourceLocation { @{ Location = 'italynorth'; IsGlobal = $true } }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput -DeploymentLimit $limit -RegionLimit $limit `
                -RemoveDeployment $remove -CustomLocation $pin

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentOutput.region.value | Should -BeExactly 'italynorth'
            $result.DeploymentAttempts | Should -Be 1
            $result.AttemptedLocations | Should -Be @('italynorth')
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }

        It 'Relocates only after the original Running root becomes Failed and all resources and history are removed' {
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentAttempts | Should -Be 2
            @($script:submissions) | Should -Be @('italynorth', 'swedencentral')
            $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            $script:trace.IndexOf('observed:Running') | Should -BeLessThan $script:trace.IndexOf('observed:Failed')
            $script:trace.IndexOf('observed:Failed') | Should -BeLessThan $script:trace.IndexOf("remove:$script:groupId")
            $script:trace.IndexOf("remove:$script:groupId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$($script:roots[0])")
            $script:trace.IndexOf("DELETE:$($script:roots[0])") | Should -BeLessThan $script:trace.IndexOf('validate:swedencentral')
            Should -Invoke New-AzSubscriptionDeployment -Times 2 -Exactly
        }

        It 'Never resubmits when root observation is <state>' -ForEach @(
            @{ state = 'Running' }, @{ state = 'Unknown' }
        ) {
            $script:readRecoveryStates = [System.Collections.Generic.Queue[string]]::new([string[]] @($state))
            Mock Start-Sleep { $script:clock = $script:clock.AddHours(1) }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'read recovery'
            $result.DeploymentAttempts | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Keeps failed recovery inside the three-submission budget' {
            $script:outcomes = @('NestedReadNotFound', 'NestedReadNotFound', 'NestedReadNotFound')
            $script:regionalError = @{ error = @{ code = 'SkuNotAvailable'; message = 'Capacity is not available in this location.' } }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'confirmed Failed'
            $result.DeploymentAttempts | Should -Be 3
            $result.AttemptedLocations | Should -Be @('italynorth', 'swedencentral', 'eastus')
            @($script:submissions) | Should -Be @('italynorth', 'swedencentral', 'eastus')
            $result.RemainingDeploymentNames | Should -Be @($script:names[2])
            $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
            $script:records.ContainsKey($script:roots[1]) | Should -BeFalse
            Should -Invoke New-AzSubscriptionDeployment -Times 3 -Exactly
        }

        It 'Does not replay after <kind> prevents complete cleanup or classification' -ForEach @(
            @{ kind = 'exhausted nested status reads' }, @{ kind = 'history deletion permission failure' }
            @{ kind = 'mixed authorization evidence' }
        ) {
            switch ($kind) {
                'exhausted nested status reads' {
                    Mock Get-AzResourceGroupDeployment { throw [System.TimeoutException]::new('Nested status deadline elapsed.') }
                }
                'history deletion permission failure' {
                    Mock Invoke-AzRestMethod {
                        if ($Method -eq 'DELETE') { throw [System.UnauthorizedAccessException]::new('History deletion is forbidden.') }
                        Invoke-FixtureRest $Method $Path
                    }
                }
                'mixed authorization evidence' {
                    $script:regionalError.error.details += @{ code = 'AuthorizationFailed'; message = 'Permission denied.' }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'confirmed Failed'
            $result.DeploymentAttempts | Should -Be 1
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly
            if ($kind -ne 'history deletion permission failure') {
                Should -Invoke Remove-AzResource -Times 0 -Exactly
                Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            } else {
                Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            }
        }

        It 'Retains same-region retry safety with deployment scripts <presence>' -ForEach @(
            @{ presence = 'absent' }, @{ presence = 'present' }
        ) {
            $script:vnetId = "$script:groupId/providers/Microsoft.Network/privateEndpoints/failed-resource"
            $script:regionalError = New-FixtureResourceFailure -ResourceId $script:vnetId `
                -Leaf @{ code = 'InternalServerError'; message = 'An error occurred.'; details = @() }
            if ($presence -eq 'present') {
                Mock New-AzSubscriptionDeployment {
                    try {
                        Invoke-FixtureSubmission -Name $DeploymentName -Path $TemplateFile -Region $resourceLocation -BaseTime $baseTime -Secret $adminSecret
                    } finally {
                        $script:records[$script:roots[-1]].Operations +=
                        New-FixtureOperation -Id "$script:groupId/providers/Microsoft.Resources/deploymentScripts/setup"
                    }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            if ($presence -eq 'present') {
                $result.Exception | Should -Match 'deployment scripts'
                $result.DeploymentAttempts | Should -Be 1
                $result.RemainingDeploymentNames | Should -Be @($script:names)
                Should -Invoke Remove-AzResource -Times 0 -Exactly
                Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
            } else {
                $result.ContainsKey('Exception') | Should -BeFalse
                $result.DeploymentAttempts | Should -Be 2
                @($script:submissions) | Should -Be @('italynorth', 'italynorth')
                @($script:validations) | Should -Be @('italynorth')
                $result.RemainingDeploymentNames | Should -Be @($script:names[1])
            }
        }
    }

    Context 'Management-group authorization reconciliation within shared budgets' -Tag 'ManagementGroupRecovery' {
        BeforeEach {
            $template.'$schema' = 'https://schema.management.azure.com/schemas/2019-08-01/managementGroupDeploymentTemplate.json#'
            $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
            $originalBytes = [System.IO.File]::ReadAllBytes($templatePath)
            $script:outcomes = @('Forbidden')
        }

        It 'Recovers outputs with one submission and no intermediate cleanup under <kind> limits' -ForEach @(
            @{ kind = 'single-attempt'; limit = 1; remove = $true; pin = '' }
            @{ kind = 'normal'; limit = 3; remove = $true; pin = '' }
            @{ kind = 'retained-resources'; limit = 3; remove = $false; pin = '' }
            @{ kind = 'pinned-region'; limit = 3; remove = $true; pin = 'italynorth' }
        ) {
            $result = Invoke-TemplateDeploymentWithRetry @retryInput -DeploymentLimit $limit -RegionLimit $limit `
                -RemoveDeployment $remove -CustomLocation $pin

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentOutput.region.value | Should -BeExactly 'italynorth'
            $result.DeploymentAttempts | Should -Be 1
            $result.AttemptedLocations | Should -Be @('italynorth')
            $result.DeploymentNames | Should -Be @($script:names)
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            $script:names.Count | Should -Be 1
            @($script:validations) | Should -Be @('italynorth')
            @($script:submissions) | Should -Be @('italynorth')
            $script:alive.Count | Should -Be 2
            Should -Invoke New-AzManagementGroupDeployment -Times 1 -Exactly -ParameterFilter {
                $DeploymentName -eq $script:names[0] -and $ManagementGroupId -eq 'test-management-group' -and
                [object]::ReferenceEquals($DefaultProfile, $script:azContext)
            }
            Should -Invoke Get-AzManagementGroupDeployment -Times 1 -Exactly -ParameterFilter {
                $Name -eq $script:names[0] -and $ManagementGroupId -eq 'test-management-group' -and
                [object]::ReferenceEquals($DefaultProfile, $script:azContext)
            }
            Should -Invoke Start-Sleep -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
        }

        It 'Does not spend another region or submission on <state> despite available budgets and regional operation errors' -ForEach @(
            @{ state = 'Failed' }, @{ state = 'Unknown' }, @{ state = 'Canceled' }, @{ state = 'Running' }
            @{ state = 'Forbidden read' }, @{ state = 'Wrong management group' }
        ) {
            $script:forbiddenState = $state
            if ($state -eq 'Running') {
                Mock Start-Sleep { $script:clock = $script:clock.AddHours(1) }
            } elseif ($state -eq 'Forbidden read') {
                Mock Get-AzManagementGroupDeployment {
                    throw [System.Net.Http.HttpRequestException]::new('Status remains forbidden.', $null, [System.Net.HttpStatusCode]::Forbidden)
                }
            } elseif ($state -eq 'Wrong management group') {
                Mock Get-AzManagementGroupDeployment {
                    @{ DeploymentName = $Name; Id = "/providers/Microsoft.Management/managementGroups/wrong/providers/Microsoft.Resources/deployments/$Name"; ProvisioningState = 'Succeeded' }
                }
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.Exception | Should -Match 'Original management-group submission returned HTTP 403'
            $result.Exception | Should -Match 'Original authorization diagnostic; OperationID: fixture-operation'
            $result.ContainsKey('DeploymentOutput') | Should -BeFalse
            $result.DeploymentAttempts | Should -Be 1
            $result.AttemptedLocations | Should -Be @('italynorth')
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PreflightRejectedDeploymentNames.Count | Should -Be 0
            $script:names.Count | Should -Be 1
            @($script:validations) | Should -Be @('italynorth')
            $script:alive.Count | Should -Be 2
            Should -Invoke Get-AzManagementGroupDeployment -Times 1 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($templatePath)) | Should -Be ([Convert]::ToBase64String($originalBytes))
        }

        It 'Preserves earlier attempt ownership when the later original submission is recovered' {
            $script:outcomes = @('Legacy', 'Forbidden')
            $result = Invoke-TemplateDeploymentWithRetry @retryInput

            $result.ContainsKey('Exception') | Should -BeFalse
            $result.DeploymentOutput.region.value | Should -BeExactly 'italynorth'
            $result.DeploymentAttempts | Should -Be 2
            $result.AttemptedLocations | Should -Be @('italynorth')
            $result.DeploymentNames | Should -Be @($script:names)
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            @($script:names | Select-Object -Unique).Count | Should -Be 2
            @($script:validations) | Should -Be @('italynorth')
            Should -Invoke Get-AzManagementGroupDeployment -Times 1 -Exactly -ParameterFilter { $Name -eq $script:names[1] }
            Should -Invoke Remove-AzResource -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
        }

        It 'Does not turn a validation-stage authorization denial into submitted-deployment recovery' {
            Mock Test-AzManagementGroupDeployment {
                throw [System.Net.Http.HttpRequestException]::new('Validation forbidden.', $null, [System.Net.HttpStatusCode]::Forbidden)
            }
            $result = Invoke-TemplateDeploymentWithRetry @retryInput
            $result.Exception | Should -Match 'Validation forbidden'
            $result.DeploymentAttempts | Should -Be 0
            $result.DeploymentNames.Count | Should -Be 0
            Should -Invoke New-AzManagementGroupDeployment -Times 0 -Exactly
            Should -Invoke Get-AzManagementGroupDeployment -Times 0 -Exactly
            Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        }
    }

    It 'Bounds preparation failures even when no deployment is submitted' {
        Mock New-AzSubscriptionDeployment { throw 'Submission fixture should not be reached.' }
        $script:contextCalls = 0
        Mock Set-AzContext {
            $script:contextCalls++
            if ($script:contextCalls -gt 1) { throw 'Preparation failed.' }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.DeploymentAttempts | Should -Be 3
        $result.DeploymentNames.Count | Should -Be 0
        $result.Exception | Should -Match 'Preparation failed'
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Relocates the observed ResourceDeploymentFailure wrapper with wholly regional descendants' {
        $script:regionalError = @{ error = @{ code = 'DeploymentFailed'; details = @(
                    @{ code = 'ResourceDeploymentFailure'; message = 'The resource write operation failed to complete successfully, because it reached terminal provisioning state Failed.'; details = $script:regionalError.error.details }
                )
            }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        @($script:submissions) | Should -Be @('italynorth', 'swedencentral')
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
    }

    It 'Does not relocate mixed or empty ResourceDeploymentFailure details: <kind>' -ForEach @(
        @{ kind = 'empty' }, @{ kind = 'mixed' }
    ) {
        $details = @()
        if ($kind -eq 'mixed') {
            $details = @($script:regionalError.error.details) + @{ code = 'InvalidParameter'; message = 'EncryptionAtHost subscription feature is missing.' }
        }
        $script:regionalError = @{ error = @{ code = 'ResourceDeploymentFailure'; details = $details } }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'ExampleSku'
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
    }

    It 'Shares three candidate slots with validation failures without multiplying submissions' {
        $script:validationFailures = @('italynorth', 'swedencentral', 'eastus')
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'SkuNotAvailable'
        $result.AttemptedLocations | Should -Be $script:regions
        $result.DeploymentNames.Count | Should -Be 0
        $result.DeploymentAttempts | Should -Be 0
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Honors smaller independent limits: <regionLimit> regions and <deploymentLimit> deployments' -ForEach @(
        @{ regionLimit = 1; deploymentLimit = 3; outcomes = @('Legacy', 'Legacy', 'Succeeded'); expectedRegions = 1; expectedSubmissions = 3 }
        @{ regionLimit = 3; deploymentLimit = 1; outcomes = @('Regional'); expectedRegions = 1; expectedSubmissions = 1 }
        @{ regionLimit = 3; deploymentLimit = 2; outcomes = @('Regional', 'Regional'); expectedRegions = 2; expectedSubmissions = 2 }
    ) {
        $script:outcomes = $outcomes
        $result = Invoke-TemplateDeploymentWithRetry @retryInput -RegionLimit $regionLimit -DeploymentLimit $deploymentLimit
        $result.DeploymentAttempts | Should -Be $expectedSubmissions
        $result.AttemptedLocations.Count | Should -Be $expectedRegions
        $script:submissions.Count | Should -Be $expectedSubmissions
        if ($regionLimit -eq 1 -and $outcomes[0] -eq 'Legacy') {
            Should -Invoke Get-AzDeployment -Times 0 -Exactly
        }
    }

    It 'Rejects invalid <budget> limits before validation or submission' -ForEach @(
        @{ budget = 'RegionLimit'; limit = 0 }, @{ budget = 'RegionLimit'; limit = 4 }
        @{ budget = 'DeploymentLimit'; limit = 0 }, @{ budget = 'DeploymentLimit'; limit = 4 }
    ) {
        $retryInput[$budget] = $limit
        { Invoke-TemplateDeploymentWithRetry @retryInput } | Should -Throw
        $script:validations.Count | Should -Be 0
        $script:submissions.Count | Should -Be 0
    }

    It 'Does not revisit a region or lose a cleaned name when <selectionFailure>' -ForEach @(
        @{ selectionFailure = 'candidates are exhausted'; expected = 'No eligible regions remain' }
        @{ selectionFailure = 'the selector repeats a region'; expected = 'previously rejected' }
    ) {
        if ($selectionFailure -eq 'candidates are exhausted') {
            $script:regions = @('italynorth')
        } else {
            Mock Get-AvailableResourceLocation { @{ Location = 'italynorth'; IsGlobal = $false } }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match $expected
        $result.Exception | Should -Match 'ExampleSku'
        $result.DeploymentNames | Should -Be @($script:names)
        $result.RemainingDeploymentNames.Count | Should -Be 0
        $script:submissions.Count | Should -Be 1
        $script:alive.Count | Should -Be 0
    }

    It 'Preserves a genuine earlier root preflight rejection while cleaning the submitted regional failure' {
        $script:outcomes = @('Preflight', 'Regional', 'Succeeded')
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        $result.DeploymentNames | Should -Be @($script:names)
        $result.PreflightRejectedDeploymentNames | Should -Be @($script:names[0])
        $result.RemainingDeploymentNames | Should -Be @($script:names[2])
        @($script:submissions) | Should -Be @('italynorth', 'italynorth', 'swedencentral')
        Should -Invoke Start-Sleep -Times 0 -Exactly -ParameterFilter { $Seconds -eq 60 }
    }

    It 'Refreshes dependent Bicep region tokens while preserving non-location inputs' {
        $bicepPath = Join-Path $TestDrive 'main.test.bicep'
        $script:childPath = Join-Path $TestDrive 'dependency.bicep'
        @'
targetScope = 'subscription'
param resourceLocation string
param baseTime string
@secure()
param adminSecret string
module dependency './dependency.bicep' = {
  name: 'dependency'
  params: {
    location: '#_resourceLocation_#'
  }
}
'@ | Set-Content -LiteralPath $bicepPath
        "param location string = '#_resourceLocation_#'`nvar fixedValue = 'fixed-nonregional-value'" | Set-Content -LiteralPath $script:childPath
        $templateInput.TemplateFilePath = $bicepPath
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        Get-Content -LiteralPath $script:childPath -Raw | Should -Match "location string = 'swedencentral'"
        Get-Content -LiteralPath $script:childPath -Raw | Should -Match 'fixed-nonregional-value'
        $templateInput.AdditionalParameters.baseTime | Should -BeExactly 'fixed-base-time'
    }

    It 'Stops relocation on token restoration failure without losing cleanup tracking' {
        Mock Restore-RegionTokenFile { throw 'Token restoration failed.' }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'Token restoration failed'
        $result.Exception | Should -Match 'ExampleSku'
        $result.DeploymentNames.Count | Should -Be 1
        $result.RemainingDeploymentNames.Count | Should -Be 0
        $script:submissions.Count | Should -Be 1
    }

    It 'Traverses every operation page before removing resources' {
        Mock Invoke-AzRestMethod {
            $root = $script:roots[0]
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2025-04-01") {
                $script:trace.Add('first-page')
                return New-FixtureResponse -Content @{
                    value    = @($script:records[$root].Operations[0])
                    nextLink = "https://management.azure.com${root}/operations?api-version=2025-04-01&`$skiptoken=next"
                }
            }
            if ($Method -eq 'GET' -and $Path.EndsWith('&$skiptoken=next')) {
                $script:trace.Add('second-page')
                return New-FixtureResponse -Content @{ value = @($script:records[$root].Operations[1]) }
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        $script:trace.IndexOf('second-page') | Should -BeLessThan $script:trace.IndexOf("remove:$script:groupId")
        $script:trace | Should -Contain "GET:$script:nestedId/operations"
    }

    It 'Refuses unsafe operation pagination: <kind>' -ForEach @(
        @{ kind = 'foreign host' }, @{ kind = 'different deployment' }, @{ kind = 'cycle' }
        @{ kind = 'insecure scheme' }, @{ kind = 'userinfo' }, @{ kind = 'fragment' }
        @{ kind = 'false link' }, @{ kind = 'zero link' }, @{ kind = 'array link' }, @{ kind = 'blank link' }
    ) {
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'GET' -and $Path.Contains('/operations?')) {
                $root = $script:roots[0]
                $nextLink = switch ($kind) {
                    'foreign host' { "https://example.invalid${root}/operations?api-version=2025-04-01" }
                    'different deployment' { "https://management.azure.com${root}-other/operations?api-version=2025-04-01" }
                    'cycle' { "https://management.azure.com${root}/operations?api-version=2025-04-01" }
                    'insecure scheme' { "http://management.azure.com${root}/operations?api-version=2025-04-01" }
                    'userinfo' { "https://other@management.azure.com${root}/operations?api-version=2025-04-01" }
                    'fragment' { "https://management.azure.com${root}/operations?api-version=2025-04-01#fragment" }
                    'false link' { $false }
                    'zero link' { 0 }
                    'array link' { , @() }
                    'blank link' { ' ' }
                }
                return New-FixtureResponse -Content @{ value = @($script:records[$root].Operations[1]); nextLink = $nextLink }
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'operation page|operation pages'
        $script:removed.Count | Should -Be 0
        $script:submissions.Count | Should -Be 1
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Path -like '*example.invalid*' -or $Path -like '*-other/operations*' }
    }

    It 'Rejects a <kind> later operation page without authorizing cleanup from the first regional error' -ForEach @(
        @{ kind = 'nonregional error' }, @{ kind = 'running operation' }, @{ kind = 'missing error' }
        @{ kind = 'HTTP failure' }, @{ kind = 'malformed page' }
    ) {
        Mock Invoke-AzRestMethod {
            $root = $script:roots[0]
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2025-04-01") {
                return New-FixtureResponse -Content @{
                    value    = @($script:records[$root].Operations[1])
                    nextLink = "https://management.azure.com${root}/operations?api-version=2025-04-01&`$skiptoken=next"
                }
            }
            if ($Method -eq 'GET' -and $Path.EndsWith('&$skiptoken=next')) {
                switch ($kind) {
                    'HTTP failure' { return New-FixtureResponse -StatusCode 503 }
                    'malformed page' { return New-FixtureResponse -Content @{} }
                    'nonregional error' { $operation = New-FixtureOperation -State Failed -StatusMessage @{ error = @{ code = 'Unknown'; message = 'Unknown failure.' } } }
                    'running operation' { $operation = New-FixtureOperation -State Running -StatusMessage $script:regionalError }
                    'missing error' { $operation = New-FixtureOperation -State Failed }
                }
                return New-FixtureResponse -Content @{ value = @($operation) }
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Not -BeNullOrEmpty
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Path.EndsWith('&$skiptoken=next') }
    }

    It 'Keeps known resource IDs when a later operation page fails' {
        Mock Invoke-AzRestMethod {
            if ($Path.EndsWith('&$skiptoken=next')) {
                return New-FixtureResponse -StatusCode 503 -Content @{ error = @{ code = 'ServiceUnavailable' } }
            }
            New-FixtureResponse -Content @{
                value    = @((New-FixtureOperation -Id $script:groupId))
                nextLink = "https://management.azure.com$($Path.Split('?')[0])?api-version=2025-04-01&`$skiptoken=next"
            }
        }
        $result = Get-DeploymentTargetResourceList -DeploymentNames 'known' -Scope subscription
        $result.resolveError | Should -Match 'ServiceUnavailable'
        $result.resourcesToRemove | Should -Contain $script:groupId
    }

    It 'Does not remove a failed root while a nested deployment is still running' {
        Mock Get-AzResourceGroupDeployment { @{ DeploymentName = $Name; ProvisioningState = 'Running' } }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'Running'
        $script:removed.Count | Should -Be 0
        $script:records.ContainsKey($script:roots[0]) | Should -BeTrue
        $script:submissions.Count | Should -Be 1
    }

    It 'Preserves the original subscription after traversing a nested deployment in another subscription' {
        $otherSubscription = '22222222-2222-2222-2222-222222222222'
        $script:requiredRemovalSubscription = $otherSubscription
        $script:groupId = $script:groupId.Replace($script:subscriptionId, $otherSubscription)
        $script:vnetId = $script:vnetId.Replace($script:subscriptionId, $otherSubscription)
        $script:nestedId = $script:nestedId.Replace($script:subscriptionId, $otherSubscription)
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        $script:azContext.Subscription.Id | Should -Be $script:subscriptionId
        Should -Invoke Set-AzContext -Times 3 -Exactly -ParameterFilter { $PesterBoundParameters.ContainsKey('Context') -and $Context.Subscription.Id -eq $script:subscriptionId }
        $script:trace | Should -Contain "GET:$script:nestedId/operations"
    }

    It 'Uses exact <scope> deployment records without moving metadata location' -ForEach @(
        @{ scope = 'managementGroup'; schema = 'managementGroupDeploymentTemplate'; command = 'New-AzManagementGroupDeployment' }
        @{ scope = 'tenant'; schema = 'tenantDeploymentTemplate'; command = 'New-AzTenantDeployment' }
    ) {
        $template.'$schema' = "https://schema.management.azure.com/schemas/2019-08-01/$schema.json#"
        $template | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $templatePath
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        $script:trace | Should -Contain "DELETE:$($script:roots[0])"
        Should -Invoke $command -Times 2 -Exactly -ParameterFilter { $Location -eq 'WestEurope' }
    }

    It 'Refuses relocation for protected cleanup targets rather than reporting complete removal' {
        $script:groupId = $script:groupId.Replace('retry-fixture', 'NetworkWatcherRG')
        $script:vnetId = "$script:groupId/providers/Microsoft.Network/virtualNetworks/dependencies"
        $script:nestedId = "$script:groupId/providers/Microsoft.Resources/deployments/dependencies"
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'protected resources'
        $script:removed.Count | Should -Be 0
        $result.RemainingDeploymentNames.Count | Should -Be 1
    }

    It 'Confirms every independent resource even when IDs have equal length' {
        $ids = @("$script:groupId/providers/Microsoft.Network/virtualNetworks/first", "$script:groupId/providers/Microsoft.Network/virtualNetworks/other")
        $script:proofReads = [System.Collections.Generic.List[string]]::new()
        Mock Get-AzResource {
            $script:proofReads.Add($ResourceId)
            $exception = [System.InvalidOperationException]::new('Not found.')
            $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 404 }
            $exception | Add-Member -NotePropertyName Body -NotePropertyValue @{ Code = 'ResourceNotFound' }
            throw $exception
        }
        Complete-DeploymentRemoval -ResourceIds $ids
        @($script:proofReads | Sort-Object) | Should -Be @($ids | Sort-Object)
    }

    It 'Only accepts authoritative absence responses: <kind>' -ForEach @(
        @{ kind = 'unclassified 404'; status = 404; content = @{ error = @{ code = 'NotFound' } } }
        @{ kind = 'wrong status'; status = 403; content = @{ error = @{ code = 'ResourceGroupNotFound' } } }
        @{ kind = 'wrong identity'; status = 200; content = @{ id = '/subscriptions/other/resourceGroups/other' } }
    ) {
        Mock Invoke-AzRestMethod { New-FixtureResponse -StatusCode $status -Content $content }
        { Complete-DeploymentRemoval -ResourceIds $script:groupId } | Should -Throw '*Cannot confirm removal*'
    }

    It 'Cleans an empty but confirmed failed deployment record' {
        $id = Get-DeploymentResourceId -Scope subscription -Name 'empty' -SubscriptionId $script:subscriptionId
        $script:roots.Add($id)
        $script:records[$id] = @{ State = 'Failed'; Operations = @() }
        $result = Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames empty `
            -SubscriptionId $script:subscriptionId -RequireCompleteRemoval
        $result.RemovedDeploymentNames | Should -Be @('empty')
        $script:records.ContainsKey($id) | Should -BeFalse
    }

    It 'Only retains outstanding names when deleting a later root record fails' {
        $script:outcomes = @('Legacy', 'Regional', 'Succeeded')
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'DELETE' -and $Path.Split('?')[0] -eq $script:roots[1]) {
                return New-FixtureResponse -StatusCode 403
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'ExampleSku'
        $result.Exception | Should -Match 'record removal failed'
        $result.DeploymentNames | Should -Be @($script:names)
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
        $result.PendingDeletionDeploymentIds.Count | Should -Be 0
        $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
        $script:records.ContainsKey($script:roots[1]) | Should -BeTrue
        $script:alive.Count | Should -Be 0
        $script:submissions.Count | Should -Be 2
    }

    It 'Separates confirmed earlier roots from a later accepted deletion that is still pending' -Tag 'HistoryRemoval' {
        $script:outcomes = @('Legacy', 'Regional', 'Succeeded')
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'DELETE' -and $Path.Split('?')[0] -eq $script:roots[1]) {
                return New-FixtureResponse -StatusCode 202
            }
            Invoke-FixtureRest $Method $Path
        }

        $result = Invoke-TemplateDeploymentWithRetry @retryInput

        $result.Exception | Should -Match 'ExampleSku'
        $result.Exception | Should -Match 'still exists after cleanup'
        $result.RemainingDeploymentNames | Should -Be @($script:names[1])
        $result.PendingDeletionDeploymentIds | Should -Be @($script:roots[1])
        $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
        $script:records.ContainsKey($script:roots[1]) | Should -BeTrue
        $script:alive.Count | Should -Be 0
        $script:submissions.Count | Should -Be 2
        Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
    }

    It 'Keeps cancellation terminal when restoring a cross-subscription context also fails' {
        $otherSubscription = '22222222-2222-2222-2222-222222222222'
        $script:groupId = $script:groupId.Replace($script:subscriptionId, $otherSubscription)
        $script:vnetId = $script:vnetId.Replace($script:subscriptionId, $otherSubscription)
        $script:nestedId = $script:nestedId.Replace($script:subscriptionId, $otherSubscription)
        Mock Get-AzResourceGroupDeployment { throw [System.OperationCanceledException]::new('Discovery cancelled.') }
        Mock Set-AzContext { throw [System.Net.Http.HttpRequestException]::new('Context restoration failed.') } -ParameterFilter { $null -ne $Context }
        { Invoke-TemplateDeploymentWithRetry @retryInput } | Should -Throw '*Discovery cancelled*'
        $script:submissions.Count | Should -Be 1
        $script:removed.Count | Should -Be 0
    }

    It 'Stops without inspecting or replaying a deployment when timeout recovery is uncertain' {
        $script:outcomes = @('Timeout', 'Succeeded')
        Mock Get-AzDeployment { throw [System.TimeoutException]::new('Status timed out.') }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'outcome remains unknown'
        $result.RemainingDeploymentNames | Should -Be @($script:names)
        Should -Invoke Get-AzDeployment -Times 3 -Exactly
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
        $script:submissions.Count | Should -Be 1
    }

    It 'Does not let authoritative regional errors override <reason> evidence' -ForEach @(
        @{ reason = 'permission category' }, @{ reason = 'HTTP 403' }
    ) {
        Mock New-AzSubscriptionDeployment {
            $script:submissions.Add($resourceLocation)
            $exception = [System.InvalidOperationException]::new('Submission was forbidden.')
            $category = [System.Management.Automation.ErrorCategory]::PermissionDenied
            if ($reason -eq 'HTTP 403') {
                $exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = 403 }
                $category = [System.Management.Automation.ErrorCategory]::OperationStopped
            }
            throw [System.Management.Automation.ErrorRecord]::new($exception, 'Forbidden', $category, $null)
        }
        Mock Get-AzDeployment { @{ DeploymentName = $Name; ProvisioningState = 'Failed' } }
        Mock Invoke-AzRestMethod {
            New-FixtureResponse -Content @{ value = @((New-FixtureOperation -State Failed -StatusMessage $script:regionalError)) }
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'forbidden'
        $script:submissions.Count | Should -Be 1
        Should -Invoke Get-AzDeploymentOperation -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly
    }

    It 'Preserves full attempt suffixes for long prefixes and a frozen clock' {
        $longFolder = Join-Path $TestDrive ('a' * 100)
        $null = New-Item -Path $longFolder -ItemType Directory
        $longPath = Join-Path $longFolder 'main.test.json'
        Copy-Item -LiteralPath $templatePath -Destination $longPath
        $templateInput.TemplateFilePath = $longPath
        $script:outcomes = @('Legacy', 'Legacy', 'Succeeded')
        Mock Start-Sleep {}
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.ContainsKey('Exception') | Should -BeFalse
        @($result.DeploymentNames | Select-Object -Unique).Count | Should -Be 3
        for ($index = 0; $index -lt 3; $index++) {
            $result.DeploymentNames[$index].Length | Should -BeLessOrEqual 64
            $result.DeploymentNames[$index] | Should -Match "-t$($index + 1)-[0-9T]+Z$"
        }
    }

    It 'Rejects an invalid name during <phase> instead of looping indefinitely' -ForEach @(
        @{ phase = 'validation'; attempts = 0 }, @{ phase = 'deployment'; attempts = 1 }
    ) {
        $invalidFolder = Join-Path $TestDrive "invalid $phase name"
        $null = New-Item -Path $invalidFolder -ItemType Directory
        $invalidPath = Join-Path $invalidFolder 'main.test.json'
        Copy-Item -LiteralPath $templatePath -Destination $invalidPath
        $templateInput.TemplateFilePath = $invalidPath
        $script:nameGenerations = 0
        Mock Get-Date {
            if (++$script:nameGenerations -gt 2) { throw 'Repeated generation of an invalid deployment name.' }
            $script:clock.ToString($Format)
        }
        if ($phase -eq 'deployment') { Mock Test-TemplateDeployment {} }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $result.Exception | Should -Match 'unsupported characters'
        $result.DeploymentNames.Count | Should -Be 0
        $result.DeploymentAttempts | Should -Be $attempts
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
    }

    It 'Removes an out-of-group nested record before its root: <outcome>' -ForEach @(
        @{ outcome = 'success' }, @{ outcome = 'nested deletion failure' }, @{ outcome = 'nested deletion remains pending' }
    ) {
        $otherSubscription = '22222222-2222-2222-2222-222222222222'
        $script:subscriptionRecordId = "/subscriptions/$otherSubscription/providers/Microsoft.Resources/deployments/subscription-dependencies"
        $script:groupId = $script:groupId.Replace($script:subscriptionId, $otherSubscription)
        $script:vnetId = $script:vnetId.Replace($script:subscriptionId, $otherSubscription)
        $script:nestedId = $script:nestedId.Replace($script:subscriptionId, $otherSubscription)
        Mock Invoke-AzRestMethod {
            $id = $Path.Split('?')[0]
            if ($Method -eq 'GET' -and $id -eq "$($script:roots[0])/operations" -and -not $script:records.ContainsKey($script:subscriptionRecordId)) {
                $script:records[$script:roots[0]].Operations = @(
                    (New-FixtureOperation -Id $script:subscriptionRecordId -State Failed -StatusMessage $script:regionalError)
                )
                $script:records[$script:subscriptionRecordId] = @{
                    State      = 'Succeeded'
                    Operations = @((New-FixtureOperation -Id $script:groupId), (New-FixtureOperation -Id $script:nestedId))
                }
            }
            if ($id -eq $script:subscriptionRecordId) {
                $script:trace.Add("${Method}:$id")
                if ($Method -eq 'DELETE') {
                    if ($outcome -eq 'nested deletion failure') { return New-FixtureResponse -StatusCode 403 }
                    if ($outcome -eq 'nested deletion remains pending') { return New-FixtureResponse -StatusCode 202 }
                    $script:records.Remove($id)
                    return New-FixtureResponse -StatusCode 204
                }
                if ($Method -eq 'GET' -and -not $script:records.ContainsKey($id)) {
                    return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
                }
                if ($Method -eq 'GET' -and $outcome -eq 'nested deletion remains pending') {
                    return New-FixtureResponse -Content @{ id = $id; properties = @{ provisioningState = 'Succeeded' } }
                }
            }
            Invoke-FixtureRest $Method $Path
        }
        $result = Invoke-TemplateDeploymentWithRetry @retryInput
        $root = $script:roots[0]
        if ($outcome -eq 'success') {
            $result.ContainsKey('Exception') | Should -BeFalse
            $script:trace.IndexOf("DELETE:$script:subscriptionRecordId") | Should -BeLessThan $script:trace.IndexOf("DELETE:$root")
        } else {
            $result.Exception | Should -Match 'record removal failed|still exists after cleanup'
            $result.RemainingDeploymentNames | Should -Be @($script:names)
            $result.PendingDeletionDeploymentIds.Count | Should -Be 0
            $script:records.ContainsKey($root) | Should -BeTrue
            $script:trace | Should -Not -Contain "DELETE:$root"
        }
        $script:azContext.Subscription.Id | Should -Be $script:subscriptionId
    }

    It 'Redacts retry diagnostics while retaining the original deployment exception' {
        $script:incidentMessage += ' Rejected secret-not-for-logs and fixed-base-time.'
        $script:outcomes = @('Regional')
        $log = @(Invoke-TemplateDeploymentWithRetry @retryInput -DeploymentLimit 1 3>&1 4>&1)
        $result = $log | Where-Object { $_ -is [hashtable] }
        $messages = $log | Where-Object { $_ -isnot [hashtable] } | Out-String
        $messages | Should -Match 'ExampleSku'
        $messages | Should -Not -Match 'secret-not-for-logs|fixed-base-time'
        $result.Exception | Should -Match '\[REDACTED\]'
        $result.Exception | Should -Not -Match 'secret-not-for-logs|fixed-base-time'
        $result.ErrorRecord.Exception.Message | Should -Match 'secret-not-for-logs'
    }

    It 'Does not deploy, select regions or clean up under WhatIf' {
        Invoke-TemplateDeploymentWithRetry @retryInput -WhatIf
        Should -Invoke Get-AvailableResourceLocation -Times 0 -Exactly
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }
}

Describe 'Confirmed post-removal cleanup before regional relocation' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Invoke-ResourcePostRemoval.ps1')
        function Get-AzKeyVault {
            [CmdletBinding()]
            param([switch] $InRemovedState)
            throw 'Unexpected vault query.'
        }
        function Remove-AzKeyVault {
            [CmdletBinding()]
            param([string] $ResourceId, [switch] $InRemovedState, [switch] $Force, [string] $Location)
            throw 'Unexpected vault purge.'
        }
        function Get-AzCognitiveServicesAccount {
            [CmdletBinding()]
            param([switch] $InRemovedState)
            throw 'Unexpected account query.'
        }
        function Remove-AzCognitiveServicesAccount {
            [CmdletBinding()]
            param([switch] $InRemovedState, [switch] $Force, [string] $Location, [string] $ResourceGroupName, [string] $Name)
            throw 'Unexpected account purge.'
        }
        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path)
            throw 'Unexpected REST request.'
        }
    }

    BeforeEach {
        $script:resourceId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/cleanup/providers/Microsoft.KeyVault/vaults/retry-vault'
        $script:softDeleted = $true
        Mock Invoke-RestMethod { throw 'Unexpected network access.' }
        Mock Get-AzKeyVault {
            if ($script:softDeleted) {
                @{ ResourceId = $script:resourceId; Id = 'deleted-vault'; Location = 'italynorth'; EnablePurgeProtection = $false }
            }
        }
        Mock Remove-AzKeyVault { $script:softDeleted = $false }
    }

    It 'Confirms a purged vault is no longer in removed state' {
        Invoke-ResourcePostRemoval -Type 'Microsoft.KeyVault/vaults' -ResourceId $script:resourceId -RequireCompleteRemoval
        Should -Invoke Remove-AzKeyVault -Times 1 -Exactly
        Should -Invoke Get-AzKeyVault -Times 2 -Exactly
    }

    It 'Stops relocation when a vault <reason>' -ForEach @(
        @{ reason = 'remains reserved' }, @{ reason = 'cannot be purged' }, @{ reason = 'is purge protected' }
    ) {
        switch ($reason) {
            'remains reserved' { Mock Remove-AzKeyVault {} }
            'cannot be purged' { Mock Remove-AzKeyVault { throw 'DeletedVaultPurge is denied.' } }
            'is purge protected' {
                Mock Get-AzKeyVault { @{ ResourceId = $script:resourceId; EnablePurgeProtection = $true } }
            }
        }
        { Invoke-ResourcePostRemoval -Type 'Microsoft.KeyVault/vaults' -ResourceId $script:resourceId -RequireCompleteRemoval } |
            Should -Throw
        Should -Invoke Remove-AzKeyVault -Times ($reason -eq 'is purge protected' ? 0 : 3) -Exactly
    }

    It 'Does not retry a cancelled post-removal query' {
        Mock Get-AzKeyVault { throw [System.OperationCanceledException]::new('Purge cancelled.') }
        { Invoke-ResourcePostRemoval -Type 'Microsoft.KeyVault/vaults' -ResourceId $script:resourceId -RequireCompleteRemoval } |
            Should -Throw '*cancelled*'
        Should -Invoke Get-AzKeyVault -Times 1 -Exactly
        Should -Invoke Remove-AzKeyVault -Times 0 -Exactly
    }

    It 'Keeps the existing non-strict behavior for a purge-protected vault' {
        Mock Get-AzKeyVault { @{ ResourceId = $script:resourceId; Id = 'deleted-vault'; EnablePurgeProtection = $false } }
        Mock Remove-AzKeyVault { throw 'DeletedVaultPurge is denied.' }
        { Invoke-ResourcePostRemoval -Type 'Microsoft.KeyVault/vaults' -ResourceId $script:resourceId } | Should -Not -Throw
        Should -Invoke Get-AzKeyVault -Times 1 -Exactly
        Should -Invoke Remove-AzKeyVault -Times 1 -Exactly
    }

    It 'Does not mistake incomplete REST post-removal lookup for absence: <kind>' -ForEach @(
        @{ kind = 'denied'; status = 403; content = @{ error = @{ code = 'AuthorizationFailed' } } }
        @{ kind = 'malformed'; status = 200; content = @{} }
        @{ kind = 'paginated'; status = 200; content = @{ value = @(); nextLink = '/another-page' } }
    ) {
        Mock Invoke-AzRestMethod { @{ StatusCode = $status; Content = ConvertTo-Json $content -Depth 5 } }
        { Invoke-ResourcePostRemoval -Type 'Microsoft.ApiManagement/service' -ResourceId $script:resourceId -RequireCompleteRemoval } |
            Should -Throw '*Cannot confirm complete post-removal*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Does not authorize relocation while <type> remains soft-deleted after a successful purge request' -ForEach @(
        @{ type = 'Microsoft.AppConfiguration/configurationStores'; property = 'configurationStoreId' }
        @{ type = 'Microsoft.ApiManagement/service'; property = 'serviceId' }
    ) {
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'GET') {
                return @{ StatusCode = 200; Content = ConvertTo-Json @{
                        value = @(@{ properties = @{ $property = $script:resourceId; location = 'italynorth' }; location = 'italynorth' })
                    } -Depth 6
                }
            }
            @{ StatusCode = 200; Content = '{}' }
        }
        { Invoke-ResourcePostRemoval -Type $type -ResourceId $script:resourceId -RequireCompleteRemoval } |
            Should -Throw '*remains reserved*'
        Should -Invoke Invoke-AzRestMethod -Times 3 -Exactly -ParameterFilter { $Method -ne 'GET' }
    }

    It 'Confirms cognitive account purge at the original resource group' {
        $script:resourceId = $script:resourceId.Replace('Microsoft.KeyVault/vaults', 'Microsoft.CognitiveServices/accounts')
        Mock Get-AzCognitiveServicesAccount {
            if ($script:softDeleted) {
                @{ AccountName = 'retry-vault'; ResourceGroupName = 'cleanup'; Id = $script:resourceId; Location = 'italynorth' }
            }
        }
        Mock Remove-AzCognitiveServicesAccount { $script:softDeleted = $false }
        Invoke-ResourcePostRemoval -Type 'Microsoft.CognitiveServices/accounts' -ResourceId $script:resourceId -RequireCompleteRemoval
        Should -Invoke Remove-AzCognitiveServicesAccount -Times 1 -Exactly -ParameterFilter { $ResourceGroupName -eq 'cleanup' }
        Should -Invoke Get-AzCognitiveServicesAccount -Times 2 -Exactly
    }

    It 'Does not purge an ambiguous soft-deleted account or claim it is absent' {
        Mock Get-AzCognitiveServicesAccount { @{ AccountName = 'retry-vault'; Id = 'unclassified-removed-account' } }
        Mock Remove-AzCognitiveServicesAccount { throw 'Unexpected purge.' }
        { Invoke-ResourcePostRemoval -Type 'Microsoft.CognitiveServices/accounts' -ResourceId $script:resourceId -RequireCompleteRemoval } |
            Should -Throw '*remains reserved*'
        Should -Invoke Remove-AzCognitiveServicesAccount -Times 0 -Exactly
    }
}
