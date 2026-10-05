param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

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
            param([string] $TemplateFile, [string] $DeploymentName, [string] $Location, [string] $ManagementGroupId, [string] $resourceLocation, [string] $baseTime, [securestring] $adminSecret)
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
                'Legacy' {
                    $script:operationError = @{ error = @{ code = 'QuotaExceeded'; message = 'Nonregional quota failure.' } }
                    $script:records[$rootId].Operations[1].properties.statusMessage = $script:operationError
                    throw "The deployment '$Name' failed with error(s). (Code: DeploymentFailed) QuotaExceeded"
                }
                'FailedResult' { return @{ ProvisioningState = 'Failed' } }
                'Timeout' { throw [System.TimeoutException]::new('Original submission timed out.') }
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
            if (-not $script:records.ContainsKey($id)) { throw "Missing deployment [$id]." }
            @{ DeploymentName = $Name; ProvisioningState = $script:records[$id].State }
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
            if ($Method -eq 'GET' -and $id -eq $script:groupId) {
                if ($script:alive.Contains($id)) { return New-FixtureResponse -Content @{ id = $id } }
                return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'ResourceGroupNotFound' } }
            }
            if ($Method -eq 'DELETE' -and $id -in $script:roots) {
                $script:records.Remove($id)
                return New-FixtureResponse -StatusCode 204
            }
            if ($Method -eq 'GET' -and $id -in $script:roots) {
                if ($script:records.ContainsKey($id)) { return New-FixtureResponse -Content @{ id = $id } }
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
        $script:azContext = @{ Subscription = @{ Id = $script:subscriptionId }; Environment = @{ ResourceManagerUrl = 'https://management.azure.com/' } }
        $script:clock = [datetime]::new(2026, 10, 3, 8, 51, 48, [DateTimeKind]::Utc)
        $script:regions = @('italynorth', 'swedencentral', 'eastus')
        $script:outcomes = @('Regional', 'Succeeded')
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
                $script:azContext = @{ Subscription = @{ Id = $Subscription }; Environment = $script:azContext.Environment }
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
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2021-04-01") {
                return New-FixtureResponse -Content @{
                    value = @($script:records[$root].Operations[1])
                    nextLink = "https://management.azure.com${root}/operations?api-version=2021-04-01&`$skiptoken=next"
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
        $firstPage = "${id}/operations?api-version=2021-04-01"
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
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2021-04-01") {
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
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2021-04-01") {
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
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2021-04-01") {
                $script:trace.Add('first-page')
                return New-FixtureResponse -Content @{
                    value    = @($script:records[$root].Operations[0])
                    nextLink = "https://management.azure.com${root}/operations?api-version=2021-04-01&`$skiptoken=next"
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
                    'foreign host' { "https://example.invalid${root}/operations?api-version=2021-04-01" }
                    'different deployment' { "https://management.azure.com${root}-other/operations?api-version=2021-04-01" }
                    'cycle' { "https://management.azure.com${root}/operations?api-version=2021-04-01" }
                    'insecure scheme' { "http://management.azure.com${root}/operations?api-version=2021-04-01" }
                    'userinfo' { "https://other@management.azure.com${root}/operations?api-version=2021-04-01" }
                    'fragment' { "https://management.azure.com${root}/operations?api-version=2021-04-01#fragment" }
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
            if ($Method -eq 'GET' -and $Path -eq "${root}/operations?api-version=2021-04-01") {
                return New-FixtureResponse -Content @{
                    value    = @($script:records[$root].Operations[1])
                    nextLink = "https://management.azure.com${root}/operations?api-version=2021-04-01&`$skiptoken=next"
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
                nextLink = "https://management.azure.com$($Path.Split('?')[0])?api-version=2021-04-01&`$skiptoken=next"
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
        $script:records.ContainsKey($script:roots[0]) | Should -BeFalse
        $script:records.ContainsKey($script:roots[1]) | Should -BeTrue
        $script:alive.Count | Should -Be 0
        $script:submissions.Count | Should -Be 2
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
        @{ outcome = 'success' }, @{ outcome = 'nested deletion failure' }
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
                    $script:records.Remove($id)
                    return New-FixtureResponse -StatusCode 204
                }
                if ($Method -eq 'GET' -and -not $script:records.ContainsKey($id)) {
                    return New-FixtureResponse -StatusCode 404 -Content @{ error = @{ code = 'DeploymentNotFound' } }
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
            $result.Exception | Should -Match 'record removal failed'
            $result.RemainingDeploymentNames | Should -Be @($script:names)
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
