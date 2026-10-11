param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Image Builder deployment scripts' {
    BeforeAll {
        $startScript = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'scripts' 'Start-ImageTemplate.ps1'
        $copyScript = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'scripts' 'Copy-VhdToStorageAccount.ps1'

        function Start-AzImageBuilderTemplate {
            [CmdletBinding()]
            param ([string] $ImageTemplateName, [string] $ResourceGroupName, [switch] $NoWait)
            throw 'Start-AzImageBuilderTemplate must be mocked.'
        }

        function Get-AzImageBuilderTemplate {
            [CmdletBinding()]
            param ([string] $ImageTemplateName, [string] $ResourceGroupName)
            throw ('Get-AzImageBuilderTemplate for [{0}] in [{1}] must be mocked.' -f $ImageTemplateName, $ResourceGroupName)
        }

        function Get-AzImageBuilderTemplateRunOutput {
            [CmdletBinding()]
            param ([string] $ImageTemplateName, [string] $ResourceGroupName)
            throw 'Get-AzImageBuilderTemplateRunOutput must be mocked.'
        }

        function Get-AzStorageAccount {
            [CmdletBinding()]
            param ()
            throw 'Get-AzStorageAccount must be mocked.'
        }

        function Start-AzStorageBlobCopy {
            [CmdletBinding()]
            param (
                [string] $AbsoluteUri,
                [object] $Context,
                [object] $DestContext,
                [string] $DestBlob,
                [string] $DestContainer,
                [switch] $Force
            )
            throw 'Start-AzStorageBlobCopy must be mocked.'
        }

        function Get-AzStorageBlobCopyState {
            [CmdletBinding()]
            param (
                [Parameter(ValueFromPipeline)]
                [object] $Blob,
                [switch] $WaitForComplete
            )
            process {
                throw 'Get-AzStorageBlobCopyState must be mocked.'
            }
        }
    }

    BeforeEach {
        $startInput = @{
            ImageTemplateName          = 'build-template'
            ImageTemplateResourceGroup = 'build-rg'
            Confirm                    = $false
        }
        $copyInput = $startInput.Clone()
        $copyInput.DestinationStorageAccountName = 'destination'
        $script:sourceUri = 'https://source.blob.core.windows.net/vhds/source.vhd'
        $script:runOutputs = @([pscustomobject]@{ ArtifactUri = $script:sourceUri })
        $script:clock = [datetime] '2026-10-06T10:00:00Z'
        $script:imageTemplate = [pscustomobject]@{
            BuildTimeoutInMinute    = 6
            LastRunStatusStartTime   = $script:clock
            LastRunStatusRunState    = 'Succeeded'
            LastRunStatusRunSubState = 'Distributing'
            LastRunStatusMessage     = ''
        }
        $script:previousImageTemplate = $script:imageTemplate.PSObject.Copy()
        $script:previousImageTemplate.LastRunStatusStartTime = [datetime]::MinValue
        $script:previousImageTemplate.LastRunStatusRunState = $null

        Mock Install-Module {}
        Mock Get-Module {} -ParameterFilter { $Name -contains 'Az.ImageBuilder' -or $Name -contains 'Az.Storage' }
        Mock Get-InstalledModule {}
        Mock Write-Verbose {}
        Mock Get-Date { $script:clock }
        Mock Start-Sleep { $script:clock = $script:clock.AddSeconds($Seconds) }
        Mock Start-AzImageBuilderTemplate {}
        Mock Get-AzImageBuilderTemplate { $script:imageTemplate.PSObject.Copy() }
        Mock Get-AzImageBuilderTemplateRunOutput { $script:runOutputs }
        Mock Get-AzStorageAccount {
            [pscustomobject]@{
                StorageAccountName = 'source'
                ResourceGroupName  = 'source-rg'
                Context            = 'source-context'
            }
            [pscustomobject]@{
                StorageAccountName = 'destination'
                ResourceGroupName  = 'destination-rg'
                Context            = 'destination-context'
            }
        }
        Mock Start-AzStorageBlobCopy { [pscustomobject]@{ Name = $DestBlob } }
        Mock Get-AzStorageBlobCopyState { [pscustomobject]@{ Status = 'Success'; StatusDescription = '' } }
    }

    Context 'Starting an image build' {
        BeforeEach {
            $script:templateLookupCount = 0
            Mock Get-AzImageBuilderTemplate {
                $script:templateLookupCount++
                if ($script:templateLookupCount -eq 1) {
                    $script:previousImageTemplate.PSObject.Copy()
                } else {
                    $script:imageTemplate.PSObject.Copy()
                }
            }
        }

        It 'Waits for the current image build by default' {
            . $startScript @startInput

            Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly -ParameterFilter {
                $ImageTemplateName -eq 'build-template' -and $ResourceGroupName -eq 'build-rg' -and $NoWait
            }
            Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly -ParameterFilter {
                $ImageTemplateName -eq 'build-template' -and $ResourceGroupName -eq 'build-rg'
            }
        }

        It 'Does not treat a completed run action as a completed image build' {
            Mock Start-AzImageBuilderTemplate { [pscustomobject]@{ Status = 'Succeeded' } }
            $script:imageTemplate.LastRunStatusRunState = 'Running'
            Mock Start-Sleep {
                $script:clock = $script:clock.AddSeconds($Seconds)
                $script:imageTemplate.LastRunStatusRunState = 'Succeeded'
            }

            . $startScript @startInput

            Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
        }

        It 'Does not accept the previous completed run after a new submission' {
            $script:previousImageTemplate = $script:imageTemplate.PSObject.Copy()
            Mock Start-Sleep {
                $script:clock = $script:clock.AddSeconds($Seconds)
                $script:imageTemplate.LastRunStatusStartTime = $script:clock
            }

            . $startScript @startInput

            Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
            Should -Invoke Start-Sleep -Times 1 -Exactly
        }

        It 'Ignores an older successful status after observing the submitted run' {
            $script:previousImageTemplate.LastRunStatusStartTime = $script:clock.AddMinutes(-2)
            Mock Get-AzImageBuilderTemplate {
                $script:templateLookupCount++
                if ($script:templateLookupCount -eq 1) {
                    $script:previousImageTemplate.PSObject.Copy()
                } else {
                    $status = $script:imageTemplate.PSObject.Copy()
                    if ($script:templateLookupCount -eq 2) {
                        $status.LastRunStatusRunState = 'Running'
                    } elseif ($script:templateLookupCount -eq 3) {
                        $status.LastRunStatusStartTime = $status.LastRunStatusStartTime.AddMinutes(-1)
                    }
                    $status
                }
            }

            . $startScript @startInput

            Should -Invoke Get-AzImageBuilderTemplate -Times 4 -Exactly
            Should -Invoke Start-Sleep -Times 2 -Exactly
        }

        It 'Rejects a different newer run instead of reporting its success' {
            $script:imageTemplate.LastRunStatusRunState = 'Running'
            Mock Start-Sleep {
                $script:clock = $script:clock.AddSeconds($Seconds)
                $script:imageTemplate.LastRunStatusStartTime = $script:clock
                $script:imageTemplate.LastRunStatusRunState = 'Succeeded'
            }

            { . $startScript @startInput } | Should -Throw '*changed while waiting*'

            Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
        }

        It 'Rejects the current terminal build state <state> with provider diagnostics' -ForEach @(
            @{ state = 'Failed' }
            @{ state = 'Canceled' }
            @{ state = 'PartiallySucceeded' }
        ) {
            $script:imageTemplate.LastRunStatusRunState = $state
            $script:imageTemplate.LastRunStatusMessage = 'PackerBuildFailed: customization failed'

            { . $startScript @startInput } | Should -Throw "*$state*PackerBuildFailed: customization failed*"

            Should -Invoke Start-Sleep -Times 0 -Exactly
            Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
        }

        It 'Rejects an unknown current build state' {
            $script:imageTemplate.LastRunStatusRunState = 'UnexpectedState'

            { . $startScript @startInput } | Should -Throw '*Unexpected*UnexpectedState*'

            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Bounds a running build using <case>' -ForEach @(
            @{ case = 'the configured timeout'; minutes = 7; expectedMinutes = 12 }
            @{ case = 'the default for zero'; minutes = 0; expectedMinutes = 245 }
            @{ case = 'the default for an omitted timeout'; minutes = $null; expectedMinutes = 245 }
        ) {
            $script:previousImageTemplate.BuildTimeoutInMinute = $minutes
            $script:imageTemplate.LastRunStatusRunState = 'Running'
            $script:timeoutMinutes = $expectedMinutes
            Mock Start-Sleep { $script:clock = $script:clock.AddMinutes($script:timeoutMinutes) }

            { . $startScript @startInput } | Should -Throw "*Timed out after $expectedMinutes minutes*Running*"

            Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
            Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
        }

        It 'Accepts completion just before the observation deadline' {
            $script:imageTemplate.LastRunStatusRunState = 'Running'
            Mock Start-Sleep {
                $script:clock = $script:clock.AddSeconds(659)
                $script:imageTemplate.LastRunStatusRunState = 'Succeeded'
            }

            . $startScript @startInput

            Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
        }

        It 'Does not read another status after the observation deadline' {
            $script:imageTemplate.LastRunStatusRunState = 'Running'
            Mock Start-Sleep {
                $script:clock = $script:clock.AddMinutes(11)
                $script:imageTemplate.LastRunStatusRunState = 'Succeeded'
            }

            { . $startScript @startInput } | Should -Throw '*Timed out after 11 minutes*'

            Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
        }

        It 'Times out rather than accepting a success without a new run timestamp' {
            $script:imageTemplate.LastRunStatusStartTime = $null
            Mock Start-Sleep { $script:clock = $script:clock.AddMinutes(11) }

            { . $startScript @startInput } | Should -Throw '*Timed out*'

            Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
        }

        It 'Rejects a negative build timeout before submission' {
            $script:previousImageTemplate.BuildTimeoutInMinute = -1

            { . $startScript @startInput } | Should -Throw '*invalid build timeout*'

            Should -Invoke Start-AzImageBuilderTemplate -Times 0 -Exactly
        }

        It 'Rejects a missing template before submission' {
            Mock Get-AzImageBuilderTemplate {}

            { . $startScript @startInput } | Should -Throw '*Expected exactly one image template*'

            Should -Invoke Start-AzImageBuilderTemplate -Times 0 -Exactly
        }

        It 'Preserves a non-terminating status lookup error' {
            $ErrorActionPreference = 'Continue'
            Mock Get-AzImageBuilderTemplate { Write-Error 'Image status lookup failed' }

            { . $startScript @startInput } | Should -Throw '*Image status lookup failed*'

            Should -Invoke Start-AzImageBuilderTemplate -Times 0 -Exactly
        }

        It 'Preserves the explicit asynchronous option' {
            . $startScript @startInput -NoWait

            Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly -ParameterFilter { $NoWait }
            Should -Invoke Get-AzImageBuilderTemplate -Times 0 -Exactly
        }

        It 'Does not start a build with WhatIf' {
            . $startScript @startInput -WhatIf

            Should -Invoke Start-AzImageBuilderTemplate -Times 0 -Exactly
            Should -Invoke Get-AzImageBuilderTemplate -Times 0 -Exactly
        }

        It 'Propagates a non-terminating build error without reporting success' {
            $ErrorActionPreference = 'Continue'
            Mock Start-AzImageBuilderTemplate { Write-Error 'Image build failed: PackerBuildFailed' }

            { . $startScript @startInput } | Should -Throw '*Image build failed: PackerBuildFailed*'

            Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
        }

        It 'Propagates submission errors with NoWait' {
            $ErrorActionPreference = 'Continue'
            Mock Start-AzImageBuilderTemplate { Write-Error 'Image build submission failed' }

            { . $startScript @startInput -NoWait } | Should -Throw '*Image build submission failed*'

            Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
        }

        Context 'Recovering a post-submission status read' -Tag 'StatusReadRecovery' {
            BeforeAll {
                function Assert-OriginalStatusReadError {
                    param ([System.Management.Automation.ErrorRecord] $Actual)

                    $Actual | Should -Not -BeNullOrEmpty
                    [object]::ReferenceEquals($Actual.Exception, $script:lastStatusReadError.Exception) | Should -BeTrue
                    $Actual.FullyQualifiedErrorId | Should -BeExactly $script:lastStatusReadError.FullyQualifiedErrorId
                    $Actual.CategoryInfo.ToString() | Should -BeExactly $script:lastStatusReadError.CategoryInfo.ToString()
                    $Actual.TargetObject | Should -Be $script:lastStatusReadError.TargetObject
                    $Actual.ErrorDetails.Message | Should -Be $script:lastStatusReadError.ErrorDetails.Message
                    $Actual.InvocationInfo.PositionMessage | Should -BeExactly $script:lastStatusReadError.InvocationInfo.PositionMessage
                    $Actual.ScriptStackTrace | Should -BeExactly $script:lastStatusReadError.ScriptStackTrace
                }
            }

            BeforeEach {
                $script:resetException = [System.Net.Http.HttpRequestException]::new(
                    'An error occurred while sending the request.',
                    [System.IO.IOException]::new(
                        'Unable to read data from the transport connection: Connection reset by peer.',
                        [System.Net.Sockets.SocketException]::new([int] [System.Net.Sockets.SocketError]::ConnectionReset)
                    )
                )
                $script:statusReadException = $script:resetException
                $script:lastStatusReadError = $null
                $script:statusReads = [System.Collections.Generic.Queue[scriptblock]]::new()
                $script:statusReads.Enqueue({ throw $script:statusReadException })
                $script:statusReads.Enqueue({ $script:imageTemplate.PSObject.Copy() })

                Mock Write-Warning {}
                Mock Get-AzImageBuilderTemplate {
                    $script:templateLookupCount++
                    if ($script:templateLookupCount -eq 1) {
                        return $script:previousImageTemplate.PSObject.Copy()
                    }
                    try {
                        . ($script:statusReads.Dequeue())
                    } catch {
                        $script:lastStatusReadError = $_
                        throw
                    }
                }
            }

            It 'Recovers the typed connection reset from <case> without resubmission' -ForEach @(
                @{ case = 'a thrown exception'; failure = { throw $script:statusReadException }; wrapper = [System.Net.Http.HttpRequestException] }
                @{
                    case = 'a terminating error record'
                    failure = {
                        $record = [System.Management.Automation.ErrorRecord]::new(
                            $script:statusReadException, 'ImageStatusReadFailed', [System.Management.Automation.ErrorCategory]::ReadError, 'build-template'
                        )
                        Write-Error -ErrorRecord $record -ErrorAction Stop
                    }
                    wrapper = [System.Net.Http.HttpRequestException]
                }
                @{
                    case = 'a PowerShell method invocation'
                    failure = { [System.Runtime.ExceptionServices.ExceptionDispatchInfo]::Capture($script:statusReadException).Throw() }
                    wrapper = [System.Management.Automation.MethodInvocationException]
                }
                @{
                    case = 'nested PowerShell invocation wrappers'
                    failure = { { param($exception) throw $exception }.Invoke($script:statusReadException) }
                    wrapper = [System.Management.Automation.MethodInvocationException]
                }
            ) {
                $script:statusReads.Clear()
                $script:statusReads.Enqueue($failure)
                $script:statusReads.Enqueue({ $script:imageTemplate.PSObject.Copy() })

                . $startScript @startInput

                $script:lastStatusReadError.Exception.GetType() | Should -Be $wrapper
                if ($case -eq 'nested PowerShell invocation wrappers') {
                    $script:lastStatusReadError.Exception.InnerException.GetType() | Should -Be ([System.Management.Automation.RuntimeException])
                }
                $script:resetException.InnerException.InnerException.SocketErrorCode | Should -Be ([System.Net.Sockets.SocketError]::ConnectionReset)
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly -ParameterFilter { $NoWait -and $ErrorAction -eq 'Stop' }
                Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly -ParameterFilter {
                    $ImageTemplateName -eq 'build-template' -and $ResourceGroupName -eq 'build-rg' -and $ErrorAction -eq 'Stop'
                }
                Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
                Should -Invoke Write-Warning -Times 1 -Exactly -ParameterFilter { $Message -like '*Connection reset*build-template*1 of 2*' }
                Should -Invoke Write-Verbose -Times 1 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
            }

            It 'Allows exactly two recovery reads when both are needed' {
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({ throw $script:statusReadException })
                $script:statusReads.Enqueue({ throw $script:statusReadException })
                $script:statusReads.Enqueue({ $script:imageTemplate.PSObject.Copy() })

                . $startScript @startInput

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 4 -Exactly
                Should -Invoke Start-Sleep -Times 2 -Exactly -ParameterFilter { $Seconds -eq 15 }
                Should -Invoke Write-Warning -Times 2 -Exactly
                Should -Invoke Write-Warning -Times 1 -Exactly -ParameterFilter { $Message -like '*1 of 2*' }
                Should -Invoke Write-Warning -Times 1 -Exactly -ParameterFilter { $Message -like '*2 of 2*' }
            }

            It 'Exhausts the shared recovery allowance with <case>' -ForEach @(
                @{ case = 'consecutive resets'; failures = @(1, 2, 3); reads = 3 }
                @{ case = 'healthy polls between resets'; failures = @(1, 3, 5); reads = 5 }
            ) {
                $script:statusReads.Clear()
                $script:imageTemplate.LastRunStatusRunState = 'Running'
                for ($read = 1; $read -le $reads; $read++) {
                    if ($read -in $failures) {
                        $script:statusReads.Enqueue({ throw $script:statusReadException })
                    } else {
                        $script:statusReads.Enqueue({ $script:imageTemplate.PSObject.Copy() })
                    }
                }
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times ($reads + 1) -Exactly
                Should -Invoke Start-Sleep -Times ($reads - 1) -Exactly -ParameterFilter { $Seconds -eq 15 }
                Should -Invoke Write-Warning -Times 2 -Exactly
                Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
            }

            It 'Does not recover <case>' -ForEach @(
                @{ case = 'a string-only lookalike'; factory = { 'System.Net.Http.HttpRequestException -> System.IO.IOException -> System.Net.Sockets.SocketException (104): Connection reset by peer.' } }
                @{ case = 'an untyped wrapper'; factory = { [System.Exception]::new('Connection reset by peer.', $script:resetException) } }
                @{ case = 'an HTTP exception without the transport chain'; factory = { [System.Net.Http.HttpRequestException]::new('Connection reset by peer.') } }
                @{ case = 'a bare IO exception'; factory = { $script:resetException.InnerException } }
                @{ case = 'a bare socket exception'; factory = { $script:resetException.InnerException.InnerException } }
                @{ case = 'a missing IO wrapper'; factory = { [System.Net.Http.HttpRequestException]::new('request', $script:resetException.InnerException.InnerException) } }
                @{ case = 'an authentication failure'; factory = { [System.Security.Authentication.AuthenticationException]::new('Authentication failed', $script:resetException) } }
                @{ case = 'an authorization failure'; factory = { [System.UnauthorizedAccessException]::new('Access denied', $script:resetException) } }
                @{ case = 'a single aggregate failure'; factory = { [System.AggregateException]::new($script:resetException) } }
                @{
                    case = 'a mixed aggregate with the reset first'
                    factory = { [System.AggregateException]::new('Mixed failure', [System.Exception[]] @($script:resetException, [System.UnauthorizedAccessException]::new('Access denied'))) }
                }
                @{
                    case = 'a mixed aggregate with the reset last'
                    factory = { [System.AggregateException]::new('Mixed failure', [System.Exception[]] @([System.UnauthorizedAccessException]::new('Access denied'), $script:resetException)) }
                }
                @{
                    case = 'an aggregate inside the transport chain'
                    factory = { [System.Net.Http.HttpRequestException]::new('request', [System.IO.IOException]::new('transport', [System.AggregateException]::new($script:resetException.InnerException.InnerException))) }
                }
            ) {
                $script:statusReadException = . $factory
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Write-Warning -Times 0 -Exactly
                Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
            }

            It 'Does not recover a typed <socketError> transport failure' -ForEach @(
                @{ socketError = [System.Net.Sockets.SocketError]::ConnectionAborted }
                @{ socketError = [System.Net.Sockets.SocketError]::ConnectionRefused }
                @{ socketError = [System.Net.Sockets.SocketError]::TimedOut }
            ) {
                $script:statusReadException = [System.Net.Http.HttpRequestException]::new(
                    'Connection reset by peer.',
                    [System.IO.IOException]::new('Connection reset by peer.', [System.Net.Sockets.SocketException]::new([int] $socketError))
                )
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Write-Warning -Times 0 -Exactly
            }

            It 'Does not recover HTTP <statusCode> even with an inner connection reset' -ForEach @(
                @{ statusCode = 401 }
                @{ statusCode = 403 }
                @{ statusCode = 429 }
                @{ statusCode = 500 }
                @{ statusCode = 503 }
            ) {
                $script:statusReadException = [System.Net.Http.HttpRequestException]::new(
                    'Provider rejected the request', $script:resetException.InnerException, [System.Net.HttpStatusCode] $statusCode
                )
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Write-Warning -Times 0 -Exactly
            }

            It 'Preserves a structured error record for <case>' -ForEach @(
                @{ case = 'an unrecoverable read'; recoveries = 0 }
                @{ case = 'an exhausted connection reset'; recoveries = 2 }
            ) {
                $exception = if ($recoveries) { $script:resetException } else { [System.UnauthorizedAccessException]::new('Access denied') }
                $script:statusReadRecord = [System.Management.Automation.ErrorRecord]::new(
                    $exception, 'ImageStatusReadFailed', [System.Management.Automation.ErrorCategory]::ReadError, 'build-template'
                )
                $script:statusReadRecord.ErrorDetails = [System.Management.Automation.ErrorDetails]::new('Original provider diagnostic')
                $script:statusReads.Clear()
                for ($read = 0; $read -le $recoveries; $read++) {
                    $script:statusReads.Enqueue({ Write-Error -ErrorRecord $script:statusReadRecord -ErrorAction Stop })
                }
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                $caught.ErrorDetails.Message | Should -BeExactly 'Original provider diagnostic'
                $caught.TargetObject | Should -BeExactly 'build-template'
                Should -Invoke Get-AzImageBuilderTemplate -Times ($recoveries + 2) -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Write-Warning -Times $recoveries -Exactly
            }

            It 'Does not recover the initial pre-submission GET' {
                Mock Get-AzImageBuilderTemplate {
                    try { throw $script:resetException } catch { $script:lastStatusReadError = $_; throw }
                }
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Get-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 0 -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Write-Warning -Times 0 -Exactly
            }

            It 'Does not recover a build-start write with NoWait=<noWait>' -ForEach @(
                @{ noWait = $false; reads = 1 }
                @{ noWait = $true; reads = 0 }
            ) {
                Mock Start-AzImageBuilderTemplate {
                    try { throw $script:resetException } catch { $script:lastStatusReadError = $_; throw }
                }
                $caught = $null

                try { . $startScript @startInput -NoWait:$noWait } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times $reads -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Write-Warning -Times 0 -Exactly
            }

            It 'Retains the submitted run identity across a reset and ignores stale success' {
                $script:previousImageTemplate.LastRunStatusStartTime = $script:clock.AddMinutes(-2)
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({
                    $status = $script:imageTemplate.PSObject.Copy()
                    $status.LastRunStatusRunState = 'Running'
                    $status
                })
                $script:statusReads.Enqueue({ throw $script:resetException })
                $script:statusReads.Enqueue({
                    $status = $script:imageTemplate.PSObject.Copy()
                    $status.LastRunStatusStartTime = $status.LastRunStatusStartTime.AddMinutes(-1)
                    $status
                })
                $script:statusReads.Enqueue({ $script:imageTemplate.PSObject.Copy() })

                . $startScript @startInput

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 5 -Exactly
                Should -Invoke Start-Sleep -Times 3 -Exactly
                Should -Invoke Write-Warning -Times 1 -Exactly
            }

            It 'Rejects a different newer run after recovery' {
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({
                    $status = $script:imageTemplate.PSObject.Copy()
                    $status.LastRunStatusRunState = 'Running'
                    $status
                })
                $script:statusReads.Enqueue({ throw $script:resetException })
                $script:statusReads.Enqueue({
                    $status = $script:imageTemplate.PSObject.Copy()
                    $status.LastRunStatusStartTime = $status.LastRunStatusStartTime.AddMinutes(1)
                    $status
                })

                { . $startScript @startInput } | Should -Throw '*changed while waiting*'

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 4 -Exactly
                Should -Invoke Start-Sleep -Times 2 -Exactly
                Should -Invoke Write-Warning -Times 1 -Exactly
                Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
            }

            It 'Rejects <state> with provider diagnostics after recovery' -ForEach @(
                @{ state = 'Failed' }
                @{ state = 'Canceled' }
                @{ state = 'PartiallySucceeded' }
                @{ state = 'UnexpectedState' }
            ) {
                $script:imageTemplate.LastRunStatusRunState = $state
                $script:imageTemplate.LastRunStatusMessage = 'Original image build diagnostic'

                { . $startScript @startInput } | Should -Throw "*$state*Original image build diagnostic*"

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
                Should -Invoke Start-Sleep -Times 1 -Exactly
                Should -Invoke Write-Warning -Times 1 -Exactly
                Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
            }

            It 'Rejects <count> returned templates after recovery' -ForEach @(
                @{ count = 0 }
                @{ count = 2 }
            ) {
                $script:returnedTemplateCount = $count
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({ throw $script:resetException })
                $script:statusReads.Enqueue({
                    for ($index = 0; $index -lt $script:returnedTemplateCount; $index++) {
                        $script:imageTemplate.PSObject.Copy()
                    }
                })

                { . $startScript @startInput } | Should -Throw '*Expected exactly one image template*'

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
                Should -Invoke Write-Warning -Times 1 -Exactly
            }

            It 'Rejects success returned <seconds> seconds into the wait with recovery=<recover>' -ForEach @(
                @{ seconds = 660; recover = $false }
                @{ seconds = 661; recover = $false }
                @{ seconds = 660; recover = $true }
                @{ seconds = 661; recover = $true }
            ) {
                $script:readCompletionTime = $script:clock.AddSeconds($seconds)
                $script:statusReads.Clear()
                if ($recover) {
                    $script:statusReads.Enqueue({ throw $script:resetException })
                }
                $script:statusReads.Enqueue({
                    $script:clock = $script:readCompletionTime
                    $script:imageTemplate.PSObject.Copy()
                })

                { . $startScript @startInput } | Should -Throw '*Timed out after 11 minutes*'

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times (2 + [int] $recover) -Exactly
                Should -Invoke Start-Sleep -Times ([int] $recover) -Exactly
                Should -Invoke Write-Warning -Times ([int] $recover) -Exactly
                Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created*image artifacts*' }
            }

            It 'Accepts a recovered success just before the original deadline' {
                $script:readCompletionTime = $script:clock.AddSeconds(659)
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({ throw $script:resetException })
                $script:statusReads.Enqueue({
                    $script:clock = $script:readCompletionTime
                    $script:imageTemplate.PSObject.Copy()
                })

                . $startScript @startInput

                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
                Should -Invoke Write-Warning -Times 1 -Exactly
            }

            It 'Caps the final sleep to the remaining deadline with recovery=<recover>' -ForEach @(
                @{ recover = $false }
                @{ recover = $true }
            ) {
                $script:resetNearDeadline = $recover
                $script:readCompletionTime = $script:clock.AddSeconds(657.5)
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({
                    $script:clock = $script:readCompletionTime
                    if ($script:resetNearDeadline) { throw $script:resetException }
                    $status = $script:imageTemplate.PSObject.Copy()
                    $status.LastRunStatusRunState = 'Running'
                    $status
                })

                { . $startScript @startInput } | Should -Throw '*Timed out after 11 minutes*'

                $script:clock | Should -Be ([datetime] '2026-10-06T10:11:00Z')
                Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 2.5 }
                Should -Invoke Write-Warning -Times ([int] $recover) -Exactly
            }

            It 'Does not renew the deadline across two recovery waits' {
                $script:readCompletionTime = $script:clock.AddSeconds(640)
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({
                    $script:clock = $script:readCompletionTime
                    throw $script:resetException
                })
                $script:statusReads.Enqueue({ throw $script:resetException })

                { . $startScript @startInput } | Should -Throw '*Timed out after 11 minutes*'

                $script:clock | Should -Be ([datetime] '2026-10-06T10:11:00Z')
                Should -Invoke Get-AzImageBuilderTemplate -Times 3 -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Start-Sleep -Times 2 -Exactly
                Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
                Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 5 }
                Should -Invoke Write-Warning -Times 2 -Exactly
            }

            It 'Preserves a reset returned <seconds> seconds into the wait without recovery' -ForEach @(
                @{ seconds = 660 }
                @{ seconds = 661 }
            ) {
                $script:readCompletionTime = $script:clock.AddSeconds($seconds)
                $script:statusReads.Clear()
                $script:statusReads.Enqueue({
                    $script:clock = $script:readCompletionTime
                    throw $script:resetException
                })
                $caught = $null

                try { . $startScript @startInput } catch { $caught = $_ }

                Assert-OriginalStatusReadError $caught
                Should -Invoke Get-AzImageBuilderTemplate -Times 2 -Exactly
                Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly
                Should -Invoke Start-Sleep -Times 0 -Exactly
                Should -Invoke Write-Warning -Times 0 -Exactly
            }
        }
    }

    Context 'Copying an image artifact' {
        It 'Preserves the source URI and storage contexts for <case>' -ForEach @(
            @{ case = 'Azure public cloud'; uri = 'https://source.blob.core.windows.net/vhds/source.vhd' }
            @{ case = 'Azure Government'; uri = 'https://source.blob.core.usgovcloudapi.net/vhds/source.vhd' }
            @{ case = 'an escaped blob path'; uri = 'https://source.blob.core.windows.net/vhds/source%20image.vhd' }
        ) {
            $script:sourceUri = $uri
            $script:runOutputs = @([pscustomobject]@{ ArtifactUri = $uri })

            . $copyScript @copyInput

            Should -Invoke Get-AzImageBuilderTemplateRunOutput -Times 1 -Exactly -ParameterFilter {
                $ImageTemplateName -eq 'build-template' -and $ResourceGroupName -eq 'build-rg'
            }
            Should -Invoke Start-AzStorageBlobCopy -Times 1 -Exactly -ParameterFilter {
                $AbsoluteUri -ceq $script:sourceUri -and $Context -eq 'source-context' -and
                $DestContext -eq 'destination-context' -and $DestBlob -eq 'build-template.vhd' -and
                $DestContainer -eq 'vhds' -and $Force
            }
            Should -Invoke Get-AzStorageBlobCopyState -Times 0 -Exactly
        }

        It 'Waits for the copy when requested and preserves destination overrides' {
            . $copyScript @copyInput -VhdName 'custom-image' -DestinationContainerName 'custom-container' -WaitForComplete

            Should -Invoke Start-AzStorageBlobCopy -Times 1 -Exactly -ParameterFilter {
                $DestBlob -eq 'custom-image.vhd' -and $DestContainer -eq 'custom-container'
            }
            Should -Invoke Get-AzStorageBlobCopyState -Times 1 -Exactly -ParameterFilter {
                $WaitForComplete -and $Blob.Name -eq 'custom-image.vhd'
            }
        }

        It 'Ignores non-VHD outputs when exactly one VHD is present' {
            $script:runOutputs += [pscustomobject]@{ ArtifactUri = $null; ArtifactId = '/subscriptions/example/images/image' }

            . $copyScript @copyInput

            Should -Invoke Start-AzStorageBlobCopy -Times 1 -Exactly -ParameterFilter { $AbsoluteUri -ceq $script:sourceUri }
        }

        It 'Waits for a successful build to expose its VHD output' {
            $script:runOutputs = @()
            Mock Start-Sleep {
                $script:clock = $script:clock.AddSeconds($Seconds)
                $script:runOutputs = @([pscustomobject]@{ ArtifactUri = $script:sourceUri })
            }

            . $copyScript @copyInput

            Should -Invoke Get-AzImageBuilderTemplateRunOutput -Times 2 -Exactly
            Should -Invoke Start-Sleep -Times 1 -Exactly -ParameterFilter { $Seconds -eq 15 }
            Should -Invoke Start-AzStorageBlobCopy -Times 1 -Exactly
        }

        It 'Does not copy even an existing artifact from a build in state <state>' -ForEach @(
            @{ state = 'Running' }
            @{ state = 'Failed' }
            @{ state = 'Canceled' }
            @{ state = 'PartiallySucceeded' }
            @{ state = 'UnexpectedState' }
            @{ state = '' }
        ) {
            $script:imageTemplate.LastRunStatusRunState = $state

            { . $copyScript @copyInput } | Should -Throw '*has not completed successfully*'

            Should -Invoke Get-AzImageBuilderTemplateRunOutput -Times 0 -Exactly
            Should -Invoke Get-AzStorageAccount -Times 0 -Exactly
            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
        }

        It 'Rejects <case> before accessing storage' -ForEach @(
            @{ case = 'no outputs'; outputs = @() }
            @{ case = 'a null URI'; outputs = @([pscustomobject]@{ ArtifactUri = $null }) }
            @{ case = 'an empty URI'; outputs = @([pscustomobject]@{ ArtifactUri = '' }) }
            @{ case = 'a whitespace URI'; outputs = @([pscustomobject]@{ ArtifactUri = '   ' }) }
        ) {
            $script:runOutputs = $outputs

            { . $copyScript @copyInput } | Should -Throw '*Expected exactly one VHD artifact URI*found*0*'

            Should -Invoke Get-AzStorageAccount -Times 0 -Exactly
            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
            $script:clock | Should -Be ([datetime] '2026-10-06T10:05:00Z')
        }

        It 'Rejects ambiguous VHD outputs before accessing storage' {
            $script:runOutputs += [pscustomobject]@{ ArtifactUri = 'https://source.blob.core.windows.net/vhds/other.vhd' }

            { . $copyScript @copyInput } | Should -Throw '*Expected exactly one VHD artifact URI*found*2*'

            Should -Invoke Get-AzStorageAccount -Times 0 -Exactly
            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
            Should -Invoke Start-Sleep -Times 0 -Exactly
        }

        It 'Rejects an invalid artifact URI [<uri>] before accessing storage' -ForEach @(
            @{ uri = 'vhds/source.vhd' }
            @{ uri = 'not a URI' }
            @{ uri = 'https://' }
            @{ uri = 'ftp://source.blob.core.windows.net/vhds/source.vhd' }
        ) {
            $script:runOutputs = @([pscustomobject]@{ ArtifactUri = $uri })

            { . $copyScript @copyInput } | Should -Throw '*invalid VHD artifact URI*'

            Should -Invoke Get-AzStorageAccount -Times 0 -Exactly
            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
        }

        It 'Preserves a non-terminating run-output lookup error' {
            $ErrorActionPreference = 'Continue'
            Mock Get-AzImageBuilderTemplateRunOutput { Write-Error 'Run-output lookup failed' }

            { . $copyScript @copyInput } | Should -Throw '*Run-output lookup failed*'

            Should -Invoke Get-AzStorageAccount -Times 0 -Exactly
            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
        }

        It 'Rejects missing storage accounts before copying' {
            Mock Get-AzStorageAccount {}

            { . $copyScript @copyInput } | Should -Throw '*source storage account*'

            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
        }

        It 'Preserves a non-terminating copy submission error' {
            $ErrorActionPreference = 'Continue'
            Mock Start-AzStorageBlobCopy { Write-Error 'Blob copy submission failed' }

            { . $copyScript @copyInput -WaitForComplete } | Should -Throw '*Blob copy submission failed*'

            Should -Invoke Get-AzStorageBlobCopyState -Times 0 -Exactly
        }

        It 'Rejects a copy that ends in <state>' -ForEach @(
            @{ state = 'Failed' }
            @{ state = 'Aborted' }
            @{ state = 'Pending' }
        ) {
            Mock Get-AzStorageBlobCopyState { [pscustomobject]@{ Status = $state; StatusDescription = 'Copy provider diagnostic' } }

            { . $copyScript @copyInput -WaitForComplete } | Should -Throw "*$state*Copy provider diagnostic*"
        }

        It 'Rejects a missing copy status' {
            Mock Get-AzStorageBlobCopyState {}

            { . $copyScript @copyInput -WaitForComplete } | Should -Throw '*Expected exactly one blob copy status*'
        }

        It 'Preserves a non-terminating copy status error' {
            $ErrorActionPreference = 'Continue'
            Mock Get-AzStorageBlobCopyState { Write-Error 'Blob copy status lookup failed' }

            { . $copyScript @copyInput -WaitForComplete } | Should -Throw '*Blob copy status lookup failed*'
        }

        It 'Does not copy with WhatIf' {
            . $copyScript @copyInput -WhatIf

            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
        }

        It 'Does not wait for a copy that WhatIf did not start' {
            . $copyScript @copyInput -WhatIf -WaitForComplete

            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
            Should -Invoke Get-AzStorageBlobCopyState -Times 0 -Exactly
        }
    }
}
