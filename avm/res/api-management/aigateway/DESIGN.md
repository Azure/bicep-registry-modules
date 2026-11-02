# Azure AI Gateway module shape review

Azure AI Gateway needs a reusable infrastructure module that combines a standalone gateway with model routing, governance, tools and monitoring. The proposed module is `avm/res/api-management/aigateway`, distinct from the existing API Management `service` module. It uses the project's `aigateway` short name and the standalone ARM type `Microsoft.ApiManagement/aigateways`.

**The draft is ready for API-shape review, not upstream submission.** The gateway and all three scenario templates compile. No Azure deployment or upstream PR has been performed. The immediate review decisions are the public configuration shape, supported preview feature boundary, and validation required before AVM submission.

## Proposed hierarchy

```text
avm/res/api-management/aigateway/
  main.bicep                         standalone Premium gateway
  main.json                          compiled root and nested templates
  metadata.json                      candidate owner and telemetry metadata
  version.json                       proposed 0.1 version
  README.md
  DESIGN.md
  api-key/main.bicep                  gateway-level apiKeys
  workspace/main.bicep               default workspace and policies
    model-provider/main.bicep        Foundry / Custom providers
      model/main.bicep               deployment metadata and policies
    alias/main.bicep                 provider/model routes
    tool-server/main.bicep           MCP / OpenAPI endpoints
    telemetry-exporter/main.bicep    ApplicationInsights / OpenTelemetry
  tests/e2e/
    defaults/main.test.bicep
    max/main.test.bicep
    waf-aligned/main.test.bicep
    dependencies/main.bicep          identity, monitoring, optional network
    dependencies/foundry-role-assignment.bicep
  tests/unit/test_contract.py        compiled-template invariants
```

Every gateway-family resource uses `2025-09-01-preview`. API keys sit directly under the gateway; model providers, aliases, tool servers and telemetry exporters sit under a workspace. Models sit under providers. Policies are inline resource properties, not XML API Management policy resources or additional ARM child types.

The resource provider automatically creates `workspaces/default`. Without policies, the workspace component uses an `existing` resource. Supplying policies enables a workspace PUT; an empty array clears existing policies. The public parameter permits at most one `default` entry, rather than implying unverified support for creating arbitrary named workspaces or allowing competing policy deployments.

## Configuration surface

The root takes the common AVM parameters `name`, `location`, `tags`, `managedIdentities`, `roleAssignments`, `lock` and `enableTelemetry`, plus `sku`, `virtualNetworkConfiguration`, `apiKeys`, `workspaces` and secure `secrets`.

Only `name` is required. Defaults select Premium, a system-assigned identity and a reference to the default workspace. The module does not silently register models, create client keys or provision monitoring destinations.

Resource configuration uses a typed `{ name, properties }` envelope to separate ARM identifiers from writable wire properties. Model providers add `models`; workspaces group their child arrays. This is a deliberate variation from adjacent modules that flatten many child resource properties. It keeps the preview contract visible and avoids generic unvalidated `object` payloads. The README documents each root parameter and output.

Secret-bearing fields are an additional deliberate variation: public arrays contain secret reference names, while a separate secure dictionary carries values. The child module converts references to the actual API key, header or connection-string wire fields. Values remain secure through nested deployment parameters and are never returned in outputs. Missing references fail instead of falling back to empty credentials.

Root `roleAssignments` grants callers access to the gateway. It does not grant the gateway identity upstream access. The max and WAF examples create a user-assigned identity, grant it Cognitive Services OpenAI User on an existing Foundry account, and only then configure the gateway. This avoids a circular dependency between gateway outputs and provider creation.

## Exported Bicep types

All public types below are exported from `main.bicep`. Their definitions live with the corresponding child module and are re-exported at the root, avoiding circular imports between the resource module and its children. Sealed objects reject unknown fields; discriminated unions select required provider, credential, tool endpoint and exporter variants.

| Export | Shape / role |
|---|---|
| `apiKeyType` | `name`, optional metadata and primary/secondary key secret references |
| `workspaceType` | `name: 'default'`, optional policies and four workspace-level child arrays |
| `modelProviderType` | `name`, Foundry/Custom properties, optional `models` |
| `authenticationType` | ManagedIdentity audience/client ID, or ApiKey header/secret reference |
| `modelType` | `name`, display name, API format, supported endpoints, deployment details, policies |
| `policyType` | Discriminated tokenLimit / costLimit / contentSafety / ipFilter union |
| `tokenLimitPolicyType` | Positive token count, minute/hour/day period, camelCase counter-dimension array |
| `costLimitPolicyType` | Stable ID, positive whole-USD amount, hour/day/week/month/year period, counter dimensions |
| `contentSafetyPolicyType` | Hate, self-harm, sexual and violence severity thresholds |
| `ipFilterPolicyType` | Inbound caller IP filter (`Allow` / `Deny` action and `cidrRanges` array) |
| `aliasType` | `name`, alias/display name, description, routes and optional policies |
| `routeType` | Provider name, model name, priority 0-100, weight 1-100 |
| `toolServerType` | MCP/OpenAPI server metadata, endpoint array, allow/block lists and access settings |
| `toolEndpointType` | MCP URL or URL-based OpenAPI source with optional upstream credentials |
| `telemetryExporterType` | Application Insights or OTLP configuration with boolean payload capture |
| `virtualNetworkConfigurationType` | Outbound VNet subnet attachment (`subnetResourceId` -> `properties.backend.subnet.id`) |

The common AVM identity, lock and RBAC types come from `br/public:avm/utl/types/avm-common-types:0.7.0`, matching the adjacent API Management module.

## Preview wire decisions

