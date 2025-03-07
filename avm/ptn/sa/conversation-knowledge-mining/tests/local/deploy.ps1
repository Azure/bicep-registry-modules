##az deployment group create --resource-group 'avm-dev' --template-file './local.test.bicep'
##Test-AzResourceGroupDeployment -ResourceGroupName 'avm-dev' -TemplateFile './local.test.bicep' -Verbose
New-AzResourceGroupDeployment -ResourceGroupName 'avm-dev' -TemplateFile './local.test.bicep' -DeploymentName 'local-tests' -Verbose
