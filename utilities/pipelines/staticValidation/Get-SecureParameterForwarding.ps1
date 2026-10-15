<#
.SYNOPSIS
Compare forwarded production inputs with secure child-module schemas.

.DESCRIPTION
This is AVM interface hygiene, not a Bicep type error or a taint analyzer.
See utilities/tests/pipelines/src/secureParameterForwarding/coverage.md for the
supported emitted expressions, scan scope, and baseline.
Unrecognized expressions produce Unsupported results; invalid schemas throw.

.PARAMETER Template
A compiled ARM template, deserialized with ConvertFrom-Json -AsHashtable.

.PARAMETER ModulePath
The root module's repository-relative path, used in diagnostics.
#>
function Get-SecureParameterForwarding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $Template,

        [Parameter(Mandatory)]
        [string] $ModulePath
    )

    $ErrorActionPreference = 'Stop'
    $rootModulePath = $ModulePath

    function Resolve-Schema {
        param([System.Collections.IDictionary] $Document, [System.Collections.IDictionary] $Schema, [string[]] $Seen = @())
        if ($null -eq $Schema) { throw 'Missing ARM schema.' }
        if ($Schema.Contains('$ref')) {
            $reference = [string] $Schema['$ref']
            if ($reference -notmatch '^#/definitions/([^/]+)$' -or $reference -in $Seen) {
                throw "Unsupported or cyclic schema reference [$reference]."
            }
            $name = $Matches[1].Replace('~1', '/').Replace('~0', '~')
            if (-not $Document['definitions'].Contains($name)) { throw "Missing definition [$reference]." }
            $resolved = Resolve-Schema -Document $Document -Schema $Document['definitions'][$name] -Seen ($Seen + $reference)
            $merged = @{}
            foreach ($key in $resolved.psbase.Keys) { $merged[$key] = $resolved[$key] }
            foreach ($key in $Schema.psbase.Keys) {
                if ($key -ne '$ref') { $merged[$key] = $Schema[$key] }
            }
            return $merged
        }
        return $Schema
    }

    function Get-SecureLeaf {
        param([System.Collections.IDictionary] $Document, [System.Collections.IDictionary] $Schema, [string[]] $Path = @(), [int] $Depth = 0)
        if ($Depth -gt 64) { throw 'Schema nesting exceeds 64 levels (possibly recursive).' }
        $schema = Resolve-Schema $Document $Schema
        if ($schema['type'] -in @('secureString', 'secureObject')) {
            [pscustomobject] @{ Path = $Path; Type = $schema['type'] }
            return
        }
        foreach ($keyword in @('oneOf', 'anyOf', 'allOf')) {
            if ($schema.Contains($keyword)) { throw "Unsupported schema keyword [$keyword]." }
        }
        # Bicep emits `any` as a schema with no type; it has no secure leaves.
        if (-not $schema.Contains('type')) { return }
        if ($schema['type'] -notin @('string', 'object', 'array', 'int', 'bool')) {
            throw "Missing or unsupported ARM schema type [$($schema['type'])]."
        }
        if ($schema['discriminator']) {
            foreach ($variant in $schema['discriminator']['mapping'].psbase.Keys) {
                # A variant token preserves the relationship when forwarding a whole union.
                Get-SecureLeaf -Document $Document -Schema $schema['discriminator']['mapping'][$variant] -Path ($Path + "@$($schema['discriminator']['propertyName'])=$variant") -Depth ($Depth + 1)
            }
        }
        foreach ($property in $schema['properties'].psbase.Keys) {
            if ($property -in @('[]', '*') -or $property.StartsWith('@')) {
                throw "Unsupported schema property name [$property]."
            }
            Get-SecureLeaf -Document $Document -Schema $schema['properties'][$property] -Path ($Path + $property) -Depth ($Depth + 1)
        }
        # Tuple positions share the '[]' token, so a tuple leaf is secure only if every position is.
        foreach ($item in @($schema['prefixItems']) + @($schema['items'])) {
            if ($item -is [System.Collections.IDictionary]) {
                Get-SecureLeaf -Document $Document -Schema $item -Path ($Path + '[]') -Depth ($Depth + 1)
            }
        }
        if ($schema['additionalProperties'] -is [System.Collections.IDictionary]) {
            Get-SecureLeaf -Document $Document -Schema $schema['additionalProperties'] -Path ($Path + '*') -Depth ($Depth + 1)
        }
    }

    function Read-InputPath {
        param([string] $Expression, [int] $Depth = 0)
        if ($Depth -gt 64) { return $null }
        # Recognize only these complete forms. This is not a general ARM parser.
        $expression = $Expression.Trim()
        if ($expression -cmatch "^parameters\('(?<name>[A-Za-z_][A-Za-z0-9_]*)'\)$") {
            return [pscustomobject] @{ Parameter = $Matches['name']; Path = @() }
        }
        $suffix = @()
        $base = $null
        if ($expression -cmatch '^(?<base>.+)\.(?<property>[A-Za-z_][A-Za-z0-9_]*)$') {
            $base = $Matches['base']; $suffix = @($Matches['property'])
        } elseif ($expression -cmatch "^(?<base>.+)\['(?<property>[A-Za-z_][A-Za-z0-9_]*)'\]$") {
            $base = $Matches['base']; $suffix = @($Matches['property'])
        } elseif ($expression -cmatch "^(?<base>.+)\[(?:[0-9]+|copyIndex\((?:'[A-Za-z_][A-Za-z0-9_]*')?\))\]$") {
            $base = $Matches['base']; $suffix = @('[]')
        } elseif ($expression -cmatch '^coalesce\((?<base>.+), (?:createArray\(\)|createObject\(\)|null\(\))\)$') {
            $base = $Matches['base']
        } elseif ($expression -cmatch "^tryGet\((?<base>.+?), (?<properties>'[A-Za-z_][A-Za-z0-9_]*'(?:, '[A-Za-z_][A-Za-z0-9_]*')*)\)$") {
            $base = $Matches['base']
            $suffix = @($Matches['properties'].Split(', ') | ForEach-Object { $_.Trim("'") })
        } else {
            return $null
        }
        $inputPath = Read-InputPath $base ($Depth + 1)
        if ($null -eq $inputPath) { return $null }
        return [pscustomobject] @{ Parameter = $inputPath.Parameter; Path = @($inputPath.Path) + $suffix }
    }

    function Test-SecurePath {
        param([System.Collections.IDictionary] $Document, [System.Collections.IDictionary] $Schema, [string[]] $Path, [int] $Depth = 0)
        if ($Depth -gt 64) { throw 'Schema nesting exceeds 64 levels (possibly recursive).' }
        $schema = Resolve-Schema $Document $Schema
        if ($schema['type'] -in @('secureString', 'secureObject')) { return $true }
        if ($Path.Count -eq 0) { return $false }
        $head = $Path[0]
        $tail = @($Path | Select-Object -Skip 1)
        if ($head.StartsWith('@')) {
            if (-not $schema['discriminator']) { return $false }
            $parts = $head.Substring(1).Split('=', 2)
            if ($schema['discriminator']['propertyName'] -ne $parts[0]) { return $false }
            $variant = $parts[1]
            $mapping = $schema['discriminator']['mapping']
            if (-not $mapping -or -not $mapping.Contains($variant)) { return $false }
            return Test-SecurePath -Document $Document -Schema $mapping[$variant] -Path $tail -Depth ($Depth + 1)
        }
        if ($schema['discriminator']) {
            $applicable = @($schema['discriminator']['mapping'].psbase.Values | Where-Object {
                    $variantSchema = Resolve-Schema $Document $_
                    ($variantSchema['properties'] -and $variantSchema['properties'].Contains($head)) -or
                    $variantSchema['additionalProperties'] -ne $false
                })
            if ($applicable.Count -eq 0) { return $false }
            foreach ($variant in $applicable) {
                if (-not (Test-SecurePath -Document $Document -Schema $variant -Path $Path -Depth ($Depth + 1))) { return $false }
            }
            return $true
        }
        $next = if ($head -eq '[]') {
            @(@($schema['prefixItems']) + @($schema['items']) | Where-Object { $_ -is [System.Collections.IDictionary] })
        } elseif ($head -eq '*') {
            # Any member can reach a dictionary sink, so declared properties must be secure too,
            # and members not described by a schema are not known to be secure.
            if ($schema['additionalProperties'] -ne $false -and $schema['additionalProperties'] -isnot [System.Collections.IDictionary]) { return $false }
            @(@($schema['properties'].psbase.Values) + @($schema['additionalProperties']) | Where-Object { $_ -is [System.Collections.IDictionary] })
        } elseif ($schema['properties'] -and $schema['properties'].Contains($head)) {
            @($schema['properties'][$head])
        } elseif ($schema['additionalProperties'] -is [System.Collections.IDictionary]) {
            @($schema['additionalProperties'])
        } else { @() }
        if ($next.Count -eq 0) { return $false }
        foreach ($candidate in $next) {
            if (-not (Test-SecurePath -Document $Document -Schema $candidate -Path $tail -Depth ($Depth + 1))) { return $false }
        }
        return $true
    }

    function Test-LiteralValue {
        param([object] $Value)
        if ($Value -is [System.Collections.IDictionary] -or $Value -is [array]) {
            $values = if ($Value -is [System.Collections.IDictionary]) { $Value.psbase.Values } else { $Value }
            foreach ($item in $values) {
                if (-not (Test-LiteralValue $item)) { return $false }
            }
            return $true
        }
        return $Value -isnot [string] -or -not $Value.StartsWith('[') -or $Value.StartsWith('[[')
    }

    function Compare-Binding {
        param(
            [System.Collections.IDictionary] $Document, [object] $Value,
            [string[]] $LeafPath, [string] $SinkType, [string] $Deployment, [string] $Target
        )
        $result = [ordered] @{
            Module = $rootModulePath; Deployment = $Deployment; Target = $Target
            SinkType = $SinkType; Source = ''; Status = ''; Detail = ''; ExpressionHash = ''
        }
        # Descend through literal object/array constructors before inspecting a leaf.
        if ($LeafPath.Count -gt 0 -and $null -ne $Value -and $Value -isnot [string]) {
            $head = $LeafPath[0]
            $tail = @($LeafPath | Select-Object -Skip 1)
            if ($head.StartsWith('@')) {
                # Literal discriminated objects need their discriminator value to choose a branch.
                $result.Status = if (Test-LiteralValue $Value) { 'NonInput' } else { 'Unsupported' }
                $result.Detail = 'Discriminated constructor; only entirely literal values are classified.'
                return [pscustomobject] $result
            }
            if ($head -eq '[]' -and $Value -is [array]) {
                foreach ($item in $Value) { Compare-Binding -Document $Document -Value $item -LeafPath $tail -SinkType $SinkType -Deployment $Deployment -Target $Target }
                return
            }
            if ($head -eq '*' -and $Value -is [System.Collections.IDictionary]) {
                foreach ($item in $Value.psbase.Values) { Compare-Binding -Document $Document -Value $item -LeafPath $tail -SinkType $SinkType -Deployment $Deployment -Target $Target }
                return
            }
            if ($Value -is [System.Collections.IDictionary]) {
                Compare-Binding -Document $Document -Value $Value[$head] -LeafPath $tail -SinkType $SinkType -Deployment $Deployment -Target $Target
                return
            }
        }
        if ($Value -is [string] -and $Value.StartsWith('[') -and -not $Value.StartsWith('[[')) {
            if (-not $Value.EndsWith(']')) { throw 'Malformed ARM expression.' }
            $expression = $Value.Substring(1, $Value.Length - 2)
            # Only split a final, simple fallback; never split arbitrary function arguments.
            if ($expression -cmatch "^coalesce\((?<base>.+), (?<fallback>parameters\('[A-Za-z_][A-Za-z0-9_]*'\)|'')\)$") {
                $base = $Matches['base']
                $fallback = $Matches['fallback']
                Compare-Binding -Document $Document -Value "[$base]" -LeafPath $LeafPath -SinkType $SinkType -Deployment $Deployment -Target $Target
                $fallbackValue = if ($fallback -eq "''") { '' } else { "[$fallback]" }
                Compare-Binding -Document $Document -Value $fallbackValue -LeafPath $LeafPath -SinkType $SinkType -Deployment $Deployment -Target $Target
                return
            }
            $source = Read-InputPath $expression
            if ($null -ne $source) {
                $path = @($source.Path) + $LeafPath
                $result.Source = (@($source.Parameter) + $path) -join '.'
                if (-not $Document['parameters'].Contains($source.Parameter)) { throw "Unknown input [$($source.Parameter)]." }
                $result.Status = if (Test-SecurePath -Document $Document -Schema $Document['parameters'][$source.Parameter] -Path $path) { 'Secure' } else { 'Mismatch' }
            } elseif ($expression -in @('null()', 'newGuid()')) {
                $result.Status = 'NonInput'
            } elseif ($expression -cmatch "^(?:reference|list[A-Za-z0-9_]*)\(.*\)(?:\.[A-Za-z_][A-Za-z0-9_]*|\[[0-9]+\])*$") {
                $result.Status = 'NonInput'
                $result.Detail = 'Runtime resource result; not a forwarded caller value.'
            } else {
                $result.Status = 'Unsupported'
                # Do not echo values: a diagnostic need only identify the binding.
                $result.Detail = 'Expression is outside the documented direct-forwarding grammar.'
                $result.ExpressionHash = [Convert]::ToHexString([System.Security.Cryptography.SHA256]::HashData([Text.Encoding]::UTF8.GetBytes($Value)))
            }
        } elseif ($Value -is [System.Collections.IDictionary] -or $Value -is [array]) {
            # A secureObject constructor may contain forwarded inputs, not just literals.
            $values = if ($Value -is [System.Collections.IDictionary]) { $Value.psbase.Values } else { $Value }
            foreach ($item in $values) { Compare-Binding -Document $Document -Value $item -LeafPath @() -SinkType $SinkType -Deployment $Deployment -Target $Target }
            return
        } else {
            $result.Status = 'NonInput'
        }
        [pscustomobject] $result
    }

    function Get-TemplateBinding {
        param([System.Collections.IDictionary] $Document, [string] $Deployment, [int] $Depth = 0)
        if ($Depth -gt 64) { throw 'Deployment nesting exceeds 64 levels.' }
        $resources = $Document['resources']
        if ($resources -is [System.Collections.IDictionary]) {
            $entries = @($resources.GetEnumerator() | ForEach-Object { @{ Name = $_.Key; Resource = $_.Value } })
        } elseif ($resources -is [array]) {
            $entries = @(for ($i = 0; $i -lt $resources.Count; $i++) { @{ Name = [string] $i; Resource = $resources[$i] } })
        } else { throw 'Expected a compiled ARM resources object or array.' }
        foreach ($entry in $entries) {
            $resource = $entry.Resource
            if ($resource['type'] -ne 'Microsoft.Resources/deployments') { continue }
            $properties = $resource['properties']
            if ($properties -isnot [System.Collections.IDictionary]) { throw 'Unsupported deployment properties expression.' }
            if ($properties['templateLink']) { throw 'Linked templates cannot be inspected; compile embedded modules.' }
            $child = $properties['template']
            # Bicep stores loadJsonContent() templates in a generated variable.
            if ($child -is [string] -and $child -cmatch "^\[variables\('(?<name>[^']+)'\)\]$" -and
                $Document['variables'] -is [System.Collections.IDictionary] -and $Document['variables'].Contains($Matches['name'])) {
                $child = $Document['variables'][$Matches['name']]
            }
            if ($child -isnot [System.Collections.IDictionary]) { throw 'Missing embedded deployment template.' }
            $location = "$Deployment/$($entry.Name)"
            foreach ($parameter in $child['parameters'].psbase.Keys) {
                $leaves = @(Get-SecureLeaf $child $child['parameters'][$parameter])
                foreach ($leaf in $leaves) {
                    $binding = $properties['parameters'][$parameter]
                    if ($null -eq $binding) { continue } # Omitted child input uses the child's default.
                    if ($binding.Contains('reference')) { continue } # ARM Key Vault parameter reference.
                    if (-not $binding.Contains('value')) { throw "Missing value for [$location/$parameter]." }
                    $target = (@($parameter) + $leaf.Path) -join '.'
                    Compare-Binding -Document $Document -Value $binding['value'] -LeafPath $leaf.Path -SinkType $leaf.Type -Deployment $location -Target $target
                }
            }
            Get-TemplateBinding -Document $child -Deployment $location -Depth ($Depth + 1)
        }
    }

    Get-TemplateBinding -Document $Template -Deployment ''
}

