param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate deployment' {

    BeforeAll {
        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        Write-Host $resourceId
        $name = $TestInputData.DeploymentOutputs.name.Value
        Write-Host $name
        $location = $TestInputData.DeploymentOutputs.location.Value
        Write-Host $location
        $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value
        Write-Host $resourceGroupName

        $virtualNetworkResourceId = $TestInputData.DeploymentOutputs.virtualNetworkResourceId.Value
        Write-Host $virtualNetworkResourceId
        $virtualNetworkName = $TestInputData.DeploymentOutputs.virtualNetworkName.Value
        Write-Host $virtualNetworkName
        $virtualNetworkLocation = $TestInputData.DeploymentOutputs.virtualNetworkLocation.Value
        Write-Host $virtualNetworkLocation
        $virtualNetworkResourceGroupName = $TestInputData.DeploymentOutputs.virtualNetworkResourceGroupName.Value
        Write-Host $virtualNetworkResourceGroupName

        $logAnalyticsWorkspaceResourceId = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceId.Value
        Write-Host $logAnalyticsWorkspaceResourceId
        $logAnalyticsWorkspaceName = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceName.Value
        Write-Host $logAnalyticsWorkspaceName
        $logAnalyticsWorkspaceLocation = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceLocation.Value
        Write-Host $logAnalyticsWorkspaceLocation
        $logAnalyticsWorkspaceResourceGroupName = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceGroupName.Value
        Write-Host $logAnalyticsWorkspaceResourceGroupName

        $keyVaultResourceId = $TestInputData.DeploymentOutputs.keyVaultResourceId.Value
        Write-Host $keyVaultResourceId
        $keyVaultName = $TestInputData.DeploymentOutputs.keyVaultName.Value
        Write-Host $keyVaultName
        $keyVaultLocation = $TestInputData.DeploymentOutputs.keyVaultLocation.Value
        Write-Host $keyVaultLocation
        $keyVaultResourceGroupName = $TestInputData.DeploymentOutputs.keyVaultResourceGroupName.Value
        Write-Host $keyVaultResourceGroupName
    }

    Context 'Common Tests' {

        BeforeAll {
        }

        It 'Check Output Variables' {

            $resourceId | Should -Not -BeNullOrEmpty
            $name | Should -Not -BeNullOrEmpty
            $location | Should -Not -BeNullOrEmpty
            $resourceGroupName | Should -Not -BeNullOrEmpty

            $virtualNetworkResourceId | Should -Not -BeNullOrEmpty
            $virtualNetworkName | Should -Not -BeNullOrEmpty
            $virtualNetworkLocation | Should -Not -BeNullOrEmpty
            $virtualNetworkResourceGroupName | Should -Not -BeNullOrEmpty

            $logAnalyticsWorkspaceResourceId | Should -Not -BeNullOrEmpty
            $logAnalyticsWorkspaceName | Should -Not -BeNullOrEmpty
            $logAnalyticsWorkspaceLocation | Should -Not -BeNullOrEmpty
            $logAnalyticsWorkspaceResourceGroupName | Should -Not -BeNullOrEmpty

            $keyVaultResourceId | Should -Not -BeNullOrEmpty
            $keyVaultName | Should -Not -BeNullOrEmpty
            $keyVaultLocation | Should -Not -BeNullOrEmpty
            $keyVaultResourceGroupName | Should -Not -BeNullOrEmpty
        }

        It 'Check Mandatory Objects' {

            $r = Get-AzResource -ResourceId $resourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $name
            $r.Location | Should -Be $location
            $r.ResourceGroupName | Should -Be $resourceGroupName

            $r = Get-AzResource -ResourceId $virtualNetworkResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $virtualNetworkName
            $r.Location | Should -Be $virtualNetworkLocation
            $r.ResourceGroupName | Should -Be $virtualNetworkResourceGroupName

            $r = Get-AzResource -ResourceId $logAnalyticsWorkspaceResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $logAnalyticsWorkspaceName
            $r.Location | Should -Be $logAnalyticsWorkspaceLocation
            $r.ResourceGroupName | Should -Be $logAnalyticsWorkspaceResourceGroupName

            $r = Get-AzResource -ResourceId $keyVaultResourceId
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $keyVaultName
            $r.Location | Should -Be $keyVaultLocation
            $r.ResourceGroupName | Should -Be $keyVaultResourceGroupName
        }
    }

    Context 'Monitoring - Azure Log Analytics Workspace Tests' {

        BeforeAll {
        }

        It 'Check Azure Log Analytics Workspace Defaults' {

            $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName -Name $logAnalyticsWorkspaceName
            Write-Host ($log | Out-String)

            # NOT Relevant for this test
            #$log.Sku | Should -Be 'PerGB2018'
            #$log.RetentionInDays | Should -Be 365
            #$log.WorkspaceFeatures.DailyQuotaGb | Should -Be -1
        }
    }
}
