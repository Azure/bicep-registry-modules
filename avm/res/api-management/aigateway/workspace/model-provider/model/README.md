# AI Gateway catalog model

Provider-scoped model component with deployment metadata, API format, supported runtime endpoints and optional governance policies.

Inputs: required `aiGatewayName`, `workspaceName`, `modelProviderName`, `name`, typed `properties`. Registering a model does not create its upstream Foundry deployment.

Outputs: `resourceId`, `name`, `resourceGroupName`.

Public exports: `modelType`, `modelPropertiesType`, `policyType`, `tokenLimitPolicyType`, `costLimitPolicyType`, `contentSafetyPolicyType`. Cost amounts are positive whole USD in this draft; token/cost counters use arrays of camelCase public dimensions.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
