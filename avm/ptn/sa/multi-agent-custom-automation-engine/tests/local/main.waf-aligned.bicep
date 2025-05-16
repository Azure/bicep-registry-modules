module testDeployment '../../main.bicep' = {
  name: 'test-macae-waf-aligned'
  params: {
    solutionPrefix: 'macaewaf013'
    solutionLocation: 'australiaeast'
    virtualMachineConfiguration: {
      //enabled: false
      adminUsername: 'adminuser'
      adminPassword: 'P@ssw0rd1234'
      //enabled: false
    }
  }
}
