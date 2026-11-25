
### Parameter Usage: `credentials`

<details>

<summary>Parameter JSON format</summary>

```json
"credentials": {
    "value":{
        "certificate": [
            "string"
        ],
        "query": {},
        "header": {},
        "authorization": {
            "scheme": "Authentication Scheme name.-string",
            "parameter": "Authentication Parameter value. - string"
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
credentials: {
    certificate: [
        'string'
    ]
    query: {}
    header: {}
    authorization: {
        scheme: 'Authentication Scheme name.-string'
        parameter: 'Authentication Parameter value. - string'
    }
}
```

</details>
<p>

### Parameter Usage: `tls`

<details>

<summary>Parameter JSON format</summary>

```json
"tls": {
    "value":{
        "validateCertificateChain": "Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. - boolean",
        "validateCertificateName": "Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. - boolean"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tls: {
    validateCertificateChain: 'Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. - boolean'
    validateCertificateName: 'Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. - boolean'
}
```

</details>
<p>

