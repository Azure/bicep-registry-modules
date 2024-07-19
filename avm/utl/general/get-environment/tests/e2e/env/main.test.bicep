targetScope = 'subscription'

// ============== //
// Test Execution //
// ============== //

import { getGraphEndpoint } from '../../../main.bicep'

output graphEndpoint string = getGraphEndpoint(environment().name)
