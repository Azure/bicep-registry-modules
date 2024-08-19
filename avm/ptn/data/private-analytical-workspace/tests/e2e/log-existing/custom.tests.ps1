param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate deployment' {

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

        $databricksResourceId = $TestInputData.DeploymentOutputs.databricksResourceId.Value
        $databricksName = $TestInputData.DeploymentOutputs.databricksName.Value
        $databricksLocation = $TestInputData.DeploymentOutputs.databricksLocation.Value
        $databricksResourceGroupName = $TestInputData.DeploymentOutputs.databricksResourceGroupName.Value
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

            $databricksResourceId | Should -Not -BeNullOrEmpty
            $databricksName | Should -Not -BeNullOrEmpty
            $databricksLocation | Should -Not -BeNullOrEmpty
            $databricksResourceGroupName | Should -Not -BeNullOrEmpty
        }

        It 'Check Mandatory Objects' {

            $r = Get-AzResource -ResourceId $resourceId
            $r | Format-List
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $name
            $r.Location | Should -Be $location
            $r.ResourceGroupName | Should -Be $resourceGroupName

            $r = Get-AzResource -ResourceId $virtualNetworkResourceId
            $r | Format-List
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $virtualNetworkName
            $r.Location | Should -Be $virtualNetworkLocation
            $r.ResourceGroupName | Should -Be $virtualNetworkResourceGroupName

            $r = Get-AzResource -ResourceId $logAnalyticsWorkspaceResourceId
            $r | Format-List
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $logAnalyticsWorkspaceName
            $r.Location | Should -Be $logAnalyticsWorkspaceLocation
            $r.ResourceGroupName | Should -Be $logAnalyticsWorkspaceResourceGroupName

            $r = Get-AzResource -ResourceId $keyVaultResourceId
            $r | Format-List
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $keyVaultName
            $r.Location | Should -Be $keyVaultLocation
            $r.ResourceGroupName | Should -Be $keyVaultResourceGroupName

            $r = Get-AzResource -ResourceId $databricksResourceId
            $r | Format-List
            $r | Should -Not -BeNullOrEmpty
            $r.Name | Should -Be $databricksName
            $r.Location | Should -Be $databricksLocation
            $r.ResourceGroupName | Should -Be $databricksResourceGroupName
        }

        Context 'Monitoring - Azure Log Analytics Workspace Tests' {

            BeforeAll {
            }

            It 'Check Azure Log Analytics Workspace Defaults' {

                $log = Get-AzOperationalInsightsWorkspace -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName -name $logAnalyticsWorkspaceName
                $log | Should -Not -BeNullOrEmpty
                $log | Format-List

                $log.Sku | Should -Be 'PerGB2018'
                $log.RetentionInDays | Should -Be 53
                $log.WorkspaceCapping.DailyQuotaGb | Should -Be 22
                $log.WorkspaceCapping.DataIngestionStatus | Should -Be 'RespectQuota'
            }
        }

        Context 'Secrets - Azure Key Vault Tests' {

            BeforeAll {
            }

            It 'Check Azure Key Vault Defaults' {

                $kv = Get-AzKeyVault -ResourceGroupName $keyVaultResourceGroupName -VaultName $keyVaultName
                $kv | Should -Not -BeNullOrEmpty
                $kv | Format-List

                $kv.Sku | Should -Be 'Premium'

                $kv.EnabledForDeployment | Should -Be $false
                $kv.EnabledForTemplateDeployment | Should -Be $false
                $kv.EnabledForDiskEncryption | Should -Be $false

                $kv.EnabledForRBACAuthorization | Should -BeNullOrEmpty #-Be $true

                $kv.EnableSoftDelete | Should -Be $true
                $kv.SoftDeleteRetentionInDays | Should -Be 90
                $kv.EnablePurgeProtection | Should -Be $true

                $kv.PublicNetworkAccess | Should -Be 'Disabled'
                $kv.NetworkAcls.Bypass | Should -Be 'None'
                $kv.NetworkAcls.DefaultAction | Should -Be 'Deny'

                $kvDiag = Get-AzDiagnosticSettingCategory -ResourceId $keyVaultResourceId
                $kvDiag | Should -Not -BeNullOrEmpty
                $kvDiag | Format-List
                $kvDiag.Count | Should -Be 3 # AuditEvent, AzurePolicyEvaluationDetails, AllMetrics

                $kvPEP = Get-AzPrivateEndpoint -ResourceGroupName $keyVaultResourceGroupName -Name "$($keyVaultName)-PEP"
                $kvPEP | Should -Not -BeNullOrEmpty
                $kvPEP | Format-List
                # $kvPEP TODO - do more checks

                $kvZone = Get-AzPrivateDnsZone -ResourceGroupName $keyVaultResourceGroupName -Name "privatelink.vaultcore.azure.net"
                $kvZone | Should -Not -BeNullOrEmpty
                $kvZone | Format-List
                $kvZone.NumberOfRecordSets | Should -Be 2 # SOA + A
                $kvZone.NumberOfVirtualNetworkLinks | Should -Be 1
                $kvZone.Tags.Owner | Should -Be "Contoso"
                $kvZone.Tags.CostCenter | Should -Be "123-456-789"





                # TODO
                #$kv.NetworkAcls.IpAddressRanges  | Should -Be ''
                #diag settings
                #private links
                #role assignments
            }
        }

        Context 'Azure Databricks Tests' {

            BeforeAll {
            }

            It 'Check Azure Databricks Defaults' {

                $adb = Get-AzDatabricksWorkspace -ResourceGroupName $databricksResourceGroupName -Name $databricksName
                $adb | Should -Not -BeNullOrEmpty
                $adb | Format-List

                $adbZone = Get-AzPrivateDnsZone -ResourceGroupName $databricksResourceGroupName -Name "privatelink.azuredatabricks.net"
                $adbZone | Should -Not -BeNullOrEmpty
                $adbZone | Format-List
                $adbZone.NumberOfRecordSets | Should -Be 5 # SOA + 4xA
                $adbZone.NumberOfVirtualNetworkLinks | Should -Be 1
                $adbZone.Tags.Owner | Should -Be "Contoso"
                $adbZone.Tags.CostCenter | Should -Be "123-456-789"

                $adbAuthPEP = Get-AzPrivateEndpoint -ResourceGroupName $databricksResourceGroupName -Name "$($databricksName)-auth-PEP"
                $adbAuthPEP | Should -Not -BeNullOrEmpty
                $adbAuthPEP | Format-List
                # $adbAuthPEP TODO - do more checks

                $adbUiPEP = Get-AzPrivateEndpoint -ResourceGroupName $databricksResourceGroupName -Name "$($databricksName)ui-PEP"
                $adbUiPEP | Should -Not -BeNullOrEmpty
                $adbUiPEP | Format-List
                # $adbUiPEP TODO - do more checks
            }
        }














        It 'Check Tags' {

            $tag1 = 'Owner'
            $tag1Val = 'Contoso'
            $tag2 = 'CostCenter'
            $tag2Val = '123-456-789'

            $t = Get-AzTag -ResourceId $resourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $virtualNetworkResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            # Existing log has different tags
            #$t = Get-AzTag -ResourceId $logAnalyticsWorkspaceResourceId
            #$t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            #$t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $keyVaultResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val

            $t = Get-AzTag -ResourceId $databricksResourceId
            $t.Properties.TagsProperty[$tag1] | Should -Be $tag1Val
            $t.Properties.TagsProperty[$tag2] | Should -Be $tag2Val
        }
    }






}
