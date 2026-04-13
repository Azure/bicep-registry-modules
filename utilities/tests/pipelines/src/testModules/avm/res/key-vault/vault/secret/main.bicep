metadata name = 'Child module'
metadata description = 'This is a child module for tests.'

// ================ //
// Parameters       //
// ================ //
@description('Required. An required param.')
@maxLength(24)
param requiredParam string

// =========== //
// Variables   //
// =========== //

var aVariable string = 'oi'

// ============ //
// Dependencies //
// ============ //

resource main 'Microsoft.KeyVault/vaults/secrets@2025-05-01' = {
  name: requiredParam
  properties: {
    value: requiredParam
  }
}

// =========== //
// Outputs     //
// =========== //
@description('An output value.')
output anOutput string = aVariable
