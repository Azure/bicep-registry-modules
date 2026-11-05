# AI Gateway alias

Workspace-scoped alias component using the preview `routes` contract. Routes identify catalog models by `providerName` and `modelName`.

Inputs: required `aiGatewayName`, `workspaceName`, `name`, typed `properties`. Lower priority is preferred; weight is relative within each priority group. Omitted priority defaults to zero and weight to one. The root workspace component waits for model registrations before deploying aliases.

Outputs: `resourceId`, `name`, `resourceGroupName`.

Public exports: `aliasType`, `aliasPropertiesType`, `routeType`. `backendModels` is deliberately not accepted for this preview draft.

Root contract and preview limitations: https://github.com/paulyuk/bicep-registry-modules/blob/feat/aigateway-avm-review/avm/res/api-management/aigateway/README.md
