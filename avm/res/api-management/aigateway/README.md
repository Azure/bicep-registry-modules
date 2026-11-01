# API Management AI Gateway

Deploy a standalone Azure AI Gateway, register model providers and tools in its default workspace, and give clients a stable model alias with priority and weighted routing.

**Review draft, not a published Azure Verified Module.** This module targets `Microsoft.ApiManagement/aigateways@2025-09-01-preview`. It is separate from the existing API Management `service` module. The preview accepts the `Premium` SKU; this module does not deploy the retired connector gateway resource.

Start with the [shape review](https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/DESIGN.md) before deciding whether to submit the module to AVM. Compilation does not establish live deployment compatibility or AVM certification.

## Minimal deployment

From a checkout containing this module:

```bicep
module gateway './avm/res/api-management/aigateway/main.bicep' = {
  name: 'aigateway'
  params: {
    name: 'my-aigateway'
  }
}
```

This creates a Premium gateway with a system-assigned identity. The resource provider provisions `workspaces/default`; the module references that workspace without writing its policies. It does not create API keys, model providers, tools or runtime telemetry destinations unless requested.

There is no `br/public:avm/res/api-management/aigateway` release to consume yet. Use the local module path while reviewing.

## Two models behind one alias

Use `properties.routes` to route to catalog model names, not to upstream deployment IDs. Lower priority is preferred. Weights are relative within a priority group: these two routes use 80/20 selection at priority zero.

The following example assumes two existing Foundry deployments and a user-assigned identity already granted **Cognitive Services OpenAI User** on that account. Supply a Foundry endpoint with a trailing slash and use a region where the gateway preview is available.

```bicep
param gatewayName string
param foundryAccountResourceId string
param foundryEndpoint string
param primaryDeploymentName string
param secondaryDeploymentName string
param userAssignedIdentityResourceId string
param userAssignedIdentityClientId string

module gateway './avm/res/api-management/aigateway/main.bicep' = {
  name: 'aigateway'
  params: {
    name: gatewayName
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentityResourceId
      ]
    }
    workspaces: [
      {
        name: 'default'
        modelProviders: [
          {
            name: 'foundry'
            properties: {
              kind: 'Foundry'
              displayName: 'Foundry'
              foundry: {
                endpoint: foundryEndpoint
                resourceIds: [
                  foundryAccountResourceId
                ]
                authentication: {
                  kind: 'ManagedIdentity'
                  managedIdentity: {
                    resource: 'https://cognitiveservices.azure.com/'
                    clientId: userAssignedIdentityClientId
                  }
                }
              }
            }
            models: [for deploymentName in [primaryDeploymentName, secondaryDeploymentName]: {
              name: deploymentName
              properties: {
                displayName: deploymentName
                apiFormat: 'OpenAIChatCompletions'
                supportedEndpoints: [
                  '/openai/v1/chat/completions'
                ]
                deployment: {
                  resourceId: '${foundryAccountResourceId}/deployments/${deploymentName}'
                  modelName: deploymentName
                }
              }
            }]
          }
        ]
        aliases: [
          {
            name: 'chat'
            properties: {
              displayName: 'Chat'
              routes: [
                {
                  providerName: 'foundry'
                  modelName: primaryDeploymentName
                  priority: 0
                  weight: 80
                }
                {
                  providerName: 'foundry'
                  modelName: secondaryDeploymentName
                  priority: 0
                  weight: 20
                }
              ]
            }
          }
        ]
      }
    ]
  }
}
```

The gateway creates providers and their models before aliases. A route may also refer to a model already present in the workspace; the service validates its existence.

## Parameters

| Name | Type | Default / meaning |
|---|---|---|
| `name` | `string` | Required; 3-24 characters, lowercase letters, numbers and hyphens |
| `location` | `string` | Resource group location |
| `sku` | `'Premium'` | Only supported preview SKU |
| `tags` | String dictionary | `{}` |
| `managedIdentities` | AVM `managedIdentityAllType` | System-assigned identity enabled; supply `{}` to disable identities |
| `roleAssignments` | AVM `roleAssignmentType[]?` | No gateway-scoped assignments |
| `lock` | AVM `lockType?` | No lock; absent `kind` or `None` also creates no lock |
| `enableTelemetry` | `bool` | `true`; AVM usage telemetry only |
| `virtualNetworkConfiguration` | `virtualNetworkConfigurationType?` | No network attachment |
| `apiKeys` | `apiKeyType[]?` | No API keys |
| `workspaces` | `workspaceType[]` | One entry: `{ name: 'default' }` |
| `secrets` | Secure string dictionary | `{}`; values referenced by child configuration |

Each resource entry has a `name` and strongly typed `properties`; a provider additionally has `models`. A workspace groups `policies`, `modelProviders`, `aliases`, `toolServers` and `telemetryExporters`. Unknown configuration properties are rejected by sealed Bicep types.

`workspaces: []` skips workspace configuration; it does not delete the service-provisioned workspace. The parameter permits at most one `default` entry. `policies: null` leaves workspace policies untouched, while `policies: []` explicitly replaces them with an empty set. Resource deployments use incremental mode; removing a child from an array does not delete a previously deployed child.

