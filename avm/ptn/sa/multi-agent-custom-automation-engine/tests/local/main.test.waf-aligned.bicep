module testDeployment '../../main.waf-aligned.bicep' = {
  name: 'test-macae-waf-aligned'
  params: {
    solutionPrefix: 'macaewaf005'
    solutionLocation: 'australiaeast'
    virtualMachineConfiguration: {
      adminUsername: 'adminuser'
      adminPassword: 'P@ssw0rd1234'
    }
  }
}
