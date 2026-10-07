# Parent-to-child secure input checks

`SecureParameterForwarding.Tests.ps1` walks the embedded deployments in every top-level module's committed `main.json` (`avm/{res,ptn,utl}/*/*/main.json`). Child modules are embedded in those templates, so they are covered through their parents. Module static validation already fails when `main.json` is stale, so the scan doesn't recompile; the whole repository takes a few seconds. Examples and intentional plain-caller compatibility fixtures are outside the production scan.

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
- Dictionary values (`additionalProperties`, shown as `*` in paths) and tuple positions (`prefixItems`, shown as `[]`). Every tuple position, and every declared and undeclared member of a parent object forwarded into a secure dictionary, must be secure. A literal object bound to a child that mixes declared properties with a secure dictionary is checked conservatively: every member is treated as a dictionary value.
- Child templates embedded through `loadJsonContent()`, which Bicep stores in a generated variable.

Literal values (including escaped ARM strings), omitted inputs, optional nulls, ARM Key Vault parameter references, and direct runtime `reference(...)` / `list*(...)` results are not caller-input mismatches. We do not inspect resource internals or claim those values are safe. A direct `newGuid()` is not a caller input; a parameter with that default is still overridable and is checked normally.

Variables, transformations, conditionals, dynamic property/index expressions, lambdas, arbitrary projections, and discriminated-object constructors containing expressions are **Unsupported**, not inferred safe. Entirely literal discriminated constructors are non-inputs. There is no variable expansion, resource-flow tracing, or general taint analysis. Unfamiliar identifiers/access shapes are unsupported rather than guessed. Untyped (`any`) schemas have no secure leaves. Unsupported union-schema keywords, unresolved/cyclic references, linked templates, malformed templates, and compilation failures fail the scan. Nullability alone never implies security.

The repository has schema-walking helpers but no reusable ARM expression parser. This bounded recognizer avoids adding a general-purpose parser or a new toolchain. Extending it should start with a real compiler fixture; broader expression analysis belongs in a compiler-semantic implementation, not increasingly permissive regular expressions.

## Existing findings baseline

`baseline.json` records the Mismatch and Unsupported findings that already existed on `main` when the scan went repository-wide, so the check can gate new regressions without first fixing every module. It is generated, not hand-edited: dot-source `utilities/pipelines/staticValidation/Get-SecureParameterForwarding.ps1` and run `Update-SecureParameterForwardingBaseline`. Entries use the same exact key as exceptions, and each must match exactly one current finding. Fixing a finding therefore fails the test until the entry is removed, which keeps a fixed binding from quietly regressing later.

Reviewers should reject additions to `baseline.json`: a new regression can't be allowed by adding it to the baseline. Removals are expected. Regenerate the baseline only to drop fixed entries or to follow a rename of an existing finding (for example, a deployment path that moved). A new insecure forwarding should get `@secure()` on the parent input, not a baseline entry. Reviewed, intentional findings with a rationale belong in `exceptions.json` instead.

## Deliberate exceptions and follow-ups

`exceptions.json` matches the module, deployment path, target leaf, sink type, source path, and finding status exactly. Exceptions emit warnings and must still match a current finding, so stale entries fail. There are no deployment-wide, field-name-wide, or secure-object-wide exclusions.

1. **Workspace logger credentials:** `service_workspaces/workspace_loggers` takes a plain `loggers[].credentials` object into a secure child object. This existing mismatch is deferred. The service-level logger credentials object is already secure. The exception cannot hide a new `secureString` binding or a different input leaf.
2. **Named-value placeholder:** the service's `newGuidValue` input is an existing nonsecret placeholder fallback. Its ordinary typing is not silently inferred secure from its default. Only that fallback binding is excepted; the actual `namedValues[].value` branch is checked.
3. **SQL secret export:** `secretsExport.secretsToSet[].value` comes from a `union` / conditional / object-construction / formatted connection-string projection. We do not claim to analyze it. The exception pins the SHA-256 of the exact emitted expression, so a changed projection requires review. Parent-schema changes alone do not change that hash: this path needs a future semantic/projection check, not an assumption that the pin proves security.

Do not widen these exceptions to make a new failure green. Either fix the interface, add a bounded expression form with compiler evidence, or explicitly review a new narrow exception. Removing the workspace logger exception after its interface fix and covering SQL's projection are follow-ups, not production changes in this patch.

## Regression evidence

The tests include compiler-generated scalar, nested optional, array-loop, discriminator, and secure-ancestor cases; arbitrary names; `$ref` aliases; literals; runtime and Key Vault values; unsupported expressions; and schema/scan failures. A source mutation removes the fixture's secure type decorator and recompiles it, changing its result from Secure to Mismatch. A production-schema mutation reverts the cache leaf and must fail the same gate used by CI. Another injects a previously unseen child input into the compiled service template and fails without changing a name list.

Unit tests also cover dictionary values, tuple positions, untyped schemas, and `loadJsonContent()` templates. The existing 27 focused checks remain alongside this suite. These suites run with the other platform CI tests (`.github/workflows/platform.ci-tests.yml` via `utilities/tests/Test-CI.ps1`) and are compile-only, without Azure login, secrets, or deployments.

## Why the built-in linter is not enough

`secure-secrets-in-params` defaults to **warning**, and this repository does not override it. It checks top-level parameter names for patterns such as `password`, `secret`, and `accountkey` (and secure-parameter references in defaults); it does not compare parent properties with secure child inputs. See Bicep's [rule implementation](https://github.com/Azure/bicep/blob/main/src/Bicep.Core/Analyzers/Linter/Rules/SecretsInParamsMustBeSecureRule.cs) and [security-category default severity](https://github.com/Azure/bicep/blob/main/src/Bicep.Core/Analyzers/Linter/LinterRuleBase.cs).
