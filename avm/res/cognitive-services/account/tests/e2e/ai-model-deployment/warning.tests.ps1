######################################
## Additional post-deployment tests ##
######################################
##
## You can add any custom post-deployment validation tests you want here, or add them spread accross multiple test files in the test case folder.
##
###########################

param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Warning' {

    It 'Disabled test' {

        Write-Output @{
            Warning = "Note, the OpenAI-Deployments test is temporarily disabled as it needs to be enabled on the subscription.<br>As we don't want other contributions from being blocked by this, we disabled the test for now / rely on a manual execution outside the CI environemnt. For more information please review the [offical docs](https://learn.microsoft.com/en-us/legal/cognitive-services/openai/limited-access) and or register [here](https://aka.ms/oai/access"

        }
    }
}

