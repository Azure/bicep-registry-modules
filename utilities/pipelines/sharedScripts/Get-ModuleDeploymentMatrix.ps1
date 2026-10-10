<#
.SYNOPSIS
Assign test subscriptions and deployment locks before scheduling deployment jobs.

.DESCRIPTION
Preserves seeded round-robin selection while exposing only pool positions and ID digests.
Ignored tests use unique groups and do not share deployment locks.
Subscription locks are invariant across revisions. Management-group and tenant scopes, plus
linked or expression-based templates, additionally require a shared deployment-phase lock.
#>
function Get-ModuleDeploymentMatrix {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [hashtable[]] $TestFilePaths,

        [Parameter()]
        [string] $TestSubscriptionIds,

        [Parameter()]
        [string] $FallbackSubscriptionId,

        [Parameter(Mandatory)]
        [ValidateRange(0, 2147483647)]
        [int] $RandomSeed,

        [Parameter()]
        [switch] $DisplaySubscriptionNames,

        [Parameter()]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
    )

    . (Join-Path $PSScriptRoot 'Get-TestSubscriptionList.ps1')
    . (Join-Path $PSScriptRoot 'Get-ScopeOfTemplateFile.ps1')
    . (Join-Path $PSScriptRoot 'Get-NestedResourceList.ps1')

    $activeTests = @($TestFilePaths | Where-Object { $_.e2eIgnore -ne $true -and $_.e2eIgnore -ne 'true' })
    $sharedScope = $false
    if ($activeTests.Count -gt 0) {
        if (-not [string]::IsNullOrEmpty($TestSubscriptionIds) -and [string]::IsNullOrWhiteSpace($TestSubscriptionIds)) {
            throw 'The configured test subscription pool must not contain only whitespace.'
        }
        $subscriptions = @(Get-TestSubscriptionList -TestSubscriptionIds $TestSubscriptionIds -FallbackSubscriptionId $FallbackSubscriptionId -RandomSeed $RandomSeed)

        foreach ($test in $activeTests) {
            $templateFilePath = Join-Path $RepoRoot $ModulePath $test.path
            $compiledTemplate = bicep build $templateFilePath --stdout
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to compile test template [$templateFilePath] for deployment scope discovery."
            }
            $template = ConvertFrom-Json -InputObject ($compiledTemplate -join [Environment]::NewLine) -AsHashtable
            $templates = @($template)
            foreach ($deployment in (Get-NestedResourceList -TemplateFileContent $template | Where-Object { $_.type -eq 'Microsoft.Resources/deployments' })) {
                if ($deployment.properties.templateLink -or $deployment.properties.template -is [string]) {
                    $sharedScope = $true
                } elseif ($deployment.properties.template) {
                    $templates += $deployment.properties.template
                }
            }
            foreach ($scopeTemplate in $templates) {
                if ((Get-ScopeOfTemplateFile -TemplateFileContent $scopeTemplate) -in @('managementgroup', 'tenant')) {
                    $sharedScope = $true
                }
            }
        }
    }

    $moduleKey = $ModulePath.Replace('\', '/').Trim('/').ToLowerInvariant()
    $matrix = @(for ($jobIndex = 0; $jobIndex -lt $TestFilePaths.Count; $jobIndex++) {
        $test = $TestFilePaths[$jobIndex]
        $ignored = $test.e2eIgnore -eq $true -or $test.e2eIgnore -eq 'true'
        $entry = @{
            path              = $test.path
            name              = $test.name
            e2eIgnore         = $ignored
            subscriptionIndex = ''
            subscriptionKey   = ''
            subscriptionName  = 'Deployment disabled'
            concurrencyGroup  = "avm-deploy-$moduleKey-ignored-$([guid]::NewGuid().ToString('N'))"
        }
        if (-not $ignored) {
            $subscription = $subscriptions[$jobIndex % $subscriptions.Count]
            $entry.subscriptionIndex = $subscription.index
            $entry.subscriptionKey = $subscription.key
            $entry.subscriptionName = $DisplaySubscriptionNames ? $subscription.name : "Configured subscription $($subscription.index + 1)"
            $entry.concurrencyGroup = "avm-deploy-$moduleKey-$($subscription.key)"
        }
        $entry
    })

    return @{
        testCases   = $matrix
        sharedScope = $sharedScope
    }
}
