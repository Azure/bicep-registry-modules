# AI Gateway telemetry exporter

Workspace-scoped runtime exporter for `ApplicationInsights` or `OpenTelemetry`. This is separate from root AVM usage telemetry.

Inputs: required `aiGatewayName`, `workspaceName`, `name`, typed `properties`; optional secure `secrets`. Application Insights requires a connection-string secret reference. OpenTelemetry requires at least one complete signal endpoint, with optional managed identity or secure header references; do not configure both authentication methods.

`payloadCapture` defaults to boolean false. Enabling it can capture prompts, completions and tool payloads without built-in PII redaction.

Outputs: `resourceId`, `name`, `resourceGroupName`.

Public exports: `telemetryExporterType`, `telemetryExporterPropertiesType`.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
