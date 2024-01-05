<#
.SYNOPSIS
Remove deployed resources based on their deploymentName(s)

.DESCRIPTION
Remove deployed resources based on their deploymentName(s)

.PARAMETER DeploymentName(s)
Mandatory. The name(s) of the deployment(s)

.PARAMETER TemplateFilePath
Mandatory. The path to the template used for the deployment. Used to determine the level/scope (e.g. subscription)

.PARAMETER ResourceGroupName
Optional. The name of the resource group the deployment was happening in. Relevant for resource-group level deployments.

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.EXAMPLE
Initialize-DeploymentRemoval -DeploymentName 'n-vw-t1-20211204T1812029146Z' -TemplateFilePath "$home/ResourceModules/modules/network/virtual-wan/main.bicep" -resourceGroupName 'test-virtualWan-rg'

Remove the deployment 'n-vw-t1-20211204T1812029146Z' from resource group 'test-virtualWan-rg' that was executed using template in path "$home/ResourceModules/modules/network/virtual-wan/main.bicep"
#>
function Initialize-DeploymentRemoval {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('DeploymentName')]
        [string[]] $DeploymentNames,

        [Parameter(Mandatory = $true)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $subscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)
        # Load functions
        . (Join-Path $PSScriptRoot 'helper' 'Remove-Deployment.ps1')
    }

    process {

        if (-not [String]::IsNullOrEmpty($subscriptionId)) {
            Write-Verbose ('Setting context to subscription [{0}]' -f $subscriptionId)
            $null = Set-AzContext -Subscription $subscriptionId
        }

        # The initial sequence is a general order-recommendation
        $removalSequence = @(
            'Microsoft.Authorization/locks',
            'Microsoft.Authorization/roleAssignments',
            'Microsoft.Insights/diagnosticSettings',
            'Microsoft.Network/privateEndpoints/privateDnsZoneGroups',
            'Microsoft.Network/privateEndpoints',
            'Microsoft.Network/azureFirewalls',
            'Microsoft.Network/virtualHubs',
            'Microsoft.Network/virtualWans',
            'Microsoft.OperationsManagement/solutions',
            'Microsoft.OperationalInsights/workspaces/linkedServices',
            'Microsoft.OperationalInsights/workspaces',
            'Microsoft.KeyVault/vaults',
            'Microsoft.Authorization/policyExemptions',
            'Microsoft.Authorization/policyAssignments',
            'Microsoft.Authorization/policySetDefinitions',
            'Microsoft.Authorization/policyDefinitions'
            'Microsoft.Sql/managedInstances',
            'Microsoft.MachineLearningServices/workspaces',
            'Microsoft.Resources/resourceGroups',
            'Microsoft.Compute/virtualMachines'
        )

        Write-Verbose ('Handling resource removal with deployment names [{0}]' -f ($deploymentNames -join ', ')) -Verbose

        ### CODE LOCATION: Add custom removal sequence here
        ## Add custom module-specific removal sequence following the example below
        # $moduleName = Split-Path (Split-Path (Split-Path $templateFilePath -Parent) -Parent) -LeafBase
        # switch ($moduleName) {
        #     '<moduleName01>' {                # For example: 'virtualWans', 'automationAccounts'
        #         $removalSequence += @(
        #             '<resourceType01>',       # For example: 'Microsoft.Network/vpnSites', 'Microsoft.OperationalInsights/workspaces/linkedServices'
        #             '<resourceType02>',
        #             '<resourceType03>'
        #         )
        #         break
        #     }
        # }

        # Invoke removal
        $inputObject = @{
            DeploymentNames  = $DeploymentNames
            TemplateFilePath = $templateFilePath
            RemovalSequence  = $removalSequence
        }
        if (-not [String]::IsNullOrEmpty($resourceGroupName)) {
            $inputObject['resourceGroupName'] = $resourceGroupName
        }
        if (-not [String]::IsNullOrEmpty($ManagementGroupId)) {
            $inputObject['ManagementGroupId'] = $ManagementGroupId
        }
        Remove-Deployment @inputObject
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
