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

@description('Optional. AAD profile for the connected cluster.')
param aadProfile aadProfileType?

@description('Optional. Arc agentry configuration for the provisioned cluster.')
param arcAgentProfile arcAgentProfileType = {
  agentAutoUpgrade: 'Enabled'
}

@description('Optional. Open ID Connect (OIDC) Issuer Profile for the connected cluster.')
param oidcIssuerProfile oidcIssuerProfileType = { enabled: false }

@description('Optional. Security profile for the connected cluster.')
param securityProfile securityProfileType = {
  workloadIdentity: {
    enabled: false
  }
}

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
    aadProfile: aadProfile
    agentPublicKeyCertificate: ''
    arcAgentProfile: arcAgentProfile
    distribution: null
    infrastructure: null
    oidcIssuerProfile: oidcIssuerProfile
    securityProfile: securityProfile
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

// ============ //
// Outputs      //
// ============ //

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

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type for AAD profile configuration.')
type aadProfileType = {
  @description('Required. The list of AAD group object IDs that will have admin role of the cluster.')
  adminGroupObjectIDs: string[]
  @description('Required. Whether to enable Azure RBAC for Kubernetes authorization.')
  enableAzureRBAC: bool
  @description('Required. The AAD tenant ID.')
  tenantID: string
}

@export()
@description('The type for system component configuration.')
type systemComponentType = {
  @description('Required. The major version of the system component.')
  majorVersion: int
  @description('Required. The type of the system component.')
  type: string
  @description('Required. The user specified version of the system component.')
  userSpecifiedVersion: string
}

@export()
@description('The type for Arc agent profile configuration.')
type arcAgentProfileType = {
  @description('Required. Indicates whether the Arc agents on the be upgraded automatically to the latest version.')
  agentAutoUpgrade: 'Enabled' | 'Disabled'
  @description('Optional. The errors encountered by the Arc agent.')
  agentErrors: array?
  @description('Optional. The desired version of the Arc agent.')
  desiredAgentVersion: string?
  @description('Optional. List of system extensions that are installed on the cluster resource.')
  systemComponents: systemComponentType[]?
}

@export()
@description('The type for OIDC issuer profile configuration.')
type oidcIssuerProfileType = {
  @description('Required. Whether the OIDC issuer is enabled.')
  enabled: bool
  @description('Optional. The URL of the self-hosted OIDC issuer.')
  selfHostedIssuerUrl: string?
}

@export()
@description('The type for security profile configuration.')
type securityProfileType = {
  @description('Required. The workload identity configuration.')
  workloadIdentity: {
    @description('Required. Whether workload identity is enabled.')
    enabled: bool
  }
}
