metadata name = 'Load Balancers'
metadata description = 'This module deploys a Load Balancer.'
metadata owner = 'Azure/module-maintainers'

// ================ //
// Parameters       //
// ================ //

@description('Required. The Proximity Placement Groups Name.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Name of a load balancer SKU.')
@allowed([
  'Basic'
  'Standard'
])
param skuName string = 'Standard'

@description('Required. Array of objects containing all frontend IP configurations.')
@minLength(1)
param frontendIPConfigurations array

@description('Optional. Collection of backend address pools used by a load balancer.')
param backendAddressPools array?

@description('Optional. Array of objects containing all load balancing rules.')
param loadBalancingRules array?

@description('Optional. Array of objects containing all probes, these are references in the load balancing rules.')
param probes array?

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules.')
param inboundNatRules array = []

@description('Optional. The outbound rules.')
param outboundRules array = []

// =========== //
// Variables   //
// =========== //

var frontendIPConfigurationsVar = [
  for (frontendIPConfiguration, index) in frontendIPConfigurations: {
    name: frontendIPConfiguration.name
    properties: {
      subnet: contains(frontendIPConfiguration, 'subnetId') && !empty(frontendIPConfiguration.subnetId)
        ? {
            id: frontendIPConfiguration.subnetId
          }
        : null
      publicIPAddress: contains(frontendIPConfiguration, 'publicIPAddressId') && !empty(frontendIPConfiguration.publicIPAddressId)
        ? {
            id: frontendIPConfiguration.publicIPAddressId
          }
        : null
      privateIPAddress: contains(frontendIPConfiguration, 'privateIPAddress') && !empty(frontendIPConfiguration.privateIPAddress)
        ? frontendIPConfiguration.privateIPAddress
        : null
      privateIPAddressVersion: contains(frontendIPConfiguration, 'privateIPAddressVersion')
        ? frontendIPConfiguration.privateIPAddressVersion
        : 'IPv4'
      privateIPAllocationMethod: contains(frontendIPConfiguration, 'subnetId') && !empty(frontendIPConfiguration.subnetId)
        ? (contains(frontendIPConfiguration, 'privateIPAddress') ? 'Static' : 'Dynamic')
        : null
      gatewayLoadBalancer: contains(frontendIPConfiguration, 'gatewayLoadBalancer') && !empty(frontendIPConfiguration.gatewayLoadBalancer)
        ? {
            id: frontendIPConfiguration.gatewayLoadBalancer
          }
        : null
      publicIPPrefix: contains(frontendIPConfiguration, 'publicIPPrefix') && !empty(frontendIPConfiguration.publicIPPrefix)
        ? {
            id: frontendIPConfiguration.publicIPPrefix
          }
        : null
    }
  }
]

var loadBalancingRulesVar = [
  for loadBalancingRule in (loadBalancingRules ?? []): {
    name: loadBalancingRule.name
    properties: {
      backendAddressPool: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/backendAddressPools',
          name,
          loadBalancingRule.backendAddressPoolName
        )
      }
      backendPort: loadBalancingRule.backendPort
      disableOutboundSnat: contains(loadBalancingRule, 'disableOutboundSnat')
        ? loadBalancingRule.disableOutboundSnat
        : true
      enableFloatingIP: contains(loadBalancingRule, 'enableFloatingIP') ? loadBalancingRule.enableFloatingIP : false
      enableTcpReset: contains(loadBalancingRule, 'enableTcpReset') ? loadBalancingRule.enableTcpReset : false
      frontendIPConfiguration: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/frontendIPConfigurations',
          name,
          loadBalancingRule.frontendIPConfigurationName
        )
      }
      frontendPort: loadBalancingRule.frontendPort
      idleTimeoutInMinutes: contains(loadBalancingRule, 'idleTimeoutInMinutes')
        ? loadBalancingRule.idleTimeoutInMinutes
        : 4
      loadDistribution: contains(loadBalancingRule, 'loadDistribution') ? loadBalancingRule.loadDistribution : 'Default'
      probe: {
        id: '${az.resourceId('Microsoft.Network/loadBalancers', name)}/probes/${loadBalancingRule.probeName}'
      }
      protocol: contains(loadBalancingRule, 'protocol') ? loadBalancingRule.protocol : 'Tcp'
    }
  }
]

var outboundRulesVar = [
  for outboundRule in outboundRules: {
    name: outboundRule.name
    properties: {
      frontendIPConfigurations: [
        {
          id: az.resourceId(
            'Microsoft.Network/loadBalancers/frontendIPConfigurations',
            name,
            outboundRule.frontendIPConfigurationName
          )
        }
      ]
      backendAddressPool: {
        id: az.resourceId(
          'Microsoft.Network/loadBalancers/backendAddressPools',
          name,
          outboundRule.backendAddressPoolName
        )
      }
      protocol: contains(outboundRule, 'protocol') ? outboundRule.protocol : 'All'
      allocatedOutboundPorts: contains(outboundRule, 'allocatedOutboundPorts')
        ? outboundRule.allocatedOutboundPorts
        : 63984
      enableTcpReset: contains(outboundRule, 'enableTcpReset') ? outboundRule.enableTcpReset : true
      idleTimeoutInMinutes: contains(outboundRule, 'idleTimeoutInMinutes') ? outboundRule.idleTimeoutInMinutes : 4
    }
  }
]

