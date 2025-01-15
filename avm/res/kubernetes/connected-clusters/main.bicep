metadata name = 'Kubernetes Connected Clusters'
metadata description = 'Deploy an Azure Arc connected cluster.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Azure Arc connected cluster.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

//
// Add your parameters here
//

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.[[REPLACE WITH TELEMETRY IDENTIFIER]].${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

//
// Add your resources here
//

// ============ //
// Outputs      //
// ============ //

// Add your outputs here

// @description('The resource ID of the resource.')
// output resourceId string = <Resource>.id

// @description('The name of the resource.')
// output name string = <Resource>.name

// @description('The location the resource was deployed into.')
// output location string = <Resource>.location

// ================ //
// Definitions      //
// ================ //
//
// Add your User-defined-types here, if any
//

@description('Optional. The identity type for the cluster. Allowed values: "SystemAssigned", "None"')
@allowed([
  'SystemAssigned'
  'None'
])
param identityType string = 'SystemAssigned'

@description('Optional. Tags for the cluster resource')
param tags object = {}

@description('Optional. Optional. The Azure AD tenant ID')
param aadTenantId string = ''

@description('Optional. The Azure AD admin group object IDs')
param aadAdminGroupObjectIds array = []

@description('Optional. Enable Azure RBAC')
param enableAzureRBAC bool = false

@description('Optional. Enable automatic agent upgrades')
@allowed([
  'Enabled'
  'Disabled'
])
param agentAutoUpgrade string = 'Enabled'

@description('Optional. Enable OIDC issuer')
param oidcIssuerEnabled bool = false

@description('Optional. Enable workload identity')
param workloadIdentityEnabled bool = false

// Resource definition
resource connectedCluster 'Microsoft.Kubernetes/connectedClusters@2024-12-01-preview' = {
  name: name
  location: location
  identity: {
    type: identityType
  }
  tags: tags
  properties: {
    aadProfile: !empty(aadTenantId)
      ? {
          tenantID: aadTenantId
          adminGroupObjectIDs: aadAdminGroupObjectIds
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
