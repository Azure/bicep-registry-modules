@description('Required. The names of the Arc-enabled machines in this resource group.')
param machineNames string[]

resource arcMachines 'Microsoft.HybridCompute/machines@2026-07-15' existing = [
  for machineName in machineNames: {
    name: machineName
  }
]

@description('The principal IDs of the machines\' system-assigned identities, in the order of the machine names.')
output principalIds string[] = [for (machineName, i) in machineNames: arcMachines[i].identity!.principalId!]
