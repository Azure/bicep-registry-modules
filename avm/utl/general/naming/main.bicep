metadata name = 'Resource naming'
metadata description = '''
Pure naming functions using the modern [Terraform naming utility](https://github.com/Azure/terraform-azure-avm-utl-naming) catalog. No resources, telemetry, randomness or name-availability checks are performed.

Import `getName`, `getNames` or `getNamesByResourceType` and pass an options object. Use a nonempty `uniqueSeed` for Terraform-compatible exact tokens, `uniqueLength: 0` for no token, or `uniqueIdentity` with optional `uniqueScope` and `uniqueAttempt` for Bicep-derived tokens. Reuse every input and pin the module version for in-place redeployment; change caller-owned identity for a fresh name. Derived tokens use the full, untruncated logical name and are limited to 13 characters. They are not Terraform random seeds. Hashes can collide; length and name availability remain the caller's responsibility.

Default rendering, prefixes/suffixes, casing, slugs, numbered instances, fixed names and property-level catalog overrides follow Terraform for ASCII inputs. Character counting and Unicode casing use native ARM semantics, which differ from Terraform's Unicode handling. Customer files are loaded by the caller with `loadJsonContent` and passed as `customOverrides`; schema_version and snake-case catalog properties stay unchanged. Omitted properties inherit; explicit values replace, including arrays and whole metadata objects.

Templates support `${token}`, `${lower(token)}`, `${upper(token)}`, joining prefix/suffix lists, and `join(separator, [token, ...])` with optional `compact`. Custom token names must be distinct ignoring case; names that collide with built-in tokens are rejected. Arbitrary HCL expressions, directives, indexing, nested function expressions and the frozen Terraform legacy renderer are not supported. Unsupported syntax returns errors and null names. Instance formats support a single `%d` or `%0Nd` with optional literal text, not arbitrary Terraform format expressions.

UUID entries use native Bicep `guid`, whose namespace differs from Terraform `uuidv5("url", ...)`; UUID values are therefore deliberately not cross-language identical. Literal names cannot retain instance or uniqueness tokens. Always inspect the retention flags before relying on them.

`nameAvailable` means rendering succeeded, not that Azure accepts or has the name available. Validation returns null, never true, when catalog constraints or native regex support are incomplete. Supported anchored ASCII character-class patterns and literals are compiled into validation descriptors without editing the upstream rules; other RE2 patterns (including Unicode classes and new customer patterns) remain explicitly unvalidated. `requireValidNames` rejects both invalid and incompletely validated candidates.

Upstream snapshots under `upstream` are byte-identical at the revision in `catalog-source.json`. Run `. .\utilities\tools\Sync-NamingCatalog.ps1; Sync-NamingCatalog -Check` from the repository root to verify hashes and lossless chunk recomposition. The downstream synchronization workflow proposes changes for review and never scrapes Azure rules or merges updates.

This module is under development at the proposed path in [Azure/Azure-Verified-Modules#3059](https://github.com/Azure/Azure-Verified-Modules/issues/3059); proposal filing does not establish program approval.
'''

import { generatedCatalog, manualCatalog, regexDescriptors } from './generated/catalog.bicep'

@export()
@description('A partial upstream version-2 resource rule. Supplied properties replace earlier properties, rather than recursively merging.')
@sealed()
type namingRuleType = {
  resource_type: string?
  variant: string?
  slug: string?
  slug_source: ('caf' | 'derived' | 'manual')?
  legacy_slug: string?
  legacy_outputs: string[]?
  min_length: int?
  max_length: int?
  scope: string?
  regex: string?
  dashes: bool?
  lowercase: bool?
  name_kind: ('standard' | 'uuid' | 'literal')?
  fixed_name: string?
  validation_complete: bool?
  validation_notes: string[]?
  forbidden_prefixes: string[]?
  forbidden_suffixes: string[]?
  forbidden_sequences: string[]?
  reserved_names: string[]?
  source: object?
  override_reason: string?
  override_source: string?
}

@export()
@description('The upstream customer-file shape. Load the file at compile time in the caller; file paths cannot be evaluated inside a naming function.')
type namingOverridesType = {
  schema_version: 2
  resources: {
    *: namingRuleType
  }
}

