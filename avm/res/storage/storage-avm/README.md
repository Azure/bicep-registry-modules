# Storage Account AVM Module

This module deploys an Azure Storage Account with configurable SKU, kind, access tier, and network access settings.

## Features

- Storage Account creation with flexible SKU options
- Support for multiple storage kinds (Storage, StorageV2, BlobStorage, etc.)
- Hot/Cool access tier configuration
- HTTPS-only enforcement option
- Public network access control
- Tag support for resource organization

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `name` | string | Yes | Name of the Storage Account |
| `location` | string | No | Location for the Storage Account (default: resource group location) |
| `sku` | string | No | Storage Account SKU (default: Standard_LRS) |
| `kind` | string | No | Storage Account kind (default: StorageV2) |
| `accessTier` | string | No | Access tier - Hot or Cool (default: Hot) |
| `httpsOnly` | bool | No | Enable HTTPS traffic only (default: true) |
| `publicNetworkAccess` | string | No | Enable public network access (default: Enabled) |
| `tags` | object | No | Resource tags |

## Outputs

| Name | Type | Description |
|------|------|-------------|
| `resourceId` | string | Storage Account resource ID |
| `name` | string | Storage Account name |
| `primaryBlobEndpoint` | string | Primary blob endpoint URL |
| `location` | string | Storage Account location |

## Example Usage

```bicep
module storageAccount 'br/public:avm/res/storage/storage-avm:0.1.0' = {
  name: 'storageDeployment'
  params: {
    name: 'mystorageaccount'
    location: 'eastus'
    sku: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    httpsOnly: true
    tags: {
      environment: 'production'
    }
  }
}
```

## Notes

- Storage Account names must be globally unique across Azure
- Ensure compliance with your organization's naming conventions
- Consider using encryption for sensitive data
