# Healthcare API Workspace IoT Connector FHIR Destinations `[Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations]`

This module deploys a Healthcare API Workspace IoT Connector FHIR Destination.

You can reference the module as follows:
```bicep
module workspace 'br/public:avm/res/healthcare-apis/workspace/iotconnector/fhirdestination:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.HealthcareApis/workspaces/iotconnectors/fhirdestinations` | 2022-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.healthcareapis_workspaces_iotconnectors_fhirdestinations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HealthcareApis/2022-06-01/workspaces/iotconnectors/fhirdestinations)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
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
| [`destinationMapping`](#parameter-destinationmapping) | object | The mapping JSON that determines how normalized data is converted to FHIR Observations. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`resourceIdentityResolutionType`](#parameter-resourceidentityresolutiontype) | string | Determines how resource identity is resolved on the destination. |

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