@export()
@description('Naming inputs. Empty options are valid for base names but require an explicit seed or identity to produce unique names.')
@sealed()
type namingOptionsType = {
  @description('Optional. Components before the slug. Null and empty components are removed.')
  prefix: (string?)[]?
  @description('Optional. Components after the slug. Null and empty components are removed.')
  suffix: (string?)[]?
  @description('Optional. Exact Terraform-compatible seed, used unchanged before taking uniqueLength characters. Cannot be combined with derived identity inputs.')
  uniqueSeed: string?
  @description('Optional. Maximum token length. Default 4; zero disables uniqueness. Derived tokens support at most 13 characters.')
  uniqueLength: int?
  @description('Optional. Stable caller-owned identity included in token derivation. Change it for a fresh attempt; hash collisions remain possible.')
  uniqueIdentity: string?
  @description('Optional. Caller-owned scope, such as a subscription ID; never discovered implicitly.')
  uniqueScope: string?
  @description('Optional. Caller-owned fresh-attempt identity. Omit or reuse for in-place retries.')
  uniqueAttempt: string?
  @description('Optional. Allow digits in derived tokens. Default true. Does not alter an explicit uniqueSeed.')
  uniqueIncludeNumbers: bool?
  @description('Optional. Nonnegative numeric instance. Zero is an explicit instance.')
  instance: int?
  @description('Optional. One %d or %0Nd conversion with literal text. Default %03d. Width is a minimum, not a cap.')
  instanceFormat: string?
  @description('Optional. Version-2 customer catalog loaded by the caller. Supplied properties replace generated and manual properties.')
  customOverrides: namingOverridesType?
  @description('Optional. Final slug overrides keyed by catalog key. Null inherits the catalog slug; an empty string omits it.')
  slugOverrides: {
    *: string?
  }?
  @description('Optional. Additional string template tokens with ASCII identifier names. Built-in names are reserved regardless of case, except the exact instance token when no numbered instance is supplied.')
  namingTemplateVariables: {
    *: string?
  }?
  @description('Optional. Supported Terraform template strings. Null selects the default rendering.')
  namingTemplates: {
    name: string?
    nameUnique: string?
  }?
  @description('Optional. Return null names unless all supported validation checks succeed. Default false, matching Terraform candidate-name behavior.')
  requireValidNames: bool?
}

var ruleDefaults = {
  resource_type: null
  variant: null
  slug: null
  slug_source: 'manual'
  legacy_slug: null
  legacy_outputs: []
  min_length: null
  max_length: null
  scope: null
  regex: null
  dashes: false
  lowercase: true
  name_kind: 'standard'
  fixed_name: null
  validation_complete: false
  validation_notes: []
  forbidden_prefixes: []
  forbidden_suffixes: []
  forbidden_sequences: []
  reserved_names: []
}

var defaultNameTemplate = '\${join(separator, compact([join(separator, prefix), slug, join(separator, suffix)]))}'
var defaultInstanceTemplate = '\${join(separator, compact([join(separator, prefix), slug, join(separator, suffix), instance]))}'
var defaultUniqueTemplate = '\${join(separator, compact([name, unique]))}'
var builtInTokens = [
  'name'
  'prefix'
  'suffix'
  'slug'
  'separator'
  'unique'
  'unique_seed'
  'instance'
  'terraform_key'
  'resource_type'
  'variant'
  'min_length'
  'max_length'
]

@export()
@description('Merged generated and manual catalog, retaining all upstream metadata and null constraints. This is not a validation guarantee.')
var namingCatalog = toObject(
  union(map(items(generatedCatalog), entry => entry.key), map(items(manualCatalog), entry => entry.key)),
  key => key,
  key => shallowMerge([ruleDefaults, generatedCatalog[?key] ?? {}, manualCatalog[?key] ?? {}])
)

@export()
@description('Inspect the raw catalog after a version-2 customer overlay, including invalid or incomplete entries. Uses whole-property replacement; getName performs rendering validation.')
func getCatalog(overrides namingOverridesType) object =>
  toObject(
    union(map(items(namingCatalog), entry => entry.key), map(items(overrides.resources), entry => entry.key)),
    key => key,
    key => shallowMerge([ruleDefaults, namingCatalog[?key] ?? {}, overrides.resources[?key] ?? {}])
  )

@export()
@description('Render one catalog key. Inspect nameErrors/nameUniqueErrors, validation and token-retention flags; no Azure availability check is made.')
func getName(resourceKey string, options namingOptionsType) object =>
  prepareName(
    resourceKey,
    options,
    shallowMerge([
      ruleDefaults
      generatedCatalog[?resourceKey] ?? {}
      manualCatalog[?resourceKey] ?? {}
      options.?customOverrides.?resources[?resourceKey] ?? {}
    ])
  )

@export()
@description('Render a selected list of catalog keys independently. Prefer a small selection to avoid copying unnecessary results into consumer templates.')
func getNames(resourceKeys string[], options namingOptionsType) object => toObject(union(resourceKeys, []), key => key, key => getName(key, options))

@export()
@description('Render every matching catalog variant for an exact Azure resource type. Variants remain keyed separately; no arbitrary first-match selection is made.')
func getNamesByResourceType(resourceType string, options namingOptionsType) object =>
  getNames(
    map(
      filter(
        items(getCatalog(options.?customOverrides ?? { schema_version: 2, resources: {} })),
        entry => entry.value.resource_type == resourceType
      ),
      entry => entry.key
    ),
    options
  )

func hasKey(value object, key string) bool => contains(map(items(value), entry => entry.key), key)
func isBundledKey(key string) bool =>
  key == toLower(key) && (contains(generatedCatalog, key) || contains(manualCatalog, key))
