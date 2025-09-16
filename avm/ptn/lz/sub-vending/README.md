# Sub-vending `[Lz/SubVending]`

This module deploys a subscription to accelerate deployment of landing zones. For more information on how to use it, please visit this [Wiki](https://github.com/Azure/bicep-lz-vending/wiki).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Authorization/roleAssignmentScheduleRequests` | 2022-04-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignmentschedulerequests.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleAssignmentScheduleRequests)</li></ul> |
| `Microsoft.Authorization/roleEligibilityScheduleRequests` | 2022-04-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleeligibilityschedulerequests.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleEligibilityScheduleRequests)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.KeyVault/vaults/secrets` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.keyvault_vaults_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/secrets)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities)</li></ul> |
| `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials` | 2024-11-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.managedidentity_userassignedidentities_federatedidentitycredentials.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ManagedIdentity/2024-11-30/userAssignedIdentities/federatedIdentityCredentials)</li></ul> |
| `Microsoft.Management/managementGroups/subscriptions` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.management_managementgroups_subscriptions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Management/2023-04-01/managementGroups/subscriptions)</li></ul> |
| `Microsoft.Network/bastionHosts` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_bastionhosts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/bastionHosts)</li></ul> |
| `Microsoft.Network/natGateways` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_natgateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/natGateways)</li></ul> |
| `Microsoft.Network/networkSecurityGroups` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecuritygroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/networkSecurityGroups)</li></ul> |
| `Microsoft.Network/privateDnsZones` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones)</li></ul> |
| `Microsoft.Network/privateDnsZones/A` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_a.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/A)</li></ul> |
| `Microsoft.Network/privateDnsZones/AAAA` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_aaaa.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/AAAA)</li></ul> |
| `Microsoft.Network/privateDnsZones/CNAME` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_cname.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/CNAME)</li></ul> |
| `Microsoft.Network/privateDnsZones/MX` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_mx.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/MX)</li></ul> |
| `Microsoft.Network/privateDnsZones/PTR` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_ptr.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/PTR)</li></ul> |
| `Microsoft.Network/privateDnsZones/SOA` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_soa.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SOA)</li></ul> |
| `Microsoft.Network/privateDnsZones/SRV` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_srv.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/SRV)</li></ul> |
| `Microsoft.Network/privateDnsZones/TXT` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_txt.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/TXT)</li></ul> |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2024-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_virtualnetworklinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks)</li></ul> |
| `Microsoft.Network/privateEndpoints` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints)</li></ul> |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privateendpoints_privatednszonegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/privateEndpoints/privateDnsZoneGroups)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/publicIPPrefixes` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipprefixes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/publicIPPrefixes)</li></ul> |
| `Microsoft.Network/routeTables` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_routetables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/routeTables)</li></ul> |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | 2023-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualhubs_hubvirtualnetworkconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualHubs/hubVirtualNetworkConnections)</li></ul> |
| `Microsoft.Network/virtualNetworks` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks)</li></ul> |
| `Microsoft.Network/virtualNetworks/subnets` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_subnets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworks/subnets)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualnetworks_virtualnetworkpeerings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/virtualNetworks/virtualNetworkPeerings)</li></ul> |
| `Microsoft.Resources/deploymentScripts` | 2023-08-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_deploymentscripts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2023-08-01/deploymentScripts)</li></ul> |
| `Microsoft.Resources/resourceGroups` | 2021-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_resourcegroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2021-04-01/resourceGroups)</li></ul> |
| `Microsoft.Resources/tags` | 2025-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.resources_tags.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Resources/2025-04-01/tags)</li></ul> |
| `Microsoft.Storage/storageAccounts` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/fileServices/shares)</li></ul> |
| `Microsoft.Storage/storageAccounts/localUsers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_localusers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers)</li></ul> |
| `Microsoft.Storage/storageAccounts/managementPolicies` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_managementpolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/managementPolicies)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/queueServices/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_queueservices_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/queueServices/queues)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_tableservices_tables.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/tableServices/tables)</li></ul> |
| `Microsoft.Subscription/aliases` | 2021-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.subscription_aliases.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Subscription/2021-10-01/aliases)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/lz/sub-vending:<version>`.

