#################################################
## Post-deployment configuration persistence  ##
#################################################
##
## Validates that static (restart-required) PostgreSQL server parameters requested during
## deployment are actually persisted on the server. Guards against the regression described
## in GitHub issue #7270, where static configurations reported success but kept their old value.
##
#################################################

param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Static configuration persistence' {

    BeforeAll {
        $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.Parent.Parent.Parent.Parent.Parent.FullName
        . (Join-Path $repoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Invoke-DeploymentRead.ps1')

        $script:serverResourceId = $TestInputData.DeploymentOutputs.serverResourceId.Value
        $script:apiVersion = '2025-08-01'
    }

    It 'Static configuration [<name>] should be persisted with the requested value [<value>]' -TestCases @(
        $TestInputData.DeploymentOutputs.expectedConfigurations.Value | ForEach-Object {
            @{ name = $_.name; value = $_.value }
        }
    ) {
        param($name, $value)

        $response = Invoke-DeploymentRead -Read {
            Invoke-AzRestMethod -Method 'GET' -Path ('{0}/configurations/{1}?api-version={2}' -f $serverResourceId, $name, $apiVersion) -ErrorAction Stop
        }
        $response.StatusCode | Should -Be 200 -Because "the configuration [$name] must be retrievable after deployment"

        $actualValue = ($response.Content | ConvertFrom-Json).properties.value
        $actualValue | Should -Be $value -Because "the static server parameter [$name] must reflect the requested value after deployment"
    }
}
