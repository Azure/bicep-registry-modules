function Assert-TestSubscriptionTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowNull()]
        [AllowEmptyString()]
        [object] $Tag
    )

    if ($Tag -isnot [string] -or $Tag.Length -gt 64 -or $Tag -cnotmatch '\A[A-Za-z0-9]+(?:[ -][A-Za-z0-9]+)*\z') {
        throw 'A test subscription tag must be a non-empty ASCII name of at most 64 characters, with single spaces or hyphens between words.'
    }
}

<#
.SYNOPSIS
Resolve an exact module root to its reserved test subscription tag.

.DESCRIPTION
The repository-root .reserved-test-subscriptions.json maps module roots to tags.
Unmapped modules use General. Tags are case-sensitive; requirements are never
inherited from parent paths. A missing or invalid map fails before selection.
#>
function Get-TestSubscriptionTag {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [string] $ModulePath,

        [Parameter()]
        [string] $RepoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
    )

    $ErrorActionPreference = 'Stop'
    $modulePattern = '\Aavm/(res|ptn|utl)/[a-z0-9]+(?:-[a-z0-9]+)*(?:/[a-z0-9]+(?:-[a-z0-9]+)*)+\z'
    if ($ModulePath -cnotmatch $modulePattern) {
        throw 'ModulePath must be an exact repository-relative AVM module directory, using lowercase names and forward slashes.'
    }

    $fileName = '.reserved-test-subscriptions.json'
    $files = @(Get-ChildItem -LiteralPath $RepoRootPath -Force | Where-Object { $_.Name -ieq $fileName })
    if ($files.Count -ne 1 -or $files[0].Name -cne $fileName -or $files[0].PSIsContainer) {
        throw "Test subscription reservations require a file named exactly $fileName at the repository root."
    }
    if ($files[0].Length -gt 65536) {
        throw "$fileName exceeds the 64 KiB limit."
    }

    $contents = Get-Content -LiteralPath $files[0].FullName -Raw -Encoding utf8
    try {
        $document = [System.Text.Json.JsonDocument]::Parse([string] $contents)
    } catch [System.Text.Json.JsonException] {
        throw [System.ArgumentException]::new("$fileName must contain a valid JSON object mapping exact module roots to subscription tags.", $_.Exception)
    }

    try {
        if ($document.RootElement.ValueKind -ne [System.Text.Json.JsonValueKind]::Object) {
            throw "$fileName must contain a JSON object mapping exact module roots to subscription tags."
        }

        $modules = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        $tag = 'General'
        foreach ($module in $document.RootElement.EnumerateObject()) {
            if ($module.Name -cnotmatch $modulePattern) {
                throw "$fileName key [$($module.Name)] must be an exact repository-relative AVM module directory."
            }
            if (-not $modules.Add($module.Name)) {
                throw "Duplicate module path [$($module.Name)] in $fileName."
            }
            if ($module.Value.ValueKind -ne [System.Text.Json.JsonValueKind]::String) {
                throw "$fileName entry [$($module.Name)] must be a subscription tag string."
            }
            $requiredTag = $module.Value.GetString()
            Assert-TestSubscriptionTag -Tag $requiredTag
            if ($module.Name -ceq $ModulePath) {
                $tag = $requiredTag
            }
        }
        return $tag
    } finally {
        $document.Dispose()
    }
}
