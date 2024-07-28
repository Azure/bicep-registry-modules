# General environment functions `[General/GetEnvironment]`

This module provides you with several functions you can import into your template.

## Navigation

- [Usage examples](#Usage-examples)
- [Exported functions](#Exported-functions)

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

## Exported functions

| Function | Description |
| :-- | :-- |
| `getGraphEndpoint` | Get the graph endpoint for the given environment |
| `getPortalUrl` | Get the Portal URL for the given environment |
