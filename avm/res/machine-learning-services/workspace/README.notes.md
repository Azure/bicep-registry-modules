
### Parameter Usage: `computes`

Array to specify the compute resources to create respectively attach.
In case you provide a resource ID, it will attach the resource and ignore "properties". In this case "computeLocation", "sku", "systemAssignedIdentity", "userAssignedIdentities" as well as "tags" don't need to be provided respectively are being ignored.
Attaching a compute is not idempotent and will fail in case you try to redeploy over an existing compute in AML. I.e. for the first run set "deploy" to true, and after successful deployment to false.
For more information see https://learn.microsoft.com/en-us/azure/templates/microsoft.machinelearningservices/workspaces/computes?tabs=bicep

<details>

<summary>Parameter JSON format</summary>

```json
"computes": {
    "value": [
        // Attach existing resources
        {
            "name": "DefaultAKS",
            "location": "westeurope",
            "description": "Default AKS Cluster",
            "disableLocalAuth": false,
            "deployCompute": true,
            "computeType": "AKS",
            "resourceId": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx"
        },
        // Create new compute resource
        {
            "name": "DefaultCPU",
            "location": "westeurope",
            "computeLocation": "westeurope",
            "sku": "Basic",
            "systemAssignedIdentity": true,
            "userAssignedIdentities": {
                "/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-[[namePrefix]]-az-msi-x-001": {}
            },
            "description": "Default CPU Cluster",
            "disableLocalAuth": false,
            "computeType": "AmlCompute",
            "properties": {
                "enableNodePublicIp": true,
                "isolatedNetwork": false,
                "osType": "Linux",
                "remoteLoginPortPublicAccess": "Disabled",
                "scaleSettings": {
                    "maxNodeCount": 3,
                    "minNodeCount": 0,
                    "nodeIdleTimeBeforeScaleDown": "PT5M"
                },
                "vmPriority": "Dedicated",
                "vmSize": "STANDARD_DS11_V2"
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
computes: [
    // Attach existing resources
    {
        name: 'DefaultAKS'
        location: 'westeurope'
        description: 'Default AKS Cluster'
        disableLocalAuth: false
        deployCompute: true
        computeType: 'AKS'
        resourceId: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.ContainerService/managedClusters/xxx'
    }
    // Create new compute resource
    {
        name: 'DefaultCPU'
        location: 'westeurope'
        computeLocation: 'westeurope'
        sku: 'Basic'
        systemAssignedIdentity: true
        userAssignedIdentities: {
            '/subscriptions/[[subscriptionId]]/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-[[namePrefix]]-az-msi-x-001': {}
        }
        description: 'Default CPU Cluster'
        disableLocalAuth: false
        computeType: 'AmlCompute'
        properties: {
            enableNodePublicIp: true
            isolatedNetwork: false
            osType: 'Linux'
            remoteLoginPortPublicAccess: 'Disabled'
            scaleSettings: {
                maxNodeCount: 3
                minNodeCount: 0
                nodeIdleTimeBeforeScaleDown: 'PT5M'
            }
            vmPriority: 'Dedicated'
            vmSize: 'STANDARD_DS11_V2'
        }
    }
]
```

</details>
<p>

