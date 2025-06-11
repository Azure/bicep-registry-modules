using './main.bicep'

param solutionPrefix = 'macaewaf00'
param solutionLocation = 'australiaeast'
param azureOpenAILocation = 'australiaeast'
param virtualMachineConfiguration = {
  adminUsername: 'adminuser'
  adminPassword: 'P@ssw0rd1234'
}
