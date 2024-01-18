# Network Application Gateways `[Microsoft.Network/applicationGateways]`

This module deploys a Network Application Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/applicationGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/applicationGateways) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.application-gateway:1.0.0`.

- [Using large parameter set](#example-1-using-large-parameter-set)
- [WAF-aligned](#example-2-waf-aligned)

### Example 1: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module applicationGateway 'br:bicep/modules/network.application-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagmax'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'appServiceBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: 'aghapp.azurewebsites.net'
            }
          ]
        }
      }
      {
        name: 'privateVmBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.0.0.4'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appServiceBackendHttpsSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          port: 443
          protocol: 'Https'
          requestTimeout: 30
        }
      }
      {
        name: 'privateVmHttpSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          port: 80
          probe: {
            id: '<id>'
          }
          protocol: 'Http'
          requestTimeout: 30
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHttp2: true
    frontendIPConfigurations: [
      {
        name: 'private'
        properties: {
          privateIPAddress: '10.0.0.20'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '<id>'
          }
        }
      }
      {
        name: 'public'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          privateLinkConfiguration: {
            id: '<id>'
          }
          publicIPAddress: {
            id: '<id>'
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port443'
        properties: {
          port: 443
        }
      }
      {
        name: 'port4433'
        properties: {
          port: 4433
        }
      }
      {
        name: 'port80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port8080'
        properties: {
          port: 8080
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'apw-ip-configuration'
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'public443'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '<id>'
          }
        }
      }
      {
        name: 'private4433'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '<id>'
          }
        }
      }
      {
        name: 'httpRedirect80'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'public'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    privateLinkConfigurations: [
      {
        id: '<id>'
        name: 'pvtlink01'
        properties: {
          ipConfigurations: [
            {
              id: '<id>'
              name: 'privateLinkIpConfig1'
              properties: {
                primary: false
                privateIPAllocationMethod: 'Dynamic'
                subnet: {
                  id: '<id>'
                }
              }
            }
          ]
        }
      }
    ]
    probes: [
      {
        name: 'privateVmHttpSettingProbe'
        properties: {
          host: '10.0.0.4'
          interval: 60
          match: {
            statusCodes: [
              '200'
              '401'
            ]
          }
          minServers: 3
          path: '/'
          pickHostNameFromBackendHttpSettings: false
          protocol: 'Http'
          timeout: 15
          unhealthyThreshold: 5
        }
      }
    ]
    redirectConfigurations: [
      {
        name: 'httpRedirect80'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '<id>'
            }
          ]
          targetListener: {
            id: '<id>'
          }
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '<id>'
            }
          ]
          targetListener: {
            id: '<id>'
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting'
        properties: {
          backendAddressPool: {
            id: '<id>'
          }
          backendHttpSettings: {
            id: '<id>'
          }
          httpListener: {
            id: '<id>'
          }
          priority: 200
          ruleType: 'Basic'
        }
      }
      {
        name: 'private4433-privateVmHttpSetting-privateVmHttpSetting'
        properties: {
          backendAddressPool: {
            id: '<id>'
          }
          backendHttpSettings: {
            id: '<id>'
          }
          httpListener: {
            id: '<id>'
          }
          priority: 250
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect80-public443'
        properties: {
          httpListener: {
            id: '<id>'
          }
          priority: 300
          redirectConfiguration: {
            id: '<id>'
          }
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect8080-private4433'
        properties: {
          httpListener: {
            id: '<id>'
          }
          priority: 350
          redirectConfiguration: {
            id: '<id>'
          }
          rewriteRuleSet: {
            id: '<id>'
          }
          ruleType: 'Basic'
        }
      }
    ]
    rewriteRuleSets: [
      {
        id: '<id>'
        name: 'customRewrite'
        properties: {
          rewriteRules: [
            {
              actionSet: {
                requestHeaderConfigurations: [
                  {
                    headerName: 'Content-Type'
                    headerValue: 'JSON'
                  }
                  {
                    headerName: 'someheader'
                  }
                ]
                responseHeaderConfigurations: []
              }
              conditions: []
              name: 'NewRewrite'
              ruleSequence: 100
            }
          ]
        }
      }
    ]
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    sku: 'WAF_v2'
    sslCertificates: [
      {
        name: 'az-apgw-x-001-ssl-certificate'
        properties: {
          keyVaultSecretId: '<keyVaultSecretId>'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    webApplicationFirewallConfiguration: {
      disabledRuleGroups: [
        {
          ruleGroupName: 'Known-CVEs'
        }
        {
          ruleGroupName: 'REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION'
        }
        {
          ruleGroupName: 'REQUEST-941-APPLICATION-ATTACK-XSS'
        }
      ]
      enabled: true
      exclusions: [
        {
          matchVariable: 'RequestHeaderNames'
          selector: 'hola'
          selectorMatchOperator: 'StartsWith'
        }
      ]
      fileUploadLimitInMb: 100
      firewallMode: 'Detection'
      maxRequestBodySizeInKb: 128
      requestBodyCheck: true
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "appServiceBackendPool",
          "properties": {
            "backendAddresses": [
              {
                "fqdn": "aghapp.azurewebsites.net"
              }
            ]
          }
        },
        {
          "name": "privateVmBackendPool",
          "properties": {
            "backendAddresses": [
              {
                "ipAddress": "10.0.0.4"
              }
            ]
          }
        }
      ]
    },
    "backendHttpSettingsCollection": {
      "value": [
        {
          "name": "appServiceBackendHttpsSetting",
          "properties": {
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": true,
            "port": 443,
            "protocol": "Https",
            "requestTimeout": 30
          }
        },
        {
          "name": "privateVmHttpSetting",
          "properties": {
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": false,
            "port": 80,
            "probe": {
              "id": "<id>"
            },
            "protocol": "Http",
            "requestTimeout": 30
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableHttp2": {
      "value": true
    },
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "private",
          "properties": {
            "privateIPAddress": "10.0.0.20",
            "privateIPAllocationMethod": "Static",
            "subnet": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "public",
          "properties": {
            "privateIPAllocationMethod": "Dynamic",
            "privateLinkConfiguration": {
              "id": "<id>"
            },
            "publicIPAddress": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendPorts": {
      "value": [
        {
          "name": "port443",
          "properties": {
            "port": 443
          }
        },
        {
          "name": "port4433",
          "properties": {
            "port": 4433
          }
        },
        {
          "name": "port80",
          "properties": {
            "port": 80
          }
        },
        {
          "name": "port8080",
          "properties": {
            "port": 8080
          }
        }
      ]
    },
    "gatewayIPConfigurations": {
      "value": [
        {
          "name": "apw-ip-configuration",
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "httpListeners": {
      "value": [
        {
          "name": "public443",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "https",
            "requireServerNameIndication": false,
            "sslCertificate": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "private4433",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "https",
            "requireServerNameIndication": false,
            "sslCertificate": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "httpRedirect80",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "Http",
            "requireServerNameIndication": false
          }
        },
        {
          "name": "httpRedirect8080",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "Http",
            "requireServerNameIndication": false
          }
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "public",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "privateLinkConfigurations": {
      "value": [
        {
          "id": "<id>",
          "name": "pvtlink01",
          "properties": {
            "ipConfigurations": [
              {
                "id": "<id>",
                "name": "privateLinkIpConfig1",
                "properties": {
                  "primary": false,
                  "privateIPAllocationMethod": "Dynamic",
                  "subnet": {
                    "id": "<id>"
                  }
                }
              }
            ]
          }
        }
      ]
    },
    "probes": {
      "value": [
        {
          "name": "privateVmHttpSettingProbe",
          "properties": {
            "host": "10.0.0.4",
            "interval": 60,
            "match": {
              "statusCodes": [
                "200",
                "401"
              ]
            },
            "minServers": 3,
            "path": "/",
            "pickHostNameFromBackendHttpSettings": false,
            "protocol": "Http",
            "timeout": 15,
            "unhealthyThreshold": 5
          }
        }
      ]
    },
    "redirectConfigurations": {
      "value": [
        {
          "name": "httpRedirect80",
          "properties": {
            "includePath": true,
            "includeQueryString": true,
            "redirectType": "Permanent",
            "requestRoutingRules": [
              {
                "id": "<id>"
              }
            ],
            "targetListener": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "httpRedirect8080",
          "properties": {
            "includePath": true,
            "includeQueryString": true,
            "redirectType": "Permanent",
            "requestRoutingRules": [
              {
                "id": "<id>"
              }
            ],
            "targetListener": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "requestRoutingRules": {
      "value": [
        {
          "name": "public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting",
          "properties": {
            "backendAddressPool": {
              "id": "<id>"
            },
            "backendHttpSettings": {
              "id": "<id>"
            },
            "httpListener": {
              "id": "<id>"
            },
            "priority": 200,
            "ruleType": "Basic"
          }
        },
        {
          "name": "private4433-privateVmHttpSetting-privateVmHttpSetting",
          "properties": {
            "backendAddressPool": {
              "id": "<id>"
            },
            "backendHttpSettings": {
              "id": "<id>"
            },
            "httpListener": {
              "id": "<id>"
            },
            "priority": 250,
            "ruleType": "Basic"
          }
        },
        {
          "name": "httpRedirect80-public443",
          "properties": {
            "httpListener": {
              "id": "<id>"
            },
            "priority": 300,
            "redirectConfiguration": {
              "id": "<id>"
            },
            "ruleType": "Basic"
          }
        },
        {
          "name": "httpRedirect8080-private4433",
          "properties": {
            "httpListener": {
              "id": "<id>"
            },
            "priority": 350,
            "redirectConfiguration": {
              "id": "<id>"
            },
            "rewriteRuleSet": {
              "id": "<id>"
            },
            "ruleType": "Basic"
          }
        }
      ]
    },
    "rewriteRuleSets": {
      "value": [
        {
          "id": "<id>",
          "name": "customRewrite",
          "properties": {
            "rewriteRules": [
              {
                "actionSet": {
                  "requestHeaderConfigurations": [
                    {
                      "headerName": "Content-Type",
                      "headerValue": "JSON"
                    },
                    {
                      "headerName": "someheader"
                    }
                  ],
                  "responseHeaderConfigurations": []
                },
                "conditions": [],
                "name": "NewRewrite",
                "ruleSequence": 100
              }
            ]
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "sku": {
      "value": "WAF_v2"
    },
    "sslCertificates": {
      "value": [
        {
          "name": "az-apgw-x-001-ssl-certificate",
          "properties": {
            "keyVaultSecretId": "<keyVaultSecretId>"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "webApplicationFirewallConfiguration": {
      "value": {
        "disabledRuleGroups": [
          {
            "ruleGroupName": "Known-CVEs"
          },
          {
            "ruleGroupName": "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION"
          },
          {
            "ruleGroupName": "REQUEST-941-APPLICATION-ATTACK-XSS"
          }
        ],
        "enabled": true,
        "exclusions": [
          {
            "matchVariable": "RequestHeaderNames",
            "selector": "hola",
            "selectorMatchOperator": "StartsWith"
          }
        ],
        "fileUploadLimitInMb": 100,
        "firewallMode": "Detection",
        "maxRequestBodySizeInKb": 128,
        "requestBodyCheck": true,
        "ruleSetType": "OWASP",
        "ruleSetVersion": "3.0"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module applicationGateway 'br:bicep/modules/network.application-gateway:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nagwaf'
  params: {
    // Required parameters
    name: '<name>'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'appServiceBackendPool'
        properties: {
          backendAddresses: [
            {
              fqdn: 'aghapp.azurewebsites.net'
            }
          ]
        }
      }
      {
        name: 'privateVmBackendPool'
        properties: {
          backendAddresses: [
            {
              ipAddress: '10.0.0.4'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appServiceBackendHttpsSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: true
          port: 443
          protocol: 'Https'
          requestTimeout: 30
        }
      }
      {
        name: 'privateVmHttpSetting'
        properties: {
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          port: 80
          probe: {
            id: '<id>'
          }
          protocol: 'Http'
          requestTimeout: 30
        }
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    enableHttp2: true
    frontendIPConfigurations: [
      {
        name: 'private'
        properties: {
          privateIPAddress: '10.0.0.20'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '<id>'
          }
        }
      }
      {
        name: 'public'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          privateLinkConfiguration: {
            id: '<id>'
          }
          publicIPAddress: {
            id: '<id>'
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port443'
        properties: {
          port: 443
        }
      }
      {
        name: 'port4433'
        properties: {
          port: 4433
        }
      }
      {
        name: 'port80'
        properties: {
          port: 80
        }
      }
      {
        name: 'port8080'
        properties: {
          port: 8080
        }
      }
    ]
    gatewayIPConfigurations: [
      {
        name: 'apw-ip-configuration'
        properties: {
          subnet: {
            id: '<id>'
          }
        }
      }
    ]
    httpListeners: [
      {
        name: 'public443'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '<id>'
          }
        }
      }
      {
        name: 'private4433'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'https'
          requireServerNameIndication: false
          sslCertificate: {
            id: '<id>'
          }
        }
      }
      {
        name: 'httpRedirect80'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          frontendIPConfiguration: {
            id: '<id>'
          }
          frontendPort: {
            id: '<id>'
          }
          hostNames: []
          protocol: 'Http'
          requireServerNameIndication: false
        }
      }
    ]
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    privateEndpoints: [
      {
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        service: 'public'
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          Role: 'DeploymentValidation'
        }
      }
    ]
    privateLinkConfigurations: [
      {
        id: '<id>'
        name: 'pvtlink01'
        properties: {
          ipConfigurations: [
            {
              id: '<id>'
              name: 'privateLinkIpConfig1'
              properties: {
                primary: false
                privateIPAllocationMethod: 'Dynamic'
                subnet: {
                  id: '<id>'
                }
              }
            }
          ]
        }
      }
    ]
    probes: [
      {
        name: 'privateVmHttpSettingProbe'
        properties: {
          host: '10.0.0.4'
          interval: 60
          match: {
            statusCodes: [
              '200'
              '401'
            ]
          }
          minServers: 3
          path: '/'
          pickHostNameFromBackendHttpSettings: false
          protocol: 'Http'
          timeout: 15
          unhealthyThreshold: 5
        }
      }
    ]
    redirectConfigurations: [
      {
        name: 'httpRedirect80'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '<id>'
            }
          ]
          targetListener: {
            id: '<id>'
          }
        }
      }
      {
        name: 'httpRedirect8080'
        properties: {
          includePath: true
          includeQueryString: true
          redirectType: 'Permanent'
          requestRoutingRules: [
            {
              id: '<id>'
            }
          ]
          targetListener: {
            id: '<id>'
          }
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting'
        properties: {
          backendAddressPool: {
            id: '<id>'
          }
          backendHttpSettings: {
            id: '<id>'
          }
          httpListener: {
            id: '<id>'
          }
          priority: 200
          ruleType: 'Basic'
        }
      }
      {
        name: 'private4433-privateVmHttpSetting-privateVmHttpSetting'
        properties: {
          backendAddressPool: {
            id: '<id>'
          }
          backendHttpSettings: {
            id: '<id>'
          }
          httpListener: {
            id: '<id>'
          }
          priority: 250
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect80-public443'
        properties: {
          httpListener: {
            id: '<id>'
          }
          priority: 300
          redirectConfiguration: {
            id: '<id>'
          }
          ruleType: 'Basic'
        }
      }
      {
        name: 'httpRedirect8080-private4433'
        properties: {
          httpListener: {
            id: '<id>'
          }
          priority: 350
          redirectConfiguration: {
            id: '<id>'
          }
          rewriteRuleSet: {
            id: '<id>'
          }
          ruleType: 'Basic'
        }
      }
    ]
    rewriteRuleSets: [
      {
        id: '<id>'
        name: 'customRewrite'
        properties: {
          rewriteRules: [
            {
              actionSet: {
                requestHeaderConfigurations: [
                  {
                    headerName: 'Content-Type'
                    headerValue: 'JSON'
                  }
                  {
                    headerName: 'someheader'
                  }
                ]
                responseHeaderConfigurations: []
              }
              conditions: []
              name: 'NewRewrite'
              ruleSequence: 100
            }
          ]
        }
      }
    ]
    sku: 'WAF_v2'
    sslCertificates: [
      {
        name: 'az-apgw-x-001-ssl-certificate'
        properties: {
          keyVaultSecretId: '<keyVaultSecretId>'
        }
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    webApplicationFirewallConfiguration: {
      disabledRuleGroups: [
        {
          ruleGroupName: 'Known-CVEs'
        }
        {
          ruleGroupName: 'REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION'
        }
        {
          ruleGroupName: 'REQUEST-941-APPLICATION-ATTACK-XSS'
        }
      ]
      enabled: true
      exclusions: [
        {
          matchVariable: 'RequestHeaderNames'
          selector: 'hola'
          selectorMatchOperator: 'StartsWith'
        }
      ]
      fileUploadLimitInMb: 100
      firewallMode: 'Detection'
      maxRequestBodySizeInKb: 128
      requestBodyCheck: true
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.0'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<name>"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "appServiceBackendPool",
          "properties": {
            "backendAddresses": [
              {
                "fqdn": "aghapp.azurewebsites.net"
              }
            ]
          }
        },
        {
          "name": "privateVmBackendPool",
          "properties": {
            "backendAddresses": [
              {
                "ipAddress": "10.0.0.4"
              }
            ]
          }
        }
      ]
    },
    "backendHttpSettingsCollection": {
      "value": [
        {
          "name": "appServiceBackendHttpsSetting",
          "properties": {
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": true,
            "port": 443,
            "protocol": "Https",
            "requestTimeout": 30
          }
        },
        {
          "name": "privateVmHttpSetting",
          "properties": {
            "cookieBasedAffinity": "Disabled",
            "pickHostNameFromBackendAddress": false,
            "port": 80,
            "probe": {
              "id": "<id>"
            },
            "protocol": "Http",
            "requestTimeout": 30
          }
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "enableHttp2": {
      "value": true
    },
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "private",
          "properties": {
            "privateIPAddress": "10.0.0.20",
            "privateIPAllocationMethod": "Static",
            "subnet": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "public",
          "properties": {
            "privateIPAllocationMethod": "Dynamic",
            "privateLinkConfiguration": {
              "id": "<id>"
            },
            "publicIPAddress": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendPorts": {
      "value": [
        {
          "name": "port443",
          "properties": {
            "port": 443
          }
        },
        {
          "name": "port4433",
          "properties": {
            "port": 4433
          }
        },
        {
          "name": "port80",
          "properties": {
            "port": 80
          }
        },
        {
          "name": "port8080",
          "properties": {
            "port": 8080
          }
        }
      ]
    },
    "gatewayIPConfigurations": {
      "value": [
        {
          "name": "apw-ip-configuration",
          "properties": {
            "subnet": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "httpListeners": {
      "value": [
        {
          "name": "public443",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "https",
            "requireServerNameIndication": false,
            "sslCertificate": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "private4433",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "https",
            "requireServerNameIndication": false,
            "sslCertificate": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "httpRedirect80",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "Http",
            "requireServerNameIndication": false
          }
        },
        {
          "name": "httpRedirect8080",
          "properties": {
            "frontendIPConfiguration": {
              "id": "<id>"
            },
            "frontendPort": {
              "id": "<id>"
            },
            "hostNames": [],
            "protocol": "Http",
            "requireServerNameIndication": false
          }
        }
      ]
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "service": "public",
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "privateLinkConfigurations": {
      "value": [
        {
          "id": "<id>",
          "name": "pvtlink01",
          "properties": {
            "ipConfigurations": [
              {
                "id": "<id>",
                "name": "privateLinkIpConfig1",
                "properties": {
                  "primary": false,
                  "privateIPAllocationMethod": "Dynamic",
                  "subnet": {
                    "id": "<id>"
                  }
                }
              }
            ]
          }
        }
      ]
    },
    "probes": {
      "value": [
        {
          "name": "privateVmHttpSettingProbe",
          "properties": {
            "host": "10.0.0.4",
            "interval": 60,
            "match": {
              "statusCodes": [
                "200",
                "401"
              ]
            },
            "minServers": 3,
            "path": "/",
            "pickHostNameFromBackendHttpSettings": false,
            "protocol": "Http",
            "timeout": 15,
            "unhealthyThreshold": 5
          }
        }
      ]
    },
    "redirectConfigurations": {
      "value": [
        {
          "name": "httpRedirect80",
          "properties": {
            "includePath": true,
            "includeQueryString": true,
            "redirectType": "Permanent",
            "requestRoutingRules": [
              {
                "id": "<id>"
              }
            ],
            "targetListener": {
              "id": "<id>"
            }
          }
        },
        {
          "name": "httpRedirect8080",
          "properties": {
            "includePath": true,
            "includeQueryString": true,
            "redirectType": "Permanent",
            "requestRoutingRules": [
              {
                "id": "<id>"
              }
            ],
            "targetListener": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "requestRoutingRules": {
      "value": [
        {
          "name": "public443-appServiceBackendHttpsSetting-appServiceBackendHttpsSetting",
          "properties": {
            "backendAddressPool": {
              "id": "<id>"
            },
            "backendHttpSettings": {
              "id": "<id>"
            },
            "httpListener": {
              "id": "<id>"
            },
            "priority": 200,
            "ruleType": "Basic"
          }
        },
        {
          "name": "private4433-privateVmHttpSetting-privateVmHttpSetting",
          "properties": {
            "backendAddressPool": {
              "id": "<id>"
            },
            "backendHttpSettings": {
              "id": "<id>"
            },
            "httpListener": {
              "id": "<id>"
            },
            "priority": 250,
            "ruleType": "Basic"
          }
        },
        {
          "name": "httpRedirect80-public443",
          "properties": {
            "httpListener": {
              "id": "<id>"
            },
            "priority": 300,
            "redirectConfiguration": {
              "id": "<id>"
            },
            "ruleType": "Basic"
          }
        },
        {
          "name": "httpRedirect8080-private4433",
          "properties": {
            "httpListener": {
              "id": "<id>"
            },
            "priority": 350,
            "redirectConfiguration": {
              "id": "<id>"
            },
            "rewriteRuleSet": {
              "id": "<id>"
            },
            "ruleType": "Basic"
          }
        }
      ]
    },
    "rewriteRuleSets": {
      "value": [
        {
          "id": "<id>",
          "name": "customRewrite",
          "properties": {
            "rewriteRules": [
              {
                "actionSet": {
                  "requestHeaderConfigurations": [
                    {
                      "headerName": "Content-Type",
                      "headerValue": "JSON"
                    },
                    {
                      "headerName": "someheader"
                    }
                  ],
                  "responseHeaderConfigurations": []
                },
                "conditions": [],
                "name": "NewRewrite",
                "ruleSequence": 100
              }
            ]
          }
        }
      ]
    },
    "sku": {
      "value": "WAF_v2"
    },
    "sslCertificates": {
      "value": [
        {
          "name": "az-apgw-x-001-ssl-certificate",
          "properties": {
            "keyVaultSecretId": "<keyVaultSecretId>"
          }
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "webApplicationFirewallConfiguration": {
      "value": {
        "disabledRuleGroups": [
          {
            "ruleGroupName": "Known-CVEs"
          },
          {
            "ruleGroupName": "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION"
          },
          {
            "ruleGroupName": "REQUEST-941-APPLICATION-ATTACK-XSS"
          }
        ],
        "enabled": true,
        "exclusions": [
          {
            "matchVariable": "RequestHeaderNames",
            "selector": "hola",
            "selectorMatchOperator": "StartsWith"
          }
        ],
        "fileUploadLimitInMb": 100,
        "firewallMode": "Detection",
        "maxRequestBodySizeInKb": 128,
        "requestBodyCheck": true,
        "ruleSetType": "OWASP",
        "ruleSetVersion": "3.0"
      }
    }
  }
}
```

