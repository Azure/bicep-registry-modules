# AI Gateway model provider

Workspace-scoped provider component with a discriminated Foundry/Custom configuration and optional catalog models.

Inputs: required `aiGatewayName`, `workspaceName`, `name`, typed `properties`; optional `models` and secure `secrets`. Foundry authentication supports managed identity or an API key reference; Custom supports an API key reference. Foundry account access must be granted before invoking models; this component does not create upstream role assignments.

Outputs: `resourceId`, `name`, `resourceGroupName`, `modelResourceIds`.

Public exports: `modelProviderType`, `modelProviderPropertiesType`, `authenticationType`.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
