function Set-ModuleChangelog {

    [CmdletBinding()]
    param (
        # avm/res/app/job/CHANGELOG.md avm/res/app/job/README.md
        # [Parameter(Mandatory)]
        # [array] $Files
        [Parameter(Mandatory)]
        [string] $RepoRoot
    )

    Write-Verbose "Setting module changelog - RepoRoot: $RepoRoot" -Verbose

    # $FileArray = $Files.split(' ')
    # Write-Host "Setting module changelog - FileArray: $FileArray"

    # # parse input array to get module path and filename
    # $ProcessedFiles = @()
    # $FileArray | ForEach-Object {
    #     $splitArray = $_ -split '/'
    #     $modulePath = "$($splitArray[1])/$($splitArray[2])/$($splitArray[3])"
    #     $filename = $splitArray[4]
    #     $ProcessedFiles += [PSCustomObject]@{ ModulePath = $modulePath; Filename = $filename }
    # }

    # # group files by module path, to check if there are multiple files for a module
    # $GroupedFiles = $ProcessedFiles | Group-Object -Property ModulePath
    # $GroupedFiles | ForEach-Object {
    #     # Write-Host "ModulePath: $($_.Name)"
    #     # $_.Group | ForEach-Object {
    #     #     Write-Host "  Filename: $($_.Filename)"
    #     # }
    #     if ($_.Count -gt 1) {
    #         Write-Host "Multiple files found for module path $($_.Name). Parsing changelog file."
    #         $changelogContent = Get-Content "avm/$modulePath/CHANGELOG.md"
    #         $sections = $changelogContent | Where-Object { $_ -match '^##' }
    #         $changelogSection = $sections | Where-Object { $_ -match '^##\s+unreleased' }

    #     }
    # }

    # TODO: Implement logic to set module changelog
    return 'TODO: CHANGELOG.md File Content'
}
