param (
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'HCI host image builder' {
    BeforeAll {
        $assetRoot = Join-Path $RepoRootPath 'utilities' 'e2e-template-assets' 'module-specific' 'azure-stack-hci' 'image'
        $template = Join-Path $assetRoot 'main.bicep'
        $buildScript = Join-Path $assetRoot 'Invoke-HciImageBuild.ps1'
        . $buildScript

        function Invoke-AzRestMethod {
            param([string] $Method, [string] $Path, [object] $DefaultProfile)
            throw 'Invoke-AzRestMethod must be mocked.'
        }
    }

    BeforeEach {
        $script:requests = [Collections.Generic.List[object]]::new()
        Mock Start-Sleep {}
    }

    It 'Preserves the stable external defaults' {
        $content = Get-Content -LiteralPath $template -Raw

        $content | Should -Match "param location string = 'southeastasia'"
        $content | Should -Match "param resourceGroupName string = 'rg-avm-persistent-hci-image'"
        $content | Should -Match "param galleryName string = 'galavmpersistenthci'"
        $content | Should -Match "param imageDefinitionName string = 'hci-host-image'"
        $content | Should -Match "param imageVersion string = '26.1.0'"
    }

    It 'Skips a successful deterministic image version' {
        Mock Invoke-AzRestMethod {
            $script:requests.Add([pscustomobject]@{ Method = $Method; Path = $Path })
            [pscustomobject]@{
                StatusCode = 200
                Content = @{
                    properties = @{
                        provisioningState = 'Succeeded'
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        $result = Invoke-HciImageBuild `
            -ImageTemplateResourceId '/subscriptions/sub/resourceGroups/rg/providers/Microsoft.VirtualMachineImages/imageTemplates/template' `
            -ImageVersionResourceId '/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Compute/galleries/gallery/images/image/versions/26.1.0' `
            -Context 'context'

        $result.ready | Should -BeTrue
        $result.buildStarted | Should -BeFalse
        $script:requests.Count | Should -Be 1
        $script:requests[0].Method | Should -Be 'GET'
    }

    It 'Starts a missing image version and verifies publication' {
        $script:getCount = 0
        Mock Invoke-AzRestMethod {
            $script:requests.Add([pscustomobject]@{ Method = $Method; Path = $Path })
            if ($Method -eq 'POST') {
                return [pscustomobject]@{ StatusCode = 202; Content = '' }
            }

            $script:getCount++
            if ($script:getCount -eq 1) {
                return [pscustomobject]@{ StatusCode = 404; Content = '' }
            }
            if ($Path -like '*/imageTemplates/*') {
                return [pscustomobject]@{
                    StatusCode = 200
                    Content = @{
                        properties = @{
                            lastRunStatus = @{
                                runState = if ($script:getCount -lt 3) { '' } else { 'Succeeded' }
                                startTime = if ($script:getCount -lt 3) { '' } else { '2026-10-08T14:00:00Z' }
                            }
                        }
                    } | ConvertTo-Json -Depth 5
                }
            }
            [pscustomobject]@{
                StatusCode = 200
                Content = @{
                    properties = @{
                        provisioningState = 'Succeeded'
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        $result = Invoke-HciImageBuild `
            -ImageTemplateResourceId '/subscriptions/sub/resourceGroups/rg/providers/Microsoft.VirtualMachineImages/imageTemplates/template' `
            -ImageVersionResourceId '/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Compute/galleries/gallery/images/image/versions/26.1.0' `
            -Context 'context' `
            -TimeoutMinutes 1 `
            -PollIntervalSeconds 1

        $result.ready | Should -BeTrue
        $result.buildStarted | Should -BeTrue
        @($script:requests | Where-Object Method -eq 'POST').Count | Should -Be 1
    }

    It 'Rejects a failed image build with provider diagnostics' {
        $script:getCount = 0
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'POST') {
                return [pscustomobject]@{ StatusCode = 202; Content = '' }
            }
            $script:getCount++
            if ($script:getCount -eq 1) {
                return [pscustomobject]@{ StatusCode = 404; Content = '' }
            }
            if ($script:getCount -eq 2) {
                return [pscustomobject]@{
                    StatusCode = 200
                    Content = @{
                        properties = @{}
                    } | ConvertTo-Json -Depth 5
                }
            }
            [pscustomobject]@{
                StatusCode = 200
                Content = @{
                    properties = @{
                        lastRunStatus = @{
                            runState = 'Failed'
                            startTime = '2026-10-08T14:00:00Z'
                            message = 'PackerBuildFailed: payload download failed'
                        }
                    }
                } | ConvertTo-Json -Depth 5
            }
        }

        {
            Invoke-HciImageBuild `
                -ImageTemplateResourceId '/subscriptions/sub/resourceGroups/rg/providers/Microsoft.VirtualMachineImages/imageTemplates/template' `
                -ImageVersionResourceId '/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Compute/galleries/gallery/images/image/versions/26.1.0' `
                -Context 'context' `
                -TimeoutMinutes 1 `
                -PollIntervalSeconds 1
        } | Should -Throw '*PackerBuildFailed: payload download failed*'
    }
}
