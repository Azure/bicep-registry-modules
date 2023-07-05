@description('When performing object replication, it must be true and for source OR Policy and false for sestination OR policy.')
param sourcePolicy bool = objectReplicationPolicy.sourcePolicy ? true: false

@description('When performing object replication, it should contains: source SA name, destination SA names & their resource Ids, array of rules containing source and destination containers & rule ID')
param objectReplicationPolicy objectReplicationPolicyObj = {
  sourcePolicy: false
  policyId: 'default'
  sourceSaId: 'sourceSaId'
  destinationSaId: 'destinationSaId'
  sourceSaName: 'sourceSaName'
  destinationSaName: 'destinationSaName'
  objReplicationRules: [
    {
       destinationContainer: 'destContainer'
       sourceContainer: 'sourceContainer'
       ruleId: null
    }
  ]
}

resource sourceSA 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: objectReplicationPolicy.sourceSaName
  scope: resourceGroup()
}

resource destinationSA 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: objectReplicationPolicy.destinationSaName
  scope: resourceGroup()
}

resource destinationOrPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2022-09-01' = if (!sourcePolicy) {
  name:  objectReplicationPolicy.policyId
  parent: destinationSA
  dependsOn: [
    sourceSA
  ]
  properties: {
      sourceAccount: objectReplicationPolicy.sourceSaId // pass the output of Master SA module for sorageAccount.ID as input here
      destinationAccount: objectReplicationPolicy.destinationSaId // pass the output of Edge SA module for sorageAccount.ID as input here
      rules: objectReplicationPolicy.objReplicationRules
  }
}

resource sourceOrPolicy 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2022-09-01' = if (sourcePolicy) {
  name:  objectReplicationPolicy.policyId
  parent: sourceSA
  dependsOn: [
    destinationSA
  ]
  properties: {
      sourceAccount: objectReplicationPolicy.sourceSaId // pass the output of Master SA module for sorageAccount.ID as input here
      destinationAccount: objectReplicationPolicy.destinationSaId // pass the output of Edge SA module for sorageAccount.ID as input here
      rules: objectReplicationPolicy.objReplicationRules
  }
}

type objReplicationRuelsArray = {
  destinationContainer: string
  sourceContainer: string
  ruleId: string?
}[]

type objectReplicationPolicyObj = {
  policyId: string
  sourceSaId: string
  destinationSaId: string
  sourceSaName: string
  destinationSaName: string
  objReplicationRules: objReplicationRuelsArray
  sourcePolicy: bool
}

output orpIdRules array = objectReplicationPolicy.sourcePolicy ? sourceOrPolicy.properties.rules: destinationOrPolicy.properties.rules 
output orpId string = objectReplicationPolicy.sourcePolicy ? sourceOrPolicy.properties.policyId: destinationOrPolicy.properties.policyId
