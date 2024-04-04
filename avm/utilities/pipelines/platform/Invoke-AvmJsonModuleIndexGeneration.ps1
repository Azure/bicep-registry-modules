<#
.SYNOPSIS
Creates the moduleIndex.json file for the AVM modules that is used by Visual Studio Code and other IDEs to provide the intellisense list of modules from the Bicep public registry.

.DESCRIPTION
Creates the moduleIndex.json file for the AVM modules that is used by Visual Studio Code and other IDEs to provide the intellisense list of modules from the Bicep public registry.

Also has error handling to cope with a module not being published fully but will not prevent the script from completeing each time.

The script uses a merging strategy with the previous version of moduleIndex.json to ensure that the file is always up to date with the latest modules but previous versions are not removed, this can be changed by setting the $doNotMergeWithLastModuleIndexJsonFileVersion parameter to $true.

.EXAMPLE
Invoke-AvmJsonModuleIndexGeneration.ps1 -storageAccountName '<STORAGE ACCOUNT NAME>' -storageAccountContainer '<STORAGE ACCOUNT BLOB CONTAINER NAME>' -storageBlobName '<STORAGE ACCOUNT BLOB NAME>' -moduleIndexJsonFilePath 'moduleIndex.json' -prefixForLastModuleIndexJsonFile 'last-' -prefixForCurrentGeneratedModuleIndexJsonFile 'generated-' -doNotMergeWithLastModuleIndexJsonFileVersion $false

This example will generate the moduleIndex.json file for the AVM modules and save it to the current directory and merge it with the last version of the moduleIndex.json file that was downloaded from the storage account.

.NOTES
The function requires Azure PowerShell Storage Module (Az.Storage) to be installed and the user to be logged in to Azure.
#>

