@description('Required. The Resource ID or name of an existing resource.')
param resourceIdOrName string

var resourceParts = split(resourceIdOrName, '/')
var name = !empty(resourceParts) ? last(resourceParts) : resourceIdOrName
var subscriptionId = length(resourceParts) > 2 ? resourceParts[2] : subscription().subscriptionId
var resourceGroupName = length(resourceParts) > 4 ? resourceParts[4] : resourceGroup().name

@description('Name of the resource.')
output name string = name

@description('Subscription ID of the resource.')
output subscriptionId string = subscriptionId

@description('Resource Group Name of the resource.')
output resourceGroupName string = resourceGroupName
