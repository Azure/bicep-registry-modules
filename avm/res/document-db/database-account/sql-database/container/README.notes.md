
### Parameter Usage: `indexingPolicy`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"indexingPolicy": {
    "indexingMode": "consistent",
    "includedPaths": [
        {
            "path": "/*"
        }
    ],
    "excludedPaths": [
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
indexingPolicy: {
    indexingMode: 'consistent'
    includedPaths: [
    {
        path: '/*'
    }
    ]
    excludedPaths: []
}
```

</details>
<p>

