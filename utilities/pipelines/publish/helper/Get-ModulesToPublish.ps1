#region Helper functions

<#
.SYNOPSIS
Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.

.EXAMPLE
Get-ModifiedFileList

    Directory: .utilities\pipelines\publish

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          08.12.2021    15:50           7133 Script.ps1

Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.
#>
function Get-ModifiedFileList {

    $CurrentBranch = Get-GitBranchName
    if ($CurrentBranch -eq 'main') {
        Write-Verbose 'Gathering modified files from the pull request' -Verbose
        $Diff = git diff --name-only --diff-filter=AM 'HEAD^' 'HEAD'
    } else {
        Write-Verbose 'Gathering modified files between current branch and main' -Verbose
        $Diff = git diff --name-only --diff-filter=AM 'origin/main'
    }
    $ModifiedFiles = $Diff | Get-Item -Force

    return $ModifiedFiles
}

<#
.SYNOPSIS
Get the name of the current checked out branch.

.DESCRIPTION
Get the name of the current checked out branch. If git cannot find it, best effort based on environment variables is used.

.EXAMPLE
Get-CurrentBranch

Get the name of the current checked out branch.
#>
function Get-GitBranchName {
    [CmdletBinding()]
    param ()

    # Get branch name from Git
    $BranchName = git branch --show-current

    # If git could not get name, try GitHub variable
    if ([string]::IsNullOrEmpty($BranchName) -and (Test-Path env:GITHUB_REF_NAME)) {
        $BranchName = $env:GITHUB_REF_NAME
    }

    return $BranchName
}

<#
.SYNOPSIS
Find the closest main.json file to the changed files in the module folder structure.

.DESCRIPTION
Find the closest main.json file to the changed files in the module folder structure.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.PARAMETER PathsToInclude
Mandatory. Paths to include in the search for the closest main.json file.

.PARAMETER SkipNotVersionedModules
Optional. Specify if filtering the list by returning only versioned modified modules.

.EXAMPLE
Get-TemplateFileToPublish -ModuleFolderPath ".\avm\storage\storage-account\"

.\avm\storage\storage-account\table-service\table\main.json

Gets the closest main.json file to the changed files in the module folder structure.
Assuming there is a changed file in 'storage\storage-account\table-service\table' and that a version.json file exists in the same folder,
the function would return the main.json file in the same folder.

#>
function Get-TemplateFileToPublish {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $false)]
        [string[]] $PathsToInclude = @(
            './main.json',
            './version.json'
        ),

        [Parameter(Mandatory = $false)]
        [switch] $SkipNotVersionedModules
    )

    $ModuleRelativeFolderPath = (($ModuleFolderPath -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
    $ModifiedFiles = Get-ModifiedFileList -Verbose
    Write-Verbose "Looking for modified files under: [$ModuleRelativeFolderPath]" -Verbose
    $modifiedModuleFiles = $ModifiedFiles.FullName | Where-Object { $_ -like "*$ModuleFolderPath*" }

    $relevantPaths = @()
    foreach ($modifiedFile in $modifiedModuleFiles) {

        foreach ($path in  $PathsToInclude) {
            if ($modifiedFile -eq (Resolve-Path (Join-Path (Split-Path $modifiedFile) $path) -ErrorAction 'SilentlyContinue')) {
                $relevantPaths += $modifiedFile
            }
        }
    }

    $TemplateFilesToPublish = $relevantPaths | ForEach-Object {
        Find-TemplateFile -Path $_ -Verbose
    } | Sort-Object -Culture 'en-US' -Unique -Descending

    if ($TemplateFilesToPublish.Count -eq 0) {
        Write-Verbose 'No template file found in the modified module.' -Verbose
    }

    Write-Verbose ('Modified modules found: [{0}]' -f $TemplateFilesToPublish.count) -Verbose
    $TemplateFilesToPublish | ForEach-Object {
        $RelPath = (($_ -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
        $RelPath = $RelPath.Split('/main.')[0]
        Write-Verbose " - [$RelPath]" -Verbose
    }

    if ($SkipNotVersionedModules) {
        $toSkip = $TemplateFilesToPublish | Where-Object {
            -not (Test-Path (Join-Path (Split-Path $_) 'version.json'))
        }
        if ($toSkip.Count -gt 0) {
            Write-Verbose ('Skipping [{0}] modules that are not versioned.' -f $toSkip.Count) -Verbose
            $TemplateFilesToPublish = $TemplateFilesToPublish | Where-Object {
                $_ -notin $toSkip
            }
        }
    }

    Write-Verbose ('Versioned modules to publish: [{0}]' -f $TemplateFilesToPublish.count) -Verbose
    $TemplateFilesToPublish | ForEach-Object {
        $RelPath = (($_ -split '[\/|\\](avm)[\/|\\](res|ptn|utl)[\/|\\]')[-3..-1] -join '/') -replace '\\', '/'
        $RelPath = $RelPath.Split('/main.')[0]
        Write-Verbose " - [$RelPath]" -Verbose
    }

    return $TemplateFilesToPublish
}

<#
.SYNOPSIS
Find the closest main.json file to the current directory/file.

.DESCRIPTION
This function will search the current directory and all parent directories for a main.json file.
This can be relevant if, for example, only a version.json file was changed, but what we need to find then is the corresponding main.json file.

.PARAMETER Path
Mandatory. Path to the folder/file that should be searched

.EXAMPLE
Find-TemplateFile -Path ".\avm\storage\storage-account\table-service\table\.bicep\nested_roleAssignments.bicep"

  Directory: .\avm\storage\storage-account\table-service\table

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          05.12.2021    22:45           1230 main.json

Gets the closest main.json file to the current directory.
#>
function Find-TemplateFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Path
    )

    $FolderPath = Split-Path $Path -Parent
    $FolderName = Split-Path $Path -Leaf
    if ($FolderName -eq 'modules') {
        return $null
    }

    $TemplateFilePath = Join-Path $FolderPath 'main.json'

    if (-not (Test-Path $TemplateFilePath)) {
        return Find-TemplateFile -Path $FolderPath
    }

    return ($TemplateFilePath | Get-Item).FullName
}
#endregion

<#
.SYNOPSIS
Get any template (main.json) files in the given folder path that would qualify for publishing.

.DESCRIPTION
Get any template (main.json) files in the given folder path that would qualify for publishing.
Uses Head^-1 to check for changed files and filters them by the module path & path filter of the version.json

.PARAMETER ModuleFolderPath
Mandatory. The path to the module to check for changed files in.

.PARAMETER SkipNotVersionedModules
Optional. Specify if filtering the list by returning only versioned modified modules.

.EXAMPLE
Get-ModulesToPublish -ModuleFolderPath "C:\avm\storage\storage-account"

Could return paths like
- C:\avm\storage\storage-account\main.json
- C:\avm\storage\storage-account\blob-service\main.json

#>
function Get-ModulesToPublish {


    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleFolderPath,

        [Parameter(Mandatory = $false)]
        [switch] $SkipNotVersionedModules
    )

    # Check as per a `diff` with head^-1 if there was a change in any file that would justify a publish
    $TemplateFilesToPublish = Get-TemplateFileToPublish -ModuleFolderPath $ModuleFolderPath -SkipNotVersionedModules

    # Return the remaining template file(s)
    return $TemplateFilesToPublish
}
