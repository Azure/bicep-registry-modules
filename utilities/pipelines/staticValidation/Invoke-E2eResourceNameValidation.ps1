<#
.SYNOPSIS
Compile and check e2e templates for globally colliding resource names without deploying to Azure.

.PARAMETER TestFilePath
The main.test.bicep files to validate.

.PARAMETER ReportPath
Path for a JSON report containing every result, including compilation and expansion failures.
#>
function Invoke-E2eResourceNameValidation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $TestFilePath,

        [Parameter(Mandatory)]
        [string] $ReportPath
    )

    $ErrorActionPreference = 'Stop'
    Import-Module Avm.Authoring -ErrorAction Stop
    $repoRootPath = (Get-Item -LiteralPath $PSScriptRoot).Parent.Parent.Parent.FullName
    $compiler = Get-AvmTool -Name bicep -Path $repoRootPath -ErrorAction Stop
    if ($compiler.Status -ne 'installed' -or -not (Test-Path -LiteralPath $compiler.Path -PathType Leaf)) {
        throw 'The managed Bicep compiler is not installed. Run avm tool install bicep before validating names.'
    }
    . (Join-Path $PSScriptRoot 'Test-E2eResourceNames.ps1')

    $paths = @($TestFilePath | ForEach-Object { (Resolve-Path -LiteralPath $_).Path } | Sort-Object -Unique)
    $results = [System.Collections.Generic.List[object]]::new()
    $templateFile = New-TemporaryFile
    try {
        for ($offset = 0; $offset -lt $paths.Count; $offset += 25) {
            $batch = $paths[$offset..([Math]::Min($offset + 24, $paths.Count - 1))]
            foreach ($path in $batch) {
                $result = [pscustomobject]@{
                    TestFilePath = $path
                    CheckedNames = 0
                    Violations   = @()
                    Error        = $null
                }
                try {
                    $diagnostics = & $compiler.Path build $path --outfile $templateFile.FullName 2>&1
                    if ($LASTEXITCODE -ne 0) {
                        throw "Bicep compilation failed: $($diagnostics | Out-String)"
                    }
                    $check = Test-E2eResourceNames -TemplateFilePath $templateFile.FullName
                    $result.CheckedNames = $check.CheckedNames
                    $result.Violations = $check.Violations
                    foreach ($violation in $check.Violations) {
                        Write-Warning "[$path] $($violation.ResourceType) $($violation.Property) [$($violation.Name)] collides across subscriptions."
                    }
                } catch {
                    $result.Error = $_.Exception.Message
                    Write-Warning "[$path] $($result.Error)"
                }
                $results.Add($result)
            }
            ConvertTo-Json -InputObject $results.ToArray() -Depth 10 | Set-Content -LiteralPath $ReportPath
            Write-Host "Checked $($results.Count)/$($paths.Count) e2e templates."
        }
    } finally {
        Remove-Item -LiteralPath $templateFile.FullName -Force
    }

    $failed = @($results | Where-Object { $_.Error -or $_.Violations.Count -gt 0 })
    if ($failed.Count -gt 0) {
        throw "$($failed.Count) of $($paths.Count) e2e templates failed resource name validation. See [$ReportPath]."
    }
    Write-Host "All $($paths.Count) e2e templates passed resource name validation."
}
