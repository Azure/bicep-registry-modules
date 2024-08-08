<#
.SYNOPSIS
Toggle the state of GitHub workflows in a given repository to either being enabled or disabled.

.DESCRIPTION
Toggle the state of GitHub workflows in a given repository to either being enabled or disabled.

.PARAMETER TargetState
Mandatory. The state to set the workflows to. Must be either 'enable' or 'disable'.

.PARAMETER RepositoryOwner
Mandatory. The owning organization of the repository. For example, 'MyOrg'.

.PARAMETER RepositoryName
Optional. The name of the repository. Defaults to 'bicep-registry-modules'.

.PARAMETER IncludePattern
Optional. A regex pattern to match against the workflow names. Defaults to 'avm\.(?:res|ptn|utl)' - avm.res, avm.ptn & avm.utl.

.PARAMETER ExlcudePattern
Optional. A regex pattern that should not match against the workflow names. Defaults to '^$' - empty.

.PARAMETER GitHubToken
Optional. The GitHub PAT token to use for authentication when interacting with GitHub. If not provided, the PAT must be available in the environment variable 'GH_TOKEN'

.EXAMPLE
Switch-WorkflowState -RepositoryOwner 'Paul' -RepositoryName 'bicep-registry-modules' -TargetState 'enable' -GitHubToken ('iAmAToken' | ConvertTo-SecureString -AsPlainText -Force)

Enable any AVM res/ptn/utl workflow in the [Paul/bicep-registry-modules] repository that is not in state 'active' using a custom GitHub PAT token.

.EXAMPLE
Switch-WorkflowState -RepositoryOwner 'Paul' -RepositoryName 'bicep-registry-modules' -TargetState 'disable'

Disable any workflow in the [Paul/bicep-registry-modules] repository that has the state 'active', assuming you have a GitHub PAT token 'GH_TOKEN' set in your environment.

.EXAMPLE
Switch-WorkflowState -RepositoryOwner 'Paul' -RepositoryName 'bicep-registry-modules' -TargetState 'disable' -IncludePattern 'avm\.res\.network\.'

Disable any workflow with a naming matching [avm.res.network*] in the [Paul/bicep-registry-modules] repository that has the state 'active', assuming you have a GitHub PAT token 'GH_TOKEN' set in your environment.

.EXAMPLE
Switch-WorkflowState -RepositoryOwner 'Paul' -RepositoryName 'bicep-registry-modules' -TargetState 'disable' -IncludePattern 'avm\.res\.network' -ExlcudePattern 'avm\.res\.network\.virtual-network'

Disable any workflow with a naming matching [avm.res.network*] but exluding those that match the name [avm.res.network.virtual-network] in the [Paul/bicep-registry-modules] repository that has the state 'active', assuming you have a GitHub PAT token 'GH_TOKEN' set in your environment.
#>
function Switch-WorkflowState {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('enable', 'disable')]
        [string] $TargetState,

        [Parameter(Mandatory = $true)]
        [string] $RepositoryOwner,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'bicep-registry-modules',

        [Parameter(Mandatory = $false)]
        [string] $IncludePattern = 'avm\.(?:res|ptn|utl)',

        [Parameter(Mandatory = $false)]
        [string] $ExlcudePattern = '^$',

        [Parameter(Mandatory = $false)]
        [secureString] $GitHubToken
    )

    if (-not [String]::IsNullOrEmpty($GitHubToken)) {
        $env:GH_TOKEN = $GitHubToken | ConvertFrom-SecureString -AsPlainText
    }

    $repo = "$RepositoryOwner/$RepositoryName"

    if ($repo -eq 'Azure/bicep-registry-modules') {
        throw 'Function should not run for [Azure/bicep-registry-modules].'
    }

    $workflows = gh workflow list --repo $repo --all --json 'name,state,id' --limit 999 | ConvertFrom-Json -Depth 100
    $relevantWorkflows = $workflows | Where-Object {
        $_.name -match $IncludePattern -and $_.name -notmatch $ExlcudePattern
    }

    if ($TargetState -eq 'disable') {
        foreach ($workflow in ($relevantWorkflows | Where-Object { $_.state -eq 'active' })) {
            gh workflow $TargetState $workflow.id --repo $repo
            Write-Verbose ('- Disabled workflow [{0}]' -f $workflow.name)
        }
    } else {
        foreach ($workflow in ($relevantWorkflows | Where-Object { $_.state -ne 'active' })) {
            gh workflow $TargetState $workflow.id --repo $repo
            Write-Verbose ('+ Enabled workflow [{0}]' -f $workflow.name)
        }
    }
}
