<#
.SYNOPSIS
Get a list of all GitHub module workflows

.DESCRIPTION
Get a list of all GitHub module workflows. Does not return all properties but only the relevant ones.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub / Azure DevOps. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository to fetch the workflows from.

.PARAMETER IncludeDisabled
Optional. Set if you want to also include disabled workflows in the result.

.PARAMETER Filter
Optional. A regex filter to apply when fetching the workflows. By default we fetch all module workflows.

.EXAMPLE
Get-GitHubModuleWorkflowList -PersonalAccessToken '<Placeholder>' -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules'

Get all module workflows from repository 'Azure/bicep-registry-modules'
#>
function Get-GitHubModuleWorkflowList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [switch] $IncludeDisabled,

        [Parameter(Mandatory = $false)]
        [string] $Filter = 'avm\.(?:res|ptn|utl)'
    )

    $allWorkflows = @()

    $page = 1
    do {
        $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/actions/workflows?per_page=100&page=$page"
        if ($PersonalAccessToken) {
            # Using PAT
            $requestInputObject = @{
                Method  = 'GET'
                Uri     = "https://api.github.com$queryUrl"
                Headers = @{
                    Authorization = "Bearer $PersonalAccessToken"
                }
            }
            $response = Invoke-RestMethod @requestInputObject
        } else {
            # Using GH API instead of 'gh workflow list' to get all results instead of just the first few
            $requestInputObject = @(
                '-H', 'Accept: application/vnd.github+json',
                '-H', 'X-GitHub-Api-Version: 2022-11-28',
                $queryUrl
            )
            $response = (gh api @requestInputObject | ConvertFrom-Json)
        }

        if (-not $response.workflows) {
            Write-Error "Request failed. Response: [$response]"
        }

        $allWorkflows += $response.workflows | Select-Object -Property @('id', 'name', 'path', 'badge_url', 'state') | Where-Object {
            $_.name -match $Filter -and
            ($IncludeDisabled ? $true : $_.state -eq 'active')
        }

        $expectedPages = [math]::ceiling($response.total_count / 100)
        $page++
    } while ($page -le $expectedPages)

    return $allWorkflows
}