| Concern | Draft behavior |
|---|---|
| Gateway type and SKU | `Microsoft.ApiManagement/aigateways`, `sku.name: 'Premium'`; no SKU capacity |
| Gateway properties | Empty by default; optional virtual network type/subnet |
| Runtime hostname | Read `properties.frontend.defaultHostname`; no success-shaped fallback |
| Workspace lifecycle | Reference service-provisioned default; PUT only when policies are supplied |
| Alias routing | `properties.routes` with `providerName`, `modelName`, `priority`, `weight` |
| Counters | Arrays containing camelCase `identity` and/or `ipAddress` selectors |
| Content safety | Explicit severity fields, not an opaque policy object |
| Exporters | Workspace-scoped, correctly cased `ApplicationInsights` / `OpenTelemetry` |
| Payload capture | Boolean, false unless explicitly enabled |
| Retired connector resource | Never deployed |

The preview decisions follow the supplied live-resource-provider observations. The public sample and newer schema materials differ in some fields: notably SKU choices, connector resources, `backendModels` versus `routes`, encoded display names and exporter casing. Those differences are not treated as permission to change the requested preview wire contract. Raw non-public schema materials are not included in this branch.

## Outputs and deployment ordering

The root returns gateway `resourceId`, `name`, `resourceGroupName`, `location`, nullable `systemAssignedMIPrincipalId`, service-provided `defaultHostname`, `apiKeyResourceIds` and `workspaceResourceIds`.

Workspace components return provider, alias, tool server and exporter IDs; providers return model IDs. All children return the standard resource identity outputs. No secret-listing or key-regeneration actions are called.

The gateway precedes API keys and workspace configuration. Workspace policies precede its children; provider modules complete their model registrations before aliases are created. Resource locks follow child configuration and gateway RBAC. These dependencies prevent aliases from racing newly registered models and prevent an initial ReadOnly lock from blocking initial child creation.

Incremental deployments do not delete children removed from configuration arrays. A persistent ReadOnly lock still blocks subsequent updates; repeated deployments use CanNotDelete. Upstream RBAC propagation and runtime reachability are separate from successful ARM ordering.

## Review scenarios and evidence

| Scenario | What it demonstrates | Remaining live evaluation |
|---|---|---|
| Defaults | Minimum inputs, Premium, system identity, default-workspace reference, sequential init/idem | Preview region availability, automatic workspace provisioning, repeat deployment |
| Max | Both identity forms; gateway RBAC; lock; network attachment; explicit/generated keys; Foundry/custom providers; three models; 80/20 priority-zero routing plus priority-one target; governance; MCP/OpenAPI; both exporters | All preview child PUT shapes, endpoint connectivity, key behavior, network/subnet requirements, routing/failover semantics |
| WAF-aligned | User-assigned identity, upstream least-privilege RBAC, token/cost governance, content safety, two-model alias, metadata-only monitoring, delete protection | Client authentication, policy scope behavior, enforcement and runtime failure handling; network isolation is not asserted |

All scenarios compile and include sequential initial/idempotency module deployments. The max and WAF scenarios require an existing Foundry account with two deployments. Their dependency modules create identity and monitoring resources, and modify RBAC on that existing account. The max scenario also requires real custom/tool/OTLP endpoints and secure credentials; it is not an unattended deployment with invented placeholder secrets.

Compiled-template checks cover the exact gateway type/SKU constraints, exports and sealed types, alias route fields and bounds, counter dimension casing, exporter defaults, workspace-policy conditions, deployment ordering and secure parameter propagation. These are offline checks, not live policy-enforcement or AVM pipeline results.

## Open questions

1. **AVM public shape:** retain the explicit typed `properties` envelopes and shared secure dictionary, or flatten more fields to match existing resource modules? Resolve before documenting a published contract.
2. **Preview compatibility:** validate every child resource PUT against the target RP, particularly tool endpoint fields, custom provider/model support and alias display-name encoding. The compiler has no preview RP schema to validate those fields.
3. **Workspace scope:** keep the single-entry `default` boundary until named-workspace creation is verified. Extend the name and cardinality constraints only if that capability is established.
4. **Policy breadth and decimal budgets:** the draft intentionally supports token limits, whole-USD cost limits and content safety. Fractional budgets, cost overrides, request-rate limits, fallback, IP/CORS policies, tool-threat protection and agent hooks need explicit scope and wire validation before adding types.
5. **Networking and WAF:** confirm supported regions, virtual network modes, subnet delegation/service requirements and private connectivity surfaces. Do not copy API Management Service private-endpoint or diagnostic settings onto this different resource type without evidence.
6. **Secret/API key lifecycle:** verify service-generated keys are preserved on repeat PUTs when values are omitted, and confirm acceptable explicit key formats and rotation behavior.
7. **AVM admission:** confirm module ownership and naming with AVM maintainers, assign authoritative telemetry metadata, decide child documentation/telemetry requirements, run the full AVM validation pipeline and live idempotency tests, and regenerate release artifacts before submission. The current metadata is a candidate, not an ownership assignment or completed registration.

## References

- Review branch: https://github.com/paulyuk/bicep-registry-modules/tree/feat/aigateway-avm-review/avm/res/api-management/aigateway
- Root source and public type exports: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/main.bicep
- Adjacent AVM resource module: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/api-management/service
- AVM common types: https://github.com/Azure/bicep-registry-modules/tree/main/avm/utl/types/avm-common-types
- AVM Bicep specifications: https://azure.github.io/Azure-Verified-Modules/specs/bicep/
- Public sample hierarchy: https://github.com/Azure-Samples/simple-foundry-hosted-agent-python-aigateway/blob/main/infra/ai-gateway/main.bicep
