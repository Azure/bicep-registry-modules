<#
.SYNOPSIS
Resolve module paths for the generic module workflow.

.DESCRIPTION
Accepts either a single module path, comma-separated module paths, or changed file paths.
Returns a GitHub Actions matrix containing unique top-level AVM module paths.
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
        $trimmedInput = $ModulePathInput.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmedInput)) {
            throw 'At least one module path must be specified.'
        }

        $requestedPaths = @($trimmedInput.Split(','))
    } else {
        $requestedPaths = @($ChangedFilePath)
    }

    $modulePaths = foreach ($requestedPath in $requestedPaths) {
        if ($requestedPath -isnot [string] -or [string]::IsNullOrWhiteSpace($requestedPath)) {
            if ($PSCmdlet.ParameterSetName -eq 'Input') {
                throw 'Every module path must be a non-empty string.'
            }
            continue
        }

        $normalizedPath = $requestedPath.Trim().Replace('\', '/').TrimEnd('/')
        if ($normalizedPath.StartsWith('./')) {
            $normalizedPath = $normalizedPath.Substring(2)
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
        if (-not (Test-Path -Path $moduleTemplateFilePath)) {
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
            @{
                concurrencyGroup = $_.Replace('/', '.')
                modulePath       = $_
            }
        }
    )

    return @{
        include = $matrixEntries
    }
}
