﻿<#
.SYNOPSIS
Remove deployed resources based on their deploymentName(s)

.DESCRIPTION
Remove deployed resources based on their deploymentName(s)

.PARAMETER DeploymentName(s)
Optional. The name(s) of the deployment(s). Combined with resources provide via the resource Id(s).

.PARAMETER ResourceId(s)
Optional. The resource Id(s) of the resources to remove. Combined with resources found via the deployment name(s).

.PARAMETER TemplateFilePath
Optional. The path to the template used for the deployment(s). Used to determine the level/scope (e.g. subscription). Required if deploymentName(s) are provided.

.PARAMETER ResourceGroupName
Optional. The name of the resource group the deployment was happening in. Relevant for resource-group level deployments.

.PARAMETER ManagementGroupId
Optional. The ID of the management group to fetch deployments from. Relevant for management-group level deployments.

.PARAMETER PurgeTestResources
Optional. Specify to fetch and remove all resources in the current context that match the 'dep-' pattern

.EXAMPLE
Initialize-DeploymentRemoval -DeploymentName 'n-vw-t1-20211204T1812029146Z' -TemplateFilePath "$home/ResourceModules/modules/network/virtual-wan/main.bicep" -resourceGroupName 'test-virtualWan-rg'

Remove the deployment 'n-vw-t1-20211204T1812029146Z' from resource group 'test-virtualWan-rg' that was executed using template in path "$home/ResourceModules/modules/network/virtual-wan/main.bicep"
#>
function Initialize-DeploymentRemoval {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Alias('DeploymentName')]
        [string[]] $DeploymentNames = @(),

        [Parameter(Mandatory = $false)]
        [Alias('ResourceId')]
        [string[]] $ResourceIds = @(),

        [Parameter(Mandatory = $false)]
        [string] $TemplateFilePath,

        [Parameter(Mandatory = $false)]
        [string] $ResourceGroupName,

        [Parameter(Mandatory = $false)]
        [string] $SubscriptionId,

        [Parameter(Mandatory = $false)]
        [string] $ManagementGroupId,

        [Parameter(Mandatory = $false)]
        [switch] $PurgeTestResources
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
        $RemoveFirstSequence = @(
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
            'Microsoft.Compute/virtualMachines',
            'Microsoft.VirtualMachineImages/imageTemplates', # Must be removed before their MSI
            'Microsoft.ManagedIdentity/userAssignedIdentities',
            'Microsoft.Resources/resourceGroups'
        )

        $removeLastSequence = @(
            'Microsoft.Subscription/aliases'
        )

        if ($DeploymentNames.Count -gt 0) {
            Write-Verbose 'Handling resource removal with deployment names' -Verbose
            foreach ($DeploymentName in $DeploymentNames) {
                Write-Verbose "- $DeploymentName" -Verbose
            }
        }
        if ($ResourceIds.Count -gt 0) {
            Write-Verbose 'Handling resource removal with resource Ids' -Verbose
            foreach ($ResourceId in $ResourceIds) {
                Write-Verbose "- $ResourceId" -Verbose
            }
        }

        ### CODE LOCATION: Add custom removal sequence here
        ## Add custom module-specific removal sequence following the example below
        # $moduleName = Split-Path (Split-Path (Split-Path $templateFilePath -Parent) -Parent) -LeafBase
        # switch ($moduleName) {
        #     '<moduleName01>' {                # For example: 'virtualWans', 'automationAccounts'
        #         $RemoveFirstSequence += @(
        #             '<resourceType01>',       # For example: 'Microsoft.Network/vpnSites', 'Microsoft.OperationalInsights/workspaces/linkedServices'
        #             '<resourceType02>',
        #             '<resourceType03>'
        #         )
        #         $RemoveLastSequence += @(
        #             '<resourceType01>',       # For example: 'Microsoft.Network/vpnSites', 'Microsoft.OperationalInsights/workspaces/linkedServices'
        #             '<resourceType02>',
        #             '<resourceType03>'
        #         )
        #         break
        #     }
        # }

        if ($PurgeTestResources) {
            # Resources
            $filteredResourceIds = (Get-AzResource).ResourceId | Where-Object { $_ -like '*dep-*' }
            $ResourceIds += ($filteredResourceIds | Sort-Object -Unique)

            # Resource groups
            $filteredResourceGroupIds = (Get-AzResourceGroup).ResourceId | Where-Object { $_ -like '*dep-*' }
            $ResourceIds += ($filteredResourceGroupIds | Sort-Object -Unique)
        }

        # Invoke removal
        $inputObject = @{
            DeploymentNames     = $DeploymentNames
            ResourceIds         = $ResourceIds
            TemplateFilePath    = $TemplateFilePath
            RemoveFirstSequence = $removeFirstSequence
            RemoveLastSequence  = $removeLastSequence
        }
        if (-not [String]::IsNullOrEmpty($TemplateFilePath)) {
            $inputObject['TemplateFilePath'] = $TemplateFilePath
        }
        if (-not [String]::IsNullOrEmpty($ResourceGroupName)) {
            $inputObject['ResourceGroupName'] = $ResourceGroupName
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
