metadata name = 'Fabric Capacities'
metadata description = 'This module deploys Fabric capacities, which provide the compute resources for all the experiences in Fabric.'

@description('Required. Name of the resource to create.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@allowed([
  'F2'
  'F4'
  'F8'
  'F16'
  'F32'
  'F64'
  'F128'
  'F256'
  'F512'
  'F1024'
  'F2048'
])
@description('Optional. SKU tier of the Fabric resource.')
param skuName string = 'F2'

@allowed(['Fabric'])
@description('Optional. SKU name of the Fabric resource.')
param skuTier string = 'Fabric'

@description('Required. List of admin members. Format: ["something@domain.com"].')
param adminMembers array

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Enable automatic handling of paused capacity during SKU changes. When enabled, the module will automatically resume paused capacities before SKU changes and optionally restore the previous state.')
param enableAutomaticPauseHandling bool = false

@description('Optional. When automatic pause handling is enabled, restore the previous pause state after SKU changes. Only applies when enableAutomaticPauseHandling is true.')
param restorePreviousState bool = true

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The managed identity definition for this resource. Required when enableAutomaticPauseHandling is true.')
param managedIdentities managedIdentityAllType?

// ============== //
// Variables      //
// ============== //

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
)

var identity = !empty(managedIdentities ?? {})
  ? {
      type: (managedIdentities!.?systemAssigned ?? false)
        ? (!empty(managedIdentities!.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities!.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.fabric-capacity.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource capacityStateHandler 'Microsoft.Resources/deploymentScripts@2023-08-01' = if (enableAutomaticPauseHandling) {
  name: '${name}-state-handler'
  location: location
  kind: 'AzurePowerShell'
  identity: identity
  properties: {
    azPowerShellVersion: '10.0'
    retentionInterval: 'P1D'
    timeout: 'PT30M'
    scriptContent: '''
      param(
        [string]$ResourceGroupName,
        [string]$CapacityName,
        [string]$SubscriptionId,
        [bool]$RestorePreviousState
      )

      # Set the context
      Set-AzContext -SubscriptionId $SubscriptionId

      try {
        # Get current capacity state (only if capacity exists)
        $uri = "${environment().resourceManager}subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Fabric/capacities/$CapacityName?api-version=2023-11-01"
        $headers = @{
          'Authorization' = "Bearer $((Get-AzAccessToken).Token)"
          'Content-Type' = 'application/json'
        }

        try {
          $response = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
          $currentState = $response.properties.state
          $capacityExists = $true
          Write-Output "Found existing capacity with state: $currentState"
        } catch {
          if ($_.Exception.Response.StatusCode -eq 404) {
            Write-Output "Capacity does not exist yet. This appears to be a new deployment."
            $capacityExists = $false
            $currentState = "NotFound"
          } else {
            throw "Error checking capacity state: $_"
          }
        }

        # Only process state changes if capacity exists and is paused/suspended
        if ($capacityExists -and ($currentState -eq 'Paused' -or $currentState -eq 'Suspended')) {
          Write-Output "Capacity is in $currentState state. Resuming capacity..."

          # Resume the capacity
          $resumeUri = "${environment().resourceManager}subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Fabric/capacities/$CapacityName/resume?api-version=2023-11-01"
          $resumeResponse = Invoke-RestMethod -Uri $resumeUri -Method POST -Headers $headers

          # Wait for resume operation to complete
          $retryCount = 0
          $maxRetries = 30
          do {
            Start-Sleep -Seconds 30
            $statusResponse = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers
            $newState = $statusResponse.properties.state
            Write-Output "Capacity state after resume attempt: $newState"
            $retryCount++
          } while ($newState -ne 'Active' -and $retryCount -lt $maxRetries)

          if ($newState -ne 'Active') {
            throw "Failed to resume capacity after $maxRetries attempts. Current state: $newState"
          }

          Write-Output "Capacity successfully resumed and is now Active"

          # Store original state for potential restoration
          $DeploymentScriptOutputs = @{
            'originalState' = $currentState
            'wasResumed' = $true
          }
        } else {
          if ($capacityExists) {
            Write-Output "Capacity is already in Active state. No action needed."
          } else {
            Write-Output "New capacity deployment. No state management needed."
          }
          $DeploymentScriptOutputs = @{
            'originalState' = $currentState
            'wasResumed' = $false
          }
        }
      } catch {
        Write-Error "Error handling capacity state: $_"
        throw
      }
    '''
    arguments: '-ResourceGroupName "${resourceGroup().name}" -CapacityName "${name}" -SubscriptionId "${subscription().subscriptionId}" -RestorePreviousState $${restorePreviousState}'
  }
}

resource fabricCapacity 'Microsoft.Fabric/capacities@2023-11-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    administration: {
      members: adminMembers
    }
  }
  dependsOn: enableAutomaticPauseHandling ? [capacityStateHandler] : []
}

