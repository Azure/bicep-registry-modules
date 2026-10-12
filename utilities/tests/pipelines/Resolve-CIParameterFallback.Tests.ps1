param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'Resolve-CIParameterFallback' {

    BeforeAll {
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Resolve-CIParameterFallback.ps1')

        function Invoke-AzRestMethod {
            [CmdletBinding()]
            param([string] $Method, [string] $Path)
            throw 'Unexpected Azure REST access.'
        }

        $templateParameters = @{
            hciHostImageReferenceId = @{ type = 'secureString' }
        }
        $variables = @{
            VALIDATE_PERSISTENT_SUBSCRIPTION_ID = '6309aab3-10ef-496c-a60f-b009c280611a'
        } | ConvertTo-Json -Compress
    }

    BeforeEach {
        Mock Invoke-AzRestMethod { throw 'Unexpected Azure REST access.' }
    }

    It 'Keeps an explicit HCI host image reference instead of performing a lookup' {
        $resolvedParameters = @{
            hciHostImageReferenceId = [securestring]::new()
        }

        $result = Resolve-CIParameterFallback -TemplateParameters $templateParameters `
            -ResolvedParameters $resolvedParameters -GitHubVariables $variables

        $result.Count | Should -Be 0
    }

    It 'Selects the newest successful usable image by published date' {
        $expectedId = '/subscriptions/test/resourceGroups/test/providers/Microsoft.Compute/galleries/galavmpersistenthci/images/hci-host-image/versions/1.9.0'
        $responseContent = @{
            value = @(
                @{
                    id = '/subscriptions/test/resourceGroups/test/providers/Microsoft.Compute/galleries/galavmpersistenthci/images/hci-host-image/versions/1.10.0'
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{
                            publishedDate = '2026-09-01T00:00:00Z'
                        }
                    }
                }
                @{
                    id = $expectedId
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{
                            publishedDate = '2026-10-01T00:00:00Z'
                        }
                    }
                }
                @{
                    id = '/subscriptions/test/resourceGroups/test/providers/Microsoft.Compute/galleries/galavmpersistenthci/images/hci-host-image/versions/2.0.0'
                    properties = @{
                        provisioningState = 'Creating'
                        publishingProfile = @{
                            publishedDate = '2026-10-03T00:00:00Z'
                        }
                    }
                }
                @{
                    id = '/subscriptions/test/resourceGroups/test/providers/Microsoft.Compute/galleries/galavmpersistenthci/images/hci-host-image/versions/3.0.0'
                    properties = @{
                        provisioningState = 'Succeeded'
                        publishingProfile = @{
                            excludeFromLatest = $true
                            publishedDate     = '2026-10-04T00:00:00Z'
                        }
                    }
                }
            )
        } | ConvertTo-Json -Depth 8 -Compress
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{
                StatusCode = 200
                Content    = $responseContent
            }
        }

        $result = Resolve-CIParameterFallback -TemplateParameters $templateParameters `
            -ResolvedParameters @{} -GitHubVariables $variables

        $result.hciHostImageReferenceId | Should -BeOfType [securestring]
        ConvertFrom-SecureString -SecureString $result.hciHostImageReferenceId -AsPlainText | Should -BeExactly $expectedId
        Should -Invoke Invoke-AzRestMethod -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'GET' -and
            $Path -eq '/subscriptions/6309aab3-10ef-496c-a60f-b009c280611a/resourceGroups/rg-avm-persistent-hci-image/providers/Microsoft.Compute/galleries/galavmpersistenthci/images/hci-host-image/versions?api-version=2024-03-03'
        }
    }

    It 'Returns no fallback when the gallery contains no versions' {
        Mock Invoke-AzRestMethod {
            [pscustomobject] @{
                StatusCode = 200
                Content    = '{"value":[]}'
            }
        }

        $result = Resolve-CIParameterFallback -TemplateParameters $templateParameters `
            -ResolvedParameters @{} -GitHubVariables $variables -WarningAction SilentlyContinue

        $result.Count | Should -Be 0
    }

    It 'Returns no fallback when the image lookup fails' {
        Mock Invoke-AzRestMethod { throw 'Access denied.' }

        $result = Resolve-CIParameterFallback -TemplateParameters $templateParameters `
            -ResolvedParameters @{} -GitHubVariables $variables -WarningVariable warnings -WarningAction SilentlyContinue

        $result.Count | Should -Be 0
        $warnings | Should -Match 'marketplace host fallback will be used'
        $warnings | Should -Match 'Access denied'
    }
}
