targetScope = 'subscription'

metadata name = 'General'
metadata description = 'This example deploys all available exported functions of the given module.'

// ============== //
// Test Execution //
// ============== //

import { getGraphEndpoint, getPortalUrl } from '../../../main.bicep'

output graphEndpoint string = getGraphEndpoint('AzureCloud')
output portal string = getPortalUrl('AzureCloud')