var probesVar = [
  for probe in (probes ?? []): {
    name: probe.name
    properties: {
      protocol: contains(probe, 'protocol') ? probe.protocol : 'Tcp'
      requestPath: toLower(probe.protocol) != 'tcp' ? probe.requestPath : null
      port: contains(probe, 'port') ? probe.port : 80
      intervalInSeconds: contains(probe, 'intervalInSeconds') ? probe.intervalInSeconds : 5
      numberOfProbes: contains(probe, 'numberOfProbes') ? probe.numberOfProbes : 2
    }
  }
]

var backendAddressPoolNames = [
  for backendAddressPool in (backendAddressPools ?? []): {
    name: backendAddressPool.name
  }
]

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

// ============ //
// Dependencies //
// ============ //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' =
  if (enableTelemetry) {
    name: '46d3xbcp.res.network-loadbalancer.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    frontendIPConfigurations: frontendIPConfigurationsVar
    loadBalancingRules: loadBalancingRulesVar
    backendAddressPools: backendAddressPoolNames
    outboundRules: outboundRulesVar
    probes: probesVar
  }
}

module loadBalancer_backendAddressPools 'backend-address-pool/main.bicep' = [
  for (backendAddressPool, index) in backendAddressPools ?? []: {
    name: '${uniqueString(deployment().name, location)}-loadBalancer-backendAddressPools-${index}'
    params: {
      loadBalancerName: loadBalancer.name
      name: backendAddressPool.name
      tunnelInterfaces: contains(backendAddressPool, 'tunnelInterfaces') && !empty(backendAddressPool.tunnelInterfaces)
        ? backendAddressPool.tunnelInterfaces
        : []
      loadBalancerBackendAddresses: contains(backendAddressPool, 'loadBalancerBackendAddresses') && !empty(backendAddressPool.loadBalancerBackendAddresses)
        ? backendAddressPool.loadBalancerBackendAddresses
        : []
      drainPeriodInSeconds: contains(backendAddressPool, 'drainPeriodInSeconds')
        ? backendAddressPool.drainPeriodInSeconds
        : 0
    }
  }
]

module loadBalancer_inboundNATRules 'inbound-nat-rule/main.bicep' = [
  for (inboundNATRule, index) in inboundNatRules: {
    name: '${uniqueString(deployment().name, location)}-LoadBalancer-inboundNatRules-${index}'
    params: {
      loadBalancerName: loadBalancer.name
      name: inboundNATRule.name
      frontendIPConfigurationName: inboundNATRule.frontendIPConfigurationName
      frontendPort: inboundNATRule.frontendPort
      backendPort: contains(inboundNATRule, 'backendPort') ? inboundNATRule.backendPort : inboundNATRule.frontendPort
      backendAddressPoolName: contains(inboundNATRule, 'backendAddressPoolName')
        ? inboundNATRule.backendAddressPoolName
        : ''
      enableFloatingIP: contains(inboundNATRule, 'enableFloatingIP') ? inboundNATRule.enableFloatingIP : false
      enableTcpReset: contains(inboundNATRule, 'enableTcpReset') ? inboundNATRule.enableTcpReset : false
      frontendPortRangeEnd: contains(inboundNATRule, 'frontendPortRangeEnd') ? inboundNATRule.frontendPortRangeEnd : -1
      frontendPortRangeStart: contains(inboundNATRule, 'frontendPortRangeStart')
        ? inboundNATRule.frontendPortRangeStart
        : -1
      idleTimeoutInMinutes: contains(inboundNATRule, 'idleTimeoutInMinutes') ? inboundNATRule.idleTimeoutInMinutes : 4
      protocol: contains(inboundNATRule, 'protocol') ? inboundNATRule.protocol : 'Tcp'
    }
    dependsOn: [
      loadBalancer_backendAddressPools
    ]
  }
]

resource loadBalancer_lock 'Microsoft.Authorization/locks@2020-05-01' =
  if (!empty(lock ?? {}) && lock.?kind != 'None') {
    name: lock.?name ?? 'lock-${name}'
    properties: {
      level: lock.?kind ?? ''
      notes: lock.?kind == 'CanNotDelete'
        ? 'Cannot delete resource or child resources.'
        : 'Cannot delete or modify the resource or child resources.'
    }
    scope: loadBalancer
  }

resource loadBalancer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: loadBalancer
  }
]

resource loadBalancer_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(loadBalancer.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: loadBalancer
  }
]

// =========== //
// Outputs     //
// =========== //

@description('The name of the load balancer.')
output name string = loadBalancer.name

@description('The resource ID of the load balancer.')
output resourceId string = loadBalancer.id

@description('The resource group the load balancer was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The backend address pools available in the load balancer.')
output backendpools array = loadBalancer.properties.backendAddressPools

@description('The location the resource was deployed into.')
output location string = loadBalancer.location

// ================ //
// Definitions      //
// ================ //

type diagnosticSettingType = {
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
}[]?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
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
}[]?
