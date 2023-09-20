#region Helper functions

<#
.SYNOPSIS
Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.

.EXAMPLE
Get-ModifiedFileList

    Directory: .avm\utilities\pipelines\resourcePublish

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          08.12.2021    15:50           7133 Script.ps1

Get modified files between previous and current commit depending on if you are running on main/master or a custom branch.
#>
function Get-ModifiedFileList {

  # TODO : Replace back to 'main'
  if ((Get-GitBranchName) -eq 'users/alsehr/introduceDiffBranch') {
    Write-Verbose 'Gathering modified files from the previous head' -Verbose
    $Diff = git diff --name-only --diff-filter=AM HEAD^ HEAD
  }
  $ModifiedFiles = $Diff | Get-Item -Force

  return $ModifiedFiles
}


# <#
# .SYNOPSIS
# Get the name of the current checked out branch.

# .DESCRIPTION
# Get the name of the current checked out branch. If git cannot find it, best effort based on environment variables is used.

# .EXAMPLE
# Get-CurrentBranch

# feature-branch-1

# Get the name of the current checked out branch.

# #>
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
Find the closest main.bicep file to the changed files in the module folder structure.

.DESCRIPTION
Find the closest main.bicep file to the changed files in the module folder structure.

.PARAMETER ModuleFolderPath
Mandatory. Path to the main/parent module folder.

.EXAMPLE
Get-TemplateFileToPublish -ModuleFolderPath ".\avm\storage\storage-account\"

.\avm\storage\storage-account\table-service\table\main.bicep

Gets the closest main.bicep file to the changed files in the module folder structure.
Assuming there is a changed file in 'storage\storage-account\table-service\table'
the function would return the main.bicep file in the same folder.

#>
function Get-TemplateFileToPublish {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string] $ModuleFolderPath,

    [Parameter(Mandatory)]
    [string[]] $PathsToInclude = @()
  )

  $ModuleFolderRelPath = $ModuleFolderPath.Split('/avm/')[-1]
  $ModifiedFiles = Get-ModifiedFileList -Verbose
  Write-Verbose "Looking for modified files under: [$ModuleFolderRelPath]" -Verbose
  $modifiedModuleFiles = $ModifiedFiles.FullName | Where-Object { $_ -like "*$ModuleFolderPath*" }


  # C:\dev\ip\Azure-bicep-registry-modules\eriqua-fork\avm\res\network\private-endpoint\private-dns-zone-group\README.md
  # C:\dev\ip\Azure-bicep-registry-modules\eriqua-fork\avm\res\network\private-endpoint\main.json
  # C:\dev\ip\Azure-bicep-registry-modules\eriqua-fork\avm\res\network\private-endpoint\main.bicep

  # ./main.json
  # ./version.json
  # /sfds/../../tests/main.bicep

  $relevantPaths = @()
  $PathsToInclude += 'version.json' # Add the file itself to be considered too
  foreach ($modifiedFile in $modifiedModuleFiles) {

    foreach ($path in  $PathsToInclude) {
      if ($modifiedFile -eq (Resolve-Path (Join-Path (Split-Path $modifiedFile) $path))) {
        $relevantPaths += $modifiedFile
      }
    }
  }


  $TemplateFilesToPublish = $relevantPaths | ForEach-Object {
    Find-TemplateFile -Path $_ -Verbose
  } | Sort-Object -Unique -Descending

  if ($TemplateFilesToPublish.Count -eq 0) {
    Write-Verbose 'No template file found in the modified module.' -Verbose
  }

  Write-Verbose ('Modified modules found: [{0}]' -f $TemplateFilesToPublish.count) -Verbose
  $TemplateFilesToPublish | ForEach-Object {
    $RelPath = $_.Split('/avm/')[-1]
    $RelPath = $RelPath.Split('/main.')[0]
    Write-Verbose " - [$RelPath]" -Verbose
  }

  return $TemplateFilesToPublish
}

<#
.SYNOPSIS
Find the closest main.bicep file to the current directory/file.

.DESCRIPTION
This function will search the current directory and all parent directories for a main.bicep file.

.PARAMETER Path
Mandatory. Path to the folder/file that should be searched

.EXAMPLE
Find-TemplateFile -Path ".\avm\storage\storage-account\table-service\table\.bicep\nested_roleAssignments.bicep"

  Directory: .\avm\storage\storage-account\table-service\table

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
la---          05.12.2021    22:45           1230 main.bicep

