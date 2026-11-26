param(
    [Parameter()]
    [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
)

Describe 'PR label automation cleanup' {
    BeforeAll {
        $policy = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'policies' 'eventResponder.yml') -Raw | ConvertFrom-Yaml
        $tasks = @($policy.configuration.resourceManagementConfiguration.eventResponderTasks)
        $fabricbot = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'fabricbot.json') -Raw | ConvertFrom-Json
    }

    It 'limits issue comment label actions to issues' {
        $commentTasks = @($tasks | Where-Object {
                ($_.if | ConvertTo-Json -Depth 20) -match 'Issue_Comment' -and
                ($_.then | ConvertTo-Json -Depth 20) -match 'addLabel|removeLabel'
            })
        $commentTasks.Count | Should -Be 6
        foreach ($task in $commentTasks) {
            $task.if | Should -Contain 'isIssue'
        }
        @($fabricbot | Where-Object { $_.subCapability -eq 'IssueCommentResponder' }).Count | Should -Be 0
    }

    It 'preserves issue-only legacy label transitions' {
        $feedback = @($tasks | Where-Object description -eq 'Replace legacy author feedback label when an issue author comments')
        $stale = @($tasks | Where-Object description -eq 'Remove legacy no recent activity label when an issue is commented on')
        $feedback.Count | Should -Be 1
        $stale.Count | Should -Be 1
        ($feedback[0].then | ConvertTo-Json -Depth 20) | Should -Match 'Needs: Attention :wave:'
        ($feedback[0].then | ConvertTo-Json -Depth 20) | Should -Match 'Needs: Author Feedback'
        ($stale[0].then | ConvertTo-Json -Depth 20) | Should -Match 'Status: No Recent Activity'
    }

    It 'suppresses default Dependabot PR labels' {
        $dependabot = Get-Content -LiteralPath (Join-Path $RepoRootPath '.github' 'dependabot.yml') -Raw | ConvertFrom-Yaml
        $actions = @($dependabot.updates | Where-Object { $_.'package-ecosystem' -eq 'github-actions' })
        $actions.Count | Should -Be 1
        $actions[0].ContainsKey('labels') | Should -BeTrue
        $actions[0].labels.Count | Should -Be 0
    }
}
