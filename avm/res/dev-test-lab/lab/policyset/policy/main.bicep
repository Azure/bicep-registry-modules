metadata name = 'DevTest Lab Policy Sets Policies'
metadata description = '''This module deploys a DevTest Lab Policy Sets Policy.

DevTest lab policies are used to modify the lab settings such as only allowing certain VM Size SKUs, marketplace image types, number of VMs allowed per user and other settings.'''

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@sys.description('Required. The name of the policy.')
param name string

@sys.description('Optional. The description of the policy.')
param description string = ''

@allowed([
  'AllowedValuesPolicy'
  'MaxValuePolicy'
])
@sys.description('Required. The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy).')
param evaluatorType string

@sys.description('Optional. The fact data of the policy.')
param factData string = ''

@allowed([
  'EnvironmentTemplate'
  'GalleryImage'
  'LabPremiumVmCount'
  'LabTargetCost'
  'LabVmCount'
  'LabVmSize'
  'ScheduleEditPermission'
  'UserOwnedLabPremiumVmCount'
  'UserOwnedLabVmCount'
  'UserOwnedLabVmCountInSubnet'
])
@sys.description('Required. The fact name of the policy.')
param factName string

@allowed([
  'Disabled'
  'Enabled'
])
@sys.description('Optional. The status of the policy.')
param status string = 'Enabled'

@sys.description('Required. The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy).')
param threshold string

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName

  resource policySets 'policysets@2018-09-15' existing = {
    name: 'default'
  }
}

resource policy 'Microsoft.DevTestLab/labs/policysets/policies@2018-09-15' = {
  name: name
  parent: lab::policySets
  properties: {
    description: description ?? ''
    evaluatorType: evaluatorType
    factData: factData ?? ''
    factName: factName
    status: status
    threshold: threshold
  }
}

@sys.description('The name of the policy.')
output name string = policy.name

@sys.description('The resource ID of the policy.')
output resourceId string = policy.id

@sys.description('The name of the resource group the policy was created in.')
output resourceGroupName string = resourceGroup().name