Gets the closest main.bicep file to the current directory.
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

  $TemplateFilePath = Join-Path $FolderPath 'main.bicep'

  if (-not (Test-Path $TemplateFilePath)) {
    return Find-TemplateFile -Path $FolderPath
  }

  return ($TemplateFilePath | Get-Item).FullName
}


#endregion

# -> Is there a diff to head
# -> Is there a diff to PBR

function Test-ModuleQualifiesForPublish {


  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [string] $ModuleFolderPath
  )

  $versionFile = (Get-Content (Join-Path $ModuleFolderPath 'version.json') -Raw) | ConvertFrom-Json
  $PathsToInclude = $versionFile.PathFilters

  $TemplateFilesToPublish = Get-TemplateFileToPublish -ModuleFolderPath $ModuleFolderPath -PathsToInclude $PathsToInclude
  $TemplateFilesToPublish
}


Test-ModuleQualifiesForPublish -ModuleFolderPath 'C:\dev\ip\Azure-bicep-registry-modules\eriqua-fork\avm\res\network\private-endpoint'
# Test-ModuleQualifiesForPublish -ModuleFolderPath 'C:\dev\ip\Azure-bicep-registry-modules\eriqua-fork\avm\res\network\private-endpoint\private-dns-zone-group'

# #region Helper functions

# <#
# .SYNOPSIS
# Gets the parent main.bicep file(s) to the changed files in the module folder structure.

# .DESCRIPTION
# Gets the parent main.bicep file(s) to the changed files in the module folder structure.

# .PARAMETER TemplateFilePath
# Mandatory. Path to a main.bicep file.

# .PARAMETER Recurse
# Optional. If true, the function will recurse up the folder structure to find the closest main.bicep file.

# .EXAMPLE
# Get-ParentModuleTemplateFile -TemplateFilePath '.\avm\storage\storage-account\table-service\table\main.bicep' -Recurse

#   Directory: .\avm\storage\storage-account\table-service

# Mode                 LastWriteTime         Length Name
# ----                 -------------         ------ ----
# la---          05.12.2021    22:45           1427 main.bicep

#   Directory: .\avm\storage\storage-account

# Mode                 LastWriteTime         Length Name
# ----                 -------------         ------ ----
# la---          02.12.2021    13:19          10768 main.bicep

# Gets the parent main.bicep file(s) to the changed files in the module folder structure.

# #>
# function Get-ParentModuleTemplateFile {

#   [CmdletBinding()]
#   param (
#       [Parameter(Mandatory)]
#       [string] $TemplateFilePath,

#       [Parameter(Mandatory = $false)]
#       [switch] $Recurse
#   )

#   $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
#   $ParentFolderPath = Split-Path $ModuleFolderPath -Parent

#   $ParentTemplateFilePath = Join-Path $ParentFolderPath 'main.bicep'

#   if (-not (Test-Path -Path $ParentTemplateFilePath)) {
#       return
#   }

#   $ParentTemplateFilesToPublish = [System.Collections.ArrayList]@()
#   $ParentTemplateFilesToPublish += $ParentTemplateFilePath | Get-Item

#   if ($Recurse) {
#       $ParentTemplateFilesToPublish += Get-ParentModuleTemplateFile $ParentTemplateFilePath -Recurse
#   }

#   return $ParentTemplateFilesToPublish
# }

# <#
# .SYNOPSIS
# Get the number of commits following the specified commit.

# .PARAMETER Commit
# Optional. A specified git reference to get commit counts on.

# .EXAMPLE
# Get-GitDistance -Commit origin/main.

# 620

# There are currently 620 commits on origin/main. When run as a push on main, this will be the current commit number on the main branch.
# #>
# function Get-GitDistance {

#   [CmdletBinding()]
#   param (
#       [Parameter(Mandatory = $false)]
#       [string] $Commit = 'HEAD'

#   )

#   return [int](git rev-list --count $Commit) + 1
# }

# <#
# .SYNOPSIS
# Gets the version from the version file from the corresponding main.bicep file.

# .DESCRIPTION
# Gets the version file from the corresponding main.bicep file.
# The file needs to be in the same folder as the template file itself.

# .PARAMETER TemplateFilePath
# Mandatory. Path to a main.bicep file.

# .EXAMPLE
# Get-ModuleVersionFromFile -TemplateFilePath '.\avm\storage\storage-account\table-service\table\main.bicep'

# 0.3

# Get the version file from the specified main.bicep file.
# #>
# function Get-ModuleVersionFromFile {

