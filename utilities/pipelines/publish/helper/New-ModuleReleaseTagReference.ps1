function Get-ModuleReleaseTagRemoteCommit {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TagName,

        [Parameter()]
        [string] $Remote = 'origin'
    )

    $references = @(
        & git ls-remote --tags $Remote "refs/tags/$TagName" "refs/tags/$TagName^{}" 2>&1 |
        ForEach-Object { $_.ToString() }
    )
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to query release tag [$TagName] from remote [$Remote]. Git output: $($references -join [Environment]::NewLine)"
    }

    $directCommit = $null
    $peeledCommit = $null
    foreach ($reference in $references) {
        if ($reference -notmatch '^([0-9a-fA-F]{40,64})\s+(.+)$') {
            continue
        }

        if ($matches[2] -eq "refs/tags/$TagName^{}") {
            $peeledCommit = $matches[1]
        } elseif ($matches[2] -eq "refs/tags/$TagName") {
            $directCommit = $matches[1]
        }
    }

    return $peeledCommit ?? $directCommit
}

function Invoke-ModuleReleaseTagGitHubApi {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Repository,

        [Parameter(Mandatory)]
        [string] $TagName,

        [Parameter(Mandatory)]
        [string] $TargetCommit,

        [Parameter()]
        [string] $GitHubToken = ($env:GH_TOKEN ?? $env:GITHUB_TOKEN)
    )

    if ([string]::IsNullOrWhiteSpace($Repository)) {
        throw 'The GitHub repository is required to create a release tag.'
    }
    if ([string]::IsNullOrWhiteSpace($GitHubToken)) {
        throw 'A GitHub token is required to create a release tag.'
    }

    $requestInput = @{
        Uri         = "https://api.github.com/repos/$Repository/git/refs"
        Method      = 'Post'
        ErrorAction = 'Stop'
        Headers     = @{
            Accept                 = 'application/vnd.github+json'
            Authorization          = "Bearer $GitHubToken"
            'X-GitHub-Api-Version' = '2022-11-28'
        }
        ContentType = 'application/json'
        Body        = @{
            ref = "refs/tags/$TagName"
            sha = $TargetCommit
        } | ConvertTo-Json -Compress
    }

    Invoke-RestMethod @requestInput | Out-Null
}

function New-ModuleReleaseTagReference {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $TagName,

        [Parameter(Mandatory)]
        [string] $TargetCommit,

        [Parameter()]
        [string] $Repository = $env:GITHUB_REPOSITORY,

        [Parameter()]
        [string] $Remote = 'origin'
    )

    $existingCommit = Get-ModuleReleaseTagRemoteCommit -TagName $TagName -Remote $Remote
    if ($existingCommit) {
        if ($existingCommit -eq $TargetCommit) {
            Write-Verbose "Tag [$TagName] already exists at the target commit." -Verbose
            return
        }

        throw "Tag [$TagName] already exists at a different commit [$existingCommit]."
    }

    try {
        Invoke-ModuleReleaseTagGitHubApi `
            -Repository $Repository `
            -TagName $TagName `
            -TargetCommit $TargetCommit
        return
    } catch {
        $creationError = $_
    }

    $concurrentCommit = Get-ModuleReleaseTagRemoteCommit -TagName $TagName -Remote $Remote
    if ($concurrentCommit -eq $TargetCommit) {
        Write-Verbose "Tag [$TagName] was concurrently created at the target commit." -Verbose
        return
    }
    if ($concurrentCommit) {
        throw "Tag [$TagName] was concurrently created at a different commit [$concurrentCommit]."
    }

    throw "Failed to create release tag [$TagName] through the GitHub API. Error: $($creationError.Exception.Message)"
}
