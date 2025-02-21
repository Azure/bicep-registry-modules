metadata name = 'Default interface types for AVM modules'
metadata description = '''
This module provides you with all common variants for AVM interfaces to be used in AVM modules.

Details for how to implement these interfaces can be found in the AVM documentation [here](https://azure.github.io/Azure-Verified-Modules/specs/bcp/res/interfaces/).
'''

//  ====================== //
//   Diagnostic Settings   //
//  ====================== //

// Type with all properties available
@export()
@description('An AVM-aligned type for a diagnostic setting. To be used if both logs & metrics are supported by the resource provider.')
type diagnosticSettingFullType = {
  @description('Optional. The name of the diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}

@export()
@description('An AVM-aligned type for a diagnostic setting. To be used if only metrics are supported by the resource provider.')
type diagnosticSettingMetricsOnlyType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}

@export()
@description('An AVM-aligned type for a diagnostic setting. To be used if only logs are supported by the resource provider.')
type diagnosticSettingLogsOnlyType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}

//  =================== //
//   Role Assignments   //
//  =================== //

@export()
@description('An AVM-aligned type for a role assignment.')
type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}

// ========= //
//   Locks   //
// ========= //

@export()
@description('An AVM-aligned type for a lock.')
type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}

// ====================== //
//   Managed Identities   //
// ====================== //

@export()
@description('An AVM-aligned type for a managed identity configuration. To be used if both a system-assigned & user-assigned identities are supported by the resource provider.')
type managedIdentityAllType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}

@export()
@description('An AVM-aligned type for a managed identity configuration. To be used if only system-assigned identities are supported by the resource provider.')
type managedIdentityOnlySysAssignedType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?
}

@export()
@description('An AVM-aligned type for a managed identity configuration. To be used if only user-assigned identities are supported by the resource provider.')
type managedIdentityOnlyUserAssignedType = {
  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}

// ===================== //
//   Private Endpoints   //
// ===================== //

type privateEndpointPrivateDnsZoneGroupType = {
  @description('Optional. The name of the Private DNS Zone Group.')
  name: string?

  @description('Required. The private DNS Zone Groups to associate the Private Endpoint. A DNS Zone Group can support up to 5 DNS zones.')
  privateDnsZoneGroupConfigs: {
    @description('Optional. The name of the private DNS Zone Group config.')
    name: string?

    @description('Required. The resource id of the private DNS zone.')
    privateDnsZoneResourceId: string
  }[]
}

type privateEndpointCustomDnsConfigType = {
  @description('Optional. FQDN that resolves to private endpoint IP address.')
  fqdn: string?

  @description('Required. A list of private IP addresses of the private endpoint.')
  ipAddresses: string[]
}

type privateEndpointIpConfigurationType = {
  @description('Required. The name of the resource that is unique within a resource group.')
  name: string

  @description('Required. Properties of private endpoint IP configurations.')
  properties: {
    @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
    groupId: string

    @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
    memberName: string

    @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
    privateIPAddress: string
  }
}

@export()
@description('An AVM-aligned type for a private endpoint. To be used if the private endpoint\'s default service / groupId can be assumed (i.e., for services that only have one Private Endpoint type like \'vault\' for key vault).')
type privateEndpointSingleServiceType = {
  @description('Optional. The name of the Private Endpoint.')
  name: string?

  @description('Optional. The location to deploy the Private Endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Optional. The subresource to deploy the Private Endpoint for. For example "vault" for a Key Vault Private Endpoint.')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.')
  resourceGroupResourceId: string?

  @description('Optional. The private DNS Zone Group to configure for the Private Endpoint.')
  privateDnsZoneGroup: privateEndpointPrivateDnsZoneGroupType?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: privateEndpointCustomDnsConfigType[]?

  @description('Optional. A list of IP configurations of the Private Endpoint. This will be used to map to the first-party Service endpoints.')
  ipConfigurations: privateEndpointIpConfigurationType[]?

  @description('Optional. Application security groups in which the Private Endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the Private Endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Tags to be applied on all resources/Resource Groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}

@export()
@description('An AVM-aligned type for a private endpoint. To be used if the private endpoint\'s default service / groupId can NOT be assumed (i.e., for services that have more than one subresource, like Storage Account with Blob (blob, table, queue, file, ...).')
type privateEndpointMultiServiceType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Required. The subresource to deploy the private endpoint for. For example "blob", "table", "queue" or "file" for a Storage Account\'s Private Endpoints.')
  service: string

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The resource ID of the Resource Group the Private Endpoint will be created in. If not specified, the Resource Group of the provided Virtual Network Subnet is used.')
  resourceGroupResourceId: string?

  @description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: privateEndpointPrivateDnsZoneGroupType?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: privateEndpointCustomDnsConfigType[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: privateEndpointIpConfigurationType[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}

// ======================== //
//   Customer-Managed Keys  //
// ======================== //

@export()
@description('An AVM-aligned type for a customer-managed key. To be used if the resource type does not support auto-rotation of the customer-managed key.')
type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, the deployment will use the latest version available at deployment time.')
  keyVersion: string?

  @description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}

@export()
@description('An AVM-aligned type for a customer-managed key. To be used if the resource type supports auto-rotation of the customer-managed key.')
type customerManagedKeyWithAutoRotateType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using version as per \'autoRotationEnabled\' setting.')
  keyVersion: string?

  @description('Optional. Enable or disable auto-rotating to the latest key version. Default is `true`. If set to `false`, the latest key version at the time of the deployment is used.')
  autoRotationEnabled: bool?

  @description('Optional. User assigned identity to use when fetching the customer managed key. Required if no system assigned identity is available for use.')
  userAssignedIdentityResourceId: string?
}

// ================== //
//   Secrets Export   //
// ================== //
@export()
@description('An AVM-aligned type for the secret to set via the secrets export feature.')
type secretToSetType = {
  @description('Required. The name of the secret to set.')
  name: string

  @description('Required. The value of the secret to set.')
  @secure()
  value: string
}

@export()
@description('An AVM-aligned type for the output of the secret set via the secrets export feature.')
type secretSetOutputType = {
  @description('The resourceId of the exported secret.')
  secretResourceId: string

  @description('The secret URI of the exported secret.')
  secretUri: string

  @description('The secret URI with version of the exported secret.')
  secretUriWithVersion: string
}

@export()
@description('A map of the exported secrets')
type secretsOutputType = {
  @description('An exported secret\'s references.')
  *: secretSetOutputType
}
