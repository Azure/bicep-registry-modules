function Wait-Replication {
  [CmdletBinding()]
  Param(
    [Parameter(mandatory = $true)]
    [scriptblock]$ScriptBlock,

    [int]$SuccessCount = 2,

    [int]$DelayInSeconds = 2,

    [int]$MaximumFailureCount = 20
  )
  
  Begin {
    $successiveSuccessCount = 0
    $failureCount = 0
  }
  
  Process {
    while ($successiveSuccessCount -lt $SuccessCount) {
      if ($ScriptBlock.Invoke()) {
        $successiveSuccessCount++
      }
      else {
        $successiveSuccessCount = 0
        $failureCount++
        
        if ($failureCount -eq $MaximumFailureCount) {
          throw "Reached maximum failure count: $MaximumFailureCount."
        }
      }
    }
    
    Start-Sleep $DelayInSeconds
  }
}

<#
.SYNOPSIS
  Clears a Recovery Services vault.

.DESCRIPTION
  The function removes all backup items and configuration in a Recovery Services vault so it can be removed.
  The source code was copied from https://docs.microsoft.com/en-us/azure/backup/scripts/delete-recovery-services-vault.

.PARAMETER Vault
  The vault to clear.
#>
function Clear-AzRecoveryServicesVault {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true, ValueFromPipeline = $true)]
    [Microsoft.Azure.Commands.RecoveryServices.ARSVault]$Vault
  )

  process {
    Write-Host "Clearing Recovery Services vault" $vault.Name "..."

    Set-AzRecoveryServicesAsrVaultContext -Vault $Vault
    Set-AzRecoveryServicesVaultProperty -Vault $Vault.ID -SoftDeleteFeatureState Disable #disable soft delete
    Write-Host "Soft delete disabled for the vault" $Vault.Name

    $containerSoftDelete = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM -VaultId $Vault.ID | Where-Object { $_.DeleteState -eq "ToBeDeleted" } #fetch backup items in soft delete state
    foreach ($softitem in $containerSoftDelete) {
      Undo-AzRecoveryServicesBackupItemDeletion -Item $softitem -VaultId $Vault.ID -Force #undelete items in soft delete state
    }
    #Invoking API to disable enhanced security
    $body = @{properties = @{enhancedSecurityState = "Disabled" } }
    $vaultPath = $Vault.ID + "/backupconfig/vaultconfig?api-version=2020-05-13"

    Invoke-AzRestMethod -Method "PATCH" -Path $vaultPath -Payload ($body | ConvertTo-JSON -Depth 5)

    #Fetch all protected items and servers
    $backupItemsVM = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM -VaultId $Vault.ID
    $backupItemsSQL = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureWorkload -WorkloadType MSSQL -VaultId $Vault.ID
    $backupItemsAFS = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureStorage -WorkloadType AzureFiles -VaultId $Vault.ID
    $backupItemsSAP = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureWorkload -WorkloadType SAPHanaDatabase -VaultId $Vault.ID
    $backupContainersSQL = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVMAppContainer -Status Registered -VaultId $Vault.ID | Where-Object { $_.ExtendedInfo.WorkloadType -eq "SQL" }
    $protectableItemsSQL = Get-AzRecoveryServicesBackupProtectableItem -WorkloadType MSSQL -VaultId $Vault.ID | Where-Object { $_.IsAutoProtected -eq $true }
    $backupContainersSAP = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVMAppContainer -Status Registered -VaultId $Vault.ID | Where-Object { $_.ExtendedInfo.WorkloadType -eq "SAPHana" }
    $StorageAccounts = Get-AzRecoveryServicesBackupContainer -ContainerType AzureStorage -Status Registered -VaultId $Vault.ID
    $backupServersMARS = Get-AzRecoveryServicesBackupContainer -ContainerType "Windows" -BackupManagementType MAB -VaultId $Vault.ID
    $backupServersMABS = Get-AzRecoveryServicesBackupManagementServer -VaultId $Vault.ID | Where-Object { $_.BackupManagementType -eq "AzureBackupServer" }
    $backupServersDPM = Get-AzRecoveryServicesBackupManagementServer -VaultId $Vault.ID | Where-Object { $_.BackupManagementType -eq "SCDPM" }
    $pvtendpoints = Get-AzPrivateEndpointConnection -PrivateLinkResourceId $Vault.ID

    foreach ($item in $backupItemsVM) {
      Disable-AzRecoveryServicesBackupProtection -Item $item -VaultId $Vault.ID -RemoveRecoveryPoints -Force #stop backup and delete Azure VM backup items
    }
    Write-Host "Disabled and deleted Azure VM backup items"

    foreach ($item in $backupItemsSQL) {
      Disable-AzRecoveryServicesBackupProtection -Item $item -VaultId $Vault.ID -RemoveRecoveryPoints -Force #stop backup and delete SQL Server in Azure VM backup items
    }
    Write-Host "Disabled and deleted SQL Server backup items"

    foreach ($item in $protectableItemsSQL) {
      Disable-AzRecoveryServicesBackupAutoProtection -BackupManagementType AzureWorkload -WorkloadType MSSQL -InputItem $item -VaultId $Vault.ID #disable auto-protection for SQL
    }
    Write-Host "Disabled auto-protection and deleted SQL protectable items"

    foreach ($item in $backupContainersSQL) {
      Unregister-AzRecoveryServicesBackupContainer -Container $item -Force -VaultId $Vault.ID #unregister SQL Server in Azure VM protected server
    }
    Write-Host "Deleted SQL Servers in Azure VM containers" 

    foreach ($item in $backupItemsSAP) {
      Disable-AzRecoveryServicesBackupProtection -Item $item -VaultId $Vault.ID -RemoveRecoveryPoints -Force #stop backup and delete SAP HANA in Azure VM backup items
    }
    Write-Host "Disabled and deleted SAP HANA backup items"

    foreach ($item in $backupContainersSAP) {
      Unregister-AzRecoveryServicesBackupContainer -Container $item -Force -VaultId $Vault.ID #unregister SAP HANA in Azure VM protected server
    }
    Write-Host "Deleted SAP HANA in Azure VM containers"

    foreach ($item in $backupItemsAFS) {
      Disable-AzRecoveryServicesBackupProtection -Item $item -VaultId $Vault.ID -RemoveRecoveryPoints -Force #stop backup and delete Azure File Shares backup items
    }
    Write-Host "Disabled and deleted Azure File Share backups"

    foreach ($item in $StorageAccounts) {   
      Unregister-AzRecoveryServicesBackupContainer -container $item -Force -VaultId $Vault.ID #unregister storage accounts
    }
    Write-Host "Unregistered Storage Accounts"

    foreach ($item in $backupServersMARS) {
      Unregister-AzRecoveryServicesBackupContainer -Container $item -Force -VaultId $Vault.ID #unregister MARS servers and delete corresponding backup items
    }
    Write-Host "Deleted MARS Servers"

    foreach ($item in $backupServersMABS) { 
      Unregister-AzRecoveryServicesBackupManagementServer -AzureRmBackupManagementServer $item -VaultId $Vault.ID #unregister MABS servers and delete corresponding backup items
    }
    Write-Host "Deleted MAB Servers"

    foreach ($item in $backupServersDPM) {
      Unregister-AzRecoveryServicesBackupManagementServer -AzureRmBackupManagementServer $item -VaultId $Vault.ID #unregister DPM servers and delete corresponding backup items
    }
    Write-Host "Deleted DPM Servers"

    #Deletion of ASR Items

    $fabricObjects = Get-AzRecoveryServicesAsrFabric
    if ($null -ne $fabricObjects) {
      # First DisableDR all VMs.
      foreach ($fabricObject in $fabricObjects) {
        $containerObjects = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $fabricObject
        foreach ($containerObject in $containerObjects) {
          $protectedItems = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $containerObject
          # DisableDR all protected items
          foreach ($protectedItem in $protectedItems) {
            Write-Host "Triggering DisableDR(Purge) for item:" $protectedItem.Name
            Remove-AzRecoveryServicesAsrReplicationProtectedItem -InputObject $protectedItem -Force
            Write-Host "DisableDR(Purge) completed"
          }
			
          $containerMappings = Get-AzRecoveryServicesAsrProtectionContainerMapping `
            -ProtectionContainer $containerObject
          # Remove all Container Mappings
          foreach ($containerMapping in $containerMappings) {
            Write-Host "Triggering Remove Container Mapping: " $containerMapping.Name
            Remove-AzRecoveryServicesAsrProtectionContainerMapping -ProtectionContainerMapping $containerMapping -Force
            Write-Host "Removed Container Mapping."
          }			
        }
        $NetworkObjects = Get-AzRecoveryServicesAsrNetwork -Fabric $fabricObject 
        foreach ($networkObject in $NetworkObjects) {
          #Get the PrimaryNetwork
          $PrimaryNetwork = Get-AzRecoveryServicesAsrNetwork -Fabric $fabricObject -FriendlyName $networkObject
          $NetworkMappings = Get-AzRecoveryServicesAsrNetworkMapping -Network $PrimaryNetwork
          foreach ($networkMappingObject in $NetworkMappings) {
            #Get the Neetwork Mappings
            $NetworkMapping = Get-AzRecoveryServicesAsrNetworkMapping -Name $networkMappingObject.Name -Network $PrimaryNetwork
            Remove-AzRecoveryServicesAsrNetworkMapping -InputObject $NetworkMapping
          }
        }		
        # Remove Fabric
        Write-Host "Triggering Remove Fabric:" $fabricObject.FriendlyName
        Remove-AzRecoveryServicesAsrFabric -InputObject $fabricObject -Force
        Write-Host "Removed Fabric."
      }
    }

    foreach ($item in $pvtendpoints) {
      $penamesplit = $item.Name.Split(".")
      $pename = $penamesplit[1]
      Remove-AzPrivateEndpointConnection -ResourceId $item.PrivateEndpoint.Id -Force #remove private endpoint connections
      Remove-AzPrivateEndpoint -Name $pename -ResourceGroupName $Vault.ResourceGroupName -Force #remove private endpoints
    }	 
    Write-Host "Removed Private Endpoints"

    #Recheck ASR items in vault
    $fabricCount = 1
    $ASRProtectedItems = 1
    $ASRPolicyMappings = 1
    $fabricObjects = Get-AzRecoveryServicesAsrFabric
    if ($null -ne $fabricObjects) {
      foreach ($fabricObject in $fabricObjects) {
        $containerObjects = Get-AzRecoveryServicesAsrProtectionContainer -Fabric $fabricObject
        foreach ($containerObject in $containerObjects) {
          $protectedItems = Get-AzRecoveryServicesAsrReplicationProtectedItem -ProtectionContainer $containerObject
          foreach ($protectedItem in $protectedItems) {
            $ASRProtectedItems++
          }
          $containerMappings = Get-AzRecoveryServicesAsrProtectionContainerMapping `
            -ProtectionContainer $containerObject
          foreach ($containerMapping in $containerMappings) {
            $ASRPolicyMappings++
          }			
        }
        $fabricCount++
      }
    }
    #Recheck presence of backup items in vault
    $backupItemsVMFin = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM -VaultId $Vault.ID
    $backupItemsSQLFin = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureWorkload -WorkloadType MSSQL -VaultId $Vault.ID
    $backupContainersSQLFin = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVMAppContainer -Status Registered -VaultId $Vault.ID | Where-Object { $_.ExtendedInfo.WorkloadType -eq "SQL" }
    $protectableItemsSQLFin = Get-AzRecoveryServicesBackupProtectableItem -WorkloadType MSSQL -VaultId $Vault.ID | Where-Object { $_.IsAutoProtected -eq $true }
    $backupItemsSAPFin = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureWorkload -WorkloadType SAPHanaDatabase -VaultId $Vault.ID
    $backupContainersSAPFin = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVMAppContainer -Status Registered -VaultId $Vault.ID | Where-Object { $_.ExtendedInfo.WorkloadType -eq "SAPHana" }
    $backupItemsAFSFin = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureStorage -WorkloadType AzureFiles -VaultId $Vault.ID
    $StorageAccountsFin = Get-AzRecoveryServicesBackupContainer -ContainerType AzureStorage -Status Registered -VaultId $Vault.ID
    $backupServersMARSFin = Get-AzRecoveryServicesBackupContainer -ContainerType "Windows" -BackupManagementType MAB -VaultId $Vault.ID
    $backupServersMABSFin = Get-AzRecoveryServicesBackupManagementServer -VaultId $Vault.ID | Where-Object { $_.BackupManagementType -eq "AzureBackupServer" }
    $backupServersDPMFin = Get-AzRecoveryServicesBackupManagementServer -VaultId $Vault.ID | Where-Object { $_.BackupManagementType -eq "SCDPM" }
    $pvtendpointsFin = Get-AzPrivateEndpointConnection -PrivateLinkResourceId $Vault.ID
    Write-Host "Number of backup items left in the vault and which need to be deleted:" $backupItemsVMFin.count "Azure VMs" $backupItemsSQLFin.count "SQL Server Backup Items" $backupContainersSQLFin.count "SQL Server Backup Containers" $protectableItemsSQLFin.count "SQL Server Instances" $backupItemsSAPFin.count "SAP HANA backup items" $backupContainersSAPFin.count "SAP HANA Backup Containers" $backupItemsAFSFin.count "Azure File Shares" $StorageAccountsFin.count "Storage Accounts" $backupServersMARSFin.count "MARS Servers" $backupServersMABSFin.count "MAB Servers" $backupServersDPMFin.count "DPM Servers" $pvtendpointsFin.count "Private endpoints"
    Write-Host "Number of ASR items left in the vault and which need to be deleted:" $ASRProtectedItems "ASR protected items" $ASRPolicyMappings "ASR policy mappings" $fabricCount "ASR Fabrics" $pvtendpointsFin.count "Private endpoints. Warning: This script will only remove the replication configuration from Azure Site Recovery and not from the source. Please cleanup the source manually. Visit https://go.microsoft.com/fwlink/?linkid=2182782 to learn more"
    
    $Vault
  }
}

