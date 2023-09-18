<#
.SYNOPSIS
Reads a YAML file that contains a list (hashtable) of key-value pairs within it and outputs a file with the key-value pair in a (key1=value1) format. Suitable for environment variables

.DESCRIPTION
Accepts input for a YAML file that contains a List, which has key-value pairs (also known as scalars) like key1: 'value1' in each line, and outputs a file with the key-value pair in a (key1=value1) format.
See File structure below:

ListName:
    key1: value1
    key2: value2

Output file will contain:
key1=value1
key2=value2

.PARAMETER InputFilePath
Mandatory. The path to the YAML file that contains the key-value pairs List.

.PARAMETER ListName
Mandatory. The name of the List in the file that contains the key-value pair.

.PARAMETER OutputFilePath
Mandatory. The path to the file to output the key-value pairs to (format will be key1=value1)

.EXAMPLE
Add-YamlListToFile -InputFilePath C:\MyFile.yaml -ListName variables -OutputFilePath C:\MyFile.txt -verbose

Important: Requires the PowerShell module 'powershell-yaml' to be installed.
#>

function Add-YamlListToFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $InputFilePath,

        [Parameter(Mandatory)]
        [string] $ListName,

        [Parameter(Mandatory)]
        [string] $OutputFilePath
    )

    begin {
        Write-Debug ('{0} entered' -f $MyInvocation.MyCommand)

        # Check if the 'powershell-yaml' module is installed
        if (-not (Get-InstalledModule -Name 'powershell-yaml')) {
            throw "PowerShell module 'powershell-yaml' is required for for serializing and deserializing YAML.`nInstall using:`nInstall-Module 'powershell-yaml' -Repository PSGallery"
        }

        # Validate Input and Output Path
        if (-not ($InputFileContent = Get-Content -Path $InputFilePath)) {
            throw "Invalid Input File Path: $InputFilePath"
        }
        if (-not (Test-Path $OutputFilePath)) {
            throw "Invalid Output File Path: $OutputFilePath"
        }
    }

    process {

        # Process List (Hashtable)
        $KeyValuePair = $InputFileContent | ConvertFrom-Yaml | Select-Object -ExpandProperty $ListName
        Write-Verbose ('Found [{0}] Key-Value pairs' -f $KeyValuePair.Count) -Verbose

        if (-not $KeyValuePair) {
            throw "No key-value pairs found in List: $ListName"
        }
        # Process key value pairs in the list
        foreach ($Key in ($KeyValuePair.Keys.split(' ') | Sort-Object)) {
            Write-Verbose ('Setting environment variable [{0}] with value [{1}]' -f $Key, $KeyValuePair[$Key]) -Verbose
            Write-Output "$Key=$($KeyValuePair[$Key])" | Out-File -FilePath $OutputFilePath -Encoding 'utf-8' -Append
        }
    }

    end {
        Write-Debug ('{0} exited' -f $MyInvocation.MyCommand)
    }
}
