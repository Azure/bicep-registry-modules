module testDeployment '../../main.bicep' = {
  name: 'test-macae-waf-aligned'
  params: {
    solutionPrefix: 'macaewaf010'
    solutionLocation: 'australiaeast'
    virtualMachineConfiguration: {
      adminUsername: 'adminuser'
      adminPassword: 'P@ssw0rd1234'
    }
  }
}