function Invoke-AvmJsonModuleIndexGeneration {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $false)]
    [string] $storageAccountName = 'biceplivedatasaprod',

    [Parameter(Mandatory = $false)]
    [string] $storageAccountContainer = 'bicep-cdn-live-data-container',

    [Parameter(Mandatory = $false)]
    [string] $storageBlobName = 'module-index',

    [Parameter(Mandatory = $false)]
    [string] $moduleIndexJsonFilePath = 'moduleIndex.json',

    [Parameter(Mandatory = $false)]
    [string] $prefixForLastModuleIndexJsonFile = 'last-',

    [Parameter(Mandatory = $false)]
    [string] $prefixForCurrentGeneratedModuleIndexJsonFile = 'generated-',

    [Parameter(Mandatory = $false)]
    [bool] $doNotMergeWithLastModuleIndexJsonFileVersion = $false
  )

  ## Download the current published moduleIndex.json from the storage account if the $doNotMergeWithLastModuleIndexJsonFileVersion is set to $false
  if (-not $doNotMergeWithLastModuleIndexJsonFileVersion) {
    try {
      $lastModuleIndexJsonFilePath = $prefixForLastModuleIndexJsonFile + $moduleIndexJsonFilePath

      Write-Verbose "Attempting to get last version of the moduleIndex.json from the Storage Account: $storageAccountName, Container: $storageAccountContainer, Blob: $storageBlobName and save to file: $lastModuleIndexJsonFilePath ..." -Verbose

      $storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -UseConnectedAccount

      Get-AzStorageBlobContent -Blob $storageBlobName -Container $storageAccountContainer -Context $storageContext -Destination $lastModuleIndexJsonFilePath -Force | Out-Null
    } catch {
      Write-Error "Unable to retrieve moduleIndex.json file from the Storage Account: $storageAccountName, Container: $storageAccountContainer, Blob: $storageBlobName. Error: $($_.Exception.Message)"
    }

    ## Check if the last version of the moduleIndex.json (last-moduleIndex.json) file exists and is not empty

    if (Test-Path $lastModuleIndexJsonFilePath) {
      $lastModuleIndexJsonFileContent = Get-Content $lastModuleIndexJsonFilePath
      if ($null -eq $lastModuleIndexJsonFileContent) {
        Write-Error "The last version of the moduleIndex.json file (last-moduleIndex.json) exists but is empty. File: $lastModuleIndexJsonFilePath" -ErrorAction Stop
      }
      Write-Verbose 'The last version of the moduleIndex.json file (last-moduleIndex.json) exists and is not empty. Proceeding...' -Verbose
    }
  }

  ## Generate the new moduleIndex.json file based off the modules in the repository

  $currentGeneratedModuleIndexJsonFilePath = $prefixForCurrentGeneratedModuleIndexJsonFile + $moduleIndexJsonFilePath

  Write-Verbose "Generating the current generated moduleIndex.json file and saving to: $currentGeneratedModuleIndexJsonFilePath ..." -Verbose

  $moduleIndexData = @()

  foreach ($avmModuleRoot in @('avm/res', 'avm/ptn')) {
    $avmModuleGroups = (Get-ChildItem -Path $avmModuleRoot -Directory).Name

    foreach ($moduleGroup in $avmModuleGroups) {
      $moduleGroupPath = "$avmModuleRoot/$moduleGroup"
      $moduleNames = (Get-ChildItem -Path $moduleGroupPath -Directory).Name

      foreach ($moduleName in $moduleNames) {
        $modulePath = "$moduleGroupPath/$moduleName"
        $mainJsonPath = "$modulePath/main.json"
        $tagListUrl = "https://mcr.microsoft.com/v2/bicep/$modulePath/tags/list"

        try {
          Write-Verbose "Processing AVM Module '$modulePath'..." -Verbose
          Write-Verbose "  Getting available tags at '$tagListUrl'..." -Verbose

          try {
            $tagListResponse = Invoke-RestMethod -Uri $tagListUrl
          } catch {
            Write-Output "Error occurred while accessing URL: $tagListUrl"
            Write-Output "Error message: $($_.Exception.Message)"
            continue
          }
          $tags = $tagListResponse.tags | Sort-Object

          $properties = [ordered]@{}
          foreach ($tag in $tags) {
            $gitTag = "$modulePath/$tag"
            $documentationUri = "https://github.com/Azure/bicep-registry-modules/tree/$gitTag/$modulePath/README.md"

            try {
              $moduleMainJsonUri = "https://raw.githubusercontent.com/Azure/bicep-registry-modules/$gitTag/$mainJsonPath"
              Write-Verbose "    Getting available description for tag $tag via '$moduleMainJsonUri'..." -Verbose
              $moduleMainJsonUriResponse = Invoke-RestMethod -Uri $moduleMainJsonUri
              $description = $moduleMainJsonUriResponse.metadata.description
            } catch {
              Write-Output "Error occurred while accessing description for tag $tag via '$moduleMainJsonUri'"
              Write-Output "Error message: $($_.Exception.Message)"
              continue
            }

            $properties[$tag] = [ordered]@{
              'description'      = $description
              'documentationUri' = $documentationUri
            }
          }

          $moduleIndexData += [ordered]@{
            'moduleName' = $modulePath
            'tags'       = @($tags)
            'properties' = $properties
          }
        } catch {
          Write-Error "Error message: $($_.Exception.Message)"
        }
      }

      $numberOfModuleGroupsProcessed++
    }
  }

  Write-Verbose "Processed $numberOfModuleGroupsProcessed modules groups." -Verbose
  Write-Verbose "Processed $($moduleIndexData.Count) total modules." -Verbose

  Write-Verbose "Convert moduleIndexData variable to JSON and save as 'generated-moduleIndex.json'" -Verbose
  $moduleIndexData | ConvertTo-Json -Depth 10 | Out-File -FilePath $currentGeneratedModuleIndexJsonFilePath

  ## Merge the new moduleIndex.json file with the previous version if the $doNotMergeWithLastModuleIndexJsonFileVersion is set to $false

  if ($doNotMergeWithLastModuleIndexJsonFileVersion -eq $false) {
    Write-Verbose "Merging 'generated-moduleIndex.json' (new) file with 'last-moduleIndex.json' (previous) file..." -Verbose

    $lastModuleIndexJsonFileContent = Get-Content $lastModuleIndexJsonFilePath
    $currentGeneratedModuleIndexJsonFileContent = Get-Content $currentGeneratedModuleIndexJsonFilePath

    $lastModuleIndexData = $lastModuleIndexJsonFileContent | ConvertFrom-Json -Depth 10
    $currentGeneratedModuleIndexData = $currentGeneratedModuleIndexJsonFileContent | ConvertFrom-Json -Depth 10

    $mergedModuleIndexData = $lastModuleIndexData + $currentGeneratedModuleIndexData | Group-Object -Property moduleName | ForEach-Object {
      $_.Group | Sort-Object -Property @{Expression = { $_.tags -join ',' } } -Descending | Select-Object -First 1
    } | Sort-Object -Property moduleName

    Write-Verbose "Convert mergedModuleIndexData variable to JSON and save as 'moduleIndex.json'" -Verbose
    $mergedModuleIndexData | ConvertTo-Json -Depth 10 | Out-File -FilePath $moduleIndexJsonFilePath
  }
  if ($doNotMergeWithLastModuleIndexJsonFileVersion -eq $true) {
    Write-Verbose "Convert currentGeneratedModuleIndexData variable to JSON and save as 'moduleIndex.json to overwrite it as doNotMergeWithLastModuleIndexJsonFileVersion was set to true'" -Verbose
    $moduleIndexData | ConvertTo-Json -Depth 10 | Out-File -FilePath $moduleIndexJsonFilePath -Force
  }

}
