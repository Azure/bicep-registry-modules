# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/app/agent/CHANGELOG.md).

## 0.1.0

### Changes

- Initial release of the SRE Agent (`Microsoft.App/agents`) AVM module.
- Supports `Microsoft.App/agents@2025-05-01-preview` API.
- Implements standard AVM interfaces: `managedIdentities`, `lock`, `roleAssignments`, `diagnosticSettings`, `tags`, `enableTelemetry`.
- Supports knowledge graph configuration with User-Assigned Managed Identity.
- Supports action configuration with access level (`High`/`Low`) and mode (`Review`/`Autonomous`/`ReadOnly`).
- Supports log configuration via Application Insights.
- Supports incident management configuration (`AzMonitor`).
- Supports monthly Agent Activity Unit (AAU) limit and upgrade channel.

### Notes

- Azure SRE Agent product is generally available (GA), but ARM/Bicep deployment for `Microsoft.App/agents` is still published as `2025-05-01-preview`.
- This module intentionally continues to use the preview API version until a stable (non-preview) API version is published.

### Breaking Changes

- None
