<#
.SYNOPSIS
Fetch general information about the repository, such as the number of open issues, watchers, etc.

.DESCRIPTION
Fetch general information about the repository, such as the number of open issues, watchers, etc.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub / Azure DevOps. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER RepositoryOwner
Mandatory. The repository's organization.

.PARAMETER RepositoryName
Mandatory. The name of the repository in the organization to query.

.EXAMPLE
Get-RepoInfo -RepositoryOwner 'Azure' -RepositoryName 'bicep-registry-modules'

Fetch the metadata of repository [Azure/bicep-registry-modules].
#>
function Get-RepoInfo {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName
    )

    $queryUrl = "/repos/$RepositoryOwner/$RepositoryName"
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
        # Using GH API instead of e.g., 'gh workflow list' to get all results instead of just the first few
        $requestInputObject = @(
            '-H', 'Accept: application/vnd.github+json',
            '-H', 'X-GitHub-Api-Version: 2022-11-28',
            $queryUrl
        )
        $response = (gh api @requestInputObject | ConvertFrom-Json)
    }

    if (-not $response) {
        Write-Error "Request failed. Response: [$response]"
    }

    return $response
}
