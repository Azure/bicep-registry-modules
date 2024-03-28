<#
.SYNOPSIS
Parses AVM module CSV file

.DESCRIPTION
Depending on the parameter, the correct CSV file will be parsed and returned a an object

.PARAMETER ModuleIndex
Type of CSV file, that should be parsed ('Bicep-Resource', 'Bicep-Pattern')

.EXAMPLE
Next line will parse the AVM Bicep modules
Get-AvmCsvData -ModuleIndex 'Bicep-Resource'

#>
Function Get-AvmCsvData {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateSet('Bicep-Resource', 'Bicep-Pattern')]
    [string] $ModuleIndex
  )

  # CSV file URLs
  $BicepResourceUrl = "https://aka.ms/avm/index/bicep/res/csv"
  $BicepPatternUrl = "https://aka.ms/avm/index/bicep/ptn/csv"

  # Retrieve the CSV file
  switch ($ModuleIndex) {
    'Bicep-Resource' {
      try {
        $unfilteredCSV = Invoke-WebRequest -Uri $BicepResourceUrl
      }
      catch {
        Write-Error "Unable to retrieve CSV file - Check network connection."
      }
    }
    'Bicep-Pattern' {
      try {
        $unfilteredCSV = Invoke-WebRequest -Uri $BicepPatternUrl
      }
      catch {
        Write-Error "Unable to retrieve CSV file - Check network connection."
      }
    }
  }

  # Convert the CSV content to a PowerShell object
  $formattedBicepFullCsv = ConvertFrom-CSV $unfilteredCSV.Content

  # Loop through each item in the filtered data
  foreach ($item in $formattedBicepFullCsv) {
    # Remove '@Azure/' from the ModuleOwnersGHTeam property
    $item.ModuleOwnersGHTeam = $item.ModuleOwnersGHTeam -replace '@Azure/', ''
    # Remove '@Azure/' from the ModuleContributorsGHTeam property
    $item.ModuleContributorsGHTeam = $item.ModuleContributorsGHTeam -replace '@Azure/', ''
  }

  # Return the modified data
  return $formattedBicepFullCsv
}