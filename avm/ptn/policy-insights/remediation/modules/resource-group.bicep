metadata name = 'Policy Insights Remediations (Resource Group scope)'
metadata description = 'This module deploys a Policy Insights Remediation on a Resource Group scope.'

targetScope = 'resourceGroup'

// ================ //
// Parameters       //
// ================ //

@sys.description('Required. Specifies the name of the policy remediation.')
param name string

@sys.description('Optional. The remediation failure threshold settings. A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold. 0 means that the remediation will stop after the first failure. 1 means that the remediation will not stop even if all deployments fail.')
param failureThresholdPercentage string = '1'

@sys.description('Optional. The filters that will be applied to determine which resources to remediate.')
param filtersLocations array = []

@sys.description('Optional. Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. Can be between 1-30. Higher values will cause the remediation to complete more quickly, but increase the risk of throttling. If not provided, the default parallel deployments value is used.')
@minValue(1)
@maxValue(30)
param parallelDeployments int = 10

@sys.description('Optional. Determines the max number of resources that can be remediated by the remediation job. Can be between 1-50000. If not provided, the default resource count is used.')
@minValue(1)
@maxValue(50000)
param resourceCount int = 500

@sys.description('Optional. The way resources to remediate are discovered. Defaults to ExistingNonCompliant if not specified.')
@allowed([
  'ExistingNonCompliant'
  'ReEvaluateCompliance'
])
param resourceDiscoveryMode string = 'ExistingNonCompliant'

@sys.description('Required. The resource ID of the policy assignment that should be remediated.')
param policyAssignmentId string

@sys.description('Optional. The policy definition reference ID of the individual definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition.')
param policyDefinitionReferenceId string = ''

@sys.description('Optional. Location deployment metadata.')
param location string = resourceGroup().location

// ================ //
// Resources        //
// ================ //

resource remediation 'Microsoft.PolicyInsights/remediations@2021-10-01' = {
  name: name
  properties: {
    failureThreshold: {
      percentage: json(failureThresholdPercentage) // The json() function is used to allow specifying a decimal value.
    }
    filters: {
      locations: filtersLocations
    }
    parallelDeployments: parallelDeployments
    policyAssignmentId: policyAssignmentId
    policyDefinitionReferenceId: policyDefinitionReferenceId
    resourceCount: resourceCount
    resourceDiscoveryMode: resourceDiscoveryMode
  }
}

// ================ //
// Outputs          //
// ================ //

@sys.description('The name of the remediation.')
output name string = remediation.name

@sys.description('The resource ID of the remediation.')
output resourceId string = remediation.id

@sys.description('The resource group of the deployed remediation.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = location
