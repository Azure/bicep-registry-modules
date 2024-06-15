param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate deployment with provided Azure Log Analytics Workspace' {

    BeforeAll {
        $resourceId = $TestInputData.DeploymentOutputs.resourceId.Value
        $name = $TestInputData.DeploymentOutputs.name.Value
        $location = $TestInputData.DeploymentOutputs.location.Value
        $resourceGroupName = $TestInputData.DeploymentOutputs.resourceGroupName.Value

        $virtualNetworkResourceId = $TestInputData.DeploymentOutputs.virtualNetworkResourceId.Value
        $virtualNetworkName = $TestInputData.DeploymentOutputs.virtualNetworkName.Value
        $virtualNetworkLocation = $TestInputData.DeploymentOutputs.virtualNetworkLocation.Value
        $virtualNetworkResourceGroupName = $TestInputData.DeploymentOutputs.virtualNetworkResourceGroupName.Value

        $logAnalyticsWorkspaceResourceId = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceId.Value
        $logAnalyticsWorkspaceName = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceName.Value
        $logAnalyticsWorkspaceLocation = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceLocation.Value
        $logAnalyticsWorkspaceResourceGroupName = $TestInputData.DeploymentOutputs.logAnalyticsWorkspaceResourceGroupName.Value

        $keyVaultResourceId = $TestInputData.DeploymentOutputs.keyVaultResourceId.Value
        $keyVaultName = $TestInputData.DeploymentOutputs.keyVaultName.Value
        $keyVaultLocation = $TestInputData.DeploymentOutputs.keyVaultLocation.Value
        $keyVaultResourceGroupName = $TestInputData.DeploymentOutputs.keyVaultResourceGroupName.Value
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

            $r = Get-AzVirtualNetwork -Name $name -ResourceGroupName $resourceGroupName -ErrorAction SilentlyContinue
            $r | Should -Not -BeNullOrEmpty
            $r.ResourceId | Should -Be $resourceId
            $r.Location | Should -Be $location

            $vnet = Get-AzVirtualNetwork -Name $virtualNetworkName -ResourceGroupName $virtualNetworkResourceGroupName -ErrorAction SilentlyContinue
            $vnet | Should -Not -BeNullOrEmpty
            $vnet.ResourceId | Should -Be $virtualNetworkResourceId
            $vnet.Location | Should -Be $virtualNetworkLocation

            $log = Get-AzOperationalInsightsWorkspace -Name $logAnalyticsWorkspaceName -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName -ErrorAction SilentlyContinue
            $log | Should -Not -BeNullOrEmpty
            $log.ResourceId | Should -Be $logAnalyticsWorkspaceResourceId
            $log.Location | Should -Be $logAnalyticsWorkspaceLocation

            $kv = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $keyVaultResourceGroupName -ErrorAction SilentlyContinue
            $kv | Should -Not -BeNullOrEmpty
            $kv.ResourceId | Should -Be $keyVaultResourceId
            $kv.Location | Should -Be $keyVaultLocation
        }
    }

    Context 'Monitoring - Azure Log Analytics Workspace Tests' {

        BeforeAll {
        }

        It 'Check Azure Log Analytics Workspace Defaults' {

            $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName -Name $logAnalyticsWorkspaceName -ErrorAction SilentlyContinue

            # NOT Relevant for this test
            #$log.Sku | Should -Be 'PerGB2018'
            #$log.RetentionInDays | Should -Be 365
            #$log.WorkspaceFeatures.DailyQuotaGb | Should -Be -1
        }
    }
}