function Remove-AzResourceLockInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  Get-AzResourceLock -ResourceGroupName $ResourceGroupName -Verbose | Remove-AzResourceLock -Force -verbose
}

function Remove-AzRecoveryServicesVaultInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  Get-AzRecoveryServicesVault -ResourceGroupName $ResourceGroupName -Verbose |
  Clear-AzRecoveryServicesVault |
  Remove-AzRecoveryServicesVault -Verbose
}

function Remove-AzDataProtectionBackupVaultInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  # The Az.DataProtection is not yet included with the rest of the Az module.
  if ($null -eq $(Get-Module -ListAvailable Az.DataProtection)) {
    Write-Host "Installing Az.DataProtection module..."
    Install-Module Az.DataProtection -Force -AllowClobber
  }
  
  $vaults = Get-AzDataProtectionBackupVault -ResourceGroupName $ResourceGroupName
  
  foreach ($vault in $vaults) {
    Write-Host "Removing Backup vault" $vault.name "..."

    $backupInstances = Get-AzDataProtectionBackupInstance -ResourceGroupName $ResourceGroupName -VaultName $vault.Name
    foreach ($backupInstance in $backupInstances) {
      Write-Host "Removing Backup instance" $backupInstance.Name "..."
      Remove-AzDataProtectionBackupInstance -ResourceGroupName $ResourceGroupName -VaultName $vault.Name -Name $backupInstance.Name 
    }
    
    $backupPolicies = Get-AzDataProtectionBackupPolicy -ResourceGroupName $ResourceGroupName -VaultName $vault.Name 
    foreach ($backupPolicy in $backupPolicies) {
      Write-Host "Removing Backup policy" $backupPolicy.name "..."
      Remove-AzDataProtectionBackupPolicy -ResourceGroupName $ResourceGroupName -VaultName $vault.name -Name $backupPolicy.Name   
    }
  }
}