#   [CmdletBinding()]
#   param (
#       [Parameter(Mandatory)]
#       [string] $TemplateFilePath
#   )

#   $ModuleFolder = Split-Path -Path $TemplateFilePath -Parent
#   $VersionFilePath = Join-Path $ModuleFolder 'version.json'

#   if (-not (Test-Path -Path $VersionFilePath)) {
#       throw "No version file found at: [$VersionFilePath]"
#   }

#   $VersionFileContent = Get-Content $VersionFilePath | ConvertFrom-Json

#   return $VersionFileContent.version
# }

# <#
# .SYNOPSIS
# Generates a new version for the specified module.

# .DESCRIPTION
# Generates a new version for the specified module, based on version.json file and git commit count.
# Major and minor version numbers are gathered from the version.json file.
# Patch version number is calculated based on the git commit count on the branch.

# .PARAMETER TemplateFilePath
# Mandatory. Path to a main.bicep file.

# .EXAMPLE
# Get-NewModuleVersion -TemplateFilePath '.\avm\storage\storage-account\table-service\table\main.bicep'

# 0.3.630

# Generates a new version for the table module.

# #>
# function Get-NewModuleVersion {
#   [CmdletBinding()]
#   param (
#       [Parameter(Mandatory)]
#       [string] $TemplateFilePath
#   )

#   $Version = Get-ModuleVersionFromFile -TemplateFilePath $TemplateFilePath
#   $Patch = Get-GitDistance
#   $NewVersion = "$Version.$Patch"

#   $BranchName = Get-GitBranchName -Verbose

#   if ($BranchName -ne 'main' -and $BranchName -ne 'master') {
#       $NewVersion = "$NewVersion-prerelease".ToLower()
#   }

#   return $NewVersion
# }

# #endregion

# <#
# .SYNOPSIS
# Generates a hashtable with template file paths to publish with a new version.

# .DESCRIPTION
# Generates a hashtable with template file paths to publish with a new version.

# .PARAMETER TemplateFilePath
# Mandatory. Path to a main.bicep file.

# .EXAMPLE
# Get-ModulesToPublish -TemplateFilePath '.\avm\storage\storage-account\main.bicep'

# Name               Value
# ----               -----
# TemplateFilePath   .\avm\storage\storage-account\file-service\share\main.bicep
# Version            0.1.0

# Generates a hashtable with template file paths to publish and their new versions.

# #>#
# function Get-ModulesToPublish {

#   [CmdletBinding()]
#   param (
#       [Parameter(Mandatory)]
#       [string] $TemplateFilePath
#   )

#   $ModuleFolderPath = Split-Path $TemplateFilePath -Parent
#   $TemplateFilesToPublish = Get-TemplateFileToPublish -ModuleFolderPath $ModuleFolderPath | Sort-Object FullName -Descending

#   $modulesToPublish = [System.Collections.ArrayList]@()
#   foreach ($TemplateFileToPublish in $TemplateFilesToPublish) {
#       $ModuleVersion = Get-NewModuleVersion -TemplateFilePath $TemplateFileToPublish.FullName -Verbose

#       $modulesToPublish += @{
#           Version          = $ModuleVersion
#           TemplateFilePath = $TemplateFileToPublish.FullName
#       }

#       $ParentTemplateFilesToPublish = Get-ParentModuleTemplateFile -TemplateFilePath $TemplateFileToPublish.FullName -Recurse
#       foreach ($ParentTemplateFileToPublish in $ParentTemplateFilesToPublish) {
#           $ParentModuleVersion = Get-NewModuleVersion -TemplateFilePath $ParentTemplateFileToPublish.FullName

#           $modulesToPublish += @{
#               Version          = $ParentModuleVersion
#               TemplateFilePath = $ParentTemplateFileToPublish.FullName
#           }
#       }
#   }

#   $modulesToPublish = $modulesToPublish | Sort-Object TemplateFilePath, Version -Descending -Unique

#   if ($modulesToPublish.count -gt 0) {
#       Write-Verbose 'Publish the following modules:'-Verbose
#       $modulesToPublish | ForEach-Object {
#           $RelPath = ($_.TemplateFilePath).Split('/avm/')[-1]
#           $RelPath = $RelPath.Split('/main.')[0]
#           Write-Verbose (' - [{0}] [{1}] ' -f $RelPath, $_.Version) -Verbose
#       }
#   }
#   else {
#       Write-Verbose 'No modules with changes found to publish.'-Verbose
#   }

#   return $modulesToPublish
# }
