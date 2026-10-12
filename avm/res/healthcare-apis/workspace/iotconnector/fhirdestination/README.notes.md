
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

