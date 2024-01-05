#requires -version 7.3

<#
.SYNOPSIS
Convert a given JSON string into an ordered HashTable.

.DESCRIPTION
Convert a given JSON string into an ordered HashTable.

.PARAMETER JSONInputObject
Mandatory. The JSON string to convert into an ordered HashTable object.

.EXAMPLE
ConvertTo-OrderedHashtable -JSONInputObject "@{ b = 'b'; a = 'a' ; c = @( 3, 1, 2 )}"

Convert the given JSON string into a sorted HashTable. Would return the HashTable:

    @{
        a = 'a'
        b = 'b'
        c = @(
            1,
            2,
            3
        )
    }

.EXAMPLE
ConvertTo-OrderedHashtable -JSONInputObject '{"elem":[3,1,2,"a",{"a":"a","b":"b"},[23,1],["23","1"]],"arr":["one"]}'

Convert the given JSON string into a sorted HashTable. Would return the HashTable:

    @{
        arr  = @('one')
        elem = @(
            1,
            @(
                1,
                23
            ),
            @(
                '1',
                '23'
            )
            2,
            3,
            'a'
        )
    }
#>
function ConvertTo-OrderedHashtable {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $JSONInputObject # Must be string to workaround auto-conversion
    )

    $JSONObject = ConvertFrom-Json $JSONInputObject -AsHashtable -Depth 99 -NoEnumerate
    $orderedLevel = [ordered]@{}

    if (-not ($JSONObject.GetType().BaseType.Name -eq 'Hashtable')) {
        return $JSONObject # E.g. in primitive data types [1,2,3]
    }

    foreach ($currentLevelKey in ($JSONObject.Keys | Sort-Object)) {

        if ($null -eq $JSONObject[$currentLevelKey]) {
            # Handle case in which the value is 'null' and hence has no type
            $orderedLevel[$currentLevelKey] = $null
            continue
        }

        switch ($JSONObject[$currentLevelKey].GetType().BaseType.Name) {
            { $PSItem -in @('Hashtable') } {
                $orderedLevel[$currentLevelKey] = ConvertTo-OrderedHashtable -JSONInputObject ($JSONObject[$currentLevelKey] | ConvertTo-Json -Depth 99)
            }
            'Array' {
                $arrayOutput = @()

                # Case: Array of arrays
                $arrayElements = $JSONObject[$currentLevelKey] | Where-Object { $_.GetType().BaseType.Name -eq 'Array' }
                foreach ($array in $arrayElements) {
                    if ($array.Count -gt 1) {
                        # Only sort for arrays with more than one item. Otherwise single-item arrays are casted
                        $array = $array | Sort-Object
                    }
                    $arrayOutput += , (ConvertTo-OrderedHashtable -JSONInputObject ($array | ConvertTo-Json -Depth 99))
                }

                # Case: Array of objects
                $hashTableElements = $JSONObject[$currentLevelKey] | Where-Object { $_.GetType().BaseType.Name -eq 'Hashtable' }
                foreach ($hashTable in $hashTableElements) {
                    $arrayOutput += , (ConvertTo-OrderedHashtable -JSONInputObject ($hashTable | ConvertTo-Json -Depth 99))
                }

                # Case: Primitive data types
                $primitiveElements = $JSONObject[$currentLevelKey] | Where-Object { $_.GetType().BaseType.Name -notin @('Array', 'Hashtable') } | ConvertTo-Json -Depth 99 | ConvertFrom-Json -AsHashtable -NoEnumerate -Depth 99
                if ($primitiveElements.Count -gt 1) {
                    $primitiveElements = $primitiveElements | Sort-Object
                }
                $arrayOutput += $primitiveElements

                if ($array.Count -gt 1) {
                    # Only sort for arrays with more than one item. Otherwise single-item arrays are casted
                    $arrayOutput = $arrayOutput | Sort-Object
                }
                $orderedLevel[$currentLevelKey] = $arrayOutput
            }
            Default {
                # string/int/etc.
                $orderedLevel[$currentLevelKey] = $JSONObject[$currentLevelKey]
            }
        }
    }

    return $orderedLevel
}
