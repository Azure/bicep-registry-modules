/**
 * Azure naming module - helps maintaining a consistent naming convention
 * Licensed to use under the MIT license.
 * ----------------------------------------------------------------------------
 * Module repository & documentation: https://github.com/nianton/azure-naming
 * Starter repository template:       https://github.com/nianton/bicep-starter
 * ----------------------------------------------------------------------------
 * Microsoft naming convention best practices (supports user-defined types and compile time imports)
 * https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming
 * ----------------------------------------------------------------------------
 * Generated/built on: 2024-05-02T13:30:03.233Z
 */

metadata name = 'Azure Naming module'
metadata description = 'Module to maintain a consistent naming of Azure resources.'
metadata owner = 'https://github.com/nianton'

@description('Optional. It is not recommended that you use prefix by azure you should be using a suffix for your resources.')
param prefix array = []

@description('Optional. It is recommended that you specify a suffix for consistency. Please use only lowercase characters when possible.')
param suffix array = []

@description('Optional. Custom seed value for the unique string to be created -defaults to resourceGroup Id.')
param uniqueSeed string = resourceGroup().id

@description('Optional. Max length of the uniqueness suffix to be added -defaults to 4')
param uniqueLength int = 4

@description('Optional. Use dashes as separator where applicable -defaults to true')
param useDashes bool = true

@description('Optional. Create names using lowercase letters -defaults to true')
param useLowerCase bool = true

@description('Optional. Used when region abbreviation is needed (placeholder value is "**location**)')
param location string = resourceGroup().location

var uniquePart = substring(uniqueString(uniqueSeed), 0, uniqueLength)
var delimiter = useDashes ? '-' : ''
var locationPlaceholder = '**location**'
var regionAbbreviations = {
  australiacentral: 'auc'
  australiacentral2: 'auc2'
  australiaeast: 'aue'
  australiasoutheast: 'ause'
  brazilsouth: 'brs'
  brazilsoutheast: 'brse'
  brazilus: 'brus'
  canadacentral: 'canc'
  canadaeast: 'cane'
  centralindia: 'cin'
  centralus: 'cus'
  centraluseuap: 'cuseuap'
  eastasia: 'ea'
  eastus: 'eus'
  eastus2: 'eus2'
  eastus2euap: 'eus2euap'
  eastusstg: 'eusstg'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gern'
  germanywestcentral: 'gerwc'
  israelcentral: 'isc'
  italynorth: 'itn'
  japaneast: 'jae'
  japanwest: 'jaw'
  jioindiacentral: 'jioinc'
  jioindiawest: 'jioinw'
  koreacentral: 'koc'
  koreasouth: 'kors'
  mexicocentral: 'mxc'
  northcentralus: 'ncus'
  northeurope: 'neu'
  norwayeast: 'nore'
  norwaywest: 'norw'
  polandcentral: 'polc'
  qatarcentral: 'qatc'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  southeastasia: 'sea'
  southindia: 'sin'
  swedencentral: 'swc'
  switzerlandnorth: 'swn'
  switzerlandwest: 'sww'
  uaecentral: 'uaec'
  uaenorth: 'uaen'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'weu'
  westindia: 'win'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
}

var strPrefixJoined = empty(prefix)
  ? ''
  : '${replace(replace(replace(string(prefix), '["', ''), '"]', ''), '","', delimiter)}${delimiter}'
var strPrefixInterim = useLowerCase ? toLower(strPrefixJoined) : strPrefixJoined
var strPrefix = replace(strPrefixInterim, locationPlaceholder, regionAbbreviations[location])

var strSuffixJoined = empty(suffix)
  ? ''
  : '${delimiter}${replace(replace(replace(string(suffix), '["', ''), '"]', ''), '","', delimiter)}'
var strSuffixInterim = useLowerCase ? toLower(strSuffixJoined) : strSuffixJoined
var strSuffix = replace(strSuffixInterim, locationPlaceholder, regionAbbreviations[location])

