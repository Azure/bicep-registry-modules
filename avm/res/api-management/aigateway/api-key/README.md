# AI Gateway API key

Local child component for `Microsoft.ApiManagement/aigateways/apiKeys@2025-09-01-preview`, scoped directly to the gateway.

Inputs: required `aiGatewayName` and `name`; optional typed `properties` and secure `secrets`. Properties include display name, state, expiry, and optional `primaryKeySecretName` / `secondaryKeySecretName` references. Omitted key values are left to the resource provider.

Outputs: `resourceId`, `name`, `resourceGroupName`. No secret retrieval or regeneration is performed.

Public exports: `apiKeyType`, `apiKeyPropertiesType`.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