func compactStrings(values array) array => filter(values, value => value != null && value != '')
func startsExactly(value string, prefix string) bool =>
  length(value) >= length(prefix) && take(value, length(prefix)) == prefix
func endsExactly(value string, suffix string) bool =>
  length(value) >= length(suffix) && skip(value, length(value) - length(suffix)) == suffix
func characters(value string) array => map(range(0, length(value)), index => substring(value, index, 1))
func allCharacters(value string, allowed string) bool =>
  empty(filter(characters(value), character => !contains(allowed, character)))
func applyCase(value string, rule object) string => rule.lowercase ? toLower(value) : value
func bounded(value string, maximum int?) string => maximum == null ? value : take(value, max(0, maximum!))

func ruleErrors(key string, rule object) array =>
  compactStrings([
    empty(key) || !allCharacters(key, 'abcdefghijklmnopqrstuvwxyz0123456789_') || !contains(
        'abcdefghijklmnopqrstuvwxyz',
        take(key, 1)
      ) || contains(key, '__') || endsExactly(key, '_')
      ? 'Catalog keys must use lower snake case.'
      : ''
    rule.slug == null ? 'The merged rule requires a non-null string slug.' : ''
    rule.slug_source == null || rule.name_kind == null || rule.dashes == null || rule.lowercase == null || rule.validation_complete == null
      ? 'Required rule properties cannot be null.'
      : ''
    !empty(filter(
        [
          'legacy_outputs'
          'validation_notes'
          'forbidden_prefixes'
          'forbidden_suffixes'
          'forbidden_sequences'
          'reserved_names'
        ],
        field => rule[field] == null
      ))
      ? 'Rule lists cannot be null.'
      : ''
    rule.min_length != null && rule.min_length < 0 || rule.max_length != null && rule.max_length < 0
      ? 'Name bounds must be nonnegative.'
      : ''
    rule.min_length != null && rule.max_length != null && rule.min_length > rule.max_length
      ? 'min_length must not exceed max_length.'
      : ''
    rule.name_kind == 'literal' && rule.fixed_name == null ? 'Literal entries require fixed_name.' : ''
    rule.regex != null && ((contains(rule.regex, '\${min_length - 1}') && rule.min_length != null && rule.min_length < 1) || (contains(
        rule.regex,
        '\${max_length - 1}'
      ) && rule.max_length != null && rule.max_length < 1))
      ? 'Name bounds produce an invalid interpolated regex.'
      : ''
  ])

func optionErrors(key string, options namingOptionsType) array =>
  concat(
    compactStrings([
      !isBundledKey(key) && !hasKey(options.?customOverrides.?resources ?? {}, key)
        ? 'Unknown catalog key: ${key}.'
        : ''
      options.?customOverrides != null && (options.?customOverrides.?schema_version != 2 || hasKey(
          options.?customOverrides ?? {},
          'overrides'
        ))
        ? 'customOverrides must use the version-2 resources shape.'
        : ''
      !empty(filter(
          items(options.?slugOverrides ?? {}),
          entry => !isBundledKey(entry.key) && !hasKey(options.?customOverrides.?resources ?? {}, entry.key)
        ))
        ? 'Every slug override must identify a catalog entry.'
        : ''
      !empty(filter(
          items(options.?namingTemplateVariables ?? {}),
          entry => contains(builtInTokens, toLower(entry.key)) && (entry.key != 'instance' || options.?instance != null)
        ))
        ? 'Custom template variables cannot replace built-in tokens.'
        : ''
      !empty(filter(
          items(options.?namingTemplateVariables ?? {}),
          entry =>
            empty(entry.key) || !contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_', take(entry.key, 1)) || !allCharacters(
              entry.key,
              'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-'
            )
        ))
        ? 'Custom template token names must be ASCII identifiers.'
        : ''
      (options.?uniqueLength ?? 4) < 0 ? 'uniqueLength must be nonnegative.' : ''
      !empty(options.?uniqueSeed ?? '') && (options.?uniqueIdentity != null || options.?uniqueScope != null || options.?uniqueAttempt != null)
        ? 'Exact uniqueSeed and derived identity inputs are mutually exclusive.'
        : ''
      empty(options.?uniqueIdentity ?? '') && (options.?uniqueScope != null || options.?uniqueAttempt != null)
        ? 'uniqueScope and uniqueAttempt require uniqueIdentity.'
        : ''
      empty(options.?uniqueSeed ?? '') && !empty(options.?uniqueIdentity ?? '') && (options.?uniqueLength ?? 4) > 13
        ? 'Bicep-derived unique tokens have at most 13 characters; use an exact uniqueSeed for longer tokens.'
        : ''
      (options.?instance ?? 0) < 0 ? 'instance must be nonnegative.' : ''
    ]),
    flatten(map(
      items(options.?customOverrides.?resources ?? {}),
      entry =>
        map(
          ruleErrors(
            entry.key,
            shallowMerge([
              ruleDefaults
              generatedCatalog[?entry.key] ?? {}
              manualCatalog[?entry.key] ?? {}
              entry.value
            ])
          ),
          error => 'Invalid customer entry ${entry.key}: ${error}'
        )
    ))
  )

