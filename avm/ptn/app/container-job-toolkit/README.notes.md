
The use of Private Endpoints can be activated by setting the `deployInVnet` parameter to `true`. In order to have Private Endpoints enabled, the Azure Container Registry requires the 'Premium' tier, which will be set automatically.

### Configuration

Environment variables and secrets can be deployed by specifying the corresponding parameters. Each secret that is specified in the `secrets` parameter will be added to:

- Key Vault (if `keyVaultUrl` is set) and as secret to the container app secrets
- container app secrets if the `value` has been set

> If a value for the `appInsightsConnectionString` parameter is passed, a secret `applicationinsightsconnectionstring` is automatically added to the container app secrets and as `applicationinsights-connection-string` to Key Vault.

#### Zone Redundancy

[Zone Redundant configuration](https://learn.microsoft.com/en-us/azure/reliability/reliability-azure-container-apps) will be configured automatically if

1. `deployInVnet`has been enabled
2. No `workloadProfile` has been specified, which will deploy the Managed Environment with a Consumption Plan, _and_ an `addressPrefix` has been specified.

