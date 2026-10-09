using none

import { getName, getNames, getNamesByResourceType, getCatalog, namingCatalog } from '../../main.bicep'

var seed = { uniqueSeed: 'a1b2c3d4' }
var identity = {
  prefix: ['Contoso']
  suffix: ['workload', 'dev']
  uniqueIdentity: 'local-run-001'
  uniqueScope: 'subscription-001'
  uniqueLength: 13
}
var longPrefix = [join(map(range(0, 100), i => 'a'), '')]
var instance = { uniqueSeed: 'abcd1234', suffix: ['workload', 'dev'], instance: 1 }
var simpleTemplate = {
  uniqueLength: 0
  instance: 1
  namingTemplateVariables: { environment: 'dev', location: 'uks' }
  namingTemplates: { name: '\${slug}\${separator}\${environment}\${separator}\${location}\${separator}\${instance}' }
}
var custom = loadJsonContent('./overrides.json')

param baseline = getNames(map(items(namingCatalog), entry => entry.key), seed)
param cases = {
  noSeed: getName('storage_account', {})
  seedZero: getName('storage_account', { uniqueLength: 0 })
  seedUnchanged: getName('resource_group', { uniqueSeed: 'AB12z', uniqueLength: 4, uniqueIncludeNumbers: false })
  shortSeed: getName('storage_account', { uniqueSeed: 'z', uniqueLength: 8 })
  compact: getName('resource_group', { prefix: ['', 'Team', null, ''], suffix: ['', null, 'Dev', ''], uniqueLength: 0 })
  repeated: [getName('storage_account', identity), getName('storage_account', identity)]
  fresh: getName('storage_account', shallowMerge([identity, { uniqueAttempt: 'attempt-002' }]))
  changedIdentity: getName('storage_account', shallowMerge([identity, { uniqueIdentity: 'local-run-002' }]))
  changedScope: getName('storage_account', shallowMerge([identity, { uniqueScope: 'subscription-002' }]))
  orderedVariables: [
    getName(
      'storage_account',
      shallowMerge([identity, { namingTemplateVariables: { team: 'infra', environment: 'dev' } }])
    )
    getName(
      'storage_account',
      shallowMerge([identity, { namingTemplateVariables: { environment: 'dev', team: 'infra' } }])
    )
  ]
  letters: getName('storage_account', shallowMerge([identity, { uniqueIncludeNumbers: false }]))
  fullIdentityA: getName('storage_account', { uniqueIdentity: 'same', prefix: longPrefix, suffix: ['first'] })
  fullIdentityB: getName('storage_account', { uniqueIdentity: 'same', prefix: longPrefix, suffix: ['second'] })
  instance: getName('storage_account', instance)
  instanceZero: getName('resource_group', shallowMerge([instance, { instance: 0 }]))
  instanceLarge: getName('resource_group', shallowMerge([instance, { instance: 1000 }]))
  instanceWidth: getName('resource_group', shallowMerge([instance, { instance: 20, instanceFormat: '%02d' }]))
  instanceUnpadded: getName('resource_group', shallowMerge([instance, { instance: 20, instanceFormat: '%d' }]))
  instanceLong: getName('storage_account', shallowMerge([instance, { prefix: longPrefix }]))
  instanceLongOther: getName('storage_account', shallowMerge([instance, { prefix: longPrefix, instance: 20 }]))
  instanceOversized: getName('storage_account', shallowMerge([instance, { instanceFormat: '%030d' }]))
  instanceInvalid: getName('storage_account', shallowMerge([instance, { instance: -1 }]))
  formatInvalid: getName('storage_account', shallowMerge([instance, { instanceFormat: '%f' }]))
  simpleTemplate: getName('storage_account', simpleTemplate)
  literalTemplate: getName(
    'storage_account',
    shallowMerge([simpleTemplate, { namingTemplates: { name: '\${slug}-\${environment}-\${location}-\${instance}' } }])
  )
  joinedTemplate: getName('resource_group', {
    uniqueSeed: 'abcd'
    namingTemplateVariables: { environment: 'dev', location: 'uks' }
    namingTemplates: {
      name: '\${join(separator, compact([slug, environment, location]))}'
      nameUnique: '\${join(separator, compact([unique, name]))}'
    }
  })
  prefixTemplate: getName(
    'resource_group',
    { uniqueLength: 0, prefix: ['a', 'b'], namingTemplates: { name: '\${join(separator, prefix)}' } }
  )
  upperTemplate: getName(
    'resource_group',
    { uniqueSeed: 'abcd', namingTemplates: { nameUnique: '\${name}\${upper(unique)}' } }
  )
  instanceUpper: getName(
    'resource_group',
    shallowMerge([
      instance
      { instanceFormat: 'id%03d', namingTemplates: { name: '\${join(separator, [upper(instance), slug])}' } }
    ])
  )
  instanceMissing: getName(
    'storage_account',
    shallowMerge([instance, { prefix: ['001'], namingTemplates: { name: '\${slug}' } }])
  )
  instanceUniqueOnly: getName(
    'resource_group',
    shallowMerge([
      instance
      { namingTemplates: { name: '\${slug}', nameUnique: '\${join(separator, [name, instance, unique])}' } }
    ])
  )
  uniqueMissing: getName(
    'storage_account',
    { uniqueSeed: 'p', prefix: ['prod'], namingTemplates: { nameUnique: '\${name}' } }
  )
  unsupportedTemplate: getName(
    'resource_group',
    { uniqueSeed: 'abcd', namingTemplates: { name: '\${format("%d", 1)}' } }
  )
  malformedLiteral: getName('resource_group', { uniqueSeed: 'abcd', namingTemplates: { name: '\${"a" + "b"}' } })
  escapedTemplate: getName('resource_group', { uniqueSeed: 'abcd', namingTemplates: { name: '$\${slug}' } })
  emptyJoin: getName('resource_group', { uniqueLength: 0, namingTemplates: { name: '\${join(separator, [])}' } })
  unknownToken: getName('storage_account', { uniqueSeed: 'abcd', namingTemplates: { name: '\${noSuchToken}' } })
  unclosedTemplate: getName('storage_account', { uniqueSeed: 'abcd', namingTemplates: { name: '\${slug' } })
  invalidReservedToken: getName('storage_account', { uniqueSeed: 'abcd', namingTemplateVariables: { slug: 'other' } })
  invalidReservedTokenCase: getName('resource_group', {
    uniqueLength: 0
    namingTemplateVariables: { SLUG: 'other' }
    namingTemplates: { name: '\${SLUG}' }
  })
  invalidInstanceTokenCase: getName('resource_group', {
    uniqueLength: 0
    namingTemplateVariables: { INSTANCE: 'other' }
  })
  upperCustomToken: getName('resource_group', {
    uniqueLength: 0
    namingTemplateVariables: { TEAM: 'blue' }
    namingTemplates: { name: '\${TEAM}' }
  })
  exactAndIdentity: getName('storage_account', shallowMerge([identity, seed]))
  identityMissing: getName('storage_account', { uniqueScope: 'scope' })
  identityTooLong: getName('storage_account', { uniqueIdentity: 'id', uniqueLength: 14 })
  unknownKey: getName('STORAGE_ACCOUNT', seed)
  invalidSlugKey: getName('storage_account', { uniqueSeed: 'abcd', slugOverrides: { not_a_key: 'bad' } })
  fixed: getName('storage_account_blob_service', shallowMerge([instance, { prefix: longPrefix }]))
  uuid: getName('role_assignment', seed)
  uuidZero: getName('role_assignment', { uniqueLength: 0, suffix: ['one'] })
  uuidOther: getName('role_assignment', { uniqueLength: 0, suffix: ['two'] })
  custom: getName('storage_account', { prefix: ['Contoso'], uniqueSeed: 'abcd', customOverrides: custom })
  customStrict: getName(
    'storage_account',
    { prefix: ['Contoso'], uniqueSeed: 'abcd', customOverrides: custom, requireValidNames: true }
  )
  customNew: getName('organization_label', { uniqueLength: 0, customOverrides: custom })
  customSlug: getName(
    'storage_account',
    { uniqueLength: 0, customOverrides: custom, slugOverrides: { storage_account: 'override' } }
  )
  invalidBounds: getName('storage_account', {
    uniqueLength: 0
    customOverrides: { schema_version: 2, resources: { storage_account: { min_length: 20, max_length: 2 } } }
  })
  nullBoolean: getName(
    'storage_account',
    { uniqueLength: 0, customOverrides: { schema_version: 2, resources: { storage_account: { lowercase: null } } } }
  )
  nullList: getName('storage_account', {
    uniqueLength: 0
    customOverrides: { schema_version: 2, resources: { storage_account: { forbidden_suffixes: null } } }
  })
  invalidInterpolatedRegex: getName('storage_account', {
    uniqueLength: 0
    customOverrides: {
      schema_version: 2
      resources: {
        storage_account: { min_length: 0, regex: '^[a-zA-Z0-9][a-zA-Z0-9_-]{\${min_length - 1},\${max_length - 1}}$' }
      }
    }
  })
  unrelatedInvalidEntry: getName('storage_account', {
    uniqueLength: 0
    customOverrides: { schema_version: 2, resources: { other_entry: { slug: 'x', min_length: 5, max_length: 1 } } }
  })
  invalidNewEntry: getName(
    'missing_slug',
    { uniqueLength: 0, customOverrides: { schema_version: 2, resources: { missing_slug: { min_length: 1 } } } }
  )
  unsupportedRegex: getName('storage_account', {
    uniqueSeed: 'abcd'
    customOverrides: { schema_version: 2, resources: { storage_account: { regex: '^custom.*$' } } }
  })
  strictValid: getName('storage_account', { uniqueSeed: 'abcd', suffix: ['dev'], requireValidNames: true })
  strictInvalid: getName('storage_account', { uniqueSeed: 'abcd', prefix: ['bad-'], requireValidNames: true })
  caseSensitiveBoundary: getName('storage_account', {
    uniqueLength: 0
    customOverrides: {
      schema_version: 2
      resources: {
        storage_account: { slug: 'Ab', lowercase: false, forbidden_prefixes: ['a'], forbidden_suffixes: ['B'] }
      }
    }
  })
  suffixChain: getName('storage_account', {
    uniqueLength: 0
    customOverrides: {
      schema_version: 2
      resources: { storage_account: { slug: 'zbaba', forbidden_suffixes: ['a', 'ba'] } }
    }
  })
  longForbiddenSuffix: getName('storage_account', {
    uniqueLength: 0
    customOverrides: { schema_version: 2, resources: { storage_account: { forbidden_suffixes: ['longerthanslug'] } } }
  })
}
param selected = getNames(['storage_account', 'resource_group', 'storage_account', 'unknown_key'], seed)
param nullableCases = {
  inheritedSlug: getName('storage_account', { uniqueSeed: 'abcd', slugOverrides: { storage_account: null } })
  customInstance: getName('resource_group', {
    uniqueSeed: 'abcd'
    namingTemplateVariables: { instance: 'blue' }
    namingTemplates: { name: '\${slug}-\${instance}' }
  })
  instanceConflict: getName(
    'resource_group',
    { uniqueSeed: 'abcd', instance: 1, namingTemplateVariables: { instance: 'blue' } }
  )
  invalidIdentifier: getName(
    'resource_group',
    { uniqueSeed: 'abcd', namingTemplateVariables: { 'a.b': 'blue' }, namingTemplates: { name: '\${a.b}' } }
  )
  nullToken: getName(
    'resource_group',
    { uniqueSeed: 'abcd', namingTemplateVariables: { team: null }, namingTemplates: { name: '\${team}' } }
  )
  unusedNullToken: getName('resource_group', { uniqueSeed: 'abcd', namingTemplateVariables: { team: null } })
}
param variants = getNamesByResourceType('Microsoft.Compute/virtualMachines', seed)
param merged = {
  storage: getCatalog(custom).storage_account
  site: getCatalog(custom).site_web_app
  untouched: getCatalog(custom).resource_group
}
