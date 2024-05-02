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

Describe 'Warn about disabled test' {

    It 'Inner' {

        $warningMessage = @'
Note, this test is temporarily disabled as it needs to be enabled on the subscription.
As we don't want other contributions from being blocked by this, we disabled the test for now / rely on a manual execution outside the CI environemnt
You can find more information here: https://learn.microsoft.com/en-us/legal/cognitive-services/openai/limited-access
And register here: https://aka.ms/oai/access
'@

        Write-Warning $warningMessage -Verbose
    }
}