func formatInstance(instance int?, pattern string) object =>
  instance == null ? { value: null, errors: [] } : instanceFormatParts(instance!, split(pattern, '%'))
func instanceFormatParts(instance int, parts array) object =>
  length(parts) != 2 || !contains(parts[1], 'd')
    ? {
        value: ''
        errors: ['instanceFormat supports one %d or %0Nd conversion.']
      }
    : instanceFormatWidth(
        instance,
        parts[0],
        take(parts[1], indexOf(parts[1], 'd')),
        skip(parts[1], indexOf(parts[1], 'd') + 1)
      )
func instanceFormatWidth(instance int, prefix string, width string, suffix string) object =>
  !empty(width) && (!startsExactly(width, '0') || !allCharacters(width, '0123456789') || length(width) > 4) || contains(
      suffix,
      '%'
    )
    ? {
        value: ''
        errors: ['instanceFormat supports one %d or %0Nd conversion, with width at most 999.']
      }
    : {
        value: '${prefix}${join(map(range(0, max(0, (empty(width) ? 0 : int(width)) - length(string(instance)))), digit => '0'), '')}${instance}${suffix}'
        errors: []
      }

func prepareName(key string, options namingOptionsType, rule object) object =>
  checkedName(
    key,
    options,
    rule,
    concat(optionErrors(key, options), ruleErrors(key, rule)),
    formatInstance(options.?instance, options.?instanceFormat ?? '%03d')
  )
func checkedName(key string, options namingOptionsType, rule object, errors array, instance object) object =>
  !empty(errors) || !empty(instance.errors)
    ? {
        name: null
        nameUnique: null
        nameAvailable: false
        nameUniqueAvailable: false
        nameErrors: concat(errors, instance.errors)
        nameUniqueErrors: concat(errors, instance.errors)
        validationComplete: false
        validationNotes: ['Invalid inputs prevented rendering and validation.']
        validation: { validName: false, validNameUnique: false }
        terraformKey: key
        resourceType: rule.resource_type
        variant: rule.variant
        nameKind: rule.name_kind
        slug: options.?slugOverrides[?key] ?? rule.slug
        slugSource: selectedSlugSource(key, options, rule)
        separator: rule.dashes == null ? null : rule.dashes ? '-' : ''
        dashes: rule.dashes
        minLength: rule.min_length
        maxLength: rule.max_length
        scope: rule.scope
        regex: rule.regex
        instance: empty(instance.errors) ? instance.value : null
        uniqueSeed: options.?uniqueSeed
        uniqueSuffixRetained: false
        instanceRetained: { name: false, nameUnique: false }
        fitsMaxLength: null
        rule: rule
      }
    : renderBase(
        key,
        options,
        rule,
        {
          prefix: compactStrings(options.?prefix ?? [])
          suffix: compactStrings(options.?suffix ?? [])
          slug: options.?slugOverrides[?key] ?? rule.slug
          separator: rule.dashes ? '-' : ''
          instance: instance.value ?? options.?namingTemplateVariables.?instance
          terraform_key: key
          resource_type: rule.resource_type
          variant: rule.variant
          min_length: rule.min_length
          max_length: rule.max_length
        },
        instance.value
      )

func renderBase(key string, options namingOptionsType, rule object, context object, instance string?) object =>
  seedContext(
    key,
    options,
    rule,
    shallowMerge([options.?namingTemplateVariables ?? {}, context]),
    instance,
    applyCase(join(compactStrings(concat(context.prefix, [context.slug], context.suffix)), context.separator), rule)
  )

func seedContext(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  defaultBase string
) object =>
  renderNameStage(
    key,
    options,
    rule,
    context,
    instance,
    defaultBase,
    !empty(options.?uniqueSeed ?? '')
      ? options.uniqueSeed!
      : empty(options.?uniqueIdentity ?? '') || (options.?uniqueLength ?? 4) == 0
          ? null
          : identitySeed(
              uniqueString(string([
                'avm-bicep-naming-v1'
                key
                options.?uniqueIdentity
                options.?uniqueScope ?? ''
                options.?uniqueAttempt ?? ''
                context.prefix
                context.suffix
                context.slug
                context.separator
                context.instance
                context.resource_type
                context.variant
                context.min_length
                context.max_length
                map(items(options.?namingTemplateVariables ?? {}), entry => [entry.key, entry.value])
                options.?namingTemplates.?name
                options.?namingTemplates.?nameUnique
              ])),
              options.?uniqueIncludeNumbers ?? true
            )
  )
func identitySeed(value string, includeNumbers bool) string =>
  includeNumbers
    ? value
    : reduce(range(0, 10), value, (seed, digit) => replace(seed, string(digit), substring('abcdefghij', digit, 1)))

