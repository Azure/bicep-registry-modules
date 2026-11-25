#################################################
## Post-deployment configuration persistence   ##
#################################################
##
## Validates that the Git repository configuration requested during deployment is actually
## persisted on the Data Factory. Guards against the regression where the resource provider
## accepted the deployment but silently discarded the repository configuration.
##
#################################################

param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Git repository configuration persistence' {

    BeforeAll {
        $script:response = Invoke-AzRestMethod -Method 'GET' -Path ('{0}?api-version=2018-06-01' -f $TestInputData.DeploymentOutputs.dataFactoryResourceId.Value)
        $script:repoConfiguration = ($script:response.Content | ConvertFrom-Json).properties.repoConfiguration
    }

    It 'The Data Factory should be retrievable after deployment' {
        $response.StatusCode | Should -Be 200 -Because 'the post-deployment test must be able to read back the deployed Data Factory'
    }

    It 'The Data Factory should have a Git repository configuration persisted' {
        $repoConfiguration | Should -Not -BeNullOrEmpty -Because 'the deployment requested a Git repository configuration'
    }

    It 'Git repository configuration property [<name>] should be [<value>]' -TestCases @(
        $TestInputData.DeploymentOutputs.expectedGitConfiguration.Value | ForEach-Object {
            @{ name = $_.name; value = $_.value }
        }
    ) {
        param($name, $value)

        $repoConfiguration.$name | Should -Be $value -Because "the property [$name] must reflect the requested value after deployment"
    }
}
