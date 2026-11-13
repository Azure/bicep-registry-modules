param(
    [Parameter()]
    [string] $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.FullName,
    [array] $moduleFolderPaths
)

Describe 'Private analytical workspace diagnostic categories' {
    BeforeAll {
        . (Join-Path $repoRootPath 'avm' 'ptn' 'data' 'private-analytical-workspace' 'tests' 'common.tests.ps1')

        function Get-AzDiagnosticSetting {
            param($ResourceId, $Name)
            throw 'Azure calls must be mocked.'
        }

        function Get-AzDiagnosticSettingCategory {
            param($ResourceId)
            throw 'Azure calls must be mocked.'
        }
    }

    It 'Checks expected categories for <scenario>' -ForEach @(
        @{ scenario = 'existing categories in reverse order'; categories = @('clusters', 'dbfs'); accepted = $true }
        @{ scenario = 'additional Azure categories'; categories = @('dbfs', 'clusters', 'newCategory'); accepted = $true }
        @{ scenario = 'missing expected category despite matching count'; categories = @('dbfs', 'newCategory'); accepted = $false }
        @{ scenario = 'empty Azure response'; categories = @(); accepted = $false }
    ) {
        Mock Get-AzDiagnosticSetting {
            [pscustomobject]@{
                Type = 'Microsoft.Insights/diagnosticSettings'
                WorkspaceId = 'workspace-id'
            }
        }
        Mock Get-AzDiagnosticSettingCategory {
            foreach ($category in $categories) {
                [pscustomobject]@{ Name = $category }
            }
        }

        $verify = {
            Test-VerifyDiagSettings -ResourceId 'resource-id' -LogAnalyticsWorkspaceResourceId 'workspace-id' -Logs @('dbfs', 'clusters')
        }
        if ($accepted) {
            $verify | Should -Not -Throw
        } else {
            $verify | Should -Throw
        }
    }
}
