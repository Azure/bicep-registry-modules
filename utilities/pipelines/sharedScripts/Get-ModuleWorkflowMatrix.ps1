<#
.SYNOPSIS
Resolve module paths and test files for the generic module workflow.

.DESCRIPTION
Accepts either a single module path, comma-separated module paths, or changed file paths.
Returns a GitHub Actions matrix containing unique top-level AVM modules and their test files.
#>
function Get-ModuleWorkflowMatrix {

    [CmdletBinding(DefaultParameterSetName = 'ChangedFiles')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Input')]
        [string] $ModulePathInput,

        [Parameter(Mandatory, ParameterSetName = 'ChangedFiles')]
        [AllowEmptyCollection()]
        [string[]] $ChangedFilePath,

        [Parameter()]
        [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).Parent.Parent.Parent.FullName
    )

    if ($PSCmdlet.ParameterSetName -eq 'Input') {
        if ([string]::IsNullOrWhiteSpace($ModulePathInput)) {
            throw 'At least one module path must be specified.'
        }

        $requestedPaths = @($ModulePathInput.Trim().Split(','))
    } else {
        $requestedPaths = @($ChangedFilePath)
    }

    $modulePaths = foreach ($requestedPath in $requestedPaths) {
        if ([string]::IsNullOrWhiteSpace($requestedPath)) {
            if ($PSCmdlet.ParameterSetName -eq 'Input') {
                throw 'Every module path must be a non-empty string.'
            }
            continue
        }
        if ($PSCmdlet.ParameterSetName -eq 'Input' -and $requestedPath -match '[*?\[\]]') {
            throw "Path [$requestedPath] contains wildcard characters."
        }

        $normalizedPath = $requestedPath.Trim().Replace('\', '/').TrimEnd('/')
        if ($normalizedPath.StartsWith('./')) {
            $normalizedPath = $normalizedPath.Substring(2)
        }
        if ($PSCmdlet.ParameterSetName -eq 'ChangedFiles' -and $normalizedPath.EndsWith('/README.md', [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }
        if ($normalizedPath.Split('/') -contains '..') {
            throw "Path [$requestedPath] contains a parent-directory segment."
        }

        $pathSegments = $normalizedPath.Split('/', [System.StringSplitOptions]::RemoveEmptyEntries)
        $isModulePath = $pathSegments.Count -ge 4 -and
        $pathSegments[0] -eq 'avm' -and
        $pathSegments[1] -in @('res', 'ptn', 'utl')

        if (-not $isModulePath) {
            if ($PSCmdlet.ParameterSetName -eq 'Input') {
                throw "Path [$requestedPath] is not within a top-level AVM module."
            }
            continue
        }

        $modulePath = $pathSegments[0..3] -join '/'
        $moduleTemplateFilePath = Join-Path -Path $RepoRoot -ChildPath $modulePath -AdditionalChildPath 'main.bicep'
        if (-not (Test-Path -LiteralPath $moduleTemplateFilePath)) {
            if ($PSCmdlet.ParameterSetName -eq 'Input') {
                throw "No top-level AVM module was found at path [$modulePath]."
            }
            continue
        }

        $modulePath
    }

    $matrixEntries = @(
        $modulePaths |
        Sort-Object -Unique |
        ForEach-Object {
            $modulePath = $_
            $moduleFolderPath = Join-Path -Path $RepoRoot -ChildPath $modulePath
            $testFilePaths = @(
                Get-ChildItem -LiteralPath $moduleFolderPath -Recurse -Filter 'main.test.bicep' -File |
                ForEach-Object {
                    [System.IO.Path]::GetRelativePath($moduleFolderPath, $_.FullName).Replace('\', '/')
                } |
                Sort-Object
            )

            $moduleTestFiles = @(
                $testFilePaths | ForEach-Object {
                    @{
                        path      = $_
                        name      = Split-Path -Path (Split-Path -Path $_) -Leaf
                        e2eIgnore = Test-Path -LiteralPath (Join-Path -Path $moduleFolderPath -ChildPath $_).Replace('main.test.bicep', '.e2eignore')
                    }
                }
            )
            $psRuleModuleTestFiles = @(
                $testFilePaths |
                Where-Object { $_ -match '(defaults|waf-aligned)' } |
                ForEach-Object {
                    @{
                        path = $_
                        name = Split-Path -Path (Split-Path -Path $_) -Leaf
                    }
                }
            )

            @{
                modulePath               = $modulePath
                moduleTestFilePaths       = ConvertTo-Json -InputObject $moduleTestFiles -Compress
                psRuleModuleTestFilePaths = ConvertTo-Json -InputObject $psRuleModuleTestFiles -Compress
            }
        }
    )

    return @{
        include = $matrixEntries
    }
}
