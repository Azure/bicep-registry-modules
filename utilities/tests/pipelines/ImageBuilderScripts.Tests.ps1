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
