##az deployment group create --resource-group 'avm-dev' --template-file './local.test.bicep'
New-AzResourceGroupDeployment -ResourceGroupName 'avm-dev' -TemplateFile './local.test.bicep' -DeploymentName 'local-tests' -Verbose
