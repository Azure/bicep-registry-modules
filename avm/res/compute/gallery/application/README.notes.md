
### Parameter Usage: `customActions`

Create a list of custom actions that can be performed with all of the Gallery Application Versions within this Gallery Application.

<details>

<summary>Parameter JSON format</summary>

```json
"customActions": {
    "value": [
        {
            "description": "This is a sample custom action",
            "name": "Name of the custom action 1 (Required). Must be unique within the Compute Gallery",
            "parameters": [
                {
                    "defaultValue": "Default Value of Parameter1. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": True,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                },
                {
                    "defaultValue": "Default Value of Parameter2. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": False,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                }
            ],
            "script": "The script to run when executing this custom action. (Required)"
        },
        {
            "description": "This is another sample custom action",
            "name": "Name of the custom action 2 (Required). Must be unique within the Compute Gallery",
            "parameters": [
                {
                    "defaultValue": "Default Value of Parameter1. Only applies to string types.",
                    "description": "a description value to help others understands what it means.",
                    "name": "The parameter name. (Required)",
                    "required": True,
                    "type": "ConfigurationDataBlob, LogOutputBlob, or String"
                }
            ],
            "script": "The script to run when executing this custom action. (Required)"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customActions: [
    {
        description: "This is a sample custom action"
        name: "Name of the custom action 1 (Required). Must be unique within the Compute Gallery"
        parameters: [
            {
                defaultValue: "Default Value of Parameter 1. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The parameter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
            {
                defaultValue: "Default Value of Parameter 2. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The parameter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
        ]
        script: "The script to run when executing this custom action. (Required)"
    }
    {
        description: "This is another sample custom action"
        name: "Name of the custom action 2 (Required). Must be unique within the Compute Gallery"
        parameters: [
            {
                defaultValue: "Default Value of Parameter. Only applies to string types."
                description: "a description value to help others understands what it means."
                name: "The paramter name. (Required)"
                required: True,
                type: "ConfigurationDataBlob, LogOutputBlob, or String"
            }
        ]
        script: "The script to run when executing this custom action. (Required)"
    }
]
```

</details>
<p>

