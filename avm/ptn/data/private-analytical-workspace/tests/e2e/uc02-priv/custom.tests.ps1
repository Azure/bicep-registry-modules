param (
    [Parameter(Mandatory = $false)]
    [hashtable] $TestInputData = @{}
)

Describe 'Validate Pattern deployment' {

    BeforeAll {

        . $PSScriptRoot/../../common.tests.ps1
        $expectedTags = @{Owner = 'Contoso'; CostCenter = '123-456-789' }

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

            Test-VerifyOutputVariables -MustBeNullOrEmpty $false -ResourceId $resourceId -name $name -Location $location -ResourceGroupName $resourceGroupName
            Test-VerifyOutputVariables -MustBeNullOrEmpty $false -ResourceId $virtualNetworkResourceId -name $virtualNetworkName -Location $virtualNetworkLocation -ResourceGroupName $virtualNetworkResourceGroupName
            Test-VerifyOutputVariables -MustBeNullOrEmpty $false -ResourceId $logAnalyticsWorkspaceResourceId -name $logAnalyticsWorkspaceName -Location $logAnalyticsWorkspaceLocation -ResourceGroupName $logAnalyticsWorkspaceResourceGroupName
            Test-VerifyOutputVariables -MustBeNullOrEmpty $false -ResourceId $keyVaultResourceId -name $keyVaultName -Location $keyVaultLocation -ResourceGroupName $keyVaultResourceGroupName
            Test-VerifyOutputVariables -MustBeNullOrEmpty $false -ResourceId $databricksResourceId -name $databricksName -Location $databricksLocation -ResourceGroupName $databricksResourceGroupName
        }

        Context 'Network - Azure Virtual Network Tests' {

            BeforeAll {
            }

            It 'Check Azure Virtual Network' {

                # Not relevant for the custom VNET deployment
            }
        }

        Context 'Monitoring - Azure Log Analytics Workspace Tests' {

            BeforeAll {
            }

            It 'Check Azure Log Analytics Workspace' {

                Test-VerifyLogAnalyticsWorkspace -LogAnalyticsWorkspaceResourceGroupName $logAnalyticsWorkspaceResourceGroupName `
                    -LogAnalyticsWorkspaceName $logAnalyticsWorkspaceName -Tags $expectedTags -Sku 'PerGB2018' -RetentionInDays 365 -DailyQuotaGb -1
            }
        }

        Context 'Secrets - Azure Key Vault Tests' {

            BeforeAll {
            }

            It 'Check Azure Key Vault' {

                Test-VerifyKeyVault -KeyVaultResourceGroupName $keyVaultResourceGroupName -KeyVaultName $keyVaultName -Tags $expectedTags `
                    -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Sku 'Premium' -EnableSoftDelete $true -RetentionInDays 90 -PEPName '-PEP' `
                    -NumberOfRecordSets 0 -SubnetName 'private-link-subnet' -PublicNetworkAccess 'Disabled' -IpAddressRanges $null
            }
        }

        Context 'Azure Databricks Tests' {

            BeforeAll {
            }

            It 'Check Azure Databricks' {

                Test-VerifyDatabricks -DatabricksResourceGroupName $databricksResourceGroupName -DatabricksName $databricksName -Tags $expectedTags `
                    -LogAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -Sku 'premium' -VirtualNetworkResourceId $virtualNetworkResourceId `
                    -PrivateSubnetName 'dbw-backend-subnet' -PublicSubnetName 'dbw-frontend-subnet' -PEPName0 '-sa-blob-PEP' -PEPName1 '-dbw-auth-PEP' -PEPName2 '-dbw-ui-PEP' `
                    -BlobNumberOfRecordSets 0 -DatabricksNumberOfRecordSets 0 -PLSubnetName 'private-link-subnet' -PublicNetworkAccess 'Disabled' -RequiredNsgRule 'NoAzureDatabricksRules'
            }
        }
    }
}