var placeholder = '[****]'
var nameTemplate = '${strPrefix}${placeholder}${strSuffix}'
var nameUniqueTemplate = '${strPrefix}${placeholder}${strSuffix}${delimiter}${uniquePart}'
var nameSafeTemplate = toLower(replace(nameTemplate, delimiter, ''))
var nameUniqueSafeTemplate = toLower(replace(nameUniqueTemplate, delimiter, ''))

var d = delimiter
var ph = placeholder
var nt = nameTemplate
var nut = nameUniqueTemplate
var nst = nameSafeTemplate
var nust = nameUniqueSafeTemplate

var names = {
  apiManagement: {
    name: take(replace(nst, ph, 'apim'), 50)
    nameUnique: take(replace(nust, ph, 'apim'), 50)
    slug: 'apim'
  }
  appConfiguration: {
    name: endsWith(take(replace(nt, ph, 'appcg'), 50), d)
      ? take(replace(nt, ph, 'appcg'), 50 - 1)
      : take(replace(nt, ph, 'appcg'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'appcg'), 50), d)
      ? take(replace(nut, ph, 'appcg'), 50 - 1)
      : take(replace(nut, ph, 'appcg'), 50)
    slug: 'appcg'
  }
  appServiceEnvironment: {
    name: endsWith(take(replace(nt, ph, 'ase'), 36), d)
      ? take(replace(nt, ph, 'ase'), 36 - 1)
      : take(replace(nt, ph, 'ase'), 36)
    nameUnique: endsWith(take(replace(nut, ph, 'ase'), 36), d)
      ? take(replace(nut, ph, 'ase'), 36 - 1)
      : take(replace(nut, ph, 'ase'), 36)
    slug: 'ase'
  }
  appServicePlan: {
    name: endsWith(take(replace(nt, ph, 'plan'), 40), d)
      ? take(replace(nt, ph, 'plan'), 40 - 1)
      : take(replace(nt, ph, 'plan'), 40)
    nameUnique: endsWith(take(replace(nut, ph, 'plan'), 40), d)
      ? take(replace(nut, ph, 'plan'), 40 - 1)
      : take(replace(nut, ph, 'plan'), 40)
    slug: 'plan'
  }
  appService: {
    name: endsWith(take(replace(nt, ph, 'app'), 60), d)
      ? take(replace(nt, ph, 'app'), 60 - 1)
      : take(replace(nt, ph, 'app'), 60)
    nameUnique: endsWith(take(replace(nut, ph, 'app'), 60), d)
      ? take(replace(nut, ph, 'app'), 60 - 1)
      : take(replace(nut, ph, 'app'), 60)
    slug: 'app'
  }
  applicationGateway: {
    name: endsWith(take(replace(nt, ph, 'agw'), 80), d)
      ? take(replace(nt, ph, 'agw'), 80 - 1)
      : take(replace(nt, ph, 'agw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'agw'), 80), d)
      ? take(replace(nut, ph, 'agw'), 80 - 1)
      : take(replace(nut, ph, 'agw'), 80)
    slug: 'agw'
  }
  applicationInsights: {
    name: endsWith(take(replace(nt, ph, 'appi'), 260), d)
      ? take(replace(nt, ph, 'appi'), 260 - 1)
      : take(replace(nt, ph, 'appi'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'appi'), 260), d)
      ? take(replace(nut, ph, 'appi'), 260 - 1)
      : take(replace(nut, ph, 'appi'), 260)
    slug: 'appi'
  }
  applicationSecurityGroup: {
    name: endsWith(take(replace(nt, ph, 'asg'), 80), d)
      ? take(replace(nt, ph, 'asg'), 80 - 1)
      : take(replace(nt, ph, 'asg'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'asg'), 80), d)
      ? take(replace(nut, ph, 'asg'), 80 - 1)
      : take(replace(nut, ph, 'asg'), 80)
    slug: 'asg'
  }
  bastionHost: {
    name: endsWith(take(replace(nt, ph, 'bas'), 80), d)
      ? take(replace(nt, ph, 'bas'), 80 - 1)
      : take(replace(nt, ph, 'bas'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'bas'), 80), d)
      ? take(replace(nut, ph, 'bas'), 80 - 1)
      : take(replace(nut, ph, 'bas'), 80)
    slug: 'bas'
  }
  cdnEndpoint: {
    name: endsWith(take(replace(nt, ph, 'cdn'), 50), d)
      ? take(replace(nt, ph, 'cdn'), 50 - 1)
      : take(replace(nt, ph, 'cdn'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'cdn'), 50), d)
      ? take(replace(nut, ph, 'cdn'), 50 - 1)
      : take(replace(nut, ph, 'cdn'), 50)
    slug: 'cdn'
  }
  cdnProfile: {
    name: endsWith(take(replace(nt, ph, 'cdnprof'), 260), d)
      ? take(replace(nt, ph, 'cdnprof'), 260 - 1)
      : take(replace(nt, ph, 'cdnprof'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'cdnprof'), 260), d)
      ? take(replace(nut, ph, 'cdnprof'), 260 - 1)
      : take(replace(nut, ph, 'cdnprof'), 260)
    slug: 'cdnprof'
  }
  containerRegistry: {
    name: take(replace(nst, ph, 'acr'), 63)
    nameUnique: take(replace(nust, ph, 'acr'), 63)
    slug: 'acr'
  }
  containerRegistryWebhook: {
    name: take(replace(nst, ph, 'crwh'), 50)
    nameUnique: take(replace(nust, ph, 'crwh'), 50)
    slug: 'crwh'
  }
  dnsZone: {
    name: endsWith(take(replace(nt, ph, 'dns'), 63), d)
      ? take(replace(nt, ph, 'dns'), 63 - 1)
      : take(replace(nt, ph, 'dns'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'dns'), 63), d)
      ? take(replace(nut, ph, 'dns'), 63 - 1)
      : take(replace(nut, ph, 'dns'), 63)
    slug: 'dns'
  }
  firewall: {
    name: endsWith(take(replace(nt, ph, 'afw'), 80), d)
      ? take(replace(nt, ph, 'afw'), 80 - 1)
      : take(replace(nt, ph, 'afw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'afw'), 80), d)
      ? take(replace(nut, ph, 'afw'), 80 - 1)
      : take(replace(nut, ph, 'afw'), 80)
    slug: 'afw'
  }
  firewallPolicy: {
    name: endsWith(take(replace(nt, ph, 'afwp'), 80), d)
      ? take(replace(nt, ph, 'afwp'), 80 - 1)
      : take(replace(nt, ph, 'afwp'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'afwp'), 80), d)
      ? take(replace(nut, ph, 'afwp'), 80 - 1)
      : take(replace(nut, ph, 'afwp'), 80)
    slug: 'afwp'
  }
  frontDoor: {
    name: endsWith(take(replace(nt, ph, 'fd'), 64), d)
      ? take(replace(nt, ph, 'fd'), 64 - 1)
      : take(replace(nt, ph, 'fd'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'fd'), 64), d)
      ? take(replace(nut, ph, 'fd'), 64 - 1)
      : take(replace(nut, ph, 'fd'), 64)
    slug: 'fd'
  }
  frontDoorFirewallPolicy: {
    name: endsWith(take(replace(nt, ph, 'fdfw'), 80), d)
      ? take(replace(nt, ph, 'fdfw'), 80 - 1)
      : take(replace(nt, ph, 'fdfw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'fdfw'), 80), d)
      ? take(replace(nut, ph, 'fdfw'), 80 - 1)
      : take(replace(nut, ph, 'fdfw'), 80)
    slug: 'fdfw'
  }
  keyVault: {
    name: endsWith(take(replace(nt, ph, 'kv'), 24), d)
      ? take(replace(nt, ph, 'kv'), 24 - 1)
      : take(replace(nt, ph, 'kv'), 24)
    nameUnique: endsWith(take(replace(nut, ph, 'kv'), 24), d)
      ? take(replace(nut, ph, 'kv'), 24 - 1)
      : take(replace(nut, ph, 'kv'), 24)
    slug: 'kv'
  }
  keyVaultCertificate: {
    name: endsWith(take(replace(nt, ph, 'kvc'), 127), d)
      ? take(replace(nt, ph, 'kvc'), 127 - 1)
      : take(replace(nt, ph, 'kvc'), 127)
    nameUnique: endsWith(take(replace(nut, ph, 'kvc'), 127), d)
      ? take(replace(nut, ph, 'kvc'), 127 - 1)
      : take(replace(nut, ph, 'kvc'), 127)
    slug: 'kvc'
  }
  keyVaultKey: {
    name: endsWith(take(replace(nt, ph, 'kvk'), 127), d)
      ? take(replace(nt, ph, 'kvk'), 127 - 1)
      : take(replace(nt, ph, 'kvk'), 127)
    nameUnique: endsWith(take(replace(nut, ph, 'kvk'), 127), d)
      ? take(replace(nut, ph, 'kvk'), 127 - 1)
      : take(replace(nut, ph, 'kvk'), 127)
    slug: 'kvk'
  }
  keyVaultSecret: {
    name: endsWith(take(replace(nt, ph, 'kvs'), 127), d)
      ? take(replace(nt, ph, 'kvs'), 127 - 1)
      : take(replace(nt, ph, 'kvs'), 127)
    nameUnique: endsWith(take(replace(nut, ph, 'kvs'), 127), d)
      ? take(replace(nut, ph, 'kvs'), 127 - 1)
      : take(replace(nut, ph, 'kvs'), 127)
    slug: 'kvs'
  }
  linuxVirtualMachine: {
    name: endsWith(take(replace(nt, ph, 'vm'), 64), d)
      ? take(replace(nt, ph, 'vm'), 64 - 1)
      : take(replace(nt, ph, 'vm'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'vm'), 64), d)
      ? take(replace(nut, ph, 'vm'), 64 - 1)
      : take(replace(nut, ph, 'vm'), 64)
    slug: 'vm'
  }
  logAnalyticsWorkspace: {
    name: endsWith(take(replace(nt, ph, 'log'), 63), d)
      ? take(replace(nt, ph, 'log'), 63 - 1)
      : take(replace(nt, ph, 'log'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'log'), 63), d)
      ? take(replace(nut, ph, 'log'), 63 - 1)
      : take(replace(nut, ph, 'log'), 63)
    slug: 'log'
  }
  managedIdentity: {
    name: endsWith(take(replace(nt, ph, 'id'), 128), d)
      ? take(replace(nt, ph, 'id'), 128 - 1)
      : take(replace(nt, ph, 'id'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'id'), 128), d)
      ? take(replace(nut, ph, 'id'), 128 - 1)
      : take(replace(nut, ph, 'id'), 128)
    slug: 'id'
  }
  networkInterface: {
    name: endsWith(take(replace(nt, ph, 'nic'), 80), d)
      ? take(replace(nt, ph, 'nic'), 80 - 1)
      : take(replace(nt, ph, 'nic'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'nic'), 80), d)
      ? take(replace(nut, ph, 'nic'), 80 - 1)
      : take(replace(nut, ph, 'nic'), 80)
    slug: 'nic'
  }
  networkSecurityGroup: {
    name: endsWith(take(replace(nt, ph, 'nsg'), 80), d)
      ? take(replace(nt, ph, 'nsg'), 80 - 1)
      : take(replace(nt, ph, 'nsg'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'nsg'), 80), d)
      ? take(replace(nut, ph, 'nsg'), 80 - 1)
      : take(replace(nut, ph, 'nsg'), 80)
    slug: 'nsg'
  }
  networkSecurityGroupRule: {
    name: endsWith(take(replace(nt, ph, 'nsgr'), 80), d)
      ? take(replace(nt, ph, 'nsgr'), 80 - 1)
      : take(replace(nt, ph, 'nsgr'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'nsgr'), 80), d)
      ? take(replace(nut, ph, 'nsgr'), 80 - 1)
      : take(replace(nut, ph, 'nsgr'), 80)
    slug: 'nsgr'
  }
  networkSecurityRule: {
    name: endsWith(take(replace(nt, ph, 'nsgr'), 80), d)
      ? take(replace(nt, ph, 'nsgr'), 80 - 1)
      : take(replace(nt, ph, 'nsgr'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'nsgr'), 80), d)
      ? take(replace(nut, ph, 'nsgr'), 80 - 1)
      : take(replace(nut, ph, 'nsgr'), 80)
    slug: 'nsgr'
  }
  privateDnsZone: {
    name: endsWith(take(replace(nt, ph, 'pdns'), 63), d)
      ? take(replace(nt, ph, 'pdns'), 63 - 1)
      : take(replace(nt, ph, 'pdns'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'pdns'), 63), d)
      ? take(replace(nut, ph, 'pdns'), 63 - 1)
      : take(replace(nut, ph, 'pdns'), 63)
    slug: 'pdns'
  }
  publicIp: {
    name: endsWith(take(replace(nt, ph, 'pip'), 80), d)
      ? take(replace(nt, ph, 'pip'), 80 - 1)
      : take(replace(nt, ph, 'pip'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'pip'), 80), d)
      ? take(replace(nut, ph, 'pip'), 80 - 1)
      : take(replace(nut, ph, 'pip'), 80)
    slug: 'pip'
  }
  resourceGroup: {
    name: endsWith(take(replace(nt, ph, 'rg'), 90), d)
      ? take(replace(nt, ph, 'rg'), 90 - 1)
      : take(replace(nt, ph, 'rg'), 90)
    nameUnique: endsWith(take(replace(nut, ph, 'rg'), 90), d)
      ? take(replace(nut, ph, 'rg'), 90 - 1)
      : take(replace(nut, ph, 'rg'), 90)
    slug: 'rg'
  }
  roleAssignment: {
    name: endsWith(take(replace(nt, ph, 'ra'), 64), d)
      ? take(replace(nt, ph, 'ra'), 64 - 1)
      : take(replace(nt, ph, 'ra'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'ra'), 64), d)
      ? take(replace(nut, ph, 'ra'), 64 - 1)
      : take(replace(nut, ph, 'ra'), 64)
    slug: 'ra'
  }
  roleDefinition: {
    name: endsWith(take(replace(nt, ph, 'rd'), 64), d)
      ? take(replace(nt, ph, 'rd'), 64 - 1)
      : take(replace(nt, ph, 'rd'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'rd'), 64), d)
      ? take(replace(nut, ph, 'rd'), 64 - 1)
      : take(replace(nut, ph, 'rd'), 64)
    slug: 'rd'
  }
  route: {
    name: endsWith(take(replace(nt, ph, 'rt'), 80), d)
      ? take(replace(nt, ph, 'rt'), 80 - 1)
      : take(replace(nt, ph, 'rt'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'rt'), 80), d)
      ? take(replace(nut, ph, 'rt'), 80 - 1)
      : take(replace(nut, ph, 'rt'), 80)
    slug: 'rt'
  }
  routeTable: {
    name: endsWith(take(replace(nt, ph, 'route'), 80), d)
      ? take(replace(nt, ph, 'route'), 80 - 1)
      : take(replace(nt, ph, 'route'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'route'), 80), d)
      ? take(replace(nut, ph, 'route'), 80 - 1)
      : take(replace(nut, ph, 'route'), 80)
    slug: 'route'
  }
  subnet: {
    name: endsWith(take(replace(nt, ph, 'snet'), 80), d)
      ? take(replace(nt, ph, 'snet'), 80 - 1)
      : take(replace(nt, ph, 'snet'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'snet'), 80), d)
      ? take(replace(nut, ph, 'snet'), 80 - 1)
      : take(replace(nut, ph, 'snet'), 80)
    slug: 'snet'
  }
  templateDeployment: {
    name: endsWith(take(replace(nt, ph, 'deploy'), 64), d)
      ? take(replace(nt, ph, 'deploy'), 64 - 1)
      : take(replace(nt, ph, 'deploy'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'deploy'), 64), d)
      ? take(replace(nut, ph, 'deploy'), 64 - 1)
      : take(replace(nut, ph, 'deploy'), 64)
    slug: 'deploy'
  }
  virtualMachine: {
    name: endsWith(take(replace(nt, ph, 'vm'), 15), d)
      ? take(replace(nt, ph, 'vm'), 15 - 1)
      : take(replace(nt, ph, 'vm'), 15)
    nameUnique: endsWith(take(replace(nut, ph, 'vm'), 15), d)
      ? take(replace(nut, ph, 'vm'), 15 - 1)
      : take(replace(nut, ph, 'vm'), 15)
    slug: 'vm'
  }
  virtualNetwork: {
    name: endsWith(take(replace(nt, ph, 'vnet'), 64), d)
      ? take(replace(nt, ph, 'vnet'), 64 - 1)
      : take(replace(nt, ph, 'vnet'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'vnet'), 64), d)
      ? take(replace(nut, ph, 'vnet'), 64 - 1)
      : take(replace(nut, ph, 'vnet'), 64)
    slug: 'vnet'
  }
  virtualNetworkGateway: {
    name: endsWith(take(replace(nt, ph, 'vgw'), 80), d)
      ? take(replace(nt, ph, 'vgw'), 80 - 1)
      : take(replace(nt, ph, 'vgw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'vgw'), 80), d)
      ? take(replace(nut, ph, 'vgw'), 80 - 1)
      : take(replace(nut, ph, 'vgw'), 80)
    slug: 'vgw'
  }
  virtualNetworkPeering: {
    name: endsWith(take(replace(nt, ph, 'vpeer'), 80), d)
      ? take(replace(nt, ph, 'vpeer'), 80 - 1)
      : take(replace(nt, ph, 'vpeer'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'vpeer'), 80), d)
      ? take(replace(nut, ph, 'vpeer'), 80 - 1)
      : take(replace(nut, ph, 'vpeer'), 80)
    slug: 'vpeer'
  }
  windowsVirtualMachine: {
    name: endsWith(take(replace(nt, ph, 'vm'), 15), d)
      ? take(replace(nt, ph, 'vm'), 15 - 1)
      : take(replace(nt, ph, 'vm'), 15)
    nameUnique: endsWith(take(replace(nut, ph, 'vm'), 15), d)
      ? take(replace(nut, ph, 'vm'), 15 - 1)
      : take(replace(nut, ph, 'vm'), 15)
    slug: 'vm'
  }
}

