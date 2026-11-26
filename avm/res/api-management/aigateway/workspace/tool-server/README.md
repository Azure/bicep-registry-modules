# AI Gateway tool server

Workspace-scoped tool server component for MCP URLs and URL-based OpenAPI sources. Connector-backed servers are excluded.

Inputs: required `aiGatewayName`, `workspaceName`, `name`, typed `properties`; optional secure `secrets`. Endpoint authentication supports anonymous, secure header references and managed identity. Subscription requirements default to true; endpoint federation requirements default to false.

Outputs: `resourceId`, `name`, `resourceGroupName`.

Public exports: `toolServerType`, `toolServerPropertiesType`, `toolEndpointType`. OAuth, inline OpenAPI content and tool-specific policies are outside this draft's feature boundary. The endpoint fields require live preview RP evaluation before submission.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
