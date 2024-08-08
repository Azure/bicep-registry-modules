# Healthcare API Workspace IoT Connector FHIR Destinations `[Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations]`

This module deploys a Healthcare API Workspace IoT Connector FHIR Destination.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/workspaces) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinationMapping`](#parameter-destinationmapping) | object | The mapping JSON that determines how normalized data is converted to FHIR Observations. |
| [`fhirServiceResourceId`](#parameter-fhirserviceresourceid) | string | The resource identifier of the FHIR Service to connect to. |
| [`name`](#parameter-name) | string | The name of the FHIR destination. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`iotConnectorName`](#parameter-iotconnectorname) | string | The name of the MedTech service to add this destination to. Required if the template is used in a standalone deployment. |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent health data services workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`resourceIdentityResolutionType`](#parameter-resourceidentityresolutiontype) | string | Determines how resource identity is resolved on the destination. |

### Parameter: `destinationMapping`

The mapping JSON that determines how normalized data is converted to FHIR Observations.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      template: []
      templateType: 'CollectionFhir'
  }
  ```

### Parameter: `fhirServiceResourceId`

The resource identifier of the FHIR Service to connect to.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the FHIR destination.

- Required: Yes
- Type: string

### Parameter: `iotConnectorName`

The name of the MedTech service to add this destination to. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent health data services workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `resourceIdentityResolutionType`

Determines how resource identity is resolved on the destination.

- Required: No
- Type: string
- Default: `'Lookup'`
- Allowed:
  ```Bicep
  [
    'Create'
    'Lookup'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `iotConnectorName` | string | The name of the medtech service. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the FHIR destination. |
| `resourceGroupName` | string | The resource group where the namespace is deployed. |
| `resourceId` | string | The resource ID of the FHIR destination. |

## Notes

### Parameter Usage: `destinationMapping`

You can specify a collection of destination mapping using the following format:

> NOTE: More detailed information on destination mappings can be found [here](https://learn.microsoft.com/en-us/azure/healthcare-apis/iot/how-to-use-fhir-mappings).

<details>

<summary>Parameter JSON format</summary>

```json
"destinationMapping": {
    "value": {
        "templateType": "CodeValueFhir",
        "template": {
            "codes": [
                {
                    "code": "8867-4",
                    "system": "http://loinc.org",
                    "display": "Heart rate"
                }
            ],
            "periodInterval": 60,
            "typeName": "heartrate",
            "value": {
                "defaultPeriod": 5000,
                "unit": "count/min",
                "valueName": "hr",
                "valueType": "SampledData"
            }
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
destinationMapping: {
    templateType: 'CodeValueFhir'
    template: {
        codes: [
            {
                code: '8867-4'
                system: 'http://loinc.org'
                display: 'Heart rate'
            }
        ],
        periodInterval: 60,
        typeName: 'heartrate'
        value: {
            defaultPeriod: 5000
            unit: 'count/min'
            valueName: 'hr'
            valueType: 'SampledData'
        }
    }
}
```

</details>