func renderNameStage(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  defaultBase string,
  seed string?
) object =>
  renderPrepared(
    key,
    options,
    rule,
    shallowMerge([context, { unique: take(seed ?? '', max(0, options.?uniqueLength ?? 4)), unique_seed: seed }]),
    instance,
    defaultBase,
    options.?namingTemplates.?name ?? (instance == null ? defaultNameTemplate : defaultInstanceTemplate),
    options.?namingTemplates.?nameUnique ?? defaultUniqueTemplate
  )

func renderPrepared(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  defaultBase string,
  nameTemplate string,
  uniqueTemplate string
) object =>
  renderBounded(
    key,
    options,
    rule,
    context,
    instance,
    defaultBase,
    nameTemplate,
    uniqueTemplate,
    instance != null && (options.?namingTemplates.?name == null || nameTemplate == defaultInstanceTemplate),
    nameTemplate == defaultNameTemplate || nameTemplate == defaultInstanceTemplate
      ? {
          value: join(
            compactStrings([defaultBase, nameTemplate == defaultInstanceTemplate ? instance : null]),
            context.separator
          )
          errors: []
        }
      : renderTemplate(nameTemplate, context),
    uniqueTemplate == defaultUniqueTemplate
      ? length(context.unique) + (empty(context.unique) ? 0 : length(context.separator))
      : max(0, length(renderTemplate(uniqueTemplate, shallowMerge([context, { name: 'x' }])).value) - 1)
  )

func renderBounded(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  defaultBase string,
  nameTemplate string,
  uniqueTemplate string,
  defaultInstance bool,
  rendered object,
  overhead int
) object =>
  renderUniqueStage(
    key,
    options,
    rule,
    context,
    instance,
    nameTemplate,
    uniqueTemplate,
    defaultInstance,
    rendered,
    applyCase(rendered.value, rule),
    defaultInstance
      ? join(
          compactStrings([
            bounded(
              defaultBase,
              rule.max_length == null
                ? null
                : rule.max_length - length(instance!) - (empty(defaultBase) ? 0 : length(context.separator))
            )
            applyCase(instance!, rule)
          ]),
          context.separator
        )
      : bounded(applyCase(rendered.value, rule), rule.max_length),
    rule.name_kind == 'uuid' && empty(context.unique) && uniqueTemplate == defaultUniqueTemplate
      ? applyCase(rendered.value, rule)
      : defaultInstance
          ? join(
              compactStrings([
                bounded(
                  defaultBase,
                  rule.max_length == null
                    ? null
                    : rule.max_length - overhead - length(instance!) - (empty(defaultBase)
                        ? 0
                        : length(context.separator))
                )
                applyCase(instance!, rule)
              ]),
              context.separator
            )
          : bounded(applyCase(rendered.value, rule), rule.max_length == null ? null : rule.max_length - overhead)
  )

func trimSuffixes(value string, suffixes array) string =>
  empty(suffixes) || empty(value)
    ? value
    : take(
        value,
        length(value) - max(reduce(
          range(1, length(value)),
          [0],
          (trimmed, size) =>
            concat(
              trimmed,
              empty(filter(
                  suffixes,
                  suffix =>
                    !empty(suffix) && length(suffix) <= size && contains(trimmed, size - length(suffix)) && substring(
                      value,
                      length(value) - size,
                      length(suffix)
                    ) == suffix
                ))
                ? []
                : [size]
            )
        ))
      )

func renderUniqueStage(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  nameTemplate string,
  uniqueTemplate string,
  defaultInstance bool,
  rendered object,
  base string,
  nameBounded string,
  uniqueBase string
) object =>
  renderFinal(
    key,
    options,
    rule,
    context,
    instance,
    nameTemplate,
    uniqueTemplate,
    defaultInstance,
    rendered,
    base,
    rule.name_kind == 'literal'
      ? rule.fixed_name
      : rule.name_kind == 'uuid'
          ? guid('urn:avm:naming:${key}:${base}')
          : trimSuffixes(nameBounded, rule.forbidden_suffixes),
    trimSuffixes(uniqueBase, rule.forbidden_suffixes),
    uniqueTemplate == defaultUniqueTemplate
      ? {
          value: join(
            compactStrings([trimSuffixes(uniqueBase, rule.forbidden_suffixes), context.unique]),
            context.separator
          )
          errors: []
        }
      : renderTemplate(
          uniqueTemplate,
          shallowMerge([context, { name: trimSuffixes(uniqueBase, rule.forbidden_suffixes) }])
        )
  )

func renderFinal(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  nameTemplate string,
  uniqueTemplate string,
  defaultInstance bool,
  rendered object,
  base string,
  name string,
  uniqueBase string,
  uniqueRendered object
) object =>
  retentionStage(
    key,
    options,
    rule,
    context,
    instance,
    nameTemplate,
    uniqueTemplate,
    defaultInstance,
    rendered,
    base,
    name,
    uniqueBase,
    uniqueRendered,
    rule.name_kind == 'literal'
      ? rule.fixed_name
      : rule.name_kind == 'uuid'
          ? guid('urn:avm:naming:${key}:${applyCase(uniqueRendered.value, rule)}')
          : applyCase(uniqueRendered.value, rule),
    instance == null || defaultInstance ? -1 : instancePosition(nameTemplate, context, base, key)
  )

