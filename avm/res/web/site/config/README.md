
## Navigation

- [Notes](#Notes)

## Notes

### Parameter Usage: `appSettingsKeyValuePairs`

AzureWebJobsStorage, AzureWebJobsDashboard, APPINSIGHTS_INSTRUMENTATIONKEY and APPLICATIONINSIGHTS_CONNECTION_STRING are set separately (check parameters storageAccountId, setAzureWebJobsDashboard, appInsightId).
For all other app settings key-value pairs use this object.

<details>

<summary>Parameter JSON format</summary>

```json
"appSettingsKeyValuePairs": {
    "value": [
        {
            "name": "key1",
            "value": "val1"
        },
        {
            "name": "key2",
            "value": "val2"
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
appSettingsKeyValuePairs: [
    {
        name: 'key1'
        value: 'val1'
    }
    {
        name: 'key2'
        value: 'val2'
    }
]
```

</details>
<p>
