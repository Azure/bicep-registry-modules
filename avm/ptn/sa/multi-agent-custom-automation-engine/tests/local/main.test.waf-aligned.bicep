module testDeployment '../../main.waf-aligned.bicep' = {
  name: 'test-macae-waf-aligned'
  params: {
    solutionPrefix: 'macaewaf006'
    solutionLocation: 'australiaeast'
    virtualMachineConfiguration: {
      adminUsername: 'adminuser'
      adminPassword: 'P@ssw0rd1234'
    }
  }
}