- [Multiple virtual networks.](#example-1-multiple-virtual-networks)
- [Deploy subscription with Bastion.](#example-2-deploy-subscription-with-bastion)
- [Using only defaults.](#example-3-using-only-defaults)
- [Hub and spoke topology.](#example-4-hub-and-spoke-topology)
- [Hub and spoke topology with NAT gateway.](#example-5-hub-and-spoke-topology-with-nat-gateway)
- [Using PIM Active Role assignments.](#example-6-using-pim-active-role-assignments)
- [Using PIM Eligible Role assignments.](#example-7-using-pim-eligible-role-assignments)
- [Using RBAC conditions.](#example-8-using-rbac-conditions)
- [Using standalone NSG deployment.](#example-9-using-standalone-nsg-deployment)
- [Using user-assigned managed identities.](#example-10-using-user-assigned-managed-identities)
- [Vwan topology.](#example-11-vwan-topology)

### Example 1: _Multiple virtual networks._

This instance deploys a subscription with a multiple virtual networks.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    additionalVirtualNetworks: [
      {
        addressPrefixes: [
          '10.120.0.0/16'
        ]
        location: '<location>'
        name: '<name>'
        resourceGroupLockEnabled: false
        resourceGroupName: '<resourceGroupName>'
        subnets: [
          {
            addressPrefix: '10.120.1.0/24'
            name: 'subnet1'
            networkSecurityGroup: {
              location: '<location>'
              name: '<name>'
              securityRules: [
                {
                  name: 'Allow-HTTPS'
                  properties: {
                    access: 'Allow'
                    description: 'Allow HTTPS'
                    destinationAddressPrefix: '*'
                    destinationPortRange: '443'
                    direction: 'Inbound'
                    priority: 100
                    protocol: 'Tcp'
                    sourceAddressPrefix: '*'
                    sourcePortRange: '*'
                  }
                }
              ]
            }
          }
        ]
      }
      {
        addressPrefixes: [
          '10.90.0.0/16'
        ]
        deployNatGateway: true
        location: '<location>'
        name: '<name>'
        natGatewayConfiguration: {
          name: '<name>'
        }
        peerToHubNetwork: false
        resourceGroupLockEnabled: false
        resourceGroupName: '<resourceGroupName>'
        subnets: [
          {
            addressPrefix: '10.90.1.0/24'
            associateWithNatGateway: true
            name: 'data-subnet'
            routeTableName: '<routeTableName>'
          }
        ]
      }
    ]
    peerAllVirtualNetworks: true
    resourceProviders: {}
    routeTables: [
      {
        location: '<location>'
        name: '<name>'
        routes: [
          {
            name: 'route1'
            properties: {
              addressPrefix: '0.0.0.0/0'
              nextHopType: 'None'
            }
          }
        ]
      }
    ]
    routeTablesResourceGroupName: '<routeTablesResourceGroupName>'
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.110.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.110.1.0/24'
        name: 'app-subnet'
        routeTableName: '<routeTableName>'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "additionalVirtualNetworks": {
      "value": [
        {
          "addressPrefixes": [
            "10.120.0.0/16"
          ],
          "location": "<location>",
          "name": "<name>",
          "resourceGroupLockEnabled": false,
          "resourceGroupName": "<resourceGroupName>",
          "subnets": [
            {
              "addressPrefix": "10.120.1.0/24",
              "name": "subnet1",
              "networkSecurityGroup": {
                "location": "<location>",
                "name": "<name>",
                "securityRules": [
                  {
                    "name": "Allow-HTTPS",
                    "properties": {
                      "access": "Allow",
                      "description": "Allow HTTPS",
                      "destinationAddressPrefix": "*",
                      "destinationPortRange": "443",
                      "direction": "Inbound",
                      "priority": 100,
                      "protocol": "Tcp",
                      "sourceAddressPrefix": "*",
                      "sourcePortRange": "*"
                    }
                  }
                ]
              }
            }
          ]
        },
        {
          "addressPrefixes": [
            "10.90.0.0/16"
          ],
          "deployNatGateway": true,
          "location": "<location>",
          "name": "<name>",
          "natGatewayConfiguration": {
            "name": "<name>"
          },
          "peerToHubNetwork": false,
          "resourceGroupLockEnabled": false,
          "resourceGroupName": "<resourceGroupName>",
          "subnets": [
            {
              "addressPrefix": "10.90.1.0/24",
              "associateWithNatGateway": true,
              "name": "data-subnet",
              "routeTableName": "<routeTableName>"
            }
          ]
        }
      ]
    },
    "peerAllVirtualNetworks": {
      "value": true
    },
    "resourceProviders": {
      "value": {}
    },
    "routeTables": {
      "value": [
        {
          "location": "<location>",
          "name": "<name>",
          "routes": [
            {
              "name": "route1",
              "properties": {
                "addressPrefix": "0.0.0.0/0",
                "nextHopType": "None"
              }
            }
          ]
        }
      ]
    },
    "routeTablesResourceGroupName": {
      "value": "<routeTablesResourceGroupName>"
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.110.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.110.1.0/24",
          "name": "app-subnet",
          "routeTableName": "<routeTableName>"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param additionalVirtualNetworks = [
  {
    addressPrefixes: [
      '10.120.0.0/16'
    ]
    location: '<location>'
    name: '<name>'
    resourceGroupLockEnabled: false
    resourceGroupName: '<resourceGroupName>'
    subnets: [
      {
        addressPrefix: '10.120.1.0/24'
        name: 'subnet1'
        networkSecurityGroup: {
          location: '<location>'
          name: '<name>'
          securityRules: [
            {
              name: 'Allow-HTTPS'
              properties: {
                access: 'Allow'
                description: 'Allow HTTPS'
                destinationAddressPrefix: '*'
                destinationPortRange: '443'
                direction: 'Inbound'
                priority: 100
                protocol: 'Tcp'
                sourceAddressPrefix: '*'
                sourcePortRange: '*'
              }
            }
          ]
        }
      }
    ]
  }
  {
    addressPrefixes: [
      '10.90.0.0/16'
    ]
    deployNatGateway: true
    location: '<location>'
    name: '<name>'
    natGatewayConfiguration: {
      name: '<name>'
    }
    peerToHubNetwork: false
    resourceGroupLockEnabled: false
    resourceGroupName: '<resourceGroupName>'
    subnets: [
      {
        addressPrefix: '10.90.1.0/24'
        associateWithNatGateway: true
        name: 'data-subnet'
        routeTableName: '<routeTableName>'
      }
    ]
  }
]
param peerAllVirtualNetworks = true
param resourceProviders = {}
param routeTables = [
  {
    location: '<location>'
    name: '<name>'
    routes: [
      {
        name: 'route1'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'None'
        }
      }
    ]
  }
]
param routeTablesResourceGroupName = '<routeTablesResourceGroupName>'
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.110.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.110.1.0/24'
    name: 'app-subnet'
    routeTableName: '<routeTableName>'
  }
]
```

</details>
<p>

### Example 2: _Deploy subscription with Bastion._

This instance deploys a subscription with a bastion host.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.130.0.0/16'
    ]
    virtualNetworkBastionConfiguration: {
      bastionSku: 'Standard'
      name: '<name>'
    }
    virtualNetworkDeployBastion: true
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.130.1.0/24'
        name: 'Subnet1'
      }
      {
        addressPrefix: '10.130.0.0/26'
        name: 'AzureBastionSubnet'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.130.0.0/16"
      ]
    },
    "virtualNetworkBastionConfiguration": {
      "value": {
        "bastionSku": "Standard",
        "name": "<name>"
      }
    },
    "virtualNetworkDeployBastion": {
      "value": true
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.130.1.0/24",
          "name": "Subnet1"
        },
        {
          "addressPrefix": "10.130.0.0/26",
          "name": "AzureBastionSubnet"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.130.0.0/16'
]
param virtualNetworkBastionConfiguration = {
  bastionSku: 'Standard'
  name: '<name>'
}
param virtualNetworkDeployBastion = true
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.130.1.0/24'
    name: 'Subnet1'
  }
  {
    addressPrefix: '10.130.0.0/26'
    name: 'AzureBastionSubnet'
  }
]
```

</details>
<p>

### Example 3: _Using only defaults._

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
```

</details>
<p>

### Example 4: _Hub and spoke topology._

This instance deploys a subscription with a hub-spoke network topology.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-ssahs'
    deploymentScriptNetworkSecurityGroupName: '<deploymentScriptNetworkSecurityGroupName>'
    deploymentScriptResourceGroupName: '<deploymentScriptResourceGroupName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptVirtualNetworkName: '<deploymentScriptVirtualNetworkName>'
    hubNetworkResourceId: '<hubNetworkResourceId>'
    resourceProviders: {
      'Microsoft.AVS': [
        'AzureServicesVm'
      ]
      'Microsoft.HybridCompute': [
        'ArcServerPrivateLinkPreview'
      ]
      'Microsoft.Network': []
    }
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        description: 'Network contributor role'
        principalId: '<principalId>'
        principalType: 'User'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.110.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkPeeringEnabled: true
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.110.1.0/24'
        name: 'Subnet1'
        networkSecurityGroup: {
          location: '<location>'
          name: '<name>'
          securityRules: [
            {
              name: 'Allow-HTTPS'
              properties: {
                access: 'Allow'
                description: 'Allow HTTPS'
                destinationAddressPrefix: '*'
                destinationPortRange: '443'
                direction: 'Inbound'
                priority: 100
                protocol: 'Tcp'
                sourceAddressPrefix: '*'
                sourcePortRange: '*'
              }
            }
          ]
        }
      }
    ]
    virtualNetworkUseRemoteGateways: false
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentScriptLocation": {
      "value": "<deploymentScriptLocation>"
    },
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptName": {
      "value": "ds-ssahs"
    },
    "deploymentScriptNetworkSecurityGroupName": {
      "value": "<deploymentScriptNetworkSecurityGroupName>"
    },
    "deploymentScriptResourceGroupName": {
      "value": "<deploymentScriptResourceGroupName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptVirtualNetworkName": {
      "value": "<deploymentScriptVirtualNetworkName>"
    },
    "hubNetworkResourceId": {
      "value": "<hubNetworkResourceId>"
    },
    "resourceProviders": {
      "value": {
        "Microsoft.AVS": [
          "AzureServicesVm"
        ],
        "Microsoft.HybridCompute": [
          "ArcServerPrivateLinkPreview"
        ],
        "Microsoft.Network": []
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7",
          "description": "Network contributor role",
          "principalId": "<principalId>",
          "principalType": "User",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.110.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkPeeringEnabled": {
      "value": true
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.110.1.0/24",
          "name": "Subnet1",
          "networkSecurityGroup": {
            "location": "<location>",
            "name": "<name>",
            "securityRules": [
              {
                "name": "Allow-HTTPS",
                "properties": {
                  "access": "Allow",
                  "description": "Allow HTTPS",
                  "destinationAddressPrefix": "*",
                  "destinationPortRange": "443",
                  "direction": "Inbound",
                  "priority": 100,
                  "protocol": "Tcp",
                  "sourceAddressPrefix": "*",
                  "sourcePortRange": "*"
                }
              }
            ]
          }
        }
      ]
    },
    "virtualNetworkUseRemoteGateways": {
      "value": false
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param deploymentScriptLocation = '<deploymentScriptLocation>'
param deploymentScriptManagedIdentityName = '<deploymentScriptManagedIdentityName>'
param deploymentScriptName = 'ds-ssahs'
param deploymentScriptNetworkSecurityGroupName = '<deploymentScriptNetworkSecurityGroupName>'
param deploymentScriptResourceGroupName = '<deploymentScriptResourceGroupName>'
param deploymentScriptStorageAccountName = '<deploymentScriptStorageAccountName>'
param deploymentScriptVirtualNetworkName = '<deploymentScriptVirtualNetworkName>'
param hubNetworkResourceId = '<hubNetworkResourceId>'
param resourceProviders = {
  'Microsoft.AVS': [
    'AzureServicesVm'
  ]
  'Microsoft.HybridCompute': [
    'ArcServerPrivateLinkPreview'
  ]
  'Microsoft.Network': []
}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
    description: 'Network contributor role'
    principalId: '<principalId>'
    principalType: 'User'
    relativeScope: '<relativeScope>'
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.110.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkPeeringEnabled = true
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.110.1.0/24'
    name: 'Subnet1'
    networkSecurityGroup: {
      location: '<location>'
      name: '<name>'
      securityRules: [
        {
          name: 'Allow-HTTPS'
          properties: {
            access: 'Allow'
            description: 'Allow HTTPS'
            destinationAddressPrefix: '*'
            destinationPortRange: '443'
            direction: 'Inbound'
            priority: 100
            protocol: 'Tcp'
            sourceAddressPrefix: '*'
            sourcePortRange: '*'
          }
        }
      ]
    }
  }
]
param virtualNetworkUseRemoteGateways = false
```

</details>
<p>

### Example 5: _Hub and spoke topology with NAT gateway._

This instance deploys a subscription with a hub-spoke network topology with NAT gateway.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {
      'Microsoft.Network': []
    }
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        principalId: '<principalId>'
        principalType: 'User'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.120.0.0/16'
    ]
    virtualNetworkDeployNatGateway: true
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkNatGatewayConfiguration: {
      name: '<name>'
      publicIPAddressProperties: [
        {
          name: '<name>'
          zones: [
            1
            2
            3
          ]
        }
      ]
    }
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
    virtualNetworkSubnets: [
      {
        addressPrefix: '10.120.1.0/24'
        associateWithNatGateway: true
        name: 'Subnet1'
      }
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {
        "Microsoft.Network": []
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7",
          "principalId": "<principalId>",
          "principalType": "User",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.120.0.0/16"
      ]
    },
    "virtualNetworkDeployNatGateway": {
      "value": true
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkNatGatewayConfiguration": {
      "value": {
        "name": "<name>",
        "publicIPAddressProperties": [
          {
            "name": "<name>",
            "zones": [
              1,
              2,
              3
            ]
          }
        ]
      }
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    },
    "virtualNetworkSubnets": {
      "value": [
        {
          "addressPrefix": "10.120.1.0/24",
          "associateWithNatGateway": true,
          "name": "Subnet1"
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {
  'Microsoft.Network': []
}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
    principalId: '<principalId>'
    principalType: 'User'
    relativeScope: '<relativeScope>'
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.120.0.0/16'
]
param virtualNetworkDeployNatGateway = true
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkNatGatewayConfiguration = {
  name: '<name>'
  publicIPAddressProperties: [
    {
      name: '<name>'
      zones: [
        1
        2
        3
      ]
    }
  ]
}
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
param virtualNetworkSubnets = [
  {
    addressPrefix: '10.120.1.0/24'
    associateWithNatGateway: true
    name: 'Subnet1'
  }
]
```

</details>
<p>

### Example 6: _Using PIM Active Role assignments._

This instance deploys the module with PIM Active Role assignments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    pimRoleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        justification: 'This is a justification from an AVM test.'
        principalId: '<principalId>'
        relativeScope: '<relativeScope>'
        requestType: 'AdminAssign'
        roleAssignmentType: 'Active'
        scheduleInfo: {
          duration: 'PT4H'
          durationType: 'AfterDuration'
          startTime: '<startTime>'
        }
      }
    ]
    resourceProviders: {
      'Microsoft.Network': []
    }
    roleAssignmentEnabled: true
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.140.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "pimRoleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
          "justification": "This is a justification from an AVM test.",
          "principalId": "<principalId>",
          "relativeScope": "<relativeScope>",
          "requestType": "AdminAssign",
          "roleAssignmentType": "Active",
          "scheduleInfo": {
            "duration": "PT4H",
            "durationType": "AfterDuration",
            "startTime": "<startTime>"
          }
        }
      ]
    },
    "resourceProviders": {
      "value": {
        "Microsoft.Network": []
      }
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.140.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param pimRoleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    justification: 'This is a justification from an AVM test.'
    principalId: '<principalId>'
    relativeScope: '<relativeScope>'
    requestType: 'AdminAssign'
    roleAssignmentType: 'Active'
    scheduleInfo: {
      duration: 'PT4H'
      durationType: 'AfterDuration'
      startTime: '<startTime>'
    }
  }
]
param resourceProviders = {
  'Microsoft.Network': []
}
param roleAssignmentEnabled = true
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.140.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
```

</details>
<p>

### Example 7: _Using PIM Eligible Role assignments._

This instance deploys the module with PIM Eligible Role assignments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    pimRoleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        justification: 'This is a justification from an AVM test.'
        principalId: '<principalId>'
        relativeScope: ''
        requestType: 'AdminUpdate'
        roleAssignmentType: 'Eligible'
        scheduleInfo: {
          duration: 'PT4H'
          durationType: 'AfterDuration'
          startTime: '<startTime>'
        }
      }
    ]
    resourceProviders: {}
    roleAssignmentEnabled: true
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "pimRoleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
          "justification": "This is a justification from an AVM test.",
          "principalId": "<principalId>",
          "relativeScope": "",
          "requestType": "AdminUpdate",
          "roleAssignmentType": "Eligible",
          "scheduleInfo": {
            "duration": "PT4H",
            "durationType": "AfterDuration",
            "startTime": "<startTime>"
          }
        }
      ]
    },
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param pimRoleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    justification: 'This is a justification from an AVM test.'
    principalId: '<principalId>'
    relativeScope: ''
    requestType: 'AdminUpdate'
    roleAssignmentType: 'Eligible'
    scheduleInfo: {
      duration: 'PT4H'
      durationType: 'AfterDuration'
      startTime: '<startTime>'
    }
  }
]
param resourceProviders = {}
param roleAssignmentEnabled = true
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
```

</details>
<p>

### Example 8: _Using RBAC conditions._

This instance deploys the module with RBAC conditions for the role assignments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
        principalId: '<principalId>'
        principalType: 'User'
        relativeScope: ''
        roleAssignmentCondition: {
          roleConditionType: {
            principleTypesToAssign: [
              'Group'
              'ServicePrincipal'
            ]
            rolesToAssign: [
              'b24988ac-6180-42a0-ab88-20f7382dd24c'
            ]
            templateName: 'constrainRolesAndPrincipalTypes'
          }
        }
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168",
          "principalId": "<principalId>",
          "principalType": "User",
          "relativeScope": "",
          "roleAssignmentCondition": {
            "roleConditionType": {
              "principleTypesToAssign": [
                "Group",
                "ServicePrincipal"
              ],
              "rolesToAssign": [
                "b24988ac-6180-42a0-ab88-20f7382dd24c"
              ],
              "templateName": "constrainRolesAndPrincipalTypes"
            }
          }
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    principalId: '<principalId>'
    principalType: 'User'
    relativeScope: ''
    roleAssignmentCondition: {
      roleConditionType: {
        principleTypesToAssign: [
          'Group'
          'ServicePrincipal'
        ]
        rolesToAssign: [
          'b24988ac-6180-42a0-ab88-20f7382dd24c'
        ]
        templateName: 'constrainRolesAndPrincipalTypes'
      }
    }
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
```

</details>
<p>

### Example 9: _Using standalone NSG deployment._

This instance deploys the module to test standalone NSG deployments.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    networkSecurityGroupResourceGroupName: '<networkSecurityGroupResourceGroupName>'
    networkSecurityGroups: [
      {
        location: '<location>'
        name: '<name>'
        securityRules: [
          {
            name: 'Allow-HTTP-Inbound'
            properties: {
              access: 'Allow'
              destinationAddressPrefix: '*'
              destinationPortRange: '80'
              direction: 'Inbound'
              priority: 100
              protocol: 'Tcp'
              sourceAddressPrefix: '*'
              sourcePortRange: '*'
            }
          }
          {
            name: 'Allow-HTTPS-Inbound'
            properties: {
              access: 'Allow'
              destinationAddressPrefix: '*'
              destinationPortRange: '443'
              direction: 'Inbound'
              priority: 110
              protocol: 'Tcp'
              sourceAddressPrefix: '*'
              sourcePortRange: '*'
            }
          }
        ]
      }
    ]
    resourceProviders: {}
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "networkSecurityGroupResourceGroupName": {
      "value": "<networkSecurityGroupResourceGroupName>"
    },
    "networkSecurityGroups": {
      "value": [
        {
          "location": "<location>",
          "name": "<name>",
          "securityRules": [
            {
              "name": "Allow-HTTP-Inbound",
              "properties": {
                "access": "Allow",
                "destinationAddressPrefix": "*",
                "destinationPortRange": "80",
                "direction": "Inbound",
                "priority": 100,
                "protocol": "Tcp",
                "sourceAddressPrefix": "*",
                "sourcePortRange": "*"
              }
            },
            {
              "name": "Allow-HTTPS-Inbound",
              "properties": {
                "access": "Allow",
                "destinationAddressPrefix": "*",
                "destinationPortRange": "443",
                "direction": "Inbound",
                "priority": 110,
                "protocol": "Tcp",
                "sourceAddressPrefix": "*",
                "sourcePortRange": "*"
              }
            }
          ]
        }
      ]
    },
    "resourceProviders": {
      "value": {}
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param networkSecurityGroupResourceGroupName = '<networkSecurityGroupResourceGroupName>'
param networkSecurityGroups = [
  {
    location: '<location>'
    name: '<name>'
    securityRules: [
      {
        name: 'Allow-HTTP-Inbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '80'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'Allow-HTTPS-Inbound'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          direction: 'Inbound'
          priority: 110
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
]
param resourceProviders = {}
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
```

</details>
<p>

### Example 10: _Using user-assigned managed identities._

This instance deploys the module with user-assigned managed identities.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    resourceProviders: {}
    roleAssignmentEnabled: true
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    userAssignedIdentitiesResourceGroupLockEnabled: false
    userAssignedIdentityResourceGroupName: 'rg-identity-ssmsi'
    userAssignedManagedIdentities: [
      {
        federatedIdentityCredentials: [
          {
            audiences: [
              'api://AzureADTokenExchange'
            ]
            issuer: 'https://token.actions.githubusercontent.com'
            name: '<name>'
            subject: 'repo:githubOrganization/sampleRepository:ref:refs/heads/main'
          }
        ]
        location: '<location>'
        name: 'test-identity-ssmsi'
        roleAssignments: [
          {
            definition: '/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
            description: 'Virtual Machine Contributor'
            relativeScope: ''
          }
          {
            definition: '/providers/Microsoft.Authorization/roleDefinitions/602da2ba-a5c2-41da-b01d-5360126ab525'
            description: 'Virtual Machine Local User Login'
            relativeScope: '<relativeScope>'
          }
        ]
      }
    ]
    virtualNetworkAddressSpace: [
      '10.110.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "userAssignedIdentitiesResourceGroupLockEnabled": {
      "value": false
    },
    "userAssignedIdentityResourceGroupName": {
      "value": "rg-identity-ssmsi"
    },
    "userAssignedManagedIdentities": {
      "value": [
        {
          "federatedIdentityCredentials": [
            {
              "audiences": [
                "api://AzureADTokenExchange"
              ],
              "issuer": "https://token.actions.githubusercontent.com",
              "name": "<name>",
              "subject": "repo:githubOrganization/sampleRepository:ref:refs/heads/main"
            }
          ],
          "location": "<location>",
          "name": "test-identity-ssmsi",
          "roleAssignments": [
            {
              "definition": "/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c",
              "description": "Virtual Machine Contributor",
              "relativeScope": ""
            },
            {
              "definition": "/providers/Microsoft.Authorization/roleDefinitions/602da2ba-a5c2-41da-b01d-5360126ab525",
              "description": "Virtual Machine Local User Login",
              "relativeScope": "<relativeScope>"
            }
          ]
        }
      ]
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.110.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param resourceProviders = {}
param roleAssignmentEnabled = true
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param userAssignedIdentitiesResourceGroupLockEnabled = false
param userAssignedIdentityResourceGroupName = 'rg-identity-ssmsi'
param userAssignedManagedIdentities = [
  {
    federatedIdentityCredentials: [
      {
        audiences: [
          'api://AzureADTokenExchange'
        ]
        issuer: 'https://token.actions.githubusercontent.com'
        name: '<name>'
        subject: 'repo:githubOrganization/sampleRepository:ref:refs/heads/main'
      }
    ]
    location: '<location>'
    name: 'test-identity-ssmsi'
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
        description: 'Virtual Machine Contributor'
        relativeScope: ''
      }
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/602da2ba-a5c2-41da-b01d-5360126ab525'
        description: 'Virtual Machine Local User Login'
        relativeScope: '<relativeScope>'
      }
    ]
  }
]
param virtualNetworkAddressSpace = [
  '10.110.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
```

</details>
<p>

### Example 11: _Vwan topology._

This instance deploys a subscription with a vwan network topology.


<details>

<summary>via Bicep module</summary>

```bicep
module subVending 'br/public:avm/ptn/lz/sub-vending:<version>' = {
  name: 'subVendingDeployment'
  params: {
    deploymentScriptLocation: '<deploymentScriptLocation>'
    deploymentScriptManagedIdentityName: '<deploymentScriptManagedIdentityName>'
    deploymentScriptName: 'ds-ssawan'
    deploymentScriptNetworkSecurityGroupName: '<deploymentScriptNetworkSecurityGroupName>'
    deploymentScriptResourceGroupName: '<deploymentScriptResourceGroupName>'
    deploymentScriptStorageAccountName: '<deploymentScriptStorageAccountName>'
    deploymentScriptVirtualNetworkName: '<deploymentScriptVirtualNetworkName>'
    hubNetworkResourceId: '<hubNetworkResourceId>'
    resourceProviders: {}
    roleAssignmentEnabled: true
    roleAssignments: [
      {
        definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
        description: 'Network contributor role'
        principalId: '<principalId>'
        relativeScope: '<relativeScope>'
      }
    ]
    subscriptionAliasEnabled: true
    subscriptionAliasName: '<subscriptionAliasName>'
    subscriptionBillingScope: '<subscriptionBillingScope>'
    subscriptionDisplayName: '<subscriptionDisplayName>'
    subscriptionManagementGroupAssociationEnabled: true
    subscriptionManagementGroupId: 'bicep-lz-vending-automation-child'
    subscriptionTags: {
      namePrefix: '<namePrefix>'
      serviceShort: '<serviceShort>'
    }
    subscriptionWorkload: 'Production'
    virtualNetworkAddressSpace: [
      '10.210.0.0/16'
    ]
    virtualNetworkEnabled: true
    virtualNetworkLocation: '<virtualNetworkLocation>'
    virtualNetworkName: '<virtualNetworkName>'
    virtualNetworkPeeringEnabled: true
    virtualNetworkResourceGroupLockEnabled: false
    virtualNetworkResourceGroupName: '<virtualNetworkResourceGroupName>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "deploymentScriptLocation": {
      "value": "<deploymentScriptLocation>"
    },
    "deploymentScriptManagedIdentityName": {
      "value": "<deploymentScriptManagedIdentityName>"
    },
    "deploymentScriptName": {
      "value": "ds-ssawan"
    },
    "deploymentScriptNetworkSecurityGroupName": {
      "value": "<deploymentScriptNetworkSecurityGroupName>"
    },
    "deploymentScriptResourceGroupName": {
      "value": "<deploymentScriptResourceGroupName>"
    },
    "deploymentScriptStorageAccountName": {
      "value": "<deploymentScriptStorageAccountName>"
    },
    "deploymentScriptVirtualNetworkName": {
      "value": "<deploymentScriptVirtualNetworkName>"
    },
    "hubNetworkResourceId": {
      "value": "<hubNetworkResourceId>"
    },
    "resourceProviders": {
      "value": {}
    },
    "roleAssignmentEnabled": {
      "value": true
    },
    "roleAssignments": {
      "value": [
        {
          "definition": "/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7",
          "description": "Network contributor role",
          "principalId": "<principalId>",
          "relativeScope": "<relativeScope>"
        }
      ]
    },
    "subscriptionAliasEnabled": {
      "value": true
    },
    "subscriptionAliasName": {
      "value": "<subscriptionAliasName>"
    },
    "subscriptionBillingScope": {
      "value": "<subscriptionBillingScope>"
    },
    "subscriptionDisplayName": {
      "value": "<subscriptionDisplayName>"
    },
    "subscriptionManagementGroupAssociationEnabled": {
      "value": true
    },
    "subscriptionManagementGroupId": {
      "value": "bicep-lz-vending-automation-child"
    },
    "subscriptionTags": {
      "value": {
        "namePrefix": "<namePrefix>",
        "serviceShort": "<serviceShort>"
      }
    },
    "subscriptionWorkload": {
      "value": "Production"
    },
    "virtualNetworkAddressSpace": {
      "value": [
        "10.210.0.0/16"
      ]
    },
    "virtualNetworkEnabled": {
      "value": true
    },
    "virtualNetworkLocation": {
      "value": "<virtualNetworkLocation>"
    },
    "virtualNetworkName": {
      "value": "<virtualNetworkName>"
    },
    "virtualNetworkPeeringEnabled": {
      "value": true
    },
    "virtualNetworkResourceGroupLockEnabled": {
      "value": false
    },
    "virtualNetworkResourceGroupName": {
      "value": "<virtualNetworkResourceGroupName>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/lz/sub-vending:<version>'

param deploymentScriptLocation = '<deploymentScriptLocation>'
param deploymentScriptManagedIdentityName = '<deploymentScriptManagedIdentityName>'
param deploymentScriptName = 'ds-ssawan'
param deploymentScriptNetworkSecurityGroupName = '<deploymentScriptNetworkSecurityGroupName>'
param deploymentScriptResourceGroupName = '<deploymentScriptResourceGroupName>'
param deploymentScriptStorageAccountName = '<deploymentScriptStorageAccountName>'
param deploymentScriptVirtualNetworkName = '<deploymentScriptVirtualNetworkName>'
param hubNetworkResourceId = '<hubNetworkResourceId>'
param resourceProviders = {}
param roleAssignmentEnabled = true
param roleAssignments = [
  {
    definition: '/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
    description: 'Network contributor role'
    principalId: '<principalId>'
    relativeScope: '<relativeScope>'
  }
]
param subscriptionAliasEnabled = true
param subscriptionAliasName = '<subscriptionAliasName>'
param subscriptionBillingScope = '<subscriptionBillingScope>'
param subscriptionDisplayName = '<subscriptionDisplayName>'
param subscriptionManagementGroupAssociationEnabled = true
param subscriptionManagementGroupId = 'bicep-lz-vending-automation-child'
param subscriptionTags = {
  namePrefix: '<namePrefix>'
  serviceShort: '<serviceShort>'
}
param subscriptionWorkload = 'Production'
param virtualNetworkAddressSpace = [
  '10.210.0.0/16'
]
param virtualNetworkEnabled = true
param virtualNetworkLocation = '<virtualNetworkLocation>'
param virtualNetworkName = '<virtualNetworkName>'
param virtualNetworkPeeringEnabled = true
param virtualNetworkResourceGroupLockEnabled = false
param virtualNetworkResourceGroupName = '<virtualNetworkResourceGroupName>'
```

</details>
<p>

## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalVirtualNetworks`](#parameter-additionalvirtualnetworks) | array | A list of additional virtual networks to create. |
| [`deploymentScriptLocation`](#parameter-deploymentscriptlocation) | string | The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc. |
| [`deploymentScriptManagedIdentityName`](#parameter-deploymentscriptmanagedidentityname) | string | The name of the user managed identity for the resource providers registration deployment script. |
| [`deploymentScriptName`](#parameter-deploymentscriptname) | string | The name of the deployment script to register resource providers. |
| [`deploymentScriptNetworkSecurityGroupName`](#parameter-deploymentscriptnetworksecuritygroupname) | string | The name of the network security group for the deployment script private subnet. |
| [`deploymentScriptResourceGroupName`](#parameter-deploymentscriptresourcegroupname) | string | The name of the resource group to create the deployment script for resource providers registration. |
| [`deploymentScriptStorageAccountName`](#parameter-deploymentscriptstorageaccountname) | string | The name of the storage account for the deployment script. |
| [`deploymentScriptVirtualNetworkName`](#parameter-deploymentscriptvirtualnetworkname) | string | The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`existingSubscriptionId`](#parameter-existingsubscriptionid) | string | An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`. |
| [`hubNetworkResourceId`](#parameter-hubnetworkresourceid) | string | The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<p> |
| [`managementGroupAssociationDelayCount`](#parameter-managementgroupassociationdelaycount) | int | The number of blank ARM deployments to create sequentially to introduce a delay to the Subscription being moved to the target Management Group being, if set, to allow for background platform RBAC inheritance to occur. |
| [`networkSecurityGroupResourceGroupName`](#parameter-networksecuritygroupresourcegroupname) | string | The name of the resource group to create the network security groups in. |
| [`networkSecurityGroups`](#parameter-networksecuritygroups) | array | The list of network security groups to create |
| [`peerAllVirtualNetworks`](#parameter-peerallvirtualnetworks) | bool | Flag to do mesh peering of all virtual networks deployed into the new subscription. |
| [`pimRoleAssignments`](#parameter-pimroleassignments) | array | Supply an array of objects containing the details of the PIM role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p> |
| [`resourceProviders`](#parameter-resourceproviders) | object | An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.<p> |
| [`roleAssignmentEnabled`](#parameter-roleassignmentenabled) | bool | Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<p> |
| [`roleAssignments`](#parameter-roleassignments) | array | Supply an array of objects containing the details of the role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Role Based Access Control Administrator, and User Access Administrator). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p> |
| [`routeTables`](#parameter-routetables) | array | The list of route tables to create. |
| [`routeTablesResourceGroupName`](#parameter-routetablesresourcegroupname) | string | The name of the resource group to create the route tables in. |
| [`subscriptionAliasEnabled`](#parameter-subscriptionaliasenabled) | bool | Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription''s ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription. |
| [`subscriptionAliasName`](#parameter-subscriptionaliasname) | string | The name of the Subscription Alias, that will be created by this module.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`subscriptionBillingScope`](#parameter-subscriptionbillingscope) | string | The Billing Scope for the new Subscription alias, that will be created by this module.<p><p>A valid Billing Scope looks like `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`subscriptionDisplayName`](#parameter-subscriptiondisplayname) | string | The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`subscriptionManagementGroupAssociationEnabled`](#parameter-subscriptionmanagementgroupassociationenabled) | bool | Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<p> |
| [`subscriptionManagementGroupId`](#parameter-subscriptionmanagementgroupid) | string | The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<p><p>**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<p> |
| [`subscriptionOwnerId`](#parameter-subscriptionownerid) | string | The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**. |
| [`subscriptionTags`](#parameter-subscriptiontags) | object | An object of Tag key & value pairs to be appended to a Subscription.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p> |
| [`subscriptionTenantId`](#parameter-subscriptiontenantid) | string | The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**. |
| [`subscriptionWorkload`](#parameter-subscriptionworkload) | string | The workload type can be either `Production` or `DevTest` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p> |
| [`userAssignedIdentitiesResourceGroupLockEnabled`](#parameter-userassignedidentitiesresourcegrouplockenabled) | bool | Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p> |
| [`userAssignedIdentityResourceGroupName`](#parameter-userassignedidentityresourcegroupname) | string | The name of the resource group to create the user-assigned managed identities in. |
| [`userAssignedManagedIdentities`](#parameter-userassignedmanagedidentities) | array | The list of user-assigned managed identities. |
| [`vHubRoutingIntentEnabled`](#parameter-vhubroutingintentenabled) | bool | Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.<p> |
| [`virtualNetworkAddressSpace`](#parameter-virtualnetworkaddressspace) | array | The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`. |
| [`virtualNetworkBastionConfiguration`](#parameter-virtualnetworkbastionconfiguration) | object | The configuration object for the Bastion host. Do not provide this object or keep it empty if you do not want to deploy a Bastion host. |
| [`virtualNetworkDdosPlanResourceId`](#parameter-virtualnetworkddosplanresourceid) | string | The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<p> |
| [`virtualNetworkDeployBastion`](#parameter-virtualnetworkdeploybastion) | bool | Whether to deploy a Bastion host to the created virtual network. |
| [`virtualNetworkDeploymentScriptAddressPrefix`](#parameter-virtualnetworkdeploymentscriptaddressprefix) | string | The address prefix of the private virtual network for the deployment script. |
| [`virtualNetworkDeployNatGateway`](#parameter-virtualnetworkdeploynatgateway) | bool | Whether to deploy a NAT gateway to the created virtual network. |
| [`virtualNetworkDnsServers`](#parameter-virtualnetworkdnsservers) | array | The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<p> |
| [`virtualNetworkEnabled`](#parameter-virtualnetworkenabled) | bool | Whether to create a Virtual Network or not.<p><p>If set to `true` ensure you also provide values for the following parameters at a minimum:<p><li>`virtualNetworkResourceGroupName`<li>`virtualNetworkResourceGroupLockEnabled`<li>`virtualNetworkLocation`<li>`virtualNetworkName`<li>`virtualNetworkAddressSpace`<p><p>> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<p> |
| [`virtualNetworkLocation`](#parameter-virtualnetworklocation) | string | The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<p> |
| [`virtualNetworkName`](#parameter-virtualnetworkname) | string | The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<p> |
| [`virtualNetworkNatGatewayConfiguration`](#parameter-virtualnetworknatgatewayconfiguration) | object | The NAT Gateway configuration object. Do not provide this object or keep it empty if you do not want to deploy a NAT Gateway. |
| [`virtualNetworkPeeringEnabled`](#parameter-virtualnetworkpeeringenabled) | bool | Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<p> |
| [`virtualNetworkResourceGroupLockEnabled`](#parameter-virtualnetworkresourcegrouplockenabled) | bool | Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p> |
| [`virtualNetworkResourceGroupName`](#parameter-virtualnetworkresourcegroupname) | string | The name of the Resource Group to create the Virtual Network in that is created by this module.<p> |
| [`virtualNetworkResourceGroupTags`](#parameter-virtualnetworkresourcegrouptags) | object | An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p> |
| [`virtualNetworkSubnets`](#parameter-virtualnetworksubnets) | array | The subnets of the Virtual Network that will be created by this module. |
| [`virtualNetworkTags`](#parameter-virtualnetworktags) | object | An object of tag key/value pairs to be set on the Virtual Network that is created.<p><p>> **NOTE:** Tags will be overwritten on resource if any exist already.<p> |
| [`virtualNetworkUseRemoteGateways`](#parameter-virtualnetworkuseremotegateways) | bool | Enables the use of remote gateways in the specified hub virtual network.<p><p>> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<p> |
| [`virtualNetworkVwanAssociatedRouteTableResourceId`](#parameter-virtualnetworkvwanassociatedroutetableresourceid) | string | The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<p> |
| [`virtualNetworkVwanEnableInternetSecurity`](#parameter-virtualnetworkvwanenableinternetsecurity) | bool | Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.<p> |
| [`virtualNetworkVwanPropagatedLabels`](#parameter-virtualnetworkvwanpropagatedlabels) | array | An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<p> |
| [`virtualNetworkVwanPropagatedRouteTablesResourceIds`](#parameter-virtualnetworkvwanpropagatedroutetablesresourceids) | array | An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<p><p>Each object must contain the following `key`:<li>`id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<p><p>> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<p> |

### Parameter: `additionalVirtualNetworks`

A list of additional virtual networks to create.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-additionalvirtualnetworksaddressprefixes) | array | The address prefixes for the virtual network. |
| [`location`](#parameter-additionalvirtualnetworkslocation) | string | The location of the virtual network. |
| [`name`](#parameter-additionalvirtualnetworksname) | string | The name of the virtual network resource. |
| [`resourceGroupName`](#parameter-additionalvirtualnetworksresourcegroupname) | string | The name of the virtual network resource group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`alternativeHubVnetResourceId`](#parameter-additionalvirtualnetworksalternativehubvnetresourceid) | string | The resource ID of an alternative virtual network in the hub, opposed to what is defined in the parameter `hubNetworkResourceId`, to which the created virtual network will be peered/connected to via a virtual network peering instead of whats provided in `hubNetworkResourceId`. |
| [`alternativeVwanHubResourceId`](#parameter-additionalvirtualnetworksalternativevwanhubresourceid) | string | The resource ID of an alternative virtual wan hub in the hub, opposed to what is defined in the parameter `hubNetworkResourceId`, to which the created virtual network will be peered/connected to via a virtual hub connection instead of whats provided in `hubNetworkResourceId`. |
| [`ddosProtectionPlanResourceId`](#parameter-additionalvirtualnetworksddosprotectionplanresourceid) | string | The resource Id of the DDOS protection plan. |
| [`deployBastion`](#parameter-additionalvirtualnetworksdeploybastion) | bool | The option to deploy Azure Bastion in the virtual network. |
| [`deployNatGateway`](#parameter-additionalvirtualnetworksdeploynatgateway) | bool | Flag to deploy a NAT gateway. |
| [`dnsServers`](#parameter-additionalvirtualnetworksdnsservers) | array | The list of DNS servers for the virtual network. |
| [`natGatewayConfiguration`](#parameter-additionalvirtualnetworksnatgatewayconfiguration) | object | The configuration for deploying a NAT gateway. |
| [`peerToHubNetwork`](#parameter-additionalvirtualnetworkspeertohubnetwork) | bool | The option to peer the virtual network to the hub network. |
| [`resourceGroupLockEnabled`](#parameter-additionalvirtualnetworksresourcegrouplockenabled) | bool | Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group. |
| [`subnets`](#parameter-additionalvirtualnetworkssubnets) | array | The subnets for the virtual network. |
| [`tags`](#parameter-additionalvirtualnetworkstags) | object | The tags for the virtual network. |
| [`useRemoteGateways`](#parameter-additionalvirtualnetworksuseremotegateways) | bool | Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections. |

### Parameter: `additionalVirtualNetworks.addressPrefixes`

The address prefixes for the virtual network.

- Required: Yes
- Type: array

### Parameter: `additionalVirtualNetworks.location`

The location of the virtual network.

- Required: Yes
- Type: string

### Parameter: `additionalVirtualNetworks.name`

The name of the virtual network resource.

- Required: Yes
- Type: string

### Parameter: `additionalVirtualNetworks.resourceGroupName`

The name of the virtual network resource group.

- Required: Yes
- Type: string

### Parameter: `additionalVirtualNetworks.alternativeHubVnetResourceId`

The resource ID of an alternative virtual network in the hub, opposed to what is defined in the parameter `hubNetworkResourceId`, to which the created virtual network will be peered/connected to via a virtual network peering instead of whats provided in `hubNetworkResourceId`.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.alternativeVwanHubResourceId`

The resource ID of an alternative virtual wan hub in the hub, opposed to what is defined in the parameter `hubNetworkResourceId`, to which the created virtual network will be peered/connected to via a virtual hub connection instead of whats provided in `hubNetworkResourceId`.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.ddosProtectionPlanResourceId`

The resource Id of the DDOS protection plan.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.deployBastion`

The option to deploy Azure Bastion in the virtual network.

- Required: No
- Type: bool

### Parameter: `additionalVirtualNetworks.deployNatGateway`

Flag to deploy a NAT gateway.

- Required: No
- Type: bool

### Parameter: `additionalVirtualNetworks.dnsServers`

The list of DNS servers for the virtual network.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration`

The configuration for deploying a NAT gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-additionalvirtualnetworksnatgatewayconfigurationname) | string | The name of the NAT gateway. |
| [`publicIPAddressPrefixesProperties`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddressprefixesproperties) | array | The Public IP address(es) prefixes properties to be attached to the NAT gateway. |
| [`publicIPAddressProperties`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddressproperties) | array | The Public IP address(es) properties to be attached to the NAT gateway. |
| [`zones`](#parameter-additionalvirtualnetworksnatgatewayconfigurationzones) | int | The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones). |

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.name`

The name of the NAT gateway.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressPrefixesProperties`

The Public IP address(es) prefixes properties to be attached to the NAT gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customIPPrefix`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddressprefixespropertiescustomipprefix) | string | The custom IP prefix of the public IP address prefix. |
| [`name`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddressprefixespropertiesname) | string | The name of the Public IP address prefix. |
| [`prefixLength`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddressprefixespropertiesprefixlength) | int | The prefix length of the public IP address prefix.. |

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressPrefixesProperties.customIPPrefix`

The custom IP prefix of the public IP address prefix.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressPrefixesProperties.name`

The name of the Public IP address prefix.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressPrefixesProperties.prefixLength`

The prefix length of the public IP address prefix..

- Required: No
- Type: int

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressProperties`

The Public IP address(es) properties to be attached to the NAT gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddresspropertiesname) | string | The name of the Public IP address. |
| [`zones`](#parameter-additionalvirtualnetworksnatgatewayconfigurationpublicipaddresspropertieszones) | array | The SKU of the Public IP address. |

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressProperties.name`

The name of the Public IP address.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.publicIPAddressProperties.zones`

The SKU of the Public IP address.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `additionalVirtualNetworks.natGatewayConfiguration.zones`

The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones).

- Required: No
- Type: int

### Parameter: `additionalVirtualNetworks.peerToHubNetwork`

The option to peer the virtual network to the hub network.

- Required: No
- Type: bool

### Parameter: `additionalVirtualNetworks.resourceGroupLockEnabled`

Enables the deployment of a `CanNotDelete` resource locks to the virtual networks resource group.

- Required: No
- Type: bool

### Parameter: `additionalVirtualNetworks.subnets`

The subnets for the virtual network.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-additionalvirtualnetworkssubnetsname) | string | The Name of the subnet resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-additionalvirtualnetworkssubnetsaddressprefix) | string | The address prefix for the subnet. Required if `addressPrefixes` is empty. |
| [`addressPrefixes`](#parameter-additionalvirtualnetworkssubnetsaddressprefixes) | array | List of address prefixes for the subnet. Required if `addressPrefix` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayIPConfigurations`](#parameter-additionalvirtualnetworkssubnetsapplicationgatewayipconfigurations) | array | Application gateway IP configurations of virtual network resource. |
| [`associateWithNatGateway`](#parameter-additionalvirtualnetworkssubnetsassociatewithnatgateway) | bool | Option to associate the subnet with the NAT gatway deployed by this module. |
| [`defaultOutboundAccess`](#parameter-additionalvirtualnetworkssubnetsdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-additionalvirtualnetworkssubnetsdelegation) | string | The delegation to enable on the subnet. |
| [`natGatewayResourceId`](#parameter-additionalvirtualnetworkssubnetsnatgatewayresourceid) | string | The resource ID of the NAT Gateway to use for the subnet. |
| [`networkSecurityGroup`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroup) | object | The network security group to be associated with this subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-additionalvirtualnetworkssubnetsprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-additionalvirtualnetworkssubnetsprivatelinkservicenetworkpolicies) | string | enable or disable apply network policies on private link service in the subnet. |
| [`routeTableName`](#parameter-additionalvirtualnetworkssubnetsroutetablename) | string | The name of the route table to be associated with this subnet. |
| [`serviceEndpointPolicies`](#parameter-additionalvirtualnetworkssubnetsserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-additionalvirtualnetworkssubnetsserviceendpoints) | array | The service endpoints to enable on the subnet. |
| [`sharingScope`](#parameter-additionalvirtualnetworkssubnetssharingscope) | string | Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty. |

### Parameter: `additionalVirtualNetworks.subnets.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.addressPrefix`

The address prefix for the subnet. Required if `addressPrefixes` is empty.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.addressPrefixes`

List of address prefixes for the subnet. Required if `addressPrefix` is empty.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.applicationGatewayIPConfigurations`

Application gateway IP configurations of virtual network resource.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.associateWithNatGateway`

Option to associate the subnet with the NAT gatway deployed by this module.

- Required: No
- Type: bool

### Parameter: `additionalVirtualNetworks.subnets.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `additionalVirtualNetworks.subnets.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.natGatewayResourceId`

The resource ID of the NAT Gateway to use for the subnet.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup`

The network security group to be associated with this subnet.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygrouplocation) | string | The location of the network security group. |
| [`name`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupname) | string | The name of the network security group. |
| [`securityRules`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrules) | array | The security rules of the network security group. |
| [`tags`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygrouptags) | object | The tags of the network security group. |

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.location`

The location of the network security group.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.name`

The name of the network security group.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules`

The security rules of the network security group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-additionalvirtualnetworkssubnetsnetworksecuritygroupsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.access`

Whether network traffic is allowed or denied.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.networkSecurityGroup.tags`

The tags of the network security group.

- Required: No
- Type: object

### Parameter: `additionalVirtualNetworks.subnets.privateEndpointNetworkPolicies`

enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NetworkSecurityGroupEnabled'
    'RouteTableEnabled'
  ]
  ```

### Parameter: `additionalVirtualNetworks.subnets.privateLinkServiceNetworkPolicies`

enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `additionalVirtualNetworks.subnets.routeTableName`

The name of the route table to be associated with this subnet.

- Required: No
- Type: string

### Parameter: `additionalVirtualNetworks.subnets.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array

### Parameter: `additionalVirtualNetworks.subnets.sharingScope`

Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DelegatedServices'
    'Tenant'
  ]
  ```

### Parameter: `additionalVirtualNetworks.tags`

The tags for the virtual network.

- Required: No
- Type: object

### Parameter: `additionalVirtualNetworks.useRemoteGateways`

Enables the use of remote gateways in the spefcified hub virtual network. If no gateways exsit in the hub virtual network, set this to `false`, otherwise peering will fail to create. Set this to `false` for virtual wan hub connections.

- Required: No
- Type: bool

### Parameter: `deploymentScriptLocation`

The location of the deployment script. Use region shortnames e.g. uksouth, eastus, etc.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `deploymentScriptManagedIdentityName`

The name of the user managed identity for the resource providers registration deployment script.

- Required: No
- Type: string
- Default: `[format('id-{0}', deployment().location)]`

### Parameter: `deploymentScriptName`

The name of the deployment script to register resource providers.

- Required: No
- Type: string
- Default: `[format('ds-{0}', deployment().location)]`

### Parameter: `deploymentScriptNetworkSecurityGroupName`

The name of the network security group for the deployment script private subnet.

- Required: No
- Type: string
- Default: `[format('nsg-ds-{0}', deployment().location)]`

### Parameter: `deploymentScriptResourceGroupName`

The name of the resource group to create the deployment script for resource providers registration.

- Required: No
- Type: string
- Default: `[format('rsg-{0}-ds', deployment().location)]`

### Parameter: `deploymentScriptStorageAccountName`

The name of the storage account for the deployment script.

- Required: No
- Type: string
- Default: `[format('stgds{0}', substring(uniqueString(deployment().name, parameters('existingSubscriptionId'), parameters('subscriptionAliasName'), parameters('subscriptionDisplayName'), parameters('virtualNetworkLocation')), 0, 10))]`

### Parameter: `deploymentScriptVirtualNetworkName`

The name of the private virtual network for the deployment script. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.

- Required: No
- Type: string
- Default: `[format('vnet-ds-{0}', deployment().location)]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `existingSubscriptionId`

An existing subscription ID. Use this when you do not want the module to create a new subscription. But do want to manage the management group membership. A subscription ID should be provided in the example format `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`.

- Required: No
- Type: string
- Default: `''`

### Parameter: `hubNetworkResourceId`

The resource ID of the Virtual Network or Virtual WAN Hub in the hub to which the created Virtual Network, by this module, will be peered/connected to via Virtual Network Peering or a Virtual WAN Virtual Hub Connection.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `managementGroupAssociationDelayCount`

The number of blank ARM deployments to create sequentially to introduce a delay to the Subscription being moved to the target Management Group being, if set, to allow for background platform RBAC inheritance to occur.

- Required: No
- Type: int
- Default: `15`

### Parameter: `networkSecurityGroupResourceGroupName`

The name of the resource group to create the network security groups in.

- Required: No
- Type: string
- Default: `''`

### Parameter: `networkSecurityGroups`

The list of network security groups to create

- Required: No
- Type: array
- Default: `[]`

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-networksecuritygroupslocation) | string | The location of the network security group. |
| [`name`](#parameter-networksecuritygroupsname) | string | The name of the network security group. |
| [`securityRules`](#parameter-networksecuritygroupssecurityrules) | array | The security rules of the network security group. |
| [`tags`](#parameter-networksecuritygroupstags) | object | The tags of the network security group. |

### Parameter: `networkSecurityGroups.location`

The location of the network security group.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.name`

The name of the network security group.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.securityRules`

The security rules of the network security group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networksecuritygroupssecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-networksecuritygroupssecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `networkSecurityGroups.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `networkSecurityGroups.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-networksecuritygroupssecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-networksecuritygroupssecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-networksecuritygroupssecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-networksecuritygroupssecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networksecuritygroupssecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-networksecuritygroupssecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-networksecuritygroupssecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupssecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-networksecuritygroupssecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-networksecuritygroupssecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-networksecuritygroupssecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-networksecuritygroupssecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-networksecuritygroupssecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-networksecuritygroupssecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-networksecuritygroupssecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `networkSecurityGroups.securityRules.properties.access`

Whether network traffic is allowed or denied.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkSecurityGroups.securityRules.properties.direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `networkSecurityGroups.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `networkSecurityGroups.securityRules.properties.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `networkSecurityGroups.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroups.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `networkSecurityGroups.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroups.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroups.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `networkSecurityGroups.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `networkSecurityGroups.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `networkSecurityGroups.tags`

The tags of the network security group.

- Required: No
- Type: object

### Parameter: `peerAllVirtualNetworks`

Flag to do mesh peering of all virtual networks deployed into the new subscription.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `pimRoleAssignments`

Supply an array of objects containing the details of the PIM role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p>

- Required: No
- Type: array
- Default: `[]`
- Example:
  ```Bicep
  [
    {
      // Contributor role assignment at subscription scope
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/Contributor'
      relativeScope: ''
    }
    {
      // Owner role assignment at resource group scope
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
      relativeScope: '/resourceGroups/{resourceGroupName}'
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-pimroleassignmentsdefinition) | string | The role definition ID or name. |
| [`principalId`](#parameter-pimroleassignmentsprincipalid) | string | The principal ID of the user, group, or service principal. |
| [`relativeScope`](#parameter-pimroleassignmentsrelativescope) | string | The relative scope of the role assignment. |
| [`roleAssignmentType`](#parameter-pimroleassignmentsroleassignmenttype) | string | The type of the role assignment. |
| [`scheduleInfo`](#parameter-pimroleassignmentsscheduleinfo) | object | The schedule information for the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`justification`](#parameter-pimroleassignmentsjustification) | string | The justification for the role assignment. |
| [`requestType`](#parameter-pimroleassignmentsrequesttype) | string | The type of the PIM request. |
| [`roleAssignmentCondition`](#parameter-pimroleassignmentsroleassignmentcondition) | object | The condition for the role assignment. |
| [`ticketInfo`](#parameter-pimroleassignmentsticketinfo) | object | The ticket information for the role assignment. |

### Parameter: `pimRoleAssignments.definition`

The role definition ID or name.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.principalId`

The principal ID of the user, group, or service principal.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.relativeScope`

The relative scope of the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.roleAssignmentType`

The type of the role assignment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Active'
    'Eligible'
  ]
  ```

### Parameter: `pimRoleAssignments.scheduleInfo`

The schedule information for the role assignment.

- Required: Yes
- Type: object
- Discriminator: `durationType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`NoExpiration`](#variant-pimroleassignmentsscheduleinfodurationtype-noexpiration) |  |
| [`AfterDuration`](#variant-pimroleassignmentsscheduleinfodurationtype-afterduration) |  |
| [`AfterDateTime`](#variant-pimroleassignmentsscheduleinfodurationtype-afterdatetime) |  |

### Variant: `pimRoleAssignments.scheduleInfo.durationType-NoExpiration`


To use this variant, set the property `durationType` to `NoExpiration`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`durationType`](#parameter-pimroleassignmentsscheduleinfodurationtype-noexpirationdurationtype) | string | The type of the duration. |

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-NoExpiration.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NoExpiration'
  ]
  ```

### Variant: `pimRoleAssignments.scheduleInfo.durationType-AfterDuration`


To use this variant, set the property `durationType` to `AfterDuration`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`duration`](#parameter-pimroleassignmentsscheduleinfodurationtype-afterdurationduration) | string | The duration for the role assignment. |
| [`durationType`](#parameter-pimroleassignmentsscheduleinfodurationtype-afterdurationdurationtype) | string | The type of the duration. |
| [`startTime`](#parameter-pimroleassignmentsscheduleinfodurationtype-afterdurationstarttime) | string | The start time for the role assignment. |

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-AfterDuration.duration`

The duration for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-AfterDuration.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDuration'
  ]
  ```

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-AfterDuration.startTime`

The start time for the role assignment.

- Required: Yes
- Type: string

### Variant: `pimRoleAssignments.scheduleInfo.durationType-AfterDateTime`


To use this variant, set the property `durationType` to `AfterDateTime`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`durationType`](#parameter-pimroleassignmentsscheduleinfodurationtype-afterdatetimedurationtype) | string | The type of the duration. |
| [`endDateTime`](#parameter-pimroleassignmentsscheduleinfodurationtype-afterdatetimeenddatetime) | string | The end date and time for the role assignment. |
| [`startTime`](#parameter-pimroleassignmentsscheduleinfodurationtype-afterdatetimestarttime) | string | The start date and time for the role assignment. |

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-AfterDateTime.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDateTime'
  ]
  ```

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-AfterDateTime.endDateTime`

The end date and time for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.scheduleInfo.durationType-AfterDateTime.startTime`

The start date and time for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignments.justification`

The justification for the role assignment.

- Required: No
- Type: string

### Parameter: `pimRoleAssignments.requestType`

The type of the PIM request.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AdminAssign'
    'AdminExtend'
    'AdminRemove'
    'AdminRenew'
    'AdminUpdate'
    'SelfActivate'
    'SelfDeactivate'
    'SelfExtend'
    'SelfRenew'
  ]
  ```

### Parameter: `pimRoleAssignments.roleAssignmentCondition`

The condition for the role assignment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conditionVersion`](#parameter-pimroleassignmentsroleassignmentconditionconditionversion) | string | The version of the condition template. |
| [`delegationCode`](#parameter-pimroleassignmentsroleassignmentconditiondelegationcode) | string | The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '. |
| [`roleConditionType`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontype) | object | The type of template for the role assignment condition. |

### Parameter: `pimRoleAssignments.roleAssignmentCondition.conditionVersion`

The version of the condition template.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `pimRoleAssignments.roleAssignmentCondition.delegationCode`

The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '.

- Required: No
- Type: string

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType`

The type of template for the role assignment condition.

- Required: No
- Type: object
- Discriminator: `templateName`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`excludeRoles`](#variant-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderoles) |  |
| [`constrainRoles`](#variant-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainroles) |  |
| [`constrainRolesAndPrincipalTypes`](#variant-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypes) |  |
| [`constrainRolesAndPrincipals`](#variant-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipals) |  |

### Variant: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles`


To use this variant, set the property `templateName` to `excludeRoles`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`excludedRoles`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderolesexcludedroles) | array | The list of roles that are not allowed to be assigned by the delegate. |
| [`templateName`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderolestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles.excludedRoles`

The list of roles that are not allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'excludeRoles'
  ]
  ```

### Variant: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles`


To use this variant, set the property `templateName` to `constrainRoles`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rolesToAssign`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRoles'
  ]
  ```

### Variant: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes`


To use this variant, set the property `templateName` to `constrainRolesAndPrincipalTypes`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principleTypesToAssign`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypesprincipletypestoassign) | array | The list of principle types that are allowed to be assigned roles by the delegate. |
| [`rolesToAssign`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypesrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.principleTypesToAssign`

The list of principle types that are allowed to be assigned roles by the delegate.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRolesAndPrincipalTypes'
  ]
  ```

### Variant: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals`


To use this variant, set the property `templateName` to `constrainRolesAndPrincipals`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalsToAssignTo`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalsprincipalstoassignto) | array | The list of principals that are allowed to be assigned roles by the delegate. |
| [`rolesToAssign`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalsrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-pimroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalstemplatename) | string | Name of the RBAC condition template. |

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.principalsToAssignTo`

The list of principals that are allowed to be assigned roles by the delegate.

- Required: Yes
- Type: array

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `pimRoleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRolesAndPrincipals'
  ]
  ```

### Parameter: `pimRoleAssignments.ticketInfo`

The ticket information for the role assignment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ticketNumber`](#parameter-pimroleassignmentsticketinfoticketnumber) | string | The ticket number for the role eligibility assignment. |
| [`ticketSystem`](#parameter-pimroleassignmentsticketinfoticketsystem) | string | The ticket system name for the role eligibility assignment. |

### Parameter: `pimRoleAssignments.ticketInfo.ticketNumber`

The ticket number for the role eligibility assignment.

- Required: No
- Type: string

### Parameter: `pimRoleAssignments.ticketInfo.ticketSystem`

The ticket system name for the role eligibility assignment.

- Required: No
- Type: string

### Parameter: `resourceProviders`

An object of resource providers and resource providers features to register. If left blank/empty, no resource providers will be registered.<p>

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      'Microsoft.ApiManagement': []
      'Microsoft.AppPlatform': []
      'Microsoft.Authorization': []
      'Microsoft.Automation': []
      'Microsoft.AVS': []
      'Microsoft.Blueprint': []
      'Microsoft.BotService': []
      'Microsoft.Cache': []
      'Microsoft.Cdn': []
      'Microsoft.CognitiveServices': []
      'Microsoft.Compute': []
      'Microsoft.ContainerInstance': []
      'Microsoft.ContainerRegistry': []
      'Microsoft.ContainerService': []
      'Microsoft.CostManagement': []
      'Microsoft.CustomProviders': []
      'Microsoft.Databricks': []
      'Microsoft.DataLakeAnalytics': []
      'Microsoft.DataLakeStore': []
      'Microsoft.DataMigration': []
      'Microsoft.DataProtection': []
      'Microsoft.DBforMariaDB': []
      'Microsoft.DBforMySQL': []
      'Microsoft.DBforPostgreSQL': []
      'Microsoft.DesktopVirtualization': []
      'Microsoft.Devices': []
      'Microsoft.DevTestLab': []
      'Microsoft.DocumentDB': []
      'Microsoft.EventGrid': []
      'Microsoft.EventHub': []
      'Microsoft.GuestConfiguration': []
      'Microsoft.HDInsight': []
      'Microsoft.HealthcareApis': []
      'microsoft.insights': []
      'Microsoft.KeyVault': []
      'Microsoft.Kusto': []
      'Microsoft.Logic': []
      'Microsoft.MachineLearningServices': []
      'Microsoft.Maintenance': []
      'Microsoft.ManagedIdentity': []
      'Microsoft.ManagedServices': []
      'Microsoft.Management': []
      'Microsoft.Maps': []
      'Microsoft.MarketplaceOrdering': []
      'Microsoft.Media': []
      'Microsoft.MixedReality': []
      'Microsoft.Network': []
      'Microsoft.NotificationHubs': []
      'Microsoft.OperationalInsights': []
      'Microsoft.OperationsManagement': []
      'Microsoft.PolicyInsights': []
      'Microsoft.PowerBIDedicated': []
      'Microsoft.RecoveryServices': []
      'Microsoft.Relay': []
      'Microsoft.Resources': []
      'Microsoft.Search': []
      'Microsoft.Security': []
      'Microsoft.SecurityInsights': []
      'Microsoft.ServiceBus': []
      'Microsoft.ServiceFabric': []
      'Microsoft.Sql': []
      'Microsoft.Storage': []
      'Microsoft.StreamAnalytics': []
      'Microsoft.Web': []
  }
  ```

### Parameter: `roleAssignmentEnabled`

Whether to create role assignments or not. If true, supply the array of role assignment objects in the parameter called `roleAssignments`.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Supply an array of objects containing the details of the role assignments to create.<p><p>Each object must contain the following `keys`:<li>`principalId` = The Object ID of the User, Group, SPN, Managed Identity to assign the RBAC role too.<li>`definition` = The Name of one of the pre-defined built-In RBAC Roles or a Resource ID of a Built-in or custom RBAC Role Definition as follows:<p>  - You can only provide the RBAC role name of the pre-defined roles (Contributor, Owner, Reader, Role Based Access Control Administrator, and User Access Administrator). We only provide those roles as they are the most common ones to assign to a new subscription, also to reduce the template size and complexity in case we define each and every Built-in RBAC role.<p>  - You can provide the Resource ID of a Built-in or custom RBAC Role Definition<p>    - e.g. `/providers/Microsoft.Authorization/roleDefinitions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`<li>`relativeScope` = 2 options can be provided for input value:<p>    1. `''` *(empty string)* = Make RBAC Role Assignment to Subscription scope<p>    2. `'/resourceGroups/<RESOURCE GROUP NAME>'` = Make RBAC Role Assignment to specified Resource Group.<p>

- Required: No
- Type: array
- Default: `[]`
- Example:
  ```Bicep
  [
    {
      // Contributor role assignment at subscription scope
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/Contributor'
      relativeScope: ''
    }
    {
      // Owner role assignment at resource group scope
      principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
      definition: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
      relativeScope: '/resourceGroups/{resourceGroupName}'
    }
  ]
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-roleassignmentsdefinition) | string | The role definition ID or name. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the user, group, or service principal. |
| [`relativeScope`](#parameter-roleassignmentsrelativescope) | string | The relative scope of the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-roleassignmentsdescription) | string | The role assignment description. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the user, group, or service principal. |
| [`roleAssignmentCondition`](#parameter-roleassignmentsroleassignmentcondition) | object | The condition for the role assignment. |

### Parameter: `roleAssignments.definition`

The role definition ID or name.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalId`

The principal ID of the user, group, or service principal.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.relativeScope`

The relative scope of the role assignment.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.description`

The role assignment description.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the user, group, or service principal.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `roleAssignments.roleAssignmentCondition`

The condition for the role assignment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conditionVersion`](#parameter-roleassignmentsroleassignmentconditionconditionversion) | string | The version of the condition template. |
| [`delegationCode`](#parameter-roleassignmentsroleassignmentconditiondelegationcode) | string | The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '. |
| [`roleConditionType`](#parameter-roleassignmentsroleassignmentconditionroleconditiontype) | object | The type of template for the role assignment condition. |

### Parameter: `roleAssignments.roleAssignmentCondition.conditionVersion`

The version of the condition template.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.roleAssignmentCondition.delegationCode`

The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '.

- Required: No
- Type: string

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType`

The type of template for the role assignment condition.

- Required: No
- Type: object
- Discriminator: `templateName`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`excludeRoles`](#variant-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderoles) |  |
| [`constrainRoles`](#variant-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainroles) |  |
| [`constrainRolesAndPrincipalTypes`](#variant-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypes) |  |
| [`constrainRolesAndPrincipals`](#variant-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipals) |  |

### Variant: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles`


To use this variant, set the property `templateName` to `excludeRoles`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`excludedRoles`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderolesexcludedroles) | array | The list of roles that are not allowed to be assigned by the delegate. |
| [`templateName`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderolestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles.excludedRoles`

The list of roles that are not allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'excludeRoles'
  ]
  ```

### Variant: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles`


To use this variant, set the property `templateName` to `constrainRoles`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rolesToAssign`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRoles'
  ]
  ```

### Variant: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes`


To use this variant, set the property `templateName` to `constrainRolesAndPrincipalTypes`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principleTypesToAssign`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypesprincipletypestoassign) | array | The list of principle types that are allowed to be assigned roles by the delegate. |
| [`rolesToAssign`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypesrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.principleTypesToAssign`

The list of principle types that are allowed to be assigned roles by the delegate.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRolesAndPrincipalTypes'
  ]
  ```

### Variant: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals`


To use this variant, set the property `templateName` to `constrainRolesAndPrincipals`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalsToAssignTo`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalsprincipalstoassignto) | array | The list of principals that are allowed to be assigned roles by the delegate. |
| [`rolesToAssign`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalsrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-roleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalstemplatename) | string | Name of the RBAC condition template. |

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.principalsToAssignTo`

The list of principals that are allowed to be assigned roles by the delegate.

- Required: Yes
- Type: array

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRolesAndPrincipals'
  ]
  ```

### Parameter: `routeTables`

The list of route tables to create.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-routetableslocation) | string | The location of the route table resource. |
| [`name`](#parameter-routetablesname) | string | The name of the route table resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`routes`](#parameter-routetablesroutes) | array | The routes for the route table resource. |
| [`tags`](#parameter-routetablestags) | object | The tags for the route table resource. |

### Parameter: `routeTables.location`

The location of the route table resource.

- Required: Yes
- Type: string

### Parameter: `routeTables.name`

The name of the route table resource.

- Required: Yes
- Type: string

### Parameter: `routeTables.routes`

The routes for the route table resource.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-routetablesroutesname) | string | Name of the route. |
| [`properties`](#parameter-routetablesroutesproperties) | object | Properties of the route. |

### Parameter: `routeTables.routes.name`

Name of the route.

- Required: Yes
- Type: string

### Parameter: `routeTables.routes.properties`

Properties of the route.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-routetablesroutespropertiesaddressprefix) | string | The destination CIDR to which the route applies. |
| [`nextHopType`](#parameter-routetablesroutespropertiesnexthoptype) | string | The type of Azure hop the packet should be sent to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`nextHopIpAddress`](#parameter-routetablesroutespropertiesnexthopipaddress) | string | The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance. |

### Parameter: `routeTables.routes.properties.addressPrefix`

The destination CIDR to which the route applies.

- Required: Yes
- Type: string

### Parameter: `routeTables.routes.properties.nextHopType`

The type of Azure hop the packet should be sent to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Internet'
    'None'
    'VirtualAppliance'
    'VirtualNetworkGateway'
    'VnetLocal'
  ]
  ```

### Parameter: `routeTables.routes.properties.nextHopIpAddress`

The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.

- Required: No
- Type: string

### Parameter: `routeTables.tags`

The tags for the route table resource.

- Required: No
- Type: object

### Parameter: `routeTablesResourceGroupName`

The name of the resource group to create the route tables in.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionAliasEnabled`

Whether to create a new Subscription using the Subscription Alias resource. If `false`, supply an existing Subscription''s ID in the parameter named `existingSubscriptionId` instead to deploy resources to an existing Subscription.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `subscriptionAliasName`

The name of the Subscription Alias, that will be created by this module.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionBillingScope`

The Billing Scope for the new Subscription alias, that will be created by this module.<p><p>A valid Billing Scope looks like `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/enrollmentAccounts/{enrollmentAccountName}` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionDisplayName`

The name of the subscription alias. The string must be comprised of a-z, A-Z, 0-9, - and _. The maximum length is 63 characters.<p><p>The string must be comprised of `a-z`, `A-Z`, `0-9`, `-`, `_` and ` ` (space). The maximum length is 63 characters.<p><p>> The value for this parameter and the parameter named `subscriptionAliasName` are usually set to the same value for simplicity. But they can be different if required for a reason.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionManagementGroupAssociationEnabled`

Whether to move the Subscription to the specified Management Group supplied in the parameter `subscriptionManagementGroupId`.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `subscriptionManagementGroupId`

The destination Management Group ID for the new Subscription that will be created by this module (or the existing one provided in the parameter `existingSubscriptionId`).<p><p>**IMPORTANT:** Do not supply the display name of the Management Group. The Management Group ID forms part of the Azure Resource ID. e.g., `/providers/Microsoft.Management/managementGroups/{managementGroupId}`.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionOwnerId`

The Azure Active Directory principals object ID (GUID) to whom should be the Subscription Owner.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionTags`

An object of Tag key & value pairs to be appended to a Subscription.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `subscriptionTenantId`

The Azure Active Directory Tenant ID (GUID) to which the Subscription should be attached to.<p><p>> **Leave blank unless following this scenario only [Programmatically create MCA subscriptions across Azure Active Directory tenants](https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-microsoft-customer-agreement-across-tenants)**.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionWorkload`

The workload type can be either `Production` or `DevTest` and is case sensitive.<p><p>> **Not required when providing an existing Subscription ID via the parameter `existingSubscriptionId`**.<p>

- Required: No
- Type: string
- Default: `'Production'`
- Allowed:
  ```Bicep
  [
    'DevTest'
    'Production'
  ]
  ```

### Parameter: `userAssignedIdentitiesResourceGroupLockEnabled`

Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `userAssignedIdentityResourceGroupName`

The name of the resource group to create the user-assigned managed identities in.

- Required: No
- Type: string
- Default: `[format('rsg-{0}-identities', deployment().location)]`

### Parameter: `userAssignedManagedIdentities`

The list of user-assigned managed identities.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-userassignedmanagedidentitiesname) | string | The name of the user assigned managed identity. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`federatedIdentityCredentials`](#parameter-userassignedmanagedidentitiesfederatedidentitycredentials) | array | The federated identity credentials for the user assigned managed identity. |
| [`location`](#parameter-userassignedmanagedidentitieslocation) | string | The location of the user assigned managed identity. |
| [`lock`](#parameter-userassignedmanagedidentitieslock) | object | The locks for the user assigned managed identity. |
| [`roleAssignments`](#parameter-userassignedmanagedidentitiesroleassignments) | array | The role assignments for the user assigned managed identity. |
| [`tags`](#parameter-userassignedmanagedidentitiestags) | object | The tags for the user assigned managed identity. |

### Parameter: `userAssignedManagedIdentities.name`

The name of the user assigned managed identity.

- Required: Yes
- Type: string

### Parameter: `userAssignedManagedIdentities.federatedIdentityCredentials`

The federated identity credentials for the user assigned managed identity.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`audiences`](#parameter-userassignedmanagedidentitiesfederatedidentitycredentialsaudiences) | array | The list of audiences that can appear in the issued token. |
| [`issuer`](#parameter-userassignedmanagedidentitiesfederatedidentitycredentialsissuer) | string | The URL of the issuer to be trusted. |
| [`name`](#parameter-userassignedmanagedidentitiesfederatedidentitycredentialsname) | string | The name of the federated identity credential. |
| [`subject`](#parameter-userassignedmanagedidentitiesfederatedidentitycredentialssubject) | string | The identifier of the external identity. |

### Parameter: `userAssignedManagedIdentities.federatedIdentityCredentials.audiences`

The list of audiences that can appear in the issued token.

- Required: Yes
- Type: array

### Parameter: `userAssignedManagedIdentities.federatedIdentityCredentials.issuer`

The URL of the issuer to be trusted.

- Required: Yes
- Type: string

### Parameter: `userAssignedManagedIdentities.federatedIdentityCredentials.name`

The name of the federated identity credential.

- Required: Yes
- Type: string

### Parameter: `userAssignedManagedIdentities.federatedIdentityCredentials.subject`

The identifier of the external identity.

- Required: Yes
- Type: string

### Parameter: `userAssignedManagedIdentities.location`

The location of the user assigned managed identity.

- Required: No
- Type: string

### Parameter: `userAssignedManagedIdentities.lock`

The locks for the user assigned managed identity.

- Required: No
- Type: object

### Parameter: `userAssignedManagedIdentities.roleAssignments`

The role assignments for the user assigned managed identity.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`definition`](#parameter-userassignedmanagedidentitiesroleassignmentsdefinition) | string | The role definition ID or name. |
| [`relativeScope`](#parameter-userassignedmanagedidentitiesroleassignmentsrelativescope) | string | The relative scope of the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-userassignedmanagedidentitiesroleassignmentsdescription) | string | The role assignment description. |
| [`roleAssignmentCondition`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentcondition) | object | The condition for the role assignment. |

### Parameter: `userAssignedManagedIdentities.roleAssignments.definition`

The role definition ID or name.

- Required: Yes
- Type: string

### Parameter: `userAssignedManagedIdentities.roleAssignments.relativeScope`

The relative scope of the role assignment.

- Required: Yes
- Type: string

### Parameter: `userAssignedManagedIdentities.roleAssignments.description`

The role assignment description.

- Required: No
- Type: string

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition`

The condition for the role assignment.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conditionVersion`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionconditionversion) | string | The version of the condition template. |
| [`delegationCode`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditiondelegationcode) | string | The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '. |
| [`roleConditionType`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontype) | object | The type of template for the role assignment condition. |

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.conditionVersion`

The version of the condition template.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.delegationCode`

The code for a custom condition if no template is used. The user should supply their own custom code if the available templates are not matching their requirements. If a value is provided, this will overwrite any added template. All single quotes needs to be skipped using '.

- Required: No
- Type: string

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType`

The type of template for the role assignment condition.

- Required: No
- Type: object
- Discriminator: `templateName`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`excludeRoles`](#variant-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderoles) |  |
| [`constrainRoles`](#variant-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainroles) |  |
| [`constrainRolesAndPrincipalTypes`](#variant-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypes) |  |
| [`constrainRolesAndPrincipals`](#variant-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipals) |  |

### Variant: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles`


To use this variant, set the property `templateName` to `excludeRoles`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`excludedRoles`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderolesexcludedroles) | array | The list of roles that are not allowed to be assigned by the delegate. |
| [`templateName`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-excluderolestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles.excludedRoles`

The list of roles that are not allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-excludeRoles.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'excludeRoles'
  ]
  ```

### Variant: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles`


To use this variant, set the property `templateName` to `constrainRoles`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rolesToAssign`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRoles.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRoles'
  ]
  ```

### Variant: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes`


To use this variant, set the property `templateName` to `constrainRolesAndPrincipalTypes`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principleTypesToAssign`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypesprincipletypestoassign) | array | The list of principle types that are allowed to be assigned roles by the delegate. |
| [`rolesToAssign`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypesrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipaltypestemplatename) | string | Name of the RBAC condition template. |

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.principleTypesToAssign`

The list of principle types that are allowed to be assigned roles by the delegate.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipalTypes.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRolesAndPrincipalTypes'
  ]
  ```

### Variant: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals`


To use this variant, set the property `templateName` to `constrainRolesAndPrincipals`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalsToAssignTo`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalsprincipalstoassignto) | array | The list of principals that are allowed to be assigned roles by the delegate. |
| [`rolesToAssign`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalsrolestoassign) | array | The list of roles that are allowed to be assigned by the delegate. |
| [`templateName`](#parameter-userassignedmanagedidentitiesroleassignmentsroleassignmentconditionroleconditiontypetemplatename-constrainrolesandprincipalstemplatename) | string | Name of the RBAC condition template. |

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.principalsToAssignTo`

The list of principals that are allowed to be assigned roles by the delegate.

- Required: Yes
- Type: array

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.rolesToAssign`

The list of roles that are allowed to be assigned by the delegate.

- Required: Yes
- Type: array

### Parameter: `userAssignedManagedIdentities.roleAssignments.roleAssignmentCondition.roleConditionType.templateName-constrainRolesAndPrincipals.templateName`

Name of the RBAC condition template.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'constrainRolesAndPrincipals'
  ]
  ```

### Parameter: `userAssignedManagedIdentities.tags`

The tags for the user assigned managed identity.

- Required: No
- Type: object

### Parameter: `vHubRoutingIntentEnabled`

Indicates whether routing intent is enabled on the Virtual Hub within the Virtual WAN.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkAddressSpace`

The address space of the Virtual Network that will be created by this module, supplied as multiple CIDR blocks in an array, e.g. `["10.0.0.0/16","172.16.0.0/12"]`.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkBastionConfiguration`

The configuration object for the Bastion host. Do not provide this object or keep it empty if you do not want to deploy a Bastion host.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bastionSku`](#parameter-virtualnetworkbastionconfigurationbastionsku) | string | The SKU of the bastion host. |
| [`disableCopyPaste`](#parameter-virtualnetworkbastionconfigurationdisablecopypaste) | bool | The option to allow copy and paste. |
| [`enableFileCopy`](#parameter-virtualnetworkbastionconfigurationenablefilecopy) | bool | The option to allow file copy. |
| [`enableIpConnect`](#parameter-virtualnetworkbastionconfigurationenableipconnect) | bool | The option to allow IP connect. |
| [`enablePrivateOnlyBastion`](#parameter-virtualnetworkbastionconfigurationenableprivateonlybastion) | bool | Option to deploy a private Bastion host with no public IP address. |
| [`enableShareableLink`](#parameter-virtualnetworkbastionconfigurationenableshareablelink) | bool | The option to allow shareable link. |
| [`name`](#parameter-virtualnetworkbastionconfigurationname) | string | The name of the bastion host. |
| [`scaleUnits`](#parameter-virtualnetworkbastionconfigurationscaleunits) | int | The number of scale units. The Basic SKU only supports 2 scale units. |

### Parameter: `virtualNetworkBastionConfiguration.bastionSku`

The SKU of the bastion host.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `virtualNetworkBastionConfiguration.disableCopyPaste`

The option to allow copy and paste.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enableFileCopy`

The option to allow file copy.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enableIpConnect`

The option to allow IP connect.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enablePrivateOnlyBastion`

Option to deploy a private Bastion host with no public IP address.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.enableShareableLink`

The option to allow shareable link.

- Required: No
- Type: bool

### Parameter: `virtualNetworkBastionConfiguration.name`

The name of the bastion host.

- Required: No
- Type: string

### Parameter: `virtualNetworkBastionConfiguration.scaleUnits`

The number of scale units. The Basic SKU only supports 2 scale units.

- Required: No
- Type: int

### Parameter: `virtualNetworkDdosPlanResourceId`

The resource ID of an existing DDoS Network Protection Plan that you wish to link to this Virtual Network.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkDeployBastion`

Whether to deploy a Bastion host to the created virtual network.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkDeploymentScriptAddressPrefix`

The address prefix of the private virtual network for the deployment script.

- Required: No
- Type: string
- Default: `'192.168.0.0/24'`

### Parameter: `virtualNetworkDeployNatGateway`

Whether to deploy a NAT gateway to the created virtual network.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkDnsServers`

The custom DNS servers to use on the Virtual Network, e.g. `["10.4.1.4", "10.2.1.5"]`. If left empty (default) then Azure DNS will be used for the Virtual Network.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkEnabled`

Whether to create a Virtual Network or not.<p><p>If set to `true` ensure you also provide values for the following parameters at a minimum:<p><li>`virtualNetworkResourceGroupName`<li>`virtualNetworkResourceGroupLockEnabled`<li>`virtualNetworkLocation`<li>`virtualNetworkName`<li>`virtualNetworkAddressSpace`<p><p>> Other parameters may need to be set based on other parameters that you enable that are listed above. Check each parameters documentation for further information.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkLocation`

The location of the virtual network. Use region shortnames e.g. `uksouth`, `eastus`, etc. Defaults to the region where the ARM/Bicep deployment is targeted to unless overridden.<p>

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `virtualNetworkName`

The name of the virtual network. The string must consist of a-z, A-Z, 0-9, -, _, and . (period) and be between 2 and 64 characters in length.<p>

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration`

The NAT Gateway configuration object. Do not provide this object or keep it empty if you do not want to deploy a NAT Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworknatgatewayconfigurationname) | string | The name of the NAT gateway. |
| [`publicIPAddressPrefixesProperties`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixesproperties) | array | The Public IP address(es) prefixes properties to be attached to the NAT gateway. |
| [`publicIPAddressProperties`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressproperties) | array | The Public IP address(es) properties to be attached to the NAT gateway. |
| [`zones`](#parameter-virtualnetworknatgatewayconfigurationzones) | int | The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones). |

### Parameter: `virtualNetworkNatGatewayConfiguration.name`

The name of the NAT gateway.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties`

The Public IP address(es) prefixes properties to be attached to the NAT gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customIPPrefix`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixespropertiescustomipprefix) | string | The custom IP prefix of the public IP address prefix. |
| [`name`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixespropertiesname) | string | The name of the Public IP address prefix. |
| [`prefixLength`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddressprefixespropertiesprefixlength) | int | The prefix length of the public IP address prefix.. |

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties.customIPPrefix`

The custom IP prefix of the public IP address prefix.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties.name`

The name of the Public IP address prefix.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressPrefixesProperties.prefixLength`

The prefix length of the public IP address prefix..

- Required: No
- Type: int

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressProperties`

The Public IP address(es) properties to be attached to the NAT gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddresspropertiesname) | string | The name of the Public IP address. |
| [`zones`](#parameter-virtualnetworknatgatewayconfigurationpublicipaddresspropertieszones) | array | The SKU of the Public IP address. |

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressProperties.name`

The name of the Public IP address.

- Required: No
- Type: string

### Parameter: `virtualNetworkNatGatewayConfiguration.publicIPAddressProperties.zones`

The SKU of the Public IP address.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `virtualNetworkNatGatewayConfiguration.zones`

The availability zones of the NAT gateway. Check the availability zone guidance for NAT gateway to understand how to map NAT gateway zone to the associated Public IP address zones (https://learn.microsoft.com/azure/nat-gateway/nat-availability-zones).

- Required: No
- Type: int

### Parameter: `virtualNetworkPeeringEnabled`

Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.<p>

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkResourceGroupLockEnabled`

Enables the deployment of a `CanNotDelete` resource locks to the Virtual Networks Resource Group that is created by this module.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkResourceGroupName`

The name of the Resource Group to create the Virtual Network in that is created by this module.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkResourceGroupTags`

An object of Tag key & value pairs to be appended to the Resource Group that the Virtual Network is created in.<p><p>> **NOTE:** Tags will only be overwritten if existing tag exists with same key as provided in this parameter; values provided here win.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkSubnets`

The subnets of the Virtual Network that will be created by this module.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworksubnetsname) | string | The Name of the subnet resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-virtualnetworksubnetsaddressprefix) | string | The address prefix for the subnet. Required if `addressPrefixes` is empty. |
| [`addressPrefixes`](#parameter-virtualnetworksubnetsaddressprefixes) | array | List of address prefixes for the subnet. Required if `addressPrefix` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationGatewayIPConfigurations`](#parameter-virtualnetworksubnetsapplicationgatewayipconfigurations) | array | Application gateway IP configurations of virtual network resource. |
| [`associateWithNatGateway`](#parameter-virtualnetworksubnetsassociatewithnatgateway) | bool | Option to associate the subnet with the NAT gatway deployed by this module. |
| [`defaultOutboundAccess`](#parameter-virtualnetworksubnetsdefaultoutboundaccess) | bool | Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet. |
| [`delegation`](#parameter-virtualnetworksubnetsdelegation) | string | The delegation to enable on the subnet. |
| [`natGatewayResourceId`](#parameter-virtualnetworksubnetsnatgatewayresourceid) | string | The resource ID of the NAT Gateway to use for the subnet. |
| [`networkSecurityGroup`](#parameter-virtualnetworksubnetsnetworksecuritygroup) | object | The network security group to be associated with this subnet. |
| [`privateEndpointNetworkPolicies`](#parameter-virtualnetworksubnetsprivateendpointnetworkpolicies) | string | enable or disable apply network policies on private endpoint in the subnet. |
| [`privateLinkServiceNetworkPolicies`](#parameter-virtualnetworksubnetsprivatelinkservicenetworkpolicies) | string | enable or disable apply network policies on private link service in the subnet. |
| [`routeTableName`](#parameter-virtualnetworksubnetsroutetablename) | string | The name of the route table to be associated with this subnet. |
| [`serviceEndpointPolicies`](#parameter-virtualnetworksubnetsserviceendpointpolicies) | array | An array of service endpoint policies. |
| [`serviceEndpoints`](#parameter-virtualnetworksubnetsserviceendpoints) | array | The service endpoints to enable on the subnet. |
| [`sharingScope`](#parameter-virtualnetworksubnetssharingscope) | string | Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty. |

### Parameter: `virtualNetworkSubnets.name`

The Name of the subnet resource.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkSubnets.addressPrefix`

The address prefix for the subnet. Required if `addressPrefixes` is empty.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.addressPrefixes`

List of address prefixes for the subnet. Required if `addressPrefix` is empty.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.applicationGatewayIPConfigurations`

Application gateway IP configurations of virtual network resource.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.associateWithNatGateway`

Option to associate the subnet with the NAT gatway deployed by this module.

- Required: No
- Type: bool

### Parameter: `virtualNetworkSubnets.defaultOutboundAccess`

Set this property to false to disable default outbound connectivity for all VMs in the subnet. This property can only be set at the time of subnet creation and cannot be updated for an existing subnet.

- Required: No
- Type: bool

### Parameter: `virtualNetworkSubnets.delegation`

The delegation to enable on the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.natGatewayResourceId`

The resource ID of the NAT Gateway to use for the subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup`

The network security group to be associated with this subnet.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-virtualnetworksubnetsnetworksecuritygrouplocation) | string | The location of the network security group. |
| [`name`](#parameter-virtualnetworksubnetsnetworksecuritygroupname) | string | The name of the network security group. |
| [`securityRules`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrules) | array | The security rules of the network security group. |
| [`tags`](#parameter-virtualnetworksubnetsnetworksecuritygrouptags) | object | The tags of the network security group. |

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.location`

The location of the network security group.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.name`

The name of the network security group.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules`

The security rules of the network security group.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulesname) | string | The name of the security rule. |
| [`properties`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulesproperties) | object | The properties of the security rule. |

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.name`

The name of the security rule.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties`

The properties of the security rule.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`access`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesaccess) | string | Whether network traffic is allowed or denied. |
| [`direction`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdirection) | string | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. |
| [`priority`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiespriority) | int | Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule. |
| [`protocol`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesprotocol) | string | Network protocol this rule applies to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdescription) | string | The description of the security rule. |
| [`destinationAddressPrefix`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefix) | string | Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. |
| [`destinationAddressPrefixes`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdestinationaddressprefixes) | array | The destination address prefixes. CIDR or destination IP ranges. |
| [`destinationApplicationSecurityGroupResourceIds`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdestinationapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as destination. |
| [`destinationPortRange`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdestinationportrange) | string | The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`destinationPortRanges`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiesdestinationportranges) | array | The destination port ranges. |
| [`sourceAddressPrefix`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiessourceaddressprefix) | string | The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| [`sourceAddressPrefixes`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiessourceaddressprefixes) | array | The CIDR or source IP ranges. |
| [`sourceApplicationSecurityGroupResourceIds`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiessourceapplicationsecuritygroupresourceids) | array | The resource IDs of the application security groups specified as source. |
| [`sourcePortRange`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiessourceportrange) | string | The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports. |
| [`sourcePortRanges`](#parameter-virtualnetworksubnetsnetworksecuritygroupsecurityrulespropertiessourceportranges) | array | The source port ranges. |

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.access`

Whether network traffic is allowed or denied.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.direction`

The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.priority`

Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.

- Required: Yes
- Type: int
- MinValue: 100
- MaxValue: 4096

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.protocol`

Network protocol this rule applies to.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    '*'
    'Ah'
    'Esp'
    'Icmp'
    'Tcp'
    'Udp'
  ]
  ```

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.description`

The description of the security rule.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.destinationAddressPrefix`

Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.destinationAddressPrefixes`

The destination address prefixes. CIDR or destination IP ranges.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.destinationApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as destination.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.destinationPortRange`

The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.destinationPortRanges`

The destination port ranges.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.sourceAddressPrefix`

The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.sourceAddressPrefixes`

The CIDR or source IP ranges.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.sourceApplicationSecurityGroupResourceIds`

The resource IDs of the application security groups specified as source.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.sourcePortRange`

The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.securityRules.properties.sourcePortRanges`

The source port ranges.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.networkSecurityGroup.tags`

The tags of the network security group.

- Required: No
- Type: object

### Parameter: `virtualNetworkSubnets.privateEndpointNetworkPolicies`

enable or disable apply network policies on private endpoint in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
    'NetworkSecurityGroupEnabled'
    'RouteTableEnabled'
  ]
  ```

### Parameter: `virtualNetworkSubnets.privateLinkServiceNetworkPolicies`

enable or disable apply network policies on private link service in the subnet.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `virtualNetworkSubnets.routeTableName`

The name of the route table to be associated with this subnet.

- Required: No
- Type: string

### Parameter: `virtualNetworkSubnets.serviceEndpointPolicies`

An array of service endpoint policies.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.serviceEndpoints`

The service endpoints to enable on the subnet.

- Required: No
- Type: array

### Parameter: `virtualNetworkSubnets.sharingScope`

Set this property to Tenant to allow sharing subnet with other subscriptions in your AAD tenant. This property can only be set if defaultOutboundAccess is set to false, both properties can only be set if subnet is empty.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'DelegatedServices'
    'Tenant'
  ]
  ```

### Parameter: `virtualNetworkTags`

An object of tag key/value pairs to be set on the Virtual Network that is created.<p><p>> **NOTE:** Tags will be overwritten on resource if any exist already.<p>

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualNetworkUseRemoteGateways`

Enables the use of remote gateways in the specified hub virtual network.<p><p>> **IMPORTANT:** If no gateways exist in the hub virtual network, set this to `false`, otherwise peering will fail to create.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkVwanAssociatedRouteTableResourceId`

The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty the `defaultRouteTable` will be associated.<p>

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkVwanEnableInternetSecurity`

Enables the ability for the Virtual WAN Hub Connection to learn the default route 0.0.0.0/0 from the Hub.<p>

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkVwanPropagatedLabels`

An array of virtual hub route table labels to propagate routes to. If left blank/empty the default label will be propagated to only.<p>

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualNetworkVwanPropagatedRouteTablesResourceIds`

An array of of objects of virtual hub route table resource IDs to propagate routes to. If left blank/empty the `defaultRouteTable` will be propagated to only.<p><p>Each object must contain the following `key`:<li>`id` = The Resource ID of the Virtual WAN Virtual Hub Route Table IDs you wish to propagate too<p><p>> **IMPORTANT:** If you provide any Route Tables in this array of objects you must ensure you include also the `defaultRouteTable` Resource ID as an object in the array as it is not added by default when a value is provided for this parameter.<p>

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `failedResourceProviders` | string | The resource providers that failed to register. |
| `failedResourceProvidersFeatures` | string | The resource providers features that failed to register. |
| `subscriptionAcceptOwnershipState` | string | The Subscription Owner State. Only used when creating MCA Subscriptions across tenants. |
| `subscriptionAcceptOwnershipUrl` | string | The Subscription Ownership URL. Only used when creating MCA Subscriptions across tenants. |
| `subscriptionId` | string | The Subscription ID that has been created or provided. |
| `subscriptionResourceId` | string | The Subscription Resource ID that has been created or provided. |
| `virtualWanHubConnectionName` | string | The name of the Virtual WAN Hub Connection. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/pim-role-assignment:0.1.1` | Remote reference |
| `br/public:avm/ptn/authorization/role-assignment:0.2.2` | Remote reference |
| `br/public:avm/res/managed-identity/user-assigned-identity:0.4.1` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.8.0` | Remote reference |
| `br/public:avm/res/network/nat-gateway:1.4.0` | Remote reference |
| `br/public:avm/res/network/network-security-group:0.5.1` | Remote reference |
| `br/public:avm/res/network/private-dns-zone:0.8.0` | Remote reference |
| `br/public:avm/res/network/route-table:0.5.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.7.0` | Remote reference |
| `br/public:avm/res/resources/deployment-script:0.5.1` | Remote reference |
| `br/public:avm/res/resources/resource-group:0.4.1` | Remote reference |
| `br/public:avm/res/storage/storage-account:0.26.2` | Remote reference |

## Notes

- The `Microsoft.Subscription/aliases/write` action is required at the `/` (tenant) scope as this is where the API operates, as per [Microsoft.Subscription aliases template reference documentation](https://learn.microsoft.com/azure/templates/microsoft.subscription/aliases?pivots=deployment-language-bicep#bicep-resource-definition)
  - You may need to elevate to User Access Administrator role to be able to assign the relevant role to the identity you wish to be able to create the subscription at the `/` (tenant) scope, as per [Elevate access to manage all Azure subscriptions and management groups](https://learn.microsoft.com/azure/role-based-access-control/elevate-access-global-admin)

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
