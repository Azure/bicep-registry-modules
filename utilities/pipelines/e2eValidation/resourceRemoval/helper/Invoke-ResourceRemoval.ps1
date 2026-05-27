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
        'Microsoft.KeyVault/managedHSMs/keys' {
            $parentName = $ResourceId.Split('/')[8]
            $resourceName = Split-Path $ResourceId -Leaf
            $hSMKeyUri = 'https://{0}.managedhsm.azure.net/keys/{1}' -f $parentName, $resourceName

            # Remove resource
            if ($PSCmdlet.ShouldProcess("Managed HSM key [$hSMKeyUri]", 'Remove')) {
                $hSMKeyApiUri = '{0}?api-version=2025-05-01' -f $hSMKeyUri
                $removeRequestInputObject = @{
                    Method = 'DELETE'
                    Uri    = $hSMKeyApiUri
                }
                $hSMKeyState = Invoke-AzRestMethod @removeRequestInputObject
                $hSMKeyStateContent = $hSMKeyState.Content | ConvertFrom-Json
                if ($hSMKeyState.StatusCode -notlike '2*') {
                    throw ('{0} : {1}' -f $hSMKeyStateContent.error.code, $hSMKeyStateContent.error.message)
                }
            }
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
        'Microsoft.Authorization/roleEligibilityScheduleRequests' {
            $idElem = $ResourceId.Split('/')
            $scope = $idElem[0..($idElem.Count - 5)] -join '/'
            $pimRequestName = $idElem[-1]
            $pimRoleAssignment = Get-AzRoleEligibilityScheduleRequest -Scope $scope -Name $pimRequestName
            if ($pimRoleAssignment) {
                $pimRoleAssignmentPrinicpalId = $pimRoleAssignment.PrincipalId
                $pimRoleAssignmentRoleDefinitionId = $pimRoleAssignment.RoleDefinitionId
                $guid = New-Guid
                # PIM role assignments cannot be removed before 5 minutes from being created. Waiting for 5 minutes
                Write-Verbose 'Waiting for 5 minutes before removing PIM role assignment' -Verbose
                Start-Sleep -Seconds 300
                # The PIM ARM API doesn't support DELETE requests so the only way to delete an assignment is by creating a new assignment with `AdminRemove` type using a new GUID
                $removalInputObject = @{
                    Name             = $guid
                    Scope            = $scope
                    PrincipalId      = $pimRoleAssignmentPrinicpalId
                    RequestType      = 'AdminRemove'
                    RoleDefinitionId = $pimRoleAssignmentRoleDefinitionId
                }
                $null = New-AzRoleEligibilityScheduleRequest @removalInputObject

            }
            break
        }
        'Microsoft.Authorization/roleAssignmentScheduleRequests' {
            $idElem = $ResourceId.Split('/')
            $scope = $idElem[0..($idElem.Count - 5)] -join '/'
            $pimRequestName = $idElem[-1]
            $pimRoleAssignment = Get-AzRoleAssignmentScheduleRequest -Scope $scope -Name $pimRequestName
            if ($pimRoleAssignment) {
                $pimRoleAssignmentPrinicpalId = $pimRoleAssignment.PrincipalId
                $pimRoleAssignmentRoleDefinitionId = $pimRoleAssignment.RoleDefinitionId
                $guid = New-Guid
                # PIM role assignments cannot be removed before 5 minutes from being created. Waiting for 5 minutes
                Write-Verbose 'Waiting for 5 minutes before removing PIM role assignment' -Verbose
                Start-Sleep -Seconds 300
                # The PIM ARM API doesn't support DELETE requests so the only way to delete an assignment is by creating a new assignment with `AdminRemove` type using a new GUID
                $removalInputObject = @{
                    Name             = $guid
                    Scope            = $scope
                    PrincipalId      = $pimRoleAssignmentPrinicpalId
                    RequestType      = 'AdminRemove'
                    RoleDefinitionId = $pimRoleAssignmentRoleDefinitionId
                }
                $null = New-AzRoleAssignmentScheduleRequest @removalInputObject
            }
            break
        }
        'Microsoft.Cdn/profiles' {
            # Removing custom removal logic as the default `Remove-AzResource` does not correctly handle the resource's inner workings
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf
            $cdnProfile = az cdn profile show --resource-group $resourceGroupName --name $resourceName
            if ($cdnProfile) {
                if ($PSCmdlet.ShouldProcess("Resource with ID [$ResourceId]", 'Remove')) {
                    az cdn profile delete --resource-group $resourceGroupName --name $resourceName
                }
            } else {
                Write-Warning "Unable to find CDN profile [$resourceName] in resource group [$resourceGroupName]"
            }
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
        'Microsoft.DataProtection/backupVaults' {
            # Note: This Resource Provider does not allow deleting the vault as long as it has nested resources
            # Pre-Removal
            # -----------
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf
            $vault = Get-AzDataProtectionBackupVault -ResourceGroupName $resourceGroupName -VaultName $resourceName

            # Disable vault immutability
            if ($vault.ImmutabilityState -ne 'Disabled') {
                Write-Verbose ('    [-] Disabling immutability on vault [{0}]' -f $resourceName) -Verbose
                if ($PSCmdlet.ShouldProcess(('Immutability on vault [{0}]' -f $resourceName), 'Update')) {
                    $null = Update-AzDataProtectionBackupVault -ResourceGroupName $resourceGroupName -VaultName $resourceName -ImmutabilityState Disabled
                }
            }

            # Disable vault soft-deletion
            if ($vault.SoftDeleteState -ne 'Off') {
                Write-Verbose ('    [-] Disabling soft-deletion on vault [{0}]' -f $resourceName) -Verbose
                if ($PSCmdlet.ShouldProcess(('Soft-delete on vault [{0}]' -f $resourceName), 'Update')) {
                    $null = Update-AzDataProtectionBackupVault -ResourceGroupName $resourceGroupName -VaultName $resourceName -SoftDeleteState Off
                }
            }

            # Undo soft-deleted backup instances
            $softDeletedBackupInstances = Get-AzDataProtectionSoftDeletedBackupInstance -ResourceGroupName $resourceGroupName -VaultName $resourceName
            foreach ($softDeletedBackupInstance in $softDeletedBackupInstances) {
                Write-Verbose ('    [-] Removing Backup instance soft deletion [{0}] from vault [{1}]' -f $softDeletedBackupInstance.Name, $resourceName) -Verbose
                if ($PSCmdlet.ShouldProcess(('Soft deletion on backup instance [{0}] from vault [{1}]' -f $softDeletedBackupInstance.Name, $resourceName), 'Undo')) {
                    $null = Undo-AzDataProtectionBackupInstanceDeletion -ResourceGroupName $resourceGroupName -VaultName $resourceName -BackupInstanceName $softDeletedBackupInstance.name
                }
            }

            # Actual removal
            # --------------
            # Remove backup instances
            $backupInstances = Get-AzDataProtectionBackupInstance -ResourceGroupName $resourceGroupName -VaultName $resourceName
            foreach ($backupInstance in $backupInstances) {
                Write-Verbose ('    [-] Removing Backup instance [{0}] from vault [{1}]' -f $backupInstance.Name, $resourceName) -Verbose
                if ($PSCmdlet.ShouldProcess(('Backup instance [{0}] from vault [{1}]' -f $backupInstance.Name, $resourceName), 'Remove')) {
                    $null = Remove-AzDataProtectionBackupInstance -ResourceGroupName $resourceGroupName -VaultName $resourceName -Name $backupInstance.name
                }
            }

            # Remove backup policies
            $backupPolicies = Get-AzDataProtectionBackupPolicy -ResourceGroupName $resourceGroupName -VaultName $resourceName
            foreach ($backupPolicy in $backupPolicies) {
                Write-Verbose ('    [-] Removing Backup policy [{0}] from vault [{1}]' -f $backupPolicy.Name, $resourceName) -Verbose
                if ($PSCmdlet.ShouldProcess(('Backup instance [{0}] from vault [{1}]' -f $backupPolicy.Name, $resourceName), 'Remove')) {
                    $null = Remove-AzDataProtectionBackupPolicy -ResourceGroupName $resourceGroupName -VaultName $resourceName -Name $backupPolicy.name
                }
            }

            # Remove backup vault
            Write-Verbose ('    [-] Removing Backup vault [{0}]' -f $resourceName) -Verbose
            if ($PSCmdlet.ShouldProcess("Backup vault with ID [$ResourceId]", 'Remove')) {
                $null = Remove-AzDataProtectionBackupVault -ResourceGroupName $resourceGroupName -VaultName $resourceName
            }
            break
        }
        'Microsoft.OperationalInsights/workspaces' {
            # If the workspace has been deployed with replication enabled, we need to disable it first,
            # otherwise the associated data collection endpoint cannot be removed.
            # The replication cannot be disabled within the first hour after it has been enabled.
            # If the workspace has not been deployed with replication enabled, we can remove it directly.
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf
            $subscriptionId = $ResourceId.Split('/')[2]

            # Get the workspace state to check if replication is enabled
            $workspaceApiPath = '/subscriptions/{0}/resourceGroups/{1}/providers/Microsoft.OperationalInsights/workspaces/{2}?api-version=2025-02-01' -f $subscriptionId, $resourceGroupName, $resourceName
            $getWorkspaceStateInputObject = @{
                Method = 'GET'
                Path   = $workspaceApiPath
            }
            $workspaceState = Invoke-AzRestMethod @getWorkspaceStateInputObject
            $workspaceStateContent = $workspaceState.Content | ConvertFrom-Json
            if ($workspaceState.StatusCode -notlike '2*') {
                throw ('{0} : {1}' -f $workspaceStateContent.error.code, $workspaceStateContent.error.message)
            }

            # Handle workspace replication if it is enabled
            if ($workspaceStateContent.properties.replication.enabled) {
                $retryCount = 1
                $retryLimit = 90
                $retryInterval = 60
                $replicationCreated = [DateTime]$workspaceStateContent.properties.replication.createdDate

                do {
                    # No need to check the replication state in the first hour after it has been enabled, as any attempt to disable it will fail.
                    if ([DateTime]::UtcNow -lt $replicationCreated.AddHours(1)) {
                        $timeLeft = [int]($replicationCreated.AddHours(1) - [DateTime]::UtcNow).TotalSeconds
                        Write-Verbose ('    [⏱️] Waiting {0} minutes to ensure at least 1 hour has passed since replication creation time [{1}] (UTC).' -f [int]($timeLeft / 60), $replicationCreated) -Verbose
                        Start-Sleep -Seconds ([int]$timeLeft + 10)  # Add 10 seconds to ensure we are past the hour mark
                        $retryCount++
                        continue
                    }

                    # After the first hour, check if the workspace replication is in a state that allows disabling
                    $getWorkspaceState = Invoke-AzRestMethod @getWorkspaceStateInputObject
                    $workspaceStateContent = $getWorkspaceState.Content | ConvertFrom-Json
                    if ($getWorkspaceState.StatusCode -notlike '2*') {
                        throw ('{0} : {1}' -f $workspaceStateContent.error.code, $workspaceStateContent.error.message)
                    }

                    if ($workspaceStateContent.properties.replication.provisioningState -eq 'Succeeded') {
                        Write-Verbose ('    [✔️] Workspace replication is in a state that allows disabling.') -Verbose
                        $replicationFullyProvisioned = $true
                        break
                    } else {
                        $replicationFullyProvisioned = $false
                        Write-Verbose ('    [⏱️] Waiting {0} seconds for workspace replication to finish provisioning. [{1}/{2}]' -f $retryInterval, $retryCount, $retryLimit) -Verbose
                        Start-Sleep -Seconds $retryInterval
                        $retryCount++
                    }
                } while (-not $replicationFullyProvisioned -and $retryCount -lt $retryLimit)

                if ($retryCount -ge $retryLimit) {
                    Write-Warning ('    [!] Workspace replication was not finished after {0} seconds. Continuing with resource removal.' -f ($retryCount * $retryInterval))
                }

                # Disable workspace replication
                $disableReplicationInputObject = @{
                    Method  = 'PUT'
                    Path    = $workspaceApiPath
                    Payload = @{
                        properties = @{
                            replication = @{
                                enabled = $false
                            }
                        }
                        location   = $workspaceStateContent.location
                    } | ConvertTo-Json -Depth 10
                }
                Write-Verbose ('[*] Disabling workspace replication for resource [{0}] of type [{1}]' -f $resourceName, $Type) -Verbose
                if ($PSCmdlet.ShouldProcess("Log Analytics Workspace [$resourceName]", 'Disable replication')) {
                    $disableReplicationResponse = Invoke-AzRestMethod @disableReplicationInputObject
                    if ($disableReplicationResponse.StatusCode -notlike '2*') {
                        $responseContent = $disableReplicationResponse.Content | ConvertFrom-Json
                        throw ('{0} : {1}' -f $responseContent.error.code, $responseContent.error.message)
                    }

                    # Wait for workspace replication to be disabled
                    $retryCount = 1
                    $retryLimit = 240
                    $retryInterval = 15
                    do {
                        $getWorkspaceState = Invoke-AzRestMethod @getWorkspaceStateInputObject
                        $workspaceStateContent = $getWorkspaceState.Content | ConvertFrom-Json
                        if ($getWorkspaceState.StatusCode -notlike '2*') {
                            throw ('{0} : {1}' -f $workspaceStateContent.error.code, $workspaceStateContent.error.message)
                        }

                        if (-not $workspaceStateContent.properties.replication.enabled -and $workspaceStateContent.properties.replication.provisioningState -eq 'Succeeded') {
                            Write-Verbose ('    [✔️] Workspace replication is disabled.') -Verbose
                            break
                        } else {
                            Write-Verbose ('    [⏱️] Waiting {0} seconds for workspace replication to be disabled. [{1}/{2}]' -f $retryInterval, $retryCount, $retryLimit) -Verbose
                            Start-Sleep -Seconds $retryInterval
                            $retryCount++
                        }
                    } while (($workspaceStateContent.properties.replication.enabled -or $workspaceStateContent.properties.replication.provisioningState -ne 'Succeeded') -and $retryCount -lt $retryLimit)
                    Start-Sleep -Seconds 30  # Additional wait to ensure replication is fully disabled and avoid leftovers in the Entra ID

                    if ($retryCount -ge $retryLimit) {
                        Write-Warning ('    [!] Workspace replication was not disabled after {0} seconds. Continuing with resource removal.' -f ($retryCount * $retryInterval))
                    }
                }
            }

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
            $subscriptionId = $ResourceId.Split('/')[2]

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
                    $getResponse = Invoke-AzRestMethod @getRequestInputObject

                    if ($getResponse.StatusCode -eq 400) {
                        # Invalid request
                        throw ($getResponse.Content | ConvertFrom-Json).error.message
                    } elseif ($getResponse.StatusCode -eq 404) {
                        # Resource not found, removal was successful
                        $templateExists = $false
                    } elseif ($getResponse.StatusCode -eq '200') {
                        # Resource still around - try again
                        $templateExists = $true
                        Write-Verbose ('    [⏱️] Waiting {0} seconds for Image Template to be removed. [{1}/{2}]' -f $retryInterval, $retryCount, $retryLimit) -Verbose
                        Start-Sleep -Seconds $retryInterval
                        $retryCount++
                    } else {
                        throw ('Failed request. Response: [{0}]' -f ($getResponse | Out-String))
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
        { $PSItem -eq 'Microsoft.Subscription/aliases' -and $ResourceId -like '*dep-sub-blzv-tests*' } {
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
                Write-Verbose ('[*] Moving resource [{0}] of type [{1}] to management group: bicep-lz-vending-automation-decom' -f $subscriptionName, $Type) -Verbose
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
        'Microsoft.ApiManagement/service' {
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf
            $subscriptionId = $ResourceId.Split('/')[2]

            # Check if the APIM service exists
            $apimService = az apim show --resource-group $resourceGroupName --name $resourceName 2>$null
            if ($apimService) {
                $apimLocation = ($apimService | ConvertFrom-Json).location

                # Delete the APIM service (with retry for ServiceLocked / transitioning state)
                $retryCount = 0
                $retryLimit = 30
                $retryInterval = 60
                $deleteSucceeded = $false

                do {
                    $retryCount++
                    Write-Verbose ('[*] Removing API Management service [{0}] from resource group [{1}] (attempt [{2}/{3}])' -f $resourceName, $resourceGroupName, $retryCount, $retryLimit) -Verbose

                    if ($PSCmdlet.ShouldProcess("API Management service [$resourceName]", 'Remove')) {
                        $deleteOutput = az apim delete --resource-group $resourceGroupName --name $resourceName --yes 2>&1

                        if ($LASTEXITCODE -eq 0) {
                            $deleteSucceeded = $true
                            Write-Verbose ('[✔️] Successfully initiated deletion of API Management service [{0}]' -f $resourceName) -Verbose
                        } else {
                            $deleteOutputString = $deleteOutput | Out-String
                            if ($deleteOutputString -match 'ServiceLocked|transitioning') {
                                Write-Verbose ('    [⏱️] API Management service [{0}] is transitioning. Waiting {1} seconds before retrying. [{2}/{3}]' -f $resourceName, $retryInterval, $retryCount, $retryLimit) -Verbose
                                Start-Sleep -Seconds $retryInterval
                            } else {
                                Write-Warning ('[!] Failed to delete API Management service [{0}]: {1}' -f $resourceName, $deleteOutputString)
                                break
                            }
                        }
                    } else {
                        break
                    }
                } while (-not $deleteSucceeded -and $retryCount -lt $retryLimit)

                if (-not $deleteSucceeded) {
                    if ($retryCount -ge $retryLimit) {
                        Write-Warning ('[!] Failed to delete API Management service [{0}] after [{1}] attempts.' -f $resourceName, $retryCount)
                    }
                    break
                }

                # Wait for the service to be fully soft-deleted before attempting purge
                $retryCount = 0
                $retryLimit = 60
                $retryInterval = 30
                $serviceSoftDeleted = $false

                do {
                    $retryCount++
                    $existingService = az apim show --resource-group $resourceGroupName --name $resourceName 2>$null
                    if (-not $existingService) {
                        $serviceSoftDeleted = $true
                        Write-Verbose ('[✔️] API Management service [{0}] has been soft-deleted.' -f $resourceName) -Verbose
                    } else {
                        Write-Verbose ('    [⏱️] Waiting {0} seconds for API Management service [{1}] to be soft-deleted. [{2}/{3}]' -f $retryInterval, $resourceName, $retryCount, $retryLimit) -Verbose
                        Start-Sleep -Seconds $retryInterval
                    }
                } while (-not $serviceSoftDeleted -and $retryCount -lt $retryLimit)

                if (-not $serviceSoftDeleted) {
                    Write-Warning ('[!] API Management service [{0}] was not soft-deleted after [{1}] seconds. Skipping purge.' -f $resourceName, ($retryCount * $retryInterval))
                    break
                }

                # Purge the soft-deleted APIM service to ensure complete removal
                $softDeletedService = az apim deletedservice show --service-name $resourceName --location $apimLocation 2>$null
                if ($softDeletedService) {
                    Write-Verbose ('[*] Purging soft-deleted API Management service [{0}] in location [{1}]' -f $resourceName, $apimLocation) -Verbose
                    if ($PSCmdlet.ShouldProcess("API Management service [$resourceName]", 'Purge')) {
                        az apim deletedservice purge --service-name $resourceName --location $apimLocation
                    }
                } else {
                    Write-Verbose ('[/] No soft-deleted API Management service [{0}] found in location [{1}]. Skipping purge.' -f $resourceName, $apimLocation) -Verbose
                }
            } else {
                # Service not found - check if it exists as a soft-deleted service and purge if so
                Write-Verbose ('[/] API Management service [{0}] not found in resource group [{1}]. Checking for soft-deleted instance.' -f $resourceName, $resourceGroupName) -Verbose
                $softDeletedServices = az apim deletedservice list 2>$null
                if ($softDeletedServices) {
                    $matchingDeleted = ($softDeletedServices | ConvertFrom-Json) | Where-Object { $_.name -eq $resourceName }
                    if ($matchingDeleted) {
                        $apimLocation = $matchingDeleted.location
                        Write-Verbose ('[*] Purging soft-deleted API Management service [{0}] in location [{1}]' -f $resourceName, $apimLocation) -Verbose
                        if ($PSCmdlet.ShouldProcess("API Management service [$resourceName]", 'Purge')) {
                            az apim deletedservice purge --service-name $resourceName --location $apimLocation
                        }
                    } else {
                        Write-Warning "Unable to find API Management service [$resourceName] (active or soft-deleted)"
                    }
                }
            }
            break
        }
        'Microsoft.Network/expressRouteGateways' {
            $resourceGroupName = $ResourceId.Split('/')[4]
            $resourceName = Split-Path $ResourceId -Leaf
            if ($PSCmdlet.ShouldProcess("Express Route Gateway [$resourceName]", 'Remove')) {
                # Express Route Gateways can take 20-30+ minutes to delete. Use the dedicated cmdlet
                # and poll until the resource is gone to avoid ARM client-side timeout errors.
                $null = Remove-AzExpressRouteGateway -ResourceGroupName $resourceGroupName -Name $resourceName -Force -ErrorAction 'Stop'
                $retryCount = 0
                $maxRetries = 60  # up to ~30 minutes (60 × 30s)
                do {
                    $gateway = Get-AzExpressRouteGateway -ResourceGroupName $resourceGroupName -Name $resourceName -ErrorAction 'SilentlyContinue'
                    if ($gateway) {
                        $retryCount++
                        Write-Verbose ("Express Route Gateway [$resourceName] still deleting. Waiting 30 seconds. [{0}/{1}]" -f $retryCount, $maxRetries) -Verbose
                        Start-Sleep -Seconds 30
                    }
                } while ($gateway -and $retryCount -lt $maxRetries)
                if ($gateway) {
                    throw "Express Route Gateway [$resourceName] did not finish deleting within the expected time."
                }
            }
            break
        }
        ### CODE LOCATION: Add custom removal action here
        default {
            if ($PSCmdlet.ShouldProcess("Resource with ID [$ResourceId]", 'Remove')) {
                $null = Remove-AzResource -ResourceId $ResourceId -Force -ErrorAction 'Stop'
            }
        }
    }
}
