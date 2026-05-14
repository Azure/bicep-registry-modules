# Virtual Hub Route Maps `[Microsoft.Network/virtualHubs/routeMaps]`

This module deploys a Virtual Hub Route Map.

You can reference the module as follows:
```bicep
module virtualHub 'br/public:avm/res/network/virtual-hub/route-map:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/virtualHubs/routeMaps` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_virtualhubs_routemaps.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/virtualHubs/routeMaps)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the route map. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualHubName`](#parameter-virtualhubname) | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedInboundConnections`](#parameter-associatedinboundconnections) | array | List of connections which have this route map associated for inbound traffic. |
| [`associatedOutboundConnections`](#parameter-associatedoutboundconnections) | array | List of connections which have this route map associated for outbound traffic. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`rules`](#parameter-rules) | array | List of route map rules to be applied. |

### Parameter: `name`

The name of the route map.

- Required: Yes
- Type: string

### Parameter: `virtualHubName`

The name of the parent virtual hub. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `associatedInboundConnections`

List of connections which have this route map associated for inbound traffic.

- Required: No
- Type: array

### Parameter: `associatedOutboundConnections`

List of connections which have this route map associated for outbound traffic.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `rules`

List of route map rules to be applied.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-rulesname) | string | The unique name for the rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-rulesactions) | array | List of actions which will be applied on a match. |
| [`matchCriteria`](#parameter-rulesmatchcriteria) | array | List of matching criterion which will be applied to traffic. |
| [`nextStepIfMatched`](#parameter-rulesnextstepifmatched) | string | Next step after rule is evaluated. Current supported behaviors are 'Continue'(to next rule) and 'Terminate'. |

### Parameter: `rules.name`

The unique name for the rule.

- Required: Yes
- Type: string

### Parameter: `rules.actions`

List of actions which will be applied on a match.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`parameters`](#parameter-rulesactionsparameters) | array | List of parameters relevant to the action. |
| [`type`](#parameter-rulesactionstype) | string | Type of action to be taken. Supported types are 'Remove', 'Add', 'Replace', and 'Drop'. |

### Parameter: `rules.actions.parameters`

List of parameters relevant to the action.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`asPath`](#parameter-rulesactionsparametersaspath) | array | List of AS paths. |
| [`community`](#parameter-rulesactionsparameterscommunity) | array | List of BGP communities. |
| [`routePrefix`](#parameter-rulesactionsparametersrouteprefix) | array | List of route prefixes. |

### Parameter: `rules.actions.parameters.asPath`

List of AS paths.

- Required: No
- Type: array

### Parameter: `rules.actions.parameters.community`

List of BGP communities.

- Required: No
- Type: array

### Parameter: `rules.actions.parameters.routePrefix`

List of route prefixes.

- Required: No
- Type: array

### Parameter: `rules.actions.type`

Type of action to be taken. Supported types are 'Remove', 'Add', 'Replace', and 'Drop'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Add'
    'Drop'
    'Remove'
    'Replace'
    'Unknown'
  ]
  ```

### Parameter: `rules.matchCriteria`

List of matching criterion which will be applied to traffic.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`asPath`](#parameter-rulesmatchcriteriaaspath) | array | List of AS paths which this criteria matches. |
| [`community`](#parameter-rulesmatchcriteriacommunity) | array | List of BGP communities which this criteria matches. |
| [`matchCondition`](#parameter-rulesmatchcriteriamatchcondition) | string | Match condition to apply RouteMap rules. |
| [`routePrefix`](#parameter-rulesmatchcriteriarouteprefix) | array | List of route prefixes which this criteria matches. |

### Parameter: `rules.matchCriteria.asPath`

List of AS paths which this criteria matches.

- Required: No
- Type: array

### Parameter: `rules.matchCriteria.community`

List of BGP communities which this criteria matches.

- Required: No
- Type: array

### Parameter: `rules.matchCriteria.matchCondition`

Match condition to apply RouteMap rules.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Contains'
    'Equals'
    'NotContains'
    'NotEquals'
    'Unknown'
  ]
  ```

### Parameter: `rules.matchCriteria.routePrefix`

List of route prefixes which this criteria matches.

- Required: No
- Type: array

### Parameter: `rules.nextStepIfMatched`

Next step after rule is evaluated. Current supported behaviors are 'Continue'(to next rule) and 'Terminate'.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Continue'
    'Terminate'
    'Unknown'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed route map. |
| `resourceGroupName` | string | The resource group the route map was deployed into. |
| `resourceId` | string | The resource ID of the deployed route map. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
