param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI host image builder' {
    BeforeAll {
        $builderRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci'
        $buildScript = Join-Path $builderRoot 'Invoke-HciHostImageBuild.ps1'
        $builderTemplate = Join-Path $builderRoot 'hciHostGalleryBuilder.bicep'

        function Get-AzContext {
            [pscustomobject] @{ Subscription = [pscustomobject] @{ Id = 'subscription-id' } }
        }

        function Set-AzContext {
            param ([string] $SubscriptionId)
        }

        function Invoke-AzRestMethod {
            param ([string] $Method, [string] $Path)
            throw 'Invoke-AzRestMethod must be mocked.'
        }

        function New-AzSubscriptionDeployment {
            param (
                [string] $Name,
                [string] $Location,
                [string] $TemplateFile,
                [hashtable] $TemplateParameterObject
            )
            throw 'New-AzSubscriptionDeployment must be mocked.'
        }
    }

    BeforeEach {
        $script:templateStartTime = [datetimeoffset] '2026-10-08T12:00:00Z'
        Mock Set-AzContext {}
        Mock Start-Sleep {}
        Mock New-AzSubscriptionDeployment {
            [pscustomobject] @{ ProvisioningState = 'Succeeded' }
        }
    }

    It 'Preserves the stable external defaults in the subscription template' {
        $templateText = Get-Content -LiteralPath $builderTemplate -Raw

        $templateText | Should -Match "param location string = 'southeastasia'"
        $templateText | Should -Match "param resourceGroupName string = 'rg-avm-persistent-hci-image'"
        $templateText | Should -Match "param galleryName string = 'galavmpersistenthci'"
        $templateText | Should -Match "param imageDefinitionName string = 'hci-host-image'"
        $templateText | Should -Match "param imageVersion string = '26.1.0'"
        $templateText | Should -Match 'param buildTimeoutInMinutes int = 570'
        $templateText | Should -Match 'https://azlocalvhds\.blob\.\$\{environment\(\)\.suffixes\.storage\}/images/AzLocal2601\.vhdx'
    }

    It 'Skips deployment and build when the deterministic version already succeeded' {
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{
                StatusCode = 200
                Content = @{
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{ excludeFromLatest = $false }
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        $result = . $buildScript -AssetBaseUri 'https://example.test/assets'

        $result.BuildStatus | Should -Be 'Skipped'
        $result.BuildStarted | Should -BeFalse
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'GET' }
    }

    It 'Deploys, starts, and verifies a newly published version' {
        $script:templateGetCount = 0
        $script:versionGetCount = 0
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'POST') {
                return [pscustomobject] @{ StatusCode = 202; Content = '' }
            }

            if ($Path -like '*/imageTemplates/*') {
                $script:templateGetCount++
                if ($script:templateGetCount -eq 1) {
                    return [pscustomobject] @{ StatusCode = 404; Content = '' }
                }
                return [pscustomobject] @{
                    StatusCode = 200
                    Content = @{
                        properties = @{
                            lastRunStatus = @{
                                startTime = if ($script:templateGetCount -eq 2) {
                                    $script:templateStartTime.AddHours(-1).ToString('o')
                                } else {
                                    $script:templateStartTime.ToString('o')
                                }
                                runState = if ($script:templateGetCount -lt 4) { 'Running' } else { 'Succeeded' }
                                message = ''
                            }
                        }
                    } | ConvertTo-Json -Depth 5
                }
            }

            $script:versionGetCount++
            if ($script:versionGetCount -eq 1) {
                return [pscustomobject] @{ StatusCode = 404; Content = '' }
            }
            return [pscustomobject] @{
                StatusCode = 200
                Content = @{
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{ excludeFromLatest = $false }
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        $result = . $buildScript -AssetBaseUri 'https://example.test/assets'

        $result.BuildStatus | Should -Be 'Succeeded'
        $result.BuildStarted | Should -BeTrue
        Should -Invoke New-AzSubscriptionDeployment -Times 1 -Exactly -ParameterFilter {
            $Location -eq 'southeastasia' -and
            $TemplateParameterObject.resourceGroupName -eq 'rg-avm-persistent-hci-image' -and
            $TemplateParameterObject.galleryName -eq 'galavmpersistenthci' -and
            $TemplateParameterObject.imageDefinitionName -eq 'hci-host-image' -and
            $TemplateParameterObject.imageVersion -eq '26.1.0' -and
            $TemplateParameterObject.buildTimeoutInMinutes -eq 570
        }
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Resumes an active image build without deploying or submitting another run' {
        $script:templateGetCount = 0
        $script:versionGetCount = 0
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'POST') {
                return [pscustomobject] @{ StatusCode = 202; Content = '' }
            }

            if ($Path -like '*/imageTemplates/*') {
                $script:templateGetCount++
                return [pscustomobject] @{
                    StatusCode = 200
                    Content = @{
                        properties = @{
                            lastRunStatus = @{
                                startTime = $script:templateStartTime.ToString('o')
                                runState = if ($script:templateGetCount -lt 3) { 'Pending' } else { 'Succeeded' }
                                message = ''
                            }
                        }
                    } | ConvertTo-Json -Depth 5
                }
            }

            $script:versionGetCount++
            if ($script:versionGetCount -eq 1) {
                return [pscustomobject] @{ StatusCode = 404; Content = '' }
            }
            return [pscustomobject] @{
                StatusCode = 200
                Content = @{
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{ excludeFromLatest = $false }
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        $result = . $buildScript -AssetBaseUri 'https://example.test/assets'

        $result.BuildStatus | Should -Be 'Succeeded'
        $result.BuildStarted | Should -BeFalse
        Should -Invoke New-AzSubscriptionDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'POST' }
    }

    It 'Rejects an unsuccessful image build with provider diagnostics' {
        $script:templateGetCount = 0
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'POST') {
                return [pscustomobject] @{ StatusCode = 202; Content = '' }
            }

            if ($Path -like '*/versions/*') {
                return [pscustomobject] @{ StatusCode = 404; Content = '' }
            }

            $script:templateGetCount++
            if ($script:templateGetCount -eq 1) {
                return [pscustomobject] @{ StatusCode = 404; Content = '' }
            }
            return [pscustomobject] @{
                StatusCode = 200
                Content = @{
                    properties = @{
                        lastRunStatus = @{
                            startTime = if ($script:templateGetCount -eq 2) {
                                $script:templateStartTime.AddHours(-1).ToString('o')
                            } else {
                                $script:templateStartTime.ToString('o')
                            }
                            runState = if ($script:templateGetCount -eq 2) { 'Succeeded' } else { 'Failed' }
                            message = 'PackerBuildFailed: payload download failed'
                        }
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        {
            . $buildScript -AssetBaseUri 'https://example.test/assets'
        } | Should -Throw '*Failed*PackerBuildFailed: payload download failed*'
    }
}
