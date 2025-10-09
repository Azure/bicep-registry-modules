metadata name = 'DevTest Lab Secrets'
metadata description = '''This module deploys a DevTest Lab Secret.

Lab secrets will be accessible to all lab users. Depending on their scope, secrets can be used to securely provide credentials when creating formulas, virtual machines, artifacts, or ARM templates.'''

@sys.description('Conditional. The name of the parent lab. Required if the template is used in a standalone deployment.')
param labName string

@sys.description('Required. The name of the secret. Secret names can only contain alphanumeric characters and dashes.')
param name string

@secure()
@sys.description('Required. The value of the secret.')
param value string

@sys.description('Optional. Set a secret for your artifacts (e.g., a personal access token to clone your Git repository via an artifact). At least one of the following must be true: enabledForArtifacts, enabledForVmCreation.')
param enabledForArtifacts bool = false

@sys.description('Optional. Set a user password or provide an SSH public key to access your Windows or Linux virtual machines. At least one of the following must be true: enabledForArtifacts, enabledForVmCreation.')
param enabledForVmCreation bool = false

resource lab 'Microsoft.DevTestLab/labs@2018-09-15' existing = {
  name: labName
}

resource secret 'Microsoft.DevTestLab/labs/secrets@2018-10-15-preview' = {
  name: name
  parent: lab
  properties: {
    enabledForArtifacts: enabledForArtifacts
    enabledForVmCreation: enabledForVmCreation
    value: value
  }
}

@sys.description('The name of the secret.')
output name string = secret.name

@sys.description('The resource ID of the secret.')
output resourceId string = secret.id

@sys.description('The name of the resource group the secret was created in.')
output resourceGroupName string = resourceGroup().name
