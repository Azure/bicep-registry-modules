<#
.SYNOPSIS
Parses AVM module CSV file

.DESCRIPTION
Depending on the parameter, the correct CSV file will be parsed and returned a an object

.PARAMETER ModuleIndex
Mandatory. Type of CSV file, that should be parsed ('Bicep-Resource', 'Bicep-Pattern', 'Bicep-Utility')

.EXAMPLE
Get-AvmCsvData -ModuleIndex 'Bicep-Resource'

Parse the AVM Bicep modules
#>
Function Get-AvmCsvData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Bicep-Resource', 'Bicep-Pattern', 'Bicep-Utility')]
        [string] $ModuleIndex
    )

    # CSV file URLs
    $BicepResourceUrl = 'https://aka.ms/avm/index/bicep/res/csv'
    $BicepPatternUrl = 'https://aka.ms/avm/index/bicep/ptn/csv'
    $BicepUtilityUrl = 'https://aka.ms/avm/index/bicep/utl/csv'

    # Retrieve the CSV file
    switch ($ModuleIndex) {
        'Bicep-Resource' {
            try {
                $unfilteredCSV = Invoke-WebRequest -Uri $BicepResourceUrl
            } catch {
                throw 'Unable to retrieve CSV file - Check network connection.'
            }
        }
        'Bicep-Pattern' {
            try {
                $unfilteredCSV = Invoke-WebRequest -Uri $BicepPatternUrl
            } catch {
                throw 'Unable to retrieve CSV file - Check network connection.'
            }
        }
        'Bicep-Utility' {
            try {
                $unfilteredCSV = Invoke-WebRequest -Uri $BicepUtilityUrl
            } catch {
                throw 'Unable to retrieve CSV file - Check network connection.'
            }
        }
    }

    # Convert the CSV content to a PowerShell object
    $formattedBicepFullCsv = ConvertFrom-Csv $unfilteredCSV.Content

    # Loop through each item in the filtered data
    foreach ($item in $formattedBicepFullCsv) {
        # Remove '@Azure/' from the ModuleOwnersGHTeam property
        $item.ModuleOwnersGHTeam = $item.ModuleOwnersGHTeam -replace '@Azure\/', ''
        # Remove '@Azure/' from the ModuleContributorsGHTeam property
        $item.ModuleContributorsGHTeam = $item.ModuleContributorsGHTeam -replace '@Azure\/', ''
    }

    # Return the modified data
    return $formattedBicepFullCsv
}
