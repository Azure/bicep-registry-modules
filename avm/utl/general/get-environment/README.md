# General environment functions `[General/GetEnvironment]`

This module provides you with several functions you can import into your template.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Exported functions](#Exported-functions)
- [Data Collection](#Data-Collection)

## Resource Types

_None_

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/utl/general/get-environment:<version>`.

- [General](#example-1-general)

### Example 1: _General_

This example deploys all available exported functions of the given module.


<details>

<summary>via Bicep module</summary>

```bicep
targetScope = 'subscription'

metadata name = 'General'
metadata description = 'This example deploys all available exported functions of the given module.'

// ============== //
// Test Execution //
// ============== //

// Triggering comme

import { getGraphEndpoint, getPortalUrl } from '../../../main.bicep'

output graphEndpoint string = getGraphEndpoint('AzureCloud')
output portal string = getPortalUrl('AzureCloud')
```

</details>
<p>


## Parameters

_None_

## Outputs

_None_

## Cross-referenced modules

_None_

## Exported functions

| Function | Description |
| :-- | :-- |
| `getGraphEndpoint` | Get the graph endpoint for the given environment |
| `getPortalUrl` | Get the Portal URL for the given environment |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
