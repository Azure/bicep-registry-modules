module github 'main.bicep' = {
  name: 'deploymen1'
  params: {
    computeTypes: [
      'azure-container-app'
    ]
    namingPrefix: 'sbs'
    privateNetworking: false
    networkingConfiguration: {
      addressSpace: '10.0.0.0/16'
      networkType: 'createNew'
      virtualNetworkName: 'vnet001'
    }
    selfHostedConfig: {
      githubOrganization: 'sebassem-org'
      personalAccessToken: ''
      selfHostedType: 'github'
      runnerScope: 'org'
    }
  }
}

/*var runnerScope = 'repo'
var acaGitHubEnvVariables = union(
  runnerScope == 'repo'
    ? [
        {
          name: 'repoURL'
          value: 'repoURL'
        }
      ]
    : [],
  [
    {
      name: 'RUNNER_NAME_PREFIX'
      value: 'gh-runner'
    }
    {
      name: 'RUNNER_SCOPE'
      value: 'repo'
    }
    {
      name: 'EPHEMERAL'
      value: 'true'
    }
    {
      name: 'RUNNER_GROUP'
      value: 'group1'
    }
    {
      name: 'ACCESS_TOKEN'
      value: 'personal-access-token'
    }
  ]
)

output x array = acaGitHubEnvVariables
*/
