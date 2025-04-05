function Get-GitHubIssueList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $PersonalAccessToken,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('open', 'closed', 'all')]
        [string] $State = 'open',

        [Parameter(Mandatory = $false)]
        [string] $Assignee = '*',

        [Parameter(Mandatory = $false)]
        [ValidateSet('created', 'updated', 'comments')]
        [string] $SortBy = 'created',

        [Parameter(Mandatory = $false)]
        [ValidateSet('asc', 'desc')]
        [string] $SortDirection = 'desc'
    )

    $allIssues = @()

    $page = 1
    do {
        $queryParameters = @(
            "sort=$SortBy",
            "direction=$SortDirection",
            "assignee=$Assignee",
            "state=$State",
            'per_page=100',
            "page=$page"
        ) -join '&'
        $queryUrl = "/repos/$RepositoryOwner/$RepositoryName/issues?$queryParameters"
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
            $response = (gh api @requestInputObject | ConvertFrom-Json -AsHashtable)
        }

        $allIssues += $response | Where-Object {
            # In the API, PRs are considered issues too. See 'Note' at https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#get-an-issue
            $_.Keys -notcontains 'pull_request'
        }

        $page++
    } while ($response)

    return $allIssues
}
