targetScope = 'subscription'

// ============== //
// Test Execution //
// ============== //

import { getGraphEndpoint, getPortalUrl } from '../../../main.bicep'

output graphEndpoint string = getGraphEndpoint('AzureCloud')
output portal string = getPortalUrl('AzureCloud')
