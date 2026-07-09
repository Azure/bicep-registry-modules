# App ManagedEnvironments Certificates `[Microsoft.App/managedEnvironments/certificates]`

This module deploys a App Managed Environment Certificate.

You can reference the module as follows:
```bicep
module managedEnvironment 'br/public:avm/res/app/managed-environment/certificate:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.App/managedEnvironments/certificates` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/certificates)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Container Apps Managed Environment Certificate. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedEnvironmentName`](#parameter-managedenvironmentname) | string | The name of the parent app managed environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateKeyVaultProperties`](#parameter-certificatekeyvaultproperties) | object | A key vault reference to the certificate to use for the custom domain. |
| [`certificatePassword`](#parameter-certificatepassword) | securestring | The password of the certificate. |
| [`certificateType`](#parameter-certificatetype) | string | The type of the certificate. |
| [`certificateValue`](#parameter-certificatevalue) | string | The value of the certificate. PFX or PEM blob. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Container Apps Managed Environment Certificate.

- Required: Yes
- Type: string

### Parameter: `managedEnvironmentName`

The name of the parent app managed environment. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `certificateKeyVaultProperties`

A key vault reference to the certificate to use for the custom domain.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityResourceId`](#parameter-certificatekeyvaultpropertiesidentityresourceid) | string | The resource ID of the identity. This is the identity that will be used to access the key vault. |
| [`keyVaultUrl`](#parameter-certificatekeyvaultpropertieskeyvaulturl) | string | A key vault URL referencing the wildcard certificate that will be used for the custom domain. |

### Parameter: `certificateKeyVaultProperties.identityResourceId`

The resource ID of the identity. This is the identity that will be used to access the key vault.

- Required: Yes
- Type: string

### Parameter: `certificateKeyVaultProperties.keyVaultUrl`

A key vault URL referencing the wildcard certificate that will be used for the custom domain.

- Required: Yes
- Type: string

### Parameter: `certificatePassword`

The password of the certificate.

- Required: No
- Type: securestring

### Parameter: `certificateType`

The type of the certificate.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ImagePullTrustedCA'
    'ServerSSLCertificate'
  ]
  ```

### Parameter: `certificateValue`

The value of the certificate. PFX or PEM blob.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key values. |
| `resourceGroupName` | string | The resource group the certificate was deployed into. |
| `resourceId` | string | The resource ID of the key values. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