<#
.SYNOPSIS
Run Get-SecureParameterForwarding on every top-level module's committed main.json.

.DESCRIPTION
Module static validation already fails when main.json is stale, so the committed
JSON is the compiled interface. Nested child modules are embedded in it.
#>
function Get-RepositorySecureParameterForwarding {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $RepoRootPath
    )

    $ErrorActionPreference = 'Stop'
    $templates = Get-ChildItem -Path (Join-Path $RepoRootPath 'avm') -Filter 'main.json' -Recurse -File | Where-Object {
        $relative = [IO.Path]::GetRelativePath($RepoRootPath, $_.FullName).Replace('\', '/')
        $relative -match '^avm/(res|ptn|utl)/[^/]+/[^/]+/main\.json$'
    } | Sort-Object FullName
    if (-not $templates) { throw "No module templates found below [$RepoRootPath]." }
    foreach ($templateFile in $templates) {
        $modulePath = [IO.Path]::GetRelativePath($RepoRootPath, $templateFile.DirectoryName).Replace('\', '/')
        $template = Get-Content -LiteralPath $templateFile.FullName -Raw | ConvertFrom-Json -AsHashtable -Depth 200
        try {
            Get-SecureParameterForwarding -Template $template -ModulePath $modulePath
        } catch {
            throw "[$modulePath] $($_.Exception.Message)"
        }
    }
}

<#
.SYNOPSIS
Regenerate the baseline of existing findings that are not reviewed exceptions.

.DESCRIPTION
Use this only to record findings that already exist on main or to drop stale
entries. A new insecure forwarding should be fixed with @secure() instead.
#>
function Update-SecureParameterForwardingBaseline {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [string] $RepoRootPath = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
    )

    $ErrorActionPreference = 'Stop'
    $dataPath = Join-Path $RepoRootPath 'utilities/tests/pipelines/src/secureParameterForwarding'
    $keys = @('Module', 'Deployment', 'Target', 'SinkType', 'Source', 'Status', 'ExpressionHash')
    $exceptionKeys = @(Get-Content (Join-Path $dataPath 'exceptions.json') -Raw | ConvertFrom-Json | ForEach-Object {
            $exception = $_; ($keys | ForEach-Object { $exception.$_ }) -join "`0"
        })
    $baseline = @(Get-RepositorySecureParameterForwarding -RepoRootPath $RepoRootPath | Where-Object {
            $finding = $_
            $_.Status -in @('Mismatch', 'Unsupported') -and (($keys | ForEach-Object { $finding.$_ }) -join "`0") -notin $exceptionKeys
        } | Sort-Object Module, Deployment, Target, Source, ExpressionHash | Select-Object -Property $keys)
    $baselinePath = Join-Path $dataPath 'baseline.json'
    if ($PSCmdlet.ShouldProcess($baselinePath, "Write $($baseline.Count) findings")) {
        ConvertTo-Json -InputObject $baseline -Depth 5 | Set-Content -LiteralPath $baselinePath
    }
}
