# AI Gateway workspace

Local component for the automatically provisioned `workspaces/default`. A null `policies` input references the workspace without a write; a supplied array triggers a policy PUT. An empty array clears workspace policies.

Inputs: required `aiGatewayName`; optional `name` constrained to `default`, `policies`, `modelProviders`, `aliases`, `toolServers`, `telemetryExporters` and secure `secrets`. Aliases wait for provider/model configuration to complete.

Outputs: `resourceId`, `name`, `resourceGroupName`, `modelProviderResourceIds`, `aliasResourceIds`, `toolServerResourceIds`, `telemetryExporterResourceIds`.

Public export: `workspaceType`. The component does not imply support for creating arbitrary workspaces.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
