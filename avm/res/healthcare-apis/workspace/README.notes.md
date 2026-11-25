
### Parameter Usage: `iotconnectors`

Create an IOT Connector (MedTech) service with the workspace.

<details>

<summary>Parameter JSON format</summary>

```json
"iotConnectors": {
    "value": [
      {
        "name": "[[namePrefix]]-az-iomt-x-001",
        "workspaceName": "[[namePrefix]]001",
        "corsOrigins": [ "*" ],
        "corsHeaders": [ "*" ],
        "corsMethods": [ "GET" ],
        "corsMaxAge": 600,
        "corsAllowCredentials": false,
        "location": "[[location]]",
        "diagnosticStorageAccountId": "[[storageAccountResourceId]]",
        "diagnosticWorkspaceId": "[[logAnalyticsWorkspaceResourceId]]",
        "diagnosticEventHubAuthorizationRuleId": "[[eventHubAuthorizationRuleId]]",
        "diagnosticEventHubName": "[[eventHubNamespaceEventHubName]]",
        "publicNetworkAccess": "Enabled",
        "enableDefaultTelemetry": false,
        "systemAssignedIdentity": true,
        "userAssignedIdentities": {
          "[[managedIdentityResourceId]]": {}
        },
        "eventHubName": "[[eventHubName]]",
        "consumerGroup": "[[consumerGroup]]",
        "eventHubNamespaceName": "[[eventHubNamespaceName]]",
        "deviceMapping": "[[deviceMapping]]",
        "destinationMapping": "[[destinationMapping]]",
        "fhirServiceResourceId": "[[fhirServiceResourceId]]",
      }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
iotConnectors: [
    {
        name: '[[namePrefix]]-az-iomt-x-001'
        workspaceName: '[[namePrefix]]001'
        corsOrigins: [ '*' ]
        corsHeaders: [ '*' ]
        corsMethods: [ 'GET' ]
        corsMaxAge: 600
        corsAllowCredentials: false
        location: location
        diagnosticStorageAccountId: diagnosticDependencies.outputs.storageAccountResourceId
        diagnosticWorkspaceId: diagnosticDependencies.outputs.logAnalyticsWorkspaceResourceId
        diagnosticEventHubAuthorizationRuleId: diagnosticDependencies.outputs.eventHubAuthorizationRuleId
        diagnosticEventHubName: diagnosticDependencies.outputs.eventHubNamespaceEventHubName
        publicNetworkAccess: 'Enabled'
        enableDefaultTelemetry: enableDefaultTelemetry
        systemAssignedIdentity: true
        userAssignedIdentities: {
          '${resourceGroupResources.outputs.managedIdentityResourceId}': {}
        }
        eventHubName: '[[eventHubName]]'
        consumerGroup: '[[consumerGroup]]'
        eventHubNamespaceName: '[[eventHubNamespaceName]]'
        deviceMapping: '[[deviceMapping]]'
        destinationMapping: '[[destinationMapping]]'
        fhirServiceResourceId: '[[fhirServiceResourceId]]'
      }
]
```

</details>
<p>

