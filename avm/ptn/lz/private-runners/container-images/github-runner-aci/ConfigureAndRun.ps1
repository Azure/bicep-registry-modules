$token = $env:GH_RUNNER_TOKEN
$url = $env:GH_RUNNER_URL
$runnerName = $env:GH_RUNNER_NAME
$runnerGroup = $env:GH_RUNNER_GROUP
$runnerMode = $env:GH_RUNNER_MODE

$hasRunnerGroup = ($null -ne $runnerGroup -and $runnerGroup -ne "")
$isEphemeral = $true

if($null -ne $runnerMode -and $runnerMode -ne "" -and $runnerMode.ToLower() -eq "persistent") {
    $isEphemeral = $false
}

# Get the runner registration token from the GitHub API if a PAT is supplied
$isPat = $false
if($token.StartsWith("ghp_") -or $token.StartsWith("github_pat_")) {
    $isPat = $true
}

if($isPat) {
    $githubUrlSplit = $url.Split("/", [System.StringSplitOptions]::RemoveEmptyEntries)
    $githubOrgRepoSegment = ""
    $tokenApiUrl = ""
    $tokenType = ""

    if($githubUrlSplit.Length -eq 3) {
        $githubOrgRepoSegment = $githubUrlSplit[-1]
        $tokenType = "orgs"
    } else {
        $githubOrgRepoSegment = $githubUrlSplit[-2] + "/" + $githubUrlSplit[-1]
        $tokenType = "repos"
    }

    $tokenApiUrl = "https://api.github.com/$($tokenType)/$($githubOrgRepoSegment)/actions/runners/registration-token"

    Write-Host "Generating a new runner registration token using the supplied PAT from the url $tokenApiUrl"

    $headers = @{}
    $headers.Add("Authorization", "bearer $token")
    $headers.Add("Accept", "application/vnd.github.v3+json")

    $token = (Invoke-RestMethod -Uri $tokenApiUrl -Headers $headers -Method Post).token
}

# Register the runner
$env:RUNNER_ALLOW_RUNASROOT = "1"
if($hasRunnerGroup) {
    if($isEphemeral) {
        Write-Host "Registering the runner $runnerName with the runner group $runnerGroup and ephemeral mode"
        ./config.sh --unattended --replace --url $url --token $token --name $runnerName --runnergroup $runnerGroup --ephemeral
    } else {
        Write-Host "Registering the runner $runnerName with the runner group $runnerGroup"
        ./config.sh --unattended --replace --url $url --token $token --name $runnerName --runnergroup $runnerGroup
    }
} else {
    if($isEphemeral) {
        Write-Host "Registering the runner $runnerName in ephemeral mode"
        ./config.sh --unattended --replace --url $url --token $token --name $runnerName --ephemeral
    } else {
        Write-Host "Registering the runner $runnerName"
        ./config.sh --unattended --replace --url $url --token $token --name $runnerName
    }
}

./run.sh
