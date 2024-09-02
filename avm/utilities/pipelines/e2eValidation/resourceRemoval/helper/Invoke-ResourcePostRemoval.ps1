<#
.SYNOPSIS
Remove any artifacts that remain of the given resource

.DESCRIPTION
Remove any artifacts that remain of the given resource. For example, some resources such as key vaults usually go into a soft-delete state from which we want to purge them from.

.PARAMETER ResourceId
Mandatory. The resourceID of the resource to remove

.PARAMETER Type
Mandatory. The type of the resource to remove

.PARAMETER PostRemovalRetryLimit
Optional. Specify the number of times the script should try to repeat the post-removal operation in case of a failure.

.EXAMPLE
Invoke-ResourcePostRemoval -Type 'Microsoft.KeyVault/vaults' -ResourceId '/subscriptions/.../resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/myVault'

Purge the resource 'myVault' of type 'Microsoft.KeyVault/vaults' with ID '/subscriptions/.../resourceGroups/validation-rg/providers/Microsoft.KeyVault/vaults/myVault' if no purge protection is enabled
#>
function Invoke-ResourcePostRemoval {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ResourceId,

        [Parameter(Mandatory = $true)]
        [string] $Type,

        [Parameter(Mandatory = $false)]
        [int] $PostRemovalRetryLimit = 3
    )

    $postRemovalRetryCount = 1
    do {
        try {
            switch ($Type) {
                'Microsoft.AppConfiguration/configurationStores' {
                    $subscriptionId = $ResourceId.Split('/')[2]
                    $resourceName = Split-Path $ResourceId -Leaf

                    # Fetch service in soft-delete
                    $getPath = '/subscriptions/{0}/providers/Microsoft.AppConfiguration/deletedConfigurationStores?api-version=2021-10-01-preview' -f $subscriptionId
                    $getRequestInputObject = @{
                        Method = 'GET'
                        Path   = $getPath
                    }
                    $softDeletedConfigurationStore = ((Invoke-AzRestMethod @getRequestInputObject).Content | ConvertFrom-Json).value | Where-Object { $_.properties.configurationStoreId -eq $ResourceId }

                    if ($softDeletedConfigurationStore) {
                        # Purge service
                        $purgePath = '/subscriptions/{0}/providers/Microsoft.AppConfiguration/locations/{1}/deletedConfigurationStores/{2}/purge?api-version=2021-10-01-preview' -f $subscriptionId, $softDeletedConfigurationStore.properties.location, $resourceName
                        $purgeRequestInputObject = @{
                            Method = 'POST'
                            Path   = $purgePath
                        }
                        Write-Verbose ('[*] Purging resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
                        if ($PSCmdlet.ShouldProcess(('App Configuration Store with ID [{0}]' -f $softDeletedConfigurationStore.properties.configurationStoreId), 'Purge')) {
                            $response = Invoke-AzRestMethod @purgeRequestInputObject
                            if ($response.StatusCode -ne 200) {
                                throw ('Purge of resource [{0}] failed with error code [{1}]' -f $ResourceId, $response.StatusCode)
                            }
                        }
                    }
                    break
                }
                'Microsoft.KeyVault/vaults' {
                    $resourceName = Split-Path $ResourceId -Leaf

                    $matchingKeyVault = Get-AzKeyVault -InRemovedState | Where-Object { $_.resourceId -eq $ResourceId }
                    if ($matchingKeyVault -and -not $matchingKeyVault.EnablePurgeProtection) {
                        Write-Verbose ('[*] Purging resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
                        if ($PSCmdlet.ShouldProcess(('Key Vault with ID [{0}]' -f $matchingKeyVault.Id), 'Purge')) {
                            try {
                                $null = Remove-AzKeyVault -ResourceId $matchingKeyVault.Id -InRemovedState -Force -Location $matchingKeyVault.Location -ErrorAction 'Stop'
                            } catch {
                                if ($_.Exception.Message -like '*DeletedVaultPurge*') {
                                    Write-Warning ('Purge protection for key vault [{0}] enabled. Skipping. Scheduled purge date is [{1}]' -f $resourceName, $matchingKeyVault.ScheduledPurgeDate)
                                } else {
                                    throw $_
                                }
                            }
                        }
                    }
                    break
                }
                'Microsoft.CognitiveServices/accounts' {
                    $resourceGroupName = $ResourceId.Split('/')[4]
                    $resourceName = Split-Path $ResourceId -Leaf

                    $matchingAccount = Get-AzCognitiveServicesAccount -InRemovedState | Where-Object { $_.AccountName -eq $resourceName }
                    if ($matchingAccount) {
                        Write-Verbose ('[*] Purging resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
                        if ($PSCmdlet.ShouldProcess(('Cognitive services account with ID [{0}]' -f $matchingAccount.Id), 'Purge')) {
                            $null = Remove-AzCognitiveServicesAccount -InRemovedState -Force -Location $matchingAccount.Location -ResourceGroupName $resourceGroupName -Name $matchingAccount.AccountName
                        }
                    }
                    break
                }
                'Microsoft.ApiManagement/service' {
                    $subscriptionId = $ResourceId.Split('/')[2]
                    $resourceName = Split-Path $ResourceId -Leaf

                    # Fetch service in soft-delete
                    $getPath = '/subscriptions/{0}/providers/Microsoft.ApiManagement/deletedservices?api-version=2021-08-01' -f $subscriptionId
                    $getRequestInputObject = @{
                        Method = 'GET'
                        Path   = $getPath
                    }
                    $softDeletedService = ((Invoke-AzRestMethod @getRequestInputObject).Content | ConvertFrom-Json).value | Where-Object { $_.properties.serviceId -eq $ResourceId }

                    if ($softDeletedService) {
                        # Purge service
                        $purgePath = '/subscriptions/{0}/providers/Microsoft.ApiManagement/locations/{1}/deletedservices/{2}?api-version=2020-06-01-preview' -f $subscriptionId, $softDeletedService.location, $resourceName
                        $purgeRequestInputObject = @{
                            Method = 'DELETE'
                            Path   = $purgePath
                        }
                        Write-Verbose ('[*] Purging resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
                        if ($PSCmdlet.ShouldProcess(('API management service with ID [{0}]' -f $softDeletedService.properties.serviceId), 'Purge')) {
                            $null = Invoke-AzRestMethod @purgeRequestInputObject
                        }
                    }
                    break
                }
                'Microsoft.RecoveryServices/vaults/backupFabrics/protectionContainers/protectedItems' {
                    # Remove protected VM
                    # Required if e.g. a VM was listed in an RSV and only that VM is removed
                    $vaultId = $ResourceId.split('/backupFabrics/')[0]
                    $resourceName = Split-Path $ResourceId -Leaf
                    $softDeleteStatus = (Get-AzRecoveryServicesVaultProperty -VaultId $vaultId).SoftDeleteFeatureState
                    if ($softDeleteStatus -ne 'Disabled') {
                        if ($PSCmdlet.ShouldProcess(('Soft-delete on RSV [{0}]' -f $vaultId), 'Set')) {
                            $null = Set-AzRecoveryServicesVaultProperty -VaultId $vaultId -SoftDeleteFeatureState 'Disable'
                        }
                    }

                    $backupItemInputObject = @{
                        BackupManagementType = 'AzureVM'
                        WorkloadType         = 'AzureVM'
                        VaultId              = $vaultId
                        Name                 = $resourceName
                    }
                    if ($backupItem = Get-AzRecoveryServicesBackupItem @backupItemInputObject -ErrorAction 'SilentlyContinue') {
                        Write-Verbose ('    [-] Removing Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $vaultId) -Verbose

                        if ($backupItem.DeleteState -eq 'ToBeDeleted') {
                            if ($PSCmdlet.ShouldProcess('Soft-deleted backup data removal', 'Undo')) {
                                $null = Undo-AzRecoveryServicesBackupItemDeletion -Item $backupItem -VaultId $vaultId -Force
                            }
                        }

                        if ($PSCmdlet.ShouldProcess(('Backup item [{0}] from RSV [{1}]' -f $backupItem.Name, $vaultId), 'Remove')) {
                            $null = Disable-AzRecoveryServicesBackupProtection -Item $backupItem -VaultId $vaultId -RemoveRecoveryPoints -Force
                        }
                    }

                    # Undo a potential soft delete state change
                    $null = Set-AzRecoveryServicesVaultProperty -VaultId $vaultId -SoftDeleteFeatureState $softDeleteStatus.TrimEnd('d')
                    break
                }
                'Microsoft.Databricks/workspaces' {
                    $resourceGroupName = $ResourceId.Split('/')[4]
                    $resourceName = Split-Path $ResourceId -Leaf
                    # If the `managedResourceGroupResourceId` parameter was set during deployment, we should look for that resource group and remove it as it is not automatically removed
                    # NOTE: This requires that the provided value uses the prefix `rg-` and suffix '-managed'
                    $managedResourceGroupName = "rg-$resourceGroupName-managed"
                    if (Get-AzResourceGroup -Name $managedResourceGroupName -ErrorAction 'SilentlyContinue') {
                        Write-Verbose ('[*] Removing managed resource group [{0}] of workspace [{1}]' -f $managedResourceGroupName, $resourceName) -Verbose
                        if ($PSCmdlet.ShouldProcess(('Managed resource group [{0}]' -f $managedResourceGroupName), 'Remove')) {
                            $null = Remove-AzResourceGroup -Name $managedResourceGroupName -Force
                        }
                    }
                    # If the `managedResourceGroupResourceId` parameter was NOT set during deployment, we should look for a resource group with the default name and remove it as it is not automatically removed
                    # NOTE: This requires that the default value uses the prefix 'rg-'
                    $defaultManagedResourceGroupName = "rg-$resourceName-managed"
                    if (Get-AzResourceGroup -Name $defaultManagedResourceGroupName -ErrorAction 'SilentlyContinue') {
                        Write-Verbose ('[*] Removing managed resource group [{0}] of workspace [{1}]' -f $defaultManagedResourceGroupName, $resourceName) -Verbose
                        if ($PSCmdlet.ShouldProcess(('Managed resource group [{0}]' -f $defaultManagedResourceGroupName), 'Remove')) {
                            $null = Remove-AzResourceGroup -Name $defaultManagedResourceGroupName -Force
                        }
                    }
                    break
                }
                ### CODE LOCATION: Add custom post-removal operation here
            }
            break # Post-removal was successful
        } catch {
            Write-Warning ('[!] Post-removal operation failed. Reason: [{0}]. Retry [{1}/{2}]' -f $_.Exception.Message, $removalRetryCount, $PostRemovalRetryLimit)
            $removalRetryCount++
        }
    } while ($postRemovalRetryCount -le $PostRemovalRetryLimit)
}
