param (
    [hashtable] $TestInputData = @{}
)

BeforeAll {
    $vmssResourceId = $TestInputData.DeploymentOutputs.virtualMachineScaleSetResourceId.Value
    $expectedIds = $TestInputData.DeploymentOutputs.applicationVersionResourceIds.Value
    $response = Invoke-AzRestMethod -Method GET -Path "${vmssResourceId}?api-version=2024-11-01" -ErrorAction Stop
    if ($response.StatusCode -ne 200) {
        throw "Unable to read scale set model: HTTP $($response.StatusCode)."
    }
    $model = $response.Content | ConvertFrom-Json
    $applications = @($model.properties.virtualMachineProfile.applicationProfile.galleryApplications)
}

Describe 'Gallery Applications on the Flexible scale set model' {
    It 'retains both pinned application versions and caller settings' {
        $model.properties.orchestrationMode | Should -Be 'Flexible'
        $applications.Count | Should -Be 2
        for ($index = 0; $index -lt 2; $index++) {
            $applications[$index].packageReferenceId | Should -Be $expectedIds[$index]
            $applications[$index].packageReferenceId | Should -Match '/versions/1\.0\.0$'
            $applications[$index].enableAutomaticUpgrade | Should -BeFalse
            $applications[$index].order | Should -Be ($index + 1)
        }
        $applications[0].tags | Should -Be 'first-test-application'
        $applications[0].treatFailureAsDeploymentFailure | Should -BeTrue
        $applications[1].treatFailureAsDeploymentFailure | Should -BeFalse
    }

    It 'installs both harmless packages on the instances created from the model' {
        $resourceGroupName = $vmssResourceId.Split('/')[4]
        $instances = @(Get-AzVM -ResourceGroupName $resourceGroupName -ErrorAction Stop |
            Where-Object { $_.VirtualMachineScaleSet.Id -eq $vmssResourceId })
        $instances.Count | Should -Be $model.sku.capacity
        $instances.Count | Should -BeGreaterThan 0
        foreach ($instance in $instances) {
            $result = Invoke-AzVMRunCommand -ResourceGroupName $resourceGroupName -VMName $instance.Name -CommandId 'RunShellScript' -ScriptString (@(
                'set -eu'
                'test "$(cat /var/lib/avm-gallery-applications/first)" = "AVM VMSS gallery application test"'
                'test "$(cat /var/lib/avm-gallery-applications/second)" = "AVM VMSS gallery application test"'
                'printf "AVM_GALLERY_APPLICATIONS_INSTALLED\n"'
            ) -join "`n") -ErrorAction Stop
            ($result.Value.Message -join "`n") | Should -Match '(?m)^AVM_GALLERY_APPLICATIONS_INSTALLED\r?$'
        }
    }
}
