param ([hashtable] $TestInputData)

Describe 'ACA-LZA native Notation image acceptance' {
    BeforeAll {
        $outputs = $TestInputData.DeploymentOutputs
        $sample = $outputs.testDeploymentOutputs.value.sampleImageVerification.value
        $verification = $outputs.notationVerification.value
    }

    It 'Deploys the same immutable image accepted by strict verification' {
        $sample.strictVerification | Should -BeTrue
        $sample.image | Should -Match '^.+/aca-lza/sample@sha256:[a-f0-9]{64}$'
        $verification.trustedAccepted | Should -BeTrue
        $verification.trustedImage | Should -BeExactly $sample.image
        $verification.privateKeyExported | Should -BeFalse
    }

    It 'Runs the verified digest in the actual managed-identity consumer latest ready revision' {
        $sample.strictVerification | Should -BeTrue
        $resourceGroupName = $outputs.testDeploymentOutputs.value.resourceGroupName.value
        $resourceGroupName | Should -Not -BeNullOrEmpty
        $pullIdentity = $outputs.testDeploymentOutputs.value.containerRegistryUserAssignedIdentityResourceId.value
        $pullIdentity | Should -Not -BeNullOrEmpty
        $apps = @(Get-AzResource -ResourceGroupName $resourceGroupName -ResourceType 'Microsoft.App/containerApps' `
                -ExpandProperties -ErrorAction Stop)
        $apps.Count | Should -Be 1
        $app = $apps[0]
        $app.ResourceGroupName | Should -Be $resourceGroupName
        $app.Properties.provisioningState | Should -Be 'Succeeded'
        @($app.Properties.template.containers).Count | Should -Be 1
        $app.Properties.template.containers[0].image | Should -BeExactly $sample.image
        $app.Properties.configuration.activeRevisionsMode | Should -Be 'Single'
        $app.Properties.latestRevisionName | Should -Not -BeNullOrEmpty
        $app.Properties.latestReadyRevisionName | Should -BeExactly $app.Properties.latestRevisionName
        $registries = @($app.Properties.configuration.registries)
        $registries.Count | Should -Be 1
        $registries[0].server | Should -BeExactly $sample.image.Split('/')[0]
        $registries[0].identity |
            Should -Be $pullIdentity
        $registries[0].username | Should -BeNullOrEmpty
        $registries[0].passwordSecretRef | Should -BeNullOrEmpty
        $app.ResourceId | Should -Not -BeNullOrEmpty
        $revisionResourceId = "$($app.ResourceId)/revisions/$($app.Properties.latestRevisionName)"
        $response = Invoke-AzRestMethod -Method GET -Path "${revisionResourceId}?api-version=2024-03-01" -ErrorAction Stop
        $response.StatusCode | Should -Be 200
        $revision = $response.Content | ConvertFrom-Json -ErrorAction Stop
        $revision.id | Should -Be $revisionResourceId
        $revision.name | Should -BeExactly $app.Properties.latestRevisionName
        $revision.properties.active | Should -BeTrue
        $revision.properties.provisioningState | Should -Be 'Provisioned'
        $revision.properties.healthState | Should -Be 'Healthy'
        $revision.properties.runningState | Should -BeIn @('Running', 'Processing')
        $revision.properties.replicas | Should -BeGreaterThan 0
        @($revision.properties.template.containers).Count | Should -Be 1
        $revision.properties.template.containers[0].image | Should -BeExactly $sample.image
    }

    It 'Rejects unsigned, actually tampered and untrusted-root artifacts without treating transport failures as verification' {
        @($verification.controls).Count | Should -Be 3
        @($verification.controls.case | Sort-Object) | Should -Be @('Tampered', 'Unsigned', 'Untrusted')
        foreach ($control in $verification.controls) {
            $control.rejected | Should -BeTrue
            $control.errorSha256 | Should -Match '^[a-f0-9]{64}$'
        }
    }
}