</details>
<p>


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Application Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authenticationCertificates`](#parameter-authenticationcertificates) | array | Authentication certificates of the application gateway resource. |
| [`autoscaleMaxCapacity`](#parameter-autoscalemaxcapacity) | int | Upper bound on number of Application Gateway capacity. |
| [`autoscaleMinCapacity`](#parameter-autoscalemincapacity) | int | Lower bound on number of Application Gateway capacity. |
| [`backendAddressPools`](#parameter-backendaddresspools) | array | Backend address pool of the application gateway resource. |
| [`backendHttpSettingsCollection`](#parameter-backendhttpsettingscollection) | array | Backend http settings of the application gateway resource. |
| [`backendSettingsCollection`](#parameter-backendsettingscollection) | array | Backend settings of the application gateway resource. For default limits, see [Application Gateway limits](https://learn.microsoft.com/en-us/azure/azure-subscription-service-limits#application-gateway-limits). |
| [`capacity`](#parameter-capacity) | int | The number of Application instances to be configured. |
| [`customErrorConfigurations`](#parameter-customerrorconfigurations) | array | Custom error configurations of the application gateway resource. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`enableFips`](#parameter-enablefips) | bool | Whether FIPS is enabled on the application gateway resource. |
| [`enableHttp2`](#parameter-enablehttp2) | bool | Whether HTTP2 is enabled on the application gateway resource. |
| [`enableRequestBuffering`](#parameter-enablerequestbuffering) | bool | Enable request buffering. |
| [`enableResponseBuffering`](#parameter-enableresponsebuffering) | bool | Enable response buffering. |
| [`firewallPolicyId`](#parameter-firewallpolicyid) | string | The resource ID of an associated firewall policy. Should be configured for security reasons. |
| [`frontendIPConfigurations`](#parameter-frontendipconfigurations) | array | Frontend IP addresses of the application gateway resource. |
| [`frontendPorts`](#parameter-frontendports) | array | Frontend ports of the application gateway resource. |
| [`gatewayIPConfigurations`](#parameter-gatewayipconfigurations) | array | Subnets of the application gateway resource. |
| [`httpListeners`](#parameter-httplisteners) | array | Http listeners of the application gateway resource. |
| [`listeners`](#parameter-listeners) | array | Listeners of the application gateway resource. For default limits, see [Application Gateway limits](https://learn.microsoft.com/en-us/azure/azure-subscription-service-limits#application-gateway-limits). |
| [`loadDistributionPolicies`](#parameter-loaddistributionpolicies) | array | Load distribution policies of the application gateway resource. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`privateLinkConfigurations`](#parameter-privatelinkconfigurations) | array | PrivateLink configurations on application gateway. |
| [`probes`](#parameter-probes) | array | Probes of the application gateway resource. |
| [`redirectConfigurations`](#parameter-redirectconfigurations) | array | Redirect configurations of the application gateway resource. |
| [`requestRoutingRules`](#parameter-requestroutingrules) | array | Request routing rules of the application gateway resource. |
| [`rewriteRuleSets`](#parameter-rewriterulesets) | array | Rewrite rules for the application gateway resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`routingRules`](#parameter-routingrules) | array | Routing rules of the application gateway resource. |
| [`sku`](#parameter-sku) | string | The name of the SKU for the Application Gateway. |
| [`sslCertificates`](#parameter-sslcertificates) | array | SSL certificates of the application gateway resource. |
| [`sslPolicyCipherSuites`](#parameter-sslpolicyciphersuites) | array | Ssl cipher suites to be enabled in the specified order to application gateway. |
| [`sslPolicyMinProtocolVersion`](#parameter-sslpolicyminprotocolversion) | string | Ssl protocol enums. |
| [`sslPolicyName`](#parameter-sslpolicyname) | string | Ssl predefined policy name enums. |
| [`sslPolicyType`](#parameter-sslpolicytype) | string | Type of Ssl Policy. |
| [`sslProfiles`](#parameter-sslprofiles) | array | SSL profiles of the application gateway resource. |
| [`tags`](#parameter-tags) | object | Resource tags. |
| [`trustedClientCertificates`](#parameter-trustedclientcertificates) | array | Trusted client certificates of the application gateway resource. |
| [`trustedRootCertificates`](#parameter-trustedrootcertificates) | array | Trusted Root certificates of the application gateway resource. |
| [`urlPathMaps`](#parameter-urlpathmaps) | array | URL path map of the application gateway resource. |
| [`webApplicationFirewallConfiguration`](#parameter-webapplicationfirewallconfiguration) | object | Application gateway web application firewall configuration. Should be configured for security reasons. |
| [`zones`](#parameter-zones) | array | A list of availability zones denoting where the resource needs to come from. |

### Parameter: `name`

Name of the Application Gateway.

- Required: Yes
- Type: string

### Parameter: `authenticationCertificates`

Authentication certificates of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `autoscaleMaxCapacity`

Upper bound on number of Application Gateway capacity.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `autoscaleMinCapacity`

Lower bound on number of Application Gateway capacity.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `backendAddressPools`

Backend address pool of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `backendHttpSettingsCollection`

Backend http settings of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `backendSettingsCollection`

Backend settings of the application gateway resource. For default limits, see [Application Gateway limits](https://learn.microsoft.com/en-us/azure/azure-subscription-service-limits#application-gateway-limits).

- Required: No
- Type: array
- Default: `[]`

### Parameter: `capacity`

The number of Application instances to be configured.

- Required: No
- Type: int
- Default: `2`

### Parameter: `customErrorConfigurations`

Custom error configurations of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableFips`

