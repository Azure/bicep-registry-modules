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
| `Microsoft.ApiManagement/service/backends` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/backends) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Backend Name. |
| [`url`](#parameter-url) | string | Runtime URL of the Backend. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | Required if the template is used in a standalone deployment. The name of the parent API Management service. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`circuitBreaker`](#parameter-circuitbreaker) | object | Backend Circuit Breaker Configuration. |
| [`credentials`](#parameter-credentials) | object | Backend Credentials Contract Properties. |
| [`description`](#parameter-description) | string | Backend Description. |
| [`pool`](#parameter-pool) | object | Backend pool configuration for load balancing. |
| [`protocol`](#parameter-protocol) | string | Backend communication protocol. - http or soap. |
| [`proxy`](#parameter-proxy) | object | Backend gateway Contract Properties. |
| [`resourceId`](#parameter-resourceid) | string | Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps. |
| [`serviceFabricCluster`](#parameter-servicefabriccluster) | object | Backend Service Fabric Cluster Properties. |
| [`title`](#parameter-title) | string | Backend Title. |
| [`tls`](#parameter-tls) | object | Backend TLS Properties. |
| [`type`](#parameter-type) | string | Type of the backend. A backend can be either Single or Pool. |

### Parameter: `name`

Backend Name.

- Required: Yes
- Type: string

### Parameter: `url`

Runtime URL of the Backend.

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

Required if the template is used in a standalone deployment. The name of the parent API Management service.

- Required: Yes
- Type: string

### Parameter: `circuitBreaker`

Backend Circuit Breaker Configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rules`](#parameter-circuitbreakerrules) | array | The rules for tripping the backend. |

### Parameter: `circuitBreaker.rules`

The rules for tripping the backend.

- Required: No
- Type: array

### Parameter: `credentials`

Backend Credentials Contract Properties.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorization`](#parameter-credentialsauthorization) | object | Authorization header authentication. |
| [`certificate`](#parameter-credentialscertificate) | array | List of Client Certificate Thumbprints. Will be ignored if certificatesIds are provided. |
| [`certificateIds`](#parameter-credentialscertificateids) | array | List of Client Certificate Ids. |
| [`header`](#parameter-credentialsheader) | object | Header Parameter description. |
| [`query`](#parameter-credentialsquery) | object | Query Parameter description. |

### Parameter: `credentials.authorization`

Authorization header authentication.

- Required: No
- Type: object

### Parameter: `credentials.certificate`

List of Client Certificate Thumbprints. Will be ignored if certificatesIds are provided.

- Required: No
- Type: array

### Parameter: `credentials.certificateIds`

List of Client Certificate Ids.

- Required: No
- Type: array

### Parameter: `credentials.header`

Header Parameter description.

- Required: No
- Type: object

### Parameter: `credentials.query`

Query Parameter description.

- Required: No
- Type: object

### Parameter: `description`

Backend Description.

- Required: No
- Type: string

### Parameter: `pool`

Backend pool configuration for load balancing.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`services`](#parameter-poolservices) | array | The list of backend entities belonging to a pool. |

### Parameter: `pool.services`

The list of backend entities belonging to a pool.

- Required: No
- Type: array

### Parameter: `protocol`

Backend communication protocol. - http or soap.

- Required: No
- Type: string
- Default: `'http'`

### Parameter: `proxy`

Backend gateway Contract Properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`url`](#parameter-proxyurl) | string | WebProxy Server AbsoluteUri property which includes the entire URI stored in the Uri instance, including all fragments and query strings. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`password`](#parameter-proxypassword) | securestring | Password to connect to the WebProxy Server. |
| [`username`](#parameter-proxyusername) | string | Username to connect to the WebProxy server. |

### Parameter: `proxy.url`

WebProxy Server AbsoluteUri property which includes the entire URI stored in the Uri instance, including all fragments and query strings.

- Required: Yes
- Type: string

### Parameter: `proxy.password`

Password to connect to the WebProxy Server.

- Required: No
- Type: securestring

### Parameter: `proxy.username`

Username to connect to the WebProxy server.

- Required: No
- Type: string

### Parameter: `resourceId`

Management Uri of the Resource in External System. This URL can be the Arm Resource ID of Logic Apps, Function Apps or API Apps.

- Required: No
- Type: string

### Parameter: `serviceFabricCluster`

Backend Service Fabric Cluster Properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managementEndpoints`](#parameter-servicefabricclustermanagementendpoints) | array | The cluster management endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientCertificateId`](#parameter-servicefabricclusterclientcertificateid) | string | The client certificate id for the management endpoint. |
| [`clientCertificatethumbprint`](#parameter-servicefabricclusterclientcertificatethumbprint) | string | The client certificate thumbprint for the management endpoint. Will be ignored if certificatesIds are provided. |
| [`maxPartitionResolutionRetries`](#parameter-servicefabricclustermaxpartitionresolutionretries) | int | Maximum number of retries while attempting resolve the partition. |
| [`serverCertificateThumbprints`](#parameter-servicefabricclusterservercertificatethumbprints) | array | Thumbprints of certificates cluster management service uses for tls communication. |
| [`serverX509Names`](#parameter-servicefabricclusterserverx509names) | array | Server X509 Certificate Names Collection. |

### Parameter: `serviceFabricCluster.managementEndpoints`

The cluster management endpoint.

- Required: Yes
- Type: array

### Parameter: `serviceFabricCluster.clientCertificateId`

The client certificate id for the management endpoint.

- Required: No
- Type: string

### Parameter: `serviceFabricCluster.clientCertificatethumbprint`

The client certificate thumbprint for the management endpoint. Will be ignored if certificatesIds are provided.

- Required: No
- Type: string

### Parameter: `serviceFabricCluster.maxPartitionResolutionRetries`

Maximum number of retries while attempting resolve the partition.

- Required: No
- Type: int

### Parameter: `serviceFabricCluster.serverCertificateThumbprints`

Thumbprints of certificates cluster management service uses for tls communication.

- Required: No
- Type: array

### Parameter: `serviceFabricCluster.serverX509Names`

Server X509 Certificate Names Collection.

- Required: No
- Type: array

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`validateCertificateChain`](#parameter-tlsvalidatecertificatechain) | bool | Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host. |
| [`validateCertificateName`](#parameter-tlsvalidatecertificatename) | bool | Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host. |

### Parameter: `tls.validateCertificateChain`

Flag indicating whether SSL certificate chain validation should be done when using self-signed certificates for this backend host.

- Required: No
- Type: bool

### Parameter: `tls.validateCertificateName`

Flag indicating whether SSL certificate name validation should be done when using self-signed certificates for this backend host.

- Required: No
- Type: bool

### Parameter: `type`

Type of the backend. A backend can be either Single or Pool.

- Required: No
- Type: string
- Default: `'Single'`
- Allowed:
  ```Bicep
  [
    'Pool'
    'Single'
  ]
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