func probeMarkers(key string) array => ['avmnaming${uniqueString(key)}markera', 'avmnaming${uniqueString(key)}markerb']
func interpolated(template string, context object, token string, value string, rendered string, key string) bool =>
  empty(filter(
    probeMarkers(key),
    marker =>
      !contains(toLower(renderTemplate(template, shallowMerge([context, { '${token}': marker }])).value), marker) || replace(
        toLower(renderTemplate(template, shallowMerge([context, { '${token}': marker }])).value),
        marker,
        toLower(value)
      ) != toLower(rendered)
  ))
func instancePosition(template string, context object, rendered string, key string) int =>
  !interpolated(template, context, 'instance', context.instance, rendered, key)
    ? -1
    : indexOf(
        toLower(renderTemplate(template, shallowMerge([context, { instance: probeMarkers(key)[0] }])).value),
        probeMarkers(key)[0]
      )
func retainedAt(value string, position int, token string) bool =>
  position >= 0 && length(value) >= position + length(token) && toLower(substring(value, position, length(token))) == toLower(token)

func retentionStage(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  nameTemplate string,
  uniqueTemplate string,
  defaultInstance bool,
  rendered object,
  base string,
  name string,
  uniqueBase string,
  uniqueRendered object,
  uniqueName string,
  instancePosition int
) object =>
  resultStage(
    key,
    options,
    rule,
    context,
    instance,
    name,
    uniqueName,
    rendered.errors,
    uniqueRendered.errors,
    instance == null
      ? true
      : rule.name_kind == 'literal'
          ? false
          : rule.name_kind == 'uuid'
              ? (defaultInstance || interpolated(nameTemplate, context, 'instance', instance!, base, key))
              : defaultInstance
                  ? endsExactly(toLower(name), toLower(instance!))
                  : retainedAt(name, instancePosition, instance!),
    empty(context.unique)
      ? true
      : rule.name_kind == 'literal'
          ? false
          : uniqueTemplate == defaultUniqueTemplate || interpolated(
              uniqueTemplate,
              shallowMerge([context, { name: uniqueBase }]),
              'unique',
              context.unique,
              uniqueRendered.value,
              key
            ),
    instance == null
      ? true
      : rule.name_kind == 'literal'
          ? false
          : uniqueInstanceRetained(
              key,
              context,
              instance!,
              uniqueTemplate,
              uniqueBase,
              uniqueRendered.value,
              defaultInstance
                ? (endsExactly(toLower(uniqueBase), toLower(instance!)) ? length(uniqueBase) - length(instance!) : -1)
                : retainedAt(uniqueBase, instancePosition, instance!) ? instancePosition : -1
            )
  )

func uniqueInstanceRetained(
  key string,
  context object,
  instance string,
  template string,
  base string,
  rendered string,
  position int
) bool =>
  template == defaultUniqueTemplate
    ? position >= 0
    : empty(filter(
        probeMarkers(key),
        marker =>
          !contains(
            toLower(renderTemplate(
              template,
              shallowMerge([
                context
                {
                  instance: marker
                  name: position < 0
                    ? base
                    : '${take(base, position)}${marker}${skip(base, position + length(instance))}'
                }
              ])
            ).value),
            marker
          ) || replace(
            toLower(renderTemplate(
              template,
              shallowMerge([
                context
                {
                  instance: marker
                  name: position < 0
                    ? base
                    : '${take(base, position)}${marker}${skip(base, position + length(instance))}'
                }
              ])
            ).value),
            marker,
            toLower(instance)
          ) != toLower(rendered)
      ))

func resultStage(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  name string,
  uniqueName string,
  nameTemplateErrors array,
  uniqueTemplateErrors array,
  nameInstance bool,
  uniqueRetained bool,
  uniqueInstance bool
) object =>
  validatedResult(
    key,
    options,
    rule,
    context,
    instance,
    name,
    uniqueName,
    nameInstance,
    uniqueRetained,
    uniqueInstance,
    concat(
      nameTemplateErrors,
      compactStrings([
        rule.max_length != null && length(name) > rule.max_length
          ? 'The name exceeds max_length while retaining its instance.'
          : ''
        rule.name_kind != 'literal' && !nameInstance ? 'The complete instance token was omitted or truncated.' : ''
      ])
    ),
    concat(
      nameTemplateErrors,
      uniqueTemplateErrors,
      compactStrings([
        (options.?uniqueLength ?? 4) > 0 && empty(context.unique_seed ?? '')
          ? 'Unique names require a nonempty uniqueSeed or uniqueIdentity; use uniqueLength: 0 to disable uniqueness.'
          : ''
        rule.max_length != null && length(uniqueName) > rule.max_length
          ? 'The unique name exceeds max_length; shorten the template or tokens.'
          : ''
        rule.name_kind != 'literal' && !uniqueRetained
          ? 'The unique template must retain the complete unique token.'
          : ''
        rule.name_kind != 'literal' && !uniqueInstance
          ? 'The unique template omitted or truncated the complete instance token.'
          : ''
      ])
    ),
    validateCandidate(name, rule),
    validateCandidate(uniqueName, rule)
  )

