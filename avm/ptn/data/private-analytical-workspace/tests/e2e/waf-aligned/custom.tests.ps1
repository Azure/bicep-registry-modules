param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Pattern deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{Owner='Contoso'; CostCenter='123-456-789'}

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

    Context 'Pattern Tests' {

        BeforeAll {
        }

        It 'Check Output Variables' {

            Test-VerifyOutputVariables -ResourceId $resourceId -Name $name -Location $location -ResourceGroupName $resourceGroupName
            Test-VerifyOutputVariables -ResourceId $virtualNetworkResourceId -Name $virtualNetworkName -Location $virtualNetworkLocation -ResourceGroupName $virtualNetworkResourceGroupName
            Test-VerifyOutputVariables -ResourceId $logAnalyticsWorkspaceResourceId -Name $logAnalyticsWorkspaceName -Location $logAnalyticsWorkspaceLocation -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName
            Test-VerifyOutputVariables -ResourceId $keyVaultResourceId -Name $keyVaultName -Location $keyVaultLocation -ResourceGroupName $keyVaultResourceGroupName
            Test-VerifyOutputVariables -ResourceId $databricksResourceId -Name $databricksName -Location $databricksLocation -ResourceGroupName $databricksResourceGroupName
        }

        Context 'Network - Azure Virtual Network Tests' {

            BeforeAll {
            }

            It 'Check Azure Virtual Network' {

                $vnet = Test-VerifyVirtualNetwork -VirtualNetworkResourceGroupName $virtualNetworkResourceGroupName -VirtualNetworkName $virtualNetworkName `
                    -Tags $expectedTags -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -AddressPrefix "192.168.224.0/19" -NumberOfSubnets 3

                Test-VerifySubnet -Subnet $vnet.Subnets[0] -SubnetName "private-link-subnet" -SubnetAddressPrefix "192.168.224.0/24" `
                    -NumberOfSecurityGroups 1 -NumberOfPrivateEndpoints 3 -NumberOfIpConfigurations 5 -DelegationServiceName $null

                Test-VerifySubnet -Subnet $vnet.Subnets[1] -SubnetName "dbw-frontend-subnet" -SubnetAddressPrefix "192.168.228.0/23" `
                    -NumberOfSecurityGroups 1 -NumberOfPrivateEndpoints $null -NumberOfIpConfigurations $null -DelegationServiceName "Microsoft.Databricks/workspaces"

                Test-VerifySubnet -Subnet $vnet.Subnets[2] -SubnetName "dbw-backend-subnet" -SubnetAddressPrefix "192.168.230.0/23" `
                    -NumberOfSecurityGroups 1 -NumberOfPrivateEndpoints $null -NumberOfIpConfigurations $null -DelegationServiceName "Microsoft.Databricks/workspaces"

                $nsgLogs = @('NetworkSecurityGroupEvent', 'NetworkSecurityGroupRuleCounter')
                Test-VerifyNetworkSecurityGroup -NetworkSecurityGroupResourceId $vnet.Subnets[0].NetworkSecurityGroup[0].Id `
                    -Tags $expectedTags -VirtualNetworkResourceId $virtualNetworkResourceId -SubnetName "private-link-subnet" `
                    -NumberOfSecurityRules 1 -NumberOfDefaultSecurityRules 6 -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $nsgLogs

                Test-VerifyNetworkSecurityGroup -NetworkSecurityGroupResourceId $vnet.Subnets[1].NetworkSecurityGroup[0].Id `
                    -Tags $expectedTags -VirtualNetworkResourceId $virtualNetworkResourceId -SubnetName "dbw-frontend-subnet" `
                    -NumberOfSecurityRules 7 -NumberOfDefaultSecurityRules 6 -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $nsgLogs

                Test-VerifyNetworkSecurityGroup -NetworkSecurityGroupResourceId $vnet.Subnets[2].NetworkSecurityGroup[0].Id `
                    -Tags $expectedTags -VirtualNetworkResourceId $virtualNetworkResourceId -SubnetName "dbw-backend-subnet" `
                    -NumberOfSecurityRules 7 -NumberOfDefaultSecurityRules 6 -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $nsgLogs
            }
        }

        Context 'Monitoring - Azure Log Analytics Workspace Tests' {

            BeforeAll {
            }

            It 'Check Azure Log Analytics Workspace' {

                Test-VerifyLogAnalyticsWorkspace -LogAnalyticsWorkspaceResourceGroupName $logAnalyticsWorkspaceResourceGroupName `
                    -LogAnalyticsWorkspaceName $logAnalyticsWorkspaceName -Tags $expectedTags -Sku "PerGB2018" -RetentionInDays 35 -DailyQuotaGb 1
            }
        }

        Context 'Secrets - Azure Key Vault Tests' {

            BeforeAll {
            }

            It 'Check Azure Key Vault' {

                Test-VerifyKeyVault -KeyVaultResourceGroupName $keyVaultResourceGroupName -KeyVaultName $keyVaultName -Tags $expectedTags `
                    -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Sku "Standard" -RetentionInDays 90 -PEPName "-PEP" -NumberOfRecordSets 2 -SubnetName "private-link-subnet"
            }
        }







        Context 'Azure Databricks Tests' {

            BeforeAll {
            }

            It 'Check Azure Databricks' {

                $adb = Get-AzDatabricksWorkspace -ResourceGroupName $databricksResourceGroupName -Name $databricksName
                $adb | Should -Not -BeNullOrEmpty
                $adb.ProvisioningState | Should -Be "Succeeded"
                $adb.AccessConnectorId | Should -BeNullOrEmpty
                $adb.AccessConnectorIdentityType | Should -BeNullOrEmpty
                $adb.AccessConnectorUserAssignedIdentityId | Should -BeNullOrEmpty
                $adb.AmlWorkspaceIdType | Should -BeNullOrEmpty
                $adb.AmlWorkspaceIdValue | Should -BeNullOrEmpty
                #Skip $adb.Authorization
                $adb.AutomaticClusterUpdateValue | Should -BeNullOrEmpty
                $adb.ComplianceSecurityProfileComplianceStandard | Should -BeNullOrEmpty
                $adb.ComplianceSecurityProfileValue | Should -BeNullOrEmpty
                #Skip $adb.CreatedByApplicationId, $adb.CreatedByOid, $adb.CreatedByPuid, $adb.CreatedDateTime,
                $adb.CustomPrivateSubnetNameType | Should -Be "String"
                $adb.CustomPrivateSubnetNameValue | Should -Be "dbw-backend-subnet"
                $adb.CustomPublicSubnetNameType | Should -Be "String"
                $adb.CustomPublicSubnetNameValue | Should -Be "dbw-frontend-subnet"
                $adb.CustomVirtualNetworkIdType | Should -Be "String"
                $adb.CustomVirtualNetworkIdValue | Should -Be $virtualNetworkResourceId
                $adb.DefaultCatalogInitialName | Should -BeNullOrEmpty
                $adb.DefaultCatalogInitialType | Should -BeNullOrEmpty
                $adb.DefaultStorageFirewall | Should -BeNullOrEmpty
                $adb.DiskEncryptionSetId | Should -BeNullOrEmpty
                $adb.EnableNoPublicIP | Should -Be $true
                $adb.EnableNoPublicIPType | Should -Be "Bool"
                $adb.EncryptionKeyName | Should -BeNullOrEmpty
                $adb.EncryptionKeySource | Should -BeNullOrEmpty
                $adb.EncryptionKeyVaultUri | Should -BeNullOrEmpty
                $adb.EncryptionKeyVersion | Should -BeNullOrEmpty
                $adb.EncryptionType | Should -BeNullOrEmpty
                $adb.EnhancedSecurityMonitoringValue | Should -BeNullOrEmpty
                $adb.Id | Should -Be $databricksResourceId
                $adb.IsUcEnabled | Should -Be $true
                $adb.LoadBalancerBackendPoolNameType | Should -BeNullOrEmpty
                $adb.LoadBalancerBackendPoolNameValue | Should -BeNullOrEmpty
                $adb.LoadBalancerIdType | Should -BeNullOrEmpty
                $adb.LoadBalancerIdValue | Should -BeNullOrEmpty
                $adb.Location | Should -Be $databricksLocation
                $adb.ManagedDiskIdentityPrincipalId | Should -BeNullOrEmpty
                $adb.ManagedDiskIdentityTenantId | Should -BeNullOrEmpty
                $adb.ManagedDiskIdentityType | Should -BeNullOrEmpty
                $adb.ManagedDiskKeySource | Should -Be "Microsoft.Keyvault"
                $adb.ManagedDiskKeyVaultPropertiesKeyName | Should -BeNullOrEmpty
                $adb.ManagedDiskKeyVaultPropertiesKeyVaultUri | Should -BeNullOrEmpty
                $adb.ManagedDiskKeyVaultPropertiesKeyVersion | Should -BeNullOrEmpty
                $adb.ManagedDiskRotationToLatestKeyVersionEnabled | Should -BeNullOrEmpty
                #Skip $adb.ManagedResourceGroupId
                $adb.ManagedServiceKeySource | Should -Be "Microsoft.Keyvault"
                $adb.ManagedServicesKeyVaultPropertiesKeyName | Should -BeNullOrEmpty
                $adb.ManagedServicesKeyVaultPropertiesKeyVaultUri | Should -BeNullOrEmpty
                $adb.ManagedServicesKeyVaultPropertiesKeyVersion | Should -BeNullOrEmpty
                $adb.Name | Should -Be $databricksName
                $adb.NatGatewayNameType | Should -BeNullOrEmpty
                $adb.NatGatewayNameValue | Should -BeNullOrEmpty
                $adb.PrepareEncryption | Should -Be $true
                $adb.PrepareEncryptionType | Should -Be "Bool"
                $adb.PrivateEndpointConnection.Count | Should -Be 2

                $adb.PrivateEndpointConnection[0].GroupId.Count | Should -Be 1
                $adb.PrivateEndpointConnection[0].GroupId[0] | Should -Be "databricks_ui_api"
                $adb.PrivateEndpointConnection[0].PrivateLinkServiceConnectionStateStatus | Should -Be "Approved"
                $adb.PrivateEndpointConnection[0].ProvisioningState | Should -Be "Succeeded"

                $adb.PrivateEndpointConnection[1].GroupId.Count | Should -Be 1
                $adb.PrivateEndpointConnection[1].GroupId[0] | Should -Be "browser_authentication"
                $adb.PrivateEndpointConnection[1].PrivateLinkServiceConnectionStateStatus | Should -Be "Approved"
                $adb.PrivateEndpointConnection[1].ProvisioningState | Should -Be "Succeeded"

                $adb.PublicIPNameType | Should -Be "String"
                $adb.PublicIPNameValue | Should -Be "nat-gw-public-ip"
                $adb.PublicNetworkAccess | Should -Be "Disabled"
                $adb.RequireInfrastructureEncryption | Should -Be $false
                $adb.RequireInfrastructureEncryptionType | Should -Be "Bool"
                $adb.RequiredNsgRule | Should -Be "NoAzureDatabricksRules"
                $adb.ResourceGroupName | Should -Be $databricksResourceGroupName
                #Skip $adb.ResourceTagType, $adb.ResourceTagValue
                $adb.SkuName | Should -Be "premium"
                $adb.SkuTier | Should -BeNullOrEmpty
                #Skip $adb.StorageAccount**
                #Skip $adb.SystemData**
                $adb.Type | Should -Be "Microsoft.Databricks/workspaces"
                $adb.UiDefinitionUri | Should -BeNullOrEmpty
                #Skip $adb.UpdatedBy**
                #Skip $adb.Url
                $adb.VnetAddressPrefixType | Should -Be "String"
                $adb.VnetAddressPrefixValue | Should -Be "10.139"
                #Skip $adb.WorkspaceId
                Test-VerifyTagsForResource -ResourceId $adb.Id -Tags $expectedTags
                # TODO Role, Lock - How?


                $logs = @(
                    'dbfs', 'clusters', 'accounts', 'jobs', 'notebook',
                    'ssh', 'workspace', 'secrets', 'sqlPermissions', 'instancePools',
                    'sqlanalytics', 'genie', 'globalInitScripts', 'iamRole', 'mlflowExperiment',
                    'featureStore', 'RemoteHistoryService', 'mlflowAcledArtifact', 'databrickssql', 'deltaPipelines',
                    'modelRegistry', 'repos', 'unityCatalog', 'gitCredentials', 'webTerminal',
                    'serverlessRealTimeInference', 'clusterLibraries', 'partnerHub', 'clamAVScan', 'capsule8Dataplane',
                    'BrickStoreHttpGateway', 'Dashboards', 'CloudStorageMetadata', 'PredictiveOptimization', 'DataMonitoring',
                    'Ingestion', 'MarketplaceConsumer', 'LineageTracking'
                    )
                Test-VerifyDiagSettings -ResourceId $databricksResourceId -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Logs $logs

                Test-VerifyPrivateEndpoint -Name "$($databricksName)-auth-PEP" -ResourceGroupName $databricksResourceGroupName -Tags $expectedTags -SubnetName "private-link-subnet" -ServiceId $databricksResourceId -GroupId "browser_authentication"
                # TODO Role, Lock - How?

                Test-VerifyPrivateEndpoint -Name "$($databricksName)-ui-PEP" -ResourceGroupName $databricksResourceGroupName -Tags $expectedTags -SubnetName "private-link-subnet" -ServiceId $databricksResourceId -GroupId "databricks_ui_api"
                # TODO Role, Lock - How?

                Test-VerifyDnsZone -Name "privatelink.azuredatabricks.net" -ResourceGroupName $databricksResourceGroupName -Tags $expectedTags -NumberOfRecordSets 5 # SOA + 4xA
                # TODO Role, Lock - How?








                #KV pubacc, ACL pub ip
                #$log | Format-List

                #kvIpRules
                #dbwIpRules


            }
        }
    }
}
