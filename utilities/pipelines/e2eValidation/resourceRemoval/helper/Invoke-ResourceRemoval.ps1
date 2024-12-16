<#
.SYNOPSIS
Remove a specific resource

.DESCRIPTION
Remove a specific resource. Tries to handle different resource types accordingly

.PARAMETER ResourceId
Mandatory. The resourceID of the resource to remove

.PARAMETER Type
Mandatory. The type of the resource to remove

.EXAMPLE
Invoke-ResourceRemoval -Type 'Microsoft.Insights/diagnosticSettings' -ResourceId '/subscriptions/.../resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01/providers/Microsoft.Insights/diagnosticSettings/sxx-vm-linux-001-nic-01-diagnosticSettings'

Remove the resource 'sxx-vm-linux-001-nic-01-diagnosticSettings' of type 'Microsoft.Insights/diagnosticSettings' from resource '/subscriptions/.../resourceGroups/validation-rg/providers/Microsoft.Network/networkInterfaces/sxx-vm-linux-001-nic-01'
#>
function Invoke-ResourceRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceId,

        [Parameter(Mandatory = $true)]
        [string] $Type
    )
    # Load functions
    . (Join-Path $PSScriptRoot 'Invoke-ResourceLockRemoval.ps1')

    # Remove unhandled resource locks, for cases when the resource
    # collection is incomplete, usually due to previous removal failing.
    if ($PSCmdlet.ShouldProcess("Possible locks on resource with ID [$ResourceId]", 'Handle')) {
        Invoke-ResourceLockRemoval -ResourceId $ResourceId -Type $Type
    }

    switch ($Type) {
        'Microsoft.Insights/diagnosticSettings' {
            $parentResourceId = $ResourceId.Split('/providers/{0}' -f $Type)[0]
            $resourceName = Split-Path $ResourceId -Leaf
            if ($PSCmdlet.ShouldProcess("Diagnostic setting [$resourceName]", 'Remove')) {
                $null = Remove-AzDiagnosticSetting -ResourceId $parentResourceId -Name $resourceName
            }
            break
        }
        'Microsoft.Authorization/locks' {
            if ($PSCmdlet.ShouldProcess("Lock with ID [$ResourceId]", 'Remove')) {
                Invoke-ResourceLockRemoval -ResourceId $ResourceId -Type $Type
            }
            break
        }
        'Microsoft.KeyVault/vaults/keys' {
            $resourceName = Split-Path $ResourceId -Leaf
            Write-Verbose ('[/] Skipping resource [{0}] of type [{1}]. Reason: It is handled by different logic.' -f $resourceName, $Type) -Verbose
            # Also, we don't want to accidently remove keys of the dependency key vault
            break
        }
        'Microsoft.KeyVault/vaults/accessPolicies' {
            $resourceName = Split-Path $ResourceId -Leaf
            Write-Verbose ('[/] Skipping resource [{0}] of type [{1}]. Reason: It is handled by different logic.' -f $resourceName, $Type) -Verbose
            break
        }
        'Microsoft.ServiceBus/namespaces/authorizationRules' {
            if ((Split-Path $ResourceId '/')[-1] -eq 'RootManageSharedAccessKey') {
                Write-Verbose ('[/] Skipping resource [RootManageSharedAccessKey] of type [{0}]. Reason: The Service Bus''s default authorization key cannot be removed' -f $Type) -Verbose
            } else {
                if ($PSCmdlet.ShouldProcess("Resource with ID [$ResourceId]", 'Remove')) {
                    $null = Remove-AzResource -ResourceId $ResourceId -Force -ErrorAction 'Stop'
                }
            }
            break
        }
        'Microsoft.Compute/diskEncryptionSets' {
            # Pre-Removal
            # -----------
            # Remove access policies on key vault
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf

            $diskEncryptionSet = Get-AzDiskEncryptionSet -Name $resourceName -ResourceGroupName $resourceGroupName
            $keyVaultResourceId = $diskEncryptionSet.ActiveKey.SourceVault.Id
            $keyVaultName = Split-Path $keyVaultResourceId -Leaf
            $objectId = $diskEncryptionSet.Identity.PrincipalId

            if ($PSCmdlet.ShouldProcess(('Access policy [{0}] from key vault [{1}]' -f $objectId, $keyVaultName), 'Remove')) {
                $null = Remove-AzKeyVaultAccessPolicy -VaultName $keyVaultName -ObjectId $objectId
            }

            # Actual removal
            # --------------
            if ($PSCmdlet.ShouldProcess("Resource with ID [$ResourceId]", 'Remove')) {
                $null = Remove-AzResource -ResourceId $ResourceId -Force -ErrorAction 'Stop'
            }
            break
        }
        'Microsoft.RecoveryServices/vaults/backupstorageconfig' {
            # Not a 'resource' that can be removed, but represents settings on the RSV. The config is deleted with the RSV
            break
        }
        'Microsoft.Authorization/roleAssignments' {
            $idElem = $ResourceId.Split('/')
            $scope = $idElem[0..($idElem.Count - 5)] -join '/'
            $roleAssignmentsOnScope = Get-AzRoleAssignment -Scope $scope
            $null = $roleAssignmentsOnScope | Where-Object { $_.RoleAssignmentId -eq $ResourceId } | Remove-AzRoleAssignment
            break
        }
        'Microsoft.RecoveryServices/vaults' {
            # Pre-Removal
            # -----------
            # Remove protected VMs
            if ((Get-AzRecoveryServicesVaultProperty -VaultId $ResourceId).SoftDeleteFeatureState -ne 'Disabled') {
                if ($PSCmdlet.ShouldProcess(('Soft-delete on RSV [{0}]' -f $ResourceId), 'Set')) {
                    $null = Set-AzRecoveryServicesVaultProperty -VaultId $ResourceId -SoftDeleteFeatureState 'Disable'
                }
            }

            $backupItems = Get-AzRecoveryServicesBackupItem -BackupManagementType 'AzureVM' -WorkloadType 'AzureVM' -VaultId $ResourceId
            foreach ($backupItem in $backupItems) {
                Write-Verbose ('Removing Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $ResourceId) -Verbose

                if ($backupItem.DeleteState -eq 'ToBeDeleted') {
                    if ($PSCmdlet.ShouldProcess('Soft-deleted backup data removal', 'Undo')) {
                        $null = Undo-AzRecoveryServicesBackupItemDeletion -Item $backupItem -VaultId $ResourceId -Force
                    }
                }

                if ($PSCmdlet.ShouldProcess(('Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $ResourceId), 'Remove')) {
                    $null = Disable-AzRecoveryServicesBackupProtection -Item $backupItem -VaultId $ResourceId -RemoveRecoveryPoints -Force
                }
            }

            # Actual removal
            # --------------
            if ($PSCmdlet.ShouldProcess("Resource with ID [$ResourceId]", 'Remove')) {
                $null = Remove-AzResource -ResourceId $ResourceId -Force -ErrorAction 'Stop'
            }
            break
        }
        'Microsoft.OperationalInsights/workspaces' {
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf
            # Force delete workspace (cannot be recovered)
            if ($PSCmdlet.ShouldProcess("Log Analytics Workspace [$resourceName]", 'Remove')) {
                Write-Verbose ('[*] Purging resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
                $null = Remove-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $resourceName -Force -ForceDelete
            }
            break
        }
        'Microsoft.VirtualMachineImages/imageTemplates' {
            # Note: If you ever run into the issue that you cannot remove the image template because of an issue with the MSI (e.g., because the below logic was not executed in the pipeline), you can follow these manual steps:
            # 1. Unassign the existing MSI (az image builder identity remove --resource-group <itRg> --name <itName> --user-assigned <msiResourceId> --yes)
            # 2. Trigger image template removal (will fail, but remove the cached 'running' state)
            # 3. Assign a new MSI (az image builder identity assign --resource-group <itRg> --name <itName> --user-assigned <msiResourceId>)
            # 4. Trigger image template removal again, which removes the resource for good

            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf

            # Remove resource
            if ($PSCmdlet.ShouldProcess("Image Template [$resourceName]", 'Remove')) {

                $removeRequestInputObject = @{
                    Method = 'DELETE'
                    Path   = '/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.VirtualMachineImages/imageTemplates/{2}?api-version=2022-07-01' -f $subscriptionId, $resourceGroupName, $resourceName
                }
                $removalResponse = Invoke-AzRestMethod @removeRequestInputObject
                if ($removalResponse.StatusCode -notlike '2*') {
                    $responseContent = $removalResponse.Content | ConvertFrom-Json
                    throw ('{0} : {1}' -f $responseContent.error.code, $responseContent.error.message)
                }

                # Wait for template to be removed. If we don't wait, it can happen that its MSI is removed too soon, locking the resource from deletion
                $retryCount = 1
                $retryLimit = 240
                $retryInterval = 15
                do {
                    $getRequestInputObject = @{
                        Method = 'GET'
                        Path   = '/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.VirtualMachineImages/imageTemplates/{2}?api-version=2022-07-01' -f $subscriptionId, $resourceGroupName, $resourceName
                    }
                    $getReponse = Invoke-AzRestMethod @getRequestInputObject

                    if ($getReponse.StatusCode -eq 400) {
                        # Invalid request
                        throw ($imageTgetReponseemplate.Content | ConvertFrom-Json).error.message
                    } elseif ($getReponse.StatusCode -eq 404) {
                        # Resource not found, removal was successful
                        $templateExists = $false
                    } elseif ($getReponse.StatusCode -eq '200') {
                        # Resource still around - try again
                        $templateExists = $true
                        Write-Verbose ('    [⏱️] Waiting {0} seconds for Image Template to be removed. [{1}/{2}]' -f $retryInterval, $retryCount, $retryLimit) -Verbose
                        Start-Sleep -Seconds $retryInterval
                        $retryCount++
                    } else {
                        throw ('Failed request. Response: [{0}]' -f ($getReponse | Out-String))
                    }
                } while ($templateExists -and $retryCount -lt $retryLimit)

                if ($retryCount -ge $retryLimit) {
                    Write-Warning ('    [!] Image Template [{0}] was not removed after {1} seconds. Continuing with resource removal.' -f $resourceName, ($retryCount * $retryInterval))
                    break
                }
            }
            break
        }
        'Microsoft.MachineLearningServices/workspaces' {
            $subscriptionId = $ResourceId.Split('/')[2]
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf

            # Purge service
            $purgePath = '/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.MachineLearningServices/workspaces/{2}?api-version=2023-06-01-preview&forceToPurge=true' -f $subscriptionId, $resourceGroupName, $resourceName
            $purgeRequestInputObject = @{
                Method = 'DELETE'
                Path   = $purgePath
            }
            Write-Verbose ('[*] Purging resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
            if ($PSCmdlet.ShouldProcess("Machine Learning Workspace [$resourceName]", 'Purge')) {
                $purgeResource = Invoke-AzRestMethod @purgeRequestInputObject
                if ($purgeResource.StatusCode -notlike '2*') {
                    $responseContent = $purgeResource.Content | ConvertFrom-Json
                    throw ('{0} : {1}' -f $responseContent.error.code, $responseContent.error.message)
                }

                # Wait for workspace to be purged. If it is not purged it has a chance of being soft-deleted via RG deletion (not purged)
                # The consecutive deployments will fail because it is not purged.
                $retryCount = 0
                $retryLimit = 240
                $retryInterval = 15
                do {
                    $retryCount++
                    if ($retryCount -ge $retryLimit) {
                        Write-Warning ('    [!] Workspace [{0}] was not purged after {1} seconds. Continuing with resource removal.' -f $resourceName, ($retryCount * $retryInterval))
                        break
                    }
                    Write-Verbose ('    [⏱️] Waiting {0} seconds for workspace to be purged.' -f $retryInterval) -Verbose
                    Start-Sleep -Seconds $retryInterval
                    $workspace = Get-AzMLWorkspace -Name $resourceName -ResourceGroupName $resourceGroupName -SubscriptionId $subscriptionId -ErrorAction SilentlyContinue
                    $workspaceExists = $workspace.count -gt 0
                } while ($workspaceExists)
            }
            break
        }
        { $PSItem -eq 'Microsoft.Subscription/aliases' -and $ResourceId -like '*dep-sub-blzv-tests*ssa*' } {
            $subscriptionName = $ResourceId.Split('/')[4]
            $subscription = Get-AzSubscription | Where-Object { $_.Name -eq $subscriptionName }
            $subscriptionId = $subscription.Id
            $subscriptionState = $subscription.State

            $null = Select-AzSubscription -SubscriptionId $subscriptionId -WarningAction 'SilentlyContinue'

            # Delete NetworkWatcher resource group
            if ((Get-AzResourceGroup -Name 'NetworkWatcherRG' -ErrorAction SilentlyContinue)) {
                if ($PSCmdlet.ShouldProcess('Resource Group [NetworkWatcherRG]', 'Remove')) {
                    $null = Remove-AzResourceGroup -Name 'NetworkWatcherRG' -Force
                }
            }

            # Moving Subscription to Management Group: bicep-lz-vending-automation-decom
            if (-not (Get-AzManagementGroupSubscription -GroupName 'bicep-lz-vending-automation-decom' -SubscriptionId $subscriptionId -ErrorAction 'SilentlyContinue')) {
                if ($PSCmdlet.ShouldProcess("Subscription [$subscriptionName] to Management Group: bicep-lz-vending-automation-decom", 'Move')) {
                    $null = New-AzManagementGroupSubscription -GroupName 'bicep-lz-vending-automation-decom' -SubscriptionId $subscriptionId
                }
            }

            if ($subscriptionState -eq 'Enabled') {
                Write-Verbose ('[*] Disabling resource [{0}] of type [{1}]' -f $subscriptionName, $Type) -Verbose
                if ($PSCmdlet.ShouldProcess("Subscription [$subscriptionName]", 'Remove')) {
                    $null = Disable-AzSubscription -SubscriptionId $subscriptionId -Confirm:$false
                }
            }
            break
        }
        ### CODE LOCATION: Add custom removal action here
        Default {
            if ($PSCmdlet.ShouldProcess("Resource with ID [$ResourceId]", 'Remove')) {
                $null = Remove-AzResource -ResourceId $ResourceId -Force -ErrorAction 'Stop'
            }
        }
    }
}