func validatedResult(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  name string,
  uniqueName string,
  nameInstance bool,
  uniqueRetained bool,
  uniqueInstance bool,
  nameErrors array,
  uniqueErrors array,
  nameValidation object,
  uniqueValidation object
) object =>
  finalResult(
    key,
    options,
    rule,
    context,
    instance,
    name,
    uniqueName,
    nameInstance,
    uniqueRetained,
    uniqueInstance,
    concat(
      nameErrors,
      options.?requireValidNames == true && nameValidation.valid != true
        ? ['Name validation failed or is incomplete.']
        : []
    ),
    concat(
      uniqueErrors,
      options.?requireValidNames == true && uniqueValidation.valid != true
        ? ['Unique-name validation failed or is incomplete.']
        : []
    ),
    nameValidation,
    uniqueValidation
  )

func finalResult(
  key string,
  options namingOptionsType,
  rule object,
  context object,
  instance string?,
  name string,
  uniqueName string,
  nameInstance bool,
  uniqueRetained bool,
  uniqueInstance bool,
  nameErrors array,
  uniqueErrors array,
  nameValidation object,
  uniqueValidation object
) object => {
  name: empty(nameErrors) ? name : null
  nameUnique: empty(uniqueErrors) ? uniqueName : null
  nameAvailable: empty(nameErrors)
  nameUniqueAvailable: empty(uniqueErrors)
  nameErrors: nameErrors
  nameUniqueErrors: uniqueErrors
  terraformKey: key
  resourceType: rule.resource_type
  variant: rule.variant
  nameKind: rule.name_kind
  slug: context.slug
  slugSource: selectedSlugSource(key, options, rule)
  separator: context.separator
  dashes: rule.dashes
  minLength: rule.min_length
  maxLength: rule.max_length
  scope: rule.scope
  regex: resolvedRegex(rule)
  instance: instance
  uniqueSeed: context.unique_seed
  uniqueSuffixRetained: uniqueRetained
  instanceRetained: { name: nameInstance, nameUnique: uniqueInstance }
  fitsMaxLength: rule.max_length == null ? null : length(uniqueName) <= rule.max_length
  validationComplete: nameValidation.complete
  validationNotes: nameValidation.notes
  validation: {
    validName: empty(nameErrors) ? nameValidation.valid : false
    validNameUnique: empty(uniqueErrors) ? uniqueValidation.valid : false
  }
  rule: rule
}

func selectedSlugSource(key string, options namingOptionsType, rule object) string? =>
  options.?slugOverrides[?key] != null
    ? 'override'
    : options.?customOverrides.?resources[?key].?slug != null
        ? 'customer'
        : manualCatalog[?key].?slug != null ? 'manual' : rule.slug_source

func resolvedRegex(rule object) string? =>
  rule.regex == null
    ? null
    : replace(
        replace(
          replace(
            replace(
              rule.regex,
              '\${min_length - 1}',
              rule.min_length == null ? '\${min_length - 1}' : string(rule.min_length - 1)
            ),
            '\${max_length - 1}',
            rule.max_length == null ? '\${max_length - 1}' : string(rule.max_length - 1)
          ),
          '\${min_length}',
          rule.min_length == null ? '\${min_length}' : string(rule.min_length)
        ),
        '\${max_length}',
        rule.max_length == null ? '\${max_length}' : string(rule.max_length)
      )

func validateCandidate(value string, rule object) object =>
  validateWithDescriptor(value, rule, filter(regexDescriptors, entry => entry.pattern == rule.regex))