function Remove-AzEventHubGeoDRConfigurationInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $namespaces = Get-AzEventHubNamespace -ResourceGroupName $ResourceGroupName -Verbose

  foreach ($namespace in $namespaces) {
    $configurations = Get-AzEventHubGeoDRConfiguration -ResourceGroupName $ResourceGroupName -Namespace $namespace.Name -Verbose

    foreach ($configuration in $configurations) {
      # First look at the primary namespaces and break pairing.
      if ($configuration.Role.ToString() -eq "Primary") {
        Write-Host "Breaking Event Hubs namespace pairing for namespace" $namespace.Name "..."
        Set-AzEventHubGeoDRConfigurationBreakPair -ResourceGroupName $ResourceGroupName -Namespace $namespace.Name -Name $configuration.Name
      }

      # Now that pairing is removed we can remove primary and secondary configs.
      Write-Host "Removing Event Hubs DR configuration" $configuration.Name "..."
      Remove-AzEventHubGeoDRConfiguration -ResourceGroupName $ResourceGroupName -Namespace $namespace.Name $configuration.Name -Verbose
    }
  }
}

function Remove-AzServiceBusGeoDRConfigurationAndMigrationInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $namespaces = Get-AzServiceBusNamespace -ResourceGroupName $ResourceGroupName -Verbose

  foreach ($namespace in $namespaces) {
    $configurations = Get-AzServiceBusGeoDRConfiguration -ResourceGroupName $ResourceGroupName -Namespace $namespace.Name
    
    foreach ($configuration in $configurations) {
      # First look at the primary namespaces and break pairing.
      if ($configuration.Role.ToString() -eq "Primary") {
        Write-Host "Breaking Service Bus namespace pairing for namespace" $namespace "..."
        Set-AzServiceBusGeoDRConfigurationBreakPair -ResourceGroupName $ResourceGroupName -Namespace $namespace.Name -Name $configuration.Name
      }
      
      # Now that pairing is removed we can remove primary and secondary configs.
      Write-Host "Removing Service Bus DR configuration" $configuration.Name "..."
      Remove-AzServiceBusGeoDRConfiguration -ResourceGroupName $ResourceGroupName -Namespace $namespace.Name -Name $configuration.Name -Verbose
    }
  }

  foreach ($namespace in $namespaces) {
    # Set ErrorAction on this since it throws if there is no config (unlike the other cmdlets).
    $migration = Get-AzServiceBusMigration -ResourceGroupName $ResourceGroupName -Name $namespace.Name -ErrorAction "SilentlyContinue"

    if ($migration) {
      Write-Host "Removing Service Bus migration" $migration.Name "..."
      Remove-AzServiceBusMigration -ResourceGroupName $ResourceGroupName -Name $namespace.Name -Verbose
    }
  }
}