resource fabricCapacity_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: fabricCapacity
}

resource capacityStateRestorer 'Microsoft.Resources/deploymentScripts@2023-08-01' = if (enableAutomaticPauseHandling && restorePreviousState) {
  name: '${name}-state-restorer'
  location: location
  kind: 'AzurePowerShell'
  identity: identity
  properties: {
    azPowerShellVersion: '10.0'
    retentionInterval: 'P1D'
    timeout: 'PT30M'
    scriptContent: '''
      param(
        [string]$ResourceGroupName,
        [string]$CapacityName,
        [string]$SubscriptionId,
        [string]$OriginalState,
        [bool]$WasResumed
      )

      # Set the context
      Set-AzContext -SubscriptionId $SubscriptionId

      try {
        if ($WasResumed -and ($OriginalState -eq 'Paused' -or $OriginalState -eq 'Suspended')) {
          Write-Output "Restoring capacity to original state: $OriginalState"

          $headers = @{
            'Authorization' = "Bearer $((Get-AzAccessToken).Token)"
            'Content-Type' = 'application/json'
          }

          # Determine the appropriate action based on original state
          $action = if ($OriginalState -eq 'Paused') { 'suspend' } else { 'suspend' }
          $actionUri = "${environment().resourceManager}subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Fabric/capacities/$CapacityName/$action?api-version=2023-11-01"

          # Perform the action
          $actionResponse = Invoke-RestMethod -Uri $actionUri -Method POST -Headers $headers

          # Wait for the operation to complete
          $retryCount = 0
          $maxRetries = 30
          $checkUri = "${environment().resourceManager}subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Fabric/capacities/$CapacityName?api-version=2023-11-01"

          do {
            Start-Sleep -Seconds 30
            $statusResponse = Invoke-RestMethod -Uri $checkUri -Method GET -Headers $headers
            $currentState = $statusResponse.properties.state
            Write-Output "Current capacity state: $currentState"
            $retryCount++
          } while ($currentState -ne $OriginalState -and $retryCount -lt $maxRetries)

          if ($currentState -eq $OriginalState) {
            Write-Output "Successfully restored capacity to $OriginalState state"
          } else {
            Write-Warning "Could not restore capacity to original state within timeout. Current state: $currentState"
          }
        } else {
          Write-Output "No state restoration needed. WasResumed: $WasResumed, OriginalState: $OriginalState"
        }
      } catch {
        Write-Error "Error restoring capacity state: $_"
        # Don't throw here as the main deployment should succeed even if state restoration fails
        Write-Warning "State restoration failed but main deployment completed successfully"
      }
    '''
    arguments: '-ResourceGroupName "${resourceGroup().name}" -CapacityName "${name}" -SubscriptionId "${subscription().subscriptionId}" -OriginalState "${enableAutomaticPauseHandling ? (capacityStateHandler.properties.outputs.?originalState ?? 'Unknown') : 'NotApplicable'}" -WasResumed ${enableAutomaticPauseHandling ? (capacityStateHandler.properties.outputs.?wasResumed ?? 'false') : 'false'}'
  }
  dependsOn: [fabricCapacity]
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the resource group the module was deployed to.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the deployed Fabric resource.')
output resourceId string = fabricCapacity.id

@description('The name of the deployed Fabric resource.')
output name string = fabricCapacity.name

@description('The location the resource was deployed into.')
output location string = fabricCapacity.location
