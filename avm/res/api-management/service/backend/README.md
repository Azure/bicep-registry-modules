# API Management Service Backends `[Microsoft.ApiManagement/service/backends]`

This module deploys an API Management Service Backend.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/backends` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/backends) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Backend Name. |
| [`url`](#parameter-url) | string | Runtime URL of the Backend. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-credentials) | object | Backend Credentials Contract Properties. |
| [`description`](#parameter-description) | string | Backend Description. |
| [`protocol`](#parameter-protocol) | string | Backend communication protocol. - http or soap. |
| [`proxy`](#parameter-proxy) | object | Backend Proxy Contract Properties. |
| [`resourceId`](#parameter-resourceid) | string | Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. |
| [`serviceFabricCluster`](#parameter-servicefabriccluster) | object | Backend Service Fabric Cluster Properties. |
| [`title`](#parameter-title) | string | Backend Title. |
| [`tls`](#parameter-tls) | object | Backend TLS Properties. |

### Parameter: `name`

Backend Name.

- Required: Yes
- Type: string

### Parameter: `url`

Runtime URL of the Backend.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentials`

Backend Credentials Contract Properties.

- Required: No
- Type: object

### Parameter: `description`

Backend Description.

- Required: No
- Type: string

### Parameter: `protocol`

Backend communication protocol. - http or soap.

- Required: No
- Type: string
- Default: `'http'`

### Parameter: `proxy`

Backend Proxy Contract Properties.

- Required: No
- Type: object

### Parameter: `resourceId`

Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.

- Required: No
- Type: string

### Parameter: `serviceFabricCluster`

Backend Service Fabric Cluster Properties.

- Required: No
- Type: object

### Parameter: `title`

Backend Title.

- Required: No
- Type: string

### Parameter: `tls`

Backend TLS Properties.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      validateCertificateChain: false
      validateCertificateName: false
  }
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service backend. |
| `resourceGroupName` | string | The resource group the API management service backend was deployed into. |
| `resourceId` | string | The resource ID of the API management service backend. |

## Notes

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