function Remove-AzWebAppSwiftVnetConnectionInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  function Remove-AzWebAppSwiftVnetConnection {
    [CmdletBinding()]
    param (
      [Parameter(mandatory = $true)]
      [Microsoft.Azure.Commands.WebApps.Models.PSSite]$WebAppOrSlot
    )
    
    process {
      # Assumption is that there can only be one connection, but it returns an array so maybe not.
      $result = Invoke-AzRestMethod -Method "GET" -Path "$($WebAppOrSlot.Id)/virtualNetworkConnections?api-version=2021-10-01"

      if ($result.StatusCode -eq "200") {
        Write-Host "Removing a Swift Virtual Network connection from the Web App: $($WebAppOrSlot.Name)"
        # The URI for remove is not the same as the GET URI.
        Invoke-AzRestMethod -Method "DELETE" -Path "$($WebAppOrSlot.Id)/networkConfig/virtualNetwork?api-version=2021-10-01" -Verbose
      }
    }
  }
  
  # Web apps that have a serviceAssociationLink can be deleted even if the link exists and the vnet
  # will be bricked (cannot be delete and the serviceAssociation link cannot be removed).
  # A funky traversal of 4 resources are needed to discover and remove the link (PUT/GET/DELETE are not symmetrical).
  $webApps = Get-AzWebApp -ResourceGroupName $ResourceGroupName -Verbose

  foreach ($webApp in $webApps) {
    # Remove the config on the WebApp slots.
    Get-AzWebAppSlot -ResourceGroupName $ResourceGroupName -Name $webApp.Name -Verbose | Remove-AzWebAppSwiftVnetConnection

    # Now remove the config on the WebApp itself.
    Remove-AzWebAppSwiftVnetConnection -WebAppOrSlot $webApp
  }
}