Gateway-level `roleAssignments` accepts the common names `Owner`, `Contributor`, `Reader`, `Role Based Access Control Administrator` and `User Access Administrator`, or a role-definition GUID/full resource ID. Other role display names must be resolved to a GUID or resource ID first. These assignments do not grant the gateway access to upstream Foundry accounts.

## Secret inputs and telemetry

Keep credentials out of configuration arrays and source control. For example, a custom provider's `authentication.apiKey` supplies `headerName` and `secretName`; the module looks up `secrets[secretName]` and sends the result as the wire `value`. API keys use `primaryKeySecretName` / `secondaryKeySecretName`, and Application Insights uses `connectionStringSecretName`. Tool headers and OTLP headers also use secret references.

Supply `secrets` from secure parameters or a Key Vault-backed parameter file. An absent referenced secret fails deployment rather than supplying an empty credential. The secure dictionary stays secure through every child deployment. No output lists or regenerates API key values.

Runtime exporters use `kind: 'ApplicationInsights'` or `kind: 'OpenTelemetry'`. `payloadCapture` is a boolean and defaults to `false`. Enabling it can record prompts, completions and tool payloads without built-in PII redaction. For OpenTelemetry, supply at least one complete signal endpoint; the module does not append `/v1/traces`, `/v1/logs` or `/v1/metrics`. Do not configure duplicate header names or both header and managed-identity authentication.

AVM `enableTelemetry` controls the module's empty usage-telemetry deployment, not runtime exporter behavior. The draft emits usage telemetry only at the root; child modules are local components, not independently published modules.

## Outputs

| Name | Type | Meaning |
|---|---|---|
| `resourceId` | `string` | Gateway ARM resource ID |
| `name` | `string` | Gateway resource name |
| `resourceGroupName` | `string` | Gateway resource group |
| `location` | `string` | Gateway region |
| `systemAssignedMIPrincipalId` | `string?` | System-assigned principal, or `null` |
| `defaultHostname` | `string` | `properties.frontend.defaultHostname` from the service |
| `apiKeyResourceIds` | `string[]` | Configured key resource IDs, never values |
| `workspaceResourceIds` | `string[]` | Configured workspace IDs |

Workspace child outputs expose provider, alias, tool server and exporter resource IDs. Provider outputs expose model IDs. Every child also returns `resourceId`, `name` and `resourceGroupName`.

## Review scenarios

| Scenario | Coverage | Deployment prerequisites |
|---|---|---|
| [Defaults](https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/tests/e2e/defaults/main.test.bicep) | Minimum parameters; identity; service-provisioned workspace; sequential initial/idempotency deployment | Preview-enabled subscription and region |
| [Max](https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/tests/e2e/max/main.test.bicep) | Both identities; RBAC; lock; VNet; API keys; Foundry/custom providers; three models; weighted/priority alias; policies; MCP/OpenAPI endpoints; both exporters | Existing Foundry account and two deployments, reachable custom/tool/OTLP endpoints, secure credentials, Reader principal; gateway subnet prerequisites need live confirmation |
| [WAF-aligned](https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/tests/e2e/waf-aligned/main.test.bicep) | User-assigned identity; upstream least-privilege RBAC; budgets; content safety; two-model routing; metadata-only monitoring; delete lock | Existing Foundry account and two deployments; preview-enabled region |

The max and WAF scenarios create their own user-assigned identity and monitoring resources, then grant the identity access to the specified Foundry account before deploying the gateway configuration. Test execution therefore changes RBAC on that external account. They do not create Foundry model deployments or reserve model quota.

All scenarios run `init` and `idem` sequentially. The harness replaces `#_namePrefix_#`; for manual use, supply a short lowercase alphanumeric `namePrefix` and all required parameters. Role-assignment propagation can delay the first runtime call even after ARM deployment completes.

The WAF example demonstrates governance choices, not a security certification, network isolation guarantee or comprehensive WAF assessment. Client authentication, network isolation and failure behavior still require live evaluation. A `ReadOnly` lock blocks later gateway and child updates; use `CanNotDelete` for repeatable deployments. Remove test locks before cleanup and explicitly remove test role assignments on external Foundry accounts.

## Compile and check the draft

Run from `avm/res/api-management/aigateway`:

```bash
az bicep build --file main.bicep
az bicep build --file tests/e2e/defaults/main.test.bicep
az bicep build --file tests/e2e/max/main.test.bicep
az bicep build --file tests/e2e/waf-aligned/main.test.bicep
python3 -m unittest discover -s tests/unit -v
```

These commands compile and inspect templates without creating Azure resources. `BCP081` is suppressed only at the preview resource declarations because the preview resource schemas are not yet in the compiler catalog. Typed module inputs provide compile-time shape checks but do not replace live ARM validation.

## References

- Shape review: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/DESIGN.md
- Adjacent API Management module: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/api-management/service
- AVM Bicep specifications: https://azure.github.io/Azure-Verified-Modules/specs/bicep/
- AVM telemetry: https://aka.ms/avm/TelemetryInfo
- Public sample used for hierarchy context, not as an authoritative preview schema: https://github.com/Azure-Samples/simple-foundry-hosted-agent-python-aigateway/blob/main/infra/ai-gateway/main.bicep
