metadata name = 'Kubernetes Connected Cluster'
metadata description = 'This module deploys an Azure Arc connected cluster.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the Azure Arc connected cluster.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Tags for the cluster resource.')
param tags object?

@description('Optional. The Azure AD tenant ID.')
param tenantId string?

@description('Optional. The Azure AD admin group object IDs.')
param aadAdminGroupObjectIds array?

@description('Optional. Enable Azure RBAC.')
param enableAzureRBAC bool = false

@description('Optional. Enable automatic agent upgrades.')
@allowed([
  'Enabled'
  'Disabled'
])
param agentAutoUpgrade string = 'Enabled'

@description('Optional. Enable OIDC issuer.')
param oidcIssuerEnabled bool = false

@description('Optional. Enable workload identity.')
param workloadIdentityEnabled bool = false

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ============= //
//   Resources   //
// ============= //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.kubernetes-connectedcluster.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// Resource definition
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-07-15-preview' = {
  name: name
  kind: 'ProvisionedCluster'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: {
    aadProfile: enableAzureRBAC
      ? {
          tenantID: !empty(tenantId) ? tenantId : tenant().tenantId
          adminGroupObjectIDs: aadAdminGroupObjectIds ?? []
          enableAzureRBAC: enableAzureRBAC
        }
      : null
    agentPublicKeyCertificate: ''
    arcAgentProfile: {
      agentAutoUpgrade: agentAutoUpgrade
    }
    distribution: null
    infrastructure: null
    oidcIssuerProfile: {
      enabled: oidcIssuerEnabled
    }
    securityProfile: {
      workloadIdentity: {
        enabled: workloadIdentityEnabled
      }
    }
    azureHybridBenefit: null
  }
}

resource connectedCluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(connectedCluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: connectedCluster
  }
]

@description('The name of the connected cluster.')
output name string = connectedCluster.name

@description('The resource ID of the connected cluster.')
output resourceId string = connectedCluster.id

@description('The resource group of the connected cluster.')
output resourceGroupName string = resourceGroup().name

@description('The location of the connected cluster.')
output location string = connectedCluster.location

@description('The principalId of the connected cluster identity.')
output systemAssignedMIPrincipalId string? = connectedCluster.identity.principalId