function Remove-AzRedisCacheLinkInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $redisCaches = Get-AzRedisCache -ResourceGroupName $ResourceGroupName -Verbose

  foreach ($redisCache in $redisCaches) {
    $link = Get-AzRedisCacheLink -Name $redisCache.Name
    
    if ($link) {
      Write-Host "Removing Redis Cache geo-replication link" $link.Name "..."
      $link | Remove-AzRedisCacheLink -Verbose
    }
  }
}

function Remove-AzSubnetDelegationInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  # ACI create a subnet delegation that must be removed before the vnet can be deleted.
  $vnets = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Verbose

  foreach ($vnet in $vnets) {
    foreach ($subnet in $vnet.Subnets) {
      $delegations = Get-AzDelegation -Subnet $subnet -Verbose

      foreach ($delegation in $delegations) {
        Write-Output "Removing Subnet delegation" $delegation.Name "..."
        Remove-AzDelegation -Name $delegation.Name -Subnet $subnet -Verbose
      }
    }
  }
}

function Remove-AzVirtualHubIPConfigurationInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )

  # Virtual Hubs can have ipConfigurations that take a few minutes to delete.
  # There appears to be no cmdlets or CLI to invoke these APIs.
  $virtualHubs = Get-AzVirtualHub -ResourceGroupName $ResourceGroupName -Verbose

  foreach ($virtualHub in $virtualHubs) {
    $listResult = Invoke-AzRestMethod -Method "GET" -path "$($virtualHub.Id)/ipConfigurations?api-version=2020-11-01"
    $configurations = $($listResult.Content | ConvertFrom-Json -Depth 50).Value

    foreach ($configuration in $configurations) {
      Write-Host "Removing Virtual Hub IP configuration" $($configuration.id) "..."

      Write-Host "Sending a DELETE request..."
      $deleteResult = Invoke-AzRestMethod -Method "DELETE" -Path "$($configuration.id)?api-version=2020-11-01"
      $deleteResult

      if ($deleteResult.StatusCode -like "20*") {
        Write-Host "Waiting for the DELETE operation to complte..."
        do {
          Start-Sleep -Seconds 60
          Write-Host "Making sure GET returns 404..."
          $getResult = Invoke-AzRestMethod -Method GET -Path "$($configuration.id)?api-version=2020-11-01"
          $getResult
        } until ($getResult.StatusCode -eq "404")
      }
    }
  }
}

function Remove-AzPrivateEndpointConnectionInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )

  $privateLinkServices = Get-AzPrivateLinkService -ResourceGroupName $ResourceGroupName

  foreach ($privateLinkService in $privateLinkServices) {
    $connections = Get-AzPrivateEndpointConnection -ResourceGroupName $ResourceGroupName -ServiceName $privateLinkService.Name

    foreach ($connection in $connections) {
      Write-Host "Removing Private Endpoint connection" $connection.Name "..."
      Remove-AzPrivateEndpointConnection -ResourceGroupName $ResourceGroupName -ServiceName $privateLinkService.Name -Name $connection.Name -Force
    }
  }
}

function Remove-AzKeyVaultInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $keyVaults = Get-AzKeyVault -ResourceGroupName $ResourceGroupName
  
  foreach ($keyVault in $keyVaults) {
    Write-Host "Removing Key vault" $keyVault.VaultName "..."
    Remove-AzKeyVault -VaultName $keyVault.VaultName -ResourceGroupName $ResourceGroupName -Force
    
    if (-not $keyVault.EnableSoftDelete) {
      continue
    }
    
    if ($keyVault.EnablePurgeProtection) {
      Write-Warning ('Key vault {0} had purge protection enabled. The retention time is {1} days. Please wait until after this period before re-running the test.' -f $keyVault.VaultName, $keyVault.SoftDeleteRetentionInDays)
    }
    else {
      Wait-Replication {
        Write-Host "Waiting for the Key vault deletion operation to complete..."
        $null -ne (Get-AzKeyVault -VaultName $keyVault.VaultName -Location $keyVault.Location -InRemovedState)
      }

      Write-Host "Purging Key vault" $keyVault.VaultName "..."
      Remove-AzKeyVault -VaultName $keyVault.VaultName -Location $keyVault.Location -InRemovedState -Force
    }
  }
}

function Remove-AzCognitiveServicesAccountInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $accounts = Get-AzCognitiveServicesAccount -ResourceGroupName $ResourceGroupName
  
  foreach ($account in $accounts) {
    Write-Host "Removing Cognitive Services account" $account.AccountName "..."
    $account | Remove-AzCognitiveServicesAccount -Force

    Wait-Replication {
      Write-Host "Waiting for the Cognitive Services account deletion operation to complete..."
      $null -ne (Get-AzCognitiveServicesAccount -ResourceGroupName $ResourceGroupName -Name $account.AccountName -Location $account.Location -InRemovedState)
    }

    Write-Host "Purging Cognitive Services account" $account.AccountName "..."
    $account | Remove-AzCognitiveServicesAccount -Location $account.Location -InRemovedState -Force
  }
}

function Remove-AzApiManagementServiceInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $context = Get-AzContext
  $subscriptionId = $context.Subscription.Id
  $services = Get-AzApiManagement -ResourceGroupName $ResourceGroupName
  
  foreach ($service in $services) {
    Write-Host "Removing API Management service" $service.Name "..."
    $service | Remove-AzApiManagement
    
    Write-Host "Waiting for the API Management service deletion operation to complete..."
    Start-Sleep 20

    Write-Host "Purging API Management service" $service.Name "..."
    $purgePath = "/subscriptions/{0}/providers/Microsoft.ApiManagement/locations/{1}/deletedservices/{2}?api-version=2020-06-01-preview" -f $subscriptionId, $service.Location, $service.Name
    Invoke-AzRestMethod -Method "DELETE" -Path $purgePath
  }
}

function Remove-AzOperationalInsightsWorkspaceInResourceGroup {
  [CmdletBinding()]
  param (
    [Parameter(mandatory = $true)]
    [string]$ResourceGroupName
  )
  
  $workspaces = Get-AzOperationalInsightsWorkspace -ResourceGroupName $ResourceGroupName
  
  foreach ($workspace in $workspaces) {
    Write-Host "Removing Operational Insights workspace" $workspace.Name "..."
    $workspace | Remove-AzOperationalInsightsWorkspace -ForceDelete -Force
  }
}

Export-ModuleMember -Function `
  Wait-Replication, `
  Remove-AzResourceLockInResourceGroup, `
  Remove-AzRecoveryServicesVaultInResourceGroup, `
  Remove-AzDataProtectionBackupVaultInResourceGroup, `
  Remove-AzEventHubGeoDRConfigurationInResourceGroup, `
  Remove-AzServiceBusGeoDRConfigurationAndMigrationInResourceGroup, `
  Remove-AzWebAppSwiftVnetConnectionInResourceGroup, `
  Remove-AzRedisCacheLinkInResourceGroup, `
  Remove-AzSubnetDelegationInResourceGroup, `
  Remove-AzVirtualHubIPConfigurationInResourceGroup, `
  Remove-AzPrivateEndpointConnectionInResourceGroup, `
  Remove-AzKeyVaultInResourceGroup, `
  Remove-AzCognitiveServicesAccountInResourceGroup, `
  Remove-AzApiManagementServiceInResourceGroup, `
  Remove-AzOperationalInsightsWorkspaceInResourceGroup
  