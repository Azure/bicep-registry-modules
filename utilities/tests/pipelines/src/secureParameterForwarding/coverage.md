# Parent-to-child secure input checks

`SecureParameterForwarding.Tests.ps1` freshly compiles `avm/res/api-management/service`, `avm/res/app/managed-environment`, and `avm/res/sql/server`, then walks their embedded deployments. These are the three module families already covered by the compile-only secure-parameter workflow. This is not a whole-repository release gate. Unreferenced child files, registry versions not embedded in those builds, examples, and intentional plain-caller compatibility fixtures are outside the production scan.

The check starts with each child's compiled secure schema, not credential-looking names or a list of known fields. It compares the forwarded parent input's schema, including nested objects, arrays, local `$ref` aliases, nullable types, discriminator branches, and secure ancestors. A new arbitrary secure child input therefore needs equivalent parent typing. Ordinary sibling fields do not need to become secure.

This is AVM production-interface hygiene under [BCPNFR9](https://azure.github.io/Azure-Verified-Modules/spec/BCPNFR9) and [BCPNFR21](https://azure.github.io/Azure-Verified-Modules/spec/BCPNFR21), not a universal Bicep error. Bicep deliberately allows ordinary caller inputs to bind to secure child parameters. The fixtures in this directory test that distinction and never deploy.

## Supported analysis

The helper recognizes a small set of **complete emitted ARM forms**, not fragments in an arbitrary expression:

- `parameters('name')`, with identifier property accesses (`.name` or `['name']`).
- Literal array indices and `copyIndex()` / `copyIndex('name')`, normalized to the item schema. This covers straightforward module loops.
- `tryGet(path, 'property', ...)`, including nested optional accesses.
- `coalesce(path, createArray())`, `createObject()`, or `null()`.
- A final simple `coalesce` fallback of `''` or `parameters('name')`; both branches are checked.
- Whole typed objects/arrays, and literal object/array constructors with individual forwarded leaves.

Literal values (including escaped ARM strings), omitted inputs, optional nulls, ARM Key Vault parameter references, and direct runtime `reference(...)` / `list*(...)` results are not caller-input mismatches. We do not inspect resource internals or claim those values are safe. A direct `newGuid()` is not a caller input; a parameter with that default is still overridable and is checked normally.

Variables, transformations, conditionals, dynamic property/index expressions, lambdas, arbitrary projections, and discriminated-object constructors containing expressions are **Unsupported**, not inferred safe. Entirely literal discriminated constructors are non-inputs. There is no variable expansion, resource-flow tracing, or general taint analysis. Unfamiliar identifiers/access shapes are unsupported rather than guessed. Secure `additionalProperties` sinks, unsupported union-schema keywords, unresolved/cyclic references, linked templates, malformed templates, and compilation failures fail the scan. Nullability alone never implies security.

The repository has schema-walking helpers but no reusable ARM expression parser. This bounded recognizer avoids adding a general-purpose parser or a new toolchain. Extending it should start with a real compiler fixture; broader expression analysis belongs in a compiler-semantic implementation, not increasingly permissive regular expressions.

## Deliberate exceptions and follow-ups

`exceptions.json` matches the module, deployment path, target leaf, sink type, source path, and finding status exactly. Exceptions emit warnings and must still match a current finding, so stale entries fail. There are no deployment-wide, field-name-wide, or secure-object-wide exclusions.

1. **Workspace logger credentials:** `service_workspaces/workspace_loggers` takes a plain `loggers[].credentials` object into a secure child object. This existing mismatch is deferred. The service-level logger credentials object is already secure. The exception cannot hide a new `secureString` binding or a different input leaf.
2. **Named-value placeholder:** the service's `newGuidValue` input is an existing nonsecret placeholder fallback. Its ordinary typing is not silently inferred secure from its default. Only that fallback binding is excepted; the actual `namedValues[].value` branch is checked.
3. **SQL secret export:** `secretsExport.secretsToSet[].value` comes from a `union` / conditional / object-construction / formatted connection-string projection. We do not claim to analyze it. The exception pins the SHA-256 of the exact emitted expression, so a changed projection requires review. Parent-schema changes alone do not change that hash: this path needs a future semantic/projection check, not an assumption that the pin proves security.

Do not widen these exceptions to make a new failure green. Either fix the interface, add a bounded expression form with compiler evidence, or explicitly review a new narrow exception. Removing the workspace logger exception after its interface fix and covering SQL's projection are follow-ups, not production changes in this patch.

## Regression evidence

The tests include compiler-generated scalar, nested optional, array-loop, discriminator, and secure-ancestor cases; arbitrary names; `$ref` aliases; literals; runtime and Key Vault values; unsupported expressions; and schema/scan failures. A source mutation removes the fixture's secure type decorator and recompiles it, changing its result from Secure to Mismatch. A production-schema mutation reverts the cache leaf and must fail the same gate used by CI. Another injects a previously unseen child input into the compiled service template and fails without changing a name list.

The existing 27 focused checks remain alongside this suite. The workflow stays `pull_request`, read-only, compile-only, without Azure login, secrets, or deployments.

## Why the built-in linter is not enough

`secure-secrets-in-params` defaults to **warning**, and this repository does not override it. It checks top-level parameter names for patterns such as `password`, `secret`, and `accountkey` (and secure-parameter references in defaults); it does not compare parent properties with secure child inputs. See Bicep's [rule implementation](https://github.com/Azure/bicep/blob/main/src/Bicep.Core/Analyzers/Linter/Rules/SecretsInParamsMustBeSecureRule.cs) and [security-category default severity](https://github.com/Azure/bicep/blob/main/src/Bicep.Core/Analyzers/Linter/LinterRuleBase.cs).
