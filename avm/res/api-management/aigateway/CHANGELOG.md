# Changelog

The latest version of the changelog can be found [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/api-management/aigateway/CHANGELOG.md).

## 0.1.0

### Changes

- Initial release of `avm/res/api-management/aigateway` for standalone `Microsoft.ApiManagement/aigateways@2025-09-01-preview` resources.
- Added child modules for `apiKeys`, `workspaces`, `workspaces/modelProviders`, `workspaces/modelProviders/models`, `workspaces/aliases`, `workspaces/toolServers`, and `workspaces/telemetryExporters`.
- Added support for system-assigned and user-assigned managed identities, `AI Gateway User` RBAC, resource locks, outbound VNet subnet integration (`properties.backend.subnet.id`), inline workspace/model/tool-server policies (`tokenLimit`, `costLimit`, `contentSafety`, `ipFilter`), and Application Insights / OpenTelemetry exporters.

### Breaking Changes

- None
