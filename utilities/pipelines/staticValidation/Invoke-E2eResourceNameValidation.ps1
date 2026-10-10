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
    . (Join-Path $PSScriptRoot '..' 'sharedScripts' 'helper' 'Build-ViaRPC.ps1')
    . (Join-Path $PSScriptRoot 'Test-E2eResourceNames.ps1')

    $paths = @($TestFilePath | ForEach-Object { (Resolve-Path -LiteralPath $_).Path } | Sort-Object -Unique)
    $results = [System.Collections.Generic.List[object]]::new()
    $templateFile = New-TemporaryFile
    try {
        for ($offset = 0; $offset -lt $paths.Count; $offset += 25) {
            $batch = $paths[$offset..([Math]::Min($offset + 24, $paths.Count - 1))]
            $compiled = Build-ViaRPC -BicepFilePath $batch -PassThru -ErrorAction Continue
            foreach ($path in $batch) {
                $result = [pscustomobject]@{
                    TestFilePath = $path
                    CheckedNames = 0
                    Violations   = @()
                    Error        = $null
                }
                try {
                    if (-not $compiled.ContainsKey($path)) {
                        throw 'Bicep compilation failed. See the compiler diagnostics above.'
                    }
                    $compiled[$path] | Set-Content -LiteralPath $templateFile.FullName
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