output names NamingOutput = names
output regionAbbreviations object = regionAbbreviations

// ================== //
//  Type Definitions  //
// ================== //

@export()
type ServiceNameType = {
  name: string
  nameUnique: string
  slug: string
}

@export()
type NamingOutput = {
  apiManagement: ServiceNameType
  appConfiguration: ServiceNameType
  appServiceEnvironment: ServiceNameType
  appServicePlan: ServiceNameType
  appService: ServiceNameType
  applicationGateway: ServiceNameType
  applicationInsights: ServiceNameType
  applicationSecurityGroup: ServiceNameType
  bastionHost: ServiceNameType
  cdnEndpoint: ServiceNameType
  cdnProfile: ServiceNameType
  containerRegistry: ServiceNameType
  containerRegistryWebhook: ServiceNameType
  dnsZone: ServiceNameType
  firewall: ServiceNameType
  firewallPolicy: ServiceNameType
  frontDoor: ServiceNameType
  frontDoorFirewallPolicy: ServiceNameType
  keyVault: ServiceNameType
  keyVaultCertificate: ServiceNameType
  keyVaultKey: ServiceNameType
  keyVaultSecret: ServiceNameType
  linuxVirtualMachine: ServiceNameType
  logAnalyticsWorkspace: ServiceNameType
  managedIdentity: ServiceNameType
  networkInterface: ServiceNameType
  networkSecurityGroup: ServiceNameType
  networkSecurityGroupRule: ServiceNameType
  networkSecurityRule: ServiceNameType
  privateDnsZone: ServiceNameType
  publicIp: ServiceNameType
  resourceGroup: ServiceNameType
  roleAssignment: ServiceNameType
  roleDefinition: ServiceNameType
  route: ServiceNameType
  routeTable: ServiceNameType
  subnet: ServiceNameType
  templateDeployment: ServiceNameType
  virtualMachine: ServiceNameType
  virtualNetwork: ServiceNameType
  virtualNetworkGateway: ServiceNameType
  virtualNetworkPeering: ServiceNameType
  windowsVirtualMachine: ServiceNameType
}
