param ([string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName)

Describe 'Authoritative final deployment cleanup' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'Initialize-DeploymentRemoval.ps1')
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'helper' 'Get-DeploymentTargetResourceList.ps1')
        function Get-AzContext {}
        function Set-AzContext { param ($Subscription) }
        function Get-AzDeployment { param ($Name, $DefaultProfile) }
        function Invoke-AzRestMethod { param ($Method, $Path) }
    }

    BeforeEach {
        $subscriptionId = '11111111-1111-1111-1111-111111111111'
        $script:contextSubscriptionId = $subscriptionId
        $deploymentId = "/subscriptions/$subscriptionId/providers/Microsoft.Resources/deployments/neutral-fixture"
        $templatePath = Join-Path $TestDrive 'main.test.json'
        '{"$schema":"https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#","resources":[]}' |
            Set-Content -LiteralPath $templatePath
        $script:rootState = 'Succeeded'
        $script:recordRemoved = $false
        Mock Get-AzContext { @{ Subscription = @{ Id = $script:contextSubscriptionId } } }
        Mock Set-AzContext {}
        Mock Get-AzDeployment { @{ DeploymentName = 'neutral-fixture'; ProvisioningState = $script:rootState } }
        Mock Invoke-AzRestMethod {
            if ($Method -eq 'GET' -and $Path -eq "$deploymentId/operations?api-version=2025-04-01") {
                return @{ StatusCode = 200; Content = '{"value":[]}' }
            }
            if ($Method -eq 'DELETE' -and $Path -eq "${deploymentId}?api-version=2021-04-01") {
                $script:recordRemoved = $true
                return @{ StatusCode = 202; Content = '' }
            }
            if ($Method -eq 'GET' -and $Path -eq "${deploymentId}?api-version=2021-04-01" -and $script:recordRemoved) {
                return @{ StatusCode = 404; Content = '{"error":{"code":"DeploymentNotFound"}}' }
            }
            throw "Unexpected offline cleanup request [$Method $Path]."
        }
    }

    It 'Confirms complete final teardown of a successful root through the real cleanup helpers' {
        $result = Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
            -SubscriptionId $subscriptionId -RequireCompleteRemoval -FinalCleanup

        $result.RemovedDeploymentNames | Should -Be @('neutral-fixture')
        $script:recordRemoved | Should -BeTrue
    }

    It 'Keeps successful roots ineligible for failed-attempt retry cleanup' {
        { Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
                -SubscriptionId $subscriptionId -RequireCompleteRemoval } |
            Should -Throw '*Succeeded*cleanup cannot authorize regional relocation*'
        $script:recordRemoved | Should -BeFalse
    }

    It 'Allows failed terminal roots in <kind> cleanup' -ForEach @(
        @{ kind = 'final'; final = $true }
        @{ kind = 'retry'; final = $false }
    ) {
        $script:rootState = 'Failed'
        $result = Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
            -SubscriptionId $subscriptionId -RequireCompleteRemoval -FinalCleanup:$final
        $result.RemovedDeploymentNames | Should -Be @('neutral-fixture')
        $script:recordRemoved | Should -BeTrue
    }

    It 'Rejects final teardown of a <state> root without deleting evidence' -ForEach @(
        @{ state = 'Running' }, @{ state = 'Accepted' }, @{ state = 'Deleting' }
        @{ state = 'Canceled' }, @{ state = 'Unknown' }, @{ state = '' }
    ) {
        $script:rootState = $state
        { Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
                -SubscriptionId $subscriptionId -RequireCompleteRemoval -FinalCleanup } | Should -Throw
        $script:recordRemoved | Should -BeFalse
    }

    It 'Requires complete removal when final confirmation is selected' {
        { Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' -FinalCleanup } |
            Should -Throw '*requires complete discovery and removal*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Confirms an exact pending final deletion without rediscovering or deleting its resources again' {
        $script:recordRemoved = $true
        $result = Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
            -PendingDeletionDeploymentIds $deploymentId -RequireCompleteRemoval -FinalCleanup

        $result.RemovedDeploymentNames | Should -Be @('neutral-fixture')
        Should -Invoke Get-AzDeployment -Times 0 -Exactly
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
    }

    It 'Keeps pending final history deletion unconfirmed while its record remains visible' {
        Mock Start-Sleep {}
        Mock Invoke-AzRestMethod {
            @{ StatusCode = 200; Content = (@{ id = $deploymentId; properties = @{ provisioningState = 'Deleting' } } | ConvertTo-Json -Compress) }
        } -ParameterFilter { $Method -eq 'GET' -and $Path -eq "${deploymentId}?api-version=2021-04-01" }

        $failure = $null
        try {
            Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
                -PendingDeletionDeploymentIds $deploymentId -RequireCompleteRemoval -FinalCleanup
        } catch {
            $failure = $_
        }
        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Match 'still exists after cleanup'
        $failure.Exception.Data['PendingDeletionDeploymentIds'] | Should -Be @($deploymentId)
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly -ParameterFilter { $Method -eq 'DELETE' }
    }

    It 'Rejects pending metadata for another subscription during complete final cleanup' {
        $otherId = $deploymentId.Replace($subscriptionId, '22222222-2222-2222-2222-222222222222')
        { Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
                -PendingDeletionDeploymentIds $otherId -RequireCompleteRemoval -FinalCleanup } |
            Should -Throw '*original scope*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Keeps retry cleanup from accepting pending-deletion metadata' {
        { Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
                -PendingDeletionDeploymentIds $deploymentId -RequireCompleteRemoval } |
            Should -Throw '*only valid for final cleanup*'
        Should -Invoke Invoke-AzRestMethod -Times 0 -Exactly
    }

    It 'Protects explicitly retained records during successful final teardown' {
        { Initialize-DeploymentRemoval -TemplateFilePath $templatePath -DeploymentNames 'neutral-fixture' `
                -ProtectedResourceIds $deploymentId -RequireCompleteRemoval -FinalCleanup } |
            Should -Throw '*protected persistent resource*'
        $script:recordRemoved | Should -BeFalse
    }
}

Describe 'Neutral module deployment data' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Get-ModuleDeploymentData.ps1')
        $parameters = @{
            name = @{ type = 'string' }
            retryCount = @{ type = 'int' }
            enabled = @{ type = 'bool' }
            settings = @{ type = 'object' }
            password = @{ type = 'secureString' }
        }
    }

    BeforeEach {
        $dataPath = Join-Path $TestDrive 'deployment-data.json'
        $protectedId = '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/shared-neutral-fixture'
    }

    It 'Adds nothing for ordinary callers without optional data' {
        $result = Get-ModuleDeploymentData
        $result.ParameterOverrides.Count | Should -Be 0
        $result.ProtectedResourceIds.Count | Should -Be 0
        $resolved = Resolve-ModuleDeploymentParameterOverride -ParameterOverrides @{} -TemplateParameters @{}
        $resolved.Count | Should -Be 0
    }

    It 'Resolves a non-HCI fixture through ordinary ARM types without logging its secret' {
        @{
            parameterOverrides = @{
                name = 'neutral-widget'
                retryCount = '3'
                enabled = 'true'
                settings = '{"mode":"existing"}'
                password = 'neutral-override-secret'
            }
            protectedResourceIds = @($protectedId)
        } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $dataPath

        $messages = @(. {
                $data = Get-ModuleDeploymentData -FilePath $dataPath
                $resolved = Resolve-ModuleDeploymentParameterOverride -ParameterOverrides $data.ParameterOverrides -TemplateParameters $parameters
                $resolved.name | Should -Be 'neutral-widget'
                $resolved.retryCount | Should -BeOfType ([long])
                $resolved.retryCount | Should -Be 3
                $resolved.enabled | Should -BeTrue
                $resolved.settings.mode | Should -Be 'existing'
                $resolved.password | Should -BeOfType ([securestring])
                ConvertFrom-SecureString $resolved.password -AsPlainText | Should -Be 'neutral-override-secret'
                $data.ProtectedResourceIds | Should -Be @($protectedId)
            } 4>&1)
        ($messages | Out-String) | Should -Not -Match 'neutral-override-secret'
    }

    It 'Rejects <kind> data' -ForEach @(
        @{ kind = 'malformed JSON'; json = '{"password":"do-not-print-this-secret"' }
        @{ kind = 'non-object'; json = '[]' }
        @{ kind = 'unknown fields'; json = '{"contextFile":"opaque-context.json"}' }
        @{ kind = 'duplicate fields'; json = '{"parameterOverrides":{},"parameterOverrides":{}}' }
        @{ kind = 'non-object parameters'; json = '{"parameterOverrides":[]}' }
        @{ kind = 'duplicate parameter names'; json = '{"parameterOverrides":{"name":"one","NAME":"two"}}' }
        @{ kind = 'non-string parameter values'; json = '{"parameterOverrides":{"retryCount":3}}' }
        @{ kind = 'non-array protection'; json = '{"protectedResourceIds":"not-an-array"}' }
        @{ kind = 'invalid resource identity'; json = '{"protectedResourceIds":["/subscriptions/not-a-guid/resourceGroups/shared"]}' }
        @{ kind = 'empty subscription identity'; json = '{"protectedResourceIds":["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/shared"]}' }
        @{ kind = 'relative resource identity'; json = '{"protectedResourceIds":["resourceGroups/shared"]}' }
        @{ kind = 'incomplete provider identity'; json = '{"protectedResourceIds":["/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/shared/providers/Microsoft.Compute"]}' }
        @{ kind = 'missing provider prefix'; json = '{"protectedResourceIds":["/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/shared/virtualMachines/host"]}' }
        @{ kind = 'ambiguous resource identity'; json = '{"protectedResourceIds":["/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/../shared"]}' }
    ) {
        $json | Set-Content -LiteralPath $dataPath
        $failure = $null
        try { Get-ModuleDeploymentData -FilePath $dataPath } catch { $failure = $_ }
        $failure | Should -Not -BeNullOrEmpty
        $failure.Exception.Message | Should -Not -Match 'do-not-print-this-secret'
    }

    It 'Rejects an undeclared parameter rather than silently dropping an override' {
        { Resolve-ModuleDeploymentParameterOverride -ParameterOverrides @{ missing = 'value' } -TemplateParameters $parameters } |
            Should -Throw '*undeclared template parameter*'
    }

    It 'Rejects invalid parameter types using the existing conversion rules' {
        { Resolve-ModuleDeploymentParameterOverride -ParameterOverrides @{ retryCount = 'not-an-integer' } -TemplateParameters $parameters } |
            Should -Throw '*type*int*'
    }
}

Describe 'Generic cleanup confirmation contract' {
    BeforeAll {
        . (Join-Path $RepoRootPath 'utilities' 'pipelines' 'e2eValidation' 'resourceRemoval' 'Invoke-ModuleDeploymentCleanup.ps1')
    }
    BeforeEach {
        $cleanupInput = @{
            TemplateFilePath = Join-Path $TestDrive 'main.test.json'
            DeploymentNames = @('neutral')
            RemainingDeploymentNames = @('neutral')
            PreflightRejectedDeploymentNames = @()
            PendingDeletionDeploymentIds = @()
            DeploymentAttempts = 1
            RequireCompleteRemoval = $true
        }
        Mock Initialize-DeploymentRemoval { @{ RemovedDeploymentNames = @('neutral') } }
    }

    It 'Keeps best-effort cleanup with <kind> remaining metadata without claiming confirmation' -ForEach @(
        @{ kind = 'omitted'; optionalInput = @{} }
        @{ kind = 'null'; optionalInput = @{ RemainingDeploymentNames = $null } }
    ) {
        $result = Invoke-ModuleDeploymentCleanup -TemplateFilePath $cleanupInput.TemplateFilePath -DeploymentNames @('neutral') @optionalInput
        $result.Status | Should -Be 'unconfirmed'
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter {
            -not $RequireCompleteRemoval -and -not $FinalCleanup -and $DeploymentNames.Count -eq 1 -and $DeploymentNames[0] -eq 'neutral'
        }
    }

    It 'Confirms only exact complete final removal' {
        (Invoke-ModuleDeploymentCleanup @cleanupInput).Status | Should -Be 'confirmed'
        Should -Invoke Initialize-DeploymentRemoval -Times 1 -Exactly -ParameterFilter { $RequireCompleteRemoval -and $FinalCleanup }
    }

    It 'Rejects missing <field> instead of interpreting empty outputs as successful cleanup' -ForEach @(
        @{ field = 'RemainingDeploymentNames' }, @{ field = 'PreflightRejectedDeploymentNames' }
        @{ field = 'PendingDeletionDeploymentIds' }, @{ field = 'DeploymentAttempts' }
    ) {
        $cleanupInput.Remove($field)
        { Invoke-ModuleDeploymentCleanup @cleanupInput } | Should -Throw '*authoritative deployment tracking*'
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
    }

    It 'Reports zero submission only from explicit complete tracking' {
        $cleanupInput.DeploymentNames = @()
        $cleanupInput.RemainingDeploymentNames = @()
        $cleanupInput.DeploymentAttempts = 0
        (Invoke-ModuleDeploymentCleanup @cleanupInput).Status | Should -Be 'not-submitted'
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
    }

    It 'Does not mistake an untracked submission attempt for successful cleanup' {
        $cleanupInput.DeploymentNames = @()
        $cleanupInput.RemainingDeploymentNames = @()
        (Invoke-ModuleDeploymentCleanup @cleanupInput).Status | Should -Be 'unknown'
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
    }

    It 'Recognizes explicitly completed intermediate cleanup without removing it again' {
        $cleanupInput.RemainingDeploymentNames = @()
        (Invoke-ModuleDeploymentCleanup @cleanupInput).Status | Should -Be 'confirmed'
        Should -Invoke Initialize-DeploymentRemoval -Times 0 -Exactly
    }

    It 'Rejects pending history with no outstanding owner' {
        $cleanupInput.RemainingDeploymentNames = @()
        $cleanupInput.PendingDeletionDeploymentIds = @('/subscriptions/11111111-1111-1111-1111-111111111111/providers/Microsoft.Resources/deployments/neutral')
        { Invoke-ModuleDeploymentCleanup @cleanupInput } | Should -Throw '*no remaining deployment owner*'
    }

    It 'Does not confirm <resultKind> removal results' -ForEach @(
        @{ resultKind = 'missing'; removalResult = $null }
        @{ resultKind = 'empty'; removalResult = @{} }
        @{ resultKind = 'partial'; removalResult = @{ RemovedDeploymentNames = @() } }
        @{ resultKind = 'wrong identity'; removalResult = @{ RemovedDeploymentNames = @('other') } }
    ) {
        Mock Initialize-DeploymentRemoval { $removalResult }
        { Invoke-ModuleDeploymentCleanup @cleanupInput } | Should -Throw '*did not confirm every outstanding deployment*'
    }

    It 'Propagates cleanup failures instead of reporting a successful last step' {
        Mock Initialize-DeploymentRemoval { throw 'Offline cleanup failure.' }
        { Invoke-ModuleDeploymentCleanup @cleanupInput } | Should -Throw '*Offline cleanup failure*'
    }
}

Describe 'Generic action architectural separation' {
    BeforeAll {
        Import-Module powershell-yaml -ErrorAction Stop
        $actionText = Get-Content (Join-Path $RepoRootPath '.github' 'actions' 'templates' 'avm-validateModuleDeployment' 'action.yml') -Raw
        $action = ConvertFrom-Yaml $actionText
    }

    It 'Contains no implementation-specific selectors, context handling, or hidden image fallback' {
        $actionText | Should -Not -Match 'Hci|Azure Local|azure-stack-hci|hybrid-container-service|Resolve-CIParameterFallback'
        foreach ($path in @(
                '.github/actions/templates/avm-setEnvironment/action.yml'
                'utilities/pipelines/sharedScripts/Get-ModuleDeploymentData.ps1'
                'utilities/pipelines/e2eValidation/resourceRemoval/Invoke-ModuleDeploymentCleanup.ps1'
            )) {
            Get-Content (Join-Path $RepoRootPath $path) -Raw | Should -Not -Match 'Hci|Azure Local|preparedHciEnvironment'
        }
        Test-Path (Join-Path $RepoRootPath 'utilities' 'pipelines' 'sharedScripts' 'Resolve-CIParameterFallback.ps1') | Should -BeFalse
    }

    It 'Defaults optional data off and unobserved cleanup to unknown' {
        $action.inputs.deploymentDataFile.default | Should -Be ''
        $action.inputs.requireCompleteRemoval.default | Should -Be 'false'
        $action.outputs.cleanupStatus.value | Should -Be '${{ steps.remove-deployed-resources.outputs.cleanupStatus || ''unknown'' }}'
        $actionText | Should -Not -Match 'Invoke-Expression|scriptHook|isHci|fixtureName'
    }
}
