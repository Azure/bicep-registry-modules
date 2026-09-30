
### Parameter Usage: `keyVault`

<details>

<summary>Parameter JSON format</summary>

```json
"keyVault": {
    "value":{
        "secretIdentifier":"Key vault secret identifier for fetching secret.",
        "identityClientId":"SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret."
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
keyVault: {
    secretIdentifier:'Key vault secret identifier for fetching secret.'
    identityClientId:'SystemAssignedIdentity or UserAssignedIdentity Client ID which will be used to access key vault secret.'
}
```

</details>
<p>