func validateWithDescriptor(value string, rule object, descriptors array) object => {
  complete: rule.validation_complete && rule.min_length != null && rule.max_length != null && rule.regex != null && !empty(descriptors)
  notes: union(
    rule.validation_notes,
    rule.min_length == null || rule.max_length == null || rule.regex == null
      ? ['Validation is incomplete while min_length, max_length, or regex is null.']
      : [],
    !rule.validation_complete && rule.min_length != null && rule.max_length != null && rule.regex != null && empty(rule.validation_notes)
      ? ['Validation completeness has not been specified for this entry.']
      : [],
    rule.regex != null && empty(descriptors)
      ? ['Bicep cannot evaluate this RE2 pattern; validation is incomplete.']
      : []
  )
  valid: !rule.validation_complete || rule.min_length == null || rule.max_length == null || rule.regex == null || empty(descriptors)
    ? null
    : length(value) >= rule.min_length && length(value) <= rule.max_length && matchesDescriptor(
        value,
        descriptors[0].descriptor
      ) && empty(filter(rule.forbidden_prefixes, prefix => startsExactly(value, prefix))) && empty(filter(
        rule.forbidden_suffixes,
        suffix => endsExactly(value, suffix)
      )) && empty(filter(rule.forbidden_sequences, sequence => contains(value, sequence))) && !contains(
        map(rule.reserved_names, reserved => toLower(reserved)),
        toLower(value)
      )
}
func matchesDescriptor(value string, descriptor object) bool =>
  descriptor.kind == 'literal'
    ? value == descriptor.value
    : descriptor.kind == 'uuid'
        ? length(value) == 36 && length(replace(value, '-', '')) == 32 && map(
            [8, 13, 18, 23],
            position => substring(value, position, 1)
          ) == ['-', '-', '-', '-'] && allCharacters(replace(value, '-', ''), '0123456789abcdefABCDEF')
        : length(value) == 1 && descriptor.single != null
            ? contains(descriptor.single, value)
            : length(value) < descriptor.minimum || descriptor.maximum != null && length(value) > descriptor.maximum
                ? false
                : empty(value)
                    ? descriptor.minimum == 0
                    : contains(descriptor.first, take(value, 1)) && contains(
                        descriptor.last,
                        substring(value, max(0, length(value) - 1), 1)
                      ) && allCharacters(substring(value, 1, max(0, length(value) - 2)), descriptor.middle)

func renderTemplate(template string, context object) object =>
  templateParts(split(template, '\${'), context, contains(template, '%{') || contains(template, '$\${'))
func templateParts(parts array, context object, unsupported bool) object =>
  reduce(
    skip(parts, 1),
    {
      value: parts[0]
      errors: unsupported ? ['Template directives and escaped interpolation are not supported.'] : []
    },
    (state, part) => appendInterpolation(state, part, context)
  )
func appendInterpolation(state object, part string, context object) object =>
  !contains(part, '}')
    ? {
        value: state.value
        errors: concat(state.errors, ['Unclosed template interpolation.'])
      }
    : appendExpression(
        state,
        skip(part, indexOf(part, '}') + 1),
        templateExpression(trim(take(part, indexOf(part, '}'))), context)
      )
func appendExpression(state object, literal string, expression object) object => {
  value: '${state.value}${expression.value}${literal}'
  errors: concat(state.errors, expression.errors)
}
func templateExpression(expression string, context object) object =>
  startsExactly(expression, 'join(separator, ') && endsExactly(expression, ')')
    ? templateJoin(trim(substring(expression, 16, max(0, length(expression) - 17))), context)
    : scalarExpression(expression, context)
func templateJoin(expression string, context object) object =>
  expression == 'prefix' || expression == 'suffix'
    ? {
        value: join(context[expression], context.separator)
        errors: []
      }
    : expression == '[]' || expression == 'compact([])'
        ? { value: '', errors: [] }
        : startsExactly(expression, 'compact([') && endsExactly(expression, '])')
            ? joinExpressions(split(substring(expression, 9, max(0, length(expression) - 11)), ','), context, true)
            : startsExactly(expression, '[') && endsExactly(expression, ']')
                ? joinExpressions(split(substring(expression, 1, max(0, length(expression) - 2)), ','), context, false)
                : {
                    value: ''
                    errors: ['Unsupported join expression: ${expression}.']
                  }
func joinExpressions(expressions array, context object, compact bool) object =>
  joinRendered(map(expressions, expression => scalarExpression(trim(expression), context)), context.separator, compact)
func joinRendered(expressions array, separator string, compact bool) object => {
  value: join(
    compact
      ? compactStrings(map(expressions, expression => expression.value))
      : map(expressions, expression => expression.value),
    separator
  )
  errors: flatten(map(expressions, expression => expression.errors))
}
func scalarExpression(expression string, context object) object =>
  startsExactly(expression, 'lower(') && endsExactly(expression, ')')
    ? caseExpression(tokenExpression(trim(substring(expression, 6, max(0, length(expression) - 7))), context), false)
    : startsExactly(expression, 'upper(') && endsExactly(expression, ')')
        ? caseExpression(tokenExpression(trim(substring(expression, 6, max(0, length(expression) - 7))), context), true)
        : startsExactly(expression, '"') && endsExactly(expression, '"') && !contains(expression, '\\') && length(split(
              expression,
              '"'
            )) == 3
            ? {
                value: substring(expression, 1, max(0, length(expression) - 2))
                errors: []
              }
            : tokenExpression(expression, context)
func caseExpression(expression object, upper bool) object => {
  value: upper ? toUpper(expression.value) : toLower(expression.value)
  errors: expression.errors
}
func tokenExpression(token string, context object) object =>
  !hasKey(context, token) || token == 'prefix' || token == 'suffix'
    ? {
        value: ''
        errors: ['Unsupported template token or expression: ${token}.']
      }
    : context[token] == null
        ? {
            value: ''
            errors: ['Template token ${token} is null.']
          }
        : { value: string(context[token]), errors: [] }
