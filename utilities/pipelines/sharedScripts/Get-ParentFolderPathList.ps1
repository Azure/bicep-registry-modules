
<#
.SYNOPSIS
Get a list of all versioned parents of a module

.DESCRIPTION
Get a list of all versioned parents of a module. The function will recursively search the parent directories of the given path until it finds a directory containing a version.json file or reaches the root path.
The function will return a list of all the directories in the parent hierarchy that contain a version.json file, including the given path.
The function will return the list in the order from the root path to the given path.

.PARAMETER Path
Mandatory. The path of the module to search for versioned parents.

.PARAMETER UpperBoundPath
Optional. The root path to stop the search at. The function will not search above this path.

.PARAMETER Filter
Optional. Only include module folders in the list (i.e., modules with a `main.json` file), or versioned modules folders (i.e., modules with `version.json` files). The default is to include all folders).

.EXAMPLE
Get-ParentFolderPathList -Path 'C:/bicep-registry-modules/avm/res/storage/storage-account/blob-service/container/immutability-policy'

Get all parent folders of the 'immutability-policy' folder up to 'res'. Returns

- <repoPath>\avm\res\storage
- <repoPath>\avm\res\storage\storage-account
- <repoPath>\avm\res\storage\storage-account\blob-service
- <repoPath>\avm\res\storage\storage-account\blob-service\container

.EXAMPLE
Get-ParentFolderPathList -Path 'C:/bicep-registry-modules/avm/res/storage/storage-account/blob-service/container/immutability-policy' -RootPath 'C:/bicep-registry-modules/avm/res' -Filter 'OnlyVersionedModules'

Get all versioned parent module folders of the 'immutability-policy' folder up to 'res'. Returns, e.g.,
- <repoPath>\avm\res\storage\storage-account
#>
function Get-ParentFolderPathList {

    param
    (
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [string] $UpperBoundPath = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName,

        [Parameter(Mandatory = $false)]
        [ValidateSet('OnlyModules', 'OnlyVersionedModules', 'All')]
        [string] $Filter = 'All'
    )

    $Item = Get-Item -Path $Path
    $result = @()

    if ($Item.FullName -ne $UpperBoundPath) {

        $result += Get-ParentFolderPathList -Path $Item.Parent.FullName -UpperBoundPath $UpperBoundPath -Filter $Filter

        switch ($Filter) {
            'OnlyModules' {
                if (Test-Path (Join-Path -Path $Item.FullName 'main.json')) {
                    $result += $Item.FullName
                }
                break
            }
            'OnlyVersionedModules' {
                if ((Test-Path (Join-Path -Path $Item.FullName 'version.json')) -and (Test-Path (Join-Path -Path $Item.FullName 'main.json'))) {
                    $result += $Item.FullName
                }
                break
            }
            'All' {
                $result += $Item.FullName
                break
            }
        }
    }

    return $result
}