Whether FIPS is enabled on the application gateway resource.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableHttp2`

Whether HTTP2 is enabled on the application gateway resource.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRequestBuffering`

Enable request buffering.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableResponseBuffering`

Enable response buffering.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `firewallPolicyId`

The resource ID of an associated firewall policy. Should be configured for security reasons.

- Required: No
- Type: string
- Default: `''`

### Parameter: `frontendIPConfigurations`

Frontend IP addresses of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `frontendPorts`

Frontend ports of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `gatewayIPConfigurations`

Subnets of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `httpListeners`

Http listeners of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `listeners`

Listeners of the application gateway resource. For default limits, see [Application Gateway limits](https://learn.microsoft.com/en-us/azure/azure-subscription-service-limits#application-gateway-limits).

- Required: No
- Type: array
- Default: `[]`

### Parameter: `loadDistributionPolicies`

Load distribution policies of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`service`](#parameter-privateendpointsservice) | string | The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob". |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualPrivateLinkServiceConnections`](#parameter-privateendpointsmanualprivatelinkserviceconnections) | array | Manual PrivateLink Service Connections. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.service`

The service (sub-) type to deploy the private endpoint for. For example "vault" or "blob".

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |

### Parameter: `privateEndpoints.lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualPrivateLinkServiceConnections`

Manual PrivateLink Service Connections.

- Required: No
- Type: array

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

The name of the private DNS zone group to create if privateDnsZoneResourceIds were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

### Parameter: `privateLinkConfigurations`

PrivateLink configurations on application gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `probes`

Probes of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `redirectConfigurations`

Redirect configurations of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `requestRoutingRules`

Request routing rules of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `rewriteRuleSets`

Rewrite rules for the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `routingRules`

Routing rules of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sku`

The name of the SKU for the Application Gateway.

- Required: No
- Type: string
- Default: `'WAF_Medium'`
- Allowed:
  ```Bicep
  [
    'Standard_Large'
    'Standard_Medium'
    'Standard_Small'
    'Standard_v2'
    'WAF_Large'
    'WAF_Medium'
    'WAF_v2'
  ]
  ```

### Parameter: `sslCertificates`

SSL certificates of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `sslPolicyCipherSuites`

Ssl cipher suites to be enabled in the specified order to application gateway.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
  ]
  ```
- Allowed:
  ```Bicep
  [
    'TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA'
    'TLS_DHE_DSS_WITH_AES_128_CBC_SHA'
    'TLS_DHE_DSS_WITH_AES_128_CBC_SHA256'
    'TLS_DHE_DSS_WITH_AES_256_CBC_SHA'
    'TLS_DHE_DSS_WITH_AES_256_CBC_SHA256'
    'TLS_DHE_RSA_WITH_AES_128_CBC_SHA'
    'TLS_DHE_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_DHE_RSA_WITH_AES_256_CBC_SHA'
    'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384'
    'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA'
    'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256'
    'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA'
    'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384'
    'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384'
    'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA'
    'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA'
    'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384'
    'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384'
    'TLS_RSA_WITH_3DES_EDE_CBC_SHA'
    'TLS_RSA_WITH_AES_128_CBC_SHA'
    'TLS_RSA_WITH_AES_128_CBC_SHA256'
    'TLS_RSA_WITH_AES_128_GCM_SHA256'
    'TLS_RSA_WITH_AES_256_CBC_SHA'
    'TLS_RSA_WITH_AES_256_CBC_SHA256'
    'TLS_RSA_WITH_AES_256_GCM_SHA384'
  ]
  ```

### Parameter: `sslPolicyMinProtocolVersion`

Ssl protocol enums.

- Required: No
- Type: string
- Default: `'TLSv1_2'`
- Allowed:
  ```Bicep
  [
    'TLSv1_0'
    'TLSv1_1'
    'TLSv1_2'
    'TLSv1_3'
  ]
  ```

### Parameter: `sslPolicyName`

Ssl predefined policy name enums.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'AppGwSslPolicy20150501'
    'AppGwSslPolicy20170401'
    'AppGwSslPolicy20170401S'
    'AppGwSslPolicy20220101'
    'AppGwSslPolicy20220101S'
  ]
  ```

### Parameter: `sslPolicyType`

Type of Ssl Policy.

- Required: No
- Type: string
- Default: `'Custom'`
- Allowed:
  ```Bicep
  [
    'Custom'
    'CustomV2'
    'Predefined'
  ]
  ```

### Parameter: `sslProfiles`

SSL profiles of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

### Parameter: `trustedClientCertificates`

Trusted client certificates of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `trustedRootCertificates`

Trusted Root certificates of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `urlPathMaps`

URL path map of the application gateway resource.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `webApplicationFirewallConfiguration`

Application gateway web application firewall configuration. Should be configured for security reasons.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `zones`

A list of availability zones denoting where the resource needs to come from.

- Required: No
- Type: array
- Default: `[]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the application gateway. |
| `resourceGroupName` | string | The resource group the application gateway was deployed into. |
| `resourceId` | string | The resource ID of the application gateway. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/private-endpoint` | Local reference |
