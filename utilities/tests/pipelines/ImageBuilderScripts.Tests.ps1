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

        Mock Install-Module {}
        Mock Get-Module {} -ParameterFilter { $Name -contains 'Az.ImageBuilder' -or $Name -contains 'Az.Storage' }
        Mock Get-InstalledModule {}
        Mock Write-Verbose {}
        Mock Start-AzImageBuilderTemplate {}
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
        Mock Get-AzStorageBlobCopyState {}
    }

    Context 'Starting an image build' {
        It 'Waits for the image build by default' {
            . $startScript @startInput

            Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly -ParameterFilter {
                $ImageTemplateName -eq 'build-template' -and $ResourceGroupName -eq 'build-rg' -and -not $NoWait
            }
        }

        It 'Preserves the explicit asynchronous option' {
            . $startScript @startInput -NoWait

            Should -Invoke Start-AzImageBuilderTemplate -Times 1 -Exactly -ParameterFilter { $NoWait }
        }

        It 'Does not start a build with WhatIf' {
            . $startScript @startInput -WhatIf

            Should -Invoke Start-AzImageBuilderTemplate -Times 0 -Exactly
        }

        It 'Propagates a non-terminating build error without reporting success' {
            $ErrorActionPreference = 'Continue'
            Mock Start-AzImageBuilderTemplate { Write-Error 'Image build failed: PackerBuildFailed' }

            { . $startScript @startInput } | Should -Throw '*Image build failed: PackerBuildFailed*'

            Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created/initialized*' }
        }

        It 'Propagates submission errors with NoWait' {
            $ErrorActionPreference = 'Continue'
            Mock Start-AzImageBuilderTemplate { Write-Error 'Image build submission failed' }

            { . $startScript @startInput -NoWait } | Should -Throw '*Image build submission failed*'

            Should -Invoke Write-Verbose -Times 0 -Exactly -ParameterFilter { $Message -like 'Created/initialized*' }
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
        }

        It 'Rejects ambiguous VHD outputs before accessing storage' {
            $script:runOutputs += [pscustomobject]@{ ArtifactUri = 'https://source.blob.core.windows.net/vhds/other.vhd' }

            { . $copyScript @copyInput } | Should -Throw '*Expected exactly one VHD artifact URI*found*2*'

            Should -Invoke Get-AzStorageAccount -Times 0 -Exactly
            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
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

        It 'Does not copy with WhatIf' {
            . $copyScript @copyInput -WhatIf

            Should -Invoke Start-AzStorageBlobCopy -Times 0 -Exactly
        }
    }
}
