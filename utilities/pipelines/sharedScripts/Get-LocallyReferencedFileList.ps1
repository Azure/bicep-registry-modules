<#
.SYNOPSIS
Get all bicep files involved in a module deployment as per their local references (recusively)

.DESCRIPTION
Get all bicep files involved in a module deployment as per their local references (recusively).
That means if module A references module B, which references module C, then all three module paths are returned.

.PARAMETER FilePath
Mandatory. The path to the template to investigate.

.PARAMETER TemplateMap
Optional. The hashtable of templatePath-templateContent to search in. Can be provided to speed up runtime.

.EXAMPLE
Get-LocallyReferencedFileList -FilePath 'C:/modules/key-vault/vault/main.bicep'

Get all referenced paths of file 'C:/modules/key-vault/vault/main.bicep'
#>
function Get-LocallyReferencedFileList {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FilePath,

        [Parameter(Mandatory = $false)]
        [hashtable] $TemplateMap = @{}
    )

    $resList = @()

    $fileContent = ($TemplateMap.Count -gt 0 -and $TemplateMap.Keys -contains $FilePath) ? $TemplateMap[$FilePath] : (Get-Content $FilePath)

    $resList += $fileContent | Where-Object { $_ -match "^module .+ '(.+.bicep)' .+$" } | ForEach-Object { (Resolve-Path (Join-Path (Split-Path $FilePath) $matches[1])).Path }

    if ($resList.Count -gt 0) {
        foreach ($containedFilePath in $resList) {
            $resList += Get-LocallyReferencedFileList -FilePath $containedFilePath -TemplateMap $TemplateMap
        }
    }

    return $resList
}
