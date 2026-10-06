param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Available resource location selection' {
    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'regionSelector' 'Get-AvailableResourceLocation.ps1')

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
    }

    BeforeEach {
        $savedTemp = $env:TEMP
        $env:TEMP = $TestDrive
        '{"Microsoft.DevTestLab":{"labs":{},"labs/virtualMachines":{}}}' |
            Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
        $inputParameters = @{
            ModuleRoot                  = 'avm/res/dev-test-lab/lab'
            GlobalResourceGroupLocation = 'WestEurope'
            RepoRoot                    = $repoRootPath
        }
        Mock Invoke-WebRequest { throw 'Unexpected network request.' }
        Mock Get-Random { 0 }
        Mock Get-AzResourceProvider {
            if ($ProviderNamespace) {
                [pscustomobject]@{
                    ProviderNamespace = 'Microsoft.DevTestLab'
                    RegistrationState = 'NotRegistered'
                    ResourceTypes     = @(
                        @{ ResourceTypeName = 'labs'; Locations = @('Central US', 'East US', 'West Europe') }
                        @{ ResourceTypeName = 'labs/virtualMachines'; Locations = @('East US') }
                    )
                }
            }
        }
        Mock Get-AzLocation {
            @(
                @{ Location = 'centralus'; DisplayName = 'Central US'; RegionCategory = 'Recommended'; PairedRegion = 'eastus2' }
                @{ Location = 'eastus'; DisplayName = 'East US'; RegionCategory = 'Recommended'; PairedRegion = 'westus' }
                @{ Location = 'westeurope'; DisplayName = 'West Europe'; RegionCategory = 'Recommended'; PairedRegion = 'northeurope' }
                @{ Location = 'norwayeast'; DisplayName = 'Norway East'; RegionCategory = 'Recommended'; PairedRegion = 'norwaywest' }
            )
        }
    }

    AfterEach {
        $env:TEMP = $savedTemp
    }

    It 'Recovers missing registered-only enumeration using explicit namespace metadata' {
        @(Get-AzResourceProvider).Count | Should -Be 0

        $location = Get-AvailableResourceLocation @inputParameters

        $location | Should -Be 'centralus'
        $location | Should -Not -Be 'westeurope'
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly -ParameterFilter {
            $ProviderNamespace -eq 'Microsoft.DevTestLab'
        }
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
    }

    It 'Recognizes Windows and absolute resource module paths' -ForEach @(
        @{ path = 'avm\res\dev-test-lab\lab' }
        @{ path = 'C:\repo\avm\res\dev-test-lab\lab' }
    ) {
        $inputParameters.ModuleRoot = $path
        Get-AvailableResourceLocation @inputParameters | Should -Be 'centralus'
        Should -Invoke Get-AzResourceProvider -Times 1 -Exactly
    }

    It 'Uses the full child resource type instead of its parent locations' {
        $inputParameters.ModuleRoot = 'avm/res/dev-test-lab/lab/virtual-machine'
        Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
    }

    It 'Keeps the metadata location only for explicitly global resources' {
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @('Global') }) }
        }

        $selection = Get-AvailableResourceLocation @inputParameters -AsObject

        $selection.Location | Should -BeExactly 'WestEurope'
        $selection.IsGlobal | Should -BeTrue
        Should -Invoke Get-AzLocation -Times 0 -Exactly
    }

    It 'Rejects missing <missing> rather than assuming global availability' -ForEach @(
        @{ missing = 'provider'; data = $null }
        @{ missing = 'resource type'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'other'; Locations = @('Central US') }) } }
        @{ missing = 'null locations'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = $null }) } }
        @{ missing = 'empty locations'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @() }) } }
        @{ missing = 'blank locations'; data = @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @(' ') }) } }
    ) {
        Mock Get-AzResourceProvider { $data }

        { Get-AvailableResourceLocation @inputParameters } | Should -Throw '*No location metadata*'
        Should -Invoke Get-AzLocation -Times 0 -Exactly
        Should -Invoke Get-Random -Times 0 -Exactly
    }

    It 'Intersects supported and allowed regions and preserves exclusions' {
        $inputParameters.AllowedRegionsList = @('westeurope', 'eastus', 'norwayeast')
        Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
    }

    It 'Does not use global as a fallback for mixed location metadata' {
        Mock Get-AzResourceProvider {
            @{ ResourceTypes = @(@{ ResourceTypeName = 'labs'; Locations = @('Global', 'Central US') }) }
        }
        $selection = Get-AvailableResourceLocation @inputParameters -AsObject
        $selection.Location | Should -Be 'centralus'
        $selection.IsGlobal | Should -BeFalse
    }

    It 'Excludes previously attempted regions without replacing the normal exclusion list' {
        $inputParameters.AllowedRegionsList = @('centralus', 'eastus', 'westeurope')
        Get-AvailableResourceLocation @inputParameters -UnavailableRegions 'Central US' | Should -Be 'eastus'
    }

    It 'Fails explicitly when no eligible candidates remain' {
        { Get-AvailableResourceLocation @inputParameters -UnavailableRegions @('centralus', 'eastus') } |
            Should -Throw '*No supported, allowed regions remain*'
        Should -Invoke Get-Random -Times 0 -Exactly
    }

    It 'Honors exclusions for non-resource modules too' {
        $inputParameters.ModuleRoot = 'avm/ptn/test/example'
        $inputParameters.AllowedRegionsList = @('westeurope', 'eastus', 'centralus')
        Get-AvailableResourceLocation @inputParameters -UnavailableRegions 'centralus' | Should -Be 'eastus'
        Should -Invoke Get-AzResourceProvider -Times 0 -Exactly
    }

    It 'Fails on an empty allowed list for non-resource modules' {
        $inputParameters.ModuleRoot = 'avm/ptn/test/example'
        $inputParameters.AllowedRegionsList = @()
        { Get-AvailableResourceLocation @inputParameters } | Should -Throw '*No supported, allowed regions remain*'
    }

    It 'Propagates provider permission errors without location fallback' {
        Mock Get-AzResourceProvider { throw '403 Forbidden' }
        { Get-AvailableResourceLocation @inputParameters } | Should -Throw '*403 Forbidden*'
        Should -Invoke Get-AzLocation -Times 0 -Exactly
        Should -Invoke Get-Random -Times 0 -Exactly
    }

    Context 'Bounded metadata reads' -Tag 'RegionMetadataRetries' {
        BeforeAll {
            function Get-MetadataError {
                param(
                    [System.Exception] $Exception = [System.Threading.Tasks.TaskCanceledException]::new(
                        'private-fixture-request', [System.TimeoutException]::new('Request deadline.')
                    ),
                    [System.Management.Automation.ErrorCategory] $Category = 'OperationStopped',
                    [int] $Attempt = 1
                )
                $record = [System.Management.Automation.ErrorRecord]::new(
                    $Exception, "MetadataReadFailed$Attempt", $Category, [pscustomobject]@{ Attempt = $Attempt }
                )
                $record.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('private-fixture-response')
                return $record
            }

            function Invoke-MetadataFixtureRead {
                param([string] $Operation)
                $attempt = ++$script:metadataReads[$Operation]
                if ($attempt -le $script:metadataErrors[$Operation].Count -and $script:metadataErrors[$Operation][$attempt - 1]) {
                    $script:partialMetadata[$Operation]
                    throw $script:metadataErrors[$Operation][$attempt - 1]
                }
                return $script:metadataResults[$Operation]
            }
        }

        BeforeEach {
            '{"Microsoft.RetryTest":{"widgets":{}}}' | Set-Content -LiteralPath (Join-Path $TestDrive 'avm-apiSpecs.json')
            $inputParameters.ModuleRoot = 'avm/res/retry-test/widget'
            $script:metadataReads = @{ 'Get-AzResourceProvider' = 0; 'Get-AzLocation' = 0 }
            $script:metadataErrors = @{ 'Get-AzResourceProvider' = @(); 'Get-AzLocation' = @() }
            $script:partialMetadata = @{}
            $script:metadataResults = @{
                'Get-AzResourceProvider' = @{ ResourceTypes = @(@{ ResourceTypeName = 'widgets'; Locations = @('East US') }) }
                'Get-AzLocation'         = @(
                    @{ Location = 'eastus'; DisplayName = 'East US'; RegionCategory = 'Recommended'; PairedRegion = 'westus' }
                )
            }
            Mock Get-AzResourceProvider { Invoke-MetadataFixtureRead 'Get-AzResourceProvider' }
            Mock Get-AzLocation { Invoke-MetadataFixtureRead 'Get-AzLocation' }
            Mock Start-Sleep {}
            Mock Invoke-RestMethod { throw 'Unexpected network request.' }
        }

        AfterEach {
            Should -Invoke Invoke-WebRequest -Times 0 -Exactly
            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        }

        It 'Reads each metadata source once on immediate success' {
            Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
            Should -Invoke Get-AzResourceProvider -Times 1 -Exactly -ParameterFilter {
                $ProviderNamespace -eq 'Microsoft.RetryTest' -and $PesterBoundParameters.ErrorAction -eq 'Stop'
            }
            Should -Invoke Get-AzLocation -Times 1 -Exactly -ParameterFilter { $PesterBoundParameters.ErrorAction -eq 'Stop' }
            Should -Invoke Start-Sleep -Times 0 -Exactly
            Should -Invoke Get-Random -Times 1 -Exactly
        }

        Context '<operation>' -ForEach @(
            @{ operation = 'Get-AzResourceProvider' }
            @{ operation = 'Get-AzLocation' }
        ) {
            It 'Retries a <kind> timeout without repeating the other metadata read' -ForEach @(
                @{ kind = 'plain'; exception = [System.TimeoutException]::new('Deadline.') }
                @{ kind = 'HTTP cancellation'; exception = [System.Threading.Tasks.TaskCanceledException]::new('', [System.TimeoutException]::new('Deadline.')) }
                @{ kind = 'wrapped'; exception = [System.InvalidOperationException]::new('Read failed.', [System.TimeoutException]::new('Deadline.')) }
                @{ kind = 'aggregate'; exception = [System.AggregateException]::new([System.Exception[]] @([System.TimeoutException]::new('Deadline.'))) }
            ) {
                $script:metadataErrors[$operation] = @((Get-MetadataError -Exception $exception))
                Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
                $script:metadataReads[$operation] | Should -Be 2
                $script:metadataReads[$operation -eq 'Get-AzLocation' ? 'Get-AzResourceProvider' : 'Get-AzLocation'] | Should -Be 1
                Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
                Should -Invoke Get-Random -Times 1 -Exactly
            }

            It 'Retries a timeout carried by a RuntimeException ErrorRecord' {
                $record = Get-MetadataError
                $script:metadataErrors[$operation] = @((Get-MetadataError -Exception (
                            [System.Management.Automation.RuntimeException]::new('Wrapped read.', $null, $record)
                        )))
                Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
                $script:metadataReads[$operation] | Should -Be 2
            }

            It 'Allows three total attempts and logs only operation and attempt context' {
                $script:metadataErrors[$operation] = @((Get-MetadataError), (Get-MetadataError -Attempt 2))
                $log = @(Get-AvailableResourceLocation @inputParameters 3>&1)
                $warnings = @($log | Where-Object { $_ -is [System.Management.Automation.WarningRecord] })
                @($log | Where-Object { $_ -is [string] }) | Should -Be @('eastus')
                $warnings.Count | Should -Be 2
                $warnings[0].Message | Should -Match "$operation.*\[1/3\]"
                $warnings[1].Message | Should -Match "$operation.*\[2/3\]"
                $warnings | Out-String | Should -Not -Match 'private-fixture'
                $script:metadataReads[$operation] | Should -Be 3
                Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 5 }
            }

            It 'Rethrows the exhausted read error without replacing its exception or details' {
                $script:metadataErrors[$operation] = @(1..3 | ForEach-Object { Get-MetadataError -Attempt $_ })
                $expected = $script:metadataErrors[$operation][-1]
                $caught = $null
                try { Get-AvailableResourceLocation @inputParameters } catch { $caught = $_ }
                $caught | Should -Not -BeNullOrEmpty
                [object]::ReferenceEquals($caught.Exception, $expected.Exception) | Should -BeTrue
                [object]::ReferenceEquals($caught.TargetObject, $expected.TargetObject) | Should -BeTrue
                $caught.ErrorDetails.Message | Should -BeExactly $expected.ErrorDetails.Message
                $caught.FullyQualifiedErrorId | Should -Be $expected.FullyQualifiedErrorId
                $caught.CategoryInfo.Category | Should -Be $expected.CategoryInfo.Category
                $script:metadataReads[$operation] | Should -Be 3
                Should -Invoke Start-Sleep -Times 2 -Exactly
                Should -Invoke Get-Random -Times 0 -Exactly
            }

            It 'Does not retry <kind> even with misleading timeout text or evidence' -ForEach @(
                @{ kind = 'transport'; exception = [System.Net.Http.HttpRequestException]::new('An error occurred while sending the request.') }
                @{ kind = 'untyped timeout text'; exception = [System.InvalidOperationException]::new('HttpClient.Timeout of 100 seconds elapsing.') }
                @{ kind = 'cancellation'; exception = [System.OperationCanceledException]::new('HttpClient.Timeout of 100 seconds elapsing.') }
                @{ kind = 'task cancellation'; exception = [System.Threading.Tasks.TaskCanceledException]::new('Cancelled.') }
                @{ kind = 'mixed cancellation'; exception = [System.AggregateException]::new([System.Exception[]] @([System.TimeoutException]::new(), [System.OperationCanceledException]::new())) }
                @{ kind = 'wrapped pipeline cancellation'; exception = [System.TimeoutException]::new('Deadline.', [System.Management.Automation.PipelineStoppedException]::new()) }
                @{ kind = 'permission wrapper'; exception = [System.UnauthorizedAccessException]::new('Forbidden.', [System.TimeoutException]::new()) }
                @{ kind = 'authentication wrapper'; exception = [System.Security.Authentication.AuthenticationException]::new('Authentication failed.', [System.TimeoutException]::new()) }
                @{ kind = 'security wrapper'; exception = [System.Security.SecurityException]::new('Security check failed.', [System.TimeoutException]::new()) }
                @{ kind = 'mixed permission'; exception = [System.AggregateException]::new([System.Exception[]] @([System.TimeoutException]::new(), [System.UnauthorizedAccessException]::new())) }
                @{ kind = 'HTTP 401'; exception = [System.Net.Http.HttpRequestException]::new('Unauthorized.', [System.TimeoutException]::new(), [System.Net.HttpStatusCode]::Unauthorized) }
                @{ kind = 'HTTP 403'; exception = [System.Net.Http.HttpRequestException]::new('Forbidden.', [System.TimeoutException]::new(), [System.Net.HttpStatusCode]::Forbidden) }
            ) {
                $record = Get-MetadataError -Exception $exception
                $script:metadataErrors[$operation] = @($record)
                $caught = $null
                try { Get-AvailableResourceLocation @inputParameters } catch { $caught = $_ }
                [object]::ReferenceEquals($caught.Exception, $record.Exception) | Should -BeTrue
                $script:metadataReads[$operation] | Should -Be 1
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Get-Random -Times 0 -Exactly
            }

            It 'Does not retry a timeout with the <category> category' -ForEach @(
                @{ category = 'AuthenticationError' }, @{ category = 'PermissionDenied' }, @{ category = 'SecurityError' }
            ) {
                $record = Get-MetadataError -Category $category
                $script:metadataErrors[$operation] = @($record)
                $caught = $null
                try { Get-AvailableResourceLocation @inputParameters } catch { $caught = $_ }
                [object]::ReferenceEquals($caught.Exception, $record.Exception) | Should -BeTrue
                $caught.CategoryInfo.Category | Should -Be $category
                $script:metadataReads[$operation] | Should -Be 1
                Should -Invoke Start-Sleep -Times 0 -Exactly
            }

            It 'Preserves a terminal category inside a wrapped ErrorRecord' {
                $record = Get-MetadataError -Category PermissionDenied
                $wrapped = Get-MetadataError -Exception ([System.Management.Automation.RuntimeException]::new('Wrapped read.', $null, $record))
                $script:metadataErrors[$operation] = @($wrapped)
                $caught = $null
                try { Get-AvailableResourceLocation @inputParameters } catch { $caught = $_ }
                [object]::ReferenceEquals($caught.Exception, $wrapped.Exception) | Should -BeTrue
                $script:metadataReads[$operation] | Should -Be 1
                Should -Invoke Start-Sleep -Times 0 -Exactly
            }

            It 'Does not retry HTTP <status> response evidence alongside a timeout' -ForEach @(
                @{ status = 401 }, @{ status = 403 }
            ) {
                $record = Get-MetadataError
                $record.Exception | Add-Member -NotePropertyName Response -NotePropertyValue @{ StatusCode = $status }
                $script:metadataErrors[$operation] = @($record)
                $caught = $null
                try { Get-AvailableResourceLocation @inputParameters } catch { $caught = $_ }
                [object]::ReferenceEquals($caught.Exception, $record.Exception) | Should -BeTrue
                $script:metadataReads[$operation] | Should -Be 1
                Should -Invoke Start-Sleep -Times 0 -Exactly
            }

            It 'Discards partial metadata from a failed attempt' {
                $central = @{ Location = 'centralus'; DisplayName = 'Central US'; RegionCategory = 'Recommended'; PairedRegion = 'eastus2' }
                if ($operation -eq 'Get-AzResourceProvider') {
                    $script:partialMetadata[$operation] = @{ ResourceTypes = @(@{ ResourceTypeName = 'widgets'; Locations = @('Central US') }) }
                    $script:metadataResults['Get-AzLocation'] += $central
                } else {
                    $script:partialMetadata[$operation] = $central
                    $script:metadataResults['Get-AzResourceProvider'].ResourceTypes[0].Locations += 'Central US'
                }
                $script:metadataErrors[$operation] = @((Get-MetadataError))
                @(Get-AvailableResourceLocation @inputParameters) | Should -Be @('eastus')
                Should -Invoke Get-Random -Times 1 -Exactly -ParameterFilter { $Maximum -eq 1 }
                $script:metadataReads[$operation] | Should -Be 2
            }

            It 'Makes non-terminating cmdlet timeout errors terminating before retry' {
                $record = Get-MetadataError
                Mock $operation {
                    if (++$script:metadataReads[$operation] -eq 1) {
                        Write-Error -ErrorRecord $record
                    } else {
                        $script:metadataResults[$operation]
                    }
                }
                Get-AvailableResourceLocation @inputParameters | Should -Be 'eastus'
                $script:metadataReads[$operation] | Should -Be 2
                Should -Invoke $operation -Times 2 -Exactly -ParameterFilter { $PesterBoundParameters.ErrorAction -eq 'Stop' }
            }

            It 'Propagates cancellation during the retry delay immediately' {
                $script:metadataErrors[$operation] = @((Get-MetadataError))
                $cancellation = [System.OperationCanceledException]::new('Delay cancelled.')
                Mock Start-Sleep { throw $cancellation }
                $caught = $null
                try { Get-AvailableResourceLocation @inputParameters } catch { $caught = $_ }
                [object]::ReferenceEquals($caught.Exception, $cancellation) | Should -BeTrue
                $script:metadataReads[$operation] | Should -Be 1
                Should -Invoke Start-Sleep -Times 1 -Exactly
                Should -Invoke Get-Random -Times 0 -Exactly
            }

            It 'Stops the actual pipeline immediately without another metadata read' {
                $trace = [System.Collections.Generic.List[string]]::new()
                $pipeline = [powershell]::Create()
                try {
                    $null = $pipeline.AddScript(@'
param($RepoRoot, $ModuleRoot, $CancelledOperation, $Trace)
. (Join-Path $RepoRoot 'utilities' 'pipelines' 'e2eValidation' 'regionSelector' 'Get-AvailableResourceLocation.ps1')
function Get-AzResourceProvider {
    [CmdletBinding()]
    param([string[]] $ProviderNamespace)
    $Trace.Add('Get-AzResourceProvider')
    if ($CancelledOperation -eq 'Get-AzResourceProvider') {
        throw [System.Management.Automation.PipelineStoppedException]::new('Metadata cancelled.')
    }
    @{ ResourceTypes = @(@{ ResourceTypeName = 'widgets'; Locations = @('East US') }) }
}
function Get-AzLocation {
    [CmdletBinding()]
    param()
    $Trace.Add('Get-AzLocation')
    throw [System.Management.Automation.PipelineStoppedException]::new('Metadata cancelled.')
}
function Invoke-WebRequest { throw 'Unexpected network request.' }
function Invoke-RestMethod { throw 'Unexpected network request.' }
function Start-Sleep { param([int] $Seconds) $Trace.Add('delay') }
Get-AvailableResourceLocation -RepoRoot $RepoRoot -ModuleRoot $ModuleRoot -GlobalResourceGroupLocation 'WestEurope'
$Trace.Add('returned')
'@).AddArgument($repoRootPath).AddArgument($inputParameters.ModuleRoot).AddArgument($operation).AddArgument($trace)
                    @($pipeline.Invoke()).Count | Should -Be 0
                    $pipeline.InvocationStateInfo.State | Should -Be 'Stopped'
                    $pipeline.InvocationStateInfo.Reason | Should -BeOfType [System.Management.Automation.PipelineStoppedException]
                    @($trace) | Should -Be ($operation -eq 'Get-AzResourceProvider' ? @('Get-AzResourceProvider') : @('Get-AzResourceProvider', 'Get-AzLocation'))
                } finally {
                    $pipeline.Dispose()
                }
            }

            It 'Does not treat missing metadata after a retried read as another timeout' {
                $script:metadataErrors[$operation] = @((Get-MetadataError))
                $script:metadataResults[$operation] = $null
                $expectedMessage = $operation -eq 'Get-AzResourceProvider' ? '*No location metadata*' : '*No supported, allowed regions*'
                { Get-AvailableResourceLocation @inputParameters } | Should -Throw $expectedMessage
                $script:metadataReads[$operation] | Should -Be 2
                Should -Invoke Start-Sleep -Times 1 -Exactly
                Should -Invoke Get-Random -Times 0 -Exactly
            }
        }

        It 'Preserves explicit global availability after a retried provider read' {
            $script:metadataErrors['Get-AzResourceProvider'] = @((Get-MetadataError))
            $script:metadataResults['Get-AzResourceProvider'].ResourceTypes[0].Locations = @('Global')
            $selection = Get-AvailableResourceLocation @inputParameters -AsObject
            $selection.IsGlobal | Should -BeTrue
            $selection.Location | Should -BeExactly 'WestEurope'
            $script:metadataReads['Get-AzResourceProvider'] | Should -Be 2
            Should -Invoke Get-AzLocation -Times 0 -Exactly
            Should -Invoke Get-Random -Times 0 -Exactly
        }

        Context 'Integration with the regional deployment coordinator' {
            BeforeAll {
                . (Join-Path $repoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceDeployment' 'Invoke-TemplateDeploymentWithRetry.ps1')
            }

            BeforeEach {
                $templatePath = Join-Path $TestDrive 'metadata.test.json'
                @{
                    '$schema' = 'https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#'
                    resources = @()
                } | ConvertTo-Json | Set-Content -LiteralPath $templatePath
                $script:metadataRetryInput = @{
                    ModuleRoot    = $inputParameters.ModuleRoot
                    DoNotThrow    = $true
                    TemplateInput = @{
                        TemplateFilePath           = $templatePath
                        DeploymentMetadataLocation = 'WestEurope'
                        RepoRoot                   = $repoRootPath
                        AdditionalParameters       = @{ resourceLocation = '' }
                    }
                }
                Mock Test-TemplateDeployment {}
                Mock New-TemplateDeployment {
                    @{ DeploymentOutput = @{ region = $AdditionalParameters.resourceLocation }; DeploymentNames = @('metadata-fixture') }
                }
                Mock Initialize-DeploymentRemoval { throw 'Unexpected deployment cleanup.' }
            }

            AfterEach {
                Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
            }

            It 'Retries both reads independently within a single region and submission budget' {
                foreach ($operation in @('Get-AzResourceProvider', 'Get-AzLocation')) {
                    $script:metadataErrors[$operation] = @((Get-MetadataError), (Get-MetadataError -Attempt 2))
                }
                $result = Invoke-TemplateDeploymentWithRetry @metadataRetryInput -RegionLimit 1 -DeploymentLimit 1
                $result.ContainsKey('Exception') | Should -BeFalse
                $result.AttemptedLocations | Should -Be @('eastus')
                $result.DeploymentAttempts | Should -Be 1
                $result.DeploymentNames | Should -Be @('metadata-fixture')
                $result.DeploymentOutput.region | Should -Be 'eastus'
                $script:metadataReads['Get-AzResourceProvider'] | Should -Be 3
                $script:metadataReads['Get-AzLocation'] | Should -Be 3
                Should -Invoke Get-Random -Times 1 -Exactly
                Should -Invoke Test-TemplateDeployment -Times 1 -Exactly
                Should -Invoke New-TemplateDeployment -Times 1 -Exactly
                Should -Invoke Start-Sleep -Times 4 -Exactly -ParameterFilter { $Seconds -eq 5 }
            }

            It 'Keeps the three-region limit despite timeouts in each selection' {
                $script:metadataResults['Get-AzResourceProvider'].ResourceTypes[0].Locations = @('centralus', 'eastus', 'swedencentral')
                $script:metadataResults['Get-AzLocation'] = @('centralus', 'eastus', 'swedencentral') | ForEach-Object {
                    @{ Location = $_; DisplayName = $_; RegionCategory = 'Recommended'; PairedRegion = 'paired' }
                }
                foreach ($operation in @('Get-AzResourceProvider', 'Get-AzLocation')) {
                    $script:metadataErrors[$operation] = @((Get-MetadataError), $null, (Get-MetadataError), $null, (Get-MetadataError), $null)
                }
                Mock Test-TemplateDeployment {
                    throw [System.Management.Automation.ErrorRecord]::new(
                        [System.InvalidOperationException]::new('Regional validation failed.'),
                        'TemplateValidationFailed', [System.Management.Automation.ErrorCategory]::InvalidResult,
                        @{ code = 'RequestDisallowedByAzure'; message = 'See https://aka.ms/locationineligible.' }
                    )
                }
                $result = Invoke-TemplateDeploymentWithRetry @metadataRetryInput
                $result.AttemptedLocations | Should -Be @('centralus', 'eastus', 'swedencentral')
                $result.DeploymentAttempts | Should -Be 0
                $result.DeploymentNames.Count | Should -Be 0
                $script:metadataReads['Get-AzResourceProvider'] | Should -Be 6
                $script:metadataReads['Get-AzLocation'] | Should -Be 6
                Should -Invoke Get-Random -Times 3 -Exactly
                Should -Invoke Test-TemplateDeployment -Times 3 -Exactly
                Should -Invoke New-TemplateDeployment -Times 0 -Exactly
                Should -Invoke Start-Sleep -Times 6 -Exactly -ParameterFilter { $Seconds -eq 5 }
            }

            It 'Never validates or submits after exhausted <operation> timeouts' -ForEach @(
                @{ operation = 'Get-AzResourceProvider' }, @{ operation = 'Get-AzLocation' }
            ) {
                $script:metadataErrors[$operation] = @(1..3 | ForEach-Object { Get-MetadataError -Attempt $_ })
                $result = Invoke-TemplateDeploymentWithRetry @metadataRetryInput
                [object]::ReferenceEquals($result.ErrorRecord.Exception, $script:metadataErrors[$operation][-1].Exception) | Should -BeTrue
                $result.AttemptedLocations.Count | Should -Be 0
                $result.DeploymentAttempts | Should -Be 0
                $result.DeploymentNames.Count | Should -Be 0
                $script:metadataReads[$operation] | Should -Be 3
                Should -Invoke Get-Random -Times 0 -Exactly
                Should -Invoke Test-TemplateDeployment -Times 0 -Exactly
                Should -Invoke New-TemplateDeployment -Times 0 -Exactly
            }

            It 'Propagates <operation> cancellation even with DoNotThrow' -ForEach @(
                @{ operation = 'Get-AzResourceProvider' }, @{ operation = 'Get-AzLocation' }
            ) {
                $record = Get-MetadataError -Exception ([System.OperationCanceledException]::new('Metadata cancelled.'))
                $script:metadataErrors[$operation] = @($record)
                $caught = $null
                try { Invoke-TemplateDeploymentWithRetry @metadataRetryInput } catch { $caught = $_ }
                [object]::ReferenceEquals($caught.Exception, $record.Exception) | Should -BeTrue
                $script:metadataReads[$operation] | Should -Be 1
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Get-Random -Times 0 -Exactly
                Should -Invoke Test-TemplateDeployment -Times 0 -Exactly
                Should -Invoke New-TemplateDeployment -Times 0 -Exactly
            }
        }
    }
}
