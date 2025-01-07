function Set-ModuleChangelog {

    [CmdletBinding()]
    param (
        # avm/res/app/job/CHANGELOG.md avm/res/app/job/README.md
        [Parameter(Mandatory)]
        [array] $Files
    )

    $FileArray = $Files.split(' ')
    Write-Host "Setting module changelog - FileArray: $FileArray"

    $ProcessedFiles = @()
    $FileArray | ForEach-Object {
        $splitArray = $_ -split '/'
        $modulePath = "$($splitArray[1])/$($splitArray[2])/$($splitArray[3])"
        $filename = $splitArray[4]
        $ProcessedFiles += [PSCustomObject]@{ ModulePath = $modulePath; Filename = $filename }
    }

    $FilteredFiles = $FileArray | Where-Object { $_ -contains 'CHANGELOG.md' }

    $FilteredFiles | ForEach-Object {
        Write-Host "Module: $_"
    }

    # $changelogContent = Get-Content $changelogFilePath
    # $sections = $changelogContent | Where-Object { $_ -match '^##' }
    # $changelogSection = $sections | Where-Object { $_ -match '^##\s+unreleased' }

}
