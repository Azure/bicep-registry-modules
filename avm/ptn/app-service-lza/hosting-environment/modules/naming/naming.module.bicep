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
  aiSearch: {
    name: endsWith(take(replace(nt, ph, 'srch'), 60), d)
      ? take(replace(nt, ph, 'srch'), 60 - 1)
      : take(replace(nt, ph, 'srch'), 60)
    nameUnique: endsWith(take(replace(nut, ph, 'srch'), 60), d)
      ? take(replace(nut, ph, 'srch'), 60 - 1)
      : take(replace(nut, ph, 'srch'), 60)
    slug: 'srch'
  }
  analysisServicesServer: {
    name: take(replace(nst, ph, 'as'), 63)
    nameUnique: take(replace(nust, ph, 'as'), 63)
    slug: 'as'
  }
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
  automationAccount: {
    name: endsWith(take(replace(nt, ph, 'aa'), 50), d)
      ? take(replace(nt, ph, 'aa'), 50 - 1)
      : take(replace(nt, ph, 'aa'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'aa'), 50), d)
      ? take(replace(nut, ph, 'aa'), 50 - 1)
      : take(replace(nut, ph, 'aa'), 50)
    slug: 'aa'
  }
  automationCertificate: {
    name: endsWith(take(replace(nt, ph, 'aacert'), 128), d)
      ? take(replace(nt, ph, 'aacert'), 128 - 1)
      : take(replace(nt, ph, 'aacert'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'aacert'), 128), d)
      ? take(replace(nut, ph, 'aacert'), 128 - 1)
      : take(replace(nut, ph, 'aacert'), 128)
    slug: 'aacert'
  }
  automationCredential: {
    name: endsWith(take(replace(nt, ph, 'aacred'), 128), d)
      ? take(replace(nt, ph, 'aacred'), 128 - 1)
      : take(replace(nt, ph, 'aacred'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'aacred'), 128), d)
      ? take(replace(nut, ph, 'aacred'), 128 - 1)
      : take(replace(nut, ph, 'aacred'), 128)
    slug: 'aacred'
  }
  automationRunbook: {
    name: endsWith(take(replace(nt, ph, 'aacred'), 63), d)
      ? take(replace(nt, ph, 'aacred'), 63 - 1)
      : take(replace(nt, ph, 'aacred'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'aacred'), 63), d)
      ? take(replace(nut, ph, 'aacred'), 63 - 1)
      : take(replace(nut, ph, 'aacred'), 63)
    slug: 'aacred'
  }
  automationSchedule: {
    name: endsWith(take(replace(nt, ph, 'aasched'), 128), d)
      ? take(replace(nt, ph, 'aasched'), 128 - 1)
      : take(replace(nt, ph, 'aasched'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'aasched'), 128), d)
      ? take(replace(nut, ph, 'aasched'), 128 - 1)
      : take(replace(nut, ph, 'aasched'), 128)
    slug: 'aasched'
  }
  automationVariable: {
    name: endsWith(take(replace(nt, ph, 'aavar'), 128), d)
      ? take(replace(nt, ph, 'aavar'), 128 - 1)
      : take(replace(nt, ph, 'aavar'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'aavar'), 128), d)
      ? take(replace(nut, ph, 'aavar'), 128 - 1)
      : take(replace(nut, ph, 'aavar'), 128)
    slug: 'aavar'
  }
  availabilitySet: {
    name: endsWith(take(replace(nt, ph, 'avail'), 80), d)
      ? take(replace(nt, ph, 'avail'), 80 - 1)
      : take(replace(nt, ph, 'avail'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'avail'), 80), d)
      ? take(replace(nut, ph, 'avail'), 80 - 1)
      : take(replace(nut, ph, 'avail'), 80)
    slug: 'avail'
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
  batchAccount: {
    name: take(replace(nst, ph, 'ba'), 24)
    nameUnique: take(replace(nust, ph, 'ba'), 24)
    slug: 'ba'
  }
  batchApplication: {
    name: endsWith(take(replace(nt, ph, 'baapp'), 64), d)
      ? take(replace(nt, ph, 'baapp'), 64 - 1)
      : take(replace(nt, ph, 'baapp'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'baapp'), 64), d)
      ? take(replace(nut, ph, 'baapp'), 64 - 1)
      : take(replace(nut, ph, 'baapp'), 64)
    slug: 'baapp'
  }
  batchCertificate: {
    name: endsWith(take(replace(nt, ph, 'bacert'), 45), d)
      ? take(replace(nt, ph, 'bacert'), 45 - 1)
      : take(replace(nt, ph, 'bacert'), 45)
    nameUnique: endsWith(take(replace(nut, ph, 'bacert'), 45), d)
      ? take(replace(nut, ph, 'bacert'), 45 - 1)
      : take(replace(nut, ph, 'bacert'), 45)
    slug: 'bacert'
  }
  batchPool: {
    name: endsWith(take(replace(nt, ph, 'bapool'), 24), d)
      ? take(replace(nt, ph, 'bapool'), 24 - 1)
      : take(replace(nt, ph, 'bapool'), 24)
    nameUnique: endsWith(take(replace(nut, ph, 'bapool'), 24), d)
      ? take(replace(nut, ph, 'bapool'), 24 - 1)
      : take(replace(nut, ph, 'bapool'), 24)
    slug: 'bapool'
  }
  botChannelDirectline: {
    name: endsWith(take(replace(nt, ph, 'botline'), 64), d)
      ? take(replace(nt, ph, 'botline'), 64 - 1)
      : take(replace(nt, ph, 'botline'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'botline'), 64), d)
      ? take(replace(nut, ph, 'botline'), 64 - 1)
      : take(replace(nut, ph, 'botline'), 64)
    slug: 'botline'
  }
  botChannelEmail: {
    name: endsWith(take(replace(nt, ph, 'botmail'), 64), d)
      ? take(replace(nt, ph, 'botmail'), 64 - 1)
      : take(replace(nt, ph, 'botmail'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'botmail'), 64), d)
      ? take(replace(nut, ph, 'botmail'), 64 - 1)
      : take(replace(nut, ph, 'botmail'), 64)
    slug: 'botmail'
  }
  botChannelMsTeams: {
    name: endsWith(take(replace(nt, ph, 'botteams'), 64), d)
      ? take(replace(nt, ph, 'botteams'), 64 - 1)
      : take(replace(nt, ph, 'botteams'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'botteams'), 64), d)
      ? take(replace(nut, ph, 'botteams'), 64 - 1)
      : take(replace(nut, ph, 'botteams'), 64)
    slug: 'botteams'
  }
  botChannelSlack: {
    name: endsWith(take(replace(nt, ph, 'botslack'), 64), d)
      ? take(replace(nt, ph, 'botslack'), 64 - 1)
      : take(replace(nt, ph, 'botslack'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'botslack'), 64), d)
      ? take(replace(nut, ph, 'botslack'), 64 - 1)
      : take(replace(nut, ph, 'botslack'), 64)
    slug: 'botslack'
  }
  botChannelsRegistration: {
    name: endsWith(take(replace(nt, ph, 'botchan'), 64), d)
      ? take(replace(nt, ph, 'botchan'), 64 - 1)
      : take(replace(nt, ph, 'botchan'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'botchan'), 64), d)
      ? take(replace(nut, ph, 'botchan'), 64 - 1)
      : take(replace(nut, ph, 'botchan'), 64)
    slug: 'botchan'
  }
  botConnection: {
    name: endsWith(take(replace(nt, ph, 'botcon'), 64), d)
      ? take(replace(nt, ph, 'botcon'), 64 - 1)
      : take(replace(nt, ph, 'botcon'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'botcon'), 64), d)
      ? take(replace(nut, ph, 'botcon'), 64 - 1)
      : take(replace(nut, ph, 'botcon'), 64)
    slug: 'botcon'
  }
  botWebApp: {
    name: endsWith(take(replace(nt, ph, 'bot'), 64), d)
      ? take(replace(nt, ph, 'bot'), 64 - 1)
      : take(replace(nt, ph, 'bot'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'bot'), 64), d)
      ? take(replace(nut, ph, 'bot'), 64 - 1)
      : take(replace(nut, ph, 'bot'), 64)
    slug: 'bot'
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
  chaosExperiment: {
    name: endsWith(take(replace(nt, ph, 'chaosexp'), 128), d)
      ? take(replace(nt, ph, 'chaosexp'), 128 - 1)
      : take(replace(nt, ph, 'chaosexp'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'chaosexp'), 128), d)
      ? take(replace(nut, ph, 'chaosexp'), 128 - 1)
      : take(replace(nut, ph, 'chaosexp'), 128)
    slug: 'chaosexp'
  }
  chaosTarget: {
    name: endsWith(take(replace(nt, ph, 'chaostarget'), 128), d)
      ? take(replace(nt, ph, 'chaostarget'), 128 - 1)
      : take(replace(nt, ph, 'chaostarget'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'chaostarget'), 128), d)
      ? take(replace(nut, ph, 'chaostarget'), 128 - 1)
      : take(replace(nut, ph, 'chaostarget'), 128)
    slug: 'chaostarget'
  }
  cognitiveAccount: {
    name: endsWith(take(replace(nt, ph, 'cog'), 64), d)
      ? take(replace(nt, ph, 'cog'), 64 - 1)
      : take(replace(nt, ph, 'cog'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cog'), 64), d)
      ? take(replace(nut, ph, 'cog'), 64 - 1)
      : take(replace(nut, ph, 'cog'), 64)
    slug: 'cog'
  }
  cognitiveServicesOpenAi: {
    name: endsWith(take(replace(nt, ph, 'oai'), 64), d)
      ? take(replace(nt, ph, 'oai'), 64 - 1)
      : take(replace(nt, ph, 'oai'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'oai'), 64), d)
      ? take(replace(nut, ph, 'oai'), 64 - 1)
      : take(replace(nut, ph, 'oai'), 64)
    slug: 'oai'
  }
  cognitiveServicesComputerVision: {
    name: endsWith(take(replace(nt, ph, 'cv'), 64), d)
      ? take(replace(nt, ph, 'cv'), 64 - 1)
      : take(replace(nt, ph, 'cv'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cv'), 64), d)
      ? take(replace(nut, ph, 'cv'), 64 - 1)
      : take(replace(nut, ph, 'cv'), 64)
    slug: 'cv'
  }
  cognitiveServicesContentModerator: {
    name: endsWith(take(replace(nt, ph, 'cm'), 64), d)
      ? take(replace(nt, ph, 'cm'), 64 - 1)
      : take(replace(nt, ph, 'cm'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cm'), 64), d)
      ? take(replace(nut, ph, 'cm'), 64 - 1)
      : take(replace(nut, ph, 'cm'), 64)
    slug: 'cm'
  }
  cognitiveServicesContentSafety: {
    name: endsWith(take(replace(nt, ph, 'cs'), 64), d)
      ? take(replace(nt, ph, 'cs'), 64 - 1)
      : take(replace(nt, ph, 'cs'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cs'), 64), d)
      ? take(replace(nut, ph, 'cs'), 64 - 1)
      : take(replace(nut, ph, 'cs'), 64)
    slug: 'cs'
  }
  cognitiveServicesCustomVisionPrediction: {
    name: endsWith(take(replace(nt, ph, 'cstv'), 64), d)
      ? take(replace(nt, ph, 'cstv'), 64 - 1)
      : take(replace(nt, ph, 'cstv'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cstv'), 64), d)
      ? take(replace(nut, ph, 'cstv'), 64 - 1)
      : take(replace(nut, ph, 'cstv'), 64)
    slug: 'cstv'
  }
  cognitiveServicesCustomVisionTraining: {
    name: endsWith(take(replace(nt, ph, 'cstvt'), 64), d)
      ? take(replace(nt, ph, 'cstvt'), 64 - 1)
      : take(replace(nt, ph, 'cstvt'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cstvt'), 64), d)
      ? take(replace(nut, ph, 'cstvt'), 64 - 1)
      : take(replace(nut, ph, 'cstvt'), 64)
    slug: 'cstvt'
  }
  cognitiveServicesDocumentIntelligence: {
    name: endsWith(take(replace(nt, ph, 'di'), 64), d)
      ? take(replace(nt, ph, 'di'), 64 - 1)
      : take(replace(nt, ph, 'di'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'di'), 64), d)
      ? take(replace(nut, ph, 'di'), 64 - 1)
      : take(replace(nut, ph, 'di'), 64)
    slug: 'di'
  }
  cognitiveServicesMultiServiceAccount: {
    name: endsWith(take(replace(nt, ph, 'aisa'), 64), d)
      ? take(replace(nt, ph, 'aisa'), 64 - 1)
      : take(replace(nt, ph, 'aisa'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'aisa'), 64), d)
      ? take(replace(nut, ph, 'aisa'), 64 - 1)
      : take(replace(nut, ph, 'aisa'), 64)
    slug: 'aisa'
  }
  cognitiveServicesVideoIndexer: {
    name: endsWith(take(replace(nt, ph, 'avi'), 64), d)
      ? take(replace(nt, ph, 'avi'), 64 - 1)
      : take(replace(nt, ph, 'avi'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'avi'), 64), d)
      ? take(replace(nut, ph, 'avi'), 64 - 1)
      : take(replace(nut, ph, 'avi'), 64)
    slug: 'avi'
  }
  cognitiveServicesFaceApi: {
    name: endsWith(take(replace(nt, ph, 'face'), 64), d)
      ? take(replace(nt, ph, 'face'), 64 - 1)
      : take(replace(nt, ph, 'face'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'face'), 64), d)
      ? take(replace(nut, ph, 'face'), 64 - 1)
      : take(replace(nut, ph, 'face'), 64)
    slug: 'face'
  }
  cognitiveServicesImmersiveReader: {
    name: endsWith(take(replace(nt, ph, 'ir'), 64), d)
      ? take(replace(nt, ph, 'ir'), 64 - 1)
      : take(replace(nt, ph, 'ir'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'ir'), 64), d)
      ? take(replace(nut, ph, 'ir'), 64 - 1)
      : take(replace(nut, ph, 'ir'), 64)
    slug: 'ir'
  }
  cognitiveServicesLanguageService: {
    name: endsWith(take(replace(nt, ph, 'lang'), 64), d)
      ? take(replace(nt, ph, 'lang'), 64 - 1)
      : take(replace(nt, ph, 'lang'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'lang'), 64), d)
      ? take(replace(nut, ph, 'lang'), 64 - 1)
      : take(replace(nut, ph, 'lang'), 64)
    slug: 'lang'
  }
  cognitiveServicesSpeechService: {
    name: endsWith(take(replace(nt, ph, 'spch'), 64), d)
      ? take(replace(nt, ph, 'spch'), 64 - 1)
      : take(replace(nt, ph, 'spch'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'spch'), 64), d)
      ? take(replace(nut, ph, 'spch'), 64 - 1)
      : take(replace(nut, ph, 'spch'), 64)
    slug: 'spch'
  }
  cognitiveServicesTranslator: {
    name: endsWith(take(replace(nt, ph, 'trsl'), 64), d)
      ? take(replace(nt, ph, 'trsl'), 64 - 1)
      : take(replace(nt, ph, 'trsl'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'trsl'), 64), d)
      ? take(replace(nut, ph, 'trsl'), 64 - 1)
      : take(replace(nut, ph, 'trsl'), 64)
    slug: 'trsl'
  }
  containerApps: {
    name: endsWith(take(replace(nt, ph, 'ca'), 32), d)
      ? take(replace(nt, ph, 'ca'), 32 - 1)
      : take(replace(nt, ph, 'ca'), 32)
    nameUnique: endsWith(take(replace(nut, ph, 'ca'), 32), d)
      ? take(replace(nut, ph, 'ca'), 32 - 1)
      : take(replace(nut, ph, 'ca'), 32)
    slug: 'ca'
  }
  containerAppsEnvironment: {
    name: endsWith(take(replace(nt, ph, 'cae'), 64), d)
      ? take(replace(nt, ph, 'cae'), 64 - 1)
      : take(replace(nt, ph, 'cae'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'cae'), 64), d)
      ? take(replace(nut, ph, 'cae'), 64 - 1)
      : take(replace(nut, ph, 'cae'), 64)
    slug: 'cae'
  }
  containerGroup: {
    name: endsWith(take(replace(nt, ph, 'cg'), 63), d)
      ? take(replace(nt, ph, 'cg'), 63 - 1)
      : take(replace(nt, ph, 'cg'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'cg'), 63), d)
      ? take(replace(nut, ph, 'cg'), 63 - 1)
      : take(replace(nut, ph, 'cg'), 63)
    slug: 'cg'
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
  cosmosdbAccount: {
    name: endsWith(take(replace(nt, ph, 'cosmos'), 63), d)
      ? take(replace(nt, ph, 'cosmos'), 63 - 1)
      : take(replace(nt, ph, 'cosmos'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'cosmos'), 63), d)
      ? take(replace(nut, ph, 'cosmos'), 63 - 1)
      : take(replace(nut, ph, 'cosmos'), 63)
    slug: 'cosmos'
  }
  customProvider: {
    name: endsWith(take(replace(nt, ph, 'prov'), 64), d)
      ? take(replace(nt, ph, 'prov'), 64 - 1)
      : take(replace(nt, ph, 'prov'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'prov'), 64), d)
      ? take(replace(nut, ph, 'prov'), 64 - 1)
      : take(replace(nut, ph, 'prov'), 64)
    slug: 'prov'
  }
  dashboard: {
    name: endsWith(take(replace(nt, ph, 'dsb'), 160), d)
      ? take(replace(nt, ph, 'dsb'), 160 - 1)
      : take(replace(nt, ph, 'dsb'), 160)
    nameUnique: endsWith(take(replace(nut, ph, 'dsb'), 160), d)
      ? take(replace(nut, ph, 'dsb'), 160 - 1)
      : take(replace(nut, ph, 'dsb'), 160)
    slug: 'dsb'
  }
  dataFactory: {
    name: endsWith(take(replace(nt, ph, 'adf'), 63), d)
      ? take(replace(nt, ph, 'adf'), 63 - 1)
      : take(replace(nt, ph, 'adf'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'adf'), 63), d)
      ? take(replace(nut, ph, 'adf'), 63 - 1)
      : take(replace(nut, ph, 'adf'), 63)
    slug: 'adf'
  }
  dataFactoryDatasetMysql: {
    name: endsWith(take(replace(nt, ph, 'adfmysql'), 260), d)
      ? take(replace(nt, ph, 'adfmysql'), 260 - 1)
      : take(replace(nt, ph, 'adfmysql'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfmysql'), 260), d)
      ? take(replace(nut, ph, 'adfmysql'), 260 - 1)
      : take(replace(nut, ph, 'adfmysql'), 260)
    slug: 'adfmysql'
  }
  dataFactoryDatasetPostgresql: {
    name: endsWith(take(replace(nt, ph, 'adfpsql'), 260), d)
      ? take(replace(nt, ph, 'adfpsql'), 260 - 1)
      : take(replace(nt, ph, 'adfpsql'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfpsql'), 260), d)
      ? take(replace(nut, ph, 'adfpsql'), 260 - 1)
      : take(replace(nut, ph, 'adfpsql'), 260)
    slug: 'adfpsql'
  }
  dataFactoryDatasetSqlServerTable: {
    name: endsWith(take(replace(nt, ph, 'adfmssql'), 260), d)
      ? take(replace(nt, ph, 'adfmssql'), 260 - 1)
      : take(replace(nt, ph, 'adfmssql'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfmssql'), 260), d)
      ? take(replace(nut, ph, 'adfmssql'), 260 - 1)
      : take(replace(nut, ph, 'adfmssql'), 260)
    slug: 'adfmssql'
  }
  dataFactoryIntegrationRuntimeManaged: {
    name: endsWith(take(replace(nt, ph, 'adfir'), 63), d)
      ? take(replace(nt, ph, 'adfir'), 63 - 1)
      : take(replace(nt, ph, 'adfir'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'adfir'), 63), d)
      ? take(replace(nut, ph, 'adfir'), 63 - 1)
      : take(replace(nut, ph, 'adfir'), 63)
    slug: 'adfir'
  }
  dataFactoryLinkedServiceDataLakeStorageGen2: {
    name: endsWith(take(replace(nt, ph, 'adfsvst'), 260), d)
      ? take(replace(nt, ph, 'adfsvst'), 260 - 1)
      : take(replace(nt, ph, 'adfsvst'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfsvst'), 260), d)
      ? take(replace(nut, ph, 'adfsvst'), 260 - 1)
      : take(replace(nut, ph, 'adfsvst'), 260)
    slug: 'adfsvst'
  }
  dataFactoryLinkedServiceKeyVault: {
    name: endsWith(take(replace(nt, ph, 'adfsvkv'), 260), d)
      ? take(replace(nt, ph, 'adfsvkv'), 260 - 1)
      : take(replace(nt, ph, 'adfsvkv'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfsvkv'), 260), d)
      ? take(replace(nut, ph, 'adfsvkv'), 260 - 1)
      : take(replace(nut, ph, 'adfsvkv'), 260)
    slug: 'adfsvkv'
  }
  dataFactoryLinkedServiceMysql: {
    name: endsWith(take(replace(nt, ph, 'adfsvmysql'), 260), d)
      ? take(replace(nt, ph, 'adfsvmysql'), 260 - 1)
      : take(replace(nt, ph, 'adfsvmysql'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfsvmysql'), 260), d)
      ? take(replace(nut, ph, 'adfsvmysql'), 260 - 1)
      : take(replace(nut, ph, 'adfsvmysql'), 260)
    slug: 'adfsvmysql'
  }
  dataFactoryLinkedServicePostgresql: {
    name: endsWith(take(replace(nt, ph, 'adfsvpsql'), 260), d)
      ? take(replace(nt, ph, 'adfsvpsql'), 260 - 1)
      : take(replace(nt, ph, 'adfsvpsql'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfsvpsql'), 260), d)
      ? take(replace(nut, ph, 'adfsvpsql'), 260 - 1)
      : take(replace(nut, ph, 'adfsvpsql'), 260)
    slug: 'adfsvpsql'
  }
  dataFactoryLinkedServiceSqlServer: {
    name: endsWith(take(replace(nt, ph, 'adfsvmssql'), 260), d)
      ? take(replace(nt, ph, 'adfsvmssql'), 260 - 1)
      : take(replace(nt, ph, 'adfsvmssql'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfsvmssql'), 260), d)
      ? take(replace(nut, ph, 'adfsvmssql'), 260 - 1)
      : take(replace(nut, ph, 'adfsvmssql'), 260)
    slug: 'adfsvmssql'
  }
  dataFactoryPipeline: {
    name: endsWith(take(replace(nt, ph, 'adfpl'), 260), d)
      ? take(replace(nt, ph, 'adfpl'), 260 - 1)
      : take(replace(nt, ph, 'adfpl'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adfpl'), 260), d)
      ? take(replace(nut, ph, 'adfpl'), 260 - 1)
      : take(replace(nut, ph, 'adfpl'), 260)
    slug: 'adfpl'
  }
  dataFactoryTriggerSchedule: {
    name: endsWith(take(replace(nt, ph, 'adftg'), 260), d)
      ? take(replace(nt, ph, 'adftg'), 260 - 1)
      : take(replace(nt, ph, 'adftg'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'adftg'), 260), d)
      ? take(replace(nut, ph, 'adftg'), 260 - 1)
      : take(replace(nut, ph, 'adftg'), 260)
    slug: 'adftg'
  }
  dataLakeAnalyticsAccount: {
    name: take(replace(nst, ph, 'dla'), 24)
    nameUnique: take(replace(nust, ph, 'dla'), 24)
    slug: 'dla'
  }
  dataLakeAnalyticsFirewallRule: {
    name: endsWith(take(replace(nt, ph, 'dlfw'), 50), d)
      ? take(replace(nt, ph, 'dlfw'), 50 - 1)
      : take(replace(nt, ph, 'dlfw'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'dlfw'), 50), d)
      ? take(replace(nut, ph, 'dlfw'), 50 - 1)
      : take(replace(nut, ph, 'dlfw'), 50)
    slug: 'dlfw'
  }
  dataLakeStore: {
    name: take(replace(nst, ph, 'dls'), 24)
    nameUnique: take(replace(nust, ph, 'dls'), 24)
    slug: 'dls'
  }
  dataLakeStoreFirewallRule: {
    name: endsWith(take(replace(nt, ph, 'dlsfw'), 50), d)
      ? take(replace(nt, ph, 'dlsfw'), 50 - 1)
      : take(replace(nt, ph, 'dlsfw'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'dlsfw'), 50), d)
      ? take(replace(nut, ph, 'dlsfw'), 50 - 1)
      : take(replace(nut, ph, 'dlsfw'), 50)
    slug: 'dlsfw'
  }
  databaseMigrationProject: {
    name: endsWith(take(replace(nt, ph, 'migr'), 57), d)
      ? take(replace(nt, ph, 'migr'), 57 - 1)
      : take(replace(nt, ph, 'migr'), 57)
    nameUnique: endsWith(take(replace(nut, ph, 'migr'), 57), d)
      ? take(replace(nut, ph, 'migr'), 57 - 1)
      : take(replace(nut, ph, 'migr'), 57)
    slug: 'migr'
  }
  databaseMigrationService: {
    name: endsWith(take(replace(nt, ph, 'dms'), 62), d)
      ? take(replace(nt, ph, 'dms'), 62 - 1)
      : take(replace(nt, ph, 'dms'), 62)
    nameUnique: endsWith(take(replace(nut, ph, 'dms'), 62), d)
      ? take(replace(nut, ph, 'dms'), 62 - 1)
      : take(replace(nut, ph, 'dms'), 62)
    slug: 'dms'
  }
  databricksWorkspace: {
    name: endsWith(take(replace(nt, ph, 'dbw'), 30), d)
      ? take(replace(nt, ph, 'dbw'), 30 - 1)
      : take(replace(nt, ph, 'dbw'), 30)
    nameUnique: endsWith(take(replace(nut, ph, 'dbw'), 30), d)
      ? take(replace(nut, ph, 'dbw'), 30 - 1)
      : take(replace(nut, ph, 'dbw'), 30)
    slug: 'dbw'
  }
  devTestLab: {
    name: endsWith(take(replace(nt, ph, 'lab'), 50), d)
      ? take(replace(nt, ph, 'lab'), 50 - 1)
      : take(replace(nt, ph, 'lab'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'lab'), 50), d)
      ? take(replace(nut, ph, 'lab'), 50 - 1)
      : take(replace(nut, ph, 'lab'), 50)
    slug: 'lab'
  }
  devTestLinuxVirtualMachine: {
    name: endsWith(take(replace(nt, ph, 'labvm'), 64), d)
      ? take(replace(nt, ph, 'labvm'), 64 - 1)
      : take(replace(nt, ph, 'labvm'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'labvm'), 64), d)
      ? take(replace(nut, ph, 'labvm'), 64 - 1)
      : take(replace(nut, ph, 'labvm'), 64)
    slug: 'labvm'
  }
  devTestWindowsVirtualMachine: {
    name: endsWith(take(replace(nt, ph, 'labvm'), 15), d)
      ? take(replace(nt, ph, 'labvm'), 15 - 1)
      : take(replace(nt, ph, 'labvm'), 15)
    nameUnique: endsWith(take(replace(nut, ph, 'labvm'), 15), d)
      ? take(replace(nut, ph, 'labvm'), 15 - 1)
      : take(replace(nut, ph, 'labvm'), 15)
    slug: 'labvm'
  }
  diskEncryptionSet: {
    name: endsWith(take(replace(nt, ph, 'des'), 80), d)
      ? take(replace(nt, ph, 'des'), 80 - 1)
      : take(replace(nt, ph, 'des'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'des'), 80), d)
      ? take(replace(nut, ph, 'des'), 80 - 1)
      : take(replace(nut, ph, 'des'), 80)
    slug: 'des'
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
  eventGridDomain: {
    name: endsWith(take(replace(nt, ph, 'egd'), 50), d)
      ? take(replace(nt, ph, 'egd'), 50 - 1)
      : take(replace(nt, ph, 'egd'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'egd'), 50), d)
      ? take(replace(nut, ph, 'egd'), 50 - 1)
      : take(replace(nut, ph, 'egd'), 50)
    slug: 'egd'
  }
  eventGridDomainTopic: {
    name: endsWith(take(replace(nt, ph, 'egdt'), 50), d)
      ? take(replace(nt, ph, 'egdt'), 50 - 1)
      : take(replace(nt, ph, 'egdt'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'egdt'), 50), d)
      ? take(replace(nut, ph, 'egdt'), 50 - 1)
      : take(replace(nut, ph, 'egdt'), 50)
    slug: 'egdt'
  }
  eventGridEventSubscription: {
    name: endsWith(take(replace(nt, ph, 'egs'), 64), d)
      ? take(replace(nt, ph, 'egs'), 64 - 1)
      : take(replace(nt, ph, 'egs'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'egs'), 64), d)
      ? take(replace(nut, ph, 'egs'), 64 - 1)
      : take(replace(nut, ph, 'egs'), 64)
    slug: 'egs'
  }
  eventGridTopic: {
    name: endsWith(take(replace(nt, ph, 'egt'), 50), d)
      ? take(replace(nt, ph, 'egt'), 50 - 1)
      : take(replace(nt, ph, 'egt'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'egt'), 50), d)
      ? take(replace(nut, ph, 'egt'), 50 - 1)
      : take(replace(nut, ph, 'egt'), 50)
    slug: 'egt'
  }
  eventHub: {
    name: endsWith(take(replace(nt, ph, 'evh'), 50), d)
      ? take(replace(nt, ph, 'evh'), 50 - 1)
      : take(replace(nt, ph, 'evh'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'evh'), 50), d)
      ? take(replace(nut, ph, 'evh'), 50 - 1)
      : take(replace(nut, ph, 'evh'), 50)
    slug: 'evh'
  }
  eventHubAuthorizationRule: {
    name: endsWith(take(replace(nt, ph, 'ehar'), 50), d)
      ? take(replace(nt, ph, 'ehar'), 50 - 1)
      : take(replace(nt, ph, 'ehar'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'ehar'), 50), d)
      ? take(replace(nut, ph, 'ehar'), 50 - 1)
      : take(replace(nut, ph, 'ehar'), 50)
    slug: 'ehar'
  }
  eventHubConsumerGroup: {
    name: endsWith(take(replace(nt, ph, 'ehcg'), 50), d)
      ? take(replace(nt, ph, 'ehcg'), 50 - 1)
      : take(replace(nt, ph, 'ehcg'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'ehcg'), 50), d)
      ? take(replace(nut, ph, 'ehcg'), 50 - 1)
      : take(replace(nut, ph, 'ehcg'), 50)
    slug: 'ehcg'
  }
  eventHubNamespace: {
    name: endsWith(take(replace(nt, ph, 'ehn'), 50), d)
      ? take(replace(nt, ph, 'ehn'), 50 - 1)
      : take(replace(nt, ph, 'ehn'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'ehn'), 50), d)
      ? take(replace(nut, ph, 'ehn'), 50 - 1)
      : take(replace(nut, ph, 'ehn'), 50)
    slug: 'ehn'
  }
  eventHubNamespaceAuthorizationRule: {
    name: endsWith(take(replace(nt, ph, 'ehnar'), 50), d)
      ? take(replace(nt, ph, 'ehnar'), 50 - 1)
      : take(replace(nt, ph, 'ehnar'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'ehnar'), 50), d)
      ? take(replace(nut, ph, 'ehnar'), 50 - 1)
      : take(replace(nut, ph, 'ehnar'), 50)
    slug: 'ehnar'
  }
  eventHubNamespaceDisasterRecoveryConfig: {
    name: endsWith(take(replace(nt, ph, 'ehdr'), 50), d)
      ? take(replace(nt, ph, 'ehdr'), 50 - 1)
      : take(replace(nt, ph, 'ehdr'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'ehdr'), 50), d)
      ? take(replace(nut, ph, 'ehdr'), 50 - 1)
      : take(replace(nut, ph, 'ehdr'), 50)
    slug: 'ehdr'
  }
  expressRouteCircuit: {
    name: endsWith(take(replace(nt, ph, 'erc'), 80), d)
      ? take(replace(nt, ph, 'erc'), 80 - 1)
      : take(replace(nt, ph, 'erc'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'erc'), 80), d)
      ? take(replace(nut, ph, 'erc'), 80 - 1)
      : take(replace(nut, ph, 'erc'), 80)
    slug: 'erc'
  }
  expressRouteGateway: {
    name: endsWith(take(replace(nt, ph, 'ergw'), 80), d)
      ? take(replace(nt, ph, 'ergw'), 80 - 1)
      : take(replace(nt, ph, 'ergw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'ergw'), 80), d)
      ? take(replace(nut, ph, 'ergw'), 80 - 1)
      : take(replace(nut, ph, 'ergw'), 80)
    slug: 'ergw'
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
  functionApp: {
    name: endsWith(take(replace(nt, ph, 'func'), 60), d)
      ? take(replace(nt, ph, 'func'), 60 - 1)
      : take(replace(nt, ph, 'func'), 60)
    nameUnique: endsWith(take(replace(nut, ph, 'func'), 60), d)
      ? take(replace(nut, ph, 'func'), 60 - 1)
      : take(replace(nut, ph, 'func'), 60)
    slug: 'func'
  }
  grafana: {
    name: endsWith(take(replace(nt, ph, 'grfn'), 23), d)
      ? take(replace(nt, ph, 'grfn'), 23 - 1)
      : take(replace(nt, ph, 'grfn'), 23)
    nameUnique: endsWith(take(replace(nut, ph, 'grfn'), 23), d)
      ? take(replace(nut, ph, 'grfn'), 23 - 1)
      : take(replace(nut, ph, 'grfn'), 23)
    slug: 'grfn'
  }
  hdInsightHadoopCluster: {
    name: endsWith(take(replace(nt, ph, 'hadoop'), 59), d)
      ? take(replace(nt, ph, 'hadoop'), 59 - 1)
      : take(replace(nt, ph, 'hadoop'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'hadoop'), 59), d)
      ? take(replace(nut, ph, 'hadoop'), 59 - 1)
      : take(replace(nut, ph, 'hadoop'), 59)
    slug: 'hadoop'
  }
  hdInsightHbaseCluster: {
    name: endsWith(take(replace(nt, ph, 'hbase'), 59), d)
      ? take(replace(nt, ph, 'hbase'), 59 - 1)
      : take(replace(nt, ph, 'hbase'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'hbase'), 59), d)
      ? take(replace(nut, ph, 'hbase'), 59 - 1)
      : take(replace(nut, ph, 'hbase'), 59)
    slug: 'hbase'
  }
  hdInsightInteractiveQueryCluster: {
    name: endsWith(take(replace(nt, ph, 'iqr'), 59), d)
      ? take(replace(nt, ph, 'iqr'), 59 - 1)
      : take(replace(nt, ph, 'iqr'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'iqr'), 59), d)
      ? take(replace(nut, ph, 'iqr'), 59 - 1)
      : take(replace(nut, ph, 'iqr'), 59)
    slug: 'iqr'
  }
  hdInsightKafkaCluster: {
    name: endsWith(take(replace(nt, ph, 'kafka'), 59), d)
      ? take(replace(nt, ph, 'kafka'), 59 - 1)
      : take(replace(nt, ph, 'kafka'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'kafka'), 59), d)
      ? take(replace(nut, ph, 'kafka'), 59 - 1)
      : take(replace(nut, ph, 'kafka'), 59)
    slug: 'kafka'
  }
  hdInsightMlServicesCluster: {
    name: endsWith(take(replace(nt, ph, 'mls'), 59), d)
      ? take(replace(nt, ph, 'mls'), 59 - 1)
      : take(replace(nt, ph, 'mls'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'mls'), 59), d)
      ? take(replace(nut, ph, 'mls'), 59 - 1)
      : take(replace(nut, ph, 'mls'), 59)
    slug: 'mls'
  }
  hdInsightRserverCluster: {
    name: endsWith(take(replace(nt, ph, 'rsv'), 59), d)
      ? take(replace(nt, ph, 'rsv'), 59 - 1)
      : take(replace(nt, ph, 'rsv'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'rsv'), 59), d)
      ? take(replace(nut, ph, 'rsv'), 59 - 1)
      : take(replace(nut, ph, 'rsv'), 59)
    slug: 'rsv'
  }
  hdInsightSparkCluster: {
    name: endsWith(take(replace(nt, ph, 'spark'), 59), d)
      ? take(replace(nt, ph, 'spark'), 59 - 1)
      : take(replace(nt, ph, 'spark'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'spark'), 59), d)
      ? take(replace(nut, ph, 'spark'), 59 - 1)
      : take(replace(nut, ph, 'spark'), 59)
    slug: 'spark'
  }
  hdInsightStormCluster: {
    name: endsWith(take(replace(nt, ph, 'storm'), 59), d)
      ? take(replace(nt, ph, 'storm'), 59 - 1)
      : take(replace(nt, ph, 'storm'), 59)
    nameUnique: endsWith(take(replace(nut, ph, 'storm'), 59), d)
      ? take(replace(nut, ph, 'storm'), 59 - 1)
      : take(replace(nut, ph, 'storm'), 59)
    slug: 'storm'
  }
  image: {
    name: endsWith(take(replace(nt, ph, 'img'), 80), d)
      ? take(replace(nt, ph, 'img'), 80 - 1)
      : take(replace(nt, ph, 'img'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'img'), 80), d)
      ? take(replace(nut, ph, 'img'), 80 - 1)
      : take(replace(nut, ph, 'img'), 80)
    slug: 'img'
  }
  iotCentralApplication: {
    name: endsWith(take(replace(nt, ph, 'iotapp'), 63), d)
      ? take(replace(nt, ph, 'iotapp'), 63 - 1)
      : take(replace(nt, ph, 'iotapp'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'iotapp'), 63), d)
      ? take(replace(nut, ph, 'iotapp'), 63 - 1)
      : take(replace(nut, ph, 'iotapp'), 63)
    slug: 'iotapp'
  }
  iotHub: {
    name: endsWith(take(replace(nt, ph, 'iot'), 50), d)
      ? take(replace(nt, ph, 'iot'), 50 - 1)
      : take(replace(nt, ph, 'iot'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'iot'), 50), d)
      ? take(replace(nut, ph, 'iot'), 50 - 1)
      : take(replace(nut, ph, 'iot'), 50)
    slug: 'iot'
  }
  iotHubConsumerGroup: {
    name: endsWith(take(replace(nt, ph, 'iotcg'), 50), d)
      ? take(replace(nt, ph, 'iotcg'), 50 - 1)
      : take(replace(nt, ph, 'iotcg'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'iotcg'), 50), d)
      ? take(replace(nut, ph, 'iotcg'), 50 - 1)
      : take(replace(nut, ph, 'iotcg'), 50)
    slug: 'iotcg'
  }
  iotHubDps: {
    name: endsWith(take(replace(nt, ph, 'dps'), 64), d)
      ? take(replace(nt, ph, 'dps'), 64 - 1)
      : take(replace(nt, ph, 'dps'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'dps'), 64), d)
      ? take(replace(nut, ph, 'dps'), 64 - 1)
      : take(replace(nut, ph, 'dps'), 64)
    slug: 'dps'
  }
  iotHubDpsCertificate: {
    name: endsWith(take(replace(nt, ph, 'dpscert'), 64), d)
      ? take(replace(nt, ph, 'dpscert'), 64 - 1)
      : take(replace(nt, ph, 'dpscert'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'dpscert'), 64), d)
      ? take(replace(nut, ph, 'dpscert'), 64 - 1)
      : take(replace(nut, ph, 'dpscert'), 64)
    slug: 'dpscert'
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
  kubernetesCluster: {
    name: endsWith(take(replace(nt, ph, 'aks'), 63), d)
      ? take(replace(nt, ph, 'aks'), 63 - 1)
      : take(replace(nt, ph, 'aks'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'aks'), 63), d)
      ? take(replace(nut, ph, 'aks'), 63 - 1)
      : take(replace(nut, ph, 'aks'), 63)
    slug: 'aks'
  }
  kustoCluster: {
    name: take(replace(nst, ph, 'kc'), 22)
    nameUnique: take(replace(nust, ph, 'kc'), 22)
    slug: 'kc'
  }
  kustoDatabase: {
    name: endsWith(take(replace(nt, ph, 'kdb'), 260), d)
      ? take(replace(nt, ph, 'kdb'), 260 - 1)
      : take(replace(nt, ph, 'kdb'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'kdb'), 260), d)
      ? take(replace(nut, ph, 'kdb'), 260 - 1)
      : take(replace(nut, ph, 'kdb'), 260)
    slug: 'kdb'
  }
  kustoEventHubDataConnection: {
    name: endsWith(take(replace(nt, ph, 'kehc'), 40), d)
      ? take(replace(nt, ph, 'kehc'), 40 - 1)
      : take(replace(nt, ph, 'kehc'), 40)
    nameUnique: endsWith(take(replace(nut, ph, 'kehc'), 40), d)
      ? take(replace(nut, ph, 'kehc'), 40 - 1)
      : take(replace(nut, ph, 'kehc'), 40)
    slug: 'kehc'
  }
  loadBalancer: {
    name: endsWith(take(replace(nt, ph, 'lb'), 80), d)
      ? take(replace(nt, ph, 'lb'), 80 - 1)
      : take(replace(nt, ph, 'lb'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'lb'), 80), d)
      ? take(replace(nut, ph, 'lb'), 80 - 1)
      : take(replace(nut, ph, 'lb'), 80)
    slug: 'lb'
  }
  loadBalancerNatRule: {
    name: endsWith(take(replace(nt, ph, 'lbnatrl'), 80), d)
      ? take(replace(nt, ph, 'lbnatrl'), 80 - 1)
      : take(replace(nt, ph, 'lbnatrl'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'lbnatrl'), 80), d)
      ? take(replace(nut, ph, 'lbnatrl'), 80 - 1)
      : take(replace(nut, ph, 'lbnatrl'), 80)
    slug: 'lbnatrl'
  }
  loadTesting: {
    name: endsWith(take(replace(nt, ph, 'lt'), 64), d)
      ? take(replace(nt, ph, 'lt'), 64 - 1)
      : take(replace(nt, ph, 'lt'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'lt'), 64), d)
      ? take(replace(nut, ph, 'lt'), 64 - 1)
      : take(replace(nut, ph, 'lt'), 64)
    slug: 'lt'
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
  linuxVirtualMachineScaleSet: {
    name: endsWith(take(replace(nt, ph, 'vmss'), 64), d)
      ? take(replace(nt, ph, 'vmss'), 64 - 1)
      : take(replace(nt, ph, 'vmss'), 64)
    nameUnique: endsWith(take(replace(nut, ph, 'vmss'), 64), d)
      ? take(replace(nut, ph, 'vmss'), 64 - 1)
      : take(replace(nut, ph, 'vmss'), 64)
    slug: 'vmss'
  }
  localNetworkGateway: {
    name: endsWith(take(replace(nt, ph, 'lgw'), 80), d)
      ? take(replace(nt, ph, 'lgw'), 80 - 1)
      : take(replace(nt, ph, 'lgw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'lgw'), 80), d)
      ? take(replace(nut, ph, 'lgw'), 80 - 1)
      : take(replace(nut, ph, 'lgw'), 80)
    slug: 'lgw'
  }
  logicApp: {
    name: endsWith(take(replace(nt, ph, 'logic'), 43), d)
      ? take(replace(nt, ph, 'logic'), 43 - 1)
      : take(replace(nt, ph, 'logic'), 43)
    nameUnique: endsWith(take(replace(nut, ph, 'logic'), 43), d)
      ? take(replace(nut, ph, 'logic'), 43 - 1)
      : take(replace(nut, ph, 'logic'), 43)
    slug: 'logic'
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
  machineLearningWorkspace: {
    name: endsWith(take(replace(nt, ph, 'mlw'), 260), d)
      ? take(replace(nt, ph, 'mlw'), 260 - 1)
      : take(replace(nt, ph, 'mlw'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'mlw'), 260), d)
      ? take(replace(nut, ph, 'mlw'), 260 - 1)
      : take(replace(nut, ph, 'mlw'), 260)
    slug: 'mlw'
  }
  managedDisk: {
    name: endsWith(take(replace(nt, ph, 'dsk'), 80), d)
      ? take(replace(nt, ph, 'dsk'), 80 - 1)
      : take(replace(nt, ph, 'dsk'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'dsk'), 80), d)
      ? take(replace(nut, ph, 'dsk'), 80 - 1)
      : take(replace(nut, ph, 'dsk'), 80)
    slug: 'dsk'
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
  mapsAccount: {
    name: endsWith(take(replace(nt, ph, 'map'), 98), d)
      ? take(replace(nt, ph, 'map'), 98 - 1)
      : take(replace(nt, ph, 'map'), 98)
    nameUnique: endsWith(take(replace(nut, ph, 'map'), 98), d)
      ? take(replace(nut, ph, 'map'), 98 - 1)
      : take(replace(nut, ph, 'map'), 98)
    slug: 'map'
  }
  mariadbDatabase: {
    name: endsWith(take(replace(nt, ph, 'mariadb'), 63), d)
      ? take(replace(nt, ph, 'mariadb'), 63 - 1)
      : take(replace(nt, ph, 'mariadb'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'mariadb'), 63), d)
      ? take(replace(nut, ph, 'mariadb'), 63 - 1)
      : take(replace(nut, ph, 'mariadb'), 63)
    slug: 'mariadb'
  }
  mariadbFirewallRule: {
    name: endsWith(take(replace(nt, ph, 'mariafw'), 128), d)
      ? take(replace(nt, ph, 'mariafw'), 128 - 1)
      : take(replace(nt, ph, 'mariafw'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'mariafw'), 128), d)
      ? take(replace(nut, ph, 'mariafw'), 128 - 1)
      : take(replace(nut, ph, 'mariafw'), 128)
    slug: 'mariafw'
  }
  mariadbServer: {
    name: endsWith(take(replace(nt, ph, 'maria'), 63), d)
      ? take(replace(nt, ph, 'maria'), 63 - 1)
      : take(replace(nt, ph, 'maria'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'maria'), 63), d)
      ? take(replace(nut, ph, 'maria'), 63 - 1)
      : take(replace(nut, ph, 'maria'), 63)
    slug: 'maria'
  }
  mariadbVirtualNetworkRule: {
    name: endsWith(take(replace(nt, ph, 'mariavn'), 128), d)
      ? take(replace(nt, ph, 'mariavn'), 128 - 1)
      : take(replace(nt, ph, 'mariavn'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'mariavn'), 128), d)
      ? take(replace(nut, ph, 'mariavn'), 128 - 1)
      : take(replace(nut, ph, 'mariavn'), 128)
    slug: 'mariavn'
  }
  mssqlDatabase: {
    name: endsWith(take(replace(nt, ph, 'sqldb'), 128), d)
      ? take(replace(nt, ph, 'sqldb'), 128 - 1)
      : take(replace(nt, ph, 'sqldb'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'sqldb'), 128), d)
      ? take(replace(nut, ph, 'sqldb'), 128 - 1)
      : take(replace(nut, ph, 'sqldb'), 128)
    slug: 'sqldb'
  }
  mssqlElasticpool: {
    name: endsWith(take(replace(nt, ph, 'sqlep'), 128), d)
      ? take(replace(nt, ph, 'sqlep'), 128 - 1)
      : take(replace(nt, ph, 'sqlep'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'sqlep'), 128), d)
      ? take(replace(nut, ph, 'sqlep'), 128 - 1)
      : take(replace(nut, ph, 'sqlep'), 128)
    slug: 'sqlep'
  }
  mssqlServer: {
    name: endsWith(take(replace(nt, ph, 'sql'), 63), d)
      ? take(replace(nt, ph, 'sql'), 63 - 1)
      : take(replace(nt, ph, 'sql'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'sql'), 63), d)
      ? take(replace(nut, ph, 'sql'), 63 - 1)
      : take(replace(nut, ph, 'sql'), 63)
    slug: 'sql'
  }
  mysqlDatabase: {
    name: endsWith(take(replace(nt, ph, 'mysqldb'), 63), d)
      ? take(replace(nt, ph, 'mysqldb'), 63 - 1)
      : take(replace(nt, ph, 'mysqldb'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'mysqldb'), 63), d)
      ? take(replace(nut, ph, 'mysqldb'), 63 - 1)
      : take(replace(nut, ph, 'mysqldb'), 63)
    slug: 'mysqldb'
  }
  mysqlFirewallRule: {
    name: endsWith(take(replace(nt, ph, 'mysqlfw'), 128), d)
      ? take(replace(nt, ph, 'mysqlfw'), 128 - 1)
      : take(replace(nt, ph, 'mysqlfw'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'mysqlfw'), 128), d)
      ? take(replace(nut, ph, 'mysqlfw'), 128 - 1)
      : take(replace(nut, ph, 'mysqlfw'), 128)
    slug: 'mysqlfw'
  }
  mysqlServer: {
    name: endsWith(take(replace(nt, ph, 'mysql'), 63), d)
      ? take(replace(nt, ph, 'mysql'), 63 - 1)
      : take(replace(nt, ph, 'mysql'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'mysql'), 63), d)
      ? take(replace(nut, ph, 'mysql'), 63 - 1)
      : take(replace(nut, ph, 'mysql'), 63)
    slug: 'mysql'
  }
  mysqlVirtualNetworkRule: {
    name: endsWith(take(replace(nt, ph, 'mysqlvn'), 128), d)
      ? take(replace(nt, ph, 'mysqlvn'), 128 - 1)
      : take(replace(nt, ph, 'mysqlvn'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'mysqlvn'), 128), d)
      ? take(replace(nut, ph, 'mysqlvn'), 128 - 1)
      : take(replace(nut, ph, 'mysqlvn'), 128)
    slug: 'mysqlvn'
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
  networkWatcher: {
    name: endsWith(take(replace(nt, ph, 'nw'), 80), d)
      ? take(replace(nt, ph, 'nw'), 80 - 1)
      : take(replace(nt, ph, 'nw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'nw'), 80), d)
      ? take(replace(nut, ph, 'nw'), 80 - 1)
      : take(replace(nut, ph, 'nw'), 80)
    slug: 'nw'
  }
  notificationHub: {
    name: endsWith(take(replace(nt, ph, 'nh'), 260), d)
      ? take(replace(nt, ph, 'nh'), 260 - 1)
      : take(replace(nt, ph, 'nh'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'nh'), 260), d)
      ? take(replace(nut, ph, 'nh'), 260 - 1)
      : take(replace(nut, ph, 'nh'), 260)
    slug: 'nh'
  }
  notificationHubAuthorizationRule: {
    name: endsWith(take(replace(nt, ph, 'dnsrec'), 256), d)
      ? take(replace(nt, ph, 'dnsrec'), 256 - 1)
      : take(replace(nt, ph, 'dnsrec'), 256)
    nameUnique: endsWith(take(replace(nut, ph, 'dnsrec'), 256), d)
      ? take(replace(nut, ph, 'dnsrec'), 256 - 1)
      : take(replace(nut, ph, 'dnsrec'), 256)
    slug: 'dnsrec'
  }
  notificationHubNamespace: {
    name: endsWith(take(replace(nt, ph, 'dnsrec'), 50), d)
      ? take(replace(nt, ph, 'dnsrec'), 50 - 1)
      : take(replace(nt, ph, 'dnsrec'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'dnsrec'), 50), d)
      ? take(replace(nut, ph, 'dnsrec'), 50 - 1)
      : take(replace(nut, ph, 'dnsrec'), 50)
    slug: 'dnsrec'
  }
  pointToSiteVpnGateway: {
    name: endsWith(take(replace(nt, ph, 'vpngw'), 80), d)
      ? take(replace(nt, ph, 'vpngw'), 80 - 1)
      : take(replace(nt, ph, 'vpngw'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'vpngw'), 80), d)
      ? take(replace(nut, ph, 'vpngw'), 80 - 1)
      : take(replace(nut, ph, 'vpngw'), 80)
    slug: 'vpngw'
  }
  postgresqlDatabase: {
    name: endsWith(take(replace(nt, ph, 'psqldb'), 63), d)
      ? take(replace(nt, ph, 'psqldb'), 63 - 1)
      : take(replace(nt, ph, 'psqldb'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'psqldb'), 63), d)
      ? take(replace(nut, ph, 'psqldb'), 63 - 1)
      : take(replace(nut, ph, 'psqldb'), 63)
    slug: 'psqldb'
  }
  postgresqlFirewallRule: {
    name: endsWith(take(replace(nt, ph, 'psqlfw'), 128), d)
      ? take(replace(nt, ph, 'psqlfw'), 128 - 1)
      : take(replace(nt, ph, 'psqlfw'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'psqlfw'), 128), d)
      ? take(replace(nut, ph, 'psqlfw'), 128 - 1)
      : take(replace(nut, ph, 'psqlfw'), 128)
    slug: 'psqlfw'
  }
  postgresqlServer: {
    name: endsWith(take(replace(nt, ph, 'psql'), 63), d)
      ? take(replace(nt, ph, 'psql'), 63 - 1)
      : take(replace(nt, ph, 'psql'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'psql'), 63), d)
      ? take(replace(nut, ph, 'psql'), 63 - 1)
      : take(replace(nut, ph, 'psql'), 63)
    slug: 'psql'
  }
  postgresqlVirtualNetworkRule: {
    name: endsWith(take(replace(nt, ph, 'psqlvn'), 128), d)
      ? take(replace(nt, ph, 'psqlvn'), 128 - 1)
      : take(replace(nt, ph, 'psqlvn'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'psqlvn'), 128), d)
      ? take(replace(nut, ph, 'psqlvn'), 128 - 1)
      : take(replace(nut, ph, 'psqlvn'), 128)
    slug: 'psqlvn'
  }
  powerbiEmbedded: {
    name: endsWith(take(replace(nt, ph, 'pbi'), 63), d)
      ? take(replace(nt, ph, 'pbi'), 63 - 1)
      : take(replace(nt, ph, 'pbi'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'pbi'), 63), d)
      ? take(replace(nut, ph, 'pbi'), 63 - 1)
      : take(replace(nut, ph, 'pbi'), 63)
    slug: 'pbi'
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
  publicIpPrefix: {
    name: endsWith(take(replace(nt, ph, 'pippf'), 80), d)
      ? take(replace(nt, ph, 'pippf'), 80 - 1)
      : take(replace(nt, ph, 'pippf'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'pippf'), 80), d)
      ? take(replace(nut, ph, 'pippf'), 80 - 1)
      : take(replace(nut, ph, 'pippf'), 80)
    slug: 'pippf'
  }
  redisCache: {
    name: endsWith(take(replace(nt, ph, 'redis'), 63), d)
      ? take(replace(nt, ph, 'redis'), 63 - 1)
      : take(replace(nt, ph, 'redis'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'redis'), 63), d)
      ? take(replace(nut, ph, 'redis'), 63 - 1)
      : take(replace(nut, ph, 'redis'), 63)
    slug: 'redis'
  }
  redisFirewallRule: {
    name: take(replace(nst, ph, 'redisfw'), 256)
    nameUnique: take(replace(nust, ph, 'redisfw'), 256)
    slug: 'redisfw'
  }
  relayHybridConnection: {
    name: endsWith(take(replace(nt, ph, 'rlhc'), 260), d)
      ? take(replace(nt, ph, 'rlhc'), 260 - 1)
      : take(replace(nt, ph, 'rlhc'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'rlhc'), 260), d)
      ? take(replace(nut, ph, 'rlhc'), 260 - 1)
      : take(replace(nut, ph, 'rlhc'), 260)
    slug: 'rlhc'
  }
  relayNamespace: {
    name: endsWith(take(replace(nt, ph, 'rln'), 50), d)
      ? take(replace(nt, ph, 'rln'), 50 - 1)
      : take(replace(nt, ph, 'rln'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'rln'), 50), d)
      ? take(replace(nut, ph, 'rln'), 50 - 1)
      : take(replace(nut, ph, 'rln'), 50)
    slug: 'rln'
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
  serviceFabricCluster: {
    name: endsWith(take(replace(nt, ph, 'sf'), 23), d)
      ? take(replace(nt, ph, 'sf'), 23 - 1)
      : take(replace(nt, ph, 'sf'), 23)
    nameUnique: endsWith(take(replace(nut, ph, 'sf'), 23), d)
      ? take(replace(nut, ph, 'sf'), 23 - 1)
      : take(replace(nut, ph, 'sf'), 23)
    slug: 'sf'
  }
  serviceFabricManagedCluster: {
    name: endsWith(take(replace(nt, ph, 'sfmc'), 23), d)
      ? take(replace(nt, ph, 'sfmc'), 23 - 1)
      : take(replace(nt, ph, 'sfmc'), 23)
    nameUnique: endsWith(take(replace(nut, ph, 'sfmc'), 23), d)
      ? take(replace(nut, ph, 'sfmc'), 23 - 1)
      : take(replace(nut, ph, 'sfmc'), 23)
    slug: 'sfmc'
  }
  serviceBusNamespace: {
    name: endsWith(take(replace(nt, ph, 'sb'), 50), d)
      ? take(replace(nt, ph, 'sb'), 50 - 1)
      : take(replace(nt, ph, 'sb'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'sb'), 50), d)
      ? take(replace(nut, ph, 'sb'), 50 - 1)
      : take(replace(nut, ph, 'sb'), 50)
    slug: 'sb'
  }
  serviceBusNamespaceAuthorizationRule: {
    name: endsWith(take(replace(nt, ph, 'sbar'), 50), d)
      ? take(replace(nt, ph, 'sbar'), 50 - 1)
      : take(replace(nt, ph, 'sbar'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'sbar'), 50), d)
      ? take(replace(nut, ph, 'sbar'), 50 - 1)
      : take(replace(nut, ph, 'sbar'), 50)
    slug: 'sbar'
  }
  serviceBusQueue: {
    name: endsWith(take(replace(nt, ph, 'sbq'), 260), d)
      ? take(replace(nt, ph, 'sbq'), 260 - 1)
      : take(replace(nt, ph, 'sbq'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'sbq'), 260), d)
      ? take(replace(nut, ph, 'sbq'), 260 - 1)
      : take(replace(nut, ph, 'sbq'), 260)
    slug: 'sbq'
  }
  serviceBusQueueAuthorizationRule: {
    name: endsWith(take(replace(nt, ph, 'sbqar'), 50), d)
      ? take(replace(nt, ph, 'sbqar'), 50 - 1)
      : take(replace(nt, ph, 'sbqar'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'sbqar'), 50), d)
      ? take(replace(nut, ph, 'sbqar'), 50 - 1)
      : take(replace(nut, ph, 'sbqar'), 50)
    slug: 'sbqar'
  }
  serviceBusSubscription: {
    name: endsWith(take(replace(nt, ph, 'sbs'), 50), d)
      ? take(replace(nt, ph, 'sbs'), 50 - 1)
      : take(replace(nt, ph, 'sbs'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'sbs'), 50), d)
      ? take(replace(nut, ph, 'sbs'), 50 - 1)
      : take(replace(nut, ph, 'sbs'), 50)
    slug: 'sbs'
  }
  serviceBusSubscriptionRule: {
    name: endsWith(take(replace(nt, ph, 'sbsr'), 50), d)
      ? take(replace(nt, ph, 'sbsr'), 50 - 1)
      : take(replace(nt, ph, 'sbsr'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'sbsr'), 50), d)
      ? take(replace(nut, ph, 'sbsr'), 50 - 1)
      : take(replace(nut, ph, 'sbsr'), 50)
    slug: 'sbsr'
  }
  serviceBusTopic: {
    name: endsWith(take(replace(nt, ph, 'sbt'), 260), d)
      ? take(replace(nt, ph, 'sbt'), 260 - 1)
      : take(replace(nt, ph, 'sbt'), 260)
    nameUnique: endsWith(take(replace(nut, ph, 'sbt'), 260), d)
      ? take(replace(nut, ph, 'sbt'), 260 - 1)
      : take(replace(nut, ph, 'sbt'), 260)
    slug: 'sbt'
  }
  serviceBusTopicAuthorizationRule: {
    name: endsWith(take(replace(nt, ph, 'dnsrec'), 50), d)
      ? take(replace(nt, ph, 'dnsrec'), 50 - 1)
      : take(replace(nt, ph, 'dnsrec'), 50)
    nameUnique: endsWith(take(replace(nut, ph, 'dnsrec'), 50), d)
      ? take(replace(nut, ph, 'dnsrec'), 50 - 1)
      : take(replace(nut, ph, 'dnsrec'), 50)
    slug: 'dnsrec'
  }
  sharedImage: {
    name: endsWith(take(replace(nt, ph, 'si'), 80), d)
      ? take(replace(nt, ph, 'si'), 80 - 1)
      : take(replace(nt, ph, 'si'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'si'), 80), d)
      ? take(replace(nut, ph, 'si'), 80 - 1)
      : take(replace(nut, ph, 'si'), 80)
    slug: 'si'
  }
  sharedImageGallery: {
    name: take(replace(nst, ph, 'sig'), 80)
    nameUnique: take(replace(nust, ph, 'sig'), 80)
    slug: 'sig'
  }
  signalrService: {
    name: endsWith(take(replace(nt, ph, 'sgnlr'), 63), d)
      ? take(replace(nt, ph, 'sgnlr'), 63 - 1)
      : take(replace(nt, ph, 'sgnlr'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'sgnlr'), 63), d)
      ? take(replace(nut, ph, 'sgnlr'), 63 - 1)
      : take(replace(nut, ph, 'sgnlr'), 63)
    slug: 'sgnlr'
  }
  snapshots: {
    name: endsWith(take(replace(nt, ph, 'snap'), 80), d)
      ? take(replace(nt, ph, 'snap'), 80 - 1)
      : take(replace(nt, ph, 'snap'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'snap'), 80), d)
      ? take(replace(nut, ph, 'snap'), 80 - 1)
      : take(replace(nut, ph, 'snap'), 80)
    slug: 'snap'
  }
  sqlElasticpool: {
    name: endsWith(take(replace(nt, ph, 'sqlep'), 128), d)
      ? take(replace(nt, ph, 'sqlep'), 128 - 1)
      : take(replace(nt, ph, 'sqlep'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'sqlep'), 128), d)
      ? take(replace(nut, ph, 'sqlep'), 128 - 1)
      : take(replace(nut, ph, 'sqlep'), 128)
    slug: 'sqlep'
  }
  sqlFailoverGroup: {
    name: endsWith(take(replace(nt, ph, 'sqlfg'), 63), d)
      ? take(replace(nt, ph, 'sqlfg'), 63 - 1)
      : take(replace(nt, ph, 'sqlfg'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'sqlfg'), 63), d)
      ? take(replace(nut, ph, 'sqlfg'), 63 - 1)
      : take(replace(nut, ph, 'sqlfg'), 63)
    slug: 'sqlfg'
  }
  sqlFirewallRule: {
    name: endsWith(take(replace(nt, ph, 'sqlfw'), 128), d)
      ? take(replace(nt, ph, 'sqlfw'), 128 - 1)
      : take(replace(nt, ph, 'sqlfw'), 128)
    nameUnique: endsWith(take(replace(nut, ph, 'sqlfw'), 128), d)
      ? take(replace(nut, ph, 'sqlfw'), 128 - 1)
      : take(replace(nut, ph, 'sqlfw'), 128)
    slug: 'sqlfw'
  }
  sqlServer: {
    name: endsWith(take(replace(nt, ph, 'sql'), 63), d)
      ? take(replace(nt, ph, 'sql'), 63 - 1)
      : take(replace(nt, ph, 'sql'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'sql'), 63), d)
      ? take(replace(nut, ph, 'sql'), 63 - 1)
      : take(replace(nut, ph, 'sql'), 63)
    slug: 'sql'
  }
  storageAccount: {
    name: take(replace(nst, ph, 'st'), 24)
    nameUnique: take(replace(nust, ph, 'st'), 24)
    slug: 'st'
  }
  storageBlob: {
    name: endsWith(take(replace(nt, ph, 'blob'), 1024), d)
      ? take(replace(nt, ph, 'blob'), 1024 - 1)
      : take(replace(nt, ph, 'blob'), 1024)
    nameUnique: endsWith(take(replace(nut, ph, 'blob'), 1024), d)
      ? take(replace(nut, ph, 'blob'), 1024 - 1)
      : take(replace(nut, ph, 'blob'), 1024)
    slug: 'blob'
  }
  storageContainer: {
    name: endsWith(take(replace(nt, ph, 'stct'), 63), d)
      ? take(replace(nt, ph, 'stct'), 63 - 1)
      : take(replace(nt, ph, 'stct'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'stct'), 63), d)
      ? take(replace(nut, ph, 'stct'), 63 - 1)
      : take(replace(nut, ph, 'stct'), 63)
    slug: 'stct'
  }
  storageDataLakeGen2Filesystem: {
    name: endsWith(take(replace(nt, ph, 'stdl'), 63), d)
      ? take(replace(nt, ph, 'stdl'), 63 - 1)
      : take(replace(nt, ph, 'stdl'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'stdl'), 63), d)
      ? take(replace(nut, ph, 'stdl'), 63 - 1)
      : take(replace(nut, ph, 'stdl'), 63)
    slug: 'stdl'
  }
  storageQueue: {
    name: endsWith(take(replace(nt, ph, 'stq'), 63), d)
      ? take(replace(nt, ph, 'stq'), 63 - 1)
      : take(replace(nt, ph, 'stq'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'stq'), 63), d)
      ? take(replace(nut, ph, 'stq'), 63 - 1)
      : take(replace(nut, ph, 'stq'), 63)
    slug: 'stq'
  }
  storageShare: {
    name: endsWith(take(replace(nt, ph, 'sts'), 63), d)
      ? take(replace(nt, ph, 'sts'), 63 - 1)
      : take(replace(nt, ph, 'sts'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'sts'), 63), d)
      ? take(replace(nut, ph, 'sts'), 63 - 1)
      : take(replace(nut, ph, 'sts'), 63)
    slug: 'sts'
  }
  storageShareDirectory: {
    name: endsWith(take(replace(nt, ph, 'sts'), 63), d)
      ? take(replace(nt, ph, 'sts'), 63 - 1)
      : take(replace(nt, ph, 'sts'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'sts'), 63), d)
      ? take(replace(nut, ph, 'sts'), 63 - 1)
      : take(replace(nut, ph, 'sts'), 63)
    slug: 'sts'
  }
  storageTable: {
    name: take(replace(nst, ph, 'stt'), 63)
    nameUnique: take(replace(nust, ph, 'stt'), 63)
    slug: 'stt'
  }
  streamAnalyticsFunctionJavascriptUdf: {
    name: endsWith(take(replace(nt, ph, 'asafunc'), 63), d)
      ? take(replace(nt, ph, 'asafunc'), 63 - 1)
      : take(replace(nt, ph, 'asafunc'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asafunc'), 63), d)
      ? take(replace(nut, ph, 'asafunc'), 63 - 1)
      : take(replace(nut, ph, 'asafunc'), 63)
    slug: 'asafunc'
  }
  streamAnalyticsJob: {
    name: endsWith(take(replace(nt, ph, 'asa'), 63), d)
      ? take(replace(nt, ph, 'asa'), 63 - 1)
      : take(replace(nt, ph, 'asa'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asa'), 63), d)
      ? take(replace(nut, ph, 'asa'), 63 - 1)
      : take(replace(nut, ph, 'asa'), 63)
    slug: 'asa'
  }
  streamAnalyticsOutputBlob: {
    name: endsWith(take(replace(nt, ph, 'asaoblob'), 63), d)
      ? take(replace(nt, ph, 'asaoblob'), 63 - 1)
      : take(replace(nt, ph, 'asaoblob'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaoblob'), 63), d)
      ? take(replace(nut, ph, 'asaoblob'), 63 - 1)
      : take(replace(nut, ph, 'asaoblob'), 63)
    slug: 'asaoblob'
  }
  streamAnalyticsOutputEventHub: {
    name: endsWith(take(replace(nt, ph, 'asaoeh'), 63), d)
      ? take(replace(nt, ph, 'asaoeh'), 63 - 1)
      : take(replace(nt, ph, 'asaoeh'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaoeh'), 63), d)
      ? take(replace(nut, ph, 'asaoeh'), 63 - 1)
      : take(replace(nut, ph, 'asaoeh'), 63)
    slug: 'asaoeh'
  }
  streamAnalyticsOutputMssql: {
    name: endsWith(take(replace(nt, ph, 'asaomssql'), 63), d)
      ? take(replace(nt, ph, 'asaomssql'), 63 - 1)
      : take(replace(nt, ph, 'asaomssql'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaomssql'), 63), d)
      ? take(replace(nut, ph, 'asaomssql'), 63 - 1)
      : take(replace(nut, ph, 'asaomssql'), 63)
    slug: 'asaomssql'
  }
  streamAnalyticsOutputServiceBusQueue: {
    name: endsWith(take(replace(nt, ph, 'asaosbq'), 63), d)
      ? take(replace(nt, ph, 'asaosbq'), 63 - 1)
      : take(replace(nt, ph, 'asaosbq'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaosbq'), 63), d)
      ? take(replace(nut, ph, 'asaosbq'), 63 - 1)
      : take(replace(nut, ph, 'asaosbq'), 63)
    slug: 'asaosbq'
  }
  streamAnalyticsOutputServiceBusTopic: {
    name: endsWith(take(replace(nt, ph, 'asaosbt'), 63), d)
      ? take(replace(nt, ph, 'asaosbt'), 63 - 1)
      : take(replace(nt, ph, 'asaosbt'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaosbt'), 63), d)
      ? take(replace(nut, ph, 'asaosbt'), 63 - 1)
      : take(replace(nut, ph, 'asaosbt'), 63)
    slug: 'asaosbt'
  }
  streamAnalyticsReferenceInputBlob: {
    name: endsWith(take(replace(nt, ph, 'asarblob'), 63), d)
      ? take(replace(nt, ph, 'asarblob'), 63 - 1)
      : take(replace(nt, ph, 'asarblob'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asarblob'), 63), d)
      ? take(replace(nut, ph, 'asarblob'), 63 - 1)
      : take(replace(nut, ph, 'asarblob'), 63)
    slug: 'asarblob'
  }
  streamAnalyticsStreamInputBlob: {
    name: endsWith(take(replace(nt, ph, 'asaiblob'), 63), d)
      ? take(replace(nt, ph, 'asaiblob'), 63 - 1)
      : take(replace(nt, ph, 'asaiblob'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaiblob'), 63), d)
      ? take(replace(nut, ph, 'asaiblob'), 63 - 1)
      : take(replace(nut, ph, 'asaiblob'), 63)
    slug: 'asaiblob'
  }
  streamAnalyticsStreamInputEventHub: {
    name: endsWith(take(replace(nt, ph, 'asaieh'), 63), d)
      ? take(replace(nt, ph, 'asaieh'), 63 - 1)
      : take(replace(nt, ph, 'asaieh'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaieh'), 63), d)
      ? take(replace(nut, ph, 'asaieh'), 63 - 1)
      : take(replace(nut, ph, 'asaieh'), 63)
    slug: 'asaieh'
  }
  streamAnalyticsStreamInputIotHub: {
    name: endsWith(take(replace(nt, ph, 'asaiiot'), 63), d)
      ? take(replace(nt, ph, 'asaiiot'), 63 - 1)
      : take(replace(nt, ph, 'asaiiot'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'asaiiot'), 63), d)
      ? take(replace(nut, ph, 'asaiiot'), 63 - 1)
      : take(replace(nut, ph, 'asaiiot'), 63)
    slug: 'asaiiot'
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
  trafficManagerProfile: {
    name: endsWith(take(replace(nt, ph, 'traf'), 63), d)
      ? take(replace(nt, ph, 'traf'), 63 - 1)
      : take(replace(nt, ph, 'traf'), 63)
    nameUnique: endsWith(take(replace(nut, ph, 'traf'), 63), d)
      ? take(replace(nut, ph, 'traf'), 63 - 1)
      : take(replace(nut, ph, 'traf'), 63)
    slug: 'traf'
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
  virtualMachineScaleSet: {
    name: endsWith(take(replace(nt, ph, 'vmss'), 15), d)
      ? take(replace(nt, ph, 'vmss'), 15 - 1)
      : take(replace(nt, ph, 'vmss'), 15)
    nameUnique: endsWith(take(replace(nut, ph, 'vmss'), 15), d)
      ? take(replace(nut, ph, 'vmss'), 15 - 1)
      : take(replace(nut, ph, 'vmss'), 15)
    slug: 'vmss'
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
  virtualWan: {
    name: endsWith(take(replace(nt, ph, 'vwan'), 80), d)
      ? take(replace(nt, ph, 'vwan'), 80 - 1)
      : take(replace(nt, ph, 'vwan'), 80)
    nameUnique: endsWith(take(replace(nut, ph, 'vwan'), 80), d)
      ? take(replace(nut, ph, 'vwan'), 80 - 1)
      : take(replace(nut, ph, 'vwan'), 80)
    slug: 'vwan'
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
  windowsVirtualMachineScaleSet: {
    name: endsWith(take(replace(nt, ph, 'vmss'), 15), d)
      ? take(replace(nt, ph, 'vmss'), 15 - 1)
      : take(replace(nt, ph, 'vmss'), 15)
    nameUnique: endsWith(take(replace(nut, ph, 'vmss'), 15), d)
      ? take(replace(nut, ph, 'vmss'), 15 - 1)
      : take(replace(nut, ph, 'vmss'), 15)
    slug: 'vmss'
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
  aiSearch: ServiceNameType
  analysisServicesServer: ServiceNameType
  apiManagement: ServiceNameType
  appConfiguration: ServiceNameType
  appServiceEnvironment: ServiceNameType
  appServicePlan: ServiceNameType
  appService: ServiceNameType
  applicationGateway: ServiceNameType
  applicationInsights: ServiceNameType
  applicationSecurityGroup: ServiceNameType
  automationAccount: ServiceNameType
  automationCertificate: ServiceNameType
  automationCredential: ServiceNameType
  automationRunbook: ServiceNameType
  automationSchedule: ServiceNameType
  automationVariable: ServiceNameType
  availabilitySet: ServiceNameType
  bastionHost: ServiceNameType
  batchAccount: ServiceNameType
  batchApplication: ServiceNameType
  batchCertificate: ServiceNameType
  batchPool: ServiceNameType
  botChannelDirectline: ServiceNameType
  botChannelEmail: ServiceNameType
  botChannelMsTeams: ServiceNameType
  botChannelSlack: ServiceNameType
  botChannelsRegistration: ServiceNameType
  botConnection: ServiceNameType
  botWebApp: ServiceNameType
  cdnEndpoint: ServiceNameType
  cdnProfile: ServiceNameType
  chaosExperiment: ServiceNameType
  chaosTarget: ServiceNameType
  cognitiveAccount: ServiceNameType
  cognitiveServicesOpenAi: ServiceNameType
  cognitiveServicesComputerVision: ServiceNameType
  cognitiveServicesContentModerator: ServiceNameType
  cognitiveServicesContentSafety: ServiceNameType
  cognitiveServicesCustomVisionPrediction: ServiceNameType
  cognitiveServicesCustomVisionTraining: ServiceNameType
  cognitiveServicesDocumentIntelligence: ServiceNameType
  cognitiveServicesMultiServiceAccount: ServiceNameType
  cognitiveServicesVideoIndexer: ServiceNameType
  cognitiveServicesFaceApi: ServiceNameType
  cognitiveServicesImmersiveReader: ServiceNameType
  cognitiveServicesLanguageService: ServiceNameType
  cognitiveServicesSpeechService: ServiceNameType
  cognitiveServicesTranslator: ServiceNameType
  containerApps: ServiceNameType
  containerAppsEnvironment: ServiceNameType
  containerGroup: ServiceNameType
  containerRegistry: ServiceNameType
  containerRegistryWebhook: ServiceNameType
  cosmosdbAccount: ServiceNameType
  customProvider: ServiceNameType
  dashboard: ServiceNameType
  dataFactory: ServiceNameType
  dataFactoryDatasetMysql: ServiceNameType
  dataFactoryDatasetPostgresql: ServiceNameType
  dataFactoryDatasetSqlServerTable: ServiceNameType
  dataFactoryIntegrationRuntimeManaged: ServiceNameType
  dataFactoryLinkedServiceDataLakeStorageGen2: ServiceNameType
  dataFactoryLinkedServiceKeyVault: ServiceNameType
  dataFactoryLinkedServiceMysql: ServiceNameType
  dataFactoryLinkedServicePostgresql: ServiceNameType
  dataFactoryLinkedServiceSqlServer: ServiceNameType
  dataFactoryPipeline: ServiceNameType
  dataFactoryTriggerSchedule: ServiceNameType
  dataLakeAnalyticsAccount: ServiceNameType
  dataLakeAnalyticsFirewallRule: ServiceNameType
  dataLakeStore: ServiceNameType
  dataLakeStoreFirewallRule: ServiceNameType
  databaseMigrationProject: ServiceNameType
  databaseMigrationService: ServiceNameType
  databricksWorkspace: ServiceNameType
  devTestLab: ServiceNameType
  devTestLinuxVirtualMachine: ServiceNameType
  devTestWindowsVirtualMachine: ServiceNameType
  diskEncryptionSet: ServiceNameType
  dnsZone: ServiceNameType
  eventGridDomain: ServiceNameType
  eventGridDomainTopic: ServiceNameType
  eventGridEventSubscription: ServiceNameType
  eventGridTopic: ServiceNameType
  eventHub: ServiceNameType
  eventHubAuthorizationRule: ServiceNameType
  eventHubConsumerGroup: ServiceNameType
  eventHubNamespace: ServiceNameType
  eventHubNamespaceAuthorizationRule: ServiceNameType
  eventHubNamespaceDisasterRecoveryConfig: ServiceNameType
  expressRouteCircuit: ServiceNameType
  expressRouteGateway: ServiceNameType
  firewall: ServiceNameType
  firewallPolicy: ServiceNameType
  frontDoor: ServiceNameType
  frontDoorFirewallPolicy: ServiceNameType
  functionApp: ServiceNameType
  grafana: ServiceNameType
  hdInsightHadoopCluster: ServiceNameType
  hdInsightHbaseCluster: ServiceNameType
  hdInsightInteractiveQueryCluster: ServiceNameType
  hdInsightKafkaCluster: ServiceNameType
  hdInsightMlServicesCluster: ServiceNameType
  hdInsightRserverCluster: ServiceNameType
  hdInsightSparkCluster: ServiceNameType
  hdInsightStormCluster: ServiceNameType
  image: ServiceNameType
  iotCentralApplication: ServiceNameType
  iotHub: ServiceNameType
  iotHubConsumerGroup: ServiceNameType
  iotHubDps: ServiceNameType
  iotHubDpsCertificate: ServiceNameType
  keyVault: ServiceNameType
  keyVaultCertificate: ServiceNameType
  keyVaultKey: ServiceNameType
  keyVaultSecret: ServiceNameType
  kubernetesCluster: ServiceNameType
  kustoCluster: ServiceNameType
  kustoDatabase: ServiceNameType
  kustoEventHubDataConnection: ServiceNameType
  loadBalancer: ServiceNameType
  loadBalancerNatRule: ServiceNameType
  loadTesting: ServiceNameType
  linuxVirtualMachine: ServiceNameType
  linuxVirtualMachineScaleSet: ServiceNameType
  localNetworkGateway: ServiceNameType
  logicApp: ServiceNameType
  logAnalyticsWorkspace: ServiceNameType
  machineLearningWorkspace: ServiceNameType
  managedDisk: ServiceNameType
  managedIdentity: ServiceNameType
  mapsAccount: ServiceNameType
  mariadbDatabase: ServiceNameType
  mariadbFirewallRule: ServiceNameType
  mariadbServer: ServiceNameType
  mariadbVirtualNetworkRule: ServiceNameType
  mssqlDatabase: ServiceNameType
  mssqlElasticpool: ServiceNameType
  mssqlServer: ServiceNameType
  mysqlDatabase: ServiceNameType
  mysqlFirewallRule: ServiceNameType
  mysqlServer: ServiceNameType
  mysqlVirtualNetworkRule: ServiceNameType
  networkInterface: ServiceNameType
  networkSecurityGroup: ServiceNameType
  networkSecurityGroupRule: ServiceNameType
  networkSecurityRule: ServiceNameType
  networkWatcher: ServiceNameType
  notificationHub: ServiceNameType
  notificationHubAuthorizationRule: ServiceNameType
  notificationHubNamespace: ServiceNameType
  pointToSiteVpnGateway: ServiceNameType
  postgresqlDatabase: ServiceNameType
  postgresqlFirewallRule: ServiceNameType
  postgresqlServer: ServiceNameType
  postgresqlVirtualNetworkRule: ServiceNameType
  powerbiEmbedded: ServiceNameType
  privateDnsZone: ServiceNameType
  publicIp: ServiceNameType
  publicIpPrefix: ServiceNameType
  redisCache: ServiceNameType
  redisFirewallRule: ServiceNameType
  relayHybridConnection: ServiceNameType
  relayNamespace: ServiceNameType
  resourceGroup: ServiceNameType
  roleAssignment: ServiceNameType
  roleDefinition: ServiceNameType
  route: ServiceNameType
  routeTable: ServiceNameType
  serviceFabricCluster: ServiceNameType
  serviceFabricManagedCluster: ServiceNameType
  serviceBusNamespace: ServiceNameType
  serviceBusNamespaceAuthorizationRule: ServiceNameType
  serviceBusQueue: ServiceNameType
  serviceBusQueueAuthorizationRule: ServiceNameType
  serviceBusSubscription: ServiceNameType
  serviceBusSubscriptionRule: ServiceNameType
  serviceBusTopic: ServiceNameType
  serviceBusTopicAuthorizationRule: ServiceNameType
  sharedImage: ServiceNameType
  sharedImageGallery: ServiceNameType
  signalrService: ServiceNameType
  snapshots: ServiceNameType
  sqlElasticpool: ServiceNameType
  sqlFailoverGroup: ServiceNameType
  sqlFirewallRule: ServiceNameType
  sqlServer: ServiceNameType
  storageAccount: ServiceNameType
  storageBlob: ServiceNameType
  storageContainer: ServiceNameType
  storageDataLakeGen2Filesystem: ServiceNameType
  storageQueue: ServiceNameType
  storageShare: ServiceNameType
  storageShareDirectory: ServiceNameType
  storageTable: ServiceNameType
  streamAnalyticsFunctionJavascriptUdf: ServiceNameType
  streamAnalyticsJob: ServiceNameType
  streamAnalyticsOutputBlob: ServiceNameType
  streamAnalyticsOutputEventHub: ServiceNameType
  streamAnalyticsOutputMssql: ServiceNameType
  streamAnalyticsOutputServiceBusQueue: ServiceNameType
  streamAnalyticsOutputServiceBusTopic: ServiceNameType
  streamAnalyticsReferenceInputBlob: ServiceNameType
  streamAnalyticsStreamInputBlob: ServiceNameType
  streamAnalyticsStreamInputEventHub: ServiceNameType
  streamAnalyticsStreamInputIotHub: ServiceNameType
  subnet: ServiceNameType
  templateDeployment: ServiceNameType
  trafficManagerProfile: ServiceNameType
  virtualMachine: ServiceNameType
  virtualMachineScaleSet: ServiceNameType
  virtualNetwork: ServiceNameType
  virtualNetworkGateway: ServiceNameType
  virtualNetworkPeering: ServiceNameType
  virtualWan: ServiceNameType
  windowsVirtualMachine: ServiceNameType
  windowsVirtualMachineScaleSet: ServiceNameType
}
